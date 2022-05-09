%INCLUDE "console.inc"

;DEKLARASI VARIABEL
;------------------------------------------------------------------------------------------------
section .data 		

judul			db "Baca dan Kapitalisasi huruf", 0 
teks1           db 13,10,13,10,"Tulis Kalimat  : ", 0 
pteks1			dd 0 
teks2           db 13,10,13,10,"Tampilkan lagi : ", 0 
pteks2			dd 0 
teks3           db 13,10,13,10,"Dikapitalisasi menjadi: ", 0 
pteks3			dd 0 
teks4			db 13,10,13,10,"Tunggu 10 detik ....................", 13,10,0 
pteks4	        dd 0 

buff			resb 24
nul				db 0
buff_len		dd 25
buf2			resb 24
nul2			db 0
buf2_len		dd 25

section .bss 		;; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1

; MULAI PROGRAM
;--------------------------------------------------------------------------------------------------
section .text use32 
..start: 

initconsole judul, hStdOut, hStdIn
tampilkan_teks teks1, pteks1, nBytes, hStdOut

call BacaTeks	

tampilkan_teks teks2, pteks2, nBytes, hStdOut

call TampilkanLagi

call KapitalisasiHuruf

tampilkan_teks teks3, pteks3, nBytes, hStdOut

call TampilYgKapital

tampilkan_teks teks4, pteks4, nBytes, hStdOut
tunggu 10000 			;; delay 10 second 
quitconsole
;=================================================================================================

BacaTeks:
				;; membaca string dari Console(keyboard) dg ReadFile
push dword 0 			;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 		;; parameter ke 4 jumlah byte yg sesungguhnya terbaca (TERMASUK ENTER)
push dword [buff_len] 		;; parameter ke 3 panjang buffer yg disediakan
push dword buff 		;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdIn] 		;; parameter ke 1 handle stdin
call [ReadFile] 			
ret
;--------------------------------------------------------------------------------------------------
TampilkanLagi:
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [iBytes] 		;; parameter ke 3 panjang string
push dword buff			;; parameter ke 2 string yang akan ditampilkan 
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 
ret
;--------------------------------------------------------------------------------------------------
TampilYgKapital:
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [iBytes] 		;; parameter ke 3 panjang string
push dword buf2			;; parameter ke 2 string yang akan ditampilkan 
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 
ret
;--------------------------------------------------------------------------------------------------

;KAPITALISASI HURUF	
;-----------------------------------------------------------------------------------------------
KapitalisasiHuruf:
mov ebx, dword buff        ;memberi alamat variabel berisi string yang akan diolah
mov ecx, [iBytes]           ;memberi panjang string

mov esi, buf2			; ESI alamat tujuan

sub ecx,2			; counter kurangi 2 (krn tdk termasuk enter)
mov [buf2_len], ecx

kapitalkan:                   ;a=61H A=41H  |   z=7AH Z=5AH
	mov al, byte [ebx]
	cmp al, 61H
	jb lolos1
	cmp al, 7AH
	ja lolos2
	
	sub al,20h
	
	lolos1:
    lolos2:
	
	mov [esi], al
	inc ebx
	inc esi
	loop kapitalkan
        
ret
;------------------------------------------------------------------------------------------------
