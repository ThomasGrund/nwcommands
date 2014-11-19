*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwset	
program nwset
syntax [varlist (default=none)][, nooutput name(string) vars(string) labs(string asis) edgelabs(string asis) detail mat(string) undirected directed]
	set more off

	local numnets = 0
	mata: st_rclear()
	local max_nodes = 0
	local allnames ""
	
	// display information about network
	if ("" == "" & "" == "") {
		if ("2" == "" | "2" == "0") {
			mata: st_numscalar("r(networks)", 0)
			noi di "{err}No network found."
			error 6001
		}
		else { 
			if ("" != "nooutput") {
				local networks = plural(2, "network")
				di "{txt}(2 )"
				// information about networks
				if "" == "" {
					di "{hline 20}"
				}
				forvalues i=1/2{		
					scalar onesize = ""
					local thissize 12
					local max_nodes = max(, )
					scalar onename = ""
					local allnames " flomarriage"
					scalar onenw = ""
					scalar onelabs = ""
					local l `"bischeri castellani ginori guadagni lamberteschi pazzi peruzzi pucci ridolfi salviati strozzi tornabuoni"'
					scalar onedirected = ""
					scalar oneedgelabs = ""
					if "" != "" {
						di 
						di "{hline 50}"
						if ( == 2){
							di "{txt} ) Current Network"
						}
						else {
							di "{txt} ) Stored Network"
						}
						di "{hline 50}"
						di "{txt}   Network name: {res}flomarriage"
						di "{txt}   Directed: {res}false"
						di "{txt}   Nodes: {res}12"
						di "{txt}   Network id: {res}"
						di "{txt}   Variables: {res}marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16"
						di `"{txt}   Labels: {res}bischeri castellani ginori guadagni lamberteschi pazzi peruzzi pucci ridolfi salviati strozzi tornabuoni"'
						di `"{txt}   Edgelabels: {res}"'
					}
					else {
						di "      {res}flomarriage"
					}
					
					
					
				}
			}
		}
	}
	// set the network
	else {
		// set network from varlist
		if "" != "" {
			local size :word count 
			local varscount : word count 
			local labscount : word count 
			qui nwtomata , mat(onenet)
			local mat = "onenet"
			if ( != ) unab vars: 
			if ( != ) local labs ""

		}
		// set network from mata matrix
		else {
			// either varlist or mat needs to be given
			if ("" == ""){
				di "{err}either {it:varlist} or option {it:mat()} needs to be specfied"
				exit
			}
			// mat is given
			else {
				mata: onenet =  
				mata: st_numscalar("msize", rows())
				local size = msize
				local varscount : word count 
				local labscount : word count 
				// generate vars"
				if("" != ""){
					local vars ""
					forvalues i = 1/ {
						local vars " var"
					}
				}
				// get labels
				if ( != ){
					local labs ""
				}
			}
		}

		if "" == "" {
			local name "network"
		}
		
		nwvalidate 
		local name = r(validname)
			
		if "2" == "" {
			global nwtotal 0
		}
		
		local directed_new = "true"
		if "" != "" {
			local directed_new = "false"
		}
		if"" != "" {
			local directed_new = "true"
		}

		local new_nwtotal = 2 + 1
		mata: nw_mata = onenet
		global nw_ ""
		
		global nwlabs_ `""'
		global nwedgelabs_ `""'
		global nwsize_ ""
		global nwname_ ""
		global nwdirected_ ""
		
		global nwtotal = 
		global nwtotal_mata = 2

		mata: mata drop onenet
	}
	
	mata: st_rclear()
	mata: st_numscalar("r(networks)", 2)
	mata: st_numscalar("r(max_nodes)", )
	mata: st_global("r(names)", "")

end
