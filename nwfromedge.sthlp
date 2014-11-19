{smcl}
{* *! version 1.0.4.1  18nov2014}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}
{cmd:help nwfromedge}
{hline}

{title:Title}

{p2colset 5 19 22 2}{...}
{p2col :nwfromedge {hline 2}}Imports a network from an edge-/arclist{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwfromedge} 
{help var: fromid}
{help var: toid}
[{help var: link}]
[{help if}]
[{cmd:,}
{opt name(string)}
{opt xvars}
{opt vars}({help newvarlist})
{opt undirected | directed}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt name}({it:new}{it:{help netname}})}name of the new network; default = network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}overwrite Stata variables{p_end}
{synopt:{opt labs}({it:lab1 lab2 ...})}overwrite node labels{p_end}
{synopt:{opt undirected}}force the network to be undirected{p_end}
{synopt:{opt directed}}force the network to be directed{p_end}

{p2colreset}{...}

{title:Description}

{pstd}
{cmd:nwfromedge} imports a network from an edgelist. The variables 
{it:fromid} and {it:toid} need to be specified. When the variable {it:link} is specified
a valued network is created.


{pstd}
An edgelist or arclist is a set of two variables representing
relations [that is, edges (undirected) or arcs (directed)] between 
network nodes (vertices). Nodes are identified by entries in cells.  For example,

                 {c TLC}{hline 14}{c -}{c TRC}
                 {c |} {res} fromid  toid {txt}{c |}
                 {c LT}{hline 14}{c -}{c RT}
              1. {c |} {res} 1       2    {txt}{c |}
              2. {c |} {res} 2       3    {txt}{c |}
              3. {c |} {res} 4       .    {txt}{c |}
                 {c BLC}{hline 14}{c -}{c BRC}

{pstd}
The command {cmd: nwfromedge fromid toid} generates a network.

{pstd}
The variables defining the edges can also be {help string} variables. 

                 {c TLC}{hline 25}{c -}{c TRC}
                 {c |} {res} fromid    toid     value{txt}{c |}
                 {c LT}{hline 25}{c -}{c RT}
              1. {c |} {res} Peter     Thomas   1    {txt}{c |}
              2. {c |} {res} Tim       Peter    3    {txt}{c |}
              3. {c |} {res} Mathilde  Thomas   2    {txt}{c |}
                 {c BLC}{hline 25}{c -}{c BRC}

				 {pstd}
The command {cmd: nwfromedge fromid toid value} generates a valued network.
				 
{pstd}
By default, the command recognizes if a network is directed or undirected, i.e. for each 
edge entry (i,j) there is also an edge entry (j,i). However, this automatic detection
can be overwritten with the options {cmd:undirected} and {cmd:directed}.

{title:Examples}

	{cmd:. nwuse glasgow, nwclear}
	{cmd:. nwtoedge glasgow1}
	{cmd:. nwfromedge _fromid _toid _link, name(mynet)}
	{cmd:. nwset}
	
{title:Also see}
	
	{help nwtoedge}
