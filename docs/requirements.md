# Requirements

## counter_lib

* REQ_SEG_0110: Counter module shall use provided value as a preload value for the counter.
* REQ_SEG_0111: Counter module shall count down from preloaded value to 0.
* REQ_SEG_0112: Counter module shall indicate that 0 value has been reached by the counter. It shall be indicated by 1 clock cycle.
* REQ_SEG_0113: Counter module shall start counting again from a preloaded value when 0 value has been reached by the counter.
* REQ_SEG_0120: Counter module shall be enabled and disabled by a dedicated signal.
* REQ_SEG_0124: Counter module shall count only when it is enabled.
* REQ_SEG_0122: Counter module shall update internal preload value only when the rising edge of the enable signal has been detected.
* REQ_SEG_0123: Counter module shall continue counting from the last value after it has been re-enabled.
* REQ_SEG_0130: Counter module shall be reset by a dedicated signal. This shall a separate signal from the global reset.
* REQ_SEG_0131: Counter module shall stop counting when reset signal has been detected.