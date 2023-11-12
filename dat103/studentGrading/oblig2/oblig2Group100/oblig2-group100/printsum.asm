; Constants for system calls and file descriptors
CR equ 13               ; Carriage Return
LF equ 10               ; Line Feed
EXIT equ 1
READ equ 3
WRITE equ 4
STDIN equ 0
STDOUT equ 1
STDERR equ 2

; Uninitialized data section
section .bss
  num resb 2

; Initialized data section
section .data
  invite db "Input two single-digit numbers with a space:", LF
  invLen equ $ - invite
  errMsg db CR, LF, "Digits only, please!", LF
  errLen equ $ - errMsg
  newLine db LF
  newLineLen equ $ - newLine

; Text section with program code
section .text
global _start

_start:
  ; Display the prompt
  mov edx, invLen
  mov ecx, invite
  mov ebx, STDOUT
  mov eax, WRITE
  int 80h
  
  ; Read the first number
  call getNumber
  cmp edx, 0               
  jnz endProg             
  mov eax, ecx             
  
  ; Read the second number
  call getNumber
  cmp edx, 0               
  jnz endProg             
  add eax, ecx             
  call lineFeed
  cmp eax, 10              ; Check if the sum is less than 10
  jge endProg
  mov ecx, eax
  call printNumber         

endProg:
  mov eax, EXIT
  xor ebx, ebx
  int 80h

; Subroutines go here
; ... (other subroutines with the same functionality, possibly renamed)

; ---------------------------------------------------------
getNumber:
  ; Read a single character and convert it to a number
  ; ...

lineFeed:
  ; Output a line feed to STDOUT
  ; ...

printNumber:
  ; Print the number in ecx if it's a single digit
  ; ...

; End of _start section