capture program drop nwneighbor
program nwneighbor
	syntax [anything(name=netname)], ego(integer) [ incoming outgoing]
	
	qui nwset
	if "`netname'" == "" {
		nwcurrent
		local netname = r(current)
	}

	nwtomata `netname', mat(onenet)
	
	mata: vecin=onenet[.,`ego']
	mata: vecout=onenet[`ego',.]
	if "`outgoing'" != "" {
		mata: vec = vecout
	}
	else {
		mata: vec = vecin
	}
	mata: neighbors=.
	mata: temp=.
	mata: maxindex(vec,1,neighbors, temp)
	mata: neighbor=jumble(neighbors)[1]
	mata: st_numscalar("r(oneneighbor)", neighbor)
	mata: st_matrix("r(neighbors)", jumble(neighbors))
	mata: st_numscalar("r(total)", sum(vec))
	mata: mata drop onenet neighbors temp neighbor
end


