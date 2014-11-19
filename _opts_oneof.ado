*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop _opts_oneof
program _opts_oneof
        version 8.2

        args opts optname selectopt errcode

        local opts = trim("")     // to trim leading and trailing spaces

		local s = wordcount("")
		local found = 0
		forvalues i=1/{
			local oneopt = word("", )
			if "" == "" {
				local found = 1
			}
        }
		local opts = subinstr(""," ",",",.)

        if  == 1{ // no error message or return code 
                exit
        }
		di in smcl as err `"option {bf:()} invalid; only one of {bf:} is allowed"'
        if `""' != "" {
                exit 
        }
        else {
                exit 198
        }
end
