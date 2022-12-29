# VerilogProgram
The Verilog HDL code does the following:
* The input is two selection inputs, and two signed integers in 2's complement form: A and B, each integer is 3-bits.  
* The output is a signed integer in 2's complement from: G, its size is 3-bits.  
* When the selection inputs are 00, G = A-1  
* When the selection inputs are 01, G = A+B  
* When the selection inputs are 10, G = A-B  
* When the selection inputs are 11, G = -B  
  
Sample output:  
  
![output sample](https://user-images.githubusercontent.com/108128985/209972463-f8c5637a-bded-4ba4-ba6b-eab53fb9b98e.PNG)
