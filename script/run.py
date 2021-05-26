from vunit import VUnit
from pathlib import Path
import sys
import os

# os.environ['VUNIT_SIMULATOR'] = 'ghdl'
# ROOT
ROOT = Path(__file__).resolve().parents[1]
# WORK
WORK = "work"
# Sources path for DUT
DUT_PATH = ROOT / "hdl"
# Sources path for TB
TEST_PATH = ROOT / "hdl_tb"
# MODULE_NAME
MODULE_NAME = "seg7_display_driver"
# Append arguments to VUnit call
sys.argv.append("-o")
sys.argv.append(f"{ROOT / WORK}")
# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()
vu.enable_location_preprocessing()
# Add OSVVM
# vu.add_osvvm()
# Create design library
module_lib = vu.add_library(f"{MODULE_NAME}_lib")
# Add design source files to module_lib
module_lib.add_source_files([DUT_PATH / "*.vhd"], vhdl_standard="2008")
# Create testbench library
tb_lib = vu.add_library(f"{MODULE_NAME}_tb_lib")
# Add testbench source files to tb_lib
tb_lib.add_source_files([TEST_PATH / "*.vhd"], vhdl_standard="2008")
# Run vunit function
vu.main()
