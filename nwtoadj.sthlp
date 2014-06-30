{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwtoadj
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwtoadj {hline 2}}Converts an edgelist to an adjacency matrix{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtoadj} 
{cmd:,}
[{opt nnodes(nodes)}
{opt fromvars(varlist)}
{opt fromid(varname)}
{opt toid(varname)}
{opt link(varname)}
{opt nofromvars}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt n:nodes(nodes)}}specifies the number of nodes.{p_end}
{synopt:{opt fr:omvars(varlist)}}attributes of sending node to be included{p_end}
{synopt:{opt fromid(varname)}}variable name specifying {it: fromid}.{p_end}
{synopt:{opt toid(varname)}}variable name specifying {it: toid}.{p_end}
{synopt:{opt link(varname)}}variable name specifying link. {p_end}
{synopt:{opt nofr:omvars}}diregard attribute values{p_end}



{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwtoadj} Reads an edgelist and converts it to an adjacency matrix that
consists of variables called var1, var2 … varn. 

{title:Options}

{dlgtab:Main}

{phang}
{opt n:nodes(nodes)} specifies the number of nodes. This must be specified if the edgelist is not in full
format, that is, if it does not contain n*n observations. By default all variables that start with the prefix 
{it: from_} are kept, their prefixes are removed,
and they are included in the dataset containing the adjacency-matrix variables. The {it: from_}
variables need to be constant within {it: fromid}, because only one observation per sending node
is retained.

{phang}
{opt fr:omvars(varlist)}Needs to be specified if the user prefers to choose which attribute variables
of the sending node shall be included in the new dataset. These variables need to be constant
within {it: fromid}. Names starting with the prefix {it: from_} will have the prefix removed, while other
names will not be changed.

{phang}
{opt nofr:omvars}Needs to be specified if no attribute variables shall be included in the adjacency
matrix dataset.

{title:Remarks}

{pstd}
None. 


{title:Examples}
To be written.

{title:Also see}
