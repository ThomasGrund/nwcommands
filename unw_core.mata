*! version 1.0.0  02oct2015

/*
!! low level Mata functions for nwcommands 
*/

/* -------------------------------------------------------------------- */
//!! require a Stata version change before release
version 14

set matastrict on
	
local NWVersion	1

/* -------------------------------------------------------------------- */
					/* Shorthands for types		*/
local RS	real scalar
local RR	real rowvector
local RC	real colvector
local RM	real matrix

local SS	string scalar
local SR	string rowvector
local SC	string colvector
local SM	string matrix
local BOOL	real scalar

/* -------------------------------------------------------------------- */
					/* Derived types 		*/
local 	True	1
local 	False	0

//!! more derived types

/* -------------------------------------------------------------------- */
					/* Derived type:  version1 	*/
local 	v1NWs		__v1nws_cls
local 	v1NWsdef	__v1nws_clsdef		// class definition
//!! for datasig ??
local 	v1NWsder	__v1nws_clsder		
local 	v1NWdef		__v1nw_clsdef		// single network definition

local 	NWs		`v1NWs'
local 	NWsdef		`v1NWsdef'
local 	NWsder		`v1NWsder'
local 	NWdef		`v1NWddef'

/* -------------------------------------------------------------------- */
					/* constants			*/
local 	cDftNWpef	"network_"	//default network name pefix
local 	cDftNodepef	"net"		//default node name prefix

/* -------------------------------------------------------------------- */
					/* Error codes			*/
local 	errNWsCrete	480		
local 	errNodeDupName	481		

/* -------------------------------------------------------------------- */
					/* Utilities			*/
mata:
/* 
	Find the first index of matching string 
*/
real scalar first_index_match(string vector src, string scalar t)
{
	real scalar i, dim
	
	dim = rows(src)*cols(src)
	for(i=1; i<=dim; i++){
		if(src[i]==t) {
			return(i)
		}
	}
	return(0)
}

/*
	Display various error messages 
*/
void error_handle(string scalar r, real scalar code){
	errprintf(r)  
	exit(code)
}

end
					/* End utilities		*/
/* -------------------------------------------------------------------- */


mata:
/* -------------------------------------------------------------------- */
/* 
	Version 1 gobal object
		nwsdef is definition of networks
		nwsder is derived from nws
*/

class `v1NWs' {
	static class `v1NWsdef' scalar nws
	static class `v1NWsder' scalar nwsder
//!! methods:
}

/* -------------------------------------------------------------------- */
/* 
	Version 1 definition of a network
		name:		the name of the network
		label:		the label of the network
		nodenames:	name of nodes
		modes:		mode of nodes
		edge:		edge matrix
		isdirect:	if is direct graph
		ismode:		if node has modes
TODO:
	modes is not handled yet 
*/
class `v1NWdef' {
	string scalar 		name
	string scalar 		label
	string rowvector 	nodes
	string rowvector 	modes
	real matrix 		edge
	real scalar 		isdirect
	real scalar 		ismode
//!! how edge matrix is stored	
	real scalar 		edgetype  
//!! methods:
	void create() 
	void create_by_name()
	void init_edge()
	void set_name()
	void set_isdirect()
	void connect_edge()
	void add_node()
	void zap()
	void dumper()
	
	real matrix get_adjacency()
}

/*
	Create a network with n nodes
*/
void `v1NWdef'::create(real scalar n, | string scalar prefix) {
	zap()
	if(args() == 1) {
		nodes = "`cDftNodepef'" :+ strofreal((1..n))
	}
	else {
		nodes = prefix :+ strofreal((1..n))	
	}
	init_edge()
}

real matrix `v1NWdef'::get_adjacency(){
	return(edge)
}

/*
	Create a network with n nodes by name
*/
void `v1NWdef'::create_by_name(string rowvector name) {
	zap()
	nodes = name 
	init_edge()
}

/* 
	Set name property
*/
void `v1NWdef'::set_name(string scalar s) {
	name = s 
}

/* 
	Set isdirect property
*/
void `v1NWdef'::set_isdirect(real scalar d) {
	if(d != 0) {
		isdirect = `True'
	}
	else {
		isdirect = `False'	
	}
}

/*
	Initialize edge matrix
*/
void `v1NWdef'::init_edge() {
	real scalar size
//!! create edge matrix based on edgetype
	size = cols(nodes)
	edge = J(size, size, 0)	
}

/*
	Update edge matrix given a list of nodes connecting to node i
*/
void `v1NWdef'::connect_edge(real scalar i, real rowvector rj) {
	edge[i, rj] = J(1, cols(rj), 1)
	if(!isdirect) {
		edge[rj', i] = J(cols(rj), 1, 1)	
	}
}

