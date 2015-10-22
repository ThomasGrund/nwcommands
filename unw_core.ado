clear mata

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

unw_defs

/*					
local 	vxNWs		nws
local 	vxNWsdef	nws_def
local 	vxNWsder	nws_der		
local 	vxNWdef		nw_def		
*/

local 	NWs			`vxNWs'
local 	NWsdef		`vxNWsdef'
local 	NWsder		`vxNWsder'
local 	NWdef		`vxNWdef'


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

class `NWs' {
	static class `NWsdef' scalar nws
	static class `NWsder' scalar nwsder
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
class `NWdef' {
	string scalar 		name
	string scalar 		label
	string scalar		caption
	string rowvector 	nodes
	string rowvector	nodesvar
	string rowvector 	modes
	real matrix 		edge
	`BOOL'				isdirect
	`BOOL'				isvalued
	`BOOL'		 		ismode
	`BOOL'				isselfloop
	
//!! how edge matrix is stored	
	real scalar 		edgetype  
//!! methods:

	void create() 
	void create_by_name()
	void init_edge()
	void set_name()
	string scalar get_name()
	void set()
	void set_edge()
	void set_nodes_from_string()
	real scalar get_nodes()
	real matrix get_edge()
	pointer(real matrix) get_edge_original()
	void set_directed()
	string scalar is_selfloop()
	string scalar is_valued()
	string scalar is_directed()
	string scalar is_2mode()
	string scalar get_label()
	string scalar get_caption()
	void set_label()
	void set_caption()
	void set_nodes()
	void set_selfloop()
	void connect_edge()
	void add_node()
	void zap()
	void dumper()
	string scalar get_vars()
	real scalar get_maximum()
	real scalar get_minimum()
	real scalar get_missing_edges()
	real scalar get_edges_count()
	real scalar get_edges_sum()
	real scalar get_arcs_count()
	real scalar get_arcs_sum()
	real scalar get_density()
	real scalar get_selfloops_number()
	void update_nodesvar()
}

/*
	Update variable names that should be used when loading data to Stata
*/
void `NWdef'::update_nodesvar(){
	real scalar i, j, k
	
	k = cols(nodesvar)
	
	nodesvar = strtoname(nodes)
	for(i = 1; i<=k;i++){
		for(j = 1; j<=k;j++){
			if (nodesvar[i] == nodesvar[j]){
				j = k + 1
				i = j
				nodesvar = J(1,k,"`nwvars_def_pref'") + (strofreal(1::k))'
			}
		}	
	}
}

/*
	Get number of self-loops
*/
real scalar `NWdef'::get_selfloops_number(){
	real matrix e
	
	if (isselfloop == 1) { 
		e = diagonal(get_edge())
		return(sum(e :/ e))	
	}
	else {
		return(0)
	}
}

/*
	Get network density
*/
real scalar `NWdef'::get_density(){
	real matrix e
	real scalar possnodes
	
	e = get_edge()
	
	e = e:/e
	possnodes = (cols(e) * cols(e) )
	
	if (isselfloop != 1){
		_diag(e,0)
		possnodes = possnodes - cols(e)
	}

	if (ismode == 0) {
		return(sum(e) / possnodes)
	}
	if (ismode == 1){
//!! TODO implement two- and multi-modes		
		return(sum(e)/ possnodes)
	}
}


/*
	Get edges counts
*/
real scalar `NWdef'::get_edges_count(){
	real matrix e
	
	e = get_edge()
	return(sum(e:==. & e:==0)/2)
}

/*
	Get sum of edge values
*/
real scalar `NWdef'::get_edges_sum(){
	real matrix e
	
	e = get_edge()
	return(sum(e)/2)
}

/*
	Get arcs counts
*/
real scalar `NWdef'::get_arcs_count(){
	real matrix e
	
	e = get_edge()
	return(sum(e:!=. :& e:!=0))
}

/*
	Get sum of arc values
*/
real scalar `NWdef'::get_arcs_sum(){
	real matrix e
	
	e = get_edge()
	return(sum(e))
}

/*
	Get missing edge values
*/
real scalar `NWdef'::get_missing_edges(){
	real matrix e
	
	e = get_edge()
	return(sum(e:==.))
}

/*
	Get minimum edge value
*/
real scalar `NWdef'::get_minimum(){
	real matrix e
	
	e = get_edge()
	return(min(e))
}

/*
	Get maximum edge value
*/
real scalar `NWdef'::get_maximum(){
	real matrix e
	
	e = get_edge()
	return(max(e))
}

/*
	Set network label
*/
void `NWdef'::set_label(string scalar s){
	label = s
}

/*
	Set network caption
*/
void `NWdef'::set_caption(string scalar s){
	caption = s
}

/*
	Set new nodes
*/
void `NWdef'::set_nodes(rowvector n){
	nodes = n
}

void `NWdef'::set_nodes_from_string(string scalar s){
	nodes = s
}

/*
	Return network label
*/
string scalar `NWdef'::get_label(){
	return(label)
}

