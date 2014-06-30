nwclear
nwrandom 10, prob(.2) ntimes(4)

forvalues i = 1/4 {
	gen siz`i' = 5 + int(0.4*(uniform()*100))
	gen col`i' = int(3*uniform())
}

nwmovie _all, size(siz*) color(col*) scheme(s1color)
