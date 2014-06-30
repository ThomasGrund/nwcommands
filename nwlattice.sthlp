{smcl}
{* *! version 1.0.6  16may2012}{...}
{cmd:help nwlattice}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwlattice {hline 2}}Generate lattice network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwlatt:ice} 
{cmd:,}
{opt rows(r)}
{opt cols(c)}
[eight torus]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt r:ows(r)}}number of rows{p_end}
{synopt:{opt c:ols(c)}}number of columns{p_end}
{synoptline}
{syntab:Optional}
{synopt:{opt eight}}generate eight-cell neighborhood{p_end}
{synopt:{opt torus}}generate torus{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwlattice} Generates an undirected lattice network, where {it:r} gives the number of rows in the lattice, {it:c} gives the number of
columns.

{title:Options}

{dlgtab:Main}

{phang}
{opt eight} Specifies that the type of lattice shall be an eight-cell neighborhood.
Default is a four-cell neighborhood.

{phang}
{opt torus} Makes the lattice wraps around at the edges.By default world does not wrap around.


{title:Remarks}

{pstd}
None. 


{title:Examples}

{phang}{cmd:. nwlattice, rows(5) cols(5)}
{phang}{cmd:. nwlattice, rows(5) cols(5) eight torus}


{title:Also see}
