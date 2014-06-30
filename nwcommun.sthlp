{smcl}
{* *! version 1.0.6  16may2012}{...}
{cmd:help nwcommun}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwcommun {hline 2}}Generate community network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: :nwcommun }
{it: nodes}
{cmd:,}
{opt groups(gr)}
{opt prob(p)}
{opt gprob(gp)}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt gr:oups(gr)}}number of groups (communities) in the network{p_end}
{synopt:{opt p:rob(p)}}probability of a link forming between nodes belonging to different groups{p_end}
{synopt:{opt gp:rob(gp)}}defines network stub{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwcommun} Generates a community network, where {it: nodes} is the number of nodes in the
 network.{cmd: nwcommun} splits the nodes in {it: gr} groups of approximately equal size. {it:p} 
is the probability of a link forming between nodes belonging to different groups, and {it: gp}
 is the probability of a link forming between
nodes belonging to the same group.}.


{title:Remarks}

{pstd}
None. 


{title:Examples}

{phang}{cmd:. nwcommun 100, groups(5) prob(.05) gprob(.2)}


{title:Also see}
