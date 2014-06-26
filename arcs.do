clear
set obs 1
gen x1 = 5
gen y1 = 4
gen x2 = 3
gen y2 = 4

gen l = sqrt((x1 - x2)^2 + (y1-y2)^2)
gen rad = 0.5*l

gen mult = 1 - 2 * (x2 > x1)
gen alpha = _pi/2 - acos(abs(x2-x1)/l)
gen beta = 2 * _pi - alpha 

gen y3n = (y1 + 1/2 * (y2 - y1)) 
gen x3n = (x1 + 1/2 * (x2 - x1)) 
gen x3 = x3n + mult* cos(beta) * rad
gen y3 = y3n + mult* sin(beta) * rad

gen r = sqrt(rad^2 + (1/2*l)^2)
gen gamma = acos((x3-x1) / r)
gen delta = acos((x3-x2) / r)

gen lid = _n
local spl = 10
expand `spl'
bys lid: gen llid = _n
gen alphaX = delta + (gamma - delta) * (llid - 1)/(`spl' -1)

gen x4 = x3 + mult* cos(alphaX + 2* _pi) * r
gen y4 = y3 + mult* sin(alphaX + 2* _pi) * r 

twoway (pcspike y1 x1 y2 x2) || (scatter y4 x4) || (scatter y3 x3)

replace x2 = x4
replace y2 = y4
replace x1 = x4[_n-1]
replace y1 = y4[_n-1] 
drop if llid == 1

twoway (pcspike y1 x1 y2 x2) || (scatter y4 x4, msymbol(S) ) ||(scatter y3 x3), yscale(range(0 10)) xscale(range(0 10)) aspectratio(1)

    
