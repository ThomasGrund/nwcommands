{smcl}
{* *! version 1.0.4  20nov2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}

{title:Title}

{p2colset 9 17 23 2}{...}
{p2col :nw2set {hline 2} Declare data to be two-mode network data}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{pstd}Declare data to be two-mode network data

{p 8 15 2}
{cmd:nw2set} {it:{help varlist}} [, {it:options} ]

{p 8 15 2}
{cmd:nw2set}
,
{opt mat}({it:matamatrix})
[ {it:options} ]


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth generate(newvarname)}}name of variable identifying two-mode membership; default = {it:_modeid}{p_end}
{synopt:{opt edgelist}}declare data in edgelist format{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new network; default = {it:network}{p_end}
{synopt:{opt labs}({it:lab1 lab2...})}new node labels that are used for the network{p_end}
{synopt:{opth rownames(varname)}}names of nodes on level 2{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
This command declares data to be two-mode network data. A two-mode network consists of two sets of units (e. g. people and
events) and relations connect the two sets, e. g. participation of people in social events. Some examples are: 

{pmore}
- Membership in institutions - people, institutions, is a member, e.g. directors and commissioners on the boards of corporations.

{pmore}
- Voting for suggestions - polititians, suggestions, votes for.

{pmore}
- Citation network, where first set consists of authors,
the second set consists of articles/papers,
connection is a relation author cites a paper.

{pmore}
- Co-autorship networks - authors, papers, is a (co)author.

{pstd}
A corresponding graph is called bipartite graph – lines
connect only vertices from one to vertices from another set –
inside sets there are no connections.

{pstd}
Setting two-mode networks is very similar to setting normal networks with {help nwset}. With M nodes
on level 1 and N nodes on level 2, the command internally generates a (M+N) x (M+N) matrix, which stores
the network data. Furthermore, it generates a variable {it:_modeid}, which has the value 1 for nodes on level 1 (e.g. persons: Peter, Tim,
Thomas, Michael, Mathilde) and value 2 for nodes on level 2 (e.g institutions: LiU, UCD, Oxford, ETH).

{pstd}
After setting a network "mynet", one can plot this two-mode network and color the two levels differently:

	{cmd:. nwplot mynet, color(_modeid)}

{pstd}
There are three ways to explicitly declare data to be two-mode network data:

{pstd}
{bf:{ul:1. Declare adjacency matrix from variables}}

{pstd}
Declare the variables in {help varlist} to represent the adjacency matrix of the two-mode network. In this case a
{help varlist} (var_1, var_2,..., var_z) needs to be given. Each variable stands for a
node on level 1 (e.g. organisations). Each row in the dataset stands for a node on level 2 (e.g. persons).

{pstd}
In this dummy example, we create 5 observations and 3 new variables v1-v3. After that we set a two-mode network from this data. This
creates an empty network with 5 nodes on level 1 and 3 nodes on level 2.

	{cmd:. nwclear}
	{cmd:. set obs 5}
	{cmd:. forvalues i = 1/3} {
	{cmd:     gen v`i' = 0}
	{cmd:  }}
	{cmd:. nwset v*}

{pstd}
By default, the nodes on level 2 are named after the variables v1, v2 and v3. If option {bf:rownames(varname)} is
specified, the nodes on level 2 are named afther the values found in variable {bf:varname}. 
	
{pstd}
{bf:{ul:2. Declare edgelist from variables}}

{pstd}
In this case, the command interprets the variables {help varlist} as egdelist (see {help nw2fromedge}). 

{pstd}
An edgelist or arclist is a set of two (or three in the case of a valued network) variables representing
relations. Nodes are identified by entries in the cells.  For example, imagine the following kind of data:

                 {c TLC}{hline 18}{c -}{c TRC}
                 {c |} {res} fromid      toid {txt}{c |}
                 {c LT}{hline 18}{c -}{c RT}
              1. {c |} {res} Peter       LiU  {txt}{c |}
              2. {c |} {res} Andreas     UCD  {txt}{c |}
              3. {c |} {res} Thomas      UCD  {txt}{c |}
                 {c BLC}{hline 18}{c -}{c BRC}

{pstd}			
We can declare the data as two-mode network like this:
	
	{cmd:. nw2set fromid toid, egdelist}
	
{pstd}	
This commands generates a network with 5 nodes in total; 3 nodes on level 1 (Peter, Andreas, Thomas) and 2 nodes
on level 2 (LiU, UCD). 
	
{pstd}
{bf:{ul:2. Declare adjacency matrix from Mata matrix}}

{pstd}
Set a network from a {it:M x N} Mata matrix that holds the adjacency matrix of the new network with M nodes on level 1 and N nodes on level
2. The option {bf:mat()} is specified with the name of an existing Mata matrix.

{pstd}
For example, this generates a Mata matrix and sets a two-mode network with 6 nodes (4 nodes in level 1 and 2 nodes on level 2):

	{cmd:. nwclear}
	{cmd:. mata: net = (0,1\1,0\1,1\1,1)}
	{cmd:. nwset, mat(net) name(network)}


{title:Remarks}
 
{pstd}
By default, two-mode networks are undirected. 

{pstd}
Although not really needed, networks can be represented with Stata variables (see {help nwload}). For this purpose, each network
holds some meta-information about which Stata variables should be created when a network is loaded in such a way. This meta-information
can be set wit option {bf:vars()}. When specified, it needs to have as many entries as there are nodes in the network. When not specified, 
the program automatically makes a suggestion for variable names (see {help nwvalidvars}). 

{pstd}
Many network generators allow the option {bf:xvars}, 
which essentially only produces a network object, but does not load a network as Stata variables (see {help nwload}). It can be
useful to surpress loading the adjacency matrix of a network in Stata when one deals with many or large networks. All commands
that require a {help netname} still work, even when all Stata variables are dropped, e.g.{bf: drop _all}. This also means that one 
can still deal with larger networks even when using {bf:Small Stata}.

{pstd}
Each node in a network also has a node label. This is a unique name for each node. This meta-information can be set with
option {bf:labs()}. As before, there need to be as many entries as there are nodes in the network. When not specified, the program
automatically labels nodes according the variables that have been set.
	
{pstd}
Whenever a network is set with {bf:nw2set}, it is also made the {help nwcurrent:current network}. The current network is always 
the network that has been most recently loaded or generated. Many nwcommands allow that a {help netname} or a {help netlist} is
optional. In case no network is given, all nwcommands generally refer to the current network.

{pstd}
Programmers can use {bf:nw2set} to write their own import routines  (see also {help nwimport}) for different network
file formats that are not natively supported by the {bf:nwcommands}.All you need to do is transform your data either in
an adjacency list or an edgelist represented by Stata variables. 

{title:See also}

	{help nwset}, {help nw2fromedge}, {help nwload}

