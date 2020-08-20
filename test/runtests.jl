using Test
using SafeTestsets


mkpath("Files")

@safetestset "Simulation Tests" begin
    include("e1_test.jl")
    include("e2_test.jl")
    include("e3_test.jl")
    include("e4_test.jl")
end

rm("Files"; force=true, recursive=true)