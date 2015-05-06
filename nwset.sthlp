{smcl}
{* *! version 1.0.4  20nov2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}

{title:Title}

{p2colset 9 17 23 2}{...}
{p2col :nwset {hline 2} Declare data to be network data}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{pstd}Declare data to be network data

{p 8 15 2}
{cmd:nwset} {it:{help varlist}} [, {it:options} ]

{p 8 15 2}
{cmd:nwset}
,
{opt mat}({it:matamatrix})
[ {it:options} ]


{pstd}Display currently existing networks

{p 8 15 2}
{cmd:nwset}


{pstd}Display more details about existing networks

{p 8 15 2}
{cmd:nwset, detail}


{pstd}Clear all networks (but keep Stata variables)

{p 8 15 2}
{cmd:nwset, clear}


{pstd}Clear all networks and Stata variables

{p 8 15 2}
{cmd:nwset, nwclear}


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}

{synopt:{opt edgelist}}declare data in edgelist format{p_end}
{synopt:{opt directed}}force network to be directed{p_end}
{synopt:{opt undirected}}force network to be undirected{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new network; default = {it:network}{p_end}
{synopt:{opt labs}({it:lab1 lab2...})}new node labels that are used for the network{p_end}
{synopt:{opth labsfromvar(varname)}}new node labels that are used for the network{p_end}
{synopt:{opt vars}({it:var1 var2...})}new variables that are used for the network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
This command declares data to be network data (it is very similar to {help xtset} or {help stset}). When networks are 
{help nwimport:imported} or {help nwuse:used} or loaded from the {help webnwuse:internet} or created from
an {help nwfromedge:edgelist} or created by any other {help nw_topical##generator:network generator}, {bf:nwset} is automatically
invoked. But one can also explicitly declare data to be network data. 

{pstd}
Networks ultimately exist as objects in Stata. Once a network is declared one can interact with it by referring
to its {help netname}. In practice, this works just as if one would refer to a {help varname} in other commands.
The command sets a new network by assigning it an adjacency matrix. It can also be used to assign various meta-information
to the network.

{pstd}
An adjacency matrix is a simple representation of a network. The adjaceny matrix {it:M} of a one-mode network
has the dimensions {it:nodes} x {it:nodes}. The matrix cell {it:M_ij} = 0 when there is no tie between nodes {it:i}
and {it:j}. In binary networks, {it:M_ij} = 1 when there is a network relationship between nodes {it:i} and {it:j}.
However, networks can also be valued, i.e. {it:M_ij} > 1; in undirected networks {it:M_ij = M_ji}.


{pstd}
There are three ways to explicitly declare data to be network data:

{pstd}
{bf:{ul:1. Declare adjacency matrix from variables}}

{pstd}
Declare the variables in {help varlist} to represent the adjacency matrix of the network. In this case a
{help varlist} (var_1, var_2,..., var_z) needs to be given. Each variable is assumed to stand for one column in the adjacency matrix. 

{pmore}
{it:M_ij = var_i[j]}

{pstd}
When there are more observations {it:n} than variables {it:z}, only the the first {it:z} observations of each variable are considered. When
there are more variables than observations, then only the first {it:n} variables are considered as network data.

{pstd}
In this dummy example, we create 5 new variables v1-v5 and set a network from these variables. It creates an empty network (there 
are no ties).

	{cmd:. nwclear}
	{cmd:. forvalues i = 1/5} {
	{cmd:     gen v`i' = 0}
	{cmd:  }}
	{cmd:. nwset v*}

{pstd}
After that we can display the networks that have been set (see also {help nwsummarize} or {help nwds})

	{cmd:. nwset, detail}
	{hline 50}
	{txt} 1) Current Network
	{hline 50}
	{txt}   Network name: {res}network
	{txt}   Directed: {res}true
	{txt}   Nodes: {res}5
	{txt}   Network id: {res}1
	{txt}   Variables: {res}v1 v2 v3 v4 v5
	{txt}   Labels: {res}v1 v2 v3 v4 v5{txt}

{pstd}
There is exactly one network. When neither {bf:name()}, {bf:vars()}, or {bf:labs()} are specified, the command comes up with 
a suggestion to fill this meta-information.	


{pstd}
{bf:{ul:2. Declare edgelist from variables}}

{pstd}
In this case, the command interprets the variables {help varlist} as egdelist (see {help nwfromedge}). 

{pstd}
An edgelist or arclist is a set of two (or three in the case of a valued network) variables representing
relations. Nodes are identified by entries in the cells.  For example, the data

                 {c TLC}{hline 14}{c -}{c TRC}
                 {c |} {res} fromid  toid {txt}{c |}
                 {c LT}{hline 14}{c -}{c RT}
              1. {c |} {res} 1       2    {txt}{c |}
              2. {c |} {res} 2       3    {txt}{c |}
              3. {c |} {res} 4       2    {txt}{c |}
                 {c BLC}{hline 14}{c -}{c BRC}

{pstd}
stores information about three {it:ties} (1=>2), (2=>3) and (4=>2) among four unique network nodes. The
variables defining the edges can also be {help string} variables. 

                 {c TLC}{hline 25}{c -}{c TRC}
                 {c |} {res} fromid    toid     value{txt}{c |}
                 {c LT}{hline 25}{c -}{c RT}
              1. {c |} {res} Peter     Thomas   1    {txt}{c |}
              2. {c |} {res} Tim       Peter    3    {txt}{c |}
              3. {c |} {res} Mathilde  Thomas   2    {txt}{c |}
                 {c BLC}{hline 25}{c -}{c BRC}

{pstd}
Here, there are also three relationships: (Peter => Thomas), (Tim => Peter) and (Mathilde => Thomas).

{pstd}
The following command declares such data as network data and gives the new network the name {it:mynet}:

	{cmd:. nwset fromid toid value, name(mynet) edgelist}

	
{pstd}
{bf:{ul:2. Declare adjacency matrix from Mata matrix}}

{pstd}
Set a network from a {it:nodes x nodes} Mata matrix that holds the adjacency matrix of the new network. The option
{bf:mat()} is specified with the name of an existing Mata matrix.

{pstd}
For example, this generates a Mata matrix:

	{cmd:. nwclear}
	{cmd:. mata: net = (0,1,0,0\1,0,0,1\1,1,0,0\1,1,1,0)}
	{cmd:. nwset, mat(net) name(network)}

{pstd}
This also generates a network called {it:network}. When no {bf:name()} for a network is specified, the command makes a valid suggestion (see {help nwvalidate}).
	
{pstd}
Now a network called {it:network} exists and we can interact with it. For example, we can get a summary of the network:
	
	{com}. nwsummarize network, mat
	{res}{hline 50}
	{txt}   Network name: {res} network
	{txt}   Network id: {res} 1
	{txt}   Directed: {res}true
	{txt}   Nodes: {res}4
	{txt}   Arcs: {res}8
	{txt}   Minimum value: {res} 0
	{txt}   Maximum value: {res} 1
	{txt}   Density: {res} .6666666666666666
             {txt}1   2   3   4
          {c TLC}{hline 17}{c TRC}
	1 {c |}  {res}0   1   0   0{txt}  {c |}
	2 {c |}  {res}1   0   0   1{txt}  {c |}
	3 {c |}  {res}1   1   0   0{txt}  {c |}
	4 {c |}  {res}1   1   1   0{txt}  {c |}
          {c BLC}{hline 17}{c BRC}
 
 
{title:Remarks}
 
{pstd}
The command {bf:nwset} or {bf:nwset, detail} without a {help varlist} or {bf:mat()} option, give a list of all
networks that do currently exist in memory. A similar overview is provided by {help nwds} (which is very similar to {help ds}).

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
Whenever a network is set with {bf:nwset}, it is also made the {help nwcurrent:current network}. The current network is always 
the network that has been most recently loaded or generated. Many nwcommands allow that a {help netname} or a {help netlist} is
optional. In case no network is given, all nwcommands generally refer to the current network.

{pstd}
Programmers can use {bf:nwset} to write their own import routines  (see also {help nwimport}) for different network
file formats that are not natively supported by the {bf:nwcommands}.All you need to do is transform your data either in
an adjacency list or an edgelist represented by Stata variables. 

{title:See also}

	{help nodeid}, {help nwname}, {help nwds}, {help nwload}, {help nwvalidate}, {help nwvalidvars}, {help nwsummarize}
