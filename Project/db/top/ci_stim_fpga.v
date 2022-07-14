`timescale 1ns/10ps
		 
/**  Possible NOM_FREQ (MHz)	of  Lattice XP2 internal oscillator (OSCE)
  
  - IMPORTANT NOTES: This parameter is string type.
	2.5 (default) , 3.1, 4.3, 5.4, 6.9, 8.1, 9.2, 10.0, 13.0, 15.0, 20.0
	26.0 , 32.0, 40.0, 54.0, 80.0, 163.0
*/

`define NOM_FREQ	("2.5") 

module ci_stim_fpga_wrapper (	
	/**
	- FPGA related signals
	*/
	/* input ports */
	i_rst_n,
	
	sw1_a,
	sw1_b,
	sw1_pb,
	
	sw2_a,
	sw2_b,
	sw2_pb,
	
	//mode,
	polarity,
    
	/* output ports */
	led_out,
	
	/* Level shifter control */
	/**
	  Level shifter control function table
	  lv_oe_n  |  lv_dir  |  A port | B port  | Operation
	  ---------+----------+---------+---------+-------------
	      L    |    L     | Enabled | Hi-Z    | B data to A bus
		    L    |    H     |   Hi-Z  | Enabled | A data to B bus
		    H    |    X     |   Hi-Z  | Hi-Z    |  Isolation
	*/
	lv_dir,
	lv_oe_n,
	
	/* Class E test ports */
	clk_out,
	data_out,
	
	/**
	- Dual dac stimulator related signals 
	*/
	/* input ports */
	stim_comp_err,
	stim_comp_en_n,
	
	/* output ports */
	stim_an,
	stim_ca,	  
	
	stim_dac0_val,
	stim_dac1_val,
	
	stim_bcg0_sel,
	stim_bcg1_sel
	
) /* synthesis syn_force_pads=1 syn_noprune=1*/;

	/**
	- FPGA related signals
	*/
	/* input ports */
	input i_rst_n/* synthesis LOC="A10" IO_TYPE="LVCMOS33" PULLMODE="UP" */ ;
	
	input sw1_a/* synthesis LOC="P10" IO_TYPE="LVCMOS33" */; 
	input sw1_b/* synthesis LOC="P11" IO_TYPE="LVCMOS33" */; 
	input sw1_pb/* synthesis LOC="N12" IO_TYPE="LVCMOS33" */;
	
	input sw2_a/* synthesis LOC="P14" IO_TYPE="LVCMOS33" */;
	input sw2_b/* synthesis LOC="P15" IO_TYPE="LVCMOS33" */;
	input sw2_pb/* synthesis LOC="P13" IO_TYPE="LVCMOS33" */;
		
	//input [2:0] mode;
	
	input [2:0] polarity/* synthesis LOC="D3,D1,D2" IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33" PULLMODE="DOWN,UP,DOWN */ ;
	
	/* output ports */
  output [15:0] led_out/* synthesis LOC="D7,E5,E6,E8,F4,H6,J5,J6,R10,R11,R13,R14,R15,R16,T10,T11" 
	                                  IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33" */ ;	

    /* Level shifter control */
	output lv_dir/* synthesis LOC="M1" IO_TYPE="LVCMOS33" */;
	output lv_oe_n/* synthesis LOC="M4" IO_TYPE="LVCMOS33" */;
	
	/* Class E test ports */
	output clk_out/* synthesis LOC="L5" IO_TYPE="LVCMOS33" */;
	output data_out/* synthesis LOC="L4" IO_TYPE="LVCMOS33" */;
	
    /**
	- Dual dac stimulator related signals 
	*/
	/* input ports */  
  input [7:0] stim_comp_err/* synthesis LOC="H1,G4,G3,G2,G1,F3,F2,F1" IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33" PULLMODE="DOWN,DOWN,DOWN,DOWN,DOWN,DOWN,DOWN,DOWN" */ ;
	
	output stim_comp_en_n/* synthesis LOC="N16" IO_TYPE="LVCMOS33" */;
	
	/* output ports */
	output [7:0] stim_an/* synthesis LOC="E13,D16,D14,C16,C14,B16,B14,A14" IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33" */;
	output [7:0] stim_ca/* synthesis LOC="E16,E11,D15,D13,C15,C13,B15,A15" IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33" */;
	
  output [7:0] stim_dac0_val/* synthesis LOC="L12,K15,K13,J16,J14,J12,H16,H13" IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33" */;
  output [7:0] stim_dac1_val/* synthesis LOC="L13,K16,K14,K11,J15,J13,J11,H15" IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33" */;
		
	output [2:0] stim_bcg0_sel/* synthesis LOC="N14,M16,L15" IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33" */;
	output [2:0] stim_bcg1_sel/* synthesis LOC="N13,L16,L14" IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33" */;

	/* internal wires and regs */
	/* IMPORTANT NOTES 
	  for specifying clock constraints, let SynplifyPro keep this wire name during synthesis by using this attribute
	*/
	wire w_clk 		/* synthesis syn_keep = 1 */;
	wire w_div4_clk /* synthesis syn_keep = 1 */;
	wire w_div64_clk 	/* synthesis syn_keep = 1 */;
	wire w_div64x64_clk /* synthesis syn_keep = 1 */;
	wire w_db_clk 	/* synthesis syn_keep = 1 */;
	wire w_div64x4_clk /* synthesis syn_keep = 1 */;
	wire w_slow_clk /* synthesis syn_keep = 1 */;
		
	reg [7:0] sw1_counter;
	reg [7:0] sw2_counter;
	reg [2:0] display_item_num;
	
	reg set_mode_display;	
	
	reg [7:0] sw1_max_count_num;
	reg [2:0] sw2_max_count_num;
	
	reg [7:0] r_dac_amp_0;
	reg [7:0] r_dac_amp_1;

	reg [7:0] c_dac_amp_0;
	reg [7:0] c_dac_amp_1;
	
	reg [2:0] r_mode;
	
	reg r_req_mode_transition;
	reg r_ack_mode_transition;
	
	reg [2:0] r_async_ack_mode_transition;
	
	reg [7:0] r_rate;
	reg [7:0] c_rate;
	
	reg [7:0] r_duration;
	reg [7:0] c_duration;
	
	reg [7:0] r_channel_0;
	reg [7:0] r_channel_1;
	reg [7:0] c_channel_0;
	reg [7:0] c_channel_1;
	
	wire w_async_ack_mode_transition_p;
	
	wire w_db_sw1_pb;
	wire w_db_sw2_pb;
	wire w_sw1_pb_p;
	wire w_sw2_pb_p;
	wire w_trigger_en;
	wire w_sync_trigger_en;
	
	reg [1:0] r_db_sw1_pb_d;
	reg [1:0] r_db_sw2_pb_d;
	
	reg mode_disp_en;
  wire [7:0] w_debug_fsm_led;
	wire [7:0] w_debug_wrap_led;
						 
	reg [15:0] led_out;
	
	/**
	- 1) Lattice IP instantiation
	    * Generates internal Clock and Reset
	*/
