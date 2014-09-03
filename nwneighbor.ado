*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwneighbor
program nwneighbor
	syntax [anything(name=netname)], ego(integer) [ mode(string)]
	_nwsyntax `netname', max(1)
	local nodes = r(nodes)
	
	if "`mode'" == "" {
		local mode = "outgoing"
	}
	_opts_oneof "incoming outgoing both" "mode" "`mode'" 6810
	
	nwtomata `netname', mat(onenet)
	
	mata: vecin=onenet[.,`ego']
	mata: vecout=onenet[`ego',.]
	if "`mode'" == "incoming" {
		mata: vec = vecin
	}
	if "`mode'" == "outgoing" {
		mata: vec = vecout'
	}
	if "`mode'" == "both" {
		mata: vec = vecout' + vecin
	}
	mata: vec = vec :/ vec
	mata: _editmissing(vec,0)
	
	mata: neighbors=.
	mata: neighbor=.
	
	mata: ids = (1::`nodes')
	mata: sel = (vec :!= 0)
	mata: neighbors = select(ids, sel)

	mata: st_rclear()
	capture mata: neighbor=jumble(neighbors)[1]
	capture mata: st_numscalar("r(oneneighbor)", neighbor)
	capture mata: st_matrix("r(neighbors)", jumble(neighbors))
	mata: mata drop vec vecin vecout onenet neighbors neighbor ids sel
end


