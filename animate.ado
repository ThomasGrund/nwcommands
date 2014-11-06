capture program drop animate
program animate
	syntax anything, graphs(string) [imagickpath(string) delay(string) noloop showcommand keepeps mag(integer 100)]

	if "`imagickpath'" != "" {
		local ipend = substr("`imagickpath'",-1,.)
		if "`ipend'" != "/" & "`ipend'" != "\" {
			local imagickpath "`imagickpath'/"
		}
	}
	if trim("`loop'") == "noloop"{
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
	
	di `"{err}command requires {net "http://www.imagemagick.org/":ImageMagick} to be installed on your computer; {net "`download'":download it here}"'
	
	if "`delay'" == "" {
		local delay "50"
	}
	local epslist ""
	local numgraphs : word count `graphs'
	local i = 1
	qui if "`graphs'" == "_all" {
		graph dir
		local graphs `r(list)'
	}
	foreach g in `graphs' {
		local gl = length("`g'") - 4
		
		if (substr("`g'", -4, .) == ".gph") {
			graph use `g'
			local geps = substr("`g'",1, `gl')
		}
		else {
			graph display `g'
			local geps `g'
		}
		
		graph export `geps'.eps, replace 
		//mag(`mag')
		local epslist "`epslist' `geps'.eps"
	
		if `i' == `numgraphs' {
			local last "`geps'.eps"
		}
		local i = `i' + 1
	}
	
	local lastname : word `numgraphs' of `graphs'
	local lastdelay = `delay'
	local shellcmd "`imagickpath'convert -delay `delay' `epslist' -delay `lastdelay' `last'.eps -loop `dloop' `anything'.gif"
	shell `shellcmd'
	
	if "`showcommand'" != "" {
		di "`shellcmd'"
	}
	if "`keepeps'" == "" {
		if c(os) == "MaxOSX" {
			shell rm `epslist'
		}
		else {
			shell del `epslist'
		}
	}
end



