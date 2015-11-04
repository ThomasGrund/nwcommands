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
					/* constants			*/
local 	cDftNWpef	"network_"	//default network name pefix
local 	cDftNodepef	"net"		//default node name prefix

/* -------------------------------------------------------------------- */
					/* Error codes			*/
local 	errNWsCreate	480		
local 	errNodeDupName	481	
local 	errNWsNotFound	482		
local 	errNWsExists	483	

/* -------------------------------------------------------------------- */
					/* Utilities			*/
mata:
/* 
	Find the first index of matching string 
*/
real scalar first_index_match(string vector src, string scalar t)
{
	real scalar i, dim
	if (cols(src) == 0 | rows(src) == 0){
		return(0)
	}
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

/*
	Match two string vectors
*/
real matrix match_xy(string matrix x, string matrix y){
	real scalar i, j, Mdim
	real matrix M
	string scalar x_i
	
	Mdim = rows(x)
	M = J(Mdim,2,.)
	M[(1::rows(x)),1] = (1::rows(x))

	for (i = 1; i<= rows(x);i++){
		for (j = 1; j<= rows(y);j++){
			if (x[i] == y[j]) {
				M[i,2] = j
			}
		}
	}
	return(M)
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
	class `NWsdef' scalar nws
	class `NWsder' scalar nwsder
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
		is2mode:	if network is two-mode
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
	real colvector		match // holds information about case numbers to which nodes 1,2,3... match
	
	real matrix 		edge
	`BOOL'				isdirect
	`BOOL'				isvalued
	`BOOL'		 		is2mode
	`BOOL'				isselfloop
	
//!! how edge matrix is stored	
	real scalar 		edgetype  
//!! methods:

	void symmetrize()
	void create() 
	void create_by_name()
	void init_edge()

	string scalar get_name()
	real scalar get_nodes()
	string matrix get_nodenames()
	string scalar get_nodesvar()
	real matrix get_matrix()
	real matrix get_matrix_unvalued()
	string matrix get_edgelist()
	real matrix get_outdegree()
	real matrix get_indegree()
	pointer(real matrix) get_matrix_original()

	string scalar is_selfloop()
	string scalar is_valued()
	string scalar is_directed()
	string scalar is_2mode()
	real scalar get_selfloop_boolean()
	real scalar get_valued_boolean()
	real scalar get_directed_boolean()
	real scalar get_2mode_boolean()
	string scalar get_label()
	string scalar get_caption()
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
	
	void set()
	void set_name()
	void set_nodenames()
	void set_nodes_from_string()
	void set_edge()
	void set_label()
	void set_caption()
	void set_nodes()
	void set_selfloop()
	void set_directed()
	void set_valued()
	void set_2mode()
	
	void connect_edge()
	void add_node()
	void zap()
	void dumper()
	void update_nodesvar()
	void update_match()
	void data_sync()
	string scalar check_symmetry()
	void keep_nodes()
	void drop_nodes()
}

string scalar `NWdef'::get_nodesvar(){
	return(invtokens(nodesvar," "))
}

string matrix `NWdef'::get_edgelist(real scalar undirected, real scalar isolates0){
	string matrix sender, receiver
	real scalar i, size
	real matrix e, z
	
	e = get_matrix()
	if is_
	if (undirected == 1) {
		z = (J(rows(e), cols(e), 1) :- uppertriangle(J(rows(e), cols(e),1))) * (`missing2')
		e = e:* uppertriangle(J(rows(e), cols(e),1)) +  z 
	}
	size = rows(e)
	sender = nodes'
	receiver = J(size, 1, nodes[1])
	
	for(i = 2; i<= size; i++){
		sender = (sender \ nodes')
		receiver = (receiver \(J(size, 1, nodes[i])))
	}
	return((sender, receiver, strofreal(vec(e))))
}

void `NWdef'::drop_nodes(rowvector d){
	keep_nodes(d:==0)
}

void `NWdef'::keep_nodes(rowvector k){
	real matrix edge_new
	string matrix modes_new, nodesvar_new, nodes_new

	if (cols(k) == cols(nodes)){
		nodes_new = select(nodes,k)
		nodesvar_new = select(nodesvar,k)
		if (is2mode == 1){
			modes_new = select(modes,k)
		}
		edge_new = select(edge,k)
		edge_new = select(edge_new,k')
		nodes = nodes_new
		nodesvar = nodesvar_new
		modes = modes_new
		edge = edge_new
	}
}

real scalar `NWdef'::get_selfloop_boolean(){
	return(isselfloop)
}

real scalar `NWdef'::get_valued_boolean(){
	return(isvalued)
}

real scalar `NWdef'::get_directed_boolean(){
	return(isdirect)
}

