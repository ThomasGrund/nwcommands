{smcl}
{* *! version 1.0.0  21april2015}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{marker top2}
{helpb nw_topical##analysis:[NW-2.6] Analysis}


{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwsimilar {hline 2} Generate node similarities}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwsimilar} 
[{it:{help netname}}]
{cmd:,}
[{opt mode}({it:{help nwsimilar##context:type}})
{opt name}({it:{help newnetname}})
{opt xvars}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt type}({it:{help nwsimilar##type:type}})}Type of similarity between two nodes; default = pearson{p_end}
{synopt:{opt mode}({it:{help nwsimilar##context:context}})}Context definition for similarity calculation; default = both{p_end}
{synopt:{opt name}({it:{help newnetname}})}Name of the new similarity network; default = {it:_similar}{p_end}
{synopt:{opt xvars}}Do not generate Stata variables{p_end}

{synoptset 15 tabbed}{...}
{marker type}{...}
{p2col:{it:type}}{p_end}
{p2line}
{p2col:{cmd: pearson}}Calculate Pearson correlation for tie vectors of two nodes{p_end}
{p2col:{cmd: hamming}}Calculate Hamming distance between the tie vectors of two nodes{p_end}
{p2col:{cmd: jaccard}}Calculate Jaccard distance between the tie vectors of two nodes{p_end}
{p2col:{cmd: matches}}Calculate percentage of matches in tie vectors of two nodes{p_end}
{p2col:{cmd: crossproduct}}Calculate the cross-product of the tie vectors of two nodes{p_end}

{synoptset 15 tabbed}{...}
{marker context}{...}
{p2col:{it:mode}}{p_end}
{p2line}
{p2col:{cmd: both}}Calculate dissimilarity between nodes based on both in- and outgoing ties{p_end}
{p2col:{cmd: incoming}}Calculate dissimilarity between nodes based on incoming ties only{p_end}
{p2col:{cmd: outgoing}}Calculate dissimilarity between nodes based on outgoing ties only{p_end}



{title:Description}

{pstd}
This command calculates the similarities between all nodes {it:i} and {it:j} and saves the result in a new network. The similarity between two nodes reflects how similar these nodes
are regarding the ties they have to other nodes (tie vectors). 

{pstd}
By default, the similarity is calculated based on both incoming and outgoing ties ({bf:mode(both)}). With {bf:mode(incoming)} the similarity
between two nodes {it:i} and {it:j} is calculated only based on the ties they receive (columns). Option {bf:mode(outgoing)} only considers outgoing ties (rows) when calculating the similarity
between nodes. Practially, option {bf:mode(both)} stacks the vector of outgoing and incoming ties.


{pstd}
{bf:Pearson similarity:}

{pstd}
This measure calculates the Pearson correlation coefficient for two tie vectors of nodes {it:i} and {it:j}. See {help nwcorrelate##nodes:here for more information} on this (see also {help nwcorrelate}. 


{pstd}
{bf:Hamming similarity:}

{pstd}
The Hamming similarity is the number of entries in the tie vectors of nodes {it:i} and {it:j} that are identical. Notice that the Hamming similarity treats joint
absence as similarity as well.

{pmore}
{it:D_ij = sum(i_outvec :== j_outvec) + sum(i_invec :== j_invec)}


{pstd}
{bf:Jaccard similarity:}

{pstd}
The Jaccard similarity (or Jaccard index) of two tie vectors A and B is the the number of ties that exist in both A and B divided by 
the total number of ties that exist either in A or in B. When the tie profiles of nodes {it:i} and {it:j} are exactly the same the Jaccard index equals 1. In contrast to the
Hamming similarity, the Jaccard similarity does not consider non-ties. 

{pmore}
{it:D_ij = sum(A :!= 0 and B :!= 0) / sum(A :!= 0 or B :!= 0)}


{pstd}
{bf:Matches similarity:}

{pstd}
Simply gives the percentage of dyads (tie or non-tie) that nodes {it:i} and {it:j} have in common with the same alters. Notice that {it:i} and {it:j} are excluded from
from these alters.

{pmore}
{it:D_ij = (sum(i_outvec :== j_outvec) + sum(i_invec :== j_invec)) / 2 * (n - 1)}


{pstd}
{bf:Cross-product similarity:}

{pstd}
Calculates the cross-product of the tie vectors of nodes {it:} and {it:j}

{pmore}
{it:D_ij = (sum(i_outvec :* j_outvec) + sum(i_invec :* j_invec))}


{title:Example}

{cmd:. webnwuse florentine}
{cmd:. nwsimilar flomarriage}

{cmd:. nwsimilar flomarriage, type(hamming) mode(outgoing)}


{title:See also}

	{help nwdissimilar}, {help nwcorrelate}
