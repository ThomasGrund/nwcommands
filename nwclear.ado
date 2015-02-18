*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwclear
program nwclear
	clear
	// clear all mata networks
	if "$nwtotal" != "" { 
		forvalues i = 1/$nwtotal {
			capture mata: mata drop nw_mata`i'
		}
	}
	capture macro drop _all
	
	// clear file handlers
	capture file close expfile
	capture file close sessfile
	capture file close importfile
	
	capture return clear
	capture mata: st_rclear()
end

