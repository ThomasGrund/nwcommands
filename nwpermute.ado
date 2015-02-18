*! Date        : 3sept2014
*! Version     : 1.0.4
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwpermute	
program nwpermute
	version 9.0
	syntax [anything(name=netname)], [ id(string) xvars name(string) vars(string) stub(string) noreplace ]
	
	_nwsyntax `netname', max(1)
	scalar onevars = "\$nw_`id'"
	local vars `=onevars'
	
	// generate valid network name and valid varlist
	if "`name'" == "" {
		local name "`netname'_perm"
	}
	if "`stub'" == "" {
		local stub "perm"
	}

	nwvalidate `name'
	local name = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(`stub')
		local permvars "$validvars"
	}
	else {
		local permvars "`vars'"
	}

	nwtomata `netname', mat(onenet)
	mata: perm = permutenet(onenet)

	if "`directed'"=="false" {
		local undirected = "undirected"
	}
	nwduplicate `netname', name(`name')
	nwreplacemat `name', newmat(perm)
end

capture mata mata drop permutenet()
mata:
real matrix permutenet(real matrix nwadj) {
	nsize = rows(nwadj)
	permutationVec = unorder(nsize)
	return (nwadj[permutationVec, permutationVec])
}
end




