*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwdrop
program nwdrop
	version 9
	syntax [anything(name=netname)] [if/] [in/], [netonly ATTRibutes(varlist) reverseif]
	_nwsyntax `netname', max(9999)

	local nets `networks'
	local z = 0
    foreach dropnet in `netname' {
		nwname `dropnet'
		local id = r(id)
		local nodes = r(nodes)
		local z = `z' + 1
		
		// only drop nodes 
		qui if ("`if'" != "" | "`in'" != ""){
			tempvar keepnode
			gen `keepnode' = 1
		    if "`if'" != "" {
				replace `keepnode' = 0 if `if'
				tab `keepnode'
				//if ("`reverseif'"!= ""){
				//	recode `keepnode' (0=1) (1=0)
				//}
			}
			if "`in'" != "" {
				replace `keepnode' = 0 in `in'
			}
		
			mata: keepnode = st_data((1,`nodes'), st_varindex("`keepnode'"))
			
			if (`z' != `nets') {
			 nwdropnodes `dropnet', keepmat(keepnode) `netonly'
			}
			else {
				 nwdropnodes `dropnet', keepmat(keepnode) `netonly' attributes(`attributes')
			}
			mata: mata drop keepnode
		}
		
		// drop the whole network
		else {
			// delete Stata variables if needed
			scalar onenw = "\$nw_`id'"
			if "`netonly'" == "" {
				capture confirm variable `=onenw'
				if _rc == 0 {
					qui drop `=onenw'
				}
				capture drop _label	 
			}
	
			// update all Stata/Mata macros
			local k 	= $nwtotal - 1
			forvalues j = `id'/`k' {
				local next = `j' + 1
				nwname, id(`next')
				global nwname_`j' = r(name)
				global nwsize_`j' = r(nodes)
				global nwdirected_`j' = r(directed)			
				global nwlabs_`j' = r(labs)
				
				scalar movenw = "\$nw_`next'"
				global nw_`j' `=movenw'
				
				mata: mata drop nw_mata`j'
				mata: nw_mata`j' = nw_mata`next'
			}
			
			// clean-up
			macro drop nw_$nwtotal
			macro drop nwsize_$nwtotal
			macro drop nwname_$nwtotal
			macro drop nwdirected_$nwtotal
			macro drop nwlabs_$nwtotal
			macro drop nwedgelabs_$nwtotal
			mata: mata drop nw_mata$nwtotal
			global nwtotal `=$nwtotal - 1'
			global nwtotal_mata = `=$nwtotal_mata - 1'
		}
	}
	nwcompressobs
	mata: st_rclear()
end
	
	
	
