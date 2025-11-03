#![allow(dead_code)]
#[derive(Debug, Clone, PartialEq)]
pub struct User {
    pub user_id: u64,
    pub date_of_birth: u64,
    pub created_at: u64,
    pub updated_at: u64,
    pub account_balance: f64,
    pub reputation_score: u32,
    pub username: String,
    pub email: String,
    pub first_name: String,
    pub last_name: String,
    pub display_name: String,
    pub bio: String,
    pub avatar_url: String,
    pub is_verified: u8,
    pub is_premium: u8,
}
impl User {
    pub fn new() -> Self {
        Self::default()
    }
}
impl Default for User {
    fn default() -> Self {
        Self {
            user_id: 0,
            date_of_birth: 0,
            created_at: 0,
            updated_at: 0,
            account_balance: 0.0,
            reputation_score: 0,
            username: String::new(),
            email: String::new(),
            first_name: String::new(),
            last_name: String::new(),
            display_name: String::new(),
            bio: String::new(),
            avatar_url: String::new(),
            is_verified: 0,
            is_premium: 0,
        }
    }
}
#[derive(Debug, Clone, PartialEq)]
pub struct Post {
    pub post_id: u64,
    pub user_id: u64,
    pub created_at: u64,
    pub updated_at: u64,
    pub view_count: u64,
    pub like_count: u64,
    pub comment_count: u64,
    pub username: String,
    pub title: String,
    pub content: String,
    pub is_edited: u8,
    pub is_pinned: u8,
}
impl Post {
    pub fn new() -> Self {
        Self::default()
    }
}
impl Default for Post {
    fn default() -> Self {
        Self {
            post_id: 0,
            user_id: 0,
            created_at: 0,
            updated_at: 0,
            view_count: 0,
            like_count: 0,
            comment_count: 0,
            username: String::new(),
            title: String::new(),
            content: String::new(),
            is_edited: 0,
            is_pinned: 0,
        }
    }
}
