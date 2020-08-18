function run1!(str)
    open("Files/E1.jl",create=true,write=true) do file
        write(file,"# Parameters
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

        jointid = joint1.id
        function controller!(mechanism,k)
            q = pend1.state.qc
            θ = (rotation_angle(q) * rotation_axis(q))[1]
            ω = pend1.state.ωc[1]
            V = 1/3*m1*L1^2*ω^2 + m1*9.81*l1*(1+cos(θ))
          
            u = [F(θ,ω,V)]
            setForce!(mechanism, geteqconstraint(mechanism, jointid), u)
        end
        
        steps = Base.OneTo(1000)
        storage = Storage{Float64}(steps,2)
        
        storage = simulate!(mech,storage,controller!,record = true)
        visualize(mech,storage,shapes)")
    end

    include("Files/E1.jl")

    return
end