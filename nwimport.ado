capture program drop nwimport
program nwimport
	syntax anything, type(string) [ name(string) clear nwclear xvars *]
	local fname `"`anything'"'
	if strpos(`"`anything'"',`"""') == 0 {
		local fname  `""`fname'""'
	}
	
	local options_original `"`options'"'
	
	if "`name'" != "" {
		local nameoff = "false"
	}
	
	set more off
	qui `clear'
	qui `nwclear'
	
	if "`name'" == "" {
		local fname_temp =  lower(subinstr(`"`fname'"', char(34), "", .))
		local fnamerev = strreverse(`"`fname_temp'"')
		local bslash = strpos(`"`fnamerev'"', "/")
		local fslash = strpos(`"`fnamerev'"', "\")
		local slash = max(`bslash', `fslash')
		local slash = cond(`slash'== 0, length(`"`fnamerev'"'), `slash')
		local name = substr(`"`fname_temp'"', `=length(`"`fname_temp'"') - `slash' + 1', .)
		local name = subinstr(`"`name'"',".net", "", .)
		local name = subinstr(`"`name'"',".dat", "", .)
		local name = subinstr(`"`name'"',".txt", "", .)
		local name = subinstr(`"`name'"',".csv", "", .)
		local name = subinstr(`"`name'"',".dta", "", .)
		local name = subinstr(`"`name'"', char(34), "", .)
		local name = substr(`"`name'"', 2, .)
	}
	
	capture qui nwset
	local nets_before = r(networks)
		
	local 0 `type'
	syntax anything(name=import_type) [, *] 
	_opts_oneof "pajek matrix edgelist compressed gml graphml ucinet" "import_type" "`import_type'" 6556
	
	local options `"`options_original'"'

	if "`import_type'" == "matrix" {
		 capture _nwimport_matrix `fname', `options'
	}
	if "`import_type'" == "compressed" {
		 capture _nwimport_compressed `fname', `options'
	}
	if "`import_type'" == "edgelist" {
		 capture _nwimport_edgelist `fname', `options'
	}
	if "`import_type'" == "pajek" {
		 capture _nwimport_pajek `fname', `options'		 
	}
	if "`import_type'" == "gml" {
		capture _nwimport_gml `fname', `options'
	}
	if "`import_type'" == "graphml" {
		capture _nwimport_graphml `fname', `options'
	}
	if "`import_type'" == "ucinet" {
		  capture _nwimpdl `fname'
		  if "`nameoff'" == "" {
			local nameoff = r(nameoff)
		  }
	}
	local i = 1
	capture qui nwset
	local nets_now = `r(networks)'
	
	if `nets_now' > `nets_before'{
		forvalues j = `=`nets_before'+1'/`nets_now' {
			nwname, id(`j')
			local directed `r(directed)'	

			// check of network is undirected or not
			nwissymmetric `r(name)'
			if `r(issymmetric)' == 1 & "`directed'" == "true" {
				local newdirectedcmd "newdirected(false)"
			}
			if `r(issymmetric)' == 0 & "`directed'" == "false" {
				local newdirectedcmd "newdirected(true)"
			}
				
			local onename : word `i' of `name'
			if "`onename'" != ""  & "`nameoff'" != "true"{
				local newnamecmd "newname(`onename')"
			}
			nwname, id(`j') `newnamecmd' `newdirectedcmd'
			local i = `i' + 1
			qui if "`xvars'" == ""{
				nwload
			}
		}
		di "{hline 30}"
		di  "{txt}{it:Importing successful}"
		nwset
		//di "{txt}(`=`nets_now'-`nets_before'' networks loaded)"
		//di "{hline 30}"
		//di 
	}
	else {
		di 
		noi di `"{err}{it:Loading networks from file {bf:`fname'} failed}"'
		error 6750
	}
end
	
	
	

	
	
///////////////////////////
///////////////////////////

