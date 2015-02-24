{smcl}
{* *! version 1.0.6  16may2012}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwrandom {hline 2} Generate a random network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwrandom} 
{it:{help int:nodes}}
{cmd:,}
[{opth prob(float)}
{opth density(float)}
{opt census}({help nwdyads:{it:mutual} [{it:asym null}]})
{opt undirected}
{opth ntimes(int)}
{opt name}({it:{help newnetname}})
{opt vars}({it:{help newvarlist}})
{opt labs}({it:lab1 lab2 ...})
{opt xvars}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{it:{help int:nodes}}}number of nodes{p_end}
{synopt:{opth prob(float)}}probability for a tie{p_end}
{synopt:{opth density(float)}}exact density of the new network{p_end}
{synopt:{opt census}({help nwdyads:{it:mutual} [{it:asym null}]})}dyad census of the new network{p_end}
{synopt:{opt undirected}}generate an undirected network; default = directed{p_end}
{synopt:{opth ntimes(int)}}number of random networks to be generated; default = 1{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new random network; default = {it:random}{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}
{synopt:{opt labs}({it:lab1 lab2 ...})}overwrite node labels{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwrandom} generates a directed Erdos-Renyi network. Each
potential tie in the network has the same probability to exist, which is defined 
by {bf:prob()}. Option {bf:prob()} generates ties based on probabilities, which means that
the exact number of ties can vary. 

{pstd}
Alternatively, the overall density of the network can be specified with 
{bf:density()}. This option always generates the same number of ties
( = {it:density * nodes}), where each tie has the same probability to exist.

{pstd}
Lastly, once can also generate a random network that has a specific {help nwdyads:dyad census} using {opt census()} 

{pstd}
Either {bf:prob()}, {bf:density()} or {bf:census()} needs to be specified.

{pstd}
The command can also be used to generate many random networks at the same time. For example, the following command
produces 100 random networks.

{pmore}
{bf:. nwrandom 50, ntimes(100)}

{pstd}
By default, directed networks are generated, option {bf:undirected} generates undiretced networks instead. 

{pstd}
The command can also be used to generate both complete ({bf:prob(1)}) and empty networks ({bf:prob(0)}). 


{title:Examples}
	
	{cmd:. nwclear}
	{cmd:. nwrandom 50, prob(.1)}
	{cmd:. nwrandom 15, density(0.5)}
	{cmd:. nwrandom 20, prob(.3) ntimes(5)}
	{cmd:. nwrandom 10, prob(.2) undirected}
	{cmd:. nwsummarize _all}
	
	{cmd:. nwrandom 200, census(100 2000)}
	{cmd:. nwdyads}
	

{title:See also}

	{help nwsmall}, {help nwpref}, {help nwpref}, {help nwlattice}, {help nwring}
