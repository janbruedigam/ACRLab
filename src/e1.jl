mutable struct Controller1 <: Controller
    g::Real
    m::Real
    l::Real
    c::Real
    k::Real
    Fs::Real
    F::Function
    control!::Function

    function Controller1(F,g,m,l,c,k,Fs)

        new(g,m,l,c,k,Fs,F,control!)
    end
end

function control!(mechanism,controller::Controller1,k)
    g = controller.g
    m = controller.m
    l = controller.l
    c = controller.c
    k = controller.k
    Fs = controller.Fs
    F = controller.F
    cart = mechanism.bodies[1]
    pend = mechanism.bodies[2]

    v = cart.state.vc[2]
    q = pend.state.qc
    θ = (rotation_angle(q) * rotation_axis(q))[1]
    ω = pend.state.ωc[1]
    V = 1/6*m*l^2*ω^2 + m*g*l*(1+cos(θ))

    Fcart = F(θ,ω,V) - sign(v)*k*g
    if v < 1e-3
        Fcart = sign(Fcart)*max(abs(Fcart)-Fs,0) 
    end
    Fpend = -c*ω

    setForce!(mechanism, geteqconstraint(mechanism, 3), [Fcart])
    setForce!(mechanism, geteqconstraint(mechanism, 4), [Fpend])

    return
end

function run1!(str)
    open("Files/E1.jl",create=true,write=true) do file
        write(file,"
        Δt = 0.01

        # Parameters from Table 1.1
        g = 9.81
        L1 = 0.28125
        l1 = L1/2
        l = (l1-0.135)/2 + l1
        M = 4.5
        m = 0.2585
        # I = 1/3*m*l^2
        c = 0.002
        k = 0.3
        Fs = 8

        # Joint axes
        ex = [1.0;0.0;0.0]
        ey = [0.0;1.0;0.0]

        cartshape = Box(0.1, 0.5, 0.1, M)
        pendshape = Box(0.055, 0.055, L1, m)

        p = [0.0;0.0;l1] # joint connection point

        # Desired orientation
        θ1 = 0

        # Links
        origin = Origin{Float64}()
        cart = Body(cartshape)
        pend = Body(pendshape)

        # Constraints
        joint1 = EqualityConstraint(Prismatic(origin, cart, ey))
        joint2 = EqualityConstraint(Revolute(cart, pend, ex; p2 = -p))

        links = [cart;pend]
        constraints = [joint1;joint2]
        shapes = [cartshape;pendshape]


        mech = Mechanism(origin, links, constraints, shapes = shapes, Δt = Δt, g = -g)
        setPosition!(origin,cart,Δx = [0;-0.5;0])
        setPosition!(cart,pend,p2 = -p, Δq = UnitQuaternion(RotX(pi)))

        F(theta,dtheta,Vis) = 0
        sgn(x) = x==0 ? 1 : sign(x)

        ### Begin Student Input

        ")
        write(file, str)
        write(file, "
        
        ### End Student Input

        controller = Controller1(F,g,m,l1,c,k,Fs)

        steps = Base.OneTo(Int(10/Δt))
        storage = Storage{Float64}(steps,2)

        try
            simulate!(mech,storage,controller,record = true)
        catch
            println(\"Error. Unstable behavior.\")
        end
        
        visualize(mech,storage,shapes)")
    end

    try
        include("Files/E1.jl")
    catch
        println("Error. Bad code.")
    end

    return
end