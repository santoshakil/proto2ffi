use crate::types::{ProtoFile, Message, Field, Enum, FieldType};
use crate::layout::{Layout, MessageLayout};
use crate::stats::ProtoStats;
use crate::error::Result;
use std::io::Write;

pub struct DocGenerator {
    include_examples: bool,
    include_layout_info: bool,
    include_statistics: bool,
    format: DocFormat,
}

#[derive(Debug, Clone, Copy)]
pub enum DocFormat {
    Markdown,
    Html,
    PlainText,
}

impl Default for DocGenerator {
    fn default() -> Self {
        Self {
            include_examples: true,
            include_layout_info: true,
            include_statistics: true,
            format: DocFormat::Markdown,
        }
    }
}

impl DocGenerator {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn with_format(mut self, format: DocFormat) -> Self {
        self.format = format;
        self
    }

    pub fn with_examples(mut self, include: bool) -> Self {
        self.include_examples = include;
        self
    }

    pub fn with_layout_info(mut self, include: bool) -> Self {
        self.include_layout_info = include;
        self
    }

    pub fn with_statistics(mut self, include: bool) -> Self {
        self.include_statistics = include;
        self
    }

    pub fn generate<W: Write>(
        &self,
        proto: &ProtoFile,
        layout: Option<&Layout>,
        writer: &mut W,
    ) -> Result<()> {
        match self.format {
            DocFormat::Markdown => self.generate_markdown(proto, layout, writer),
            DocFormat::Html => self.generate_html(proto, layout, writer),
            DocFormat::PlainText => self.generate_plaintext(proto, layout, writer),
        }
    }

    fn generate_markdown<W: Write>(
        &self,
        proto: &ProtoFile,
        layout: Option<&Layout>,
        writer: &mut W,
    ) -> Result<()> {
        writeln!(writer, "# Protocol Buffer Schema Documentation")?;
        writeln!(writer)?;

        if let Some(pkg) = &proto.package {
            writeln!(writer, "**Package:** `{}`", pkg)?;
            writeln!(writer)?;
        }

        if self.include_statistics {
            let stats = ProtoStats::from_proto(proto);
            writeln!(writer, "## Statistics")?;
            writeln!(writer)?;
            writeln!(writer, "- Messages: {}", stats.message_count)?;
            writeln!(writer, "- Enums: {}", stats.enum_count)?;
            writeln!(writer, "- Total Fields: {}", stats.total_fields)?;
            writeln!(writer)?;
        }

        writeln!(writer, "## Messages")?;
        writeln!(writer)?;

        for message in &proto.messages {
            self.write_message_markdown(message, layout, writer)?;
        }

        if !proto.enums.is_empty() {
            writeln!(writer, "## Enums")?;
            writeln!(writer)?;

            for enum_type in &proto.enums {
                self.write_enum_markdown(enum_type, writer)?;
            }
        }

        Ok(())
    }

    fn write_message_markdown<W: Write>(
        &self,
        message: &Message,
        layout: Option<&Layout>,
        writer: &mut W,
    ) -> Result<()> {
        writeln!(writer, "### {}", message.name)?;
        writeln!(writer)?;

        if self.include_layout_info {
            if let Some(layout) = layout {
                if let Some(msg_layout) = layout.find_message(&message.name) {
                    writeln!(writer, "**Layout Information:**")?;
                    writeln!(writer, "- Size: {} bytes", msg_layout.size)?;
                    writeln!(writer, "- Alignment: {} bytes", msg_layout.alignment)?;
                    writeln!(writer, "- Fields: {}", msg_layout.fields.len())?;
                    writeln!(writer)?;
                }
            }
        }

        if !message.fields.is_empty() {
            writeln!(writer, "**Fields:**")?;
            writeln!(writer)?;
            writeln!(writer, "| Field | Type | Number | Repeated |")?;
            writeln!(writer, "|-------|------|--------|----------|")?;

            for field in &message.fields {
                writeln!(
                    writer,
                    "| {} | {} | {} | {} |",
                    field.name,
                    Self::format_field_type(&field.field_type),
                    field.number,
                    if field.repeated { "Yes" } else { "No" }
                )?;
            }

            writeln!(writer)?;
        }

        if self.include_examples {
            writeln!(writer, "**Example (Rust):**")?;
            writeln!(writer, "```rust")?;
            writeln!(writer, "let msg = {}::default();", message.name)?;
            writeln!(writer, "```")?;
            writeln!(writer)?;
        }

        Ok(())
    }

