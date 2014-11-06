*! Date        : 12oct2014
*! Version     : 1.1
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwcomponents
program nwcomponents, rclass
	version 9
	syntax [anything(name=netname)][, lgc GENerate(string) ]
	set more off

	_nwsyntax `netname', max(9999)
	
	if `networks' > 1 {
		local k = 1
	}
	
	foreach netname_temp in `netname' {
		nwtomata `netname_temp', mat(onenet)

		mata: onenet = onenet + onenet'
		mata: onenet = onenet :/ onenet
		mata: _editmissing(onenet,0)
		mata: comp = components(onenet, 1)
		mata: numcomp = max(comp)
	
		if "`generate'" == "" {
			if "`lgc'" == "" {
				local generate = "_component"
			}
			else {
				local generate = "_lgc"
			}
		}
		
		capture drop `generate'`k'
		gen `generate'`k' = .
	
		mata: st_rclear()
		if _N < `nodes' {
			set obs `nodes'
		}
	
		mata: st_store((1::`nodes'),"`generate'`k'", comp)
		qui tab `generate'`k', matrow(comp_id) matcell(comp_size)
		mata: comp_id = st_matrix("comp_id")
		mata: comp_size = st_matrix("comp_size")
		mata: comp_share = comp_size :/ (sum(comp_size))
		mata: comp_sizeid = J(numcomp, 3, 0)
		mata: comp_sizeid[.,1] = comp_size
		mata: comp_sizeid[.,2] = comp_id
		mata: comp_sizeid[.,3] = comp_share
		mata: comp_sizeid = sort(comp_sizeid, -1)
		mata: st_numscalar("components", numcomp)
		mata: st_matrix("comp_sizeid", comp_sizeid)
	
		matrix colnames comp_sizeid = size compid share
	
		local rowlabs ""
		return scalar components = components
		forvalues i = 1/`=components'{
			local rowlabs "`rowlabs' comp`i'"
		}
		matrix rownames comp_sizeid = `rowlabs'
		return matrix comp_sizeid = comp_sizeid
		mata: mata drop comp numcomp comp_id comp_size comp_sizeid

		qui if "`lgc'" != "" {
			tempvar running
			gen `running' = _n
			tempvar compmemb
			tempvar temp
			gen `temp' = 1
			bys `generate'`k' : egen `compmemb' = total(`temp')
			sum `compmemb'
			replace `generate'`k' = (`r(max)' == `compmemb'[_n])
			replace `generate'`k' = . if _n > `nodes'
			sort `running'
			
		}
		local k = `=`k' + 1'
	}
end

capture mata mata drop components()
mata:
// function returns a matrix with the membership to components. 
real matrix components(real matrix nw, real scalar undirected) {	
	real scalar nodes
	real scalar ncomp
	real scalar next
	real matrix visited
	real matrix comp 	
	real matrix bfs_queue
	real matrix bfs_next
	
	nodes = rows(nw[.,.])
	visited = J(nodes,1,0)
	comp  = J(nodes,1,0)
	ncomp = 1
	next = 1 
	
	// as long as not everybody has been visited
	while (sum(visited) != nodes){

			// find next not visited node
			while (visited[next,1]==1) {
				next = next + 1
			}

			// perform bfs from next and visit everybody reachable
		    // assign component id
			// increment component id	
			visited[next,1]=1
			comp[next,1]=ncomp

			bfs_queue = nw[next,]
			if (undirected == 1){
				bfs_queue = bfs_queue :+ (nw[,next])'
			}
			
			bfs_next = J(1, nodes,0)
			while (sum(bfs_queue)>0) {
				for (i = 1 ; i<=nodes ; i++) {
					if (bfs_queue[1,i]>= 1) {
				    		bfs_queue[1,i]=0
				    		if (visited[i,1]==0){
				    			visited[i,1]=1		
								comp[i,1]=ncomp
				    			bfs_next = bfs_next + nw[i,]
								if (undirected == 1){
									bfs_next = bfs_next :+ (nw[,i])'
								}
				   	 	}
					}
				}
				for (i = 1; i<=nodes ; i++){
					if (bfs_next[1,i]>0 & visited[i,1]==0) {
						bfs_queue[1,i]=1
					}
				}			
			}
			ncomp = ncomp + 1			
		}
	return(comp)
}
end
