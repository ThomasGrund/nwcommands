cscript

clear mata
mata: mata desc
do unw_core.do
set more off

nwset, mat(J(4,4,2)) name("first")
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


