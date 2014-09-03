{smcl}
{* *! version 1.0.0  3sept2014}{...}
{cmd:help nwtriads}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwtriads  {hline 2}}Triad census of the network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtriads} 
[{help netname}]

{title:Description}

{pstd}
Returns the triad census of the network. Each unique triad of nodes A, B, and C can 
have one of the following values. The triad census gives a fingerprint of the network.

	003 = A,B,C, empty triad.
	012 = A->B, C, triad with a single directed edge.
	102 = A<->B, C, triad with a reciprocated connection between two vertices.
	021D = A<-B->C, triadic out-star.
	021U = A->B<-C triadic in-star.
	021C = A->B->C, directed line.
	111D = A<->B<-C.
	111U = A<->B->C.
	030T = A->B<-C, A->C.
	030C = A<-B<-C, A->C.
	201 = A<->B<->C.
	120D = A<-B->C, A<->C.
	120U = A->B<-C, A<->C.
	120C = A->B->C, A<->C.
	210 = A->B<->C, A<->C.
	300 = A<->B<->C, A<->C,  complete triad.
 


{title:Examples}
	
	// Directed network
	{cmd:. webnwuse glasgow}
	{cmd:. nwtriads}

{title:See also}

	{help nwdyads}


