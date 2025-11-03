use crate::layout::{Layout, MessageLayout};
use crate::types::ProtoFile;
use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct ProtoStats {
    pub message_count: usize,
    pub enum_count: usize,
    pub total_fields: usize,
    pub repeated_fields: usize,
    pub optional_fields: usize,
    pub largest_message: Option<String>,
    pub largest_message_size: usize,
    pub smallest_message: Option<String>,
    pub smallest_message_size: usize,
    pub field_type_distribution: HashMap<String, usize>,
}

impl ProtoStats {
    pub fn from_proto(proto: &ProtoFile) -> Self {
        let mut total_fields = 0;
        let mut repeated_fields = 0;
        let mut optional_fields = 0;
        let mut field_type_distribution = HashMap::new();

        for message in &proto.messages {
            total_fields += message.fields.len();

            for field in &message.fields {
                if field.repeated {
                    repeated_fields += 1;
                }
                if field.optional {
                    optional_fields += 1;
                }

                let type_name = format!("{:?}", field.field_type);
                *field_type_distribution.entry(type_name).or_insert(0) += 1;
            }
        }

        Self {
            message_count: proto.messages.len(),
            enum_count: proto.enums.len(),
            total_fields,
            repeated_fields,
            optional_fields,
            largest_message: None,
            largest_message_size: 0,
            smallest_message: None,
            smallest_message_size: 0,
            field_type_distribution,
        }
    }

    pub fn from_layout(layout: &Layout) -> Self {
        let mut total_fields = 0;
        let mut repeated_fields = 0;
        let optional_fields = 0;
        let mut field_type_distribution = HashMap::new();
        let mut largest_message = None;
        let mut largest_message_size = 0;
        let mut smallest_message = None;
        let mut smallest_message_size = usize::MAX;

        for message in &layout.messages {
            total_fields += message.fields.len();

            for field in &message.fields {
                if field.repeated {
                    repeated_fields += 1;
                }

                let type_name = field.rust_type.clone();
                *field_type_distribution.entry(type_name).or_insert(0) += 1;
            }

            if message.size > largest_message_size {
                largest_message_size = message.size;
                largest_message = Some(message.name.clone());
            }

            if message.size < smallest_message_size {
                smallest_message_size = message.size;
                smallest_message = Some(message.name.clone());
            }
        }

        Self {
            message_count: layout.messages.len(),
            enum_count: layout.enums.len(),
            total_fields,
            repeated_fields,
            optional_fields,
            largest_message,
            largest_message_size,
            smallest_message,
            smallest_message_size: if smallest_message_size == usize::MAX { 0 } else { smallest_message_size },
            field_type_distribution,
        }
    }

    pub fn report(&self) -> String {
        let mut output = String::new();

        output.push_str("Proto Statistics:\n");
        output.push_str("=================\n\n");

        output.push_str(&format!("Messages: {}\n", self.message_count));
        output.push_str(&format!("Enums:    {}\n", self.enum_count));
        output.push_str(&format!("Fields:   {}\n", self.total_fields));
        output.push_str(&format!("  Repeated: {}\n", self.repeated_fields));
        output.push_str(&format!("  Optional: {}\n", self.optional_fields));

        if let Some(name) = &self.largest_message {
            output.push_str(&format!("\nLargest message:  {} ({} bytes)\n", name, self.largest_message_size));
        }

        if let Some(name) = &self.smallest_message {
            output.push_str(&format!("Smallest message: {} ({} bytes)\n", name, self.smallest_message_size));
        }

        output.push_str("\nField Type Distribution:\n");
        let mut types: Vec<_> = self.field_type_distribution.iter().collect();
        types.sort_by_key(|(_, count)| std::cmp::Reverse(*count));

        for (type_name, count) in types {
            output.push_str(&format!("  {:30} {}\n", type_name, count));
        }

        output
    }

    pub fn avg_fields_per_message(&self) -> f64 {
        if self.message_count == 0 {
            0.0
        } else {
            self.total_fields as f64 / self.message_count as f64
        }
    }

    pub fn repeated_field_ratio(&self) -> f64 {
        if self.total_fields == 0 {
            0.0
        } else {
            self.repeated_fields as f64 / self.total_fields as f64
        }
    }

