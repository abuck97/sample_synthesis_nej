# OPTIONAL : supress certain warnings that are almost always spurious
#suppress_message LINT-32
#suppress_message VER-314 
#suppress_message VER-944 
#suppress_message OPT-314

# ============ CHANGE HERE ===========
# Add any paths you want for DC Shell to search for filepaths without absolute paths
# To use GF12, uncomment the following line
#set search_path "./src . /CMC/kits/gf12_libs/Synopsys/Invecas/IN12LP_SC9T_84CPP_BASE_SSC14R_FDK_RELV00R20/model/timing/ccs_db" 

#If using TSMC 65nm, uncomment the following line and comment the above line
set search_path "../src/dsp/ ../src . /CMC/kits/tsmc_65nm_libs/tcbn65gplus/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65gplus_140b"

# Database files containing all of the cell information need to synthesize
# If using GF12, uncomment the following lines and comment the lines below.
#set link_library "IN14LPP_SC9T_84CPP_BASE_SSC14R_TT_0P80V_25C_ccs.db"
#set target_library "IN14LPP_SC9T_84CPP_BASE_SSC14R_TT_0P80V_25C_ccs.db"

#If using TSMC 65nm, uncomment the following lines and comment the above lines:
set link_library "tcbn65gpluswc.db"
set target_library "tcbn65gpluswc.db"
set verilog_files [list multiplier.v full_adder.v]
# ============ END CHANGE ============

set symbol_library ""

define_design_lib work -path "./work"

# ============ CHANGE HERE ===========
# Set to your actual top_level_module
set top_level_module multiplier
# Add all your verilog files in the list here
set verilog_files [list multiplier.v full_adder.v]
# ============ END CHANGE ============

# delete prev run files
file mkdir "results"
file mkdir "rpts"
file mkdir "work"

# read in all Verilog source files
analyze -f verilog $verilog_files
elaborate $top_level_module
current_design $top_level_module

# Constraints
# ============ CHANGE HERE ===========
# You'll need to put your actual clock here. You can also remove
# the false paths and set_case_analysis if you don't need them.
#if using TSMC 65, then units are in ns. For GF12, it's in ps.
create_clock -name clk -period 1 clk

# ============ END CHANGE ============

compile -map_effort high -area_effort high
check_design

set_svf ./results/${top_level_module}_syn.svf

# OPTIONAL : report PPA metrics more thoroughly 
report_timing > ./rpts/syn_timing.rpt
report_area > ./rpts/syn_area.rpt
report_power > ./rpts/syn_power.rpt

# change names so that they are legal for Innovus stage
change_names -hier -rule verilog

# write 
write_file -format verilog -hierarchy -output "./results/${top_level_module}_syn.v"
write_sdc "./results/${top_level_module}_syn.sdc"
write_file -format ddc -output "./results/${top_level_module}_syn.ddc"
