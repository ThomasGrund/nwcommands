*! Date        : 3sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

// TODO make sure it also works with larger networks (problem: matrix)
// Do the whole thing from scratch and bypass plotmatrix...


capture program drop nwplotmatrix
program nwplotmatrix
	syntax [anything(name=netname)] [if] ,[ * sortby(varlist) group(string) lab label(varname) ylabel(string) xlabel(string) NODichotomize BAckground(string) labelopt(string) legendopt(string asis) COlorpalette(string) LColor(string) legend(string asis) tievalue tievalueopt(string) ]
	_nwsyntax `netname'

	local onenodes `nodes'
	gettoken temp ylabel : ylabel, parse(",")
	gettoken temp xlabel : xlabel, parse(",")
	if substr(`"`ylabel'"',1,1) == "," {
		local ylabel = substr(`"`ylabel'"', 2,.)
	}
	if substr(`"`xlabel'"',1,1) == "," {
		local xlabel = substr(`"`xlabel'"', 2,.)
	}
	preserve
	nwduplicate `netname', name(__temp_sort) xvars
	local netname "__temp_sort"
	tempvar  nodelab 
	tempvar originalSorting

	// deal with if condition
    if "`if'" != "" {
		if "`label'" == "_nodeid" {
			gen `nodelab' = _nodeid
			local label "`nodelab'"
		}
		if "`label'" == "_nodelab" {
			gen `nodelab' = _nodelab
			local label "`nodelab'"
		}
		if "`label'" == "`sortby'"  & "`label'" != "" {
			gen `nodelab' = `sortby'
			local label "`nodelab'"
		}
		nwduplicate `netname', name(__temp_if) xvars
		nwkeep __temp_if `if', attributes(`sortby' `label') 
		_nwsyntax_other __temp_if
		local netname "__temp_if"
		drop if _n > `othernodes' 
	}
	local oldoptions "`options'"
		
	local oldlcolor "`lcolor'"
    qui if "`group'" != "" {
		local 0 "`group'"
		syntax varlist(min=1 max=1) [, lcolor(string) *]
		local groupvar "`varlist'"
		local groupopt "`options'"
		local sortby "`groupvar' `sortby'"
		if "`lcolor'" == "" {
			local lcolor `""scheme p2line""'
		}
	}

	// deal with sorting
    qui if "`sortby'" != "" {
		if "`lab" != "" {
			nwload `netname', labelonly
			local nl "_nodelab"
		}
		gen `originalSorting' = _n
		nwsort `netname', by(`sortby') attributes(`originalSorting' `label' `groupvar')
	}
	local xlines ""

	qui if "`group'" != "" {
		local groupopt "`options'"
		forvalues i = 2/`onenodes' {
			if (`groupvar'[`i'] != `groupvar'[`=`i'-1']) {
				local xlines "`xlines' `=`i'-0.5'"
				local ylines "`ylines' `=2 - `i' - 0.5'"
			}
		}
		local xlinecmd `"xline(`xlines', `groupopt' lcolor(`lcolor'))"'
		local ylinecmd `"yline(`ylines', `groupopt' lcolor(`lcolor'))"'
	}
	local options "`oldoptions'"

	local lcolor `"`oldlcolor'"'
	qui nwsociomatrix_noif `netname', `xlinecmd' `ylinecmd' `lab' label(`label') `nodichotomize' background(`background') ylabel(`labelopt' `ylabel') xlabel(`labelopt' `xlabel') legendopt(`legendopt') color(`colorpalette') lcolor(`lcolor') legend(`legend') `tievalue' tievalueopt(`tievalueopt') `options'
	
	capture nwdrop __temp*
	restore
end



