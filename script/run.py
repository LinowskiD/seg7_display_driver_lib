from vunit import VUnit, VUnitCLI
from pathlib import Path
import sys
import os

# os.environ['VUNIT_SIMULATOR'] = 'ghdl'
# os.environ['VUNIT_SIMULATOR'] = 'modelsim'
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
# sys.argv.append("-o")
# sys.argv.append(f"{ROOT / WORK}")
# Add custom command line argument to standard CLI
# Beware of conflicts with existing arguments
cli = VUnitCLI()
# cli.parser.set_defaults(no_color=True)
cli.parser.set_defaults(output_path=f"{ROOT / WORK}")
# cli.parser.add_argument('-s', '--style', action='store_true', help='Check VHDL code style according to rules in code_style_conf.yaml') # TBD
args = cli.parse_args()
# Create VUnit instance by parsing command line arguments (including custom)
# vu = VUnit.from_argv()
vu = VUnit.from_args(args=args)
#print(args.style)
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
