*! Date        : 3oct2014
*! Version     : 1.0.4
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwclustering
program nwclustering
	version 9
	syntax [anything(name=netname)][, GENerate(string)]
	set more off

	_nwsyntax `netname', max(9999)
	_nwsetobs
		
	if `networks' > 1 {
		local k = 1
	}

	qui foreach netname_temp in `netname' {
		_nwsyntax_other `netname_temp'
		nwtomata `netname_temp', mat(onenet)
	
		if "`generate'" == "" {
			local generate = "_clustering"
		}
	
		capture drop `generate'`k'
		qui gen `generate'`k' = .
		if _N <= `othernodes' {
			set obs `othernodes'
		}
		mata: onenet = onenet :/ onenet
		mata: _editmissing(onenet, 0)
		mata: st_rclear()
		mata: c = cluster(onenet)		
		mata: st_store((1::`othernodes'),"`generate'`k'", c[,1])
		mata: st_numscalar("r(cluster_avg)", mean(c[,1]))
		mata: st_numscalar("r(cluster_overall)",(sum(c[,2]) / sum(c[,3])))
		mata: mata drop c
		local k = `k' + 1
		
		noi di "{hline 40}"
		noi di "{txt}  Network name: {res}`othername'"
		noi di "{hline 40}"
		noi di "{txt}    Average clustering coefficient: {res}`r(cluster_avg)'"
		noi di "{txt}    Overall clustering coefficient: {res}`r(cluster_overall)'"
		noi di " "
	}
end




capture mata mata drop cluster()
mata:
// function returns a matrix with the membership to components. 
real matrix cluster(real matrix nw) {	
	real matrix cluster
	real matrix alters
	real matrix id
	real matrix closed_triplets
	real matrix potential_triples
	
	closed_triplets = J(rows(nw),1,0)
	potential_triplets = rowsum(nw) :* (rowsum(nw):-1)
	id = (1::rows(nw))
	for ( i = 1 ; i <= rows(nw); i++) {
		alters = select(id, (nw[i,])')
		for (j = 1; j <= rows(alters); j++){
			alter_id = alters[j]
			closed_triplets[i,1] = closed_triplets[i,1] + sum((nw[i,]:== nw[alter_id,]) :& (nw[i,]:==1))
		}	
	}
	cluster = J(rows(nw),3,0)
	cluster[,1] = (closed_triplets:/potential_triplets)
	cluster[,2] = closed_triplets
	cluster[,3] = potential_triplets
	return(editmissing(cluster,0))
}
end

	
	