capture program drop nwsociomatrix_noif	
program nwsociomatrix_noif
	syntax [anything(name=netname)] [if] ,[ gap(real 0.1) sortby(varlist) lab label(varname) nodichotomize BAckground(string) ylabel(string) xlabel(string) legendopt(string asis) COlor(string) LColor(string) legend(string asis) tievalue tievalueopt(string) * ]

	_nwsyntax `netname', max(1)

	// Version test
	capture which plotmatrix
	if _rc {
		ssc install plotmatrix
	}
	
	nwtomata `netname', mat(socionet)
	
	if "`dichotomize'" == "" {
		mata: socionet = socionet :/ socionet
		mata: _editmissing(socionet, 0)
	}
	else {
		tempname tabresult
		qui nwtabulate `netname', matrow(`tabresult')
		local tabN = rowsof(`tabresult')
		local split = ""
		forvalues i = 1 / `tabN' {
			local nextValue = `tabresult'[`i',1]
			local split "`split' `nextValue'"
		}
		local split "split(`split')"
	}

	mata: st_matrix("onenet", socionet)
	nwname `netname'
	matrix rownames onenet = `r(labs)'
	matrix colnames onenet = `r(labs)'	

	if "`tievalue'" != "" {
		local freq = "freq"
	}

	if "`maxticks'" == "" {
		local maxticks = "maxticks(`nodes')"
	}

	if "`legend'" != "" {
		if "`dichotomize'" != "" {
			if strpos(`"`legend'"', "off") == 0 {
				if strpos("`legend'", "label") == 0 & strpos("`legend'", "order") == 0{
					local lab ""
					local order ""
					forvalues i = 1 / `tabN' {
						local order "`order' `i'"
						local nextValue = `tabresult'[`i',1]
						local legend `"`legend' label(`legendlab' `i' "`=`i'-1'")"'
					}
					local legend `"`legend' order(`order')"'
				}
			}
		}
		else {
			if strpos(`"`legend'"', "off") == 0  & strpos("`legend'", "order") == 0{
				local legend `"on label(1 "0") label(2 "1") order(1 2)"'
			}
		}
	}
	else {
		local legend "off"
	}
	plotmatrix, gap(`gap') `lab' label(`label') legend(`legend') `freq' tievalueopt(`tievalueopt') `maxticks' `split' ylabel(, angle(0) `ylabel') xlabel(, angle(90) `xlabel') aspect(1) mat(onenet) background(`background') color(`color') lcolor(`lcolor') `options'  
end

// The following code cas been modified....


*! Date        : 24 Apr 2014
*! Version     : 1.20
*! Author      : Adrian Mander
*! Email       : adrian.mander@mrc-bsu.cam.ac.uk
*! Description : Plot matrices/Heat maps

/*
v 1.15 24Nov2008  Bug -- had to specify a cmiss(n) option on the boxes and moved it to version 10.1 (not sure 
> if this is necessary)
v 1.16 20Oct2009  Bug - there is a problem with people using set dp comma added a check to stop the program
v 1.17  6May2011  Add - allow frequencies to be plotted on screen
v 1.18 21May2012  Add option to allow all colours to be specified using the allcolors() option.
v 1.19  8Mar2013  Add a formatcells() option to alter the printing style of the matrix values
v 1.20 24Apr2014  Bug? -- skipping allcolors if the graph is null is now removed
*/

capture program drop plotmatrix
prog def  plotmatrix
version 10.1
syntax , Mat(name) [,ifvar(varname) gap(real 0.05) originalnodes(integer 0) legend(string asis) Split(numlist) lab label(varname) tievalueopt(string) background(string) Color(string) LColor(string) Upper Lower MAXTicks(integer 8) FREQ FORMATCELLS(string) *]
local twoway_opt "`options'"
set more off

local nodes = rowsof(`mat')
local xnames = ""
if "`label'" != "" {
	forvalues i = 1/ `nodes' {
		local onelab = `label'[`i']
		local xnames "`xnames' `onelab'"
	}
}
local ynames `"`xnames'"'
drop _all

/* Find matrix dimensions and col/row names */
local ny = rowsof(`mat')
local nx = colsof(`mat')
if "`ynames'" == "" {
	local ynames: rowfullnames `mat'
}
if "`xnames'" == "" {
	local xnames: colfullnames `mat'
}

local rowsmat = rowsof(`mat')
local colsmat = colsof(`mat')
local rowsname ""
local colsname ""
forvalues i =1 /`rowsmat' {
	local rowsname "`rowsname' v`i'"
}
forvalues i =1 /`colsmat' {
	local colsname "`colsname' v`i'"
}
mat rownames `mat' = `rowsname'
mat colnames `mat' = `colsname'

noi svmat `mat', names(matcol) 
if "`split'" ~= "" _mkdata, s(`split') nc(`nx')
else  _mkdata, nc(`nx')


if "`nodiag'"~="" {
  qui replace col1=. if _stack==y
  qui replace cb=. if _stack==y
}

/***************************************************** 
 * put the numlist of values in split macro 
 *****************************************************/
if "`split'"=="" local split "`r(split)'"


/*Go through the colour cutoffs to create the legend list?*/
local count 1
foreach num of numlist `split' {
  if `count' > 1 local lablist `"`lablist' "`prev'-`num'" "'
  local `count++'
  local prev `num'
}
local lablist `"`lablist' "`prev'" "' 

/*************************************************************************************** 
 * The colour list...get the levels and produce the colours 
 *  ncolleg is the number of columns in legend
 *  size is the number of colors
 *  colorlist is the list of colours
 *
 *  cb is created in the _mkdata command and it is _n per color level according to split
 *  BUT clevels will only see the observed values and groupings not used will be missed
 *
 * work out the number of specified colours and change intensities around them.. 
 * OR if you specify a colorlist
 * then you make the intensity of 1 
 ***************************************************************************************/

qui levelsof cb, local(clevels)

local colorlist ""
local ccc 1
local size:list sizeof clevels
local no_spec_cols: list sizeof color
local new_size = int(`size'/`no_spec_cols'+0.999)
local spcol 1

/*****************************************************
 * Work out the color levels 
 * this is where the set dp is problematic
 *****************************************************/

foreach temp of local clevels {
  if `spcol'>`no_spec_cols' local spcol 1
  local cind`temp' `ccc'
  local cbak = `ccc++'-1
  local fact = int(255 -  200/`new_size'*`cbak')
  local fact2 = int( (255 -  200/`new_size'*`cbak')/2 )
  local fact3 = int( (255 -  200/`new_size'*`cbak')/3 )  
  if `spcol'==1 & `new_size'~=1 local intensity : di %4.2f (255/`new_size'*`cbak')/175+0.15
  if `spcol'==1 & `new_size'==1 local intensity : di %4.2f 1
  if `size'==1 local intensity "1"
  if "`color'"=="" local colorlist `" `colorlist' "`fact3' `fact2' `fact'" "'
  if "`color'"~="" {
    local scolor: word `spcol' of `color'
    local colorlist `" `colorlist' `scolor'*`intensity' "'
    local `spcol++'
  }
}

local ncolleg = int(sqrt(`cbak')+1)
local txt ""
local i 1

//local colorlist "scheme p5"
/*************** This next part is OK if allcolors is empty*****************/
    if "`lcolor'" == "" {
		local blc = `"white"'
	}
	else {
		local blc = `"`lcolor'"'
	}
	
	local i = 1
	foreach c of local clevels {
		qui count if  cb==`c'
		if r(N)>0 {
			if "`done`c''" == "" {
				local clab: word `c' of `lablist'
				local clegord "`clegord' `i'"
				local cleg `" `cleg' label(`i' "`clab'")"'
				local numb`c' `i'
			}
			
			capture local bcolor : word `=`i'-1' of `color'
			if "`bcolor'" == "" {
				local bc `""scheme p`=`i'-1'color""'
			}
			else {
				local bc `"`bcolor'"'
			}
	  
			if `i' == 1 {
				if "`background'" != "" {
					local bc = "`background'"
				}
				else {
					local bc `""scheme background""'
				}
			}
			
			if "`upper'"~="" local xtraif " & y<=_stack"
			if "`lower'"~="" local xtraif " & y>=_stack"
 
			local txt`c' `"area yy xx if cb==`c' & col1~=. `xtraif',  cmiss(n) bfintensity(100) blc("`blc'") blw(vvthin) bc(`bc') nodropb"'
			
			if `"`txt'"'=="" local txt `"(`txt`c'')"'
			else {
				local txt `"`txt'||(`txt`c'')"'
			}
			local gsty "`gsty' p1area"
		}
		local `i++'
   }
   

  /***** this if if allcolors is specified then we make sure missing graphs still abide by the allcolors list 
> */
  
  /* Reconstruct the order of the legend */
foreach cord of local clevels {
  local corder "`corder'`numb`cord'' "
}


// Create labels
local xlab ""
forvalues i = 1 / `nodes'{
	local onelab " "
	if "`xnames'" != "" {
		local onelab : word `i' of `xnames'
	}
	local onelab `"`i' "`onelab'""'
	local xlab `"`xlab'  `onelab'"'
}


local ylab ""
forvalues i = 1 / `nodes'{
	local onelab " "
	local j = 1 - `i'
	if "`ynames'" != "" {
		local onelab : word `i' of `ynames'
	}
	local onelab `"`j' "`onelab'""'
	local ylab `"`ylab'  `onelab'"'
}

if "`lab'" == "" & "`label'" == "" {
	local scaleOff = "yscale(off) xscale(off)"
}




/********************************************************
 * The Freq option
 *  Want to display the values of the cells as the text 
 *  within each box
 *  ALSO the user can alter these formats
 ********************************************************/
if "`freq'"~="" {
  gen newy = -1*y+1
  if "`formatcells'"~="" format col1 `formatcells'
  local txt "`txt'||(scatter newy _stack, mlab(col1) mlabcolor(black) mlabposition(0) ms(i) `tievalueopt')"
} 

