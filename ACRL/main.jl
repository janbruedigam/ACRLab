using Pkg
@info "Setting up ACRLab. This can take several minutes the first time."
Pkg.activate("ACRL")
Pkg.instantiate()

# deps = Pkg.dependencies()
# if haskey(deps,Base.UUID("ad839575-38b3-5650-b840-f874b8c74a25")) && deps[Base.UUID("ad839575-38b3-5650-b840-f874b8c74a25")].version == v"0.12.3" && # Blink
#         haskey(deps,Base.UUID("5933d0f4-dc4a-46ce-a189-54b4465bd7a4")) && deps[Base.UUID("5933d0f4-dc4a-46ce-a189-54b4465bd7a4")].version == v"0.1.0" && # ConstrainedControl
#         haskey(deps,Base.UUID("65b0d8a9-e9fd-4f02-8653-a7163c490b26")) && deps[Base.UUID("65b0d8a9-e9fd-4f02-8653-a7163c490b26")].version == v"0.5.3" && # ConstrainedDynamics
#         haskey(deps,Base.UUID("07ee0992-da0a-4409-aa8f-e0a0c9c09c30")) && deps[Base.UUID("07ee0992-da0a-4409-aa8f-e0a0c9c09c30")].version == v"0.2.2" && # ConstrainedDynamicsVis
#         haskey(deps,Base.UUID("c601a237-2ae4-5e1e-952c-7a85b0c7eef1")) && deps[Base.UUID("c601a237-2ae4-5e1e-952c-7a85b0c7eef1")].version == v"0.10.3" && # Interact
#         haskey(deps,Base.UUID("37e2e46d-f89d-539d-b4ee-838fcccc9c8e")) && # LinearAlgebra
#         haskey(deps,Base.UUID("6038ab10-8711-5258-84ad-4b1120ba62dc")) && deps[Base.UUID("6038ab10-8711-5258-84ad-4b1120ba62dc")].version == v"1.0.1" && # Rotations
#         haskey(deps,Base.UUID("90137ffa-7385-5640-81b9-e52037218182")) && deps[Base.UUID("90137ffa-7385-5640-81b9-e52037218182")].version == v"0.12.4" # StaticArrays

#     nothing
# else
#     Pkg.add(url="https://github.com/janbruedigam/ACRLab.jl")
# end

# deps = Pkg.dependencies()
# if haskey(deps,Base.UUID("ad839575-38b3-5650-b840-f874b8c74a25")) && deps[Base.UUID("ad839575-38b3-5650-b840-f874b8c74a25")].version == v"0.12.3" && # Blink
#         haskey(deps,Base.UUID("5933d0f4-dc4a-46ce-a189-54b4465bd7a4")) && deps[Base.UUID("5933d0f4-dc4a-46ce-a189-54b4465bd7a4")].version == v"0.1.0" && # ConstrainedControl
#         haskey(deps,Base.UUID("65b0d8a9-e9fd-4f02-8653-a7163c490b26")) && deps[Base.UUID("65b0d8a9-e9fd-4f02-8653-a7163c490b26")].version == v"0.5.3" && # ConstrainedDynamics
#         haskey(deps,Base.UUID("07ee0992-da0a-4409-aa8f-e0a0c9c09c30")) && deps[Base.UUID("07ee0992-da0a-4409-aa8f-e0a0c9c09c30")].version == v"0.2.2" && # ConstrainedDynamicsVis
#         haskey(deps,Base.UUID("c601a237-2ae4-5e1e-952c-7a85b0c7eef1")) && deps[Base.UUID("c601a237-2ae4-5e1e-952c-7a85b0c7eef1")].version == v"0.10.3" && # Interact
#         haskey(deps,Base.UUID("37e2e46d-f89d-539d-b4ee-838fcccc9c8e")) && # LinearAlgebra
#         haskey(deps,Base.UUID("6038ab10-8711-5258-84ad-4b1120ba62dc")) && deps[Base.UUID("6038ab10-8711-5258-84ad-4b1120ba62dc")].version == v"1.0.1" && # Rotations
#         haskey(deps,Base.UUID("90137ffa-7385-5640-81b9-e52037218182")) && deps[Base.UUID("90137ffa-7385-5640-81b9-e52037218182")].version == v"0.12.4" # StaticArrays

#     @info "Packages are installed."
# else
#     @error "Package error."
# end


@info "Loading ACRLab. This can take several minutes the first time."
using ACRLab

@info "Running main()"
main()