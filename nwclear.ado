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
	capture macro drop nw*
	capture macro drop validvars
	
	// clear file handlers
	capture file close expfile
	capture file close sessfile
	capture file close importfile
	
	capture return clear
	capture mata: st_rclear()
end

*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
