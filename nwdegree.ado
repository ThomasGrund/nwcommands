*! Date        : 12oct2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwdegree
program nwdegree
	version 9
	syntax [anything(name=netname)],[ isolates unweighted GENerate(string)]
	
	_nwsyntax `netname', max(9999)
	if `networks' > 1 {
		local k = 1
		local more = "`networks'"
	}
	
	foreach netname_temp in `netname' {
		_nwsyntax `netname_temp'
		
		local directed = r(directed)
		nwtomata `netname_temp', mat(degreeNet)
	
		if "`unweighted'" != "" {
			mata: degreeNet = degreeNet :/ degreeNet
			mata: _editmissing(degreeNet,0)
		}
	
		local gencount : word count `generate'
		if (`gencount' != 4) {
			local generate = "_degree _outdegree _indegree _isolates"
		}
	
		mata: outdegree = (colsum(degreeNet))'
		mata: indegree = rowsum(degreeNet)
	
		if (_N < `nodes'){
			set obs `nodes'
		}
	
		local _degree : word 1 of `generate'
		local _outdegree : word 2 of `generate'
		local _indegree : word 3 of `generate'
		local _isolates : word 4 of `generate'
	
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
	
		mata: st_rclear()
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
		tab `_indegree'`k' 
		tab `_outdegree'`k'
	}
	else {
		tab `_degree'`k'
	}
end	
