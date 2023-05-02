transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/github/RISC_pipeline/VHDL_Implementation/Register_4bit.vhd}
vcom -93 -work work {D:/github/RISC_pipeline/VHDL_Implementation/ID_adder.vhd}
vcom -93 -work work {D:/github/RISC_pipeline/VHDL_Implementation/SE10.vhd}
vcom -93 -work work {D:/github/RISC_pipeline/VHDL_Implementation/SE7.vhd}
vcom -93 -work work {D:/github/RISC_pipeline/VHDL_Implementation/Instr_decode.vhd}

