# Requirements

## Global requirements
* REQ_SEG_0010: System clock value shall be passed as a generic to the module, so that it can be passed to the submodules, like time counter.
* REQ_SEG_0020: Reset shall be asynchronous. During reset all registers shall be filled with zeroes.

## counter_rtl
* REQ_SEG_0100: System clock value shall be passed as a generic to the module, so that it can be used in the internal calculations.
* REQ_SEG_0101: Preload value bit size shall be passed as a generic to the module.
* REQ_SEG_0110: Counting shall be enabled when 'enable' signal has been provided for at least one clock cycle.
* REQ_SEG_0120: Current internal counter value shall be cleared when 'clear' signal has been provided for at least one clock cycle.
* REQ_SEG_0121: When 'clear' signal has been applied counting shall be stopped.
* REQ_SEG_0130: Module shall load initialization value for the internal counter when 'load' signal has been provided for at least one clock cycle.
* REQ_SEG_0131: When no value has been loaded, counter starting value shall be it's maximum value.
* REQ_SEG_0140: Module shall indicate that it is enabled and is counting by driving 'busy' signal.
* REQ_SEG_0150: Module shall indicate that the internal counter has stopped counting (end value has been reached) by driving 'done' signal - it shall be kept high
* REQ_SEG_0151: 'done' signal shall be driven low when new cycle starts.

<!-- * REQ_SEG_0110: Counter module shall use provided value as a preload value for the counter.
* REQ_SEG_0111: Counter module shall count down from preloaded value to 0.
* REQ_SEG_0112: Counter module shall indicate that 0 value has been reached by the counter. It shall be indicated by 1 clock cycle.
* REQ_SEG_0113: Counter module shall start counting again from a preloaded value when 0 value has been reached by the counter.
* REQ_SEG_0120: Counter module shall be enabled and disabled by a dedicated signal.
* REQ_SEG_0121: Counter module shall count only when it is enabled.
* REQ_SEG_0122: Counter module shall update internal preload value only when the rising edge of the enable signal has been detected.
* REQ_SEG_0123: Counter module shall continue counting from the last value after it has been re-enabled.
* REQ_SEG_0124: Counter shall indicate that it is busy.
* REQ_SEG_0130: Counter module shall be reset by a dedicated signal. This shall a separate signal from the global reset.
* REQ_SEG_0131: Counter module shall stop counting when reset signal has been detected. -->