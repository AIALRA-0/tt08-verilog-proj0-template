/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // 专用输入
    output wire [7:0] uo_out,   // 专用输出
    input  wire [7:0] uio_in,   // IO: 输入路径
    output wire [7:0] uio_out,  // IO: 输出路径
    output wire [7:0] uio_oe,   // IO: 使能路径（高电平有效：0=输入，1=输出）
    input  wire       ena,      // 当设计上电时始终为1，因此可以忽略
    input  wire       clk,      // 时钟信号
    input  wire       rst_n     // 复位信号 - 低电平复位
);

  // 必须为所有输出引脚赋值。如果未使用，则赋值为0。
  assign uo_out  = ui_in + uio_in;  // 示例：uo_out是ui_in和uio_in的和
  assign uio_out = 0;
  assign uio_oe  = 0;

  // 列出所有未使用的输入以防止警告
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
