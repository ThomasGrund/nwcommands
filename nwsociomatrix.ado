*! Date        : 3sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

// TODO make sure it also works with larger networks (problem: matrix)
// Do the whole thing from scratch and bypass plotmatrix...
capture program drop nwsociomatrix	
program nwsociomatrix
	syntax [anything(name=netname)]
	_nwsyntax `netname', max(1)
	
	// Version test
	capture which plotmatrix
	if _rc {
		ssc install plotmatrix
	}
	
	nwtomata `netname', mat(socionet)
	mata: st_matrix("sociomat", socionet)
	plotmatrix, mat(sociomat)
end
