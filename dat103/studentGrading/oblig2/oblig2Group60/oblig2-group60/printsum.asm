cr equ 13
lf equ 10
SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1
STDERR equ 2
section .bss
digit resb 4
section .data
report db "Write two single-digit numbers separated by a space.",cr,lf
db "the sum of the numbers must be greater than 10, but less than 18.",cr,lf
message equ $ - report
failreport db cr,lf, "write numbers only",cr,lf
failmessage equ $ - failreport
crlf db cr,lf
crlflen equ $ - crlf
section .text
global _start
_start:
mov byte [digit],0
mov edx,message
mov ecx,report
mov ebx,STDOUT
mov eax,SYS_WRITE
int 80h
call lessdigits
cmp edx,0
jne Stop
mov eax,ecx
call lessdigits
cmp edx,0
jne Stop
mov ebx,ecx
call newline
add eax,ebx
mov ecx,eax
call writedigits
Stop:
mov eax,SYS_EXIT
mov ebx,0
int 80h
writedigits:
push eax
push ebx
push ecx
push edx
push esi
push edi
mov esi,10
xor edi,edi
Toll2:
xor edx,edx
div esi
add dl,'0'
push edx
inc edi
test eax,eax
jnz Toll2
Writemessage:
cmp edi,0
jz Quit
pop edx
mov [digit],dl
mov ecx,digit
mov ebx,STDOUT
mov eax,SYS_WRITE
int 80h
dec edi
jnz Writemessage
Quit:
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax
ret
lessdigits:
push eax
push ebx
Toll:
mov eax,SYS_READ
mov ebx,STDIN
mov ecx,digit
mov edx,1
int 80h
mov ecx,[digit]
cmp ecx,' '
je Toll
cmp ecx,'0'
jb Fail
cmp ecx,'9'
ja Fail
sub ecx,'0'
mov edx,0
pop ebx
pop eax
ret
Fail:
mov edx,failmessage
mov ecx,failreport
mov ebx,STDERR
mov eax,SYS_WRITE
int 80h
mov edx,1
pop ebx
pop eax
ret
newline:
push eax
push ebx
push ecx
push edx
mov edx,crlflen
mov ecx,crlf
mov ebx,STDOUT
mov eax,SYS_WRITE
int 80h
pop edx
pop ecx
pop ebx
pop eax
ret