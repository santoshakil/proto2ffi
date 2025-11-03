use pest::Parser;
use pest_derive::Parser;
use std::path::Path;
use std::fs;
use crate::error::{Proto2FFIError, Result};
use crate::types::{ProtoFile, Message, Field, FieldType, FieldOption, MessageOption, Enum, EnumVariant};

#[derive(Parser)]
#[grammar = "proto.pest"]
struct ProtoParser;

pub fn parse_proto_file(path: &Path) -> Result<ProtoFile> {
    let content = fs::read_to_string(path)?;
    parse_proto_string(&content)
}

pub fn parse_proto_string(content: &str) -> Result<ProtoFile> {
    let pairs = ProtoParser::parse(Rule::proto_file, content)
        .map_err(|e| Proto2FFIError::ParseError(e.to_string()))?;

    let mut proto_file = ProtoFile {
        package: None,
        messages: Vec::new(),
        enums: Vec::new(),
    };

    for pair in pairs {
        match pair.as_rule() {
            Rule::proto_file => {
                for inner in pair.into_inner() {
                    match inner.as_rule() {
                        Rule::package => {
                            proto_file.package = Some(parse_package(inner)?);
                        }
                        Rule::message => {
                            proto_file.messages.push(parse_message(inner)?);
                        }
                        Rule::enum_def => {
                            proto_file.enums.push(parse_enum(inner)?);
                        }
                        Rule::EOI => {}
                        _ => {}
                    }
                }
            }
            _ => {}
        }
    }

    // Post-process: Convert Message fields to Enum fields if they reference enums
    let enum_names: std::collections::HashSet<_> = proto_file
        .enums
        .iter()
        .map(|e| e.name.as_str())
        .collect();

    for message in &mut proto_file.messages {
        for field in &mut message.fields {
            if let FieldType::Message(type_name) = &field.field_type {
                if enum_names.contains(type_name.as_str()) {
                    field.field_type = FieldType::Enum(type_name.clone());
                }
            }
        }
    }

    Ok(proto_file)
}

fn parse_package(pair: pest::iterators::Pair<Rule>) -> Result<String> {
    let mut parts = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::ident {
            parts.push(inner.as_str().to_string());
        }
    }
    Ok(parts.join("."))
}

fn parse_message(pair: pest::iterators::Pair<Rule>) -> Result<Message> {
    let mut name = String::new();
    let mut fields = Vec::new();
    let mut options = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::ident => {
                name = inner.as_str().to_string();
            }
            Rule::field => {
                fields.push(parse_field(inner)?);
            }
            Rule::option_stmt => {
                options.push(parse_option(inner)?);
            }
            _ => {}
        }
    }

    Ok(Message {
        name,
        fields,
        options,
    })
}

fn parse_field(pair: pest::iterators::Pair<Rule>) -> Result<Field> {
    let mut field_label = None;
    let mut field_type = None;
    let mut field_name = String::new();
    let mut field_number = 0;
    let mut field_options = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::field_label => {
                field_label = Some(inner.as_str().to_string());
            }
            Rule::field_type => {
                field_type = Some(parse_field_type(inner)?);
            }
            Rule::ident => {
                field_name = inner.as_str().to_string();
            }
            Rule::number => {
                field_number = inner.as_str().parse()
                    .map_err(|e| Proto2FFIError::ParseError(format!("Invalid field number: {}", e)))?;
            }
            Rule::field_options => {
                field_options = parse_field_options(inner)?;
            }
            _ => {}
        }
    }

    let repeated = field_label.as_deref() == Some("repeated");
    let optional = field_label.as_deref() == Some("optional");

    Ok(Field {
        name: field_name,
        field_type: field_type.ok_or_else(|| Proto2FFIError::MissingField("field_type".into()))?,
        number: field_number,
        repeated,
        optional,
        options: field_options,
    })
}

fn parse_field_type(pair: pest::iterators::Pair<Rule>) -> Result<FieldType> {
    let type_str = pair.as_str();

    Ok(match type_str {
        "int32" => FieldType::Int32,
        "int64" => FieldType::Int64,
        "uint32" => FieldType::Uint32,
        "uint64" => FieldType::Uint64,
        "sint32" => FieldType::Sint32,
        "sint64" => FieldType::Sint64,
        "fixed32" => FieldType::Fixed32,
        "fixed64" => FieldType::Fixed64,
        "sfixed32" => FieldType::Sfixed32,
        "sfixed64" => FieldType::Sfixed64,
        "float" => FieldType::Float,
        "double" => FieldType::Double,
        "bool" => FieldType::Bool,
        "string" => FieldType::String {
            max_length: FieldType::default_string_size(),
        },
        "bytes" => FieldType::Bytes {
            max_length: FieldType::default_bytes_size(),
        },
        custom => FieldType::Message(custom.to_string()),
    })
}

fn parse_field_options(pair: pest::iterators::Pair<Rule>) -> Result<Vec<FieldOption>> {
    let mut options = Vec::new();

    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::field_option {
            options.push(parse_field_option(inner)?);
        }
    }

    Ok(options)
}

fn parse_field_option(pair: pest::iterators::Pair<Rule>) -> Result<FieldOption> {
    let mut name_parts = Vec::new();
    let mut value = String::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::ident => {
                name_parts.push(inner.as_str().to_string());
            }
            Rule::number => {
                value = inner.as_str().to_string();
            }
            Rule::string_literal => {
                value = inner.as_str().trim_matches('"').to_string();
            }
            _ => {}
        }
    }

    Ok(FieldOption {
        name: name_parts.join("."),
        value,
    })
}

fn parse_option(pair: pest::iterators::Pair<Rule>) -> Result<MessageOption> {
    let mut idents = Vec::new();
    let mut value = String::new();
    let mut has_non_ident_value = false;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::ident => {
                idents.push(inner.as_str().to_string());
            }
            Rule::number => {
                value = inner.as_str().to_string();
                has_non_ident_value = true;
            }
            Rule::string_literal => {
                value = inner.as_str().trim_matches('"').to_string();
                has_non_ident_value = true;
            }
            _ => {}
        }
    }

    if !has_non_ident_value && !idents.is_empty() {
        value = idents.pop().ok_or_else(||
            Proto2FFIError::ParseError("Expected option value".into()))?;
    }

    Ok(MessageOption {
        name: idents.join("."),
        value,
    })
}

fn parse_enum(pair: pest::iterators::Pair<Rule>) -> Result<Enum> {
    let mut name = String::new();
    let mut variants = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::ident => {
                if name.is_empty() {
                    name = inner.as_str().to_string();
                }
            }
            Rule::enum_field => {
                variants.push(parse_enum_field(inner)?);
            }
            _ => {}
        }
    }

    Ok(Enum { name, variants })
}

fn parse_enum_field(pair: pest::iterators::Pair<Rule>) -> Result<EnumVariant> {
    let mut name = String::new();
    let mut number = 0;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::ident => {
                name = inner.as_str().to_string();
            }
            Rule::number => {
                number = inner.as_str().parse()
                    .map_err(|e| Proto2FFIError::ParseError(format!("Invalid enum value: {}", e)))?;
            }
            _ => {}
        }
    }

    Ok(EnumVariant { name, number })
}
