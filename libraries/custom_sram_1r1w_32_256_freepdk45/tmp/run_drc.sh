#!/bin/sh
source /home/klenn/Desktop/Digital_Design/OpenRAM/miniconda/bin/activate
/home/klenn/Desktop/Digital_Design/OpenRAM/miniconda/bin/klayout -b -r freepdk45.lydrc -rd input=custom_sram_1r1w_32_256_freepdk45.gds -rd topcell=custom_sram_1r1w_32_256_freepdk45 -rd output=custom_sram_1r1w_32_256_freepdk45.drc.report
conda deactivate
