capture program drop nwsave_pajek
program nwsave_pajek
	version 9
	syntax anything(name=filename), [ replace * ]
	
	save `filename', `replace' `options'

	local fname = regexr(`"`filename'"',".dta","")
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
	nwexport _all, session(`session') path(`path') `replace'
end
