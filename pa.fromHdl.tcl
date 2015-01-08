
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name atlys-playing -dir "/media/psf/Home/Develop/atlys-playing/planAhead_run_4" -part xc6slx45csg324-2
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "program.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {program.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top program $srcset
add_files [list {program.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx45csg324-2
