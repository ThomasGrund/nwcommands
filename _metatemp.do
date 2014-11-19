*! Date      :9999
*! Version   :0.0.0
*! Author    :
*! Email     :

capture program drop nwbetween
program nwbetween
	syntax [anything(name=netname)], [GENerate(string) sym]
	_nwsyntax , max(9999)
	if  > 1 {
		local k = 1
	}
	
	foreach netname_temp in  {
		nwtomata , mat(betweennet)
		if  !=  {
			mata: betweennet = betweennet :+ betweennet'
		}
	
		mata: betweennet = betweennet :/ betweennet
		mata: _editmissing(betweennet, 0)
	
		mata: C = between(betweennet)
		if  !=   {
			mata: C = C:/2
		}
	
	
		if  ==  {
			local generate 