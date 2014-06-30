{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwsym}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwsym {hline 2}}Makes network symmetric{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwsym} 
[{cmd:,}
{opt stub(stub)}
{weighted | unweighted | lower}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt stub(stub)}}stub of the network{p_end}
{synopt:{opt w:eighted}}add all weights/tie values up{p_end}
{synopt:{opt unw:eighted}}disregard all weights/tie values{p_end}
{synopt:{opt low:er}}use lower trinagular{p_end}


{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwsym} Takes the network represented by the adjacency matrix variables (var1, var2, etc) and makes
it symmetric. One of the options needs to be specified.
{title:Options}

{dlgtab:Main}

{phang}
{opt stub(stub)} Changes the {it: stub} of the network. Default is 'var'.

{phang}
{opt w:eighted}Adds the weights of the links from node i to node j to the weights of the links from
node j to node i.

{phang}
{opt unw:eighted}Converts all weights of the links, except 0 and missing, into the value 1.
Unweighted creates a link from node i to node j if a link exists from j to i.

{phang}
{opt low:er}Deletes the links that go from nodes with a lower number to nodes with a higher
number, and replaces these links with the corresponding links from nodes with a higher
number to nodes with a lower number. That is, option lower replaces the entries in the cells
above the diagonal of the adjacency matrix with the transpose of the entries below the
diagonal. 

{title:Remarks}
This command increases the total number of links in the network when options {it: weighted} or {it: unweighted} 
are specified, but not when option {it: lower} is specified. 

{pstd}
None. 


{title:Examples}
{cmd:. nwrandom 50, prob(.1)}
{cmd:. nwsym}

{title:Also see}
