{smcl}
{* *! version 1.0.6  16may2012}{...}
{cmd:help nwrandom}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwrandom {hline 2}}Generate a random Erdos-Renyi network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwrand:om} 
{it: nodes}
{cmd:,}
{opt prob(p)}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt p:rob(p)}}probability for a tie to exist{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwrandom} Generates a directed random Erdos-Renyi network with {it: nodes} number of nodes. Each
potential tie in the network has the same probability to exist, which is defined by {it: p}.  


{title:Options}

{dlgtab:Main}

{phang}
{opt p:rob(p)} Defines the probability for a tie to exist. For all dyads in the network this
probability is the same, regardless of already existing ties.

{title:Remarks}

{pstd}
None. 


{title:Examples}

{phang}{cmd:. nwrandom 50, prob(.1)}


{title:Also see}
