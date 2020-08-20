using ACRLab


str = "
xinit = -0.5
theta1init = 0.1
"

ACRLab.run2!(str, vis = false)
@test true