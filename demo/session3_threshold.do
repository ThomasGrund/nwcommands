**********************************************
**********************************************
*****
*****		Introduction to agent-based modeling and 
*****		social network analysis using Stata
*****		
*****		30 May 2013, Institute for Futures Studies, Stockholm
*****		
*****
***** 		Stata commands to be used in the course
*****     
*****			Session 3: threshold and other models
*****
*****			@: Thomas Grund, thomas.grund@iffs.se
*****
**********************************************
**********************************************


****************************
*
*	Threshold model
*.
****************************

clear
set more off
set obs 400
gen threshold= uniform() * (_N - 1)

gen act0 = 0
sum threshold, detail
replace act0 = int(uniform() + .1)

forvalues t=0/50 {
	quietly sum act`t'
	gen 	act`=`t'+1' = act`t'
	replace act`=`t'+1' = 1 if threshold<=r(sum)
}

gen var=0
nwsvggraph, ncol(act*) lattice nonet
nwsvggraph, ncolor(act*) ystretch(.5) labeltext("Time: ") animationspeed(2) lattice nonet

gen thresholdsize = 3 + threshold / 50
nwsvggraph, ncolor(act*) ystretch(.5) labeltext("Time: ") lattice nonet nsize(thresholdsize )


****************************
*
*	Threshold model on a network
*.
****************************


* Instead of having the whole population as a reference point, we let agents now only focus on the
* immediate neighborshood and 10 x 10 lattice.

set more off
clear
nwlattice, r(10) c(10)
nwsym, unweighted
nwdegree
gen threshold=uniform() * outdegree
gen act=int(uniform()+.1)
qui forvalues t=1/50 { 
	gen act_time`t' = act
	nwcontext act, gen(pressure)
	replace act = 1 if pressure >= threshold & act == 0
	drop pressure
}
nwsvggraph, ncolor(act_time*) ystretch(.7) labeltext("Time: ") animationspeed(2) lattice

gen thresholdsize = 2 + threshold * 10
nwsvggraph, ncolor(act_time*) ystretch(.7) labeltext("Time: ") lattice nsize(thresholdsize ) animationspeed(2)

* Notice that the all agents act much faster when they only consider their local environment.


* Let us use a ring lattice now.

set more off
clear
nwsmall 100, neigh(4) 
nwsym, unweighted
nwdegree
gen threshold=uniform() * ( outdegree - 2)
gen act=0
replace act = 1 if _n <= 2
qui forvalues t=1/50 { 
	gen act_time`t' = act
	nwcontext act, gen(pressure)
	replace act = 1 if pressure >= threshold & act == 0
	drop pressure
}
nwsvggraph, ncolor(act_time*) ystretch(.6) xstretch (.6) labeltext("Time: ") animationspeed(2) circle

gen thresholdsize = 2 + threshold * 10
nwsvggraph, ncolor(act_time*) nsize(thresholdsize) ystretch(.6) xstretch (.6) labeltext("Time: ") animationspeed(2) circle


* Now let us add some shortcuts and see how the result changes

set more off
clear
nwsmall 100, neigh(4) shortc(20)
nwsym, unweighted
nwdegree
gen threshold=uniform() * (outdegree - 2)
gen act=0
replace act = 1 if _n <= 2
qui forvalues t=1/50 { 
	gen act_time`t' = act
	nwcontext act, gen(pressure)
	replace act = 1 if pressure >= threshold & act == 0
	drop pressure
}
nwsvggraph, ncolor(act_time*) ystretch(.6) xstretch (.6) labeltext("Time: ") animationspeed(2) circle


****************************
*
*	Network dynamics
*.
****************************

clear all
set more off
	
nwrandom 10, p(.1)
	
gen inc=100*uniform()
sum inc
	
nwgraph, c cont(inc) gropt(title(Graph0))
graph rename graph0, replace
	
nwtoedge, full to(inc)
	
gen incdiff = abs(from_inc - to_inc)
	
dis "Round no. 0"
tab link, sum(incdiff)
	
forvalues x = 1/20 {
	replace link = 0 if (incdiff + 100*uniform()- 50) > 60
	replace link = 1 if (incdiff + 100*uniform()- 50) < -30
	replace link = 0 if fromid == toid
		
	nwtoadj
		
	nwgraph, c cont(inc) gr(title(Graph`x'))
		
	graph rename graph`x', replace
		
	nwtoedge, full to(inc)
		
	gen incdiff = abs(from_inc - to_inc)
		
	dis "Round no. `x'"
	ab link, sum (incdiff)
}
