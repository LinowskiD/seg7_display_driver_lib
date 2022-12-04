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
* Experiment with Test-Driven Development and how it will affect design choices along the way (kind of).
* Experiment with different VHDL code styles, preferably to create a tailored ruleset similar to this from ALSE (just what SKA telescope FPGA team did).
* Experiment with VHDL Style Guide (VSG) by jeremiah-c-leary to enforce proper VHDL style.
* Experiment with different ways of documenting VHDL code, to find the one that "fits".

## Features
* Handles displays consisting of defined number of digits. Currently max value is not defined.
* Allows to display different value on each digit.
* Allows to display hexadecimal value between 0x0 and 0xF - provided as a Binary Coded Decimal (BCD).
* Digits are being lit one at a time in a sequence.
* Digit "ON" time can be modified in runtime.
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
    ---Control generics->|                     |-Seg control---->
                         |                     |
    ---Control signals-->| SEG7_DISPLAY_DRIVER |-Digit select--->
                         |                     |
    ---BCD digits------->|                     |
                         +---------------------+

## Module interface
| Signal name       | Direction | Type                   | Description                                      |
|-------------------|-----------|------------------------|--------------------------------------------------|
| i_clk             | IN        | std_logic              | System clock                                     |
| i_rst             | IN        | std_logic              | System reset (active high)                       |
| i_digit_on_time   | IN        | std_logic_vector       | Number of clock cycles when digit shall be "lit" |
| i_value           | IN        | std_logic_vector array | Array of BCD digit values (each BDC on 4 bits)   |
| o_segments        | OUT       | std_logic_vector       | Controls digit's segments                        |
| o_digit_select    | OUT       | std_logic_vector       | Controls which digit is enabled at this moment   |

| Generic name                      | Type    | Description                                                 |
|-----------------------------------|---------|-------------------------------------------------------------|
| g_number_of_digits                | natural | Number of digits from which display is composed             |
| g_digit_change_interval           | natural | Interval between digit change (in clock cycles)             |
| g_digit_change_interval_bit_size  | natural | Bit size of g_digit_change_interval                         |

## Detailed architecture
TBD

# Module level description

TODO:
* Code documentation available from github (Read the Docs?).