`ifdef SIMULATION
	/* Lattice GSR */
	gsr GSR_INST (.gsr(i_rst_n));
		
	/* Lattice XP2 internal Oscillator */	
	osce #(.NOM_FREQ(`NOM_FREQ))  internal_osc (.osc(w_clk));

`else
	/* Lattice GSR */
	/* GSR and PUR should make the instance name with pre-defined name which is "GSR_INST" and "PUR_INST" in each.
	   It is because their output is generated by Lattice tool and routed to all registers by the tool and so 
	   the tool should be able to find the instance automatically. This is the reason why instance name is fixed. */
	GSR GSR_INST (.GSR(i_rst_n));

//`define XO2
`ifdef XO2

	`define NOM_FREQ ("9.5")
	
	/* Lattice XP2 internal Oscillator */	
	/* NOM_FREQ: 2.08(default),2.15,2.22,2.29,2.38,2.46,2.56,2.66,2.77,2.89,
	 3.02,3.17,3.33,3.50,3.69,3.91,4.16,4.29,4.43,4.59,4.75,4.93,5.12,5.32,5.54,
	 5.78,6.05,6.33,6.65,7.00,7.39,7.82,8.31,8.58,8.87,9.17,9.50,9.85,10.23,10.64,
	 11.08,11.57,12.09,12.67,13.30,14.00,14.78,15.65,16.63,17.73,19.00,20.46,
	 22.17,24.18,26.60,29.56,33.25,38.00,44.33,53.20,66.50,88.67,133.00 MHz 
	*/
	OSCH #(.NOM_FREQ(`NOM_FREQ))  internal_osc (.STDBY(1'b0), .OSC(w_clk), .SEDSTDBY());
