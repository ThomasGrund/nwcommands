capture program drop nwcomponents
program nwcomponents
	version 9
	syntax [anything(name=netname)][, GENerate(string) undirected]
	set more off

	nwset, nooutput
	if "`netname'" == "" {
		nwcurrent
		local netname = r(current)
	}

	nwname `netname'
	local nodes = r(nodes)
	
	nwtomata `netname', mat(onenet)
	local compUndirected = 0
	if "`undirected'" != "" {
		local compUndirected = 1
	}
	mata: comp = components(onenet, `compUndirected')
	mata: numcomp = max(comp)
	
	capture drop _component
	qui gen _component = .
	

	mata: st_rclear()
	mata: st_store((1::`nodes'),"_component", comp)
	qui tab _component, matrow(comp_id) matcell(comp_size)
	mata: comp_id = st_matrix("comp_id")
	mata: comp_size = st_matrix("comp_size")
	mata: comp_share = comp_size :/ (sum(comp_size))
	mata: comp_sizeid = J(numcomp, 3, 0)
	mata: comp_sizeid[.,1] = comp_size
	mata: comp_sizeid[.,2] = comp_id
	mata: comp_sizeid[.,3] = comp_share
	mata: comp_sizeid = sort(comp_sizeid, -1)
	mata: st_numscalar("r(components)", numcomp)
	mata: st_matrix("r(comp_sizeid)", comp_sizeid)
	mata: mata drop comp numcomp comp_id comp_size comp_sizeid
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
