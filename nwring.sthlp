{smcl}
{* *! version 1.0.0  11nov2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}

{title:Title}

{p2colset 9 16 22 2}{...}
{p2col :nwring {hline 2} Generate a ring-lattice network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwring} 
{it:{help int:nodes}}
{cmd:,}
{opth k(int)} 
[{opt undirected}
{opth name(newnetname)}
{opt vars}({it:{help newvarlist}})
{opt xvars}
{opth ntimes(int)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{it:{help in:nodes}}}number of nodes{p_end}
{synopt:{opth k(int)}}number of neighhbors on ring-lattice on each side{p_end}
{synopt:{opt undirected}}generate an undirected network; default = directed{p_end}
{synopt:{opth name(newnetname)}}name of the new network{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}
{synopt:{opth ntimes(int)}}number of networks to be generated; default = 1{p_end}

{title:Description}

{pstd}
{cmd:nwring} generates a directed ring-lattice network. Each node is connected to {it:k} 
nodes on each side. Basically, each node has 2 * {it:k} neighbors in a ring structure.


{title:Examples}
	
	{cmd:. nwclear}
	{cmd:. nwring 20, k(2) undirected}
	{cmd:. nwplot, arcbend(.5)}
	
	
{title:See also}

	{help nwpref}, {help nwrandom}, {help nwlattice}, {help nwsmall}
