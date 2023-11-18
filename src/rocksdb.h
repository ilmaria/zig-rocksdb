#include "rocksdb/c.h"

#ifdef __cplusplus
extern "C" {
#endif

rocksdb_comparator_t* rocksdb_bytewise_comparator(void);
rocksdb_comparator_t* rocksdb_reverse_bytewise_comparator(void);
rocksdb_comparator_t* rocksdb_bytewise_comparator_with_u64_ts(void);
rocksdb_comparator_t* rocksdb_reverse_bytewise_comparator_with_u64_ts(void);

#ifdef __cplusplus
}
#endif