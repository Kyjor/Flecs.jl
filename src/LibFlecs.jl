module LibFlecs

using flecs_jll
export flecs_jll

using CEnum

const intptr_t = Clong

const ecs_id_t = UInt64

const ecs_entity_t = ecs_id_t

const ecs_size_t = Int32

mutable struct ecs_world_t end

function ecs_get_alive(world, e)
    ccall((:ecs_get_alive, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t), world, e)
end

const ecs_poly_t = Cvoid

struct EcsPoly
    poly::Ptr{ecs_poly_t}
end

mutable struct ecs_table_t end

function ecs_table_lock(world, table)
    ccall((:ecs_table_lock, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_table_t}), world, table)
end

function ecs_table_unlock(world, table)
    ccall((:ecs_table_unlock, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_table_t}), world, table)
end

# typedef void ( * ecs_xtor_t ) ( void * ptr , int32_t count , const ecs_type_info_t * type_info )
const ecs_xtor_t = Ptr{Cvoid}

# typedef void ( * ecs_copy_t ) ( void * dst_ptr , const void * src_ptr , int32_t count , const ecs_type_info_t * type_info )
const ecs_copy_t = Ptr{Cvoid}

# typedef void ( * ecs_move_t ) ( void * dst_ptr , void * src_ptr , int32_t count , const ecs_type_info_t * type_info )
const ecs_move_t = Ptr{Cvoid}

# typedef void ( * ecs_iter_action_t ) ( ecs_iter_t * it )
const ecs_iter_action_t = Ptr{Cvoid}

# typedef void ( * ecs_ctx_free_t ) ( void * ctx )
const ecs_ctx_free_t = Ptr{Cvoid}

struct ecs_type_hooks_t
    ctor::ecs_xtor_t
    dtor::ecs_xtor_t
    copy::ecs_copy_t
    move::ecs_move_t
    copy_ctor::ecs_copy_t
    move_ctor::ecs_move_t
    ctor_move_dtor::ecs_move_t
    move_dtor::ecs_move_t
    on_add::ecs_iter_action_t
    on_set::ecs_iter_action_t
    on_remove::ecs_iter_action_t
    ctx::Ptr{Cvoid}
    binding_ctx::Ptr{Cvoid}
    lifecycle_ctx::Ptr{Cvoid}
    ctx_free::ecs_ctx_free_t
    binding_ctx_free::ecs_ctx_free_t
    lifecycle_ctx_free::ecs_ctx_free_t
end

struct ecs_type_info_t
    size::ecs_size_t
    alignment::ecs_size_t
    hooks::ecs_type_hooks_t
    component::ecs_entity_t
    name::Ptr{Cchar}
end

struct ecs_table_range_t
    table::Ptr{ecs_table_t}
    offset::Int32
    count::Int32
end

struct ecs_var_t
    range::ecs_table_range_t
    entity::ecs_entity_t
end

mutable struct ecs_table_cache_t end

struct ecs_table_cache_hdr_t
    cache::Ptr{ecs_table_cache_t}
    table::Ptr{ecs_table_t}
    prev::Ptr{ecs_table_cache_hdr_t}
    next::Ptr{ecs_table_cache_hdr_t}
    empty::Bool
end

struct ecs_table_record_t
    hdr::ecs_table_cache_hdr_t
    index::Int16
    count::Int16
    column::Int16
end

const ecs_flags64_t = UInt64

const ecs_flags32_t = UInt32

mutable struct ecs_mixins_t end

struct ecs_header_t
    magic::Int32
    type::Int32
    refcount::Int32
    mixins::Ptr{ecs_mixins_t}
end

struct ecs_term_ref_t
    id::ecs_entity_t
    name::Ptr{Cchar}
end

const ecs_flags16_t = UInt16

struct ecs_term_t
    id::ecs_id_t
    src::ecs_term_ref_t
    first::ecs_term_ref_t
    second::ecs_term_ref_t
    trav::ecs_entity_t
    inout::Int16
    oper::Int16
    field_index::Int8
    flags_::ecs_flags16_t
end

@cenum ecs_query_cache_kind_t::UInt32 begin
    EcsQueryCacheDefault = 0
    EcsQueryCacheAuto = 1
    EcsQueryCacheAll = 2
    EcsQueryCacheNone = 3
end

struct ecs_query_t
    hdr::ecs_header_t
    terms::NTuple{32, ecs_term_t}
    sizes::NTuple{32, Int32}
    ids::NTuple{32, ecs_id_t}
    flags::ecs_flags32_t
    var_count::Int8
    term_count::Int8
    field_count::Int8
    fixed_fields::ecs_flags32_t
    var_fields::ecs_flags32_t
    static_id_fields::ecs_flags32_t
    data_fields::ecs_flags32_t
    write_fields::ecs_flags32_t
    read_fields::ecs_flags32_t
    row_fields::ecs_flags32_t
    shared_readonly_fields::ecs_flags32_t
    set_fields::ecs_flags32_t
    cache_kind::ecs_query_cache_kind_t
    vars::Ptr{Ptr{Cchar}}
    ctx::Ptr{Cvoid}
    binding_ctx::Ptr{Cvoid}
    entity::ecs_entity_t
    real_world::Ptr{ecs_world_t}
    world::Ptr{ecs_world_t}
    eval_count::Int32
end

struct var"union (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/api_types.h:150:5)"
    data::NTuple{96, UInt8}
end

function Base.getproperty(x::Ptr{var"union (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/api_types.h:150:5)"}, f::Symbol)
    f === :query && return Ptr{ecs_query_iter_t}(x + 0)
    f === :page && return Ptr{ecs_page_iter_t}(x + 0)
    f === :worker && return Ptr{ecs_worker_iter_t}(x + 0)
    f === :each && return Ptr{ecs_each_iter_t}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::var"union (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/api_types.h:150:5)", f::Symbol)
    r = Ref{var"union (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/api_types.h:150:5)"}(x)
    ptr = Base.unsafe_convert(Ptr{var"union (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/api_types.h:150:5)"}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{var"union (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/api_types.h:150:5)"}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct ecs_stack_page_t
    data::Ptr{Cvoid}
    next::Ptr{ecs_stack_page_t}
    sp::Int16
    id::UInt32
end

struct ecs_stack_t
    first::ecs_stack_page_t
    tail_page::Ptr{ecs_stack_page_t}
    tail_cursor::Ptr{Cvoid} # tail_cursor::Ptr{ecs_stack_cursor_t}
    cursor_count::Int32
end

function Base.getproperty(x::ecs_stack_t, f::Symbol)
    f === :tail_cursor && return Ptr{ecs_stack_cursor_t}(getfield(x, f))
    return getfield(x, f)
end

struct ecs_stack_cursor_t
    prev::Ptr{ecs_stack_cursor_t}
    page::Ptr{ecs_stack_page_t}
    sp::Int16
    is_free::Bool
    owner::Ptr{ecs_stack_t}
end

const ecs_flags8_t = UInt8

struct ecs_iter_cache_t
    stack_cursor::Ptr{ecs_stack_cursor_t}
    used::ecs_flags8_t
    allocated::ecs_flags8_t
end

struct ecs_iter_private_t
    data::NTuple{120, UInt8}
end

function Base.getproperty(x::Ptr{ecs_iter_private_t}, f::Symbol)
    f === :iter && return Ptr{var"union (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/api_types.h:150:5)"}(x + 0)
    f === :entity_iter && return Ptr{Ptr{Cvoid}}(x + 96)
    f === :cache && return Ptr{ecs_iter_cache_t}(x + 104)
    return getfield(x, f)
end

function Base.getproperty(x::ecs_iter_private_t, f::Symbol)
    r = Ref{ecs_iter_private_t}(x)
    ptr = Base.unsafe_convert(Ptr{ecs_iter_private_t}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{ecs_iter_private_t}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

# typedef bool ( * ecs_iter_next_action_t ) ( ecs_iter_t * it )
const ecs_iter_next_action_t = Ptr{Cvoid}

# typedef void ( * ecs_iter_fini_action_t ) ( ecs_iter_t * it )
const ecs_iter_fini_action_t = Ptr{Cvoid}

struct ecs_iter_t
    world::Ptr{ecs_world_t}
    real_world::Ptr{ecs_world_t}
    entities::Ptr{ecs_entity_t}
    sizes::Ptr{ecs_size_t}
    table::Ptr{ecs_table_t}
    other_table::Ptr{ecs_table_t}
    ids::Ptr{ecs_id_t}
    variables::Ptr{ecs_var_t}
    trs::Ptr{Ptr{ecs_table_record_t}}
    sources::Ptr{ecs_entity_t}
    constrained_vars::ecs_flags64_t
    group_id::UInt64
    set_fields::ecs_flags32_t
    ref_fields::ecs_flags32_t
    row_fields::ecs_flags32_t
    up_fields::ecs_flags32_t
    system::ecs_entity_t
    event::ecs_entity_t
    event_id::ecs_id_t
    event_cur::Int32
    field_count::Int8
    term_index::Int8
    variable_count::Int8
    query::Ptr{ecs_query_t}
    variable_names::Ptr{Ptr{Cchar}}
    param::Ptr{Cvoid}
    ctx::Ptr{Cvoid}
    binding_ctx::Ptr{Cvoid}
    callback_ctx::Ptr{Cvoid}
    run_ctx::Ptr{Cvoid}
    delta_time::Cfloat
    delta_system_time::Cfloat
    frame_offset::Int32
    offset::Int32
    count::Int32
    flags::ecs_flags32_t
    interrupted_by::ecs_entity_t
    priv_::ecs_iter_private_t
    next::ecs_iter_next_action_t
    callback::ecs_iter_action_t
    fini::ecs_iter_fini_action_t
    chain_it::Ptr{ecs_iter_t}
end

function ecs_field_w_size(it, size, index)
    ccall((:ecs_field_w_size, libflecs), Ptr{Cvoid}, (Ptr{ecs_iter_t}, Csize_t, Int8), it, size, index)
end

struct ecs_block_allocator_chunk_header_t
    next::Ptr{ecs_block_allocator_chunk_header_t}
end

struct ecs_block_allocator_block_t
    memory::Ptr{Cvoid}
    next::Ptr{ecs_block_allocator_block_t}
end

struct ecs_block_allocator_t
    head::Ptr{ecs_block_allocator_chunk_header_t}
    block_head::Ptr{ecs_block_allocator_block_t}
    block_tail::Ptr{ecs_block_allocator_block_t}
    chunk_size::Int32
    data_size::Int32
    chunks_per_block::Int32
    block_size::Int32
    alloc_count::Int32
end

struct ecs_vec_t
    array::Ptr{Cvoid}
    count::Int32
    size::Int32
end

struct ecs_sparse_t
    dense::ecs_vec_t
    pages::ecs_vec_t
    size::ecs_size_t
    count::Int32
    max_id::UInt64
    allocator::Ptr{Cvoid} # allocator::Ptr{ecs_allocator_t}
    page_allocator::Ptr{ecs_block_allocator_t}
end

function Base.getproperty(x::ecs_sparse_t, f::Symbol)
    f === :allocator && return Ptr{ecs_allocator_t}(getfield(x, f))
    return getfield(x, f)
end

struct ecs_allocator_t
    chunks::ecs_block_allocator_t
    sizes::ecs_sparse_t
end

function ecs_vec_init(allocator, vec, size, elem_count)
    ccall((:ecs_vec_init, libflecs), Cvoid, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t, Int32), allocator, vec, size, elem_count)
end

function ecs_vec_init_if(vec, size)
    ccall((:ecs_vec_init_if, libflecs), Cvoid, (Ptr{ecs_vec_t}, ecs_size_t), vec, size)
end

function ecs_vec_fini(allocator, vec, size)
    ccall((:ecs_vec_fini, libflecs), Cvoid, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t), allocator, vec, size)
end

function ecs_vec_reset(allocator, vec, size)
    ccall((:ecs_vec_reset, libflecs), Ptr{ecs_vec_t}, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t), allocator, vec, size)
end

function ecs_vec_append(allocator, vec, size)
    ccall((:ecs_vec_append, libflecs), Ptr{Cvoid}, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t), allocator, vec, size)
end

function ecs_vec_remove(vec, size, elem)
    ccall((:ecs_vec_remove, libflecs), Cvoid, (Ptr{ecs_vec_t}, ecs_size_t, Int32), vec, size, elem)
end

function ecs_vec_copy(allocator, vec, size)
    ccall((:ecs_vec_copy, libflecs), ecs_vec_t, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t), allocator, vec, size)
end

function ecs_vec_copy_shrink(allocator, vec, size)
    ccall((:ecs_vec_copy_shrink, libflecs), ecs_vec_t, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t), allocator, vec, size)
end

function ecs_vec_reclaim(allocator, vec, size)
    ccall((:ecs_vec_reclaim, libflecs), Cvoid, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t), allocator, vec, size)
end

function ecs_vec_set_size(allocator, vec, size, elem_count)
    ccall((:ecs_vec_set_size, libflecs), Cvoid, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t, Int32), allocator, vec, size, elem_count)
end

function ecs_vec_set_min_size(allocator, vec, size, elem_count)
    ccall((:ecs_vec_set_min_size, libflecs), Cvoid, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t, Int32), allocator, vec, size, elem_count)
end

function ecs_vec_set_min_count(allocator, vec, size, elem_count)
    ccall((:ecs_vec_set_min_count, libflecs), Cvoid, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t, Int32), allocator, vec, size, elem_count)
end

function ecs_vec_set_min_count_zeromem(allocator, vec, size, elem_count)
    ccall((:ecs_vec_set_min_count_zeromem, libflecs), Cvoid, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t, Int32), allocator, vec, size, elem_count)
end

function ecs_vec_set_count(allocator, vec, size, elem_count)
    ccall((:ecs_vec_set_count, libflecs), Cvoid, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t, Int32), allocator, vec, size, elem_count)
end

function ecs_vec_grow(allocator, vec, size, elem_count)
    ccall((:ecs_vec_grow, libflecs), Ptr{Cvoid}, (Ptr{ecs_allocator_t}, Ptr{ecs_vec_t}, ecs_size_t, Int32), allocator, vec, size, elem_count)
end

function ecs_vec_get(vec, size, index)
    ccall((:ecs_vec_get, libflecs), Ptr{Cvoid}, (Ptr{ecs_vec_t}, ecs_size_t, Int32), vec, size, index)
end

function ecs_vec_first(vec)
    ccall((:ecs_vec_first, libflecs), Ptr{Cvoid}, (Ptr{ecs_vec_t},), vec)
end

function ecs_vec_last(vec, size)
    ccall((:ecs_vec_last, libflecs), Ptr{Cvoid}, (Ptr{ecs_vec_t}, ecs_size_t), vec, size)
end

function flecs_sparse_init(result, allocator, page_allocator, size)
    ccall((:flecs_sparse_init, libflecs), Cvoid, (Ptr{ecs_sparse_t}, Ptr{ecs_allocator_t}, Ptr{ecs_block_allocator_t}, ecs_size_t), result, allocator, page_allocator, size)
end

function flecs_sparse_add(sparse, elem_size)
    ccall((:flecs_sparse_add, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t), sparse, elem_size)
end

function flecs_sparse_remove(sparse, elem_size, id)
    ccall((:flecs_sparse_remove, libflecs), Cvoid, (Ptr{ecs_sparse_t}, ecs_size_t, UInt64), sparse, elem_size, id)
end

function flecs_sparse_get_dense(sparse, elem_size, index)
    ccall((:flecs_sparse_get_dense, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t, Int32), sparse, elem_size, index)
end

function flecs_sparse_get(sparse, elem_size, id)
    ccall((:flecs_sparse_get, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t, UInt64), sparse, elem_size, id)
end

function flecs_sparse_try(sparse, elem_size, id)
    ccall((:flecs_sparse_try, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t, UInt64), sparse, elem_size, id)
end

function flecs_sparse_get_any(sparse, elem_size, id)
    ccall((:flecs_sparse_get_any, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t, UInt64), sparse, elem_size, id)
end

function flecs_sparse_ensure(sparse, elem_size, id)
    ccall((:flecs_sparse_ensure, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t, UInt64), sparse, elem_size, id)
end

function flecs_sparse_ensure_fast(sparse, elem_size, id)
    ccall((:flecs_sparse_ensure_fast, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t, UInt64), sparse, elem_size, id)
end

function ecs_sparse_init(sparse, elem_size)
    ccall((:ecs_sparse_init, libflecs), Cvoid, (Ptr{ecs_sparse_t}, ecs_size_t), sparse, elem_size)
end

function ecs_sparse_add(sparse, elem_size)
    ccall((:ecs_sparse_add, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t), sparse, elem_size)
end

function ecs_sparse_get_dense(sparse, elem_size, index)
    ccall((:ecs_sparse_get_dense, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t, Int32), sparse, elem_size, index)
end

function ecs_sparse_get(sparse, elem_size, id)
    ccall((:ecs_sparse_get, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t, UInt64), sparse, elem_size, id)
end

function flecs_ballocator_init(ba, size)
    ccall((:flecs_ballocator_init, libflecs), Cvoid, (Ptr{ecs_block_allocator_t}, ecs_size_t), ba, size)
end

function flecs_ballocator_new(size)
    ccall((:flecs_ballocator_new, libflecs), Ptr{ecs_block_allocator_t}, (ecs_size_t,), size)
end

function flecs_stack_alloc(stack, size, align)
    ccall((:flecs_stack_alloc, libflecs), Ptr{Cvoid}, (Ptr{ecs_stack_t}, ecs_size_t, ecs_size_t), stack, size, align)
end

function flecs_stack_calloc(stack, size, align)
    ccall((:flecs_stack_calloc, libflecs), Ptr{Cvoid}, (Ptr{ecs_stack_t}, ecs_size_t, ecs_size_t), stack, size, align)
end

function flecs_stack_free(ptr, size)
    ccall((:flecs_stack_free, libflecs), Cvoid, (Ptr{Cvoid}, ecs_size_t), ptr, size)
end

const ecs_map_data_t = UInt64

const ecs_map_key_t = ecs_map_data_t

const ecs_map_val_t = ecs_map_data_t

struct ecs_bucket_entry_t
    key::ecs_map_key_t
    value::ecs_map_val_t
    next::Ptr{ecs_bucket_entry_t}
end

struct ecs_bucket_t
    first::Ptr{ecs_bucket_entry_t}
end

struct ecs_map_t
    bucket_shift::UInt8
    shared_allocator::Bool
    buckets::Ptr{ecs_bucket_t}
    bucket_count::Int32
    count::Int32
    entry_allocator::Ptr{ecs_block_allocator_t}
    allocator::Ptr{ecs_allocator_t}
end

function ecs_map_get(map, key)
    ccall((:ecs_map_get, libflecs), Ptr{ecs_map_val_t}, (Ptr{ecs_map_t}, ecs_map_key_t), map, key)
end

function ecs_map_get_deref_(map, key)
    ccall((:ecs_map_get_deref_, libflecs), Ptr{Cvoid}, (Ptr{ecs_map_t}, ecs_map_key_t), map, key)
end

function ecs_map_ensure(map, key)
    ccall((:ecs_map_ensure, libflecs), Ptr{ecs_map_val_t}, (Ptr{ecs_map_t}, ecs_map_key_t), map, key)
end

function ecs_map_insert(map, key, value)
    ccall((:ecs_map_insert, libflecs), Cvoid, (Ptr{ecs_map_t}, ecs_map_key_t, ecs_map_val_t), map, key, value)
end

function ecs_map_insert_alloc(map, elem_size, key)
    ccall((:ecs_map_insert_alloc, libflecs), Ptr{Cvoid}, (Ptr{ecs_map_t}, ecs_size_t, ecs_map_key_t), map, elem_size, key)
end

function ecs_map_ensure_alloc(map, elem_size, key)
    ccall((:ecs_map_ensure_alloc, libflecs), Ptr{Cvoid}, (Ptr{ecs_map_t}, ecs_size_t, ecs_map_key_t), map, elem_size, key)
end

function ecs_map_remove(map, key)
    ccall((:ecs_map_remove, libflecs), ecs_map_val_t, (Ptr{ecs_map_t}, ecs_map_key_t), map, key)
end

function flecs_balloc(allocator)
    ccall((:flecs_balloc, libflecs), Ptr{Cvoid}, (Ptr{ecs_block_allocator_t},), allocator)
end

function flecs_allocator_get(a, size)
    ccall((:flecs_allocator_get, libflecs), Ptr{ecs_block_allocator_t}, (Ptr{ecs_allocator_t}, ecs_size_t), a, size)
end

function flecs_bcalloc(allocator)
    ccall((:flecs_bcalloc, libflecs), Ptr{Cvoid}, (Ptr{ecs_block_allocator_t},), allocator)
end

function flecs_bfree(allocator, memory)
    ccall((:flecs_bfree, libflecs), Cvoid, (Ptr{ecs_block_allocator_t}, Ptr{Cvoid}), allocator, memory)
end

function flecs_bfree_w_dbg_info(allocator, memory, type_name)
    ccall((:flecs_bfree_w_dbg_info, libflecs), Cvoid, (Ptr{ecs_block_allocator_t}, Ptr{Cvoid}, Ptr{Cchar}), allocator, memory, type_name)
end

function flecs_brealloc(dst, src, memory)
    ccall((:flecs_brealloc, libflecs), Ptr{Cvoid}, (Ptr{ecs_block_allocator_t}, Ptr{ecs_block_allocator_t}, Ptr{Cvoid}), dst, src, memory)
end

function flecs_dup(a, size, src)
    ccall((:flecs_dup, libflecs), Ptr{Cvoid}, (Ptr{ecs_allocator_t}, ecs_size_t, Ptr{Cvoid}), a, size, src)
end

struct ecs_strbuf_list_elem
    count::Int32
    separator::Ptr{Cchar}
end

struct ecs_strbuf_t
    content::Ptr{Cchar}
    length::ecs_size_t
    size::ecs_size_t
    list_stack::NTuple{32, ecs_strbuf_list_elem}
    list_sp::Int32
    small_string::NTuple{512, Cchar}
