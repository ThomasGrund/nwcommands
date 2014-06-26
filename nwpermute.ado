capture program drop nwpermute	
program nwpermute
	version 9.0
	syntax [anything(name=netname)], [ id(string) xvars name(string) vars(string) stub(string) noreplace ]
	
	nwset, nooutput
	if ("`netname'" == "") {
		nwcurrent
		local netname=r(current)
	}

	// get parameters
	nwname `netname'
	local nodes = r(nodes)
	local id = r(id)
	local directed = r(directed)
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
	nwrandom `nodes', prob(0) name(`name') vars(`vars') `undirected' `xvars'
	nwreplacemat `netname', newmat(perm)
end

capture mata mata drop permutenet()
mata:
real matrix permutenet(real matrix nwadj) {
	nsize = rows(nwadj)
	permutationVec = unorder(nsize)
	return (nwadj[permutationVec, permutationVec])
}
end




