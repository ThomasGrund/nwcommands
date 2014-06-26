capture program drop nwdegree
program nwdegree
	version 9
	syntax [anything(name=netname)],[ isolates]
	
	if ("`netname'" == ""){
		nwcurrent
		local netname = r(current)
	}
	
	nwname `netname'
	local directed = r(directed)
	local nodes = r(nodes)
	
	nwtomata `netname', mat(degreeNet)
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
			drop _outdegree _indegree
		}
		else{
			gen _isolates = (_degree == 0)
			drop _degree
		}
	}
	
	mata: st_rclear()
	nwname `netname'
	mata: mata drop outdegree indegree degreeNet
end	