end

function ecs_strbuf_appendstrn(buffer, str, n)
    ccall((:ecs_strbuf_appendstrn, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Ptr{Cchar}, Int32), buffer, str, n)
end

function ecs_strbuf_list_appendstrn(buffer, str, n)
    ccall((:ecs_strbuf_list_appendstrn, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Ptr{Cchar}, Int32), buffer, str, n)
end

function flecs_poly_claim_(poly)
    ccall((:flecs_poly_claim_, libflecs), Int32, (Ptr{ecs_poly_t},), poly)
end

function flecs_poly_release_(poly)
    ccall((:flecs_poly_release_, libflecs), Int32, (Ptr{ecs_poly_t},), poly)
end

# typedef uint64_t ( * ecs_hash_value_action_t ) ( const void * ptr )
const ecs_hash_value_action_t = Ptr{Cvoid}

# typedef int ( * ecs_compare_action_t ) ( const void * ptr1 , const void * ptr2 )
const ecs_compare_action_t = Ptr{Cvoid}

struct ecs_hashmap_t
    hash::ecs_hash_value_action_t
    compare::ecs_compare_action_t
    key_size::ecs_size_t
    value_size::ecs_size_t
    hashmap_allocator::Ptr{ecs_block_allocator_t}
    bucket_allocator::ecs_block_allocator_t
    impl::ecs_map_t
end

function flecs_hashmap_init_(hm, key_size, value_size, hash, compare, allocator)
    ccall((:flecs_hashmap_init_, libflecs), Cvoid, (Ptr{ecs_hashmap_t}, ecs_size_t, ecs_size_t, ecs_hash_value_action_t, ecs_compare_action_t, Ptr{ecs_allocator_t}), hm, key_size, value_size, hash, compare, allocator)
end

function flecs_hashmap_get_(map, key_size, key, value_size)
    ccall((:flecs_hashmap_get_, libflecs), Ptr{Cvoid}, (Ptr{ecs_hashmap_t}, ecs_size_t, Ptr{Cvoid}, ecs_size_t), map, key_size, key, value_size)
end

struct flecs_hashmap_result_t
    key::Ptr{Cvoid}
    value::Ptr{Cvoid}
    hash::UInt64
end

function flecs_hashmap_ensure_(map, key_size, key, value_size)
    ccall((:flecs_hashmap_ensure_, libflecs), flecs_hashmap_result_t, (Ptr{ecs_hashmap_t}, ecs_size_t, Ptr{Cvoid}, ecs_size_t), map, key_size, key, value_size)
end

function flecs_hashmap_set_(map, key_size, key, value_size, value)
    ccall((:flecs_hashmap_set_, libflecs), Cvoid, (Ptr{ecs_hashmap_t}, ecs_size_t, Ptr{Cvoid}, ecs_size_t, Ptr{Cvoid}), map, key_size, key, value_size, value)
end

function flecs_hashmap_remove_(map, key_size, key, value_size)
    ccall((:flecs_hashmap_remove_, libflecs), Cvoid, (Ptr{ecs_hashmap_t}, ecs_size_t, Ptr{Cvoid}, ecs_size_t), map, key_size, key, value_size)
end

function flecs_hashmap_remove_w_hash_(map, key_size, key, value_size, hash)
    ccall((:flecs_hashmap_remove_w_hash_, libflecs), Cvoid, (Ptr{ecs_hashmap_t}, ecs_size_t, Ptr{Cvoid}, ecs_size_t, UInt64), map, key_size, key, value_size, hash)
end

struct ecs_map_iter_t
    map::Ptr{ecs_map_t}
    bucket::Ptr{ecs_bucket_t}
    entry::Ptr{ecs_bucket_entry_t}
    res::Ptr{ecs_map_data_t}
end

struct ecs_hm_bucket_t
    keys::ecs_vec_t
    values::ecs_vec_t
end

struct flecs_hashmap_iter_t
    it::ecs_map_iter_t
    bucket::Ptr{ecs_hm_bucket_t}
    index::Int32
end

function flecs_hashmap_next_(it, key_size, key_out, value_size)
    ccall((:flecs_hashmap_next_, libflecs), Ptr{Cvoid}, (Ptr{flecs_hashmap_iter_t}, ecs_size_t, Ptr{Cvoid}, ecs_size_t), it, key_size, key_out, value_size)
end

function flecs_poly_is_(object, type)
    ccall((:flecs_poly_is_, libflecs), Bool, (Ptr{ecs_poly_t}, Int32), object, type)
end

struct ecs_value_t
    type::ecs_entity_t
    ptr::Ptr{Cvoid}
end

struct ecs_entity_desc_t
    _canary::Int32
    id::ecs_entity_t
    parent::ecs_entity_t
    name::Ptr{Cchar}
    sep::Ptr{Cchar}
    root_sep::Ptr{Cchar}
    symbol::Ptr{Cchar}
    use_low_id::Bool
    add::Ptr{ecs_id_t}
    set::Ptr{ecs_value_t}
    add_expr::Ptr{Cchar}
end

function ecs_entity_init(world, desc)
    ccall((:ecs_entity_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_entity_desc_t}), world, desc)
end

struct ecs_component_desc_t
    _canary::Int32
    entity::ecs_entity_t
    type::ecs_type_info_t
end

function ecs_component_init(world, desc)
    ccall((:ecs_component_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_component_desc_t}), world, desc)
end

# typedef int ( * ecs_order_by_action_t ) ( ecs_entity_t e1 , const void * ptr1 , ecs_entity_t e2 , const void * ptr2 )
const ecs_order_by_action_t = Ptr{Cvoid}

# typedef void ( * ecs_sort_table_action_t ) ( ecs_world_t * world , ecs_table_t * table , ecs_entity_t * entities , void * ptr , int32_t size , int32_t lo , int32_t hi , ecs_order_by_action_t order_by )
const ecs_sort_table_action_t = Ptr{Cvoid}

# typedef uint64_t ( * ecs_group_by_action_t ) ( ecs_world_t * world , ecs_table_t * table , ecs_id_t group_id , void * ctx )
const ecs_group_by_action_t = Ptr{Cvoid}

# typedef void * ( * ecs_group_create_action_t ) ( ecs_world_t * world , uint64_t group_id , void * group_by_ctx )
const ecs_group_create_action_t = Ptr{Cvoid}

# typedef void ( * ecs_group_delete_action_t ) ( ecs_world_t * world , uint64_t group_id , void * group_ctx , /* return value from ecs_group_create_action_t */ void * group_by_ctx )
const ecs_group_delete_action_t = Ptr{Cvoid}

struct ecs_query_desc_t
    _canary::Int32
    terms::NTuple{32, ecs_term_t}
    expr::Ptr{Cchar}
    cache_kind::ecs_query_cache_kind_t
    flags::ecs_flags32_t
    order_by_callback::ecs_order_by_action_t
    order_by_table_callback::ecs_sort_table_action_t
    order_by::ecs_entity_t
    group_by::ecs_id_t
    group_by_callback::ecs_group_by_action_t
    on_group_create::ecs_group_create_action_t
    on_group_delete::ecs_group_delete_action_t
    group_by_ctx::Ptr{Cvoid}
    group_by_ctx_free::ecs_ctx_free_t
    ctx::Ptr{Cvoid}
    binding_ctx::Ptr{Cvoid}
    ctx_free::ecs_ctx_free_t
    binding_ctx_free::ecs_ctx_free_t
    entity::ecs_entity_t
end

# typedef void ( * ecs_run_action_t ) ( ecs_iter_t * it )
const ecs_run_action_t = Ptr{Cvoid}

struct ecs_observer_desc_t
    _canary::Int32
    entity::ecs_entity_t
    query::ecs_query_desc_t
    events::NTuple{8, ecs_entity_t}
    yield_existing::Bool
    callback::ecs_iter_action_t
    run::ecs_run_action_t
    ctx::Ptr{Cvoid}
    ctx_free::ecs_ctx_free_t
    callback_ctx::Ptr{Cvoid}
    callback_ctx_free::ecs_ctx_free_t
    run_ctx::Ptr{Cvoid}
    run_ctx_free::ecs_ctx_free_t
    observable::Ptr{ecs_poly_t}
    last_event_id::Ptr{Int32}
    term_index_::Int8
    flags_::ecs_flags32_t
end

function ecs_observer_init(world, desc)
    ccall((:ecs_observer_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_observer_desc_t}), world, desc)
end

function ecs_query_init(world, desc)
    ccall((:ecs_query_init, libflecs), Ptr{ecs_query_t}, (Ptr{ecs_world_t}, Ptr{ecs_query_desc_t}), world, desc)
end

