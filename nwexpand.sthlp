{smcl}
{* *! version 1.0.6  16may2012}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwexpand {hline 2} Expand variable to network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwexpand} 
{it:{help varname}} [{it:{help if}}]
{cmd:,}
[{opt mode}({it:{help nwexpand##expand_mode:mode}})
{opth nodes(int)}
{opt name}({it:{help newnetname}})
{opt vars}({it:{help newvarlist}})
{opt xvars}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mode}({it:{help nwexpand##expand_mode:mode}})}mode used to expand variable; default = {it:same}{p_end}
{synopt:{opth nodes(int)}}size of new network{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new random network; default = {it:{help nwexpand##expand_mode:mode}_varname}{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}

{synoptset 20 tabbed}{...}
{marker expand_mode}{...}
{p2col:{it:mode}}{p_end}
{p2line}
{p2col:{cmd: same}}{it:same(x_ij) = (varname[i] == varname[j])}{p_end}
{p2col:{cmd: dist}}{it:dist(x_ij) = (varname[i] - varname[j])}{p_end}
{p2col:{cmd: distinv}}{it:invdist(x_ij) = 1 / (varname[i] - varname[j])}{p_end}
{p2col:{cmd: absdist}}{it:dist(x_ij) = (|varname[i] - varname[j]|)}{p_end}
{p2col:{cmd: absdistinv}}{it:invdist(x_ij) = 1 / (|varname[i] - varname[j]|)}{p_end}
{p2col:{cmd: sender}}{it:sender(x_ij) = varname[i]}{p_end}
{p2col:{cmd: receiver}}{it:receiver(x_ij) = varname[j]}{p_end}


{title:Description}

{pstd}
This command generates a new network by expanding an existing variable. When option {bf:nodes()} is unspecified, the 
command generates a network with {help _N} nodes. 
 
{pstd}
The value {it:M_ij} of the adjacency matrix {it:M} of the new network is calculated from the values {help varname}{bf:[i]}, {help varname}{bf:[j]}
and some function {it:expfcn} defined by {it:{help nwexpand##expand_mode:mode}}. By default, {it:mode = same}.

{pstd}
Valid modes are: {bf:same, dist, distinv, absdist, abdistinv, sender, receiver}

{pstd} 
An example demomstrates how this works. First, we generate a small dataset with 6 observations and the new variable {it: gender}. This new variable
takes the value 0 for observations 1-3 and the value 1 for observations 4-6.

	{cmd:. nwclear}
	{cmd:. set obs 6}
	{cmd:. gen gender = (_n > 3)}
	{cmd:. list gender}
     
	   {c TLC}{hline 8}{c TRC}
	   {c |} {res}gender {txt}{c |}
	   {c LT}{hline 8}{c RT}
	1. {c |} {res}     0 {txt}{c |}
	2. {c |} {res}     0 {txt}{c |}
	3. {c |} {res}     0 {txt}{c |}
	4. {c |} {res}     1 {txt}{c |}
	5. {c |} {res}     1 {txt}{c |}
	   {c LT}{hline 8}{c RT}
	6. {c |} {res}     1 {txt}{c |}
	   {c BLC}{hline 8}{c BRC}


{pstd}
Next, we use {it:nwexpand} to generate a new network from this variable. This generate a new network called {it:same_gender}.

	{cmd:. nwexpand gender}	   

	
{pstd}
By looking closer at the adjacency matrix {it:M} of this new network we see how the default {it:exp_fcn = same} generated the entries {it:M_ij} as:

{pmore}
{it:M_ij = (varname[i] == varname[j])}.
	
	{com}. nwsummarize same_gender, matonly

	     1   2   3   4   5   6
	  {c TLC}{hline 25}{c TRC}
	1 {c |}  {res}0                    {txt}  {c |}
	2 {c |}  {res}1   0                {txt}  {c |}
	3 {c |}  {res}1   1   0            {txt}  {c |}
	4 {c |}  {res}0   0   0   0        {txt}  {c |}
	5 {c |}  {res}0   0   0   1   0    {txt}  {c |}
	6 {c |}  {res}0   0   0   1   1   0{txt}  {c |}
          {c BLC}{hline 25}{c BRC}
	
	
{pstd}
Alternatively, let us select another mode to illustrate the difference. This command generates a new network called {it:dist_gender} with 
the following adjacency matrix:

{pmore}
{it:M_ij = (varname[i] - varname[j])}.

	{cmd:. nwexpand gender, mode(dist)}
	{cmd:. nwsummarize dist_gender, matonly}


	     {txt} 1    2    3    4    5    6
	  {c TLC}{hline 31}{c TRC}
	1 {c |}  {res} 0    0    0   -1   -1   -1{txt}  {c |}
	2 {c |}  {res} 0    0    0   -1   -1   -1{txt}  {c |}
	3 {c |}  {res} 0    0    0   -1   -1   -1{txt}  {c |}
	4 {c |}  {res} 1    1    1    0    0    0{txt}  {c |}
	5 {c |}  {res} 1    1    1    0    0    0{txt}  {c |}
	6 {c |}  {res} 1    1    1    0    0    0{txt}  {c |}
          {c BLC}{hline 31}{c BRC}

	
{pstd}
Generally, creating networks like this can be extremely useful for many purposes. For example, one can use it to plot 
the edgecolors of ties differently when two nodes have the same value on some attribute. This example 
loads the {it:gang} network and plots the color of ties in such a way that it shows if two gang members
(who co-offend with each other) were either 1) both in prison before or 2) both not in prison before.

	{cmd:. webnwuse gang, nwclear}
	{cmd:. nwexpand Prison}
	{cmd:. nwplot gang, edgecolor(same_Prison)}

	
{pstd}
The next example loads the {it:glasgow} dataset and colors ties differently depending on whether the sender
of a friendship tie did sport at wave1.

	{cmd:. webnwuse glasgow, nwclear}
	{cmd:. nwexpand sport1, mode(sender)}
	{cmd:. nwplot glasgow1, edgecolor(sender_sport1)}
	

{title:See also}

	{help nwcorrelate}
