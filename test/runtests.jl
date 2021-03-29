using Test
using SafeTestsets


mkpath("Files")

@safetestset "E1 Tests" begin
    include("e1_test.jl")
end

@safetestset "E2 Tests" begin
    include("e2_test.jl")
end

@safetestset "E3 Tests" begin
    include("e3_test.jl")
end

@safetestset "E4 Tests" begin
    include("e4_test.jl")
end

rm("Files"; force=true, recursive=true)