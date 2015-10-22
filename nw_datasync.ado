capture program drop nw_datasync
program nw_datasync
	syntax [anything(name=netname)]
	unw_defs
	nw_syntax `netname'

	mata: `netobj'->data_sync()
end



