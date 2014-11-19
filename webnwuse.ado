*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop webnwuse
program webnwuse
	syntax anything [, *]
	local webname = subinstr("", ".dta","",99)
	nwuse http://nwcommands.org/data/, 
end



	

