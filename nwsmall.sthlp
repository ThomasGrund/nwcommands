{smcl}
{* *! version 1.0.4.1  18nov2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{cmd:help nwsmall}
{hline}

{title:Title}

{p2colset 5 16 22 2}{...}
{p2col :nwsmall {hline 2}}Generates a small-world network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwsmall} 
{it: nodes}
{cmd:,}
{opt k(integer)} 
{opt prob(float)} 
[{opt undirected}
{opt ntimes(integer)}
{opt name}({it:{help newnetname}})
{opt vars}({it:{help newvarlist}})
{opt xvars}]

{p 8 17 2}
{cmdab: nwsmall} 
{it: nodes}
{cmd:,}
{opt k(integer)} 
{opt shortcuts(integer)} 
[{opt undirected}
{opt ntimes(integer)}
{opt name}({it:{help newnetname}})
{opt vars}({it:{help newvarlist}})
{opt xvars}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{it:nodes}}number of nodes{p_end}
{synopt:{opt k}({it:integer})}number of neighhbors on ring-lattice on each side{p_end}
{synopt:{opt prob}({it:float})}probability for a tie to rewire{p_end}
{synopt:{opt shortcuts}({it:integer})}exact number of ties to rewire{p_end}
{synopt:{opt undirected}}generate an undirected network; default = directed{p_end}
{synopt:{opt ntimes}({it:integer})}number of small-world networks to be generated; default = 1{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new network{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwsmall} generates a small-world network (see Watts and Strogatz 1998) with {it: nodes} number of nodes. The algorithm starts
with a ring-lattice where each node has k neighbors on each side. Next, the ties of the ring-lattice are rewired one of two ways:

{pstd}
1) When option {it:prob} is specified, each tie of the ring-lattice has a certain probability to get rewired. All non-existent ties
are valid as rewirings (including the ones  produced through previous rewirings).

{pstd}
2) When option {it:shortcuts} is specified, an exact number of ties of the ring-lattice gets rewired. In this algorithm, only ties 
that had not been on the original ring-lattice are valid rewirings. 


{pstd}
Watts, D. J.; Strogatz, S. H. (1998). "Collective dynamics of 'small-world' networks". Nature 393 (6684): 440Ð442

{title:Examples}
	
	{cmd:. nwclear}
	{cmd:. nwsmall 20, k(2) prob(.2)}
	{cmd:. nwplot, layout(circle)}
	
	{cmd:. nwsmall 30, k(2) shortcuts(3) undirected}
	{cmd:. nwplot, layout(circle)}
	
{title:See also}

	{help nwpref}, {help nwrandom}, {help nwlattice}, {help nwring}
