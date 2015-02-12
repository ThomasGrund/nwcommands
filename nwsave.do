capture window fsave NETFILE "Save network data" "Stata network file|*.dta"
if _rc == 0 {
	nwsave $NETFILE
}
