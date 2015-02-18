capture program drop nwissymmetric
program nwissymmetric
	syntax [anything(name=netname)]
	_nwsyntax `netname'
	nwtomata `netname', mat(onenet)
	mata: st_numscalar("r(issymmetric)", issymmetric(onenet))
	mata: mata drop onenet
end
