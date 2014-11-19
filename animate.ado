*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop animate
program animate
	syntax anything, graphs(string) [imagickpath(string) delay(string) noloop showcommand keepeps mag(integer 100)]

	if "" != "" {
		local ipend = substr("",-1,.)
		if "" != "/" & "" != "\" {
			local imagickpath "/"
		}
	}
	if trim("") == "noloop"{
		local dloop = 1
	}
	else {
		local dloop = 0
	}
	if c(os) == "MaxOSX" {
		local download = "http://cactuslab.com/imagemagick/assets/ImageMagick-6.8.7-2.pkg.zip"
	}
	if c(os) == "Windows" {
		if c(osdtl) == "64-bit" {
			local download ="http://www.imagemagick.org/download/binaries/ImageMagick-6.8.8-5-Q16-x64-dll.exe"
		}
		else {
			local download ="http://www.imagemagick.org/download/binaries/ImageMagick-6.8.8-5-Q8-x86-dll.exe"
		}
	}
	
	di `"{err}command requires {net "http://www.imagemagick.org/":ImageMagick} to be installed on your computer; {net "":download it here}"'
	
	if "" == "" {
		local delay "50"
	}
	local epslist ""
	local numgraphs : word count 
	local i = 1
	qui if "" == "_all" {
		graph dir
		local graphs 
	}
	foreach g in  {
		local gl = length("") - 4
		
		if (substr("", -4, .) == ".gph") {
			graph use 
			local geps = substr("",1, )
		}
		else {
			graph display 
			local geps 
		}
		
		graph export .eps, replace 
		//mag()
		local epslist " .eps"
	
		if  ==  {
			local last ".eps"
		}
		local i =  + 1
	}
	
	local lastname : word  of 
	local lastdelay = 
	local shellcmd "convert -delay   -delay  .eps -loop  .gif"
	shell 
	
	if "" != "" {
		di ""
	}
	if "" == "" {
		if c(os) == "MaxOSX" {
			shell rm 
		}
		else {
			shell del 
		}
	}
end



