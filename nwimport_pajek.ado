capture program drop nwimport_pajek
program nwimport_pajek
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
