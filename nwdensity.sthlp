{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwdensity}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwdensity {hline 2}}Calculates network density{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdensity} 
{it: varlist}
[{cmd:,}
{opt stub(stub)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt stub(stub)}}specifies network{p_end}

{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwdensity} Calculates network density, which is defined as total number of ties 
divided by number of dyads. Works for both directed and undirected networks. Stores result in 
{it: r(density)}.
  
{title:Options}

{dlgtab:Main}

{phang}
{opt stub(stub)} Specifies network.{it: newvar}.


{title:Remarks}
{pstd}
Calculates density based on binary network. 


{title:Examples}
{cmd:. nwrandom 50, prob(.1)}
{cmd:. nwdensity}
{cmd:. return list}

{title:Also see}
