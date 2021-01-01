# design setup (change library files according to your technology)
set link_library /home/abdelazeem/Desktop/synopsys/uk65lscllmvbbr_120c25_tc.db
set target_library /home/abdelazeem/Desktop/synopsys/uk65lscllmvbbr_120c25_tc.db

#analyze
analyze -format verilog {/home/abdelazeem/Desktop/synopsys/pfd_loopF.v}

#elaborate (pfd_loopF is the name of the top level module)
elaborate pfd_loopF -architecture verilog -library DEFAULT -update
write -hierarchy -format ddc -output /home/abdelazeem/Desktop/synopsys/pfd_loopF.ddc

#timing & area constraints (refSignal is the clock name in my verilog file-edit according to your design (ns))
create_clock -name "clk" -period 10 -waveform { 0 5  }  { refSignal  }
set_max_area 0

#compile design
compile

#export design (reports and netlist and timing files)
write -hierarchy -format ddc -output /home/eslam/Desktop/synopsys/pfd_loopF_mapped.ddc

report_constraint -nosplit -all_violators > /home/abdelazeem/Desktop/synopsys/allviol.rpt
report_area > /home/abdelazeem/Desktop/synopsys/area.rpt
report_timing > /home/abdelazeem/Desktop/synopsys/timing.rpt
report_resources -nosplit -hierarchy > /home/abdelazeem/Desktop/synopsys/resources.rpt
report_reference -nosplit -hierarchy > /home/abdelazeem/Desktop/synopsys/references.rpt
report_hierarchy > hierarchy.rpt
report_design > design.rpt

change_names -rules verilog -hierarchy -verbose
write -hierarchy -format verilog -output /home/abdelazeem/Desktop/synopsys/pfd_loopF_mapped.v
write_sdf -version 2.1 pfd_loopF_vlog.sdf
write_sdc -nosplit pfd_loopF_vlog.sdc
puts "Finished"
