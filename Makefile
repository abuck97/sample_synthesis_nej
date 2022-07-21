run_dc:
	dc_shell-t -64 -f script/run_dc.tcl -output_log_file dc_shell_log.txt
clean:
	@rm -f work/*.syn
	@rm -f work/*.pvl
	@rm -f work/*.mr
	@rm -f command.log filenames.log
	@rm -f results/*.v
	@rm -f results/*.sdc
	@rm -f results/*.ddc
	@rm -f results/*.svf
	@rm -f dc_shell_log.txt
	@rm -f rpts/*.rpt
