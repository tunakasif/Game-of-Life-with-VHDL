# Game-of-Life-with-VHDL
Implementation of John Conway’s Game of Life is created on a FPGA board with VHDL, for the course EEE102 - Introduction to Digital Design in Bilkent University 

Video Demonstration: https://youtu.be/yiSuvMy-zL4

Summary of the project:
In this project, implementation of John Conway’s Game of Life is created on a FPGA board with VHDL. Despite the name, Game of Life is more like a simulation; user defines an initial condition which describes a cell population that will be simulated. No further input is needed to observe the consequences of the simulation. User defines an initial condition and observes how the system evolves. The rules of the simulation are determined by the Cambridge mathematician John Conway and these rules create a logical system for determining the fate of the cell population. Implementation of this logical system is handled by the FPGA board and the condition of the system is displayed on a monitor via VGA port of the board.

For further information see the report specified in the repository, which you can find every detail about the project.

Things to know:
The project is uploaded as a Vivado Project, so you can use Xilinx Vivado Design Suite to edit and alter the code according to your needs. On the other hand, source files can be found under the directory game_of_life/game_of_life.srcs/sources_1/new/ for the users who do not prefer Vivado. Last but not least, constraints for this project is created in order to have functionality over the FPGA board called BASYS3. Thus, for using this code in another board you need to create your own constraints according to your board. Also if your board's VGA output isn't 4-bits per colour, then you need to adjust "vga_controller" and "vga_display" modules under the directory game_of_life/game_of_life.srcs/sources_1/new/ accordingly.

