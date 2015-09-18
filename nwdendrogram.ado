capture program drop nwdendrogram
program nwdendrogram
	syntax [anything(name=clus)], [ factor(passthru) label(varname) * ]
	
	preserve
	cluster query
	if "`clus'" != "" {
		/*local found : list clus & r(names)
		if "`found'" == "" {
			di "{err}Cluster name {bf:clus} not found."
			exit
		}*/
	}
	else {
		cluster query
		local clus : word 1 of `r(names)'
		if "`clus'" == "" {
			di "{err}No cluster analysis found"
			exit
		}
	}	
	
	local ord = "`clus'_ord"
	local hgt = "`clus'_hgt"
	
	qui levelsof `hgt'
	local rings : word count `r(levels)'

	qui replace `hgt' = float(`hgt')

	tempname _level
	
	local i = 1
	local mylevels ""
	capture drop __lev*
	qui foreach onelevel in `r(levels)' {
		gen __lev`i' = _n
		replace __lev`i' = __lev`i'[_n - 1] if `hgt'[_n - 1] <= float(`onelevel')
		local mylevels "`mylevels' __lev`i' "
		local i = `i' + 1
	}
	
	qui if "`label'" != "" {
		capture mata: mata drop myord mylab
		putmata myord = `ord'
		putmata mylab = `label'
		mata: mylab = mylab[myord]
		capture drop __`label'
		getmata __`label' = mylab, replace
		capture mata: mata drop myord mylab
		local label = "__`label'"
	}
	
	capture {
	if "`label'" == "" {
		local label = "`ord'"
	}

	qui levelsof `hgt'
	local maxCut = 0
	foreach onecut in `r(levels)' {
		if `onecut' > `maxCut' {
			local maxCut = `onecut'
		}
	}

	local cutpts ""
	foreach onecut in `r(levels)' {
		local cutpts "`cutpts' `=1 - `onecut'/`maxCut''" 
	}
	local cutpts "`cutpts' 0"
	set more off
	qui dendrogram_classes `mylevels', `factor' cutpoints(`cutpts') `options' label(`label') 
	}
	capture drop __lev*
	restore
	
end

