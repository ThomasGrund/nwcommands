{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{cmd:help nwdyadprob}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwdyadprob  {hline 2}}Generates a network based on tie probabilities{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdyadprob} 
[{help netname}]
{cmd:,}
{opt density(float)}
{opt name(string)}
{opt xvars}
{opt undirected}


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt density}({it:float})}density of the new network{p_end}
{synopt:{opt name}({it:new}{it:{help netname}})}name of the new random network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}
{synopt:{opt undirected}}generate undirected network{p_end}


{title:Description}

{pstd}
{cmd:nwdyadprob} generates a random network where each tie x_ij has the 
probability p_ij to exist. The values for p_ij are derived from the edge values
in network {help netname} and the {it:density}. The command can be used to create
all sorts of networks based on a matrix for probabilities (given as another network).

{pstd}
Let e_ij be the edge values of network {netname}. 

{pstd}
Then, p_ij = ((e_ij) / sum(e_kl)) * density * 100 

{pstd}
The command is a {help nwgenerator} and can be used whenever such an element is allowed. 


{title:Examples}
	
	{cmd:. nwclear}
	// Generate a homophily network based on two variables
	 
	// Generate variables gender and race
	{cmd:. set obs 20}
	{cmd:. gen gender = (_n > 10) + 2}
	{cmd:. gen race = int(0.5 + uniform())}
	
	// Generate expanded networks based on variables
	{cmd:. nwexpand gender}
	{cmd:. nwexpand race}
	
	// Generate network that holds the probabilities for each tie
	// Ties between nodes with the same gender should be overrepresented.
	// Ties between nodes with the same race should be underrepresented.
	{cmd:. nwrandom 20, prob(1) name(dyadweight)}
	{cmd:. nwreplace dyadweight = exp(5 * same_gender) * exp((-5) * same_race)}
	
	{cmd:. nwdyadprob dyadweight, density(0.1)}
	
	// Show result
	{cmd:. nwplot, color(gender) layout(circle) title("gender, homophily = exp(5)")}
	{cmd:. graph save g4, replace}
	{cmd:. nwplot, color(race) layout(circle) title("race, homophily = exp(-5)")}
	{cmd:. graph save g5, replace}
	{cmd:. graph combine g4.gph g5.gph }

{title:See also}
	{help nwassortmix}