/*
	Return network caption
*/
string scalar `NWdef'::get_caption(){
	return(caption)
}

/*
	Return true/false string if network is valued
*/
string scalar `NWdef'::is_valued(){
	if (isvalued == 1) {
		return("true")
	}
	else {
		return("false")
	}
}

/*
	Return true/false string if network has self-loops
*/
string scalar `NWdef'::is_selfloop(){
	if (isselfloop == 1) {
		return("true")
	}
	else {
		return("false")
	}
}

/*
	Return true/false string if network is two-mode
*/
string scalar `NWdef'::is_2mode(){
	if (ismode == 1) {
		return("true")
	}
	else {
		return("false")
	}
}

/*
	Return true/false string if network is directed
*/
string scalar `NWdef'::is_directed(){
	if (isdirect == 1) {
		return("true")
	}
	else {
		return("false")
	}
}

/* 
	Return list of variables for network representation in dataset
*/
string scalar `NWdef'::get_vars(){
	 string scalar s
	 real scalar i
	 
	 for(i = 1 ; i<= get_nodes(); i++) {
			s = s + " " + ustrtoname(nodes[i])
	 }
	 return(s)
}
	
/*
	Return number of nodes
*/
real scalar `NWdef'::get_nodes(){
	return(cols(nodes))
}

/*
	Return name of a network
*/
string scalar `NWdef'::get_name(){
	return(name)
}

/*
	Create a network with n nodes
*/
void `NWdef'::create(real scalar n, | string scalar prefix) {
	zap()
	if(args() == 1) {
		nodes = "`cDftNodepef'" :+ strofreal((1..n))
	}
	else {
		nodes = prefix :+ strofreal((1..n))	
	}
	update_nodevars()
	init_edge()
}

/*
	Set a network
*/
void `NWdef'::set(string scalar networkname, string colvector nodenames, real matrix edge, `BOOL' isdirect){
	this.name = networkname
	this.nodes = nodenames
	this.edge = edge
	this.isdirect = isdirect
	
	if (max(edge) > 1 | min(edge) < 0) {
		this.isvalued = `True'
	}
	else {
		this.isvalued = `False'
	}
} 

/*
	Create a network with n nodes by name
*/
void `NWdef'::create_by_name(string rowvector name) {
	zap()
	nodes = name 
	update_nodesvar()
	init_edge()
}

/* 
	Set name property
*/
void `NWdef'::set_name(string scalar s) {
	name = s 
}

/* 
	Set isselfloop property
*/
void `NWdef'::set_selfloop(string scalar d) {
	if(ustrlower(d) == "true") {
		isselfloop = `True'
	}
	else {
		isselfloop = `False'	
	}
}

/* 
	Set isdirect property
*/
void `NWdef'::set_directed(string scalar d) {
	if(ustrlower(d) != "true") {
		isdirect = `True'
	}
	else {
		isdirect = `False'	
	}
}

/*
	Initialize edge matrix
*/
void `NWdef'::init_edge() {
	real scalar size
//!! create edge matrix based on edgetype
	size = cols(nodes)
	edge = J(size, size, 0)	
}

/*
	Set edge matrix
*/
void `NWdef'::set_edge(real matrix edge1) {
	edge = edge1
}

/*
	Get edge matrix
*/
real matrix `NWdef'::get_edge() {
//!! generate edge matrix based on edgetype
	return(edge)
}

/*
	Get pointer to edge matrix
*/
pointer(real matrix) `NWdef'::get_edge_original(){
	return(&edge)
}

/*
	Update edge matrix given a list of nodes connecting to node i
*/
void `NWdef'::connect_edge(real scalar i, real rowvector rj) {
	edge[i, rj] = J(1, cols(rj), 1)
	if(!isdirect) {
		edge[rj', i] = J(cols(rj), 1, 1)	
	}
}

/*
	Add a node
*/
void `NWdef'::add_node(string scalar s) {
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
void `NWdef'::zap() {
	name = ""
	label = ""
	caption = ""
	nodes = J(0, 0, "")
	modes = J(0, 0, "")
	edge  = J(0, 0, 0)
	isdirect = `False'
	ismode   = `False'
}

/*
	Print out network information
*/
void `NWdef'::dumper(string scalar prefix) {
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
			if(edge[i, j] != 0 & edge[i,j] != .) { 
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
class `NWsdef' {
	string rowvector 				names
	pointer(class `NWdef' scalar) rowvector 	pdefs
	real scalar number  // number of networks in memory
	pointer(class `NWdef' scalar) scalar pcurrent
	
//!! methods:
	void create()	
	void create_by_name()
	void add()
	void dumper()
	void update_number()
	void delete_index()
	void delete_name()
	void rename()
	real scalar get_number()
	real scalar get_index_of() 	// return the index of a network with a name
	string scalar get_names()
	void make_current()
	void make_current_from_name()
	real scalar get_index_of_current()
	string scalar get_current_name()
	real scalar get_max_nodes()
	string scalar get_valid_name()
}


string scalar `NWsdef'::get_valid_name(string scalar s){
	real scalar i, suffix
	string scalar snew
	
	snew = s
	suffix = 1
	i = first_index_match(names, s)
	
	if (i != 0) {
		snew = s + "_" + strofreal(suffix)
		while (first_index_match(names, snew)!= 0) {
			suffix = suffix + 1
			snew = s + "_" + strofreal(suffix)
		}
	}
	return(snew)
}

/*
	Get number of largest network
*/
real scalar `NWsdef'::get_max_nodes(){
	real scalar n, m, i
	
	n = 0
	for (i = 1; i<= 1; i++){
		n = max((n,pdefs[i]->get_nodes()))
	}
	return(n)
}

/*
	Get index of current network
*/
real scalar `NWsdef'::get_index_of_current(){
	string scalar s

	s = pcurrent->get_name()
	return(first_index_match(names, s))
}

