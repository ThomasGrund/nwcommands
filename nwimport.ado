capture program drop nwimport
program nwimport
	syntax anything, [type(string) name(string) clear nwclear]
	local fname `"`anything'"'
	
	`clear'
	`nwclear'
	
	capture qui nwset
	local nets_before = r(networks)
		
	// Type is given explicitly
	if "`type'" != "" {
		local 0 `type'
		syntax anything(name=import_type) [, *] 
		_opts_oneof "pajek matrix edgelist gml graphml ucinet" "import_type" "`import_type'" 6556
	
		if "`import_type'" == "matrix" {
			capture _nwimport_matrix `fname', `options'
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
			capture _nwimport_ucinet `fname', `options'
		}
	}
	
	// No type is given; try to find it out
	else {
		gettoken filename ending : fname , parse(".")
		if "`ending'" == ".xls" | "`ending'" == ".xlsx" | "`ending'" == ".txt" {
			capture _nwimport_edgelist `fname'
			if _rc != 0 {
				capture _nwimport_matrix `fname'
				if _rc != 0 {
					capture _nwimport_matrix `fname', colnames
				}
			}
		}
		if "`ending'" == ".net" {
			capture _nwimport_pajek `fname'
		}
		if "`ending'" == ".dl" {
			capture _nwimport_ucinet `fname'
		}
		if "`ending'" == ".gml" {
			capture _nwimport_gml `fname'
		}
		if "`ending'" == ".gfx" {
			capture _nwimport_gefx `fname'
		}
		
		capture _opts_oneof ".net .dl .txt .xls .xlsx .gml .gfx" "ending" "`ending'" 6556
		if _rc != 0 {
			di "{err}file format of {bf:`fname'} could not be detected automatically; use {it:option} {bf:type()} instead."
		}
	
	}
	qui nwset
	if r(networks) > `nets_before'{
		di 
		di "{txt}{it:Loading successfull}"
		nwsummary
	}
	else {
		di 
		di "{err}{it:Loading network from file {bf:`fname'} failed}"
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
		
		local anything = subinstr(`"`anything'"',".net","",.)
		
		file open importfile using `anything'.net, read

		file read importfile line
		qui while `"`line'"' != "" {
			// get first word
			local f : word 1 of `line'
			local f_star = strpos(`"`line'"', "*")
			// new * command
			if `f_star' == 1 {
				local f_cmd = substr(`"`line'"', 2,.)
				local f_cmd : word 1 of `f_cmd'
				local f_cmd = lower("`f_cmd'")
				if lower("`f_cmd'") == "vertices" {
					local size = word("`f_cmd'",2)
					local mode = "vertices"
					gen _fromid = .
					gen _toid = .
					gen _value = .
					local labs ""
					local id ""
					local id_num 1
				}
				if lower("`f_cmd'") == "arcs" {
					local mode = "arcs"
					local directed = "true"
					local nwfromedgeopt = "directed"
				}
				if lower("`f_cmd'") == "edges" {
					local mode = "edges"
					local directed = "false"
					if "`nwfromedgeopt'" != "directed" {
						local nwfromedgeopt = "undirected"
					}
				}
				if lower("`f_cmd'") == "matrix" {
					local mode = "matrix"
				}		
			}
			// interpret last * cmd
			else {
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
				
				// generate entries for potential isolates
				if ("`mode'" == "vertices"){
					local newN = _N + 1
					set obs `newN'
					capture confirm _fromid _toid _value
					if _rc != 0 {
						capture gen _fromid = .
						capture gen _toid = .
						capture gen _value = .
					}
					
					local ego = word("`line'", 1)
					local ego_lab = word(`"`line'"', 2)
					if `"`ego_lab'"' != ""{
						local labs `"`labs' `ego_lab'"'
					}
					local id "`id' `ego'"
					replace _fromid = `ego' in `newN'
					replace _toid = `ego' in `newN'
					replace _value = 1 in `newN'
				}
			}
			
			// read next line
			file read importfile line
		}
		file close importfile
		nwfromedge _fromid _toid _value, name(`name') labs(`labs') `nwfromedgeopt'
		restore
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
		qui while `"`line'"' != "" & `matrix_loaded' == 0{
			
			local line = subinstr(`"`line'"', "="," = ",.)
			local first : word 1 of `line'
			
			if "`mode'" == "label" {
				local labs = subinstr(`"`line'"', ", ", `"" ""',.)
				local labs `""`labs'""'
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
				di "{err}format {bf:`data_format'} not supported"
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
				noi nwfrommatrix _all, name(`name') labs(`labs')
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
			}
			
			if lower("`line'") == "labels embedded:"{
				di "{err}{bf:labels embedded} in ucinet format not supported"
				file close importfile
				error 6705
			}
			if lower("`line'") == "labels:"{
				local mode = "label"
			}
			if lower("`line'") == "data:"{
				local mode = "data"
			}
			local l = `l' + 1
			
			// read next line
			file read importfile line
		}
		capture file close importfile
		
		if `matrix_loaded' == 0  {
			capture destring _fromid, gen(_fromidnum)
			if _rc != 0 {
				gen _fromidnum = _fromid
			}
			capture encode _toid, gen(_toidnum)
			if _rc != 0 {
				gen _toidnum = _toid
			}	
			nwfromedge _fromidnum _toidnum _value, name(`name') labs(`labs') `nwfromedgeopt'
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
	syntax anything, [name(string) delimiter(string) directed rownames colnames] 
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
	
	local sub_col = ("`colnames'" == "colnames") 
	local sub_row = ("`rownames'" == "rownames")
	
	// Excel file detected
	qui if (strpos("`ending'", "xls") != 0 ){
		local excel = 1
		import excel "`anything'", sheet("Sheet1") clear
		if c(k) != `=`_N'' {
			local success = 0
		}
		else {
			local success = 1
		}
	}
	
	local i = 1
	qui while (`excel' == 0 & "`delimiter'" == "" & `success' == 0 & `i' <= `pot_delimiters_length'){
		local use_delimiter : word `i' of `pot_delimiters'
		local i = `i' + 1
		
		if "`use_delimiter'" == "tab" {
			local insheet_opt = ", tab clear"
		}
		else {
			local insheet_opt = `", delimiter("`use_delimiter'") clear"'
		}
		
		insheet using `anything' `insheet_opt'
		// Check for failure
		local n = _N + `sub_col'
		if c(k) != `n' {
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
		if c(k) != `=`_N' + `sub_col''  {
			local success = 0
		}
		else {
			local success = 1
		}
	}
	
	
	if `success' == 0 {
		di "{err}matrix could not be loaded"
		error 6703
	}
	
	qui if "`colnames'" != "" {
		ds _all
		local first : word 1 of `r(varlist)'
		rename `first' _cls
		local labs ""
		local i = 1
		foreach var of varlist _all {
			if `i' == 1 {
				local column "`var'"
			}
			else {
				local newlab = `column'[`=`i'-1']
				local newvar = strtoname("`newlab'",1)
				local labs "`labs' `newlab'"
				capture rename `var' `newvar'
				if _rc != 0 {
					set more off
					di "{err}{it:nodename} {bf:`newlab'} in first column invalid"
					exit
				}
			}
			local i = `i' + 1
		}
		drop `column'
	}	

	local n = _N 
	if c(k) != `n' {
		di "{err}Something went wrong; data has wrong dimensions."
		error 6703
	}
	
	qui ds
	local labs "`r(varlist)'"
	qui nwset _all, name("`name'") vars(_all) labs(`labs')
	restore
	if "`directed'" == "" {
		nwsym, check 
		if "`r(is_symmetric)'" == "true" {
			nwsym
		}
	}
	di 
	di "{txt}{it:Loading successful}"
	nwsummary
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

	preserve
	clear
	
	gettoken fname ending : anything, parse(".")

	local success = 0
	local excel = 0
	local pot_delimiters = `""tab" ";" "," " ""'
	local pot_delimiters_length : word count `pot_delimiters'
	
	// Excel file detected
	qui if (strpos("`ending'", "xls") != 0 ){
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
	qui while (`excel' == 0 & "`delimiter'" == "" & `success' == 0 & `i' <= `pot_delimiters_length'){
		local use_delimiter : word `i' of `pot_delimiters'
		local i = `i' + 1
		
		if "`use_delimiter'" == "tab" {
			local insheet_opt = ", tab clear"
		}
		else {
			local insheet_opt = `", delimiter("`use_delimiter'") clear"'
		}
		
		insheet using `anything' `insheet_opt'
		
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
	qui if ("`delimiter'" != ""){
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
		di "{err}{it:edgelist} could not be loaded"
		restore
		error 6704
	}

	if `c(k)' > 3 | `c(k)' < 2 {
		di "{err}Something went wrong; data has more than three columns."
		restore
		error 6704
	}
	
	nwfromedge _all, name(`name') `directed' `undirected' `xvars'
	restore
end







	