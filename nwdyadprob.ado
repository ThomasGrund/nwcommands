*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwdyadprob
program nwdyadprob
	syntax [anything(name=weightnet)],  [ density(string) mat(string) name(string) vars(passthru) xvars undirected]
	
	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "dyadprob"
	}
	
	if "`mat'" == "" {
		local mat = "mat"
	}

	nwvalidate `name'
	local dyadname = r(validname)

	
	// Install gsample if needed
	capture which gsample
	if _rc != 0 {
		ssc install gsample
	}
	capture mata: mata which mm_sample()
	if _rc != 0 {
		ssc install moremata
	}

	
	if "`weightnet'" != "" {
		_nwsyntax `weightnet'
		nwtomata `weightnet', mat(`mat')
		mata: `mat' = transformIntoProbs(`mat')
	}
	
	mata: onenet = getNetFromProbs(`mat')
	mata: st_numscalar("r(nodes)", rows(onenet))
	local nodes = `r(nodes)'
	
	if  "`density'" == ""{
		capture mata: `mat'
		if _rc != 0 {
			di "{err}Mata matrix `mat' not found.{txt}"
			error _rc
		}
		else {
			mata: st_numscalar("r(matrows)", rows(`mat'))
			mata: st_numscalar("r(matcols)", cols(`mat'))
			if (`r(matrows)' != `r(matcols)') {
				di "{err}Mata matrix `mat' not square.{txt}"
				error 6099
			}
			if "`undirected'" != "" {
				mata: `mat' = lowertriangle(`mat')
			}
			nwset, mat(onenet) name(`dyadname') `vars' `labs' `xvars'
			
			if "`undirected'" != "" {
				nwsym `dyadname'
			}
		}
		
	}
	if "`density'" != "" {
		// Generate network from weight network
		preserve
		nwset, mat(`mat') name(_tempdyad)
		nwreplace _tempdyad = _tempdyad * 10
		nwtoedge _tempdyad, forcedirected full

		if "`undirected'" != "" {
			replace _tempdyad = 0 if _toid <= _fromid
		}

		local ties = `nodes' * (`nodes' -1) * `density'
		if "`undirected'" != "" {
			local ties = `ties' / 2
		}
		qui gen _nonzero = (_tempdyad > 0)
		qui sum _nonzero
		if `r(sum)' < `ties' {
			noi di "{err}Not enough non-zero weights to generate `ties' ties"
			nwdrop _tempdyad
			exit
		}
		qui drop if _fromid == _toid
		gsample `ties' [aweight=_tempdyad], generate(link) wor
		qui nwfromedge _fromid _toid link, name(`dyadname') `vars' `labs' `xvars'
		nwdrop _tempdyad
		restore
	}
	
	if "`undirected'" != "" {
		nwsym `dyadname'
	}
	if "`xvars'" == "" {
		nwload `dyadname'
	}
	capture mata : mata drop onenet
	nwcurrent `name'
end

capture mata: mata drop getNetFromProbs()
capture mata: mata drop transformIntoProbs()

mata:
real matrix getNetFromProbs(real matrix probs) {
	net = J(rows(probs), rows(probs), 0)
	if (rows(probs) == cols(probs)) {
		nodes = rows(probs)
		net = (runiform(rows(probs), cols(probs)):<= probs)	
		_diag(net, 0)
	}
	return(net)
}

real matrix transformIntoProbs(real matrix net) {
	if (max(net) > 1 | min(net) < 0) {
		net = invlogit(net)
		_diag(net,0)
	}
	return(net)
}
end


