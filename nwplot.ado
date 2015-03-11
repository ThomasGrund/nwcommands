*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwplot
program nwplot
	version 9.0
	set more off
	local 0_original = `"`0'"'
	local layout = "" 
	syntax [anything(name=netname)][if/] [in/], [ ignorelgc lab  labelopt(string) _layoutfunction(string) arrows edgesize(string) ASPECTratio(string) components(string) arcstyle(string) arcbend(string) arcsplines(integer 10) nodexy(varlist numeric min=2 max=2) edgeforeground(string) GENerate(string) colorpalette(string) edgecolorpalette(string) edgepatternpalette(string) symbolpalette(string) lineopt(string) scatteropt(string) legendopt(string) size(string) color(string) symbol(string) edgecolor(string) label(varname) nodefactor(string) sizebin(string) edgefactor(string) arrowfactor(string) arrowgap(string) arrowbarbfactor(string) layout(string) iterations(integer 1000) scheme(string) * ]
	local twowayopt `"`options'"'
	
	// filter out lgc
	local 0 "`layout'"
	syntax [anything(name=something)], [ lgc *]
	tempvar lgc_var
	
	if "`ignorelgc'" != "" {
		local lgc = ""
	}
	local ignorelgc = ""
	
	if "`lgc'" != "" {
		nwgen `lgc_var' = lgc(`netname')
		local if_lgc = " `lgc_var' == 1"
	}
	
	local 0 = `"`0_original'"'
	syntax [anything(name=netname)][if/] [in/], [ lab  labelopt(string) _layoutfunction(string) arrows edgesize(string) ASPECTratio(string) components(string) arcstyle(string) arcbend(string) arcsplines(integer 10) nodexy(varlist numeric min=2 max=2) edgeforeground(string) GENerate(string) colorpalette(string) edgecolorpalette(string) edgepatternpalette(string) symbolpalette(string) lineopt(string) scatteropt(string) legendopt(string) size(string) color(string) symbol(string) edgecolor(string) label(varname) nodefactor(string) sizebin(string) edgefactor(string) arrowfactor(string) arrowgap(string) arrowbarbfactor(string) layout(string) iterations(integer 1000) scheme(string) * ]
	_nwsyntax `netname', max(1)
	qui nwsummarize `netname'
	if `r(density)' == 0 {
		di "{txt}Network empty. Plotting does not make sense.{txt}"
		exit
	}
	
	local masternetname "`netname'"
	
	if "`if_lgc'" != "" {
		local if = "`if_lgc'"
	}
	
	gettoken edgecolor_original edgecolor_options : edgecolor, parse(",")
	gettoken edgesize_original edgesize_options : edgesize, parse(",")
	local edgecolor `edgecolor_original'
	local edgesize `edgesize_original'
	
	if "`labelopt'" != "" {
		local scatteropt "`scatteropt' `labelopt'"
	}

    if "`in'" != "" {
		capture nwdrop _temp_in
		nwduplicate `netname', name(__temp_in)
		nwkeep __temp_in in `in'
		if "`edgecolor'" != "" {
			nwgen __temp_edgecolor_in = `edgecolor'
			local edgecolor "__temp_edgecolor_in"
			if "`edgecolor'" != "`netname'" {
				nwkeep __temp_edgecolor_in in `in'
			}
		}
		if "`edgesize'" != "" {
			nwgen __temp_edgesize_in = `edgesize'
			local edgesize "__temp_edgesize_in"
			if "`edgesize'" != "`netname'" & "`edgesize'" != "`edgecolor'"{
				nwkeep __temp_edgesize_in in `in'
			}
		}
		local netname "__temp_in"
		_nwsyntax `netname', max(1)
	}

     if "`if'"!="" {
		local ifmaster "if `if'"
		capture nwdrop __temp_if
		nwduplicate `netname', name(__temp_if)
		nwdrop __temp_if if (!(`if'))
		if "`edgecolor'" != "" {
			capture nwdrop _temp_edgecolor_if
			nwgen __temp_edgecolor_if = `edgecolor'
			local edgecolor "__temp_edgecolor_if"
			if "`edgecolor'" != "`netname'" {
				nwdrop __temp_edgecolor_if if (!(`if'))
			}
		}
		if "`edgesize'" != "" {
			capture nwdrop _temp_edgesize_if
			nwgen __temp_edgesize_if = `edgesize'
			local edgesize "_temp_edgesize_if"
			if "`edgesize'" != "`netname'" & "`edgesize'" != "`edgecolor'" {
				nwdrop __temp_edgesize_if if (!(`if'))
			}
		}
		
		local netname "__temp_if"
	}
	_nwsyntax `netname', max(1)
	
	qui if "`lab'" != ""{
		capture drop _nodelab
		capture drop _nodeid
		nwload `netname', labelonly
		local label "_nodelab"
	}
	
	capture which labellist
	if _rc != 0 {
		ssc install labellist
	}

		
	if "`aspectratio'" == "" {
		local aspectratio = 1
	}
	local aspectratio = `aspectratio'*  0.67
	
	if "`sizebin'" == "" {
		local sizebin = 1
	}
	
	if "`arrowbarbfactor'" == "" {
		local arrowbarbfactor = 1
	}
	local arrowbarbfactor = `arrowbarbfactor' * 0.7
	
	if "`nodefactor'" == "" {
		local nodefactor = 1
	}
	local nodefactor = `nodefactor' / 50
	/*if `nodes' > 20 {
		local nodefactor = `nodefactor' / 1.5
	}*/
	
	if "`edgefactor'" == "" {
		local edgefactor = 1
	}
	if "`arrowfactor'" == "" {
		local arrowfactor = 1
	}
	
	if "`arrowgap'" == "" {
		local arrowgap = 0
	}
	local arrowgap = `arrowgap' + 0.5

	if "`arcstyle'" == "" {
		local arcstyle = "automatic"
	}
	_opts_oneof "automatic curved straight" "arcstyle" "`arcstyle'" 6556

	if "`arcbend'" == "" {
		local arcbend = 1
	}
	local arcbend = `arcbend' * 2
	
	local gridcols = ceil(sqrt(`nodes'))
	local 0 = "`layout'"
	syntax [anything][, lgc norescale iterations(integer 1000) columns(integer `gridcols') ]
	
	if("`anything'"=="") {
		if `nodes' < 50 {
			local anything "mds"
		}
		else {
			local anything "mdsclassical"
		}
	}
	
	local layout_norescale "`rescale'"
	local layout_gridcols = "`columns'"
	local layout_components = "`components'"
	local layout = "`anything'"
	_opts_oneof "mds mdsclassical grid circle nodexy _layoutfunction" "layout" "`layout'" 6556


	// Check matsize (because mds requires STATA matrix)
	if (c(matsize) <`nodes'& "`layout'" == "mds") {
		if "`c(flavor)'" == "Small" {
			di "{err}STATA Small can only use {it:layout(mds)} with networks with max. {bf:100} nodes; {it:layout(circle)} selected instead."
			local layout = "circle"
		}
		else {
			if (c(SE) == 0 & c(MP) == 0 & `nodes' > 800){
				di "{err}STATA/IC can only use {it:layout(mds)} with networks with max. {bf:800} nodes; {it:layout(circle)} selected instead."
				local layout = "circle"
			}
			else{ 
				if (`nodes' > 11000) {
					di "{err}Unfortunately, STATA can only use {it:layout(mds)} with networks with max. {bf:1100} nodes; {it:layout(circle)} selected instead."
					local layout = "circle"
				}
				else {
					set matsize `nodes'
				}
			}
		}
	}
	
	local dolabel  = ("`label'" !="")

	if "`directed'" == "false" & "`arcstyle'" == "automatic" {
		local arcstyle = "straight"
	}

	if "`directed'" == "true" {
		local arrows = "arrows"
	}
	if "`arrows'" != "" {
		local pc "pcarrow"
		local doarrows = 1
	}
	else {
		local pc "pcspike"
		local doarrows = 0
	}
	if "`scheme'" != "" {
		local schemetwoway "scheme(`scheme')"
	}
	
	///////////////////
	//
	// NODE ATTRIBUTES
	//
	///////////////////
	
	preserve
	if "`ifmaster'" != "" {
		keep `ifmaster'
	}
	
	// Color of nodes
	local colorkeys ""
	local colororder ""
	local colorlabels ""
	
	if ("`color'" != ""){
		local 0 = "`color'"
		syntax [varlist(default=none max=1)] [, norescale forcekeys(string) legendoff colorpalette(string) *]
		if "`varlist'" == "" {
			tempvar dummy_col
			gen `dummy_col' = 1
			local varlist "`dummy_col'"
			local legendoff "legendoff"
		}
		tempvar color_numeric
		capture encode `varlist' , gen(`color_numeric')
		if _rc == 0 {
			local varlist "`color_numeric'"
		}
		
		local colorkeys = "`forcekeys'"
		local colorkeys_legendoff "`legendoff'"
		local fnum : word count `forcekeys'
				
		// Use forced keys
		local j = 1
		if "`forcekeys'" != "" {
			qui tab `varlist' if _n <= `nodes', matrow(colorkeysmap)
			foreach i in `forcekeys' {
				local colororder "`colororder' `j'"
				local ckey = colorkeysmap[`i', 1]
				_getvaluelabel `varlist', key(`ckey')
				local colorlabels `"`colorlabels' label(`j' "`r(key_label)'")"'
				local j = `j' + 1
			}
		}
			
		// Rescale colors
		if "`rescale'" == "" {	
			tempvar __color
			egen `__color' = group(`varlist')
			mata: ncolor = st_data((1,`nodes'),st_varindex("`__color'"))
			if "`forcekeys'" == "" {
				qui tab `varlist' if _n <= `nodes', matrow(colorkeysmap)
				forvalues i = 1/`r(r)' {
					local ckey = colorkeysmap[`i', 1]
					local colorkeys "`colorkeys' `i'"
					local colororder "`colororder' `i'"
					_getvaluelabel `varlist', key(`ckey')
					local key_label : label (`varlist') `i'
					local colorlabels `"`colorlabels' label(`i' "`r(key_label)'")"'
				}
			}
		}
		else {
			mata: ncolor = st_data((1,`nodes'),st_varindex("`varlist'"))
			if "`forcekeys'" == "" {
				qui tab `varlist' if _n <= `nodes', matrow(colorkeysmap)
				forvalues i = 1/`r(r)' {
				
				
					local ckey = colorkeysmap[`i', 1]
					local colorkeys "`colorkeys' `ckey'"
					local colororder "`colororder' `i'"
					_getvaluelabel `varlist', key(`ckey')
					local colorlabels `"`colorlabels' label(`i' "`r(key_label)'")"'
				}
			}
		}
	}
	else {
		mata: ncolor = J(`nodes',1,1)
		local colorkeys = ""
	}
	if "`colorkeys_legendoff'" == ""{			
		local keysused : word count `colorkeys'
	}
	else {
		local keysused = 0
		local colororder = ""
		local colorlabels = ""
	}
	
	
	// Symbol of nodes
	local symbolkeys ""
	local symbolorder ""
	local symbollabels ""
	if ("`symbol'" != ""){
		// Check for known schemes without symbol support
		if "`scheme'" == "" {
			local scheme = c(scheme)
		}
		
		if ((strpos("s1color s2color economist", "`scheme'") > 0) & "`symbolpalette'" == "") {
			local symbolpalette "circle diamond square triangle smcircle smdiamond smsquare smtriangle"
		}
		
		local 0 = "`symbol'"
		syntax [varlist(default=none max=1)] [, norescale forcekeys(string) legendoff symbolpalette(string) *]
		if "`varlist'" == "" {
			tempvar dummy_symb
			gen `dummy_symb' = 1
			local varlist "`dummy_symb'"
			local legendoff "legendoff"
		}
		tempvar symbol_numeric
		capture encode `varlist', gen(`symbol_numeric')
		if _rc == 0 {
			local varlist "`symbol_numeric'"
		}
		
		local symbolkeys = "`forcekeys'"
		local symbolkeys_legendoff "`legendoff'"
		local fnum : word count `forcekeys'
				
		// Use forced keys
		forvalues i = 1/`fnum' {
			local j = `i' + `keysused' + 1
			local symbolorder "`symbolorder' `j'"
			_getvaluelabel `varlist', key(`i')
			local symbollabels `"`symbollabels' label(`j' "`r(key_label)'")"'
		}
			
		// Rescale symbols
		if "`rescale'" == "" {	
			tempvar __symbol
			egen `__symbol' = group(`varlist')
			mata: nsymbol = st_data((1,`nodes'),st_varindex("`__symbol'"))
			if "`forcekeys'" == "" {
				qui tab `varlist' if _n <= `nodes', matrow(symbolkeysmap)
				forvalues i = 1/`r(r)' {
					local j = `i' + `keysused'
					local skey = symbolkeysmap[`i', 1]
					local symbolkeys "`symbolkeys' `i'"
					local symbolorder "`symbolorder' `j'"
					_getvaluelabel `varlist', key(`skey')
					local symbollabels `"`symbollabels' label(`j' "`r(key_label)'")"'
				}
			}
		}
		else {
			mata: nsymbol = st_data((1,`nodes'),st_varindex("`varlist'"))
			if "`forcekeys'" == "" {
				qui tab `varlist' if _n <= `nodes', matrow(symbolkeysmap)
				forvalues i = 1/`r(r)' {
					local j = `i' + `keysused'
					local skey = symbolkeysmap[`i', 1]
					local symbolkeys "`symbolkeys' `skey'"
					local symbolorder "`symbolorder' `j'"
					_getvaluelabel `varlist', key(`skey')
					local symbollabels `"`symbollabels' label(`j' "`r(key_label)'")"'
				}
			}
		}
	}
	else {
		mata: nsymbol = J(`nodes',1,1)
	}
	
	local keysused_symbol : word count `symbolkeys'
	if "`symbolkeys_legendoff'" == "" & "`symbol'" != ""{
		local keysused = `keysused' + `keysused_symbol'
	}
	else{
		local symbolkeys = ""
		local symbolorder = ""
		local symbollabels = ""
	}
	
	local 0 = "`size'"
	syntax [varlist(min=0 max=1 default=none)][, norescale legendoff forcekeys(string) sizebin(integer 1) *]
	local size "`varlist'"
	// Size of nodes
	if ("`size'" != ""){
		local nodefactor = `nodefactor' / 2
		qui sum `varlist' if _n <= `nodes'
		local sizekeys_legendoff "`legendoff'"
		local sizekeys "`=round(`r(min)',0.01)' `=round(`r(max)',0.01)'"
		local sizekeys_size "`=round(`r(min)',0.01)' `=round(`r(max)',0.01)'"
		
		if "`forcekeys'" != "" {
			local sizekeys "`forcekeys'"
		}	
		
		capture drop __size
		gen __size = `varlist'
		if "`rescale'" == "" {
			local sizekeys_size ""
			if (`r(min)' != `r(max)') {
				qui replace __size = 1000 + 3000 * (`varlist') / (`r(max)')
				foreach szkey in `sizekeys' {
					local sizekeys_size_temp `= 1000 + 3000 * (`szkey' / (`r(max)'))'
					local sizekeys_size_temp = `sizekeys_size_temp' * `nodefactor' * 2/20
					local sizekeys_size "`sizekeys_size' `sizekeys_size_temp'"
				}
			}
			else {
				qui replace __size = 1500
				local szkey = 1500
				local sizekeys "`r(min)'"
				local sizekeys_size_temp = 1000
				local sizekeys_size_temp = `sizekeys_size_temp' * `nodefactor' * 2/20
				local sizekeys_size "`sizekeys_size' `sizekeys_size_temp'"
			}
			mata: nsize = st_data((1,`nodes'),st_varindex("__size"))
		}
		else {
			local sizekeys_size ""
			foreach szkey in `sizekeys' {
				local sizekeys_size "`sizekeys_size' `= 0.04 * `szkey''"
			}
			mata: nsize = st_data((1,`nodes'),st_varindex("__size"))
			mata: nsize = nsize :*40
		}
		local nodefactor = `nodefactor' / 20
		capture drop __size
	}
	else {
		mata: nsize = J(`nodes',1,80)
		local sizekeys ""
	}
	
	local sizeorder = ""
	local sizelabels = ""	
	local keysused_size : word count `sizekeys'
	if "`sizekeys_legendoff'" == ""  & "`size'" != ""{
		forvalues i = 1/ `keysused_size' {
			local sizelabel_temp : word `i' of `sizekeys'
			local sizeorder "`sizeorder' `=`keysused' + `i''"
			local sizelabels `"`sizelabels' label(`=`keysused' + `i'' "`varlist' = `sizelabel_temp'")"'
		}
		local keysused = `keysused' + `keysused_size'
	}
	else {
		local sizekeys = ""
	}
	
	restore
	
	// Label of nodes
	qui if ("`label'" != ""){
		capture confirm string variable `label'
		if _rc != 0 {
			tempvar nlabel_string
			tostring `label', generate(`nlabel_string') force
			mata: nlabel = st_sdata((1,`nodes'),st_varindex("`nlabel_string'"))
		}
		else {
			mata: nlabel = st_sdata((1,`nodes'),st_varindex("`label'"))
		}
	}
	else {
		mata: nlabel = J(`nodes',1,"")
	}

	////////////////////
	//
	//   EDGE ATTRIBUTES
	//
	////////////////////
	
	// Get network data
	nwtomata `netname', mat(plotmat)
	mata: M = (plotmat + plotmat') :/ (plotmat + plotmat')
	mata: _editmissing(M,0)
	// Get edgesize network data
	if "`edgesize'" != "" {
		if "`edgesize'" == "," {
			nwrandom `nodes', prob(1) name(__temp_edgesize_dummy)
			local edgesize "__temp_edgesize_dummy,"
			if strpos("`edgesize_options'", "legendoff") == 0 {
				local edgesize_options `"`edgesize_options' legendoff"'
			}
		}
		local 0 "`edgesize'`edgesize_options'"
		capture noi syntax [anything] [, forcekeys(string) legendoff ]
		if _rc != 0 {
			nwdrop __temp_edgesize_dummy
			error 6088
		}
		
		// check and clean networks as edgecolor and edgesize
		local edgesizekeys_legendoff "`legendoff'"
		local edgesize "`anything'"			
		_nwsyntax_other `edgesize', max(1) nocurrent
		local edgesize_directed = "`otherdirected'"	
		_nwsyntax_other `edgesize', max(1) nocurrent forcedirected(true)
		
		local edgesize = trim("`othernetname'")
		local othernetname = ""
		qui nwsummarize `edgesize'
		local siznodes = r(nodes)
		
		if `nodes' != `siznodes' {
			di "{err}{it:network} {bf:`edgesize'} needs to be of the same size as {it:network} {bf:`netname'}"
			error 6056
		}
		local edgesizekeys "`forcekeys'"
		if "`forcekeys'" == "" {
			local edgesizekeys "`r(minval)' `r(maxval)'"
		}
		nwtomata `edgesize', mat(edgesizemat)
		nwname `edgesize', newdirected("`edgesize_directed'")
	}
	else {
		mata: edgesizemat = J(`nodes',`nodes',1)
		local edgesizekeys ""
	}
	
	local edgesizeorder = ""
	local edgesizelabels = ""	
	local keysused_edgesize : word count `edgesizekeys'
	if "`edgesizekeys_legendoff'" == ""  & "`edgesize'" != ""{
		forvalues i = 1/ `keysused_edgesize' {
			local edgesizelabel_temp : word `i' of `edgesizekeys'
			local edgesizeorder "`edgesizeorder' `=`keysused' + `i''"
			local edgesizelabels `"`edgesizelabels' label(`=`keysused' + `i'' "`edgesize_original' = `edgesizelabel_temp'")"'
		}
		local keysused = `keysused' + `keysused_edgesize'
	}
	else {
		local edgesizekeys = ""	
	}
	
	// Get edgecolor network data
	if "`edgecolor'" != ""  {
		if "`edgecolor'" == "," {
			nwrandom `nodes', prob(0) name(__temp_edgecol_dummy)
			//nwreplace __temp_egdecol_dummy = .
			local edgecolor "__temp_edgecol_dummy,"
			if strpos("`edgecolor_options'", "legendoff") == 0 {
				local edgecolor_options `"`edgecolor_options' legendoff"'
			}
		}
		local 0 "`edgecolor'`edgecolor_options'"
		capture noi syntax [anything] [, forcekeys(string) legendoff edgecolorpalette(string) edgepatternpalette(string)]
		if _rc != 0 {
			nwdrop __temp_edgecolor_dummy
			error 6088
		}
		// check and clean network 
		local edgecolorkeys_legendoff "`legendoff'"
		local edgecolor "`anything'"
		_nwsyntax_other `edgecolor', max(1) nocurrent 
		local edgecolor_directed = "`otherdirected'"	
		_nwsyntax_other `edgecolor', max(1) nocurrent forcedirected(true)
		local edgecolor = trim("`othernetname'")
		local othernetname = ""
		qui nwsummarize `edgecolor'
		local siznodes = r(nodes)
		if `nodes' != `siznodes' {
			di "{err}{it:network} {bf:`edgecolor'} needs to be of the same size as {it:network} {bf:`netname'}"
			error 6056
		}
		local edgecolorkeys "`forcekeys'"

		qui if "`forcekeys'" == "" {
			nwtabulate `edgecolor', matrow(r)
			matrix edgecolor_mat = r
			
			local edgecolor_matrows = rowsof(edgecolor_mat)
			forvalues i = 1/`edgecolor_matrows'{
				local eckey = edgecolor_mat[`i',1]
				local edgecolorkeys "`edgecolorkeys' `=`eckey'+1'"
			}
		}
		nwtomata `edgecolor', mat(edgecolormat)
		mata: edgecolormat = edgecolormat :+ 1
		nwname `edgecolor', newdirected("`edgecolor_directed'")
	}
	else {
		mata: edgecolormat = J(`nodes',`nodes',0)
	}

	local edgecolororder = ""
	local edgecolorlabels = ""	
	local keysused_edgecolor : word count `edgecolorkeys'
	if "`edgecolorkeys_legendoff'" == ""  & "`edgecolor'" != ""{
		forvalues i = 1/ `keysused_edgecolor' {
			local edgecolorlabel_temp : word `i' of `edgecolorkeys'
			local edgecolororder "`edgecolororder' `=`keysused' + `i''"
			local edgecolorlabels `"`edgecolorlabels' label(`=`keysused' + `i'' "`edgecolor_original' = `=`edgecolorlabel_temp'-1'")"'
		}
		local keysused = `keysused' + `keysused_edgecolor'
	}
	else {
		local edgecolorkeys = ""	
	}

	////////////////////
	//
	//   CALCULATE NODE COORDINATES
	//
	////////////////////
	
	
	if "`nodexy'" != "" {
		local layout = "nodexy"
		local nodex = word("`nodexy'", 1)
		local nodey = word("`nodexy'", 2)
		
		/*
		foreach nvar of varlist `nodex' `nodey' {
			qui sum `nvar'
			if (r(min) < 0 | r(max) >= 2) {
				di "{err}Node coordinates not between 0 and 1.5 Option {it:layout(mds)} selected instead."
				local layout = "mds"		
			}
		}*/
	}
	
	/*
	if "`nodexy'" != "" {
		tempvar xcor ycor
		local layout = "nodexy"
		local nodex = word("`nodexy'", 1)
		local nodey = word("`nodexy'", 2)
		local k = 1
		if "`layout_norescale'" == "" {
			gen `xcor' = `nodex'
			gen `ycor' = `nodey'
			qui sum `xcor'
			replace `xcor' =(1.25 * (`xcor' - r(min)) / (r(max) - r(min))) + 0.25
			qui sum `ycor'
			replace `ycor' = (`ycor' - r(min)) / (r(max) - r(min))
			local nodex "`xcor'"
			local nodey "`ycor'"
		}
		else {
			//qui sum `nodex'
			/*if (r(min) < 0.25 | r(max) >= 1.5) {
				di "{err}Node coordinates outside of valid range; {it:layout(mds)} selected instead."
				local layout = "mds"		
			}
			else {
				qui sum `nodey'
				if (r(min) < 0 | r(max) >= 1) {
					di "{err}Node coordinates outside of valid range; {it:layout(mds)} selected instead."
					local layout = "mds"
				}
			}*/
		}
	}*/
	
	
	//local layout_gridcols "`columns'"
	local components = "`layout_components'"
	
	if ("`layout'"!="nodexy"){
		di "{text:Calculating node coordinates...}"
	}
	
	if ("`layout'"=="_layoutfunction") {
		gettoken _layoutfcn _layoutfcnopt: _layoutfunction, parse(",")
		mata: Coord = `_layoutfcn'(M`_layoutfcnopt')
	}
	if ("`layout'"== "mds"){
		mata: Coord = netplotmds(M, `iterations')
	}
    qui if ("`layout'"=="mdsclassical"  ){
		// Coordinates matrix to be populated
		mata: Coord = J(`nodes', 2, 0)
		mata: Coord[.,1] = J(`nodes', 1, 1.5) 
		// Deal with isolates
		tempvar _isolates
		nwgen `_isolates' = isolates(`netname')	
		qui count if `_isolates' == 1
		local isol = `r(N)'
		local nonisol = `nodes' - `isol'
		
		// Get number of components
		tempvar _component
		nwgen `_component' = components(`netname')
		if "`lgc'" != "" {
			qui nwgen `_component' = lgc(`netname')
			replace `_component' = 1 - `_component'
			local components = 1
		}
		
		local compnum = r(components)		
		local compnum_nonisol = `compnum' - `isol'
		qui tab `_component', matrow(comp_id) matcell(comp_freq)

		mata: comp_id = st_matrix("comp_id")
		mata: comp_freq = st_matrix("comp_freq")
		mata: comp_freqid = J(rows(comp_id), 2,0)
		mata: comp_freqid[.,1] = comp_freq
		mata: comp_freqid[.,2] = comp_id
		mata: comp_freqid = sort(comp_freqid, - 1)
		mata: comp_nonisol = sum((comp_freqid[.,1] :> 1))
		mata: st_numscalar("r(comp_nonisol)", comp_nonisol)
		local comp_nonisol = `r(comp_nonisol)'
		mata: st_matrix("comp_freqid", comp_freqid)

		// Find overall layout
		// Default = number of (non-isolates) components (undirected)
		if "`components'" == "" {
			local components = `comp_nonisol'
		}
		// Limit number of distinct boxes in graph
		if `components' > `comp_nonisol' {
			local components = `comp_nonisol'
		}
		if `components' > 5 {
			di "{txt}only the {bf:5} largest components are displayed"
			local components = 5
		}
		
		// Go through all (non-isolates) components (that should be plotted in boxes) from large to small
		qui forvalues i = 1/`components' {
			nwduplicate `netname', name(`netname'_comp`i')
			capture drop _id
			gen _id = _n
			
			nwdrop `netname'_comp`i' if `_component' != comp_freqid[`i', 2], attributes(_id) netonly
			nwtomata `netname'_comp`i', mat(compmat)
			// Original id's of selected nodes
			mata: original_id = st_data((1::rows(compmat)), "_id")
			
			// Calculate mds coordinates of network i
			mata: compM = (compmat :+ compmat') :/ (compmat :+ compmat')
			mata: _editmissing(compM,0)
			mata: Coord_comp = mmdslayout(compM)
			
			// Adjust coordinates for position in layout
			// Deal with largest component
			if `i' == 1  & `components' != 1 {
				mata: Coord_comp[.,1] = Coord_comp[.,1] :* 0.9
				if `components' == 1 {
					mata: Coord_comp[.,1] = Coord_comp[.,1] :+ 0.125
				}
			}
			if `i' == 1  & `components' == 1 {
				mata: Coord_comp[.,1] = Coord_comp[.,1] :+ 0.125
			}
			
			// Deal with second largest component
			if `i' == 2 {
				mata: Coord_comp[.,1] = (Coord_comp[.,1] :*0.45):+ 1.1
				mata: Coord_comp[.,2] = (Coord_comp[.,2] :*0.45):+ .5
			}	
			
			// Assign adjusted coordinates to original network
			mata: Coord[original_id,.] = Coord_comp
			mata: mata drop original_id 
			nwdrop `netname'_comp`i', netonly
		}
		capture drop _id 
	}
	capture replace `label' = `_orig_label'
	
	if ("`layout'"=="circle"){
		mata: Coord = circlelayout(rows(M))
	}
	if ("`layout'"=="grid"){
		if "`layout_gridcols'" == "" {
			local layout_gridcols = ceil(sqrt(`nodes'))
		}
		mata: Coord = gridlayout(rows(M), `layout_gridcols')
	}
	if ("`layout'"=="nodexy"){
		mata: Coord = J(rows(M),2,0)
		mata: Coord[.,1] = st_data((1,rows(M)),"`nodex'")
		mata: Coord[.,2] = st_data((1,rows(M)),"`nodey'")
	}
	
	
	// Obtain tie coordinates 
	mata: TC = getTieCoordinates(Coord,nsize,NumElist(plotmat), edgecolormat, edgesizemat, `nodefactor', `doarrows', `arrowgap')
	mata: st_numscalar("r(TC)", rows(TC))
	local minObs = max(`r(TC)', `nodes')
	
	// Prepare temporary Stata dataset for plotting
	preserve
	qui drop _all
	qui set obs `minObs'
	qui gen nx = .
	qui gen ny = .
	qui gen nsize = .
	
	qui gen ncolor = .
	qui gen nsymbol = .
	qui mata: st_addvar("str20", "nlabel")
	qui gen sx = .
	qui gen sy = .
	qui gen ex = .
	qui gen ey = .
	qui gen value = .
	qui gen recip = .
	qui gen edgecolor = .
	qui gen edgesize = .
	
	mata: st_numscalar("r(ties)", rows(TC))
	if `r(ties)' > 0 {
		mata: st_store((1::rows(TC)),("sx","sy","ex","ey","value","recip","edgecolor", "edgesize"),TC[.,.])
	}
	
	qui gen straight =  1 - recip
	qui replace straight = 0 if "`arcstyle'" == "curved"
	qui replace straight = 1 if "`arcstyle'" == "straight"
	qui gen arrow = straight
	
	if ("`arcstyle'" != "straight"){
		di "{txt}Generating splines..."
		//save raw.dta, replace
		qui nwplotsplines, unbend(straight) arrow(arrow) x1(sx) y1(sy) x2(ex) y2(ey) bend(`arcbend') splines(`arcsplines')
	}
	
	mata: st_store((1::rows(Coord)),("nx","ny"), Coord[.,.])
	mata: st_store((1::rows(nsize)),("nsize"), nsize[.,.])
	mata: st_store((1::rows(ncolor)),("ncolor"), ncolor[.,.])
	mata: st_store((1::rows(ncolor)),("nsymbol"), nsymbol[.,.])
	mata: st_sstore((1::rows(nlabel)),("nlabel"), nlabel[.,.])
	
	local binfactor = 1/`sizebin'
	qui replace nsize = (ceil(nsize * `binfactor'))* `sizebin'
	qui tab nsize, matrow(nsizerow)
	qui sum nsize
	local sizemin = r(min)
	local sizemax = r(max)	
	
	// Prepare plots and legend
	qui tab ncolor, matrow(ncolorrow)
	local ncols = rowsof(ncolorrow)
	if `ncols' == 0 { 
		local ncols = 1
	}
	
	qui tab nsymbol, matrow(nsymbolrow)
	local symbs = rowsof(nsymbolrow)
	
	qui tab nsize, matrow(nsizerow)	
	local sizs = rowsof(nsizerow)
	
	// Prepare ghost plots for legend
	tempvar ghost1 ghost2
	local ghostcmd ""
	qui gen `ghost1' = .
	qui gen `ghost2' = .
	local sizekeys_num = 0
	local colorkeys_num = 0
	local symbolkeys_num = 0
	local colorkeys_num : word count `colorkeys'
	local symbolkeys_num : word count `symbolkeys'	
	local sizekeys_num : word count `sizekeys'
	local edgesizekeys_num : word count `edgesizekeys'
	local edgecolorkeys_num : word count `edgecolorkeys'
	local columns = max(`symbolkeys_num', `colorkeys_num', `sizekeys_num', `edgesizekeys_num', `edgecolorkeys_num')
	

	local cols_found =  strpos("`legendopt'", "cols")
	if `cols_found' == 0 {
		local legendopt "`legendopt' cols(`columns')"
	}
	else {
		local 0 `",`legendopt'"'
		syntax [, cols(string) *]
		local columns = `cols'
	}
	
	
	// Get the ident of the legend
	local colorident = ""
	local temp = mod(`=`colorkeys_num'+1', `columns')
	if "`temp'" == "." {	
		local temp = 1 
	}
	forvalues i = `temp' / `columns' {
		if `colorkeys_num' != 0 {
			local colorident = "`colorident' - "
		}
	}
	
	local symbolident = ""
	local temp = mod(`=`symbolkeys_num'+1', `columns')
	if "`temp'" == "." {	
		local temp = 1 
	}
	forvalues i = `temp' / `columns' {
		if `symbolkeys_num' != 0 {
			local symbolident = "`symbolident' - "	
		}
	}

	local sizeident = "" 
	local temp = mod(`=`sizekeys_num'+1', `columns')
	if "`temp'" == "." {	
		local temp = 1 
	}
	forvalues i = `temp' / `columns' {
		if `sizekeys_num' != 0 {
			local sizeident = "`sizeident' - "
		}
	}
	
	local edgesizeident = "" 
	local temp = mod(`=`edgesizekeys_num'+1', `columns')
	if "`temp'" == "." {	
		local temp = 1 
	}
	forvalues i = `temp' / `columns' {
		if `edgesizekeys_num' != 0 {
			local edgesizeident = "`edgesizeident' - "
		}
	}
	
	
	// Ghost plots for node color
	if "`colorkeys_legendoff'" == "" {
		if `colorkeys_num' >= 1 {	
			local ckey = 0
			foreach i in `colorkeys' {
				_getcolorstyle, i(`i') j(0) colorpalette(`colorpalette') symbolpalette(`symbolpalette') scheme(`scheme')
				local tempcolstyle_fill = r(col_fill)
				local ghostcmd `"`ghostcmd' || (scatter `ghost1' `ghost2' if `ghost1' !=.,  msymbol("scheme p0")  mcolor("`tempcolstyle_fill'")  msize(2) `scatteropt') "'            		
			}
		}
	}
	else {
		local colorident ""
	}
	
	// Ghost plots for node symbol
	if "`symbolkeys_legendoff'" == "" {
		if `symbolkeys_num' >= 1 {	
			local skey = 0
			foreach j in `symbolkeys' {
				_getcolorstyle, i(0) j(`j') colorpalette(`colorpalette') symbolpalette(`symbolpalette') scheme(`scheme')
				local tempsymbol = r(symbol)
				local ghostcmd `"`ghostcmd' || (scatter `ghost1' `ghost2' if `ghost1' !=.,  msymbol("`tempsymbol'")  mlcolor("scheme p0") mfcolor("scheme background")  msize(2) `scatteropt') "'            		
			}
		}
	}
	else {
		local symbolident ""
	}
	
	// Ghost plots of size of nodes
	if "`size'" != "" & "`sizekeys_legendoff'" == ""{
		local i = 0
		foreach szkey in `sizekeys' {
			local i = `i' + 1
			local szkey_size : word `i' of `sizekeys_size'
			local ghostcmd `"`ghostcmd' || (scatter `ghost1' `ghost2' if `ghost1' !=.,  msymbol("scheme p0")  mlcolor("scheme p0") mfcolor("scheme p0")  msize(`szkey_size') `scatteropt') "'            		
		}
		local sizekeys_num : word count `sizekeys'
	}
	else {
		local sizeident ""
	}
	
	// Ghost plots of size of edges
	if "`edgesizekeys'" != "" & "`edgesizekeys_legendoff'" == ""{
		foreach eszkey in `edgesizekeys' {
			local tempval_line = (`eszkey' / 2) * `edgefactor' / 2
			local tempval_arrow = (`eszkey' + 1) * `arrowfactor' 
			local tempval_barb = `tempval_arrow' * `arrowbarbfactor'
			local ghostcmd `"`ghostcmd' || (`pc' `ghost1' `ghost2' `ghost2' `ghost1' if `ghost1' !=., lpattern(solid) lwidth(`tempval_line') lcolor("scheme p0") mcolor("scheme p0") msize(`tempval_arrow') barbsize(`tempval_barb') `lineopt') ||"'
		}
		local edgesizekeys_num : word count `edgesizekeys'
	}
	else {
		local edgesizeident ""
	}	
	
	// Ghost plots of color of edges
	if "`edgecolorkeys'" != "" & "`edgecolorkeys_legendoff'" == ""{
		foreach eckey in `edgecolorkeys' {
			_getcolorstyle, i(`=`eckey'') edgecolorpalette(`edgecolorpalette') edgepatternpalette(`edgepatternpalette') scheme(`scheme')
			local temppattern = r(edgepattern)
			local tempcolstyle = r(edgecol)
			local tempval_arrow = 3 * `arrowfactor' 
			local tempval_barb = `tempval_arrow' * `arrowbarbfactor'
			local ghostcmd `"`ghostcmd' || (pcspike `ghost1' `ghost2' `ghost2' `ghost1' if `ghost1' !=., lpattern(`"`temppattern'"') lwidth(1) lcolor(`"`tempcolstyle'"') mcolor(`"`tempcolstyle'"')  `lineopt') ||"'
		}
		local edgesizekeys_num : word count `edgesizekeys'
	}
	else {
		local edgesizeident ""
	}	
	
	local arrowgap = `arrowgap' + 1.2
	if "`legendopt'" == "" | `keysused' == 0 {
		local legendcmd = "legend(off)"
		local arrowgap = `arrowgap' - 5.2
	}
	else {
		local legendcmd `"legend(order(`colororder' `colorident' `symbolorder' `symbolident' `sizeorder' `sizeident' `edgesizeorder' `edgesizeident' `edgecolororder' `edgecolorident') `colorlabels' `symbollabels' `sizelabels' `edgesizelabels' `edgecolorlabels' `legendopt')"'
	}
	
	// Prepare scatter commands to plot nodes
	local scattercmd ""	
	local tempsize_rows = rowsof(nsizerow)
	// Size of nodes
	forvalues tempsiz_mat = 1/`tempsize_rows'{
		local tempsiz = nsizerow[`tempsiz_mat',1] 
		// Color of nodes
		forvalues i = 1/`ncols' {
			// Symbol of nodes
			forvalues j = 1/`symbs'{
				local tempcol = ncolorrow[`i', 1]
				local tempsymb = nsymbolrow[`j',1]
				_getcolorstyle, i(`tempcol') j(`tempsymb') colorpalette(`colorpalette') symbolpalette(`symbolpalette') scheme(`scheme')
				local tempsiz_node = `tempsiz' * `nodefactor' * 2
				local tempcolstyle_fill = r(col_fill)
				local tempcolstyle_line = r(col_line)
				local tempsymbol = r(symbol)	
				if "`label'" != "" {
					local scatterlabel "mlabel(nlabel)"
				}
				local scattercmd `"`scattercmd' (scatter ny nx if ncolor == `tempcol' & nsymbol == `tempsymb' & nsize == `tempsiz',  mlabcolor("scheme label") msymbol("`tempsymbol'") mlwidth(vthin) mlcolor(`tempcolstyle_line') mfcolor("`tempcolstyle_fill'") msize(`tempsiz_node') `scatterlabel' `scatteropt') ||"' 
			}
		}
	}
	
	// Prepare pc command to plot arcs/edges
	local pccmd "||"
	local pccmdforeground ""

	qui tab edgesize, matrow(valuerow)
	local tempvalue_rows = rowsof(valuerow)
	qui tab edgecolor, matrow(edgecolorrow)
	local tempecol_rows = rowsof(edgecolorrow)

	forvalues tempecol_mat = 1/`tempecol_rows'{
		local tempecol = edgecolorrow[`tempecol_mat',1]
		_getcolorstyle, i(`tempecol') edgecolorpalette(`edgecolorpalette') edgepatternpalette(`edgepatternpalette') scheme(`scheme')
		local temppattern = r(edgepattern)
		local tempcolstyle = r(edgecol)
		forvalues tempval_mat = 1/`tempvalue_rows'{
			local tempval = valuerow[`tempval_mat',1]			
			local tempval_line = (`tempval' / 2) * `edgefactor' / 2
			local tempval_arrow = (`tempval' + 1) * `arrowfactor' 
			local tempval_barb = `tempval_arrow' * `arrowbarbfactor'
			local pccmd `"`pccmd' (pcspike sy sx ey ex if value != 0 & edgesize == `tempval' & edgecolor == `tempecol', lpattern(`temppattern') lwidth(`tempval_line') lcolor("`tempcolstyle'") mfcolor("`tempcolstyle'") mcolor("`tempcolstyle'") msize(`tempval_arrow') barbsize(`tempval_barb') `lineopt') || (`pc' sy sx ey ex if value != 0 & edgesize == `tempval'  & edgecolor == `tempecol' & arrow == 1,  lpattern(`temppattern') lwidth(`tempval_line') lcolor("`tempcolstyle'") mfcolor("`tempcolstyle'") mcolor("`tempcolstyle'") msize(`tempval_arrow') barbsize(`tempval_barb') `lineopt') ||"'
		}
	}
	
	local pmargin = `nodefactor' * 3
	
	local graphcmd `"twoway `ghostcmd' `pccmd' `scattercmd' `pccmdforeground', ylabel(, nogrid) yscale(off range(0 100)) xscale(off range(0 150)) graphregion(color("scheme plotregion")) plotregion(color("scheme plotregion") margin(`pmargin' `pmargin' `pmargin' `pmargin')) aspectratio(`aspectratio') `legendcmd' `schemetwoway' `twowayopt'"' 

	di "{text:Plotting network...}"
	//di `"`graphcmd'"'
	`graphcmd'

	restore
	
	if "`generate'" != "" {
		di "{text:Export coordinates...}"
		if (wordcount("`generate'") >= 2){
			local generate_x = word("`generate'", 1)
			local generate_y = word("`generate'", 2)
		}
		else {
			local generate_x = "_x_coord"
			local generate_y = "_y_coord"
		}
		
		capture drop `generate_x'
		capture drop `generate_y'
		if _N < `nodes' {
			set obs `nodes'
		}
		qui gen `generate_x' = .
		qui gen `generate_y' = .
		mata: st_store((1::rows(Coord)),("`generate_x'","`generate_y'"), (Coord[.,.]:/100))
		qui replace `generate_x' = (`generate_x' - 0.05) / 0.9
		qui replace `generate_y' = (`generate_y' - 0.05) / 0.9
	}
	mata: mata drop plotmat nsize ncolor nlabel Coord edgesizemat edgecolormat
	capture mata: mata drop Coord_comp compM comp_freq comp_id comp_freqid compmat comp_share comp_nonisol
	capture mata: mata drop TC M nsymbol
	capture nwdrop __temp* 
	
	capture mat drop edgecolorrow
	capture mat drop valuerow
	capture mat drop nsymbolrow
	capture mat drop ncolorrow
	capture mat drop nsizerow
	capture mat drop nsymblrow
	capture mat drop colorkeysmap
	capture mata drop symbolkeysmap

	//qui nwload `masternetname', labelonly
end
	
capture program drop _getvaluelabel
program _getvaluelabel
	syntax varlist(min=1 max=1), key(string)
	
	qui labellist `varlist'
	local labkeys "`r(values)'"
	local lablabels `"`r(labels)'"'
	if ("`r(lblname)'"!= ""){
		local lnum = `r(`r(lblname)'_k)'
		local llab "`varlist' = `key'"
		forvalues j = 1 /`lnum' {
			local lkey : word `j' of `labkeys'
			if "`lkey'" == "`key'" {
				local llab : word `j' of `lablabels'
			}
		}
	}
	else{
		local llab "`varlist' = `key'"
	}
	mata: st_global("r(key_label)", "`llab'")
	mata: st_global("r(key)", "`key'")
end

capture program drop nwplotsplines
program nwplotsplines
	syntax, unbend(string) arrow(string) y1(string) x1(string) y2(string) x2(string) bend(string) splines(string) 

	tempvar l llid rad mult1 mult2 mult3 alpha beta x3n y3n x3 x4 y3 y4 xtemp ytemp r gamma delta lid alphaX
	gen `l' = sqrt((`x1' - `x2')^2 + (`y1' - `y2')^2)
	gen `rad' = `bend'* `l'

	gen `mult1' = 1 - 2 * (`x2' > `x1')
	replace `mult1' = 1 - 2 * (`y2' > `y1') if `x1' == `x2'
	gen `mult2' = 1 - 2 * (`y2' > `y1')
	replace `mult2' = 1 - 2 * (`x2' > `x1') if `y1' == `y2'

	gen `alpha' = (acos(abs(`x2' - `x1')/`l'))
	replace `alpha' = acos(1) if `alpha' == .
	gen `beta' = _pi / 2 + `alpha'

	gen `x3n' = (`x1' + 1/2 * (`x2' - `x1')) 
	gen `x3' = `x3n' + `mult1' * cos(`beta') * `rad'
	gen `y3n' = (`y1' + 1/2 * (`y2' - `y1'))  
	gen `y3' = `y3n' + `mult2' * sin(`beta') * `rad'

	gen `r' = sqrt(`rad'^2 + (1/2*`l')^2)	
	gen `mult3' = 2 * (`x3' > `x1') - 1
	gen `gamma' =  `beta' + `mult3' * acos(`rad'/`r') 
	gen `delta' =  `beta' - `mult3' * acos(`rad'/`r') 
	
	gen `lid'  = _n
	expand `splines' if `unbend' !=1
	bys `lid': gen `llid' = _n
	gen `alphaX' = `delta' + (`gamma' - `delta') * (`llid' - 1)/(`splines' -1)
	gen `x4' = `x3' + `mult1'* cos(`alphaX' + _pi) * `r'
	gen `y4' = `y3' + `mult2'*sin(`alphaX' + _pi) * `r' 

	replace `x2' = `x4' if `unbend' != 1
	replace `y2' = `y4' if `unbend' != 1
	replace `x1' = `x4'[_n-1] if `unbend' != 1
	replace `y1' = `y4'[_n-1] if `unbend' != 1
	drop if `llid' == 1 & `unbend'!=1
	replace `arrow' = (`llid' == `splines') if (`arrow' != 1) & (`mult1' == 1)
	replace `arrow' = 1 if (`llid' == 2) & (`mult1' == - 1)
	
	gen `xtemp' = `x1'
	gen `ytemp' = `y1'
	replace `x1' = `x2' if (`llid' == 2) & (`mult1' == - 1)
	replace `y1' = `y2' if (`llid' == 2) & (`mult1' == - 1)
	replace `x2' = `xtemp' if (`llid' == 2) & (`mult1' == - 1)
	replace `y2' = `ytemp' if (`llid' == 2) & (`mult1' == - 1)
end


capture mata: mata drop getTieCoordinates()
mata:
real matrix function getTieCoordinates(
	real matrix Coord, real matrix size, real matrix List, real matrix EColMat, real matrix ESizMat, real scalar sizefactor, real scalar doarrows, real scalar arrowgap)
{
	real matrix 	TC
	real scalar 	i, radius, x1, y1, x2, y2, x3, y3, An, Op, Hy, cos_theta, sin_theta
	
	radius = ((size):* sizefactor) :+ arrowgap
	Coord = Coord :*100
	Coord = (Coord :*0.9) :+ 5
	TC = J(rows(List),8,.)

	for(i=1;i<=rows(TC);i++){
		rad = radius[List[i,2],1] 
		if (doarrows==0) {
			rad = 0
		}
		TC[i,1] = Coord[List[i,1],1] //start x of tie i
		TC[i,2] = Coord[List[i,1],2] //start y of tie i
		TC[i,3] = Coord[List[i,2],1] //end x of tie i
		TC[i,4] = Coord[List[i,2],2] //end y of tie i
		TC[i,5] = List[i,3] //value of tie
		TC[i,6] = List[i,4]
		TC[i,7] = EColMat[List[i,1],List[i,2]]
		TC[i,8] = ESizMat[List[i,1],List[i,2]] 
		
		//adjust end point of arrow for node size
		x1 = TC[i,1]
		y1 = TC[i,2]
		x2 = TC[i,3]
		y2 = TC[i,4]
		An = y2 - y1
		Op = x2 - x1
		Hy = sqrt(An*An + Op*Op)
		cos_theta = Op / Hy
		sin_theta = An / Hy
		x3 = x2 - (cos_theta*rad)
		y3 = y2 - (sin_theta*rad)
		TC[i,3] = x3
		TC[i,4] = y3
	}
	return(TC)	
}	
end

capture mata: mata drop NumElist()
mata
real matrix NumElist(matrix onenet){
	nodes = rows(onenet)
	id = range(1,nodes,1)
	full = J(nodes, nodes, 1)
	c1=colshape(full:* id,1)
	c2=colshape(full:*(id'),1)
	value=colshape(onenet,1)
	c3 = value:/value
	_editmissing(c3,0)
	
	from = select(c1,c3)
	to = select(c2,c3)
	res = J(rows(from),4,0)
	res[.,1] = from
	res[.,2] = to
	res[.,3] = select(value, c3)
	
	for (i = 1; i <= rows(from); i++) {
		res[i,4] = onenet[res[i,1], res[i,2]] != 0 & onenet[res[i,2], res[i,1]] != 0
	} 
	return(res)
}
end

/*************************************
*	Obtain color for plotting
*************************************/
capture program drop _getcolorstyle
program def _getcolorstyle
	syntax [, i(string) j(string) colorpalette(string) symbolpalette(string) edgecolorpalette(string) edgepatternpalette(string) scheme(string)]

	mata: st_rclear()
	local i = `i' - 1
	local j = `j' - 1
	
	// symbol of node
	if ("`symbolpalette'" != ""){
		local symbolpalette_length : word count `symbolpalette'
		local k  = mod(`j', `symbolpalette_length') + 1
		local symbol : word `k' of `symbolpalette' 
	}
	else {
		local symbol `"scheme p`=`j'+1'"'
	}


	// pattern of edge
	if "`edgepatternpalette'" != "" {
		local edgepatternpalette_length : word count `edgepatternpalette'
		local m  = mod(`i', `edgepatternpalette_length') + 1
		local edgepattern : word `m' of `edgepatternpalette'
	}
	else {
		local edgepattern = "solid"
	}
	
	// color of edge
	if "`edgecolorpalette'" != "" {
		local edgecolorpalette_length : word count `edgecolorpalette'
		local j  = mod(`i', `edgecolorpalette_length') + 1
		local edgecol : word `j' of `edgecolorpalette' 
	}
	else {
		local edgecol `"scheme p`=`i'+1'line"'
		/*
		if (strpos("s1mono s2mono sj s1manual s2manual", "") != 0){
			local edgecol `"scheme p`=`i'+2'"'
		}*/
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

	mata: st_global("r(edgepattern)", "`edgepattern'")
	mata: st_global("r(edgecol)", "`edgecol'")
	mata: st_global("r(col_fill)", "`col_fill'")
	mata: st_global("r(col_line)", "`col_line'")
	mata: st_global("r(symbol)", "`symbol'")
end


/*************************************
*	Network layouts functions (Mata)
*************************************/

// Attempt to implement spring embedder... but sth does not work yet :-(
capture mata: mata drop fruchtreinlayout()
mata:
real matrix function fruchtreinlayout(real matrix M, real scalar Iter)
{
	real matrix Pos, Pos_up
	real scalar W, L, area, V, temperature, k ,v_pos ,e1_pos, e2_pos, delta
	
	W = 1
	L = 1
	area = W * L
	V = rows(M)
	Pos = runiform(V,2)
	F_repulsion = J(V,2,0)
	F_attraction = J(V,2,0)
	
	temperature = 1/10 * W	
	k = sqrt(area/V)
	
	temperature = 0
	
	for(i=1;i<= Iter;i++){
		// calculate repulsive force
		for(v=1;v<=V;v++){
			v_disp = J(1,2,0)
			for(u=1;u<=V;u++){
				if (v!=u) {
					delta = Pos[v,.] - Pos[u,.]
					v_disp = v_disp + (delta :/ abs(delta)) :* ((J(1,2,1):*(k,k)) :/ abs(delta))  
				}
			}

			F_repulsion[v,.] = v_disp
		}

		Pos_up = F_repulsion
		// calculate attractive force
		for(e1=1;e1<=V;e1++){
			for(e2=1;e2<=V;e2++){
				if (M[e1,e2]!=0){		
					delta = Pos[e1,.] - Pos[e2,.]
					//delta
					e1_pos = Pos_up[e1,.] - (delta :/abs(delta)) :* ( (abs(delta):* abs(delta)):/ k)
					e2_pos = Pos_up[e2,.] + (delta :/abs(delta)) :* ( (abs(delta):* abs(delta)):/ k)		
					Pos_up[e1,.] = e1_pos
					Pos_up[e2,.] = e2_pos
				
				}
			}
		}
		// limit displacement
		for (v=1;v<=V;v++){
			delta = Pos_up[v,.] - Pos[v,.]	
			Pos[v,1] = Pos[v,1] + (delta[1,1] / abs(delta[1,1])) * min((abs(delta[1,1]), temperature))
			Pos[v,2] = Pos[v,2] + (delta[1,2] / abs(delta[1,2])) * min((abs(delta[1,2]), temperature))
			
			
			Pos[v,1] = min(( W, max((- W, Pos[v,1]))))
			Pos[v,2] = min(( L, max(( - L, Pos[v,2]))))
			
		}
		
		// reduce temperature linerarly
		temperature = temperature - (1 / 3)*temperature
	}
	return(Pos)
}
end

capture mata: mata drop mmdslayout()
mata:
real matrix function mmdslayout(real matrix G)
{
	real matrix 	D, sCoord, Coord
	string scalar 	dMat, sMat
	real scalar ScaleFactor, rc 

	Coord  =  circlelayout(rows(G))
	if (rows(G) == 2) {
		Coord[1,1] = 0.5
		Coord[2,1] = 0.5
		Coord[1,2] = 0.75
		Coord[2,2] = 0.25
	}

	D = distance(G) //compute distances
	_diag(D,0)
	
	// correct for two nodes having the same distance scores to all others
	for (i = 1; i< rows(D); i++) {
		for (j = i;j<=rows(D); j++){
			thisrow = J(1,cols(D),1)
			thisrow[1,i] = 0
			thisrow[1,j] = 0
			diff = select(D[i,.],thisrow) - select(D[j,.],thisrow)
			if ((sum(abs(diff)) == 0) & (i != j)){
				D_i =  D[i,.] :* ((uniform(1,cols(D)):*0.5):+0.75)
				D[i,.] = D_i
				D[.,i] = D_i'
			}
		}
	}

	st_matrix("dMat",D) 	    //Distance mat to stata under tempname
	// compute MDS coordinates in stata
	rc = _stata( "  mdsmat dMat,  noplot method(classical)", 1)
				//" di `test_rc")
	if (rc == 0) {
		Coord = st_matrix("e(Y)") 
		CoordMin1 = min(Coord[.,1])
		CoordMin2 = min(Coord[.,2])
		Coord[.,1] = (Coord[.,1] :- CoordMin1)
		Coord[.,2] = (Coord[.,2] :- CoordMin2)
	
		CoordMax1 = max(Coord[.,1])
		CoordMax2 = max(Coord[.,2])
		Coord[.,1] = (((Coord[.,1] :/ CoordMax1))) 
		Coord[.,2] = (((Coord[.,2] :/ CoordMax2)))
	}
	return(Coord)
}
end

capture mata: mata drop netplotmds()
mata:
real matrix function netplotmds(real matrix G, real scalar MaxIt)
{
        real matrix     D, sCoord, Coord
        string scalar   dMat, sMat
        real scalar ScaleFactor, rc 
        
		G = (G + G') :/ (G + G')
		_editmissing(G, 0)
		_diag(G,0)
		
        Coord  =  J(rows(G),2,.)
        sCoord = jumble(circlelayout(rows(G))) //circle coordinates as starting positions for mds
	    maxSX = max(sCoord[,1])
		maxSY = max(sCoord[,2])
		
        D = distance(G) //compute distances
        _diag(D,0)
		
        st_matrix(dMat=st_tempname(),D)         //Distance mat to stata under tempname
        st_matrix(sMat=st_tempname(),sCoord)    //Distance mat to stata under tempname

        // compute MDS coordinates in stata
        rc = _stata(  "qui mdsmat " + 
                dMat + 
                ", noplot method(modern) initialize(from(" + 
                sMat + 
                ")) iterate("+strofreal(MaxIt)+")" )
        
        if (rc!=0) {
                errprintf("mds computation failed \n")
                exit(rc)
        }

        Coord = st_matrix("e(Y)")       //pull coordinates back into mata
        
        // rescale coordinates to fit inside circle layout
		
		nonisolates = (rowsum(G):!= 0)
		
		maxX = max(select(Coord[.,1], nonisolates))
		minX = min(select(Coord[.,1], nonisolates))
		maxY = max(select(Coord[.,2], nonisolates))
		minY = min(select(Coord[.,2], nonisolates))

		Coord[,1] = (nonisolates :*(Coord[,1]:-minX) :* (1 / (maxX-minX)) :+ 0.25) :+ ((nonisolates:==0) :* Coord[,1])
		Coord[,2] = (nonisolates :*(Coord[,2]:-minY) :* (1 / (maxY-minY))) :+ ((nonisolates:==0):*Coord[,2])
		
		num_isol = sum( nonisolates:==0)
		maxYY = max(Coord[,2])
		
		k = 1
		for ( i = 1; i <= rows(G); i++) {
			if (nonisolates[i] == 0) {
			   Coord[i,1]=1.5
			   Coord[i,2]= (k / num_isol)
			   k = k + 1
			}
		}
		
        return(Coord)
}
end


//Calculates the distance matrix in a discrete graph
//Distances between unconnecte nodes are indicated by "0"
capture mata: mata drop distance()
mata:
real matrix function distance(real matrix Net, | real scalar MaxDist)
{
	real scalar 	ready,counter, maxcounter
	real matrix 	N1,Dist,Ntemp
	
	if (args()==2) 
		maxcounter = MaxDist
	else 
		maxcounter = rows(Net)-1
	
	// Undirected network
	Net = (Net + Net') :/ (Net + Net')
	_editmissing(Net, 0)
	
	N1 = Net
	Dist = Net	//Distance 1 matrix
	counter = 1
	ready = 0
	while (ready==0 & counter<maxcounter) {
		counter = counter + 1
		N1=(N1*Net)
		Ntemp = (Dist:==0):*(N1:>0):*counter
		if (sum(Ntemp)==0) ready = 1
		Dist = Dist:+Ntemp
	}
	//Dist = (Dist:==0):* (runiform(rows(Dist), cols(Dist))) :+ Dist 
	maxdist = max(Dist)
	Dist = (Dist:==0):* (maxdist + 1) :+ Dist
	_diag(Dist, 0)
	return(Dist)
}
end

capture mata: mata drop circlelayout()
mata:
real matrix function circlelayout(real scalar N)
{
	real colvector 	V
	real matrix 	Coord
	real scalar 	xmax, ymax

	xmax = 100
	ymax = 100
	V= (1::N)
	Coord=J(N,2,.)

	Coord[.,1] = 0.5*xmax :+ 0.5:*xmax:*cos(V[.]:*(2*pi()/N))	
	Coord[.,2] = 0.5*ymax :+ 0.5:*ymax:*sin(V[.]:*(2*pi()/N))

	CoordMax1 = max(Coord[.,1])
	CoordMax2 = max(Coord[.,2])
	Coord[.,1] = (((Coord[.,1] :/ CoordMax1)))
	Coord[.,2] = (((Coord[.,2] :/ CoordMax2)))
	Coord[.,1] = Coord[.,1] :+0.25
	return(Coord)
}
end

capture mata: mata drop gridlayout()
mata:
real matrix function gridlayout(real scalar N,  real scalar cols)
{
	real colvector 	V, C
	real matrix 	Coord

	V= (1::N)
	rows = ceil(N / cols)
	
	Coord=J(N,2,.)
	Coord[.,1] = J(N,1,100) :- floor((V:-1) :/rows) :* (100 / (cols - 1))
	
	Coord[.,2] = mod(V, rows)
	Coord[.,2] = editvalue(Coord[.,2],0,rows)
    Coord[.,2] = J(N,1,100) :- ((Coord[.,2] :- 1) :* (100 / (rows - 1)))
	
	CoordMax1 = max(Coord[.,1])
	CoordMax2 = max(Coord[.,2])
	Coord[.,1] = (((Coord[.,1] :/ CoordMax1)))
	Coord[.,2] = (((Coord[.,2] :/ CoordMax2)))
	Coord[.,1] = Coord[.,1] * 1.5
	
	return(Coord)
}
end

