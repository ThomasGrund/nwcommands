*! Date        : 11feb2015
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwmovie
program nwmovie
	syntax anything(name=netname), [z(integer 1) switchtitle(string) switchnetwork(string) switchcolor(string) switchsymbol(string) switchedgecolor(string) imagick(string) eps keepfiles width(integer 750) height(integer 500) fname(string) explosion(string) titles(string) delay(string) size(varlist) color(string) symbol(varlist) edgecolor(string) edgesize(string) frames(integer 10) *]

	local old_options `options'
	
	if "`switchnetwork'" == "" {
		local switchnetwork = "half"
	}
	if "`switchedgecolor'" == "" {
		local switchedgecolor = "half"
	}	
	if "`switchcolor'" == "" {
		local switchcolor= "half"
	}
	if "`switchsymbol'" == "" {
		local switchsymbol = "half"
	}	
	if "`switchtitle'" == "" {
		local switchtitle = "half"
	}
	
	_opts_oneof "start end half" "switchnetwork" "`switchnetwork'" 6556
	_opts_oneof "start end half" "switchcolor" "`switchcolor'" 6556
	_opts_oneof "start end half" "switchsymbol" "`switchsymbol'" 6556
	_opts_oneof "start end half" "switchtitle" "`switchtitle'" 6556		
	_opts_oneof "start end half" "switchedgecolor" "`switchedgecolor'" 6556

	local pic = "png"
	local picopt = "width(`width') height(`height')"
		
	if "`eps'" != "" {
		local pic = "eps"
		local picopt = "mag(200)"
	}


	if c(os) == "MacOSX" {
		nwmovie_install_osx
		local impath = "`r(impath)'"
	}
	
	if c(os) == "Windows" {
		nwmovie_install_win
		local impath = "`r(impath)'"
	}
	
	
	// make movie
	_nwsyntax `netname', max(999) min(2)
	local k : word count `netname'
	
	// check and clean networks as edgecolor and edgesize
	_nwsyntax_other `edgesize', exactly(`networks') nocurrent
	local edgesize_check "`othernetname'"
	local othernetname = ""
	_nwsyntax_other `edgecolor', exactly(`networks') nocurrent
	local edgecolor_check "`othernetname'"
	
	
	capture drop _c1_* 
	capture drop _c2_*
	capture drop _frame_*

	set more off
	local applysize = 0
	
	if ("`size'" != ""){
		local 0 `size'
		syntax [varlist(default=none)], [*]
		local size `varlist'
		local sizeopt `options'	
		local s : word count `size'
		if `s' != `k' {
			di "{err}Option {bf:size()} needs to have as many variables as networks to be plotted"
		}
	}
	if ("`color'" != ""){
		local 0 `color'
		syntax [varlist(default=none)], [*]
		local color `varlist'
		local coloropt `options'	
		local s : word count `color'
		if `s' != `k' {
			di "{err}Option {bf:color()} needs to have as many variables as networks to be plotted"
		}
		
		local color_uniquevalues ""
		foreach color_time in `color' {
			tempvar temp
			capture encode `color_time', gen(`temp')
			if _rc == 0 {
				di "{err}{it:nwmovie} requries variable {bf:`color_time} to be numeric."
				error 6750
			}
			qui tab `color_time', matrow(color_tab)
			forvalues i = 1/`r(r)' {
				local onecolor = color_tab[`i',1]
				if (strpos("`color_uniquevalues'","`onecolor'") == 0){
					local color_uniquevalues = "`color_uniquevalues' `onecolor'"
				}
			}
		}
	}
		
	if ("`symbol'" != ""){
		local 0 `symbol'
		syntax [varlist(default=none)], [*]
		local symbol `varlist'
		local symbolopt `options'
		local s : word count `symbol'
		if `s' != `k' {
			di "{err}option {bf:symbol()} needs to have as many variables as networks to be plotted"
		}
		local symbol_uniquevalues ""
		foreach symbol_time in `color' {
			tempvar temp
			capture encode `symbol_time', gen(`temp')
			if _rc == 0 {
				di "{err}{it:nwmovie} requries variable {bf:`symbol_time} to be numeric."
				error 6750
			}
			qui tab `symbol_time', matrow(symbol_tab)
			forvalues i = 1/`r(r)' {
				local onesymbol = symbol_tab[`i',1]
				if (strpos("`symbol_uniquevalues'","`onesymbol'") == 0){
					local symbol_uniquevalues = "`symbol_uniquevalues' `onesymbol'"
				}
			}
		}
	}
	
	local options `old_options'
	
	local k = `k' - 1
	if "`delay'" == "" {
		local delay = 10
	}
	if "`explosion'" == "" {
		local explosion = 50
	}
	
	if "`fname'" == "" {
		local fname "movie"
	}
	
	local kplus = `k' + 1
	
	// Prepare titles
	gettoken title_text title_opt : titles, parse(",") bind	
	forvalues i = 1/`kplus' {
		gettoken title_next title_text : title_text, bind
		local title_`i' = substr("`title_next'",2,`=length("`title_next'") - 2')
	}

	// Prepare frames
	forvalues i = 1/`k' {		
		local next = `i' + 1
		if ("`size'" != ""){
			local firstsize: word `i' of `size'
			local secondsize: word `next' of `size'
		}
		if ("`color'" != ""){
			local firstcol: word `i' of `color'
			local secondcol: word `next' of `color'
		}
		if ("`symbol'" != ""){
			local firstsymb: word `i' of `symbol'
			local secondsymb: word `next' of `symbol'
		}
		if ("`edgesize'" != "")  {
			local firstedgesize : word `i' of `edgesize_check'
			local secondedgesize : word `next' of `edgesize_check'
		}
		if ("`edgecolor'" != "")  {
			local firstedgecol : word `i' of `edgecolor_check'
			local secondedgecol : word `next' of `edgecolor_check'
		}

		local firsttitle_pos = `i'
		local secondtitle_pos = `i' + 1
		local firsttitle `title_`firsttitle_pos''
		local secondtitle `title_`secondtitle_pos''

		local first : word `i' of `netname'
		local second : word `next' of `netname'
		local expnum = `i' * 100
		local st = string(`z',"%05.0f")
					
		noi di "{txt}Processing network {bf:`first'}"
		noi di `i'
		noi nwset
		if `i' == 1 {
			noi di "h1"
			noi di `"nwplot `first', generate(_c1_x _c1_y) size(`firstsize', norescale `sizeopt') symbol(`firstsymb', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(`firstcol', norescale forcekeys(`color_uniquevalues') `coloropt' ) edgesize(`firstedgesize') edgecolor(`firstedgecol') title("`firsttitle'"`title_opt') `options'"'

			noi nwplot `first', generate(_c1_x _c1_y) size(`firstsize', norescale `sizeopt') symbol(`firstsymb', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(`firstcol', norescale forcekeys(`color_uniquevalues') `coloropt' ) edgesize(`firstedgesize') edgecolor(`firstedgecol') title("`firsttitle'"`title_opt') `options'
			capture graph export `"`c(pwd)'/first`st'.`pic'"', replace `picopt'
			noi di "h2"
			if _rc != 0 {
				di "{err}No writing right for working directory. Try changing the working directory.{txt}"
				error
				exit
			}
		}
		else {
			noi di "h3"
			noi nwplot `first', generate(_c1_x _c1_y) size(`firstsize', norescale `sizeopt') symbol(`firstsymb', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(`firstcol',  norescale forcekeys(`color_uniquevalues') `coloropt') edgesize(`firstedgesize') edgecolor(`firstedgecol') title("`secondtitle'"`title_opt') `options'	
			qui graph export `"`c(pwd)'/frame`st'.`pic'"', replace `picopt'
		}
		noi di "h5"
		local st = string(`z',"%05.0f")
		qui graph export `"`c(pwd)'/frame`st'.`pic'"', replace `picopt'
		noi nwset
		qui nwplot `second', generate(_c2_x _c2_y) size(`secondsize', norescale `sizeopt') symbol(`secondsymb', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(`secondcol',  norescale forcekeys(`color_uniquevalues') `coloropt') edgesize(`secondedgesize') edgecolor(`secondedgecol') title("`secondtitle'"`title_opt') `options'	
		di "h6"
		local expnum = (`z' + `frames' + 2)
		local st = string(`expnum',"%05.0f")
		qui graph export `"`c(pwd)'/frame`st'.`pic'"', replace `picopt'
		local z = `z' + 2
		

		forvalues j = 1/`frames' {
			di "h7"
			// Network switch
			if "`switchnetwork'" == "start" {
				local framenet "second"
			}
			if "`switchnetwork'" == "end" {
				local framenet "first"
			}
			if "`switchnetwork'" == "half" {
				local framenet "second"
				if `j' <= `frames'/2 {
					local framenet "first"	
				}
			}
			
			// Color switch
			if "`switchcolor'" == "start" {
				local thirdcol "secondcol"
			}
			if "`switchcolor'" == "end" {
				local thirdcol "firstcol"
			}
			if "`switchcolor'" == "half" {
				local thirdcol secondcol
				if `j' <= `frames'/2 {
					local thirdcol "firstcol"	
				}
			}
			
			di "h8"

			// Symbol switch
			if "`switchsymbol'" == "start" {
				local thirdsymb "secondsymb"
			}
			if "`switchsymbol'" == "end" {
				local thirdsymb "firstsymb"
			}
			if "`switchsymbol'" == "half" {
				local thirdsymb secondsymb
				if `j' <= `frames'/2 {
					local thirdsymb "firstsymb"	
				}
			}
			
			di "h9"
			
			// Edgecolor switch
			if "`switchedgecolor'" == "start" {
				local thirdedgecol "secondedgecol"
			}
			if "`switchedgecolor'" == "end" {
				local thirdedgecol "firstedgecol"
			}
			if "`switchedgecolor'" == "half" {
				local thirdedgecol "secondedgecol"
				if `j' <= `frames'/2 {
					local thirdedgecol "firstedgecol"	
				}
			}
			
			// Title switch
			if "`switchtitle'" == "start" {
				local thirdtitle "secondtitle"
			}
			if "`switchtitle'" == "end" {
				local thirdtitle "firsttitle"
			}
			if "`switchtitle'" == "half" {
				local thirdtitle "secondtitle"
				if `j' <= `frames'/2 {
					local thirdtitle "firsttitle"	
				}
			}
			
			di "h10"
			
			if (mod(`j',5) == 0) noi display "   ...frame `j'/`frames'"
			local st = string(`z',"%05.0f")
			local f = `frames' + 1
			local steepness = `j' / `f'
			if "`explosion'" != "" {
				local steepness =  log( 1 + (`j'/`f' * `explosion')) / log(`explosion' + 1)
			}

			gen _frame_x = _c1_x - `steepness' * (_c1_x - _c2_x) 
			gen _frame_y = _c1_y - `steepness' * (_c1_y - _c2_y)
			
			local nx = "nodexy(_frame_x _frame_y)"
			if "`nodexy'" != "" {
				local nx = ""
			}
			
			di "h11"
	
			if ("`size'" != "" | "`edgesize'" != ""){
				if "`edgesize'" != "" {
					di "nwgenerate _frame_edgesize = round(`firstedgesize' - `steepness' * (`firstedgesize' - `secondedgesize'))"

					qui nwgenerate _frame_edgesize = round(`firstedgesize' - `steepness' * abs(`firstedgesize' - `secondedgesize')))
				}
				if "`size'" != "" {
					tempvar frame_size
					qui gen `frame_size' = `firstsize' - `steepness' * (`firstsize' - `secondsize')
					
					di `"nwplot ``framenet'', `nx'  symbol(``thirdsymb'', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(``thirdcol'', norescale forcekeys(`color_uniquevalues') `coloropt' ) size(`frame_size', norescale `sizeopt') edgesize(_frame_edgesize) edgecolor(``thirdedgecol'') title("``thirdtitle''"`title_opt') `options'"'
					qui nwplot ``framenet'', `nx'  symbol(``thirdsymb'', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(``thirdcol'', norescale forcekeys(`color_uniquevalues') `coloropt' ) size(`frame_size', norescale `sizeopt') edgesize(_frame_edgesize) edgecolor(``thirdedgecol'') title("``thirdtitle''"`title_opt') `options'
				}
				else {
					di `"nwplot ``framenet'', `nx'  symbol(``thirdsymb'', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(``thirdcol'',  norescale forcekeys(`color_uniquevalues') `coloropt' ) edgesize(_frame_edgesize) edgecolor(``thirdedgecol'') title("``thirdtitle''"`title_opt') `options'"'
			
					qui nwplot ``framenet'', `nx'  symbol(``thirdsymb'', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(``thirdcol'',  norescale forcekeys(`color_uniquevalues') `coloropt' ) edgesize(_frame_edgesize) edgecolor(``thirdedgecol'') title("``thirdtitle''"`title_opt') `options'
				}
			}
			else{
				qui nwplot ``framenet'', `nx'  symbol(``thirdsymb'', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(``thirdcol'', norescale forcekeys(`color_uniquevalues') `coloropt' ) edgecolor(``thirdedgecolor'') title("``thirdtitle''"`title_opt') `options' 
			}
			capture nwdrop _frame_edgesize
			
			di "h12"
			qui graph export `"`c(pwd)'/frame`st'.`pic'"', replace `picopt' 
			capture drop _frame_x _frame_y 
			capture drop `frame_size' `frame_edgesize'
			local z = `z' + 1
		}
		local i = `i' + 1
		if (`i'<=`k'){
			capture drop _c1_* _c2_*
		}
	}
	// get last frame to pause for some time before re-looping
	local st = string(`z',"%05.0f")
	if "`nodexy'" == "" {
		local nx "nodexy(_c2_x _c2_y)"
	}
	qui nwplot `second', `nx'  size(`secondsize', norescale `sizeopt') symbol(`secondsymb', norescale forcekeys(`symbol_uniquevalues') `symbolopt') color(`secondcol', norescale forcekeys(`color_uniquevalues') `coloropt') edgesize(`secondedgesize') edgecolor(`secondedgecol') title("`secondtitle'" `title_opt') `options'
	capture drop _c1_* _c2_*
	qui graph export `"`c(pwd)'/last`st'.`pic'"', replace `picopt'	
	
	di "Processing network {bf:`second'}"
	graph drop _all
	
	di "Rendering movie (please wait)..."


	local lastdelay = `delay' * `frames'
	local shellcmd = `""`impath'/convert" -delay `delay' -loop 0 `c(pwd)'/first*.`pic' `c(pwd)'/frame*.`pic' -delay `lastdelay' `c(pwd)'/last*.`pic' `c(pwd)'/`fname'.gif"'

	
	if c(os) == "MacOSX" {
		shell export PATH="$PATH:`:environ PATH':/usr/local/bin:/usr/bin:/opt/local/bin:/opt/ImageMagick/bin/:`imagick'/";`shellcmd'
		shell open `fname'.gif -a /Applications/Safari.app/ 
	}
	
	if c(os) == "Windows" {
		shell cmd /C `shellcmd'
		capture findfile `fname'.gif 
		if _rc == 0 {
			shell explorer `fname'.gif
		}
		else {
			di "{err}Animation could not be created."
			exit
		}
	}
	
	if "`keepfiles'" == "" {
		if c(os) == "Windows" {
			shell del frame*.*
			shell del last*.*
			shell del first*.*
		}
		else {
			shell rm first*.*
			shell rm frame*.*
			shell rm last*.*
		}
	}
end

capture program drop nwmovie_install_win
program nwmovie_install_win

	// check for ImageMagick
	local p : environ PATH
	tokenize `"`p'"', parse(";")
	local impath = ""
	while "`1'" != "" & "`impath'" == "" {
		capture findfile convert.exe, path("`1'")
		if _rc == 0 {
			local impath = "`1'"
			local imlow = lower("`impath'")
			local st = strpos(lower("`impath'"), "windows")
			if strpos("`imlow'", "windows") != 0 & "`impath'" == "" {
				local impath = ""
			}
		}
		macro shift
	}	
	if "`impath'" == "" {
		local imurl = "http://www.imagemagick.org/download/binaries/ImageMagick-6.9.0-4-Q16-x64-dll.exe"
		if c(bit) == 32 {
			local imurl = "http://www.imagemagick.org/download/binaries/ImageMagick-6.9.0-4-Q16-x86-dll.exe"
		}
		di "{err}ImageMagick not found."
		di `"{err}Please install {browse "`imurl'":ImageMagick from here first} or specify option {bf:imagick()}."'
		exit
	}
	mata: st_global("r(impath)", "`impath'")
end

capture program drop nwmovie_install_osx
program nwmovie_install_osx
	
	// check for ImageMagick
	local p = "`:environ PATH':/usr/local/bin:/usr/bin:/opt/local/bin:/bin:/opt/ImageMagick/bin/:/opt/ImageMagick"
	tokenize `"`p'"', parse(":")
	local impath = ""
	while "`1'" != "" & "`impath'" == "" {
		capture findfile convert, path("`1'")
		if _rc == 0 {
			local impath = "`1'"
		}
		macro shift
	}	
	
	
	if "`impath'" == "" {
		local imurl = "http://cactuslab.com/imagemagick/assets/ImageMagick-6.9.0-0.pkg.zip"
		di "{err}ImageMagick not found."
		di `"{err}Please install {browse "`imurl'": ImageMagick from here first} or specify option {bf:imagick()}."'
		error 6999
	}
	
	/*
	if "`impath'" == "" {
		set more off
		tempname nwmovie_sh
		capture findfile nwmovie.command
		if _rc != 0 {
			file open `nwmovie_sh' using nwmovie.command, write
			file write `nwmovie_sh' "if which brew >/dev/null; then" _n
			file write `nwmovie_sh' `"echo "Homebrew found""' _n
			file write `nwmovie_sh' "	else " _n
			file write `nwmovie_sh' "	/bin/mkdir /usr/local " _n
			file write `nwmovie_sh' "	curl -L https://github.com/Homebrew/homebrew/tarball/master  | tar xz --strip 1 -C /usr/local" _n
			file write `nwmovie_sh' "fi" _n
			file write `nwmovie_sh' "if which convert >/dev/null; then" _n
			file write `nwmovie_sh' `"	echo "ImageMagic found""' _n
			file write `nwmovie_sh' "else" _n
			file write `nwmovie_sh' "	brew install ImageMagick" _n
			file write `nwmovie_sh' "fi" _n
			file write `nwmovie_sh' "if which gs >/dev/null; then" _n
			file write `nwmovie_sh' `"	echo "Ghostscript found""' _n
			file write `nwmovie_sh' "else"_n
			file write `nwmovie_sh' "	brew install ghostscript" _n
			file write `nwmovie_sh' "fi" _n
			file write `nwmovie_sh' "exit"
			file close `nwmovie_sh'
		}
		shell chmod u+x nwmovie.command
		shell open /Applications/Utilities/Terminal.app/ nwmovie.command
		
		local p = "`:environ PATH':/usr/local/bin:/usr/bin:/opt/local/bin:/bin:"
		tokenize `"`p'"', parse(":")
		local impath = ""
		while "`1'" != "" & "`impath'" == "" {
			capture findfile convert, path("`1'")
			if _rc == 0 {
				local impath = "`1'"
			}
			macro shift
		}
	}
	else {
		di ""
		di "{txt}Checking third party software:"
		di "{txt}...ImageMagick found"
	} */
	
	mata: st_global("r(impath)", "`impath'")
end


		
		
	
