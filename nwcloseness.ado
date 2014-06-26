* Calculates actor closeness centrality according to Sabidussi (1966)
* See Wassermann & Faust (1994, p. 184)
capture program drop nwcloseness
program nwcloseness
	version 9
	syntax [anything(name=net)], [ id(string) GENerate(string]
	set more off
	
	if ("`net'" != "" & "`id'" == ""){
		quietly nwname `geonet'
		local id = r(id)
	}

	if ("`net'" == "" & "`id'" == "") {
		nwname, id(1)
		local id = r(id)
	}
	
	if "`id'" != "" {
		local localid = `id'
	}
	else {
		local localid = `r(id)'
	}
	
	

	if "`varlist'" == "" {
		local varlist "v*"
	}
	
	scalar onename = "\$nwname_`id'"
	local localname `=onename'
	
	nwgeodesic `localname', distances
	nwname geodesic
	local gid = r(id)
	
	mata: far = sabidussi(nw_mata`gid')
	mata: closeness = J(`nnodes', 1,1) :/ far
    mata: st_matrix("r(farness)", far)
    mata: st_matrix("r(closeness)", closeness)
	if "`generate'" != "" {
		mata: idx = st_addvar("double", "`generate'")
		mata: st_store(.,idx,closeness)
	}	
end


