*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwsave
program nwsave
	syntax anything [, old * format(string)]
	local webname = subinstr("", ".dta","",.)

	_nwsyntax _all, max(99999)
	local nets : word count 

	
	if "" == "" {
		local format = "matrix"
	}
	if (20 > c(max_k_theory)){
		local format = "edgelist" 
	}
	
	_opts_oneof "matrix edgelist" "format" "" 6556
		
	preserve	
	qui {
	
	local nodes = 0
	local i = 1

	
	tempfile attributes
	capture drop _*
	gen _running = _n
	foreach onenet in  {
		nwname 
		local varstodelete ""
		foreach onevar in  {
			capture drop 
			capture drop _nodelab
			capture drop _nodevar
			capture drop _nodeid
		}
	}
	save , replace
	
	if "" == "edgelist" {
		clear
		gen _fromid = .
		gen _toid = .
		tempfile edgelist_all
		save 
		foreach onenet in  {
			tempfile edgelist_
			nwtoedge 
			rename  _
			save edgelist_, replace
			merge m:m _fromid _toid using , nogenerate
			save , replace
		}
	}
	if "" == "matrix" {
		clear
		local i = 1
		foreach onenet in  {
			nwname 
			local vars ""
			nwload 
			capture drop _nodelab _nodevar _nodeid
			local j = 1
			foreach v of varlist  {
				rename  _net_
				local j =  + 1
			}
			local i =  + 1
		}
	}

	gen _format = "" 
	gen _nets = . 
	gen _name = ""
	gen _size = .
	gen _directed = ""
	gen _edgelabs = ""
	
	local i = 1
	local n = _N
	if  < {
		set obs 
	}
	foreach onenet in  {
		nwname 
		replace _name = "" in 
		local nodes = 
		replace _size =  in 
		replace _directed = "" in 
		replace _edgelabs = `""' in 
		nwload , labelonly
		rename _nodelab _newlabel
		rename _nodevar _newvar
		local i =  + 1
	}
	save att1, replace
	
	local i = 1
	foreach onenet in  {
		rename _newlabel _nodelab
		rename _newvar _nodevar
		gen _runningnumber = _n
		tostring _runningnumber, replace
		replace _nodevar = "_net_" + _runningnumber
		drop _runningnumber
		local i =  + 1
	}	
	
	if "" == "matrix" {
		replace _format = "matrix" in 1
		
	}
	
	if "" == "edgelist" {
		replace _format = "edgelist" in 1
		
	}
	
	replace _nets =  in 1
	order _format _nets _name _size _directed _edgelabs _nodevar* _nodelab*
	gen _running = _n
	qui merge m:m _running using , nogenerate
	drop _running
	
	}
	save .dta, 
	restore
end



	

