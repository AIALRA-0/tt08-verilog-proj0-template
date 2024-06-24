# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("开始")

    # 将时钟周期设置为10微秒（100 KHz）
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # 复位
    dut._log.info("复位")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("测试项目行为")

    # 设置你想测试的输入值
    dut.ui_in.value = 20
    dut.uio_in.value = 30

    # 等待一个时钟周期以查看输出值
    await ClockCycles(dut.clk, 1)

    # 以下断言只是一个检查输出值的示例。
    # 根据你模块的实际预期输出更改它：
    assert dut.uo_out.value == 50

    # 通过更改输入值、等待一个或多个时钟周期并断言预期输出值来继续测试模块。
