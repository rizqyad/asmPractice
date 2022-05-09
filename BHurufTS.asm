%INCLUDE "consolesatu.inc"

;VARIABEL DECLARATION
;------------------------------------------------------------------------------------------------
section .data 		

judul		db "Length of String", 0 
teks1           db 13,10,13,10," Write Text     : ", 0 
pteks1		dd 0 
teks2           db 13,10,13,10," Text Length    : ", 0 
pteks2		dd 0 
teks3           db 13,10,13,10," Again {y/n} : ", 0 
pteks3		dd 0 



buff		resb 255
nul		db 0
buff_len	dd 256

strhasil	db '      ',0
str_len		db 6

section .bss 	;; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1
hBytes          resd 1

; MAIN PROGRAM
;================================================================================================
section .text use32 
..start: 

ULANGI:

	initconsole judul, hStdOut, hStdIn				; CREATE CONSOLE
	display_text teks1, pteks1, nBytes, hStdOut		; DISPLAY TEXT MESSAGE
	call read_text									; READ TEXT FROM KEYBOARD
    
    call HitungKarakter
	call Numeric2Str								; CONVERT NUMERIK TO STRING

	display_text teks2, pteks2, nBytes, hStdOut		; DISPLAY TEXT MESSAGE
	call display_text_length						; DISPLAY RESULT   

	display_text teks3, pteks3, nBytes, hStdOut		; DISPLAY TEXT MESSAGE
	call read_text
	mov ebx, buff
	mov al, [ebx]
	cmp al, 'y'

	je ULANGI

	quitconsole										; CLEAR CONSOLE
;=================================================================================================

read_text:
			;; membaca string dari Console(keyboard) dg ReadFile
push dword 0 		;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 	;; parameter ke 4 jumlah byte yg sesungguhnya terbaca (TERMASUK ENTER)
push dword [buff_len] 	;; parameter ke 3 panjang buffer yg disediakan
push dword buff 	;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdIn] 	;; parameter ke 1 handle stdin
call [ReadFile] 			
ret
;--------------------------------------------------------------------------------------------------
display_text_length:
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [str_len] 		;; parameter ke 3 panjang string
push dword strhasil		;; parameter ke 2 string yang akan ditampilkan 
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 
ret
;--------------------------------------------------------------------------------------------------

; MENGKONVERSI NUMERIK (iBytes) KE STRING (strhasil) 
;-------------------------------------------------------------------------------------
Numeric2Str:
	mov ebx, strhasil	;; hasil konversi disimpan di strhasil
 loop1:				
	mov byte[ebx],32
	inc ebx			    ;; ebx digunakan sebagai pointer ke strhasil
	cmp byte[ebx],0		;; diposisikan pada akhir string strhasil 
	jne loop1		
	dec ebx    		
				
	mov eax, [hBytes]	;; panjang string yang dibaca
	mov si,10		
 loop2:				
	xor edx, edx		;; edx di-nolkan untuk menampung sisa bagi
	div si			    ;; dilakukan pembagian 10 berulang
	add dl, '0'        	;; sisa bagi pada edx (dl) di ubah ke character
	mov [ebx], dl		;; simpan ke strhasil dari belakang ke depan
	dec ebx			    ;; majukan pointer
	or  eax,eax		    ;; test apakah yang dibagi sudah nol
	jnz loop2 		    ;; selesai perulangan jika yang dibagi sdh nol
ret
;--------------------------------------------------------------------------------------
;MENGHITUNG BANYAK KARAKTER PADA STRING	
;-----------------------------------------------------------------------------------------------
HitungKarakter:
mov ebx, dword buff       ;memberi alamat variabel berisi string yang akan diolah
mov ecx, [iBytes]         ;memberi panjang string
sub ecx,2			      ;counter kurangi 2 (krn tdk termasuk enter)
xor dl,dl

hitungChar:              
    mov al, byte [ebx]
	cmp al, 32
	je spasi
	inc dl
	
	spasi:
	inc ebx
	loop hitungChar
	
	mov [hBytes],dl
ret
;------------------------------------------------------------------------------------------------                                                                                   