capture program drop _nwimport_pajek
program _nwimport_pajek
	version 9
	syntax [anything][, name(string) clear nwclear]

		`clear'
		`nwclear'
		set more off
		preserve
		drop _all
		
		tempfile dict
							
		file open importfile using `anything', read
		file read importfile line
	    while `"`line'"' != "" {
			// get first word
			local f_cmd : word 1 of `line'
			local f_cmd = lower("`f_cmd'")
			if lower("`f_cmd'") == "*vertices" {
				local size = word(`"`line'"',2)
				local mode = "vertices"
				set obs `size'
				gen _fromid = _n
				gen _toid = _n
				gen _value = 0
				file read importfile line
				local f_star = strpos(`"`line'"', "*")

				// parse node labels
				if `f_star' != 1 {
					tempname dict_handler

					local num_attributes : word count `line'
					local attributes "" 
					forvalues k = 3/`num_attributes'{
						local nextattrib : word `k' of `line'
						capture confirm number `nextattrib'
						if _rc == 0 {
							local attributes "`attributes' int __x`=`k'-2'" 
						}
						else {
							local attributes "`attributes' str30 __x`=`k'-2'" 
						}
					}
					
					postfile `dict_handler' _nodeid str30 _nodelab `attributes' using `dict'
					while (`f_star' != 1) {
						local tempid : word 1 of `line'
						local templab : word 2 of `line'
						
						local attributes_post ""
						forvalues l = 3/`num_attributes' {

							local tempx : word `l' of `line'
							capture confirm number `tempx'
							if _rc == 0 {
								local attributes_post `"`attributes_post' (`tempx')"'
							}
							else {
								local attributes_post `"`attributes_post' ("`tempx'")"'
							}
						}
						
						local templab = cond("`templab'" == "", "`tempid'", "`templab'")
						local templab = subinstr("`templab'", " ","_",.)
						
						post `dict_handler' (`tempid') ("`templab'") `attributes_post'

						file read importfile line
						local f_star = cond(`"`line'"'=="", 1, strpos(`"`line'"', "*"))	
					}
					postclose `dict_handler'
				}
				local f_cmd : word 1 of `line'
				if "`f_cmd'" == "" {
					local mode ""
				}
			}
			if lower("`f_cmd'") == "*edgeslist" {
				local mode = "edgeslist"
				local directed = "false"
				local nwfromedgeopt = "undirected"
				file read importfile line
				local f_cmd : word 1 of `line'
				local f_cmd = lower("`f_cmd'")
			}
			if lower("`f_cmd'") == "*arcslist" {
				local mode = "arcslist"
				local directed = "true"
				local nwfromedgeopt = "directed"
				file read importfile line
				local f_cmd : word 1 of `line'
				local f_cmd = lower("`f_cmd'")
			}
			if lower("`f_cmd'") == "*arcs" {
				local mode = "arcs"
				local directed = "true"
				local nwfromedgeopt = "directed"
				file read importfile line
				local f_cmd : word 1 of `line'
				local f_cmd = lower("`f_cmd'")
			}
			if lower("`f_cmd'") == "*edges" {
				local mode = "edges"
				local directed = "false"
				if "`nwfromedgeopt'" != "directed" {
					local nwfromedgeopt = "undirected"
				}
				file read importfile line
				local f_cmd : word 1 of `line'
				local f_cmd = lower("`f_cmd'")
			}
			if lower("`f_cmd'") == "*matrix" {
				local mode = "matrix"	
			}
			
			// read edges from edgelist
			if ("`mode'" == "arcs" | "`mode'" == "edges"){
				local newN = _N + 1
				set obs `newN'
				local ego = word("`line'", 1)
				local alter = word("`line'", 2)
				replace _fromid = `ego' in `newN'
				replace _toid = `alter' in `newN'
				if (wordcount("`line'") - 2) > 0 {
					local value = word("`line'", 3)
				}
				else {
					local value = 1
				}
				replace _value = `value' in `newN'
				
				if "`mode'" == "edges"{
					local newN = _N + 1
					set obs `newN'
					replace _fromid = `alter' in `newN'
					replace _toid = `ego' in `newN'
					replace _value = `value' in `newN'
				}
			}
			
			// read edges from compressed edgelist
			if ("`mode'" == "arcslist" | "`mode'" == "edgeslist"){
				local ego = word("`line'", 1)
				local next = 2
				local alter = word("`line'", `next')
				while "`alter'" != "" {
					local newN = _N + 1
					set obs `newN'
					replace _fromid = `ego' in `newN'
					replace _toid = `alter' in `newN'
					replace _value = 1 in `newN'
					if "`mode'" == "edgeslist" {
						local newN = _N + 1
						set obs `newN'
						replace _fromid = `alter' in `newN'
						replace _toid = `ego' in `newN'
						replace _value = 1 in `newN'
					}
					local next = `next' + 1
					local alter = word("`line'", `next') 
				}
			}
			// read edges from matrix
			if ("`mode'" == "matrix") {
				local id_ego : word `id_num' of `id'
				local id_num = `id_num' + 1
				local next = 1
				local value = word("`line'", `next') 
				while "`value'" != "" {
					local id_alter : word `next' of `id' 
					local next = `next' + 1
					if (`value' != 0 | (`id_alter' == `id_ego')){
						local newN = _N + 1
						set obs `newN'
						replace _fromid = `id_ego' in `newN'
						replace _toid = `id_alter' in `newN'
						replace _value = `value' in `newN'
					}
					local value = word("`line'", `next') 
				}	
			}
			
			file read importfile line
		}
		file close importfile

		nwfromedge _fromid _toid _value, xvars name(`name') labs(`labs') `nwfromedgeopt' 
		
		
		qui nwname
		local nodes = r(nodes)
		
		restore
		
		capture drop _nodeid
		capture drop _nodelab
		capture drop _xcoord
		capture drop _ycoord 
		
		if _N < `nodes' {
			set obs `nodes'
		}
	    gen _nodeid = _n if _n <= `nodes'
		merge m:n _nodeid using `dict', nogenerate
		qui nwname, newlabsfromvar(_nodelab)	
end


capture program drop _nwimport_ucinet
program _nwimport_ucinet
	version 9
	syntax [anything][, name(string) clear nwclear]

		`clear'
		`nwclear'
		set more off
		preserve
		drop _all
		gen _fromid = ""
		gen _toid = ""
		gen _value = .
		local labs ""
	
		file open importfile using `anything', read

		local mode ""
		file read importfile line
		local l = 0
		
		// read line
		local matrix_loaded = 0
		while `"`line'"' != "" & `matrix_loaded' == 0{
			local line = subinstr(`"`line'"', "="," = ",.)
			local first : word 1 of `line'
			
			if "`mode'" == "label" {
				
				local labs "`line'"
				local labs = subinstr("`line'",","," ",.)
				//local labs `""`labs'""'
				local mode = ""
			}
			if "`mode'" == "data" & "`data_format'" == "" {
				local data_format = "fullmatrix"
			}
			if "`mode'" == "data" & "`data_format'" == "edgelist1" {
				local second : word 2 of `line'
				local value : word 3 of `line'
				if "`value'" == "" {
					local value = 1
				}
				_insert_edge, from(`first') to(`second') value(`value')
			}
			if ("`mode'" == "data" &  strpos("fullmatrix edgelist1", "`data_format'") == 0) {
				noi di "{err}format {bf:`data_format'} not supported"
				error 6705
			}
			
			if "`mode'" == "data" & "`data_format'" == "fullmatrix" {
				local matrix_loaded = 1
				insheet using `anything', delimiter(" ")  clear
				drop if _n < `l'
				foreach v of varlist _all {
					destring `v', replace
				}
				if "`labs'" == "" {
					forvalues i = 1/`nodes' {
						local labs "`labs' `i'"
					}
				}
				local k 1 
				foreach var of varlist _all {
					rename `var' net`k'
					local k = `k' + 1
				}
				nwset  _all, name(`name') labs(`labs')
			}
			
			local dl_add = 0
			if (lower("`first'") == "dl") {
				local first : word 2 of `line'
				local dl_add = 1
			}	
			if (lower("`first'") == "n") {
				local num = 3 + `dl_add'
				local nodes : word `num' of `line'
				forvalues i = 1/`nodes' {
					_insert_edge, from("`i'") to("`i'") value(0) 
				}
			}	
			if lower("`first'") == "format" {
				local data_format : word 3 of `line'
				di "Format:`format'"
			}
			
			if lower("`line'") == "labels embedded:"{
				local mode = "label"
				drop if _n <= `nodes'
			}
			if lower("`line'") == "labels:"{
				local mode = "label"
				local uselabs = "true"
			}
			if lower("`line'") == "data:"{
				local mode = "data"
			}
			local l = `l' + 1
			
			// read next line
			file read importfile line
		}
		capture file close importfile
		
		if "`uselabs'" == "" {
			local labs ""
		}
		
		if `matrix_loaded' == 0  {
			qui nwfromedge _fromid _toid _value, name(`name') labs(`labs') `nwfromedgeopt'
		}
		restore
end


capture program drop _insert_edge
program _insert_edge
	syntax, from(string) to(string) value(string)
	
	if ("`from'" != "-1" & "`to'" != "-1"){
		local n = _N
		local newN = `n' + 1
		set obs `newN'
		replace _fromid = "`from'" in `newN'
		replace _toid = "`to'"  in `newN'
		replace _value = `value' in `newN'
	}
