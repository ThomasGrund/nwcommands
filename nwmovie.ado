*! Date        : 11feb2015
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwmovie
program nwmovie
	syntax anything(name=netname), [z(integer 1) title(string) edgecolor(string) edgesize(string) size(string) symbol(string) color(string) switchtitle(string) switchnetwork(string) switchcolor(string) switchsymbol(string) switchedgecolor(string) imagick(string) eps keepfiles width(integer 750) height(integer 500) fname(string) explosion(integer 5) labels(string) titles(string) delay(string) sizes(varlist) colors(string) symbols(varlist) edgecolors(string) edgesizes(string) frames(integer 10) *]

	_nwsyntax `netname', max(999) min(2)
	 
	if "`fname'" == "" {
		if c(os) == "Windows" {
			local fname "`c(pwd)'\movie"
		}
		if c(os) == "MacOSX" {
			local fname "`c(pwd)'/movie"
		}
	}
	
	local old_options `options'
	if "`color'" != "" {
		gettoken color1 colorpt1 : color, parse(",")
		if "`color1'" == "," {
			local color1 ""
			local coloropt1 ", `coloropt1'"
		}
		local colors ""
		forvalues i = 1/`networks' {
			local colors "`colors' `color1'"
		}
		local colors "`colors', `coloropt1'"
	}
	
	if "`symbol'" != "" {
		gettoken symbol1 symbolopt1 : symbol, parse(",")
		if "`symbol1'" == "," {
			local symbol1 ""
			local symbolopt1 ", `symbolopt1'"
		}
		local symbols ""
		forvalues i = 1/`networks' {
			local symbols "`symbols' `symbol1'"
		}
		local symbols "`symbols', `symbolopt1'"
	}

	if "`size'" != "" {
		gettoken size1 sizeopt1 : size, parse(",")
		if "`size1'" == "," {
			local size1 ""
			local sizeopt1 ", `sizeopt1'"
		}
		local size ""
		forvalues i = 1/`networks' {
			local sizes "`sizes' `size1'"
		}
		local sizes "`sizes', `sizeopt1'"
	}
	
	if "`edgesize'" != "" {
		gettoken edgesize1 edgesizeopt1 : edgesize, parse(",")
		if "`edgesize1'" == "," {
			local edgesize1 ""
			local edgesize1 ", `edgesize1'"
		}
		local edgesize ""
		forvalues i = 1/`networks' {
			local edgesizes "`edgesizes' `edgesize1'"
		}
		local edgesizes "`edgesizes', `edgesizeopt1'"
	}
	
	if "`edgecolor'" != "" {
		gettoken edgecolor1 edgecoloropt1 : edgecolor, parse(",")
		if "`edgecolor1'" == "," {
			local edgecolor1 ""
			local edgecolor1 ", `edgecolor1'"
		}
		local edgecolor ""
		forvalues i = 1/`networks' {
			local edgecolors "`edgecolors' `edgecolor1'"
		}
		local edgecolors "`edgecolors', `edgecoloropt1'"
	}	
	
	if "`title'" != "" {
		local titles "`title'"
	}
	
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
	// rule out layout_sub_options
	if "`layout'" != "" {
		gettoken layout l1: layout, parse(",")
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
	local all_nets "`netname'"
	
	local sizeCheck = 0
	qui foreach onenet in `all_nets' {
		_nwsyntax_other `onenet'
		if `sizeCheck' == 0 {
			local sizeCheck = `othernodes'
		}
		else {
			if `sizeCheck' != `othernodes' {
				noi di "{err}Networks need to be of the same size"
				error 6055
			}
		}
	}
	_nwsyntax `all_nets', max(999) min(2)
	local k : word count `netname'
	
	// check and clean networks as edgecolor and edgesize
	local 0 `edgesizes'
	syntax [anything(name=edgesizes)], [*]
	local edgesizeopt `options'
	_nwsyntax_other `edgesizes', exactly(`networks') nocurrent
	local edgesize_check "`othernetname'"
	
	local 0 `edgecolors'
	syntax [anything(name=edgecolors)], [*]
	local edgecoloropt `options'
	local othernetname = ""
	_nwsyntax_other `edgecolors', exactly(`networks') nocurrent
	local edgecolor_check "`othernetname'"
	
	capture drop _c1_* 
	capture drop _c2_*
	capture drop _frame_*

	set more off
	local applysize = 0
	
	if ("`sizes'" != ""){
		local 0 `sizes'
		syntax [varlist(default=none)], [*]
		local sizes `varlist'
		local sizeopt "`options' legendoff"	
		local s : word count `sizes'
		/*if `s' != `k' {
			di "{err}Option {bf:sizes()} needs to have as many variables as networks to be plotted"
		}*/
	}
	if ("`colors'" != ""){
		local 0 `colors'
		syntax [varlist(default=none)], [*]
		local colors `varlist'
		local coloropt `options'	
		local s : word count `colors'
		/*if `s' != `k' {
			di "{err}Option {bf:colors()} needs to have as many variables as networks to be plotted"
		}*/
		
		local color_uniquevalues ""
		foreach color_time in `colors' {
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
		
	if ("`symbols'" != ""){
		local 0 `symbols'
		syntax [varlist(default=none)], [*]
		local symbols `varlist'
		local symbolopt `options'
		local s : word count `symbols'
		/*if `s' != `k' {
			di "{err}option {bf:symbols()} needs to have as many variables as networks to be plotted"
		}*/
		local symbol_uniquevalues ""
		foreach symbol_time in `symbols' {
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
	if `explosion' < 1 {
		local explosion = 1
	}
	
	if "`fname'" == "" {
		local fname "movie"
	}
	
	local kplus = `k' + 1
	
	// Prepare titles
	gettoken title_text title_opt : titles, parse(",")  quotes
	forvalues i = 1/`kplus' {
		gettoken title_next title_text : title_text, parse("|") 
		local title_text = substr(`"`title_text'"',2,.)
		local title_`i' = "`title_next'"
	}

	// Prepare frames
	forvalues i = 1/`k' {		
		local next = `i' + 1
		if ("`titles'" != ""){
			local firsttitle_pos = `i'
			local secondtitle_pos = `i' + 1
			local firsttitle `title_`firsttitle_pos''
			local secondtitle `title_`secondtitle_pos''
			local titlecmd1 `"title("`firsttitle'" `title_opt') "'
			local titlecmd2 `"title("`secondtitle'" `title_opt') "'
		}
		if ("`sizes'" != ""){
			local firstsize: word `i' of `sizes'
			local secondsize: word `next' of `sizes'
			local sizecmd1 `"size(`firstsize', norescale `sizeopt')"'
			local sizecmd2 `"size(`secondsize', norescale `sizeopt')"'
			local sizecmd3 `"size(`frame_size', norescale `sizeopt')"'
		}
		if ("`colors'" != ""){
			local firstcol: word `i' of `colors'
			local secondcol: word `next' of `colors'
			local colorcmd1 `"color(`firstcol', norescale `coloropt' )"' //forcekeys(`color_uniquevalues')
			local colorcmd2 `"color(`secondcol', norescale  `coloropt' )"'
		}
		if ("`symbols'" != ""){
			local firstsymb: word `i' of `symbols'
			local secondsymb: word `next' of `symbols'
			local symbolcmd1 `"symbol(`firstsymb', norescale  `symbolopt')"' //forcekeys(`symbol_uniquevalues')
			local symbolcmd2 `"symbol(`secondsymb', norescale  `symbolopt')"'
		}
		if ("`edgesizes'" != "")  {
			local firstedgesize : word `i' of `edgesize_check'
			local secondedgesize : word `next' of `edgesize_check'
			local edgesizecmd1 `"edgesize(`firstedgesize', legendoff)"'
			local edgesizecmd2 `"edgesize(`secondedgesize', legendoff)"'
			local edgesizecmd3 `"edgesize(_frame_edgesize, legendoff)"'
		}

		if ("`edgecolors'" != "" | "`edgecoloropt'" != "")  {
			local firstedgecol : word `i' of `edgecolor_check'
			local secondedgecol : word `next' of `edgecolor_check'
			local edgecolorcmd1 `"edgecolor(`firstedgecol', `edgecoloropt')"'
			local edgecolorcmd2 `"edgecolor(`secondedgecol', `edgecoloropt')"'
		}

		local first : word `i' of `netname'
		local second : word `next' of `netname'
		local expnum = `i' * 100
		local st = string(`z',"%05.0f")
		
		noi di "{txt}Processing network {bf:`first'}"
		if `i' == 1 {
			qui nwplot `first', ignorelgc generate(_c1_x _c1_y) `sizecmd1' `symbolcmd1' `colorcmd1'  `edgesizecmd1' `edgecolorcmd1' `titlecmd1' `options'
			capture graph export `"`c(pwd)'/first`st'.`pic'"', replace `picopt'
			if _rc != 0 {
				noi di "{err}No writing right for working directory. Try changing the working directory.{txt}"
				exit
			}
		}
		else {
			qui nwplot `first', ignorelgc generate(_c1_x _c1_y) `sizecmd1' `symbolcmd1' `colorcmd1'  `edgesizecmd1' `edgecolorcmd1' `titlecmd1'  `options'	
			qui graph export `"`c(pwd)'/frame`st'.`pic'"', replace `picopt'
		}
		local st = string(`z',"%05.0f")
		qui graph export `"`c(pwd)'/frame`st'.`pic'"', replace `picopt'
		qui nwplot `second', ignorelgc generate(_c2_x _c2_y) `sizecmd2' `symbolcmd2'  `colorcmd2' `edgesizecmd2' `edgecolorcmd2' `titlecmd2' `options'	
		local expnum = (`z' + `frames' + 2)
		local st = string(`expnum',"%05.0f")
		qui graph export `"`c(pwd)'/frame`st'.`pic'"', replace `picopt'
		local z = `z' + 2

		forvalues j = 1/`frames' {			
	
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
			if "`sizes'" != "" {
				tempvar frame_size
				qui gen `frame_size' = `firstsize' - `steepness' * (`firstsize' - `secondsize')
			}
			
			if "`edgecoloropt'" != "" {
				local edgecomma ","
			}
			if "`edgesize'" != "" {
				nwgenerate _frame_edgesize = round(`firstedgesize' - `steepness' * (`firstedgesize' - `secondedgesize'))
				qui nwplot ``framenet'', ignorelgc `nx' symbol(``thirdsymb'', norescale `symbolopt')  color(``thirdcol'', norescale  `coloropt' ) size(`frame_size', norescale `sizeopt') edgesize(_frame_edgesize, legendoff) edgecolor(``thirdedgecol'' `edgecomma' `edgecoloropt') title("``thirdtitle''" `title_opt')  `options'
			}
			else {
				qui nwplot ``framenet'', ignorelgc `nx'  symbol(``thirdsymb'', norescale  `symbolopt') color(``thirdcol'', norescale  `coloropt' )  size(`frame_size', norescale  `sizeopt') edgecolor(``thirdedgecol'' `edgecomma' `edgecoloropt') title("``thirdtitle''" `title_opt')  `options'
			}
			
			/*
			if ("`size'" != "" | "`edgesize'" != ""){
				if "`edgesize'" != "" {
					nwgenerate _frame_edgesize = round(`firstedgesize' - `steepness' * (`firstedgesize' - `secondedgesize'))
				}
				if "`size'" != "" {
					tempvar frame_size
					qui gen `frame_size' = `firstsize' - `steepness' * (`firstsize' - `secondsize')
					qui nwplot ``framenet'', `nx'  `symbolcmd3'  `colorcmd3' size(`frame_size', norescale `sizeopt') `edgesizecmd3' `edgecolorcmd3' title("``thirdtitle''" `title_opt')  `options'
				}
				else {
					qui nwplot ``framenet'', `nx'  `symbolcmd3' `colorcmd3' `edgesizecmd3' `edgecolorcmd3' title("``thirdtitle''" `title_opt')  `options'
				}
			}
			else{
				qui nwplot ``framenet'', `nx'  `symbolcmd3' `colorcmd3'  `edgecolorcmd3' title("``thirdtitle''" `title_opt')  `options' 
			}*/
			capture nwdrop _frame_edgesize
			capture graph export `"`c(pwd)'/frame`st'.`pic'"', replace `picopt'
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
	qui nwplot `second', ignorelgc `nx'  `sizecmd2' `symbolcmd2' `colorcmd2'  `edgesizecmd2' `edgecolorcmd2' `titlecmd2' `options'
	capture drop _c1_* _c2_*
	qui graph export `"`c(pwd)'/last`st'.`pic'"', replace `picopt'	
	
	di "Processing network {bf:`second'}"
	graph drop _all
	
	di "Rendering movie (please wait)..."


	local lastdelay = `delay' * `frames'
	local shellcmd `""`impath'/convert" -delay `delay' -loop 0 "`c(pwd)'/first*.`pic'" "`c(pwd)'/frame*.`pic'" -delay `lastdelay' "`c(pwd)'/last*.`pic'" "`fname'.gif""'

	
	if c(os) == "MacOSX" {
		shell export PATH="$PATH:`:environ PATH':/usr/local/bin:/usr/bin:/opt/local/bin:/opt/ImageMagick/bin/:`imagick'/";`shellcmd'
		shell open "`fname'.gif" -a /Applications/Safari.app/ 
	}
	
	if c(os) == "Windows" {
		nwmovie_install_win
		shell "`r(impath)'\convert.exe" -delay 10 -loop 0 "`c(pwd)'\first*.png" "`c(pwd)'\frame*.png" -delay 20 "`c(pwd)'\last*.png" "`fname'.gif"
		shell explorer.exe "`fname'.gif"
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
			local st = strpos("`imlow'", "windows")
			if (`st' != 0 & "`impath'" != ""){
				local impath = ""
			}
		}
		macro shift
	}	
	if "`impath'" == "" {
		local imurl = "http://www.imagemagick.org/script/binary-releases.php#windows"
		di "{err}ImageMagick not found."
		di `"{err}Please install {browse "`imurl'":ImageMagick from here first} or specify option {bf:imagick()}."'
		error 
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
		local imurl = "http://cactuslab.com/imagemagick/"
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


		
		
	
