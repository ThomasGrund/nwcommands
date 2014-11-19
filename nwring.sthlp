{smcl}
{* *! version 1.0.4.1  18nov2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{cmd:help nwring}
{hline}

{title:Title}

{p2colset 5 16 22 2}{...}
{p2col :nwsmall {hline 2}}Generates a ring-lattice network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwring} 
{it: nodes}
{cmd:,}
{opt k(integer)} 
[{opt undirected}
{opt name}({it:{help newnetname}})
{opt vars}({it:{help newvarlist}})
{opt xvars}
{opt ntimes(integer)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{it:nodes}}number of nodes{p_end}
{synopt:{opt k}({it:integer})}number of neighhbors on ring-lattice on each side{p_end}
{synopt:{opt undirected}}generate an undirected network; default = directed{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new network{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}
{synopt:{opt ntimes}({it:integer})}number of networks to be generated; default = 1{p_end}

{title:Description}

{pstd}
{cmd:nwring} generates a ring-lattice network. Each node is connected to {it:k} nodes on each side.

{title:Examples}
	
	{cmd:. nwclear}
	{cmd:. nwring 20, k(2) undirected}
	{cmd:. nwplot}
	
	
{title:See also}

	{help nwpref}, {help nwrandom}, {help nwlattice}, {help nwsmall}