    fn write_enum_markdown<W: Write>(&self, enum_type: &Enum, writer: &mut W) -> Result<()> {
        writeln!(writer, "### {}", enum_type.name)?;
        writeln!(writer)?;

        if !enum_type.variants.is_empty() {
            writeln!(writer, "**Variants:**")?;
            writeln!(writer)?;
            writeln!(writer, "| Variant | Value |")?;
            writeln!(writer, "|---------|-------|")?;

            for variant in &enum_type.variants {
                writeln!(writer, "| {} | {} |", variant.name, variant.number)?;
            }

            writeln!(writer)?;
        }

        Ok(())
    }

    fn generate_html<W: Write>(
        &self,
        proto: &ProtoFile,
        layout: Option<&Layout>,
        writer: &mut W,
    ) -> Result<()> {
        writeln!(writer, "<!DOCTYPE html>")?;
        writeln!(writer, "<html>")?;
        writeln!(writer, "<head>")?;
        writeln!(writer, "<title>Protocol Buffer Schema Documentation</title>")?;
        writeln!(writer, "<style>")?;
        writeln!(writer, "body {{ font-family: sans-serif; margin: 20px; }}")?;
        writeln!(writer, "h1, h2, h3 {{ color: #333; }}")?;
        writeln!(writer, "table {{ border-collapse: collapse; width: 100%; }}")?;
        writeln!(writer, "th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}")?;
        writeln!(writer, "th {{ background-color: #f2f2f2; }}")?;
        writeln!(writer, "code {{ background-color: #f5f5f5; padding: 2px 4px; }}")?;
        writeln!(writer, "</style>")?;
        writeln!(writer, "</head>")?;
        writeln!(writer, "<body>")?;

        writeln!(writer, "<h1>Protocol Buffer Schema Documentation</h1>")?;

        if let Some(pkg) = &proto.package {
            writeln!(writer, "<p><strong>Package:</strong> <code>{}</code></p>", pkg)?;
        }

        writeln!(writer, "<h2>Messages</h2>")?;

        for message in &proto.messages {
            self.write_message_html(message, layout, writer)?;
        }

        if !proto.enums.is_empty() {
            writeln!(writer, "<h2>Enums</h2>")?;

            for enum_type in &proto.enums {
                self.write_enum_html(enum_type, writer)?;
            }
        }

        writeln!(writer, "</body>")?;
        writeln!(writer, "</html>")?;

        Ok(())
    }

    fn write_message_html<W: Write>(
        &self,
        message: &Message,
        layout: Option<&Layout>,
        writer: &mut W,
    ) -> Result<()> {
        writeln!(writer, "<h3>{}</h3>", message.name)?;

        if self.include_layout_info {
            if let Some(layout) = layout {
                if let Some(msg_layout) = layout.find_message(&message.name) {
                    writeln!(writer, "<p><strong>Layout Information:</strong></p>")?;
                    writeln!(writer, "<ul>")?;
                    writeln!(writer, "<li>Size: {} bytes</li>", msg_layout.size)?;
                    writeln!(writer, "<li>Alignment: {} bytes</li>", msg_layout.alignment)?;
                    writeln!(writer, "<li>Fields: {}</li>", msg_layout.fields.len())?;
                    writeln!(writer, "</ul>")?;
                }
            }
        }

        if !message.fields.is_empty() {
            writeln!(writer, "<table>")?;
            writeln!(writer, "<tr><th>Field</th><th>Type</th><th>Number</th><th>Repeated</th></tr>")?;

            for field in &message.fields {
                writeln!(
                    writer,
                    "<tr><td>{}</td><td><code>{}</code></td><td>{}</td><td>{}</td></tr>",
                    field.name,
                    Self::format_field_type(&field.field_type),
                    field.number,
                    if field.repeated { "Yes" } else { "No" }
                )?;
            }

            writeln!(writer, "</table>")?;
        }

        Ok(())
    }

    fn write_enum_html<W: Write>(&self, enum_type: &Enum, writer: &mut W) -> Result<()> {
        writeln!(writer, "<h3>{}</h3>", enum_type.name)?;

        if !enum_type.variants.is_empty() {
            writeln!(writer, "<table>")?;
            writeln!(writer, "<tr><th>Variant</th><th>Value</th></tr>")?;

            for variant in &enum_type.variants {
                writeln!(
                    writer,
                    "<tr><td>{}</td><td>{}</td></tr>",
                    variant.name, variant.number
                )?;
            }

            writeln!(writer, "</table>")?;
        }

        Ok(())
    }

    fn generate_plaintext<W: Write>(
        &self,
        proto: &ProtoFile,
        layout: Option<&Layout>,
        writer: &mut W,
    ) -> Result<()> {
        writeln!(writer, "Protocol Buffer Schema Documentation")?;
        writeln!(writer, "=====================================")?;
        writeln!(writer)?;

        if let Some(pkg) = &proto.package {
            writeln!(writer, "Package: {}", pkg)?;
            writeln!(writer)?;
        }

        writeln!(writer, "Messages:")?;
        writeln!(writer, "---------")?;
        writeln!(writer)?;

        for message in &proto.messages {
            self.write_message_plaintext(message, layout, writer)?;
        }

        if !proto.enums.is_empty() {
            writeln!(writer, "Enums:")?;
            writeln!(writer, "------")?;
            writeln!(writer)?;

            for enum_type in &proto.enums {
                self.write_enum_plaintext(enum_type, writer)?;
            }
        }

        Ok(())
    }

