vsim -L altera_mf_ver -L lpm_ver multicycle_tb
mem load -i trial2.mif.mem -format mti /multicycle_tb/DUT/DataMem/b2v_inst/altsyncram_component/mem_data