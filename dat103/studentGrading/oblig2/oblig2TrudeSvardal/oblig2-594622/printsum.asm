; Inndata Programmet leser inn to sifre skilt med ett eller flere mellomrom
; Utdata Programmet skriver ut summen av de to sifrene,
; foutsatt at summen er mindre enn 10.

; Konstanter
	cr equ 13 ; Vognretur
	lf equ 10 ; Linjeskift
	SYS_EXIT  equ 1
	SYS_READ  equ 3
	SYS_WRITE equ 4
	STDIN	  equ 0
	STDOUT	  equ 1
	STDERR	  equ 2

; Datasegment
section .bss
	siffer resb 4
	siffer1 resb 4

; Datasegment
section .data
	meld db "Skriv to ensifrede tall skilt med mellomrom.",cr,lf
	     db "Summen av tallene maa vaere mindre enn 18.",cr,lf
	meldlen equ $ - meld
	feilmeld db cr,lf, "Skriv kun sifre!",cr,lf
	feillen equ $ - feilmeld
	crlf db cr,lf
	crlflen equ $ - crlf


; Kodesegment med program
section .text

global _start
_start:
	mov edx,meldlen
	mov ecx,meld
	mov ebx,STDOUT
	mov eax,SYS_WRITE
	int 80h

	; Les tall, innlest tall returneres i ecx
	; Vellykket retur dersom edx=0
	call lessiffer
	cmp edx,0	; Test om vellykket innlesing
	jne Slutt	; Hopp tilavslutning ved feil i innlesing
	mov eax,ecx	; Første tall/siffer lagres i reg eax

	; Les andre tall/siffer
	; vellykket: edx=0, tall i ecx
	call lessiffer
	cmp edx,0	; Test om vellykket innlesning
	jne Slutt
	mov ebx,ecx	; andre tall/siffer lagres i reg ebx

	call nylinje
	add eax,ebx
	mov ecx,eax
	call skrivsiffer ; Skriv ut verdi i ecx som ensifret tall

Slutt:
	mov eax,SYS_EXIT
	mov ebx,0
	int 80h

; ---------------------------------------------------------------------------
skrivsiffer:
	; Skriver ut sifferet lagret i ecx.

	push eax
	push ebx
	push ecx
	push edx

	; Sjekk på verdiområde
        ; Les verdien fra minnet og sjekker om verdien er mellom 10 og 18
	
	; Dersom verdien er under 10, hopper den til ikke_tosifret	
	cmp ecx, 10
	jl ikke_tosifret 
	
	; dersom verdien er mellom 10-18 fortsetter den her
	cmp ecx, 19
	jge ikke_tosifret

	sub ecx, 10
	inc ah
	add ecx,'0'
	mov [siffer], cl
	add ah,'0'
	mov [siffer1], ah
	
	mov ebx, STDOUT
	
	; skriver ut 10er tallet
	lea ecx, siffer1
	mov edx, 1
	mov eax, SYS_WRITE
	int 80h
	
	; skriver ut 1er tallet
	lea ecx, siffer
	mov eax, SYS_WRITE
	int 80h
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret


ikke_tosifret:
	add ecx,'0' ; converter tall til ascii.
	mov [siffer],ecx
	mov ecx,siffer
	mov edx,1
	mov ebx,STDOUT
	mov eax,SYS_WRITE
	int 80h
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

; ---------------------------------------------------------------------------
lessiffer:
	; Leter forbi alle blanke til neste ikke-blank
	; Neste ikke-blank returneres i ecx
	push eax
	push ebx

Lokke:
	; Leser et tegn fra tastaturet
	mov eax,SYS_READ
	mov ebx,STDIN
	mov ecx,siffer
	mov edx,1
	int 80h
	mov ecx,[siffer]

	cmp ecx,' ' 
	je Lokke
	cmp ecx,'0' ; Sjekk at tast er i område 0-9
	jb Feil
	cmp ecx,'9'  
	ja Feil
	sub ecx,'0' ; Konverter ascii til tall.
	mov edx,0   ; signaliser vellykket innlesing
	pop ebx
	pop eax
	ret         ; Vellykket retur

Feil:
	mov edx,feillen
	mov ecx,feilmeld
	mov ebx,STDERR
	mov eax,SYS_WRITE
	int 80h
	mov edx,1   ; Signaliser mislykket innlesing av tall
	pop ebx
	pop eax
	ret         ; Mislykket retur

; ----------------------------------------------------------------------------
; Flytt cursor helt til venstre på neste linje
nylinje:
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

; End _start
