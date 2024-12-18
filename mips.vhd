------------------------------------------------------------------------------------------------------------
--
-- Implementation of MIPS
--
-- File name   : mips.vhd
--
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
  
entity mips is
    pORt (clock_mips	         : in  std_logic;
          reset_mips     : in  std_logic;
          memory_in_mips       : out std_logic_vector (31 downto 0);	-- data to write into memory (sw)
          memory_out_mips      : in  std_logic_vector (31 downto 0); -- data being read from memory (lw)
          memory_address_mips  : out std_logic_vector (31 downto 0);	-- memory address to read/write
          pc_mips              : out std_logic_vector (31 downto 0);	-- instruction address to fetch
          instruction_mips     : in std_logic_vector (31 downto 0);  -- instruction data to execute in the next cycle
          overflow_mips	   : out std_logic;  -- flag for overflow ------- (CORRECTED)
          invalid_mips         : out std_logic;  -- flag for invalid opcode ------- (ADDED)
	memory_write_mips    : out std_logic; 

	 pc4_mips: out std_logic_vector (31 downto 0);
 	 rt_mips, rd_mips, regrd_mips: out std_logic_vector (4 downto 0);
	 aluout_mips: out std_logic_vector (31 downto 0);
	 memout_mips: out std_logic_vector (31 downto 0);
	 rd1_mips, rd2_mips: out std_logic_vector (31 downto 0);
	 control_mips: out std_logic_vector (9 downto 0));
end entity;

architecture rtl of mips is

------ Signal Declaration ------
   signal pc_next, pc4	  : std_logic_vectOR (31 downto 0);     -- instruction address to fetch
   signal A, B    : std_logic_vectOR (31 downto 0);   -- ALU input values
   signal ALUOut	: std_logic_vectOR (31 downto 0);  -- ALU output value
   signal ALUctl	: std_logic_vectOR (3 downto 0);  -- ALU output value
	 signal overflow : std_logic;   -- overflow flag
	 signal invalid : std_logic;   -- invalid flag
	 signal Zero    : std_logic;       -- 1 bit signals fOR ALU arithmetic operations
	 signal pcsrc    : std_logic;
 	signal RegDst, RegWrite, MemWrite, ALUSrc, MemtoReg, Branch, Jump: std_logic; 
 	signal ALUOp: std_logic_vector(1 downto 0); 
 	signal regrd, wn, rt, rd, rs: std_logic_vector(4 downto 0); 
 	signal wd, rd1, rd2, jumpaddress, btgt: std_logic_vector(31 downto 0); 

------ Register file ---
   type register_type is array (0 to 31) of std_logic_vector(31 downto 0);
   signal Registers : register_type := (
   		0 => x"00000000", 
			4 => x"00000004",
			5 => x"00000084",
			6 => x"0000008c",
			7 => x"00000001",
			others => x"00000000");


------ Project 1 Signals (your code) ------
--	signal ?????

------ Component Declarations ------
component ALU_32
	pORt(
		A_alu32      : in std_logic_vectOR(31 downto 0);  -- A input
		B_alu32      : in std_logic_vectOR(31 downto 0);  -- B input
		ALUctl_alu32 : in std_logic_vectOR(3 downto 0);  	-- control
		ALUout_alu32 : out std_logic_vectOR(31 downto 0); -- result
		overflow_alu32: out std_logic; -- overflow result
		Zero_alu32   : out std_logic);  								  -- check if ALUout is zero
end component ;

begin

------ Component Instantiations ------
   ALU_32_1 : ALU_32
      pORt map ( A_alu32       => A,
                 B_alu32       => B,
                 ALUctl_alu32  => ALUctl,
				         ALUout_alu32  =>ALUout,
					       overflow_alu32=>overflow,
					       Zero_alu32    =>Zero);

      process(CLOCK_mips, reset_mips) begin
			-- Multiplexor Controlling Write Register Input
			
			 if(reset_mips = '1') then
             Registers(0) <= x"00000000";
             Registers(1) <= x"00000000";
             Registers(2) <= x"00000000";
             Registers(3) <= x"00000000";
             Registers(4) <= x"00000004";
             Registers(5) <= x"00000084";
             Registers(6) <= x"0000008c";
             Registers(7) <= x"00000001";
             Registers(8) <= x"00000000";
             Registers(8) <= x"00000000";
             Registers(9) <= x"00000000";
             Registers(10) <= x"00000000";
             Registers(11) <= x"00000000";
             Registers(12) <= x"00000000";
             Registers(13) <= x"00000000";
             Registers(14) <= x"00000000";
             Registers(15) <= x"00000000";
             Registers(16) <= x"00000000";
             Registers(17) <= x"00000000";
             Registers(18) <= x"00000000";
             Registers(18) <= x"00000000";
             Registers(19) <= x"00000000"; 	
				 
         elsif (RISING_EDGE(clock_mips)) then  -- FALLING_EDGE in Project 2
            if (RegWrite = '1') then
                  Registers(to_integer(unsigned(wn)))<= wd;
            end if;
         end if;
      end process;

		-- ******* FOR DEBUG	
		memout_mips <= memory_out_mips;
		aluout_mips <= ALUOut;
		regrd_mips <= RegRd;
		rt_mips <= rt;
		rd_mips <= rd;
		rd1_mips <= rd1;
		rd2_mips <= rd2;
		pc4_mips <= pc4;
		
		control_mips(9) <= RegDst;
		control_mips(8) <= ALUSrc;
		control_mips(7) <= MemtoReg;
		control_mips(6) <= RegWrite;
		control_mips(5) <= MemWrite;
		control_mips(4) <= Branch;
		control_mips(3 downto 2) <= ALUOp;
		control_mips(1) <= OVERFLOW;  --****************--
		control_mips(0) <= Jump;

------ Project 1 Signal Mapping (your code) ------		  
	ALUctl <= "0010";	-- ADD

------ Housekeeping (PC, A, B) ---------------------	
    A <= x"000A0000"; 
	  B <= x"00004090"; 
	  
    memory_in_mips <= ALUOut;
    
    invalid_mips <= invalid;
    overflow_mips <= overflow;
	  

	-- pc updates 
  pc_mips <= pc_next;
  pc4 <= pc_next + 4; 
  
  process (CLOCK_mips, reset_mips) 
  begin
    if(reset_mips = '1') then
        pc_next <= x"00000000";

    elsif(RISING_EDGE(CLOCK_mips)) then
        if (Jump = '1') then
            pc_next <= jumpaddress;
        elsif (PCSrc = '1') then
            pc_next <= btgt;
        else
            pc_next <= pc4;       -- instruction memory address (to fetch) increases by 4
        end if;
    else 
        pc_next <= pc_next;
    end if;
  end process;


end architecture;


