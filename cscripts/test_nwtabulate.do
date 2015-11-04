cscript

do unw_core.do

nwclear
webnwuse florentine

nwtabulate flomarriage
assert         r(r) == 2
assert         r(N) == 120

nwtabulate flomarriage flobusiness
assert `"`r(netname2)'"' == `"flobusiness"'
assert `"`r(netname1)'"' == `"flomarriage"'

assert         r(EI_pvalue) == 0
assert reldif( r(EI_index)   , -.6833333373069763) <  1E-8
assert         r(c)         == 2
assert         r(r)         == 2
assert         r(N)         == 120

qui {
mat T_row = J(2,1,0)
mat T_row[2,1] =                  1
}
matrix C_row = r(row)
assert mreldif( C_row , T_row ) < 1E-8
_assert_streq `"`: rowfullnames C_row'"' `"r1 r2"'
_assert_streq `"`: colfullnames C_row'"' `"c1"'
mat drop C_row T_row

qui {
mat T_col = J(1,2,0)
mat T_col[1,2] =                  1
}
matrix C_col = r(col)
assert mreldif( C_col , T_col ) < 1E-8
_assert_streq `"`: rowfullnames C_col'"' `"r1"'
_assert_streq `"`: colfullnames C_col'"' `"c1 c2"'
mat drop C_col T_col

qui {
mat T_table = J(2,2,0)
mat T_table[1,1] =                 93
mat T_table[1,2] =                  7
mat T_table[2,1] =                 12
mat T_table[2,2] =                  8
}
matrix C_table = r(table)
assert mreldif( C_table , T_table ) < 1E-8
_assert_streq `"`: rowfullnames C_table'"' `"r1 r2"'
_assert_streq `"`: colfullnames C_table'"' `"c1 c2"'
mat drop C_table T_table





