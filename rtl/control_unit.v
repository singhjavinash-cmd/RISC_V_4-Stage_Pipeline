module control_unit (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg alu_src,
    output reg branch,
    output reg jump,
    output reg [3:0] alu_control
);

    always @(*) begin
        reg_write   = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        mem_to_reg  = 1'b0;
        alu_src     = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        alu_control = 4'b0000;

        case (opcode)

            // R-type
            7'b0110011: begin
                reg_write = 1'b1;
                case (funct3)
                    3'b000: alu_control = (funct7 == 7'b0100000) ? 4'b0001 : 4'b0000;
                    3'b111: alu_control = 4'b0010;
                    3'b110: alu_control = 4'b0011;
                    3'b100: alu_control = 4'b0100;
                    3'b010: alu_control = 4'b0101;
                    3'b011: alu_control = 4'b0110;
                    3'b001: alu_control = 4'b0111;
                    3'b101: alu_control = (funct7 == 7'b0100000) ? 4'b1001 : 4'b1000;
                    default: alu_control = 4'b0000;
                endcase
            end

            // I-type arithmetic
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                case (funct3)
                    3'b000: alu_control = 4'b0000;
                    3'b111: alu_control = 4'b0010;
                    3'b110: alu_control = 4'b0011;
                    3'b100: alu_control = 4'b0100;
                    3'b010: alu_control = 4'b0101;
                    3'b011: alu_control = 4'b0110;
                    3'b001: alu_control = 4'b0111;
                    3'b101: alu_control = (funct7 == 7'b0100000) ? 4'b1001 : 4'b1000;
                    default: alu_control = 4'b0000;
                endcase
            end

            // LW
            7'b0000011: begin
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;
                alu_src    = 1'b1;
            end

            // SW
            7'b0100011: begin
                mem_write = 1'b1;
                alu_src  = 1'b1;
            end

            // Conditional branches
            7'b1100011: begin
                branch = 1'b1;
                case (funct3)
                    3'b000, 3'b001: alu_control = 4'b0001; // BEQ/BNE
                    3'b100, 3'b101: alu_control = 4'b0101; // BLT/BGE
                    3'b110, 3'b111: alu_control = 4'b0110; // BLTU/BGEU
                    default: alu_control = 4'b0001;
                endcase
            end

            // JAL
            7'b1101111: begin
                reg_write = 1'b1;
                jump = 1'b1;
            end

            // JALR
            7'b1100111: begin
                reg_write = 1'b1;
                jump = 1'b1;
                alu_src = 1'b1;
            end

            default: begin
            end
        endcase
    end

endmodule