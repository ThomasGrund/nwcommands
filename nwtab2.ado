*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwtab2
program nwtab2
	syntax anything(name=something) [, unvalued plot plotoptions(string) *]
		
	if "" != "" {
		capture which tabplot
		if _rc != 0 {
			ssc install tabplot
		}
	}
	local num : word count 
		if ( > 2 |  == 0){
		di "{err}wrong number of arguments"
		err 6055
	}

	local pos =  - 1
	local arg1 = word("", ) 
	_nwsyntax 
	local netname1 = ""
	local directed1 = ""
	local undirected_all = ("" == "false")
	local nodes1 = ""
	
	qui nwname 
	local edgelabs1 
	local arg2 = word("", )
	
	capture confirm variable 
	if _rc == 0 {
		local nwtabletype = "variable"
	}
	else {	
		_nwsyntax 
		local netname2 = ""
		local directed2 = ""
		local nwtabletype = "network"
		if "" == "true" {
			local undirected_all = 0
		}
		qui nwname 
		local edgelabs2 
	}	
	
	if  == 1 {
		local undirected = "forcedirected"
	}
	
	preserve
	if "" == "variable" {
		local attrlab : value label 
		qui nwtoedge , fromvars() tovars() type(full) 
		qui keep if  > 0 
		local tabn1 = "from_"
		local tabn2 = "to_"
		capture label val  
		capture label val  
		
		di
		local ident = max(length(""), length("")) + 20
		di "{txt}   Network:  {res}{txt}{col }Directed: {res}{txt}"
		di "{txt}   Attribute:  {res}{txt}"
		
		if "" != "" {
			di
			di"{txt}       The network is undirected."
			di"{txt}       The table shows two entries for each edge."
		}
	}
	if "" == "network" {
		qui nwtoedge  , type(full) 
	
		local tabn1 = ""
		local tabn2 = ""
		local bothdirected = "true"
		if ("" == "false" & "" == "false") {
			local bothdirected = "false"
		}
		di 
		local ident = max(length(""), length("")) + 20
		di "{txt}   Network 1:  {res}{txt}{col }Directed: {res}{txt}"
		di "{txt}   Network 2:  {res}{txt}{col }Directed: {res}{txt}"
		local stubw = length("") + 4	
		capture label def elab1 
		capture label def elab2 
	
		capture label val  elab1
		capture label val  elab2
	}
	
	di 
	
	capture { 
		tab   , matcell(tableres) matcol(tablecol) matrow(tablerow) 
	}
	if (_rc == 0) {
		tab   if _fromid != _toid, matcell(tableres) matcol(tablecol) matrow(tablerow)  missing
	}
	if (_rc == 198){
		di 
		rename  _string
		encode _string, gen()
		rename  _string
		encode _string, gen()
		tab   if _fromid != _toid, matcell(tableres) matcol(tablecol) matrow(tablerow)  missing
	}
	local tab_r = r(r)
	local tab_c = r(c)
	if "" != "" {
		tabplot  , title() horizontal plotregion(margin(b = 0)) 
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
	mata: st_global("r(tab1)", "")
	mata: st_global("r(tab2)", "")
	mata: st_global("r(directed)","")
	di
	di "{txt}   E-I Index: {res}"
	mata: mata drop table col row
	mata: mata drop External
	mata: mata drop Internal
	mata: mata drop EI_index
	restore
end
