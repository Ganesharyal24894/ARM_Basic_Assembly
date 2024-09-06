# Basic ARM Assembly Code Examples
This repository contains minimal ARM assembly code examples demonstrating fundamental programming techniques. Each branch provides progressively advanced examples of bare-metal ARM programming.

## Repository Structure
The repository is organized into three branches, each illustrating different aspects of ARM programming. Examples run without a startup file and use default or custom GNU linker scripts where specified.

Branches Overview
### main branch :

Description: The simplest example.
Functionality: Blinks an LED using a basic ARM assembly program.
Linker Script: Utilizes the default GNU linker script.

### delay_var branch :

Description: A step up from the main branch.
Functionality: Initializes the .data section from flash to RAM and blinks an LED with a delay based on a variable in RAM.
Linker Script: Uses a custom linker script to handle the .data section properly.

### input_button branch :

Description: Builds upon the delay_var example by adding input handling.
Functionality: Reads an input button at pin PA8. If the button is pressed, it toggles an LED on pin PC13.
Linker Script: Uses its own custom linker script to manage initialization and memory layout.
