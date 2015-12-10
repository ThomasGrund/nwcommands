capture program drop _nwdeploy
program _nwdeploy
	syntax , version(string) [author(string) email(string) other(string)]

	di "Version_deploy: `version'"
	set more off
	tempname nw
	//di "Writing... nwcommands.sthlp"
	file open `nw' using nwcommands.sthlp, replace write
	file write `nw' "{smcl}" _n ///	
"{* *! version 1.0.0  3sept2014}{...}" _n ///
"" _n ///		
"{col 14}Section{col 31}Description" _n ///
"{col 14}{hline 46}" _n ///
"{help nw_intro:{col 14}{bf:[NW-1]}{...}{col 31}{bf:Introduction and concepts}}" _n ///
"" _n ///
"{help nw_topical:{col 14}{bf:[NW-2]}{...}{col 31}{bf:Topical list of network commands}}" _n ///
"" _n ///
"{help nw_alphabetical:{col 14}{bf:[NW-3]}{...}{col 31}{bf:Alphabetical list of network commands}}" _n ///
"" _n ///
"{help nw_start:{col 14}{bf:[NW-4]}{...}{col 31}{bf:Getting started}}" _n ///
"" _n ///
"{help nw_programming:{col 14}{bf:[NW-5]}{...}{col 31}{bf:Network programming}}" _n ///
"" _n ///
"{help nwinstall:{col 14}{bf:[NW-6]}{...}{col 31}{bf:Install Stata menus/dialogs}}" _n ///
"" _n ///
"" _n ///
"		*! Date        : `c(current_date)'" _n ///
"		*! Version     : `version'" _n ///
"		*! Authors     : Thomas U. Grund " _n ///
"		*! Contact     : thomas.u.grund@gmail.com" _n ///
`"		 *! Web         : {browse "http://nwcommands.org"}"' _n ///
`"		 *! Bugs        : {browse "mailto:thomas.u.grund@gmail.com"}"'
	file close `nw'
	
	//tempname versionlog
	//file open `versionlog' using versionlog.sh, replace write
	
	set more off
	tempname deploy_ado
	file open `deploy_ado' using nwcommands-ado.pkg, replace write
	file write `deploy_ado' "v 3" _n
	file write `deploy_ado' "d nwcommands-ado. Social Network Analysis Using Stata" _n
	file write `deploy_ado' "d Thomas U. Grund, University College Dublin, www.grund.co.uk" _n
	file write `deploy_ado' "d email: contact@nwcommands.org" _n
	local d = lower(subinstr(c(current_date)," ","",.))
	file write `deploy_ado' "d Distribution-Date: `d'" _n
	
	local adofiles : dir "`c(pwd)'" files "*.ado"
	local sthlpfiles : dir "`c(pwd)'" files "*.sthlp"
	
	// generate topical glossary help
	tempname memhold
	tempfile topics
	postfile `memhold' str30 cmdname str40 link str30 topic using `topics'
	set more off
	//di "Collecting topic categories..."
	foreach file in `sthlpfiles' {
		if (strpos("`file'", "!") == 0){
		// add sthlp meta info
		//di "sthlp: `file'"
		//qui _addmeta_hlp `file', date(`d') version(`version')
		
		local cmdname = substr("`file'", 1, `=(length("`file'") - 6)') 
		getcmdtopic `cmdname'
		if "`r(cmdtopic)'" != "" {
			post `memhold' ("`cmdname'") ("`r(topiclink)'") ("`r(cmdtopic)'")
		}
		if "`r(cmdtopic2)'" != "" {
			post `memhold' ("`cmdname'") ("`r(topiclink2)'") ("`r(cmdtopic2)'")
		}
		}
	}	
	postclose `memhold'

	preserve
	use `topics', clear	
	sort topic cmdname
	
	tempname topical
	file open `topical' using nw_topical.sthlp, replace write
	//di "Writing... help files"
	file write `topical' "{smcl}" _n ///	
			"{* *! version `version' `d'}{...}"  _n ///
		    "{phang}" _n ///
			"{help nwcommands:NW-2 topical} {hline 2} " _n ///
			"{hline 2} Topical list of network commands" _n ///
			"" _n ///
			"{title:Contents}" _n ///	
			"" _n ///
			"{col 14}Section{col 31}Description" _n ///
			"{col 14}{hline 46}" _n ///
"{help nw_topical##concept:{col 14}{bf:[NW-2.1]}{...}{col 31}{bf:Concepts}}" _n ///
	"" _n ///
"{help nw_topical##import:{col 14}{bf:[NW-2.2]}{...}{col 31}{bf:Import/Export}}" _n ///
	"" _n ///