end	


capture program drop _nwimport_matrix
program _nwimport_matrix
	syntax anything, [name(string) delimiter(string) directed ] 
	if "`name'" == "" {
		local name "network"
	}
	
	clear
	preserve
	
	gettoken fname ending : anything, parse(".")

	local success = 0
	local excel = 0
	local pot_delimiters = `""tab" ";" "," " ""'
	local pot_delimiters_length : word count `pot_delimiters'
	local i = 1
	
	// Excel file detected
	if ((strpos("`ending'", "xls") != 0 ) | strpos("`ending'", "xlsx") != 0 ){
		local excel = 1
		import excel "`anything'", sheet("Sheet1") clear
	}
	else {	
		while (`excel' == 0 & "`delimiter'" == "" & `success' == 0 & `i' <= `pot_delimiters_length'){
			local use_delimiter : word `i' of `pot_delimiters'
			local i = `i' + 1
		
			if "`use_delimiter'" == "tab" {
				local insheet_opt = ", tab clear"
			}
			else {
				local insheet_opt = `", delimiter("`use_delimiter'") clear"'
			}
		
			insheet using `anything' `insheet_opt'
			if `c(k)' == 1 {
				split v1, parse(" ")
				drop v1
				foreach v of varlist _all {
					if `v'[1] == "" {
						noi di "`v'"
						drop `v'
					}
				}
				destring _all, replace
			}
			
			if (`c(k)' == 1){
				local success = 0
			}
			else {
				local success = 1
			}
		}
	}
	
	// Check for rownames and colnames
	ds
	local firstvar : word 1 of `r(varlist)'
	local secondvar : word 2 of `r(varlist)'
	local check1 = `firstvar'[2]
	capture confirm number `check1'
	if _rc != 0 {
		local rownames "true"
	}
	else {
		local rownames "false"
	}
	
	local check2 = `secondvar'[1]

	capture confirm number `check2'
	if _rc != 0 {
		local colnames "true"
	}
	else {
		local colnames "false"
	}
	
	if "`rownames'" == "true" {
		local labs ""
		forvalues i = 1/`=_N' {
			di "`firstvar'"
			local onelabel = `firstvar'[`i']
			if "`onelabel'" != "" {
				local labs "`labs' `onelabel'"
			}
		}
		drop `firstvar'
	}	
	if "`colnames'" == "true" {
		if"`labs'" == ""{
			foreach var of varlist _all {
				local onelabel = `var'[1]
				if "`onelabel'" != "" {
					local labs "`labs' `onelabel'"
				}
			}
		}
		drop if _n == 1
	}
	destring _all, force replace
	nwset _all, name("`name'") vars(_all) labs(`labs')
end


capture program drop _nwimport_gml
program _nwimport_gml
	version 9
	syntax [anything][, name(string) clear nwclear]

		`clear'
		`nwclear'
		set more off
		preserve
		drop _all
		gen _fromid = ""
		gen _toid = ""
		gen _value = .
		local labs ""
		
		file open importfile using `anything', read

		local mode ""
		file read importfile line
		// read line
		while `"`line'"' != "" {
			tokenize `"`line'"'
			local i = 1
			// read all elements
			while "``i''" != "" {
				if "``i''" == "id" & "`mode'" == "node" {
					local mode_sub = "node_id"
					local node = "``=`i'+1''"
					_insert_edge, from(`node') to(`node') value(0)
				}
				if "``i''" == "label" & "`mode'" == "node" {
					local mode_sub = "node_label"
					local nextlab `"``=`i'+1''"'
					local labs `"`labs' "`nextlab'""'
				}
				if "``i''" == "source" & "`mode'" == "edge" {
					local mode_sub = "edge_source"
					local source = "``=`i'+1''"
					_insert_edge, from(`source') to(`target') value(1)
				}
				if "``i''" == "target" & "`mode'" == "edge" {
					local mode_sub = "edge_target"
					local target = "``=`i'+1''"
					_insert_edge, from(`source') to(`target') value(1)
				}
				if "``i''" == "node" {
					local mode = "node"
				}
				if "``i''" == "edge" {
					local mode = "edge"
					local target = -1
					local source = -1
				}
				local i = `i' + 1
			}
			// read next line
			file read importfile line
		}	
		capture file close importfile
		nwfromedge _fromid _toid _value, name(`name') labs(`labs') `nwfromedgeopt'
		restore
end


capture program drop _nwimport_gefx
program _nwimport_gefx
	version 9
	syntax [anything][, name(string) clear nwclear]

		`clear'
		`nwclear'
		set more off
		preserve
		drop _all
		gen _fromid = ""
		gen _toid = ""
		gen _value = .
		local labs ""
		
		file open importfile using `anything', read

		local mode ""
		file read importfile line
		// read line
		while `"`line'"' != "" {
			local line = subinstr(`"`line'"', "="," = ",.)
			tokenize `"`line'"'
			local i = 1
			// read all elements
			while "``i''" != "" {
				if "``i''" == "id" & "`mode'" == "node" {
					local mode_sub = "node_id"
					local node = "``=`i'+2''"
					_insert_edge, from(`node') to(`node') value(0)
				}
				if "``i''" == "label" & "`mode'" == "node" {
					local mode_sub = "node_label"
					local nextlab ``=`i'+2''
					local labs "`labs' `nextlab'"
				}
				if "``i''" == "source" & "`mode'" == "edge" {
					local mode_sub = "edge_source"
					local source = ``=`i'+2''
					_insert_edge, from(`source') to(`target') value(1)
				}
				if "``i''" == "target" & "`mode'" == "edge" {
					local mode_sub = "edge_target"
					local target = ``=`i'+2''
					_insert_edge, from(`source') to(`target') value(1)
				}
				if "``i''" == "<node" {
					local mode = "node"
				}
				if "``i''" == "<edge" {
					local mode = "edge"
					local target = -1
					local source = -1
				}
				local i = `i' + 1
			}
			// read next line
			file read importfile line
		}
		capture file close importfile
		capture encode _fromid, gen(_fromidnum)
		if _rc != 0 {
			gen _fromidnum = _fromid
		}
		capture encode _toid, gen(_toidnum)
		if _rc != 0 {
			gen _toidnum = _toid
		}		
		nwfromedge _fromidnum _toidnum _value, name(`name') labs(`labs') `nwfromedgeopt'
		restore
end


capture program drop _nwimport_edgelist
program _nwimport_edgelist
	syntax anything, [name(string) delimiter(string) directed undirected xvars] 
	if "`name'" == "" {
		local name "network"
	}

	if (strpos(lower(`anything'), ".dta") != 0) | (strpos(lower(`anything'), ".DTA") != 0)  {
		preserve
		use `anything', clear
		ds
		local ego : word 1 of `r(varlist)'
		local alter : word 2 of `r(varlist)'
		local value : word 3 of `r(varlist)'
		replace `alter' = `ego' if `alter' == .
		drop if `ego' == .
		nwfromedge `ego' `alter' `value', `undirected' `direcetd' `xvars' name(`name')
		restore
	}
	else {
	
	preserve
	clear
	
	gettoken fname ending : anything, parse(".")

	local success = 0
	local excel = 0
	local pot_delimiters = `""tab" ";" "," " ""'
	local pot_delimiters_length : word count `pot_delimiters'
	local i = 1
	
	// Excel file detected
	if (strpos("`ending'", "xls") != 0 ){
		local excel = 1
		import excel "`anything'", sheet("Sheet1") clear
		if c(k) == 1 | _rc != 0 {
			local success = 0
		}
		else {
			local success = 1
		}
	}

	local i = 1
	while (`excel' == 0 & "`delimiter'" == "" & `success' == 0 & `i' <= `pot_delimiters_length'){
		local use_delimiter : word `i' of `pot_delimiters'
		local i = `i' + 1
		
		if "`use_delimiter'" == "tab" {
			local insheet_opt = ", tab clear"
		}
		else {
			local insheet_opt = `", delimiter("`use_delimiter'") clear"'
		}
		
		capture insheet using `anything' `insheet_opt'
		
		// Check for failure
		if c(k) == 1 | _rc != 0{
			local success = 0
			clear
		}
		else {
			local success = 1
		}
	}
	
	// Try other delimiters
    if ("`delimiter'" != ""){
		insheet using `"`anything'"', delimiter("`delimiter'") clear
		// Check for failure
		if c(k) == 1 | _rc != 0 {
			local success = 0
		}
		else {
			local success = 1
		}
	}
	
	if `success' == 0 {
		noi di "{err}{it:edgelist} could not be loaded"
		restore
		error 6704
	}

	if `c(k)' > 3 | `c(k)' < 2 {
		noi di "{err}Something went wrong; data has more than three columns."
		restore
		error 6704
	}
	nwfromedge _all, name(`name') `directed' `undirected' `xvars'
	restore
	}
end


capture program drop _nwimport_compressed
program _nwimport_compressed
	syntax anything, [name(string) delimiter(string) directed undirected xvars] 
	if "`name'" == "" {
		local name "network"
	}
	if "`delimiter'" == "" {
		local delimiter = "comma"
	}
	
	preserve
	clear

	import delimited `anything', delimiter(`delimiter') varnames(noname) clear
	rename v1 ego
	
	reshape long v, i(ego) j(j)
	rename v alter

	// needed to deal with isolates
	replace alter = ego if alter == ""
	nwfromedge ego alter, `directed' `undirected' `xvars' name(`name')
	//restore
	if "`xvars'" == "" {
		nwload
	}
end



capture program drop _nwimpdl_nodelist1
program _nwimpdl_nodelist1
	syntax, filehandler(string) nodes(int) [undirected directed rankedlist edgelist netlabs(string) labs(string) labelsembedded collabsembedded rowlabsembedded]

	preserve
	clear
	
	set obs `nodes'
	gen _fromid = ""
	gen _toid = ""
	gen _value = .
	
	if "`labelsembedded'" != "" {
		foreach onenode in `labs' {
			local onenode = lower("`onenode'")
			_insert_edge, from("`onenode'") to("`onenode'") value(0)
		}
	}
	else {
		forvalues i = 1/`nodes' {
			_insert_edge, from("`i'") to("`i'") value(0)
		}
	}
	
	local r = 0
	file read `filehandler' line
	
	if "`collabsembedded'" != "" {
		local labs "`line'"
		file read `filehandler' line
	}	
	if "`rowlabsembedded'" != "" {
		local r = 1
	}	
	
	local lc : word count `labs'
	local labscomplete = cond(`lc' == `nodes', "true", "")

	while r(eof)==0 {	
		if "`rowlabsembedded'" != "" & "`labscomplete'" == "" {
			local onelab : word 1 of `line'
			labs "`labs' `onelab'"
		}
		local wc : word count `line'
		local sender : word `=1 + `r'' of `line'
		local sender = lower("`sender'")
		if "`edgelist'" != "" {
			local wc = `=2+`r''
		}
		
		forvalues i = `=2+`r''/ `wc' {
			local receiver : word `i' of `line'
			local receiver = lower("`receiver'")
			if "`rankedlist'" == "" {
				local value 1
			}
			else{
				local value = `i' - `=2+`r'' + 1
			}
			if "`edgelist'" != "" {
				local value1 :  word `=`i'+1' of `line'
				capture confirm number `value1'
				if _rc == 0 {
					local value `value1'
				}
			}
			capture _insert_edge, from("`sender'") to("`receiver'") value(`value')
		}
		file read `filehandler' line
	}
	file close `filehandler'
	capture drop if _fromid == .
	capture drop if _fromid == ""
	nwfromedge _all, name(`netlabs') labs(`labs') `directed' `undirected' `xvars'
	restore
end



capture program drop _nwimpdl_fullmatrix
program _nwimpdl_fullmatrix
	syntax, filehandler(string) nodes(int) nets(int) [directed netlabs(string) labs(string)  diagonal(string) rowlabsembedded collabsembedded]

	mata: onenet = J(`nodes', `nodes', 0)
	
	file read `filehandler' line	
	local lc = 1
	local x = 1
	local y = 0
	local twc = 0
	local netcounter 1
	
	if "`collabsembedded'" != "" {
		local labs "`line'"
		file read `filehandler' line
	}	
		
	while r(eof)==0 {
		
		local wc : word count `line'
		
		local nc = `nodes'
		if "`diagonal'" == "absent" {
			local nc = `nc' - 1
		}
		if "`rowlabsembedded'" != "" {
			local nc = `nc' + 1
		}
		
		forvalues i = 1/ `wc' {
			local ncc = `nc' * `nodes'
			local oneword : word `i' of `line'
			local twc = `twc' + 1
			
			if mod(`twc', `nc') == 1  & "`rowlabsembedded'" != "" {
				local newlabs "`newlabs' ``oneword'" 
			}	
			else {
				local y = `y' + 1 
				if `y' > `nodes' {
					local y = 1
					local x = `x' + 1
				}
				if "`oneword'" != "0" {
					mata: onenet[`x', `y'] = `oneword'
				}
				// one network complete
				if `y' == `nodes' & `x' == `nodes' {
					local onename : word `netcounter' of `netlabs'
					mata: st_numscalar("r(issymmetric)", issymmetric(onenet))
					local symmetric = `r(issymmetric)'
					nwset, name(`onename') labs(`labs') mat(onenet) 
					if "`symmetric'" == "1" & "`directed'" == "" {
						nwsym `onename'
					}
					
					mata: onenet = J(`nodes', `nodes', 0)
					local x = 1
					local y = 0
					local netcounter = `netcounter' + 1
				}
			}
		}	
		file read `filehandler' line
	}
	file close `filehandler'
end


capture program drop _nwimpdl_lowerhalf
program _nwimpdl_lowerhalf
	syntax, filehandler(string) nodes(int) nets(int) [ directed netlabs(string) labs(string)  diagonal(string) rowlabsembedded collabsembedded]

	mata: onenet = J(`nodes', `nodes', 0)
	
	file read `filehandler' line	
	local lc = 1
	local twc = 0
	local netcounter 1
	local y = 1
	local x = 0
	local ab = 0
	
	if "`collabsembedded'" != "" {
		local labs "`line'"
		file read `filehandler' line
	}	
	
	if "`diagonal'" == "absent" {
		local ab = 1
		local y = 2
	}
		
	while r(eof)==0 {		
		local wc : word count `line'
		forvalues i = 1/ `wc' {
			local twc = `twc' + 1
	
			if `x' >= `y'-`ab' {
				local x = 1
				local y = `y' + 1
			}
			else {
				local x = `x' + 1
			}
			

			local oneword : word `i' of `line'
			
			di "x:`x'  y:`y'  v:`oneword'"
						
			mata: onenet[`x',`y'] = `oneword'
			mata: onenet[`y',`x'] = `oneword'
		
			if (`y' == `nodes' & `x' == `nodes' - `ab') {
				local onename : word `netcounter' of `netlabs'
				nwset, name(`onename') labs(`labs') mat(onenet) 
				mata: onenet = J(`nodes', `nodes', 0)
				local x = 0
				local y = 0 + `ab'
				local netcounter = `netcounter' + 1
			}
		}	
		file read `filehandler' line
	}
	file close `filehandler'
end

capture program drop _nwimpdl
program _nwimpdl 
	syntax anything, [ netlistonly ]

	local nodes = ""
	local nets = "1"
	local cols = ""
	local rows = ""
	local format = "fullmatrix"
	local diagonal = ""
	local labels_on = 0
	local labs ""
	local netlabels_on = 0
	local netlabs ""
	local data_on = 0
	local rowlab_embedded ""
	local collab_embedded ""
	local labels_embedded ""
	
	local diagonal = ""
	tempname importfile
	
	// parse header of .dl file
	file open `importfile' using `anything', read
	
	file read `importfile' line
	local firstword : word 1 of `line'
	local firstword = trim(lower("`firstword'"))

	// check for .dl format
	if "`firstword'" != "dl" {
		noi di "{err}No valid {bf:.dl} file"
		error 6099
	}
	
	set more off
	// parse header until data part
	while  ("`firstword'" != "data:") {
		local line : subinstr local line "=" " ", all
		local line : subinstr local line "," " ", all
		local line : subinstr local line ";" " ", all
		
		// parse word by word
		local lc : word count `line'
		forvalues i = 1/ `lc' {
			local oneword : word `i' of `line'
			
			local keywords = "level matrix n nm nr nc format data: labels: diagonal"
			local oneword_low = lower("`oneword'")
			local key : list oneword_low  & keywords
			
			if `labels_on' == 1 & `netlabels_on' == 0 & "`key'" == "" {
				local labs "`labs' `oneword'"
			}
			else {
				local labels_on = 0
			}
			if `netlabels_on' == 1 & "`key'" == "" {
				local netlabs "`netlabs' `oneword'"
			}
			else {
				//local netlabels_on = 0
			}
			
			if (lower("`oneword'") == "n"){
				local nodes : word `=`i' + 1' of `line'
			}
		
			if (lower("`oneword'") == "nm") {
				local nets : word `=`i' + 1' of `line'
			}
			if (lower("`oneword'") == "nr") {
				local rows : word `=`i' + 1' of `line'
			}
			if (lower("`oneword'") == "nc") {
				local cols : word `=`i' + 1' of `line'
			}
			if (lower("`oneword'") == "format") {
				local format : word `=`i' + 1' of `line'
				local format = lower("`format'")
			}
			if (lower("`oneword'") == "diagonal") {
				local diagonal : word `=`i' + 1' of `line'
				local diagonal = lower("`diagonal'")
			}	
			
			if (lower("`oneword'") == "labels:") {
				if `netlabels_on' == 0 {
					local labels_on = 1
				}	
			}
			if (lower("`oneword'") == "labels"){
				local secondword : word `=`i' + 1' of `line'
				if (lower("`secondword'") == "embedded"){
					local labels_embedded "labelsembedded"
				}
			}
			
			if (lower("`oneword'") == "matrix" | lower("`oneword'") == "level") {
				local secondword : word `=`i' + 1' of `line'
				if (lower("`secondword'") == "labels:"){
					local labels_on = 0
					local netlabels_on = 1	
					local nameoff = "true"
				}
			}
			if (lower("`oneword'") == "row" | lower("`oneword'") == "col") {
				local secondword : word `=`i' + 1' of `line'
				if (lower("`secondword'") == "labels"){
					local thirdword : word `=`i' + 2' of `line'
					if (lower("`thirdword'") == "embedded"){
						if (lower("`oneword'") == "row")  {
							local rowlab_embedded = "rowlabsembedded"
						}
						if (lower("`oneword'") == "col")  {
							local collab_embedded = "collabsembedded"
						}
					}
				}
			}
		}
		file read `importfile' line
		local firstword : word 1 of `line'
		local firstword = lower("`firstword'")
	}

	if "`rows'" != "`cols'" {
		noi di "{err}Two-mode networks are not supported"
		error 6088
	}
	
	local labscount : word count `labs'
	if `labscount' > `nodes' {
		local newlabs ""
		forvalues i = 1/`nodes' {
			local onelab : word `i' of `labs'
			local newlabs "`newlabs' `onelab'"
		}
		local labs `newlabs'
	}
	
	local format = lower("`format'")
	
	if "`netlistonly'" == "" {
		if lower("`format'") == "fullmatrix" {
			capture _nwimpdl_fullmatrix, filehandler(`importfile') labs(`labs') netlabs(`netlabs') nodes(`nodes') nets(`nets') diagonal(`diagonal') `rowlab_embedded' `collab_embedded'
		}
		if lower("`format'") == "nodelist1" {
			qui  capture _nwimpdl_nodelist1, filehandler(`importfile') labs(`labs') netlabs(`netlabs') nodes(`nodes') `labels_embedded' `rowlab_embedded' `collab_embedded'
		}
		if lower("`format'") == "rankedlist1" {
			qui capture  _nwimpdl_nodelist1, rankedlist filehandler(`importfile') labs(`labs') netlabs(`netlabs') nodes(`nodes') `labels_embedded' `rowlab_embedded' `collab_embedded'
		}
		if lower("`format'") == "edgelist1" {
			qui capture _nwimpdl_nodelist1, edgelist filehandler(`importfile') labs(`labs') netlabs(`netlabs') nodes(`nodes') `labels_embedded' `rowlab_embedded' `collab_embedded'
		}
		if lower("`format'") == "lowerhalf" {
			if "`rowlabsembedded'" != "" {
				noi di "{err}Ucinet {bf:row labels embedded} not supported together with format {bf:lowerhalf}"
			}
			else {
				capture _nwimpdl_lowerhalf, filehandler(`importfile') labs(`labs') netlabs(`netlabs') nodes(`nodes') nets(`nets') diagonal(`diagonal') `rowlab_embedded' `collab_embedded'
			}
		}
	}
	mata: st_global("r(netlabs)", "`netlabs'")
	
	capture file close `importfile'
	local sformat "fullmatrix nodelist1 edgelist1 lowerhalf"
	local f : list format & sformat
			
	if "`f'" == "" {
		noi di "{err}Ucinet format = {bf:`format'} not supported."
	}	
	mata: st_global("r(nameoff)","`nameoff'")
end

	
	






	
