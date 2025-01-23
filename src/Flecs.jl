module Flecs
    include("LibFlecs.jl")
    using .LibFlecs

    import Base.unsafe_convert

    function init()
    end
end # module
