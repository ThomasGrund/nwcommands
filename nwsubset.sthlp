{smcl}
{* *! version 1.0.0  11nov2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{marker top2}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwsubset {hline 2} Subset a network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwsubset} 
[{it:{help netname}}]
[{it:{help if}}]
[,
{opt name}({it:{help newnetname}})
{opt xvars}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt name}({it:{help newnetname}})}name of the new network{p_end}
{synopt:{opt xvars}}do not generate/overwrite Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwsubset} simply subsets an existing network {it:netname}. By default, the subset network is called {it:netname_sub}. When
no {help if} condition is specified, the command simply generates a duplicate of a network.

{pstd}
For example:

	{bf:. webnwuse gang, nwclear}
	{bf:. nwsubset gang if _n < 10}

{pstd}
Notice that something similar could be achieved with {help nwgen}:

	{bf:. webnwuse gang, nwclear}
	{bf:. nwgen gang_sub = gang if _n < 10}	

{pstd}
However, the last command does not copy the node labels of network {it:gang}. This is because the {help if} condition in {help nwgen} applies to a whole {help netexp:network expression}. Because
network expressions can be very complicated, no labels are copied. 


{title:See also}

	{help nwgenerate}, {help nwduplicate}
