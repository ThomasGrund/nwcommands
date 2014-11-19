*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwutility
program nwutility
	syntax [anything(name=netname)], [Benefit(real 1) Cost(real 1) INTRValue(string) INTRCost(string) *]
	_nwsyntax , max(1)

	local netname_backup ""
	
	if  > 1 |  < 0 {
		di "{err {bf:benefit} needs to be in the range between 0 and 1."
		error 60044
	}
	
	if "" != "" {
		_nwsyntax_other 
		if  !=  {
			di "{err}network {bf:} of wrong size"
			error 60033
		}
		nwtomata , mat(checkedvalue)
	}
	else {
		mata: checkedvalue = (I() :- 1) :*(-1)
	}
	
	if "" != "" {
		_nwsyntax_other 
		if  !=  {
			di "{err}network {bf:} of wrong size"
			error 60033
		}
		nwtomata , mat(checkedcost)
	}
	else {
		mata: checkedcost = (I() :- 1) :*(-1)
	}

	nwgenerate _temp_util = (_nwgeodesic , )
	nwtomata _temp_util, mat(geonet)
	nwdrop _temp_util
	if ("" == "" & "" == ""){
		mata: util = util_simple(distance_distribution(geonet), , )
	}
	else {
		nwtomata , mat(nw)
		mata: util = util_weighted(nw, geonet, checkedvalue, checkedcost, 1) 
		mata: mata drop nw
		mata: mata drop checkedcost
	}
	capture drop _cost
	capture drop _benefit
	capture drop _util
	nwtostata, mat(util) gen(_benefit _cost _util)
	mata: mata drop util
	mata: mata drop geonet
    
end

capture mata mata drop distance_distribution()
capture mata mata drop util_simple()
capture mata mata drop util_weighted()

mata:
real matrix distance_distribution(real matrix dist) {	
	
	nodes = rows(dist)
	maxdist = max(dist)
	
	dd = J(nodes, maxdist, 0)
	
	for(i = 1; i<= nodes; i++){
		for(j = 1; j <= nodes; j++){
		    if (dist[i,j] > 0) {
				dd[i,dist[i,j]] = dd[i,dist[i,j]] + 1
			}
		}
	}
	return(dd)
}


real matrix util_simple(real matrix dd, real scalar b, real scalar c) {
	benefit_cost = J(rows(dd), 3,0)
	for (i = 1;i< cols(dd); i ++){
		benefit_cost[,1] = benefit_cost[,1] :+ (dd[,i] * b^i)
	}
	benefit_cost[,2] = dd[,1] :* c
	benefit_cost[,3] = benefit_cost[,1] - benefit_cost[,2]
	return(benefit_cost)
}

real matrix util_weighted(real matrix net, real matrix geonet, real matrix w, real matrix c, real scalar b) {
	benefit_cost = J(rows(geonet), 3,0)
	for (i = 1;i< cols(geonet); i ++){
		for (j = 1;j< cols(geonet); j ++){

			if (geonet[i,j] >= 0) {
				benefit_cost[i,1] = benefit_cost[i,1] + (w[i,j] * b^(geonet[i,j]))
			}
		}
	}
	
	benefit_cost[,1] = benefit_cost[,1] + diagonal(w)
	cost = net :* c
	benefit_cost[,2] = rowsum(cost)
	benefit_cost[,3] = benefit_cost[,1] - benefit_cost[,2]
	return(benefit_cost)
}
end
