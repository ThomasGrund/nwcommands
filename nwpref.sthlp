{smcl}
{* *! version 1.0.6  16may2012}{...}
{cmd:help nwpref}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwpref {hline 2}}Generate preferential attachment network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwp:ref} 
{it: nodes}
{cmd:,}
[{opt minout(min)}
{opt maxout(out)}
unweighted undirected]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt min:out(min)}}minimum number of links an entering agent can initiate{p_end}
{synopt:{opt max:out(max)}}maximum number of links an entering agent can initiate{p_end}
{synopt:{opt unw:eighted}}generate binary network{p_end}
{synopt:{opt und:irected}}generate symmetric network{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwlattice} Generates a preferential attachment network with {it: nodes} number of nodes. 
Iteratively, one new agent enters the network and generates links only to the other nodes who 
entered before. The actual number of links an entering agent forms will be in the interval [min,
max] and is decided on the basis of a draw from a uniform probability distribution.

{title:Options}

{dlgtab:Main}

{phang}
{opt min:out(min)} Specifies the minimum number of links an entering agent can initiate. 
Default value is 1.

{phang}
{opt max:out(max)} Specifies the maximum number of links an entering agent can initiate. 
Default value is 1.

{phang}
{opt unw:eighted} Generates binary network. Default is a {it: weighted network}. 

{phang}
{opt und:irected} Generates symmetric network. Default is a {it: directed network}. 


{title:Remarks}

{pstd}
None. 


{title:Examples}

{phang}{cmd:. nwpref 20, min(1) max(5)}

{phang}{cmd:. nwpref 20, min(1) max(5) unweighted undirected}



{title:Also see}
