{smcl}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwtomatafast {hline 2} Return link to adjacency matrix of network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtomatafast}
[{it:{help netname}}] 


{title:Description}

{pstd}
Internally, networks are saved as adjacency matrices in Mata. This command returns the name of the Mata matrix where a network is stored in the return vector. It 
differs from {help nwtomata} in the following way. It only returns a link to the adjacency matrix and does not produce a copy of the adjacency matrix.

This can be useful, when you want to directly interact with the underlying adjacency matrix. But I only recommend this for advanced programmers.
Caution is advised because the relevant meta-information is not updated when changing the adjacency matrix of a network. 


{title:Example}

	{cmd:. nwrandom 5, density(.2) name(net)}
	{cmd:. nwtomatafast net}
	{cmd:. return list}

	  
{title:See also}

	{help nwtomata}, {help nwload}, {help nwsummarize}
