capture program drop nwsimmelian
program nwsimmelian
	syntax [anything(name=netname)] [, name(string)]
	_nwsyntax `netname'
	
	if "`name'" == "" {
		local name "_simmelian"
	}
	nwtomata `netname', mat(onenet)
	
	mata: dich = (onenet :!= 0)
	mata: mutual = ((dich :!= 0) :* (dich' :!= 0))
	mata: simmel = (mutual) :* (mutual * mutual)
	mata: simmel = (simmel :!= 0)
	nwset, mat(simmel) name(`name') undirected
	capture mata: mata drop dich mutual simmel
end
