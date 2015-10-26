cscript

clear mata
do unw_core.do
set more off

nwclear
nwrandom 20, prob(1)
mata: z = nw.nws.pdefs[1]->get_edge()[1,1]
mata: st_numscalar("z", z)
assert z == .
nwsummarize
assert r(arcs) == 380

nwclear
nwrandom 20, prob(1) selfloop
mata: z = nw.nws.pdefs[1]->get_edge()[1,1]
mata: st_numscalar("z", z)
assert z == 1
nwsummarize
assert r(arcs) == 400

nwclear
nwrandom 5, prob(.1) ntimes(5)
nwset
assert `r(networks)' == 5

nwclear
nwrandom 10, density(.1)
nwsummarize

nwset






