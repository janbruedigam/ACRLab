using Pkg
@info "Setting up ACRLab. This can take several minutes the first time."
Pkg.activate("ACRL")
# Pkg.add(url="https://github.com/janbruedigam/ACRLab.jl") # Needed when updating the manifest file
Pkg.instantiate()

@info "Loading ACRLab. This can take several minutes the first time."
using ACRLab

@info "Running main()"
main()