    fn write_message_plaintext<W: Write>(
        &self,
        message: &Message,
        layout: Option<&Layout>,
        writer: &mut W,
    ) -> Result<()> {
        writeln!(writer, "{}", message.name)?;

        if self.include_layout_info {
            if let Some(layout) = layout {
                if let Some(msg_layout) = layout.find_message(&message.name) {
                    writeln!(writer, "  Size: {} bytes", msg_layout.size)?;
                    writeln!(writer, "  Alignment: {} bytes", msg_layout.alignment)?;
                }
            }
        }

        for field in &message.fields {
            writeln!(
                writer,
                "  {} ({}) [{}]{}",
                field.name,
                Self::format_field_type(&field.field_type),
                field.number,
                if field.repeated { " repeated" } else { "" }
            )?;
        }

        writeln!(writer)?;

        Ok(())
    }

    fn write_enum_plaintext<W: Write>(&self, enum_type: &Enum, writer: &mut W) -> Result<()> {
        writeln!(writer, "{}", enum_type.name)?;

        for variant in &enum_type.variants {
            writeln!(writer, "  {} = {}", variant.name, variant.number)?;
        }

        writeln!(writer)?;

        Ok(())
    }

    fn format_field_type(field_type: &FieldType) -> String {
        match field_type {
            FieldType::Int32 => "int32".into(),
            FieldType::Int64 => "int64".into(),
            FieldType::Uint32 => "uint32".into(),
            FieldType::Uint64 => "uint64".into(),
            FieldType::Sint32 => "sint32".into(),
            FieldType::Sint64 => "sint64".into(),
            FieldType::Fixed32 => "fixed32".into(),
            FieldType::Fixed64 => "fixed64".into(),
            FieldType::Sfixed32 => "sfixed32".into(),
            FieldType::Sfixed64 => "sfixed64".into(),
            FieldType::Float => "float".into(),
            FieldType::Double => "double".into(),
            FieldType::Bool => "bool".into(),
            FieldType::String { max_length } => format!("string({})", max_length),
            FieldType::Bytes { max_length } => format!("bytes({})", max_length),
            FieldType::Message(name) => name.clone(),
            FieldType::Enum(name) => name.clone(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::types::{Message, Field, FieldType};

    fn create_test_proto() -> ProtoFile {
        ProtoFile {
            package: Some("test.proto".into()),
            messages: vec![Message {
                name: "TestMessage".into(),
                fields: vec![
                    Field {
                        name: "id".into(),
                        field_type: FieldType::Uint32,
                        number: 1,
                        repeated: false,
                        optional: false,
                        options: vec![],
                    },
                    Field {
                        name: "name".into(),
                        field_type: FieldType::String { max_length: 256 },
                        number: 2,
                        repeated: false,
                        optional: false,
                        options: vec![],
                    },
                ],
                options: vec![],
            }],
            enums: vec![],
        }
    }

    #[test]
    fn test_markdown_generation() {
        let proto = create_test_proto();
        let generator = DocGenerator::new().with_format(DocFormat::Markdown);

        let mut output = Vec::new();
        generator.generate(&proto, None, &mut output).unwrap();

        let doc = String::from_utf8(output).unwrap();
        assert!(doc.contains("# Protocol Buffer Schema Documentation"));
        assert!(doc.contains("TestMessage"));
        assert!(doc.contains("id"));
        assert!(doc.contains("name"));
    }

    #[test]
    fn test_html_generation() {
        let proto = create_test_proto();
        let generator = DocGenerator::new().with_format(DocFormat::Html);

        let mut output = Vec::new();
        generator.generate(&proto, None, &mut output).unwrap();

        let doc = String::from_utf8(output).unwrap();
        assert!(doc.contains("<!DOCTYPE html>"));
        assert!(doc.contains("<h1>Protocol Buffer Schema Documentation</h1>"));
        assert!(doc.contains("TestMessage"));
    }

    #[test]
    fn test_plaintext_generation() {
        let proto = create_test_proto();
        let generator = DocGenerator::new().with_format(DocFormat::PlainText);

        let mut output = Vec::new();
        generator.generate(&proto, None, &mut output).unwrap();

        let doc = String::from_utf8(output).unwrap();
        assert!(doc.contains("Protocol Buffer Schema Documentation"));
        assert!(doc.contains("TestMessage"));
        assert!(doc.contains("id (uint32) [1]"));
    }
}
