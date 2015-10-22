// DEPRECATED => use nw_syntax instead

*! Date        : 15oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop _nwsyntax
program _nwsyntax
	nw_syntax `0'
	
	c_local netobj `netobj'
	c_local id `r(id)'
	c_local netname `name'
	c_local networks `networks'	
end
