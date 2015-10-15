*! Date        : 12oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwcurrent
program nwcurrent
	syntax [anything(name=netname)] [,id(string)]

	if ("`id'" != "") {
		mata: nw.nws.make_current(`id')
	}
	else if ("`netname'" != ""){
		_nwsyntax `netname', max(1)
		mata: nw.nws.make_current_from_name("`netname'")
	}
	
	mata: st_rclear()
	mata: st_global("r(current)", nw.nws.get_current_name())
	mata: st_numscalar("r(networks)", nw.nws.get_number())
end