`else

	/* Lattice XP2 internal Oscillator */	
	OSCE #(.NOM_FREQ(`NOM_FREQ))  internal_osc (.OSC(w_clk));
`endif
`endif

	/* This primitive determines the user clock for the Wake up sequence.
	 * Will use this STARTCLK instead of the TCK (JTAG), BCLK (SDM), or MCLK/CCLK (sysCONFIG)
	 */
	//START internal_clock (.STARTCLK(w_clk)) /* synthesis syn_noprune=1 */;
	
	/**
	- 2) Internal block instantiation
	*/
	
	// cg: current generator
	
	wire w_cg_fsm_clk = /*w_clk; */ /*w_div64_clk;*/ w_clk;
	
	ci_if_cdc u_trigger_en (
		.i_rst_n(i_rst_n),
		.i_mclk(w_clk),
		.i_sclk(w_cg_fsm_clk),
		.i_men(w_trigger_en),
		.i_ena_m(1'b1),
		.i_ena_s(1'b1),
		.i_ena_ack(1'b0),
		.o_sen(w_sync_trigger_en),
		.o_rdy()		
	);	
	
	stim_cg_fsm u_cg_fsm (
		.i_clk(w_cg_fsm_clk),
		//.i_slow_clk(w_slow_clk),
		.i_slow_clk(w_div4_clk),
		.i_rst_n(i_rst_n),
		
		.i_polarity(polarity),
		
		.i_channel_0(r_channel_0),
		.i_channel_1(r_channel_1),
		
		.i_dac_amp_0(r_dac_amp_0),
		.i_dac_amp_1(r_dac_amp_1),

		.i_duration(r_duration),
		.i_rate(r_rate),
		
		.i_trigger(w_sync_trigger_en),
		
		.i_stim_comp_err(stim_comp_err),
		.o_stim_comp_en_n(stim_comp_en_n),
	
	  .o_stim_an(stim_an),
	  .o_stim_ca(stim_ca),

	  .o_stim_dac0_val(stim_dac0_val),
	  .o_stim_dac1_val(stim_dac1_val),
	
	  .o_stim_bcg0_sel(stim_bcg0_sel),
	  .o_stim_bcg1_sel(stim_bcg1_sel),
		
		.o_debug_led(w_debug_fsm_led)
	);
	
	debounce u_debounce_sw1 (
		.i_clk(w_db_clk),
		.i_rst_n(i_rst_n),
		.i_pb_in(sw1_pb),
		.o_db_pb(w_db_sw1_pb)
	);
	
	debounce u_debounce_sw2 (
		.i_clk(w_db_clk),
		.i_rst_n(i_rst_n),
		.i_pb_in(sw2_pb),
		.o_db_pb(w_db_sw2_pb)
	);
	
	/**
	- 3) Internal glue logic implementation 
	*/				
		
	/* SW direction detector  implementation */
	
	/**
	- Panasonic 12mm Square GS Encoders with Push-on switch	 (SPST Push-on switch)
	- reference:  EVEJB	 
	- Pins: A/B/SW/COM
	- Timing Diagram
	 
	  1) Clock wise (CW - left to right)
	                                 
                  OFF    ---------------------+                 +-----------------+              +--------------
         Signal A                             |                 |                 |              |
                  ON                          +-----------------+                 +---------------
                                              |                 |                 |
                                              |<------>|<------>|<------>|<------>|<------ 
                                                  T1   |   T2       T3   |   T4       
                                                       |                 |
	          OFF          ------------------------------+                 +---------------+              +-------
         Signal B                                      |                 |               |              |      
                  ON                                   +-----------------+               +--------------+ 	
	 
	 
           * Phase difference T1,T2,T3,T4 (at rotational speed 60r/min)
           * Initial ---------- 3.5m sec. (Min)
           * After life ------- 2.5m sec. (Min)

	 
	  2) Counter clock wise (CCW - right to left)
	                                 
                  OFF    ---------------------+                 +-----------------+              +--------------
         Signal A                             |                 |                 |              |
                  ON                          +-----------------+                 +---------------
                                              |                 |                 |
                                              |<------>|<------>|<------>|<------>|<------ 
                                                  T1   |   T2       T3   |   T4       
                                                       |                 |
	          OFF                                        +-----------------+                 +-------------+
         Signal B                                      |                 |                 |             |
                  ON    -------------------------------+                 +-----------------+             +------   	
	 
	 
	- Detection Algorithm
	  In reference of A, when positive edge of A occurs, 
	     * if B value is 'low' then it means that the user rotates the SW in CW direction.
	     * if B value is 'high' then it means the user rotates the SW in CCW direction.                                             
	 	
	*/																					 
	`define MAX_RATE_NUM		  (42)  /* Need to be defined  in this digital block: former example is 230 -> 20 Hz, 5Hz step */
	`define MAX_DURATION_NUM	(64)  /* Need to be defined in this digital block: former example is 0us -> 630us, 10us step (per phase) */
	`define MAX_AMPLITUDE_NUM	(256) /* 0mA -> 2.55mA, 10uA step */
	`define MAX_CHANNEL_NUM		(256) /* 8 channel */
	`define MAX_DISPLAY_NUM		(8)   /* 9 items */
	
	always @(*)
		begin			 			
			if (polarity[2])
			begin
				set_mode_display = 0;

				sw1_max_count_num = 0;
				sw2_max_count_num = 2;
				
				c_duration = 8'd50;
				c_rate = 8'd250;

				c_channel_0 = 0;
				c_channel_1 = 1;
				
				c_dac_amp_0 = r_dac_amp_0;
				c_dac_amp_1 = r_dac_amp_1;
				
				case (/*mode*/sw2_counter)
					3'b001:
					begin
						sw1_max_count_num = `MAX_AMPLITUDE_NUM - 1;
						
						c_dac_amp_0 = sw1_counter;
					end
					3'b010:
					begin
						sw1_max_count_num = `MAX_AMPLITUDE_NUM - 1;
					
						c_dac_amp_1 = sw1_counter;
					end
					3'b000:
					begin
						set_mode_display = 1;
						sw1_max_count_num = `MAX_DISPLAY_NUM - 1;
					end					
					default:;
				endcase
			end
			else
			begin
				set_mode_display = 0;
			
				sw1_max_count_num = 0;
				sw2_max_count_num = 6;
			
				c_rate = r_rate;
				c_duration = r_duration;
				c_dac_amp_0 = r_dac_amp_0;
				c_dac_amp_1 = r_dac_amp_1;
				c_channel_0 = r_channel_0;
				c_channel_1 = r_channel_1;
			
				case (/*mode*/sw2_counter)
					3'b001:
					begin
						sw1_max_count_num = `MAX_RATE_NUM - 1;
					
						if (w_sw1_pb_p)
							c_rate = sw1_counter;
					end
					3'b010: 
					begin
						sw1_max_count_num = `MAX_DURATION_NUM - 1;
					
						if (w_sw1_pb_p)
							c_duration = sw1_counter;
					end
					3'b011: 
					begin
						sw1_max_count_num = `MAX_AMPLITUDE_NUM - 1;
					
						if (w_sw1_pb_p)
							c_dac_amp_0 = sw1_counter;
					end
					3'b100: 
					begin
						sw1_max_count_num = `MAX_AMPLITUDE_NUM - 1;
					
						if (w_sw1_pb_p)
							c_dac_amp_1 = sw1_counter;
					end							
					3'b101:
					begin
						sw1_max_count_num = `MAX_CHANNEL_NUM - 1;
					
						if (w_sw1_pb_p) 
							c_channel_0 = sw1_counter;
					end
					3'b110:
					begin
						sw1_max_count_num = `MAX_CHANNEL_NUM - 1;
					
						if (w_sw1_pb_p)
							c_channel_1 = sw1_counter;
					end
					3'b000:
					begin
						set_mode_display = 1;
						sw1_max_count_num = `MAX_DISPLAY_NUM - 1;
					end
					default:
					/* 3'b111: Not used */;
				endcase			
			end
	end

	always @(posedge w_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin
			r_rate <= 2;
			r_dac_amp_0 <= 255;
			r_dac_amp_1 <= 100;
			r_duration  <= 4;
			r_channel_0 <= 2;
			r_channel_1 <= 5;
		end
		else
    begin
			r_rate <= c_rate;
			r_dac_amp_0 <= c_dac_amp_0;
			r_dac_amp_1 <= c_dac_amp_1;
			r_duration  <= c_duration;
			r_channel_0 <= c_channel_0;
			r_channel_1 <= c_channel_1;
		end
		
	always @(posedge w_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_mode <= 0;
		else
			r_mode <= /*mode*/sw2_counter;
		
	always @(posedge w_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_req_mode_transition <= 0;
		else
		if (r_mode != /*mode*/sw2_counter)
			r_req_mode_transition <= 1;
		else
		if (w_async_ack_mode_transition_p)
			r_req_mode_transition <= 0;
	
	always @(posedge w_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_async_ack_mode_transition <= 0;
		else
			r_async_ack_mode_transition <= {r_async_ack_mode_transition[1:0],r_ack_mode_transition};
			
	assign w_async_ack_mode_transition_p = r_async_ack_mode_transition[1] & ~r_async_ack_mode_transition[2];
			
	/* Assumption: r_req_mode_transition very quickly responds after r_ack_mode_transition goes high */
	always @(posedge sw1_a or negedge i_rst_n)
		if (~i_rst_n)
			r_ack_mode_transition <= 0;
		else
		if (sw1_b == 1)
		begin
			if (r_req_mode_transition)
				r_ack_mode_transition <= 1;
			else
				r_ack_mode_transition <= 0;
		end
			
	always @(posedge sw1_a or negedge i_rst_n)
		if (~i_rst_n)
		begin	   
			sw1_counter <= 0;
		end    
	    else
		if (r_ack_mode_transition)
			sw1_counter <= 0;
		else
		if (set_mode_display == 0)
		begin
			if ((sw1_counter > sw1_max_count_num) ||
				(sw1_counter < 0))
			begin
				sw1_counter <= 0;
			end
			else
			if (sw1_b == 0)
			begin	   
				if (sw1_counter <= sw1_max_count_num)
					sw1_counter <= sw1_counter + 1;
			end			   
			else
			begin
				if (sw1_counter > 0)
					sw1_counter <= sw1_counter - 1;
			end	
		end

	always @(posedge sw2_a or negedge i_rst_n)
		if (~i_rst_n)
		begin	   
			sw2_counter <= 0;
		end    
	  else
  	if ((sw2_counter > sw2_max_count_num) ||
	  		(sw2_counter < 0))
		begin
			sw2_counter <= 0;
		end
		else
		if (sw2_b == 0)
		begin	   
			if (sw2_counter <= sw2_max_count_num)
				sw2_counter <= sw2_counter + 1;
		end			   
		else
		begin
			if (sw2_counter > 0)
				sw2_counter <= sw2_counter - 1;
		end	

	always @(posedge sw1_a or negedge i_rst_n)
		if (~i_rst_n)
    		display_item_num <= 0;
		else
		if (set_mode_display == 1)
		begin
			if (display_item_num > sw1_max_count_num)
				display_item_num <= 0;
			else
			if (sw1_b == 0)
				display_item_num <= display_item_num + 1;
			else
				display_item_num <= 0;
		end

	always @(posedge w_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin
			r_db_sw1_pb_d <= 2'b10; // after reset, one trigger pulse is generated automatically
			r_db_sw2_pb_d <= 2'b11;
		end
		else
		begin
			r_db_sw1_pb_d <= {r_db_sw1_pb_d[0],w_db_sw1_pb};
			r_db_sw2_pb_d <= {r_db_sw2_pb_d[0],w_db_sw2_pb};
		end
	
	assign w_sw1_pb_p = r_db_sw1_pb_d[0] & ~r_db_sw1_pb_d[1];
	assign w_sw2_pb_p = r_db_sw2_pb_d[0] & ~r_db_sw2_pb_d[1];
	
	assign w_trigger_en = (polarity[2]) ? w_sw1_pb_p : set_mode_display & w_sw1_pb_p;
	
  always @(posedge w_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin
			mode_disp_en <= 0;
		end
		else
		if (w_sw2_pb_p)
    begin
			mode_disp_en <= ~mode_disp_en;
		end
		
	/* 2.5Mhz clock generation for class E amp */
	div4_clk u_div4_clk (
		.i_clk(w_clk),
		.i_rst_n(i_rst_n),
		.o_gen_clk(w_div4_clk)
	);	
	
	/* Slow clock generation for debouncing push button */
	div64_clk u_div64_clk (
		.i_clk(w_clk),
		.i_rst_n(i_rst_n),
		.o_gen_clk(w_div64_clk)
	);	
	
	div64_clk u_div64x64_clk (
		.i_clk(w_div64_clk),
		.i_rst_n(i_rst_n),
		.o_gen_clk(w_div64x64_clk)
	);	
	
	div2_clk u_div2_clk (
		.i_clk(w_div64x64_clk),
		.i_rst_n(i_rst_n),
		.o_gen_clk(w_db_clk)
	);
	
	/* 10kHz clock (slow) generation for stimulation */
	div4_clk u_div64x4_clk (
		.i_clk(w_div64_clk),
		.i_rst_n(i_rst_n),
		.o_gen_clk(w_div64x4_clk)
	);	
	
	div4_clk u_div64x4x4_clk (
		.i_clk(w_div64x4_clk),
		.i_rst_n(i_rst_n),
		.o_gen_clk(w_slow_clk)
	);	

	reg pb_p_test;
	
	always @(posedge w_clk or negedge i_rst_n)
		if (~i_rst_n)
			pb_p_test <= 0;
		else
		if (w_trigger_en)
			pb_p_test <= ~pb_p_test;
					 
	assign w_debug_wrap_led = {r_req_mode_transition, r_ack_mode_transition, pb_p_test};

	always @(*)
  begin
		led_out = {8'b0,sw1_counter};
		
		if (mode_disp_en)
			led_out = {mode_disp_en,12'b0,sw2_counter[2:0]};
		else
		if (set_mode_display)
		begin
			case (display_item_num)
				0: led_out = {8'b0,r_rate};
				1: led_out = {8'b0,r_duration};
				2: led_out = {8'b0,r_dac_amp_0};
				3: led_out = {8'b0,r_dac_amp_1};
				4: led_out = {8'b0,r_channel_0};
				5: led_out = {8'b0,r_channel_1};
				6: led_out = {8'b0,w_debug_fsm_led};
				7: led_out = {8'b0,w_debug_wrap_led};
				default:;
			endcase
		end
	end
					 
	assign clk_out = w_div4_clk;
	assign data_out = 1'b0; /* PMOS = on, NMOS = off */
	
  /* Set level shifter direction
     - Setting A port to B port */
  assign lv_oe_n = 1'b0;
	assign lv_dir  = 1'b1;
	
endmodule
