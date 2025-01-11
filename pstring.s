.section    .rodata
    str1: .asciz "pstrlen:\n"
    str2: .asciz "swapCase:\n"
    str3: .asciz "pstrijcpy:\n"
    str4: .asciz "pstrcat:\n"

.section    .text

.globl          .pstrlen
.globl          .swapCase
.globl          .pstrijcpy
.globl          .pstrcat

.type           .pstrlen, @function
.type           .swapCase, @function
.type           .pstrijcpy, @function
.type           .pstrcat, @function


    # return the length of the string
    # the string in the rdi
    .pstrlen:
        pushq   %rbp
        movq    %rsp,   %rbp

        # Initialize the length counter
        xorq %rax, %rax                     # rax = 0, it will hold the length

        loop_start:
            cmpb $0, (%rdi)                 # Compare the current byte with 0 (null terminator)
            je loop_end                     # If null, jump to the end of the loop
            inc %rax                        # Increment the length counter
            inc %rdi                        # Move to the next character
            jmp loop_start                  # Repeat the loop

        loop_end:

        dec %rax                            # Decrement the length counter because we went past the null terminator
        
        movq    %rsp,   %rbp
        popq    %rbp
        ret

    # return new string with all characters in swapCase
    # the string in the rdi
    .swapCase:
        pushq   %rbp
        movq    %rsp,   %rbp

        # Initialize the rax - adress of the string
        movq %rdi, %r10                         # Get the string address from the rdi

        loop2: 
            cmpb $0, (%r10)                     # Compare the current byte with 0 (null terminator)
            je loop_end2                        # If null, jump to the end of the loop

            cmpb $'a', (%r10)                   # Compare the current byte with 'a'
            jge swap_case_upper                 # If the byte is greater than 'a', jump to swap_case_upper

            cmpb $'A', (%r10)                   # Compare the current byte with 'A'
            jl continue_loop2                   # If the byte is less than 'A', jump to continue_loop2

            cmpb $'Z', (%r10)                   # Compare the current byte with 'Z'
            jg continue_loop2                   # If the byte is greater than 'Z', jump to continue_loop2

            addb $32, (%r10)                    # if the char in low case, add 32 to it
            jmp continue_loop2                  # Jump to the next iteration

            swap_case_upper:                    # If the byte is greater than 'a', change it to lower case
                cmpb $'z', (%r10)               # Compare the current byte with 'z'
                jg continue_loop2               # if the char is not in the range of 'a' to 'z', jump to the next iteration
                subb $32, (%r10)                # if the char is in the range of 'a' to 'z, change the case
            
            continue_loop2:
                inc %r10                        # Move to the next character
                jmp loop2                       # Repeat the loop
        
        loop_end2: 


        movq %rdi, %rax       
        
        movq    %rsp,   %rbp
        popq    %rbp
        ret

    # pstring1 - rdi, pstring2 - rsi, i - rdx, j - rcx.
    .pstrijcpy:
        pushq   %rbp
        movq    %rsp,   %rbp

        movq %rdi, %r10                         # Get the string address 1 from the rdi
        movq %rsi, %r11                         # Get the string address 2 from the rsi
        xorq %rbx, %rbx                         # Initialize the rbx to 0, it will be used as a counter

        incq %rdx
        incq %rcx

        loop3:
            cmp %rcx, %rbx                      # Compare the counter with j
            jg end_loop3                        # If the counter > j, jump to end_loop3

            cmp %rdx, %rbx                      # Compare the counter with i
            jl continue_loop3                   # If the counter < i, jump to continue_loop3

            # if we got here, then - i <= counter <= j, and we need to copy the char
            movb (%r11), %al                    # Load the byte from %r10 into %al
            movb %al, (%r10)                    # Store the byte from %al into %r11

            continue_loop3:
                incq %r10                        # Move to the next character
                incq %r11                        # Move to the next character
                incq %rbx                        # Increment the counter
                jmp loop3                        # Repeat the loop
        
        end_loop3:

        movq %rdi, %rax                         # Return the address of the new string

        movq    %rsp,   %rbp
        popq    %rbp
        ret

    # string* dst - %rdi, string* src - %rsi
    .pstrcat:
        pushq   %rbp
        movq    %rsp,   %rbp

        movq %rdi, %r10                         # move the src pointer to the r10
        movq %rsi, %r11                         # move the dst pointer to the r11

        loop4:
            cmpb $0, (%r10)                
            je end_loop4                        # if the pointer points to the end of the string, jump to end_loop4

            incq %r10                           # move to the next character
            jmp loop4                           # repeat the loop

        end_loop4:    

        # now the r10 points to the end of the src string
        incq %r11

        copy_loop:
            cmpb $0, (%r11)
            je end_copy_loop                    # if the pointer points to the end of the second string, jump to end_copy_loop

            movb (%r11), %al                    # Load the byte from %r10 into %al
            movb %al, (%r10)                    # Store the byte from %al into %r11

            incq %r10                           # Move to the next character
            incq %r11                           # Move to the next character
            jmp copy_loop                       # Repeat the loop

        end_copy_loop:

        movb $0, (%r10)                         # Add a null terminator to the end of the string

        movq %rdi, %rax                         # Return the address of the new string

        movq    %rsp,   %rbp
        popq    %rbp
        ret

