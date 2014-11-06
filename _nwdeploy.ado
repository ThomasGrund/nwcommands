capture program drop _nwdeploy
program _nwdeploy
	
	tempname deploy_ado
	file open `deploy_ado' using nwcommands-ado.pkg, replace write
	file write `deploy_ado' "v 3" _n
	file write `deploy_ado' "d nwcommands-ado. Social Network Analysis Using Stata" _n
	file write `deploy_ado' "d Thomas U. Grund and Peter Hedström, Linköping University, www.liu.se/ias" _n
	file write `deploy_ado' "d email: contact@nwcommands.org" _n
	local d = lower(subinstr(c(current_date)," ","",.))
	file write `deploy_ado' "d Distribution-Date: `d'" _n
	
	local adofiles : dir "`c(pwd)'" files "*.ado"
	local sthlpfiles : dir "`c(pwd)'" files "*.sthlp"
	
	// generate topical glossary help
	tempname memhold
	tempfile topics
	postfile `memhold' str30 cmdname str40 link str30 topic using `topics'
	foreach file in `sthlpfiles' {
		local cmdname = substr("`file'", 1, `=(length("`file'") - 6)') 
		getcmdtopic `cmdname'
		if "`r(cmdtopic)'" != "" {
			post `memhold' ("`cmdname'") ("`r(topiclink)'") ("`r(cmdtopic)'")
		}
		if "`r(cmdtopic2)'" != "" {
			post `memhold' ("`cmdname'") ("`r(topiclink2)'") ("`r(cmdtopic2)'")
		}
	}
	postclose `memhold'

	preserve
	use `topics', clear
	sort topic cmdname
	
	tempname topical
	file open `topical' using nw_topical.sthlp, replace write
	file write `topical' "{smcl}" _n ///	
			"{* *! version 1.0.0  3sept2014}{...}"  _n ///
		    "{cmd:help nw_topical}" _n ///
            "{hline}" _n ///
			"{phang}" _n ///
			"{manlink NW-2 intro} {hline 2} topical list of {it:nwcommands}" _n ///
			" "_n ///
			"{col 5}{hline}" _n ///
			"{p2colset 5 32 34 2}"  _n ///
			"" _n ///
			"{title:Contents}"_n ///
			"" _n ///
			"{pstd}" _n ///
			"An alphabetical index of all {it:nwcommands} is available in" _n ///
			"{bf:{help nw_alphabetical:[NW-3] intro}}. There are some general categories:"_n ///
			""_n ///
			"{pstd}"_n ///
			"{bf:{help nw_topical##concept:[NW-2.1] Concepts}}{p_end}"_n ///
			"{pstd}"_n ///
			"{bf:{help nw_topical##import:[NW-2.2] Import/Export}}{p_end}"_n ///
			"{pstd}"_n ///
			"{bf:{help nw_topical##generator:[NW-2.3] Generators}}{p_end}"_n ///
			"{pstd}"_n ///
			"{bf:{help nw_topical##information:[NW-2.4] Information}}{p_end}"_n ///
			"{pstd}"_n ///
			"{bf:{help nw_topical##manipulation:[NW-2.5] Manipulation}}{p_end}"_n ///
			"{pstd}"_n ///
			"{bf:{help nw_topical##analysis:[NW-2.6] Analysis}}{p_end}"_n ///
			"{pstd}"_n ///
			"{bf:{help nw_topical##utilities:[NW-2.7] Utilities}}{p_end}"_n ///
			"{pstd}"_n ///
			"{bf:{help nw_topical##visualization:[NW-2.8] Visualization}}{p_end}"_n ///
			"{pstd}"_n ///
			"{bf:{help nw_topical##programming:[NW-2.9] Programming }}{p_end}" _n _n

	set more off
	gen topicmarker = substr(link, 13,.)
	
	forvalues i = 1/`=_N' {
		local t = topicmarker[`i']
		local t_lag = topicmarker[`=`i'-1']
		if "`t'" != "`t_lag'" {
			local tm = topicmarker[`i']
			local tc = substr(topic[`i'],10,.)
			file write `topical' "{marker `tm'}{...}" _n ///
					"" _n ///
					"{col 8}   {c TLC}{hline 24}{c TRC}" _n ///
					"{col 8}{hline 3}{c RT}       {it:`tc'}{col 36}{c LT}{hline}" _n ///
					"{col 8}   {c BLC}{hline 24}{c BRC}" _n ///
					"{p2colset 12 35 36 2}" _n ///
					""
		}
		local cn = cmdname[`i']
		capture getcmddesc `cn'
		if _rc == 0 {
			file write `topical' "{p2col:    {bf:{help `cn' }}}`r(cmddesc)'{p_end}" _n		
		}
	}
	
	local tc = "Uncategorized"
	file write `topical' "{marker uncategorized}{...}" _n ///
					"" _n ///
					"{col 8}   {c TLC}{hline 24}{c TRC}" _n ///
					"{col 8}{hline 3}{c RT}       {it:`tc'}{col 36}{c LT}{hline}" _n ///
					"{col 8}   {c BLC}{hline 24}{c BRC}" _n ///
					"{p2colset 12 35 36 2}" _n ///
					""
					
	foreach file in `adofiles' {
		local cmdname = substr("`file'", 1, `=(length("`file'") - 4)') 
		getcmddesc `cmdname'
		if "`r(cmddesc)'" == "{err}no help file yet{txt}" {
			file write `topical' "{p2col:{bf:{help `cmdname' }}}`r(cmddesc)'{p_end}" _n	
		}
	}
	
	file close `topical'
	restore
	
	// generate alphabetical glossary help
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
	di "h1"
	file close `deploy_ado'
	di "h2"
	
	file open deploy_hlp using nwcommands-hlp.pkg, replace write
	file write deploy_hlp "v 3" _n
	file write deploy_hlp "d nwcommands-hlp. Social Network Analysis Using Stata - Help Files" _n
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
		set more off
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

capture program drop getcmdtopic
program getcmdtopic, rclass
	syntax anything(name=cmd)
	capture findfile `cmd'.sthlp
	if _rc != 0 {
		return local cmdtopic = "Uncategorized"
		return local topiclink = "nw_topical##uncategorized"
		exit
	}
	else {
		tempname cmdsthlp
		file open `cmdsthlp' using `cmd'.sthlp, read		
		file read `cmdsthlp' line
		local found = 0
		while (r(eof)==0) {
			local j = strpos(`"`line'"', "{marker topic}")
			if (`j' >0) {
				file read `cmdsthlp' line
                gettoken topiclink cmdtopic : line, parse(":") 
				local cmdtopic= substr(`"`cmdtopic'"', 2, `=length(`"`cmdtopic'"') - 2')
				local topiclink= substr(`"`topiclink'"', 8,.)	
            }
			local k = strpos(`"`line'"', "{marker top2}")
			if (`k' >0) {
				file read `cmdsthlp' line
                gettoken topiclink2 cmdtopic2 : line, parse(":") 
				local cmdtopic2= substr(`"`cmdtopic2'"', 2, `=length(`"`cmdtopic2'"') - 2')
				local topiclink2= substr(`"`topiclink2'"', 8,.)	
            }
			file read `cmdsthlp' line
		}			
		return local cmdtopic = "`cmdtopic'"
		return local topiclink = "`topiclink'"
		if "`cmdtopic2'" != "" {
			return local cmdtopic2 = "`cmdtopic2'"
			return local topiclink2 = "`topiclink2'"
		}
	}
	file close `cmdsthlp'
end
