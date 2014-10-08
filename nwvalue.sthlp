{smcl}
{* *! version 1.0.1  23aug2014 author: Thomas Grund}{...}
{marker topical}
{helpb nw_topical##analysis:[NW-2.6] Analysis}
{cmd:help nwvalue}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwvalue {hline 2}}Returns entries form the adjaceny matrix of a network{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwvalue} 
[{it:{help netname}}]
{it:{help nwvalue##nwsubset:nwsubset}}

{marker nwsubset}
{pstd}where {it:nwsubset} is a valid {help m2_subscripts:subscript} of the underlying Mata matrix. For example,

{pstd}{cmd:mynet[2,3]}{p_end}
{pstd}{cmd:mynet[(2::4),3]}{p_end}
{pstd}{cmd:mynet[(2::4,(3::4)]}{p_end}
{pstd}{cmd:mynet[|(2,3)\(4,4)|]}{p_end}

		
{title:Description}

{pstd}
When {it: nwsubset} refers to a single tie, e.g. mynet[i,j], the command returns the scalar {it:r(value)}
with the value of the tie between node i and node j. When {it: subset} refers to more than one tie, 
e.g. mynet[(i::k),j], the command returns a Mata matrix with the name stored in {it:r(mata)} that holds
the tie values of the network subset. 

{title:Remarks}

{pstd}
Nodes always have consecutive numbers. 

{title:Examples}

{cmd: nwuse florentine}
{cmd: nwvalue flobusiness[2,3]}
{cmd: nwvalue flobusiness[(1::2),(1::2)]}
{cmd: mata: subset


{title:Also see}
   
   {help nwreplace}
