*! version 1.0.0  20may2015
program difmh, rclass
        version 14
        
        syntax varlist(numeric) [if] [in] [fw] ,        ///
                GRoup(varname numeric)                  ///
                [                                       ///
                items(varlist numeric)                  ///
                noYATES                                 ///
                Level(cilevel)                          ///
                Format(string)                          ///
                total(varname numeric)                  ///
                ]

        if missing("`format'") local format %9.4f
        
        confirm numeric format `format'
        mata: __confirm_irtdif_format()

        marksample touse
        
        __check01 `varlist', touse(`touse') stat(mh)
        __check01 `items', touse(`touse') stat(mh)
        
        if !missing("`items'") {
                local in : list items in varlist
                if !`in' {
di "{err}some items in {bf:items()} not present in varlist"
exit 198
                }
        }
        else local items `varlist'
        
        capture __check01 `group', touse(`touse') stat(mh)
        if _rc {
                di "{err}variable {bf:`group'} must be coded 0, 1, or missing"
                exit 198
        }
        
        local half  = 0.5*missing("`yates'")
        
        local n_items : list sizeof varlist
        local k_items : list sizeof items
        
        tempvar score
        if !missing("`total'") {
                qui gen `score' = `total' if `touse'
        }
        else {
                qui egen `score' = rowtotal(`varlist') if `touse'
                qui replace `touse' = 0 if `score'==0 | `score'==`n_items'
        }
        
        if !missing("`weight'") {
                local wgt [`weight'`exp']
        }

        qui sort `score'
        qui levelsof `score' if `touse', local(sc_k)
        local h : list sizeof sc_k
        tempname m r c out omt sigma n_level
        
        mat `out' = J(`k_items',5,.)
        mat `omt' = J(`k_items',1,.)
        mat `sigma' = J(`k_items',1,.)
        mat `n_level' = J(`k_items',1,.)
        
        local i 0
        
        foreach v of local items {
                local ++i
                local omit 0
                local n_lev 0
                
                // locals for Mantel-Haenszel chi2
                local mhn = 0
                local mhd = 0
                
                // locals for alpha Mantel-Haenszel (odds ratio)
                local a_mhn = 0
                local a_mhd = 0
                local n1 = 0
                local n2 = 0
                local n3 = 0
                local d1 = 0
                local d2 = 0
                local d3 = 0
                local d4 = 0

                foreach k of local sc_k {

                        qui tab `group' `v' if `score'==float(`k') `wgt', ///
                                matcell(`m') matrow(`r') matcol(`c')
                        
                        local rows = `r(r)'
                        local cols = `r(c)'
                        local n = r(N)
                        
                        if `rows'==1 | `cols'==1 {
                                local ++omit
                                continue
                        }
                        local n_lev = `n_lev' + `n'
                        
                        local nr = `m'[1,1] + `m'[1,2]
                        local nf = `m'[2,1] + `m'[2,2]
                        local m0 = `m'[1,1] + `m'[2,1]
                        local m1 = `m'[1,2] + `m'[2,2]
                        
                        local ea = (`nr'/`n')*`m1'
                        local var = (`nr'/`n')*(`nf'/`n')*(`m1'/(`n'-1)) * `m0'
                        
                        local mhn = `mhn' + (`m'[1,2] - `ea')
                        local mhd = `mhd' + `var'
                        
                        local a_mhn = `a_mhn' + (`m'[1,1]/`n')*`m'[2,2]
                        local a_mhd = `a_mhd' + (`m'[1,2]/`n')*`m'[2,1]
                        
                        // needed for variance of common odds ratio
                        
                        local n11xn22 = `m'[1,1] * `m'[2,2]
                        local n11pn22 = `m'[1,1] + `m'[2,2]
                        local n12xn21 = `m'[1,2] * `m'[2,1]
                        local n12pn21 = `m'[1,2] + `m'[2,1]
                        
                        local nn = `n'*`n'
                        
                        local n1 = `n1' + `n11pn22' * `n11xn22' / `nn'
                        local d1 = `d1' + `n11xn22' / `n'
                        
                        local n2 = `n2' + ///
                            (`n11pn22'*`n12xn21' + `n12pn21'*`n11xn22') / `nn'
                        local d2 = `d2' + `n11xn22' / `n'
                        local d3 = `d3' + `n12xn21' / `n'
                        
                        local n3 = `n3' + `n12pn21' * `n12xn21' / `nn'
                        local d4 = `d4' + `n12xn21' / `n'
                }

                if `h'-`omit' < 2 {
                        continue
                }
                
                local mh_chi2 = (abs(`mhn') - `half')^2 / `mhd'
                
                local mh_alpha = `a_mhn' / `a_mhd'

                local sig2 = `n1' / (2*(`d1'^2))        ///
                           + `n2' / (2*`d2'*`d3')       ///
                           + `n3' / (2*(`d4'^2))

                local sig = sqrt(`sig2')
                
                local z = invnormal((100+`level')/200)
                
                mat `out'[`i',1]        = `mh_chi2'
                mat `out'[`i',2]        = chiprob(1,`mh_chi2')
                mat `out'[`i',3]        = `mh_alpha'
                mat `out'[`i',4]        = `mh_alpha' * exp(-`z'*`sig')
                mat `out'[`i',5]        = `mh_alpha' * exp(+`z'*`sig')

                mat `sigma'[`i',1]      = `sig2'
                mat `omt'[`i',1]        = `omit'
                mat `n_level'[`i',1]    = `n_lev'
        }
        
        mata: __di_irtdif_mh()
        
        mat colnames `out' = Chi2 Prob. "Odds Ratio" "[`level'% Conf." "Interval]"
        mat rownames `out' = `items'

        mat rownames `omt' = `items'
        mat rownames `sigma' = `items'
        mat rownames `n_level' = `items'

        qui summ `touse' if `touse' `wgt', meanonly
        return scalar N         = `r(N)'
                        
        return scalar level     = `level'
        return hidden scalar H  = `h'
        return scalar yates     = missing("`yates'")
        
        return matrix dif       = `out'
        return matrix _N        = `n_level'
        return matrix sigma2    = `sigma'
        return hidden matrix omit = `omt'
        
        if !missing("`weight'") {
                return local wtype      "`weight'"
                return local wexp       "`exp'"
        }
        
        if !missing("`total'") {
                return local total      "`total'"
        }
        
        return local group      "`group'"
        return local items      "`varlist'"
        return local cmdline    "difmh `0'"
        return local cmd        "difmh"
        
end

program __check01
        syntax [varlist(default=none)] , touse(varname) stat(string)
        foreach v in `varlist' {
                capture assert missing(`v') | inlist(`v',0,1) if `touse'
                if _rc {
di "{err}variable {bf:`v'} has invalid values;"
di "{err}irtdif `stat' requires item variables be coded 0, 1, or missing"
exit 198
                }
        }
end

version 14
mata:
mata set matastrict on

void __confirm_irtdif_format() {

// we need to check format at the beginning, otherwise ado code will
// calculate statistics, which may take some time, and then we will error out 
// on display

        string scalar fmt, ok_fmt, my_fmt
        string vector tok
        real scalar ok, x, y, f_w
                
        fmt = st_local("format")
                
        // Allowed numeric formats at g, f, e.  Max width is 9.

        ok_fmt = "g","f","e"
        
        // width for numerical columns
        if ( substr(fmt,1,1) != "%" ) {
                printf("{err}invalid {bf:format()}\n")
                exit(198)
        }
        if ( substr(fmt,-1,1) == "c" ) {
                my_fmt = substr(fmt,-2,1)
        }
        else my_fmt = substr(fmt,-1,1)
        ok = sum( ok_fmt :== my_fmt )
        if (!ok) {
                printf("{err}invalid {bf:format();}\n")
                printf("{err}allowed numerical format is one of e, f, g\n")
                exit(198)
        }

        tok = tokens(fmt,", .")
        f_w = strtoreal(substr(tok[1],2,.))
        
        if (f_w > 9) {
                printf("{err}invalid {bf:format()};\n")
                printf("{err}width must be <= 9\n")
                exit(198)
        }
        
        // check format x.y, disallow 9.8
        x = abs(f_w)
        y = strtoreal(substr(tok[3],1,1))
        if (x==9 & y==8) {
                printf("{err}invalid {bf:format()};\n")
                printf("{err}widest allowed format is 9.7\n")
                exit(198)
        }
}

void __di_irtdif_mh() {

        string scalar fmt, ci, text, itm_fmt, ttl_fmt
        string vector items, ok_fmt, my_fmt, tok
        real scalar i, i_w, ok, f_w, x, y
        real scalar p
        real vector values
        real matrix res
        class _tab scalar Tab
        
        fmt = st_local("format")
        ci = st_local("level")
        items = tokens(st_local("items"))
        res = st_matrix(st_local("out"))

// The output table has a fixed format with the exception of the Item column
// whose width can be between 6 and 13 characters.
// The remaining columns have a width of 9 characters with 4 spaces between
// the numbers if displayed as %9.7f.

// We check for a valid format again, just in case someone comments out
// the call to __confirm_irtdif_format() in ado code

        ok_fmt = "g","f","e"

        // width of Item column
        i_w = max( (udstrlen(items),5) )
        i_w = min((i_w,12))
        
        // width for numerical columns
        if ( substr(fmt,1,1) != "%" ) {
                printf("{err}invalid {bf:format()}\n")
                exit(198)
        }
        if ( substr(fmt,-1,1) == "c" ) {
                my_fmt = substr(fmt,-2,1)
        }
        else my_fmt = substr(fmt,-1,1)
        ok = sum( ok_fmt :== my_fmt )
        if (!ok) {
                printf("{err}invalid {bf:format()};\n")
                printf("{err}allowed numerical format is one of e, f, g\n")
                exit(198)
        }

        tok = tokens(fmt,", .")
        f_w = strtoreal(substr(tok[1],2,.))
        
        if (f_w > 9) {
                printf("{err}invalid {bf:format()};\n")
                printf("{err}width must be <= 9\n")
                exit(198)
        }

        // check format x.y, disallow 9.8
        x = abs(f_w)
        y = strtoreal(substr(tok[3],1,1))
        if (x==9 & y==8) {
                printf("{err}invalid {bf:format()};\n")
                printf("{err}widest allowed format is 9.7\n")
                exit(198)
        }
        
        // print table
        
        printf("\n{txt}Mantel-Haenszel DIF Analysis\n\n")

        Tab.init(6)
        Tab.set_lmargin(0)
        Tab.set_vbar((0,1,0,1,0,0,0))
        Tab.set_width((i_w+1,10,14,11,13,13))

        text    = J(1,6,"")
        
        itm_fmt = sprintf("%%%gs",i_w)

        p = strpos(fmt, ".")
        if (p == 0) {
                p = strpos(fmt, ",")
        }
        if (p) {
                if (bsubstr(fmt,1,2) == "%0") {
                        fmt = "%09" + bsubstr(fmt, p, .)
                }
                else if (bsubstr(fmt,1,2) == "%-") {
                        fmt = "%-9" + bsubstr(fmt, p, .)
                }
                else {
                        fmt = "%9" + bsubstr(fmt, p, .)
                }
        }

        Tab.set_format_string((itm_fmt,"","","","",""))
        Tab.set_format_number(("",fmt,fmt,fmt,fmt,fmt))
        
        text = J(1,6,"")
        text[1] = "Item"
        text[2] = "Chi2"
        text[3] = "Prob."
        text[4] = "Odds Ratio"
        text[5] = sprintf("[%g%% Conf. Interval]",strtoreal(ci))
        
        ttl_fmt = J(1,6,"")
        ttl_fmt[2] = "%10s"
        ttl_fmt[3] = "%13s"
        ttl_fmt[4] = "%11s"
        ttl_fmt[5] = sprintf("%%%fs",26)
        Tab.set_format_title(ttl_fmt)
        
        Tab.titles(text)
        
        Tab.sep()
        
        for (i=1; i<=rows(res); i++) {
                values = 0,res[i,.]
                text = J(1,6,"")
                text[1] = abbrev(items[i],12)
                Tab.row(values,text)
        }

        Tab.sep("bottom")
}

end

exit
