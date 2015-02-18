{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwrename {hline 2} Rename network}
{p2colreset}{...}


{title:Syntax}

{pstd}
Rename a single network

{p 8 16 2}
{opt nwrename} {it:old_netname} {it:new_netname}


{pstd}
Rename groups networks

{p 8 16 2}
{opt nwrename} ({it:old1 old2 ...}) ({it:new1 new2 ...})


{marker description}{...}
{title:Description}

{pstd}
{cmd:nwrename} changes the name of an existing network {it:old_netname} to
{it:new_netname}; the content of the network remains unchanged.


{marker examples}{...}
{title:Examples}

	{com}. webnwuse florentine, nwclear

	{txt}{it:Loading successful}
	{res}{txt}(2 networks)
	{hline 20}
		{res}flobusiness
		{res}flomarriage
	
	{com}. nwds
	{res}{txt}{col 1}flobusiness{col 24}flomarriage

	{com}. nwrename flobusiness business
	{com}. nwrename flomarriage marriage{txt}

	{com}. nwds
	{res}{txt}{col 1}business{col 21}marriage


{title:See also}

	{help nwname}, {help rename}


