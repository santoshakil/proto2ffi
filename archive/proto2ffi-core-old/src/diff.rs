use crate::types::{ProtoFile, Message, Field, Enum, FieldType};
use crate::layout::Layout;
use std::collections::HashMap;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ChangeKind {
    Breaking,
    Compatible,
    Informational,
}

#[derive(Debug, Clone)]
pub struct Change {
    pub kind: ChangeKind,
    pub category: ChangeCategory,
    pub description: String,
    pub path: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ChangeCategory {
    MessageAdded,
    MessageRemoved,
    MessageRenamed,
    FieldAdded,
    FieldRemoved,
    FieldTypeChanged,
    FieldNumberChanged,
    FieldRenamed,
    EnumAdded,
    EnumRemoved,
    EnumVariantAdded,
    EnumVariantRemoved,
    EnumVariantValueChanged,
    LayoutChanged,
}

#[derive(Debug, Default)]
pub struct ProtoDiff {
    pub changes: Vec<Change>,
}

impl ProtoDiff {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn has_breaking_changes(&self) -> bool {
        self.changes.iter().any(|c| c.kind == ChangeKind::Breaking)
    }

    pub fn breaking_changes(&self) -> Vec<&Change> {
        self.changes.iter().filter(|c| c.kind == ChangeKind::Breaking).collect()
    }

    pub fn compatible_changes(&self) -> Vec<&Change> {
        self.changes.iter().filter(|c| c.kind == ChangeKind::Compatible).collect()
    }

