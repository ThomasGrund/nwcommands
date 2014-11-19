*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwclear
program nwclear
	clear
	// clear all mata networks
	if "2" != "" { 
		forvalues i = 1/2 {
			capture mata: mata drop nw_mata
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
