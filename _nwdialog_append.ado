capture program drop _nwdialog_append
program _nwdialog_append
	syntax anything(name=dialogname)
    qui nwset
	local netlist = "`r(names)'"
	local netlist_rev ""
	local c : word count `netlist'
	forvalues i = 1 / `c' {
		local z = `c' - `i' + 1
		local next : word `z' of `netlist'
		local netlist_rev "`netlist_rev' `next'" 
	}

	.`dialogname'_dlg.netlist_append.Arrpush "main.cb_net.smartinsert"
	foreach onenet of local netlist {
		.`dialogname'_dlg.netlist_append.Arrpush "main.ed_net.smartinsert `onenet'"
	}

end
