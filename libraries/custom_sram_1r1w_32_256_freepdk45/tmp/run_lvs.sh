#!/bin/sh
source /home/klenn/Desktop/Digital_Design/OpenRAM/miniconda/bin/activate
/home/klenn/Desktop/Digital_Design/OpenRAM/miniconda/bin/klayout -b -r freepdk45.lylvs -rd input=custom_sram_1r1w_32_256_freepdk45.gds -rd report=custom_sram_1r1w_32_256_freepdk45.lvs.report -rd schematic=custom_sram_1r1w_32_256_freepdk45.sp -rd target_netlist=custom_sram_1r1w_32_256_freepdk45.spice -rd connect_supplies=1
conda deactivate
