sim_tb:
	xvlog decrypt_rc4.sv tb_codebreaker.sv codebreaker.sv -sv --nolog
	xelab tb_codebreaker -debug typical --nolog
	xsim tb_codebreaker -log sim_tb_codebreaker.log --runall

gui:
	xvlog decrypt_rc4.sv -sv --nolog
	xelab decrypt_rc4 -debug typical --nolog
	xsim decrypt_rc4 -gui

gui_tb:
	xvlog decrypt_rc4.sv tb_codebreaker.sv codebreaker.sv -sv --nolog
	xelab tb_codebreaker -debug typical --nolog
	xsim tb_codebreaker -gui

sim_top:
	xvlog decrypt_rc4.sv codebreaker_top.sv codebreaker.sv write_vga.sv ../lab12/font_rom.sv ../lab12/charGen.sv ../lab07/seven_segment4.sv ../lab08/vga_timing.sv ../lab11/rx.sv -sv ../lab09/debounce.sv --nolog
	xelab --debug typical codebreaker_top --generic_top "WAIT_TIME_US=50" --generic_top "FILENAME=background.mem" --nolog
	xsim codebreaker_top -gui

background.mem:
	python3 ../lab12/gen_initial_chars.py background.txt background.mem

synth:
	vivado -mode batch -source synth_codebreaker.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace
	
clean:
	rm -f *.log *.dcp *.bit *.rpt *.jou *.str *.wdb *.pb *.nfs clockInfo.txt
	rm -rf .Xil xsim.dir *.mem