# Pstrings-Assembly

<p align="center">
  <a href="#description">Description</a> •
  <a href="#to-run">To Run</a> •
</p>

## Description
This is an assembly project that done in course "Computer Structure" in Bar Ilan University.  
The goal of this project is to deepen understanding of advanced assembly concepts, with a specific emphasis on string manipulations.
  
Pstring is a struct that contains a string and its length:
```bash
typedef struct {
    char size;
    char string[255];
} Pstring;
```
This programm has 5 files:  
1. **Makefile** - A file containing instructions for building and managing the project. It automates the process of compiling and linking the program's source files.
2. **pstring.h** - This header file defines the `pstring` struct and the function prototypes for operations on pstrings. It provides the necessary declarations to work with pstrings throughout the program.
3. **main.c** - Responsible for receiving two pstrings and a user’s choice, initiating the program’s flow.
4. **pstring.s** - Implements a library of functions for manipulating pstrings. These functions are used by the other parts of the program to carry out operations on pstrings.
5. **func_select.s** -  Controls the flow of the program by executing the specific operation requested by the user based on their choice. A jump table is used to efficiently manage the user’s selection and perform the corresponding operations.  

Pstring has 4 function and each function has her case:  
* Case 31 - Prints the lengths of the two pstrings.
* Case 33 - Converts each character's case (capital to lowercase and vice versa), and prints the modified strings.
* case 34 - Receives two integers as start and end indices and copies the substring `src[i:j]` from the first pstring to `dst[i:j]` of the second pstring, printing the result.
* Case 35 - Concatenates the second pstring to the end of the first, if possible, and prints the result.

## To Run
1. Clone this repository.
2. On Linux (either a virtual machine or WSL), build the executables by running:
```bash
make
```
3. Run the program:
```bash
./pstrings
```