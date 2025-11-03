use crate::error::{Proto2FFIError, Result};
use crate::types::{ProtoFile, Message, Field, FieldType};
use std::collections::{HashMap, HashSet};

pub fn validate_proto_file(proto: &ProtoFile) -> Result<ValidationReport> {
    let mut report = ValidationReport {
        errors: Vec::new(),
        warnings: Vec::new(),
    };

    validate_messages(proto, &mut report)?;
    validate_enums(proto, &mut report)?;
    validate_field_references(proto, &mut report)?;
    detect_circular_dependencies(proto, &mut report)?;

    if !report.errors.is_empty() {
        return Err(Proto2FFIError::ValidationError {
            message: "Validation failed".to_string(),
            reason: format!("{} errors found", report.errors.len()),
        });
    }

    Ok(report)
}

fn validate_messages(proto: &ProtoFile, report: &mut ValidationReport) -> Result<()> {
    let mut message_names = HashSet::new();

    for message in &proto.messages {
        if message.name.is_empty() {
            report.errors.push("Message has empty name".to_string());
        }

        if !message_names.insert(&message.name) {
            report.errors.push(format!("Duplicate message name: {}", message.name));
        }

        if message.fields.is_empty() {
            report.warnings.push(format!("Message '{}' has no fields", message.name));
        }

        validate_field_numbers(message, report)?;
        validate_field_names(message, report)?;
    }

    Ok(())
}

fn validate_field_numbers(message: &Message, report: &mut ValidationReport) -> Result<()> {
    let mut numbers = HashMap::new();

    for field in &message.fields {
        if field.number < 1 || field.number > 536870911 {
            report.errors.push(format!(
                "Field '{}' in message '{}' has invalid number {} (must be 1-536870911)",
                field.name, message.name, field.number
            ));
        }

        if field.number >= 19000 && field.number <= 19999 {
            report.warnings.push(format!(
                "Field '{}' in message '{}' uses reserved range 19000-19999",
                field.name, message.name
            ));
        }

        if let Some(existing) = numbers.insert(field.number, &field.name) {
            report.errors.push(format!(
                "Duplicate field number {} in message '{}' (fields '{}' and '{}')",
                field.number, message.name, existing, field.name
            ));
        }
    }

    Ok(())
}

fn validate_field_names(message: &Message, report: &mut ValidationReport) -> Result<()> {
    let mut names = HashSet::new();

    for field in &message.fields {
        if field.name.is_empty() {
            report.errors.push(format!("Empty field name in message '{}'", message.name));
        }

        if field.name.starts_with('_') {
            report.warnings.push(format!(
                "Field '{}' in message '{}' starts with underscore",
                field.name, message.name
            ));
        }

        if !names.insert(&field.name) {
            report.errors.push(format!(
                "Duplicate field name '{}' in message '{}'",
                field.name, message.name
            ));
        }

        validate_field_type(&field, message, report)?;
    }

    Ok(())
}

fn validate_field_type(field: &Field, message: &Message, report: &mut ValidationReport) -> Result<()> {
    match &field.field_type {
        FieldType::String { max_length } => {
            if *max_length == 0 {
                report.warnings.push(format!(
                    "Field '{}' in message '{}' has zero max_length",
                    field.name, message.name
                ));
            }
            if *max_length > 10_000_000 {
                report.warnings.push(format!(
                    "Field '{}' in message '{}' has very large max_length: {}",
                    field.name, message.name, max_length
                ));
            }
        }
        FieldType::Bytes { max_length } => {
            if *max_length == 0 {
                report.warnings.push(format!(
                    "Field '{}' in message '{}' has zero max_length",
                    field.name, message.name
                ));
            }
            if *max_length > 100_000_000 {
                report.warnings.push(format!(
                    "Field '{}' in message '{}' has very large max_length: {}",
                    field.name, message.name, max_length
                ));
            }
        }
        _ => {}
    }

    if field.repeated {
        for option in &field.options {
            if option.name == "proto2ffi.max_count" {
                if let Ok(count) = option.value.parse::<usize>() {
                    if count == 0 {
                        report.errors.push(format!(
                            "Repeated field '{}' in message '{}' has zero max_count",
                            field.name, message.name
                        ));
                    }
                    if count > 1_000_000 {
                        report.warnings.push(format!(
                            "Repeated field '{}' in message '{}' has very large max_count: {}",
                            field.name, message.name, count
                        ));
                    }
                }
            }
        }
    }

    Ok(())
}

