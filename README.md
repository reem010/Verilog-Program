# VerilogProgram
the Verilog HDL code does the following:
* The input is two selection inputs, and two signed integers in 2's complement form: A and B, each integer is 3-bits.  
* The output is a signed integer in 2's complement from: G, its size is 3-bits.  
* When the selection inputs are 00, G = A-1  
* When the selection inputs are 01, G = A+B  
* When the selection inputs are 10, G = A-B  
* When the selection inputs are 11, G = -B  
  
sample output:  

![verligoo](https://user-images.githubusercontent.com/108128985/209969517-84f25041-11f8-4ae0-83bf-226f35f39ff4.PNG)
