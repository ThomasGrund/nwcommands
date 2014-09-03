*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwkeep 
program nwkeep
	syntax [anything(name=netname)][if] [in],[ attributes(string)]
	_nwsyntax `netname', max(9999)
	
	local netdrop ""
	local netshere = "`netname'"

	nwset, nooutput
	local nets = r(networks)
	forvalues i = 1/`nets' {
		nwname, id(`i')
		local onename = r(name)
		local found = 0
		foreach keepnet in `netshere' {
			if "`keepnet'" == "`onename'" {
				local found = `found' + 1
			}
		}
		if (`found' == 0){
			local netdrop "`netdrop' `onename'"
		}
	}
	nwdrop `netdrop' `if' `in', attributes(`attributes') reverseif
	nwcompressobs
end
	