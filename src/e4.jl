mutable struct Controller4 <: Controller
    Δt::Real
    g::Real
    M::Real

    c::Real
    k::Real
    Fs::Real

    lqr::LQR
    F::Function
    control!::Function

    function Controller4(F,Δt,g,M,c,k,Fs,lqr)	
        new(Δt,g,M,c,k,Fs,lqr,F,control!)
    end
end

function control!(mechanism::Mechanism{T,Nn,Nb},controller::Controller4,kstep) where {T,Nn,Nb}
    Δt = controller.Δt
    g = controller.g
    M = controller.M
    c = controller.c
    k = controller.k
    Fs = controller.Fs
    lqr = controller.lqr
    F = controller.F
    cart = mechanism.bodies[1]
    pend1 = mechanism.bodies[2]
    pend2 = mechanism.bodies[3]

    zdes = F(zeros(6),I,kstep*Δt)
    ydes = zdes[1]
    xd1 = lqr.xd[1]
    xd2 = lqr.xd[2]
    xd3 = lqr.xd[3]
    lqr.xd[1] = [xd1[1];ydes;xd1[3]]
    lqr.xd[2] = [xd2[1];ydes;xd2[3]]
    lqr.xd[3] = [xd3[1];ydes;xd3[3]]

    Δz = zeros(T,Nb*12)
    qvm = QuatVecMap()
    for (id,body) in pairs(mechanism.bodies)
        colx = (id-1)*12+1:(id-1)*12+3
        colv = (id-1)*12+4:(id-1)*12+6
        colq = (id-1)*12+7:(id-1)*12+9
        colω = (id-1)*12+10:(id-1)*12+12

        state = body.state
        Δz[colx] = state.xsol[2]-lqr.xd[id]
        Δz[colv] = state.vsol[2]-lqr.vd[id]
        Δz[colq] = rotation_error(state.qsol[2],lqr.qd[id],qvm)
        Δz[colω] = state.ωsol[2]-lqr.ωd[id]
    end

    v = cart.state.vc[2]
    ω1 = pend1.state.ωc[1]
    ω2 = pend2.state.ωc[1]

    Fcart = -(lqr.K[1][1]*Δz)[1]
    if abs(Fcart)<Fs
        Fcart = sign(Fcart)*(Fs+0.1)
    end
    Fcart, Fpend1, Fpend2 = friction(Fcart, 0, 0, v, ω1, ω2, k, c, Fs)

    setForce!(mechanism, geteqconstraint(mechanism, 4), [Fcart])
    setForce!(mechanism, geteqconstraint(mechanism, 5), [Fpend1])
    setForce!(mechanism, geteqconstraint(mechanism, 6), [Fpend2])

    return
end

function run4!(str; vis::Bool=true)
    open("Files/E4.jl",create=true,write=true) do file
        write(file,"
        Δt = 0.01

        # Parameters from Table 1.2
        g = 9.81
        m1 = 0.135
        m2 = 0.123
        l1 = 0.140
        l2 = 0.135
        L1 = 0.280
        L2 = 0.270
        # I1
        # I2
        M = 4.5
        n1 = 0.026
        n2 = 0.010
        c = 0.002
        k = 0.3
        Fs = 8

        # Joint axes
        ex = [1.0;0.0;0.0]
        ey = [0.0;1.0;0.0]

        cartshape = Box(0.1, 0.5, 0.1, M)
        pend1shape = Box(0.055, 0.055/2, L1, m1, color = RGBA(1,0,0))
        pend2shape = Box(0.055, 0.055/2, L2, m2)

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
        joint2 = EqualityConstraint(Revolute(cart, pend1, ex; p2 = -p1))
        joint3 = EqualityConstraint(Revolute(pend1, pend2, ex; p1 = p1, p2 = -p2))

        links = [cart;pend1;pend2]
        constraints = [joint1;joint2;joint3]
        shapes = [cartshape;pend1shape;pend2shape]


        mech = Mechanism(origin, links, constraints, shapes = shapes, Δt = Δt)

        xinit = 0.0
        theta1init = pi
        theta2init = 0
        Q = diagm(ones(6))
        R = 0.1
        F(z,K,t) = K*zeros(6)

        ### Begin Student Input

        ")
        write(file, str)
        write(file, "
        
        ### End Student Input

        setPosition!(origin,cart,Δx = [0;xinit;0])
        setPosition!(cart,pend1,p2 = -p1, Δq = UnitQuaternion(RotX(theta1init)))
        setPosition!(pend1,pend2,p1 = p1, p2 = -p2, Δq = UnitQuaternion(RotX(theta1init+theta2init)))

        xd = [[[0;0.0;0.0]]; [p1]; [2*p1+p2]]

        Q1 = diagm([0;Q[1,1];0; 0;Q[2,2];0; 0;0;0; 0;0;0])
        Q2 = diagm([0;0;0; 0;0;0; Q[3,3]*4;0;0; Q[4,4];0;0])
        Q3 = diagm([0;0;0; 0;0;0; Q[5,5]*4;0;0; Q[6,6];0;0])
        Q = [[Q1];[Q2];[Q3]]
        Q = [diagm(ones(12)) for i=1:3]
        R = [ones(1,1)*R[1]]

        lqr = LQR(mech, getid.(links), [getid(constraints[1])], Q, R, Inf, xd=xd)

        controller = Controller4(F,Δt,g,M,c,k,Fs,lqr)

        steps = Base.OneTo(Int(20/Δt))
        storage = Storage{Float64}(steps,3)

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
        include("Files/E4.jl")
    catch
        println("Error. Bad code.")
    end

    return
end