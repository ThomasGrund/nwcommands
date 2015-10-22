cscript

clear mata
mata: mata desc
do unw_core.do
set more off

nwset, mat(J(4,4,2)) name("first")
assert `"`r(netlist)'"'  == `"first"'
assert `"`r(networks)'"' == `"1"'
assert         r(id) == 1

nwset, mat(J(4,4,2)) name("second")
assert `"`r(netlist)'"'  == `"second"'
assert `"`r(networks)'"' == `"1"'
assert         r(id) == 2

nwset
assert `"`r(nets)'"' == `" first second"'
assert         r(networks) == 2

nwclear
nwset, mat(J(4,4,2)) name("second")

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



nw_datasync first
nw_datasync first

nw_clear

nwset


mata: nw.nws.names

mata: nw.nws.zap()
mata: nw.nws.names

mata: nw.nws.get_number()

mata: nw.nws.pdefs[1]->data_sync()

mata: nw.nws.pdefs[1]->nodes
mata: nw.nws.pdefs[1]->update_match()
mata: nw.nws.pdefs[1]->match

nwset, mat(J(4,4,2)) name("first")
nwset

mata: nw.nws.pdefs[1]->nodesvar

nw_validate first
return list

_nwsyntax
assert "`netobj'" == "nw.nws.pdefs[1]"

mata: nw.nws.get_max_nodes()

nwset
return list

nwrandom 10, prob(.2)

nwunab n : _all
nwset

mytest n : _all
return list


mata: mata desc

nwset, mat(J(4,4,2)) name("first")
nwset

mata: nw.nws.clear()
nwset, mat(J(4,4,2)) name("first")
nwset, mat(J(4,4,2)) name("second")
nwset

// WORK ON CLEAR, DELETE...
return list

_nwsyntax
di "`netname'"

nw_unab t : f*
di "`t'"

_nwsyntax f*
di "`netname'"

nw_tomata first, mat(firstmata)

mata: firstmata

mata: firstmata[1,1] = 99
mata: nw.nws.pdefs[1]->get_edge()

nw_tomata first, mat(secondmata) master
mata: (*secondmata)[1,1] = .
mata: nw.nws.pdefs[1]->get_edge()

nw_name first
return list

_nwsyntax f*
di "`netname'"

nw_name

nwsummarize first, mat

nwname first, newselfloop(true)
nwsummarize first, mat

webnwuse florentine
mata: nw.nws.pcurrent
mata: nw.nws.pdefs

nw_name first, newname("second")
nwset

nwunab s : flo*
di "`s'"

mata: nw.nws.pdefs[1]->get_vars()


mata: nw.nws.dumper()