    pub fn optional_field_ratio(&self) -> f64 {
        if self.total_fields == 0 {
            0.0
        } else {
            self.optional_fields as f64 / self.total_fields as f64
        }
    }
}

#[derive(Debug, Clone)]
pub struct LayoutStats {
    pub total_size: usize,
    pub total_padding: usize,
    pub avg_message_size: f64,
    pub avg_padding_per_message: f64,
    pub memory_efficiency: f64,
    pub messages_with_padding: usize,
}

impl LayoutStats {
    pub fn from_layout(layout: &Layout) -> Self {
        let mut total_size = 0;
        let mut total_padding = 0;
        let mut messages_with_padding = 0;

        for message in &layout.messages {
            total_size += message.size;
            let padding = message.padding_bytes();
            total_padding += padding;

            if padding > 0 {
                messages_with_padding += 1;
            }
        }

        let message_count = layout.messages.len();
        let avg_message_size = if message_count == 0 {
            0.0
        } else {
            total_size as f64 / message_count as f64
        };

        let avg_padding_per_message = if message_count == 0 {
            0.0
        } else {
            total_padding as f64 / message_count as f64
        };

        let memory_efficiency = if total_size == 0 {
            100.0
        } else {
            ((total_size - total_padding) as f64 / total_size as f64) * 100.0
        };

        Self {
            total_size,
            total_padding,
            avg_message_size,
            avg_padding_per_message,
            memory_efficiency,
            messages_with_padding,
        }
    }

    pub fn report(&self) -> String {
        let mut output = String::new();

        output.push_str("Layout Statistics:\n");
        output.push_str("==================\n\n");

        output.push_str(&format!("Total size:               {} bytes\n", self.total_size));
        output.push_str(&format!("Total padding:            {} bytes\n", self.total_padding));
        output.push_str(&format!("Avg message size:         {:.2} bytes\n", self.avg_message_size));
        output.push_str(&format!("Avg padding per message:  {:.2} bytes\n", self.avg_padding_per_message));
        output.push_str(&format!("Memory efficiency:        {:.2}%\n", self.memory_efficiency));
        output.push_str(&format!("Messages with padding:    {}\n", self.messages_with_padding));

        output
    }
}

pub fn analyze_message(message: &MessageLayout) -> MessageAnalysis {
    let field_count = message.fields.len();
    let size = message.size;
    let padding = message.padding_bytes();
    let alignment = message.alignment;

    let has_repeated = message.fields.iter().any(|f| f.repeated);
    let repeated_count = message.fields.iter().filter(|f| f.repeated).count();

    let avg_field_size = if field_count == 0 {
        0.0
    } else {
        size as f64 / field_count as f64
    };

    let efficiency = if size == 0 {
        100.0
    } else {
        ((size - padding) as f64 / size as f64) * 100.0
    };

    MessageAnalysis {
        name: message.name.clone(),
        size,
        padding,
        alignment,
        field_count,
        repeated_count,
        has_repeated,
        avg_field_size,
        efficiency,
    }
}

#[derive(Debug, Clone)]
pub struct MessageAnalysis {
    pub name: String,
    pub size: usize,
    pub padding: usize,
    pub alignment: usize,
    pub field_count: usize,
    pub repeated_count: usize,
    pub has_repeated: bool,
    pub avg_field_size: f64,
    pub efficiency: f64,
}

impl MessageAnalysis {
    pub fn report(&self) -> String {
        let mut output = String::new();

        output.push_str(&format!("Message Analysis: {}\n", self.name));
        output.push_str("==================\n\n");

        output.push_str(&format!("Size:          {} bytes\n", self.size));
        output.push_str(&format!("Padding:       {} bytes\n", self.padding));
        output.push_str(&format!("Alignment:     {} bytes\n", self.alignment));
        output.push_str(&format!("Fields:        {}\n", self.field_count));
        output.push_str(&format!("Repeated:      {}\n", self.repeated_count));
        output.push_str(&format!("Avg field:     {:.2} bytes\n", self.avg_field_size));
        output.push_str(&format!("Efficiency:    {:.2}%\n", self.efficiency));

        output
    }
}
