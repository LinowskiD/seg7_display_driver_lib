[![](https://github.com/LinowskiD/seg7_display_driver_lib/workflows/VUnit%20Tests/badge.svg)](https://github.com/LinowskiD/seg7_display_driver_lib/actions)
# seg7_display_driver_lib
Seven segment display driver with multiple digit support.  
Written in VHDL, project organized and verified with VUnit.  
Recently added GHDL simulation support, mainly for github actions, but it is... eh... restricting in comparison to Modelsim or Riviera, especially regarding "signal spies" used in verification. I will write more about this on a later date.

## Main goals
* Provide an easy interface to control seven segment displays, which can be then embedded in other VHDL projecs.
* Playground for using VUnit to organize and verify design.
* Playground for creating design compatible with two target simulators: Modelsim and GHDL.
* Experiment with Github actions for regression testing on git push.
* Experiment with VHDL-2008 features as long they will not break GHDL compatibility.
* Experiment with Test-Driven Development and how it will affect design choices along the way.
* Experiment with different VHDL code styles, preferably to create a tailored ruleset similar to this from ALSE (just what SKA telescope FPGA team did).
* Experiment with VHDL Style Guide (VSG) by jeremiah-c-leary to enforce proper VHDL style.
* Experiment with different ways of documenting VHDL code, to find the one that "fits".

## Features
* Handles displays consisting up to 4 digits.
* Allows to display different value on each digit.
* Allows to display hexadecimal value between 0x0 and 0xF - provided as a Binary Coded Decimal (BCD).
* Digits are being lit one at a time in a sequence.
* Hardware independent by design - provides only control logic. Selection betwen Common Cathode and Common Anode control is realized on the higher design level by a dedicated interface.

## Project requirements for simulation
* Modelsim simulator installed
* Modelsim.ini file visible in the PATH
* Modelsim win32acoem folder added to the PATH
* VUnit installed
* Python 3.* installed
* OPTIONAL: GHDL

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

| Generic name            | Type    | Description                                                    |
|-------------------------|---------|----------------------------------------------------------------|
| g_clock_frequency       | natural | Main clock frequency used for digit period calculation (in Hz) |
| g_number_of_digits      | natural | Number of digits from which display is composed                |
| g_digit_change_interval | natural | Interval between digit change (in miliseconds)                 |

## Detailed architecture
TBD

# Module level description

TODO:
* Configurable digit "light" and "dim" state time when switching multiple digits - this ensures that even with real components delay, no two digits are driven at the same time (Example: lit D1 -> dim D1 -> lit D2 -> dim D2 -> lit D1 -> ...).
* Dim/lit time control signals and relevant generics contraining them.
* Code documentation available from github (Read the Docs?).
