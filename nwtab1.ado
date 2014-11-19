*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwtab1
program nwtab1
	
	syntax [anything] , [selfloop *]
	_nwsyntax 
	
	preserve
	nwname 
	if "" == "false" {
		local undirected = "undirected"
	}
	local edgelabs 
	
	nwtoedge , type(full)
	qui if "" == "" {
		drop if _fromid == _toid 
	}
	local ident = length("") + 20
	di
	di "{txt}   Network:  {res}{txt}{col }Directed: {res}{txt}"
	capture label def elab 
	capture label val  elab
	tab , 
	restore
end
