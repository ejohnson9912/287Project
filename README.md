# BattleBoard

ECE287 Final Project for Dr. Jamieson's Fall 2021 Section B <br>
<b>Authors: [Rob Lytton](https://github.com/RobLytton) ('24) & [Erik Johnson](https://erik.omg.lol) ('24) </b>

## Project Description
---
Our project is a 2-player turn-based strategy game inplementing a PS2 keyboard as an input and a VGA display as output. The goal is to defeat the other player by attacking.

## Background
---
For our project, we wanted to replicate Rob's own personal game he had programmed in Java. The original game was a side-project with the inspration being to further explore the use of Java, and to create a lineup of characters akin to the Marvel Cinematic Universe.

The game is played on a grid of squares output on a VGA output. Each player is a character that has its own unique set of abilities and base stats. The game is played in a turn-based fashion. Each player takes their turn to move and attack. The turn ends when one player is done attacking, allowing the other player a chance to move and attack. The game ends when one player's health reaches 0. The winner is the player with the highest health value.

## Design
---
### VGA Output
VGA Output is controlled via a driver module that uses an address translator to translate x and y coordinates to a pixel address in the VGA memory space. It also accepts a color value and writes it to the pixel. (Depending on the size of the color values and the sizes of pixels, the FPGA may run out of memory.) To avoid any issues with memory, the color values are 3 bits, therefore the VGA output is limited to 8 colors. (black, white, red, green, blue, yellow, cyan, and magenta)

### PS/2 Keyboard Input
The PS/2 Keyboard is connected to the FPGA via its onboard PS/2 port. The signals from the keyboard are sent as 8-bit values to the FPGA. Referencing the datasheet for the keyboard and the PS/2 Protocol, the values for the specific keys we need were hardcoded into the controller. The arrow keys are used to adjust the position of the characters and cycle through attacks. The enter key is used to confirm the attack and movement of the characters.

### LCD Display 
The Altera DE2-115 FPGA board has an onboard 16 character x 2-line liquid crystal display (LCD). The Hitachi HD44780 (in this instance) has specific controls for different functions and has 36 spaces for 5x8 dot characters. The LCD driver module accepts a 256 bit character string and writes it to the LCD.

## Video Demo
---
//TODO: [Link to video demo](https://www.youtube.com/watch?v=dQw4w9WgXcQ)

## Credits
---
LCD Controller - Isaac Budde // TODO: Add link to Isaac's GitHub
VGA Controller - [Sibo](https://github.com/dongsibo/cscb58-project)