use super::ServiceMethod;

#[derive(Debug, Clone)]
pub struct ProtoService {
    pub name: String,
    pub methods: Vec<ServiceMethod>,
    pub comments: Vec<String>,
}

impl ProtoService {
    pub fn new(name: String) -> Self {
        Self {
            name,
            methods: Vec::new(),
            comments: Vec::new(),
        }
    }

    pub fn add_method(&mut self, method: ServiceMethod) {
        self.methods.push(method);
    }

    pub fn add_comment(&mut self, comment: String) {
        self.comments.push(comment);
    }

    pub fn snake_case_name(&self) -> String {
        heck::AsSnakeCase(&self.name).to_string()
    }

    pub fn camel_case_name(&self) -> String {
        heck::AsPascalCase(&self.name).to_string()
    }
}
