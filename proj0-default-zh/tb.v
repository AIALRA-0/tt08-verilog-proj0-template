`default_nettype none
`timescale 1ns / 1ps

/* 这个测试平台仅实例化模块并创建一些方便的信号线
   这些信号线可以被 cocotb 的 test.py 驱动/测试。
*/
module tb ();

  // 将信号转储到 VCD 文件中。你可以使用 gtkwave 查看它。
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // 连接输入和输出：
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // 将 tt_um_example 替换为你的模块名：
  tt_um_example user_project (

      // 包含门级测试的电源端口：
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif

      .ui_in  (ui_in),    // 专用输入
      .uo_out (uo_out),   // 专用输出
      .uio_in (uio_in),   // IO: 输入路径
      .uio_out(uio_out),  // IO: 输出路径
      .uio_oe (uio_oe),   // IO: 使能路径（高电平有效: 0=输入, 1=输出）
      .ena    (ena),      // 使能 - 当设计被选择时为高电平
      .clk    (clk),      // 时钟
      .rst_n  (rst_n)     // 非复位
  );

endmodule
