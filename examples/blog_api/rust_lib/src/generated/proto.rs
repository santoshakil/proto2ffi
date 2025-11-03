#![allow(dead_code)]
#[derive(Debug, Clone, PartialEq)]
pub struct User {
    pub created_at: u64,
    pub id: u32,
    pub username: String,
    pub email: String,
}
impl User {
    pub fn new() -> Self {
        Self::default()
    }
}
impl Default for User {
    fn default() -> Self {
        Self {
            created_at: 0,
            id: 0,
            username: String::new(),
            email: String::new(),
        }
    }
}
#[derive(Debug, Clone, PartialEq)]
pub struct Post {
    pub created_at: u64,
    pub id: u32,
    pub author_id: u32,
    pub likes: u32,
    pub title: String,
    pub content: String,
}
impl Post {
    pub fn new() -> Self {
        Self::default()
    }
}
impl Default for Post {
    fn default() -> Self {
        Self {
            created_at: 0,
            id: 0,
            author_id: 0,
            likes: 0,
            title: String::new(),
            content: String::new(),
        }
    }
}
#[derive(Debug, Clone, PartialEq)]
pub struct Response {
    pub affected_id: u32,
    pub success: u8,
    pub message: String,
}
impl Response {
    pub fn new() -> Self {
        Self::default()
    }
}
impl Default for Response {
    fn default() -> Self {
        Self {
            affected_id: 0,
            success: 0,
            message: String::new(),
        }
    }
}
