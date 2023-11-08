const std = @import("std");
const ArrayList = std.ArrayList;

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "rocksdb",
        .target = target,
        .optimize = optimize,
    });
    lib.addIncludePath(.{ .path = "rocksdb" });
    lib.addIncludePath(.{ .path = "rocksdb/include" });
    lib.linkLibCpp();

    const ubsan_option = b.option(bool, "ROCKSDB_UBSAN_RUN", "Use ubsan") orelse false;

    var cflags = ArrayList([]const u8).init(b.allocator);
    try cflags.append("-DPORTABLE=1");
    // "-DROCKSDB_WINDOWS_UTF8_FILENAMES",
    // "-DCIRCLECI",
    // "-DROCKSDB_JEMALLOC",
    // "-DJEMALLOC_NO_DEMANGLE",
    // "-DGFLAGS",
    // "-DSNAPPY",
    // "-DZLIB",
    // "-DBZIP2",
    // "-DLZ4",
    // "-DZSTD",
    // "-D_POSIX_C_SOURCE",
    // "-DROCKSDB_IOURING_PRESENT",
    // "-DNIOSTATS_CONTEXT",
    // "-DNPERF_CONTEXT",
    // "-DNUMA",
    // "-DTBB",
    // "-DROCKSDB_DISABLE_STALL_NOTIFICATION",
    // "-DROCKSDB_NO_DYNAMIC_EXTENSION",
    // "-DROCKSDB_ASSERT_STATUS_CHECKED",
    // "-DCYGWIN",
    // "-D_MBCS",
    // "-DNOMINMAX",
    // "-DROCKSDB_PLATFORM_POSIX",
    // "-DROCKSDB_LIB_IO_POSIX",
    // "-DROCKSDB_FALLOCATE_PRESENT",
    // "-DROCKSDB_RANGESYNC_PRESENT",
    // "-DROCKSDB_PTHREAD_ADAPTIVE_MUTEX",
    // "-DROCKSDB_MALLOC_USABLE_SIZE",
    // "-DROCKSDB_SCHED_GETCPU_PRESENT",
    // "-DROCKSDB_AUXV_GETAUXVAL_PRESENT",
    // "-DHAVE_FULLFSYNC",
    // "-DUSE_FOLLY",
    // "-DFOLLY_NO_CONFIG",
    if (ubsan_option) {
        std.debug.print("hello\n", .{});
        try cflags.append("-DROCKSDB_UBSAN_RUN=1");
    }

    switch (target.getOsTag()) {
        .windows => try cflags.append("-DOS_WIN"),
        .macos => try cflags.append("-DOS_MACOSX"),
        .linux => try cflags.append("-DOS_LINUX"),
        .solaris => try cflags.append("-DOS_SOLARIS"),
        .kfreebsd => try cflags.append("-DOS_GNU_KFREEBSD"),
        .freebsd => try cflags.append("-DOS_FREEBSD"),
        .netbsd => try cflags.append("-DOS_NETBSD"),
        .dragonfly => try cflags.append("-DOS_DRAGONFLYBSD"),
        .openbsd => try cflags.append("-DOS_OPENBSD"),
        else => blk: {
            if (target.abi == .android) {
                break :blk try cflags.append("-DOS_ANDROID");
            } else {
                return error.UnsupportedOS;
            }
        },
    }

    lib.addCSourceFiles(.{
        .files = &.{
            "rocksdb/cache/cache.cc",
            "rocksdb/cache/cache_entry_roles.cc",
            "rocksdb/cache/cache_key.cc",
            "rocksdb/cache/cache_helpers.cc",
            "rocksdb/cache/cache_reservation_manager.cc",
            "rocksdb/cache/charged_cache.cc",
            "rocksdb/cache/clock_cache.cc",
            "rocksdb/cache/compressed_secondary_cache.cc",
            "rocksdb/cache/lru_cache.cc",
            "rocksdb/cache/secondary_cache.cc",
            "rocksdb/cache/secondary_cache_adapter.cc",
            "rocksdb/cache/sharded_cache.cc",
            "rocksdb/cache/tiered_secondary_cache.cc",
            "rocksdb/db/arena_wrapped_db_iter.cc",
            "rocksdb/db/blob/blob_contents.cc",
            "rocksdb/db/blob/blob_fetcher.cc",
            "rocksdb/db/blob/blob_file_addition.cc",
            "rocksdb/db/blob/blob_file_builder.cc",
            "rocksdb/db/blob/blob_file_cache.cc",
            "rocksdb/db/blob/blob_file_garbage.cc",
            "rocksdb/db/blob/blob_file_meta.cc",
            "rocksdb/db/blob/blob_file_reader.cc",
            "rocksdb/db/blob/blob_garbage_meter.cc",
            "rocksdb/db/blob/blob_log_format.cc",
            "rocksdb/db/blob/blob_log_sequential_reader.cc",
            "rocksdb/db/blob/blob_log_writer.cc",
            "rocksdb/db/blob/blob_source.cc",
            "rocksdb/db/blob/prefetch_buffer_collection.cc",
            "rocksdb/db/builder.cc",
            "rocksdb/db/c.cc",
            "rocksdb/db/column_family.cc",
            "rocksdb/db/compaction/compaction.cc",
            "rocksdb/db/compaction/compaction_iterator.cc",
            "rocksdb/db/compaction/compaction_picker.cc",
            "rocksdb/db/compaction/compaction_job.cc",
            "rocksdb/db/compaction/compaction_picker_fifo.cc",
            "rocksdb/db/compaction/compaction_picker_level.cc",
            "rocksdb/db/compaction/compaction_picker_universal.cc",
            "rocksdb/db/compaction/compaction_service_job.cc",
            "rocksdb/db/compaction/compaction_state.cc",
            "rocksdb/db/compaction/compaction_outputs.cc",
            "rocksdb/db/compaction/sst_partitioner.cc",
            "rocksdb/db/compaction/subcompaction_state.cc",
            "rocksdb/db/convenience.cc",
            "rocksdb/db/db_filesnapshot.cc",
            "rocksdb/db/db_impl/compacted_db_impl.cc",
            "rocksdb/db/db_impl/db_impl.cc",
            "rocksdb/db/db_impl/db_impl_write.cc",
            "rocksdb/db/db_impl/db_impl_compaction_flush.cc",
            "rocksdb/db/db_impl/db_impl_files.cc",
            "rocksdb/db/db_impl/db_impl_open.cc",
            "rocksdb/db/db_impl/db_impl_debug.cc",
            "rocksdb/db/db_impl/db_impl_experimental.cc",
            "rocksdb/db/db_impl/db_impl_readonly.cc",
            "rocksdb/db/db_impl/db_impl_secondary.cc",
            "rocksdb/db/db_info_dumper.cc",
            "rocksdb/db/db_iter.cc",
            "rocksdb/db/dbformat.cc",
            "rocksdb/db/error_handler.cc",
            "rocksdb/db/event_helpers.cc",
            "rocksdb/db/experimental.cc",
            "rocksdb/db/external_sst_file_ingestion_job.cc",
            "rocksdb/db/file_indexer.cc",
            "rocksdb/db/flush_job.cc",
            "rocksdb/db/flush_scheduler.cc",
            "rocksdb/db/forward_iterator.cc",
            "rocksdb/db/import_column_family_job.cc",
            "rocksdb/db/internal_stats.cc",
            "rocksdb/db/logs_with_prep_tracker.cc",
            "rocksdb/db/log_reader.cc",
            "rocksdb/db/log_writer.cc",
            "rocksdb/db/malloc_stats.cc",
            "rocksdb/db/memtable.cc",
            "rocksdb/db/memtable_list.cc",
            "rocksdb/db/merge_helper.cc",
            "rocksdb/db/merge_operator.cc",
            "rocksdb/db/output_validator.cc",
            "rocksdb/db/periodic_task_scheduler.cc",
            "rocksdb/db/range_del_aggregator.cc",
            "rocksdb/db/range_tombstone_fragmenter.cc",
            "rocksdb/db/repair.cc",
            "rocksdb/db/seqno_to_time_mapping.cc",
            "rocksdb/db/snapshot_impl.cc",
            "rocksdb/db/table_cache.cc",
            "rocksdb/db/table_properties_collector.cc",
            "rocksdb/db/transaction_log_impl.cc",
            "rocksdb/db/trim_history_scheduler.cc",
            "rocksdb/db/version_builder.cc",
            "rocksdb/db/version_edit.cc",
            "rocksdb/db/version_edit_handler.cc",
            "rocksdb/db/version_set.cc",
            "rocksdb/db/wal_edit.cc",
            "rocksdb/db/wal_manager.cc",
            "rocksdb/db/wide/wide_column_serialization.cc",
            "rocksdb/db/wide/wide_columns.cc",
            "rocksdb/db/wide/wide_columns_helper.cc",
            "rocksdb/db/write_batch.cc",
            "rocksdb/db/write_batch_base.cc",
            "rocksdb/db/write_controller.cc",
            "rocksdb/db/write_stall_stats.cc",
            "rocksdb/db/write_thread.cc",
            "rocksdb/env/composite_env.cc",
            "rocksdb/env/env.cc",
            "rocksdb/env/env_chroot.cc",
            "rocksdb/env/env_encryption.cc",
            "rocksdb/env/file_system.cc",
            "rocksdb/env/file_system_tracer.cc",
            "rocksdb/env/fs_remap.cc",
            "rocksdb/env/mock_env.cc",
            "rocksdb/env/unique_id_gen.cc",
            "rocksdb/file/delete_scheduler.cc",
            "rocksdb/file/file_prefetch_buffer.cc",
            "rocksdb/file/file_util.cc",
            "rocksdb/file/filename.cc",
            "rocksdb/file/line_file_reader.cc",
            "rocksdb/file/random_access_file_reader.cc",
            "rocksdb/file/read_write_util.cc",
            "rocksdb/file/readahead_raf.cc",
            "rocksdb/file/sequence_file_reader.cc",
            "rocksdb/file/sst_file_manager_impl.cc",
            "rocksdb/file/writable_file_writer.cc",
            "rocksdb/logging/auto_roll_logger.cc",
            "rocksdb/logging/event_logger.cc",
            "rocksdb/logging/log_buffer.cc",
            "rocksdb/memory/arena.cc",
            "rocksdb/memory/concurrent_arena.cc",
            "rocksdb/memory/jemalloc_nodump_allocator.cc",
            "rocksdb/memory/memkind_kmem_allocator.cc",
            "rocksdb/memory/memory_allocator.cc",
            "rocksdb/memtable/alloc_tracker.cc",
            "rocksdb/memtable/hash_linklist_rep.cc",
            "rocksdb/memtable/hash_skiplist_rep.cc",
            "rocksdb/memtable/skiplistrep.cc",
            "rocksdb/memtable/vectorrep.cc",
            "rocksdb/memtable/write_buffer_manager.cc",
            "rocksdb/monitoring/histogram.cc",
            "rocksdb/monitoring/histogram_windowing.cc",
            "rocksdb/monitoring/in_memory_stats_history.cc",
            "rocksdb/monitoring/instrumented_mutex.cc",
            "rocksdb/monitoring/iostats_context.cc",
            "rocksdb/monitoring/perf_context.cc",
            "rocksdb/monitoring/perf_level.cc",
            "rocksdb/monitoring/persistent_stats_history.cc",
            "rocksdb/monitoring/statistics.cc",
            "rocksdb/monitoring/thread_status_impl.cc",
            "rocksdb/monitoring/thread_status_updater.cc",
            "rocksdb/monitoring/thread_status_util.cc",
            "rocksdb/monitoring/thread_status_util_debug.cc",
            "rocksdb/options/cf_options.cc",
            "rocksdb/options/configurable.cc",
            "rocksdb/options/customizable.cc",
            "rocksdb/options/db_options.cc",
            "rocksdb/options/offpeak_time_info.cc",
            "rocksdb/options/options.cc",
            "rocksdb/options/options_helper.cc",
            "rocksdb/options/options_parser.cc",
            "rocksdb/port/mmap.cc",
            "rocksdb/port/stack_trace.cc",
            "rocksdb/table/adaptive/adaptive_table_factory.cc",
            "rocksdb/table/block_based/binary_search_index_reader.cc",
            "rocksdb/table/block_based/block.cc",
            "rocksdb/table/block_based/block_based_table_builder.cc",
            "rocksdb/table/block_based/block_based_table_factory.cc",
            "rocksdb/table/block_based/block_based_table_iterator.cc",
            "rocksdb/table/block_based/block_based_table_reader.cc",
            "rocksdb/table/block_based/block_builder.cc",
            "rocksdb/table/block_based/block_cache.cc",
            "rocksdb/table/block_based/block_prefetcher.cc",
            "rocksdb/table/block_based/block_prefix_index.cc",
            "rocksdb/table/block_based/data_block_hash_index.cc",
            "rocksdb/table/block_based/data_block_footer.cc",
            "rocksdb/table/block_based/filter_block_reader_common.cc",
            "rocksdb/table/block_based/filter_policy.cc",
            "rocksdb/table/block_based/flush_block_policy.cc",
            "rocksdb/table/block_based/full_filter_block.cc",
            "rocksdb/table/block_based/hash_index_reader.cc",
            "rocksdb/table/block_based/index_builder.cc",
            "rocksdb/table/block_based/index_reader_common.cc",
            "rocksdb/table/block_based/parsed_full_filter_block.cc",
            "rocksdb/table/block_based/partitioned_filter_block.cc",
            "rocksdb/table/block_based/partitioned_index_iterator.cc",
            "rocksdb/table/block_based/partitioned_index_reader.cc",
            "rocksdb/table/block_based/reader_common.cc",
            "rocksdb/table/block_based/uncompression_dict_reader.cc",
            "rocksdb/table/block_fetcher.cc",
            "rocksdb/table/cuckoo/cuckoo_table_builder.cc",
            "rocksdb/table/cuckoo/cuckoo_table_factory.cc",
            "rocksdb/table/cuckoo/cuckoo_table_reader.cc",
            "rocksdb/table/format.cc",
            "rocksdb/table/get_context.cc",
            "rocksdb/table/iterator.cc",
            "rocksdb/table/merging_iterator.cc",
            "rocksdb/table/compaction_merging_iterator.cc",
            "rocksdb/table/meta_blocks.cc",
            "rocksdb/table/persistent_cache_helper.cc",
            "rocksdb/table/plain/plain_table_bloom.cc",
            "rocksdb/table/plain/plain_table_builder.cc",
            "rocksdb/table/plain/plain_table_factory.cc",
            "rocksdb/table/plain/plain_table_index.cc",
            "rocksdb/table/plain/plain_table_key_coding.cc",
            "rocksdb/table/plain/plain_table_reader.cc",
            "rocksdb/table/sst_file_dumper.cc",
            "rocksdb/table/sst_file_reader.cc",
            "rocksdb/table/sst_file_writer.cc",
            "rocksdb/table/table_factory.cc",
            "rocksdb/table/table_properties.cc",
            "rocksdb/table/two_level_iterator.cc",
            "rocksdb/table/unique_id.cc",
            "rocksdb/test_util/sync_point.cc",
            "rocksdb/test_util/sync_point_impl.cc",
            "rocksdb/test_util/testutil.cc",
            "rocksdb/test_util/transaction_test_util.cc",
            "rocksdb/tools/block_cache_analyzer/block_cache_trace_analyzer.cc",
            "rocksdb/tools/dump/db_dump_tool.cc",
            "rocksdb/tools/io_tracer_parser_tool.cc",
            "rocksdb/tools/ldb_cmd.cc",
            "rocksdb/tools/ldb_tool.cc",
            "rocksdb/tools/sst_dump_tool.cc",
            "rocksdb/tools/trace_analyzer_tool.cc",
            "rocksdb/trace_replay/block_cache_tracer.cc",
            "rocksdb/trace_replay/io_tracer.cc",
            "rocksdb/trace_replay/trace_record_handler.cc",
            "rocksdb/trace_replay/trace_record_result.cc",
            "rocksdb/trace_replay/trace_record.cc",
            "rocksdb/trace_replay/trace_replay.cc",
            "rocksdb/util/async_file_reader.cc",
            "rocksdb/util/build_version.cc",
            "rocksdb/util/cleanable.cc",
            "rocksdb/util/coding.cc",
            "rocksdb/util/compaction_job_stats_impl.cc",
            "rocksdb/util/comparator.cc",
            "rocksdb/util/compression.cc",
            "rocksdb/util/compression_context_cache.cc",
            "rocksdb/util/concurrent_task_limiter_impl.cc",
            "rocksdb/util/crc32c.cc",
            "rocksdb/util/data_structure.cc",
            "rocksdb/util/dynamic_bloom.cc",
            "rocksdb/util/hash.cc",
            "rocksdb/util/murmurhash.cc",
            "rocksdb/util/random.cc",
            "rocksdb/util/rate_limiter.cc",
            "rocksdb/util/ribbon_config.cc",
            "rocksdb/util/slice.cc",
            "rocksdb/util/file_checksum_helper.cc",
            "rocksdb/util/status.cc",
            "rocksdb/util/stderr_logger.cc",
            "rocksdb/util/string_util.cc",
            "rocksdb/util/thread_local.cc",
            "rocksdb/util/threadpool_imp.cc",
            "rocksdb/util/udt_util.cc",
            "rocksdb/util/write_batch_util.cc",
            "rocksdb/util/xxhash.cc",
            "rocksdb/utilities/agg_merge/agg_merge.cc",
            "rocksdb/utilities/backup/backup_engine.cc",
            "rocksdb/utilities/blob_db/blob_compaction_filter.cc",
            "rocksdb/utilities/blob_db/blob_db.cc",
            "rocksdb/utilities/blob_db/blob_db_impl.cc",
            "rocksdb/utilities/blob_db/blob_db_impl_filesnapshot.cc",
            "rocksdb/utilities/blob_db/blob_dump_tool.cc",
            "rocksdb/utilities/blob_db/blob_file.cc",
            "rocksdb/utilities/cache_dump_load.cc",
            "rocksdb/utilities/cache_dump_load_impl.cc",
            "rocksdb/utilities/cassandra/cassandra_compaction_filter.cc",
            "rocksdb/utilities/cassandra/format.cc",
            "rocksdb/utilities/cassandra/merge_operator.cc",
            "rocksdb/utilities/checkpoint/checkpoint_impl.cc",
            "rocksdb/utilities/compaction_filters.cc",
            "rocksdb/utilities/compaction_filters/remove_emptyvalue_compactionfilter.cc",
            "rocksdb/utilities/counted_fs.cc",
            "rocksdb/utilities/debug.cc",
            "rocksdb/utilities/env_mirror.cc",
            "rocksdb/utilities/env_timed.cc",
            "rocksdb/utilities/fault_injection_env.cc",
            "rocksdb/utilities/fault_injection_fs.cc",
            "rocksdb/utilities/fault_injection_secondary_cache.cc",
            "rocksdb/utilities/leveldb_options/leveldb_options.cc",
            "rocksdb/utilities/memory/memory_util.cc",
            "rocksdb/utilities/merge_operators.cc",
            "rocksdb/utilities/merge_operators/bytesxor.cc",
            "rocksdb/utilities/merge_operators/max.cc",
            "rocksdb/utilities/merge_operators/put.cc",
            "rocksdb/utilities/merge_operators/sortlist.cc",
            "rocksdb/utilities/merge_operators/string_append/stringappend.cc",
            "rocksdb/utilities/merge_operators/string_append/stringappend2.cc",
            "rocksdb/utilities/merge_operators/uint64add.cc",
            "rocksdb/utilities/object_registry.cc",
            "rocksdb/utilities/option_change_migration/option_change_migration.cc",
            "rocksdb/utilities/options/options_util.cc",
            "rocksdb/utilities/persistent_cache/block_cache_tier.cc",
            "rocksdb/utilities/persistent_cache/block_cache_tier_file.cc",
            "rocksdb/utilities/persistent_cache/block_cache_tier_metadata.cc",
            "rocksdb/utilities/persistent_cache/persistent_cache_tier.cc",
            "rocksdb/utilities/persistent_cache/volatile_tier_impl.cc",
            "rocksdb/utilities/simulator_cache/cache_simulator.cc",
            "rocksdb/utilities/simulator_cache/sim_cache.cc",
            "rocksdb/utilities/table_properties_collectors/compact_on_deletion_collector.cc",
            "rocksdb/utilities/trace/file_trace_reader_writer.cc",
            "rocksdb/utilities/trace/replayer_impl.cc",
            "rocksdb/utilities/transactions/lock/lock_manager.cc",
            "rocksdb/utilities/transactions/lock/point/point_lock_tracker.cc",
            "rocksdb/utilities/transactions/lock/point/point_lock_manager.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/range_tree_lock_manager.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/range_tree_lock_tracker.cc",
            "rocksdb/utilities/transactions/optimistic_transaction_db_impl.cc",
            "rocksdb/utilities/transactions/optimistic_transaction.cc",
            "rocksdb/utilities/transactions/pessimistic_transaction.cc",
            "rocksdb/utilities/transactions/pessimistic_transaction_db.cc",
            "rocksdb/utilities/transactions/snapshot_checker.cc",
            "rocksdb/utilities/transactions/transaction_base.cc",
            "rocksdb/utilities/transactions/transaction_db_mutex_impl.cc",
            "rocksdb/utilities/transactions/transaction_util.cc",
            "rocksdb/utilities/transactions/write_prepared_txn.cc",
            "rocksdb/utilities/transactions/write_prepared_txn_db.cc",
            "rocksdb/utilities/transactions/write_unprepared_txn.cc",
            "rocksdb/utilities/transactions/write_unprepared_txn_db.cc",
            "rocksdb/utilities/ttl/db_ttl_impl.cc",
            "rocksdb/utilities/wal_filter.cc",
            "rocksdb/utilities/write_batch_with_index/write_batch_with_index.cc",
            "rocksdb/utilities/write_batch_with_index/write_batch_with_index_internal.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/locktree/concurrent_tree.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/locktree/keyrange.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/locktree/lock_request.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/locktree/locktree.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/locktree/manager.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/locktree/range_buffer.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/locktree/treenode.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/locktree/txnid_set.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/locktree/wfg.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/standalone_port.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/util/dbt.cc",
            "rocksdb/utilities/transactions/lock/range/range_tree/lib/util/memarena.cc",
        },
        .flags = cflags.items,
    });

    switch (target.getCpuArch()) {
        .powerpc64, .powerpc64le => {
            lib.addCSourceFiles(.{
                .files = &.{"rocksdb/util/crc32c_ppc.c"},
                .flags = cflags.items,
            });
            lib.addAssemblyFile(.{ .path = "rocksdb/util/crc32c_ppc_asm.S" });
        },
        .aarch64, .aarch64_be, .aarch64_32 => {
            lib.addCSourceFiles(.{
                .files = &.{"rocksdb/util/crc32c_arm64.cc"},
                .flags = cflags.items,
            });
        },
        else => {},
    }
    switch (target.getOsTag()) {
        .windows => {
            lib.addCSourceFiles(.{
                .files = &.{
                    "rocksdb/port/win/io_win.cc",
                    "rocksdb/port/win/env_win.cc",
                    "rocksdb/port/win/env_default.cc",
                    "rocksdb/port/win/port_win.cc",
                    "rocksdb/port/win/win_logger.cc",
                    "rocksdb/port/win/win_thread.cc",
                },
                .flags = cflags.items,
            });
            lib.linkSystemLibrary("shlwapi");
            lib.linkSystemLibrary("rpcrt4");
        },
        else => {},
    }
    const have_jemalloc = b.option(bool, "JEMALLOC", "Use Jemalloc");
    if (have_jemalloc orelse false) {
        lib.addCSourceFiles(.{
            .files = &.{
                "rocksdb/port/port_posix.cc",
                "rocksdb/env/env_posix.cc",
                "rocksdb/env/fs_posix.cc",
                "rocksdb/env/io_posix.cc",
            },
            .flags = cflags.items,
        });
    }

    b.installArtifact(lib);

    const run_example = b.step("run-simple-example", "Run simple example program");
    const simple_example = b.addExecutable(.{
        .name = "rocksdb_simple_example",
        .root_source_file = .{ .path = "examples/simple_example.zig" },
        .target = target,
        .optimize = optimize,
    });
    simple_example.linkLibrary(lib);
    simple_example.addIncludePath(.{ .path = "rocksdb/include" });
    run_example.dependOn(&b.addRunArtifact(simple_example).step);
    run_example.dependOn(&b.addInstallArtifact(simple_example, .{}).step);
}
