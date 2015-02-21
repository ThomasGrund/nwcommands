capture program drop nwtabulate
program nwtabulate
	syntax [anything(name=something)] [, twoway  *]
	capture _nwsyntax `something'
	if _rc == 0 & "`twoway'" == "" {
		nwtab1 `something', `options'
	}
	else {
		nwtab2 `something', `options'
	}
end

capture program drop nwtab1
program nwtab1
	
	syntax [anything] , [selfloop *]
	_nwsyntax `anything'
	
	preserve
	nwname `netname'
	if "`r(directed)'" == "false" {
		local undirected = "undirected"
	}
	local edgelabs `r(edgelabs)'
	
	qui nwtoedge `netname', full
	qui if "`selfloop'" == "" {
		drop if _fromid == _toid 
	}
	local ident = length("`netname'") + 20
	di
	di "{txt}   Network:  {res}`netname'{txt}{col `ident'}Directed: {res}`directed'{txt}"
	capture label def elab `edgelabs'
	capture label val `netname' elab
	tab `netname', `options'
	restore
end


capture program drop nwtab2
program nwtab2
	syntax anything(name=something) [, unvalued plot plotoptions(string) *]
		
	if "`plot'" != "" {
		capture which tabplot
		if _rc != 0 {
			ssc install tabplot
		}
	}
	
	capture _nwsyntax `something', max(9999) name(something)
	// two networks
	if _rc == 0 {
		local nwtabletype = "network"
		local netname1 : word 1 of `something'
		local directed1 = "`directed'"
		local undirected_all = ("`directed'" == "false")
		local nodes1 = "`nodes'"
		qui nwname `netname1'
		local edgelabs1 `r(edgelabs)'
	
		local num : word count `something'
		if `num' < 2 {
			nwcurrent
			local netname2 = r(current)
		}
		else {
			local netname2 : word 2 of `something'
		}
		_nwsyntax `netname2'
		local netname2 = "`netname'"
		local directed2 = "`directed'"
		if "`directed2'" == "true" {
			local undirected_all = 0
		}
		qui nwname `netname2'
		local edgelabs2 `r(edgelabs)'
		
		if `undirected_all' == 1 {
			local undirected = "forcedirected"
		}
	}
	// check for network and variable
	
	else {
		local nwtabletype = "variable"
		foreach entry in `something' {
			capture _nwsyntax `entry'
			if _rc == 0 {
				local netname1 = "`netname'"
			}
			else {
				unab entry : `entry'
			}
			capture confirm variable `entry'
			if _rc == 0 {
				local attribute1 = "`entry'"
			}
			if "`netname1'" == "" {
				nwcurrent
				local netname1 = r(current)
			}
			nwname `netname1'
			local directed1 = "`directed'"
			local undirected = "" 
			if ("`directed'" == "false") {
				local undirected = "forcedirected"
			}
			local nodes1 = "`nodes'"
		}
	}
	
	preserve
	if "`nwtabletype'" == "variable" {
		local attrlab : value label `attribute1'
		qui nwtoedge `netname1', fromvars(`attribute1') tovars(`attribute1') full `undirected'
		qui keep if `netname1' > 0 
		local tabn1 = "from_`attribute1'"
		local tabn2 = "to_`attribute1'"
		capture label val `tabn1' `attrlab'
		capture label val `tabn2' `attrlab'
		
		di
		local ident = max(length("`netname1'"), length("`attribute1'")) + 20
		di "{txt}   Network:  {res}`netname1'{txt}{col `ident'}Directed: {res}`directed1'{txt}"
		di "{txt}   Attribute:  {res}`attribute1'{txt}"
		
		if "`undirected'" != "" {
			//qui keep if _fromid <= _toid
			di
			di"{txt}       The network is undirected."
			di"{txt}       The table shows two entries for each edge."
		}
	}
	if "`nwtabletype'" == "network" {
		qui nwtoedge `netname1' `netname2', full `undirected'
	
		local tabn1 = "`netname1'"
		local tabn2 = "`netname2'"
		local bothdirected = "true"
		if ("`directed1'" == "false" & "`directed2'" == "false") {
			local bothdirected = "false"
		}
		di 
		local ident = max(length("`netname1'"), length("`netname2'")) + 20
		di "{txt}   Network 1:  {res}`netname1'{txt}{col `ident'}Directed: {res}`directed1'{txt}"
		di "{txt}   Network 2:  {res}`netname2'{txt}{col `ident'}Directed: {res}`directed2'{txt}"
		
		if "`undirected'" != "" {
			qui keep if _fromid <= _toid
		}
		local stubw = length("`tabn1'") + 4	
		capture label def elab1 `edgelabs1'
		capture label def elab2 `edgelabs2'
	
		capture label val `tabn1' elab1
		capture label val `tabn2' elab2
	}
	
	di 
	
	capture { 
		tab `tabn1' `tabn2' , matcell(tableres) matcol(tablecol) matrow(tablerow) `options'
	}
	if (_rc == 0) {
		tab `tabn1' `tabn2' if _fromid != _toid, matcell(tableres) matcol(tablecol) matrow(tablerow) `options' missing
	}
	if (_rc == 198){
		di 
		rename `tabn1' `tabn1'_string
		encode `tabn1'_string, gen(`tabn1')
		rename `tabn2' `tabn2'_string
		encode `tabn2'_string, gen(`tabn2')
		tab `tabn1' `tabn2' if _fromid != _toid, matcell(tableres) matcol(tablecol) matrow(tablerow) `options' missing
	}
	local tab_r = r(r)
	local tab_c = r(c)
	if "`plot'" != "" {
		tabplot `tabn1' `tabn2', horizontal plotregion(margin(b = 0)) `plotoptions'
	}
	
	mata: table = st_matrix("tableres")
	mata: col = st_matrix("tablecol")
	mata: row = st_matrix("tablerow")
	mata: Internal = sum(diagonal(table))
	mata: External = sum(table) - Internal
	mata: EI_index = (External - Internal) / (External + Internal)
	
	mata: st_numscalar("r(EI_index)", EI_index)
	mata: st_matrix("r(table)", table)
	mata: st_matrix("r(col)", col)
	mata: st_matrix("r(row)", row)
	mata: st_global("r(tab1)", "`netname1'")
	mata: st_global("r(tab2)", "`arg2'")
	mata: st_global("r(directed)","`bothdirected'")
	di
	di "{txt}   E-I Index: {res}`r(EI_index)'"
	mata: mata drop table col row
	mata: mata drop External
	mata: mata drop Internal
	mata: mata drop EI_index
	restore
end

