function main()
    setupgui()
    return
end

function setupgui()
    heading = "ACRLab 2: Inverted Pendulum"

    sub1 = "Pendulum Swing-Up. Set \"F\", \"xinit\", and \"theta1init\"."
    txt1 = textarea("F(theta,dtheta,Vis) = ...")
    btn1 = button("Run Simulation")

    sub2 = "Implementation of a PID Controller. Set \"F\", \"xinit\", and \"theta1init\"."
    txt2 = textarea("function F(e,inte,de,theta,dtheta,Vis)\n\t...\nend")
    btn2 = button("Run Simulation")

    sub3 = "Implementation of an LQ Regulator. Set \"F\", \"xinit\", and \"theta1init\", \"Q\", \"R\"."
    txt3 = textarea("F(z,K,t) = ...")
    btn3 = button("Run Simulation")

    sub4 = "Double Pendulum"
    txt4 = textarea("F(x,dx,theta,dtheta,t) = ...")
    btn4 = button("Run Simulation")

    widgets = [txt1;btn1;txt2;btn2;txt3;btn3;txt4;btn4]
    widgetnames = ["txt1";"btn1";"txt2";"btn2";"txt3";"btn3";"txt4";"btn4"]
    dict = Dict{String,Widget}()
    for (i,el) in enumerate(widgets)
        dict[widgetnames[i]] = el
    end

    ui = map(update!,widgets...,dict)

    layout = vbox(
        ui,
        heading,
        vskip(1em),
        sub1,
        vskip(1em),
        txt1,
        vskip(1em),
        btn1,
        vskip(1em),
        sub2,
        vskip(1em),
        txt2,
        vskip(1em),
        btn2,
        vskip(1em),
        sub3,
        vskip(1em),
        txt3,
        vskip(1em),
        btn3,
        vskip(1em),
        sub4,
        vskip(1em),
        txt4,
        vskip(1em),
        btn4
    )

    mkpath("Files")

    window = Window()
    body!(window, layout)
end