    pub fn summary(&self) -> DiffSummary {
        let mut summary = DiffSummary::default();

        for change in &self.changes {
            match change.kind {
                ChangeKind::Breaking => summary.breaking += 1,
                ChangeKind::Compatible => summary.compatible += 1,
                ChangeKind::Informational => summary.informational += 1,
            }
        }

        summary
    }
}

#[derive(Debug, Default, Clone)]
pub struct DiffSummary {
    pub breaking: usize,
    pub compatible: usize,
    pub informational: usize,
}

impl DiffSummary {
    pub fn total(&self) -> usize {
        self.breaking + self.compatible + self.informational
    }
}

pub fn diff_protos(old: &ProtoFile, new: &ProtoFile) -> ProtoDiff {
    let mut diff = ProtoDiff::new();

    diff_messages(old, new, &mut diff);
    diff_enums(old, new, &mut diff);

    diff
}

fn diff_messages(old: &ProtoFile, new: &ProtoFile, diff: &mut ProtoDiff) {
    let old_messages: HashMap<_, _> = old.messages.iter().map(|m| (&m.name, m)).collect();
    let new_messages: HashMap<_, _> = new.messages.iter().map(|m| (&m.name, m)).collect();

    for (name, new_msg) in &new_messages {
        if !old_messages.contains_key(name) {
            diff.changes.push(Change {
                kind: ChangeKind::Compatible,
                category: ChangeCategory::MessageAdded,
                description: format!("Added message '{}'", name),
                path: name.to_string(),
            });
        }
    }

    for (name, old_msg) in &old_messages {
        if let Some(new_msg) = new_messages.get(name) {
            diff_message_fields(old_msg, new_msg, diff);
        } else {
            diff.changes.push(Change {
                kind: ChangeKind::Breaking,
                category: ChangeCategory::MessageRemoved,
                description: format!("Removed message '{}'", name),
                path: name.to_string(),
            });
        }
    }
}

fn diff_message_fields(old_msg: &Message, new_msg: &Message, diff: &mut ProtoDiff) {
    let old_fields: HashMap<_, _> = old_msg.fields.iter().map(|f| (&f.name, f)).collect();
    let new_fields: HashMap<_, _> = new_msg.fields.iter().map(|f| (&f.name, f)).collect();

    for (name, new_field) in &new_fields {
        let path = format!("{}.{}", old_msg.name, name);

        if let Some(old_field) = old_fields.get(name) {
            if old_field.number != new_field.number {
                diff.changes.push(Change {
                    kind: ChangeKind::Breaking,
                    category: ChangeCategory::FieldNumberChanged,
                    description: format!(
                        "Field number changed from {} to {}",
                        old_field.number, new_field.number
                    ),
                    path: path.clone(),
                });
            }

            if !is_compatible_type_change(&old_field.field_type, &new_field.field_type) {
                diff.changes.push(Change {
                    kind: ChangeKind::Breaking,
                    category: ChangeCategory::FieldTypeChanged,
                    description: format!(
                        "Field type changed from {:?} to {:?}",
                        old_field.field_type, new_field.field_type
                    ),
                    path: path.clone(),
                });
            }
        } else {
            diff.changes.push(Change {
                kind: ChangeKind::Compatible,
                category: ChangeCategory::FieldAdded,
                description: format!("Added field '{}'", name),
                path,
            });
        }
    }

    for (name, _old_field) in &old_fields {
        if !new_fields.contains_key(name) {
            diff.changes.push(Change {
                kind: ChangeKind::Breaking,
                category: ChangeCategory::FieldRemoved,
                description: format!("Removed field '{}'", name),
                path: format!("{}.{}", old_msg.name, name),
            });
        }
    }
}

fn diff_enums(old: &ProtoFile, new: &ProtoFile, diff: &mut ProtoDiff) {
    let old_enums: HashMap<_, _> = old.enums.iter().map(|e| (&e.name, e)).collect();
    let new_enums: HashMap<_, _> = new.enums.iter().map(|e| (&e.name, e)).collect();

    for (name, _new_enum) in &new_enums {
        if !old_enums.contains_key(name) {
            diff.changes.push(Change {
                kind: ChangeKind::Compatible,
                category: ChangeCategory::EnumAdded,
                description: format!("Added enum '{}'", name),
                path: name.to_string(),
            });
        }
    }

    for (name, old_enum) in &old_enums {
        if let Some(new_enum) = new_enums.get(name) {
            diff_enum_variants(old_enum, new_enum, diff);
        } else {
            diff.changes.push(Change {
                kind: ChangeKind::Breaking,
                category: ChangeCategory::EnumRemoved,
                description: format!("Removed enum '{}'", name),
                path: name.to_string(),
            });
        }
    }
}

fn diff_enum_variants(old_enum: &Enum, new_enum: &Enum, diff: &mut ProtoDiff) {
    let old_variants: HashMap<_, _> = old_enum.variants.iter().map(|v| (&v.name, v.number)).collect();
    let new_variants: HashMap<_, _> = new_enum.variants.iter().map(|v| (&v.name, v.number)).collect();

    for (name, new_value) in &new_variants {
        let path = format!("{}.{}", old_enum.name, name);

        if let Some(&old_value) = old_variants.get(name) {
            if old_value != *new_value {
                diff.changes.push(Change {
                    kind: ChangeKind::Breaking,
                    category: ChangeCategory::EnumVariantValueChanged,
                    description: format!(
                        "Enum variant value changed from {} to {}",
                        old_value, new_value
                    ),
                    path,
                });
            }
        } else {
            diff.changes.push(Change {
                kind: ChangeKind::Compatible,
                category: ChangeCategory::EnumVariantAdded,
                description: format!("Added enum variant '{}'", name),
                path,
            });
        }
    }

    for (name, _) in &old_variants {
        if !new_variants.contains_key(name) {
            diff.changes.push(Change {
                kind: ChangeKind::Breaking,
                category: ChangeCategory::EnumVariantRemoved,
                description: format!("Removed enum variant '{}'", name),
                path: format!("{}.{}", old_enum.name, name),
            });
        }
    }
}

fn is_compatible_type_change(old: &FieldType, new: &FieldType) -> bool {
    if old == new {
        return true;
    }

    matches!(
        (old, new),
        (FieldType::Int32, FieldType::Int64)
            | (FieldType::Uint32, FieldType::Uint64)
            | (FieldType::Fixed32, FieldType::Fixed64)
            | (FieldType::Sfixed32, FieldType::Sfixed64)
    )
}

pub fn diff_layouts(old: &Layout, new: &Layout) -> ProtoDiff {
    let mut diff = ProtoDiff::new();

    let old_messages: HashMap<_, _> = old.messages.iter().map(|m| (&m.name, m)).collect();
    let new_messages: HashMap<_, _> = new.messages.iter().map(|m| (&m.name, m)).collect();

    for (name, new_msg) in &new_messages {
        if let Some(old_msg) = old_messages.get(name) {
            if old_msg.size != new_msg.size || old_msg.alignment != new_msg.alignment {
                diff.changes.push(Change {
                    kind: ChangeKind::Breaking,
                    category: ChangeCategory::LayoutChanged,
                    description: format!(
                        "Layout changed: size {}→{}, alignment {}→{}",
                        old_msg.size, new_msg.size, old_msg.alignment, new_msg.alignment
                    ),
                    path: name.to_string(),
                });
            }
        }
    }

    diff
}

#[cfg(test)]
mod tests {
    use super::*;

