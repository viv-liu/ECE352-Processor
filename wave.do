onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /multicycle_tb/reset
add wave -noupdate /multicycle_tb/clock
add wave -noupdate -divider {multicycle.v inputs}
add wave -noupdate /multicycle_tb/KEY
add wave -noupdate /multicycle_tb/SW
add wave -noupdate -divider {multicycle.v outputs}
add wave -noupdate /multicycle_tb/HEX0
add wave -noupdate /multicycle_tb/HEX1

add wave -noupdate /multicycle_tb/DUT/DataMem/clock 
add wave -noupdate /multicycle_tb/DUT/DataMem/MemRead 
add wave -noupdate /multicycle_tb/DUT/DataMem/wren 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/DataMem/address 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/DataMem/address_pc 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/DataMem/data 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/DataMem/q  
add wave -noupdate /multicycle_tb/DUT/DataMem/q_pc 
add wave -noupdate -radix hexadecimal -radix hexadecimal /multicycle_tb/DUT/ALU/in1 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/ALU/in2 
add wave -noupdate /multicycle_tb/DUT/ALU/ALUOp 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/ALU/out 
add wave -noupdate /multicycle_tb/DUT/ALU/N 
add wave -noupdate /multicycle_tb/DUT/ALU/Z 
add wave -noupdate /multicycle_tb/DUT/RF_block/clock 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/reg1 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/reg2 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/regw 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/dataw 
add wave -noupdate /multicycle_tb/DUT/RF_block/RFWrite 
add wave -noupdate /multicycle_tb/DUT/RF_block/reset 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/data1 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/data2 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/k0 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/k1 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/k2 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/RF_block/k3 
add wave -noupdate /multicycle_tb/DUT/IR1_reg/q 
add wave -noupdate /multicycle_tb/DUT/IR2_reg/q 
add wave -noupdate /multicycle_tb/DUT/IR3_reg/q 

add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/PC1/q 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/PC2/q 
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/PC3/q  
 
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2500 ns} 0}
configure wave -namecolwidth 227
configure wave -valuecolwidth 57
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2500 ns}
