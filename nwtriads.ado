capture program drop nwtriads
program nwtriads
	version 9
	syntax [anything(name=netname)]
	
	if "`mode'" == "" {
		local mode = "dyad"
	}
	
	if "`netname'" == "" {
		nwcurrent
		local netname = r(current)
	}
	
	nwname `netname'

	nwtomata `netname', mat(censusNet)
	mata: A = censusNet :/censusNet
	mata: _editmissing(A, 0)
	mata: E = abs(censusNet) + abs(censusNet)'
	mata: E = E :/ E
	mata: _editmissing(E, 0)
	mata: M = A + A'
	mata: _editvalue(M, 1, 0)
	mata: _editvalue(M, 2, 1)
	mata: C = A - M
	mata: Ecompl = E
	mata: _editvalue(Ecompl, 0, 10)
	mata: _editvalue(Ecompl, 1, 0)
	mata: _editvalue(Ecompl, 10, 1)
	mata: diagonal = J(rows(Ecompl), 1, 0)
	mata: _diag(Ecompl, diagonal)
	mata: x_003 = sum(diagonal((Ecompl * Ecompl * Ecompl))) / 6
	mata: st_numscalar("r(_003)", x_003)
	mata: x_012 = sum((Ecompl * Ecompl) :* (C + C')) / 2
	mata: st_numscalar("r(_012)", x_012)
	mata: x_102 = sum((Ecompl * Ecompl) :* M) / 2
	mata: st_numscalar("r(_102)", x_102)
	mata: x_021D = sum((C' * C) :* ( Ecompl :/ 2))
	mata: st_numscalar("r(_021D)", x_021D)
	mata: x_021U = sum((C * C') :* ( Ecompl :/ 2))
	mata: st_numscalar("r(_021U)", x_021U)
	mata: x_021C = sum((C * C) :* Ecompl)
	mata: st_numscalar("r(_021C)", x_021C)
	mata: x_030T = sum((C * C) :* C)
	mata: st_numscalar("r(_030T)", x_030T)
	mata: x_030C = sum(diagonal(C * C * C)) / 3
	mata: st_numscalar("r(_030C)", x_030C)
	mata: x_201 = sum((M * M) :* (Ecompl :/ 2))
	mata: st_numscalar("r(_201)", x_201)
	mata: x_120D = sum((C' * C) :* (M :/ 2))
	mata: st_numscalar("r(_120D)", x_120D)
	mata: x_120U = sum((C * C') :* (M :/ 2))
	mata: st_numscalar("r(_120U)", x_120U)
	mata: x_120C = sum((C * C) :* M)
	mata: st_numscalar("r(_120C)", x_120C)
	mata: x_210 = sum((M * M) :* ((C + C') :/ 2))
	mata: st_numscalar("r(_201)", x_201)
	mata: x_300 = sum(diagonal(M * M *M)) / 6
	mata: st_numscalar("r(_300)", x_300)
	mata: t201 = (M * M) :* Ecompl
	mata: t021D = (C' * C) :* Ecompl
	mata: t021U = (C * C') :* Ecompl
	mata: t111D = ((A * A') :* Ecompl) - t201 - t021U
	mata: x_111D = sum(t111D) / 2
	mata: t111U = ((A' * A) :* Ecompl) - t201 - t021D
	mata: x_111U = sum(t111U) / 2
	mata: st_numscalar("r(_111D)", x_111D)
	mata: st_numscalar("r(_111U)", x_111U)
	mata: mata drop censusNet A C E M Ecompl
	di
	di "{txt}    Triad census: {res} `netname'{txt}"
	di 
	di "{txt}{ralign 10:003}{col 12}{c |}{ralign 10:012}{col 24}{c |}{ralign 10:021D}{col 36}{c |}{ralign 10:021U}{col 48}{c |}{ralign 10:021C}{col 60}{c |}{ralign 10:030T}{col 72}{c |}{ralign 10:030C}{col 84}{c |}"
	di "{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}"
	di "{res}{ralign 10:`r(_003)'}{col 12}{c |}{ralign 10:`r(_012)'}{col 24}{c |}{ralign 10:`r(_021D)'}{col 36}{c |}{ralign 10:`r(_021U)'}{col 48}{c |}{ralign 10:`r(_021C)'}{col 60}{c |}{ralign 10:`r(_030T)'}{col 72}{c |}{ralign 10:`r(_030C)'}{col 84}{c |}"
	di
	di "{txt}{ralign 10:120D}{col 12}{c |}{ralign 10:120U}{col 24}{c |}{ralign 10:120C}{col 36}{c |}{ralign 10:111D}{col 48}{c |}{ralign 10:111U}{col 60}{c |}{ralign 10:201}{col 72}{c |}{ralign 10:300}{col 84}{c |}"
	di "{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}{hline 11}{c +}"
	di "{res}{ralign 10:`r(_120D)'}{col 12}{c |}{ralign 10:`r(_120U)'}{col 24}{c |}{ralign 10:`r(_120C)'}{col 36}{c |}{ralign 10:`r(_111D)'}{col 48}{c |}{ralign 10:`r(_111U)'}{col 60}{c |}{ralign 10:`r(_201)'}{col 72}{c |}{ralign 10:`r(_300)'}{col 84}{c |}"
end
	
	
