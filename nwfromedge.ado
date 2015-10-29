*! Date        : 25oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwfromedge
program nwfromedge
	syntax varlist(min=2 max=3) [if] [, overwrite prefix(string) noclear xvars name(string) labs(string asis) directed undirected ]
	unw_defs
	
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
				local labs "`labs' `=`fromvar'[`k']',"
			}
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
				local labs "`labs' `prefix'`=`_rawid'[`k']',"
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
	capture mata: mata drop __nwvalue 
	capture mata: mata drop __nwego 
	capture mata: mata drop __nwalter
	
	putmata __nwvalue = `_value' if `fromvar' != .
	putmata __nwego = `fromvar' if `fromvar' != .
	putmata __nwalter = `tovar' if `fromvar' != .
	mata: __nwmat = make_matrix(__nwego, __nwalter, __nwvalue, `maxNodes')
	
	capture mata: mata drop __nwvalue 
	capture mata: mata drop __nwego 
	capture mata: mata drop __nwalter
	
	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "network"
	}

	nwvalidate `name'
	local edgename = r(validname)

	// Set the new network
	nwset , mat(__nwmat) name(`edgename') labs(`labs') `overwrite'
	
	if "`clear'" == "" {
		qui drop _all
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
	
	if "`xvars'" == "" {
		qui nwload, `overwrite'
	}
	else {
		nwload, labelonly `overwrite'
	}
	
	}
	
	capture mata: mata drop __nwmat
	nwsummarize
end

capture mata : mata drop make_matrix()
mata:
real matrix function make_matrix(real matrix from, real matrix to, real matrix value, real scalar nodes) {
	real matrix mat
	real scalar i
	
	mat = J(nodes, nodes, 0)
	for (i = 1; i <= rows(from); i++) {
		mat[from[i,1],to[i,1]] = value[i,1]
	}
	mat
	return(mat)
}
end
