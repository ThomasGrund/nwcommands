*! Date        : 15oct2014
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nw_clear
program nw_clear
	unw_defs
	capture mata: mata drop `nw'
	mata: st_rclear()
end

