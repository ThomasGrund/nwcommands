{smcl}
{* *! version 1.0.1  24aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwtomata {hline 2} Return adjacency matrix of network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtomata}
[{it:{help netname}}] 
{cmd:, }
{opt mat(matamatrix)}
{p_end}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mat(matamatrix)}}name of the new Mata matrix{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
This creates a Mata matrix with name {it:matatamatrix} holding a copy of the adjacency matrix of a network.

{pstd}
You do not need to know Mata to use any of the nwcommands, but sometimes you might want to obtain the 
adjacency matrix, for example, when programming your own network commands. 

{pstd}
When you make alterations to a Mata matrix derived from {bf:nwtomata} you do not change the
underlying network. It simply gives you a copy of the underlying matrix used to store the
network. To make changes to this network use  {help nwreplace} or {help nwreplacemat}. 

{pstd}
The adjacency matrix of a network can also be displayed with:

	{cmd:. nwsummarize, mat}
	
{pstd}
Advanced programmers who might want to directly interact with the adjacency matrix of a network 
and not with a copy of it, see {help nwinternal:advanced network programming}. 


{title:Example}

	{cmd:. nwrandom 5, density(.2) name(net)}
	{cmd:. nwtomata net, mat(mymat)}
	{cmd:. mata: mymat}
	
	{res}{txt}     1   2   3   4   5
	  {c TLC}{hline 21}{c TRC}
	1 {c |}  {res}0   0   0   0   0{txt}  {c |}
	2 {c |}  {res}0   0   1   0   0{txt}  {c |}
	3 {c |}  {res}0   0   0   1   0{txt}  {c |}
	4 {c |}  {res}0   1   0   0   0{txt}  {c |}
	5 {c |}  {res}1   0   0   0   0{txt}  {c |}
	  {c BLC}{hline 21}{c BRC}

	  
{title:See also}

	{help nwtostata}, {help nwload}, {help nwsummarize}
