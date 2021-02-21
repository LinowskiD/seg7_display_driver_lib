from vunit import VUnit
from pathlib import Path
import sys

module_name = "seg7_display_driver"
src_path = Path(__file__).parent/ "../"

sys.argv.append("-o")
sys.argv.append("{}/work/".format(src_path))

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()
# vu.add_osvvm()

vu.add_library(f"{module_name}_lib").add_source_files(src_path / "hdl" / "*.vhd", vhdl_standard="2008")
vu.add_library(f"{module_name}_tb_lib").add_source_files(src_path / "hdl_tb" / "*.vhd", vhdl_standard="2008")

# Run vunit function
vu.main()