/*
	Get name of current network
*/
string scalar `NWsdef'::get_current_name(){
	return(pcurrent->get_name())
}

/*
	Make current network from index i
*/
void `NWsdef'::make_current(real scalar i){
	pcurrent = pdefs[i]
}

/*
	Make current network from name s
*/
void `NWsdef'::make_current_from_name(string scalar s){
	real scalar i 
	
	i = first_index_match(names, s)
	make_current(i)
}

/*
	Get string with list of all networks
*/
string scalar `NWsdef'::get_names(){
	real scalar i
	string scalar s

	for(i = 1; i<=get_number(); i++){
		s = s + " " + names[i]
	}
	return(s)
}

/* 
	Rename network oldname and call it newname
*/
void `NWsdef'::rename(string scalar oldname, string scalar newname){
	real scalar i

	i = first_index_match(names, oldname)

	if(i==0) {
		error_handle("Network name " + oldname + " does not exist. " , `errNWsNotFound')
	}
	names[i] = newname
	pdefs[i]->set_name(newname)
}

/*
	Delete network with index i
*/
void `NWsdef'::delete_index(real scalar i){
	real scalar size
	real matrix k
	
	size = cols(names)
	if(i == 0 | i > size) {	
		error_handle("`NWsdef':network not found", `errNWsNotFound')
	}
	
	k = J(1,size,1)
	k[i] = 0
	pdefs = select(pdefs, k)
	names = select(names, k)
	number = number - 1
}

/*
	Delete network with name s
*/
void `NWsdef'::delete_name(real scalar s){
	delete_index(first_index_match(names,s))
}


/* 
	Get index of a network with a particular name s
*/
real scalar `NWsdef'::get_index_of(string scalar s){
	return(first_index_match(names, s))
}

/*
	Update number of networks
*/
void `NWsdef'::update_number() {
	number = cols(pdefs)
}

/*
	Get number of networks
*/
real scalar `NWsdef'::get_number() {
	return(cols(pdefs))
}

/*
	Create n networks 
*/
void `NWsdef'::create(real scalar n) {
	real scalar i 
	
//!! do we want an upper limit ??
	if(n <= 0) {	
		error_handle("`NWsdef':the number of networks must be positive", `errNWsCrete')
	}
	
	names =  "`cDftNWpef'" :+ strofreal((1..n))
	pdefs = J(1, n, NULL)
	for(i=1; i<=n; i++) {
		pdefs[i] = &(`NWdef'())
		pdefs[i]->set_name(names[i])
	}
}

/*
	Create networks by name
*/
void `NWsdef'::create_by_name(string rowvector s) {
	real scalar n, i 

	n = cols(s)
//!! do we need an upper limit ??
	if(n <= 0) {	
		error_handle("`NWsdef':the number of networks must be positive", `errNWsCreate')
	}	

	names = s	
	pdefs = J(1, n, NULL)
	for(i=1; i<=n; i++) {
		pdefs[i] = &(`NWdef'())
		pdefs[i]->set_name(names[i])
	}
}

/*
	Add one networks
*/
void `NWsdef'::add(string scalar s) {

	real scalar i, size
	
	i = first_index_match(names, s)
	if(i>0) {
		error_handle("Network name already exists" , `errNWsExists')
	}
	
	names = (names, s)
	pdefs = (pdefs, NULL)
	size = cols(pdefs)
	pdefs[size] = &(`NWdef'())
	pdefs[size]->set_name(names[size])
	pcurrent = pdefs[size]
}

/*
	Print out network information 
*/
void `NWsdef'::dumper() {
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
class `NWsder' {
	string scalar datasig		// used by -nw_datasync-
//!! methods:
}

/* -------------------------------------------------------------------- */
/* 
	Version 1 interface routines for interactive session
*/
class `NWs' scalar nws_create()
{
	class `NWs'  scalar a 
	return(a)
}

end
