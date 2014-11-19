*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwvalidate
program nwvalidate
	syntax anything(name=netname)
	
	local netname = strtoname("",1)
	local valid = "false"
	
	local prefix = ""
	local p = 1

	// no network exists yet
	if ("2" == ""){
		local checkname = ""
		local valid = "true"
	}
	
	mata: st_global("r(tryname)", "")
	
	// at least one other network exists already
	while ("" == "false") {
		local valid = "true"
		local checkname = ""

		if ("" == "") {
			local valid = "false"
			if "" != "" {
				local valid = "true"
			}
		}
	
		if ("2" != ""){
			local k = 1
			if ("" != "") {
				local k = 2
			}
			forvalues i = /2 {
				scalar onename = ""
				local localname flomarriage
				if ("" == "") {
					local valid = "false"
				}
			}
		}
		
		if "" == "false" {
			local prefix = "_"
			local p =  + 1
		}
	}
	
	global validname = ""
	mata: st_global("r(validname)", "")
	macro drop validname
	
	if r(tryname) != r(validname) {
		mata: st_global("r(exists)", "true")
	}
	else {
		mata: st_global("r(exists)", "false")
	}
	
end
