*! Date        : 3sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwexport
program nwexport
	version 9
	syntax [anything(name=netname)], type(string) [FName(string asis) replace]	
	
	_nwsyntax `netname', max(1)
	_opts_oneof "pajek ucinet" "type" "`type'" 6810
	
	if `"`fname'"' == "" {
		local fname = "`netname'"
	}
	
	di `"{txt}Exporting network: {it:`netname'}"'
	
	if "`type'" == "pajek" {
		 _nwexport_pajek `netname', fname(`fname') `replace'
	}	
	if "`type'" == "ucinet" {
		 _nwexport_ucinet `netname', fname(`fname') `replace'
	}
end


capture program drop _nwexport_pajek
program _nwexport_pajek
	syntax [anything(name=netname)], fname(string) [replace]
	
	nwname `netname'
	
	local vars "`r(vars)'"
	local labs "`r(labs)'"
	local directed "`r(directed)'"
	local nodes `r(nodes)'
	tempname expfile

	file open `expfile' using "`fname'.net", write `replace'
	file write `expfile' "*Vertices `nodes'" _newline
	forvalues i = 1/`nodes' {
		local onelab : word `i' of `labs'
		file write `expfile' (`i')
		file write `expfile' ("   ")
		file write `expfile' (char(34))
		file write `expfile' ("`onelab'")
		file write `expfile' (char(34)) _newline	
	}
	if ("`directed'" == "true"){
		file write `expfile' "*Arcs"
	}
	else {
		file write `expfile' "*Edges"
	}
	
	preserve
	qui nwtoedge `netname'
	qui keep if `netname' != 0
	local ties = _N
	forvalues i = 1/`ties' {
		if `netname'[`i'] != 0 {
			local value = `netname'[`i']
			local k = _fromid[`i']
			local l = _toid[`i']
			file write `expfile' _newline
			file write `expfile' (`k')
			file write `expfile' " "
			file write `expfile' (`l')
			file write `expfile' " `value'" 	
		}
	
	}
	file write `expfile' "" _newline
	file close `expfile'	
	restore
end


capture program drop _nwexport_ucinet
program _nwexport_ucinet
	syntax [anything(name=netname)], fname(string) [replace]
	
	nwname `netname'
	local vars "`r(vars)'"
	local labs "`r(labs)'"
	local directed "`r(directed)'"
	local nodes `r(nodes)'
	tempname expfile

	file open `expfile' using "`fname'.dl", write `replace'
	file write `expfile' "dl n=`nodes'" _newline
	file write `expfile' "labels:" _newline
	forvalues i = 1/`nodes' {
		local onelab : word `i' of `labs'
		file write `expfile' ("`onelab'")
		if `i' < `nodes' {
			file write `expfile' (",")
		}
	}
	file write `expfile' _newline
	file write `expfile' "data:"
	
	preserve
	qui nwtoedge `netname'
	qui keep if `netname' != 0
	local ties = _N
	forvalues i = 1/`ties' {
		if `netname'[`i'] != 0 {
			local value = `netname'[`i']
			local k = _fromid[`i']
			local l = _toid[`i']
			file write `expfile' _newline
			file write `expfile' (`k')
			file write `expfile' " "
			file write `expfile' (`l')
			file write `expfile' " `value'" 	
		}
	
	}
	file close `expfile'	
	restore
end


