{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topical}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 14 22 2}{...}
{p2col :nwsym  {hline 2} Symmetrize network}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwsym} 
[{it:{help netname}}]
[{cmd:,}
{opt mode}({it:{help nwsym##mode:mode}})
{opth name(newntename)}
{opth vars(newvarlist)}
{opt noreplace}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mode}({it:{help nwsym##mode:mode}})}logic for creating an undirected tie{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new symmetrized network; default = {it:_sym_netname}{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}
{synopt:{opt noreplace}}creates a new network instead of changing the existing one{p_end}

{p2colreset}{...}
{synoptset 20 tabbed}{...}
{marker mode}{...}
{p2col:{it:mode}}Description{p_end}
{p2line}
{p2col:{cmd: max}}maximum of tie values (i,j) and (j,i); default
		{p_end}
{p2col:{cmd: min}}minimum of tie values (i,j) and (j,i)
		{p_end}

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Symmetrizes a network, i.e. it transforms a directed network in an undirected
network. The logic for this transformation is defined in {bf:mode()}. 

{pstd}
By default {bf:mode(max)}, an undirected tie is formed when there is either a tie from node {it:i} to node {it:j} or
a tie from node {it:j} to node {it:i}. 

{pmore}
{it:M_ij = max( M_ij, M_ji )}

{pstd}
Alternatively, with {bf:mode(min)} an undirected tie is only formed when there are both ties from node {it:i} to
node {it:j} and a tie from node {it:j} to node {it:i}. 

{pmore}
{it:M_ij = min( M_ij, M_ji )}

{pstd}
When not specified otherwise, the network {help netname} is replaced with the symmetrized network. Option
{bf:noreplace} generates a new network instead.

{pstd}
Option {bf:check} tests if the underlying adjacency matrix of the network is symmetric (but does not 
symmetrize the network). Notice that this is 
indepdendent of any meta-information saved together withe the network (see {help nwname}). 


{title:Examples}

	{cmd:. nwuse glasgow, nwclear}
	{cmd:. nwsym glasgow1, check}

	
{title:Stores results}

	Macros:
	  {bf:r(is_symmetric)}	"true" or "false"
	  {bf:r(name)}		name of the network
	 
