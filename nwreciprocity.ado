capture program drop nwreciprocity
program nwreciprocity
	syntax [anything(name=netname)]
	qui nwdyads `netname'
	local reciprocity = `r(_100)' / `=`r(_100)' + `r(_001)''
	mata: st_numscalar("r(reciprocity)", `reciprocity')
end
