capture program drop animate
program animate
	syntax anything, graphs(string) [delay(string) noloop]

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
	foreach g in `graphs' {
		graph display `g'
		graph export `g'.eps, replace
		local epslist "`epslist' `g'.eps"
	}
	
	local lastname : word `numgraphs' of `graphs'
	local lastdelay = `delay'
	local shellcmd = "convert -delay `delay' `epslist' -delay `lastdelay' `last'.eps -loop `dloop' `anything'.gif"
	shell `shellcmd'
end



