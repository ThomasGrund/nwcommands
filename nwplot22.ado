capture program drop nwplot22
program nwplot22
	version 9.0
	set more off
	syntax [anything(name=netname)],[ arcstyle(integer 1) arcbend(string) arcsplines(integer 10) nodexy(varlist numeric min=2 max=2) edgeforeground(string) GENerate(string) colorpalette(string) edgecolorpalette(string) edgepatternpalette(string) symbolpalette(string) lineopt(string) scatteropt(string) size(varname) color(varname) edgecolor(string) label(varname) nodefactor(string) sizebin(string) edgefactor(string) arrowfactor(string) arrowgap(string) barbfactor(string) layout(string) arrows iterations(integer 1000) scheme(string) * ]
	_nwsyntax `netname', max(1)
	
	if "`edgecolor'" != "" {
		nwname `netname'
		local netnamebackup = "`netname'"
		local nodes = r(nodes)
		_nwsyntax `edgecolor', max(1)
		nwname `edgecolor'
		local colnodes = r(nodes)
		local netname = "`netnamebackup'"
		if `nodes' != `colnodes' {
			di "{err}{bf:edgecolor} needs to be a network of the same size as {bf:`netname'}"
			error 6056
		}
	}
	
	if "`barbfactor'" == "" {
		local barbfactor = 1
	}
	if "`sizebin'" == "" {
		local sizebin = 1
	}
	if "`nodefactor'" == "" {
		local nodefactor = 1
	}
	local nodefactor = `nodefactor' / 50
	
	if "`edgefactor'" == "" {
		local edgefactor = 1
	}
	if "`arrowfactor'" == "" {
		local arrowfactor = `edgefactor'
	}
	if "`arrowgap'" == "" {
		local arrowgap = 0
	}
	if "`arcbend'" == "" {
		local arcbend = 2
	}
		
	if("`layout'"=="") {
		local layout "mds"
	}	
	local dolabel  = ("`label'" !="")

	if "`directed'" == "false" & `arcstyle' == 1 {
		local arcstyle = 3
	}
	if "`directed'" == "true" {
		local arrows = "arrows"
	}
	if "`arrows'" != "" {
		local pc "pcarrow"
		local doarrows = 1
	}
	else {
		local pc "pcspike"
		local doarrows = 0
	}
	if "`scheme'" != "" {
		local schemetwoway "scheme(`scheme')"
	}
	
	if "`scheme'" == "s2network" {
		if "`colorpalette'" == "" {
			local colorpalette = "gold red green blue lavender"
			local edgecolorpalette = "white red green blue"
		}
		local options = "plotregion(color(black)) graphregion(color(black)) `options'"
	}
	
	if ("`size'" != ""){
		qui sum `size'
		if (`r(max)' > 100 | `r(min)' <= 0) {
			di "{err}node size needs to have values between 1 and 100"
			exit
		}
		qui gen __size = `size' * 100
		mata: nsize = st_data((1,`nodes'),st_varindex("__size"))
		qui drop __size
		local nodefactor = `nodefactor' / 20
	}
	else {
		mata: nsize = J(`nodes',1,100)
	}
	
	if ("`color'" != ""){
		capture mata: ncolor = st_data((1,`nodes'),st_varindex("`color'"))
		if _rc != 0 {
			di "{err}variable {bf:`color'} does not have enough obs. to be used with network {bf:`netname'}"
			error 6600
		}
	
		// labels of colors
		tempvar colornum 
		capture encode `color', gen(`colornum')
		// extracts labels when color = string
		if _rc == 0{
			local labelname: value label `colornum'
			qui tab `colornum', matrow(entries)
			mata: ncolor = st_data((1,`nodes'),st_varindex("`colornum'"))
		}
		// extracts labels when color = numeric
		else {
			local labelname: value label `color'
			qui tab `color', matrow(entries)	
		}
		local colorlabels ""
		
		forvalues l = 1/`r(r)'{
			local v = entries[`l',1]
			local onelab = "`v'"
			if "`labelname'" != "" {
				local onelab: label `labelname' `v'			
			}
			local colorlabels "`colorlabels' `onelab'"
		}	
	}
	else {
		mata: ncolor = J(`nodes',1,1)
	}
	
	if ("`label'" != ""){
		mata: nlabel = st_sdata((1,`nodes'),st_varindex("`label'"))
	}
	else {
		mata: nlabel = J(`nodes',1,"")
	}

	// Get network data
	nwtomata `netname', mat(plotmat)
	mata: M = (plotmat + plotmat') :/ (plotmat + plotmat')
	mata: _editmissing(M,0)
	
	// Get edgecolor network data
	if "`edgecolor'" != "" {
		nwtomata `edgecolor', mat(edgecolormat)
	}
	else {
		mata: edgecolormat = J(`nodes',`nodes',1)
	}
	
	// Obtain node coordinates
	if "`nodexy'" != "" {
		local layout = "nodexy"
		local nodex = word("`nodexy'", 1)
		local nodey = word("`nodexy'", 2)
		foreach nvar of varlist `nodex' `nodey' {
			qui sum `nvar'
			if (r(min) < 0 | r(max) > 1) {
				di "{err}Node coordinates not between 0 and 1. Option layout(mds) selected instead."
				local layout = "mds"		
			}
		}
	}
	local 0 `layout'
	local myopt `options'
	syntax anything, [columns(string)]
	local layout_gridcols "`columns'"
	local layout `anything'
	local options `myopt'
	if ("`layout'"!="nodexy"){
		di "{text:Calculating node coordinates...}"
	}
	if ("`layout'"=="mds"  ){
		mata: Coord = mmdslayout(M,200)
	}
	if ("`layout'"=="circle"){
		mata: Coord = circlelayout(rows(M))
	}
	if ("`layout'"=="grid"){
		if "`layout_gridcols'" == "" {
			local layout_gridcols = ceil(sqrt(`nodes'))
		}
		mata: Coord = gridlayout(rows(M), `layout_gridcols')
	}
	if ("`layout'"=="nodexy"){
		mata: Coord = J(rows(M),2,0)
		mata: Coord[.,1] = st_data((1,rows(M)),"`nodex'")
		mata: Coord[.,2] = st_data((1,rows(M)),"`nodey'")
	}
	
	// Obtain tie coordinates 
	mata: TC = getTieCoordinates(Coord,nsize,NumElist(plotmat), NumElist(edgecolormat), `nodefactor', `doarrows', `arrowgap')
	mata: st_numscalar("r(TC)", rows(TC))
	local minObs = max(`r(TC)', `nodes')

	// Prepare temporary Stata dataset for plotting
	preserve
	qui drop _all
	qui set obs `minObs'
	qui gen nx = .
	qui gen ny = .
	qui gen nsize = .
	qui gen ncolor = .
	qui mata: st_addvar("str20", "nlabel")
	qui gen sx = .
	qui gen sy = .
	qui gen ex = .
	qui gen ey = .
	qui gen value = .
	qui gen recip = .
	qui gen edgecolor = .
	
	mata: st_store((1::rows(TC)),("sx","sy","ex","ey","value","recip","edgecolor"),TC[.,.])

	qui gen straight =  1 - recip
	qui replace straight = 0 if `arcstyle' == 2
	qui replace straight = 1 if `arcstyle' == 3
	qui gen arrow = straight
	
	if (`arcstyle' != 3){
		di "{txt}Generating splines..."
		qui nwplotsplines, unbend(straight) arrow(arrow) x1(sx) y1(sy) x2(ex) y2(ey) bend(`arcbend') splines(`arcsplines')
	}
	
	mata: st_store((1::rows(Coord)),("nx","ny"), Coord[.,.])
	mata: st_store((1::rows(nsize)),("nsize"), nsize[.,.])
	mata: st_store((1::rows(ncolor)),("ncolor"), ncolor[.,.])
	mata: st_sstore((1::rows(nlabel)),("nlabel"), nlabel[.,.])

	local binfactor = 1/`sizebin'
	qui replace nsize = (ceil(nsize * `binfactor'))* `sizebin'
	qui tab nsize, matrow(nsizerow)
	qui sum nsize
	local sizemin = r(min)
	local sizemax = r(max)	
		
	qui egen nncolor = group(ncolor)
	qui sum nncolor
	local cols = r(max)
	
	// Prepare scatter commands to plot nodes
	tempvar ghost1
	tempvar ghost2
	qui gen `ghost1' = .
	qui gen `ghost2' = .
	local scattercmd ""
	local legendcmd ""
	qui tab nsize, matrow(nsizerow)

	
	local tempsize_rows = rowsof(nsizerow)
	forvalues tempsiz_mat = 1/`tempsize_rows'{
		local tempsiz = nsizerow[`tempsiz_mat',1] 
		// keep the size of keys in legend constant (create ghost plots for each color)
		forvalues tempcol = 1/`cols' {
			_getcolorstyle, i(`tempcol') colorpalette(`colorpalette') symbolpalette(`symbolpalette') scheme(`scheme')
			local tempcolstyle_fill = r(col_fill)
			local tempcolstyle_line = r(col_line)
			local tempsymbol = r(symbol)	
			local scattercmd "`scattercmd' || (scatter `ghost1' `ghost2' if `ghost1' !=., msymbol(`tempsymbol')  mlcolor(`tempcolstyle_line') mfcolor(`tempcolstyle_fill')  msize(2) `scatteropt') "            
		}
		// make actual plots	
		forvalues tempcol = 1/`cols' {
			_getcolorstyle, i(`tempcol') colorpalette(`colorpalette') symbolpalette(`symbolpalette') scheme(`scheme')
			local tempsiz_node = `tempsiz' * `nodefactor' * 2
			local tempcolstyle_fill = r(col_fill)
			local tempcolstyle_line = r(col_line)
			local tempsymbol = r(symbol)	
			if "`label'" != "" {
				local scatterlabel "mlabel(nlabel) mlabcolor(black)"
			}
			local scattercmd "`scattercmd' || (scatter ny nx if nncolor == `tempcol' & nsize == `tempsiz', msymbol(`tempsymbol') mlwidth(vthin) mlcolor(`tempcolstyle_line') mfcolor(`tempcolstyle_fill') msize(`tempsiz_node') `scatterlabel' `scatteropt')" 
		}
	}
	
	// Prepare pc command to plot arcs/edges
	local pccmd ""
	local pccmdforeground ""
	
	// No extra edgecolor treatment
	if "`edgecolor'" == "" {
		qui tab value, matrow(valuerow)
		local tempvalue_rows = rowsof(valuerow)
	
		forvalues tempval_mat = 1/`tempvalue_rows'{
			local tempval = valuerow[`tempval_mat',1]
			_getcolorstyle, i(`tempval') edgecolorpalette(`edgecolorpalette') edgepatternpalette(`edgepatternpalette') scheme(`scheme')
			local temppattern = r(edgepattern)
			local tempcolstyle = r(edgecol)
			local tempval_line = (`tempval' / 2) * `edgefactor' / 2
			local tempval_arrow = (`tempval' * 2) * `arrowfactor' 
			local tempval_barb = `tempval_arrow' * `barbfactor'
			local pccmd "`pccmd' (pcspike sy sx ey ex if value == `tempval', lpattern(`temppattern') lwidth(`tempval_line') lcolor(`tempcolstyle') mcolor(`tempcolstyle') msize(`tempval_arrow') barbsize(`tempval_barb') `lineopt') || (`pc' sy sx ey ex if value == `tempval' & arrow == 1, lpattern(`temppattern') lwidth(`tempval_line') lcolor(`tempcolstyle') mcolor(`tempcolstyle') msize(`tempval_arrow') barbsize(`tempval_barb') `lineopt') ||"
		
			if (strpos("`edgeforeground'", "`tempval'")!= 0){
				local pccmdforeground "`pccmdforeground' (pcspike sy sx ey ex if value == `tempval', lpattern(`temppattern') lwidth(`tempval_line') lcolor(`tempcolstyle') mcolor(`tempcolstyle') msize(`tempval_arrow') barbsize(`tempval_barb') `lineopt') || (`pc' sy sx ey ex if value == `tempval' & arrow ==1, lpattern(`temppattern') lwidth(`tempval_line') lcolor(`tempcolstyle') mcolor(`tempcolstyle') msize(`tempval_arrow') barbsize(`tempval_barb') `lineopt') ||"
			}
		}
	}
	
	save test.dta, replace
	
	// Edgecolors are given in another network
	if "`edgecolor'" != "" {
		qui tab value, matrow(valuerow)
		local tempvalue_rows = rowsof(valuerow)
		qui tab edgecolor, matrow(edgecolorrow)
		local tempecol_rows = rowsof(edgecolorrow)
		
		forvalues tempecol_mat = 1/`tempecol_rows'{
			local tempecol = edgecolorrow[`tempecol_mat',1]
			_getcolorstyle, i(`tempecol') edgecolorpalette(`edgecolorpalette') edgepatternpalette(`edgepatternpalette') scheme(`scheme')
			local temppattern = r(edgepattern)
			local tempcolstyle = r(edgecol)				
			forvalues tempval_mat = 1/`tempvalue_rows'{
				local tempval = valuerow[`tempval_mat',1]
				
				local tempval_line = (`tempval' / 2) * `edgefactor' / 2
				local tempval_arrow = (`tempval' * 2) * `arrowfactor' 
				local tempval_barb = `tempval_arrow' * `barbfactor'
				local pccmd "`pccmd' (pcspike sy sx ey ex if value == `tempval' & edgecolor == `tempecol', lpattern(`temppattern') lwidth(`tempval_line') lcolor(`tempcolstyle') mcolor(`tempcolstyle') msize(`tempval_arrow') barbsize(`tempval_barb') `lineopt') || (`pc' sy sx ey ex if value == `tempval' & edgecolor == `tempecol' & arrow == 1, lpattern(`temppattern') lwidth(`tempval_line') lcolor(`tempcolstyle') mcolor(`tempcolstyle') msize(`tempval_arrow') barbsize(`tempval_barb') `lineopt') ||"
			}
		}
	}

	// Finaliaze twoway command
	if (`cols' > 1){
		local legendcmd "legend(on "
		local legendordercmd ""
		forvalues n = 1/`cols'{
			if (`arcstyle' != 3) {
				local legendordercmd "`legendordercmd' `=`n'+3+`tempvalue_rows''"
			}
			else {
				local legendordercmd "`legendordercmd' `=`n'+3+`tempvalue_rows''"
			}
		}
		forvalues m = 1/`cols' {
			local legendlabel = word("`colorlabels'", `m')
			local legendcmd `"`legendcmd' label(`=`m'+3+`tempvalue_rows'' "`legendlabel'" ) "'
		}
		local legendcmd "`legendcmd' order(`legendordercmd'))"
		di `"`legendcmd'"'
	}
	local pmargin = `nodefactor' * 3
	// add to graphcmd `legendcmd' 
	local graphcmd `"twoway `pccmd' `scattercmd' `pccmdforeground',  plotregion(lcolor(white)) aspect(1) legend(off) ylabel(, nogrid) yscale(off range(0,100)) xscale(off range(0,100)) plotregion(margin(`pmargin' `pmargin' `pmargin' `pmargin')) `legendcmd' `options' `schemetwoway'"'

	//di "`graphcmd'"
	di "{text:Plotting network...}"
	`graphcmd'
	
	restore
	
	if "`generate'" != "" {
		di "{text:Export coordinates...}"
		capture drop `generate'_x
		capture drop `generate'_y
		if _N < `nodes' {
			set obs `nodes'
		}
		qui gen `generate'_x = .
		qui gen `generate'_y = .
		mata: st_store((1::rows(Coord)),("`generate'_x","`generate'_y"), (Coord[.,.]:/100))
		qui replace `generate'_x = (`generate'_x - 0.05) / 0.9
		qui replace `generate'_y = (`generate'_y - 0.05) / 0.9
	}
	mata: mata drop plotmat nsize ncolor nlabel Coord
end


capture program drop nwplotsplines
program nwplotsplines
	syntax, unbend(string) arrow(string) y1(string) x1(string) y2(string) x2(string) bend(string) splines(string) 

	tempvar l llid rad mult1 mult2 mult3 alpha beta x3n y3n x3 x4 y3 y4 xtemp ytemp r gamma delta lid alphaX
	gen `l' = sqrt((`x1' - `x2')^2 + (`y1' - `y2')^2)
	gen `rad' = `bend'* `l'

	gen `mult1' = 1 - 2 * (`x2' > `x1')
	replace `mult1' = 1 - 2 * (`y2' > `y1') if `x1' == `x2'
	gen `mult2' = 1 - 2 * (`y2' > `y1')
	replace `mult2' = 1 - 2 * (`x2' > `x1') if `y1' == `y2'

	gen `alpha' = (acos(abs(`x2' - `x1')/`l'))
	gen `beta' = _pi / 2 + `alpha'

	gen `x3n' = (`x1' + 1/2 * (`x2' - `x1')) 
	gen `x3' = `x3n' + `mult1' * cos(`beta') * `rad'
	gen `y3n' = (`y1' + 1/2 * (`y2' - `y1'))  
	gen `y3' = `y3n' + `mult2' * sin(`beta') * `rad'

	gen `r' = sqrt(`rad'^2 + (1/2*`l')^2)	
	gen `mult3' = 2 * (`x3' > `x1') - 1
	gen `gamma' =  `beta' + `mult3' * acos(`rad'/`r') 
	gen `delta' =  `beta' - `mult3' * acos(`rad'/`r') 
	
	gen `lid'  = _n
	expand `splines' if `unbend' !=1
	bys `lid': gen `llid' = _n
	gen `alphaX' = `delta' + (`gamma' - `delta') * (`llid' - 1)/(`splines' -1)
	gen `x4' = `x3' + `mult1'* cos(`alphaX' + _pi) * `r'
	gen `y4' = `y3' + `mult2'*sin(`alphaX' + _pi) * `r' 

	replace `x2' = `x4' if `unbend' != 1
	replace `y2' = `y4' if `unbend' != 1
	replace `x1' = `x4'[_n-1] if `unbend' != 1
	replace `y1' = `y4'[_n-1] if `unbend' != 1
	drop if `llid' == 1 & `unbend'!=1
	replace `arrow' = (`llid' == `splines') if (`arrow' != 1) & (`mult1' == 1)
	replace `arrow' = 1 if (`llid' == 2) & (`mult1' == - 1)
	
	gen `xtemp' = `x1'
	gen `ytemp' = `y1'
	replace `x1' = `x2' if (`llid' == 2) & (`mult1' == - 1)
	replace `y1' = `y2' if (`llid' == 2) & (`mult1' == - 1)
	replace `x2' = `xtemp' if (`llid' == 2) & (`mult1' == - 1)
	replace `y2' = `ytemp' if (`llid' == 2) & (`mult1' == - 1)
end


capture mata: mata drop getTieCoordinates()
mata:
real matrix function getTieCoordinates(
	real matrix Coord, real matrix size, real matrix List, real matrix EColList, real scalar sizefactor, real scalar doarrows, real scalar arrowgap)
{
	real matrix 	TC
	real scalar 	i, radius, x1, y1, x2, y2, x3, y3, An, Op, Hy, cos_theta, sin_theta
	
	radius = ((size:* 1.1):* sizefactor) :+ arrowgap
	Coord = Coord :*100
	Coord = (Coord :*0.9) :+ 5
	TC = J(rows(List),7,.)

	for(i=1;i<=rows(TC);i++){
		rad = radius[List[i,2],1] 
		if (doarrows==0) {
			rad = 0
		}
		TC[i,1] = Coord[List[i,1],1] //start x of tie i
		TC[i,2] = Coord[List[i,1],2] //start y of tie i
		TC[i,3] = Coord[List[i,2],1] //end x of tie i
		TC[i,4] = Coord[List[i,2],2] //end y of tie i
		TC[i,5] = List[i,3] //value of tie
		TC[i,6] = List[i,4]
		TC[i,7] = EColList[i,3]
		
		//adjust end point of arrow for node size
		x1 = TC[i,1]
		y1 = TC[i,2]
		x2 = TC[i,3]
		y2 = TC[i,4]
		An = y2 - y1
		Op = x2 - x1
		Hy = sqrt(An*An + Op*Op)
		cos_theta = Op / Hy
		sin_theta = An / Hy
		x3 = x2 - (cos_theta*rad)
		y3 = y2 - (sin_theta*rad)
		TC[i,3] = x3
		TC[i,4] = y3
	}
	return(TC)	
}	
end

capture mata: mata drop NumElist()
mata
real matrix NumElist(matrix onenet){
	nodes = rows(onenet)
	id = range(1,nodes,1)
	full = J(nodes, nodes, 1)
	c1=colshape(full:* id,1)
	c2=colshape(full:*(id'),1)
	value=colshape(onenet,1)
	c3 = value:/value
	_editmissing(c3,0)
	
	from = select(c1,c3)
	to = select(c2,c3)
	res = J(rows(from),4,0)
	res[.,1] = from
	res[.,2] = to
	res[.,3] = select(value, c3)
	
	for (i = 1; i <= rows(from); i++) {
		res[i,4] = onenet[res[i,1], res[i,2]] != 0 & onenet[res[i,2], res[i,1]] != 0
	} 
	return(res)
}
end

/*************************************
*	Obtain color for plotting
*************************************/
capture program drop _getcolorstyle
program def _getcolorstyle
	syntax [, i(string) colorpalette(string) symbolpalette(string) edgecolorpalette(string) edgepatternpalette(string) scheme(string)]

	mata: st_rclear()
	local i = `i' - 1

	if ("`edgecolorpalette'" == ""){
		// monochrome schemes
		if ("`scheme'" == "s2mono" | "`scheme'" == "s2manual" | "`scheme'" == "s2gmanual" | "`scheme'" == "s1mono" | "`scheme'" == "s1manual"  | "`scheme'" == "sj" ) {
			local edgecolorpalette = "black gs10 gs2 gs8"
		}
		else {
			local edgecolorpalette = "gs10 cyan eggshell red"
		}
	}

	if ("`colorpalette'" == "") {
		// monochrome schemes
		if ("`scheme'" == "s2mono" | "`scheme'" == "s2manual" | "`scheme'" == "s2gmanual" | "`scheme'" == "s1mono" | "`scheme'" == "s1manual"  | "`scheme'" == "sj" ) {
			local colorpalette = "gray black white gs8"
			local col_line = "black"
		}
		else {
			local colorpalette = "red green blue dkorange purple ltblue black magenta brown cyan eggshell sienna"
		}
	}

	if ("`symbolpalette'" == ""){
		// monochrome schemes
		if ("`scheme'" == "s2mono" | "`scheme'" == "s2manual" | "`scheme'" == "s2gmanual" | "`scheme'" == "s1mono" | "`scheme'" == "s1manual"  | "`scheme'" == "sj" ) {
			local symbolpalette = "O D T S"
		}
		else {
			local symbolpalette = "O"
		}
	}

	if ("`edgepatternpalette'" == ""){
		// monochrome schemes
		if ("`scheme'" == "s2mono" | "`scheme'" == "s2manual" | "`scheme'" == "s2gmanual" | "`scheme'" == "s1mono" | "`scheme'" == "s1manual"  | "`scheme'" == "sj" ) {
			local edgepatternpalette = "solid longdash_dot dot shortdash longdash"
		}
		else {
			local edgepatternpalette = "solid"
		}
	}

	// pattern of edge
	local edgepatternpalette_length : word count `edgepatternpalette'
	local m  = mod(`i', `edgepatternpalette_length') + 1
	local edgepattern : word `m' of `edgepatternpalette'
	
	// color of edge
	local edgecolorpalette_length : word count `edgecolorpalette'
	local l  = mod(`i', `edgecolorpalette_length') + 1
	local edgecol : word `l' of `edgecolorpalette' 
	
	// color of node
	local colorpalette_length : word count `colorpalette'
	local j  = mod(`i', `colorpalette_length') + 1
	local col_fill : word `j' of `colorpalette' 
	
	// not implemented yet...
	if "`col_line'" == "" {
		local col_line = "`col_fill'"
	}
	// symbol of node
	local symbolpalette_length : word count `symbolpalette'
	local k  = mod(`i', `symbolpalette_length') + 1
	local symbol : word `k' of `symbolpalette' 

	mata: st_global("r(edgepattern)", "`edgepattern'")
	mata: st_global("r(edgecol)", "`edgecol'")
	mata: st_global("r(col_fill)", "`col_fill'")
	mata: st_global("r(col_line)", "`col_line'")
	mata: st_global("r(symbol)", "`symbol'")
end


/*************************************
*	Network layouts functions (Mata)
*************************************/

// Attempt to implement spring embedder... but sth does not work yet :-(
capture mata: mata drop fruchtreinlayout()
mata:
real matrix function fruchtreinlayout(real matrix M, real scalar Iter)
{
	real matrix Pos, Pos_up
	real scalar W, L, area, V, temperature, k ,v_pos ,e1_pos, e2_pos, delta
	
	W = 1
	L = 1
	area = W * L
	V = rows(M)
	Pos = runiform(V,2)
	F_repulsion = J(V,2,0)
	F_attraction = J(V,2,0)
	
	temperature = 1/10 * W	
	k = sqrt(area/V)
	
	temperature = 0
	
	for(i=1;i<= Iter;i++){
		// calculate repulsive force
		for(v=1;v<=V;v++){
			v_disp = J(1,2,0)
			for(u=1;u<=V;u++){
				if (v!=u) {
					delta = Pos[v,.] - Pos[u,.]
					v_disp = v_disp + (delta :/ abs(delta)) :* ((J(1,2,1):*(k,k)) :/ abs(delta))  
				}
			}

			F_repulsion[v,.] = v_disp
		}

		Pos_up = F_repulsion
		// calculate attractive force
		for(e1=1;e1<=V;e1++){
			for(e2=1;e2<=V;e2++){
				if (M[e1,e2]!=0){		
					delta = Pos[e1,.] - Pos[e2,.]
					//delta
					e1_pos = Pos_up[e1,.] - (delta :/abs(delta)) :* ( (abs(delta):* abs(delta)):/ k)
					e2_pos = Pos_up[e2,.] + (delta :/abs(delta)) :* ( (abs(delta):* abs(delta)):/ k)		
					Pos_up[e1,.] = e1_pos
					Pos_up[e2,.] = e2_pos
				
				}
			}
		}
		// limit displacement
		for (v=1;v<=V;v++){
			delta = Pos_up[v,.] - Pos[v,.]	
			Pos[v,1] = Pos[v,1] + (delta[1,1] / abs(delta[1,1])) * min((abs(delta[1,1]), temperature))
			Pos[v,2] = Pos[v,2] + (delta[1,2] / abs(delta[1,2])) * min((abs(delta[1,2]), temperature))
			
			
			Pos[v,1] = min(( W, max((- W, Pos[v,1]))))
			Pos[v,2] = min(( L, max(( - L, Pos[v,2]))))
			
		}
		
		// reduce temperature linerarly
		temperature = temperature - (1 / 3)*temperature
	}
	return(Pos)
}
end

capture mata: mata drop mmdslayout()
mata:
real matrix function mmdslayout(real matrix G, real scalar MaxIt)
{
	real matrix 	D, sCoord, Coord
	string scalar 	dMat, sMat
	real scalar ScaleFactor, rc 
	
	Coord  =  J(rows(G),2,.)
	sCoord = jumble(circlelayout(rows(G))) //circle coordinates as starting positions for mds

	D = distance(G) //compute distances
	_diag(D,0)
	
	st_matrix(dMat=st_tempname(),D) 	    //Distance mat to stata under tempname
	st_matrix(sMat=st_tempname(),sCoord) 	//Distance mat to stata under tempname

	// compute MDS coordinates in stata
	/*rc = _stata(  "qui mdsmat " + 
		dMat + 
	    ", noplot method(modern) initialize(from(" + 
		sMat + 
		")) iterate("+strofreal(MaxIt)+")" )
 	*/
	// compute MDS coordinates in stata
	rc = _stata(  "qui mdsmat " + 
		dMat + 
		", noplot method(classical)")
		
	if (rc!=0) {
		errprintf("mds computation failed \n")
		exit(rc)
	}

	Coord = st_matrix("e(Y)") 	//pull coordinates back into mata
	
	// put isolates back on their circle coordinate
	
	ScaleFactor = max(abs(Coord))/50
	Coord[.,1] = (rowsum(G):==0):*((sCoord[.,1]:-50):*ScaleFactor) + (rowsum(G):!=0):*Coord[.,1]
	Coord[.,2] = (rowsum(G):==0):*((sCoord[.,2]:-50):*ScaleFactor) + (rowsum(G):!=0):*Coord[.,2]

	CoordMin1 = min(Coord[.,1])
	CoordMin2 = min(Coord[.,2])
	Coord[.,1] = (Coord[.,1] :- CoordMin1)
	Coord[.,2] = (Coord[.,2] :- CoordMin2)
	
	CoordMax1 = max(Coord[.,1])
	CoordMax2 = max(Coord[.,2])
	Coord[.,1] = (((Coord[.,1] :/ CoordMax1))) 
	Coord[.,2] = (((Coord[.,2] :/ CoordMax2)))
	
	return(Coord)
}
end

//Calculates the distance matrix in a discrete graph
//Distances between unconnecte nodes are indicated by "0"
capture mata: mata drop distance()
mata:
real matrix function distance(real matrix Net, | real scalar MaxDist)
{
	real scalar 	ready,counter, maxcounter
	real matrix 	N1,Dist,Ntemp
	
	if (args()==2) 
		maxcounter = MaxDist
	else 
		maxcounter = rows(Net)-1
	
	N1 = Net
	Dist = Net	//Distance 1 matrix
	counter = 1
	ready = 0
	while (ready==0 & counter<maxcounter) {
		counter = counter + 1
		N1=(N1*Net)
		Ntemp = (Dist:==0):*(N1:>0):*counter
		if (sum(Ntemp)==0) ready = 1
		Dist = Dist:+Ntemp
	}
	return(Dist)
}
end

capture mata: mata drop circlelayout()
mata:
real matrix function circlelayout(real scalar N)
{
	real colvector 	V
	real matrix 	Coord
	real scalar 	xmax, ymax

	xmax = 100
	ymax = 100
	V= (1::N)
	Coord=J(N,2,.)

	Coord[.,1] = 0.5*xmax :+ 0.5:*xmax:*cos(V[.]:*(2*pi()/N))	
	Coord[.,2] = 0.5*ymax :+ 0.5:*ymax:*sin(V[.]:*(2*pi()/N))

	CoordMax1 = max(Coord[.,1])
	CoordMax2 = max(Coord[.,2])
	Coord[.,1] = (((Coord[.,1] :/ CoordMax1)))
	Coord[.,2] = (((Coord[.,2] :/ CoordMax2)))
	return(Coord)
}
end

capture mata: mata drop gridlayout()
mata:
real matrix function gridlayout(real scalar N,  real scalar cols)
{
	real colvector 	V, C
	real matrix 	Coord

	V= (1::N) :- 1

	C = J(N,1,cols)	
		
	Coord=J(N,2,.)
	Coord[.,1] = mod(V,C):* (100 / cols)
	Coord[.,2] = floor( (V:/C)):* (100 / cols)
	
	CoordMax1 = max(Coord[.,1])
	CoordMax2 = max(Coord[.,2])
	Coord[.,1] = (((Coord[.,1] :/ CoordMax1)))
	Coord[.,2] = J(N,1,1) :- (((Coord[.,2] :/ CoordMax2)))
	return(Coord)
}
end

