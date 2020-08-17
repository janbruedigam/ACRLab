function update!(args...)
    dict = args[end]
    dict["btn1"][] == 0 && dict["btn2"][] == 0 && return

    if dict["btn1"][] == 1
        dict["btn1"]["is-loading"][] = true
        println("Running simulation")
        run1!(dict)
        dict["btn1"]["is-loading"][] = false
        dict["btn1"][] = 0
    elseif dict["btn2"][] == 1
        dict["btn2"]["is-loading"][] = true
        println("Running simulation")
        run2!(dict)
        dict["btn2"]["is-loading"][] = false
        dict["btn2"][] = 0
    end    

    return
end

function run1!(dict)


    # Parameters
    joint_axis = [1.0;0.0;0.0]

    length1 = 1.0
    width, depth = 0.1, 0.1
    box = Box(width, depth, length1, length1)

    p2 = [0.0;0.0;length1 / 2] # joint connection point

    # Initial orientation
    ϕ1 = π / 2
    q1 = UnitQuaternion(RotX(ϕ1))

    # Links
    origin = Origin{Float64}()
    link1 = Body(box)

    # Constraints
    joint_between_origin_and_link1 = EqualityConstraint(Revolute(origin, link1, joint_axis; p2=p2))

    links = [link1]
    constraints = [joint_between_origin_and_link1]
    shapes = [box]


    mech = Mechanism(origin, links, constraints, shapes = shapes)
    # setPosition!(origin,link1,p2 = p2,Δq = q1)
    setPosition!(origin,link1,p2 = p2)

    jointid = constraints[1].id
    function controller!(mechanism, k)
        τ = SA[eval(Meta.parse(dict["txtbx1"][]))]
        setForce!(mechanism, geteqconstraint(mechanism,jointid), τ)
        return
    end

    storage = simulate!(mech, 10., controller!, record = true)
    visualize(mech, storage, shapes)

    return

end

function run2!(dict)


    # Parameters
    joint_axis = [1.0;0.0;0.0]

    length1 = 1.0
    width, depth = 0.1, 0.1
    box = Box(width, depth, length1, length1)

    p2 = [0.0;0.0;length1 / 2] # joint connection point

    # Initial orientation
    ϕ1 = π / 2
    q1 = UnitQuaternion(RotX(ϕ1))

    # Links
    origin = Origin{Float64}()
    link1 = Body(box)

    # Constraints
    joint_between_origin_and_link1 = EqualityConstraint(Revolute(origin, link1, joint_axis; p2=p2))

    links = [link1]
    constraints = [joint_between_origin_and_link1]
    shapes = [box]


    mech = Mechanism(origin, links, constraints, shapes = shapes)
    # setPosition!(origin,link1,p2 = p2,Δq = q1)
    setPosition!(origin,link1,p2 = p2)

    jointid = constraints[1].id
    function controller!(mechanism, k)
        τ = SA[eval(Meta.parse(dict["txtbx2"][]))]
        setForce!(mechanism, geteqconstraint(mechanism,jointid), τ)
        return
    end

    storage = simulate!(mech, 10., controller!, record = true)
    visualize(mech, storage, shapes)

    return

end