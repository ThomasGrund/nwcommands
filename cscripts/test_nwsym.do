cscript

do unw_core.do

nwclear
nwset, mat((1,1,0\0,0,0\1,0,0))
mata: sym = (nw.nws.pdefs[1]->get_edge()) == (nw.nws.pdefs[1]->get_edge())'
mata: st_numscalar("s", sym)
assert s == 0

nwsym
mata: sym = (nw.nws.pdefs[1]->get_edge()) == (nw.nws.pdefs[1]->get_edge())'
mata: st_numscalar("s", sym)
assert s == 1

nwclear
nwset, mat((1,2,0\4,0,0\1,0,0))
nwsym, mode(min)
mata: sym = (nw.nws.pdefs[1]->get_edge())[1,2]
mata: st_numscalar("s", sym)
assert s == 2

nwclear
nwset, mat((1,2,0\4,0,0\1,0,0))
nwsym, mode(max)
mata: sym = (nw.nws.pdefs[1]->get_edge())[1,2]
mata: st_numscalar("s", sym)
assert s == 4

nwclear
nwset, mat((1,2,0\4,0,0\1,0,0))
nwsym, mode(sum)
mata: sym = (nw.nws.pdefs[1]->get_edge())[1,2]
mata: st_numscalar("s", sym)
assert s == 6

nwclear
nwset, mat((1,2,0\4,0,0\1,0,0))
nwsym, mode(mean)
mata: sym = (nw.nws.pdefs[1]->get_edge())[1,2]
mata: st_numscalar("s", sym)
assert s == 3

