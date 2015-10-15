cscript

clear mata
do unw_core.mata

// create a network with 5 nodes
mata:
nw = nws_create()
nw.nwsdef.create(2)
nw.nwsdef.pdefs[1]->create(5)
nw.nwsdef.dumper()
// connect node 2 with node 1 3
nw.nwsdef.pdefs[1]->connect_edge(2, (3, 1))
nw.nwsdef.dumper()

nw.nwsdef.pdefs[2]->create_by_name(("bill", "alan", "vince", "yulia"))
nw.nwsdef.dumper()
// connect node 1 with node 2 3 4
nw.nwsdef.pdefs[2]->connect_edge(1, (2, 3, 4))
nw.nwsdef.pdefs[2]->add_node("tomas")
nw.nwsdef.pdefs[2]->connect_edge(2, (5))
nw.nwsdef.dumper()

nw.nwsdef.add("test")
nw.nwsdef.dumper()

end

di "all is well"
