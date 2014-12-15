{smcl}
{* *! version 1.0.4  18nov2014}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}

{p2colset 9 15 19 2}{...}
{p2col :{cmd:nwds} {hline 2} List networks matching name patterns}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmd:nwds} [{it:{help netlist}}] [{cmd:,} {opt alpha} {it:{help ds: ds_options}}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt alpha}}list networks in alphabetical order{p_end}
{synoptline}


{title:Description}

{pstd}
This is the network version of {help ds}. It lists network names currently in memory in a compact or detailed
format, and lets you specify subsets of networks to be listed by their {help netname}. In addition, {bf:nwds} 
leaves behind in r(netlist) the names of networks selected so that you can use them in a
subsequent command. It can be used with all options available for {help ds}.

{pstd}
{bf:nwds}, typed without arguments, lists all network names currently in
memory in compact form.


{title:Example}

	{com}. nwclear
	. nwrandom 10, prob(.2) ntimes(20)
	{smcl}
	{com}. nwds r*
{res}{txt}{col 1}random_1{col 12}random_5{col 23}random_9{col 34}random_13{col 45}random_17
{col 1}random_2{col 12}random_6{col 23}random_10{col 34}random_14{col 45}random_18
{col 1}random_3{col 12}random_7{col 23}random_11{col 34}random_15{col 45}random_19
{col 1}random_4{col 12}random_8{col 23}random_12{col 34}random_16{col 45}random_20


{title:Stored results}

	Macros:
	  {bf:r(netlist)}	list of networks
	  

{title:See also}

	{help ds}, {help nwset}, {help nwunab}, {help nwname}

