capture program drop _nwdeploy
program _nwdeploy
	
	tempname deploy_ado
	file open `deploy_ado' using "`c(pwd)'\nwcommands-ado.pkg", replace write
	file write `deploy_ado' "v 3" _n
	file write `deploy_ado' "d nwcommands-ado. Social Network Analysis Using Stata" _n
	file write `deploy_ado' "d Thomas U. Grund and Peter Hedström, Linköping University, www.liu.se/ias" _n
	file write `deploy_ado' "d email: contact@nwcommands.org" _n
	local d = lower(subinstr(c(current_date)," ","",.))
	file write `deploy_ado' "d Distribution-Date: `d'" _n
	
	local adofiles : dir "`c(pwd)'" files "*.ado"
	tempname alphabetical
	file open `alphabetical' using nw_alphabetical.sthlp, replace write
	file write `alphabetical' "{smcl}" _n ///	
			"{* *! version 1.0.0  3sept2014}{...}"  _n ///
		    "{cmd:help nw_alphabetical}" _n ///
            "{hline}" _n ///
			"{phang}" _n ///
			"{manlink NW-3 intro} {hline 2} alphabetical list of {it:nwcommands}" _n ///
			" "_n ///
			"{col 5}{hline}" _n ///
			"{p2colset 5 32 34 2}" 
set more off
	foreach file in `adofiles' {
		local cmdname = substr("`file'", 1, `=(length("`file'") - 4)') 
		getcmddesc `cmdname'
		file write `deploy_ado' "f `file'" _n
		file write `alphabetical' "{p2col:{bf:{help `cmdname' }}}`r(cmddesc)'{p_end}" _n		
	}
	file close `alphabetical'
	
	local dtafiles : dir "`c(pwd)'" files "*.dta"
	foreach file in `dtafiles' {
		file write `deploy_ado' "f `file'" _n
	}
	local netfiles : dir "`c(pwd)'" files "*.net"
	foreach file in `netfiles' {
		file write `deploy_ado' "f `file'" _n
	}
	file close `deploy_ado'
	
	
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

capture program drop getcmddesc
program getcmddesc, rclass
	syntax anything(name=cmd)
	capture findfile `cmd'.sthlp
	if _rc != 0 {
		return local cmddesc = "{err}no help file yet{txt}"
		exit
	}
	else {
		tempname cmdsthlp
		file open `cmdsthlp' using `cmd'.sthlp, read		
		file read `cmdsthlp' line
		local found = 0
		while (r(eof)==0 & `found' == 0) {
			local j = strpos("`line'", "{hline 2}}")
			if (`j' >0) {
                local cmddesc = substr(`"`line'"', `=`j' + 10', `=`=length("`line'")' - 16 - `j'')
				local found = 1		
            }
			file read `cmdsthlp' line
		}
		return local cmddesc = "`cmddesc'"
	}
	file close `cmdsthlp'
end
