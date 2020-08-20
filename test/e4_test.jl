using ACRLab


str = "
xinit = -0.5
theta1init = 0.1
theta2init = 0.1
"

ACRLab.run4!(str, vis = false)
@test true