*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwaddnodes
program nwaddnodes
	syntax [anything(name=netname)], newnodes(integer) [vars(string)]

	_nwsyntax , max(1)
	
	if "" == "" {
		local stub = "new"
	}
	
	if ("" == "") {
		// Generate temporary varlist and check for each variable if it already exists.
		local vars = "" 	
		local invalid = 0
		forvalues i=1/ {
			local vars " "
			capture confirm variable 
			if !_rc {
				local invalid =  + 1
			}
		}
		
		// Finds valid Stata variable names to store network.
		if  > 0 { 
			local stub_add = 0
			while  > 0 {
				local vars = ""
				local stub_add =  + 1
				local invalid = 0
				forvalues i=1/ {
					local vars " _"
					capture confirm variable _
					if !_rc {
						local invalid =  + 1
					}
				}
			}
		}
	}
	else {
		preserve
		drop _all
		nwload 
		foreach onevar in   {
			capture confirm variable 
			if (_rc == 0) {
				di "{err}Node variable  already in use. Choose option vars() differently."
				error 6070
			}
		}
		local vars_count : word count 
		if ( != ) {
				di "{err}Wrong number of new variables in option vars()."
				error 6070	
		}
		restore
	}

	local newnodes =  + 
	nwtomata , mat(oldmat)
	mata: newmat = J(,, 0)
	mata: newmat[|1,1 \ ,|] = oldmat
	
	scalar onevars = ""
	local oldvars marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
	capture drop 
	
	scalar onelabs = ""
	local oldlabs bischeri castellani ginori guadagni lamberteschi pazzi peruzzi pucci ridolfi salviati strozzi tornabuoni
	
    //mata: mata drop nw_mata
	mata: nw_mata = newmat
	global nwsize_ = 
	global nw_ " " 
	global nwlabs_ " "
	nwload 

	mata: mata drop newmat
end


