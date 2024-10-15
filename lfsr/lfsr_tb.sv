`timescale 100ps/100ps

module lfsr_tb();
    parameter N = 32;  // Register bit-width
    
    // Module signals
    logic CLK;
    logic INIT;
    logic GO;
    logic [N-1:0] SEED;
    logic [N-1:0] Q;
    
    // Clock period
    parameter CLK_PERIOD = 10;
    
    lfsr32 #(.N(N)) dut (
        .CLK(CLK),
        .INIT(INIT),
        .GO(GO),
        .SEED(SEED),
        .Q(Q)
    );
    
    // Clock generation
    always #(CLK_PERIOD / 2) CLK = ~CLK;
 
    
////////////////////////////////////////////////////////////////////////////////    
// Task to test sync initialization
////////////////////////////////////////////////////////////////////////////////
    task test_initialization(input logic [N-1:0] TestVector);
        logic [N-1:0] Response;
        $display("Testing sync initialization: TestVector = %h", TestVector);
        INIT = 0;
        GO = 0;
        SEED = TestVector;
        #(CLK_PERIOD);
        
        INIT = 1;
        #(CLK_PERIOD);
        INIT = 0;
        #(CLK_PERIOD);
        
        Response = Q;
        if (Response == TestVector) begin
            $display("Sync initialization successful: %h", Response);
        end else begin
            $display("Sync initialization error: %h, %h", Response, TestVector);
        end
    endtask


////////////////////////////////////////////////////////////////////////////////    
// Task to test storage mode
////////////////////////////////////////////////////////////////////////////////
    task test_storage(input logic [N-1:0] RandomSeed);
        logic [N-1:0] TestResponse1, TestResponse2;
        INIT = 0;
        GO = 0;
        SEED = RandomSeed;
        #(CLK_PERIOD);
        
        INIT = 1;
        #(CLK_PERIOD);
        INIT = 0;
        #(CLK_PERIOD);
        
        GO = 1;
        #(CLK_PERIOD);
        GO = 0;
        #(CLK_PERIOD);

        TestResponse1 = Q;
        #(CLK_PERIOD);
        TestResponse2 = Q;
        
        if (TestResponse1 == TestResponse2) begin
            $display("Storage mode successful: %h, %h", 
                                                  TestResponse1, TestResponse2);
        end else begin
            $display("Storage mode error: %h, %h", TestResponse1,TestResponse2);
        end
    endtask


////////////////////////////////////////////////////////////////////////////////    
// Task to test generation mode
////////////////////////////////////////////////////////////////////////////////
    task test_generation(input logic [N-1:0] RandomValue);
        logic [N-1:0] TestVector, Response, WResponse;
        TestVector = RandomValue & 'hFFFFFFFE;  // Clear the LSB
        $display("Testing generation mode: TestVector = %h", TestVector);
        
        INIT = 0;
        GO = 0;
        SEED = TestVector;
        #(CLK_PERIOD);
        
        INIT = 1;
        #(CLK_PERIOD);
        INIT = 0;
        #(CLK_PERIOD);
        
        GO = 1;
        #(CLK_PERIOD);
        GO = 0;
        #(CLK_PERIOD);
        
        Response = Q;
        WResponse = (Response << 1) & 'hFFFFFFFE;// Shift response and clear LSB
        
        if (TestVector == WResponse) begin
            $display("Generation successful: %h, %h", TestVector, WResponse);
        end else begin
            $display("Generation error: %h, %h", TestVector, WResponse);
        end
    endtask


////////////////////////////////////////////////////////////////////////////////
// Test
////////////////////////////////////////////////////////////////////////////////    
    initial begin
        // Initialize signals
        CLK = 0;
        INIT = 0;
        GO = 0;
        SEED = 0;
      
        
////////////////////////////////////////////////////////////////////////////////        
// Initialization tests
////////////////////////////////////////////////////////////////////////////////
        test_initialization(32'h00000000);
        test_initialization(32'h12345678);
        test_initialization(32'h9ABCDEF0);
        test_initialization($random);
     
        
////////////////////////////////////////////////////////////////////////////////        
// Storage tests
////////////////////////////////////////////////////////////////////////////////
        test_storage($random);


////////////////////////////////////////////////////////////////////////////////        
// Generation tests
////////////////////////////////////////////////////////////////////////////////
        test_generation($random);
        
        $finish;  
    end
endmodule