# Makefile
# 有关更多信息，请参见 https://docs.cocotb.org/en/stable/quickstart.html

# 参数设置
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = project.v

ifneq ($(GATES),yes)

# RTL仿真:
SIM_BUILD				= sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))
COMPILE_ARGS 		+= -I$(SRC_DIR)

else

# 门级仿真:
SIM_BUILD				= sim_build/gl
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DFUNCTIONAL
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
COMPILE_ARGS    += -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# 这个文件是由GDS动作工作流复制的
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# 包含测试台源文件:
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# MODULE 是Python测试文件的基本名?
MODULE = test

# 包含cocotb的make规则以处理仿真器设置
include $(shell cocotb-config --makefiles)/Makefile.sim
