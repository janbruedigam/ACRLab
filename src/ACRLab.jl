module ACRLab

using StaticArrays
using Rotations
using ConstrainedDynamics
using ConstrainedDynamicsVis
using Interact
using Blink

export main,
    Controller1,
    Controller2,
    Controller3,
    Controller4


include("e1.jl")
include("e2.jl")
include("e3.jl")
include("e4.jl")
include("functions.jl")
include("gui.jl")

end
