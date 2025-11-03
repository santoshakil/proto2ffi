use crate::error::{Error, Result};
use crate::model::*;
use protobuf_parse::Parser;
use std::path::Path;

pub struct ProtoParser {
    includes: Vec<String>,
}

impl ProtoParser {
    pub fn new() -> Self {
        Self {
            includes: vec![".".to_string()],
        }
    }

    pub fn with_includes(mut self, includes: Vec<String>) -> Self {
        self.includes = includes;
        self
    }

    pub fn parse_file(&self, path: &Path) -> Result<ProtoFile> {
        if !path.exists() {
            return Err(Error::FileNotFound(path.to_path_buf()));
        }

        let mut parser = Parser::new();

        for include in &self.includes {
            parser.include(include);
        }

        let parsed = parser
            .input(path)
            .parse_and_typecheck()
            .map_err(|e| Error::ProtobufParse(format!("{:?}", e)))?;

        let file = parsed.file_descriptors.first()
            .ok_or_else(|| Error::ParseError("No file descriptors found".to_string()))?;

        let package = file.package.as_deref().unwrap_or("").to_string();
        let mut proto_file = ProtoFile::new(package);

        for message in file.message_type.iter() {
            let message_type = self.parse_message(message)?;
            proto_file.add_message(message.name().to_string(), message_type);
        }

        for service in file.service.iter() {
            let proto_service = self.parse_service(service)?;
            proto_file.add_service(proto_service);
        }

        Ok(proto_file)
    }

    fn parse_service(&self, service: &protobuf::descriptor::ServiceDescriptorProto) -> Result<ProtoService> {
        let mut proto_service = ProtoService::new(service.name().to_string());

        for method in service.method.iter() {
            let input_type = self.strip_package_prefix(method.input_type());
            let output_type = self.strip_package_prefix(method.output_type());

            let mut service_method = ServiceMethod::new(
                method.name().to_string(),
                input_type,
                output_type,
            );

            if method.client_streaming() || method.server_streaming() {
                service_method = service_method.with_streaming(
                    method.client_streaming(),
                    method.server_streaming(),
                );
            }

            proto_service.add_method(service_method);
        }

        Ok(proto_service)
    }

    fn parse_message(&self, message: &protobuf::descriptor::DescriptorProto) -> Result<MessageType> {
        let mut message_type = MessageType::new(message.name().to_string());

        for field in message.field.iter() {
            let field_type = self.map_field_type(field)?;

            let mut msg_field = Field::new(
                field.name().to_string(),
                field.number(),
                field_type,
            );

            if field.label() == protobuf::descriptor::field_descriptor_proto::Label::LABEL_REPEATED {
                msg_field.repeated = true;
            }

            if field.label() == protobuf::descriptor::field_descriptor_proto::Label::LABEL_OPTIONAL {
                msg_field.optional = true;
            }

            message_type.add_field(msg_field);
        }

        Ok(message_type)
    }

    fn map_field_type(&self, field: &protobuf::descriptor::FieldDescriptorProto) -> Result<FieldType> {
        use protobuf::descriptor::field_descriptor_proto::Type;

        match field.type_() {
            Type::TYPE_DOUBLE => Ok(FieldType::Double),
            Type::TYPE_FLOAT => Ok(FieldType::Float),
            Type::TYPE_INT64 => Ok(FieldType::Int64),
            Type::TYPE_UINT64 => Ok(FieldType::Uint64),
            Type::TYPE_INT32 => Ok(FieldType::Int32),
            Type::TYPE_FIXED64 => Ok(FieldType::Fixed64),
            Type::TYPE_FIXED32 => Ok(FieldType::Fixed32),
            Type::TYPE_BOOL => Ok(FieldType::Bool),
            Type::TYPE_STRING => Ok(FieldType::String),
            Type::TYPE_BYTES => Ok(FieldType::Bytes),
            Type::TYPE_UINT32 => Ok(FieldType::Uint32),
            Type::TYPE_SFIXED32 => Ok(FieldType::Sfixed32),
            Type::TYPE_SFIXED64 => Ok(FieldType::Sfixed64),
            Type::TYPE_SINT32 => Ok(FieldType::Sint32),
            Type::TYPE_SINT64 => Ok(FieldType::Sint64),
            Type::TYPE_MESSAGE => {
                let type_name = self.strip_package_prefix(field.type_name());
                Ok(FieldType::Message(type_name))
            }
            Type::TYPE_ENUM => {
                let type_name = self.strip_package_prefix(field.type_name());
                Ok(FieldType::Enum(type_name))
            }
            Type::TYPE_GROUP => Err(Error::UnsupportedFeature("Groups are not supported".to_string())),
        }
    }

    fn strip_package_prefix(&self, type_name: &str) -> String {
        type_name
            .trim_start_matches('.')
            .split('.')
            .last()
            .unwrap_or(type_name)
            .to_string()
    }
}

impl Default for ProtoParser {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    use std::io::Write;
    use tempfile::TempDir;

    #[test]
    fn test_parse_simple_service() {
        let temp_dir = TempDir::new().unwrap();
        let proto_path = temp_dir.path().join("test.proto");

        let proto_content = r#"
syntax = "proto3";
package test;

message Request {
    string name = 1;
}

message Response {
    string message = 1;
}

service TestService {
    rpc Echo(Request) returns (Response);
}
"#;

        fs::write(&proto_path, proto_content).unwrap();

        let parser = ProtoParser::new();
        let proto_file = parser.parse_file(&proto_path).unwrap();

        assert_eq!(proto_file.package, "test");
        assert_eq!(proto_file.services.len(), 1);
        assert_eq!(proto_file.messages.len(), 2);

        let service = &proto_file.services[0];
        assert_eq!(service.name, "TestService");
        assert_eq!(service.methods.len(), 1);

        let method = &service.methods[0];
        assert_eq!(method.name, "Echo");
        assert_eq!(method.input_type, "Request");
        assert_eq!(method.output_type, "Response");
    }
}