/*
	Add a node
*/
void `v1NWdef'::add_node(string scalar s) {
	real scalar idx, size
	idx = first_index_match(nodes, s)
	if(idx > 0) {
		error_handle("`vlNWdef': node name already exists.", 
			`errNodeDupName') 
	}
	size = cols(nodes)
	nodes = (nodes, s)
	if(ismode) {
		modes = (modes, "")
	}
	edge = (edge, J(size, 1, 0)\J(1, size+1, 0)) 
}

/* 
	Cleanup of the network
*/
void `v1NWdef'::zap() {
	name = ""
	label = ""
	nodes = J(0, 0, "")
	modes = J(0, 0, "")
	edge  = J(0, 0, 0)
	isdirect = `False'
	ismode   = `False'
}

/*
	Print out network information
*/
void `v1NWdef'::dumper(string scalar prefix) {
	real scalar i, j, size 
	string scalar s
	
	// name
	printf(prefix)
	printf("name: %s\n", name)
	
	// label
	printf(prefix)
	printf("label: %s\n", label)

	// isdirect
	if(isdirect) {
		s = "true"
	}
	else {
		s = "false"
	}
	printf(prefix)
	printf("direct: %s\n", s)

	size = cols(nodes)
	printf(prefix)
	printf("size: %g\n", size)
	
	// ismode
	if(ismode) {
		s = "true"
	}
	else {
		s = "false"
	}
	printf(prefix)
	printf("mode: %s\n", s)

	if(ismode) {
		printf(prefix)
		printf("mode:")
		for(i=1; i<cols(modes); i++) {
			printf("%s; ", modes[i])  
		}
		if(cols(modes) != 0) {
			printf("%s", modes[cols(modes)])  		
		}
		printf("\n")
	}

	// nodes
	printf(prefix)
	printf("nodes:")
	for(i=1; i<size; i++) {
		printf("%g.%s; ", i, nodes[i])  
	}
	if(size != 0) {
		printf("%g.%s", size, nodes[size])  		
	}
	printf("\n")

	// edges
	printf(prefix)
	printf("edges:\n")
	for(i=1; i<=size; i++) {
		printf(prefix)
		printf("  %g.%s: ", i, nodes[i])
		for(j=1; j<=size; j++) {
			if(edge[i, j] != 0) { 
				printf("%g.%s;", j, nodes[j])
			}
		}
		printf("\n")
	}
	printf("\n")
}
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
/* 
	Version 1 definition of networks
		names[i] is the name of the networks
		pdefs[i] points to network definition
*/
class `v1NWsdef' {
	string rowvector 				names
	pointer(class `v1NWdef' scalar) rowvector 	pdefs

//!! methods:
	void create()	
	void create_by_name()
	void add()
	void dumper()
}

/*
	Create n networks 
*/
void `v1NWsdef'::create(real scalar n) {
	real scalar i 
	
//!! do we want an upper limit ??
	if(n <= 0) {	
		error_handle("`v1NWsdef':the number of networks must be positive", `errNWsCrete')
	}
	
	names =  "`cDftNWpef'" :+ strofreal((1..n))
	pdefs = J(1, n, NULL)
	for(i=1; i<=n; i++) {
		pdefs[i] = &(`v1NWdef'())
		pdefs[i]->set_name(names[i])
	}
}

/*
	Create networks by name
*/
void `v1NWsdef'::create_by_name(string rowvector s) {
	real scalar n, i 

	n = cols(s)
//!! do we need an upper limit ??
	if(n <= 0) {	
		error_handle("`v1NWsdef':the number of networks must be positive", `errNWsCrete')
	}

	names = s	
	pdefs = J(1, n, NULL)
	for(i=1; i<=n; i++) {
		pdefs[i] = &(`v1NWdef'())
		pdefs[i]->set_name(names[i])
	}
}

/*
	Add one networks
*/
void `v1NWsdef'::add(string scalar s) {

	real scalar i, size
	
	i = first_index_match(names, s)
	if(i>0) {
		error_handle("Name already exists", 482)
	}
	
	names = (names, s)
	pdefs = (pdefs, NULL)
	size = cols(pdefs)
	pdefs[size] = &(`v1NWdef'())
	pdefs[size]->set_name(names[size])
}

/*
	Print out network information 
*/
void `v1NWsdef'::dumper() {
	real scalar i 
	for(i=1; i<=cols(names); i++) {
		printf("Network %s:\n", names[i])
		pdefs[i]->dumper("	")
	}
}

/* -------------------------------------------------------------------- */
/* 
	Version 1 definition of derived-across-network datasig
*/
class `v1NWsder' {
	string scalar datasig		// used by -nw_datasync-
//!! methods:
}

/* -------------------------------------------------------------------- */
/* 
	Version 1 interface routines for interactive session
*/
class `v1NWs' scalar nws_create()
{
	class `v1NWs'  scalar a 
	return(a)
}

end
