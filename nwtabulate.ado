capture program drop nwtabulate
program nwtabulate
	syntax [anything(name=something)] [, *]
	nwtab `something', `options'
end
