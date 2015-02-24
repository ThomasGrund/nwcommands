capture program drop nwtomatafast
program nwtomatafast
	syntax [anything(name=netname)]
	_nwsyntax `netname'
	mata: st_global("r(mata)", "nw_mata`id'")
end
