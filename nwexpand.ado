capture program drop nwexpand	
program nwexpand
	syntax varlist(min=1 max=1) [if],[ stub(string) mode(string) vars(string) nodes(integer 0) xvars name(string) noreplace]
	
	preserve
	if "`if'" != "" {
		qui keep `if'
	}
	
	// check if this is the first network in this Stata session
	if "$nwtotal" == "" {
		global nwtotal = 0
	}
	// get important parameters
	if ("`mode'" == ""){
		local mode = "same"
	}
	
	
	_opts_oneof "same dist absdist distinv abdistinv sender receiver" "mode" "`mode'" 6555

	if `nodes' == 0{
		qui sum `varlist'
		local nodes = r(N)
		if (`nodes'==0){
			error 6200
		}
	}
	
	if `nodes' > `=_N' {
		di "{err}Not enough observations for variable {bf:`varlist'}."
		error 6200
	}
		
	// generate valid network name and valid varlist
	if "`name'" == "" {
		local name "`mode'_`varlist'"
	}
	if "`stub'" == "" {
		local stub "`mode'"
	}
	nwvalidate `name'
	local expandname = r(validname)
	nwvalidvars `nodes', stub("`stub'")
	local expandvars "$validvars"
		
	// generate network
	mata: attr = st_data((1::`nodes'),"`varlist'")
	if "`mode'" == "" {
		di "{txt}Option {it:mode(same)} selected."
		local mode = "same"
	}
	if( "`mode'" == "dist"){
		mata: expnet = distMat(attr)
	}
	if ("`mode'" == "distinv"){
		mata: expnet = distMat(attr)
		mata: expnet = expnet :* (-1)
	}
	if ("`mode'" == "absdist"){
		mata: expnet = distMat(attr)
		mata: expnet = ((expnet:<0) :* (expnet :* -2)) + expnet
		local undirected "undirected"
	}
	if("`mode'" == "absdistinv") {
		mata: expnet = distMat(attr)
		mata: expnet = ((expnet:<0) :* (expnet :* -2)) + expnet
		mata: expnet = J(`nodes',`nodes',-max(expnet)) - expnet
		local undirected "undirected"
	}
	if "`mode'" == "same" {
		mata: expnet = simMat(attr)
		local undirected "undirected"
	}
	if "`mode'" == "sender" {
		mata: expnet = senderMat(attr)		
	}
	if "`mode'" == "receiver" {
		mata: expnet = receiverMat(attr)		
	}
	nwset, mat(expnet) name(`expandname)') vars(`expandvars') `undirected'
	
	if "`xvars'" == "" {
		nwload `expandname'
	}
	capture mata: mata drop expnet 
	capture mata: mata drop attr
	restore
end
	
capture mata mata drop distMat()
capture mata mata drop simMat()
capture mata mata drop senderMat()
capture mata mata drop receiverMat()

mata:	
real matrix senderMat(real matrix attr){
	nsize = rows(attr)
	temp = attr :* I(nsize)
	rowMat = temp * J(nsize,nsize,1)
	return(rowMat)
}
real matrix receiverMat(real matrix attr){
	nsize = rows(attr)
	temp = attr :* I(nsize)
	rowMat = temp * J(nsize,nsize,1)
	colMat = rowMat'
	return(colMat)
}
real matrix distMat(real matrix attr){
	nsize = rows(attr)
	temp = attr :* I(nsize)
	rowMat = temp * J(nsize,nsize,1)
	colMat = rowMat'
	distMat = rowMat :- colMat
	return(distMat)
}
real matrix simMat(real matrix attr){
	nsize = rows(attr)
	temp = attr :* I(nsize)
	rowMat = temp * J(nsize,nsize,1)
	colMat = rowMat'
	distMat = rowMat :- colMat
	simMat = (distMat:==0) :* J(nsize,nsize,1) 
	return(simMat)
}
end
