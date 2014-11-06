capture program drop nwdyads
program nwdyads
	version 9
	syntax [anything(name=netname)], [ triad ]
	
	if "`mode'" == "" {
		local mode = "dyad"
	}
	
	if "`netname'" == "" {
		nwcurrent
		local netname = r(current)
	}
	
	nwname `netname'
	local directed = r(directed)
	
	mata: st_rclear()
	
	// Dyad census of directed network
	if ("`directed'" == "true" ) {
		nwtomata `netname', mat(censusMat)
		
		mata: censusMat = censusMat :/ censusMat
		mata:  _editmissing(censusMat, 0)
		mata: asym = (sum(abs(censusMat :- (censusMat')))) / 2
		mata: mutual = (sum(censusMat) - asym) / 2
		mata: null = rows(censusMat) * (rows(censusMat) - 1)/2 - asym - mutual

		mata: st_rclear()
		mata: st_numscalar("r(_001)", null)
		mata: st_numscalar("r(_010)", asym)
		mata: st_numscalar("r(_100)", mutual)
		
		di
		di "{txt}    Dyad census: {res} `netname'{txt}"
		di 
		
		di "{txt}{ralign 10:Mutual}{col 12}{c |}{ralign 10:Asym}{col 24}{c |}{ralign 10:Null}"
		di "{hline 11}{c +}{hline 11}{c +}{hline 11}"
		di "{res}{ralign 10:`r(_100)'}{col 12}{c |}{ralign 10:`r(_010)'}{col 24}{c |}{ralign 10:`r(_001)'}"
	}
	
	// Dyad census for undirected network
	if ("`directed'" == "false" ) {
		nwtomata `netname', mat(censusMat)
		mata: censusMat = censusMat :/ censusMat
		mata:  _editmissing(censusMat, 0)
		mata: mutual = sum(censusMat) / 2
		mata: null = rows(censusMat) * (rows(censusMat) - 1)/2 - mutual
		mata: zero = 0
		mata: st_numscalar("r(_001)", null)
		mata: st_numscalar("r(_010)", zero)
		mata: st_numscalar("r(_100)", mutual)
		
		di
		di "{txt}    Dyad census: {res} `netname'{txt}"
		di 
		di "{txt}{ralign 10:Mutual}{col 12}{c |}{ralign 10:Null}"
		di "{hline 11}{c +}{hline 11}"
		di "{res}{ralign 10:`r(_100)'}{col 12}{c |}{ralign 10:`r(_001)'}"
	}		
end
	
	