capture program drop dendrogram_classes
program dendrogram_classes
	syntax varlist [, factor(real 1) cutpoints(numlist) yscale(string) xscale(string) colorpalette(passthru) symbolpalette(passthru) obsopt(string) nodeopt(string) ringopt(string) beamopt(string) coreopt(string) label(varname) *]

	if "`colorpalette'" == "" {
		local colorpalette = "black"
	}
	
	if "`symbolpalette'" == "" {
		local symbolpalette = "i"
	}
	
	if "`yscale'" == "" {
		if "`label'" == "" {
			local yscale "off range(-1.2 1.2) "
		}
		else {
			local yscale "off range(-2 2) "
		}
	}
	if "`xscale'" == "" {
		if "`label'" == "" {
			local xscale "off range(-1.2 1.2) "
		}
		else {
			local xscale "off range(-2 2) "
		}
	}
	
	local hierarchies "`varlist'"
	checkhierarchy `hierarchies'
	
	if r(hierarchical) == 0 {
		exit
	}
	
	preserve 
	 {
	
	local nodes = `=_N'
	keep  `hierarchies' `label'

	
	local rings : word count `hierarchies'
	if "`cutpoints'" != "" {
		local cpts : word count `cutpoints'
		if `cpts' != `=`rings' + 1' {
			di "{err}Wrong number of cutpoints"
			exit 
		}
	}
	
	local h = ""
	foreach var of varlist `hierarchies' {
		egen h_`var' = group(`var')
		local h "`h' h_`var'"
	}
	local hierarchies `"`h'"'
	local firstcol : word 1 of `hierarchies'
		
	if "`label'" != "" {
		gen nlabel = `label'	
	}
	
	if  "`label'" == "" {
		gen nlabel = ""		
	}
		
	keep `hierarchies' nlabel
	
	gen _temp1 = 1
	gen _run1 = _n
	local i = 1
	foreach var of varlist `hierarchies' {
		bys `var': egen _total_`i' = total(_temp1)
		local i = `i' + 1
	}
	
	sort _run1
	
	expand `=(`rings' * 2)', generate(duplicate)
	sort `hierarchies' nlabel

	gen _running = _n
	local i = 1
	foreach var of varlist `hierarchies' {
		gen id_`var' = 1
		replace id_`var' = id_`var'[_n-1] + id_`var' if `var' == `var'[_n-1]
		gen idold_`var' = id_`var'
		replace id_`var' = -9999 if `var'[_n] != `var'[_n + 2 * (`rings'-1)]
		bys `var': egen max_`var' = max(id_`var')
		sort _running
		gen idcent_`var' = id_`var' - ceil((max_`var') / 2)
		local i = `i' + 1
	}
	
	//tempvar _value x y angle
	
	gen _value = (2 * _pi) * (_n / `=_N')
	gen _clock = _n / `=_N' * 100
	
	local graphcmd ""
	local scattercmd ""
	
	
	gen _x = (sin(_value)) * `factor'
	gen _y = (cos(_value)) * `factor'

	gen _angle = ((_n -1 ) / (`=_N')) * 360 
	replace _angle = _angle - 180 if _angle > 90 & _angle < 270
	
	if "`label'" != "" {	
		forvalues i = 1/ `nodes' {
			local oneid = (`i' - 1) * (2 * `rings') + 1
			local onelab  = nlabel[`oneid']
			local onepos = 3 - round(12 * (`i'-1) / `nodes')
			local oneposraw = (3 - (12 * (`i'-1)/ `nodes'))
			local onecol = `firstcol'[`oneid']
			local oneangle = _angle[`oneid']
		
			if `onepos' <= 0 {
				local onepos = 12  + `onepos'
			}
			if `onepos' == 12  {
				if `oneposraw' >= 0  {
					local onepos 1
				}
				else {
					local onepos 11
				}
			}

			if `onepos' == 6  {
				if abs(`oneposraw') < 6 {
					local onepos 7
				}
				else {
					local onepos 5
				}
			}
			_getcolorstyle, i(`onecol') symbolpalette(`symbolpalette') colorpalette(`colorpalette')
			local onecol `r(col_fill)'
			local onesymb `r(symbol)'
			local scattercmd `"`scattercmd' (scatter _x _y if _n == `oneid' & `firstcol' != .,  mcolor("`onecol'") mlabcolor("`onecol'")  msymbol("`onesymb'") mlabposition(`onepos') mlabel(nlabel) mlabangle(`oneangle') `obsopt') "'
		}
	}
	else {
		qui levelsof `firstcol'
		foreach val in `r(levels)' {
			_getcolorstyle, i(`val')  symbolpalette(`symbolpalette') colorpalette(`colorpalette')
			local onecol `r(col_fill)'
			local onesymb `r(symbol)'
			local scattercmd `"`scattercmd' (scatter _x _y if `firstcol' == `val'  & _bx1 != .,  mcolor("`onecol'")  msymbol("`onesymb'") `obsopt') "'
		}
	}

	// Plot outer ring
	local outerringcmd ""
	local i = 1
	local onevar : word 1 of `hierarchies'
	
	if "`cutpoints'" != "" {
		local c : word 1 of `cutpoints'
		gen _ring`i'x1 = _x * `c'
		gen _ring`i'y1 = _y * `c'
	}
	else {
		gen _ring`i'x1 = _x * (1 + `rings' - `i') / (1 + `rings')
		gen _ring`i'y1 = _y * (1 + `rings' - `i') / (1 + `rings')
	}
	
	gen _ring`i'x2 = _ring`i'x1[_n+1]
	gen _ring`i'y2 = _ring`i'y1[_n+1]
	replace _ring`i'x2 = _ring`i'x1[1] in `=_N'
	replace _ring`i'y2 = _ring`i'y1[1] in `=_N'
	replace _ring`i'x1 = . if `onevar'[_n] != `onevar'[_n + (2 * `rings')]
	
	levelsof `onevar'
	local onevartotal : word count `r(levels)'
	local coltotal = `onevartotal'

	foreach val in `r(levels)' {
		_getcolorstyle, i( `val')  symbolpalette(`symbolpalette') colorpalette(`colorpalette')
		local onecol `r(col_fill)'
		local outerringcmd `"`outerringcmd' (pcspike _ring`i'x1 _ring`i'y1 _ring`i'x2 _ring`i'y2 if `onevar' == `val', lcolor("`onecol'") `ringopt') "'
	}
	
	// Plot inner rings
	local innerringcmd ""
	local i = 2
	gen run2 = _n

	foreach var of varlist `hierarchies' {
		//tempvar ring`i'x1 ring`i'y1 ring`i'x2 ring`i'y2 

		if `i' <= `rings'{
		
			local ii = `i' + 1
			local onevar : word `i' of `hierarchies'
			
			if "`cutpoints'" != "" {
				local c : word `i' of `cutpoints'
				gen _ring`i'x1 = _x * `c'
				gen _ring`i'y1 = _y * `c'
			}
			else {
				gen _ring`i'x1 = _x * (1 + `rings' - `i') / (1 + `rings')
				gen _ring`i'y1 = _y * (1 + `rings' - `i') / (1 + `rings')
			}		
			
			gen _ring`i'x2 = _ring`i'x1[_n+1]
			gen _ring`i'y2 = _ring`i'y1[_n+1]
			replace _ring`i'x2 = _ring`i'x1[1] in `=_N'
			replace _ring`i'y2 = _ring`i'y1[1] in `=_N'
	
			gen flip`i' =  (idcent_`var' == 0)
			gen flip`i'_running = flip`i'
			replace flip`i'_running = flip`i'_running + flip`i'_running[_n-1] if _n > 1
			gen flip`i'_running_old = flip`i'_running
			replace flip`i'_running = . if flip`i' != 1
		 
			bys `onevar': egen flip`i'_min = min(flip`i'_running)
			replace flip`i'_min = 1 if  flip`i'_min == 0
			bys `onevar': egen flip`i'_max = max(flip`i'_running)
			replace _ring`i'x1 = . if flip`i'_max == flip`i'_running_old
			
			replace flip`i' = 1 if (flip`i'_min <= flip`i'_running_old ) &  (flip`i'_max > flip`i'_running_old )
			sort run2

			levelsof `onevar'
			local onevartotal : word count `r(levels)'
			foreach val in `r(levels)' {
				_getcolorstyle, i(`=`coltotal' + `val'')  symbolpalette(`symbolpalette') colorpalette(`colorpalette')
				local onecol `r(col_fill)'
				local innerringcmd `"`innerringcmd' (pcspike _ring`i'x1 _ring`i'y1 _ring`i'x2 _ring`i'y2 if `onevar' == `val' & flip`i' == 1 , lcolor("`onecol'") `ringopt')"'
			}
			local coltotal = `coltotal' + `onevartotal'
		}
		local i = `i' + 1
	}
	gen _bx1 = _x 
	gen _by1 = _y
	
	if "`cutpoints'" != "" {
		local c : word 1 of `cutpoints'
		gen _bx2 = _x * `c'
		gen _by2 = _y * `c'
	}
	else {
		gen _bx2 = _x * `rings' / (1 + `rings')
		gen _by2 = _y * `rings' / (1 + `rings')
	}
	
	replace _bx1 = . if mod(_n,`=`rings' * 2') != 1
	
	local onevar : word 1 of `hierarchies'
	levelsof `onevar'
	local onevartotal : word count `r(levels)'
	foreach val in `r(levels)' {
		_getcolorstyle, i(`val')  symbolpalette(`symbolpalette') colorpalette(`colorpalette')
		local onecol `r(col_fill)'
		local beamcmd `"`beamcmd' (pcspike _bx1 _by1 _bx2 _by2 if `onevar' == `val', lcolor("`onecol'") `beamopt')"'
	}
	local coltotal = `onevartotal'
	local coltotallag = 0 
	
	
	// Plot the beams
	local i = 1
	foreach var of varlist `hierarchies' {
		//tempvar beam`i'x1 beam`i'y1 beam`i'x2 beam`i'y2 
		
		if "`cutpoints'" != "" {
			local c1 : word `i' of `cutpoints'
			local c2 : word `=`i'+1' of `cutpoints'
			gen _beam`i'x1 = _x * `c1'
			gen _beam`i'y1 = _y * `c1'
			gen _beam`i'x2 = _x * `c2'
			gen _beam`i'y2 = _y * `c2'
		}
		else {
			gen _beam`i'x1 = _x * (1 + `rings' - `i') / (1 + `rings')
			gen _beam`i'y1 = _y * (1 + `rings' - `i') / (1 + `rings')
			gen _beam`i'x2 = _x * (1 + `rings' - `i' - 1) / (1 + `rings')
			gen _beam`i'y2 = _y * (1 + `rings' - `i' - 1) / (1 + `rings')
		}
		
		replace _beam`i'x1 = . if idcent_`var' != 0
			
		levelsof `var'
		local onevartotal : word count `r(levels)'	
		foreach val in `r(levels)' {
			_getcolorstyle, i(`=`coltotallag' + `val'')  symbolpalette(`symbolpalette') colorpalette(`colorpalette')
			local onecol `r(col_fill)'
			local onesymb `r(symbol)'
			local scattercmd `"`scattercmd' (scatter _beam`i'x1 _beam`i'y1 if idcent_`var' == 0 & `var' == `val', msymbol("`onesymb'") mcolor("`onecol'") `nodeopt')"'				
		}
		
		local var2 : word `=`i' + 1' of `hierarchies'
		if "`var2'" != "" {
			levelsof `var2'
		}
		else {
			levelsof `var'
		}

		// No fancy beam colors
		local cpc = wordcount("`colorpalette'")
		if `cpc' == 1 {
			_getcolorstyle, i(1)  symbolpalette(`symbolpalette') colorpalette(`colorpalette')
			local onecol `r(col_fill)'
			local beamcmd `"`beamcmd' (pcspike _beam`i'x1 _beam`i'y1 _beam`i'x2 _beam`i'y2,  lcolor("`onecol'") `beamopt')"'	
		
		}

		// Fancy pantsy beam colors
		if `cpc' != 1 {
			local onevartotal2 : word count `r(levels)'
			foreach val in `r(levels)' {
				if "`var2'" != "" {
					_getcolorstyle, i(`=`coltotal' + `val'')  symbolpalette(`symbolpalette') colorpalette(`colorpalette')
					local onecol `r(col_fill)'
					local beamcmd `"`beamcmd' (pcspike _beam`i'x1 _beam`i'y1 _beam`i'x2 _beam`i'y2 if `var2' == `val',  lcolor("`onecol'") `beamopt')"'	
				}
				else {
					_getcolorstyle, i(`=`coltotallag' + `val'')  symbolpalette(`symbolpalette') colorpalette(`colorpalette')
					local onecol `r(col_fill)'
					local beamcmd `"`beamcmd' (pcspike _beam`i'x1 _beam`i'y1 _beam`i'x2 _beam`i'y2 if `var' == `val',  lcolor("`onecol'") `beamopt')"'	
				}
			}
			local coltotal = `coltotal' + `onevartotal2'
			local coltotallag = `coltotallag' + `onevartotal'
		}
		local i = `i' + 1
	}
	
	local corecmd "(scatter _beam`=`i'-1'x2 _beam`=`i'-1'y2, msymbol(o) mcolor(black) `coreopt')"
	
	twoway  `beamcmd' `outerringcmd' `innerringcmd' `scattercmd' `corecmd' , ylabel(, nogrid) yscale(`yscale') xscale(`xscale') aspect(1) legend(off)  `options'
	}
	restore
