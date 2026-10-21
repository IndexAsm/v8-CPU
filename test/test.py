# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

from program import memory, ORIGIN
 
MAX_CYCLES = 10000


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    await ClockCycles(dut.clk, 2, False)


    # Wait for one clock cycle to see the output values

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    mem = list(memory)

    cycles = 0
    while (int(dut.uio_out.value) & 0b10000) == 0:
        addr = int(dut.uo_out.value)
        if (int(dut.uio_out.value) & 0b10000000) == 0:
            dut.uio_in.value = mem[addr]
        else:
            mem[addr] = int(dut.uio_out.value) & 0b1111
        await ClockCycles(dut.clk, 1, False)
 
        cycles += 1
        assert cycles < MAX_CYCLES, "CPU never halted"
 
    dut._log.info(f"CPU halted after {cycles} cycles")




    """
    memory = [0 for i in range(256)]


    #memory[2] = 1;memory[3] = 0; memory[4] = 0b1101     # movai   0b1101
    #memory[5] = 2;memory[6] = 0; memory[7] = 0b0010     # movbi   0b0010
    #memory[8] = 3;memory[9] = 0;                        # addb
    memory[2] = 0b1000; memory[3] = 0b0001; memory[4] = 0b0010      #movdsi     0b0010
    memory[5] = 5; memory[6] = 0; memory[7] = 0b1000                # movamem   0b1000


    memory[0b00101000] = 0b1001
    
    assert dut.uo_out.value == 2
    while (int(dut.uio_out.value) & 0b10000 == 0):
        if (int(dut.uio_out.value) & 0b10000000 == 0):
            dut.uio_in.value = memory[dut.uo_out.value]
        else: 
            memory[dut.uo_out.value] = dut.uio_out.value & 0b1111
        await ClockCycles(dut.clk, 1, False)
    """
    """
    assert dut.uo_out.value == 2
    dut.uio_in.value = 1
    await ClockCycles(dut.clk, 1, False)
    dut.uio_in.value = 0
    assert dut.uo_out.value == 3
    await ClockCycles(dut.clk, 2, False)
    assert dut.uo_out.value == 4
    dut.uio_in.value = 0b1101
    await ClockCycles(dut.clk, 2, False)
    dut.uio_in.value = 2
    await ClockCycles(dut.clk, 1, False)
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 2, False)
    assert dut.uo_out.value == 7
    dut.uio_in.value = 0b0001
    await ClockCycles(dut.clk, 2, False)
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 1, False)
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 2, False)
    assert dut.uo_out.value == 9
    await ClockCycles(dut.clk, 1, False)
    dut.uio_in.value = 6
    await ClockCycles(dut.clk, 1, False)
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 2, False)
    dut.uio_in.value = 0b0101
    await ClockCycles(dut.clk, 1, False)
    assert dut.uo_out.value == 0b0101
    dut.uio_in.value = 0b1100
    await ClockCycles(dut.clk, 2, False)
    assert dut.uo_out.value == 13

    """




    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
