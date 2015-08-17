capture program drop nwconstraint
program nwconstraint
	syntax [anything(name=netname)] [, *]
	_nwsyntax `netname'
	
	nwtomata `netname', mat(onenet)
	mata: c = constraint(onenet)
	nwset, mat(c) `options'
	capture mata: mata drop onenet 
	capture mata: mata drop c
end

capture mata mata drop constraint()
mata: 
real matrix constraint(real matrix net)
{
	p = net :/ rowsum(net)
	_editmissing(p,0)
	p2 = p * p
	_diag(p2, 0)
	return((p + p2):*(p + p2))
}
end

