using Pkg
@info "Setting up ACRLab. This can take several minutes the first time."
Pkg.activate("ACRL")
Pkg.instantiate()

@info "Loading ACRLab. This can take several minutes the first time."
using ACRLab

@info "Running main()"
main()
