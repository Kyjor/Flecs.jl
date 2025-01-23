using Clang.Generators
using flecs_jll

cd(@__DIR__)

include_dir = normpath(flecs_jll.artifact_dir, "include") |> normpath
println(include_dir)
flecs_dir = joinpath(include_dir, "flecs") |> normpath
flecs_h = joinpath(include_dir, "flecs.h")
println(flecs_h)

options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()  # Note you must call this function firstly and then append your own flags
push!(args, "-I$include_dir")
headers = [joinpath(flecs_dir, header) for header in readdir(flecs_dir) if endswith(header, ".h")]
pushfirst!(headers, flecs_h)
# there is also an experimental `detect_headers` function for auto-detecting top-level headers in the directory
# headers = detect_headers(flecs_dir, args)

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)