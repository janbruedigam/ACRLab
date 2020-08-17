function main()
    setupgui()
    return
end

function setupgui()
    heading = "ACRLab 2: Inverted Pendulum"
    q1 = "Question 1"
    sym1 = "Allowed symbols: F, Kf, Vis, Vdes, theta, dtheta"
    Ftxt1 = "F = "
    txtbx1 = textbox("Kf * ...")
    btn1 = button("Execute")
    q2 = "Question 2"
    sym2 = "Allowed symbols: F, Kf, Vis, Vdes, theta, dtheta"
    Ftxt2 = "F = "
    txtbx2 = textbox("Kf * ...")
    btn2 = button("Execute")

    widgets = [txtbx1;btn1;txtbx2;btn2]
    widgetnames = ["txtbx1";"btn1";"txtbx2";"btn2"]
    dict = Dict{String,Widget}()
    for (i,el) in enumerate(widgets)
        dict[widgetnames[i]] = el
    end

    ui = map(update!,widgets...,dict)

    layout = vbox(
        ui,
        heading,
        vskip(1em),
        q1,
        vskip(1em),
        sym1,
        vskip(1em),
        hbox(Ftxt1,hskip(1em),txtbx1),
        btn1,
        vskip(1em),
        q2,
        vskip(1em),
        sym2,
        vskip(1em),
        hbox(Ftxt2,hskip(1em),txtbx2),
        btn2
    )

    window = Window()
    body!(window, layout)

end