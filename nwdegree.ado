*! Date        : 12oct2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwdegree
program nwdegree
	version 9
	syntax [anything(name=netname)],[ isolates valued GENerate(string) in(string) outputoff out(string) *]
	_nwsyntax `netname', max(9999)
	_nwsetobs
	
	set more off
	if `networks' > 1 {
		local k = 1
		local more = "`networks'"
	}
		
	foreach netname_temp in `netname' {
		_nwsyntax `netname_temp'
		local nodes_temp `nodes'
		
		local directed `directed'
		nwtomata `netname_temp', mat(degreeNet)
	
		if "`valued'" == "" {
			mata: degreeNet = degreeNet :/ degreeNet
			mata: _editmissing(degreeNet,0)
		}
	
		mata: outdegree = rowsum(degreeNet) 
		mata: indegree =  (colsum(degreeNet))'
	
	
		local _degree : word 1 of `generate'
		local _outdegree : word 1 of `generate'
		local _indegree : word 2 of `generate'
		local z : word count `generate'
		local _isolate : word 2 of `generate'
		if "`directed'" == "true" {
			local _isolate : word 3 of `generate'
		}
		
		if "`_degree'" == "" {
			local _degree = cond("`valued'"=="", "_degree", "_strength") 
		}
	
		if (`z' < 2){
			local _outdegree "_out`_degree'"
			local _indegree "_in`_degree'"
		}
				
		if "`_isolate'" == "" {
			local _isolate "_isolate"
		}
	
		capture drop `_degree'`k'
		capture drop `_outdegree'`k'
		capture drop `_indegree'`k'
		
		if "`outputoff'" == "" {
		
		if ("`directed'" == "false"){
			nwtostata, mat(outdegree) gen(`_degree'`k')
		}
		else {
			nwtostata, mat(outdegree) gen(`_outdegree'`k')
			nwtostata, mat(indegree) gen(`_indegree'`k')
		}
		qui if "`isolates'" != "" {
			capture drop `_isolate'`k'
			if ("`directed'" == "true"){
				gen `_isolate'`k' = (`_outdegree'`k' == 0) * (`_indegree'`k'==0)
			}
			else{
				gen `_isolate'`k' = (`_degree'`k' == 0)
			}
			replace `_isolate'`k' = . if _n > `nodes_temp'
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
		if "`more'" != "" & "`k'" != "`more'" {
			local k = `k' + 1
		}
		
		}
		
		if ("`directed'" == "false") {
			mata: st_numscalar("r(dg_central)", sum(J(`nodes_temp',1,max(outdegree)) :- outdegree) / ((`nodes_temp' - 2) * (`nodes_temp' - 1)))
			di 
			di "{txt}   Degree centralization:: {res}`r(dg_central)'"
		}
		else {
			mata: st_numscalar("r(indg_central)", sum(J(`nodes_temp',1,max(indegree)) :- indegree) / ((`nodes_temp' - 1) * (`nodes_temp' - 1))) 
			mata: st_numscalar("r(outdg_central)", sum(J(`nodes_temp',1,max(outdegree)) :- outdegree) / ((`nodes_temp' - 1) * (`nodes_temp' - 1)))
			di 
			di "{txt}   Indegree centralization:: {res}`r(indg_central)'"
			di "{txt}   Outdegree centralization:: {res}`r(outdg_central)'"
		}
		mata: mata drop outdegree indegree degreeNet
	}
end	