fn validate_enums(proto: &ProtoFile, report: &mut ValidationReport) -> Result<()> {
    let mut enum_names = HashSet::new();

    for enum_def in &proto.enums {
        if enum_def.name.is_empty() {
            report.errors.push("Enum has empty name".to_string());
        }

        if !enum_names.insert(&enum_def.name) {
            report.errors.push(format!("Duplicate enum name: {}", enum_def.name));
        }

        if enum_def.variants.is_empty() {
            report.errors.push(format!("Enum '{}' has no variants", enum_def.name));
        }

        let mut variant_names = HashSet::new();
        let mut variant_values = HashSet::new();

        for variant in &enum_def.variants {
            if !variant_names.insert(&variant.name) {
                report.errors.push(format!(
                    "Duplicate variant name '{}' in enum '{}'",
                    variant.name, enum_def.name
                ));
            }

            if !variant_values.insert(variant.number) {
                report.warnings.push(format!(
                    "Duplicate variant value {} in enum '{}'",
                    variant.number, enum_def.name
                ));
            }
        }
    }

    Ok(())
}

fn validate_field_references(proto: &ProtoFile, report: &mut ValidationReport) -> Result<()> {
    let message_names: HashSet<_> = proto.messages.iter().map(|m| m.name.as_str()).collect();
    let enum_names: HashSet<_> = proto.enums.iter().map(|e| e.name.as_str()).collect();

    for message in &proto.messages {
        for field in &message.fields {
            match &field.field_type {
                FieldType::Message(type_name) => {
                    if !message_names.contains(type_name.as_str()) && !enum_names.contains(type_name.as_str()) {
                        report.errors.push(format!(
                            "Field '{}' in message '{}' references undefined type '{}'",
                            field.name, message.name, type_name
                        ));
                    }
                }
                FieldType::Enum(type_name) => {
                    if !enum_names.contains(type_name.as_str()) {
                        report.errors.push(format!(
                            "Field '{}' in message '{}' references undefined enum '{}'",
                            field.name, message.name, type_name
                        ));
                    }
                }
                _ => {}
            }
        }
    }

    Ok(())
}

fn detect_circular_dependencies(proto: &ProtoFile, report: &mut ValidationReport) -> Result<()> {
    let mut graph: HashMap<&str, Vec<&str>> = HashMap::new();

    for message in &proto.messages {
        let mut deps = Vec::new();
        for field in &message.fields {
            if let FieldType::Message(type_name) = &field.field_type {
                deps.push(type_name.as_str());
            }
        }
        graph.insert(message.name.as_str(), deps);
    }

    for message in &proto.messages {
        let mut visited = HashSet::new();
        let mut path = Vec::new();
        if has_cycle(&graph, message.name.as_str(), &mut visited, &mut path) {
            report.errors.push(format!(
                "Circular dependency detected: {} -> {}",
                path.join(" -> "),
                message.name
            ));
        }
    }

    Ok(())
}

fn has_cycle<'a>(
    graph: &HashMap<&'a str, Vec<&'a str>>,
    node: &'a str,
    visited: &mut HashSet<&'a str>,
    path: &mut Vec<&'a str>,
) -> bool {
    if path.contains(&node) {
        return true;
    }

    if visited.contains(node) {
        return false;
    }

    visited.insert(node);
    path.push(node);

    if let Some(deps) = graph.get(node) {
        for dep in deps {
            if has_cycle(graph, dep, visited, path) {
                return true;
            }
        }
    }

    path.pop();
    false
}

#[derive(Debug, Clone)]
pub struct ValidationReport {
    pub errors: Vec<String>,
    pub warnings: Vec<String>,
}

impl ValidationReport {
    pub fn has_errors(&self) -> bool {
        !self.errors.is_empty()
    }

    pub fn has_warnings(&self) -> bool {
        !self.warnings.is_empty()
    }

    pub fn error_count(&self) -> usize {
        self.errors.len()
    }

    pub fn warning_count(&self) -> usize {
        self.warnings.len()
    }
}
