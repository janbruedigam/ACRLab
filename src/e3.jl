mutable struct Controller3 <: Controller
    K::AbstractMatrix
    F::Function
    control!::Function

    function Controller3(F,Q,R)
        g=9.81
        l=0.28125/2
        l1 = 0.28125/2
        l=(0.28125/2-0.135)/2 +l1
        M=4.5				
        m=0.131+0.0045+0.123			
        I=1/3*m*l^2			
        c=0.002			
        k=0.3			
        v1=(M+m)/(I*(M+m)+(l^2*m*M))
        v2=(I+l^2*m)/(I*(M+m)+(l^2*m*M))
	
        A = [0 1 0 0
            0 -k*v2 (-1*((l*m)^2)*g*v2)/(I+m*l^2) (l*m*c*v2)/(I+m*l^2)
            0 0 0 1
            0 (l*m*k*v1)/(M+m) l*m*g*v1 -1*c*v1
        ]


        B = [
            0 
            v2 
            0 
            (-1*l*m*v1/(M+m))
        ]

        P = ConstrainedControl.care(A,B,Q,R)
        K = R\B'*P

        new(K,F,control!)
    end
end

function control!(mechanism,controller::Controller3,k)
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

    u = [F(z,K)]
    setForce!(mechanism, geteqconstraint(mechanism, 3), u)

    return
end

function run3!(str)
    open("Files/E3.jl",create=true,write=true) do file
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
        setPosition!(cart,pend1,p2 = -p2, Δq = UnitQuaternion(RotX(0.01)))

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

        controller = Controller3(F,Q,R)

        steps = Base.OneTo(1000)
        storage = Storage{Float64}(steps,2)

        try
            simulate!(mech,storage,controller,record = true)
        catch
            @info \"Unstable behavior\"
        end

        visualize(mech,storage,shapes)")
    end

    include("Files/E3.jl")

    return
end