*! Date        : 13oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwrename
program nwrename
	
	local renameCmd `0'
	
	preserve
	drop _all
	nw_syntax _all, max(9999)
	foreach onenet in `netname' {
		gen `onenet' = .
	}
	rename `renameCmd', r
	local oldnames "`r(oldnames)'"
	local newnames "`r(newnames)'"
	restore
	local i = 1
	foreach onenet in `oldnames' {
		local newname : word `i' of `newnames'
		nwname `onenet', newname(`newname')
		local i = `i' + 1
	}
end

