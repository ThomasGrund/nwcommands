*! full_palette v1.1 - NJGW
*! program to display color palettes
capture program drop schemeinfo
program schemeinfo
		syntax [, msize(string)]
		//qui {
		if "`msize'"  == "" {
			local msize "large"
		}
		set more off
		clear
        local n = _N
		gr_setscheme 
		
		local nsymbols = 1
		local mysymb = "null"
		while (trim("`mysymb'") != "") {
			local mysymb = "`.__SCHEME.symbol.p`nsymbols''"
			local nsymbols = `nsymbols' + 1
		}
		local nsymbols = `nsymbols' - 2
		
		local ncolors = 1
		local mycol = "null"
		while (trim("`mycol'") != "") {
			local mycol = "`.__SCHEME.color.p`ncolors''"
			local ncolors = `ncolors' + 1
		}
		local ncolors = `ncolors' - 2
		
		local nlcolors = 1
		local mylcol = "null"
		while (trim("`mylcol'") != "") {
			local mylcol = "`.__SCHEME.color.p`nlcolors'line'"
			local nlcolors = `nlcolors' + 1
		}
		local nlcolors = `nlcolors' - 2
		
	    local nlpatterns = 1
		local mylpat = "null"
		while (trim("`mylpat'") != "") {
			local mylpat = "`.__SCHEME.pattern.p`nlpatterns'line'"
			local nlpatterns = `nlpatterns' + 1
		}
		local nlpatterns = `nlpatterns' - 2
		
		set obs `=max(`ncolors',`nlcolors',`nsymbols') + 1' 
		
		gen coltemp = (_n)
		tostring coltemp, replace	
		gen str color="scheme p" + coltemp
		gen str lcolor= color + "line"

		gen plabel = "scheme plabel"
		gen pplotregion = "scheme plotregion"
		gen pbackground = "scheme backrgound"

		
		local cpos = 1
		local spos = 2.5
		local l1pos = 4
		local l2pos = 4.5
		local l3pos = (`l1pos' + `l2pos') / 2
		local opos = 6
		local epos = `opos' + 1.5
		local labpos = _N + 1
		
		gen x = _N - _n 
		gen cy = `cpos'
		gen y = -.5
		gen ly1 = `l1pos'
		gen ly2 = `l2pos'
		gen sy = `spos'
		gen oy = `opos'
	   
		gen s = _n - 1
		tostring s, replace
		replace s = "default" in 1
		
		gen sother = ""
		replace sother = "background" in  1
		replace sother = "plotregion" in 2
		replace sother = "label" in 3
		
		gen ssymb = ""
		gen scol = ""
		gen slcol = ""
		local cmd = ""
		
		
		forvalues i = 1/ `=`nsymbols'+1' {
			local mysymb = "`.__SCHEME.symbol.p`=`i'-1''"
			if `i' == 1 {
				local mysymb = "`.__SCHEME.symbol.p1'"
			}
			replace ssymb = "`mysymb'" in `i'
			local cmd `cmd' (scatter x sy if _n == `i' , msymbol("`mysymb'") mcolor(white) msize(`msize') mlcolor(black)) (scatter x sy if _n == `i' , msymbol(none) mlabcolor(black black) mlabgap(4 1) mlabel(ssymb))
		}
		forvalues i = 1 / `=`ncolors'+1' {
			local mycol = `"`.__SCHEME.color.p`=`i'-1''"'
				local mycol = "`.__SCHEME.color.p1'"
			}
			replace scol = "`mycol'" in `i' 
			local cmd `cmd' (scatter x cy if _n == `i' , msymbol(S) mcolor("`mycol'") msize(`msize') mlcolor(black)) (scatter x cy if _n == `i' , msymbol(none) mlabcolor(black black) mlabgap(4 1) mlabel(scol))
		}
		forvalues i = 1/ `=max(`=`nlcolors'+1',`=`nlptterns'+1')'  {
			local mylcol = "`.__SCHEME.color.p`=`i'-1'line'"
			local mylpat = "`.__SCHEME.pattern.p`=`i'-1'line'"
			if `i' == 1 {
				local mylcol = "`.__SCHEME.color.pline'"
			}
			replace slcol = "`mylcol'" in `i'
			local cmd `cmd' (pcspike x ly1 x ly2 if _n == `i' , lwidth(vthick) msymbol(none) lcolor("`mylcol'")) (scatter x ly2 if _n == `i' , msymbol(none) mlabcolor(black black) mlabgap(4 1) mlabel(slcol))
		}
	
		local myback = "`.__SCHEME.color.background'"
		gen sback = "`myback'"
		local cmd `cmd' (scatter x oy if _n == 1 , msymbol(S) mcolor("`myback'") msize(`msize') mlcolor(black))(scatter x oy if _n == 1 , msymbol(none) mlabcolor(black black) mlabgap(4 1) mlabel(sback))
				
		local mytitle = "`.__SCHEME.scheme_name'"
		
		local cmd (scatter x y, msymbol(none) mlabel(s) mlabcolor(black) yline(`=`labpos' - 1', lcolor(black)) xline(0.5, lcolor(black)) text(`labpos' 0 "Value") text(`labpos' `cpos' "Color") text(`labpos' `spos' "Symbol") text(`labpos' `l3pos' "Edgecolor") text(`labpos' `opos' "Background")) `cmd' 
		twoway `cmd' , title("`mytitle'", color(black)) ylab(, nogrid) xscale(range(0 `epos') off) yscale(range(0 `=`labpos'+1') off) legend(nodraw) graphregion(margin(zero) fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white))
	//}
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
