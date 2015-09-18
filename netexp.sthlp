{smcl}
{* *! version 1.0.6  16may2012 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##concept:[NW-2.1] Concepts}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :netexp {hline 2} Network expression and function}
{p2colreset}{...}


	{bf:Assignment expression}
		
		{it:=netexp}

	{bf:Conditional expression}
		
		{it:netexp}
	

{title:Assigment expression}

{pstd}
A network expression is similar to a normal expression in Stata or Mata, except
that it works on the element-by-element level of the underlying adjacency matrices of
the involved networks.

{pstd}
Network expressions accept {help netname:netnames}, {help varname:varnames} and almost all operators that one knows
from Stata or Mata. Here, the network expression consists of the simple network {it:flomarriage} and is assigned
it to {it:mynet1}.

	{cmd:. webnwuse florentine}
	{cmd:. nwgen mynet1 = flomarriage}
	
{pstd}
But one can also include other elements in a network expression, e.g.:

	{cmd:. nwgen mynet2 = 2 * flomarriage}
	{cmd:. nwgen mynet3 = exp(flomarriage)}
	
{pstd}
In more complicated network expressions, all operators are performed on an element-by-element basis. The
next expression returns the overlap of two networks.

	{cmd:. nwgen overlap1 = flobusiness * flomarriage}

{pstd}
Practically, a network expression deals with the underlying Mata matrices of the networks and transforms simple
operators (such as +, -, *, /) in {help m2_op_colon: Mata colon-operators}. But essentially, everything that can 
be done in a Mata expression can be done in a network expression as well.

{pstd}
Network expressions basically provide easy access to the underlying adjacency matrices of networks without having to deal with Mata.


{title:Conditional expression}

{pstd}
Network expressions can also be used in {help if} conditions (see e.g. {help nwreplace}). In this case, a
network expression is again evaluated on an element-by-element basis and operations are only performed
for the dyads for which the expression is true. For example:

	{cmd:. webnwuse florentine}
	{cmd:. nwgen overlap2 = flobusiness}
	{cmd:. nwreplace overlap2 = flomarriage if flobusiness == 1}
	
{pstd}
This code generates the network {it:overlap2} as a copy of {it:flobusiness}. And then
it replaces the dyads in this new network with the values of the dyads in network {it:flomarriage}, but
only for the dyads where {it:flobusiness} == 1. Ultimately, this also generates the overlap between the
two networks {it:flomarriage} and {it:flobusiness}.


{title:Advanced programming with network expression}

{pstd}
When writing own network programs one can also include network expressions using {bf:_nwnevalnetexp}. The syntax for this
command is:

	{bf:_nwevalnetexp} {it:netexp} % {it:matamatrix}
	
{pstd}
This evaluates whatever is in {it:netexp} and generates a new mata matrix {it:matatrix} with the
result of the network expression.

