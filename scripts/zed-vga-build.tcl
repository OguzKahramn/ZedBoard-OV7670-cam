# build settings
set design_name "zed-vga"
set arch "xc7"
set board_name "ZedBoard"
set fpga_part "xc7z020clg484-1"

# set reference directories for source files

set origin_dir [file normalize "."]
set ip_dir [file normalize "./../../../../lib"]

# read design sources
read_verilog -sv "${lib_dir}/clock/xc7/clock_480p.sv"
read_verilog -sv "${lib_dir}/essential/debounce.sv"
read_verilog -sv "${origin_dir}/${arch}/top_${design_name}.sv"
read_verilog -sv "${origin_dir}/simple_480p.sv"
read_verilog -sv "${origin_dir}/simple_score.sv"

# read constraints
read_xdc "${origin_dir}/constraints/vga_test.xdc"

# synth
synth_design -top "top_${design_name}" -part ${fpga_part}

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "${origin_dir}/${arch}/${design_name}.bit"