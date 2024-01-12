# build settings
set user_name [exec whoami]
set project_dir "/home/${user_name}"
set design_name "zed-vga"
set fpga_part "xc7z020clg484-1"

# set reference directories for source files

set origin_dir [file normalize "./"]
set source_dir "${origin_dir}/hdl/"
set ip_dir  "${origin_dir}/ips"
set constraint_dir "${origin_dir}/constraints"

create_project ${design_name} ${project_dir}/${design_name} -part ${fpga_part} -force
puts "${design_name} project has been created for part ${fpga_part}"

import_files ${source_dir} -force
puts "${source_dir} files have been added.."

import_ip ${ip_dir}/vga_clk_wiz_0.xci 
puts "${ip_dir} files have been added.."

synth_ip [get_ips vga_clk_wiz_0] -force

generate_target changelog [get_ips] -force

# read constraints
read_xdc "${constraint_dir}/vga_test.xdc" 
puts "xdc files have been added.."
# synth
synth_design -top ZED_VGA_TOP -part ${fpga_part}

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "${project_dir}/${design_name}/${design_name}.bit"