*! Date        : 8dec2014
*! Version     : 1.0.4
*! Author      : Thomas Grund, Linkˆping University
*! Email	   : contact@nwcommands.org

capture program drop nwfromedge
program nwfromedge
	syntax varlist(min=2 max=3) [if] [, noclear keeporiginal xvars name(string) vars(string) labs(string asis) edgelabs(string) stub(string) directed undirected ]

	// obtain variable names
	local fromvar : word 1 of `varlist'
	local tovar : word 2 of `varlist'
	
	capture replace `fromvar' = trim(`fromvar')	
	capture replace `tovar' = trim(`tovar')	
	capture replace `fromvar' = strtoname(`fromvar')
	capture replace `tovar' = strtoname(`tovar')
	
	capture replace `tovar' = `fromvar' if `tovar' == .
	capture replace `tovar' = `fromvar' if `tovar' == "."
		
	qui{
	
	tempvar _value
	if (wordcount("`varlist'") == 3) {
		local value : word 3 of `varlist'
		gen `_value' = `value'
		_extract_valuelabels `value'
		local edgelabs "`r(valuelabels)'"
	}
	else {
		gen `_value' = 1
	}
	
	// check for string variables
	capture confirm string variable `fromvar' `tovar'
	local fromStrings = 0
	tempfile dictionaryString
	
	// if condition
	if "`if'" != ""{ 
		keep `if'
	}
	
	tempfile dictionaryOriginalString
	
	// deal with strings as node identifiers
	if _rc == 0 {
		local rawtype "string"
	}
	else {
		local rawtype "numeric"
	}
	if _rc == 0 {
		local fromStrings = 1
		tempvar _nodeid _fromvarid _tovarid
		preserve
		stack `fromvar' `tovar', into(`fromvar') clear
		sort `fromvar'
		egen `_nodeid' = group(`fromvar')
		gen `tovar' = `fromvar'
		drop _stack		
		save `dictionaryString', replace
		
		sort `_nodeid'
		keep if `_nodeid' != `_nodeid'[_n-1]
		
		if "`labs'" == "" {
			forvalues k = 1/ `=_N'{
				local labs "`labs' `=`fromvar'[`k']'"
			}
		}
		if "`keeporiginal'" != "" {
			gen _nodeid = `_nodeid'
			gen _nodeoriginal = `fromvar'
			keep _node*
			sort _nodeid
			save `dictionaryOriginalString', replace
			local dictOrigString = 1
		}
		
		restore
		
		merge m:n `fromvar' using `dictionaryString'
		gen `_fromvarid' = `_nodeid' 
		drop if _merge != 3
		drop _merge `_nodeid'
		merge m:n `tovar' using `dictionaryString'
		gen `_tovarid' = `_nodeid'
		drop if _merge != 3
		drop _merge

		destring `fromvar', force replace
		destring `tovar', force replace
		replace `fromvar' = `_fromvarid'
		replace `tovar' = `_tovarid'
		collapse (max) `_value', by(`fromvar' `tovar')
	}

	// deal with non-consecutive integers as node identifiers
	set more off
	tempfile dictionaryConsecutive
	
	preserve
	tempvar _rawid _id _fromid _toid 
	tempname mynet
	
	// Generate a dictionary that maps the raw id's from the edgelist to consecutive id numbers.
	keep `fromvar' `tovar'
	stack `fromvar' `tovar', into(`_rawid') clear
	keep `_rawid'
	egen `_id' = group(`_rawid')
	collapse (mean) `_rawid', by(`_id')
	sort `_rawid'
	
	if "`rawtype'" == "numeric" {
		if "`labs'" == "" {
			forvalues k = 1/ `=_N'{
				local labs "`labs' `=`_rawid'[`k']'"
			}
		}
	}
	save `dictionaryConsecutive', replace
	
	tempfile dictionaryOriginal
	if "`keeporiginal'" != "" {
		gen _nodeid = _n
		gen _nodeoriginal = `_rawid'
		keep _nodeid _nodeoriginal
		sort _nodeid
		save `dictionaryOriginal', replace
	}
	restore

	// Map raw id's with dictionary
	gen `_rawid' = `fromvar'
	sort `_rawid'
	merge m:1 `_rawid' using `dictionaryConsecutive'
	drop if _merge != 3
	drop _merge
	replace `fromvar' = `_id'
	drop `_id'
	replace `_rawid' = `tovar'
	
	sort `_rawid'
	merge m:1 `_rawid' using `dictionaryConsecutive'
	drop if _merge != 3
	drop _merge
	replace `tovar' = `_id' 
	
	
	sum `fromvar'
	local maxNodes = r(max)
	sum `tovar'
	if r(max) > `maxNodes' {
		local maxNodes = r(max)
	}
	capture mata: mata drop mata_value 
	capture mata: mata drop mata_from 
	capture mata: mata drop mata_to
	
	putmata mata_value = `_value' if `fromvar' != .
	putmata mata_from = `fromvar' if `fromvar' != .
	putmata mata_to = `tovar' if `fromvar' != .
	
	mata: onenet = _getAdjacency(mata_from, mata_to, mata_value, `maxNodes')
	capture mata: mata drop mata_value 
	capture mata: mata drop mata_from 
	capture mata: mata drop mata_to

	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "network"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	
	nwvalidate `name'
	local edgename = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `maxNodes'){
		nwvalidvars `maxNodes', stub(`stub')
		local edgevars "$validvars"
		
	}
	else {
		local edgevars "`vars'"
	}

	// Set the new network
	nwset , mat(onenet) name(`edgename') vars(`edgevars') labs(`labs') edgelabs(`edgelabs')
	if "`clear'" == "" {
		qui drop _all
	}

	if "`xvars'" == "" {
		qui nwload
	}
	else {
		nwload, labelonly
	}
	if "`keeporiginal'" != "" {
		capture drop _nodeoriginal
		if "`dictOrigString'" != "" {
			merge 1:1 _nodeid using `dictionaryOriginalString', nogenerate
		}
		else {
			merge 1:1 _nodeid using `dictionaryOriginal', nogenerate
		}
		order _node*
	}
	
	if "`directed'" == "" {
		nwsym, check 
		if "`r(is_symmetric)'" == "true" {
			nwsym
		}
	}

	if "`undirected'" != "" {
		nwsym
	}
	
	}
	
	di 
	di "{txt}{it:Loading successful}"
	nwsummarize
end

capture mata : mata drop _getAdjacency()
mata:
real matrix function _getAdjacency(real matrix from, real matrix to, real matrix value, real scalar nodes) {
	
	onenet = J(nodes, nodes, 0)
	for (i = 1; i <= rows(from); i++) {
		onenet[from[i,1],to[i,1]] = value[i,1]
	}
	return(onenet)
}
end

*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
