cscript

do unw_core.do

nwclear
nwset, mat((1,1,0\0,0,0\1,0,0))
nwdegree

assert reldif( r(outdg_central)  , .75               ) <  1E-8
assert reldif( r(indg_central)   , .75               ) <  1E-8
assert         r(r)             == 3
assert         r(N)             == 3

assert _out_degree[1] == 2
assert _out_degree[2] == 0
assert _out_degree[3] == 1

assert _in_degree[1] == 2
assert _in_degree[2] == 1
assert _in_degree[3] == 0

nwclear
nwset, mat((0,1,0\0,0,0\1,0,0)) undirected
nwdegree

assert reldif( r(dg_central)  , .5                ) <  1E-8
assert         r(r)          == 2
assert         r(N)          == 3

assert _degree[1] == 2
assert _degree[2] == 1
assert _degree[3] == 1




