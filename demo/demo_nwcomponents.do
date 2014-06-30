// Load any data in edgelist format 
use glasgow_edge

// Set network using three variables (fromid, toid, value)
// Also works without value variable. In this case, it creates one 
// new tie for each combination of fromid, toid
nwfromedge _fromid _toid _glasgow3

// To load a network as undirected use option: , undirected

// Check if data has been nw-setted correctly
nwset

// Calculate number of components
nwcomponents

// Check number of components
return list

// Plot network with components colored differently.
nwplot, color(_component) legend(off)

nwplot, color(_component) layout(circle) legend(off)
