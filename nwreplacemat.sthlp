{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 22 22 2}{...}
{p2col :nwreplacemat {hline 2} Replace network with Mata matrix}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwreplacemat} 
[{it:{help netname}}]
{cmd:,}
{opt newmat}({it:matname})
[{opt nosync}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt newmat}({it:matname})}name of a Mata matrix{p_end}
{synopt:{opt nosync}}do not sync Stata variables; by default Stata variables are synced (see {help nwsync}){p_end}

{title:Description}

{pstd}
{cmd:nwreplacemat} changes a network by replacing the adjacency matrix of the network with an existing Mata matrix. 

{pstd}
The command checks of the Mata matrix {it:matname} has the correct dimensions.

{pstd}
By default, the command also checks if the new adjacency matrix is symmetric and if yes, it alters the 
meta-information of the network (directed => undirected). In case, one still wants to assign 
a perfectly symmetric matrix to a directed network, one can use:

{pmore}
{cmd:nwname} [{it:{help netname}}]{cmd:, directed(true)}

{pstd}
 to overwrite the automatic setting afterwards. 

{title:Examples}

{pstd}
This example generates a ring lattice first ({it:mynet}), but then replaces the adjacency matrix of this
network with a new Mata matrix {bf:J(5,5,99)}.

	{com}. nwring 5, k(1), name(mynet)
	{com}. mata: net = J(5,5,99)
	{com}. nwreplacemat mynet, newmat(net) 
	{com}. nwsummarize mynet, matonly

	     1   2   3   4   5
	  {c TLC}{hline 25}{c TRC}
	1 {c |}  {res}0                    {txt}  {c |}
	2 {c |}  {res}99   0               {txt}  {c |}
	3 {c |}  {res}99   99   0          {txt}  {c |}
	4 {c |}  {res}99   99   99   0     {txt}  {c |}
	5 {c |}  {res}99   99   99   99   0{txt}  {c |}
	  {c BLC}{hline 25}{c BRC}

	
{title:See also}

	{help nwreplace}
