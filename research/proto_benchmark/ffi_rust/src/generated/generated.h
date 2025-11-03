#ifndef PROTO2FFI_GENERATED_H
#define PROTO2FFI_GENERATED_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Proto message: User */
/* Size: 1200 bytes, Alignment: 8 bytes */
/* Internal FFI type - users interact with proto models instead */
#pragma pack(push, 8)
typedef struct UserFFI {
    uint64_t user_id;
    uint64_t date_of_birth;
    uint64_t created_at;
    uint64_t updated_at;
    double account_balance;
    uint32_t reputation_score;
    char[64] username;
    char[128] email;
    char[64] first_name;
    char[64] last_name;
    char[64] display_name;
    char[512] bio;
    char[256] avatar_url;
    uint8_t is_verified;
    uint8_t is_premium;
} UserFFI;
#pragma pack(pop)

/* Returns the size of User in bytes */
size_t user_size(void);

/* Returns the alignment of User in bytes */
size_t user_alignment(void);

/* Proto message: Post */
/* Size: 4480 bytes, Alignment: 8 bytes */
/* Internal FFI type - users interact with proto models instead */
#pragma pack(push, 8)
typedef struct PostFFI {
    uint64_t post_id;
    uint64_t user_id;
    uint64_t created_at;
    uint64_t updated_at;
    uint64_t view_count;
    uint64_t like_count;
    uint64_t comment_count;
    char[64] username;
    char[256] title;
    char[4096] content;
    uint8_t is_edited;
    uint8_t is_pinned;
} PostFFI;
#pragma pack(pop)

/* Returns the size of Post in bytes */
size_t post_size(void);

/* Returns the alignment of Post in bytes */
size_t post_alignment(void);

#ifdef __cplusplus
}
#endif

#endif /* PROTO2FFI_GENERATED_H */