function ecs_new_w_id(world, id)
    ccall((:ecs_new_w_id, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_bulk_new_w_id(world, id, count)
    ccall((:ecs_bulk_new_w_id, libflecs), Ptr{ecs_entity_t}, (Ptr{ecs_world_t}, ecs_id_t, Int32), world, id, count)
end

function ecs_add_id(world, entity, id)
    ccall((:ecs_add_id, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_remove_id(world, entity, id)
    ccall((:ecs_remove_id, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_auto_override_id(world, entity, id)
    ccall((:ecs_auto_override_id, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_set_id(world, entity, id, size, ptr)
    ccall((:ecs_set_id, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t, Csize_t, Ptr{Cvoid}), world, entity, id, size, ptr)
end

function ecs_emplace_id(world, entity, id, is_new)
    ccall((:ecs_emplace_id, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t, Ptr{Bool}), world, entity, id, is_new)
end

function ecs_get_id(world, entity, id)
    ccall((:ecs_get_id, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_get_mut_id(world, entity, id)
    ccall((:ecs_get_mut_id, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_ensure_id(world, entity, id)
    ccall((:ecs_ensure_id, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_modified_id(world, entity, id)
    ccall((:ecs_modified_id, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

mutable struct ecs_id_record_t end

struct ecs_record_t
    idr::Ptr{ecs_id_record_t}
    table::Ptr{ecs_table_t}
    row::UInt32
    dense::Int32
end

function ecs_record_get_id(world, record, id)
    ccall((:ecs_record_get_id, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, Ptr{ecs_record_t}, ecs_id_t), world, record, id)
end

function ecs_record_has_id(world, record, id)
    ccall((:ecs_record_has_id, libflecs), Bool, (Ptr{ecs_world_t}, Ptr{ecs_record_t}, ecs_id_t), world, record, id)
end

function ecs_record_ensure_id(world, record, id)
    ccall((:ecs_record_ensure_id, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, Ptr{ecs_record_t}, ecs_id_t), world, record, id)
end

struct ecs_ref_t
    entity::ecs_entity_t
    id::ecs_entity_t
    table_id::UInt64
    tr::Ptr{ecs_table_record_t}
    record::Ptr{ecs_record_t}
end

function ecs_ref_init_id(world, entity, id)
    ccall((:ecs_ref_init_id, libflecs), ecs_ref_t, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_ref_get_id(world, ref, id)
    ccall((:ecs_ref_get_id, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, Ptr{ecs_ref_t}, ecs_id_t), world, ref, id)
end

function ecs_has_id(world, entity, id)
    ccall((:ecs_has_id, libflecs), Bool, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_owns_id(world, entity, id)
    ccall((:ecs_owns_id, libflecs), Bool, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_search_relation(world, table, offset, id, rel, flags, subject_out, id_out, tr_out)
    ccall((:ecs_search_relation, libflecs), Int32, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, Int32, ecs_id_t, ecs_entity_t, ecs_flags64_t, Ptr{ecs_entity_t}, Ptr{ecs_id_t}, Ptr{Ptr{ecs_table_record_t}}), world, table, offset, id, rel, flags, subject_out, id_out, tr_out)
end

function ecs_get_table(world, entity)
    ccall((:ecs_get_table, libflecs), Ptr{ecs_table_t}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_get_target_for_id(world, entity, rel, id)
    ccall((:ecs_get_target_for_id, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t, ecs_id_t), world, entity, rel, id)
end

function ecs_enable_id(world, entity, id, enable)
    ccall((:ecs_enable_id, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t, Bool), world, entity, id, enable)
end

function ecs_is_enabled_id(world, entity, id)
    ccall((:ecs_is_enabled_id, libflecs), Bool, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_lookup_path_w_sep(world, parent, path, sep, prefix, recursive)
    ccall((:ecs_lookup_path_w_sep, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Bool), world, parent, path, sep, prefix, recursive)
end

function ecs_get_path_w_sep(world, parent, child, sep, prefix)
    ccall((:ecs_get_path_w_sep, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t, Ptr{Cchar}, Ptr{Cchar}), world, parent, child, sep, prefix)
end

function ecs_get_path_w_sep_buf(world, parent, child, sep, prefix, buf, escape)
    ccall((:ecs_get_path_w_sep_buf, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t, Ptr{Cchar}, Ptr{Cchar}, Ptr{ecs_strbuf_t}, Bool), world, parent, child, sep, prefix, buf, escape)
end

function ecs_new_from_path_w_sep(world, parent, path, sep, prefix)
    ccall((:ecs_new_from_path_w_sep, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), world, parent, path, sep, prefix)
end

function ecs_add_path_w_sep(world, entity, parent, path, sep, prefix)
    ccall((:ecs_add_path_w_sep, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), world, entity, parent, path, sep, prefix)
end

function ecs_set_hooks_id(world, id, hooks)
    ccall((:ecs_set_hooks_id, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{ecs_type_hooks_t}), world, id, hooks)
end

function ecs_get_hooks_id(world, id)
    ccall((:ecs_get_hooks_id, libflecs), Ptr{ecs_type_hooks_t}, (Ptr{ecs_world_t}, ecs_entity_t), world, id)
end

function ecs_count_id(world, entity)
    ccall((:ecs_count_id, libflecs), Int32, (Ptr{ecs_world_t}, ecs_id_t), world, entity)
end

function ecs_field_at_w_size(it, size, index, row)
    ccall((:ecs_field_at_w_size, libflecs), Ptr{Cvoid}, (Ptr{ecs_iter_t}, Csize_t, Int8, Int32), it, size, index, row)
end

function ecs_table_get_id(world, table, id, offset)
    ccall((:ecs_table_get_id, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, ecs_id_t, Int32), world, table, id, offset)
end

function ecs_value_new(world, type)
    ccall((:ecs_value_new, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, ecs_entity_t), world, type)
end

function ecs_table_swap_rows(world, table, row_1, row_2)
    ccall((:ecs_table_swap_rows, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, Int32, Int32), world, table, row_1, row_2)
end

function ecs_each_id(world, id)
    ccall((:ecs_each_id, libflecs), ecs_iter_t, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_deprecated_(file, line, msg)
    ccall((:ecs_deprecated_, libflecs), Cvoid, (Ptr{Cchar}, Int32, Ptr{Cchar}), file, line, msg)
end

function ecs_log_push_(level)
    ccall((:ecs_log_push_, libflecs), Cvoid, (Int32,), level)
end

function ecs_log_pop_(level)
    ccall((:ecs_log_pop_, libflecs), Cvoid, (Int32,), level)
end

function ecs_should_log(level)
    ccall((:ecs_should_log, libflecs), Bool, (Int32,), level)
end

struct ecs_http_reply_t
    code::Cint
    body::ecs_strbuf_t
    status::Ptr{Cchar}
    content_type::Ptr{Cchar}
    headers::ecs_strbuf_t
end

struct ecs_pipeline_desc_t
    entity::ecs_entity_t
    query::ecs_query_desc_t
end

function ecs_pipeline_init(world, desc)
    ccall((:ecs_pipeline_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_pipeline_desc_t}), world, desc)
end

struct ecs_system_desc_t
    _canary::Int32
    entity::ecs_entity_t
    query::ecs_query_desc_t
    callback::ecs_iter_action_t
    run::ecs_run_action_t
    ctx::Ptr{Cvoid}
    ctx_free::ecs_ctx_free_t
    callback_ctx::Ptr{Cvoid}
    callback_ctx_free::ecs_ctx_free_t
    run_ctx::Ptr{Cvoid}
    run_ctx_free::ecs_ctx_free_t
    interval::Cfloat
    rate::Int32
    tick_source::ecs_entity_t
    multi_threaded::Bool
    immediate::Bool
end

function ecs_system_init(world, desc)
    ccall((:ecs_system_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_system_desc_t}), world, desc)
end

struct ecs_metric_desc_t
    _canary::Int32
    entity::ecs_entity_t
    member::ecs_entity_t
    dotmember::Ptr{Cchar}
    id::ecs_id_t
    targets::Bool
    kind::ecs_entity_t
    brief::Ptr{Cchar}
end

function ecs_metric_init(world, desc)
    ccall((:ecs_metric_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_metric_desc_t}), world, desc)
end

struct ecs_alert_severity_filter_t
    severity::ecs_entity_t
    with::ecs_id_t
    var::Ptr{Cchar}
    _var_index::Int32
end

struct ecs_alert_desc_t
    _canary::Int32
    entity::ecs_entity_t
    query::ecs_query_desc_t
    message::Ptr{Cchar}
    doc_name::Ptr{Cchar}
    brief::Ptr{Cchar}
    severity::ecs_entity_t
    severity_filters::NTuple{4, ecs_alert_severity_filter_t}
    retain_period::Cfloat
    member::ecs_entity_t
    id::ecs_id_t
    var::Ptr{Cchar}
end

function ecs_alert_init(world, desc)
    ccall((:ecs_alert_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_alert_desc_t}), world, desc)
end

struct ecs_entity_to_json_desc_t
    serialize_entity_id::Bool
    serialize_doc::Bool
    serialize_full_paths::Bool
    serialize_inherited::Bool
    serialize_values::Bool
    serialize_builtin::Bool
    serialize_type_info::Bool
    serialize_alerts::Bool
    serialize_refs::ecs_entity_t
    serialize_matches::Bool
end

struct ecs_iter_to_json_desc_t
    serialize_entity_ids::Bool
    serialize_values::Bool
    serialize_builtin::Bool
    serialize_doc::Bool
    serialize_full_paths::Bool
    serialize_fields::Bool
    serialize_inherited::Bool
    serialize_table::Bool
    serialize_type_info::Bool
    serialize_field_info::Bool
    serialize_query_info::Bool
    serialize_query_plan::Bool
    serialize_query_profile::Bool
    dont_serialize_results::Bool
    serialize_alerts::Bool
    serialize_refs::ecs_entity_t
    serialize_matches::Bool
    query::Ptr{ecs_poly_t}
end

struct ecs_script_desc_t
    entity::ecs_entity_t
    filename::Ptr{Cchar}
    code::Ptr{Cchar}
end

function ecs_script_init(world, desc)
    ccall((:ecs_script_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_script_desc_t}), world, desc)
end

struct ecs_script_vars_t
    parent::Ptr{ecs_script_vars_t}
    var_index::ecs_hashmap_t
    vars::ecs_vec_t
    world::Ptr{ecs_world_t}
    stack::Ptr{ecs_stack_t}
    cursor::Ptr{ecs_stack_cursor_t}
    allocator::Ptr{ecs_allocator_t}
end

struct ecs_script_var_t
    name::Ptr{Cchar}
    value::ecs_value_t
    type_info::Ptr{ecs_type_info_t}
end

function ecs_script_vars_define_id(vars, name, type)
    ccall((:ecs_script_vars_define_id, libflecs), Ptr{ecs_script_var_t}, (Ptr{ecs_script_vars_t}, Ptr{Cchar}, ecs_entity_t), vars, name, type)
end

@cenum ecs_primitive_kind_t::UInt32 begin
    EcsBool = 1
    EcsChar = 2
    EcsByte = 3
    EcsU8 = 4
    EcsU16 = 5
    EcsU32 = 6
    EcsU64 = 7
    EcsI8 = 8
    EcsI16 = 9
    EcsI32 = 10
    EcsI64 = 11
    EcsF32 = 12
    EcsF64 = 13
    EcsUPtr = 14
    EcsIPtr = 15
    EcsString = 16
    EcsEntity = 17
    EcsId = 18
    EcsPrimitiveKindLast = 18
end

struct ecs_primitive_desc_t
    entity::ecs_entity_t
    kind::ecs_primitive_kind_t
end

function ecs_primitive_init(world, desc)
    ccall((:ecs_primitive_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_primitive_desc_t}), world, desc)
end

struct ecs_enum_constant_t
    name::Ptr{Cchar}
    value::Int32
    constant::ecs_entity_t
end

struct ecs_enum_desc_t
    entity::ecs_entity_t
    constants::NTuple{32, ecs_enum_constant_t}
end

function ecs_enum_init(world, desc)
    ccall((:ecs_enum_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_enum_desc_t}), world, desc)
end

struct ecs_bitmask_constant_t
    name::Ptr{Cchar}
    value::ecs_flags32_t
    constant::ecs_entity_t
end

struct ecs_bitmask_desc_t
    entity::ecs_entity_t
    constants::NTuple{32, ecs_bitmask_constant_t}
end

function ecs_bitmask_init(world, desc)
    ccall((:ecs_bitmask_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_bitmask_desc_t}), world, desc)
end

struct ecs_array_desc_t
    entity::ecs_entity_t
    type::ecs_entity_t
    count::Int32
end

function ecs_array_init(world, desc)
    ccall((:ecs_array_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_array_desc_t}), world, desc)
end

struct ecs_vector_desc_t
    entity::ecs_entity_t
    type::ecs_entity_t
end

function ecs_vector_init(world, desc)
    ccall((:ecs_vector_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_vector_desc_t}), world, desc)
end

# typedef int ( * ecs_meta_serialize_t ) ( const ecs_serializer_t * ser , const void * src )
const ecs_meta_serialize_t = Ptr{Cvoid}

struct EcsOpaque
    as_type::ecs_entity_t
    serialize::ecs_meta_serialize_t
    assign_bool::Ptr{Cvoid}
    assign_char::Ptr{Cvoid}
    assign_int::Ptr{Cvoid}
    assign_uint::Ptr{Cvoid}
    assign_float::Ptr{Cvoid}
    assign_string::Ptr{Cvoid}
    assign_entity::Ptr{Cvoid}
    assign_id::Ptr{Cvoid}
    assign_null::Ptr{Cvoid}
    clear::Ptr{Cvoid}
    ensure_element::Ptr{Cvoid}
    ensure_member::Ptr{Cvoid}
    count::Ptr{Cvoid}
    resize::Ptr{Cvoid}
end

struct ecs_opaque_desc_t
    entity::ecs_entity_t
    type::EcsOpaque
end

function ecs_opaque_init(world, desc)
    ccall((:ecs_opaque_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_opaque_desc_t}), world, desc)
end

struct ecs_member_value_range_t
    min::Cdouble
    max::Cdouble
end

struct ecs_member_t
    name::Ptr{Cchar}
    type::ecs_entity_t
    count::Int32
    offset::Int32
    unit::ecs_entity_t
    use_offset::Bool
    range::ecs_member_value_range_t
    error_range::ecs_member_value_range_t
    warning_range::ecs_member_value_range_t
    size::ecs_size_t
    member::ecs_entity_t
end

struct ecs_struct_desc_t
    entity::ecs_entity_t
    members::NTuple{32, ecs_member_t}
end

function ecs_struct_init(world, desc)
    ccall((:ecs_struct_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_struct_desc_t}), world, desc)
end

struct ecs_unit_translation_t
    factor::Int32
    power::Int32
end

struct ecs_unit_desc_t
    entity::ecs_entity_t
    symbol::Ptr{Cchar}
    quantity::ecs_entity_t
    base::ecs_entity_t
    over::ecs_entity_t
    translation::ecs_unit_translation_t
    prefix::ecs_entity_t
end

function ecs_unit_init(world, desc)
    ccall((:ecs_unit_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_unit_desc_t}), world, desc)
end

struct ecs_unit_prefix_desc_t
    entity::ecs_entity_t
    symbol::Ptr{Cchar}
    translation::ecs_unit_translation_t
end

function ecs_unit_prefix_init(world, desc)
    ccall((:ecs_unit_prefix_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_unit_prefix_desc_t}), world, desc)
end

function ecs_quantity_init(world, desc)
    ccall((:ecs_quantity_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_entity_desc_t}), world, desc)
end

@cenum ecs_type_kind_t::UInt32 begin
    EcsPrimitiveType = 0
    EcsBitmaskType = 1
    EcsEnumType = 2
    EcsStructType = 3
    EcsArrayType = 4
    EcsVectorType = 5
    EcsOpaqueType = 6
    EcsTypeKindLast = 6
end

function ecs_meta_from_desc(world, component, kind, desc)
    ccall((:ecs_meta_from_desc, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, ecs_type_kind_t, Ptr{Cchar}), world, component, kind, desc)
end

function ecs_module_init(world, c_name, desc)
    ccall((:ecs_module_init, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{Cchar}, Ptr{ecs_component_desc_t}), world, c_name, desc)
end

function ecs_set_scope(world, scope)
    ccall((:ecs_set_scope, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t), world, scope)
end

# typedef void ( * ecs_module_action_t ) ( ecs_world_t * world )
const ecs_module_action_t = Ptr{Cvoid}

function ecs_import_c(world, _module, module_name_c)
    ccall((:ecs_import_c, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_module_action_t, Ptr{Cchar}), world, _module, module_name_c)
end

function ecs_vec_clear(vec)
    ccall((:ecs_vec_clear, libflecs), Cvoid, (Ptr{ecs_vec_t},), vec)
end

function ecs_vec_remove_last(vec)
    ccall((:ecs_vec_remove_last, libflecs), Cvoid, (Ptr{ecs_vec_t},), vec)
end

function ecs_vec_count(vec)
    ccall((:ecs_vec_count, libflecs), Int32, (Ptr{ecs_vec_t},), vec)
end

function ecs_vec_size(vec)
    ccall((:ecs_vec_size, libflecs), Int32, (Ptr{ecs_vec_t},), vec)
end

function flecs_sparse_fini(sparse)
    ccall((:flecs_sparse_fini, libflecs), Cvoid, (Ptr{ecs_sparse_t},), sparse)
end

function flecs_sparse_clear(sparse)
    ccall((:flecs_sparse_clear, libflecs), Cvoid, (Ptr{ecs_sparse_t},), sparse)
end

function flecs_sparse_last_id(sparse)
    ccall((:flecs_sparse_last_id, libflecs), UInt64, (Ptr{ecs_sparse_t},), sparse)
end

function flecs_sparse_new_id(sparse)
    ccall((:flecs_sparse_new_id, libflecs), UInt64, (Ptr{ecs_sparse_t},), sparse)
end

function flecs_sparse_remove_fast(sparse, size, index)
    ccall((:flecs_sparse_remove_fast, libflecs), Ptr{Cvoid}, (Ptr{ecs_sparse_t}, ecs_size_t, UInt64), sparse, size, index)
end

function flecs_sparse_is_alive(sparse, id)
    ccall((:flecs_sparse_is_alive, libflecs), Bool, (Ptr{ecs_sparse_t}, UInt64), sparse, id)
end

function flecs_sparse_count(sparse)
    ccall((:flecs_sparse_count, libflecs), Int32, (Ptr{ecs_sparse_t},), sparse)
end

function flecs_sparse_ids(sparse)
    ccall((:flecs_sparse_ids, libflecs), Ptr{UInt64}, (Ptr{ecs_sparse_t},), sparse)
end

function ecs_sparse_last_id(sparse)
    ccall((:ecs_sparse_last_id, libflecs), UInt64, (Ptr{ecs_sparse_t},), sparse)
end

function ecs_sparse_count(sparse)
    ccall((:ecs_sparse_count, libflecs), Int32, (Ptr{ecs_sparse_t},), sparse)
end

function flecs_ballocator_fini(ba)
    ccall((:flecs_ballocator_fini, libflecs), Cvoid, (Ptr{ecs_block_allocator_t},), ba)
end

function flecs_ballocator_free(ba)
    ccall((:flecs_ballocator_free, libflecs), Cvoid, (Ptr{ecs_block_allocator_t},), ba)
end

function flecs_bdup(ba, memory)
    ccall((:flecs_bdup, libflecs), Ptr{Cvoid}, (Ptr{ecs_block_allocator_t}, Ptr{Cvoid}), ba, memory)
end

function flecs_stack_init(stack)
    ccall((:flecs_stack_init, libflecs), Cvoid, (Ptr{ecs_stack_t},), stack)
end

function flecs_stack_fini(stack)
    ccall((:flecs_stack_fini, libflecs), Cvoid, (Ptr{ecs_stack_t},), stack)
end

function flecs_stack_reset(stack)
    ccall((:flecs_stack_reset, libflecs), Cvoid, (Ptr{ecs_stack_t},), stack)
end

function flecs_stack_get_cursor(stack)
    ccall((:flecs_stack_get_cursor, libflecs), Ptr{ecs_stack_cursor_t}, (Ptr{ecs_stack_t},), stack)
end

function flecs_stack_restore_cursor(stack, cursor)
    ccall((:flecs_stack_restore_cursor, libflecs), Cvoid, (Ptr{ecs_stack_t}, Ptr{ecs_stack_cursor_t}), stack, cursor)
end

struct ecs_map_params_t
    allocator::Ptr{ecs_allocator_t}
    entry_allocator::ecs_block_allocator_t
end

function ecs_map_params_init(params, allocator)
    ccall((:ecs_map_params_init, libflecs), Cvoid, (Ptr{ecs_map_params_t}, Ptr{ecs_allocator_t}), params, allocator)
end

function ecs_map_params_fini(params)
    ccall((:ecs_map_params_fini, libflecs), Cvoid, (Ptr{ecs_map_params_t},), params)
end

function ecs_map_init(map, allocator)
    ccall((:ecs_map_init, libflecs), Cvoid, (Ptr{ecs_map_t}, Ptr{ecs_allocator_t}), map, allocator)
end

function ecs_map_init_w_params(map, params)
    ccall((:ecs_map_init_w_params, libflecs), Cvoid, (Ptr{ecs_map_t}, Ptr{ecs_map_params_t}), map, params)
end

function ecs_map_init_if(map, allocator)
    ccall((:ecs_map_init_if, libflecs), Cvoid, (Ptr{ecs_map_t}, Ptr{ecs_allocator_t}), map, allocator)
end

function ecs_map_init_w_params_if(result, params)
    ccall((:ecs_map_init_w_params_if, libflecs), Cvoid, (Ptr{ecs_map_t}, Ptr{ecs_map_params_t}), result, params)
end

function ecs_map_fini(map)
    ccall((:ecs_map_fini, libflecs), Cvoid, (Ptr{ecs_map_t},), map)
end

function ecs_map_remove_free(map, key)
    ccall((:ecs_map_remove_free, libflecs), Cvoid, (Ptr{ecs_map_t}, ecs_map_key_t), map, key)
end

function ecs_map_clear(map)
    ccall((:ecs_map_clear, libflecs), Cvoid, (Ptr{ecs_map_t},), map)
end

function ecs_map_iter(map)
    ccall((:ecs_map_iter, libflecs), ecs_map_iter_t, (Ptr{ecs_map_t},), map)
end

function ecs_map_next(iter)
    ccall((:ecs_map_next, libflecs), Bool, (Ptr{ecs_map_iter_t},), iter)
end

function ecs_map_copy(dst, src)
    ccall((:ecs_map_copy, libflecs), Cvoid, (Ptr{ecs_map_t}, Ptr{ecs_map_t}), dst, src)
end

struct ecs_switch_node_t
    next::UInt32
    prev::UInt32
end

struct ecs_switch_page_t
    nodes::ecs_vec_t
    values::ecs_vec_t
end

struct ecs_switch_t
    hdrs::ecs_map_t
    pages::ecs_vec_t
end

function flecs_switch_init(sw, allocator)
    ccall((:flecs_switch_init, libflecs), Cvoid, (Ptr{ecs_switch_t}, Ptr{ecs_allocator_t}), sw, allocator)
end

function flecs_switch_fini(sw)
    ccall((:flecs_switch_fini, libflecs), Cvoid, (Ptr{ecs_switch_t},), sw)
end

function flecs_switch_set(sw, element, value)
    ccall((:flecs_switch_set, libflecs), Bool, (Ptr{ecs_switch_t}, UInt32, UInt64), sw, element, value)
end

function flecs_switch_reset(sw, element)
    ccall((:flecs_switch_reset, libflecs), Bool, (Ptr{ecs_switch_t}, UInt32), sw, element)
end

function flecs_switch_get(sw, element)
    ccall((:flecs_switch_get, libflecs), UInt64, (Ptr{ecs_switch_t}, UInt32), sw, element)
end

function flecs_switch_first(sw, value)
    ccall((:flecs_switch_first, libflecs), UInt32, (Ptr{ecs_switch_t}, UInt64), sw, value)
end

function flecs_switch_next(sw, previous)
    ccall((:flecs_switch_next, libflecs), UInt32, (Ptr{ecs_switch_t}, UInt32), sw, previous)
end

function flecs_switch_targets(sw)
    ccall((:flecs_switch_targets, libflecs), ecs_map_iter_t, (Ptr{ecs_switch_t},), sw)
end

function flecs_allocator_init(a)
    ccall((:flecs_allocator_init, libflecs), Cvoid, (Ptr{ecs_allocator_t},), a)
end

function flecs_allocator_fini(a)
    ccall((:flecs_allocator_fini, libflecs), Cvoid, (Ptr{ecs_allocator_t},), a)
end

function flecs_strdup(a, str)
    ccall((:flecs_strdup, libflecs), Ptr{Cchar}, (Ptr{ecs_allocator_t}, Ptr{Cchar}), a, str)
end

function flecs_strfree(a, str)
    ccall((:flecs_strfree, libflecs), Cvoid, (Ptr{ecs_allocator_t}, Ptr{Cchar}), a, str)
end

function ecs_strbuf_appendstr(buffer, str)
    ccall((:ecs_strbuf_appendstr, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Ptr{Cchar}), buffer, str)
end

function ecs_strbuf_appendch(buffer, ch)
    ccall((:ecs_strbuf_appendch, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Cchar), buffer, ch)
end

function ecs_strbuf_appendint(buffer, v)
    ccall((:ecs_strbuf_appendint, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Int64), buffer, v)
end

function ecs_strbuf_appendflt(buffer, v, nan_delim)
    ccall((:ecs_strbuf_appendflt, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Cdouble, Cchar), buffer, v, nan_delim)
end

function ecs_strbuf_appendbool(buffer, v)
    ccall((:ecs_strbuf_appendbool, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Bool), buffer, v)
end

function ecs_strbuf_mergebuff(dst_buffer, src_buffer)
    ccall((:ecs_strbuf_mergebuff, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Ptr{ecs_strbuf_t}), dst_buffer, src_buffer)
end

function ecs_strbuf_get(buffer)
    ccall((:ecs_strbuf_get, libflecs), Ptr{Cchar}, (Ptr{ecs_strbuf_t},), buffer)
end

function ecs_strbuf_get_small(buffer)
    ccall((:ecs_strbuf_get_small, libflecs), Ptr{Cchar}, (Ptr{ecs_strbuf_t},), buffer)
end

function ecs_strbuf_reset(buffer)
    ccall((:ecs_strbuf_reset, libflecs), Cvoid, (Ptr{ecs_strbuf_t},), buffer)
end

function ecs_strbuf_list_push(buffer, list_open, separator)
    ccall((:ecs_strbuf_list_push, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Ptr{Cchar}, Ptr{Cchar}), buffer, list_open, separator)
end

function ecs_strbuf_list_pop(buffer, list_close)
    ccall((:ecs_strbuf_list_pop, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Ptr{Cchar}), buffer, list_close)
end

function ecs_strbuf_list_next(buffer)
    ccall((:ecs_strbuf_list_next, libflecs), Cvoid, (Ptr{ecs_strbuf_t},), buffer)
end

function ecs_strbuf_list_appendch(buffer, ch)
    ccall((:ecs_strbuf_list_appendch, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Cchar), buffer, ch)
end

function ecs_strbuf_list_appendstr(buffer, str)
    ccall((:ecs_strbuf_list_appendstr, libflecs), Cvoid, (Ptr{ecs_strbuf_t}, Ptr{Cchar}), buffer, str)
end

function ecs_strbuf_written(buffer)
    ccall((:ecs_strbuf_written, libflecs), Int32, (Ptr{ecs_strbuf_t},), buffer)
end

struct ecs_type_t
    array::Ptr{ecs_id_t}
    count::Int32
end

mutable struct ecs_stage_t end

mutable struct ecs_event_id_record_t end

struct ecs_event_record_t
    any::Ptr{ecs_event_id_record_t}
    wildcard::Ptr{ecs_event_id_record_t}
    wildcard_pair::Ptr{ecs_event_id_record_t}
    event_ids::ecs_map_t
    event::ecs_entity_t
end

struct ecs_observable_t
    on_add::ecs_event_record_t
    on_remove::ecs_event_record_t
    on_set::ecs_event_record_t
    on_wildcard::ecs_event_record_t
    events::ecs_sparse_t
end

struct ecs_observer_t
    hdr::ecs_header_t
    query::Ptr{ecs_query_t}
    events::NTuple{8, ecs_entity_t}
    event_count::Int32
    callback::ecs_iter_action_t
    run::ecs_run_action_t
    ctx::Ptr{Cvoid}
    callback_ctx::Ptr{Cvoid}
    run_ctx::Ptr{Cvoid}
    ctx_free::ecs_ctx_free_t
    callback_ctx_free::ecs_ctx_free_t
    run_ctx_free::ecs_ctx_free_t
    observable::Ptr{ecs_observable_t}
    world::Ptr{ecs_world_t}
    entity::ecs_entity_t
end

# typedef void ( * ecs_fini_action_t ) ( ecs_world_t * world , void * ctx )
const ecs_fini_action_t = Ptr{Cvoid}

# typedef void ( * flecs_poly_dtor_t ) ( ecs_poly_t * poly )
const flecs_poly_dtor_t = Ptr{Cvoid}

@cenum ecs_inout_kind_t::UInt32 begin
    EcsInOutDefault = 0
    EcsInOutNone = 1
    EcsInOutFilter = 2
    EcsInOut = 3
    EcsIn = 4
    EcsOut = 5
end

@cenum ecs_oper_kind_t::UInt32 begin
    EcsAnd = 0
    EcsOr = 1
    EcsNot = 2
    EcsOptional = 3
    EcsAndFrom = 4
    EcsOrFrom = 5
    EcsNotFrom = 6
end

mutable struct ecs_data_t end

mutable struct ecs_query_cache_table_match_t end

struct ecs_page_iter_t
    offset::Int32
    limit::Int32
    remaining::Int32
end

struct ecs_worker_iter_t
    index::Int32
    count::Int32
end

struct ecs_table_cache_iter_t
    cur::Ptr{ecs_table_cache_hdr_t}
    next::Ptr{ecs_table_cache_hdr_t}
    next_list::Ptr{ecs_table_cache_hdr_t}
end

struct ecs_each_iter_t
    it::ecs_table_cache_iter_t
    ids::ecs_id_t
    sources::ecs_entity_t
    sizes::ecs_size_t
    columns::Int32
    trs::Ptr{ecs_table_record_t}
end

struct ecs_query_op_profile_t
    count::NTuple{2, Int32}
end

mutable struct ecs_query_var_t end

mutable struct ecs_query_op_t end

mutable struct ecs_query_op_ctx_t end

struct ecs_query_iter_t
    query::Ptr{ecs_query_t}
    vars::Ptr{ecs_var_t}
    query_vars::Ptr{ecs_query_var_t}
    ops::Ptr{ecs_query_op_t}
    op_ctx::Ptr{ecs_query_op_ctx_t}
    node::Ptr{ecs_query_cache_table_match_t}
    prev::Ptr{ecs_query_cache_table_match_t}
    last::Ptr{ecs_query_cache_table_match_t}
    written::Ptr{UInt64}
    skip_count::Int32
    profile::Ptr{ecs_query_op_profile_t}
    op::Int16
    sp::Int16
end

function flecs_module_path_from_c(c_name)
    ccall((:flecs_module_path_from_c, libflecs), Ptr{Cchar}, (Ptr{Cchar},), c_name)
end

function flecs_identifier_is_0(id)
    ccall((:flecs_identifier_is_0, libflecs), Bool, (Ptr{Cchar},), id)
end

function flecs_default_ctor(ptr, count, ctx)
    ccall((:flecs_default_ctor, libflecs), Cvoid, (Ptr{Cvoid}, Int32, Ptr{ecs_type_info_t}), ptr, count, ctx)
end

function flecs_chresc(out, in, delimiter)
    ccall((:flecs_chresc, libflecs), Ptr{Cchar}, (Ptr{Cchar}, Cchar, Cchar), out, in, delimiter)
end

function flecs_chrparse(in, out)
    ccall((:flecs_chrparse, libflecs), Ptr{Cchar}, (Ptr{Cchar}, Ptr{Cchar}), in, out)
end

function flecs_stresc(out, size, delimiter, in)
    ccall((:flecs_stresc, libflecs), ecs_size_t, (Ptr{Cchar}, ecs_size_t, Cchar, Ptr{Cchar}), out, size, delimiter, in)
end

function flecs_astresc(delimiter, in)
    ccall((:flecs_astresc, libflecs), Ptr{Cchar}, (Cchar, Ptr{Cchar}), delimiter, in)
end

function flecs_parse_ws_eol(ptr)
    ccall((:flecs_parse_ws_eol, libflecs), Ptr{Cchar}, (Ptr{Cchar},), ptr)
end

function flecs_parse_digit(ptr, token)
    ccall((:flecs_parse_digit, libflecs), Ptr{Cchar}, (Ptr{Cchar}, Ptr{Cchar}), ptr, token)
end

function flecs_to_snake_case(str)
    ccall((:flecs_to_snake_case, libflecs), Ptr{Cchar}, (Ptr{Cchar},), str)
end

function flecs_table_observed_count(table)
    ccall((:flecs_table_observed_count, libflecs), Int32, (Ptr{ecs_table_t},), table)
end

function flecs_dump_backtrace(stream)
    ccall((:flecs_dump_backtrace, libflecs), Cvoid, (Ptr{Cvoid},), stream)
end

struct ecs_suspend_readonly_state_t
    is_readonly::Bool
    is_deferred::Bool
    defer_count::Int32
    scope::ecs_entity_t
    with::ecs_entity_t
    commands::ecs_vec_t
    defer_stack::ecs_stack_t
    stage::Ptr{ecs_stage_t}
end

function flecs_suspend_readonly(world, state)
    ccall((:flecs_suspend_readonly, libflecs), Ptr{ecs_world_t}, (Ptr{ecs_world_t}, Ptr{ecs_suspend_readonly_state_t}), world, state)
end

function flecs_resume_readonly(world, state)
    ccall((:flecs_resume_readonly, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_suspend_readonly_state_t}), world, state)
end

function flecs_poly_refcount(poly)
    ccall((:flecs_poly_refcount, libflecs), Int32, (Ptr{ecs_poly_t},), poly)
end

function flecs_hashmap_fini(map)
    ccall((:flecs_hashmap_fini, libflecs), Cvoid, (Ptr{ecs_hashmap_t},), map)
end

function flecs_hashmap_get_bucket(map, hash)
    ccall((:flecs_hashmap_get_bucket, libflecs), Ptr{ecs_hm_bucket_t}, (Ptr{ecs_hashmap_t}, UInt64), map, hash)
end

function flecs_hm_bucket_remove(map, bucket, hash, index)
    ccall((:flecs_hm_bucket_remove, libflecs), Cvoid, (Ptr{ecs_hashmap_t}, Ptr{ecs_hm_bucket_t}, UInt64, Int32), map, bucket, hash, index)
end

function flecs_hashmap_copy(dst, src)
    ccall((:flecs_hashmap_copy, libflecs), Cvoid, (Ptr{ecs_hashmap_t}, Ptr{ecs_hashmap_t}), dst, src)
end

function flecs_hashmap_iter(map)
    ccall((:flecs_hashmap_iter, libflecs), flecs_hashmap_iter_t, (Ptr{ecs_hashmap_t},), map)
end

struct ecs_bulk_desc_t
    _canary::Int32
    entities::Ptr{ecs_entity_t}
    count::Int32
    ids::NTuple{32, ecs_id_t}
    data::Ptr{Ptr{Cvoid}}
    table::Ptr{ecs_table_t}
end

struct ecs_event_desc_t
    event::ecs_entity_t
    ids::Ptr{ecs_type_t}
    table::Ptr{ecs_table_t}
    other_table::Ptr{ecs_table_t}
    offset::Int32
    count::Int32
    entity::ecs_entity_t
    param::Ptr{Cvoid}
    const_param::Ptr{Cvoid}
    observable::Ptr{ecs_poly_t}
    flags::ecs_flags32_t
end

struct ecs_build_info_t
    compiler::Ptr{Cchar}
    addons::Ptr{Ptr{Cchar}}
    version::Ptr{Cchar}
    version_major::Int16
    version_minor::Int16
    version_patch::Int16
    debug::Bool
    sanitize::Bool
    perf_trace::Bool
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs.h:1403:5)"
    add_count::Int64
    remove_count::Int64
    delete_count::Int64
    clear_count::Int64
    set_count::Int64
    ensure_count::Int64
    modified_count::Int64
    discard_count::Int64
    event_count::Int64
    other_count::Int64
    batched_entity_count::Int64
    batched_command_count::Int64
end

struct ecs_world_info_t
    data::NTuple{296, UInt8}
end

function Base.getproperty(x::Ptr{ecs_world_info_t}, f::Symbol)
    f === :last_component_id && return Ptr{ecs_entity_t}(x + 0)
    f === :min_id && return Ptr{ecs_entity_t}(x + 8)
    f === :max_id && return Ptr{ecs_entity_t}(x + 16)
    f === :delta_time_raw && return Ptr{Cfloat}(x + 24)
    f === :delta_time && return Ptr{Cfloat}(x + 28)
    f === :time_scale && return Ptr{Cfloat}(x + 32)
    f === :target_fps && return Ptr{Cfloat}(x + 36)
    f === :frame_time_total && return Ptr{Cfloat}(x + 40)
    f === :system_time_total && return Ptr{Cfloat}(x + 44)
    f === :emit_time_total && return Ptr{Cfloat}(x + 48)
    f === :merge_time_total && return Ptr{Cfloat}(x + 52)
    f === :rematch_time_total && return Ptr{Cfloat}(x + 56)
    f === :world_time_total && return Ptr{Cdouble}(x + 64)
    f === :world_time_total_raw && return Ptr{Cdouble}(x + 72)
    f === :frame_count_total && return Ptr{Int64}(x + 80)
    f === :merge_count_total && return Ptr{Int64}(x + 88)
    f === :eval_comp_monitors_total && return Ptr{Int64}(x + 96)
    f === :rematch_count_total && return Ptr{Int64}(x + 104)
    f === :id_create_total && return Ptr{Int64}(x + 112)
    f === :id_delete_total && return Ptr{Int64}(x + 120)
    f === :table_create_total && return Ptr{Int64}(x + 128)
    f === :table_delete_total && return Ptr{Int64}(x + 136)
    f === :pipeline_build_count_total && return Ptr{Int64}(x + 144)
    f === :systems_ran_frame && return Ptr{Int64}(x + 152)
    f === :observers_ran_frame && return Ptr{Int64}(x + 160)
    f === :tag_id_count && return Ptr{Int32}(x + 168)
    f === :component_id_count && return Ptr{Int32}(x + 172)
    f === :pair_id_count && return Ptr{Int32}(x + 176)
    f === :table_count && return Ptr{Int32}(x + 180)
    f === :empty_table_count && return Ptr{Int32}(x + 184)
    f === :cmd && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs.h:1403:5)"}(x + 192)
    f === :name_prefix && return Ptr{Ptr{Cchar}}(x + 288)
    return getfield(x, f)
end

function Base.getproperty(x::ecs_world_info_t, f::Symbol)
    r = Ref{ecs_world_info_t}(x)
    ptr = Base.unsafe_convert(Ptr{ecs_world_info_t}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{ecs_world_info_t}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct ecs_query_group_info_t
    match_count::Int32
    table_count::Int32
    ctx::Ptr{Cvoid}
end

struct EcsIdentifier
    value::Ptr{Cchar}
    length::ecs_size_t
    hash::UInt64
    index_hash::UInt64
    index::Ptr{ecs_hashmap_t}
end

struct EcsComponent
    size::ecs_size_t
    alignment::ecs_size_t
end

struct EcsDefaultChildComponent
    component::ecs_id_t
end

function ecs_init()
    ccall((:ecs_init, libflecs), Ptr{ecs_world_t}, ())
end

function ecs_mini()
    ccall((:ecs_mini, libflecs), Ptr{ecs_world_t}, ())
end

function ecs_init_w_args(argc, argv)
    ccall((:ecs_init_w_args, libflecs), Ptr{ecs_world_t}, (Cint, Ptr{Ptr{Cchar}}), argc, argv)
end

function ecs_fini(world)
    ccall((:ecs_fini, libflecs), Cint, (Ptr{ecs_world_t},), world)
end

function ecs_is_fini(world)
    ccall((:ecs_is_fini, libflecs), Bool, (Ptr{ecs_world_t},), world)
end

function ecs_atfini(world, action, ctx)
    ccall((:ecs_atfini, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_fini_action_t, Ptr{Cvoid}), world, action, ctx)
end

struct ecs_entities_t
    ids::Ptr{ecs_entity_t}
    count::Int32
    alive_count::Int32
end

function ecs_get_entities(world)
    ccall((:ecs_get_entities, libflecs), ecs_entities_t, (Ptr{ecs_world_t},), world)
end

function ecs_world_get_flags(world)
    ccall((:ecs_world_get_flags, libflecs), ecs_flags32_t, (Ptr{ecs_world_t},), world)
end

function ecs_frame_begin(world, delta_time)
    ccall((:ecs_frame_begin, libflecs), Cfloat, (Ptr{ecs_world_t}, Cfloat), world, delta_time)
end

function ecs_frame_end(world)
    ccall((:ecs_frame_end, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_run_post_frame(world, action, ctx)
    ccall((:ecs_run_post_frame, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_fini_action_t, Ptr{Cvoid}), world, action, ctx)
end

function ecs_quit(world)
    ccall((:ecs_quit, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_should_quit(world)
    ccall((:ecs_should_quit, libflecs), Bool, (Ptr{ecs_world_t},), world)
end

function ecs_measure_frame_time(world, enable)
    ccall((:ecs_measure_frame_time, libflecs), Cvoid, (Ptr{ecs_world_t}, Bool), world, enable)
end

function ecs_measure_system_time(world, enable)
    ccall((:ecs_measure_system_time, libflecs), Cvoid, (Ptr{ecs_world_t}, Bool), world, enable)
end

function ecs_set_target_fps(world, fps)
    ccall((:ecs_set_target_fps, libflecs), Cvoid, (Ptr{ecs_world_t}, Cfloat), world, fps)
end

function ecs_set_default_query_flags(world, flags)
    ccall((:ecs_set_default_query_flags, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_flags32_t), world, flags)
end

function ecs_readonly_begin(world, multi_threaded)
    ccall((:ecs_readonly_begin, libflecs), Bool, (Ptr{ecs_world_t}, Bool), world, multi_threaded)
end

function ecs_readonly_end(world)
    ccall((:ecs_readonly_end, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_merge(world)
    ccall((:ecs_merge, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_defer_begin(world)
    ccall((:ecs_defer_begin, libflecs), Bool, (Ptr{ecs_world_t},), world)
end

function ecs_is_deferred(world)
    ccall((:ecs_is_deferred, libflecs), Bool, (Ptr{ecs_world_t},), world)
end

function ecs_defer_end(world)
    ccall((:ecs_defer_end, libflecs), Bool, (Ptr{ecs_world_t},), world)
end

function ecs_defer_suspend(world)
    ccall((:ecs_defer_suspend, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_defer_resume(world)
    ccall((:ecs_defer_resume, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_set_stage_count(world, stages)
    ccall((:ecs_set_stage_count, libflecs), Cvoid, (Ptr{ecs_world_t}, Int32), world, stages)
end

function ecs_get_stage_count(world)
    ccall((:ecs_get_stage_count, libflecs), Int32, (Ptr{ecs_world_t},), world)
end

function ecs_get_stage(world, stage_id)
    ccall((:ecs_get_stage, libflecs), Ptr{ecs_world_t}, (Ptr{ecs_world_t}, Int32), world, stage_id)
end

function ecs_stage_is_readonly(world)
    ccall((:ecs_stage_is_readonly, libflecs), Bool, (Ptr{ecs_world_t},), world)
end

function ecs_stage_new(world)
    ccall((:ecs_stage_new, libflecs), Ptr{ecs_world_t}, (Ptr{ecs_world_t},), world)
end

function ecs_stage_free(stage)
    ccall((:ecs_stage_free, libflecs), Cvoid, (Ptr{ecs_world_t},), stage)
end

function ecs_stage_get_id(world)
    ccall((:ecs_stage_get_id, libflecs), Int32, (Ptr{ecs_world_t},), world)
end

function ecs_set_ctx(world, ctx, ctx_free)
    ccall((:ecs_set_ctx, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{Cvoid}, ecs_ctx_free_t), world, ctx, ctx_free)
end

function ecs_set_binding_ctx(world, ctx, ctx_free)
    ccall((:ecs_set_binding_ctx, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{Cvoid}, ecs_ctx_free_t), world, ctx, ctx_free)
end

function ecs_get_ctx(world)
    ccall((:ecs_get_ctx, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t},), world)
end

function ecs_get_binding_ctx(world)
    ccall((:ecs_get_binding_ctx, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t},), world)
end

function ecs_get_build_info()
    ccall((:ecs_get_build_info, libflecs), Ptr{ecs_build_info_t}, ())
end

function ecs_get_world_info(world)
    ccall((:ecs_get_world_info, libflecs), Ptr{ecs_world_info_t}, (Ptr{ecs_world_t},), world)
end

function ecs_dim(world, entity_count)
    ccall((:ecs_dim, libflecs), Cvoid, (Ptr{ecs_world_t}, Int32), world, entity_count)
end

function ecs_set_entity_range(world, id_start, id_end)
    ccall((:ecs_set_entity_range, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t), world, id_start, id_end)
end

function ecs_enable_range_check(world, enable)
    ccall((:ecs_enable_range_check, libflecs), Bool, (Ptr{ecs_world_t}, Bool), world, enable)
end

function ecs_get_max_id(world)
    ccall((:ecs_get_max_id, libflecs), ecs_entity_t, (Ptr{ecs_world_t},), world)
end

function ecs_run_aperiodic(world, flags)
    ccall((:ecs_run_aperiodic, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_flags32_t), world, flags)
end

function ecs_delete_empty_tables(world, id, clear_generation, delete_generation, min_id_count, time_budget_seconds)
    ccall((:ecs_delete_empty_tables, libflecs), Int32, (Ptr{ecs_world_t}, ecs_id_t, UInt16, UInt16, Int32, Cdouble), world, id, clear_generation, delete_generation, min_id_count, time_budget_seconds)
end

function ecs_get_world(poly)
    ccall((:ecs_get_world, libflecs), Ptr{ecs_world_t}, (Ptr{ecs_poly_t},), poly)
end

function ecs_get_entity(poly)
    ccall((:ecs_get_entity, libflecs), ecs_entity_t, (Ptr{ecs_poly_t},), poly)
end

function ecs_make_pair(first, second)
    ccall((:ecs_make_pair, libflecs), ecs_id_t, (ecs_entity_t, ecs_entity_t), first, second)
end

function ecs_new(world)
    ccall((:ecs_new, libflecs), ecs_entity_t, (Ptr{ecs_world_t},), world)
end

function ecs_new_low_id(world)
    ccall((:ecs_new_low_id, libflecs), ecs_entity_t, (Ptr{ecs_world_t},), world)
end

function ecs_new_w_table(world, table)
    ccall((:ecs_new_w_table, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{ecs_table_t}), world, table)
end

function ecs_bulk_init(world, desc)
    ccall((:ecs_bulk_init, libflecs), Ptr{ecs_entity_t}, (Ptr{ecs_world_t}, Ptr{ecs_bulk_desc_t}), world, desc)
end

function ecs_clone(world, dst, src, copy_value)
    ccall((:ecs_clone, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t, Bool), world, dst, src, copy_value)
end

function ecs_delete(world, entity)
    ccall((:ecs_delete, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_delete_with(world, id)
    ccall((:ecs_delete_with, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_clear(world, entity)
    ccall((:ecs_clear, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_remove_all(world, id)
    ccall((:ecs_remove_all, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_set_with(world, id)
    ccall((:ecs_set_with, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_get_with(world)
    ccall((:ecs_get_with, libflecs), ecs_id_t, (Ptr{ecs_world_t},), world)
end

function ecs_enable(world, entity, enabled)
    ccall((:ecs_enable, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Bool), world, entity, enabled)
end

function ecs_ensure_modified_id(world, entity, id)
    ccall((:ecs_ensure_modified_id, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, ecs_entity_t, ecs_id_t), world, entity, id)
end

function ecs_ref_update(world, ref)
    ccall((:ecs_ref_update, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_ref_t}), world, ref)
end

function ecs_record_find(world, entity)
    ccall((:ecs_record_find, libflecs), Ptr{ecs_record_t}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_write_begin(world, entity)
    ccall((:ecs_write_begin, libflecs), Ptr{ecs_record_t}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_write_end(record)
    ccall((:ecs_write_end, libflecs), Cvoid, (Ptr{ecs_record_t},), record)
end

function ecs_read_begin(world, entity)
    ccall((:ecs_read_begin, libflecs), Ptr{ecs_record_t}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_read_end(record)
    ccall((:ecs_read_end, libflecs), Cvoid, (Ptr{ecs_record_t},), record)
end

function ecs_record_get_entity(record)
    ccall((:ecs_record_get_entity, libflecs), ecs_entity_t, (Ptr{ecs_record_t},), record)
end

function ecs_record_get_by_column(record, column, size)
    ccall((:ecs_record_get_by_column, libflecs), Ptr{Cvoid}, (Ptr{ecs_record_t}, Int32, Csize_t), record, column, size)
end

function ecs_is_valid(world, e)
    ccall((:ecs_is_valid, libflecs), Bool, (Ptr{ecs_world_t}, ecs_entity_t), world, e)
end

function ecs_is_alive(world, e)
    ccall((:ecs_is_alive, libflecs), Bool, (Ptr{ecs_world_t}, ecs_entity_t), world, e)
end

function ecs_strip_generation(e)
    ccall((:ecs_strip_generation, libflecs), ecs_id_t, (ecs_entity_t,), e)
end

function ecs_make_alive(world, entity)
    ccall((:ecs_make_alive, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_make_alive_id(world, id)
    ccall((:ecs_make_alive_id, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_exists(world, entity)
    ccall((:ecs_exists, libflecs), Bool, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_set_version(world, entity)
    ccall((:ecs_set_version, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_get_type(world, entity)
    ccall((:ecs_get_type, libflecs), Ptr{ecs_type_t}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_type_str(world, type)
    ccall((:ecs_type_str, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{ecs_type_t}), world, type)
end

function ecs_table_str(world, table)
    ccall((:ecs_table_str, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{ecs_table_t}), world, table)
end

function ecs_entity_str(world, entity)
    ccall((:ecs_entity_str, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_get_target(world, entity, rel, index)
    ccall((:ecs_get_target, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t, Int32), world, entity, rel, index)
end

function ecs_get_parent(world, entity)
    ccall((:ecs_get_parent, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_get_depth(world, entity, rel)
    ccall((:ecs_get_depth, libflecs), Int32, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t), world, entity, rel)
end

function ecs_get_name(world, entity)
    ccall((:ecs_get_name, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_get_symbol(world, entity)
    ccall((:ecs_get_symbol, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_set_name(world, entity, name)
    ccall((:ecs_set_name, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, entity, name)
end

function ecs_set_symbol(world, entity, symbol)
    ccall((:ecs_set_symbol, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, entity, symbol)
end

function ecs_set_alias(world, entity, alias)
    ccall((:ecs_set_alias, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, entity, alias)
end

function ecs_lookup(world, path)
    ccall((:ecs_lookup, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{Cchar}), world, path)
end

function ecs_lookup_child(world, parent, name)
    ccall((:ecs_lookup_child, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, parent, name)
end

function ecs_lookup_symbol(world, symbol, lookup_as_path, recursive)
    ccall((:ecs_lookup_symbol, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{Cchar}, Bool, Bool), world, symbol, lookup_as_path, recursive)
end

function ecs_get_scope(world)
    ccall((:ecs_get_scope, libflecs), ecs_entity_t, (Ptr{ecs_world_t},), world)
end

function ecs_set_name_prefix(world, prefix)
    ccall((:ecs_set_name_prefix, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{Cchar}), world, prefix)
end

function ecs_set_lookup_path(world, lookup_path)
    ccall((:ecs_set_lookup_path, libflecs), Ptr{ecs_entity_t}, (Ptr{ecs_world_t}, Ptr{ecs_entity_t}), world, lookup_path)
end

function ecs_get_lookup_path(world)
    ccall((:ecs_get_lookup_path, libflecs), Ptr{ecs_entity_t}, (Ptr{ecs_world_t},), world)
end

function ecs_get_type_info(world, id)
    ccall((:ecs_get_type_info, libflecs), Ptr{ecs_type_info_t}, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_id_is_tag(world, id)
    ccall((:ecs_id_is_tag, libflecs), Bool, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_id_in_use(world, id)
    ccall((:ecs_id_in_use, libflecs), Bool, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_get_typeid(world, id)
    ccall((:ecs_get_typeid, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_id_match(id, pattern)
    ccall((:ecs_id_match, libflecs), Bool, (ecs_id_t, ecs_id_t), id, pattern)
end

function ecs_id_is_pair(id)
    ccall((:ecs_id_is_pair, libflecs), Bool, (ecs_id_t,), id)
end

function ecs_id_is_wildcard(id)
    ccall((:ecs_id_is_wildcard, libflecs), Bool, (ecs_id_t,), id)
end

function ecs_id_is_valid(world, id)
    ccall((:ecs_id_is_valid, libflecs), Bool, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_id_get_flags(world, id)
    ccall((:ecs_id_get_flags, libflecs), ecs_flags32_t, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_id_flag_str(id_flags)
    ccall((:ecs_id_flag_str, libflecs), Ptr{Cchar}, (ecs_id_t,), id_flags)
end

function ecs_id_str(world, id)
    ccall((:ecs_id_str, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_id_t), world, id)
end

function ecs_id_str_buf(world, id, buf)
    ccall((:ecs_id_str_buf, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_id_t, Ptr{ecs_strbuf_t}), world, id, buf)
end

function ecs_id_from_str(world, expr)
    ccall((:ecs_id_from_str, libflecs), ecs_id_t, (Ptr{ecs_world_t}, Ptr{Cchar}), world, expr)
end

function ecs_term_ref_is_set(id)
    ccall((:ecs_term_ref_is_set, libflecs), Bool, (Ptr{ecs_term_ref_t},), id)
end

function ecs_term_is_initialized(term)
    ccall((:ecs_term_is_initialized, libflecs), Bool, (Ptr{ecs_term_t},), term)
end

function ecs_term_match_this(term)
    ccall((:ecs_term_match_this, libflecs), Bool, (Ptr{ecs_term_t},), term)
end

function ecs_term_match_0(term)
    ccall((:ecs_term_match_0, libflecs), Bool, (Ptr{ecs_term_t},), term)
end

function ecs_term_str(world, term)
    ccall((:ecs_term_str, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{ecs_term_t}), world, term)
end

function ecs_query_str(query)
    ccall((:ecs_query_str, libflecs), Ptr{Cchar}, (Ptr{ecs_query_t},), query)
end

function ecs_each_next(it)
    ccall((:ecs_each_next, libflecs), Bool, (Ptr{ecs_iter_t},), it)
end

function ecs_children(world, parent)
    ccall((:ecs_children, libflecs), ecs_iter_t, (Ptr{ecs_world_t}, ecs_entity_t), world, parent)
end

function ecs_children_next(it)
    ccall((:ecs_children_next, libflecs), Bool, (Ptr{ecs_iter_t},), it)
end

function ecs_query_fini(query)
    ccall((:ecs_query_fini, libflecs), Cvoid, (Ptr{ecs_query_t},), query)
end

function ecs_query_find_var(query, name)
    ccall((:ecs_query_find_var, libflecs), Int32, (Ptr{ecs_query_t}, Ptr{Cchar}), query, name)
end

function ecs_query_var_name(query, var_id)
    ccall((:ecs_query_var_name, libflecs), Ptr{Cchar}, (Ptr{ecs_query_t}, Int32), query, var_id)
end

function ecs_query_var_is_entity(query, var_id)
    ccall((:ecs_query_var_is_entity, libflecs), Bool, (Ptr{ecs_query_t}, Int32), query, var_id)
end

function ecs_query_iter(world, query)
    ccall((:ecs_query_iter, libflecs), ecs_iter_t, (Ptr{ecs_world_t}, Ptr{ecs_query_t}), world, query)
end

function ecs_query_next(it)
    ccall((:ecs_query_next, libflecs), Bool, (Ptr{ecs_iter_t},), it)
end

function ecs_query_has(query, entity, it)
    ccall((:ecs_query_has, libflecs), Bool, (Ptr{ecs_query_t}, ecs_entity_t, Ptr{ecs_iter_t}), query, entity, it)
end

function ecs_query_has_table(query, table, it)
    ccall((:ecs_query_has_table, libflecs), Bool, (Ptr{ecs_query_t}, Ptr{ecs_table_t}, Ptr{ecs_iter_t}), query, table, it)
end

function ecs_query_has_range(query, range, it)
    ccall((:ecs_query_has_range, libflecs), Bool, (Ptr{ecs_query_t}, Ptr{ecs_table_range_t}, Ptr{ecs_iter_t}), query, range, it)
end

function ecs_query_match_count(query)
    ccall((:ecs_query_match_count, libflecs), Int32, (Ptr{ecs_query_t},), query)
end

function ecs_query_plan(query)
    ccall((:ecs_query_plan, libflecs), Ptr{Cchar}, (Ptr{ecs_query_t},), query)
end

function ecs_query_plan_w_profile(query, it)
    ccall((:ecs_query_plan_w_profile, libflecs), Ptr{Cchar}, (Ptr{ecs_query_t}, Ptr{ecs_iter_t}), query, it)
end

function ecs_query_args_parse(query, it, expr)
    ccall((:ecs_query_args_parse, libflecs), Ptr{Cchar}, (Ptr{ecs_query_t}, Ptr{ecs_iter_t}, Ptr{Cchar}), query, it, expr)
end

function ecs_query_changed(query)
    ccall((:ecs_query_changed, libflecs), Bool, (Ptr{ecs_query_t},), query)
end

function ecs_iter_skip(it)
    ccall((:ecs_iter_skip, libflecs), Cvoid, (Ptr{ecs_iter_t},), it)
end

function ecs_iter_set_group(it, group_id)
    ccall((:ecs_iter_set_group, libflecs), Cvoid, (Ptr{ecs_iter_t}, UInt64), it, group_id)
end

function ecs_query_get_group_ctx(query, group_id)
    ccall((:ecs_query_get_group_ctx, libflecs), Ptr{Cvoid}, (Ptr{ecs_query_t}, UInt64), query, group_id)
end

function ecs_query_get_group_info(query, group_id)
    ccall((:ecs_query_get_group_info, libflecs), Ptr{ecs_query_group_info_t}, (Ptr{ecs_query_t}, UInt64), query, group_id)
end

struct ecs_query_count_t
    results::Int32
    entities::Int32
    tables::Int32
    empty_tables::Int32
end

function ecs_query_count(query)
    ccall((:ecs_query_count, libflecs), ecs_query_count_t, (Ptr{ecs_query_t},), query)
end

function ecs_query_is_true(query)
    ccall((:ecs_query_is_true, libflecs), Bool, (Ptr{ecs_query_t},), query)
end

function ecs_query_get_cache_query(query)
    ccall((:ecs_query_get_cache_query, libflecs), Ptr{ecs_query_t}, (Ptr{ecs_query_t},), query)
end

function ecs_emit(world, desc)
    ccall((:ecs_emit, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_event_desc_t}), world, desc)
end

function ecs_enqueue(world, desc)
    ccall((:ecs_enqueue, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_event_desc_t}), world, desc)
end

function ecs_observer_get(world, observer)
    ccall((:ecs_observer_get, libflecs), Ptr{ecs_observer_t}, (Ptr{ecs_world_t}, ecs_entity_t), world, observer)
end

function ecs_iter_next(it)
    ccall((:ecs_iter_next, libflecs), Bool, (Ptr{ecs_iter_t},), it)
end

function ecs_iter_fini(it)
    ccall((:ecs_iter_fini, libflecs), Cvoid, (Ptr{ecs_iter_t},), it)
end

function ecs_iter_count(it)
    ccall((:ecs_iter_count, libflecs), Int32, (Ptr{ecs_iter_t},), it)
end

function ecs_iter_is_true(it)
    ccall((:ecs_iter_is_true, libflecs), Bool, (Ptr{ecs_iter_t},), it)
end

function ecs_iter_first(it)
    ccall((:ecs_iter_first, libflecs), ecs_entity_t, (Ptr{ecs_iter_t},), it)
end

function ecs_iter_set_var(it, var_id, entity)
    ccall((:ecs_iter_set_var, libflecs), Cvoid, (Ptr{ecs_iter_t}, Int32, ecs_entity_t), it, var_id, entity)
end

function ecs_iter_set_var_as_table(it, var_id, table)
    ccall((:ecs_iter_set_var_as_table, libflecs), Cvoid, (Ptr{ecs_iter_t}, Int32, Ptr{ecs_table_t}), it, var_id, table)
end

function ecs_iter_set_var_as_range(it, var_id, range)
    ccall((:ecs_iter_set_var_as_range, libflecs), Cvoid, (Ptr{ecs_iter_t}, Int32, Ptr{ecs_table_range_t}), it, var_id, range)
end

function ecs_iter_get_var(it, var_id)
    ccall((:ecs_iter_get_var, libflecs), ecs_entity_t, (Ptr{ecs_iter_t}, Int32), it, var_id)
end

function ecs_iter_get_var_as_table(it, var_id)
    ccall((:ecs_iter_get_var_as_table, libflecs), Ptr{ecs_table_t}, (Ptr{ecs_iter_t}, Int32), it, var_id)
end

function ecs_iter_get_var_as_range(it, var_id)
    ccall((:ecs_iter_get_var_as_range, libflecs), ecs_table_range_t, (Ptr{ecs_iter_t}, Int32), it, var_id)
end

function ecs_iter_var_is_constrained(it, var_id)
    ccall((:ecs_iter_var_is_constrained, libflecs), Bool, (Ptr{ecs_iter_t}, Int32), it, var_id)
end

function ecs_iter_changed(it)
    ccall((:ecs_iter_changed, libflecs), Bool, (Ptr{ecs_iter_t},), it)
end

function ecs_iter_str(it)
    ccall((:ecs_iter_str, libflecs), Ptr{Cchar}, (Ptr{ecs_iter_t},), it)
end

function ecs_page_iter(it, offset, limit)
    ccall((:ecs_page_iter, libflecs), ecs_iter_t, (Ptr{ecs_iter_t}, Int32, Int32), it, offset, limit)
end

function ecs_page_next(it)
    ccall((:ecs_page_next, libflecs), Bool, (Ptr{ecs_iter_t},), it)
end

function ecs_worker_iter(it, index, count)
    ccall((:ecs_worker_iter, libflecs), ecs_iter_t, (Ptr{ecs_iter_t}, Int32, Int32), it, index, count)
end

function ecs_worker_next(it)
    ccall((:ecs_worker_next, libflecs), Bool, (Ptr{ecs_iter_t},), it)
end

function ecs_field_is_readonly(it, index)
    ccall((:ecs_field_is_readonly, libflecs), Bool, (Ptr{ecs_iter_t}, Int8), it, index)
end

function ecs_field_is_writeonly(it, index)
    ccall((:ecs_field_is_writeonly, libflecs), Bool, (Ptr{ecs_iter_t}, Int8), it, index)
end

function ecs_field_is_set(it, index)
    ccall((:ecs_field_is_set, libflecs), Bool, (Ptr{ecs_iter_t}, Int8), it, index)
end

function ecs_field_id(it, index)
    ccall((:ecs_field_id, libflecs), ecs_id_t, (Ptr{ecs_iter_t}, Int8), it, index)
end

function ecs_field_column(it, index)
    ccall((:ecs_field_column, libflecs), Int32, (Ptr{ecs_iter_t}, Int8), it, index)
end

function ecs_field_src(it, index)
    ccall((:ecs_field_src, libflecs), ecs_entity_t, (Ptr{ecs_iter_t}, Int8), it, index)
end

function ecs_field_size(it, index)
    ccall((:ecs_field_size, libflecs), Csize_t, (Ptr{ecs_iter_t}, Int8), it, index)
end

function ecs_field_is_self(it, index)
    ccall((:ecs_field_is_self, libflecs), Bool, (Ptr{ecs_iter_t}, Int8), it, index)
end

function ecs_table_get_type(table)
    ccall((:ecs_table_get_type, libflecs), Ptr{ecs_type_t}, (Ptr{ecs_table_t},), table)
end

function ecs_table_get_type_index(world, table, id)
    ccall((:ecs_table_get_type_index, libflecs), Int32, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, ecs_id_t), world, table, id)
end

function ecs_table_get_column_index(world, table, id)
    ccall((:ecs_table_get_column_index, libflecs), Int32, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, ecs_id_t), world, table, id)
end

function ecs_table_column_count(table)
    ccall((:ecs_table_column_count, libflecs), Int32, (Ptr{ecs_table_t},), table)
end

function ecs_table_type_to_column_index(table, index)
    ccall((:ecs_table_type_to_column_index, libflecs), Int32, (Ptr{ecs_table_t}, Int32), table, index)
end

function ecs_table_column_to_type_index(table, index)
    ccall((:ecs_table_column_to_type_index, libflecs), Int32, (Ptr{ecs_table_t}, Int32), table, index)
end

function ecs_table_get_column(table, index, offset)
    ccall((:ecs_table_get_column, libflecs), Ptr{Cvoid}, (Ptr{ecs_table_t}, Int32, Int32), table, index, offset)
end

function ecs_table_get_column_size(table, index)
    ccall((:ecs_table_get_column_size, libflecs), Csize_t, (Ptr{ecs_table_t}, Int32), table, index)
end

function ecs_table_count(table)
    ccall((:ecs_table_count, libflecs), Int32, (Ptr{ecs_table_t},), table)
end

function ecs_table_size(table)
    ccall((:ecs_table_size, libflecs), Int32, (Ptr{ecs_table_t},), table)
end

function ecs_table_entities(table)
    ccall((:ecs_table_entities, libflecs), Ptr{ecs_entity_t}, (Ptr{ecs_table_t},), table)
end

function ecs_table_has_id(world, table, id)
    ccall((:ecs_table_has_id, libflecs), Bool, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, ecs_id_t), world, table, id)
end

function ecs_table_get_depth(world, table, rel)
    ccall((:ecs_table_get_depth, libflecs), Int32, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, ecs_entity_t), world, table, rel)
end

function ecs_table_add_id(world, table, id)
    ccall((:ecs_table_add_id, libflecs), Ptr{ecs_table_t}, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, ecs_id_t), world, table, id)
end

function ecs_table_find(world, ids, id_count)
    ccall((:ecs_table_find, libflecs), Ptr{ecs_table_t}, (Ptr{ecs_world_t}, Ptr{ecs_id_t}, Int32), world, ids, id_count)
end

function ecs_table_remove_id(world, table, id)
    ccall((:ecs_table_remove_id, libflecs), Ptr{ecs_table_t}, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, ecs_id_t), world, table, id)
end

function ecs_table_has_flags(table, flags)
    ccall((:ecs_table_has_flags, libflecs), Bool, (Ptr{ecs_table_t}, ecs_flags32_t), table, flags)
end

function ecs_commit(world, entity, record, table, added, removed)
    ccall((:ecs_commit, libflecs), Bool, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{ecs_record_t}, Ptr{ecs_table_t}, Ptr{ecs_type_t}, Ptr{ecs_type_t}), world, entity, record, table, added, removed)
end

function ecs_search(world, table, id, id_out)
    ccall((:ecs_search, libflecs), Int32, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, ecs_id_t, Ptr{ecs_id_t}), world, table, id, id_out)
end

function ecs_search_offset(world, table, offset, id, id_out)
    ccall((:ecs_search_offset, libflecs), Int32, (Ptr{ecs_world_t}, Ptr{ecs_table_t}, Int32, ecs_id_t, Ptr{ecs_id_t}), world, table, offset, id, id_out)
end

function ecs_table_clear_entities(world, table)
    ccall((:ecs_table_clear_entities, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_table_t}), world, table)
end

function ecs_value_init(world, type, ptr)
    ccall((:ecs_value_init, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}), world, type, ptr)
end

function ecs_value_init_w_type_info(world, ti, ptr)
    ccall((:ecs_value_init_w_type_info, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{ecs_type_info_t}, Ptr{Cvoid}), world, ti, ptr)
end

function ecs_value_new_w_type_info(world, ti)
    ccall((:ecs_value_new_w_type_info, libflecs), Ptr{Cvoid}, (Ptr{ecs_world_t}, Ptr{ecs_type_info_t}), world, ti)
end

function ecs_value_fini_w_type_info(world, ti, ptr)
    ccall((:ecs_value_fini_w_type_info, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{ecs_type_info_t}, Ptr{Cvoid}), world, ti, ptr)
end

function ecs_value_fini(world, type, ptr)
    ccall((:ecs_value_fini, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}), world, type, ptr)
end

function ecs_value_free(world, type, ptr)
    ccall((:ecs_value_free, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}), world, type, ptr)
end

function ecs_value_copy_w_type_info(world, ti, dst, src)
    ccall((:ecs_value_copy_w_type_info, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{ecs_type_info_t}, Ptr{Cvoid}, Ptr{Cvoid}), world, ti, dst, src)
end

function ecs_value_copy(world, type, dst, src)
    ccall((:ecs_value_copy, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}, Ptr{Cvoid}), world, type, dst, src)
end

function ecs_value_move_w_type_info(world, ti, dst, src)
    ccall((:ecs_value_move_w_type_info, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{ecs_type_info_t}, Ptr{Cvoid}, Ptr{Cvoid}), world, ti, dst, src)
end

function ecs_value_move(world, type, dst, src)
    ccall((:ecs_value_move, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}, Ptr{Cvoid}), world, type, dst, src)
end

function ecs_value_move_ctor_w_type_info(world, ti, dst, src)
    ccall((:ecs_value_move_ctor_w_type_info, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{ecs_type_info_t}, Ptr{Cvoid}, Ptr{Cvoid}), world, ti, dst, src)
end

function ecs_value_move_ctor(world, type, dst, src)
    ccall((:ecs_value_move_ctor, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}, Ptr{Cvoid}), world, type, dst, src)
end

function ecs_strerror(error_code)
    ccall((:ecs_strerror, libflecs), Ptr{Cchar}, (Int32,), error_code)
end

function ecs_log_set_level(level)
    ccall((:ecs_log_set_level, libflecs), Cint, (Cint,), level)
end

function ecs_log_get_level()
    ccall((:ecs_log_get_level, libflecs), Cint, ())
end

function ecs_log_enable_colors(enabled)
    ccall((:ecs_log_enable_colors, libflecs), Bool, (Bool,), enabled)
end

function ecs_log_enable_timestamp(enabled)
    ccall((:ecs_log_enable_timestamp, libflecs), Bool, (Bool,), enabled)
end

function ecs_log_enable_timedelta(enabled)
    ccall((:ecs_log_enable_timedelta, libflecs), Bool, (Bool,), enabled)
end

function ecs_log_last_error()
    ccall((:ecs_log_last_error, libflecs), Cint, ())
end

# typedef int ( * ecs_app_init_action_t ) ( ecs_world_t * world )
const ecs_app_init_action_t = Ptr{Cvoid}

struct ecs_app_desc_t
    target_fps::Cfloat
    delta_time::Cfloat
    threads::Int32
    frames::Int32
    enable_rest::Bool
    enable_stats::Bool
    port::UInt16
    init::ecs_app_init_action_t
    ctx::Ptr{Cvoid}
end

# typedef int ( * ecs_app_run_action_t ) ( ecs_world_t * world , ecs_app_desc_t * desc )
const ecs_app_run_action_t = Ptr{Cvoid}

# typedef int ( * ecs_app_frame_action_t ) ( ecs_world_t * world , const ecs_app_desc_t * desc )
const ecs_app_frame_action_t = Ptr{Cvoid}

function ecs_app_run(world, desc)
    ccall((:ecs_app_run, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{ecs_app_desc_t}), world, desc)
end

function ecs_app_run_frame(world, desc)
    ccall((:ecs_app_run_frame, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{ecs_app_desc_t}), world, desc)
end

function ecs_app_set_run_action(callback)
    ccall((:ecs_app_set_run_action, libflecs), Cint, (ecs_app_run_action_t,), callback)
end

function ecs_app_set_frame_action(callback)
    ccall((:ecs_app_set_frame_action, libflecs), Cint, (ecs_app_frame_action_t,), callback)
end

mutable struct ecs_http_server_t end

struct ecs_http_connection_t
    id::UInt64
    server::Ptr{ecs_http_server_t}
    host::NTuple{128, Cchar}
    port::NTuple{16, Cchar}
end

struct ecs_http_key_value_t
    key::Ptr{Cchar}
    value::Ptr{Cchar}
end

@cenum ecs_http_method_t::UInt32 begin
    EcsHttpGet = 0
    EcsHttpPost = 1
    EcsHttpPut = 2
    EcsHttpDelete = 3
    EcsHttpOptions = 4
    EcsHttpMethodUnsupported = 5
end

struct ecs_http_request_t
    id::UInt64
    method::ecs_http_method_t
    path::Ptr{Cchar}
    body::Ptr{Cchar}
    headers::NTuple{32, ecs_http_key_value_t}
    params::NTuple{32, ecs_http_key_value_t}
    header_count::Int32
    param_count::Int32
    conn::Ptr{ecs_http_connection_t}
end

# typedef bool ( * ecs_http_reply_action_t ) ( const ecs_http_request_t * request , ecs_http_reply_t * reply , void * ctx )
const ecs_http_reply_action_t = Ptr{Cvoid}

struct ecs_http_server_desc_t
    callback::ecs_http_reply_action_t
    ctx::Ptr{Cvoid}
    port::UInt16
    ipaddr::Ptr{Cchar}
    send_queue_wait_ms::Int32
    cache_timeout::Cdouble
    cache_purge_timeout::Cdouble
end

function ecs_http_server_init(desc)
    ccall((:ecs_http_server_init, libflecs), Ptr{ecs_http_server_t}, (Ptr{ecs_http_server_desc_t},), desc)
end

function ecs_http_server_fini(server)
    ccall((:ecs_http_server_fini, libflecs), Cvoid, (Ptr{ecs_http_server_t},), server)
end

function ecs_http_server_start(server)
    ccall((:ecs_http_server_start, libflecs), Cint, (Ptr{ecs_http_server_t},), server)
end

function ecs_http_server_dequeue(server, delta_time)
    ccall((:ecs_http_server_dequeue, libflecs), Cvoid, (Ptr{ecs_http_server_t}, Cfloat), server, delta_time)
end

function ecs_http_server_stop(server)
    ccall((:ecs_http_server_stop, libflecs), Cvoid, (Ptr{ecs_http_server_t},), server)
end

function ecs_http_server_http_request(srv, req, len, reply_out)
    ccall((:ecs_http_server_http_request, libflecs), Cint, (Ptr{ecs_http_server_t}, Ptr{Cchar}, ecs_size_t, Ptr{ecs_http_reply_t}), srv, req, len, reply_out)
end

function ecs_http_server_request(srv, method, req, reply_out)
    ccall((:ecs_http_server_request, libflecs), Cint, (Ptr{ecs_http_server_t}, Ptr{Cchar}, Ptr{Cchar}, Ptr{ecs_http_reply_t}), srv, method, req, reply_out)
end

function ecs_http_server_ctx(srv)
    ccall((:ecs_http_server_ctx, libflecs), Ptr{Cvoid}, (Ptr{ecs_http_server_t},), srv)
end

function ecs_http_get_header(req, name)
    ccall((:ecs_http_get_header, libflecs), Ptr{Cchar}, (Ptr{ecs_http_request_t}, Ptr{Cchar}), req, name)
end

function ecs_http_get_param(req, name)
    ccall((:ecs_http_get_param, libflecs), Ptr{Cchar}, (Ptr{ecs_http_request_t}, Ptr{Cchar}), req, name)
end

struct EcsRest
    port::UInt16
    ipaddr::Ptr{Cchar}
    impl::Ptr{Cvoid}
end

function ecs_rest_server_init(world, desc)
    ccall((:ecs_rest_server_init, libflecs), Ptr{ecs_http_server_t}, (Ptr{ecs_world_t}, Ptr{ecs_http_server_desc_t}), world, desc)
end

function ecs_rest_server_fini(srv)
    ccall((:ecs_rest_server_fini, libflecs), Cvoid, (Ptr{ecs_http_server_t},), srv)
end

function FlecsRestImport(world)
    ccall((:FlecsRestImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

struct EcsTimer
    timeout::Cfloat
    time::Cfloat
    overshoot::Cfloat
    fired_count::Int32
    active::Bool
    single_shot::Bool
end

struct EcsRateFilter
    src::ecs_entity_t
    rate::Int32
    tick_count::Int32
    time_elapsed::Cfloat
end

function ecs_set_timeout(world, tick_source, timeout)
    ccall((:ecs_set_timeout, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Cfloat), world, tick_source, timeout)
end

function ecs_get_timeout(world, tick_source)
    ccall((:ecs_get_timeout, libflecs), Cfloat, (Ptr{ecs_world_t}, ecs_entity_t), world, tick_source)
end

function ecs_set_interval(world, tick_source, interval)
    ccall((:ecs_set_interval, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Cfloat), world, tick_source, interval)
end

function ecs_get_interval(world, tick_source)
    ccall((:ecs_get_interval, libflecs), Cfloat, (Ptr{ecs_world_t}, ecs_entity_t), world, tick_source)
end

function ecs_start_timer(world, tick_source)
    ccall((:ecs_start_timer, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t), world, tick_source)
end

function ecs_stop_timer(world, tick_source)
    ccall((:ecs_stop_timer, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t), world, tick_source)
end

function ecs_reset_timer(world, tick_source)
    ccall((:ecs_reset_timer, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t), world, tick_source)
end

function ecs_randomize_timers(world)
    ccall((:ecs_randomize_timers, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_set_rate(world, tick_source, rate, source)
    ccall((:ecs_set_rate, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Int32, ecs_entity_t), world, tick_source, rate, source)
end

function ecs_set_tick_source(world, system, tick_source)
    ccall((:ecs_set_tick_source, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t), world, system, tick_source)
end

function FlecsTimerImport(world)
    ccall((:FlecsTimerImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_set_pipeline(world, pipeline)
    ccall((:ecs_set_pipeline, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t), world, pipeline)
end

function ecs_get_pipeline(world)
    ccall((:ecs_get_pipeline, libflecs), ecs_entity_t, (Ptr{ecs_world_t},), world)
end

function ecs_progress(world, delta_time)
    ccall((:ecs_progress, libflecs), Bool, (Ptr{ecs_world_t}, Cfloat), world, delta_time)
end

function ecs_set_time_scale(world, scale)
    ccall((:ecs_set_time_scale, libflecs), Cvoid, (Ptr{ecs_world_t}, Cfloat), world, scale)
end

function ecs_reset_clock(world)
    ccall((:ecs_reset_clock, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_run_pipeline(world, pipeline, delta_time)
    ccall((:ecs_run_pipeline, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Cfloat), world, pipeline, delta_time)
end

function ecs_set_threads(world, threads)
    ccall((:ecs_set_threads, libflecs), Cvoid, (Ptr{ecs_world_t}, Int32), world, threads)
end

function ecs_set_task_threads(world, task_threads)
    ccall((:ecs_set_task_threads, libflecs), Cvoid, (Ptr{ecs_world_t}, Int32), world, task_threads)
end

function ecs_using_task_threads(world)
    ccall((:ecs_using_task_threads, libflecs), Bool, (Ptr{ecs_world_t},), world)
end

function FlecsPipelineImport(world)
    ccall((:FlecsPipelineImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

struct EcsTickSource
    tick::Bool
    time_elapsed::Cfloat
end

struct ecs_system_t
    hdr::ecs_header_t
    run::ecs_run_action_t
    action::ecs_iter_action_t
    query::Ptr{ecs_query_t}
    query_entity::ecs_entity_t
    tick_source::ecs_entity_t
    multi_threaded::Bool
    immediate::Bool
    name::Ptr{Cchar}
    ctx::Ptr{Cvoid}
    callback_ctx::Ptr{Cvoid}
    run_ctx::Ptr{Cvoid}
    ctx_free::ecs_ctx_free_t
    callback_ctx_free::ecs_ctx_free_t
    run_ctx_free::ecs_ctx_free_t
    time_spent::Cfloat
    time_passed::Cfloat
    last_frame::Int64
    world::Ptr{ecs_world_t}
    entity::ecs_entity_t
    dtor::flecs_poly_dtor_t
end

function ecs_system_get(world, system)
    ccall((:ecs_system_get, libflecs), Ptr{ecs_system_t}, (Ptr{ecs_world_t}, ecs_entity_t), world, system)
end

function ecs_run(world, system, delta_time, param)
    ccall((:ecs_run, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Cfloat, Ptr{Cvoid}), world, system, delta_time, param)
end

function ecs_run_worker(world, system, stage_current, stage_count, delta_time, param)
    ccall((:ecs_run_worker, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Int32, Int32, Cfloat, Ptr{Cvoid}), world, system, stage_current, stage_count, delta_time, param)
end

function FlecsSystemImport(world)
    ccall((:FlecsSystemImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

struct ecs_gauge_t
    avg::NTuple{60, Cfloat}
    min::NTuple{60, Cfloat}
    max::NTuple{60, Cfloat}
end

struct ecs_counter_t
    rate::ecs_gauge_t
    value::NTuple{60, Cdouble}
end

struct ecs_metric_t
    data::NTuple{1200, UInt8}
end

function Base.getproperty(x::Ptr{ecs_metric_t}, f::Symbol)
    f === :gauge && return Ptr{ecs_gauge_t}(x + 0)
    f === :counter && return Ptr{ecs_counter_t}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::ecs_metric_t, f::Symbol)
    r = Ref{ecs_metric_t}(x)
    ptr = Base.unsafe_convert(Ptr{ecs_metric_t}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{ecs_metric_t}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:65:5)"
    count::ecs_metric_t
    not_alive_count::ecs_metric_t
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:71:5)"
    tag_count::ecs_metric_t
    component_count::ecs_metric_t
    pair_count::ecs_metric_t
    type_count::ecs_metric_t
    create_count::ecs_metric_t
    delete_count::ecs_metric_t
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:81:5)"
    count::ecs_metric_t
    empty_count::ecs_metric_t
    create_count::ecs_metric_t
    delete_count::ecs_metric_t
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:89:5)"
    query_count::ecs_metric_t
    observer_count::ecs_metric_t
    system_count::ecs_metric_t
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:96:5)"
    add_count::ecs_metric_t
    remove_count::ecs_metric_t
    delete_count::ecs_metric_t
    clear_count::ecs_metric_t
    set_count::ecs_metric_t
    ensure_count::ecs_metric_t
    modified_count::ecs_metric_t
    other_count::ecs_metric_t
    discard_count::ecs_metric_t
    batched_entity_count::ecs_metric_t
    batched_count::ecs_metric_t
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:111:5)"
    frame_count::ecs_metric_t
    merge_count::ecs_metric_t
    rematch_count::ecs_metric_t
    pipeline_build_count::ecs_metric_t
    systems_ran::ecs_metric_t
    observers_ran::ecs_metric_t
    event_emit_count::ecs_metric_t
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:122:5)"
    world_time_raw::ecs_metric_t
    world_time::ecs_metric_t
    frame_time::ecs_metric_t
    system_time::ecs_metric_t
    emit_time::ecs_metric_t
    merge_time::ecs_metric_t
    rematch_time::ecs_metric_t
    fps::ecs_metric_t
    delta_time::ecs_metric_t
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:134:5)"
    alloc_count::ecs_metric_t
    realloc_count::ecs_metric_t
    free_count::ecs_metric_t
    outstanding_alloc_count::ecs_metric_t
    block_alloc_count::ecs_metric_t
    block_free_count::ecs_metric_t
    block_outstanding_alloc_count::ecs_metric_t
    stack_alloc_count::ecs_metric_t
    stack_free_count::ecs_metric_t
    stack_outstanding_alloc_count::ecs_metric_t
end

struct var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:151:5)"
    request_received_count::ecs_metric_t
    request_invalid_count::ecs_metric_t
    request_handled_ok_count::ecs_metric_t
    request_handled_error_count::ecs_metric_t
    request_not_handled_count::ecs_metric_t
    request_preflight_count::ecs_metric_t
    send_ok_count::ecs_metric_t
    send_error_count::ecs_metric_t
    busy_count::ecs_metric_t
end

struct ecs_world_stats_t
    data::NTuple{73224, UInt8}
end

function Base.getproperty(x::Ptr{ecs_world_stats_t}, f::Symbol)
    f === :first_ && return Ptr{Int64}(x + 0)
    f === :entities && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:65:5)"}(x + 8)
    f === :components && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:71:5)"}(x + 2408)
    f === :tables && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:81:5)"}(x + 9608)
    f === :queries && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:89:5)"}(x + 14408)
    f === :commands && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:96:5)"}(x + 18008)
    f === :frame && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:111:5)"}(x + 31208)
    f === :performance && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:122:5)"}(x + 39608)
    f === :memory && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:134:5)"}(x + 50408)
    f === :http && return Ptr{var"struct (unnamed at /home/kyjor/.julia/artifacts/9985b744b7437a276cf9c5af999ad9f1928db99a/include/flecs/private/../addons/stats.h:151:5)"}(x + 62408)
    f === :last_ && return Ptr{Int64}(x + 73208)
    f === :t && return Ptr{Int32}(x + 73216)
    return getfield(x, f)
end

function Base.getproperty(x::ecs_world_stats_t, f::Symbol)
    r = Ref{ecs_world_stats_t}(x)
    ptr = Base.unsafe_convert(Ptr{ecs_world_stats_t}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{ecs_world_stats_t}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct ecs_query_stats_t
    first_::Int64
    result_count::ecs_metric_t
    matched_table_count::ecs_metric_t
    matched_entity_count::ecs_metric_t
    last_::Int64
    t::Int32
end

struct ecs_system_stats_t
    first_::Int64
    time_spent::ecs_metric_t
    last_::Int64
    task::Bool
    query::ecs_query_stats_t
end

struct ecs_sync_stats_t
    first_::Int64
    time_spent::ecs_metric_t
    commands_enqueued::ecs_metric_t
    last_::Int64
    system_count::Int32
    multi_threaded::Bool
    immediate::Bool
end

struct ecs_pipeline_stats_t
    canary_::Int8
    systems::ecs_vec_t
    sync_points::ecs_vec_t
    t::Int32
    system_count::Int32
    active_system_count::Int32
    rebuild_count::Int32
end

function ecs_world_stats_get(world, stats)
    ccall((:ecs_world_stats_get, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_world_stats_t}), world, stats)
end

function ecs_world_stats_reduce(dst, src)
    ccall((:ecs_world_stats_reduce, libflecs), Cvoid, (Ptr{ecs_world_stats_t}, Ptr{ecs_world_stats_t}), dst, src)
end

function ecs_world_stats_reduce_last(stats, old, count)
    ccall((:ecs_world_stats_reduce_last, libflecs), Cvoid, (Ptr{ecs_world_stats_t}, Ptr{ecs_world_stats_t}, Int32), stats, old, count)
end

function ecs_world_stats_repeat_last(stats)
    ccall((:ecs_world_stats_repeat_last, libflecs), Cvoid, (Ptr{ecs_world_stats_t},), stats)
end

function ecs_world_stats_copy_last(dst, src)
    ccall((:ecs_world_stats_copy_last, libflecs), Cvoid, (Ptr{ecs_world_stats_t}, Ptr{ecs_world_stats_t}), dst, src)
end

function ecs_world_stats_log(world, stats)
    ccall((:ecs_world_stats_log, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_world_stats_t}), world, stats)
end

function ecs_query_stats_get(world, query, stats)
    ccall((:ecs_query_stats_get, libflecs), Cvoid, (Ptr{ecs_world_t}, Ptr{ecs_query_t}, Ptr{ecs_query_stats_t}), world, query, stats)
end

function ecs_query_cache_stats_reduce(dst, src)
    ccall((:ecs_query_cache_stats_reduce, libflecs), Cvoid, (Ptr{ecs_query_stats_t}, Ptr{ecs_query_stats_t}), dst, src)
end

function ecs_query_cache_stats_reduce_last(stats, old, count)
    ccall((:ecs_query_cache_stats_reduce_last, libflecs), Cvoid, (Ptr{ecs_query_stats_t}, Ptr{ecs_query_stats_t}, Int32), stats, old, count)
end

function ecs_query_cache_stats_repeat_last(stats)
    ccall((:ecs_query_cache_stats_repeat_last, libflecs), Cvoid, (Ptr{ecs_query_stats_t},), stats)
end

function ecs_query_cache_stats_copy_last(dst, src)
    ccall((:ecs_query_cache_stats_copy_last, libflecs), Cvoid, (Ptr{ecs_query_stats_t}, Ptr{ecs_query_stats_t}), dst, src)
end

function ecs_system_stats_get(world, system, stats)
    ccall((:ecs_system_stats_get, libflecs), Bool, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{ecs_system_stats_t}), world, system, stats)
end

function ecs_system_stats_reduce(dst, src)
    ccall((:ecs_system_stats_reduce, libflecs), Cvoid, (Ptr{ecs_system_stats_t}, Ptr{ecs_system_stats_t}), dst, src)
end

function ecs_system_stats_reduce_last(stats, old, count)
    ccall((:ecs_system_stats_reduce_last, libflecs), Cvoid, (Ptr{ecs_system_stats_t}, Ptr{ecs_system_stats_t}, Int32), stats, old, count)
end

function ecs_system_stats_repeat_last(stats)
    ccall((:ecs_system_stats_repeat_last, libflecs), Cvoid, (Ptr{ecs_system_stats_t},), stats)
end

function ecs_system_stats_copy_last(dst, src)
    ccall((:ecs_system_stats_copy_last, libflecs), Cvoid, (Ptr{ecs_system_stats_t}, Ptr{ecs_system_stats_t}), dst, src)
end

function ecs_pipeline_stats_get(world, pipeline, stats)
    ccall((:ecs_pipeline_stats_get, libflecs), Bool, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{ecs_pipeline_stats_t}), world, pipeline, stats)
end

function ecs_pipeline_stats_fini(stats)
    ccall((:ecs_pipeline_stats_fini, libflecs), Cvoid, (Ptr{ecs_pipeline_stats_t},), stats)
end

function ecs_pipeline_stats_reduce(dst, src)
    ccall((:ecs_pipeline_stats_reduce, libflecs), Cvoid, (Ptr{ecs_pipeline_stats_t}, Ptr{ecs_pipeline_stats_t}), dst, src)
end

function ecs_pipeline_stats_reduce_last(stats, old, count)
    ccall((:ecs_pipeline_stats_reduce_last, libflecs), Cvoid, (Ptr{ecs_pipeline_stats_t}, Ptr{ecs_pipeline_stats_t}, Int32), stats, old, count)
end

function ecs_pipeline_stats_repeat_last(stats)
    ccall((:ecs_pipeline_stats_repeat_last, libflecs), Cvoid, (Ptr{ecs_pipeline_stats_t},), stats)
end

function ecs_pipeline_stats_copy_last(dst, src)
    ccall((:ecs_pipeline_stats_copy_last, libflecs), Cvoid, (Ptr{ecs_pipeline_stats_t}, Ptr{ecs_pipeline_stats_t}), dst, src)
end

function ecs_metric_reduce(dst, src, t_dst, t_src)
    ccall((:ecs_metric_reduce, libflecs), Cvoid, (Ptr{ecs_metric_t}, Ptr{ecs_metric_t}, Int32, Int32), dst, src, t_dst, t_src)
end

function ecs_metric_reduce_last(m, t, count)
    ccall((:ecs_metric_reduce_last, libflecs), Cvoid, (Ptr{ecs_metric_t}, Int32, Int32), m, t, count)
end

function ecs_metric_copy(m, dst, src)
    ccall((:ecs_metric_copy, libflecs), Cvoid, (Ptr{ecs_metric_t}, Int32, Int32), m, dst, src)
end

struct EcsStatsHeader
    elapsed::Cfloat
    reduce_count::Int32
end

struct EcsWorldStats
    hdr::EcsStatsHeader
    stats::ecs_world_stats_t
end

struct EcsSystemStats
    hdr::EcsStatsHeader
    stats::ecs_map_t
end

struct EcsPipelineStats
    hdr::EcsStatsHeader
    stats::ecs_map_t
end

struct EcsWorldSummary
    target_fps::Cdouble
    time_scale::Cdouble
    frame_time_total::Cdouble
    system_time_total::Cdouble
    merge_time_total::Cdouble
    frame_time_last::Cdouble
    system_time_last::Cdouble
    merge_time_last::Cdouble
    frame_count::Int64
    command_count::Int64
    build_info::ecs_build_info_t
end

function FlecsStatsImport(world)
    ccall((:FlecsStatsImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

struct EcsMetricValue
    value::Cdouble
end

struct EcsMetricSource
    entity::ecs_entity_t
end

function FlecsMetricsImport(world)
    ccall((:FlecsMetricsImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

struct EcsAlertInstance
    message::Ptr{Cchar}
end

struct EcsAlertsActive
    info_count::Int32
    warning_count::Int32
    error_count::Int32
    alerts::ecs_map_t
end

function ecs_get_alert_count(world, entity, alert)
    ccall((:ecs_get_alert_count, libflecs), Int32, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t), world, entity, alert)
end

function ecs_get_alert(world, entity, alert)
    ccall((:ecs_get_alert, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t), world, entity, alert)
end

function FlecsAlertsImport(world)
    ccall((:FlecsAlertsImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

struct ecs_from_json_desc_t
    name::Ptr{Cchar}
    expr::Ptr{Cchar}
    lookup_action::Ptr{Cvoid}
    lookup_ctx::Ptr{Cvoid}
    strict::Bool
end

function ecs_ptr_from_json(world, type, ptr, json, desc)
    ccall((:ecs_ptr_from_json, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}, Ptr{Cchar}, Ptr{ecs_from_json_desc_t}), world, type, ptr, json, desc)
end

function ecs_entity_from_json(world, entity, json, desc)
    ccall((:ecs_entity_from_json, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}, Ptr{ecs_from_json_desc_t}), world, entity, json, desc)
end

function ecs_world_from_json(world, json, desc)
    ccall((:ecs_world_from_json, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{Cchar}, Ptr{ecs_from_json_desc_t}), world, json, desc)
end

function ecs_world_from_json_file(world, filename, desc)
    ccall((:ecs_world_from_json_file, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{Cchar}, Ptr{ecs_from_json_desc_t}), world, filename, desc)
end

function ecs_array_to_json(world, type, data, count)
    ccall((:ecs_array_to_json, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}, Int32), world, type, data, count)
end

function ecs_array_to_json_buf(world, type, data, count, buf_out)
    ccall((:ecs_array_to_json_buf, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}, Int32, Ptr{ecs_strbuf_t}), world, type, data, count, buf_out)
end

function ecs_ptr_to_json(world, type, data)
    ccall((:ecs_ptr_to_json, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}), world, type, data)
end

function ecs_ptr_to_json_buf(world, type, data, buf_out)
    ccall((:ecs_ptr_to_json_buf, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}, Ptr{ecs_strbuf_t}), world, type, data, buf_out)
end

function ecs_type_info_to_json(world, type)
    ccall((:ecs_type_info_to_json, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, type)
end

function ecs_type_info_to_json_buf(world, type, buf_out)
    ccall((:ecs_type_info_to_json_buf, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{ecs_strbuf_t}), world, type, buf_out)
end

function ecs_entity_to_json(world, entity, desc)
    ccall((:ecs_entity_to_json, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{ecs_entity_to_json_desc_t}), world, entity, desc)
end

function ecs_entity_to_json_buf(world, entity, buf_out, desc)
    ccall((:ecs_entity_to_json_buf, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{ecs_strbuf_t}, Ptr{ecs_entity_to_json_desc_t}), world, entity, buf_out, desc)
end

function ecs_iter_to_json(iter, desc)
    ccall((:ecs_iter_to_json, libflecs), Ptr{Cchar}, (Ptr{ecs_iter_t}, Ptr{ecs_iter_to_json_desc_t}), iter, desc)
end

function ecs_iter_to_json_buf(iter, buf_out, desc)
    ccall((:ecs_iter_to_json_buf, libflecs), Cint, (Ptr{ecs_iter_t}, Ptr{ecs_strbuf_t}, Ptr{ecs_iter_to_json_desc_t}), iter, buf_out, desc)
end

struct ecs_world_to_json_desc_t
    serialize_builtin::Bool
    serialize_modules::Bool
end

function ecs_world_to_json(world, desc)
    ccall((:ecs_world_to_json, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{ecs_world_to_json_desc_t}), world, desc)
end

function ecs_world_to_json_buf(world, buf_out, desc)
    ccall((:ecs_world_to_json_buf, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{ecs_strbuf_t}, Ptr{ecs_world_to_json_desc_t}), world, buf_out, desc)
end

function FlecsUnitsImport(world)
    ccall((:FlecsUnitsImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

mutable struct ecs_script_template_t end

struct ecs_script_t
    world::Ptr{ecs_world_t}
    name::Ptr{Cchar}
    code::Ptr{Cchar}
end

struct EcsScript
    script::Ptr{ecs_script_t}
    template_::Ptr{ecs_script_template_t}
end

function ecs_script_parse(world, name, code)
    ccall((:ecs_script_parse, libflecs), Ptr{ecs_script_t}, (Ptr{ecs_world_t}, Ptr{Cchar}, Ptr{Cchar}), world, name, code)
end

function ecs_script_eval(script)
    ccall((:ecs_script_eval, libflecs), Cint, (Ptr{ecs_script_t},), script)
end

function ecs_script_free(script)
    ccall((:ecs_script_free, libflecs), Cvoid, (Ptr{ecs_script_t},), script)
end

function ecs_script_run(world, name, code)
    ccall((:ecs_script_run, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{Cchar}, Ptr{Cchar}), world, name, code)
end

function ecs_script_run_file(world, filename)
    ccall((:ecs_script_run_file, libflecs), Cint, (Ptr{ecs_world_t}, Ptr{Cchar}), world, filename)
end

function ecs_script_ast_to_buf(script, buf)
    ccall((:ecs_script_ast_to_buf, libflecs), Cint, (Ptr{ecs_script_t}, Ptr{ecs_strbuf_t}), script, buf)
end

function ecs_script_ast_to_str(script)
    ccall((:ecs_script_ast_to_str, libflecs), Ptr{Cchar}, (Ptr{ecs_script_t},), script)
end

function ecs_script_update(world, script, instance, code)
    ccall((:ecs_script_update, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t, Ptr{Cchar}), world, script, instance, code)
end

function ecs_script_clear(world, script, instance)
    ccall((:ecs_script_clear, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t), world, script, instance)
end

function ecs_script_vars_init(world)
    ccall((:ecs_script_vars_init, libflecs), Ptr{ecs_script_vars_t}, (Ptr{ecs_world_t},), world)
end

function ecs_script_vars_fini(vars)
    ccall((:ecs_script_vars_fini, libflecs), Cvoid, (Ptr{ecs_script_vars_t},), vars)
end

function ecs_script_vars_push(parent)
    ccall((:ecs_script_vars_push, libflecs), Ptr{ecs_script_vars_t}, (Ptr{ecs_script_vars_t},), parent)
end

function ecs_script_vars_pop(vars)
    ccall((:ecs_script_vars_pop, libflecs), Ptr{ecs_script_vars_t}, (Ptr{ecs_script_vars_t},), vars)
end

function ecs_script_vars_declare(vars, name)
    ccall((:ecs_script_vars_declare, libflecs), Ptr{ecs_script_var_t}, (Ptr{ecs_script_vars_t}, Ptr{Cchar}), vars, name)
end

function ecs_script_vars_lookup(vars, name)
    ccall((:ecs_script_vars_lookup, libflecs), Ptr{ecs_script_var_t}, (Ptr{ecs_script_vars_t}, Ptr{Cchar}), vars, name)
end

function ecs_script_vars_from_iter(it, vars, offset)
    ccall((:ecs_script_vars_from_iter, libflecs), Cvoid, (Ptr{ecs_iter_t}, Ptr{ecs_script_vars_t}, Cint), it, vars, offset)
end

struct ecs_script_expr_run_desc_t
    name::Ptr{Cchar}
    expr::Ptr{Cchar}
    lookup_action::Ptr{Cvoid}
    lookup_ctx::Ptr{Cvoid}
    vars::Ptr{ecs_script_vars_t}
end

function ecs_script_expr_run(world, ptr, value, desc)
    ccall((:ecs_script_expr_run, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{Cchar}, Ptr{ecs_value_t}, Ptr{ecs_script_expr_run_desc_t}), world, ptr, value, desc)
end

function ecs_script_string_interpolate(world, str, vars)
    ccall((:ecs_script_string_interpolate, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{Cchar}, Ptr{ecs_script_vars_t}), world, str, vars)
end

function ecs_ptr_to_expr(world, type, data)
    ccall((:ecs_ptr_to_expr, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}), world, type, data)
end

function ecs_ptr_to_expr_buf(world, type, data, buf)
    ccall((:ecs_ptr_to_expr_buf, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}, Ptr{ecs_strbuf_t}), world, type, data, buf)
end

function ecs_ptr_to_str(world, type, data)
    ccall((:ecs_ptr_to_str, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}), world, type, data)
end

function ecs_ptr_to_str_buf(world, type, data, buf)
    ccall((:ecs_ptr_to_str_buf, libflecs), Cint, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}, Ptr{ecs_strbuf_t}), world, type, data, buf)
end

function FlecsScriptImport(world)
    ccall((:FlecsScriptImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

struct EcsDocDescription
    value::Ptr{Cchar}
end

function ecs_doc_set_uuid(world, entity, uuid)
    ccall((:ecs_doc_set_uuid, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, entity, uuid)
end

function ecs_doc_set_name(world, entity, name)
    ccall((:ecs_doc_set_name, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, entity, name)
end

function ecs_doc_set_brief(world, entity, description)
    ccall((:ecs_doc_set_brief, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, entity, description)
end

function ecs_doc_set_detail(world, entity, description)
    ccall((:ecs_doc_set_detail, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, entity, description)
end

function ecs_doc_set_link(world, entity, link)
    ccall((:ecs_doc_set_link, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, entity, link)
end

function ecs_doc_set_color(world, entity, color)
    ccall((:ecs_doc_set_color, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}), world, entity, color)
end

function ecs_doc_get_uuid(world, entity)
    ccall((:ecs_doc_get_uuid, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_doc_get_name(world, entity)
    ccall((:ecs_doc_get_name, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_doc_get_brief(world, entity)
    ccall((:ecs_doc_get_brief, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_doc_get_detail(world, entity)
    ccall((:ecs_doc_get_detail, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_doc_get_link(world, entity)
    ccall((:ecs_doc_get_link, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function ecs_doc_get_color(world, entity)
    ccall((:ecs_doc_get_color, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, ecs_entity_t), world, entity)
end

function FlecsDocImport(world)
    ccall((:FlecsDocImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

const ecs_bool_t = Bool

const ecs_char_t = Cchar

const ecs_byte_t = Cuchar

const ecs_u8_t = UInt8

const ecs_u16_t = UInt16

const ecs_u32_t = UInt32

const ecs_u64_t = UInt64

const ecs_uptr_t = Csize_t

const ecs_i8_t = Int8

const ecs_i16_t = Int16

const ecs_i32_t = Int32

const ecs_i64_t = Int64

const ecs_iptr_t = intptr_t

const ecs_f32_t = Cfloat

const ecs_f64_t = Cdouble

const ecs_string_t = Ptr{Cchar}

struct EcsType
    kind::ecs_type_kind_t
    existing::Bool
    partial::Bool
end

struct EcsPrimitive
    kind::ecs_primitive_kind_t
end

struct EcsMember
    type::ecs_entity_t
    count::Int32
    unit::ecs_entity_t
    offset::Int32
    use_offset::Bool
end

struct EcsMemberRanges
    value::ecs_member_value_range_t
    warning::ecs_member_value_range_t
    error::ecs_member_value_range_t
end

struct EcsStruct
    members::ecs_vec_t
end

struct EcsEnum
    constants::ecs_map_t
end

struct EcsBitmask
    constants::ecs_map_t
end

struct EcsArray
    type::ecs_entity_t
    count::Int32
end

struct EcsVector
    type::ecs_entity_t
end

struct ecs_serializer_t
    value::Ptr{Cvoid}
    member::Ptr{Cvoid}
    world::Ptr{ecs_world_t}
    ctx::Ptr{Cvoid}
end

struct EcsUnit
    symbol::Ptr{Cchar}
    prefix::ecs_entity_t
    base::ecs_entity_t
    over::ecs_entity_t
    translation::ecs_unit_translation_t
end

struct EcsUnitPrefix
    symbol::Ptr{Cchar}
    translation::ecs_unit_translation_t
end

@cenum ecs_meta_type_op_kind_t::UInt32 begin
    EcsOpArray = 0
    EcsOpVector = 1
    EcsOpOpaque = 2
    EcsOpPush = 3
    EcsOpPop = 4
    EcsOpScope = 5
    EcsOpEnum = 6
    EcsOpBitmask = 7
    EcsOpPrimitive = 8
    EcsOpBool = 9
    EcsOpChar = 10
    EcsOpByte = 11
    EcsOpU8 = 12
    EcsOpU16 = 13
    EcsOpU32 = 14
    EcsOpU64 = 15
    EcsOpI8 = 16
    EcsOpI16 = 17
    EcsOpI32 = 18
    EcsOpI64 = 19
    EcsOpF32 = 20
    EcsOpF64 = 21
    EcsOpUPtr = 22
    EcsOpIPtr = 23
    EcsOpString = 24
    EcsOpEntity = 25
    EcsOpId = 26
    EcsMetaTypeOpKindLast = 26
end

struct ecs_meta_type_op_t
    kind::ecs_meta_type_op_kind_t
    offset::ecs_size_t
    count::Int32
    name::Ptr{Cchar}
    op_count::Int32
    size::ecs_size_t
    type::ecs_entity_t
    member_index::Int32
    members::Ptr{ecs_hashmap_t}
end

struct EcsTypeSerializer
    ops::ecs_vec_t
end

struct ecs_meta_scope_t
    type::ecs_entity_t
    ops::Ptr{ecs_meta_type_op_t}
    op_count::Int32
    op_cur::Int32
    elem_cur::Int32
    prev_depth::Int32
    ptr::Ptr{Cvoid}
    comp::Ptr{EcsComponent}
    opaque::Ptr{EcsOpaque}
    vector::Ptr{ecs_vec_t}
    members::Ptr{ecs_hashmap_t}
    is_collection::Bool
    is_inline_array::Bool
    is_empty_scope::Bool
end

struct ecs_meta_cursor_t
    world::Ptr{ecs_world_t}
    scope::NTuple{32, ecs_meta_scope_t}
    depth::Int32
    valid::Bool
    is_primitive_scope::Bool
    lookup_action::Ptr{Cvoid}
    lookup_ctx::Ptr{Cvoid}
end

function ecs_meta_cursor(world, type, ptr)
    ccall((:ecs_meta_cursor, libflecs), ecs_meta_cursor_t, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cvoid}), world, type, ptr)
end

function ecs_meta_get_ptr(cursor)
    ccall((:ecs_meta_get_ptr, libflecs), Ptr{Cvoid}, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_next(cursor)
    ccall((:ecs_meta_next, libflecs), Cint, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_elem(cursor, elem)
    ccall((:ecs_meta_elem, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Int32), cursor, elem)
end

function ecs_meta_member(cursor, name)
    ccall((:ecs_meta_member, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Ptr{Cchar}), cursor, name)
end

function ecs_meta_dotmember(cursor, name)
    ccall((:ecs_meta_dotmember, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Ptr{Cchar}), cursor, name)
end

function ecs_meta_push(cursor)
    ccall((:ecs_meta_push, libflecs), Cint, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_pop(cursor)
    ccall((:ecs_meta_pop, libflecs), Cint, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_is_collection(cursor)
    ccall((:ecs_meta_is_collection, libflecs), Bool, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_type(cursor)
    ccall((:ecs_meta_get_type, libflecs), ecs_entity_t, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_unit(cursor)
    ccall((:ecs_meta_get_unit, libflecs), ecs_entity_t, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_member(cursor)
    ccall((:ecs_meta_get_member, libflecs), Ptr{Cchar}, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_member_id(cursor)
    ccall((:ecs_meta_get_member_id, libflecs), ecs_entity_t, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_set_bool(cursor, value)
    ccall((:ecs_meta_set_bool, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Bool), cursor, value)
end

function ecs_meta_set_char(cursor, value)
    ccall((:ecs_meta_set_char, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Cchar), cursor, value)
end

function ecs_meta_set_int(cursor, value)
    ccall((:ecs_meta_set_int, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Int64), cursor, value)
end

function ecs_meta_set_uint(cursor, value)
    ccall((:ecs_meta_set_uint, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, UInt64), cursor, value)
end

function ecs_meta_set_float(cursor, value)
    ccall((:ecs_meta_set_float, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Cdouble), cursor, value)
end

function ecs_meta_set_string(cursor, value)
    ccall((:ecs_meta_set_string, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Ptr{Cchar}), cursor, value)
end

function ecs_meta_set_string_literal(cursor, value)
    ccall((:ecs_meta_set_string_literal, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Ptr{Cchar}), cursor, value)
end

function ecs_meta_set_entity(cursor, value)
    ccall((:ecs_meta_set_entity, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, ecs_entity_t), cursor, value)
end

function ecs_meta_set_id(cursor, value)
    ccall((:ecs_meta_set_id, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, ecs_id_t), cursor, value)
end

function ecs_meta_set_null(cursor)
    ccall((:ecs_meta_set_null, libflecs), Cint, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_set_value(cursor, value)
    ccall((:ecs_meta_set_value, libflecs), Cint, (Ptr{ecs_meta_cursor_t}, Ptr{ecs_value_t}), cursor, value)
end

function ecs_meta_get_bool(cursor)
    ccall((:ecs_meta_get_bool, libflecs), Bool, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_char(cursor)
    ccall((:ecs_meta_get_char, libflecs), Cchar, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_int(cursor)
    ccall((:ecs_meta_get_int, libflecs), Int64, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_uint(cursor)
    ccall((:ecs_meta_get_uint, libflecs), UInt64, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_float(cursor)
    ccall((:ecs_meta_get_float, libflecs), Cdouble, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_string(cursor)
    ccall((:ecs_meta_get_string, libflecs), Ptr{Cchar}, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_entity(cursor)
    ccall((:ecs_meta_get_entity, libflecs), ecs_entity_t, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_get_id(cursor)
    ccall((:ecs_meta_get_id, libflecs), ecs_id_t, (Ptr{ecs_meta_cursor_t},), cursor)
end

function ecs_meta_ptr_to_float(type_kind, ptr)
    ccall((:ecs_meta_ptr_to_float, libflecs), Cdouble, (ecs_primitive_kind_t, Ptr{Cvoid}), type_kind, ptr)
end

function FlecsMetaImport(world)
    ccall((:FlecsMetaImport, libflecs), Cvoid, (Ptr{ecs_world_t},), world)
end

function ecs_set_os_api_impl()
    ccall((:ecs_set_os_api_impl, libflecs), Cvoid, ())
end

function ecs_import(world, _module, module_name)
    ccall((:ecs_import, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_module_action_t, Ptr{Cchar}), world, _module, module_name)
end

function ecs_import_from_library(world, library_name, module_name)
    ccall((:ecs_import_from_library, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, Ptr{Cchar}, Ptr{Cchar}), world, library_name, module_name)
end

function ecs_cpp_get_type_name(type_name, func_name, len, front_len)
    ccall((:ecs_cpp_get_type_name, libflecs), Ptr{Cchar}, (Ptr{Cchar}, Ptr{Cchar}, Csize_t, Csize_t), type_name, func_name, len, front_len)
end

function ecs_cpp_get_symbol_name(symbol_name, type_name, len)
    ccall((:ecs_cpp_get_symbol_name, libflecs), Ptr{Cchar}, (Ptr{Cchar}, Ptr{Cchar}, Csize_t), symbol_name, type_name, len)
end

function ecs_cpp_get_constant_name(constant_name, func_name, len, back_len)
    ccall((:ecs_cpp_get_constant_name, libflecs), Ptr{Cchar}, (Ptr{Cchar}, Ptr{Cchar}, Csize_t, Csize_t), constant_name, func_name, len, back_len)
end

function ecs_cpp_trim_module(world, type_name)
    ccall((:ecs_cpp_trim_module, libflecs), Ptr{Cchar}, (Ptr{ecs_world_t}, Ptr{Cchar}), world, type_name)
end

function ecs_cpp_component_validate(world, id, name, symbol, size, alignment, implicit_name)
    ccall((:ecs_cpp_component_validate, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}, Ptr{Cchar}, Csize_t, Csize_t, Bool), world, id, name, symbol, size, alignment, implicit_name)
end

function ecs_cpp_component_register(world, id, name, symbol, size, alignment, implicit_name, existing_out)
    ccall((:ecs_cpp_component_register, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, Ptr{Cchar}, Ptr{Cchar}, ecs_size_t, ecs_size_t, Bool, Ptr{Bool}), world, id, name, symbol, size, alignment, implicit_name, existing_out)
end

function ecs_cpp_component_register_explicit(world, s_id, id, name, type_name, symbol, size, alignment, is_component, existing_out)
    ccall((:ecs_cpp_component_register_explicit, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Csize_t, Csize_t, Bool, Ptr{Bool}), world, s_id, id, name, type_name, symbol, size, alignment, is_component, existing_out)
end

function ecs_cpp_enum_init(world, id)
    ccall((:ecs_cpp_enum_init, libflecs), Cvoid, (Ptr{ecs_world_t}, ecs_entity_t), world, id)
end

function ecs_cpp_enum_constant_register(world, parent, id, name, value)
    ccall((:ecs_cpp_enum_constant_register, libflecs), ecs_entity_t, (Ptr{ecs_world_t}, ecs_entity_t, ecs_entity_t, Ptr{Cchar}, Cint), world, parent, id, name, value)
end

function ecs_cpp_reset_count_get()
    ccall((:ecs_cpp_reset_count_get, libflecs), Int32, ())
end

function ecs_cpp_reset_count_inc()
    ccall((:ecs_cpp_reset_count_inc, libflecs), Int32, ())
end

function ecs_cpp_last_member(world, type)
    ccall((:ecs_cpp_last_member, libflecs), Ptr{ecs_member_t}, (Ptr{ecs_world_t}, ecs_entity_t), world, type)
end

function ecs_os_memdup(src, size)
    ccall((:ecs_os_memdup, libflecs), Ptr{Cvoid}, (Ptr{Cvoid}, ecs_size_t), src, size)
end

struct ecs_time_t
    sec::UInt32
    nanosec::UInt32
end

const ecs_os_thread_t = Csize_t

const ecs_os_cond_t = Csize_t

const ecs_os_mutex_t = Csize_t

const ecs_os_dl_t = Csize_t

const ecs_os_sock_t = Csize_t

const ecs_os_thread_id_t = UInt64

# typedef void ( * ecs_os_proc_t ) ( void )
const ecs_os_proc_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_init_t ) ( void )
const ecs_os_api_init_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_fini_t ) ( void )
const ecs_os_api_fini_t = Ptr{Cvoid}

# typedef void * ( * ecs_os_api_malloc_t ) ( ecs_size_t size )
const ecs_os_api_malloc_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_free_t ) ( void * ptr )
const ecs_os_api_free_t = Ptr{Cvoid}

# typedef void * ( * ecs_os_api_realloc_t ) ( void * ptr , ecs_size_t size )
const ecs_os_api_realloc_t = Ptr{Cvoid}

# typedef void * ( * ecs_os_api_calloc_t ) ( ecs_size_t size )
const ecs_os_api_calloc_t = Ptr{Cvoid}

# typedef char * ( * ecs_os_api_strdup_t ) ( const char * str )
const ecs_os_api_strdup_t = Ptr{Cvoid}

# typedef void * ( * ecs_os_thread_callback_t ) ( void * )
const ecs_os_thread_callback_t = Ptr{Cvoid}

# typedef ecs_os_thread_t ( * ecs_os_api_thread_new_t ) ( ecs_os_thread_callback_t callback , void * param )
const ecs_os_api_thread_new_t = Ptr{Cvoid}

# typedef void * ( * ecs_os_api_thread_join_t ) ( ecs_os_thread_t thread )
const ecs_os_api_thread_join_t = Ptr{Cvoid}

# typedef ecs_os_thread_id_t ( * ecs_os_api_thread_self_t ) ( void )
const ecs_os_api_thread_self_t = Ptr{Cvoid}

# typedef ecs_os_thread_t ( * ecs_os_api_task_new_t ) ( ecs_os_thread_callback_t callback , void * param )
const ecs_os_api_task_new_t = Ptr{Cvoid}

# typedef void * ( * ecs_os_api_task_join_t ) ( ecs_os_thread_t thread )
const ecs_os_api_task_join_t = Ptr{Cvoid}

# typedef int32_t ( * ecs_os_api_ainc_t ) ( int32_t * value )
const ecs_os_api_ainc_t = Ptr{Cvoid}

# typedef int64_t ( * ecs_os_api_lainc_t ) ( int64_t * value )
const ecs_os_api_lainc_t = Ptr{Cvoid}

# typedef ecs_os_mutex_t ( * ecs_os_api_mutex_new_t ) ( void )
const ecs_os_api_mutex_new_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_mutex_lock_t ) ( ecs_os_mutex_t mutex )
const ecs_os_api_mutex_lock_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_mutex_unlock_t ) ( ecs_os_mutex_t mutex )
const ecs_os_api_mutex_unlock_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_mutex_free_t ) ( ecs_os_mutex_t mutex )
const ecs_os_api_mutex_free_t = Ptr{Cvoid}

# typedef ecs_os_cond_t ( * ecs_os_api_cond_new_t ) ( void )
const ecs_os_api_cond_new_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_cond_free_t ) ( ecs_os_cond_t cond )
const ecs_os_api_cond_free_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_cond_signal_t ) ( ecs_os_cond_t cond )
const ecs_os_api_cond_signal_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_cond_broadcast_t ) ( ecs_os_cond_t cond )
const ecs_os_api_cond_broadcast_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_cond_wait_t ) ( ecs_os_cond_t cond , ecs_os_mutex_t mutex )
const ecs_os_api_cond_wait_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_sleep_t ) ( int32_t sec , int32_t nanosec )
const ecs_os_api_sleep_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_enable_high_timer_resolution_t ) ( bool enable )
const ecs_os_api_enable_high_timer_resolution_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_get_time_t ) ( ecs_time_t * time_out )
const ecs_os_api_get_time_t = Ptr{Cvoid}

# typedef uint64_t ( * ecs_os_api_now_t ) ( void )
const ecs_os_api_now_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_log_t ) ( int32_t level , /* Logging level */ const char * file , /* File where message was logged */ int32_t line , /* Line it was logged */ const char * msg )
const ecs_os_api_log_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_abort_t ) ( void )
const ecs_os_api_abort_t = Ptr{Cvoid}

# typedef ecs_os_dl_t ( * ecs_os_api_dlopen_t ) ( const char * libname )
const ecs_os_api_dlopen_t = Ptr{Cvoid}

# typedef ecs_os_proc_t ( * ecs_os_api_dlproc_t ) ( ecs_os_dl_t lib , const char * procname )
const ecs_os_api_dlproc_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_dlclose_t ) ( ecs_os_dl_t lib )
const ecs_os_api_dlclose_t = Ptr{Cvoid}

# typedef char * ( * ecs_os_api_module_to_path_t ) ( const char * module_id )
const ecs_os_api_module_to_path_t = Ptr{Cvoid}

# typedef void ( * ecs_os_api_perf_trace_t ) ( const char * filename , size_t line , const char * name )
const ecs_os_api_perf_trace_t = Ptr{Cvoid}

struct ecs_os_api_t
    init_::ecs_os_api_init_t
    fini_::ecs_os_api_fini_t
    malloc_::ecs_os_api_malloc_t
    realloc_::ecs_os_api_realloc_t
    calloc_::ecs_os_api_calloc_t
    free_::ecs_os_api_free_t
    strdup_::ecs_os_api_strdup_t
    thread_new_::ecs_os_api_thread_new_t
    thread_join_::ecs_os_api_thread_join_t
    thread_self_::ecs_os_api_thread_self_t
    task_new_::ecs_os_api_thread_new_t
    task_join_::ecs_os_api_thread_join_t
    ainc_::ecs_os_api_ainc_t
    adec_::ecs_os_api_ainc_t
    lainc_::ecs_os_api_lainc_t
    ladec_::ecs_os_api_lainc_t
    mutex_new_::ecs_os_api_mutex_new_t
    mutex_free_::ecs_os_api_mutex_free_t
    mutex_lock_::ecs_os_api_mutex_lock_t
    mutex_unlock_::ecs_os_api_mutex_lock_t
    cond_new_::ecs_os_api_cond_new_t
    cond_free_::ecs_os_api_cond_free_t
    cond_signal_::ecs_os_api_cond_signal_t
    cond_broadcast_::ecs_os_api_cond_broadcast_t
    cond_wait_::ecs_os_api_cond_wait_t
    sleep_::ecs_os_api_sleep_t
    now_::ecs_os_api_now_t
    get_time_::ecs_os_api_get_time_t
    log_::ecs_os_api_log_t
    abort_::ecs_os_api_abort_t
    dlopen_::ecs_os_api_dlopen_t
    dlproc_::ecs_os_api_dlproc_t
    dlclose_::ecs_os_api_dlclose_t
    module_to_dl_::ecs_os_api_module_to_path_t
    module_to_etc_::ecs_os_api_module_to_path_t
    perf_trace_push_::ecs_os_api_perf_trace_t
    perf_trace_pop_::ecs_os_api_perf_trace_t
    log_level_::Int32
    log_indent_::Int32
    log_last_error_::Int32
    log_last_timestamp_::Int64
    flags_::ecs_flags32_t
    log_out_::Ptr{Libc.FILE}
end

function ecs_os_init()
    ccall((:ecs_os_init, libflecs), Cvoid, ())
end

function ecs_os_fini()
    ccall((:ecs_os_fini, libflecs), Cvoid, ())
end

function ecs_os_set_api(os_api)
    ccall((:ecs_os_set_api, libflecs), Cvoid, (Ptr{ecs_os_api_t},), os_api)
end

function ecs_os_get_api()
    ccall((:ecs_os_get_api, libflecs), ecs_os_api_t, ())
end

function ecs_os_set_api_defaults()
    ccall((:ecs_os_set_api_defaults, libflecs), Cvoid, ())
end

function ecs_os_dbg(file, line, msg)
    ccall((:ecs_os_dbg, libflecs), Cvoid, (Ptr{Cchar}, Int32, Ptr{Cchar}), file, line, msg)
end

function ecs_os_trace(file, line, msg)
    ccall((:ecs_os_trace, libflecs), Cvoid, (Ptr{Cchar}, Int32, Ptr{Cchar}), file, line, msg)
end

function ecs_os_warn(file, line, msg)
    ccall((:ecs_os_warn, libflecs), Cvoid, (Ptr{Cchar}, Int32, Ptr{Cchar}), file, line, msg)
end

function ecs_os_err(file, line, msg)
    ccall((:ecs_os_err, libflecs), Cvoid, (Ptr{Cchar}, Int32, Ptr{Cchar}), file, line, msg)
end

function ecs_os_fatal(file, line, msg)
    ccall((:ecs_os_fatal, libflecs), Cvoid, (Ptr{Cchar}, Int32, Ptr{Cchar}), file, line, msg)
end

function ecs_os_strerror(err)
    ccall((:ecs_os_strerror, libflecs), Ptr{Cchar}, (Cint,), err)
end

function ecs_os_strset(str, value)
    ccall((:ecs_os_strset, libflecs), Cvoid, (Ptr{Ptr{Cchar}}, Ptr{Cchar}), str, value)
end

function ecs_os_perf_trace_push_(file, line, name)
    ccall((:ecs_os_perf_trace_push_, libflecs), Cvoid, (Ptr{Cchar}, Csize_t, Ptr{Cchar}), file, line, name)
end

function ecs_os_perf_trace_pop_(file, line, name)
    ccall((:ecs_os_perf_trace_pop_, libflecs), Cvoid, (Ptr{Cchar}, Csize_t, Ptr{Cchar}), file, line, name)
end

function ecs_sleepf(t)
    ccall((:ecs_sleepf, libflecs), Cvoid, (Cdouble,), t)
end

function ecs_time_measure(start)
    ccall((:ecs_time_measure, libflecs), Cdouble, (Ptr{ecs_time_t},), start)
end

function ecs_time_sub(t1, t2)
    ccall((:ecs_time_sub, libflecs), ecs_time_t, (ecs_time_t, ecs_time_t), t1, t2)
end

function ecs_time_to_double(t)
    ccall((:ecs_time_to_double, libflecs), Cdouble, (ecs_time_t,), t)
end

function ecs_os_has_heap()
    ccall((:ecs_os_has_heap, libflecs), Bool, ())
end

function ecs_os_has_threading()
    ccall((:ecs_os_has_threading, libflecs), Bool, ())
end

function ecs_os_has_task_support()
    ccall((:ecs_os_has_task_support, libflecs), Bool, ())
end

function ecs_os_has_time()
    ccall((:ecs_os_has_time, libflecs), Bool, ())
end

function ecs_os_has_logging()
    ccall((:ecs_os_has_logging, libflecs), Bool, ())
end

function ecs_os_has_dl()
    ccall((:ecs_os_has_dl, libflecs), Bool, ())
end

function ecs_os_has_modules()
    ccall((:ecs_os_has_modules, libflecs), Bool, ())
end

const FLECS_VERSION_MAJOR = 4

const FLECS_VERSION_MINOR = 0

const FLECS_VERSION_PATCH = 3

const ecs_float_t = Float32

const ecs_ftime_t = ecs_float_t

const FLECS_HI_COMPONENT_ID = 256

const FLECS_HI_ID_RECORD_ID = 1024

const FLECS_SPARSE_PAGE_BITS = 12

const FLECS_ENTITY_PAGE_BITS = 12

const FLECS_ID_DESC_MAX = 32

const FLECS_EVENT_DESC_MAX = 8

const FLECS_VARIABLE_COUNT_MAX = 64

const FLECS_TERM_COUNT_MAX = 32

const FLECS_TERM_ARG_COUNT_MAX = 16

const FLECS_QUERY_VARIABLE_COUNT_MAX = 64

const FLECS_QUERY_SCOPE_NESTING_MAX = 8

const EcsWorldQuitWorkers = Cuint(1) << 0

const EcsWorldReadonly = Cuint(1) << 1

const EcsWorldInit = Cuint(1) << 2

const EcsWorldQuit = Cuint(1) << 3

const EcsWorldFini = Cuint(1) << 4

const EcsWorldMeasureFrameTime = Cuint(1) << 5

const EcsWorldMeasureSystemTime = Cuint(1) << 6

const EcsWorldMultiThreaded = Cuint(1) << 7

const EcsWorldFrameInProgress = Cuint(1) << 8

const EcsOsApiHighResolutionTimer = Cuint(1) << 0

const EcsOsApiLogWithColors = Cuint(1) << 1

const EcsOsApiLogWithTimeStamp = Cuint(1) << 2

const EcsOsApiLogWithTimeDelta = Cuint(1) << 3

const EcsEntityIsId = Cuint(1) << 31

const EcsEntityIsTarget = Cuint(1) << 30

const EcsEntityIsTraversable = Cuint(1) << 29

const EcsIdOnDeleteRemove = Cuint(1) << 0

const EcsIdOnDeleteDelete = Cuint(1) << 1

const EcsIdOnDeletePanic = Cuint(1) << 2

const EcsIdOnDeleteMask = (EcsIdOnDeletePanic | EcsIdOnDeleteRemove) | EcsIdOnDeleteDelete

const EcsIdOnDeleteObjectRemove = Cuint(1) << 3

const EcsIdOnDeleteObjectDelete = Cuint(1) << 4

const EcsIdOnDeleteObjectPanic = Cuint(1) << 5

const EcsIdOnDeleteObjectMask = (EcsIdOnDeleteObjectPanic | EcsIdOnDeleteObjectRemove) | EcsIdOnDeleteObjectDelete

const EcsIdOnInstantiateOverride = Cuint(1) << 6

const EcsIdOnInstantiateInherit = Cuint(1) << 7

const EcsIdOnInstantiateDontInherit = Cuint(1) << 8

const EcsIdOnInstantiateMask = (EcsIdOnInstantiateOverride | EcsIdOnInstantiateInherit) | EcsIdOnInstantiateDontInherit

const EcsIdExclusive = Cuint(1) << 9

const EcsIdTraversable = Cuint(1) << 10

const EcsIdTag = Cuint(1) << 11

const EcsIdWith = Cuint(1) << 12

const EcsIdCanToggle = Cuint(1) << 13

const EcsIdIsTransitive = Cuint(1) << 14

const EcsIdHasOnAdd = Cuint(1) << 16

const EcsIdHasOnRemove = Cuint(1) << 17

const EcsIdHasOnSet = Cuint(1) << 18

const EcsIdHasOnTableFill = Cuint(1) << 19

const EcsIdHasOnTableEmpty = Cuint(1) << 20

const EcsIdHasOnTableCreate = Cuint(1) << 21

const EcsIdHasOnTableDelete = Cuint(1) << 22

const EcsIdIsSparse = Cuint(1) << 23

const EcsIdIsUnion = Cuint(1) << 24

const EcsIdEventMask = (((((((EcsIdHasOnAdd | EcsIdHasOnRemove) | EcsIdHasOnSet) | EcsIdHasOnTableFill) | EcsIdHasOnTableEmpty) | EcsIdHasOnTableCreate) | EcsIdHasOnTableDelete) | EcsIdIsSparse) | EcsIdIsUnion

const EcsIdMarkedForDelete = Cuint(1) << 30

const EcsIterIsValid = Cuint(1) << Cuint(0)

const EcsIterNoData = Cuint(1) << Cuint(1)

const EcsIterNoResults = Cuint(1) << Cuint(3)

const EcsIterIgnoreThis = Cuint(1) << Cuint(4)

const EcsIterHasCondSet = Cuint(1) << Cuint(6)

const EcsIterProfile = Cuint(1) << Cuint(7)

const EcsIterTrivialSearch = Cuint(1) << Cuint(8)

const EcsIterTrivialTest = Cuint(1) << Cuint(11)

const EcsIterTrivialCached = Cuint(1) << Cuint(14)

const EcsIterCacheSearch = Cuint(1) << Cuint(15)

const EcsIterFixedInChangeComputed = Cuint(1) << Cuint(16)

const EcsIterFixedInChanged = Cuint(1) << Cuint(17)

const EcsIterSkip = Cuint(1) << Cuint(18)

const EcsIterCppEach = Cuint(1) << Cuint(19)

const EcsIterTableOnly = Cuint(1) << Cuint(20)

const EcsEventTableOnly = Cuint(1) << Cuint(20)

const EcsEventNoOnSet = Cuint(1) << Cuint(16)

const EcsQueryMatchThis = Cuint(1) << Cuint(11)

const EcsQueryMatchOnlyThis = Cuint(1) << Cuint(12)

const EcsQueryMatchOnlySelf = Cuint(1) << Cuint(13)

const EcsQueryMatchWildcards = Cuint(1) << Cuint(14)

const EcsQueryMatchNothing = Cuint(1) << Cuint(15)

const EcsQueryHasCondSet = Cuint(1) << Cuint(16)

const EcsQueryHasPred = Cuint(1) << Cuint(17)

const EcsQueryHasScopes = Cuint(1) << Cuint(18)

const EcsQueryHasRefs = Cuint(1) << Cuint(19)

const EcsQueryHasOutTerms = Cuint(1) << Cuint(20)

const EcsQueryHasNonThisOutTerms = Cuint(1) << Cuint(21)

const EcsQueryHasMonitor = Cuint(1) << Cuint(22)

const EcsQueryIsTrivial = Cuint(1) << Cuint(23)

const EcsQueryHasCacheable = Cuint(1) << Cuint(24)

const EcsQueryIsCacheable = Cuint(1) << Cuint(25)

const EcsQueryHasTableThisVar = Cuint(1) << Cuint(26)

const EcsQueryCacheYieldEmptyTables = Cuint(1) << Cuint(27)

const EcsQueryNested = Cuint(1) << Cuint(28)

const EcsTermMatchAny = Cuint(1) << 0

const EcsTermMatchAnySrc = Cuint(1) << 1

const EcsTermTransitive = Cuint(1) << 2

const EcsTermReflexive = Cuint(1) << 3

const EcsTermIdInherited = Cuint(1) << 4

const EcsTermIsTrivial = Cuint(1) << 5

const EcsTermIsCacheable = Cuint(1) << 7

const EcsTermIsScope = Cuint(1) << 8

const EcsTermIsMember = Cuint(1) << 9

const EcsTermIsToggle = Cuint(1) << 10

const EcsTermKeepAlive = Cuint(1) << 11

const EcsTermIsSparse = Cuint(1) << 12

const EcsTermIsUnion = Cuint(1) << 13

const EcsTermIsOr = Cuint(1) << 14

const EcsObserverIsMulti = Cuint(1) << Cuint(1)

const EcsObserverIsMonitor = Cuint(1) << Cuint(2)

const EcsObserverIsDisabled = Cuint(1) << Cuint(3)

const EcsObserverIsParentDisabled = Cuint(1) << Cuint(4)

const EcsObserverBypassQuery = Cuint(1) << Cuint(5)

const EcsObserverYieldOnCreate = Cuint(1) << Cuint(6)

const EcsObserverYieldOnDelete = Cuint(1) << Cuint(7)

const EcsTableHasBuiltins = Cuint(1) << Cuint(1)

const EcsTableIsPrefab = Cuint(1) << Cuint(2)

const EcsTableHasIsA = Cuint(1) << Cuint(3)

const EcsTableHasChildOf = Cuint(1) << Cuint(4)

const EcsTableHasName = Cuint(1) << Cuint(5)

const EcsTableHasPairs = Cuint(1) << Cuint(6)

const EcsTableHasModule = Cuint(1) << Cuint(7)

const EcsTableIsDisabled = Cuint(1) << Cuint(8)

const EcsTableNotQueryable = Cuint(1) << Cuint(9)

const EcsTableHasCtors = Cuint(1) << Cuint(10)

const EcsTableHasDtors = Cuint(1) << Cuint(11)

const EcsTableHasCopy = Cuint(1) << Cuint(12)

const EcsTableHasMove = Cuint(1) << Cuint(13)

const EcsTableHasToggle = Cuint(1) << Cuint(14)

const EcsTableHasOverrides = Cuint(1) << Cuint(15)

const EcsTableHasOnAdd = Cuint(1) << Cuint(16)

const EcsTableHasOnRemove = Cuint(1) << Cuint(17)

const EcsTableHasOnSet = Cuint(1) << Cuint(18)

const EcsTableHasOnTableFill = Cuint(1) << Cuint(19)

const EcsTableHasOnTableEmpty = Cuint(1) << Cuint(20)

const EcsTableHasOnTableCreate = Cuint(1) << Cuint(21)

const EcsTableHasOnTableDelete = Cuint(1) << Cuint(22)

const EcsTableHasSparse = Cuint(1) << Cuint(23)

const EcsTableHasUnion = Cuint(1) << Cuint(24)

const EcsTableHasTraversable = Cuint(1) << Cuint(26)

const EcsTableMarkedForDelete = Cuint(1) << Cuint(30)

const EcsTableHasLifecycle = EcsTableHasCtors | EcsTableHasDtors

const EcsTableIsComplex = (EcsTableHasLifecycle | EcsTableHasToggle) | EcsTableHasSparse

const EcsTableHasAddActions = ((EcsTableHasIsA | EcsTableHasCtors) | EcsTableHasOnAdd) | EcsTableHasOnSet

const EcsTableHasRemoveActions = (EcsTableHasIsA | EcsTableHasDtors) | EcsTableHasOnRemove

const EcsTableEdgeFlags = ((EcsTableHasOnAdd | EcsTableHasOnRemove) | EcsTableHasSparse) | EcsTableHasUnion

const EcsTableAddEdgeFlags = (EcsTableHasOnAdd | EcsTableHasSparse) | EcsTableHasUnion

const EcsTableRemoveEdgeFlags = (EcsTableHasOnRemove | EcsTableHasSparse) | EcsTableHasUnion

const EcsAperiodicEmptyTables = Cuint(1) << Cuint(1)

const EcsAperiodicComponentMonitors = Cuint(1) << Cuint(2)

const EcsAperiodicEmptyQueries = Cuint(1) << Cuint(4)

const ecs_world_t_magic = 0x65637377

const ecs_stage_t_magic = 0x65637373

const ecs_query_t_magic = 0x65637375

const ecs_observer_t_magic = 0x65637362

const ECS_ROW_MASK = Cuint(0x0fffffff)

const ECS_ROW_FLAGS_MASK = ~ECS_ROW_MASK

const ECS_ID_FLAGS_MASK = Culonglong(0xff) << 60

const ECS_ENTITY_MASK = Culonglong(0xffffffff)

const ECS_GENERATION_MASK = Culonglong(0xffff) << 32

const ECS_COMPONENT_MASK = ~ECS_ID_FLAGS_MASK

const EcsSelf = Culonglong(1) << 63

const EcsUp = Culonglong(1) << 62

const EcsTrav = Culonglong(1) << 61

const EcsCascade = Culonglong(1) << 60

const EcsDesc = Culonglong(1) << 59

const EcsTraverseFlags = (((EcsSelf | EcsUp) | EcsTrav) | EcsCascade) | EcsDesc

const EcsIsVariable = Culonglong(1) << 58

const EcsIsEntity = Culonglong(1) << 57

const EcsIsName = Culonglong(1) << 56

const EcsTermRefFlags = ((EcsTraverseFlags | EcsIsVariable) | EcsIsEntity) | EcsIsName

const EcsIterNextYield = 0

const EcsIterYield = -1

const EcsIterNext = 1

const FLECS_SPARSE_PAGE_SIZE = 1 << FLECS_SPARSE_PAGE_BITS

const ECS_STACK_PAGE_SIZE = 4096

# Skipping MacroDefinition: ECS_STRBUF_INIT ( ecs_strbuf_t ) { 0 }

const ECS_STRBUF_SMALL_STRING_SIZE = 512

const ECS_STRBUF_MAX_LIST_DEPTH = 32

const flecs_iter_cache_ids = Cuint(1) << Cuint(0)

const flecs_iter_cache_trs = Cuint(1) << Cuint(1)

const flecs_iter_cache_sources = Cuint(1) << Cuint(2)

const flecs_iter_cache_ptrs = Cuint(1) << Cuint(3)

const flecs_iter_cache_variables = Cuint(1) << Cuint(4)

const flecs_iter_cache_all = 255

const ECS_MAX_RECURSION = 512

const ECS_MAX_TOKEN_SIZE = 256

const EcsQueryMatchPrefab = Cuint(1) << Cuint(1)

const EcsQueryMatchDisabled = Cuint(1) << Cuint(2)

const EcsQueryMatchEmptyTables = Cuint(1) << Cuint(3)

const EcsQueryAllowUnresolvedByName = Cuint(1) << Cuint(6)

const EcsQueryTableOnly = Cuint(1) << Cuint(7)

const EcsFirstUserComponentId = 8

const EcsFirstUserEntityId = FLECS_HI_COMPONENT_ID + 128

const ECS_INVALID_PARAMETER = 2

# Skipping MacroDefinition: ecs_dummy_check if ( ( false ) ) { goto error ; }

const ECS_INVALID_OPERATION = 1

const ECS_CONSTRAINT_VIOLATED = 3

const ECS_OUT_OF_MEMORY = 4

const ECS_OUT_OF_RANGE = 5

const ECS_UNSUPPORTED = 6

const ECS_INTERNAL_ERROR = 7

const ECS_ALREADY_DEFINED = 8

const ECS_MISSING_OS_API = 9

const ECS_OPERATION_FAILED = 10

const ECS_INVALID_CONVERSION = 11

const ECS_ID_IN_USE = 12

const ECS_CYCLE_DETECTED = 13

const ECS_LEAK_DETECTED = 14

const ECS_DOUBLE_FREE = 15

const ECS_INCONSISTENT_NAME = 20

const ECS_NAME_IN_USE = 21

const ECS_NOT_A_COMPONENT = 22

const ECS_INVALID_COMPONENT_SIZE = 23

const ECS_INVALID_COMPONENT_ALIGNMENT = 24

const ECS_COMPONENT_NOT_REGISTERED = 25

const ECS_INCONSISTENT_COMPONENT_ID = 26

const ECS_INCONSISTENT_COMPONENT_ACTION = 27

const ECS_MODULE_UNDEFINED = 28

const ECS_MISSING_SYMBOL = 29

const ECS_ALREADY_IN_USE = 30

const ECS_ACCESS_VIOLATION = 40

const ECS_COLUMN_INDEX_OUT_OF_RANGE = 41

const ECS_COLUMN_IS_NOT_SHARED = 42

const ECS_COLUMN_IS_SHARED = 43

const ECS_COLUMN_TYPE_MISMATCH = 45

const ECS_INVALID_WHILE_READONLY = 70

const ECS_LOCKED_STORAGE = 71

const ECS_INVALID_FROM_WORKER = 72

const ECS_BLACK = "\e[1;30m"

const ECS_RED = "\e[0;31m"

const ECS_GREEN = "\e[0;32m"

const ECS_YELLOW = "\e[0;33m"

const ECS_BLUE = "\e[0;34m"

const ECS_MAGENTA = "\e[0;35m"

const ECS_CYAN = "\e[0;36m"

const ECS_WHITE = "\e[1;37m"

const ECS_GREY = "\e[0;37m"

const ECS_NORMAL = "\e[0;49m"

const ECS_BOLD = "\e[1;49m"

const ECS_HTTP_HEADER_COUNT_MAX = 32

const ECS_HTTP_QUERY_PARAM_COUNT_MAX = 32

# Skipping MacroDefinition: ECS_HTTP_REPLY_INIT ( ecs_http_reply_t ) { 200 , ECS_STRBUF_INIT , "OK" , "application/json" , ECS_STRBUF_INIT }

const ECS_REST_DEFAULT_PORT = 27750

const ECS_STAT_WINDOW = 60

const ECS_ALERT_MAX_SEVERITY_FILTERS = 4

# Skipping MacroDefinition: ECS_ENTITY_TO_JSON_INIT ( ecs_entity_to_json_desc_t ) { . serialize_doc = false , . serialize_full_paths = true , . serialize_inherited = false , . serialize_values = true , . serialize_builtin = false , . serialize_type_info = false , . serialize_alerts = false , . serialize_refs = 0 , . serialize_matches = false , \
#}

# Skipping MacroDefinition: ECS_ITER_TO_JSON_INIT ( ecs_iter_to_json_desc_t ) { . serialize_entity_ids = false , . serialize_values = true , . serialize_builtin = false , . serialize_doc = false , . serialize_full_paths = true , . serialize_fields = true , . serialize_inherited = false , . serialize_table = false , . serialize_type_info = false , . serialize_field_info = false , . serialize_query_info = false , . serialize_query_plan = false , . serialize_query_profile = false , . dont_serialize_results = false , . serialize_alerts = false , . serialize_refs = false , . serialize_matches = false , \
#}

const ECS_MEMBER_DESC_CACHE_SIZE = 32

const ECS_META_MAX_SCOPE_DEPTH = 32

# exports
const PREFIXES = ["ecs_", "FLECS_API"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
