{smcl}
{* *! version 1.0.4.1  18nov2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{cmd:help nwpermute}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwpermute  {hline 2}}Random permutation of the network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwpermute} 
[{help netname}]
{cmd:,}
{opt name(string)}
{opt xvars}
{opt noreplace}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt name}({it:new}{it:{help netname}})}name of the new random network; default = {help netname}_perm{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwpermute} makes a random permutation of the network and saves it as a new network. The id's of 
the nodes are randomly reshuffled, the structure of the network remains the same.
 
{title:Example}
	
	{cmd:. nwrandom 10, prob(.3)}
	{cmd:. nwplot, label(_label)}
	{cmd:. graph save g1.gph, replace}
	{cmd:. nwpermute}
	{cmd:. nwplot, labels(_label)}
	{cmd:. graph save g2.gph, replace}
	{cmd:. graph combine g1.gph g2.gph}
	
