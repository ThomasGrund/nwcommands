*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwlattice
program nwlattice
	syntax anything(name=dims) , [xwrap ywrap name(string) stub(string) xvars undirected noreplace ntimes(integer 1)]
	version 9
	set more off
	
	// Get parameters
	local cols = word("",1)
	local rows = 1
	if (wordcount("") > 1) {
		local rows = word("",2)
	}
	local nodes =  * 
	
	// Check if this is the first network in this Stata session
	if "2" == "" {
		global nwtotal = 0
	}

	// Generate valid network name and valid varlist
	if "" == "" {
		local name "lattice"
	}
	if "" == "" {
		local stub "net"
	}
	nwvalidate 
	local latticename = r(validname)
	local varscount : word count 
	if ( != ){
		nwvalidvars , stub()
		local latticevars " net1_1 net1_2 net1_3 net1_4 net1_5 net1_6 net1_7 net1_8 net1_9 net1_10 net1_11 net1_12"
	}
	else {
		local latticevars ""
	}
	
	if  != 1 {
		di in smcl as txt "{p}"
		forvalues i = 1/{
			if mod(, 25) == 0 {
				di in smcl as txt "..."
			}
			nwlattice  , name(_) stub()  
		}
		exit
	}

	
	// Generate network	
	mata: newmat = J(,, 0)
	local vars ""
	forvalues i = 1/ {
		local vars " lattice"
		local right =  + 1
		local left =  - 1
		
		local up =  - 
		local down =  + 
		
		if ((mod(-1, ) != 0) &  <= ) mata: newmat[, ] = 1
		if ((mod(, ) != 0) &  > 1) mata: newmat[, ] = 1
		mata: newmat[2,1]=1
		if ( > 0) mata: newmat[, ] = 1 
		if ( > 0 &  <= ) mata: newmat[, ] = 1
		
		if "" != "" {
			if  <= {
				mata: newmat[,( + (( - 1) * ))] = 1
				mata: newmat[( + (( - 1) * )), ] = 1
			}
		}
		if "" != "" {
			if mod(, ) == 1 {
				mata: newmat[,( + ( - 1))] = 1
				mata: newmat[( + ( - 1)), ] = 1
			}
		}
		
		
	}
	
	nwset, mat(newmat) vars() name(lattice) 
	nwload , 
	mata: mata drop newmat 
end


