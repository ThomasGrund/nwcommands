{smcl}
{* *! version 1.0.6  01jun2007}{...}
{cmd:help nwimport}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwimport {hline 2}}Import network dataset{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmd: nwimport using} 
{it: filename}
[{cmd:,} 
{opt stub(stub)}
{opt type(type)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt using}}filename of the network{p_end}
{synopt:{opt type}}defines type of file{p_end}
{synopt:{opt stub}}defines network stub{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwrandom} Imports a {it:n x n} network saved in {it: filename}.


{title:Options}

{dlgtab:Main}

{phang}
{opt type} Allowed types are: 'csv', 'matrix' and 'pajek'. One type needs to be specified. When type = {it:matrix}, network is a simple adjacency matrix where a tie goes from row to column. 
Values in the matrix are separated by blank spaces (see data format used in RSiena). When type = {it:pajek}, network is given in the form of a pajek .net file. 
Notice that for pajek import, quotes need to be removed from the file. Default is "matrix".

{phang}
{opt stub} The network stub indicates the name of the variables that are generated to represent the network in Stata. Default is 'var'.


{title:Remarks}

{pstd}
Work in progress. Additional file formats will be implemented. 


{title:Examples}

{phang}{cmd:. nwimport using network.dat, type(matrix)}


{title:Also see}
