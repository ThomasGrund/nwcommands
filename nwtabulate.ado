capture program drop nwtabulate
program nwtabulate
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
