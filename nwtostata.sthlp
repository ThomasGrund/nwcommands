{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwtostata
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwtostata {hline 2}}Converts network from Mata to Stata{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtostata} 
{cmd:, }
{opt mat(matname)}
{{opt gen(newvarlist) | stub(newstubname)}}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt mat(matname)}}name of the Mata matrix{p_end}
{synopt:{opt gen(newvarlist)}}specifies a list of new variable names in Stata{p_end}
{synopt:{opt stub(newstubname)}}specifies the prefix of the new variable names in Stata{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
Most of the nw-commands described are programmed in Mata, which is Stata’s
built in matrix programming language, see help mata in Stata. You do not need to know
Mata to use the nw-commands, but sometimes it may be more convenient to use Mata instead
of Stata, as Mata is extremely fast. To make it easier to move back and forth between Mata and
Stata, there are two Stata commands nwtomata and nwtostata.{cmd: nwtostata} Converts a matrix (or column vector) in Mata to Stata. It creates new Stata variables 
that contain the data in the Mata matrix. The number of observations in the Stata dataset will automatically be set to the number of
rows in the Mata matrix. Either {cmd: gen(newvarlist)} or {cmd: stub(newstubname)} need to be specified.

{title:Options}


{dlgtab:Main}

{phang}
{opt mat(matname)} Used to specify the name of the Mata matrix.

{phang}
{opt gen(newvarlist)} Specifies a list of new variable names, one name for each column of the Mata
matrix.

{phang}
{opt stub(newstublist)} Specifies the prefix of the new variable names. The new variables will be
called stub1, stub2, … stubn, where n is the number of columns in the Mata matrix.

{title:Remarks}

{pstd}
None. 


{title:Examples}
{cmd:. nwrandom 20, prob(.1)}
{cmd:. nwtomata, copy}
{cmd:. mata: nwadjview}
{cmd:. clear}
{cmd:. nwtostata, mat(nwadjview)}

{title:Also see}

{psee}
Online:  {help nwtomata}
{p_end}