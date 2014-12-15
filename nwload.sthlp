{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwload {hline 2} Load a network as Stata variables}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwload} 
[{it:{help netname}}]
[{cmd:,}
{opth id(int)}
{opt nocurrent}
{opt labelonly}
{opt force}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth id(int)}}id of the the network that should be loaded{p_end}
{synopt:{opt nocurrent}}only loads network as Stata variables, but does not make it the {it:current network}{p_end}
{synopt:{opt labelonly}}only load the node labels as Stata variable{p_end}
{synopt:{opt force}}by default nwload is not executed for networks with more than 1000 nodes unless {bf:force} is specified{p_end}
		
{title:Description}

{pstd}
Networks exist as objects in Stata. Once a network has been imported, generated or set, one can interact with
them by referring to their {help netname}, just as if one would interact with variables using their {help varname}. 

{pstd}
Networks have various meta-information, such as node labels (see
{help nwname}). Each network also has information about a set of Stata variables that should be created to represent the network as Stata
variables. {bf:nwset, detail} shows this information for all networks. 

{pstd}
The meta-data of a network (including the variables that should be used to load the network) can be changed with {help nwname}.

{pstd}
The command {bf:nwload} loads a network as Stata variables. By doing so, the command generates a set of Stata variables (the names 
of these variables are stored in the meta-information for a network) and populates these variables with the adjaceny matrix 
of the network.

{pstd}
An adjacency matrix is a simple representation of a network. The adjaceny matrix {it:M} of a network has the dimensions {it:nodes x nodes}. The 
matrix cell {it:M_ij} = 0 when there is no tie between nodes {it:i} and {it:j}. In binary networks, {it:M_ij} = 1 when there is
a network relationship between nodes {it:i} and {it:j}. However, networks can also be valued, i.e. {it:M_ij} > 1. Some 
nwcommands support valued networks.

{pstd}
Loading a network as Stata variables can be useful if one wants to interact with (or look at) the network on this level. But notice 
that changing one of the Stata variables does not change the underlying network, unless used in combination with {help nwsync}. To
change values of the underlying network directly use {help nwreplace}. 

{pstd}
For example, if one were to import/use a network with 16 nodes and drop all Stata variables, {bf:nwload} would create exactly
16 variables and 16 cases.

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. drop _all}
	{cmd:. nwload flomarriage}

{pstd}
All Stata variables can be deleted without deleting the underlying networks. With {bf:nwload} a network can always be brought back 
as Stata variables. In case the variables already exist, they are overwritten. If one wants to permanently drop a network one needs to
use {help nwdrop} or {help nwclear} (very similar to how one would drop or clear normal variables). 

{pstd}
{bf:nwload} not only loads the adjacency matrix as variables, but also generates (or overwrites) three additional Stata variables:

{synoptline}
{synopt:{it:_nodelab}}This variable holds the node labels (see {help nodeid:nodelab}).{p_end}
{synopt:{it:_nodeid}}This variable holds the node ids (see {help nodeid}).{p_end}
{synopt:{it:_nodevar}}This variable holds the information about the variables that are used to represent the adjacency matrix of the network as Stata variables.{p_end}
{synoptline}

{pstd}
One can only load the node labels of a network as a Stata variable with the option {bf:labelsonly} (this does neither load the adjacency matrix
of a network as Stata variables nor other information, but just creates the variable {it:_nodelab}).

{pstd}
These variables are created to simplify interaction with, e.g. node labels. For example, one can plot the Florentine marriage network and
label the nodes accordingly with:

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwplot flomarriage, label(_nodelab)}

{pstd}
Furthermore, {bf:nwload} makes {help netname} the current network, unless option {bf:nocurrent} is specified. Many nwcommands (although
they do something with a network) do not require a network name. In the cases where no {help netname} is specified, a nwcommand 
automatically runs with the {help nwcurrent:current network}. For programming your own network commands with this feature see 
{help _nwsyntax}.

{pstd}
By default, all commands that generate a network (see {help nw_topical##generator:network generator}) also load the network as Stata variables. However, 
these network generators almost always have the option {bf:xvars}, which does not invoke {bf:nwload} after creating a new network. This can be useful
when one deals with many networks at the same time and reaches the limits of variables that can be handled in Stata.

{pstd}
For example this code generates 1000 random networks with 100 nodes each, but does not load the networks as Stata variables because {bf:xvars} is 
specified. Afterwards, {bf:nwload} is used to load just one (the current network, here, the last random network that has been generated) as 
Stata variables.

	{cmd:. nwrandom 100, prob(.1) ntimes(1000) xvars}
	{cmd:. nwload}

{pstd}
Notice that {cmd:nwload} does not import or create a network, it simply creates Stata variables to represent a network. Only networks that 
already do exist in Stata, i.e. have been set by {help nwset} or imported by {help nwimport} or {help nwuse} or {help webnwuse} or
created by a {help nw_topical##generator:network generator}, can be loaded as Stata variables. If two different networks use the
same variable names, the Stata variables are overwritten.


{title:See also}
   
   {help nwcurrent}, {help nwsync}, {help nwuse}, {help nwimport}
