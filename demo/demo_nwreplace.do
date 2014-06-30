
nwclear

nwrandom 7, density(.2) name(first)
nwrandom 7, density(.3) name(second) xvars
nwrandom 7, density(.3) name(third) xvars
gen attr= _n * 2

// replacing networks
nwreplace first = 1
nwreplace first = 2 in 3/5
nwreplace first = 3 if attr < 10
nwreplace first = 4 * second if _n < 5
nwreplace first = exp(second) * attr if _n >= 5

// replacing subnetworks
nwreplace first[(2::6),(1::5)] = 55
nwreplace first[(1::3),(1::3)] = 6 if attr !=2
nwreplace first[(1::4),(1::4)] = second * 7 if third != 1

// replacing with temporary networks
nwreplace first =  99 * (_nwrandom 7, prob(.3)) 

nwrandom 10, density(.4)

nwexpand 

nwgenerate peter = first[(2::6),(2::6)]

nwgenerate firstsecond = first & second

