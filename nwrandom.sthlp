{smcl}
{* *! version 1.0.6  16may2012}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{cmd:help nwrandom}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwrandom {hline 2}}Generate a random Erdos-Renyi network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwrandom} 
{it: nodes}
{cmd:,}
{opt prob(float)} | {opt density(float)}
[{opt undirected}
{opt ntimes(integer)}
{opt name}({it:{help newnetname}})
{opt vars}({it:{help newvarlist}})
{opt xvars}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{it:nodes}}number of nodes{p_end}
{synopt:{opt prob}({it:float})}probability for a tie to exist{p_end}
{synopt:{opt density}({it:float})}exact density of the whole network{p_end}
{synopt:{opt undirected}}generate an undirected network; default = directed{p_end}
{synopt:{opt ntimes}({it:integer})}number of random networks to be generated; default = 1{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new random network{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwrandom} generates a directed Erdos-Renyi network with {it: nodes} number of nodes. Each
potential tie in the network has the same probability to exist, which is defined 
by {it:prob(float)}. Alternatively, the overall density of the network can be specified with {it:density(float)}. The 
difference between the two is that the latter generates the same number of ties when the command
is repeated, while the former does not necessarily.  


{title:Examples}
	
	{cmd:. nwclear}
	{cmd:. nwrandom 50, prob(.1)}
	{cmd:. nwrandom 15, density(0.5)}
	{cmd:. nwrandom 20, prob(.3) ntimes(5)}
	{cmd:. nwrandom 10, prob(.2) undirected}
	{cmd:. nwinfo _all}
