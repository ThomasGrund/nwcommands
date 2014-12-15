*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwtomata
program nwtomata
version 9
syntax [anything(name=netname)], mat(string)
	if "`mat'" == "" {
		local mat network
	}
	capture _nwsyntax `netname', max(1)
	if (_rc == 0){
		mata: `mat' = nw_mata`id'
	}
	else {
		capture unab netname : `netname'
		capture confirm variable `netname'
		if (_rc == 0){
			unab vars: `netname'
			local size : word count `vars'
			mata: `mat' = st_data((1::`size'),tokens("`vars'"))
		}
	}
 end
 
