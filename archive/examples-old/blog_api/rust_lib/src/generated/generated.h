#ifndef PROTO2FFI_GENERATED_H
#define PROTO2FFI_GENERATED_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Proto message: User */
/* Size: 208 bytes, Alignment: 8 bytes */
/* Internal FFI type - users interact with proto models instead */
#pragma pack(push, 8)
typedef struct UserFFI {
    uint64_t created_at;
    uint32_t id;
    char[64] username;
    char[128] email;
} UserFFI;
#pragma pack(pop)

/* Returns the size of User in bytes */
size_t user_size(void);

/* Returns the alignment of User in bytes */
size_t user_alignment(void);

/* Proto message: Post */
/* Size: 4376 bytes, Alignment: 8 bytes */
/* Internal FFI type - users interact with proto models instead */
#pragma pack(push, 8)
typedef struct PostFFI {
    uint64_t created_at;
    uint32_t id;
    uint32_t author_id;
    uint32_t likes;
    char[256] title;
    char[4096] content;
} PostFFI;
#pragma pack(pop)

/* Returns the size of Post in bytes */
size_t post_size(void);

/* Returns the alignment of Post in bytes */
size_t post_alignment(void);

/* Proto message: Response */
/* Size: 520 bytes, Alignment: 8 bytes */
/* Internal FFI type - users interact with proto models instead */
#pragma pack(push, 8)
typedef struct ResponseFFI {
    uint32_t affected_id;
    uint8_t success;
    char[512] message;
} ResponseFFI;
#pragma pack(pop)

/* Returns the size of Response in bytes */
size_t response_size(void);

/* Returns the alignment of Response in bytes */
size_t response_alignment(void);

#ifdef __cplusplus
}
#endif

#endif /* PROTO2FFI_GENERATED_H */
