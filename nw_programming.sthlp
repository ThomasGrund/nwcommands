{smcl}
{* *! version  30nov2014}{...}
{phang}
{help nwcommands:NW-5 programming} {hline 2} Network programming


{title:Contents}	
			
{col 14}Section{col 31}Description
{col 14}{hline 46}
{help nw_programming##programming:{col 14}{bf:[NW-5.1]}{...}{col 31}{bf:Writing own programs}}

{help nw_programming##internaldesign:{col 14}{bf:[NW-5.2]}{...}{col 31}{bf:Internal design}}




{marker programming}{...}
{title:Writing own network programs}

{pstd}
Writing own network programs is very easy. The nwcommands offer several helper programs that can be 
included in such programs (see e.g. {help nwtomata}, {help _nwsyntax}).

{pstd}
Let us write our own program {it:myindegree} to calculte indegree centrality (see {help nwdegree}) of a
network {help netname}. Let us program it in such a way that it can be called with a {help netname} as an argument 
and an option {bf:generate()} to save the result.

	{com}capture program drop myindegree
	program myindegree
		syntax [anything(name=netname)] , [ generate(string)]
		
		_nwsyntax `netname'
		nwtomata `netname', mat(net)
		
		local generate = cond("`generate'"=="", "_myindegree", "`generate'")

		mata: indegree = colsum(net)'
		getmata `generate' = indegree, force
		mata: mata drop indegree net
	end{txt}
	
{pstd}
The logic of this little program is that after normal use of {help syntax}, {help _nwsyntax} is called to check if {it:anything}
is a valid network and (if necessary) unabbreviates it (this is very similar to {help syntax}). By default, _nwsyntax only allows one
network in {it:anything}, which is just what we want. When used with the defaults, _nwsyntax also leaves a local macro {it:netname} behind
which holds the unabbreviated network name. Next, in {bf:nwtomata} we refer to this {it:netname} and obtain a Mata matrix {it:net} from
this network.

{pstd}
The line {bf:local generate = cond("`generate'"=="", "_myindegree", "`generate'")} just assigns
a default variable name in case option {bf:generate()} is unspecified.

{pstd}
Now we have the adjacency matrix of the network and can easily calcualted {it:indegree} as {bf:colsum(net)'}.

{pstd}
Lastly, we bring the result, which is stored in the Mata matrix {it:indegree}, back to Stata with {bf:getmata}. 

{pstd}
The program is called like this using the {help netexample:Florentine data}. It generates the Stata variable {it:myindegree_flomarriage}.

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. myindegree flomarriage, generate(myindegree_flomarriage)}	

	
	
{title:Writing own network generator}

{pstd}
Let us write another simple program which takes an existing network as an argument, inverses the adjacency matrix and saves the result as a new network.

	{com}capture program drop myinverse
	program myinverse
		syntax [anything(name=netname)] , [ generate(string)]
		
		_nwsyntax `netname'
		nwtomata `netname', mat(net)
		
		local generate = cond("`generate'"=="", "_myinverse", "`generate'")

		mata: inverse = (net :== 0)
		nwset, mat(inverse) name("`generate'")
		mata: mata drop indegree inverse
	end{txt}

{pstd}
As you can see, the structure of the program is very similar to the one above. The first few lines
are almost identical. Again, we perform some checks and obtain the adjacency matrix of the network
as Mata matrix {it:net}. The line {bf:mata: inverse = (net :== 0)} simply inverts a binary matrix.
Afterwards, all we have to do is {help nwset} a new network using the option {bf:mat()}.

{pstd}
Now we can generate the network {it:flomarriage_inverse} as the inverse of {it:flomarriage} like this:

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. myinverse flormarriage, name(flomarriage_inverse)}
	

{marker internaldesign}{...}
{title:Internal design}

{pstd}
So far, networks are stored in Stata as "quasi-objects", that means they are not internally stored as real Stata objects, but as a 
loose collection of global macros and Mata matrices that behave together like an object. In future versions of the nwcommands, the 
internal design is likely to change to draw on proper object-oriented programming available in Stata. 

{pstd}
The {help macro:global macro} {bf:nwtotal} holds the total number of networks in memory. When the first network is loaded, generated or set, this
macro is initialized to 1.

{pstd}
Whenever a network is generated a set of other global macros holding some meta-information about this network are initialized as well. For example,
the following code produces a random network and shows the relevant global macros afterwards:

	{com}. nwclear
	. nwrandom 4, prob(.2)
	{com}. macro list{txt}
	
{txt}{p 10 26}nwlabs_1:{space 7}{res}{res}net1 net2 net3 net4
{p_end}
{txt}{p 10 26}nwsize_1:{space 7}{res}{res}4
{p_end}
{txt}{p 10 26}nwdirected_1:{space 3}{res}{res}true
{p_end}
{txt}{p 10 26}nw_1:{space 11}{res}{res}net1 net2 net3 net4
{p_end}
{txt}{p 10 26}nwname_1:{space 7}{res}{res}random
{p_end}
{txt}{p 10 26}nwtotal_mata:{space 3}{res}{res}1
{p_end}
{txt}{p 10 26}nwtotal:{space 8}{res}{res}1
{p_end}
{txt}
	
{pstd}
Furthermore, most importantly a Mata matrix called {it:nw_mata1} has been generated as well, 
which holds the adjacency matrix of the network.

	{com}. mata: mata desc

      {txt}# bytes   type                        name and extent
{hline 79}
{res}          128   {txt}real matrix                 {res}nw_mata1{txt}[4,4]
{hline 79}

	{com}. mata: nw_mata1
      {res}       {txt}1   2   3   4
          {c TLC}{hline 17}{c TRC}
	1 {c |}  {res}0   1   1   1{txt}  {c |}
	2 {c |}  {res}0   0   1   0{txt}  {c |}
	3 {c |}  {res}0   0   0   0{txt}  {c |}
	4 {c |}  {res}1   0   0   0{txt}  {c |}
          {c BLC}{hline 17}{c BRC}

		  
{pstd}
All nwcommands internally operate with this design. Hence, manipulating some of these
global macros or Mata matrices without using the proper nwcommands can cause problems and 
crashes.


{title:See also}

	{help _nwevalnetexp}, {help _nwsyntax}, {help nwtomata}
