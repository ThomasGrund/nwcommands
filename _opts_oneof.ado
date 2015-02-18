capture program drop _opts_oneof
program _opts_oneof
        version 8.2

        args opts optname selectopt errcode

        local opts = trim("`opts'")     // to trim leading and trailing spaces

		local s = wordcount("`opts'")
		local found = 0
		forvalues i=1/`s'{
			local oneopt = word("`opts'", `i')
			if "`oneopt'" == "`selectopt'" {
				local found = 1
			}
        }
		local opts = subinstr("`opts'"," ",",",.)

        if `found' == 1{ // no error message or return code 
                exit
        }
		di in smcl as err `"option {it:`optname'}{bf:(`selectopt')} invalid; only one of {bf:`opts'} is allowed"'
        if `"`errcode'"' != "" {
                exit `errcode'
        }
        else {
                exit 198
        }
end
