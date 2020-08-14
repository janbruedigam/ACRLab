using Pkg
Pkg.activate("ACRL")
Pkg.instantiate()
@info "Instantiated Package"

using ACRLab
@info "Loaded Package"

main()
