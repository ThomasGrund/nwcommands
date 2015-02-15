{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwdyadprob {hline 2} Generate a network based on tie probabilities}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdyadprob} 
[{it:{help netname}}]
[{cmd:,}
{opt mat(matamatrix)}
{opth density(float)}
{opth name(netname)}
{opt xvars}
{opt undirected}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mat}({it:matrix})}Stata or Mata matrix with tie probabilities{p_end}
{synopt:{opth density(float)}}density of the new network{p_end}
{synopt:{opth name(netname)}}name of the new random network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}
{synopt:{opt undirected}}generate undirected network{p_end}


{title:Description}

{pstd}
{cmd:nwdyadprob} generates a random network where each tie {it:x_ij} has the 
probability {it:p_ij} to exist. The values for {it:p_ij} are derived either 1) from the edge values
in network {help netname} and the {it:density} (if given) or 2) from a Stata/Mata matrix specified in {bf:mat()}. The command can be used to create
all sorts of networks.

{pstd}
Let {it:e_ij} be the edge values of network {help netname}. 

{pstd}
Then, the probability for a tie {it:x_ij} to exist in the newly created network is {it:p_ij}:

{pmore}
{it:p_ij = ((e_ij) / sum(e_kl)) * density * 100}

{pstd}
When no {bf:density()} is given, the probability is simply:

{pmore}
{it:p_ij = e_ij}



{title:Example}

{pstd} 
The following example generates a network where ties are more likely to exist between nodes 
with similar {it:gender} and different {it:race}.

{pstd}
First, we generate two variables {it:gender} and {it:race}. 
	
	{cmd:. nwclear}
	{cmd:. set obs 10}
	{cmd:. gen gender = (_n > 5) + 2}
	{cmd:. gen race = int(0.5 + uniform())}

{pstd}
Next, we generate two expanded networks for each of the two variables (see {help nwexpand}). Basically, 
we generate for each variable a matrix {it:M} where {it:M_ij} = 1 when nodes {it:i} and {it:j} have the same
score on an attribute. And these matrices {it:M} are used to generate new networks.

	{cmd:. nwexpand gender}
	{cmd:. nwexpand race}
	
{pstd}
This creates the following networks.

	{com}. nwset
	{res}{txt}(2 networks)
	{hline 20}
		{res}same_gender
		{res}same_race{txt}

{pstd}
Having a closer look at the new network {it:same_gender}, shows the network that {help nwexpand} created.		
	
	{com}. nwsummarize same_gender, matonly

	       1    2    3    4    5    6    7    8    9   10
	   {c TLC}{hline 51}{c TRC}
	 1 {c |}  {res} 0                                             {txt}  {c |}
	 2 {c |}  {res} 1    0                                        {txt}  {c |}
	 3 {c |}  {res} 1    1    0                                   {txt}  {c |}
	 4 {c |}  {res} 1    1    1    0                              {txt}  {c |}
	 5 {c |}  {res} 1    1    1    1    0                         {txt}  {c |}
	 6 {c |}  {res} 0    0    0    0    0    0                    {txt}  {c |}
	 7 {c |}  {res} 0    0    0    0    0    1    0               {txt}  {c |}
	 8 {c |}  {res} 0    0    0    0    0    1    1    0          {txt}  {c |}
	 9 {c |}  {res} 0    0    0    0    0    1    1    1    0     {txt}  {c |}
	10 {c |}  {res} 0    0    0    0    0    1    1    1    1    0{txt}  {c |}
	   {c BLC}{hline 51}{c BRC}
	 
{pstd}
In the next step, we generate a network {it:dyadweight} on the basis of {it:same_gender} and
{it:same_race}.

{pstd}
As an example, we want that in the final network 1) ties between nodes with the same gender 
are overrepresented and 2) ties between nodes with the same race are underrepresented. This generates
tie probabilitities according to this request.  
	
	{cmd:. nwgen dyadweight = exp(5 * same_gender) * exp((-5) * same_race)}

{pstd}
Check out the tie values created in this way:

	{cmd:. nwsummarize dyadweight, matonly}
	
{pstd}
Finally, we create a new network based on tie probabilities defined in network {it:dyadweight}.

	{cmd:. nwdyadprob dyadweight, density(0.1)}
	
{pstd}
The result can be nicely plotted in the following way:

	{cmd:. nwplot, color(gender) layout(circle) title("gender, homophily = exp(5)")}
	{cmd:. graph save g4, replace}
	{cmd:. nwplot, color(race) layout(circle) title("race, homophily = exp(-5)")}
	{cmd:. graph save g5, replace}
	{cmd:. graph combine g4.gph g5.gph }


{title:Remarks}

{pstd}
The program requires some additional programs ({bf:gsample, moremata}) that it will automatically install. 


{title:See also}

	{help nwhomophily}, {help nwgen}, {help nwexpand}
