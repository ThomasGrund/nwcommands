cscript

clear mata
do unw_core.do
set more off

nwclear
set obs 5
gen x = "A"
gen y = "B"
nwfromedge _all
assert B[1] == 1

nwclear
set obs 5
gen x = "A"
gen y = "B"
nwfromedge _all, undirected
assert B[1] == 1
assert A[2] == 1

nwclear
set obs 5
gen x = 4
gen y = 5
nwfromedge _all
assert _5[1] == 1

nwclear
set obs 5
gen x = 4
gen y = 5
nwfromedge _all, prefix(net)
assert net5[1] == 1







