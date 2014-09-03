*! Date        : 3sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwtable
program nwtable
	syntax anything(name=something) [, unvalued plot plotoptions(string) *]
		
	if "`plot'" != "" {
		capture which tabplot
		if _rc != 0 {
			ssc install tabplot
		}
	}
	local num : word count `something'
		if (`num' > 2 | `num' == 0){
		di "{err}wrong number of arguments"
		err 6055
	}

	local pos = `num' - 1
	local arg1 = word("`something'", `pos') 
	_nwsyntax `arg1'
	local netname1 = "`netname'"
	local directed1 = "`directed'"
	local undirected_all = ("`directed'" == "false")
	local nodes1 = "`nodes'"
	
	nwname `netname1'
	local edgelabs1 `r(edgelabs)'
	
	local arg2 = word("`something'", `num')
	capture confirm variable `arg2'
	if _rc == 0 {
		local nwtabletype = "variable"
	}
	else {	
		_nwsyntax `arg2'
		local netname2 = "`netname'"
		local directed2 = "`directed'"
		local nwtabletype = "network"
		if "`directed2'" == "true" {
			local undirected_all = "false"
		}
		nwname `netname2'
		local edgelabs2 `r(edgelabs)'
	}	
	
	preserve
	if "`nwtabletype'" == "variable" {
		qui nwtoedge `netname1', fromvars(`arg2') tovars(`arg2') type(full)
		qui keep if `netname1' > 0 
		local tabn1 = "from_`arg2'"
		local tabn2 = "to_`arg2'"
		di
		local ident = max(length("`netname1'"), length("`arg2'")) + 20
		di "{txt}   Network:  {res}`netname1'{txt}{col `ident'}Directed: {res}`directed1'{txt}"
		di "{txt}   Attribute:  {res}`arg2'{txt}"
	}
	if "`nwtabletype'" == "network" {
		if "`undirected_all'" == "false" {
			local undirected = "forcedirected"
		}
		qui nwtoedge `netname1' `netname2', type(full) `undirected'
	
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
	}
	
	di 
	local stubw = length("`tabn1'") + 4	
	capture label def elab1 `edgelabs1'
	capture label def elab2 `edgelabs2'
	
	capture label val `tabn1' elab1
	capture label val `tabn2' elab2
	
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
		tabplot `tabn1' `tabn2', title(`netname1') horizontal plotregion(margin(b = 0)) `plotoptions'
	}
	
	mata: table = st_matrix("tableres")
	mata: col = st_matrix("tablecol")
	mata: row = st_matrix("tablerow")
	
	mata: st_matrix("r(table)", table)
	mata: st_matrix("r(col)", col)
	mata: st_matrix("r(row)", row)
	mata: st_global("r(tab1)", "`netname1'")
	mata: st_global("r(tab2)", "`arg2'")
	mata: st_global("r(directed)","`bothdirected'")
	
	mata: mata drop table col row
	restore
end
