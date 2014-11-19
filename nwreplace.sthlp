{smcl}
{* *! version 1.0.4.1  18nov2014}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}
{cmd:help nwreplace}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwreplace  {hline 2}}Replace content of existing network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwreplace} 
{cmd:{help nwreplace##netsub:netname[subnet]}}
{cmd:=}{it:{help nwreplace##netexp:netexp}}
[{it:{help nwreplace##conditions:ifego}}]
[{it:{help nwreplace##conditions:ifalter}}]
[{it:{help nwreplace##conditions:if}}]
[{it:{help nwreplace##conditions:in}}]


{title:Description}

{pstd}
Replaces whole networks, subnetworks or specific dyads. Similar in usage to {help replace}. A network expression is analogue to a normal
{help exp:expression}, but also accepts {help netname:netnames}.




{marker netexp}	
{title:Network expression}

nwclear

nwrandom 7, density(.2) name(first)
nwrandom 7, density(.3) name(second) xvars
nwrandom 7, density(.3) name(third) xvars
gen attr= _n * 2

// replacing networks

nwreplace first = 1
nwreplace first = 2 in 3/5
nwreplace first = 3 if attr < 10
nwreplace first = 4 * second if _n < 5
nwreplace first = exp(second) * attr if _n >= 5


// replacing with temporary networks

nwreplace first = 99 * (_nwrandom 7, prob(.3))
nwrandom 10, density(.4)
nwexpand
nwgenerate subnet = first[(2::6),(2::6)]
nwgenerate firstsecond = first & second

{marker netsub}	
{title:Subnet}
// replacing subnetworks

{pstd}
Some nwcommands can be applied to subsets of a network. The subscripting to achieve this is similar to the one used in
in Mata {help m2_subscripts}. 

	{cmd:. nwclear}
	{cmd:. nwrandom 7, density(.2) name(first)}
	{cmd:. nwrandom 7, density(.3) name(second) xvars}
	{cmd:. nwrandom 7, density(.3) name(third) xvars}


	{cmd:. nwreplace first[(2::6),(1::5)] = 55 }
	{cmd:. nwreplace first[(1::3),(1::3)] = 6 if attr !=2}
	{cmd:. nwreplace first[(1::4),(1::4)] = second * 7 if third != 1}


{marker netexp}	
{title:Network conditions}

{pstd}
For networks different conditions can be used:

	{it:command} {cmd:if} {help netexp}
		
	{it:command} {cmd:ifego} {help exp}

	{it:command} {cmd:ifalter} {help exp}
		
	{it:command} {cmd:in} {help in:range}
	
{pstd}
{it:netexp} in the syntax diagram means an expression, such as {hi: mynet==1}.

{pstd}
{it:exp} in the syntax diagram means an expression, such as {hi:age>21}.

{pstd}
The conditions {hi:ifego} and {hi:ifalter} make it possible that only ties are changed where {it:ego} 
and/or {it:alter} have certain attributes, such as {hi:age>21}. For example:
		
	{cmd:. nwreplace mynet = 5 * mynet ifego age > 21 ifalter age > 21}

{pstd}
only replaces those network ties of {it:mynet} where both {it:ego} and {it:alter} are over 21. 

	


