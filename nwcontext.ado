*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwcontext
program nwcontext 
	version 9
	syntax [anything(name=netname)],  ATTRibute(string) [mat(string) stat(string) mode(string) GENerate(string) noweight]
	
	_nwsyntax `netname', max(1)

	if "`stat'" == "" {
		local stat = "mean"
	}
	_opts_oneof "mean max min sum sd meanego maxego minego sumego sdego" "stat" "`stat'" 6810
	if "`mode'" == "" {
		local mode = "outgoing"
	}
	_opts_oneof "incoming outgoing both" "mode" "`mode'" 6810
	
	if "`generate'" == "" {
		local generate _context_`attribute'
	}
	
	capture drop `generate'

	if ("`stat'" == "") {
		local stat = "mean"
	}
	
	nwtomata `netname', mat(contextNet)
		
	mata: attr = J(`nodes', 1, 0)
	if `nodes' >= _N {
		local validCase = _N
		mata: attr[(1::`validCase')] = st_data((1,`validCase'), "`attribute'")
	}
	else {
		mata: attr[(1::`nodes')] = st_data((1,`nodes'), "`attribute'")
	}
	
	if ("`mode'" == "incoming") {
		mata: contextNet = contextNet'
	}
	if ("`mode'" == "both") {
		mata: contextNet = contextNet' + contextNet
	}
	
	if ("`weight'" == "noweight"){
		mata: contextNet = contextNet :/ contextNet
		mata: _editmissing(contextNet, 0)
	}
	
	
	if ("`stat'" == "mean"){
		mata: netVal = rowsum(contextNet)
		mata: context = (contextNet * attr) :/ netVal
		mata: mata drop netVal
	}
	
	if ("`stat'" == "meanego"){
		mata: _diag(contextNet, 1)
		mata: netVal = rowsum(contextNet)
		mata: context = (contextNet * attr) :/ netVal
		mata: mata drop netVal
	}
	
	if ("`stat'" == "sd"){
		mata: netVal = rowsum(contextNet)
		mata: avgContext = (contextNet * attr) :/ netVal
		mata: _editvalue(contextNet,0,.)
		mata: diffContext = (contextNet :* attr') :- avgContext
		mata: context = sqrt(rowsum(diffContext :* diffContext):/rowsum(contextNet))
		mata: mata drop netVal diffContext avgContext 
	}
	
	if ("`stat'" == "sdego"){
		mata: _diag(contextNet, 1)
		mata: netVal = rowsum(contextNet)
		mata: avgContext = (contextNet * attr) :/ netVal
		mata: _editvalue(contextNet,0,.)
		mata: diffContext = (contextNet :* attr') :- avgContext
		mata: context = sqrt(rowsum(diffContext :* diffContext):/rowsum(contextNet))
		mata: mata drop netVal diffContext avgContext 
	}
	
	if ("`stat'" == "max"){
		mata: _editvalue(contextNet,0,.)
		mata: context = rowmax(contextNet :* attr')
	}
	
	if ("`stat'" == "maxego"){
		mata: _diag(contextNet, 1)4
		mata: _editvalue(contextNet,0,.)
		mata: context = rowmax(contextNet :* attr')
	}
	
	if ("`stat'" == "min"){	
		mata: _editvalue(contextNet,0,.)
		mata: context = rowmin(contextNet :* attr')
	}
	
	if ("`stat'" == "minego"){	
		mata: _diag(contextNet, 1)
		mata: _editvalue(contextNet,0,.)
		mata: context = rowmin(contextNet :* attr')
	}
	
	if ("`stat'" == "sum"){
		mata: context = (contextNet * attr) 
	}
	
	if ("`stat'" == "sumego"){
		mata: _diag(contextNet, 1)
		mata: context = (contextNet * attr) 
	}
	
	if "`mat'" != "" {
		mata: `mat' = context
	}
	else {
		nwtostata, mat(context) gen(`generate')
	}
	mata: mata drop context contextNet attr   
end
