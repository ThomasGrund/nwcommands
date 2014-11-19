{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}
{cmd:help nwimport}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwimport  {hline 2}}Import network from external source{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwimport} 
{it:{help file}}
[, {cmd:type}({help nwimport##import_type:import_type})
{cmd:name}(string)
{cmd:nwclear}
{cmd:clear}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt name}(string)}name of new network{p_end}
{synopt:{opt nwclear}}clears all variables and networks{p_end}
{synopt:{opt clear}}only clears variables, but keeps networks{p_end}

{synoptset 20 tabbed}{...}
{marker import_type}{...}
{p2col:{it:import_type}}Description{p_end}
{p2line}
{p2col:{cmd: pajek}}network is given in pajek format
		{p_end}
{p2col:{cmd: ucinet}}network is given in ucinet format
		{p_end}
{p2col:{cmd: gml}}network is given in gml format
	{p_end}
{p2col:{cmd: graphml}}network is given in graphml format
		{p_end}
{p2col:{cmd: matrix}}network is given as an adjacency matrix
		{p_end}
{p2col:{cmd: edgelist}}network is given as an edgelist
		{p_end}

{title:Description}

{pstd}
Imports popular network file formats. When {it:type(import_type)} is not specified explicitly, the command detects
the appropriate type based on the ending of the source file. 

{title:Remarks}

{pstd}
Additional file formats will be implemented.

{title:Examples}
	
   //Import pajek file
   {cmd:. nwclear}
   {cmd:. nwimport http://nwcommands.org/data/gang_pajek.net, type(pajek)}
   {cmd:. nwset}
	
   //Import network stored as matrix in txt file
   {cmd:. nwclear}
   {cmd:. nwimport http://nwcommands.org/data/flomarriage_matrix.txt, type(matrix)}
   {cmd:. nwset}
   
   //Import network stored as edgelist in xlsx file
   {cmd:. nwclear}
   {cmd:. nwimport example_edgelist.xlsx, type(edgelist)}
   {cmd:. nwset}
	
{title:See also}
	{help nwexport}, {help nwuse}
	
