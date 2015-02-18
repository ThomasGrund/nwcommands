capture program drop _nwsetobs
program _nwsetobs
	syntax [anything(name=netname)] 
	_nwsyntax _all, max(9999)
	local othernetname `netname'
	
	local maxnodes = 0
	foreach onenet in `othernetname' {
		nwname `onenet'
		if r(nodes) > `maxnodes' {
			local maxnodes = `r(nodes)'
		}
	}
	if _N < `maxnodes' {
		set obs `maxnodes'
	}
	mata: st_rclear()
	mata: st_numscalar("r(maxnodes)", `maxnodes')
end
