#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

/**
 * No error.
 */
#define ERR_OK 0

/**
 * Config path error.
 */
#define ERR_CONFIG_PATH 1

/**
 * Config parsing error.
 */
#define ERR_CONFIG 2

/**
 * IO error.
 */
#define ERR_IO 3

/**
 * Config file watcher error.
 */
#define ERR_WATCHER 4

/**
 * Async channel send error.
 */
#define ERR_ASYNC_CHANNEL_SEND 5

/**
 * Sync channel receive error.
 */
#define ERR_SYNC_CHANNEL_RECV 6

/**
 * Runtime manager error.
 */
#define ERR_RUNTIME_MANAGER 7

/**
 * No associated config file.
 */
#define ERR_NO_CONFIG_FILE 8

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

void wire_leaf_run(int64_t port_,
                   struct wire_uint_8_list *config_path,
                   struct wire_uint_8_list *wintun_path,
                   struct wire_uint_8_list *tun2socks_path);

void wire_is_running(int64_t port_);

void wire_leaf_shutdown(int64_t port_);

void wire_ping(int64_t port_, struct wire_uint_8_list *host, int64_t port);

struct wire_uint_8_list *new_uint_8_list(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_leaf_run);
    dummy_var ^= ((int64_t) (void*) wire_is_running);
    dummy_var ^= ((int64_t) (void*) wire_leaf_shutdown);
    dummy_var ^= ((int64_t) (void*) wire_ping);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}