//***************************************************************************
// 
// Filename: charGen.sv
//
// Author: Tristan Timothy
// Description: Character Generator. Can take a .mem file as a parameter to 
// initialize the memory. Uses a character memory and char_addr, to store 
// characters that are sent as an input. Uses the font_rom.sv, pixel_x and 
// pixel_y to determine how to output the character pixel by pixel.
//
//****************************************************************************/

module charGen #(parameter FILENAME = "")(
    output logic pixel_out,
    input logic clk, char_we, 
    input logic [11:0] char_addr, 
    input logic [7:0] char_value,
    input logic [9:0] pixel_x, 
    input logic [8:0] pixel_y);

    logic [7:0] mem_data[0:4095];
    logic [7:0] char_read_value, data;
    logic [11:0] char_read_addr;
    logic [8:0] pixel_y_d;
    logic [10:0] font_rom_addr;
    logic [9:0] pixel_x_d, pixel_x_dd;

    //Initially sets mem_data
    initial begin
        if (FILENAME != "")
            $readmemh(FILENAME, mem_data, 0);
    end

    //If write enabled put char_value into mem_data
    always_ff @(posedge clk) begin
        if(char_we)
            mem_data[char_addr]<=char_value;
    end

    //Take out the character at the address
    always_ff @(posedge clk) begin
        char_read_value<=mem_data[char_read_addr];
    end

    //Assign the character address appropriately
    assign char_read_addr={pixel_y[8:4],pixel_x[9:3]};

    //Delay pixel Y
    always_ff @(posedge clk) begin
        pixel_y_d<=pixel_y;
    end

    //Assign the font address appropriately
    assign font_rom_addr={char_read_value[6:0],pixel_y_d[3:0]};

    //Instance the font_rom to get the correct character
    font_rom Font_Rom (.clk(clk),.addr(font_rom_addr),.data(data));

    //Delay pixel X
    always_ff @(posedge clk) begin
        pixel_x_d<=pixel_x;
        pixel_x_dd<=pixel_x_d;
    end

    //Multiplexer for pixel_out
    assign pixel_out =
        (pixel_x_dd[2:0]==7)? data[0]:
        (pixel_x_dd[2:0]==6)? data[1]:
        (pixel_x_dd[2:0]==5)? data[2]:
        (pixel_x_dd[2:0]==4)? data[3]:
        (pixel_x_dd[2:0]==3)? data[4]:
        (pixel_x_dd[2:0]==2)? data[5]:
        (pixel_x_dd[2:0]==1)? data[6]:
        (pixel_x_dd[2:0]==0)? data[7]:
        0;


endmodule