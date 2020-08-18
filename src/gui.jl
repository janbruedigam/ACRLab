function main()
    setupgui()
    return
end

function setupgui()
    heading = "ACRLab 2: Inverted Pendulum"

    sub1 = "Pendulum Swing-Up"
    txt1 = textarea("F(theta,dtheta,Vis) = ...")
    btn1 = button("Execute")

    sub2 = "Implementation of a PID Controller"
    txt2 = textarea("F(e,inte,de) = ...")
    btn2 = button("Execute")

    sub3 = "Implementation of an LQ Regulator"
    txt3 = textarea("F(x,dx,theta,dtheta,t) = ...")
    btn3 = button("Execute")

    sub4 = "Double Pendulum"
    txt4 = textarea("F(x,dx,theta,dtheta,t) = ...")
    btn4 = button("Execute")

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