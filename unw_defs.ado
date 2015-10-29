capture program drop unw_defs
program unw_defs
	
	//error codes
	c_local 	errNWsCreate	480		
	c_local 	errNodeDupName	481	
	c_local 	errNWsNotFound	482		
	c_local 	errNWsExists	483	

	//static objects
	c_local nw_static = "nw"
	c_local nws_static = "nws"
	c_local nwsder_static = "nwsder"

	c_local nw = "nw"
	c_local nws = "nw.nws"
	c_local nwsder = "nw.nwsder"
	
	//class definitions
	c_local vxNWs		nws
	c_local vxNWsdef	nws_def
	c_local vxNWsder	nws_der		
	c_local vxNWdef		nw_def
	
	c_local nwvars_def_pref "n"
	c_local cDftNodepref "n"
	
	c_local nw_nodename "_nwnode"
	c_local missing2 "-999999"
end