real scalar `NWdef'::get_2mode_boolean(){
	return(is2mode)
}
	
void `NWdef'::set_valued(real scalar d){
	isvalued = d
}

void `NWdef'::set_2mode(real scalar d){
	is2mode = d
}

string scalar `NWdef'::check_symmetry(){
//!! TODO - change when network not saved as matrix edge
	if (edge == edge'){
		return("true")
	}
	return("false")
}

void `NWdef'::symmetrize(string scalar mode){
//!! TODO - change when network not saved as matrix edge	
	real matrix d, res1, res2
	d = diagonal(edge)
	
	if (mode == "sum") {
		edge = edge  + edge'
	}
	if (mode == "mean") {
		edge = (edge  + edge'):/2
	}
	if (mode == "max") {
		res2 = (edge')
		res2 = ((edge') :> edge):* res2
		res1 = edge
		res1 = (edge :>= (edge')):* res1
		edge = res1 + res2
	}
	if (mode == "min") {
		res2 = (edge')
		res2 = ((edge') :< edge):* res2
		res1 = edge
		res1 = (edge :<= (edge')):* res1
		edge = res1 + res2
	}
	_diag(edge,d)
	set_directed(0)
}

real matrix `NWdef'::get_indegree(real scalar valued){
	real matrix e 
	if (valued == 0){
		e = get_matrix()
	}
	else {
		e = get_matrix_unvalued()
	}
	return(colsum(e)')
}

real matrix `NWdef'::get_outdegree(real scalar valued){
	real matrix e 
	if (valued == 0){
		e = get_matrix()
	}
	else {
		e = get_matrix_unvalued()
	}
	return(rowsum(e))
}

string matrix `NWdef'::get_nodenames(){
	return(nodes)
}

/*
	Sync network with dataset
*/
void `NWdef'::data_sync(){
	real scalar newobs
	real scalar N, z, v
	string colvector newnodename

	z = 0
	if (_st_varindex("`nw_nodename'") == .) {
		v= st_addvar("str40","`nw_nodename'")
		z = st_nobs()
	}
	
	update_match()
	newobs = sum(match[,2]:==.) - z
	
	N = st_nobs()
	if (newobs > 0){
		st_addobs(newobs)
		newnodename = select(nodes,(match[.,2]:==.)')'
		st_sstore(((N+1)::(N+newobs)),"`nw_nodename'", newnodename)	
		update_match()
	}
}

/*
	Update matching between nodes 1,2,3... and cases in the dataset.
*/
void `NWdef'::update_match(){
	match = match_xy(nodes',st_sdata(.,"`nw_nodename'"))	
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
		e = diagonal(get_matrix())
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
	
	e = get_matrix()
	
	e = e:/e
	possnodes = (cols(e) * cols(e) )
	
	if (isselfloop != 1){
		_diag(e,0)
		possnodes = possnodes - cols(e)
	}

	if (is2mode == 0) {
		return(sum(e) / possnodes)
	}
	if (is2mode == 1){
//!! TODO implement two- and multi-modes		
		return(sum(e)/ possnodes)
	}
}


/*
	Get edges counts
*/
real scalar `NWdef'::get_edges_count(){
	real matrix e
	
	e = get_matrix()
	return(sum(e:!=. :& e:!=0)/2)
}

/*
	Get sum of edge values
*/
real scalar `NWdef'::get_edges_sum(){
	real matrix e
	
	e = get_matrix()
	return(sum(e)/2)
}

/*
	Get arcs counts
*/
real scalar `NWdef'::get_arcs_count(){
	real matrix e
	
	e = get_matrix()
	return(sum(e:!=. :& e:!=0))
}

/*
	Get sum of arc values
*/
real scalar `NWdef'::get_arcs_sum(){
	real matrix e
	
	e = get_matrix()
	return(sum(e))
}

/*
	Get missing edge values
*/
real scalar `NWdef'::get_missing_edges(){
	real matrix e
	
	e = get_matrix()
	return(sum(e:==.))
}

/*
	Get minimum edge value
*/
real scalar `NWdef'::get_minimum(){
	real matrix e
	
	e = get_matrix()
	return(min(e))
}

/*
	Get maximum edge value
*/
real scalar `NWdef'::get_maximum(){
	real matrix e
	
	e = get_matrix()
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

void `NWdef'::set_nodenames(rowvector n){
	nodes = n
}

