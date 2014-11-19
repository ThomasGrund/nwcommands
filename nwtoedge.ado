*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwtoedge
program nwtoedge
	version 9
	syntax [anything(name=netname)][, forceundirected forcedirected type(string) KEEPTOnodes KEEPEgo NOFRomvars FRomvars(varlist) TOvars(varlist)  ///
	fromid(name) toid(name) link(name) full] 
	tempfile fromfile tofile
	tempvar totperfrom totperto dropcomp mergefrom mergeto 

	_nwsyntax , max(2)

	if ("" == "") {
		local type = "compact"
	}
	local numnets = wordcount("")
	
	qui if ( == 2){
		local type = "full"
		
		local net1 = word("", 1)
		nwname 
		local nodes1 = r(nodes)
		
		local net2 = word("", 2)
		nwname 
		local nodes2 = r(nodes)	
		
		// networks of different size
		if ( != ){
			gen temp = .
			tempfile current 
			tempfile edgelist1
			save 
			nwtoedge , type(full) fromvars() tovars() fromid() toid()
			save 
			use , clear
			nwtoedge , type(full)
			merge 1:1 _fromid _toid using , nogenerate
			exit
		}
	
	}

	if "" == "" {
		local fromid fromid
	}
	
	if "" == "" {
		local toid toid
	}
	
	local n = 
	local n2 =  * 

	preserve

	qui if "" != ""  {
		capture quietly gen long  =_n
		if  != _n {
			dis as error "Variable  does not contain node number." 
			dis as error "Please rename existing variable or choose another name for the new variable."
			error 110
		}
		quietly compress  
		keep  
		capture foreach x of varlist  {
			rename  from_
		}
		capture unab frfromvars : from_*
		sort 
		quietly save 
	}

	qui if "" != ""  {
		restore
		preserve
		capture quietly gen long  =_n
		if  != _n {
			dis as error "Variable  does not contain node number. Please rename."
			dis as error "Please rename existing variable or choose another name for the new variable."
			error 110
		}
		quietly compress 
		keep  
		foreach x of varlist  {
			rename  to_
		}
		capture unab totovars : to_*
		sort 
		quietly save 
	}	
	
	qui drop _all 
	
	tempfile onenet_file0
	qui set obs 
	qui gen long  = ceil(_n/)
	bysort : gen long  = _n
	order  
	sort  
	qui save 
	restore
	
	local z = 1
	local num_nets = wordcount("")

	local directed_all = "true"
	qui forvalues i=1/ {
		local onenet : word  of 
		preserve
		
		tempfile onenet_file
		nwname 
		if "" == "false" {
			local directed_all = "false"
		}
		local nodes = r(nodes)
		local id = r(id)
		scalar onevars = ""
		local vars marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16"
		drop _all
		nwload , nocurrent
		nwtomata , mat(nwtoedgenet)
		mata: nwtoedgenet = colshape(nwtoedgenet,1)
		drop _all
		qui set obs 
		local link ""
		qui gen  = .
		mata: st_view(nwfulledgeview=.,.,.)
		mata: nwfulledgeview[.,.] = nwtoedgenet
		gen long  = ceil(_n/)
		bysort : gen long  = _n
		
		if (== 1 & "" == "") {		
			if ("" == "compact"){
				keep if ( != 0 |  == ) 
			}
			if ("" == "nozero"){
				keep if  != 0  
			}
		}
		
		order  
		sort  
		save 
		mata: mata drop nwtoedgenet nwfulledgeview
		restore
	}	
	
	qui use , clear
	local z = 1
	qui foreach onenet in  {
		merge m:1   using , nogenerate
		order  
		sort  
		local z =  + 1
		//keep if  != .
	}
	
	qui if ""  != "" { 
		sort  
		merge m:1  using , nogenerate
	}
	
	qui if ""  != "" { 
		sort 
		merge m:1  using , nogenerate 
	}
	sort   
	rename fromid _fromid
	rename toid _toid

	if "" == "false" {
		local forceundirected = "forceundirected"
	}
	if "" != "" {
		local forceundirected = ""
	}
	if "" != "" {
		qui drop if _fromid > _toid
	}
end	
	
