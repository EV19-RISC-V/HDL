LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all; 
USE WORK.EV19_Types.all;

ENTITY DePipelineReg IS 
    PORT
    (
        -- Señales de control
        RegWrite_DE     :  IN  STD_LOGIC;
        WbSource_DE     :  IN  STD_LOGIC;
        MemSize_DE      :  IN  MemSize_t;
        MemOp_DE        :  IN  MemOp_t;
        AluOp_DE        :  IN  AluOp_t;
        AluSrcA_DE      :  IN  AluSourceA_t;
        AluSrcB_DE      :  IN  AluSourceB_t; 
        BranchType_DE   :  IN  BranchType_t;
        CompareType_DE  :  IN  CompareType_t;
 
        -- Señales para las otras etapas
        Rs1Data_DE      :  IN  word_t;              
        Rs2Data_DE      :  IN  word_t;  
 
        Immediate_DE    :  IN  word_t;                  
     
        Rs1_DE          :  IN  regIndex_t;          
        Rs2_DE          :  IN  regIndex_t;          
        Rd_DE           :  IN  regIndex_t;      
 
        PC_DE           :  IN  Word_t;
		  Predict_DE      :  IN  STD_LOGIC;
		  State_DE        :  IN  Byte_t;
        ---------------------------------------------------------------         
                -- Señales de control
        RegWrite_EX     :  OUT  STD_LOGIC;
        WbSource_EX     :  OUT  STD_LOGIC;
        MemSize_EX      :  OUT  MemSize_t;
        MemOp_EX        :  OUT  MemOp_t;
        AluOp_EX        :  OUT  AluOp_t;
        AluSrcA_EX      :  OUT  AluSourceA_t;
        AluSrcB_EX      :  OUT  AluSourceB_t; 
        BranchType_EX   :  OUT  BranchType_t;
        CompareType_EX  :  OUT  CompareType_t;
 
        -- Señales para las otras etapas
        Rs1Data_EX      :  OUT  word_t;              
        Rs2Data_EX      :  OUT  word_t;  
 
        Immediate_EX    :  OUT  word_t;                  
     
        Rs1_EX          :  OUT  regIndex_t;          
        Rs2_EX          :  OUT  regIndex_t;          
        Rd_EX           :  OUT  regIndex_t;      
 
        PC_EX           :  OUT  Word_t;
		  Predict_EX      :  OUT  STD_LOGIC;
		  State_EX        :  OUT  Byte_t;
		  
		  -- Control del registro de pipeline
        clk             :  IN  STD_LOGIC;
        reset           :  IN  STD_LOGIC;
        flush           :  IN  STD_LOGIC;
        stall           :  IN  STD_LOGIC
    );
END DePipelineReg;

ARCHITECTURE behaviour OF DePipelineReg IS 
begin

    Rs1Data_EX    <= Rs1Data_DE; -- Esta latcheado a la salida de RegFile!!!
    Rs2Data_EX    <= Rs2Data_DE; -- Esta latcheado a la salida de RegFile!!!

    
    process(clk)
    begin
        if rising_edge(clk) then
					 Predict_EX    <= Predict_DE;
					 State_EX      <= State_DE;	 
            if reset = '1' or flush = '1' then
                RegWrite_EX   <= '0';
                WbSource_EX   <= '0';
                MemSize_EX    <= (others=>'0');
                MemOp_EX      <= (others=>'0');
                AluOp_EX      <= (others=>'0');
                AluSrcA_EX    <= '0';
                AluSrcB_EX    <= '0';
                BranchType_EX <= (others=>'0');
                CompareType_EX<= (others=>'0');
               -- Rs1Data_EX  <= (others=>'0');
               -- Rs2Data_EX  <= (others=>'0');
                Immediate_EX  <= (others=>'0');
                Rs1_EX        <= (others=>'0');
                Rs2_EX        <= (others=>'0');
                Rd_EX         <= (others=>'0');
                PC_EX         <= (others=>'0');
					 --Predict_EX    <= '0';
					 --State_EX      <= (others=>'0');
            elsif stall = '1' then
                
            elsif stall = '0' then
                RegWrite_EX   <= RegWrite_DE;
                WbSource_EX   <= WbSource_DE;
                MemSize_EX    <= MemSize_DE; 
                MemOp_EX      <= MemOp_DE;   
                AluOp_EX      <= AluOp_DE;   
                AluSrcA_EX    <= AluSrcA_DE; 
                AluSrcB_EX    <= AluSrcB_DE; 
                BranchType_EX <= BranchType_DE;
                CompareType_EX<= CompareType_DE;
               -- Rs1Data_EX    <= Rs1Data_DE; 
               -- Rs2Data_EX    <= Rs2Data_DE; 
                Immediate_EX  <= Immediate_DE;
                Rs1_EX        <= Rs1_DE;     
                Rs2_EX        <= Rs2_DE;     
                Rd_EX         <= Rd_DE;      
                PC_EX         <= PC_DE;    
					 --Predict_EX    <= Predict_DE;
					 --State_EX      <= State_DE;	 
            end if;
        end if;
    end process;

END behaviour;