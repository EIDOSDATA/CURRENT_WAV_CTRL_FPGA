`timescale 1ns/10ps
// FSM1 STATUS
`define ST_INIT			(3'd0) /* 000 */
`define ST_NORMAL		(3'd1) /* 001 */
`define ST_RUN			(3'd2) /* 010 */
`define ST_ERROR		(3'd3) /* 011 */
// FSM2 STATUS >> PULSE
`define ST_PULSE_IDLE	(3'd4) /* 101 */
`define ST_ANODE_LV		(3'd5) /* 110 */
`define ST_CATHODE_LV	(3'd6) /* 111 */
`define ST_INTERPHASE	(3'd7) /* 111 */

`define IDLE_TIME_50MS			(3'd0) /* 00 */
`define IDLE_TIME_100MS			(3'd1) /* 001 */
`define IDLE_TIME_200MS			(3'd2) /* 010 */
`define IDLE_TIME_300MS			(3'd3) /* 011 */
`define IDLE_TIME_400MS			(3'd4) /* 100 */
`define IDLE_TIME_600MS			(3'd5) /* 101 */
`define IDLE_TIME_800MS			(3'd6) /* 110 */
`define IDLE_TIME_1000MS		(3'd7) /* 111 */

`define DUTY_TIME_50MS			(3'd0) /* 00 */
`define DUTY_TIME_100MS			(3'd1) /* 001 */
`define DUTY_TIME_200MS			(3'd2) /* 010 */
`define DUTY_TIME_300MS			(3'd3) /* 011 */
`define DUTY_TIME_400MS			(3'd4) /* 100 */
`define DUTY_TIME_600MS			(3'd5) /* 101 */
`define DUTY_TIME_800MS			(3'd6) /* 110 */
`define DUTY_TIME_1000MS		(3'd7) /* 111 */

/*
    duty     duty     duty     duty
	_____    _____    _____    _____
IDLE|   |20us|   |IDLE|   |20us|   |IDLE
____|   |____|   |____|   |____|   |____
<------rate-----><------rate------><------rate----->
*/
// PULSE TIME DEFINITION
`define INTERPHASE_TIME					(333) 	/* CONST VALUE 100us */
`define MIN_IDLE_TIME					(333) 	/* CONST VALUE 100us */
`define CURRENT_SOURCE_INTERVAL_TIME	(17)	/* CONST VALUE 5us */

`define NOM_FREQ ("3.33")
	
/* Lattice XP2 internal Oscillator */	
/* NOM_FREQ: 2.08(default),2.15,2.22,2.29,2.38,2.46,2.56,2.66,2.77,2.89,
   3.02,3.17,3.33,3.50,3.69,3.91,4.16,4.29,4.43,4.59,4.75,4.93,5.12,5.32,5.54,
   5.78,6.05,6.33,6.65,7.00,7.39,7.82,8.31,8.58,8.87,9.17,9.50,9.85,10.23,10.64,
   11.08,11.57,12.09,12.67,13.30,14.00,14.78,15.65,16.63,17.73,19.00,20.46,
   22.17,24.18,26.60,29.56,33.25,38.00,44.33,53.20,66.50,88.67,133.00 MHz 
*/

module ci_stim_fpga_wrapper (
	/**
	- FPGA related signals
	*/
	/* INPUT PORTS */
	i_rst_n,
	i_start_btn,
	i_stop_btn,
	i_duty,
	i_idle,
	
	/* OUTPUT PORTS */
	// PULSE OUTPUT
	o_ano_top,
	o_ano_bot,
	o_cat_top,
	o_cat_bot,
	o_curr_ena, // CURRENT SOURCE CONTROL
	
	// LED OUTPUT
	o_led
) /* synthesis syn_force_pads=1 syn_noprune=1*/;
	/**
	- FPGA related signals
	*/
	/* INPUT PORTS */
	input i_rst_n/* synthesis LOC="69" IO_TYPE="LVCMOS33" PULLMODE="UP" */;
	input i_start_btn/* synthesis LOC="69" IO_TYPE="LVCMOS33" PULLMODE="UP" */;
	input i_stop_btn/* synthesis LOC="69" IO_TYPE="LVCMOS33" PULLMODE="UP" */;
	input [2:0] i_duty/* synthesis LOC="69" IO_TYPE="LVCMOS33" PULLMODE="UP" */;
	input [2:0] i_idle/* synthesis LOC="25,24,21,20" IO_TYPE="LVCMOS33,LVCMOS33,LVCMOS33,LVCMOS33" PULLMODE="DOWN,DOWN,UP,UP" */; // 0011
	// EOF INPUT PORTS
	
	/* OUTPUT PORTS */
	output [3:0] o_ano_top/* synthesis LOC="64" IO_TYPE="LVCMOS33" PULLMODE="NONE" */;
	output [3:0] o_ano_bot/* synthesis LOC="65" IO_TYPE="LVCMOS33" PULLMODE="NONE" */;
	output [3:0] o_cat_top/* synthesis LOC="66" IO_TYPE="LVCMOS33" PULLMODE="NONE" */;
	output [3:0] o_cat_bot/* synthesis LOC="67" IO_TYPE="LVCMOS33" PULLMODE="NONE" */;
	output [3:0] o_curr_ena/* synthesis LOC="68" IO_TYPE="LVCMOS33" PULLMODE="NONE" */;
	output [2:0] o_led/* synthesis LOC="68" IO_TYPE="LVCMOS33" PULLMODE="NONE" */;
	// EOF OUTPUT PORTS
	
	/* OUTPUT PORT */
	reg [3:0] r_ano_top;
	reg [3:0] r_ano_bot;
	reg [3:0] r_cat_top;
	reg [3:0] r_cat_bot;
	reg [3:0] r_curr_ena;
	reg [2:0] r_led;
	/* Combinational Logic to Flip-Flop */
	reg [3:0] c_ano_top;
	reg [3:0] c_ano_bot;
	reg [3:0] c_cat_top;
	reg [3:0] c_cat_bot;
	reg [3:0] c_curr_ena;
	reg [2:0] c_led;
	// EOF OUTPUT PORT
	
	/* INPUT SET VALUE REG */
	reg [23:0] r_duty;
	reg [23:0] r_idle;
	
	reg [23:0] r_duty_val;
	reg [23:0] r_idle_val;
	// EOF INPUT REG
	
	/* STATE & TIME */
	reg [2:0] r_state;
	reg [2:0] c_next_state;
	// EOF STATE & TIME
	
	/* STATE SIGNAL */
	reg r_init_ok = 0;
	reg r_run_state = 0; // START: 1 /  STOP : 0
						 // START and STOP value
	reg r_idle_phase;
	reg r_anode_phase;
	reg r_cathod_phase;
	reg r_interphase;
	/* Combinational Logic to Flip-Flop */
	reg c_run_phase_en;
	reg c_idle_phase_en;
	reg c_anode_phase_en;
	reg c_cathod_phase_en;
	reg c_interphase_en;
	// EOF STATE SIGNAL
	
	/* COUNTER */
	reg [23:0] r_idle_cnt;
	reg [23:0] r_duty_cnt;
	reg [23:0] r_interphase_cnt;
	// EOF COUNTER

	/*------------------------------------------------------------------------------*/
	/* Output assignments */
	/*------------------------------------------------------------------------------*/
	//assign o_debug_led = {w_bcg_fsm_start,w_rate_tmout,r_cathod_phase,r_interphase,r_anode_phase,r_state};
	//assign o_debug_led = r_search_disabled_channel | (r_search_disabled_channel_phase << 7) | c_map_cathod_channel;
	//assign o_debug_led = {r_search_disabled_channel_phase,w_search_disabled_channel_phase_end_p,r_stim_bcg1_sel,c_disabled_dac_sel};
	assign o_ano_top = r_ano_top;
	assign o_ano_bot = r_ano_bot;
	assign o_cat_top = r_cat_top;
	assign o_cat_bot = r_cat_bot;
	assign o_curr_ena = r_curr_ena;
	assign o_led = r_led;
	/* END OF Output assignments */
		
	
	/* internal wires and regs */
	/* IMPORTANT NOTES 
	  for specifying clock constraints, let SynplifyPro keep this wire name during synthesis by using this attribute
	*/
	wire w_clk 		/* synthesis syn_keep = 1 */;	
	/**
	- 1) Lattice IP instantiation
	    * Generates internal Clock and Reset
	*/
`ifdef SIMULATION
	/* Lattice GSR */
	//gsr GSR_INST (.gsr(i_rst_n));
		
	/* Lattice XP2 internal Oscillator */
	wire w_force_clk;

	assign w_clk = w_force_clk;
	//osch #(.NOM_FREQ(`NOM_FREQ))  internal_osc (.osc(w_clk));

`else
	/* Lattice GSR */
	/* GSR and PUR should make the instance name with pre-defined name which is "GSR_INST" and "PUR_INST" in each.
	   It is because their output is generated by Lattice tool and routed to all registers by the tool and so 
	   the tool should be able to find the instance automatically. This is the reason why instance name is fixed. */
	GSR GSR_INST (.GSR(i_rst_n));

//`define XO2

`ifdef XO2

	OSCH #(.NOM_FREQ(`NOM_FREQ))  internal_osc (.STDBY(1'b0), .OSC(w_clk), .SEDSTDBY());
`else

	/* Lattice XP2 internal Oscillator */	
	OSCE #(.NOM_FREQ(`NOM_FREQ))  internal_osc (.OSC(w_clk));
`endif
`endif	

	/* �Է¿� ���� IDLE �� ���� �ø��÷� */
	always @(posedge w_clk or negedge i_rst_n)
	begin
		if (~i_rst_n) begin			
			r_idle_val <= 0;			
		end
		
		else begin
			case (i_idle)
				`IDLE_TIME_50MS:
					begin
						r_idle_val <= 166666;
					end
				`IDLE_TIME_100MS:
					begin
						r_idle_val <= 333333;
					end
				`IDLE_TIME_200MS:
					begin
						r_idle_val <= 666666;
					end
				`IDLE_TIME_300MS:
					begin
						r_idle_val <= 999999;
					end
				`IDLE_TIME_400MS:
					begin
						r_idle_val <= 1333333.2;
					end
				`IDLE_TIME_600MS:
					begin
						r_idle_val <= 1999999.8;
					end
				`IDLE_TIME_800MS:
					begin
						r_idle_val <= 2666666.4;
					end
				`IDLE_TIME_1000MS:
					begin
						r_idle_val <= 3333333;
					end
				default:;
			endcase
		end
	end
	
	/* �Է¿� ���� DUTY �� ���� �ø��÷� */
	always @(posedge w_clk or negedge i_rst_n)
	begin
		if (~i_rst_n) begin
			r_duty_val <= 0;
		end
		
		else begin
			case (i_duty)
				`DUTY_TIME_50MS:
					begin
						r_duty_val <= 166666;
					end
				`DUTY_TIME_100MS:
					begin
						r_duty_val <= 333333;
					end
				`DUTY_TIME_200MS:
					begin
						r_duty_val <= 666666;
					end
				`DUTY_TIME_300MS:
					begin
						r_duty_val <= 999999;
					end
				`DUTY_TIME_400MS:
					begin
						r_duty_val <= 1333333.2;
					end
				`DUTY_TIME_600MS:
					begin
						r_duty_val <= 1999999.8;
					end
				`DUTY_TIME_800MS:
					begin
						r_duty_val <= 2666666.4;
					end
				`DUTY_TIME_1000MS:
					begin
						r_duty_val <= 3333333;
					end
				default:;
			endcase
		end
	end
	
	/* ��� �ʱ�ȭ �� ��ư ���� */
    always @(posedge w_clk or negedge i_rst_n or negedge i_start_btn or negedge i_stop_btn)
	begin
		if (~i_rst_n) begin
			r_run_state <= 0;
			r_ano_top <= 0;
			r_ano_bot <= 0;
			r_cat_top <= 0;
			r_cat_bot <= 0;	
			r_curr_ena <= 0;
			r_init_ok <= 1;
		end
		
		// START BTN
		else if (~i_start_btn) begin
			r_run_state <= 1;			
		end
		
		// STOP BTN
		else if (~i_stop_btn) begin
			r_idle_cnt <= 0;
			r_duty_cnt <= 0;
			r_interphase_cnt <= 0;
			
			r_idle <= 0;
			r_duty <= 0;
			r_run_state <= 0;
		end
		
		// RUN ���¿��� ���� �����Ѵ�.
		else if(c_run_phase_en) begin
			r_idle <= r_idle_val;
			r_duty <= r_duty_val;
		end
	end	
	
	/* ���¿� ���� ���� ī���� �ʿ��� */
	always @(posedge w_clk or negedge i_rst_n)
	begin
		if (~i_rst_n) begin	
			r_idle <= 0;
			r_duty <= 0;
			
			r_idle_cnt <= 0;
			r_duty_cnt <= 0;
			r_interphase_cnt <= 0;
			
			r_idle_phase <= 0;
			r_anode_phase <= 0;
			r_interphase <= 0;
			r_cathod_phase <= 0;			
		end		
				
		// IDLE COUNTER
		else if(c_idle_phase_en) begin
			r_duty_cnt <= 0;
			r_idle_phase <= 1;
			r_idle_cnt = r_idle_cnt + 1;
		end
		// ANODE PULSE DUTY COUNTER
		else if(c_anode_phase_en) begin
			r_idle_cnt <= 0;
			r_anode_phase <= 1;			
			r_duty_cnt = r_duty_cnt + 1;
		end		
		// INTERPHASE COUNTER
		else if(c_interphase_en) begin
			r_duty_cnt <= 0;
			r_interphase <= 1;
			r_interphase_cnt = r_interphase_cnt + 1;
		end		
		// CATHOD PULSE DUTY COUNTER
		else if(c_cathod_phase_en) begin
			r_interphase_cnt <= 0;			
			r_cathod_phase <= 1;
			r_duty_cnt = r_duty_cnt + 1;
		end
	end
	
	/* ī���� �� �� */	
	always @(posedge w_clk or negedge i_rst_n)
	begin
		if (~i_rst_n) begin			
			r_idle_phase <= 0;
			r_anode_phase <= 0;
			r_cathod_phase <= 0;
			r_interphase <= 0;
		end
		// IDLE COMPARE
		else if(r_idle == r_idle_cnt) begin
			r_idle_phase <= 0;
		end		
		// DUTY COMPARE
		else if(r_duty == r_duty_cnt) begin
			r_anode_phase <= 0;
			r_cathod_phase <= 0;
		end		
		// INTERPHASE COMPARE
		else if(`INTERPHASE_TIME == r_interphase_cnt) begin
			r_interphase <= 0;
		end
	end
	
	/* FSM START POINT */
	always @(posedge w_clk or negedge i_rst_n)
	begin
		if (~i_rst_n) begin
			r_led[0] <= 1;
			r_state <= `ST_INIT;
		end		
		else begin
			r_led[0] <= 0;
			r_state <= c_next_state;
		end
	end
	
	/* STATE CONTROL */
	/* Combinational Logic */	
	always @(*)
	begin
		c_run_phase_en = 0;
		c_idle_phase_en = 0;
		c_anode_phase_en = 0;
		c_cathod_phase_en = 0;	
		c_interphase_en = 0;
		
		c_next_state = r_state;
		
		c_ano_top = 0;
		c_ano_bot = 0;
		c_cat_top = 0;
		c_cat_bot = 0;
		c_curr_ena = 0;
		c_led = 0;
		
		case (r_state)
			`ST_INIT:
				begin
					if (!r_init_ok) begin
						c_next_state = `ST_INIT;
					end
					
					else begin
						c_next_state = `ST_NORMAL;
					end
				end
			`ST_NORMAL:
				begin
					// START SIGNAL
					if (r_run_state == 1) begin
						c_run_phase_en = 1; // VALUE SETTING SINGNAL
						c_next_state = `ST_RUN;
					end
					
					else begin
						c_next_state = `ST_NORMAL;
					end
				end
			`ST_RUN:
				begin
					// VALUE CHECK
					if (r_idle != 0 && r_duty != 0) begin
						c_idle_phase_en = 1;
						c_next_state = `ST_PULSE_IDLE;
					end
					
					else begin
						c_next_state = `ST_RUN;
					end
				end
				
			/* START PULSE GENERATE */
			`ST_PULSE_IDLE:
				begin
					if (r_idle_phase) begin
						c_next_state = `ST_PULSE_IDLE;
					end
					
					// STOP ��ư�� ���� ��� ���������޽��� 1�� ��� �� IDLE���� ����
					else if (r_run_state == 0) begin
						c_run_phase_en = 0; // VALUE SETTING SINGNAL
						c_next_state = `ST_NORMAL;
					end
					
					// IDLE ������ ANODE�� �Ѿ��
					else begin
						c_anode_phase_en = 1;
						c_next_state = `ST_ANODE_LV;
					end
				end
			`ST_ANODE_LV:
				begin
					if (r_anode_phase) begin
						c_ano_top = 1;
						c_ano_bot = 1;						
						c_next_state = `ST_ANODE_LV;
					end
					
					else begin						
						// ANODE ������ INTERPHASE�� �Ѿ��
						c_interphase_en = 1;
						c_next_state = `ST_INTERPHASE;
					end
				end
			`ST_INTERPHASE:
				begin
					if (r_interphase) begin
						c_next_state = `ST_INTERPHASE;
					end
					
					else begin 
						// INTERPHASE ������ CATHODE�� �Ѿ��
						c_cathod_phase_en = 1;
						c_next_state = `ST_CATHODE_LV;
					end
				end
			`ST_CATHODE_LV:
				begin
					if (r_cathod_phase) begin
						c_cat_top = 1;
						c_cat_bot = 1;
						c_next_state = `ST_CATHODE_LV;
					end
					
					else begin						
						// CATHODE ������ IDLE�� �Ѿ��
						c_idle_phase_en = 1;
						c_next_state = `ST_PULSE_IDLE;
					end
				end
				/* EOF START PULSE GENERATE */				
			default:;
		endcase
	end
endmodule