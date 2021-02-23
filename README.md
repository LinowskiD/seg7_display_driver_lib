# seg7_display_driver_lib
Seven segment display driver. Multiple digit, with scanning controller. Written in VHDL, project organized in VUnit.\
Project mostly considered as a VUnit playgroud.\
Generics: number if digits, scanning frequency (range TBD)\
Input: integers in range 0 to 15.\
Output: 7 signals for one digit, each for one display segment, collected in a single record; digit selection.\
Requires:
* Modelsim simulator installed
* Modelsim.ini file visible in PATH
* Modelsim win32acoem folder added to PATH
* VUnit installed
* Python 3.* installed

# Module level description

## Global requirements

* REQ_SEG_0010: System clock value shall be passed as a generic to the module, so that it can be used in the internal calculations.
* REQ_SEG_0020: Reset shall be asynchronous. During reset all registers shall be filled with zeroes.

TODO:
* Code documentation available from github (Read the Docs?)
* GHDL support