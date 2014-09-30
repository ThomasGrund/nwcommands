{smcl}
{* *! version 1.0.1  15sept2014 author: Thomas Grund}{...}
{cmd:help _nwnodeid}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :_nwnodeid {hline 2}}Returns the {it:nodeid} of a node given its node label{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: _nwnodeid} 
[{it:{help netname}}],
{opt nodelab}({help nodelab})
[{opt detail}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt nodelab}({help nodelab})}nodelab of network node i{p_end}
{synopt:{opt detail}}displays the {help nodeid} and {help nodelab} of node i{p_end}
{synoptline}
{p2colreset}{...}

{title:Description}

{pstd}
Returns the {help nodeid} of a node given its node label specified in {it:nodelab}. Results are stored
in the return vector. When no node with the specified label is found in network {it:netname} and error is thrown.
This command is mostly used for programming with networks.

{title:Examples}

   {cmd:. webnwuse florentine}
   {cmd:. _nwnodeid flomarriage, nodelab(medici)}
   
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

   {help _nwnodelab}
