mod proto {
    include!("proto/hello.rs");
}

pub use proto::{HelloRequest, HelloResponse};

mod generated;

use generated::*;

struct GreeterService;

impl Greeter for GreeterService {
    fn say_hello(
        &self,
        request: HelloRequest,
    ) -> Result<HelloResponse, Box<dyn std::error::Error>> {
        let message = format!("Hello, {}!", request.name);
        Ok(HelloResponse { message })
    }
}

#[no_mangle]
pub extern "C" fn init_service() {
    unsafe {
        init_greeter(Box::new(GreeterService));
    }
}
