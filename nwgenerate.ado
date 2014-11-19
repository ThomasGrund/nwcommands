*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwgenerate
program nwgenerate
	local arg ="nwgenerate.ado, date(18nov2014) author(Thomas Grund) email(thomas.u.grund@gmail.com) version(1.0.4.1) other()"
	gettoken arg options: arg, parse(",") bind
	if "" != "" {
		local options = substr("", 2,.)
	}
	gettoken netname netexp: arg, parse("=")
	local netname = trim("")
	
	// check if network or variable should be created
	
	gettoken job jobrest: netexp, parse("(")
	local job = trim("")
	local job = substr("", 2,.)
	local selectjob : word 1 of 
	local nwgenopt "evcent context degree outdegree indegree isolates components lgc clustering closeness farness nearness between"
	local whichjob : list  nwgenopt & selectjob
	local nwgenvar : word count 
	
	// generate network
	if  == 0 {
	
		// replace the network if it exists already
		if (strpos("", "replace")!=0){
			capture nwdrop 
		}
	
		capture nwname 
		if _rc == 0 {
			di "{err}network {it:} already defined"
			error 6004
		}
	
		// get rid of first equal sign and check for single generator
		local netexp = substr(trim(""),2,.)
		if (substr("",1,1)=="_") {
			local netexp "()"
		}
	
		// evaluate network expression
		_nwevalnetexp  % _genmat
		local nodes = r(nodes)
	
		// check if new network id directed
		mata: st_numscalar("r(sym)", issymmetric(_genmat))
		if (r(sym) == 1){
			local undirected "undirected"
		}
		nwrandom , prob(0) name()  
		nwreplacemat , newmat(_genmat)
	
		mata: st_rclear()
		nwname 
		mata: st_global("r(netexp)", "")
		mata: mata drop _genmat
	}
	// generate variable
	qui else {
		// get whatever is inside parenthesis
		local start = strpos("", "(")
		local length = (strpos("",")")) -  - 1
		local subopt = substr("", 1, )
		
		// nwclustering shortcuts
		if "" == "clustering" {
			nwclustering , gen() 
		}
		
		// nwcloseness shortcuts
		if "" == "closeness" {
			tempvar _t1 _t2
			nwcloseness , gen(  ) 
		}
		if "" == "farness" {
			tempvar _t1 _t2
			nwcloseness , gen(  ) 
		}
		if "" == "nearness" {
			tempvar _t1 _t2
			nwcloseness , gen(  ) 
		}
		
		// nwcomponents shortcuts
		if "" == "components" {
			nwcomponents , gen() 
		}
		if "" == "lgc" {
			nwcomponents , gen() lgc 
		}
		
		// nwdegree shortcuts
		if "" == "isolates" {
			tempvar _t1 _t2 _t3
			nwdegree , isolates gen(   ) 
		}
		if "" == "indegree" {
			tempvar _t1 _t2 _t3
			nwdegree , gen(   ) 
			capture confirm variable 
			if _rc != 0 {
				nwdegree , gen(   ) 
			}
		}
		if "" == "outdegree" {
			tempvar _t1 _t2 _t3
			nwdegree , gen(    ) 
			capture confirm variable 
			if _rc != 0 {
				nwdegree , gen(   ) 
			}
		}
		if "" == "degree" {
			tempvar _t1 _t2 _t3
			nwdegree , gen(    ) 
			capture confirm variable 
			if _rc != 0 {
				nwdegree , gen(   ) 
			}
		}
		
		// nwbetween shortcuts
		if "" == "between" {
			nwbetween , gen() 
		}
		
		// nwcontext shortcuts
		if "" == "context" {
			nwcontext , gen() 
		}
		
		// nwevcent shortcuts
		if "" == "evcent" {
			nwevcent , gen() 
		}
		
	}
end

	
	
	
	
	
	

	
