set project_name "MAC" 

set project_found [llength [get_projects $project_name]] 
if {$project_found > 0} { 
    close_project 
}

set origin_dir [file dirname [info script]] 
cd $origin_dir 

create_project $project_name "$origin_dir/$project_name" -force 

add_files -norecurse MAC.vhd
add_files -norecurse Multiplier.vhd
add_files -norecurse MAC_Controller.vhd
add_files -norecurse Accumulate.vhd
add_files -norecurse MAC_tb.vhd

# uvm
# set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
# set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]

set_property top MAC_tb [get_filesets sim_1] ; 
launch_simulation 


