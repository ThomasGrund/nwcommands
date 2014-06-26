capture program drop nwuse_pajek
program nwuse_pajek
	version 9
	syntax anything(name=filename), [ clear replace ]
	
	if ("`nwclear'" != "") {
		local _rc = 0
		while (_rc==0){
			capture nwcurrent
			capture nwdrop `r(current)'
		}
	}
	di "{txt}Loading data {it:`filename'}"
	
	if ("`nwclear'" != "") local clear "clear"
	use `filename', `clear' `replace'
	
	local fname = regexr(`"`filename'"',".dta","")
	scalar onefname  = `"`fname'"'
	local localfname `=onefname'
	capture confirm file "`localfname'.nws"
	if _rc != 0 {
		di "{err}No network session `localfname'.nws found."
		error 6066
	}
	
	local temp = subinstr(`"`fname'"',"\","/",.)
	capture local temp_rev = reverse("`temp'")
	if _rc != 0 {
		capture local temp_rev = reverse(`temp')
	}
	local temp_index = strpos("`temp_rev'", "/")
	local path = ""
	local session `"`fname'"'
	if (`temp_index' > 0){
		scalar onefname  = `"`fname'"'
		local localfname `=onefname'
		local temp_end = length("`localfname'") - `temp_index'
		local path = substr("`localfname'",1,`temp_end')
		local session = substr("`localfname'", `=`temp_end'+ 2 ',.)
	}		
		
	nwimport, session(`session') path(`path') `clear' `replace'
end

