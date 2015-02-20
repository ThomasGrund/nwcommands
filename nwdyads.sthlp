{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##information:[NW-2.4] Information}

{title:Title}

{p2colset 9 16 22 2}{...}
{p2col :nwdyads  {hline 2} Dyad census}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdyads} 
[{it:{help netname}}]

{title:Description}

{pstd}
Returns the dyad census of a network (or a list of networks). This is a way to characterize a network based on its dyads.

{pstd}
In directed network, each dyad (pair of nodes {it:i} and {it:j}) can be one of the following:

{pmore}
1) M: mutually connected: {it:M_ij = M_ji = 1}

{pmore}
2) A: asymmetrically connected: {it:M_ij = 1}, but {it:M_ji = 0} 

{pmore}
3) N: not connected at all: {it:M_ij = M_ji = 1}


{pstd}
In undirected network, each dyad (pair of nodes {it:i} and {it:j}) can be one of the following:

{pmore}
1) M: connected: {it:M_ij = M_ji = 1}

{pmore}
2) N: unconnected:  {it:M_ij = M_ji = 0}

{pstd}
The command also returns the reciprocity of the network.

{pmore}
{it:reciprocity = M / (M + A)}

{title:Examples}
	
	{cmd:. webnwuse florentine}
	{com}. nwdyads flomarriage
	{res}
	{txt}    Dyad census: {res} flomarriage{txt}

	{txt}{ralign 10:Mutual}{col 20}{c |}{ralign 10:Null}
	{hline 11}{c +}{hline 11}
	{res}{ralign 10:20}{col 20}{c |}{ralign 10:100}

	{com}. webnwuse glasgow
	{com}. nwdyads glasgow3
	{res}
	{txt}    Dyad census: {res} glasgow3{txt}

	{txt}{ralign 10:Mutual}{col 20}{c |}{ralign 10:Asym}{col 32}{c |}{ralign 10:Null}
	{hline 11}{c +}{hline 11}{c +}{hline 11}
	{res}{ralign 10:45}{col 20}{c |}{ralign 10:32}{col 32}{c |}{ralign 10:1148}{txt}


{title:Stored results}

	Scalars:
	  {bf:r(_100)}	mutual dyads
	  {bf:r(_010)}	asymmetric dyads
	  {bf:r(_000)}	null dyads
	  {bf:r(reciprocity)}	M / (M + A)
	  
	Macros:
	  {bf:r(name)}	name of network
	  
	  
{title:See also}

	{help nwtriads}
