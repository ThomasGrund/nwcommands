*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwpermute	
program nwpermute
	version 9.0
	syntax [anything(name=netname)], [ id(string) xvars name(string) vars(string) stub(string) noreplace ]
	
	_nwsyntax , max(1)
	scalar onevars = ""
	local vars marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
	
	// generate valid network name and valid varlist
	if "" == "" {
		local name "_perm"
	}
	if "" == "" {
		local stub "perm"
	}

	nwvalidate 
	local name = r(validname)
	local varscount : word count 
	if ( != ){
		nwvalidvars , stub()
		local permvars " net1_1 net1_2 net1_3 net1_4 net1_5 net1_6 net1_7 net1_8 net1_9 net1_10 net1_11 net1_12"
	}
	else {
		local permvars ""
	}

	nwtomata , mat(onenet)
	mata: perm = permutenet(onenet)

	if ""=="false" {
		local undirected = "undirected"
	}
	nwrandom , prob(0) name() vars()  
	nwreplacemat , newmat(perm)
end

capture mata mata drop permutenet()
mata:
real matrix permutenet(real matrix nwadj) {
	nsize = rows(nwadj)
	permutationVec = unorder(nsize)
	return (nwadj[permutationVec, permutationVec])
}
end




