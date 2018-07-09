# fxclk_in
create_clock -name fxclk_in -period 20.833 [get_ports fxclk_in]
set_property PACKAGE_PIN P15 [get_ports fxclk_in]
set_property IOSTANDARD LVCMOS33 [get_ports fxclk_in]

# reset_in
set_property PACKAGE_PIN T10 [get_ports reset_in]
set_property IOSTANDARD LVCMOS33 [get_ports reset_in]
set_property PULLUP true [get_ports reset_in]

# LSI
set_property PACKAGE_PIN R17 [get_ports {lsi_miso}]  		;# PC0/GPIFADR0
set_property PACKAGE_PIN R18 [get_ports {lsi_mosi}]  		;# PC1/GPIFADR1
set_property PACKAGE_PIN P18 [get_ports {lsi_clk}]  		;# PC2/GPIFADR2
set_property PACKAGE_PIN P14 [get_ports {lsi_stop}]  		;# PC3/GPIFADR3
set_property DRIVE 4 [get_ports lsi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports lsi_*]

#transciever SPI connections                                 #Ztex    atreb
set_property PACKAGE_PIN A11 [get_ports {dev_sclk}]  		;# B30    18
set_property PACKAGE_PIN A14 [get_ports {dev_ss}]  	    	;# A29    15
set_property PACKAGE_PIN B11 [get_ports {dev_miso}]  		;# A30    17
set_property PACKAGE_PIN A13 [get_ports {dev_mosi}]  	    ;# B29    16
#set_property PACKAGE_PIN A13 [get_ports {dev_irq}]  	    ;# B28    10   
set_property DRIVE 4 [get_ports dev_miso]
set_property IOSTANDARD LVCMOS33 [get_ports dev_*]


# bitstream settings
set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]  
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR No [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 2 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design] 