end


capture program drop checkhierarchy
program checkhierarchy, rclass
	syntax varlist(min=1)
	local hierarchical = 1
			
	local w : word count `varlist' 
	forvalues i = 2/`w' {
		tempvar variance`i'
		local j = `i' - 1
		local level1 : word `j' of `varlist'
		local level0 : word `i' of `varlist'
		bys `level1': egen `variance`i'' = sd(`level0')
		qui sum `variance`i''
		if r(sd) != 0 {
			local hierarchical = 0
			noi di "{err}Variable {bf:`level1'} is not nested in variable {bf:`level0'}{txt}"
		}
		
	}
	return scalar hierarchical = `hierarchical'
	return local variables "`varlist'"
	
end


capture program drop _getcolorstyle
program _getcolorstyle
	syntax [, i(string)  colorpalette(string) symbolpalette(string)]

	local i = mod(`i', 15) + 1
	
	mata: st_rclear()
	local i = `i' - 1

	// symbol of node
	if ("`symbolpalette'" != ""){
		local symbolpalette_length : word count `symbolpalette'
		local k  = mod(`i', `symbolpalette_length') + 1
		local symbol : word `k' of `symbolpalette' 
	}
	else {
		local symbol `"scheme p`=`i'+1'"'
	}

	// color of node
	if "`colorpalette'" != "" {
		local colorpalette_length : word count `colorpalette'
		local j  = mod(`i', `colorpalette_length') + 1
		local col_fill : word `j' of `colorpalette' 
	}
	else {
		local col_fill `"scheme p`=`i'+1'"'
	}

	// not implemented yet...
	if "`col_line'" == "" {
		local col_line = "`col_fill'"
	}

	mata: st_global("r(col_fill)", "`col_fill'")
	mata: st_global("r(col_line)", "`col_line'")
	mata: st_global("r(symbol)", "`symbol'")
end




*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
