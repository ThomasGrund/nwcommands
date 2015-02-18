{smcl}
{* *! version 1.0.0  3sept2014}{...}

{title:Title}

{p2colset 9 20 23 2}{...}
{p2col :nwtabulate {hline 2} One-way table of dyads}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtab:ulate} 
[{it:{help netname}}]
[{cmd:,}
{opt selfloop}
{it:{help tabulate_oneway##tabulate1_options:tabulate1_options}}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt selfloop}}includes self-loops{p_end}


{title:Description}

{pstd}
The one-way nwtabulate simply tabulates all dyads in the network and shows the distribution of dyad
values. It works just as {help tabulate}, but on the level of network dyads. By default, the diagonal of
the underlying adjacency matrix of {help netname} is excluded, unless {bf:selfloop} is specified.

{pstd}
The command calls {help tabulate} with a temporary variable that holds the dyads of a network, hence, all 
{it:{help tabulate_oneway##tabulate1_options:tabulate1_options}} can be used.

{title:Example}
	
   {cmd:. webnwuse gang}
   {cmd:. nwtabulate gang}
{res}
{txt}   Network:  {res}gang{txt}{col 24}Directed: {res}false{txt}

       gang {c |}      Freq.     Percent        Cum.
{hline 12}{c +}{hline 35}
          0 {c |}{res}      1,116       77.99       77.99
{txt}          1 {c |}{res}        182       12.72       90.71
{txt}          2 {c |}{res}         92        6.43       97.13
{txt}          3 {c |}{res}         25        1.75       98.88
{txt}          4 {c |}{res}         16        1.12      100.00
{txt}{hline 12}{c +}{hline 35}
      Total {c |}{res}      1,431      100.00

	  {pstd}{txt}
In the {it:gang} network, 1116 potential (undirected) co-offending ties are not realized, 182 ties have the value 1,
92 ties have the value 2 and so on.


{title:See also}

    {help nwtab2:two-way nwtabulate}, {help tabulate}
