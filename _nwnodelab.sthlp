{smcl}
{* *! version 1.0.1  15sept2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##programming:[NW-2.9] Programming}
{cmd:help _nwnodelab}
{hline}

{title:Title}

{p2colset 5 19 22 2}{...}
{p2col :_nwnodelab {hline 2}}Returns the nodelab of a node given its nodeid{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: _nwnodelab} 
[{it:{help netname}}]
{cmd:, nodeid}(integer)
[{opt detail}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt nodeid}({help nodeid})}nodeid of network node i{p_end}
{synopt:{opt detail}}displays the {help nodeid} and {help nodelab} of node i{p_end}
{synoptline}
{p2colreset}{...}

{title:Description}

{pstd}
Returns the {help nodelab} of a node given its {help nodeid}. Results are also stored
in the return vector. When no node with the specified id is found in network {it:netname} and error is thrown.
This command is mostly used for programming with networks.


{title:Examples}

   {cmd:. webnwuse florentine}
   {cmd:. _nwnodelab flomarriage, nodeid(9)}
   
		{txt}Network: {res}flomarriage
		{hline 15}
		{txt}  Nodeid: {res}9
		{txt}  Nodelab: {res}medici
		
   {com}. return list

	{txt}scalars:
			r(nodeid) =  {res}9

	{txt}macros:
			r(netname) : "{res}flomarriage{txt}"
			r(nodelab) : "{res}medici{txt}"

{title:See also}

   {help _nwnodeid}
