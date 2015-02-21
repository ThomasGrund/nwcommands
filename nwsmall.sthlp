{smcl}
{* *! version 1.0.0  11nov2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}

{title:Title}

{p2colset 9 16 22 2}{...}
{p2col :nwsmall {hline 2} Generate a small-world network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwsmall} 
{it:{help int:nodes}}
{cmd:,}
{opth k(int)} 
{opth prob(float)} 
[{opt undirected}
{opth ntimes(int)}
{opt name}({it:{help newnetname}})
{opt vars}({it:{help newvarlist}})
{opt xvars}]

{p 8 17 2}
{cmdab: nwsmall} 
{it:{help int:nodes}}
{cmd:,}
{opth k(int)} 
{opt shortcuts(integer)} 
[{opt undirected}
{opth ntimes(int)}
{opt name}({it:{help newnetname}})
{opt vars}({it:{help newvarlist}})
{opt xvars}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{it:{help int:nodes}}}number of nodes{p_end}
{synopt:{opth k(int)}}number of neighhbors on ring-lattice on each side{p_end}
{synopt:{opth prob(float)}}probability for a tie to rewire{p_end}
{synopt:{opth shortcuts(int)}}exact number of ties to rewire{p_end}
{synopt:{opt undirected}}generate an undirected network; default = directed{p_end}
{synopt:{opth ntimes(int)}}number of small-world networks to be generated; default = 1{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new network{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwsmall} generates a small-world network using the original Watts-Strogatz model (see Watts and Strogatz 1998). The algorithm starts
with a ring-lattice where each node has {it:k} neighbors on each side. Next, the ties of the ring-lattice 
are rewired in one of two ways:

{pstd}
1) When option {bf:prob()} is specified, each tie of the ring-lattice has a certain probability to get rewired. All non-existent ties
are valid as rewirings (including the ones produced through previous rewirings).

{pstd}
2) When option {bf:shortcuts()} is specified, an exact number of ties of the ring-lattice gets rewired. In this algorithm, only ties 
that had not been in the original ring-lattice are valid rewirings. 

{pstd}
Either option {bf:prob()} or {bf:shortcuts()} needs to be specified.


{title:References}

{pstd}
Watts, D. J.; Strogatz, S. H. (1998). "Collective dynamics of 'small-world' networks". Nature 393 (6684): 440Ð442


{title:Examples}
	
{pstd}
In the first example, each tie on the ring-lattice has a probability to get rewired.

	{cmd:. nwclear}
	{cmd:. nwsmall 20, k(2) prob(.2)}
	{cmd:. nwplot, layout(circle)}

{pstd}
In the second example, there are exactly three shortcuts.

	{cmd:. nwsmall 30, k(2) shortcuts(3) undirected}
	{cmd:. nwplot, layout(circle)}

	
{title:See also}

	{help nwpref}, {help nwrandom}, {help nwlattice}, {help nwring}
