*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwrename
program nwrename
	version 9
	syntax anything
		
	if (wordcount("") != 2) {
		di "{err}Wrong number of networks."
		//adjust error code
		error 6000
	}
	
	local oldnet = word("", 1)
	local newnet = word("", 2)
	nwname , newname()
end
	
	
