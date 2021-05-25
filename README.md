[![](https://github.com/LinowskiD/seg7_display_driver_lib/workflows/VUnit%20Tests/badge.svg)](https://github.com/LinowskiD/seg7_display_driver_lib/actions)
# seg7_display_driver_lib
Seven segment display driver with multiple digit support.  
Written in VHDL, project organized and verified with VUnit.  
Project mostly considered as a VUnit playgroud for now. In the future it is expected to be a part of a much larger system inside actual FPGA.  

## Features:
* Handles displays consisting up to 4 digits (TBD) by providing 4 (TBD) signals to control anode/cathode switching.
* Allows to display different value on each digit.
* Allows to display hexadecimal value between 0x0 and 0xF - provided as a Binary Coded Decimal (BCD).
* Digits are being lit one at a time.
* Configurable digit "light" and "dim" state time when switching multiple digits. (lit D1 -> dim D1 -> lit D2 -> dim D2 -> lit D1 -> ...)
* Hardware independent by design - provides only control logic.

## Project requirements for simulation
* Modelsim simulator installed
* Modelsim.ini file visible in the PATH
* Modelsim win32acoem folder added to the PATH
* VUnit installed
* Python 3.* installed

## FPGA implementation considerations
It is expected to provide physical translation layer on the higher level when used to interface with actual hardware (common anode/cathode display, way of multiplexing between digits).

## General architecture
                         +---------------------+
    ---Control_generics->|                     |-Seg_control---->
                         |                     |
    ---Control_signals-->| SEG7_DISPLAY_DRIVER |-Digit_select--->
                         |                     |
    ---BCD_digits------->|                     |
                         +---------------------+

## Module interface
| Signal name    | Direction | Type                   | Description                                    |
|----------------|-----------|------------------------|------------------------------------------------|
| i_clk          | IN        | std_logic              | System clock                                   |
| i_rst          | IN        | std_logic              | System reset (active high)                     |
| i_digits       | IN        | std_logic_vector array | Array of BCD digit values (BDC on 4 bits)      |
| o_segments     | OUT       | std_logic_vector       | Controls digit's segments                      |
| o_digit_select | OUT       | std_logic_vector       | Controls which digit is enabled at this moment |

| Generic name       | Type    | Description                                     |
|--------------------|---------|-------------------------------------------------|
| g_number_of_digits | natural | Number of digits from which display is composed |

## Detailed architecture
TBD

# Module level description

TODO:
* Dim/lit time control signals and relevant generics contraining them.
* Code documentation available from github (Read the Docs?).
* GHDL support (TBD).
