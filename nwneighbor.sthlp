{smcl}
{* *! version 1.0.1  17may2012 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwneighbor {hline 2} Extract the network neighbors of a node}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwneighbor} 
[{it:{help netname}}],
{opth ego(nodeid)}
[{opth mode(nodeid)}]

{p 8 17 2}
{cmdab: nwneighbor} 
[{it:{help netname}}],
{opth ego(nodelab)}
[{opt mode}({it:{help nwneighbor##context:context}})]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth ego(nodeid)}}node{p_end}
{synopt:{opth ego(nodelab)}}node{p_end}
{synopt:{opt mode}({it:{help nwneighbor##context:context}})}defines the network neighborhood of node {it:ego}; default = {it:outgoing}{p_end}
{synoptline}
{p2colreset}{...}
		
{synoptset 15 tabbed}{...}
{marker context}{...}
{p2col:{it:context}}{p_end}
{p2line}
{p2col:{cmd: outgoing}}network neighbors of node {it:ego} are all nodes {it:j} who receive a tie from {it:ego}; default
		{p_end}
{p2col:{cmd: incoming}}network neighbors of node{it:ego} are all nodes {it:j} who send a tie to {it:ego}
		{p_end}
{p2col:{cmd: both}}network neighbors of node {it:ego} are all nodes {it:j} who either send a tie to {it:ego} or receive a tie from {it:ego}
		{p_end}

		
{title:Description}

{pstd}
{cmd: nwneighbor} returns the network neighbors of node {it:ego}. The network neighborhood of a node is defined in {opt mode()}. By default,
the neighborhood of node {it:ego} consists of all nodes {it:j}, who receive a tie from node {it:ego}. Tie values are ignored.

{pstd}
Also saves the (shuffled) list of neighbors in the return vector. 

{title:Stored results}

	Scalars
	  {bf:r(ego)}		nodeid of ego
	  {bf:r(oneneighbor)}	one randomly selected neighbor
	
	Matrices
	  {bf:r(neighbors)} 	reshuffled list of all neighbors


{title:Examples}

{pstd}
The command can be used both with the {help nodeid} or the {help nodelab} of a node {it:ego}. For example,
this loads the {help netexample:Florentine data} and returns the business partners of the "ginori"
family. 


	{com}. nwneighbor flobusiness, ego(ginori)

	{hline 40}
	{txt}  Network: {res}flobusiness
	{hline 40}
	{txt}    Ego        : {res}ginori	
	{txt}    Neighbors  : {res}{res}barbadori{txt} , {res}medici{txt}
	{hline 40}

{pstd}
This shows that the "ginori" family has business relationships with the "barbadori" and the "medici". One could
have also used the nodeid = 2 of the "ginori" family to get their network neighbors (see {help _nwnodeid} on how to obtain such an id from
a nodelab).

	{com}. nwneighbor flobusiness, ego(2){txt}

{pstd}
The first syntax displays the {help nodelab}, while the second displays the {help nodeid} of the
network neighbors. Both commands store the following in the return vector:
		
	{com}. return list {txt}
	
	scalars:
	  r(ego) =  {res}6{txt}
	  r(oneneighbor) =  {res}3{txt}

	matrices:
	   r(neighbors) : {res} 2 x 1
	   

{title:Also see}

   {help nwcontext}, {help nwgeodesic}, {help nwpath}, {help _nwnodelab}, {help _nwnodeid}
