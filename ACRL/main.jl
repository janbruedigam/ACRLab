using Pkg
Pkg.activate("ACRL")
# Pkg.instantiate()
deps = Pkg.dependencies()
if haskey(deps,Base.UUID("ad839575-38b3-5650-b840-f874b8c74a25")) && deps[Base.UUID("ad839575-38b3-5650-b840-f874b8c74a25")].version == v"0.12.3" && # Blink
        haskey(deps,Base.UUID("65b0d8a9-e9fd-4f02-8653-a7163c490b26")) && deps[Base.UUID("65b0d8a9-e9fd-4f02-8653-a7163c490b26")].version == v"0.5.3" && # ConstrainedDynamics
        haskey(deps,Base.UUID("07ee0992-da0a-4409-aa8f-e0a0c9c09c30")) && deps[Base.UUID("07ee0992-da0a-4409-aa8f-e0a0c9c09c30")].version == v"0.2.2" && # ConstrainedDynamicsVis
        haskey(deps,Base.UUID("c601a237-2ae4-5e1e-952c-7a85b0c7eef1")) && deps[Base.UUID("c601a237-2ae4-5e1e-952c-7a85b0c7eef1")].version == v"0.10.3" # Interact

    nothing
else
    Pkg.add(url="https://github.com/janbruedigam/ACRLab.jl")
end

deps = Pkg.dependencies()
if haskey(deps,Base.UUID("ad839575-38b3-5650-b840-f874b8c74a25")) && deps[Base.UUID("ad839575-38b3-5650-b840-f874b8c74a25")].version == v"0.12.3" && # Blink
        haskey(deps,Base.UUID("65b0d8a9-e9fd-4f02-8653-a7163c490b26")) && deps[Base.UUID("65b0d8a9-e9fd-4f02-8653-a7163c490b26")].version == v"0.5.3" && # ConstrainedDynamics
        haskey(deps,Base.UUID("07ee0992-da0a-4409-aa8f-e0a0c9c09c30")) && deps[Base.UUID("07ee0992-da0a-4409-aa8f-e0a0c9c09c30")].version == v"0.2.2" && # ConstrainedDynamicsVis
        haskey(deps,Base.UUID("c601a237-2ae4-5e1e-952c-7a85b0c7eef1")) && deps[Base.UUID("c601a237-2ae4-5e1e-952c-7a85b0c7eef1")].version == v"0.10.3" # Interact

    @info "Packages are installed."
else
    @error "Package error."
end


# using ACRLab
# main()
