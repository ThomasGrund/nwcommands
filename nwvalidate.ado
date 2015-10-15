//!! Deprecated

capture program drop nwvalidate
program nwvalidate
	syntax anything(name=netname) [, self(string) ]
	unw_defs
	
	local netname = strtoname("`netname'",1)
	local valid = "false"
	
	local prefix = ""
	local p = 1
	
	mata: st_global("r(tryname)", "`netname'")
	mata: st_global("r(validname)", `nws'.get_valid_name("`netname'"))
	
	if r(tryname) != r(validname) {
		mata: st_global("r(exists)", "true")
	}
	else {
		mata: st_global("r(exists)", "false")
	}
end