    fn create_test_proto() -> ProtoFile {
        ProtoFile {
            package: Some("test".into()),
            messages: vec![Message {
                name: "Test".into(),
                fields: vec![Field {
                    name: "id".into(),
                    field_type: FieldType::Uint32,
                    number: 1,
                    repeated: false,
                    optional: false,
                    options: vec![],
                }],
                options: vec![],
            }],
            enums: vec![],
        }
    }

    #[test]
    fn test_no_changes() {
        let proto1 = create_test_proto();
        let proto2 = create_test_proto();

        let diff = diff_protos(&proto1, &proto2);
        assert_eq!(diff.changes.len(), 0);
    }

    #[test]
    fn test_field_added() {
        let proto1 = create_test_proto();
        let mut proto2 = create_test_proto();

        proto2.messages[0].fields.push(Field {
            name: "name".into(),
            field_type: FieldType::String { max_length: 256 },
            number: 2,
            repeated: false,
            optional: false,
            options: vec![],
        });

        let diff = diff_protos(&proto1, &proto2);
        assert_eq!(diff.changes.len(), 1);
        assert_eq!(diff.changes[0].category, ChangeCategory::FieldAdded);
        assert!(!diff.has_breaking_changes());
    }

    #[test]
    fn test_field_removed() {
        let mut proto1 = create_test_proto();
        proto1.messages[0].fields.push(Field {
            name: "extra".into(),
            field_type: FieldType::Uint32,
            number: 2,
            repeated: false,
            optional: false,
            options: vec![],
        });

        let proto2 = create_test_proto();

        let diff = diff_protos(&proto1, &proto2);
        assert_eq!(diff.changes.len(), 1);
        assert_eq!(diff.changes[0].category, ChangeCategory::FieldRemoved);
        assert!(diff.has_breaking_changes());
    }

    #[test]
    fn test_compatible_type_change() {
        assert!(is_compatible_type_change(&FieldType::Int32, &FieldType::Int64));
        assert!(is_compatible_type_change(&FieldType::Uint32, &FieldType::Uint64));
        assert!(!is_compatible_type_change(&FieldType::Int32, &FieldType::Uint32));
    }

    #[test]
    fn test_diff_summary() {
        let mut diff = ProtoDiff::new();

        diff.changes.push(Change {
            kind: ChangeKind::Breaking,
            category: ChangeCategory::FieldRemoved,
            description: "test".into(),
            path: "test.field".into(),
        });

        diff.changes.push(Change {
            kind: ChangeKind::Compatible,
            category: ChangeCategory::FieldAdded,
            description: "test".into(),
            path: "test.field2".into(),
        });

        let summary = diff.summary();
        assert_eq!(summary.breaking, 1);
        assert_eq!(summary.compatible, 1);
        assert_eq!(summary.total(), 2);
    }
}
