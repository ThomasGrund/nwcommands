{smcl}
{* *! version 1.0.0  21april2015}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}


{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwhierarchy {hline 2} Hierarchical clustering of nodes}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwhierarchy} 
[{it:{help netname}}]
{cmd:,}
[{opt context}({it:{help nwdissimilar##context:context}})
{opt type}({it:{help nwdissimilar##type:type}})
{opt linkage}({it:{help cluster linkage:linkage}})]


{p 8 17 2}
{cmdab: nwhierarchy} 
,
{opt dismat(matname)}
[{opt linkage}({it:{help cluster linkage:linkage}})]


{p 8 17 2}
{cmdab: nwhierarchy} 
,
{opth disnet(netname)}
[{opt linkage}({it:{help cluster linkage:linkage}})]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt type}({it:{help nwdissimilar##type:type}})}Type of dissimilarity between two nodes; default = euclidean{p_end}
{synopt:{opt context}({it:{help nwdissimilar##context:context}})}Context definition for dissimilarity calculation; default = both{p_end}
{synopt:{opt name}({it:{help newnetname}})}Name of the new similarity network; default = {it:_similar}{p_end}
{synopt:{opt xvars}}Do not generate Stata variables{p_end}

{synoptset 15 tabbed}{...}
{marker type}{...}
{p2col:{it:type}}{p_end}
{p2line}
{p2col:{cmd: euclidean}}Calculate Euclidean distance between the tie vectors of two nodes{p_end}
{p2col:{cmd: manhatten}}Calculate Manhatten distance between the tie vectors of two nodes{p_end}
{p2col:{cmd: hamming}}Calculate Hamming distance between the tie vectors of two nodes{p_end}
{p2col:{cmd: jaccard}}Calculate Jaccard distance between the tie vectors of two nodes{p_end}
{p2col:{cmd: nonmatches}}Calculate percentage of non-matches in tie vectors of two nodes{p_end}

{synoptset 15 tabbed}{...}
{marker context}{...}
{p2col:{it:context}}{p_end}
{p2line}
{p2col:{cmd: both}}Calculate dissimilarity between nodes based on both in- and outgoing ties{p_end}
{p2col:{cmd: incoming}}Calculate dissimilarity between nodes based on incoming ties only{p_end}
{p2col:{cmd: outgoing}}Calculate dissimilarity between nodes based on outgoing ties only{p_end}



{title:Description}

{pstd} 
This command performs hierarchical clustering based on dissimilarities between all nodes {it:i} and {it:j} and returns a clustering
object. Essentially, the command calculates a dissimilarity matrix with {help nwdissimilar} and then performs a normal cluster analysis using {help cluster linkage}.

{pstd}
By default, the similarity is calculated based on both incoming and outgoing ties ({bf:context(both)}). With {bf:context(incoming)} the similarity
between two nodes {it:i} and {it:j} is calculated only based on the ties they receive (columns). Option {bf:context(outgoing)} only considers outgoing ties (rows) when calculating the similarity
between nodes. Practially, option {bf:context(both)} stacks the vector of outgoing and incoming ties.


{title:Example}

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwhierarchy flomarriage}

	{cmd:. clustder dendrogram _clus_1}
	{cmd:. nwdendrogram _clus_1, label(_nodelab)}


{title:See also}

	{help nwdissimilar}, {help cluster linkage}

