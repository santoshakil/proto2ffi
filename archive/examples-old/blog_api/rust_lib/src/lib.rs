// Blog API FFI Library
// This demonstrates using proto2ffi generated code for real FFI communication

mod generated;

use generated::*;
use generated::ffi::*;
use std::collections::HashMap;
use std::sync::Mutex;

// Simulated in-memory database
static DB: Mutex<Option<Database>> = Mutex::new(None);

struct Database {
    users: HashMap<u32, User>,
    posts: HashMap<u32, Post>,
    next_user_id: u32,
    next_post_id: u32,
}

impl Database {
    fn new() -> Self {
        Self {
            users: HashMap::new(),
            posts: HashMap::new(),
            next_user_id: 1,
            next_post_id: 1,
        }
    }
}

// Initialize the database
#[no_mangle]
pub extern "C" fn blog_init() {
    let mut db = DB.lock().unwrap();
    *db = Some(Database::new());
    println!("[Rust] Blog API initialized");
}

// Create a new user
// Takes User proto model via FFI pointer, returns Response via FFI pointer
#[no_mangle]
pub unsafe extern "C" fn blog_create_user(user_ptr: *const UserFFI) -> *mut ResponseFFI {
    println!("[Rust] blog_create_user called");

    if user_ptr.is_null() {
        return create_error_response("Null user pointer");
    }

    // Convert from FFI to proto model (transparent!)
    let user = User::from_ffi(&*user_ptr);

    let mut db = DB.lock().unwrap();
    let db = db.as_mut().expect("Database not initialized");

    // Assign ID
    let id = db.next_user_id;
    db.next_user_id += 1;

    let mut user = user;
    user.id = id;
    user.created_at = current_timestamp();

    println!("[Rust] Created user: {} (id={})", user.username, user.id);

    // Store in database
    db.users.insert(id, user);

    // Create success response
    let response = Response {
        success: 1,  // true
        message: format!("User created successfully"),
        affected_id: id,
    };

    // Convert proto model to FFI and return pointer
    send_response(&response)
}

// Get a user by ID
#[no_mangle]
pub unsafe extern "C" fn blog_get_user(user_id: u32) -> *mut UserFFI {
    println!("[Rust] blog_get_user called for id={}", user_id);

    let db = DB.lock().unwrap();
    let db = db.as_ref().expect("Database not initialized");

    if let Some(user) = db.users.get(&user_id) {
        println!("[Rust] Found user: {}", user.username);
        send_user(user)
    } else {
        println!("[Rust] User not found");
        std::ptr::null_mut()
    }
}

// Create a new post
#[no_mangle]
pub unsafe extern "C" fn blog_create_post(post_ptr: *const PostFFI) -> *mut ResponseFFI {
    println!("[Rust] blog_create_post called");

    if post_ptr.is_null() {
        return create_error_response("Null post pointer");
    }

    // Convert from FFI to proto model
    let post = Post::from_ffi(&*post_ptr);

    let mut db = DB.lock().unwrap();
    let db = db.as_mut().expect("Database not initialized");

    // Validate author exists
    if !db.users.contains_key(&post.author_id) {
        return create_error_response("Author does not exist");
    }

    // Assign ID
    let id = db.next_post_id;
    db.next_post_id += 1;

    let mut post = post;
    post.id = id;
    post.created_at = current_timestamp();
    post.likes = 0;

    println!("[Rust] Created post: {} (id={})", post.title, post.id);

    // Store in database
    db.posts.insert(id, post);

    // Create success response
    let response = Response {
        success: 1,  // true
        message: format!("Post created successfully"),
        affected_id: id,
    };

    send_response(&response)
}

// Get a post by ID
#[no_mangle]
pub unsafe extern "C" fn blog_get_post(post_id: u32) -> *mut PostFFI {
    println!("[Rust] blog_get_post called for id={}", post_id);

    let db = DB.lock().unwrap();
    let db = db.as_ref().expect("Database not initialized");

    if let Some(post) = db.posts.get(&post_id) {
        println!("[Rust] Found post: {}", post.title);
        send_post(post)
    } else {
        println!("[Rust] Post not found");
        std::ptr::null_mut()
    }
}

// Like a post
#[no_mangle]
pub extern "C" fn blog_like_post(post_id: u32) -> bool {
    println!("[Rust] blog_like_post called for id={}", post_id);

    let mut db = DB.lock().unwrap();
    let db = db.as_mut().expect("Database not initialized");

    if let Some(post) = db.posts.get_mut(&post_id) {
        post.likes += 1;
        println!("[Rust] Post {} now has {} likes", post_id, post.likes);
        true
    } else {
        println!("[Rust] Post not found");
        false
    }
}

// Cleanup - call before exit
#[no_mangle]
pub extern "C" fn blog_cleanup() {
    let mut db = DB.lock().unwrap();
    *db = None;
    println!("[Rust] Blog API cleaned up");
}

// Helper functions

fn create_error_response(message: &str) -> *mut ResponseFFI {
    let response = Response {
        success: 0,  // false
        message: message.to_string(),
        affected_id: 0,
    };
    send_response(&response)
}

fn current_timestamp() -> u64 {
    use std::time::{SystemTime, UNIX_EPOCH};
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_secs()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_create_user() {
        blog_init();

        let user = User {
            id: 0,  // Will be assigned
            username: "testuser".to_string(),
            email: "test@example.com".to_string(),
            created_at: 0,  // Will be assigned
        };

        let user_ffi = user.to_ffi();
        let response_ptr = unsafe { blog_create_user(&user_ffi) };
        assert!(!response_ptr.is_null());

        let response = unsafe { Response::from_ffi(&*response_ptr) };
        assert_eq!(response.success, 1);  // true
        assert_eq!(response.affected_id, 1);

        unsafe { response_free(response_ptr); }
        blog_cleanup();
    }
}
