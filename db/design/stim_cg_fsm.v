`timescale 1ns/10ps

`define ST_INIT		(3'd0) /* 000 */
`define ST_IDLE		(3'd1) /* 001 */
`define ST_BCG_N	(3'd2) /* 010 */
`define ST_BCG_I	(3'd3) /* 011 */
`define ST_BCG_P	(3'd4) /* 100 */
`define ST_CB_P		(3'd5) /* 101 */
`define ST_CB_M		(3'd6) /* 110 */
`define ST_CB_ON	(3'd7) /* 111 */

`define INTERVAL_PHASE_TIME	(1)
`define CB_INIT_TIME		(10)
`define CB_RESET_TIME		(10)

module stim_cg_fsm (
  i_clk, 
	i_slow_clk,
  i_rst_n,
		
	i_polarity,
	
  i_channel_0,
	i_channel_1,
	
  i_dac_amp_0,
	i_dac_amp_1,
	
  i_duration,
  i_rate,
  i_trigger,
   
  i_stim_comp_err,
	
  o_stim_comp_en_n,
	
  o_stim_an,
  o_stim_ca,
	
  o_stim_dac0_val,
  o_stim_dac1_val,
	
  o_stim_bcg0_sel,
  o_stim_bcg1_sel,
	
	o_debug_led
		    
);

  input i_clk;
	input i_slow_clk;
  input i_rst_n;
   
  input [2:0] i_polarity;
	
  input [7:0] i_channel_0;
	input [7:0] i_channel_1;
	
  input [7:0] i_dac_amp_0;
	input [7:0] i_dac_amp_1;
		
  input [7:0] i_duration;
  input [7:0] i_rate;
	
  input i_trigger;

  input [7:0] i_stim_comp_err;
   
  output o_stim_comp_en_n;

  output [7:0] o_stim_an;
  output [7:0] o_stim_ca;


  output [7:0] o_stim_dac0_val;
  output [7:0] o_stim_dac1_val;

  output [2:0] o_stim_bcg0_sel;
  output [2:0] o_stim_bcg1_sel;
	
	output [7:0] o_debug_led;

	/* Declaration of internal registers and wires */
	reg [7:0] r_dac_amp_0;
	reg [7:0] r_dac_amp_1;

	reg [7:0] r_channel_0;
	reg [7:0] r_channel_1;

  reg [7:0] r_duration;
	reg [7:0] r_rate;
	
  reg [7:0] r_sync_rate;
		
	reg [7:0] r_rate_cnt;
			
	reg [7:0] r_search_disabled_channel;
	
	/*reg [2:0] r_disabled_dac_sel;*/
	reg [2:0] c_disabled_dac_sel;
	
	reg [7:0] r_stim_dac0_val;
	reg [2:0] r_stim_bcg0_sel;
	
	reg [7:0] r_stim_dac1_val;
	reg [2:0] r_stim_bcg1_sel;
	
	reg r_disabled_dac_sel_found_d;
	
	reg [2:0] r_state;
	reg [2:0] c_next_state;
	
	reg [7:0] r_interval_value;
	reg [7:0] c_interval_value;
	
	reg [7:0] c_map_cathod_channel_0;
	reg [7:0] c_map_cathod_channel_1;
	
	reg [7:0] c_map_cathod_channel;
	
	reg c_set_mode_simultaneous;
	reg c_set_mode_bipolar;
	reg c_set_mode_monopolar;
	reg c_set_mode_skip_cb_phase;
	
	reg [7:0] c_stim_an;
	reg [7:0] c_stim_ca;
	
	reg [7:0] c_stim_comp_err_0;
	reg [7:0] c_stim_comp_err_1;
	
	reg [7:0] c_m_stim_comp_err_0;
	reg [7:0] c_m_stim_comp_err_1;
	
	reg c_cb_on_0;
	reg c_cb_on_1;
	
	reg r_stim_comp_en_n;
	reg c_stim_comp_en_n;
	
	reg r_sync_trigger_d;
	reg r_sync_search_disabled_channel_phase_end_p_d;
	
	reg r_rate_phase;
	
	reg c_cathod_phase_en;
	reg c_anode_phase_en;
	reg c_interval_phase_en;
	reg c_cb_phase_start_en;
	reg c_cb_phase_end_en;
			
	reg r_search_disabled_channel_phase;
	
	reg r_cathod_phase;
	reg r_interval_phase;
	reg r_anode_phase;
	reg r_cb_phase;
	
	reg [7:0] r_duration_cnt;
	reg [7:0] r_interval_cnt;
		
	reg [7:0] r_stim_an;
	reg [7:0] r_stim_ca;
	
	reg [7:0] r_stim_comp_err_0;
	reg [7:0] r_stim_comp_err_1;
	
	reg r_cb_on_0;
	reg r_cb_on_1;
	
	reg r_stim_comp_en;
	
	reg [7:0] r_sync_duration;
	reg [2:0] r_sync_cathod_phase;
	reg [2:0] r_sync_anode_phase;
		
	wire w_sync_cathod_phase_en;
	wire w_sync_anode_phase_en;
	
	wire w_cathod_phase_end_en;
	wire w_anode_phase_end_en;

	wire w_sync_cathod_phase_end_en;
	wire w_sync_anode_phase_end_en;
	
	wire [7:0] w_inactive_channel;
	
	wire w_search_disabled_channel_phase_end_p;
	
	wire w_sync_trigger;	
	wire w_sync_search_disabled_channel_phase_end_p;
	
	wire w_disabled_dac_sel_found;
	
	wire w_bcg_fsm_start;
	
	wire w_fsm_trigger;
	wire w_sync_fsm_trigger;

	wire w_rate_tmout;	wire w_duration_tmout;
	wire w_interval_tmout;
	
	/*------------------------------------------------------------------------------*/
	/* Output assignments */
	/*------------------------------------------------------------------------------*/
	assign o_debug_led = {w_bcg_fsm_start,w_rate_tmout,r_cathod_phase,r_interval_phase,r_anode_phase,r_state};
	//assign o_debug_led = r_search_disabled_channel | (r_search_disabled_channel_phase << 7) | c_map_cathod_channel;
	//assign o_debug_led = {r_search_disabled_channel_phase,w_search_disabled_channel_phase_end_p,r_stim_bcg1_sel,c_disabled_dac_sel};
				
	assign o_stim_an = r_stim_an;
	assign o_stim_ca = r_stim_ca;
	
	assign o_stim_comp_en_n = r_stim_comp_en;
				 
	assign o_stim_dac0_val = r_stim_dac0_val;
	assign o_stim_bcg0_sel = r_stim_bcg0_sel;
	
	assign o_stim_dac1_val = r_stim_dac1_val;
	assign o_stim_bcg1_sel = r_stim_bcg1_sel;    
	
	/*------------------------------------------------------------------------------*/
	/* Interval logic implementation */
	/*------------------------------------------------------------------------------*/
	always @(*)
	begin
		c_set_mode_monopolar = 0;
		c_set_mode_bipolar = 0;
		c_set_mode_simultaneous = 0;
		c_set_mode_skip_cb_phase = 1; /* monopolar test */
		
		case (i_polarity[1:0])
			2'd0: c_set_mode_monopolar = 1;
			2'd1: c_set_mode_bipolar = 1;
			2'd2: c_set_mode_simultaneous = 1;
			default:;
		endcase
	end
	
	/** 
	 * Slow clock domain
	 **/
	/* Synchronizing i_clk to i_slow_clk */
  ci_if_cdc u_sync_trigger (
		.i_rst_n(i_rst_n),
		.i_mclk(i_clk),
		.i_sclk(i_slow_clk),
	  .i_men(i_trigger),
		.i_ena_m(1'b1),
		.i_ena_s(1'b1),
		.i_ena_ack(1'b0),
		.o_sen(w_sync_trigger),
		.o_rdy()
	);
	
  ci_if_cdc u_sync_search_disabled_channel_phase_end_p (
		.i_rst_n(i_rst_n),
		.i_mclk(i_clk),
		.i_sclk(i_slow_clk),
		.i_men(w_search_disabled_channel_phase_end_p),
		.i_ena_m(1'b1),
		.i_ena_s(1'b1),
		.i_ena_ack(1'b0),
		.o_sen(w_sync_search_disabled_channel_phase_end_p),
		.o_rdy()		
	);

  ci_if_cdc u_sync_cathod_phase_en (
		.i_rst_n(i_rst_n),
		.i_mclk(i_clk),
		.i_sclk(i_slow_clk),
		.i_men(c_cathod_phase_en),
		.i_ena_m(1'b1),
		.i_ena_s(1'b1),
		.i_ena_ack(1'b0),
		.o_sen(w_sync_cathod_phase_en),
		.o_rdy()		
	);
	
  ci_if_cdc u_sync_anode_phase_en (
		.i_rst_n(i_rst_n),
		.i_mclk(i_clk),
		.i_sclk(i_slow_clk),
		.i_men(c_anode_phase_en),
		.i_ena_m(1'b1),
		.i_ena_s(1'b1),
		.i_ena_ack(1'b0),
		.o_sen(w_sync_anode_phase_en),
		.o_rdy()		
	);	
	
	always @(posedge i_slow_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_rate_cnt <= 0;
		else
		if (r_sync_trigger_d)
			r_rate_cnt <= 0;
		else
		if (w_rate_tmout ||	r_sync_rate == 0)
			r_rate_cnt <= 0;
		else
		if (r_rate_phase)
			r_rate_cnt <= r_rate_cnt + 1;
			
	assign w_rate_tmout = (r_rate_cnt == r_sync_rate); /* At reset stage, this will be zero due to (r_rate == 0) */
	
	assign w_fsm_trigger = r_rate_phase & w_rate_tmout;
	
	always @(posedge i_slow_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin
			r_sync_rate <= 0;
			r_sync_duration <= 0;
		end
		else
		if (w_sync_trigger)
		begin
			r_sync_rate <= r_rate;
			r_sync_duration <= r_duration;
		end

	always @(posedge i_slow_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin
			r_sync_trigger_d <= 0;
			r_sync_search_disabled_channel_phase_end_p_d <= 0;
		end
		else
		begin
			r_sync_trigger_d <= w_sync_trigger;
			r_sync_search_disabled_channel_phase_end_p_d <= w_sync_search_disabled_channel_phase_end_p;
		end

	always @(posedge i_slow_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_rate_phase <= 0;
		else
		if (r_sync_rate == 0)
			r_rate_phase <= 0;
		else
		if (r_sync_search_disabled_channel_phase_end_p_d)
			r_rate_phase <= 1;
			
	/* BCG pulse pattern controller */
	always @(posedge i_slow_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_duration_cnt <= 0;
		else
		if (w_sync_cathod_phase_en || w_sync_anode_phase_en || w_duration_tmout)
			r_duration_cnt <= 0;
		else
		if (r_cathod_phase || r_anode_phase)
		begin
			if (r_duration_cnt < r_sync_duration)
				r_duration_cnt <= r_duration_cnt + 1;
		end
			
	assign w_duration_tmout = (r_duration_cnt == r_sync_duration);

	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_cathod_phase <= 0;
		else
		if (w_sync_cathod_phase_en)
			r_cathod_phase <= 1;
		else
		if (w_cathod_phase_end_en)
			r_cathod_phase <= 0;
			
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_anode_phase <= 0;
		else
		if (w_sync_anode_phase_en)
			r_anode_phase <= 1;
		else
		if (w_anode_phase_end_en)
			r_anode_phase <= 0;
				
	assign w_cathod_phase_end_en = w_duration_tmout && r_cathod_phase;
	assign w_anode_phase_end_en  = w_duration_tmout && r_anode_phase;

	/** Fast clock domain
	 *
	 **/
		
	/* Synchronizing i_slow_clk to i_clk */
  ci_if_cdc u_sync_fsm_trigger (
		.i_rst_n(i_rst_n),
		.i_mclk(i_slow_clk),
		.i_sclk(i_clk),
		.i_men(w_fsm_trigger),
		.i_ena_m(1'b1),
		.i_ena_s(1'b1),
		.i_ena_ack(1'b0),
		.o_sen(w_sync_fsm_trigger),
		.o_rdy()		
	);	

	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin
			r_sync_cathod_phase <= 0;
			r_sync_anode_phase  <= 0;
		end
		else
		begin
			r_sync_cathod_phase <= {r_sync_cathod_phase[1:0],r_cathod_phase};
			r_sync_anode_phase  <= {r_sync_anode_phase[1:0] ,r_anode_phase};
		end
		
	assign w_sync_cathod_phase_end_en = ~r_sync_cathod_phase[1] & r_sync_cathod_phase[2];
	assign w_sync_anode_phase_end_en  = ~r_sync_anode_phase[1] & r_sync_anode_phase[2];
	
	/* Capture input values with trigger pulse */
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin
			r_rate <= 0;
			r_duration  <= 0;		
			r_dac_amp_0 <= 0;
			r_dac_amp_1 <= 0;
			r_channel_0 <= 0;
			r_channel_1 <= 0;
		end
		else
		if (i_polarity[2] ==  1'b1)
		begin
			r_rate <= i_rate;
			r_duration	<= i_duration;	
			r_dac_amp_0 <= i_dac_amp_0;
			r_dac_amp_1 <= i_dac_amp_1;
			r_channel_0 <= i_channel_0;
			r_channel_1 <= i_channel_1;			
		end
		else
		if (i_trigger)
		begin
			r_rate <= i_rate;
			r_duration	<= i_duration;	
			r_dac_amp_0 <= i_dac_amp_0;
			r_dac_amp_1 <= i_dac_amp_1;
			r_channel_0 <= i_channel_0;
			r_channel_1 <= i_channel_1;
		end

	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin		
			r_stim_bcg0_sel <= 0;
			r_stim_bcg1_sel <= 0;			
		end
		else
		if (w_search_disabled_channel_phase_end_p)
		begin
			r_stim_bcg0_sel <= r_channel_0[2:0];
			r_stim_bcg1_sel <= (c_set_mode_simultaneous) ? r_channel_1[2:0]: c_disabled_dac_sel;
		end
			
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin
			r_stim_dac0_val <= 0;
			r_stim_dac1_val <= 0;
		end
		else
		if (c_cathod_phase_en)
		begin
			r_stim_dac0_val <= r_dac_amp_0;
			r_stim_dac1_val <= (c_set_mode_simultaneous) ? r_dac_amp_1 : 8'd0;
		end
		
	assign w_inactive_channel = ~c_map_cathod_channel;
	
	/* Finding the nearest inactive channel to LSB */
	assign w_disabled_dac_sel_found = (r_search_disabled_channel_phase) ? |(w_inactive_channel & r_search_disabled_channel) : 0;
	
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)	
			r_search_disabled_channel <= 0;
		else
		if (i_trigger)
			r_search_disabled_channel <= 8'b0000_0001; /* Start from LSB */
		else
		if (r_search_disabled_channel_phase && 
			(w_disabled_dac_sel_found == 0) /* Not Found */)
		begin
			if (r_search_disabled_channel[7]) /* Circulating 8 bits */
				r_search_disabled_channel <= 8'b0000_0001; /* Start from LSB */
			else
				r_search_disabled_channel <= r_search_disabled_channel << 1; /* Shift left to MSB */
		end

	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)	
			r_search_disabled_channel_phase <= 0;
		else
		if (i_trigger)
			r_search_disabled_channel_phase <= 1;
		else
		if (w_search_disabled_channel_phase_end_p)
			r_search_disabled_channel_phase <= 0;
			
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_disabled_dac_sel_found_d <= 0;
		else
			r_disabled_dac_sel_found_d <= w_disabled_dac_sel_found;
			
	assign w_search_disabled_channel_phase_end_p = w_disabled_dac_sel_found & ~r_disabled_dac_sel_found_d;

	assign w_bcg_fsm_start = (r_search_disabled_channel_phase) ? w_search_disabled_channel_phase_end_p : w_sync_fsm_trigger;

	/*
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_disabled_dac_sel <= 0;
		else
			r_disabled_dac_sel <= c_disabled_dac_sel;
	*/


	/* Channel decoding */
	always @(r_channel_0)	
	begin
		c_map_cathod_channel_0 = 8'b0000_0001;
		
		case(r_channel_0)
			8'd0: c_map_cathod_channel_0 = 8'b0000_0001;
			8'd1: c_map_cathod_channel_0 = 8'b0000_0010;
			8'd2: c_map_cathod_channel_0 = 8'b0000_0100;
			8'd3: c_map_cathod_channel_0 = 8'b0000_1000;
			8'd4: c_map_cathod_channel_0 = 8'b0001_0000;
			8'd5: c_map_cathod_channel_0 = 8'b0010_0000;
			8'd6: c_map_cathod_channel_0 = 8'b0100_0000;
			8'd7: c_map_cathod_channel_0 = 8'b1000_0000;
			default:;
		endcase
	end 
	
	always @(r_channel_1)	
	begin
		c_map_cathod_channel_1 = 8'b0000_0001;
		
		case(r_channel_1)
			8'd0: c_map_cathod_channel_1 = 8'b0000_0001;
			8'd1: c_map_cathod_channel_1 = 8'b0000_0010;
			8'd2: c_map_cathod_channel_1 = 8'b0000_0100;
			8'd3: c_map_cathod_channel_1 = 8'b0000_1000;
			8'd4: c_map_cathod_channel_1 = 8'b0001_0000;
			8'd5: c_map_cathod_channel_1 = 8'b0010_0000;
			8'd6: c_map_cathod_channel_1 = 8'b0100_0000;
			8'd7: c_map_cathod_channel_1 = 8'b1000_0000;
			default:;
		endcase
	end
		
	/* Channel encoding */	
	always @(r_search_disabled_channel)
	begin
		c_disabled_dac_sel = 3'd0;
		
		case (r_search_disabled_channel)
			8'b0000_0001: c_disabled_dac_sel = 3'd0;
			8'b0000_0010: c_disabled_dac_sel = 3'd1;
			8'b0000_0100: c_disabled_dac_sel = 3'd2;
			8'b0000_1000: c_disabled_dac_sel = 3'd3;
			8'b0001_0000: c_disabled_dac_sel = 3'd4;
			8'b0010_0000: c_disabled_dac_sel = 3'd5;
			8'b0100_0000: c_disabled_dac_sel = 3'd6;
			8'b1000_0000: c_disabled_dac_sel = 3'd7;
			default:;			
		endcase
	end

	/* BCG FSM */
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_state <= `ST_INIT;
		else
			r_state <= c_next_state;

//`define TRIAL_CASE

	always @(*)
	begin
		c_stim_an = 0;
		c_stim_ca = 0;
			
		/* Support simultaneous stimulation */
		c_map_cathod_channel = c_map_cathod_channel_0 | c_map_cathod_channel_1;
		
		c_cathod_phase_en = 0;
		c_anode_phase_en = 0;
		c_interval_phase_en = 0;
		c_cb_phase_start_en = 0;
		c_cb_phase_end_en = 0;
		
		c_next_state = r_state;
		
		c_stim_comp_en_n = r_stim_comp_en_n;
				
		c_stim_comp_err_0 = r_stim_comp_err_0;
		c_stim_comp_err_1 = r_stim_comp_err_1;
		
		c_m_stim_comp_err_0 = i_stim_comp_err & c_map_cathod_channel_0;
		c_m_stim_comp_err_1 = i_stim_comp_err & c_map_cathod_channel_1;
		
		c_cb_on_0 = r_cb_on_0;
		c_cb_on_1 = r_cb_on_1;
		
		c_interval_value = r_interval_value;
		
		case (r_state)
			`ST_INIT:
				begin
					c_stim_comp_en_n = 0;
					
					if (r_interval_phase)
						c_next_state = `ST_INIT;
					else
						c_next_state = `ST_IDLE;
				end
			`ST_IDLE: 
				begin					
					if (w_bcg_fsm_start)
					begin
						c_cathod_phase_en = 1;
						c_next_state = `ST_BCG_N;
					end
					else
						c_next_state = `ST_IDLE;
				end
			`ST_BCG_N:
				begin					
					if (r_sync_cathod_phase[1])
					begin
						c_stim_ca = (c_set_mode_bipolar) ? c_map_cathod_channel_0 : c_map_cathod_channel;
						c_next_state = `ST_BCG_N;
					end
					
					if (w_sync_cathod_phase_end_en)
					begin
						c_interval_phase_en = 1;
						c_interval_value = `INTERVAL_PHASE_TIME;
						c_next_state = `ST_BCG_I;
					end
				end
			`ST_BCG_I:
				begin			
					if (r_interval_phase)
						c_next_state = `ST_BCG_I;
					else
					begin
						c_anode_phase_en = 1;
						c_next_state = `ST_BCG_P;
					end
				end
			`ST_BCG_P:
				begin
					if (r_sync_anode_phase[1])
					begin
						c_stim_an = (c_set_mode_bipolar) ? c_map_cathod_channel_1 : c_map_cathod_channel;
						c_next_state = `ST_BCG_P;
					end
					
					if (w_sync_anode_phase_end_en)
					begin

						if (c_set_mode_skip_cb_phase)
						begin
							c_stim_comp_en_n = 1;
							c_next_state = `ST_INIT;
						end
						else
						begin
							c_cb_phase_start_en = 1;
							c_interval_phase_en = 1;
							c_interval_value = `CB_INIT_TIME;
							c_next_state = `ST_CB_P;
						end
					end
				end
			`ST_CB_P:
				begin 
					if (r_interval_phase)
						c_next_state = `ST_CB_P;
					else
					begin
						c_stim_comp_err_0 = c_m_stim_comp_err_0;
						c_stim_comp_err_1 = c_m_stim_comp_err_1;
						c_next_state = `ST_CB_M;
					end
				end
			`ST_CB_M:
				begin
					if (r_interval_phase)
						c_next_state = `ST_CB_M;
					else
					begin
						if (r_stim_comp_err_0 == c_m_stim_comp_err_0)
							c_cb_on_0 = 1;
						else
							c_cb_on_0 = 0;
					
						if (r_stim_comp_err_1 == c_m_stim_comp_err_1)
							c_cb_on_1 = 1;
						else
							c_cb_on_1 = 0;
						
						if (c_cb_on_0 || c_cb_on_1)
						begin
							c_interval_phase_en = 1;
							c_interval_value = `CB_INIT_TIME;
							c_next_state = `ST_CB_ON;
						end
						else
						begin
							c_stim_comp_en_n = 1;
							c_cb_phase_end_en = 1;
							c_interval_phase_en = 1;
							c_interval_value = `CB_RESET_TIME;
							c_next_state = `ST_INIT;
						end
					end
				end
			`ST_CB_ON:
				begin
					if (r_interval_phase)
						c_next_state = `ST_CB_ON;
					else
					begin
						if (r_cb_on_0)
						begin
							if (|r_stim_comp_err_0)
							begin
`ifdef TRIAL_CASE
								c_stim_an = (c_set_mode_bipolar) ? c_map_cathod_channel_1 : c_map_cathod_channel_0;
`else
								c_stim_ca = (c_set_mode_bipolar) ? c_map_cathod_channel_0 : c_map_cathod_channel_0;
`endif
							end
							else
							begin
`ifdef TRIAL_CASE
								c_stim_ca = (c_set_mode_bipolar) ? c_map_cathod_channel_0 : c_map_cathod_channel_0;
`else
								c_stim_an = (c_set_mode_bipolar) ? c_map_cathod_channel_1 : c_map_cathod_channel_0;
`endif
							end
						end
					
						if (r_cb_on_1)
						begin
							if (|r_stim_comp_err_1)
							begin
`ifdef TRIAL_CASE
								c_stim_an = (c_set_mode_bipolar) ? c_map_cathod_channel_1 : c_map_cathod_channel_1;
`else
								c_stim_ca = (c_set_mode_bipolar) ? c_map_cathod_channel_0 : c_map_cathod_channel_1;
`endif
							end
							else
							begin
`ifdef TRIAL_CASE
								c_stim_ca = (c_set_mode_bipolar) ? c_map_cathod_channel_0 : c_map_cathod_channel_1;
`else
								c_stim_an = (c_set_mode_bipolar) ? c_map_cathod_channel_1 : c_map_cathod_channel_1;
`endif
							end
						end
				
						c_interval_phase_en = 1;
						c_interval_value = `CB_INIT_TIME;
						c_next_state = `ST_CB_M;
					end
				end
			default:;
		endcase
	end
	
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
		begin
			r_stim_an <= 0;
			r_stim_ca <= 0;
			
			r_stim_comp_en <= 0;
			r_stim_comp_err_0 <= 0;
			r_stim_comp_err_1 <= 0;
			
			r_cb_on_0 <= 0;
			r_cb_on_1 <= 0;
			
			r_stim_comp_en_n <= 1;
			
			r_interval_value <= 0;
		end
		else
		begin
			r_stim_an <= c_stim_an;
			r_stim_ca <= c_stim_ca;
			
			r_stim_comp_en <= c_stim_comp_en_n;
			r_stim_comp_err_0 <= c_stim_comp_err_0;
			r_stim_comp_err_1 <= c_stim_comp_err_1;
			
			r_cb_on_0 <= c_cb_on_0;
			r_cb_on_1 <= c_cb_on_1;
			
			r_stim_comp_en_n <= c_stim_comp_en_n;
			
			r_interval_value <= c_interval_value;
		end
	
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_interval_cnt <= 0;
		else
		if (c_interval_phase_en || w_interval_tmout)
			r_interval_cnt <= 0;
		else
		if (r_interval_phase)
		begin
			r_interval_cnt <= r_interval_cnt + 1;
		end
		
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_interval_phase <= 0;
		else
		if (c_interval_phase_en)
			r_interval_phase <= 1;
		else
		if (w_interval_tmout && r_interval_phase)
			r_interval_phase <= 0;
	
	assign w_interval_tmout = (r_interval_cnt[7:0] == r_interval_value);
	
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_cb_phase <= 0;
		else
		if (c_cb_phase_start_en)
			r_cb_phase <= 1;
		else
		if (c_cb_phase_end_en && r_cb_phase)
			r_cb_phase <= 0;
	
 endmodule
