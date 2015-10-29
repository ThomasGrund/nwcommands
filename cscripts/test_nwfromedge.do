cscript
mata: mata clear
do unw_core

set obs 4
gen x = "A"
gen y = "B"
gen z = _n
replace y = "C" in 2

nwfromedge x y
nwsummarize
assert `"`r(netname)'"'  == `"network"'
assert `"`r(name)'"'     == `"network"'
assert `"`r(labs)'"'     == `"A;B"'
assert `"`r(valued)'"'   == `"false"'
assert `"`r(directed)'"' == `"true"'
assert `"`r(selfloop)'"' == `"false"'
assert `"`r(mode2)'"'    == `"false"'
assert reldif( r(density)        , .5                ) <  1E-8
assert         r(arcs_value)    == 1
assert         r(arcs)          == 1
assert         r(maxval)        == 1
assert         r(minval)        == 0
assert         r(missing_edges) == 2
assert         r(selfloops)     == 0
assert         r(nodes)         == 2
assert         r(id)            == 1

nwclear
set obs 4
gen x = 1
gen y = 2
replace y = 3 in 2
nwfromedge x y, undirected
nwsummarize
assert         r(edges_sum)     == 2
assert         r(edges)         == 2
assert         r(maxval)        == 1
assert         r(minval)        == 0
assert         r(missing_edges) == 3
assert         r(selfloops)     == 0
assert         r(nodes)         == 3
assert         r(id)            == 1


nwclear
set obs 4
gen x = 4
gen y = 2
replace y = 3 in 2
nwfromedge x y, undirected
nwsummarize
assert         r(edges_sum)     == 2
assert         r(edges)         == 2
assert         r(maxval)        == 1
assert         r(minval)        == 0
assert         r(missing_edges) == 3
assert         r(selfloops)     == 0
assert         r(nodes)         == 3
assert         r(id)            == 1



