capture program drop nwhierarchy
program nwhierarchy
	syntax [anything(name=netname)] [, dismat(string) disnet(string) linkage(string) type(string) context(string) clear add * ]
	_nwsyntax `netname'
	
	if "`clear'" == "" & "`add'" == "" {
		local add = "add"
	}
	
	if "`linkage'" == "" {
		local linkage = "singlelinkage"
	}
	
	if "`dismat'" == "" {
		local dismat "mymat"
		if "`disnet'" != "" {
			nwtomatafast `disnet'
			mata: st_matrix("`dismat'", `r(mata)')
		}
		else {
			nwdissimilar `netname', type(`type') context(`context') name(_temp_dissimilar)
			nwtomatafast _temp_dissimilar
			mata: st_matrix("`dismat'", `r(mata)')
			nwdrop _temp_dissimilar
		}
	}
	
	clustermat `linkage' `dismat', `options' `add' `clear'
	qui nwload `netname', labelonly
end








	
