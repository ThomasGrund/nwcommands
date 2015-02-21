capture program drop nwtoedge
program nwtoedge
	version 9
	syntax [anything(name=netname)][, forceundirected forcedirected FRomvars(varlist) TOvars(varlist)  ///
	fromid(name) toid(name) link(name) full] 
	tempfile fromfile tofile
	tempvar totperfrom totperto dropcomp mergefrom mergeto 
	
	_nwsyntax `netname', max(2)
	
	local nm "`netname'"
	
	local numnets = wordcount("`netname'")
	
	qui if (`numnets' == 2){
		local type = "full"
		
		local net1 = word("`netname'", 1)
		nwname `net1'
		local nodes1 = r(nodes)
		
		local net2 = word("`netname'", 2)
		nwname `net2'
		local nodes2 = r(nodes)	
		
		// networks of different size
		if (`nodes1' != `nodes2'){
			gen temp = .
			tempfile current 
			tempfile edgelist1
			save `current'
			nwtoedge `net1', full fromvars(`fromvars') tovars(`tovars') fromid(`fromid') toid(`toid')
			save `edgelist1'
			use `current', clear
			nwtoedge `net2', full
			merge 1:1 _fromid _toid using `edgelist1', nogenerate
			exit
		}
	}
	else {
		local net1 `netname'
	}

	if "`fromid'" == "" {
		local fromid fromid
	}
	
	if "`toid'" == "" {
		local toid toid
	}
	
	local n = `nodes'
	local n2 = `nodes' * `nodes'
	
	preserve

	qui if "`fromvars'" != ""  {
		capture quietly gen long `fromid' =_n
		if `fromid' != _n {
			dis as error "Variable `fromid' does not contain node number." 
			dis as error "Please rename existing variable or choose another name for the new variable."
			error 110
		}
		quietly compress `fromid' 
		keep `fromid' `fromvars'
		capture foreach x of varlist `fromvars' {
			rename `x' from_`x'
		}
		capture unab frfromvars : from_*
		sort `fromid'
		quietly save `fromfile'
	}

	qui if "`tovars'" != ""  {
		restore
		preserve
		capture quietly gen long `toid' =_n
		if `toid' != _n {
			dis as error "Variable `toid' does not contain node number. Please rename."
			dis as error "Please rename existing variable or choose another name for the new variable."
			error 110
		}
		quietly compress `toid'
		keep `toid' `tovars'
		foreach x of varlist `tovars' {
			rename `x' to_`x'
		}
		capture unab totovars : to_*
		sort `toid'
		quietly save `tofile'
	}	
	
	qui drop _all 
	tempfile onenet_file0
	qui set obs `n2'
	qui gen long `fromid' = ceil(_n/`n')
	bysort `fromid': gen long `toid' = _n
	order `fromid' `toid'
	sort `fromid' `toid'
	qui save `onenet_file0'
	restore
	
	local z = 1
	local num_nets = wordcount("`netname'")

	local directed_all = "false"
	 qui forvalues i=1/`num_nets' {
		local onenet : word `i' of `netname'
		preserve
		
		tempfile onenet_file`i'
		nwname `onenet'
		if "`r(directed)'" == "true" {
			local directed_all = "true"
		}
		local nodes = r(nodes)
		local id = r(id)
		scalar onevars = "\$nw_`id'"
		local vars `=onevars'"
		drop _all
		nwload `onenet', nocurrent
		nwtomata `onenet', mat(nwtoedgenet)
		mata: nwtoedgenet = colshape(nwtoedgenet,1)
		drop _all
		qui set obs `n2'
		local link "`onenet'"
		qui gen `link' = .
		mata: st_view(nwfulledgeview=.,.,.)
		mata: nwfulledgeview[.,.] = nwtoedgenet
		gen long `fromid' = ceil(_n/`n')
		bysort `fromid': gen long `toid' = _n
		
		if (`num_nets'== 1 & "`full'" == "") {		
			if ("`type'" == "compact"){
				keep if (`link' != 0 | `fromid' == `toid') 
			}
			if ("`type'" == "nozero"){
				keep if `link' != 0  
			}
		}
		
		order `fromid' `toid'
		sort `fromid' `toid'
		save `onenet_file`i''
		mata: mata drop nwtoedgenet nwfulledgeview
		restore
	}	
	
	qui use `onenet_file0', clear
	local z = 1
	qui foreach onenet in `netname' {
		merge m:1 `fromid' `toid' using `onenet_file`z'', nogenerate
		order `fromid' `toid'
		sort `fromid' `toid'
		local z = `z' + 1
		//keep if `onenet' != .
	}
	
	qui if "`fromvars'"  != "" { 
		sort `fromid' 
		merge m:1 `fromid' using `fromfile', nogenerate
	}
	
	qui if "`tovars'"  != "" { 
		sort `toid'
		merge m:1 `toid' using `tofile', nogenerate 
	}
	sort `fromid' `toid' 
	rename fromid _fromid
	rename toid _toid
	
	if "`directed_all'" == "false" {
		local forceundirected = "forceundirected"
	}
	if "`forcedirected'" != "" {
		local forceundirected = ""
	}
	if "`forceundirected'" != "" {
		qui drop if _fromid > _toid
	}
	
	if "`full'" == "" {
		capture drop if `net1' == .
		capture drop if `net2' == .
	}

end	
	
