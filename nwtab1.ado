*! Date        : 3sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwtab1
program nwtab1
	
	syntax [anything] , [selfloop *]
	_nwsyntax `anything'
	
	preserve
	nwname `netname'
	if "`r(directed)'" == "false" {
		local undirected = "undirected"
	}
	local edgelabs `r(edgelabs)'
	
	nwtoedge `netname', type(full)
	qui if "`selfloop'" == "" {
		drop if _fromid == _toid 
	}
	local ident = length("`netname'") + 20
	di
	di "{txt}   Network:  {res}`netname'{txt}{col `ident'}Directed: {res}`directed'{txt}"
	capture label def elab `edgelabs'
	capture label val `netname' elab
	tab `netname', `options'
	restore
end
