{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwqap  {hline 2} Multivariate QAP regression}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwqap} 
{it:{help netname:depnet}}
[{it:{help nwqap##independentvariables:indepvars}}]
, 
{opth permutations(int)}
{opt mode}({it:{help nwexpand##expand_mode:mode}})
{opt type(regcmd)}
{opt typeoptions(regoptions)}
{opt detail}
{opt save}({it:{help filename}})



{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth permutations(int)}}number of QAP permutations; default = 500{p_end}
{synopt:{opt mode}({it:{help nwexpand##expand_mode:mode}})}modes for expanding variables to networks{p_end}
{synopt:{opt type}({it:{help nwqap##regcmd:regcmd}})}regression command to be used for dyad dataset; default = {it:logit}{p_end}
{synopt:{opt typeoptions(regoptions)}}options to be passed on to the regression command{p_end}
{synopt:{opt detail}}display details of regression results{p_end}
{synopt:{opt save}({it:{help filename}})}save coefficients from permutations in file{p_end}


{title:Description}

{pstd}
MR-QAP is a multiple regression procedure used to assess the impact of independent variables 
