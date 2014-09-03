{smcl}
{* *! version 1.0.1  3sept2014 author: Thomas Grund}{...}
{cmd:help nwfromedge}
{hline}

{title:Title}

{p2colset 5 21 22 2}{...}
{p2col :nwfromedge {hline 2}}Imports a network from an edgelist{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwfromedge} 
{help var: fromid}
{help var: toid}
[{help var: link}]
[{help if}]
[{cmd:,}
{opt name(string)}
{opt xvars}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt name}({it:new}{it:{help netname}})}name of the new random network; default = geodesic{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}

{p2colreset}{...}

{title:Description}

{pstd}
{cmd:nwfromedge} imports a network from an edgelist. The variables 
{it:fromid} and {it:toid} need to be specified. 

{title:Examples}

	{cmd:. nwuse glasgow}
	{cmd:. nwtoedge glasgow1}
	{cmd:. nwfromedge _fromid _toid _link}
	
{title:Also see}
	
	{help nwtoedge}
