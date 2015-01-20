*! Date        : 7sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwmovie
program nwmovie
	syntax anything(name=netname), [z(integer 1) imagick(string) keepeps fname(string) explosion(string) titles(string) delay(string) size(varlist) color(varlist) symbol(varlist) edgecolor(string) edgesize(string) frames(integer 20)*]


	if c(os) == "MacOSX" {
		nwmovie_install_osx
	}
	
	if c(os) == "Windows" {
		nwmovie_install_win
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
		local s : word count `size'
		if `s' != `k' {
			di "{err}option {bf:size()} needs to have as many variables as networks to be plotted"
		}
	}
	if ("`color'" != ""){
		local s : word count `color'
		if `s' != `k' {
			di "{err}option {bf:color()} needs to have as many variables as networks to be plotted"
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
		if `i' == 1 {
			qui nwplot `first', generate(_c1_x _c1_y) size(`firstsize') symbol(`firstsymb', norescale forcekeys(`symbol_uniquevalues')) color(`firstcol', norescale forcekeys(`color_uniquevalues')) edgesize(`firstedgesize') edgecolor(`firstedgecol') title("`firsttitle'"`title_opt') `options'	
			qui graph export `c(pwd)'/first`st'.eps, replace mag(200) logo(on)
		}
		else {
			qui nwplot `first', generate(_c1_x _c1_y) size(`firstsize') symbol(`firstsymb', norescale forcekeys(`symbol_uniquevalues')) color(`firstcol', norescale forcekeys(`color_uniquevalues')) edgesize(`firstedgesize') edgecolor(`firstedgecol') title("`secondtitle'"`title_opt') `options'	
			qui graph export `c(pwd)'/frame`st'.eps, replace mag(200) logo(on)
		}
		local st = string(`z',"%05.0f")
		qui graph export `c(pwd)'/frame`st'.eps, replace mag(200) logo(on)
		qui nwplot `second', generate(_c2_x _c2_y) size(`secondsize') symbol(`secondsymb', norescale forcekeys(`symbol_uniquevalues')) color(`secondcol', norescale forcekeys(`color_uniquevalues')) edgesize(`secondedgesize') edgecolor(`secondedgecol') title("`secondtitle'"`title_opt') `options'	
		local expnum = (`z' + `frames' + 2)
		local st = string(`expnum',"%05.0f")
		qui graph export `c(pwd)'/frame`st'.eps, replace mag(200) logo(on)		
		local z = `z' + 2
		

		forvalues j = 1/`frames' {
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
			
			local thirdtitle "`firsttitle'" 
			local thirdcol "`firstcol'"
			local thirdsymb "`firstsymb'"
			local thirdedgecol "`firstedgecol'"
	
			if ("`size'" != "" | "`edgesize'" != ""){
				if "`edgesize'" != "" {
					qui nwgenerate _frame_edgesize = round(`firstedgesize' - `steepness' * (`firstedgesize' - `secondedgesize'))
				}
				if "`size'" != "" {
					tempvar frame_size
					qui gen `frame_size' = `firstsize' - `steepness' * (`firstsize' - `secondsize')
					qui nwplot `second', `nx' symbol(`thirdsymb', norescale forcekeys(`symbol_uniquevalues')) color(`thirdcol', norescale forcekeys(`color_uniquevalues')) size(`frame_size') edgesize(_frame_edgesize) edgecolor(`thirdedgecol') title("`firsttitle'"`title_opt') `options'
				}
				else {
					qui nwplot `second', `nx' symbol(`thirdsymb', norescale forcekeys(`symbol_uniquevalues')) color(`thirdcol', norescale forcekeys(`color_uniquevalues')) edgesize(_frame_edgesize) edgecolor(`thirdedgecol') title("`thirdtitle'"`title_opt') `options'
				}
			}
			else{
				qui nwplot `second', `nx' symbol(`thirdsymb', norescale forcekeys(`symbol_uniquevalues')) color(`thirdcol', norescale forcekeys(`color_uniquevalues')) edgecolor(`thirdedgecolor') title("`thirdtitle'"`title_opt') `options' 
			}
			capture nwdrop _frame_edgesize
			
			qui graph export `c(pwd)'/frame`st'.eps, replace mag(200) logo(on)
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
	qui nwplot `second', `nx' size(`secondsize') symbol(`secondsymb', norescale forcekeys(`symbol_uniquevalues')) color(`secondcol', norescale forcekeys(`color_uniquevalues')) edgesize(`secondedgesize') edgecolor(`secondedgecol') title("`secondtitle'" `title_opt') `options'
	capture drop _c1_* _c2_*
	qui graph export `c(pwd)'/last`st'.eps, replace mag(200) logo(on)		
	
	di "Processing network {bf:`second'}"
	di 
	graph drop _all
	
	di "Rendering movie..."

	//shell convert frame*.eps -transparent white frame*.gif
	local lastdelay = `delay' * `frames'


	local shellcmd = "convert -delay `delay' -loop 0 `c(pwd)'/first*.eps `c(pwd)'/frame*.eps -delay `lastdelay' `c(pwd)'/last*.eps `c(pwd)'/`fname'.gif"
	
	if c(os) == "MacOSX" {
		shell export PATH="$PATH:/usr/local/bin:/usr/bin:/opt/local/bin:/opt/ImageMagick/bin/:`imagick'/";`shellcmd'
		shell open `fname'.gif -a /Applications/Safari.app/ 
	}
	
	if "`keepeps'" == "" {
		if c(os) == "Windows" {
			shell del frame*.*
			shell del last*.*
		}
		else {
			shell rm first*.*
			shell rm frame*.*
			shell rm last*.*
		}
	}
end


capture program drop nwmovie_install_osx
program nwmovie_install_osx
	tempname nwmovie_sh
	capture findfile nwmovie.command
	set more off
	if _rc != 0 {
		file open `nwmovie_sh' using nwmovie.command, write
		file write `nwmovie_sh' "if which brew >/dev/null; then" _n
		file write `nwmovie_sh' `"echo "Homebrew found""' _n
		file write `nwmovie_sh' "	else " _n
		file write `nwmovie_sh' "	/bin/mkdir /usr/local " _n
		file write `nwmovie_sh' "	curl -L https://github.com/Homebrew/homebrew/tarball/master  | sudo tar xz --strip 1 -C /usr/local" _n
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
		shell export PATH="$PATH:/usr/local/bin:/usr/bin:/opt/local/bin:/bin:`c(pwd)'";chmod +x nwmovie.command
	}
	shell export PATH="$PATH:/usr/local/bin:/usr/bin:/opt/local/bin"; nwmovie.command
	exit
end


		
		
	
