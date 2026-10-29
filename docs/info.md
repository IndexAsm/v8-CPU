<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

It's a custom 8-bit CPU on a custom architecture.

## How to test

To use it you must connect a0-a9 to an eeprom's address pins, d0-d3 to eeprom's data pins and RW to eeprom's RW pin; If eeprom has 2 separater pins (OE, W), then 1 should be connected via a not gate;


### Instruction set


| Binary Opcode | Instruction | Parameters           | Description                                              |
|---------------|-------------|----------------------|----------------------------------------------------------|
| 00000000      | halt        | None                 | Stops processor execution                                |
| 00000001      | movai       | Immediate Value      | Move immediate value into Register A                     |
| 00000010      | movbi       | Immediate Value      | Move immediate value into Register B                     |
| 00000011      | addab       | None                 | Add Register B to Register A                             |
| 00000100      | subab       | None                 | Subtract Register B from Register A                      |
| 00000101      | movamem     | Memory Address       | Move data from memory into Register A                    |
| 00000110      | movbmem     | Memory Address       | Move data from memory into Register B                    |
| 00000111      | movab       | None                 | Copy value from Register B to Register A                 |
| 00001000      | movba       | None                 | Copy value from Register A to Register B                 |
| 00001001      | cmpab       | None                 | Compare Register A and Register B                        |
| 00001010      | je          | CS Offset, Target IP | Jump if equal (loads new CS offset, then target IP)      |
| 00001011      | jne         | CS Offset, Target IP | Jump if not equal (loads new CS offset, then target IP)  |
| 00001100      | ja          | CS Offset, Target IP | Jump if above (loads new CS offset, then target IP)      |
| 00001101      | jb          | CS Offset, Target IP | Jump if below (loads new CS offset, then target IP)      |
| 00001110      | jmp         | CS Offset, Target IP | Unconditional jump (loads new CS offset, then target IP) |
| 00001111      | andab       | None                 | Bitwise AND of Register A and Register B                 |
| 00010000      | orab        | None                 | Bitwise OR of Register A and Register B                  |
| 00010001      | nota        | None                 | Bitwise NOT of Register A                                |
| 00010010      | notb        | None                 | Bitwise NOT of Register B                                |
| 00010011      | inca        | None                 | Increment Register A by 1                                |
| 00010100      | deca        | None                 | Decrement Register A by 1                                |
| 00010101      | incb        | None                 | Increment Register B by 1                                |
| 00010110      | decb        | None                 | Decrement Register B by 1                                |
| 00010111      | movcsi      | Immediate Value      | Move immediate value to Code Segment                     |
| 00011000      | movdsi      | Immediate Value      | Move immediate value to Data Segment                     |
| 00011001      | movssi      | Immediate Value      | Move immediate value to Stack Segment                    |
| 00011010      | movas       | Stack Offset         | Move value from stack to Register A                      |
| 00011011      | movbs       | Stack Offset         | Move value from stack to Register B                      |
| 00011100      | movsa       | Stack Offset         | Move Register A value to stack                           |
| 00011101      | movsb       | Stack Offset         | Move Register B value to stack                           |
| 00011110      | movspi      | Immediate Value      | Move immediate value into Stack Pointer                  |
| 00011111      | movbpi      | Immediate Value      | Move immediate value into Base Pointer                   |
| 00100000      | subspi      | Immediate Value      | Subtract immediate value from Stack Pointer              |
| 00100001      | addspi      | Immediate Value      | Add immediate value to Stack Pointer                     |
| 00100010      | subbpi      | Immediate Value      | Subtract immediate value from Base Pointer               |
| 00100011      | addbpi      | Immediate Value      | Add immediate value to Base Pointer                      |
| 00100100      | addai       | Immediate Value      | Add immediate value to Register A                        |
| 00100101      | subai       | Immediate Value      | Subtract immediate value from Register A                 |
| 00100110      | addbi       | Immediate Value      | Add immediate value to Register B                        |
| 00100111      | subbi       | Immediate Value      | Subtract immediate value from Register B                 |
| 00101000      | movspa      | None                 | Move Stack Pointer to Register A                         |
| 00101001      | movasp      | None                 | Move Register A to Stack Pointer                         |
| 00101010      | movbpa      | None                 | Move Base Pointer to Register A                          |
| 00101011      | movabp      | None                 | Move Register A to Base Pointer                          |


### Segment Registers
This architecture has 3 segment registers. They increase memory from 16B to 256B.
- <b>CS (Code Segment)</b>: Holds the base address for the memory region where executable program instructions are stored.
- <b>DS (Data Segment)</b>: Holds the base address for global variables, and general memory operations.
- <b>SS (Stack Segment)</b>: Holds the base address for the stack region used in combination with the Stack Pointer.


## External hardware

- parrarel EEPROM (or flash, ram is optional)
