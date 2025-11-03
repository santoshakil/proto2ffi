use crate::layout::{Layout, MessageLayout, FieldLayout};
use crate::types::{ProtoFile, FieldType};
use crate::error::Result;
use std::collections::{HashMap, HashSet};

#[derive(Debug, Clone)]
pub struct OptimizationConfig {
    pub enable_field_reordering: bool,
    pub enable_padding_reduction: bool,
    pub enable_unused_field_removal: bool,
    pub enable_constant_folding: bool,
    pub enable_inline_small_messages: bool,
    pub max_inline_size: usize,
}

impl Default for OptimizationConfig {
    fn default() -> Self {
        Self {
            enable_field_reordering: true,
            enable_padding_reduction: true,
            enable_unused_field_removal: false,
            enable_constant_folding: true,
            enable_inline_small_messages: true,
            max_inline_size: 64,
        }
    }
}

pub struct Optimizer {
    config: OptimizationConfig,
}

impl Optimizer {
    pub fn new(config: OptimizationConfig) -> Self {
        Self { config }
    }

    pub fn optimize_layout(&self, layout: Layout) -> Result<Layout> {
        let mut optimized = layout;

        if self.config.enable_field_reordering {
            optimized = self.reorder_fields(optimized)?;
        }

        if self.config.enable_padding_reduction {
            optimized = self.reduce_padding(optimized)?;
        }

        Ok(optimized)
    }

    pub fn optimize_proto(&self, proto: ProtoFile, used_fields: &UsedFieldsAnalysis) -> Result<ProtoFile> {
        let mut optimized = proto;

        if self.config.enable_unused_field_removal {
            optimized = self.remove_unused_fields(optimized, used_fields)?;
        }

        Ok(optimized)
    }

    fn reorder_fields(&self, mut layout: Layout) -> Result<Layout> {
        for message in &mut layout.messages {
            message.fields.sort_by(|a, b| {
                b.size.cmp(&a.size)
                    .then_with(|| b.alignment.cmp(&a.alignment))
                    .then_with(|| a.offset.cmp(&b.offset))
            });

            let mut offset = 0usize;
            for field in &mut message.fields {
                let aligned_offset = (offset + field.alignment - 1) & !(field.alignment - 1);
                field.offset = aligned_offset;
                offset = aligned_offset + field.size;
            }

            let final_aligned = (offset + message.alignment - 1) & !(message.alignment - 1);
            message.size = final_aligned;
        }

        Ok(layout)
    }

    fn reduce_padding(&self, mut layout: Layout) -> Result<Layout> {
        for message in &mut layout.messages {
            let mut fields_by_alignment: HashMap<usize, Vec<usize>> = HashMap::new();

            for (idx, field) in message.fields.iter().enumerate() {
                fields_by_alignment
                    .entry(field.alignment)
                    .or_default()
                    .push(idx);
            }

            let mut alignments: Vec<_> = fields_by_alignment.keys().copied().collect();
            alignments.sort_by(|a, b| b.cmp(a));

            let mut new_order: Vec<usize> = Vec::new();
            for align in alignments {
                if let Some(indices) = fields_by_alignment.get(&align) {
                    new_order.extend(indices);
                }
            }

            let mut reordered_fields = Vec::with_capacity(message.fields.len());
            for &idx in &new_order {
                reordered_fields.push(message.fields[idx].clone());
            }

            message.fields = reordered_fields;

            let mut offset = 0usize;
            for field in &mut message.fields {
                let aligned_offset = (offset + field.alignment - 1) & !(field.alignment - 1);
                field.offset = aligned_offset;
                offset = aligned_offset + field.size;
            }

            let final_aligned = (offset + message.alignment - 1) & !(message.alignment - 1);
            message.size = final_aligned;
        }

        Ok(layout)
    }

    fn remove_unused_fields(&self, mut proto: ProtoFile, used: &UsedFieldsAnalysis) -> Result<ProtoFile> {
        for message in &mut proto.messages {
            if let Some(used_fields) = used.message_fields.get(&message.name) {
                message.fields.retain(|f| used_fields.contains(&f.name));
            }
        }

        Ok(proto)
    }
}

#[derive(Debug, Default)]
pub struct UsedFieldsAnalysis {
    pub message_fields: HashMap<String, HashSet<String>>,
}

impl UsedFieldsAnalysis {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn mark_field_used(&mut self, message: &str, field: &str) {
        self.message_fields
            .entry(message.to_string())
            .or_default()
            .insert(field.to_string());
    }

