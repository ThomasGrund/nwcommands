*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwload
program nwload
	syntax [anything(name=loadname)][, id(string) nocurrent xvars labelonly]

	nwset, nooutput
	
	if ("" == ""){
		_nwsyntax , max(1)
		local loadname = ""
		nwname 
	}
	else {
		nwname, id("")
	}
	local id = r(id)
	local nodes = r(nodes)
	
	if (("" == "") | ("" != "")){
		capture drop _nodelab
		capture drop _nodevar
		qui mata: st_addvar("str20", "_nodelab")
		qui mata: st_addvar("str20", "_nodevar")
		
		scalar onename = ""
		local localname flomarriage
		scalar onevars = ""
		local localvars marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
		scalar onelabs = ""
		local locallabs `"bischeri castellani ginori guadagni lamberteschi pazzi peruzzi pucci ridolfi salviati strozzi tornabuoni"'
		
		if _N <  {
			set obs 
		}
		
		local i = 1
		foreach var in  {
			capture drop 
			qui replace _nodevar = "" in 
			local i =  + 1 
		}
		local j = 1
		foreach lab in  {
			qui replace _nodelab = `""' in 
			local j =  + 1
		}
		capture drop _nodeid
		gen _nodeid = _n if _n <= 
		if ("" == "") nwtostata, mat(nw_mata) gen()
	}
	
	if ("" != "nocurrent") {
		nwcurrent, id()
	}
end
