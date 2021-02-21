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

## counter_lib

* REQ_SEG_0110: Counter module shall use provided value as a preload value for the counter.
* REQ_SEG_0111: Counter module shall count down from preloaded value to 0.
* REQ_SEG_0112: Counter module shall indicate that 0 value has been reached by the counter. It shall be indicated by 1 clock cycle.
* REQ_SEG_0113: Counter module shall start counting again from a preloaded value when 0 value has been reached by the counter.
* REQ_SEG_0120: Counter module shall be enabled and disabled by a dedicated signal.
* REQ_SEG_0124: Counter module shall count only when it is enabled.
* REQ_SEG_0122: Counter module shall update internal preload value only when the rising edge of the enable signal has been detected.
* REQ_SEG_0123: Counter module shall continue counting from the last value after it has been re-enabled.
* REQ_SEG_0130: Counter module shall be reset by a dedicated signal. 
* REQ_SEG_0131: Counter module shall stop counting and reset counter value after reset signal has been detected.

TODO:
* Code documentation available from github (Read the Docs?)
* GHDL support