{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{marker top2}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}


{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwtranspose {hline 2} Transpose a network}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwtranspose} 
[{it:{help netname}}]
[{cmd:,}
{cmd:name}({it:{help newnetname}})
{opt xvars}
{opt noreplace}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt name}({it:{help newnetname}})}name of the new transposed network; default = {it:_transp_netname}{p_end}
{synopt:{opt xvars}}do not produce Stata variables{p_end}
{synopt:{opt noreplace}}create a new network instead of changing the original one{p_end}

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Simply transposes a network, i.e. a directed tie from node {it:i} to node {it:j} is transformed in a 
directed tie from node {it:j} to node {it:i}. By default, {cmd:nwtranspose} replaces a network, but you 
can specify that it should create a new network instead ({bf:noreplace}). 


{title:Examples}

	{com}. nwclear
	. nwrandom 5, prob(.3) name(net)
	{com}. nwsummarize net, matonly
	
	{res}     {txt}1   2   3   4   5
          {c TLC}{hline 21}{c TRC}
	1 {c |}  {res}0   0   1   0   0{txt}  {c |}
	2 {c |}  {res}1   0   0   0   0{txt}  {c |}
	3 {c |}  {res}0   0   0   1   0{txt}  {c |}
	4 {c |}  {res}1   1   0   0   1{txt}  {c |}
	5 {c |}  {res}0   0   1   0   0{txt}  {c |}
          {c BLC}{hline 21}{c BRC}

	{com}. nwtranspose net, name(net_transp)
	{com}. nwsummarize net_transp, matonly
	
	{res}     {txt}1   2   3   4   5
          {c TLC}{hline 21}{c TRC}
	1 {c |}  {res}0   1   0   1   0{txt}  {c |}
	2 {c |}  {res}0   0   0   1   0{txt}  {c |}
	3 {c |}  {res}1   0   0   0   1{txt}  {c |}
	4 {c |}  {res}0   0   1   0   0{txt}  {c |}
	5 {c |}  {res}0   0   0   1   0{txt}  {c |}
          {c BLC}{hline 21}{c BRC}
