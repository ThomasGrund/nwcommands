*! Date        : 12oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nw_tomata
program nw_tomata
version 9
syntax [anything(name=netname)], mat(string) [ master]
	if "`mat'" == "" {
		local mat network
	}

	capture _nwsyntax `netname', max(1)
	if (_rc == 0){
		if "`master'" != "" {
			mata: `mat' = (nw.nws.pdefs[`id']->get_matrix_original())
		}
		else{
			mata: `mat' = nw.nws.pdefs[`id']->get_matrix()
		}
	}
 end
