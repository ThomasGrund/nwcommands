cscript

do unw_core.do

nwclear
nwset, mat((1,1,0\0,0,0\1,0,0))
nwsummarize

nwduplicate, name("mycopy")
nwsummarize mycopy
assert reldif( r(density)        , .3333333333333333 ) <  1E-8
assert         r(arcs_value)    == 2
assert         r(arcs)          == 2
assert         r(maxval)        == 1
assert         r(minval)        == 0
assert         r(missing_edges) == 3
assert         r(selfloops)     == 0
assert         r(nodes)         == 3


