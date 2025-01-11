# Kfir Eitan - 328494836
.section    .data

.section    .rodata
    invalid_option_msg: .asciz "invalid option!\n"
    invalid_input_msg: .asciz "invalid input!\n"
    cannot_concatenate_msg: .asciz "cannot concatenate strings!\n"

    len_msg: .asciz "length: "
    str_msg: .asciz "string: "
    first_len_msg: .asciz "first pstring length: "
    second_len_msg: .asciz "second pstring length: "
    comma: .asciz ", "

    int_format: .asciz "%d"
    scan_2int_format: .asciz "%d %d"
    open_new_line: .asciz "\n"

    help_str: .asciz "here\n"           # for debug only
    
    .align 8
    .jmp_table:
        .quad .pstrlen_label            # case 31
        .quad .invalid_option           # case 32
        .quad .swapCase_label           # case 33
        .quad .pstrijcpy_label          # case 34
        .quad .invalid_option           # case 35
        .quad .invalid_option           # case 36
        .quad .pstrcat_label            # case 37
    
.section    .bss



.section        .text
.extern         .pstrlen
.extern         .swapCase
.extern         .pstrijcpy
.extern         .pstrcat
.globl          run_func
.type           run_func, @function

    # user choice - in %rdi
    # pstring1 - in %rsi
    # pstring2 - in %rdx
    run_func:
        pushq   %rbp
        movq    %rsp,   %rbp

        subq $16, %rsp                      # save the pstrings locally
        movq %rsi, 16(%rbp)
        movq %rdx, 24(%rbp)         

        movl %edi, %eax                     # move the user choice to the eax register
        
        cmpl $30, %eax                      # if user choice <= 30 jump to invalid option label
        jle .invalid_option

        cmpl $38, %eax                      # if user choice >= 38 jump to invalid option label
        jge .invalid_option

        sub $31, %eax
        jmp *.jmp_table(, %eax, 8)          # jump to the corresponding function based on the user choice

        jmp end_run_func                    # jump to the end of the function

        

        # if the user choice is 31
        .pstrlen_label:
            movq 16(%rbp), %rdi            # move pstring1 to the %rdi register
            call .pstrlen                   # call the pstrlen function

            movq %rax, %r9                  # move the len of pstring1 to the r9 register

            lea first_len_msg, %rdi         # print the first pstring msg
            xor %rax, %rax                  
            call printf                     

            movq %r9, %rdi                  # move the result to the rdi register and print it
            call print_number

            lea comma, %rdi                 # print comma
            xor %rax, %rax
            call printf

            movq 24(%rbp), %rdi             # move the second pstring to the rdi
            call .pstrlen                   # call the pstrlen function

            movq %rax, %r9                  # move the len of pstring2 to the r9 register

            lea second_len_msg, %rdi        # print the second pstring msg
            xor %rax, %rax                  
            call printf                    

            movq %r9, %rdi                  # move the result to the rdi register
            call print_number

            call print_new_line              # print a new line
            
            jmp end_run_func                # jump to the end of the function


        # if the user choice is 33
        .swapCase_label:
            movq 16(%rbp), %rdi             # move pstring1 to the rdi
            call .pstrlen                   # call the pstrlen function, with the first string

            movq %rax, %r9                  # move the len of pstring1 to the r9 register

            lea len_msg, %rdi               # print "lenght: "
            xor %rax, %rax                  
            call printf                     

            movq %r9, %rdi                  # move the result to the rdi register
            call print_number               # print the length of pstring1

            lea comma, %rdi                 # print comma
            xor %rax, %rax
            call printf

            lea str_msg, %rdi               # print "string: "
            xor %rax, %rax
            call printf

            movq 16(%rbp), %rdi             # move the second pstring to the rdi
            call .swapCase                  # call the swapCase function, with the first string

            lea (%rax), %rdi               # move the pointer to the second char of pstring1 and print it
            incq %rdi
            xor %rax, %rax
            call printf

            call print_new_line             # print a new line

            # handle the second string

            movq 24(%rbp), %rdi             # move pstring2 to the rdi register
            call .pstrlen                   # call the pstrlen function, with the second string

            movq %rax, %r9                  # move the len of pstring2 to the r9 register

            lea len_msg, %rdi               # print "lenght: "
            xor %rax, %rax                  
            call printf                     

            movq %r9, %rdi                  # move the result to the rdi register
            call print_number               # print the length of pstring2

            lea comma, %rdi                 # print comma
            xor %rax, %rax
            call printf

            lea str_msg, %rdi               # print "string: "
            xor %rax, %rax
            call printf

            movq 24(%rbp), %rdi             # move the second string to the rdi register
            call .swapCase                  # call the swapCase function, with the second string

            lea (%rax), %rdi               # move the pointer to the second char of pstring2 and print it
            incq %rdi
            xor %rax, %rax
            call printf

            call print_new_line             # print a new line

            jmp end_run_func                # jump to the end of the function


        # if the user choice is 34
        .pstrijcpy_label:                   
            
            subq $48, %rsp

            # get the len of the strings
            movq 16(%rbp), %rdi                     # move the first pstring to rdi
            call .pstrlen                           # call the pstrlen function, with the first string
            decq %rax
            movq %rax, 32(%rbp)                     # move the len of pstring1 to the 32(%rbp) 

            movq 24(%rbp), %rdi                     # move the second pstring to rdi
            call .pstrlen                           # call the pstrlen function, with the second string
            decq %rax
            movq %rax, 40(%rbp)                     # move the len of pstring2 to the 40(%rbp) 

            # scan two numbers from the user
            lea scan_2int_format, %rdi              # scan two numbers and save them locally - i in 48(%rbp), j in 56(%rbp)
            leaq 48(%rbp), %rsi
            leaq 56(%rbp), %rdx
            xor %rax, %rax
            call scanf
            call getchar

            movq 16(%rbp), %rdi                     # load address of pstring1 into rdi
            movq 24(%rbp), %rsi                     # Load address of pstring2 into rsi
            movq 48(%rbp), %rdx                     # Load i into rdx
            movq 56(%rbp), %rcx                     # Load j into rcx


            # first we need to check that i>=0, i<=j, j<=min_length(pstring1, pstring2)
            
            cmpq $0, %rdx                           # if i<0, jump to the invalid_input_label
            jl invalid_input_label

            cmpq %rdx, %rcx                         # if i>j , jump to the invalid_input_label
            jl invalid_input_label                 

            cmpq 32(%rbp), %rcx                     # if j>len(pstring1), jump to the invalid_input_label
            jg invalid_input_label

            cmpq 40(%rbp), %rcx                     # if j>len(pstring2), jump to the invalid_input_label
            jg invalid_input_label

            # here the input is valid, we can start the function

            call .pstrijcpy                         # call the function to copy the string

            movq %rax, 16(%rbp)                     # enter the result instead of the original string

            jmp end_pstrijcpy                       # jump to the end 

            invalid_input_label:
                lea invalid_input_msg, %rdi         # print "Invalid input!"
                xor %rax, %rax
                call printf

            end_pstrijcpy:

            # ------- print the first string -------
            lea len_msg, %rdi                       # print "length: "
            xor %rax, %rax
            call printf

            movq 32(%rbp), %rdi                     # print the len of the str (add 1 because i dec 1 before)
            incq %rdi
            call print_number

            lea comma, %rdi                         # print ", "
            xor %rax, %rax
            call printf

            lea str_msg, %rdi                       # print "string: "
            xor %rax, %rax
            call printf

            mov 16(%rbp), %rbx                      # load the string and print it
            inc %rbx
            lea (%rbx), %rdi
            xorq %rax, %rax
            call printf

            call print_new_line

            # ------- print the second string -------
            lea len_msg, %rdi                       # print "length: "
            xor %rax, %rax
            call printf

            movq 40(%rbp), %rdi                     # print the len of the str (add 1 because i dec 1 before)
            incq %rdi
            call print_number

            lea comma, %rdi                         # print ", "
            xor %rax, %rax
            call printf

            lea str_msg, %rdi                       # print "string: "
            xor %rax, %rax
            call printf

            mov 24(%rbp), %rbx                      # load the string and print it
            inc %rbx
            lea (%rbx), %rdi
            xorq %rax, %rax
            call printf

            call print_new_line

            addq $48, %rsp                          # free the stack space

            jmp end_run_func                        # jump to the end of the function


        # if the user choice is 37
        .pstrcat_label:
            subq $32, %rsp

            # get the len of the strings
            movq 16(%rbp), %rdi                     # move the first pstring to rdi
            call .pstrlen                           # call the pstrlen function, with the first string
            movq %rax, 32(%rbp)                     # move the len of pstring1 to the 32(%rbp) 

            movq 24(%rbp), %rdi                     # move the second pstring to rdi
            call .pstrlen                           # call the pstrlen function, with the second string
            movq %rax, 40(%rbp)                     # move the len of pstring2 to the 40(%rbp)

            xorq %rbx, %rbx                         # set rbx to 0
            addq 32(%rbp), %rbx                     # add the len of pstring1
            addq 40(%rbp), %rbx                     # add the len of pstring2

            cmpq $254, %rbx
            jg invalid_label_pstrcat                # if the len is more than 254, jump to the invalid label

            movq 16(%rbp), %rdi                     # load address of pstring1 into rdi
            movq 24(%rbp), %rsi                     # Load address of pstring2 into rsi

            call .pstrcat                           # call the pstrcat function, with the two pstrings

            movq %rax, 16(%rbp)                     # enter the resolt instead of the original string

            xorq %rbx, %rbx                         # set rbx to 0
            addq 32(%rbp), %rbx                     # add the len of pstring1
            addq 40(%rbp), %rbx                     # add the len of pstring2

            movq %rbx, 32(%rbp)                     # change the len of the first pstring to the new len

            jmp end_pstrcat

            invalid_label_pstrcat:
                lea cannot_concatenate_msg, %rdi    # print "Cannot concatenate strings!"
                xor %rax, %rax
                call printf

            end_pstrcat:

            # ------- print the first string -------
            lea len_msg, %rdi                       # print "length: "
            xor %rax, %rax
            call printf

            movq 32(%rbp), %rdi                     # print the len of the str
            call print_number

            lea comma, %rdi                         # print ", "
            xor %rax, %rax
            call printf

            lea str_msg, %rdi                       # print "string: "
            xor %rax, %rax
            call printf

            mov 16(%rbp), %rbx                      # load the string and print it
            inc %rbx
            lea (%rbx), %rdi
            xorq %rax, %rax
            call printf

            call print_new_line

            # ------- print the second string -------
            lea len_msg, %rdi                       # print "length: "
            xor %rax, %rax
            call printf

            movq 40(%rbp), %rdi                     # print the len of the str
            call print_number

            lea comma, %rdi                         # print ", "
            xor %rax, %rax
            call printf

            lea str_msg, %rdi                       # print "string: "
            xor %rax, %rax
            call printf

            mov 24(%rbp), %rbx                      # load the string and print it
            inc %rbx
            lea (%rbx), %rdi
            xorq %rax, %rax
            call printf

            call print_new_line

                               
            addq $32, %rsp                          # free the stack space

            jmp end_run_func                        # jump to the end of the function


        # if the user choice is not in the menu
        .invalid_option:                    
            lea invalid_option_msg, %rdi    # load the msg to the %rdi
            xor %rax, %rax
            call printf                     # print the msg

        end_run_func:

        addq $16, %rsp

        movq    %rsp,   %rbp
        popq    %rbp
        ret
    
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


    print_number:
        pushq   %rbp
        movq    %rsp,   %rbp

        mov %rdi, %rsi              # load the the adrees in the %rdi to the %rsi
        lea int_format, %rdi   # load the adress of the str "%d" to the %rdi
        xor %rax, %rax              # clear the %rax
        call printf                 # print the number

        movq    %rsp,   %rbp
        popq    %rbp
        ret

    print_new_line:
        pushq   %rbp
        movq %rsp, %rbp

        lea open_new_line, %rdi     # load the adress of the str "\n" to the %rdi
        xor %rax, %rax              # initialize the rax
        call printf                 # print the new line

        movq    %rsp,   %rbp
        popq    %rbp
        ret
