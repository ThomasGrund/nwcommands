capture program drop nwimport_gefx
program nwimport_gefx
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


capture program drop _insert_edge
program _insert_edge
	syntax, from(string) to(string) value(string)
	
	qui if ("`from'" != "-1" & "`to'" != "-1"){
		local n = _N
		local newN = `n' + 1
		set obs `newN'
		replace _fromid = "`from'"  in `newN'
		replace _toid = "`to'"  in `newN'
		replace _value = `value' in `newN'
	}
end	
