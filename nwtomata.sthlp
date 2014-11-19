{smcl}
{* *! version 1.0.4.1  18nov2014}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}
{cmd:help nwtomata}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwtomata {hline 2}}Return a Mata matrix holding the adjacency matrix of a network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtomata}
[{help netname}] 
{cmd:, }
{opt mat(string)}
{p_end}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mat(string)}}name of the new Mata matrix{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
Most of the {help nwcommands} are programmed in {help Mata}. You do not need to know
Mata to use the nwcommands, but sometimes you might want to have direct access to the adjacency matrix of
a network. The adjacency matrix of a network with {it:n nodes} is the {it:n} x {it:n} matrix where the non-diagonal entry 
{it:a_ij} is the number of edges from {it:node i} to {it:node j}.

{title:Options}

{phang}
{opt mat(string)} Name for the new Mata matrix.

{title:Remarks}

{pstd}
When you make alterations to a Mata matrix derived from nwtomata you do not change the
underlying network. It simply gives you a copy of the underlying matrix used to store the
network. This can be used for programming purposes. To make changes to this network use 
{help nwreplace} or {help nwreplacemat}. 

{title:Example}

    {cmd:. webnwuse florentine}
    {cmd:. nwtomata flomarriage, mat(mymat)}
    {cmd:. mata: mymat}

