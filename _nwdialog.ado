capture program drop _nwdialog
program _nwdialog
	syntax anything(name=dialogname)
    qui nwset
	local netlist = "`r(names)'"
	if "`netlist'" != "" {
		.`dialogname'_dlg.netlist.Arrdropall
	}
	.`dialogname'_dlg.netlist.Arrpush " "
	foreach onenet of local netlist {
		.`dialogname'_dlg.netlist.Arrpush "`onenet'"
	}
end


capture program drop _nwdialog_append
program _nwdialog_append
	gettoken dlg_element 0 : 0 
	.`dlg_element'.append `0'
	.`dlg_element'.append " "
end
