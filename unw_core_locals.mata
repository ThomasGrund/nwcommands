/* -------------------------------------------------------------------- */
//!! require a Stata version change before release
version 14

set matastrict on
	
local NWVersion	1

/* -------------------------------------------------------------------- */
					/* Shorthands for types		*/
local RS	real scalar
local RR	real rowvector
local RC	real colvector
local RM	real matrix

local SS	string scalar
local SR	string rowvector
local SC	string colvector
local SM	string matrix
local BOOL	real scalar

/* -------------------------------------------------------------------- */
					/* Derived types 		*/
local 	True	1
local 	False	0

//!! more derived types

/* -------------------------------------------------------------------- */
					/* Derived type:  version1 	*/
local 	v1NWs		__v1nws_cls
local 	v1NWsdef	__v1nws_clsdef		// class definition
//!! for datasig ??
local 	v1NWsder	__v1nws_clsder		
local 	v1NWdef		__v1nw_clsdef		// single network definition

local 	NWs		`v1NWs'
local 	NWsdef		`v1NWsdef'
local 	NWsder		`v1NWsder'
local 	NWdef		`v1NWddef'

/* -------------------------------------------------------------------- */
					/* constants			*/
local 	cDftNWpef	"network_"	//default network name pefix
local 	cDftNodepef	"net"		//default node name prefix

/* -------------------------------------------------------------------- */
					/* Error codes			*/
local 	errNWsCrete	480		
local 	errNodeDupName	481	
