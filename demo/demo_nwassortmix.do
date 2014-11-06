nwclear

set obs 20
gen gender = (_n > 10) + 2
gen genderlabel = "Name"
label define genderlabel 2 "male" 3 "female"
label values gender genderlabel

nwassortmix gender, density(0.05) homophily(0)
nwplot, color(gender) layout(circle) arrows title("homophily = 0")
graph save g1, replace

nwassortmix gender, density(0.05) homophily(5)
nwplot, color(gender) layout(circle) arrows title("homophily = 5")
graph save g2, replace

nwassortmix gender, density(0.05) homophily(-5)
nwplot, color(gender) layout(circle) arrows title("homophily = -5")
graph save g3, replace

graph combine g1.gph g2.gph g3.gph


// Homophily on more than one dimension
nwclear

set obs 20
gen gender = (_n >= 6) + 2
gen race = int(0.5 + uniform()) 

nwexpand gender
nwexpand race

nwrandom 20, prob(1) name(dyadweight)
nwreplace dyadweight = exp(5 * same_gender) * exp((-5) * same_race)

nwdyadprob dyadweight, density(0.1) 
nwplot, color(gender) layout(circle) title("gender, homophily = exp(5)") 
graph save g4, replace
nwplot, color(race) colorpalette(yellow green) layout(circle) title("race, homophily = exp(-5)")
graph save g5, replace
graph combine g4.gph g5.gph 


