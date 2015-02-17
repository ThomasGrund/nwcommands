*! Date        : 3sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwergm	
program nwergm, sortpreserve
syntax anything(name=netname), formula(string) [ ergmoptions(string) rpath(string) ergmdetail keepfiles detail gof gofoptions(string) mcmc mcmcoptions(string) * ]
	set more off
	_nwsyntax `netname'
	
	local temp = strpos(`"`formula'"', "~")
	if `temp' > 0 {
		local formula = substr(`"`formula'"',`=`temp'+1',.)
	}
	
	di `"`formula'"'
	
	di ="{txt}Checking for R installation..."
	if "`rpath'" == "" {
		// Check R installation
		if c(os) == "MacOSX" {
			nwergm_install_osx
		}
	
		if c(os) == "Windows" {
			nwergm_install_win
		}
		local rpath = "`r(rpath)'"
	}
	capture findfile R, path(`rpath')
	if _rc == 0 {
		di "{txt}...R found"
		global rpath `rpath'/R
	}
	else {
		di "{err}...R not found :-("
		exit
	}
	
	preserve
	nwname `netname'
	local netid = r(id)
	local netsize = r(nodes)
	local vars `"\$nw_`netid'"'
	nwload `netname'
	
	label drop _all
	
	if "`gofoptions'" == "" {
		local gofoptions = "control=control.gof.ergm(nsim=30), verbose = TRUE "
	}
	
	di 
	di ="{txt}Preparing analysis"
		
	// Save relevant data be opened in R
	drop if _n > `netsize'
	capture saveold ergdata.dta, replace
	
	if _rc != 0 {
		di "{err}ergdata.dta could not be saved." _n ///
		   "Change your current working directory and start nwergm again."
		exit	
	}
	restore

	// generate r_ergm.r file
	local dir `c(pwd)'
	local rdir = subinstr("`dir'","\","/",.)
	local rergm "ergrcode.r"

	tempname r_ergm
	qui file open `r_ergm' using "`rergm'", write replace

	// install and load necessary packages
	file write `r_ergm' "# install and load necessary R packages" _n ///
					`"if (!require("foreign",character.only = TRUE)) { install.packages("foreign", repos = "http://cran.rstudio.com/") } "' _n ///
					`"if (!require("ergm",character.only = TRUE)) { install.packages("ergm", repos = "http://cran.rstudio.com/") } "' _n ///
					`"suppressPackageStartupMessages(library("foreign", quietly=TRUE, verbose=FALSE, warn.conflicts=FALSE))"' _n ///
					`"suppressPackageStartupMessages(library("ergm", quietly=TRUE, verbose=FALSE, warn.conflicts=FALSE))"' _n  ///
					`"suppressPackageStartupMessages(library("network", quietly=TRUE, verbose=FALSE, warn.conflicts=FALSE))"' _n _n ///
					"# set R working directory to Stata working directory" _n ///
					`"setwd("`rdir'")"' _n _n

	// load data
	file write `r_ergm' "# load network and attributes" _n ///
					`"data <- read.dta("ergdata.dta")"' _n ///
					`"netsize <- dim(data)[1]"' _n ///
					`"netmat <- as.matrix(data[unlist(strsplit("`vars'"," "))])"' _n ///
					`"netsym <- all(netmat == t(netmat))"' _n ///
					`"net<- network(netmat, directed = !netsym)"' _n ///
					`"attrs <- dim(data)[2] - dim(data)[1]"' _n ///
					`"for (i in 1:attrs){ "' _n ///
					`"	 att <- data[,i] "' _n ///
					`"	 set.vertex.attribute(net, colnames(data[i]),att) "' _n ///
					`"} "' _n _n ///   

	// run ergm
	file write `r_ergm' "# run ERGM" _n ///
					`"model <- net~`formula'"' _n ///
					"try({summary(model)" _n ///
					`"ergmresults<-ergm(model, `ergmoptions', verbose=TRUE)"' _n ///
					"summary(ergmresults)})" _n _n

	// execute goodness-of-fit analysis					
	if ("`gof'" != "") {
		file write `r_ergm' "# generate code for goodness of fit analysis" _n ///
							"g <- gof(ergmresults, `gofoptions')" _n ///
							"simid<- rep(seq(1,dim(g\$psim.espart)[1]),dim(g\$psim.espart)[2])" _n ///
							"value<- rep(1:dim(g\$psim.espart)[2],each=dim(g\$psim.espart)[1])" _n ///
							"espart<-as.vector(g\$psim.espart[,1:g\$network.size-1])" _n ///
							"dist<-as.vector(g\$psim.espart[,1:g\$network.size-1])" _n ///						
							"obsespart<-rep(g\$pobs.espart[1:g\$network.size-1],each=dim(g\$psim.espart)[1])" _n ///
							"obsdist<-rep(g\$pobs.dist[1:g\$network.size-1],each=dim(g\$psim.espart)[1])" _n ///
							"if (netsym) { " _n ///
							"	deg<-as.vector(g\$psim.deg[,1:g\$network.size-1])" _n ///
							"	obsdeg<-rep(g\$pobs.deg[1:g\$network.size-1],each=dim(g\$psim.espart)[1])" _n ///				
							"   gof.data<- as.data.frame(cbind(simid,value, obsdeg, deg, obsespart, espart, obsdist, dist))" _n ///
							"}" _n ///
							"if (!netsym) { " _n ///
							"	ideg<-as.vector(g\$psim.ideg[,1:g\$network.size-1])" _n ///
							"	odeg<-as.vector(g\$psim.odeg[,1:g\$network.size-1])" _n ///
					        "	obsideg<-rep(g\$pobs.ideg[1:g\$network.size-1],each=dim(g\$psim.espart)[1])" _n ///
							"   obsodeg<-rep(g\$pobs.odeg[1:g\$network.size-1],each=dim(g\$psim.espart)[1])" _n ///			
							"   gof.data<- as.data.frame(cbind(simid,value, obsideg, ideg, obsodeg, odeg, obsespart, espart, obsdist, dist))" _n ///
							"}" _n ///						
							"write.csv(as.data.frame(gof.data), 'erggof.csv', na='.')" _n _n					
	}
	
	if ("`mcmc'" != ""){
		file write `r_ergm' "# generate code for mcmc diagnostics" _n ///				
							"if (length(ergmresults\$sample)!=0){" _n ///
							"  mcmcres<-as.data.frame(ergmresults\$sample)" _n ///
							"  mcmcnames<-names(mcmcres)" _n ///
							"  names(mcmcres)<-sub('#','_',mcmcnames)" _n ///
							"  write.dta(mcmcres, 'ergmcmc.dta')}" _n _n				
	}

	file write `r_ergm' "write.table(geterrmessage(),'ergerror.txt')" _n _n ///
					
	// produce ergcoefs.csv, ergcov.csv, ergmodel.csv, ergstats.csv, ergcontrol.csv
	file write `r_ergm' "# produce output files: ergcoefs.csv, ergcov.csv, ergmodel.csv,  ergstats.csv" _n

	// ergcoefs.csv - coefficients
	file write `r_ergm' "write.csv(round(summary(ergmresults)\$coefs, 3), 'ergcoefs.csv', na='.')" _n					
	
	// ergcov.csv - covariance matrix
	file write `r_ergm' "write.csv(summary(ergmresults)\$asycov, 'ergcov.csv', na='.')" _n					

	// ergmodel.csv - fingerprint
	file write `r_ergm' "write.csv(round(as.data.frame(summary(model)), 3), 'ergmodel.csv', na='.')" _n					

	// ergcontrol.csv - control
	file write `r_ergm' "capture.output(summary(ergmresults)\$control, file='ergcontrol.csv')" _n

	// ergstats.csv - estimation stats
	file write `r_ergm' "fileCon<-file('ergstats.csv', 'w')" _n ///
					"writeLines('vertices,edges,directed,numcoeff,coeff,iterations,estimate,aic,bic,samplesize,message', fileCon)" _n ///
					"writeLines(paste(network.size(net),',',network.edgecount(net),',',net[[2]]\$directed,',',dim(summary(ergmresults)\$coef)[1],',',gsub(',','',toString(names(summary(model)))),',',summary(ergmresults)\$iterations, ',',summary(ergmresults)\$estimate,',',round(summary(ergmresults)\$aic,2),',',round(summary(ergmresults)\$bic,2),',',summary(ergmresults)\$samplesize,',',summary(ergmresults)\$message), fileCon)" _n ///
					"close(fileCon)" _n ///
										
	// close file handler
	file close `r_ergm'
	
	tempname rterm
	scalar correctfile = length("$rpath") 
			
	di ="{txt}Running ERGM..."
	
	local rcode "ergrcode.r"
	local rout "ergm.Rout"
	
	local mode "--slave --silent"
	if "`detail'" != "" {
		local mode "--slave"
	}
	local Rcommand "$rpath `mode' <`rcode'"
	di "`Rcommand'"
	shell `Rcommand'
	
	
	//capture {
	// open R result files and prepare Stata output
	// get general estimation statistics from ergstats.csv
	local ergstats "ergstats.csv"
	tempname r_ergstats
	file open `r_ergstats' using "`ergstats'", read text
	file read `r_ergstats' names
	file read `r_ergstats' values
	tokenize "`values'", parse(",")
	local vertices `1'
	local edges `3'
	local directed "`5'"
	local numcoeff `7'
	local coeff "`9'"
	local iterations `11'
	local estimation "`13'"
	local aic `15'
	local bic  = `17'
	local samplesize `19'
	local message `21'
	file close `r_ergstats'

	mata: st_numscalar("e(vertices)", `vertices')
	mata: st_numscalar("e(edges)", `edges')
	mata: st_numscalar("e(numcoeff)", `numcoeff')
	mata: st_numscalar("e(iterations)", `iterations')
	mata: st_numscalar("e(samplesize)", `samplesize')
	mata: st_numscalar("e(AIC)", `aic')
	mata: st_numscalar("e(BIC)",`bic')'
	mata: st_global("e(estimation)" ,`"`estimation'"')
	mata: st_global("e(names)" ,`"`coeff'"')
	mata: st_global("e(directed)" ,`"`directed'"')

	// get coefficients from ergcoef.csv
	matrix b = J(`numcoeff',1,0)
	matrix sd = J(`numcoeff',1,0)
	matrix mcmc = J(`numcoeff',1,0)
	matrix pvalue = J(`numcoeff',1,0)

	local ergcoefs "ergcoefs.csv"
	tempname r_ergcoefs
	file open `r_ergcoefs' using "`ergcoefs'", read text
	file read `r_ergcoefs' names

	forvalues i = 1/`numcoeff' {
		file read `r_ergcoefs' values
		tokenize `"`values'"', parse(",")
		matrix b[`i',1] = `3'
		matrix sd[`i',1] = `5'
		matrix mcmc[`i',1] = `7'
		matrix pvalue[`i',1] = `9'
	}
	file close `r_ergcoefs'
	mata: st_matrix("e(coef)", st_matrix("b"))
	mata: st_matrix("e(sd)", st_matrix("sd"))
	mata: st_matrix("e(pvalue)", st_matrix("pvalue"))
	mata: st_matrix("e(mcmc)", st_matrix("mcmc"))
	
	// get model statistics from ergmodel.csv
	local ergmodel "ergmodel.csv"
	tempname r_ergmodel
	file open `r_ergmodel' using "`ergmodel'", read text
	file read `r_ergmodel' line

	matrix model = J(`numcoeff',1,0)
	forvalues i = 1/`numcoeff' {
		file read `r_ergmodel' line
		tokenize `"`line'"', parse(",")
		matrix model[`i',1] = `3'
	}
	file close `r_ergmodel'
	mata: st_matrix("e(model)", st_matrix("model"))

	// get covariance matrix  from ergcov.csv
	local ergcov "ergcov.csv"
	tempname r_ergcov
	file open `r_ergcov' using "`ergcov'", read text
	file read `r_ergcov' line
	matrix cov = J(`numcoeff',`numcoeff',0)

	forvalues i = 1/`numcoeff' {
		file read `r_ergcov' line
		tokenize `"`line'"', parse(",")
		forvalues j = 1/`numcoeff' {
			matrix cov[`i',`j'] =  ``=`j' * 2 + 1''
		}
	}
	file close `r_ergcov'
	mata: st_matrix("e(cov)", st_matrix("cov"))
	
	if _rc !=0 {
		local dir `c(pwd)'
		di 
		di "{err}ERGM analysis encountered an error running ergmcode.r:"	
		local ergerror "ergerror.txt"
		tempname r_ergerror
		file open `r_ergerror' using "`ergerror'", read text
		file read `r_ergerror' errortext
			while (r(eof) == 0){
				file read `r_ergerror' errortext
				di `"{res}`errortext'"'
			}
		file close `r_ergerror'
		exit
	}
	
	// show control details
	if "`ergmdetail'" != "" {
		set more off
		local ergcontrol "ergcontrol.csv"
		tempname r_ergcontrol
		type "`ergcontrol'"
	}

	tokenize `e(names)', parse(" ")
	local max_l 0
	matrix coef_l = J(`numcoeff',1,0)

	forvalues i = 1/`numcoeff' {
		matrix coef_l[`i',1] = length("``i''")
		if length("``i''") > `max_l'  {
			local max_l = length("``i''") 
		}
	}

	tokenize `e(names)', parse(" ")
	di 
	di
	di `"{txt}Exponential random graph analysis{col 42}Number of vertices{col 64}=  {res}`e(vertices)'"' 
	di `"{txt}{col 42}Number of edges/arcs{col 64}={res}  `e(edges)'"'
	di "{txt}{col 42}Directed{col 64}={res}  `e(directed)'"	
	di `"{txt}{col 42}Estimation{col 64}={res}  `e(estimation)'"' 
	di `"{txt}{col 42}Iterations{col 64}={res}  `e(iterations)'"' 
	di `"{txt}{col 42}MCMC sample size{col 64}={res}  `e(samplesize)'"' 
	di `"{txt}{col 42}AIC{col 64}={res}  `e(AIC)'"' 
	di `"{txt}{col 42}BIC{col 64}={res}  `e(BIC)'"' 
	di 
	di "{txt}{hline `=`max_l' + 3'}{c TT}{hline 55}"
	di "{col 2}network{col `=`max_l' + 4'}{c |}{col `=`max_l' + 12'}Observed{col `=`max_l' + 25'}Coef. {col `=`max_l' + 34'}Std.Err.{col `=`max_l' + 45'}MCMC%{col `=`max_l' + 52'}P>|z|"
	di "{hline `=`max_l' + 3'}{c +}{hline 55}"
	forvalues k=1/`numcoeff' {
		local one_model= model[`k',1]
		local one_b = b[`k',1]
		local one_sd = sd[`k',1]
		local one_mcmc = mcmc[`k',1]
		local one_p = pvalue[`k',1]
		di "{txt}{col 2}``k''{col `=`max_l' + 4'}{c |}{col `=`max_l' + 10'}{ralign 8:{res}`one_model'}{col `=`max_l' + 21'}{ralign 9:`one_b'}{col `=`max_l' + 34'}{ralign 6:`one_sd'}{col `=`max_l' + 44'}{ralign 4:`one_mcmc'}{col `=`max_l' + 52'}{ralign 4:`one_p'}"
	}
	di "{txt}{hline `=`max_l' + 3'}{c BT}{hline 55}"
	di "{error}`message'"

	// plot graphs
	if "`gof'" !="" {
		di "{txt}Plotting goodness-of-fit statistics"
		nwergmplotgof, `options'
	}
	
	if "`mcmc'" !="" {
		di "{txt}Plotting MCMC-diagnostics"
		nwergmplotmcmc, `options'
	}
	
	if ("`keepfiles'" == ""){
		if ("`c(os)'" == "Windows"){
			//di "{txt}Delete temporary file"
			capture shell erase erggof.csv ergmodel.csv ergcoefs.csv ergdata.dta ergcontrol.csv ergstats.csv ergcov.csv ergrcode.r ergerror.txt 
		}
	
		if ("`c(os)'" != "Windows"){
			//di "{txt}Delete temporary files"
			capture shell rm erggof.csv ergmodel.csv ergcoefs.csv ergdata.dta ergcontrol.csv ergstats.csv ergcov.csv ergrcode.r ergerror.txt 
		}
	}
end

capture program drop nwergmplotmcmc
program nwergmplotmcmc
syntax , [ *]
	preserve
	capture qui use "ergmcmc.dta", clear
	if _rc == 0 {
	qui gen  v1 = _n * 100
	local counter = 1
	local graphlist = ""
	foreach var of varlist _all {
		if (`counter' != c(k)) {	
			kdensity `var', ytitle("density") name(mcmcdensity`counter', replace) nodraw xline(0,lpattern(dash)) xlabel(#5) title("") note("") `options'
			line `var' v1, name(mcmcplot`counter', replace) nodraw xlabel(#3) xtitle("step") plotregion(margin(large)) `options'
			local graphlist = "`graphlist'" + " mcmcplot`counter'" + " mcmcdensity`counter'"
		}
		local counter = `counter' + 1
	}
	graph combine `graphlist', cols(2) title("MCMC-diagnostics") name(mcmcgraph, replace) `options'
	}
	restore
end
	
capture program drop nwergmplotgof
program  nwergmplotgof
syntax , [ *]
	preserve
	insheet  using `"erggof.csv"', clear
	if (trim("`e(directed)'") == "TRUE") {
		qui sum value if ideg != 0
		capture {
			stripplot ideg if value <=r(max), xtitle("indegree") ytitle("percentage of nodes") `options' xlabel(#6) over(value) ms(none)box(bfcolor(white) barw(.8))  vertical pctile(2.5)  addplot(line obsideg value, lwidth(thick) lcolor(black)) name(idegree, replace) nodraw 
		}
		// strippplot not found
		if (_rc == 199) {
			ssc install stripplot
			stripplot ideg if value <=r(max), xtitle("indegree") ytitle("percentage of nodes") `options' xlabel(#6) over(value) ms(none)box(bfcolor(white) barw(.8))  vertical pctile(2.5)  addplot(line obsideg value, lwidth(thick) lcolor(black)) name(idegree, replace) nodraw 
		}
		qui sum value if odeg != 0
		stripplot odeg if value <=r(max), xtitle("outdegree") ytitle("percentage of nodes") `options' xlabel(#6)  over(value) ms(none)box(bfcolor(white) barw(.8))  vertical pctile(2.5)  addplot(line obsodeg value, lwidth(thick) lcolor(black)) name(odegree, replace) nodraw 
		qui sum value if espart != 0
		stripplot espart if value <=r(max), xtitle("edge-wise shared partners") ytitle("percentage of nodes") `options' xlabel(#6) over(value) ms(none)box(bfcolor(white) barw(.8))  vertical pctile(2.5)  addplot(line obsespart value, lwidth(thick) lcolor(black)) name(espart, replace) nodraw 
		qui sum value if dist != 0
		stripplot dist if value <=r(max), xtitle("minimum geodesic distance") ytitle("percentage of nodes") `options'xlabel(#6)  over(value) ms(none)box(bfcolor(white) barw(.8))  vertical pctile(2.5)  addplot(line obsdist value, lwidth(thick) lcolor(black)) name(dist, replace) nodraw 
		qui sum simid
		graph combine idegree odegree espart dist, cols(2) title("goodness-of-fit") note(`"based on `r(max)' simulations"') name(gofgraph, replace) 
	}
	else{
		qui sum value if deg != 0
		capture {
			stripplot deg if value <=r(max), xtitle("degree") ytitle("percentage of nodes") `options' xlabel(#6) over(value) ms(none)box(bfcolor(white) barw(.8))  vertical pctile(2.5)  addplot(line obsdeg value, lwidth(thick) lcolor(black)) name(degree, replace) nodraw 
		}
		// strippplot not found
		if (_rc == 199) {
			ssc install stripplot
			stripplot deg if value <=r(max), xtitle("degree") ytitle("percentage of nodes") `options' xlabel(#6) over(value) ms(none)box(bfcolor(white) barw(.8))  vertical pctile(2.5)  addplot(line obsideg value, lwidth(thick) lcolor(black)) name(degree, replace) nodraw 
		}
		qui sum value if espart != 0
		stripplot espart if value <=r(max), xtitle("edge-wise shared partners") ytitle("percentage of nodes") `options' xlabel(#6) over(value) ms(none)box(bfcolor(white) barw(.8))  vertical pctile(2.5)  addplot(line obsespart value, lwidth(thick) lcolor(black)) name(espart, replace) nodraw 
		qui sum value if dist != 0
		stripplot dist if value <=r(max), xtitle("minimum geodesic distance") ytitle("percentage of nodes") `options' xlabel(#6) over(value) ms(none)box(bfcolor(white) barw(.8))  vertical pctile(2.5)  addplot(line obsdist value, lwidth(thick) lcolor(black)) name(dist, replace) nodraw 
		qui sum simid
		graph combine degree espart dist, cols(2) title("goodness-of-fit") note(`"based on `r(max)' simulations"') name(gofgraph, replace) `options'
	}
	restore
end


capture program drop nwergm_install_win
program nwergm_install_win

	local p : environ PATH
	tokenize `"`p'"', parse(";")
	local rpath = ""
	while "`1'" != "" & "`rpath'" == "" {
		capture findfile R.exe, path("`1'")
		if _rc == 0 {
			local rpath = "`1'"
			local rlow = lower("`rpath'")
			local st = strpos(lower("`rpath'"), "windows")
			if strpos("`rlow'", "windows") != 0 & "`rpath'" == "" {
				local rpath = ""
			}
		}
		macro shift
	}	
	if "`rpath'" == "" {
		local rurl = "http://cran.r-project.org/bin/windows/base/R-3.1.2-win.exe"
		di "{err}R not found."
		di `"{err}Please install {browse "`rurl'":R from here first} or specify option {bf:rpath()}."'
		exit
	}
	mata: st_global("r(rpath)", "`rpath'")
end

capture program drop nwergm_install_osx
program nwergm_install_osx
	
	// check for R
	local p = "`:environ PATH':/usr/local/bin:/usr/bin:/opt/local/bin:/bin:/usr/bin/R"
	tokenize `"`p'"', parse(":")
	local rpath = ""
	while "`1'" != "" & "`rpath'" == "" {
		capture findfile R, path("`1'")
		if _rc == 0 {
			local rpath = "`1'"
		}
		macro shift
	}	
	
	
	if "`rpath'" == "" {
		local rurl = "http://cran.r-project.org/bin/macosx/"
		di "{err}R not found."
		di `"{err}Please install {browse "`rurl'": R from here first} or specify option {bf:rpath()}."'
		error 6999
	}
	
	/*
	if "`impath'" == "" {
		set more off
		tempname nwmovie_sh
		capture findfile nwmovie.command
		if _rc != 0 {
			file open `nwmovie_sh' using nwmovie.command, write
			file write `nwmovie_sh' "if which brew >/dev/null; then" _n
			file write `nwmovie_sh' `"echo "Homebrew found""' _n
			file write `nwmovie_sh' "	else " _n
			file write `nwmovie_sh' "	/bin/mkdir /usr/local " _n
			file write `nwmovie_sh' "	curl -L https://github.com/Homebrew/homebrew/tarball/master  | tar xz --strip 1 -C /usr/local" _n
			file write `nwmovie_sh' "fi" _n
			file write `nwmovie_sh' "if which convert >/dev/null; then" _n
			file write `nwmovie_sh' `"	echo "ImageMagic found""' _n
			file write `nwmovie_sh' "else" _n
			file write `nwmovie_sh' "	brew install ImageMagick" _n
			file write `nwmovie_sh' "fi" _n
			file write `nwmovie_sh' "if which gs >/dev/null; then" _n
			file write `nwmovie_sh' `"	echo "Ghostscript found""' _n
			file write `nwmovie_sh' "else"_n
			file write `nwmovie_sh' "	brew install ghostscript" _n
			file write `nwmovie_sh' "fi" _n
			file write `nwmovie_sh' "exit"
			file close `nwmovie_sh'
		}
		shell chmod u+x nwmovie.command
		shell open /Applications/Utilities/Terminal.app/ nwmovie.command
		
		local p = "`:environ PATH':/usr/local/bin:/usr/bin:/opt/local/bin:/bin:"
		tokenize `"`p'"', parse(":")
		local impath = ""
		while "`1'" != "" & "`impath'" == "" {
			capture findfile convert, path("`1'")
			if _rc == 0 {
				local impath = "`1'"
			}
			macro shift
		}
	}
	else {
		di ""
		di "{txt}Checking third party software:"
		di "{txt}...ImageMagick found"
	} */
	
	mata: st_global("r(rpath)", "`rpath'")
end



