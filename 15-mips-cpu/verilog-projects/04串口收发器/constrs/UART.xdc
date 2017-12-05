#CA->CG
set_property PACKAGE_PIN B18 [get_ports UART_RX]
set_property PACKAGE_PIN A18 [get_ports UART_TX]

set_property PACKAGE_PIN W5 [get_ports sysclk]

create_clock -period 10.000 -name CLK -waveform {0.000 5.000} [get_ports sysclk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk]

set_property IOSTANDARD LVCMOS33 [get_ports sysclk]
set_property IOSTANDARD LVCMOS33 [get_ports UART_RX]
set_property IOSTANDARD LVCMOS33 [get_ports UART_TX]