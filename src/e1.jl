mutable struct Controller1 <: Controller
    l::Real
    m::Real
    F::Function
    control!::Function

    function Controller1(F,m,l)

        new(l,m,F,control!)
    end
end

function control!(mechanism,controller::Controller1,k)
    l = controller.l
    m = controller.m
    F = controller.F
    pend = mechanism.bodies[2]

    q = pend.state.qc
    θ = (rotation_angle(q) * rotation_axis(q))[1]
    ω = pend.state.ωc[1]
    V = 2/3*m*l^2*ω^2 + m*9.81*l*(1+cos(θ))
  
    u = [F(θ,ω,V)]
    setForce!(mechanism, geteqconstraint(mechanism, 3), u)

    return
end

function run1!(str)
    open("Files/E1.jl",create=true,write=true) do file
        write(file,"
        # Parameters
        ex = [1.0;0.0;0.0]
        ey = [0.0;1.0;0.0]
        m1 = 0.135
        m2 = 0.123
        l1 = 0.140
        l2 = 0.135
        L1 = 0.280
        L2 = 0.270
        M = 4.5

        cartshape = Box(0.1, 0.5, 0.1, M)
        pend1shape = Box(0.1, 0.1, L1, L1)
        pend2shape = Box(0.1, 0.1, L2, L2)

        p1 = [0.0;0.0;l1] # joint connection point
        p2 = [0.0;0.0;l2] # joint connection point

        # Desired orientation
        θ1 = 0
        θ2 = 0

        # Links
        origin = Origin{Float64}()
        cart = Body(cartshape)
        pend1 = Body(pend1shape)
        pend2 = Body(pend2shape)

        # Constraints
        joint1 = EqualityConstraint(Prismatic(origin, cart, ey))
        joint2 = EqualityConstraint(Revolute(cart, pend1, ex; p2 = -p2))

        links = [cart;pend1]
        constraints = [joint1;joint2]
        shapes = [cartshape;pend1shape]


        mech = Mechanism(origin, links, constraints, shapes = shapes, Δt = 0.01)
        setPosition!(origin,cart,Δx = [0;0.0;0])
        setPosition!(cart,pend1,p2 = -p2, Δq = UnitQuaternion(RotX(pi)))

        F(theta,dtheta,Vis) = 0
        sgn(x) = x==0 ? 1 : sign(x)

        ### Begin Student Input

        ")
        write(file, str)
        write(file, "
        
        ### End Student Input

        controller = Controller1(F,m1,l1)

        steps = Base.OneTo(1000)
        storage = Storage{Float64}(steps,2)

        try
            simulate!(mech,storage,controller,record = true)
        catch
            @info \"Unstable behavior\"
        end
        
        visualize(mech,storage,shapes)")
    end

    include("Files/E1.jl")

    return
end