void `NWdef'::set_nodes_from_string(string scalar s){
	nodes = tokens(s,";")
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
	if (is2mode == 1) {
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
	real scalar v
	zap()
	if(args() == 1) {
		nodes = "`nwvars_def_pref'" :+ strofreal((1..n))
	}
	else {
		nodes = prefix :+ strofreal((1..n))	
	}
	update_nodesvar()
	init_edge()
	
	if (_st_varindex("`nw_nodename'") == .) {
		v = st_addvar("str40","`nw_nodename'")
	}
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
	real scalar v
	
	zap()
	nodes = name 
	update_nodesvar()
	init_edge()
	if (_st_varindex("`nw_nodename'") == .) {
		v =	st_addvar("str40","`nw_nodename'")
	}
	
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
void `NWdef'::set_selfloop(real scalar d) {
	isselfloop = d
}

/* 
	Set isdirect property
*/
void `NWdef'::set_directed(real scalar d) {
	isdirect = d
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
real matrix `NWdef'::get_matrix() {
//!! generate edge matrix based on edgetype
	real matrix e
	e = edge
	
	if (isselfloop == 0){
		_diag(e,.)
		return(e)
	}
	else {
		return(edge)
	}
	return(edge)
}

/*
	Get unvalued edge matrix
*/
real matrix `NWdef'::get_matrix_unvalued() {
//!! generate edge matrix based on edgetype
	real matrix e
	e = edge:!= 0
	return(e)
}


/*
	Get pointer to edge matrix
*/
pointer(real matrix) `NWdef'::get_matrix_original(){
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
	if(is2mode) {
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
	is2mode   = `False'
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
	
	// is2mode
	if(is2mode) {
		s = "true"
	}
	else {
		s = "false"
	}
	printf(prefix)
	printf("mode: %s\n", s)

	if(is2mode) {
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
	void zap()
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
	void drop_current_nodesvar()
	void generate_current_nodesvar()
	void duplicate()
	void drop()
}


void `NWsdef'::drop_current_nodesvar(){
	real scalar i
	for (i = 1; i<= cols(pcurrent->nodesvar); i++){
		stata("capture drop " + pcurrent->nodesvar[i])
	}
}

void `NWsdef'::generate_current_nodesvar(){
	real scalar i

	for (i = 1; i<= cols(pcurrent->nodesvar); i++){
		stata("capture gen " + pcurrent->nodesvar[i] + " = .")
	}
}

void `NWsdef'::zap(){
	real scalar n
	n = cols(names)
	names = J(0, 0, "")
	pdefs = NULL
	number = 0
}

string scalar `NWsdef'::get_valid_name(string scalar s){
	real scalar i, suffix
	string scalar snew

	if (rows(names) == 0) {
		return(s)
	}
	
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
	return(cols(names))
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
	if (_st_varindex("`nw_nodename'") == .) {
		st_addvar("str40","`nw_nodename'")
	}
}

/*
	Create networks by name
*/
void `NWsdef'::create_by_name(string rowvector s) {
	real scalar n, i, v

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
	if (_st_varindex("`nw_nodename'") == .) {
		v= st_addvar("str40","`nw_nodename'")
	}
}

/*
	Add one network
*/
void `NWsdef'::add(string scalar s) {

	real scalar i, size
	if (rows(names) > 0){
		i = first_index_match(names, s)
	}
	else {
		i = 0
		names = s
	}
	if(i>0) {
		error_handle("Network name already exists" , `errNWsExists')
	}

	if (rows(names) > 0){
		names = (names, s)
	}
	else {
		names = s
	}

	pdefs = (pdefs, NULL)
	size = cols(pdefs)
	pdefs[size] = &(`NWdef'())
	pdefs[size]->set_name(names[size])
	pcurrent = pdefs[size]
}

/*
	Drop a network
*/
void `NWsdef'::drop(string scalar netname){
	real scalar i, size
	real matrix k
	
	i = first_index_match(names, netname)
	size = cols(names)
	
	if (i <= size) {
		k = J(1, size, 1)
		k[1,i] = 0
		names = select(names, k)
		pdefs = select(pdefs, k)
	}
}
	
/* 
	Add a duplicate of a network
*/
void `NWsdef'::duplicate(string scalar netname, string scalar new_netname){
	real scalar i, size
	
	names = (names, new_netname)
	i = first_index_match(names, netname)
	pdefs = (pdefs, NULL)
	size = cols(pdefs)
	pdefs[size] = &(`NWdef'())
	pdefs[size]->set_name(new_netname)
	pdefs[size]->set_edge(pdefs[i]->get_matrix())
	pdefs[size]->set_nodenames(pdefs[i]->get_nodenames())
	
	pdefs[size]->set_directed(pdefs[i]->get_directed_boolean())
	pdefs[size]->set_valued(pdefs[i]->get_valued_boolean())
	pdefs[size]->set_2mode(pdefs[i]->get_2mode_boolean())

	pdefs[size]->set_label(pdefs[i]->get_label())
	pdefs[size]->set_caption(pdefs[i]->get_caption())

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
