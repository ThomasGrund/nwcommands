{smcl}
{* *! version 1.0.1  24aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}
{cmd:help nwtomata}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwtomata {hline 2}}Returns a Mata matrix holding the adjacency matrix of a network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtomata}
[{help netname}] 
[{cmd:, }
{opt mat(string)}
]
{p_end}
{p 8 17 2}
{cmdab: nwtomata}
{help varlist} 
[{cmd:, }
{opt mat(string)}
]
{p_end}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mat(string)}}name of the new Mata matrix{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
Most of the {help nwcommands} are programmed in Mata, which is Stata’s
built in matrix programming language, see {help mata} in Stata. You do not need to know
Mata to use the nwcommands, but sometimes you might want to get direct access to 
a network' {help nwadjaceny:adjaceny matrix}. {cmd:nwtomata} returns a Mata matrix for a network.

{title:Options}

{phang}
{opt mat(string)} Used to specify the name for the new Mata matrix that is created.

{title:Remarks}

{pstd}
When you make alterations to a Mata matrix derived from nwtomata you do not change the
underlying network. It simply gives you a copy of the underlying matrix used to store the
network. To make changes to this network use {help nwreplace} or {help nwreplacemat}. 

{pstd}
{cmd: nwtomata} can also be used with a {help varlist}. In this case, it creates a Mata
matrix based on an adjacency matrix defined by {help varlist}. This is more or less equivalent
to {help putmata}. 


{title:Example}

    {cmd:. nwuse florentine}
    {cmd:. nwtomata, mat(mymat)}
    {cmd:. mata: mymat}

