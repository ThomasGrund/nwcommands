global char _dta[NWversion] = 1

local v1NWs	nw
local v1NWdef	network
local v1NWsdef	networks
local v1NWsder	nwsder

mata: mata clear
mata:

struct `v1NWs' {
	class `v1NWsdef' scalar	nws
	class `v1NWsder' scalar nwsd
}

class `v1NWsdef' {
	string	rowvector						networknames
	pointer (`v1Nwdef' scalar) colvector	p
}

class `v1NWdef' {
	string scalar		networkname
	string colvector 	nodenames
	string colvector	modes
	
	real matrix			e
	
	numeric scalar 		directed
	numeric scalar		valued
	
	void					set()
	real matrix 			get_adjacency()
	pointer (real matrix)	get_adjacency_original()
}

class `v1NWsder' {
	string scalar datasig
}


void `v1NWdef'::set(string scalar networkname, string colvector nodenames, real matrix e, numeric scalar directed){
	this.networkname = networkname
	this.nodenames = nodenames
	this.e = e
	this.directed = directed
	
	if (max(e) > 1 | min(e) < 0) {
		this.valued = 1
	}
	else {
		this.valued = 0
	}
} 

real matrix `v1NWdef'::get_adjacency(){
	return(e)
}

pointer(real matrix) `v1NWdef'::get_adjacency_original(){
	return(&e)
}

end

mata: w = nw
