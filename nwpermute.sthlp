{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwpermute {hline 2} Generate permutation of a network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwpermute} 
[{it:{help netname}}]
[{cmd:,}
{opth name(newnetname)}
{opt xvars}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth name(newnetname)}}name of the new random network; default = {it:netname_perm}{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
Produces a random permutation of the network {help netname} and saves it as the new network {it:netname_perm}. 
Essentially, ihe {help nodeid}'s of the nodes are randomly reshuffled. 

{pstd}
A simple example illustrates what the command does. First, we generate a regular lattice network. 
 
	{com}. nwclear
	. nwlattice 3 3
	{com}. nwsummarize lattice, matonly

	     1   2   3   4   5   6   7   8   9
	  {c TLC}{hline 37}{c TRC}
	1 {c |}  {res}0                                {txt}  {c |}
	2 {c |}  {res}1   0                            {txt}  {c |}
	3 {c |}  {res}0   1   0                        {txt}  {c |}
	4 {c |}  {res}1   0   0   0                    {txt}  {c |}
	5 {c |}  {res}0   1   0   1   0                {txt}  {c |}
	6 {c |}  {res}0   0   1   0   1   0            {txt}  {c |}
	7 {c |}  {res}0   0   0   1   0   0   0        {txt}  {c |}
	8 {c |}  {res}0   0   0   0   1   0   1   0    {txt}  {c |}
	9 {c |}  {res}0   0   0   0   0   1   0   1   0{txt}  {c |}
	  {c BLC}{hline 37}{c BRC}

{pstd}
Now, let us permute the network {it:lattice}.
		
	{com}. nwpermute lattice
	{com}. nwsummarize lattice_perm, matonly

	     1   2   3   4   5   6   7   8   9
	  {c TLC}{hline 37}{c TRC}
	1 {c |}  {res}0                                {txt}  {c |}
	2 {c |}  {res}1   0                            {txt}  {c |}
	3 {c |}  {res}0   0   0                        {txt}  {c |}
	4 {c |}  {res}0   0   1   0                    {txt}  {c |}
	5 {c |}  {res}1   0   0   0   0                {txt}  {c |}
	6 {c |}  {res}0   1   0   1   0   0            {txt}  {c |}
	7 {c |}  {res}0   0   0   0   1   0   0        {txt}  {c |}
	8 {c |}  {res}0   0   1   0   0   0   1   0    {txt}  {c |}
	9 {c |}  {res}0   1   0   1   1   0   0   1   0{txt}  {c |}
	  {c BLC}{hline 37}{c BRC}

{pstd}
The structure of the network remains exactly the same, however, the nodes have different {help nodeid}'s. Often,
such a permutation is desired to recalculate network statistics (and derive standard errors and confidence intervals for 
these statistics) while keeping the overall structure of the network constant (see more {help nwqap}, {help nwcorrelate}).	
	
	
{title:Example}

{pstd}
The next example shows how the nodeid's of the nodes have changed after permutation.
	
	{cmd:. nwrandom 10, prob(.3)}
	{cmd:. nwplot, label(_label)}
	{cmd:. graph save g1.gph, replace}
	{cmd:. nwpermute}
	{cmd:. nwplot, labels(_label)}
	{cmd:. graph save g2.gph, replace}
	{cmd:. graph combine g1.gph g2.gph}
	

{title:See also}

	{help nwqap}, {help nwcorrelate}
