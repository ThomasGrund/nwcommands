{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwaddnodes {hline 2} Add nodes to network}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwaddnodes} 
[{it:{help netname}}], 
{opth newnodes(int)}
[{cmd:vars}({it:{help newvarlist}})
{cmd:labs}({it:lab1 lab2...})
{opt generate}({it:{help newnetname}})]

{synoptline}
{p2colreset}{...}
	
{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth newnodes(int)}}number of nodes that should be added to the network.{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}names of new Stata variables that should be used for the additional nodes.{p_end}
{synopt:{opt labs}({it:lab1 lab2...})}labels that should be used for the additional nodes.{p_end}
{synopt:{opt generate}({it:{help newnetname}})}generate a new network and do not overwrite the original network{p_end}
	
	
{title:Description}

{pstd}
Add isolate nodes to an existing networks. By default, {help netname} is replaced, unless {bf:generate()} is specified.


{title:Examples}

	{cmd:. nwclear}
	{cmd:. nwrandom 5, prob(.1)}
	{cmd:. nwaddnodes, newnodes(2) labs(peter thomas)}
	{cmd:. nwset, detail}

