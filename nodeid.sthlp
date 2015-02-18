{smcl}
{marker topic}
{helpb nw_topical##concept:[NW-2.1] Concepts}
{* *! version 1.0.6  17sept2014 author: Thomas Grund}{...}

{title:Title}

    {hi:Identification of nodes}

{title:nodeid}

{pstd}
A {help _nwnodeid:nodeid} is an integer number used to identify nodes in a network. Every node in a network is automatically assigned
a {it:nodeid}. The range of these numbers goes from 1 to {it:size of the network}, where every integer number identifies
exactly one node. When a node is deleted, the {it:nodeid}'s of all other nodes are automatically changed, so that all 
consecutive numbers from 1 to {it:size of the network} correspond to one node. When attributes (saved as Stata variables) are used, the variable value of
row {it:i} corresponds to the attribute of the node with {it:nodeid i}. Nodeid's cannot be changed by the user other than
when nodes are deleted. 

{title:nodelab}

{pstd}
A {help _nwnodelab:nodelab} is more flexibile than a {it:nodeid} and attaches a unique {help word} to each node for 
identification. Node labels can be changed. There are basically two ways: 1) using {help nwname:nwname, newlab(lab1 lab2...)} or  2) using {help nwname:nwname, newlabfromvar(varname)}. Node
labels uniquely identify nodes in a network.

{title:Finding the nodeid and nodelab}

{pstd}
Both nodeid and nodelab of nodes can be found out easily. The most simple way is probably to 
use {help nwload}. This generates the variables _nodeid, _nodelab, and _nodevar.
{p_end}

{pstd}
If one wants to know the nodelab that corresponds to a nodeid one can use {help _nwnodelab}.
The other way around, when one knows a nodelab and wants to know the nodeid of a node, one can 
use {help _nwnodeid}.
{p_end}

    For example, 
	
     {com}. _nwnodelab, nodeid(9) detail
     {res}
     {hline 40}
     {txt}  Network: {res}flomarriage
     {hline 40}
     {txt}    Nodeid: {res}9
     {txt}    Nodelab: {res}medici



