; Inndata Programmet leser inn to sifre skilt med ett eller flere mellomrom
; Utdata Programmet skriver ut summen av de to sifrene,
; forutsatt at summen er mindre enn 10.

; Konstanter
	cr equ 13 ; Vognretur
	lf equ 10 ; Linjeskift
	SYS_EXIT equ 1
	SYS_READ equ 3
	SYS_WRITE equ 4
	STDIN equ 0
	STDOUT equ 1
	STDERR equ 2

; Datasegment
section .bss
	siffer resb 4
	tier resb 1
	ener resb 1
	
; Datasegment
section .data
	meld db "Skriv to ensifrede tall skilt med mellomrom.",cr,lf
			db "Summen av tallene maa vaere mindre en 18.",cr,lf
	meldlen equ $ - meld
	feilmeld db cr,lf, "Skriv kun sifre!",cr,lf
	feillen equ $ - feilmeld
	crlf db cr,lf
	crlflen equ $ - crlf
	tall dd 10

; Kodesegment med Program
section .text

global _start
_start:
	mov edx,meldlen
	mov ecx,meld
	mov ebx,STDOUT
	mov eax,SYS_WRITE
	int 80h

	; Les tall, innlest tall returneres i ecx
	; Vellykket retur dersom edx = 0
	call lessiffer
	cmp edx,0 ; Test of vellykket innlesning
	jne Slutt ; Hopp til avsluttning ved feil i innlesning
	mov eax,ecx ; Første tall/siffer lagres i reg eax

	; Les andre tall/siffer
	; Vellykket: edx = 0, tall i ecx
	call lessiffer
	cmp edx,0 ; test om Vellykket innlesning
	jne Slutt
	mov ebx,ecx ; andre tall/siffer lagres is reg ebx

	add eax,ebx
	mov ecx,eax
	mov [tall],ecx ; Bruker tall for å lagre summen av de to tallene
	mov eax, [tall]
	mov ecx, 10
	div ecx
	mov [tier], al ; Lagrer 1 eller 0 avhengig av størrelsen på summen
	mov [ener], dl ; Lagrer siste tallet av summen, ett tall fra 0-9
	mov ecx,[tier]
	call skrivsiffer ; Skriver ut 0 eller 1 avhengig av om summen av siffrene er over 9
	mov ecx,[ener]
	call skrivsiffer ; Skriver ut det andre tallet av summen
	call nylinje ; Om det var med vilje eller ikke så var denne linjen over skrifsiffer i oppgaveteksten, jeg endret den til å være under for å få ett bedre svar i terminalen.

Slutt:
	mov eax,SYS_EXIT
	mov ebx,0
	int 80h
	
; ----------------------------------------------------------------------------------------------------------------------
skrivsiffer:
	; Skriver ut sifferet lagret i ecx. Ingen sjekk op verdiområde.
	push eax
	push ebx
	push ecx
	push edx
	add ecx, '0' ; converter tall til ascii.
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

; ----------------------------------------------------------------------------------------------------------------------
lessiffer:
	; Leter forbi alle blanke til neste ikke-blank
	; Neste ikke-blank returneres i ecx
	push eax
	push ebx

Lokke:
	; leser et tegn fra tastaturet
	mov eax,SYS_READ
	mov ebx,STDIN
	mov ecx,siffer
	mov edx,1
	int 80h
	mov ecx,[siffer]

	cmp ecx,' '
	je Lokke
	cmp ecx,'0' ; sjekk at tast er i område 0-9
	jb Feil
	cmp ecx,'9'
	ja Feil
	sub ecx,'0' ; konverter ascii til tall.
	mov edx,0 ; signaliserer vellykket innlesning
	pop ebx
	pop eax
	ret ; Vellykket retur
	
Feil:
	mov edx,feillen
	mov ecx,feilmeld
	mov ebx,STDERR
	mov eax,SYS_WRITE
	int 80h
	mov edx,1 ; Signaliserer mislykket innlesning av tall
	pop ebx
	pop eax
	ret ; mislykket retur

; ----------------------------------------------------------------------------------------------------------------------
; flytt cursor helt til venstre på neste linje
nylinje:
	push eax
	push ebx
	push ecx
	push edx
	mov edx, crlflen
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