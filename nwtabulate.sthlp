{smcl}
{* *! version 1.0.0  3sept2014}{...}
{cmd:help nwtabulate}
{hline}

{title:Title}

{p2colset 5 20 23 2}{...}
{p2col :nwtabulate {hline 2}}One-way table of edge / tie values of a network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtabulate} 
[{help netname}]
[{cmd:,}
{opt selfloop}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt selfloop}}includes self-loops{p_end}


{title:Description}

{pstd}
{cmd:nwtabulate} tabulates the edge / tie values of a network.

{title:Example}
	
	// Directed network
	{cmd:. nwuse glasgow}
	{cmd:. nwtabulate glasgow1}
	
	// Undirected network
	{cmd:. nwuse gang}
	{cmd:. nwtabulate gang}
	
