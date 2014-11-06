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
*****			Session 2: visualization
*****
*****			@: Thomas Grund, thomas.grund@iffs.se
*****
**********************************************
**********************************************

****************************
*
* 	Plot networks using netplot
*
****************************

help(netplot)

clear
nwrandom 20, prob(.1)
nwtoedge
netplot fromid toid

****************************
*
* 	Plot networks using nwgraph
*
****************************

findit(netplot)
help(nwgraph)

clear
nwrandom 20, prob(.1)
nwgraph

nwgraph, circle
nwgraph, lattice

gen group = int(_n / 5)
nwgraph, cat(group)
nwgraph, cat(group) ego(6)
nwgraph, random cat(group) ego(6)
nwgraph, circle cat(group) ego(6)
	

nwtoedge
netplot fromid toid
netplot fromid toid, type(circle)
netplot fromid toid, type(mds)

****************************
*
* 	Advanced visualisation with nwsvggraph
*
****************************

clear
nwrandom 20, prob(.2)
nwsvggraph

* Arrowheads:
* By default the program knows if the network is symmetric or not. Check out the following:

nwsym, unweighted
nwsvggraph


* Layout: 
* You can adjust the layout in the same way as you do for the nwgraph command. You can choose between
* (1) nothing (which means random), (2) circle, (3) lattice and (4) mds (multidimensional scaling)

nwsvggraph, circle
nwsvggraph, lattice
nwsvggraph, mds

* Background:
* The color of the background is changed in the following way. You can define rgb (red green blue) values for
* the center of the background and for the periphery of the background. Each rgb value consists of three numbers from 
* 0 to 255.

nwsvggraph, background1(255 0 255)  mds
nwsvggraph, background1(255 0 0)  background2(120 255 255) mds

* Size:
* This is adjusted with width and height (in pixels).

nwsvggraph, width(600) height(300) background1(255 0 0)  background2(120 255 255) mds

* Stretching:
* Sometimes it is useful to stretch the graph. You do that with xstretch and ystretch. Both take a real number as an
* argument that indicates the stretching. This number can also be greater than 1.

nwsvggraph, background1(255 0 0)  background2(120 255 255) circle
nwsvggraph, background1(255 0 0)  background2(120 255 255) xstretch(.7) ystretch(.7) circle

* Title label:

nwsvggraph, background1 (255 0 0) labeltext("My network") mds
nwsvggraph, background1 (255 0 0) labeltext("My network") labelsize(15) labelx(10) labely(20) labelcolor(yellow) mds

* Node labels:

gen id = _n
nwsvggraph, background1 (255 0 0) labeltext("My network") nlabels(id) mds

* Edge Factor:
* This is a multiplier for the width of the edges.

replace var2 = 5 in 10
replace var10 = 5 in 2

nwsvggraph, efactor(.5)

* Node Factor: 
* This is a multiplier for the size of the nodes.

nwsvggraph, nfactor(3)

* Node Size:
* You can adjust the size of each node individually, but you can also combine this with nfactor.

gen size = int(uniform()*30) + 1
nwdegree

nwsvggraph, nsize(outdegree) nfactor(3) 

* Node Color:
* You can also give each node a different color. Color values range from 0 to 7 so far only.

gen mycolor1 = int(uniform()*5)
gen mycolor2 = int(uniform()*5)
gen mycolor3 = int(uniform()*5)
gen mycolor4 = int(uniform()*5)
gen mycolor5 = int(uniform()*5)
gen mycolor6 = int(uniform()*5)
gen mycolor7 = int(uniform()*5)
nwsvggraph, ncolor(mycolor*) mds

* The nwsvggraph command is very powerful and can animate your network as well. So far, you can animate
* the size of your nodes and their color. You can do this by putting a variable list in the argument
* of either the nsize or ncolor option. Let us create two variables color1 and color2.

clear
nwrandom 20, prob(.2)
nwsym, unweighted

gen mycolor1 = int(uniform()*3) + 1 
gen mycolor2 = int(uniform()*3) + 1
gen mycolor3 = int(uniform()*3) + 1

* Now the option ncolor takes a list of variables
nwsvggraph, ystretch(.7)  ncolor(mycolor*)

* You can adjust the speed with animationspeed, default = 1
nwsvggraph, ystretch(.7) lattice ncolor(mycolor*) labeltext("My animation: ") animationspeed(3)



************************
*
*	Animation of opinions
*
************************

clear
set obs 500
gen opinion0=2*uniform()+1
hist opinion0, bin(50)

dis "Time 0"
sum opinion0
gen norm=r(mean)

l in 1/10
	
* If we assume that an agent's behavior is influenced by a norm (or the normal behavior) among others,
* it typically makes more sense to not include the agent's own behavior when defining the norm.
* This command defined the norm as the average of the other agents' values on the opinion variable:
	
replace norm=(_N*r(mean)-opinion0)/(_N-1)
l in 1/10
	
	
* To make sure that this indeed is the case, compare the value of the norm for the first agent with the
* mean value from this calculation which excludes the first observation:
	
sum opinion0 if _n>1
	
	
* Now we want to model the agents' opinions as in part influenced by how deviant their opinions are in relation to the norm.
* Those to the right of the norm (opnion>norm) move to the left, and those to the left of the norm (opinion<norm) move to the right.
	
gen dev=abs(opinion0-norm)
gen intention=.
replace intention=opinion0-(.1*dev) if opinion0>=norm
replace intention=opinion0+(.1*dev) if opinion0<norm
gen opinion1=intention
drop dev
	
dis "Time 1"
sum opinion1
hist opinion1

* Do the same thing again for the next time step.
sum opinion1
gen norm1=r(mean)
replace norm1=(_N*r(mean)-opinion1)/(_N-1)
	
gen dev=abs(opinion1-norm)
replace intention=opinion1-(.1*dev) if opinion1>=norm
replace intention=opinion1+(.1*dev) if opinion1<norm
gen opinion2=intention
	
dis "Time 2"
sum opinion2
hist opinion2

* Excercise:
*
* Extend this model in such a way that agents are embedded in various network structures. Each agent has a different idea what the 
* norm is. This should be based on the opinions of an agents' network neighbors (use nwcontext). Animate the change in opinion with 
* nwsvggraph. 

