{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##programming:[NW-2.9] Programming}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwcompressobs {hline 2} Compresses observations in Stata}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}{cmd:nwcompressobs}

{title:Description}

{pstd}
Comresses the observations in Stata. Deletes all unnecessary cases that are not needed
to represent the largest network. When the dataset also contains an attribute variable with non-missing
data, these cases are not deleted.

{title:Examples}

	{cmd:. nwclear}
	{cmd:. nwrandom 20, prob(.2)}
	{cmd:. set obs 50}
	{cmd:. nwcompressobs}
	
	
{title:See also}

  {help nwdrop}, {help clear}
