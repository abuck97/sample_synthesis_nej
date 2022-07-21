# Synthesis Example (for GF12 and TSMC65)

## Steps taken for basic setup (CAD and tech nodes): 

1. You need a CMC account from cmc.ca 

2. Have your supervisor approve the request 

3. For GF12 and GF22 nodes, you need to sign an NDA and request permission from ecehelp 

    1. NDA signed by yourself and supervisor: http://www.vrg.utoronto.ca/UofT_Access_Only/FORMS_200407/CMC_GF_UofT_CIIP.pdf 

    2. Return it to ecehelp@ece.utoronto.ca 

    3. For TSMC65 nodes, this is the NDA form: http://www.vrg.utoronto.ca/UofT_Access_Only/FORMS_200407/UofT_MOSIS_TSMC65NM_CIIP.pdf 

    4. Only request access to the nodes that you are actually planning on using 

4. SSH into anubis@eecg.utoronto.ca 

    1. There's more info about the ece machines here: https://wiki.ece.utoronto.ca/doku.php/userdoc:find_nw_info 

5. Once logged in, you can check you have the proper access by running the `groups` command and seeing whether you're part of "cmcgfut" 

6. Before running design compiler, you'll need to run `source /CMC/tools/CSHRCs/Synopsys.2017.09`. This needs to be done each time you login again. You can put it into your .cshrc or create an alias for it to make it easier 

7. Ensure you can run design compiler by running `dc_shell-t -64`. If it opens up, yay. Otherwise, it's time to debug. For help, you can check here: https://wiki.ece.utoronto.ca/doku.php/userdoc:licensed_software and/or email ecehelp@ece.utoronto.ca 

8. Close dc_shell by running "exit" or hitting "ctrl-c" three times in a row 

 

# Steps for synthesizing GF12 nm 

1. Get the following git repo: https://github.com/abuck97/sample_synthesis 

    1. Contact Alex Buck (alexander.buck@mail.utoronto.ca or abuck97@gmail.com) if you need permission  

2. The .synopsys_dc.setup file seems to be run in synopsys when you start it. We've set the library paths here. It would probably be a good idea to move this into a proper script that just gets sourced so it's easier to find 

3. To synthesize the design in GF12nm, just run "make run_dc" 

4. To synthesize in TSMC 65 nm, you'll need to edit the `scripts/run_dc.tcl` file to point to the correct libraries. See the comments within the file to see what needs to be changed

5. Reports are in the "rpts" folder. Netlists are in the "results" folder. 

 

## Some notes:  

In GF12, within this tech node, there are quite a few different process options. See `/CMC/kits/gf12_libs/Synopsys/Invecas/`. You can either have 14nm or 16nm gates. And Super low (SL), low (L), regular (R), and high (H) voltage thresholds. I chose 14nm with R VT. 

For the tech library, there seem to be two options that I'm not sure the difference between. At `/CMC/kits/gf12_libs/Synopsys/Invecas/IN12LP_SC9T_84CPP_BASE_SSC14R_FDK_RELV00R20/model/timing`, I can find .db files in both the "ccs_lib" and "lib" directories. I chose ccs_lib because another script referenced using ccs once, but not sure of the actual difference. 

When doing report_power, you want to make sure the clock is at the actual FMax rather than some ridiculously high number. Otherwise your dynamic power will be higher than actual 


## Overview of files
### makefile
Simple makefile that shows how to run a script through DC Shell. 

Usage:
make run_dc # runs DC shell with script file; output is dumped to dc_shell_log.txt
make clean  # cleanup leftover files from prior run 


### Script File (./scripts/run_dc.tcl)
This file runs all of the DC Shell TCL commands needed to build the DSP block
example module. It is passed as an arg to DC shell by the makefile target
"run_dc".
