{smcl}
{* *! version 1.0.6  16may2012 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 19 22 2}{...}
{p2col :nwcontext {hline 2} Create a context variable}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwcontext} 
[{it:{help netname}}]
{cmd:,}
{opth attribute(varname)}
[{opt stat}({it:{help nwcontext##statistic:statistic}})
{opt mode}({it:{help nwcontext##context:context}})
{opth generate(newvarname)}
{opth mat(string)}
{opt noweight}]



{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth attribute(varname)}}attribute variable{p_end}
{synopt:{opt stat}({it:{help nwcontext##statistic:statistic}})}statistic that is used to calculate context variable for node i from attributes of network neighbors{p_end}
{synopt:{opt mode}({it:{help nwcontext##context:context}})}defines network neighbors of node i as either nodes j who receive ties from i, send ties to j or both{p_end}
{synopt:{opth generate(newvarname)}}name of the context variable to be generated; default = {it:_context_varname}{p_end}
{synopt:{opth mat(string)}}name of new mata matrix where context variable should be stored instead{p_end}
{synopt:{opt noweight}}ignores valued ties and treats all as binary{p_end}

{synoptline}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{marker statistic}{...}
{p2col:{it:statistic}}Description{p_end}
{p2line}
{p2col:{cmd: mean}}mean of {help varname} over network neighbors; default
		{p_end}
{p2col:{cmd: max}}maximum of {help varname} over network neighbors
		{p_end}
{p2col:{cmd: min}}minimum of {help varname} over network neighbors
		{p_end}
{p2col:{cmd: sum}}sum of {help varname} over network neighbors
		{p_end}
		
{p2colreset}{...}
{synoptset 20 tabbed}{...}
{marker context}{...}
{p2col:{it:context}}Description{p_end}
{p2line}
{p2col:{cmd: outgoing}}network neighbors of node i are all nodes j who receive a tie from i; default
		{p_end}
{p2col:{cmd: incoming}}network neighbors of node i are all nodes j who send a tie to i; default
		{p_end}
{p2col:{cmd: both}}network neighbors of node i are all nodes j who either send a tie to i or receive a tie from i
		{p_end}


{title:Description}

{pstd}
{cmd:nwcontext} generates a context variable, which holds information about the {it:attribute values} of a node's network neighbors.

{pstd}
For each node the set of network neighbors is specified in {opt mode()}, by default {it:context} = {bf:outgoing}. This means that the new context
variable {it:newvarname}[i] is calculated based on an all values {it:varname}[j], for which there is a tie from node {it:i} to node
{it:j}. A network neighborhood of
node {it:i} can be either 1) all nodes {it:j} to whom i has outgoing ties (default), 2) all nodes {it:j} from whom {it:i} receives incoming ties, or 3) both. In the case 
of valued ties {it:varname}[j] is weighted accordingly.

{pstd}
After that a {it:statistic} defined in {opt stat()} is calculated from all weigthed {it:varname}[j]. By default, the mean is calculated. More formally:

{pmore}
{it:newvarname}[i] = {it:stat}({it:varname}[j]), for all {it:j} with {it:y_ij} > 0

{pstd}
When used with the defaults, the command caluculate for each node {it:i} the mean score of its network neighbors on {help varname}.

{pstd}
Valid statistics are: the{bf: mean}, the {bf:max}, the {bf:min}, or the {bf:sum} of {help varname}.

{pstd}

{title:Remarks}

{pstd}
In the case of undirected networks, no {it: mode} option needs to be specified. 


{title:Examples}

{pstd}
In this example a new network {it:mynet} is generated on the basis of the Mata matrix {it:mymat}.

	{cmd:. nwclear}
	{cmd:. mata: mymat = (0,1,1\1,0,0\0,0,0)}
	{cmd:. nwset, mat(mymat) name(mynet)}
	
	{cmd:. set obs 3}
	{cmd:. gen var = _n}
	{cmd:. nwcontext mynet, attribute(var) mode(both) generate(cntx)}
   
	{cmd:. list cntx}
	   {c TLC}{hline 10}{c TRC}
	   {c |} {res}  cntx   {txt}{c |}
	   {c LT}{hline 10}{c RT}
	1. {c |} {res}2.333333 {txt}{c |}
	2. {c |} {res}       1 {txt}{c |}
	3. {c |} {res}       1 {txt}{c |}
	   {c BLC}{hline 10}{c BRC}	
	

{title:Also see}

   {help nwneighbor}
