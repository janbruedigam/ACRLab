mutable struct Controller3 <: Controller
    Δt::Real
    g::Real
    M::Real

    c::Real
    k::Real
    Fs::Real

    K::AbstractMatrix
    F::Function
    control!::Function

    function Controller3(F,Δt,g,M,m,l,c,k,Fs,Q,R)					
        I=1/3*m*l^2					
        v1=(M+m)/(I*(M+m)+(l^2*m*M))
        v2=(I+l^2*m)/(I*(M+m)+(l^2*m*M))
	
        A = [0 1 0 0
            0 -k*v2 ((l*m)^2*g*v2)/(I+m*l^2) (-l*m*c*v2)/(I+m*l^2)
            0 0 0 1
            0 -(l*m*k*v1)/(M+m) l*m*g*v1 -1*c*v1
        ]


        B = [
            0 
            v2 
            0 
            l*m*v1/(M+m)
        ]

        P = ConstrainedControl.care(A,B,Q,R)
        K = R\B'*P

        new(Δt,g,M,c,k,Fs,K,F,control!)
    end
end

function control!(mechanism,controller::Controller3,kstep)
    Δt = controller.Δt
    g = controller.g
    M = controller.M
    c = controller.c
    k = controller.k
    Fs = controller.Fs
    K = controller.K
    F = controller.F
    cart = mechanism.bodies[1]
    pend = mechanism.bodies[2]

    x = cart.state.xc[2]
    v = cart.state.vc[2]
    q = pend.state.qc
    θ = (rotation_angle(q) * rotation_axis(q))[1]
    ω = pend.state.ωc[1]

    z = [x;v;θ;ω]

    Fcart = F(z,K,kstep*Δt)
    Fcart, Fpend = friction(Fcart, 0, v, ω, k, c, Fs)

    setForce!(mechanism, geteqconstraint(mechanism, 3), [Fcart])
    setForce!(mechanism, geteqconstraint(mechanism, 4), [Fpend])

    return
end

function run3!(str; vis::Bool=true)
    open("Files/E3.jl",create=true,write=true) do file
        write(file,"
        Δt = 0.004

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

        xinit = 0.0
        theta1init = pi
        Q = [
            1 0 0 0
            0 1 0 0
            0 0 1 0
            0 0 0 1
        ]
        R = 1
        F(z,K) = 0

        ### Begin Student Input

        ")
        write(file, str)
        write(file, "
        
        ### End Student Input

        setPosition!(origin,cart,Δx = [0;xinit;0])
        setPosition!(cart,pend,p2 = -p, Δq = UnitQuaternion(RotX(theta1init)))

        controller = Controller3(F,Δt,g,M,m,l1,c,k,Fs,Q,R)

        steps = Base.OneTo(Int(10/Δt))
        storage = Storage{Float64}(steps,2)

        try
            simulate!(mech,storage,controller,record = true)
        catch
            println(\"Unstable behavior\")
        end")

        if vis
            write(file, "
            visualize(mech,storage,shapes)")
        end
    end

    try
        include("Files/E3.jl")
    catch
        println("Error. Bad code.")
    end

    return
end