[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/ucl8Jb97)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=16904548&assignment_repo_type=AssignmentRepo)
# starter-lab-5

Starter code for CPEN 211 Lab 5

See the Lab 5 handout on Piazza for details of what you need to do and what files
need to be included.  

DE1_SoC.qsf includes pins assignments (import in Quartus before synthesis using the 
same procedure used for pb-pins.csv outline in the HDL tutorial). Do not modify this
file.

Use lab5_top.sv to demo/test your design on your DE1-SoC (read the comments at the
top of the file for how to use it).  

Use lab5_autograder_check.sv to test your code is compatible with the autograder
that will be used to assign marks for your submission.  
WARNING: The purpose of the checker file is NOT to tell you if your code is ``correct''.
If your code does not passing the checks in this file means your code
will certainly get zero marks for the autograded portion.
Passing the checks in 
this file DOES NOT mean your code will get full marks.  Your code can pass these
checks and get zero marks.  You still need to test your code using your own
test benches!

Below is a (potentially incomplete) summary of files you need to add (check the 
lab 5 handout instructions for details on what goes in these and any other
necessary files):

1. Your synthesizable and testbench code in files named:
- regfile.sv
- regfile_tb.sv
- alu.sv
- alu_tb.sv
- shifter.sv
- shifter_tb.sv
- datapath.sv
- datapath_tb.sv

2. A Quartus Project File (.qpf) and the associated
Quartus Settings File (.qsf) that indicates which Verilog files are part of
your project when compiling for your DE1-SoC. This .qsf file is created by Quartus when you create a project.
It is typically named <top_leve_module_name>.qsf (e.g., lab5_top.qsf) and 
contains lines indicating which Verilog files are to be synthesized.

2. A Modelsim Project File (.mpf) for your testbench simulations including
all synthesizable code files.

3. The binary output file (.sof), generated from your synthesizable SystemVerilog
 used to program your DE1-SoC.  Your TAs may ask you to use the .sof generated when the 
autograder synthesizes your design, if we have it available in time. However, include
the one you generated as a backup to speed up the marking process during your demo.  

# CPEN 211 Lab 5 - Required Files Checklist

checklist for required files

## 1. Synthesizable and Testbench Code
- [x] `regfile.sv` - Contains the synthesizable code for the register file.
- [x] `regfile_tb.sv` - Testbench for the `regfile` module.
- [x] `alu.sv` - Contains the synthesizable code for the ALU (Arithmetic Logic Unit).
- [x] `alu_tb.sv` - Testbench for the `alu` module.
- [x] `shifter.sv` - Contains the synthesizable code for the shifter.
- [x] `shifter_tb.sv` - Testbench for the `shifter` module.
- [x] `datapath.sv` - Contains the synthesizable code for the datapath.
- [x] `datapath_tb.sv` - Testbench for the `datapath` module.

## 2. Quartus Project Files
- [x] **.qpf** (Quartus Project File) - Defines the structure of the project in Quartus.
- [x] **.qsf** (Quartus Settings File) - DE1_SoC.qsf is provided and includes pin assignments. Ensure it includes all necessary Verilog files for synthesis.

## 3. Modelsim Project File
- [x] **.mpf** (Modelsim Project File) - Manages testbench simulations and includes all synthesizable code files.

## 4. Binary Output File
- [x] **.sof** (Binary output file) - Used to program the DE1-SoC. Include the generated `.sof` file as a backup for grading.
- [x] **.do** (Waveform file) - For all test benches

---

