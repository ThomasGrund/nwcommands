*! Date        : 22oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwdegree
program nwdegree
	version 9
	syntax [anything(name=netname)],[ standardize isolates valued GENerate(string) in(string) outputoff out(string) *]
	nw_syntax `netname', max(99999)
	local allnets "`netname'"

	set more off
	if `networks' > 1 {
		local k = 1
		local more = "`networks'"
	}

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
	
	
	foreach netname_temp in `allnets' {
		capture drop `_degree'`k'
		capture drop `_outdegree'`k'
		capture drop `_indegree'`k'
		
		nw_datasync `netname_temp'
		nw_syntax `netname_temp'
		local nodes_temp `nodes'
		
		tempname outdegree
		tempname indegree
		
		mata: `outdegree' = `netobj'->get_outdegree("`valued'" == "")  
		mata: `indegree' = `netobj'->get_indegree("`valued'" == "")  

		if ("`directed'" == "false"){
			getmata `_degree'`k' = `outdegree', replace force
		}
		else {
			getmata `_outdegree'`k' = `outdegree', replace force
			getmata `_indegree'`k' = `indegree', replace force
		}
			
		if "`standardize'" != "" {
			capture replace `_degree'`k' = `_degree'`k' / (`nodes_temp' - 1)
			capture replace `_outdegree'`k' = `_outdegree'`k' / (`nodes_temp' - 1)
			capture replace `_indegree'`k' = `_indegree'`k' / (`nodes_temp' - 1)
		}
		
		if "`isolates'" != "" {
			capture drop `_isolate'`k'
			
			if ("`directed'" == "true"){
				gen `_isolate'`k' = (`_outdegree'`k' == 0) * (`_indegree'`k'==0)
			}
			else{
				gen `_isolate'`k' = (`_degree'`k' == 0)
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
		if "`more'" != "" & "`k'" != "`more'" {
			local k = `k' + 1
		}
		
		if ("`directed'" == "false") {
			mata: st_numscalar("r(dg_central)", sum(J(`nodes_temp',1,max(`outdegree')) :- `outdegree') / ((`nodes_temp' - 2) * (`nodes_temp' - 1)))
			di 
			di "{txt}   Degree centralization:: {res}" + `=round(`r(dg_central)',0.001)'
		}
		else {
			mata: st_numscalar("r(indg_central)", sum(J(`nodes_temp',1,max(`indegree')) :- `indegree') / ((`nodes_temp' - 1) * (`nodes_temp' - 1))) 
			mata: st_numscalar("r(outdg_central)", sum(J(`nodes_temp',1,max(`outdegree')) :- `outdegree') / ((`nodes_temp' - 1) * (`nodes_temp' - 1)))
			di 
			di "{txt}   Indegree centralization:: {res}" + `=round(`r(indg_central)',0.001)'
			di "{txt}   Outdegree centralization:: {res}" + `=round(`r(outdg_central)',0.001)'
		}
		mata: mata drop `outdegree' `indegree' 
	}
end	

