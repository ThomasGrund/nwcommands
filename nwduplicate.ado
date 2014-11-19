*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwduplicate
program nwduplicate
	version 9
	syntax [anything(name=netname)], [name(string) vars(string) xvars]
		
	qui nwset
	if "" == "" {
		nwcurrent
		local netname = r(current)
	}
	
	// get parameters
	nwname 
	local nodes = r(nodes)
	local id = r(id)
	if (r(directed) != "true"){
		local undirected = "undirected"
	}
	
	// generate valid network name and valid varlist
	if "" == "" {
		local name "_copy"
	}

	nwvalidate 
	local copyname = r(validname)
	local varscount : word count 
	if ( != ){
		// obtain vars from original
		scalar onevars = ""
		local copyvars marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
	}
	else {
		local copyvars ""
	}
	
	// create network
	nwtomata , mat(onenet)
	nwset, name() vars() mat(onenet) 
end
