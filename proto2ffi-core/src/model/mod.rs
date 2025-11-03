mod service;
mod method;
mod message;

pub use service::ProtoService;
pub use method::ServiceMethod;
pub use message::{MessageType, Field, FieldType};

use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct ProtoFile {
    pub package: String,
    pub services: Vec<ProtoService>,
    pub messages: HashMap<String, MessageType>,
}

impl ProtoFile {
    pub fn new(package: String) -> Self {
        Self {
            package,
            services: Vec::new(),
            messages: HashMap::new(),
        }
    }

    pub fn add_service(&mut self, service: ProtoService) {
        self.services.push(service);
    }

    pub fn add_message(&mut self, name: String, message: MessageType) {
        self.messages.insert(name, message);
    }

    pub fn find_message(&self, name: &str) -> Option<&MessageType> {
        self.messages.get(name)
    }
}
