function update!(args...)
    dict = args[end]
    btns = ["btn1";"btn2";"btn3";"btn4"]
    txts = ["txt1";"txt2";"txt3";"txt4"]

    dict[btns[1]][] == 0 && dict[btns[2]][] == 0 && dict[btns[3]][] == 0 && dict[btns[4]][] == 0 && return

    for (i,btn) in enumerate(btns)
        if dict[btn][] == 1
            dict[btn]["is-loading"][] = true
            println("Starting simulation...")

            i==1 && run1!(dict[txts[i]][])
            i==2 && run2!(dict[txts[i]][])
            i==3 && run3!(dict[txts[i]][])
            i==4 && run4!(dict[txts[i]][])

            dict[btn]["is-loading"][] = false
            dict[btn][] = 0
        end
    end

    return
end

function friction(Fcart, Fpend, v, ω, k, c, Fs)
    if abs(v) < 1e-3 && abs(Fcart) < Fs 
        Fcart = 0
    end
    Fcart = Fcart - k*v
    Fpend = -c*ω

    return Fcart, Fpend
end

function friction(Fcart, Fpend1, Fpend2, v, ω1, ω2, k, c, Fs)
    if abs(v) < 1e-3 && abs(Fcart) < Fs 
        Fcart = 0
    end
    Fcart = Fcart - k*v
    Fpend1 = -c*ω1
    Fpend2 = -c*ω2

    return Fcart, Fpend1, Fpend2
end