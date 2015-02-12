{smcl}
{* *! version 1.0.0  11nov2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwduplicate {hline 2} Duplicate a network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwduplicate} 
[{it:{help netname}}]
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
{cmd:nwduplicate} simply duplicates an existing network {it:netname}. By default, the duplicated network is called {it:netname_copy}. It also 
duplicates the node labels and the Stata variables of the original network.

{pstd}
For example:

	{bf:. webnwuse gang, nwclear}
	{bf:. nwduplicate gang}
	{bf:. nwname gang_copy}
	{bf:. return list}
	
{pstd}
produces a network called {it:gang_copy}. The same could be done with:

	{bf:. webnwuse gang, nwclear}
	{bf:. nwgen gang_copy = gang}
	{bf:. nwname gang_copy}
	{bf:. return list}

{pstd}
However, when {help nwgen} is used, the node labels in {it:gang_copy} are not the same as in network {it:gang} (see the different values for {bf:r(labs)} and {bf:r(vars)} in the 
two examples above. This is because {help nwgen} can be much more complicated and ultimately copies the adjacency matrix it derives from a {help netexp:network expression} to a
new network.
	
	
{title:See also}

	{help nwgenerate}, {help nwsubset}
