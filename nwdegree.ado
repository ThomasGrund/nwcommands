*! Date        : 10sept2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwdegree
program nwdegree
	version 9
	syntax [anything(name=netname)],[ isolates unweighted]
	
	_nwsyntax `netname', max(1)
	local directed = r(directed)
	nwtomata `netname', mat(degreeNet)
	
	if "`unweighted'" != "" {
		mata: degreeNet = degreeNet :/ degreeNet
		mata: _editmissing(degreeNet,0)
	}
	
	mata: outdegree = (colsum(degreeNet))'
	mata: indegree = rowsum(degreeNet)
	
	if (_N < `nodes'){
		set obs `nodes'
	}
	
	capture drop _degree
	capture drop _outdegree
	capture drop _indegree
	
	if ("`directed'" == "false"){
		nwtostata, mat(outdegree) gen(_degree)
	}
	else {
		nwtostata, mat(outdegree) gen(_outdegree)
		nwtostata, mat(indegree) gen(_indegree)
	}
	
	qui if "`isolates'" != "" {
		capture drop _isolates
		if ("`directed'" == "true"){
			gen _isolates = (_outdegree == 0) * (_indegree==0)
			//drop _outdegree _indegree
		}
		else{
			gen _isolates = (_degree == 0)
			//drop _degree
		}
	}
	
	mata: st_rclear()
	mata: mata drop outdegree indegree degreeNet
	
	nwinfo `netname'
end	
