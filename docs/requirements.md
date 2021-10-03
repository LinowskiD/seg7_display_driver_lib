# Requirements
* REQ_SEG_0000: Reset shall be asynchronous. During reset all outputs shall be set to zeroes.
* REQ_SEG_0010: System clock value shall be passed as a generic to the module. It shall be defined in Hz.
* REQ_SEG_0020: Number of digits shall be passed as a generic to the module.
* REQ_SEG_0030: Digit change interval shall be passed as a generic to the module. It shall be defined in miliseconds.
* REQ_SEG_0040: All generic values shall an integer greater than 0.
* REG_SEG_0050: Only one MUX driving signal shall be asserted at any time.
* REG_SEG_0060: MUX driving signals shall be asserted from LSB to MSB (right to left).
* REG_SEG_0070: MUX driving signals shall be changed within number of clock cycles calculated from the passed generics.
* REG_SEG_0080: BCD values provided to the module shall be translated to the corresponding digit image displayed using segments. TBD: provide table.
* REG_SEG_0090: Each BCD value shall be used only with assigned MUX line - order shall not be changed during operation.
* REG_SEG_0100: Segment driving signals shall be updated together with MUX driving signals change.