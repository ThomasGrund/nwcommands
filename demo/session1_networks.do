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
*****			Session 1: networks
*****
*****			@: Thomas Grund, thomas.grund@iffs.se
*****
**********************************************
**********************************************

* Before you can access the nwcommands, you need to download them and set the adopath.
* You can find them at : http:/grund.co.uk/teaching/stata-abm

adopath + "C:\Users\Thomas\Dropbox\ABM course Stockholm\nwcommands\"


********************************
**
**   Load real networks
**
********************************

insheet using "C:\Users\Thomas\Dropbox\ABM course Stockholm\data\gang.csv", clear
edit

nwgraph, stub(v)

* Better use nwimport
help nwimport

* Import simple matrix
clear 
nwimport using "C:\Users\Thomas\Dropbox\ABM course Stockholm\data\gang_matrix.mat", type(matrix)

* Import pajek networks
clear 
nwimport using "C:\Users\Thomas\Dropbox\ABM course Stockholm\data\gang_pajek.net", type(pajek)


****************************
*
*	Manipulate network
*
****************************

set more off
recode var* (1 = 0) (2/4 = 1)
edit



****************************
*
*	Symmetrize networks
*
****************************

help(nwsym)
nwsym, unweighted
nwsym, weighted
nwsym, lower



****************************
*
*	Utilities
*
****************************

help(nwtoedge)
nwtoedge
nwtoedge, full
nwtoedge, fromvars(attr*)
nwtoedge, fromvars(attr*) tovars(attr*) full

help(nwtoadj)
nwtoadj
nwtoadj, nnodes(100)
nwtoadj, fromvars(from_attr*)


nwfilledge


********************************
**
**   Degree and density
**
********************************
set more off
clear
nwimport using "C:\Users\Thomas\Dropbox\ABM course Stockholm\data\gang_pajek.net", type(pajek)
recode var* (1 = 0) (2/4 = 1)
help nwdegree

nwdegree
nwdegree, outdegree(out) indegree(in)

nwdensity  // CHECK
return list


********************************
**
**   Clustering coefficients
**
********************************
* The local clustering coefficient of a node is defined as the ratio between triplets in which the
* node is involved to the number of triplets the node could potentially be involved. The average 
* clustering coeffcient of the network is the average of the local clustering coefficients.
* Return clustering coefficient for each node (calculated as closed triangles divided by potential 
* triangles this node could be involved - works for both directed and non-directed ties).

clear
nwimport using "C:\Users\Thomas\Dropbox\ABM course Stockholm\data\gang_pajek.net", type(pajek)
recode var* (1 = 0) (2/4 = 1)

help nwcluster
nwcluster
return list

matrix list r(cluster)
nwcluster, gen(cluster)

* show overall global clustering = average clustering coefficient of all nodes

di r(C)

* There might be reasons to weight the local clustering coefficents when calculating the global measure

nwdegree
gen weight = indegree + outdegree
nwcluster, gen(cluster_weighted) weight(weight)



********************************
**
**    Closeness coefficients
**
********************************

nwcloseness
return list

matrix list r(closeness)
nwcloseness, gen(close)


clear
nwrandom 100, prob(.3)
nwsym, unweighted
nwcloseness
return list

********************************
**
**   Number of connected components
**
********************************

* calculates the number of connected components

nwcomponents
return list
di r(compnum)
mat list r(compmemb)

* produce variable with component number membership for each node

nwcomponents, gen(comp) 
tab comp

clear
nwimport using "C:\Users\Thomas\Dropbox\ABM course Stockholm\data\gang_pajek.net", type(pajek)
recode var* (1 = 0) (2/4 = 1)
local nnodes =_N
forvalues i=1/`nnodes'{
	replace var`i' = 0 if `i' > 10 in 1/10
	replace var`i' = 0 if `i' <= 10 in 11/`nnodes'	 
}
nwcomponents, gen(comp) 
tab comp



********************************
**
**   Geodesic distances
**
********************************

clear
nwimport using "C:\Users\Thomas\Dropbox\ABM course Stockholm\data\gang_pajek.net", type(pajek)
recode var* (1 = 0) (2/4 = 1)

help nwgeodesic
nwgeodesic
return list
* r(L) gives average shortest path length of network

* produce r(distances) matrix

nwgeodesic, distances 
return list

* Produce variables with distances

nwgeodesic, gen(dist)

* Calculate geodesic distances on directed graph

nwgeodesic, symoff

* Option "unconnected" is a value that is given to express the distance between two unconnected nodes. By default, this is
* set to maxdist + 1, but it could make sense to set it e.g. to 999 or so. Obviously, this only makes sense
* when the network is not completely connected. Hence, in the example a low density network is used.

local nnodes =_N
forvalues i=1/`nnodes'{
	replace var`i' = 0 if `i' > 10 in 1/10
	replace var`i' = 0 if `i' <= 10 in 11/`nnodes'	 
}
nwgraph

* Let us check the number of components

nwcomponents
return list

nwgeodesic, symoff unconnected(999) gen(dist)

* Force the shortest path to be calculated on the unsymmetrized network

nwgeodesic, symoff
di "Average shortests path length: " r(L)

* Return the shortest paths between nodes i and j

nwgeodesic, distances
matrix list r(distances)

* Altneratively, create new variables

nwgeodesic, gen(dist)

* When paths do not exist, the default entry in the distance matrix is the longest shortest path + 1
* You can change this, e.g. to -99.

drop dist*
nwgeodesic, symoff gen(dist) unconnected(-99)

