*! Date        : 12oct2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwdegree
program nwdegree
	version 9
	syntax [anything(name=netname)],[ isolates valued GENerate(string) in(string) out(string) *]
	_nwsyntax `netname', max(9999)
	if `networks' > 1 {
		local k = 1
		local more = "`networks'"
	}
	
	foreach netname_temp in `netname' {
		_nwsyntax `netname_temp'
		
		local directed `directed'
		nwtomata `netname_temp', mat(degreeNet)
	
		if "`valued'" == "" {
			mata: degreeNet = degreeNet :/ degreeNet
			mata: _editmissing(degreeNet,0)
		}
	
		mata: outdegree = (colsum(degreeNet))'
		mata: indegree = rowsum(degreeNet)
	
		if (_N < `nodes'){
			set obs `nodes'
		}
	
		local _degree : word 1 of `generate'
		if "`_degree'" == "" {
			local _degree = cond("`valued'"=="", "_degree", "_strength") 
		}
		
		local _outdegree "_out`_degree'"
		local _indegree "_in`_degree'"
		local _isolates : word 2 of `generate'
		if "`_isolates'" == "" {
			local _isolates "_isolate"
		}
	
		capture drop `_degree'`k'
		capture drop `_outdegree'`k'
		capture drop `_indegree'`k'
		
		if ("`directed'" == "false"){
			nwtostata, mat(outdegree) gen(`_degree'`k')
		}
		else {
			nwtostata, mat(outdegree) gen(`_outdegree'`k')
			nwtostata, mat(indegree) gen(`_indegree'`k')
		}
	
		qui if "`isolates'" != "" {
			capture drop `_isolates'`k'
			if ("`directed'" == "true"){
				gen `_isolates'`k' = (`_outdegree'`k' == 0) * (`_indegree'`k'==0)
				//drop _outdegree _indegree
			}
			else{
				gen `_isolates'`k' = (`_degree'`k' == 0)
				//drop _degree
			}
		}
	
		mata: mata drop outdegree indegree degreeNet
		if "`more'" != "" & "`k'" != "`more'" {
			local k = `k' + 1
		}
	}
	
	di "{hline 40}"
	di "{txt}  Network name: {res}`netname'"
	di "{hline 40}"
	di "{txt}    Degree distribution"
	if "`directed'" == "true"{
		tab `_indegree'`k', `in'
		tab `_outdegree'`k', `out'
	}
	else {
		tab `_degree'`k', `options'
	}
end	