"{help nw_topical##generator:{col 14}{bf:[NW-2.3]}{...}{col 31}{bf:Generators}}" _n ///
	"" _n ///
"{help nw_topical##information:{col 14}{bf:[NW-2.4]}{...}{col 31}{bf:Information}}" _n ///
	"" _n ///
"{help nw_topical##manipulation:{col 14}{bf:[NW-2.5]}{...}{col 31}{bf:Manipulation}}" _n ///
	"" _n ///
"{help nw_topical##analysis:{col 14}{bf:[NW-2.6]}{...}{col 31}{bf:Analysis}}" _n ///
	"" _n ///
"{help nw_topical##utilities:{col 14}{bf:[NW-2.7]}{...}{col 31}{bf:Utilities}}" _n ///
	"" _n ///
"{help nw_topical##visualization:{col 14}{bf:[NW-2.8]}{...}{col 31}{bf:Visualization}}" _n ///
	"" _n ///
"{help nw_topical##programming:{col 14}{bf:[NW-2.9]}{...}{col 31}{bf:Programming}}" _n _n

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
		//file write `versionlog' `"echo "*! v`version' __ `c(current_date)' __ `c(current_time)'" >> `file'"'  _n
	}
	
	file close `topical'
	restore
	
	// generate alphabetical glossary help
	tempname alphabetical
	file open `alphabetical' using nw_alphabetical.sthlp, replace write
	file write `alphabetical' "{smcl}" _n ///	
			"{* *! version 1.0.0  3sept2014}{...}"  _n ///
			"{phang}" _n ///
			"{help nwcommands:NW-3 alphabetical} {hline 2} Alphabetical list of network programs" _n ///
			" "_n ///
			"{col 5}{hline}" _n ///
			"{p2colset 5 32 34 2}" 
	set more off
	
	file open _pkg_ado using _pkg_ado.txt, read
	file read _pkg_ado _pkg_ado_line 
	while "`_pkg_ado_line'" != "" {
		file write `deploy_ado' "`_pkg_ado_line'" _n
		file read _pkg_ado _pkg_ado_line 
	}
	file close _pkg_ado
	
	foreach file in `adofiles' {
		
		// add meta to dofiles
		// di "ado: `file'"
		//qui _addmeta_do `file', date(`d') author(`author') email(`email') version(`version') other(`other')
	
		local cmdname = substr("`file'", 1, `=(length("`file'") - 4)') 
		getcmddesc `cmdname'
		//file write `deploy_ado' "f `file'" _n
		//di "`file'"
		file write `alphabetical' "{p2col:{bf:{help `cmdname' }}}`r(cmddesc)'{p_end}" _n		
	}
	
	file close `alphabetical'
	
	/*local dtafiles : dir "`c(pwd)'" files "*.dta"
	foreach file in `dtafiles' {
		file write `deploy_ado' "f `file'" _n
	}
	local netfiles : dir "`c(pwd)'" files "*.net"
	foreach file in `netfiles' {
		file write `deploy_ado' "f `file'" _n
	}
	local schemefiles : dir "`c(pwd)'" files "*.scheme"
	foreach file in `schemefiles' {
		file write `deploy_ado' "f `file'" _n
	}
	local dlfiles : dir "`c(pwd)'" files "*.dat"
	foreach file in `dlfiles' {
		file write `deploy_ado' "f `file'" _n
	}*/
	
	file close `deploy_ado'
	
	file open deploy_hlp using nwcommands-hlp.pkg, replace write
	file write deploy_hlp "v 3" _n
	file write deploy_hlp "d nwcommands-hlp. Social Network Analysis Using Stata - Help Files" _n
	file write deploy_hlp "d Thomas U. Grund, University College Dublin, www.grund.co.uk" _n
	file write deploy_hlp "d email: contact[at]nwcommands.org" _n
	local d = lower(subinstr(c(current_date)," ","",.))
	file write deploy_hlp "d Distribution-Date: `d'" _n
	
	file open _pkg_hlp using _pkg_hlp.txt, read
	file read _pkg_hlp _pkg_hlp_line 
	while "`_pkg_hlp_line'" != "" {
		file write deploy_hlp "`_pkg_hlp_line'" _n
		file read _pkg_hlp _pkg_hlp_line 
	}
	file close _pkg_hlp
	
	/*
	local hlpfiles : dir "`c(pwd)'" files "*.sthlp"
	foreach file in `hlpfiles' {
		file write deploy_hlp "f `file'" _n
	}
	*/
	
	file close deploy_hlp
	
	file open deploy_ext1 using nwcommands-ext.pkg, replace write
	file write deploy_ext1 "v 3" _n
	file write deploy_ext1 "d nwcommands-hlp. Social Network Analysis Using Stata - Extension_1" _n
	file write deploy_ext1 "d Thomas U. Grund, University College Dublin, www.grund.co.uk" _n
	file write deploy_ext1 "d email: contact[at]nwcommands.org" _n
	local d = lower(subinstr(c(current_date)," ","",.))
	file write deploy_ext1 "d Distribution-Date: `d'" _n
	
	file open _pkg_ext1 using _pkg_ext.txt, read
	file read _pkg_ext1 _pkg_ext1_line 
	while "`_pkg_ext1_line'" != "" {
		file write deploy_ext1 "`_pkg_ext1_line'" _n
		file read _pkg_ext1 _pkg_ext1_line 
	}
	file close _pkg_ext1
	file close deploy_ext1
	
	file open deploy_dlg using nwcommands-dlg.pkg, replace write
	file write deploy_dlg "v 3" _n
	file write deploy_dlg "d nwcommands-dlg. Social Network Analysis Using Stata - Dialog Boxes" _n
	file write deploy_dlg "d Thomas U. Grund, University College Dublin, www.grund.co.uk" _n
	file write deploy_dlg "d email: contact[at]nwcommands.org" _n
	local d = lower(subinstr(c(current_date)," ","",.))
	file write deploy_dlg "d Distribution-Date: `d'" _n
	
	local dlgfiles : dir "`c(pwd)'" files "*.dlg"
	foreach file in `dlgfiles' {
		file write deploy_dlg "f `file'" _n
	}
	local idlgfiles : dir "`c(pwd)'" files "*.idlg"
	foreach file in `idlgfiles' {
		file write deploy_dlg "f `file'" _n
	}
	file close deploy_dlg
	//file close `versionlog'
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
			local j = strpos("`line'", "{hline 2}")
			if (`j' >0) {
                local cmddesc = substr(`"`line'"', `=`j' + 10', .)
				local cmddesc = substr("`cmddesc'",1, `=length("`cmddesc'") - 1')
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
	syntax anything(name=cmd) [, version(string)]
	capture findfile `cmd'.sthlp
	if _rc != 0 {
		return local cmdtopic = "Uncategorized"
		return local topiclink = "nw_topical##uncategorized"
		exit
	}
	else {
		tempname cmdsthlp
		file open `cmdsthlp' using `cmd'.sthlp, read
		//file open `cmdsthlp' using nwergm.sthlp, read		

		file read `cmdsthlp' line
		local found = 0
		while (r(eof)==0) {
			local j = strpos(`"`line'"', "{marker topic}")
			//di `"`line'"'
			if (`j' >0) {
				//local found 0
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
	//shell sh versionlog.sh
end

/*

capture program drop _addmeta_do
program _addmeta_do
	syntax anything(name=adofile), date(string) [ version(string) author(string) email(string) other(string) ]
	
	tempname meta
	tempname myfile 
	
	file open `meta' using "_metatemp.do", write replace 
	file write `meta' "*! Date      :`date'" _n
	file write `meta' "*! Version   :`version'" _n
	file write `meta' "*! Author    :`author'" _n
	file write `meta' "*! Email     :`email'" _n
	if "`other'" != "" {
		file write `meta' "*! Email     :`email'" _n
	}
	file write `meta' "" _n
	
	file open `myfile' using "`adofile'", read
	file read `myfile' line
	
	local codestarted= 0
	while r(eof)==0 {
		di `"`line'"'
		if ("`=word(`"`line'"',1)'" == "capture"){
			local codestarted = 1
		}
		// copy file
		if `codestarted' == 1 {
			file write `meta' "`line'" _n
		}
		file read `myfile' line	
	}
	file close `myfile'
	file close `meta'
	//erase `adofile'
	//!mv _metatemp.do `adofile'
end


capture program drop _addmeta_hlp
program _addmeta_hlp
	syntax anything(name=hlpfile), date(string) version(string)

	set more off
	tempname meta
	tempname myfile 
	
	file open `meta' using "_metatemp.sthlp", write replace
	file write `meta' "{smcl}" _n
	file write `meta' "{* *! version `version'  `date'}{...}" _n	
	file open `myfile' using "`hlpfile'", read
	file read `myfile' line
	
	local codestarted= 0
	while r(eof)==0 {
		if (`"`line'"' == "{marker topic}"){
			local codestarted = 1
		}
		// copy file
		if `codestarted' == 1 {
			file write `meta' `"`line'"' _n
		}
		file read `myfile' line	
	}
	file close `myfile'
	file close `meta'
	erase `hlpfile'
	!mv _metatemp.sthlp `hlpfile'
end

*/

