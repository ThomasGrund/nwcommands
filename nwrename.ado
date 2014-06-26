capture program drop nwrename
program nwrename
	version 9
	syntax anything
		
	if (wordcount("`anything'") != 2) {
		di "{err}Wrong number of networks."
		//adjust error code
		error 6000
	}
	
	local oldnet = word("`anything'", 1)
	local newnet = word("`anything'", 2)
	nwname `oldnet', newname(`newnet')
end
	
	
