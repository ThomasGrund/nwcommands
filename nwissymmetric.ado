capture program drop nwissymmetric
program nwissymmetric
	syntax [anything(name=netname)]
	_nwsyntax `netname'
	nwtomata `netname', mat(onenet)
	mata: st_numscalar("r(issymmetric)", issymmetric(onenet))
	mata: mata drop onenet
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
