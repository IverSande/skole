cr equ 13
lf equ 10

section .data
message db `Hello World`,cr,lf
length equ $ - message

section .text
global _start

_start:
mov edx, length
mov ecx, message
mov ebx,1
mov eax,4
int 80h
mov ebx,0
mov eax,1
int 80h

