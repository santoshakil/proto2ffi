use heck::{AsSnakeCase, AsPascalCase};

#[derive(Debug, Clone)]
pub struct ServiceMethod {
    pub name: String,
    pub input_type: String,
    pub output_type: String,
    pub client_streaming: bool,
    pub server_streaming: bool,
    pub comments: Vec<String>,
}

impl ServiceMethod {
    pub fn new(name: String, input_type: String, output_type: String) -> Self {
        Self {
            name,
            input_type,
            output_type,
            client_streaming: false,
            server_streaming: false,
            comments: Vec::new(),
        }
    }

    pub fn with_streaming(mut self, client: bool, server: bool) -> Self {
        self.client_streaming = client;
        self.server_streaming = server;
        self
    }

    pub fn add_comment(&mut self, comment: String) {
        self.comments.push(comment);
    }

    pub fn snake_case_name(&self) -> String {
        AsSnakeCase(&self.name).to_string()
    }

    pub fn camel_case_name(&self) -> String {
        AsPascalCase(&self.name).to_string()
    }

    pub fn is_unary(&self) -> bool {
        !self.client_streaming && !self.server_streaming
    }

    pub fn ffi_function_name(&self) -> String {
        format!("proto2ffi_{}", self.snake_case_name())
    }
}
