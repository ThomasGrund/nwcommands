{smcl}
{* *! version 1.0.1  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwvalue {hline 2} Returns entries form the adjaceny matrix of a network}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwvalue} 
[{it:{help netname}}]
[{it:{help nwvalue##nwsubset:subset}}]

{marker nwsubset}
{pstd}where {it:subset} is a valid {help m2_subscripts:subscript} of the underlying Mata matrix. For example,

{pmore}{cmd:mynet[2,3]}{p_end}
{pmore}{cmd:mynet[(2::4),3]}{p_end}
{pmore}{cmd:mynet[(2::4,(3::4)]}{p_end}
{pmore}{cmd:mynet[|(2,3)\(4,4)|]}{p_end}


{title:Description}

{pstd}
When {it:subset} refers to a single tie, e.g. mynet[i,j], the command returns the scalar {it:r(value)}
with the value of the tie between node {it:i} and node {it:j}. When {it: subset} refers to more than one tie, 
e.g. mynet[(i::k),j], the command returns a matrix. By default, it creates a Stata matrix {it:r(values)} that holds
the tie values of the network subset. 


{title:Stored results}

	Scalars
	  {bf:r(value)}		single tie value
	  {bf:r(rows)}		number of rows of subnet
	  {bf:r(cols)}		number of columns of subnet

	Macros
	  {bf:r(mata)}		name of Mata matrix that holds the subnet
	
	
{title:Examples}

	{cmd:. webnwuse florentine}
	{cmd:. nwvalue flobusiness[2,3]}
	{cmd:. nwvalue flobusiness[(1::2),(1::2)]}


{title:Also see}
   
   {help nwreplace}
