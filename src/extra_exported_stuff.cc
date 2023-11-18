#include "./rocksdb.h"
#include "rocksdb/db.h"

#ifdef __cplusplus
extern "C" {
#endif

rocksdb_comparator_t* rocksdb_bytewise_comparator() {
    return (rocksdb_comparator_t*)ROCKSDB_NAMESPACE::BytewiseComparator();
}

rocksdb_comparator_t* rocksdb_reverse_bytewise_comparator() {
    return (rocksdb_comparator_t*)ROCKSDB_NAMESPACE::ReverseBytewiseComparator();
}

rocksdb_comparator_t* rocksdb_bytewise_comparator_with_u64_ts() {
    return (rocksdb_comparator_t*)ROCKSDB_NAMESPACE::BytewiseComparatorWithU64Ts();
}

rocksdb_comparator_t* rocksdb_reverse_bytewise_comparator_with_u64_ts() {
    return (rocksdb_comparator_t*)ROCKSDB_NAMESPACE::ReverseBytewiseComparatorWithU64Ts();
}

#ifdef __cplusplus
}
#endif
