{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 17 22 2}{...}
{p2col :nwdegree {hline 2} Degree centrality and distribution}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdegree} 
[{it:{help netlist}}]
[{cmd:,}
{opt generate}({it:{help varlist:varlist}})
{opt isolates}
{opt valued}
{opt in}({it:{help tabulate_oneway##tabulate1_options:tabulate_opt}})
{opt out}({it:{help tabulate_oneway##tabulate1_options:tabulate_opt}})
{it:{help tabulate_oneway##tabulate1_options:tabulate_opt}}
]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt generate}({it:{help varlist}})}Generate variables for degree, outdegree, indegree, isolate{p_end}
{synopt:{opt isolates}}Generate variable for network isolates{it:_isolate}{p_end}
{synopt:{opt valued}}Consider tie values; calculate {it:strength} instead of {it:degree}{p_end}
{synopt:{opt in}({it:{help tabulate_oneway##tabulate1_options:tabulate_opt}})}Options used for tabulating {it:indegree}{p_end}
{synopt:{opt out}({it:{help tabulate_oneway##tabulate1_options:tabulate_opt}})}Options used for tabulating {it:outdegree}{p_end}
{synopt:{it:{help tabulate_oneway##tabulate1_options:tabulate_opt}}}Options used for tabulating {it:degree}{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwdegree} calculates degree centrality for each node of a network or list of networks and tabulates the result. By  default it generates the Stata variables {it:_degree} 
(or {it:_strength} for valued networks) for undirected networks. For directed networks, it generates the variables _out_degree and _in_degree (or _out_strength and _in_strength for valued
networks). 

{pstd}
Option {bf:isolates} generates variable {it:_isolate} that indicates if a node is an isolate (not connected to any
other node).

{pstd}
With option {bf:valued} the command calculates node {it:_strength} (sum of tie values), and {it:_out_strength/_in_strength} 
for directed networks respectively, instead of node {it:_degree}.

{pstd}
In case, degree centrality is calculated
for {it:z} networks at the same time (e.g. {bf:nwdegree glasgow1 glasgow2}), the command generates the variables
{it:_out_degree_z} and {it:_in_degree_z} for each network. 


{title:Examples}

	{cmd:. webnwuse florentine}
	{cmd:. nwdegree flomarriage}
	{res}{hline 40}
	{txt}  Network name: {res}flomarriage
	{hline 40}
	{txt}    Degree distribution

	{txt}    _degree {c |}      Freq.     Percent        Cum.
	{hline 12}{c +}{hline 35}
	{txt}          0 {c |}{res}          1        6.25        6.25
	{txt}          1 {c |}{res}          4       25.00       31.25
	{txt}          2 {c |}{res}          2       12.50       43.75
	{txt}          3 {c |}{res}          6       37.50       81.25
	{txt}          4 {c |}{res}          2       12.50       93.75
	{txt}          6 {c |}{res}          1        6.25      100.00
	{txt}{hline 12}{c +}{hline 35}
	{txt}      Total {c |}{res}         16      100.00{txt}

	
{pmore}
In the following example, the degree distributions for in- and outdegree are saved in Stata matrices {it:matindeg} and {it:matoutdeg}:

	{cmd:. webnwuse glasgow}
	{cmd:. nwdegree glasgow1, in(matcell(matindeg)) out(matcell(matoutdeg))}
	{cmd:. mat list matindeg}
	
{pmore}
The next example saves the out- and indegree centrality in the variables {it:myout} and {it:myin} and the information about isolates in {it:myisolate}.

	{cmd:. nwdegree glasgow1, generate(myout myin mysiolate) isolates}
	
	
{title:See also}

   {help nwbetween}, {help nwcloseness}, {help nwcluster}, {help nwevcent}, {help nwkatz} 
