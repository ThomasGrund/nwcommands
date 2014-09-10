capture program drop _nwdeploy
program _nwdeploy
	
	file open deploy_ado using nwcommands-ado.pkg, replace write
	file write deploy_ado "v 3" _n
	file write deploy_ado "d nwcommands-ado. Social Network Analysis Using Stata" _n
	file write deploy_ado "d Thomas U. Grund and Peter Hedström, Linköping University, www.liu.se/ias" _n
	file write deploy_ado "d email: contact@nwcommands.org" _n
	local d = lower(subinstr(c(current_date)," ","",.))
	file write deploy_ado "d Distribution-Date: `d'" _n
	
	local adofiles : dir "`c(pwd)'" files "*.ado"
	foreach file in `adofiles' {
		file write deploy_ado "f `file'" _n
	}
	local dtafiles : dir "`c(pwd)'" files "*.dta"
	foreach file in `dtafiles' {
		file write deploy_ado "f `file'" _n
	}
	local netfiles : dir "`c(pwd)'" files "*.net"
	foreach file in `netfiles' {
		file write deploy_ado "f `file'" _n
	}
	file close deploy_ado
	
	
	file open deploy_hlp using nwcommands-hlp.pkg, replace write
	file write deploy_hlp "v 3" _n
	file write deploy_hlp "d nwcommands-ado. Social Network Analysis Using Stata - Help Files" _n
	file write deploy_hlp "d Thomas U. Grund and Peter Hedström, Linköping University, www.liu.se/ias" _n
	file write deploy_hlp "d email: contact@nwcommands.org" _n
	local d = lower(subinstr(c(current_date)," ","",.))
	file write deploy_hlp "d Distribution-Date: `d'" _n
	
	local hlpfiles : dir "`c(pwd)'" files "*.sthlp"
	foreach file in `hlpfiles' {
		file write deploy_hlp "f `file'" _n
	}
	file close deploy_hlp
end
