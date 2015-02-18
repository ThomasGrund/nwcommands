{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwreplace  {hline 2} Replace network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwreplace} 
{it:{cmd:{help nwreplace##netsub:netname[subnet]}}}
{cmd:=}{it:{help netexp}}
[{it:{help nwreplace##conditions:ifego}}]
[{it:{help nwreplace##conditions:ifalter}}]
[{it:{help nwreplace##conditions:if}}]
[{it:{help nwreplace##conditions:in}}]


{title:Description}

{pstd}
Replaces whole networks, subnetworks or specific dyads. Similar in usage to {help replace}. A {help netexp:network expression} is 
very similar to a normal {help exp:expression} in Stata, but also accepts {help netname:netnames}. 

{pstd}
One can also replace dyads in networks by 1) loading a network as Stata variables 
(see {help nwload}), 2) changing the Stata variables (see {help replace}) and 3) syncing Stata variables and network afterwards
(see {help nwsync}). However, replacing the networks directly (as shown below) is the faster and preferred method.

{pstd}
One can also change the entire adjaceny matrix of a network with an existing Mata matrix using {help nwreplacemat}.


{title:Assign values}

{pstd}
Only replace dyad (2,1) to a constant:

{pmore}
{bf:. nwreplace mynet[2,1] = 55}

{pstd}
Set all dyads x_ij of an existing network {it:mynet} to a constant: 

{pmore}
{bf:. nwreplace mynet = 99}


{title:Network expressions}

{pstd}
A network expresssion is similar to a normal expression in Stata with the addition that it accepts
network names. It can be a simple constant, but also a very complicated expression that consists of 
operators, networks and variables. 

{pstd}
The usual operators are allowed in network expressions. All calculations in a 
network expression are performed element-by-element.

{pstd}
For example, one can calculate the intersection of two networks.

	{bf:webnwuse florentine, nwclear}
	{bf:nwgen bus_marr = flomarriage * flobusiness}
	
{pstd}
This generates a new network {it:bus_marr}, which takes the values 1 when two Florentine families
have both marriage and business ties. 

{pstd}
A more complicated network expression:

	{bf:gen test = _n}
	{bf:nwgen net = 2 * exp(flomarriage) / flobusiness * test}
	
{pstd}
Basically, one can do all sorts of calculations using network expressions. See
more on network expressions {help netexp:here}.


{title:Network subsets}

{pstd}
Set a subnetwork to a constant:

{pmore}
{bf:. nwreplace mynet[(1::4,1::4)] = 55}

{pstd}
Tie values can also be replaced with the values found in other networks for the corresponding positions. For example, this replaces
the whole network {it:first} with the network {it:second}.

{pmore}
{bf:. nwrandom 7, density(.2) name(first)}
{p_end}
{pmore}
{bf:. nwrandom 7, density(.3) name(second)}
{p_end}
{pmore}
{bf:. nwreplace first = second}

{pstd}
Again, one can limit such a nwreplace command by using network subsetting. Furthermore,
one can use a network expression which performs element-by-element calculations:

	{bf:. nwrandom 6, density(1) name(first)}
	{bf:. nwreplace first = first * 5}
	{bf:. nwreplace first[(1::3),(1::3)] = 0}
	{bf:. nwsummarize first, matonly}

	{res}     {txt}1   2   3   4   5   6
	  {c TLC}{hline 25}{c TRC}
	1 {c |}  {res}0   0   0   5   5   5{txt}  {c |}
	2 {c |}  {res}0   0   0   5   5   5{txt}  {c |}
	3 {c |}  {res}0   0   0   5   5   5{txt}  {c |}
	4 {c |}  {res}5   5   5   0   5   5{txt}  {c |}
	5 {c |}  {res}5   5   5   5   0   5{txt}  {c |}
	6 {c |}  {res}5   5   5   5   5   0{txt}  {c |}
	  {c BLC}{hline 25}{c BRC}
	  
{marker conditions}	  
{title: Network conditions}

{pstd}
For networks different conditions can be used:

	{it:command} {cmd:if} {help netexp}
		
	{it:command} {cmd:ifego} {help exp}

	{it:command} {cmd:ifalter} {help exp}

{pstd}
The first one evaluates the following expression as a network expression (which generates a new temporary network).
For example, this code replaces the {it:first} network with the values of the {it:}second network, but only for the ties where
the {it:third} network is 1. When instead of a network expression a normal expression is given, the if condition 
acts in the same way as the ifego condition.

	{bf:. nwrandom 10, prob(.2) name(first)}
	{bf:. nwrandom 10, prob(.2) name(second)}
	{bf:. nwrandom 10, prob(.2) name(third)}

	{bf:. nwreplace first = second if third == 1}

 {pstd}
 The {bf:ifego} {help exp} condition only replaces those dyads x_ij where the expression is true
 for x_i (the {it:sender} of a tie). For example, this code only multiplies the tie values of a network where the sender of a tie
 has a _nodeid < 5.

	{bf:. nwrandom 6, prob(1) name(mynet)}
	{bf:. nwreplace mynet = 5 * mynet ifego _nodeid > 3 }
	{bf:. nwsummarize mynet, matonly}
	
	{res}     {txt}1   2   3   4   5   6
	  {c TLC}{hline 25}{c TRC}
	1 {c |}  {res}0   1   1   1   1   1{txt}  {c |}
	2 {c |}  {res}1   0   1   1   1   1{txt}  {c |}
	3 {c |}  {res}1   1   0   1   1   1{txt}  {c |}
	4 {c |}  {res}5   5   5   0   5   5{txt}  {c |}
	5 {c |}  {res}5   5   5   5   0   5{txt}  {c |}
	6 {c |}  {res}5   5   5   5   5   0{txt}  {c |}
	  {c BLC}{hline 25}{c BRC}
  {pstd}	
 The {bf:ifalter} condition works in a similar way, but limits changes to those ties where the {it:receiver}
 x_j of a tie has certain attributes.
	
	{bf:. nwrandom 6, prob(1) name(mynet)}
	{bf:. nwreplace mynet = 5 * mynet ifalter _nodeid > 3 }
	{bf:. nwsummarize mynet, matonly}
	
	{res}     {txt}1   2   3   4   5   6
	  {c TLC}{hline 25}{c TRC}
	1 {c |}  {res}0   1   1   5   5   5{txt}  {c |}
	2 {c |}  {res}1   0   1   5   5   5{txt}  {c |}
	3 {c |}  {res}1   1   0   5   5   5{txt}  {c |}
	4 {c |}  {res}1   1   1   0   5   5{txt}  {c |}
	5 {c |}  {res}1   1   1   5   0   5{txt}  {c |}
	6 {c |}  {res}1   1   1   5   5   0{txt}  {c |}
	  {c BLC}{hline 25}{c BRC}
 {pstd}	
 Both {bf:ifego} and {bf:ifalter} can be combined (and could even be combined with the normal {bf:if} condition as well).
	
	{bf:. nwrandom 6, prob(1) name(mynet)}
	{bf:. nwreplace mynet = 5 * mynet ifego _nodeid > 3 ifalter _nodeid > 3 }
	{bf:. nwsummarize mynet, matonly}
	
	{res}     {txt}1   2   3   4   5   6
	  {c TLC}{hline 25}{c TRC}
	1 {c |}  {res}0   1   1   1   1   1{txt}  {c |}
	2 {c |}  {res}1   0   1   1   1   1{txt}  {c |}
	3 {c |}  {res}1   1   0   1   1   1{txt}  {c |}
	4 {c |}  {res}1   1   1   0   5   5{txt}  {c |}
	5 {c |}  {res}1   1   1   5   0   5{txt}  {c |}
	6 {c |}  {res}1   1   1   5   5   0{txt}  {c |}
	  {c BLC}{hline 25}{c BRC}


{pstd}	
All network expressions, network subsetting and network conditions can be combined with each other. 

	{bf:. gen attr= _n * 2}
	{bf:. nwreplace first[(1::3),(1::3)]  = exp(second) * attr ifego _n >= 5 ifalter attr < 4 if third == 1}

{title:See also}

	{help nwreplacemat}, {help nwsync}, {help nwload}



