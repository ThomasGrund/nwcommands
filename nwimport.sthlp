{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwimport  {hline 2} Import network}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwimport} 
{it:{help filename}}
, 
{opt type}({it:{help nwimport##import_type:import_type}})
[{opth name(newnetname)}
{opt nwclear}
{opt clear}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt nwclear}}clear all networks and variables{p_end}
{synopt:{opt undirected}}clear variables{p_end}
{synopt:{opth name(newnetname)}}name of the imported network; default = {it:filename}{p_end}

{synoptset 20 tabbed}{...}
{marker import_type}{...}
{p2col:{it:import_type}}Description{p_end}
{p2line}
{p2col:{cmd: pajek}}network is given in {browse "http://gephi.github.io/users/supported-graph-formats/pajek-net-format/":Pajek NET file format}
		{p_end}
{p2col:{cmd: ucinet}}network is given in {help nwimport##ucinet:Ucinet file format}
		{p_end}
{p2col:{cmd: matrix}}network is given as an {help nwimport##matrix:adjacency matrix} (e.g. Excel, txt)
		{p_end}
{p2col:{cmd: edgelist}}network is given as an {help nwimport##edgelist:edgelist} (e.g. Excel, txt)
		{p_end}
{p2col:{cmd: compressed}}network is given as a {help nwimport##compressed:compressed edgelist} (e.g. txt, CSV)
		{p_end}
{p2col:{cmd: gml}}network is given in {browse "http://gephi.github.io/users/supported-graph-formats/gml-format/":GML file format}
	{p_end}
{p2col:{cmd: graphml}}network is given in {browse "http://gephi.github.io/users/supported-graph-formats/graphml-format/":GraphML file format}
		{p_end}
		
		
{title:Description}

{pstd}
Imports networks from popular network file formats. The following network formats are supported:

{pmore}{help nwimport##ucinet:- Ucinet}{p_end}
{pmore}{help nwimport##pajek:- Pajek}{p_end}
{pmore}{help nwimport##matrix:- Raw adjacency matrix}{p_end}
{pmore}{help nwimport##edgelist:- Raw edgelist}{p_end}
{pmore}{help nwimport##compressed:- Compressed edgelist}{p_end}
{pmore}{help nwimport##gml:- GML}{p_end}
{pmore}{help nwimport##graphml:- GraphML}{p_end}

{pstd}
Can also be used to import networks from the internet:

{phang}
{cmd:. nwimport "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/prison.dat", type(ucinet)}{p_end}


{marker ucinet}{...}
{title:Import Ucinet DL format}

{pstd}
{cmd:nwimport} can import the most common Ucinet DL format types: {it:fullmatrix, upperhalf, edgelist1, nodelist1}. It also supports
multiple networks ({it:nm > 0), diagonal = absent, labels:, matrix labels:, level labels:, labels embedded, row labels embedded, col labels embedded}. Two-mode
networks are not supported. For a detailed description of the Ucinet .dl file format see {browse "http://gephi.github.io/users/supported-graph-formats/ucinet-dl-format/":here}
or the {browse "https://www.soc.umn.edu/~knoke/pages/UCINET_6_User's_Guide.doc":Ucinet manual}. Here is a {help netexample##ucinet:list of popular networks delivered with Ucinet}.  

{phang}
{bf:Example 1:}{p_end}
	dl n=4 format=fullmatrix
	data:	
	0 1 1 0	
	1 0 1 1
	1 1 0 0
	0 1 0 0 

{phang}
{bf:Example 2:}{p_end}
	dl n = 4, nm = 2
	labels:
	GroupA,GroupB,GroupC,GroupD
	matrix labels:
	Marriage,Business
	data:
	0 1 0 1
	1 0 0 0
	0 0 1 0
	1 0 0 1

	0 1 1 1
	1 0 0 0
	1 0 0 1
	1 0 1 0

{phang}
{bf:Example 3:}{p_end}
	dl n = 4
	format = lowerhalf
	labels:
	Sanders,Skvoretz
	S.Smith,T.Smith
	data:
	2
	1 2
	1 1 2
	0 1 0 2
	
{phang}
{bf:Example 4:}{p_end}
	DL n=5
	format = edgelist1
	labels:
	george, sally, jim, billy, jane
	data:
	1 2
	1 3
	2 3
	3 1
	4 3

{phang}
{bf:Example 5:}{p_end}
	DL n=5
	format = edgelist1
	labels embedded:
	data:
	george sally
	george jim
	sally jim
	billy george
	jane jim

	
{marker pajek}{...}
{title:Import Pajek .net format}

{pstd}
{cmd:nwimport} can import the most common Pajek .net formats: {it:*arcs, *edges, *arcslist, *edgeslist, *matrix}. It also supports
multiple networks ({it:nm > 0), diagonal = absent, labels:, matrix labels:, level labels:, labels embedded, row labels embedded, col labels embedded}. Two-mode
networks are not supported. For a detailed description of the Ucinet .dl file format see {browse "http://gephi.github.io/users/supported-graph-formats/ucinet-dl-format/":here}
or the {browse "https://www.soc.umn.edu/~knoke/pages/UCINET_6_User's_Guide.doc":Ucinet manual}. Here is a {help netexample##ucinet:list of popular networks delivered with Ucinet}.  



{marker matrix}{...}
{title:Import raw adjacency matrix}

{pstd}
This imports networks that are in raw matrix format. Data can be saved as .txt, .xls or anything else. As delimiters "tab" "," ";" and " " are allowed. Furthermore, row
and/or column names can be included as well. This import option can be used to load networks from e.g. Excel. When data has already been opened/entered to Stata,
{help nwset} declares data as network data.

{phang}
{bf:Example 1:}{p_end}
	0 1 1 0
	1 0 0 0
	0 0 0 1
	0 1 0 0

{phang}
{bf:Example 2:}{p_end}
	thomas,peter,susan,kim
	0,1,1,0
	1,0,0,0
	0,0,0,1
	0,1,0,0

	
{marker edgelist}{...}
{title:Import raw edgelist}

{pstd}
This imports networks in {help nwfromedge##edgelist:raw edgelist format}. Data can already be in Stata-dta format. Otherwise, delimiters "tab" "," ";" and " " are allowed. When two columns are given
a non-valued network is loaded, when three columns are given a valued network is loaded. In case edgelist data has already been entered/opened
in Stata, {help nwfromedge} generates a network. Node labels can be embedded in the edgelist.

{phang}
{bf:Example 1:}{p_end}
	1 2
	1 4
	2 4
	4 3

{phang}
{bf:Example 2:}{p_end}
	peter,thomas,1
	thomas,susan,4
	susan,thomas3
	geoff,john,2

{marker compressed}{...}
{title:Import compressed edgelist}

{pstd}
This imports networks in compressed edgelist format. As delimiter "," is allowed. 

{phang}
{bf:Example 1:}{p_end}
	AS,MI,NY,TX
	TX,CA
	IL,AL,SD
	AL,MI,CA,NY

{phang}
{bf:Example 2:}{p_end}
	peter,thomas,mathilde,tim
	thomas,susan
	susan
	geoff,john,michael
