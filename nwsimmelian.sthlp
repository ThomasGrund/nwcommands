{smcl}
{* *! version 1.0.4  8dec2015 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 17 23 2}{...}
{p2col :nwsimmelian {hline 2} Calculate Simmelian ties}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab: nwsimmelian} 
[{it:{help netname}}]
[{cmd:,}
{opth name(newnetname)}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth name(newnetname)}}Save Simmelian ties as new network; default {it:_simmelian}{p_end}


{title:Description}

{pstd}
Simmelian ties are concerned with more than just the strength of the relationship (see Krackhardt 1998). They look at the number of strong ties within a
group. For a simmelian tie to exist, there must be three (a triad) or more of reciprocal strong ties in a group. A simmelian tie is viewed as even stronger than a regular strong tie.

{pstd}
For example, if Adam has a strong tie to Betty, and both Adam and Betty share a strong tie to Charles, this three-way tie would be a simmelian one.

{pstd}
The concept of a Simmelian tie is related to that of a clique; each pair of nodes (individuals) in a clique has a Simmelian tie between them. Thus a simmelian tie can be defined as a basic tie in a clique, or a co-clique relationship (between individuals who belong to a specific clique).


{title:References}

{pstd}
Krackhardt, D. (1999). The ties that torture: Simmelian tie analysis in organizations. Research in the Sociology of Organizations, (16), 183-210.
