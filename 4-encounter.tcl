# Importing the Design 
loadConfig Default.conf  
setDrawView fplan
fit
saveDesign pfd_loopF-import.enc 

#Floorplanning the Design 
floorPlan -r 1 0.7 2 2 2 2
saveDesign pfd_loopF-fplan.enc 

#Power Planning 
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -module {} -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -module {} -verbose
addRing \
-around core \
-nets {VSS VDD} \
-center 1 \
-width_bottom 0.2 -width_right 0.2 -width_top 0.2 -width_left 0.2 \
-spacing_bottom 0.5 -spacing_right 0.5 -spacing_top 0.5 -spacing_left 0.5 \
-layer_bottom ME1 -layer_right ME2 -layer_top ME1 -layer_left ME2 \
-bl 1 -br 1 -rb 0 -rt 0 -tr 0 -tl 0 -lt 1 -lb 1
#placing well taps
addWellTap -cell WT3R -maxGap 30 -skipRow 1 -startRowNum 2 -prefix WELLTAP
#special route
sroute \
-connect { blockPin corePin floatingStripe } \
-blockPin { onBoundary bottomBoundary rightBoundary } \
-allowJogging 1
saveDesign pfd_loopF.enc

#Placing the standard cells 
setPlaceMode -timingDriven true
placeDesign -prePlaceOpt
setDrawView place
checkPlace 
optDesign -preCTS -outDir /home/eslam/Desktop/encounter
saveDesign pfd_loopF-placed.enc


#Synthesizing a Clock Tree
createClockTreeSpec -output pfd_loopF_spec.cts \
-bufferList CKBUFM12R CKBUFM16R CKBUFM1R CKBUFM20R CKBUFM22RA CKBUFM24R CKBUFM26RA CKBUFM2R CKBUFM32R CKBUFM3R CKBUFM40R \
	    CKBUFM48R CKBUFM4R CKBUFM6R CKBUFM8R CKINVM12R CKINVM16R CKINVM1R CKINVM20R CKINVM22RA CKINVM24R CKINVM26RA \
	    CKINVM2R CKINVM32R CKINVM3R CKINVM40R CKINVM48R CKINVM4R CKINVM6R CKINVM8R
clockDesign -specFile pfd_loopF_spec.cts \
            -outDir /home/eslam/Desktop/encounter
optDesign -postCTS -outDir /home/eslam/Desktop/encounter
saveDesign pfd_loopF-cts.enc

#Routing the Design
setNanoRouteMode -routeWithTimingDriven true -routeTdrEffort 5
routeDesign 
optDesign -postRoute -outDir /home/eslam/Desktop/encounter
saveDesign pfd_loopF-routed.enc


#Design Finishing 
addFiller \
   -cell { FIL16R FIL1R FIL2R FIL32R FIL4R FIL64R FIL8R FILE16R FILE32R FILE3R FILE4R FILE64R FILE6R \
	FILE8R FILEP16R FILEP32R FILEP64R FILEP8 } \
   -prefix FIL
setDrawView place
saveDesign pfd_loopF-filled.enc 	

#Checking the Design 
verifyConnectivity -type all -report connectivity.rpt
verifyGeometry -report geometry.rpt

#Generating Reports 
reportNetStat
reportGateCount -outfile gateCount.rpt
summaryReport -outdir /home/eslam/Desktop/encounter

#Design Export 
write_sdf -version 2.1 -precision 4 pfd_loopF_pared.sdf
saveNetlist -excludeLeafCell pfd_loopF_pared.v

streamOut pfd_loopF_pared.gds \
-mapFile streamOut_me_pinOnly.map \
-libName pfd_loopF_pared \
-merge uk65lscllmvbbr.gds