gen temp = mod(_n,5)
replace xx = xx - `gap' if temp == 1 | temp == 4
replace xx = xx + `gap' if temp == 2 | temp == 3

replace yy = yy + `gap' if (temp == 1 | temp == 2) 
replace yy = yy - `gap' if (temp == 3 | temp == 4) 

twoway `txt', `scaleOff' legend(`legend') xlabel(`xlab', nogrid) ylabel(`ylab', nogrid) xtitle("") ytitle("") graphregion( c(white) lp(blank)) `twoway_opt' 

di `"twoway `txt', `scaleOff' legend(`legend') xlabel(`xlab', nogrid) ylabel(`ylab', nogrid) xtitle("") ytitle("") graphregion( c(white) lp(blank)) `twoway_opt' "'

end

/************************************************ 
 *
 * Make the dataset that will create the boxes 
 *
 *************************************************/

capture program drop _mkdata
prog def _mkdata, rclass
syntax [varlist] [, Split(numlist) NC(integer 0)]

/* 
Create percentiles if split is not specified
nc is the number of columns.. if there is only one column just do a rename otherwise stack the columns
*/

if `nc'==1 {
  rename `varlist' col1
  qui g _stack = 1
}
else qui stack `varlist', into(col1) clear

/*
 Split option here allows for the calculation of the legend, percentiles are 
 defaults
*/

qui su col1
local min: di %5.3f (`r(min)'-0.001)
local max: di %5.3f (`r(max)'+0.001)
if "`split'"=="" {
  //di as text "Percentiles are used to create legend"
  qui _pctile col1, p( 1 5(10)95 99)
  local i 1
  local split "`min' "
  while r(r`i')~=. {
    local entry:di %5.3f `r(r`i++')'
    local split "`split'`entry' "
  }
  local split "`split' `max'"
}
return local split = "`split'"  

local diff 0.5
qui bysort _stack:g y=_n
qui expand 5
qui bysort _stack y: g yy=-1*cond(_n==1 | _n==2, y+`diff', cond( _n==3 | _n==4, y-`diff',.))+1
qui bysort _stack y: g xx=cond(_n==1 | _n==4, _stack+`diff', cond(_n==3 | _n==2, _stack-`diff',.))

qui g cb =.
qui g colorleg =""
local var "col1"
local pcent 0

foreach num of numlist `split' {
  if `pcent'~=0 {
    qui replace cb = cond( `var'<`num' & `var'>=`prev', `pcent',cb) 
    qui replace colorleg =  cond( `var'<`num' & `var'>=`prev', "`prev'-`num'",colorleg)
  }
  local prev = `num'
  local `pcent++'
}
qui replace cb= cond( `var'==`prev', `pcent',cb)  /* This is the extra very last value*/
qui replace colorleg =  cond( `var'==`prev' , "`prev'",colorleg)

end



