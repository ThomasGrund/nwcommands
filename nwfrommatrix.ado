capture program drop nwfrommatrix
program nwfrommatrix
	syntax varlist(min=2) [, xvars name(string) labs(string) label(varname) vars(string) stub(string) directed undirected]

	local nodes : word count `varlist'
	
	if `nodes' > _N {
		di "{err}input data has wrong dimensions and is not square"
		error 6101
	}
	
	if "`name'" == "" {
		local name "network"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	
	nwvalidate `name'
	local edgename = r(validname)
	local varscount : word count `vars'
	
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(`stub')
		local matvars "$validvars"
		
	}
	else {
		local matvars "`vars'"
	}
	
	if "`label'" == "" & "`labs'" == ""{
		qui ds `varlist'
		local labs "`r(varlist)'"
	}
	else if "`labs'" == ""{
		local labs ""
		forvalues i = 1/`nodes'{
			local newlab = `label'[`i']
			local labs "`labs' `newlab'"
		}
	}
	
	
	// Set the new network
	nwset `varlist', name(`edgename') vars(`matvars') labs(`labs') 
	qui drop _all
	if "`xvars'" == "" {
		qui nwload
	}
	if "`directed'" == "" {
		nwsym, check 
		if "`r(is_symmetric)'" == "true" {
			nwsym
		}
	}
	if "`undirected'" != "" {
		nwsym
	}
	
	di 
	di "{txt}{it:Loading successful}"
	nwsummary
end
