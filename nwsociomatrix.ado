// TODO make sure it also works with larger networks (problem: matrix)
// Do the whole thing from scratch and bypass plotmatrix...
capture program drop nwsociomatrix	
program nwsociomatrix
	// Version test
	capture which plotmatrix
	if _rc {
		ssc install plotmatrix
	}
	nwset, check
	local varlist $nw
	mkmat `varlist', mat(sociomat)
	plotmatrix, mat(sociomat)
end
