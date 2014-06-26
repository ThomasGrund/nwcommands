capture program drop nwimport_ucinet

program nwimport_ucinet
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
