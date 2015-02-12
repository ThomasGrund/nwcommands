capture window fopen NETFILE "Open network data" "Stata network file|*.dta"
if _rc == 0 {
	set more off
	noi nwuse $NETFILE
}
