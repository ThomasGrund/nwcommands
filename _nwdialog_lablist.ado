capture program drop _nwdialog_lablist
program _nwdialog_lablist
	tokenize `0'
	local dialogname `1'
	local onenet `2'
	set more off
    nwname `onenet'
	local lablist "`r(labs)'"
	
	capture {
		/* dynamic_list_control is a helper class
		 * for managing dynamic list conrols.
		 */
		.dlist = .dynamic_list_control.new , dialogname(nwpath) controlname(main.cb_egolab)
		.dlist.setList, newlist(`lablist')
	}
	capture {
		/* dynamic_list_control is a helper class
		 * for managing dynamic list conrols.
		 */
		.dlist = .dynamic_list_control.new , dialogname(nwpath) controlname(main.cb_alterlab)
		.dlist.setList, newlist(`lablist')
	}
	capture classutil drop .dlist
end
