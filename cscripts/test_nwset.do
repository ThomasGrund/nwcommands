cscript

clear mata
do unw_core.do
set more off

nwclear
nwset, mat(J(4,4,2)) name("second")
nwset, mat(J(6,6,2)) name("second")
nwset
assert `"`r(nets)'"' == `" second second_1"'
assert         r(networks) == 2

nwclear
set obs 4
gen v1 = 0
gen v2 = (_n == 3)
gen v3 = (_n < 3)
gen v4 = 0
gen v5 = (_n < 3)

nwset v*, name(netfromvar)
assert `"`r(netlist)'"'  == `"netfromvar"'
assert `"`r(networks)'"' == `"1"'
assert         r(id) == 1

nwclear
nwset, mat(J(4,4,1)) labs(a,b)
mata: st_local("lab1", nw.nws.pdefs[1]->nodes[1])
assert "`lab1'" == "a"

nwclear
nwset, mat(J(4,4,1)) labs(a,b,c,d,e,f,g,h)
mata: st_local("lab1", nw.nws.pdefs[1]->nodes[1])
assert "`lab1'" == "a"

nwclear
nwset, mat(J(4,4,1)) labs(a,a)
mata: st_local("lab1", nw.nws.pdefs[1]->nodes[1])
rcof `"assert "`lab1'" == "a""' != 0

nwclear
set obs 4
gen v1 = 0
gen v2 = (_n == 3)
gen v3 = (_n < 3)
gen v4 = 0
gen v5 = (_n < 3)
gen nodelab = "mynode" + string(_n)

nwset v*, labsfromvar(nodelab)
mata: st_local("lab1", nw.nws.pdefs[1]->nodes[1])
assert "`lab1'" == "mynode1"

nwclear
set obs 4
gen v1 = 0
gen v2 = (_n == 3)
gen v3 = (_n < 3)
gen v4 = 0
gen v5 = (_n < 3)
gen nodelab = "mynode" + string(_n)

nwset v*, labsfromvar(nodelab) bipartite
mata: st_local("lab1", nw.nws.pdefs[1]->nodes[6])
assert "`lab1'" == "mynode1"

nwclear
nwset, mat(J(4,4,2)) name("second")
mata: st_numscalar("val", nw.nws.pdefs[1]->get_edge()[1,1])
assert val == .

nwclear
nwset, mat(J(4,4,2)) name("second") selfloop
mata: st_numscalar("val", nw.nws.pdefs[1]->get_edge()[1,1])
assert val == 2

nwclear
nwset, mat(J(4,4,2)) name("second") bipartite
mata: st_numscalar("val1", nw.nws.pdefs[1]->get_edge()[2,1])
assert val1 == .
mata: st_numscalar("val2", nw.nws.pdefs[1]->get_edge()[5,1])
assert val2 == 2
