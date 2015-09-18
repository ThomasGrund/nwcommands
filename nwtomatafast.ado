capture program drop nwtomatafast
program nwtomatafast
	syntax [anything(name=netname)] 
	_nwsyntax `netname'
	mata: st_global("r(mata)", "nw_mata`id'")
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