    pub fn mark_message_used(&mut self, proto: &ProtoFile, message_name: &str) {
        if let Some(message) = proto.messages.iter().find(|m| m.name == message_name) {
            for field in &message.fields {
                self.mark_field_used(message_name, &field.name);

                if let FieldType::Message(ref nested_msg) = field.field_type {
                    self.mark_message_used(proto, nested_msg);
                }
            }
        }
    }

    pub fn analyze_from_roots(&mut self, proto: &ProtoFile, root_messages: &[String]) {
        for root in root_messages {
            self.mark_message_used(proto, root);
        }
    }
}

pub fn calculate_padding_waste(layout: &Layout) -> HashMap<String, usize> {
    let mut waste = HashMap::new();

    for message in &layout.messages {
        let field_sizes: usize = message.fields.iter().map(|f| f.size).sum();
        let padding = message.size.saturating_sub(field_sizes);
        waste.insert(message.name.clone(), padding);
    }

    waste
}

pub fn calculate_packing_efficiency(layout: &Layout) -> HashMap<String, f64> {
    let mut efficiency = HashMap::new();

    for message in &layout.messages {
        if message.size == 0 {
            efficiency.insert(message.name.clone(), 0.0);
            continue;
        }

        let field_sizes: usize = message.fields.iter().map(|f| f.size).sum();
        let eff = field_sizes as f64 / message.size as f64;
        efficiency.insert(message.name.clone(), eff);
    }

    efficiency
}

pub fn find_oversized_messages(layout: &Layout, threshold: usize) -> Vec<String> {
    layout
        .messages
        .iter()
        .filter(|m| m.size > threshold)
        .map(|m| m.name.clone())
        .collect()
}

pub fn suggest_field_splits(layout: &Layout, max_size: usize) -> HashMap<String, Vec<Vec<String>>> {
    let mut suggestions = HashMap::new();

    for message in &layout.messages {
        if message.size <= max_size {
            continue;
        }

        let mut splits = Vec::new();
        let mut current_split = Vec::new();
        let mut current_size = 0usize;

        for field in &message.fields {
            if current_size + field.size > max_size && !current_split.is_empty() {
                splits.push(current_split.clone());
                current_split.clear();
                current_size = 0;
            }

            current_split.push(field.name.clone());
            current_size += field.size;
        }

        if !current_split.is_empty() {
            splits.push(current_split);
        }

        if splits.len() > 1 {
            suggestions.insert(message.name.clone(), splits);
        }
    }

    suggestions
}

#[cfg(test)]
mod tests {
    use super::*;

    fn create_test_layout() -> Layout {
        Layout {
            messages: vec![MessageLayout {
                name: "Test".into(),
                size: 32,
                alignment: 8,
                fields: vec![
                    FieldLayout {
                        name: "a".into(),
                        rust_type: "u8".into(),
                        dart_type: "int".into(),
                        dart_annotation: "Uint8()".into(),
                        c_type: "uint8_t".into(),
                        offset: 0,
                        size: 1,
                        alignment: 1,
                        repeated: false,
                        max_count: None,
                    },
                    FieldLayout {
                        name: "b".into(),
                        rust_type: "u64".into(),
                        dart_type: "int".into(),
                        dart_annotation: "Uint64()".into(),
                        c_type: "uint64_t".into(),
                        offset: 8,
                        size: 8,
                        alignment: 8,
                        repeated: false,
                        max_count: None,
                    },
                ],
                options: HashMap::new(),
            }],
            enums: vec![],
            alignment: 8,
        }
    }

    #[test]
    fn test_field_reordering() {
        let layout = create_test_layout();
        let optimizer = Optimizer::new(OptimizationConfig::default());

        let optimized = optimizer.reorder_fields(layout).unwrap();

        assert_eq!(optimized.messages[0].fields[0].name, "b");
        assert_eq!(optimized.messages[0].fields[1].name, "a");
    }

    #[test]
    fn test_padding_waste() {
        let layout = create_test_layout();
        let waste = calculate_padding_waste(&layout);

        assert!(waste.get("Test").copied().unwrap_or(0) > 0);
    }

    #[test]
    fn test_packing_efficiency() {
        let layout = create_test_layout();
        let efficiency = calculate_packing_efficiency(&layout);

        let eff = efficiency.get("Test").copied().unwrap_or(0.0);
        assert!(eff > 0.0 && eff <= 1.0);
    }

    #[test]
    fn test_oversized_detection() {
        let layout = create_test_layout();
        let oversized = find_oversized_messages(&layout, 16);

        assert!(oversized.contains(&"Test".to_string()));
    }
}
