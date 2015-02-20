{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}

{title:Title}

{p2colset 9 14 22 2}{...}
{p2col :nwsave  {hline 2} Save network data in file}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwsave} 
{it:{help filename}}
[{cmd:,}
{cmd:format}({it:{help nwsave##save_format:save_format}})
{it:{help save##save_options:save_options}}
]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{cmd: format}({it:{help nwsave##save_format:save_format}})}saves network either as matrix or as edgelist{p_end}


{synoptset 20 tabbed}{...}
{marker save_format}{...}
{p2col:{it:save_format}}Description{p_end}
{p2line}
{p2col:{cmd: matrix}}saves networks as adjacency matrices; default
		{p_end}
{p2col:{cmd: edgelist}}saves networks as edgelists
		{p_end}

{title:Description}

{pstd}
{bf:nwsave} stores the networks currently in memory on disk under the name {it:filename}. By default, network data is saved as an adjacencey matrix (stored in Stata variables), unless 
{bf:format(edgelist)} is specified or unless there is not enough space to create the necessary Stata variables. In the latter case, the command also switches to store the network data
as {it:edgelists}. When networks have been saved, they can be loaded again using {help nwuse}.

{pstd}
The command automatically saves the data with {help save}, but also creates the necessary meta-information for each network in memory. 

{pstd}
All options one can use with {help save} can be used together with {help nwsave} as well.


{title:Examples}
	
{pstd}
This example creates 5 new random networks and {help nwsave:saves} them as {it:mynets}.	A new dataset called {it:mynets.dta} is created in the working director with the networks and the relevant meta-information.

	{cmd:. nwclear}
	{cmd:. nwrandom 20, ntimes(5) prob(.2)}
	{cmd:. nwsave mynets}

{pstd}
After this, one can easily load these 5 networks in a new Stata session. Just as if one would load a normal Stata dataset. The difference is that {help nwuse} automatically declares data 
to be network data with the meta-information it finds in the dataset.

	{cmd:. nwuse mynets}
	
{marker fileformat}{...}
{title:Stata network file-format}

{pstd}
As user one will never have to interact with the Stata file-format for networks directly. However, in case you want to write your own import function for 
non-supported network file-formats or just want to know more about how network data is saved in .dta files, here is a description of the file format
the nwcommands use.

{pstd}
Each {bf:.dta} file loaded with {help nwuse} needs to have the following variables as meta-information. The first two
variables hold general meta-information about the format and the number of networks saved in this file. 

{center:{c TLC}{hline 14}{c TT}{hline 56}{c TRC}}
{center:{c |} varname      {c |}     Description                                        {c |}}
{center:{c LT}{hline 14}{c TT}{hline 56}{c RT}}
{center:{c |} _format      {c |} Format ("matrix" or "edgelist")                        {c |}}
{center:{c |} _nets        {c |} Number Z of networks saved in this file                {c |}}
{center:{c BLC}{hline 14}{c BT}{hline 56}{c BRC}}

{pstd}
For each network {it:z} that is stored in the dataset additional meta-information is saved: 

{center:{c TLC}{hline 14}{c TT}{hline 56}{c TRC}}
{center:{c |} varname      {c |}     Description                                        {c |}}
{center:{c LT}{hline 14}{c +}{hline 56}{c RT}}
{center:{c |} _name        {c |} Name of the networks; _name[1]-_name[Z]                {c |}}
{center:{c |} _directed    {c |} Directionality of networks: _directed[1]-_directed[Z]  {c |}}
{center:{c |} _size        {c |} Size of networks: _size[1]-_size[Z]                    {c |}}
{center:{c BLC}{hline 14}{c BT}{hline 56}{c BRC}}

{pstd}
For each network {it:z} there also need to exist the variables: 

{center:{c TLC}{hline 14}{c TT}{hline 36}{c TRC}}
{center:{c |} varname      {c |}     Description                    {c |}}
{center:{c LT}{hline 14}{c +}{hline 36}{c RT}}
{center:{c |} _nodevar`z'  {c |} Stata variables used for network z {c |}}
{center:{c |} _nodelab`z'  {c |} Node labels for network z          {c |}}
{center:{c BLC}{hline 14}{c BT}{hline 36}{c BRC}}


{pstd}
{bf:Edgelist format:}

{pstd}
When _format[1] == "edgelist" there are two variables defining the sender and receiver ID. Furthermore, there is one variable `_name[`z']' for each network in the dataset, which
holds the tie values of the node pair (_fromid, _toid) for network {it:z}. 

{center:{c TLC}{hline 14}{c TT}{hline 21}{c TRC}}
{center:{c |} varname      {c |}     Description     {c |}}
{center:{c LT}{hline 14}{c +}{hline 21}{c RT}}
{center:{c |} _fromid      {c |} ID of sender        {c |}}
{center:{c |} _toid        {c |} ID of receiver      {c |}}
{center:{c |} `_name[`z']' {c |} Tie value           {c |}}
{center:{c BLC}{hline 14}{c BT}{hline 21}{c BRC}}

{pstd}
This file format is best understood by studying the raw .dta file for e.g. the Florentine network data. Notice that this command only loads the raw data, but does not
{help nwset:declare the data as network data}.

	{cmd:. use http://nwcommands.org/data/florentine.dta, clear}

	
{pstd}
{bf:Matrix format:}

{pstd}
When _format[1] == "matrix" there are {it:z * k} variables with the names given in {it:_nodevar`z'[`k']}, where {it:k} is the number of nodes in network 
{it:z}. These variables store the network as an adjacency matrix in Stata variable format.

{center:{c TLC}{hline 22}{c TT}{hline 40}{c TRC}}
{center:{c |} varname              {c |}     Description                        {c |}}
{center:{c LT}{hline 22}{c +}{hline 40}{c RT}}
{center:{c |} `_nodevar`z'[`k']'   {c |} Adjacency matrix for network z         {c |}}
{center:{c BLC}{hline 22}{c BT}{hline 40}{c BRC}}

{pstd}
Again, this file format is best understood by studying the raw .dta file for e.g. the Gang network data. Notice that this command only loads the raw data, but does not
{help nwset:declare the data as network data}.

	{cmd:. use http://nwcommands.org/data/gang.dta, clear}

	
	
{title:See also}

	{help webnwuse}, {help nwuse}, {help use}

	
