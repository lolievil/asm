.586P

.MODEL FLAT, STDCALL

STD_OUT_HANDLE EQU -11
STD_INPUT_HANDLE EQU -10

COL1 = 1H+2H+8H

extern wsprintfA:near
extern GetStdHandle@4:near
extern WriteConsoleA@20:near
extern SetConsoleCursorPosition@8:near
extern SetConsoleTitleA@4:near
extern FreeConsole@0:near
extern AllocConsole@0:near
extern CharToOemA@8:near
extern SetConsoleTextAttribute@8:near
extern ReadConsoleA@20:near
extern SetConsoleScreenBufferSize@8:near
extern ExitProcess@4:near

includelib user32.lib
includelib kernel32.lib

COOR STRUC
	X WORD ?
	Y WORD ?
COOR ENDS

_DATA SEGMENT
	HANDL_INPUT DWORD ?
	HANDL_OUTPU DWORD ?
	STR1 DB 'This is the lolicolor: %lu ugu~~ ^.^', 13, 10, 0
	STR2 DB 'Colors', 0
	BUF DB 200 DUP(?)
	LENS DWORD ?
	CRD COOR <?>
	Color DWORD 0
	i DWORD 0
_DATA ENDS

_TEXT SEGMENT

START:
	PUSH OFFSET STR1
	PUSH OFFSET STR1
	CALL CharToOemA@8
	
	CALL FreeConsole@0
	CALL AllocConsole@0
	
	PUSH STD_INPUT_HANDLE
	CALL GetStdHandle@4
	MOV HANDL_INPUT, EAX
	PUSH STD_OUT_HANDLE
	CALL GetStdHandle@4
	MOV HANDL_OUTPU, EAX
	
	MOV CRD.X, 100
	MOV CRD.Y, 100H 
	PUSH CRD
	PUSH EAX
	CALL SetConsoleScreenBufferSize@8
	
	PUSH OFFSET STR2
	CALL SetConsoleTitleA@4
	
LOOP1:
	MOV EAX, i
	MOV CRD.X, 0
	MOV CRD.Y, AX
	PUSH CRD
	PUSH HANDL_OUTPU
	CALL SetConsoleCursorPosition@8
	
	PUSH i
	PUSH HANDL_OUTPU
	CALL SetConsoleTextAttribute@8
	
	PUSH i
	PUSH OFFSET STR1
	PUSH OFFSET BUF
	CALL wsprintfA
	ADD ESP, 12
	
	PUSH OFFSET BUF
	CALL LENSTR
	PUSH 0
	PUSH OFFSET LENS
	PUSH EBX
	PUSH OFFSET BUF
	PUSH HANDL_OUTPU
	CALL WriteConsoleA@20
	
	INC i
	CMP i, 100H
	JNE LOOP1
	
	PUSH 0
	PUSH OFFSET LENS
	PUSH 200
	PUSH OFFSET BUF
	PUSH HANDL_INPUT
	CALL ReadConsoleA@20
	
	PUSH COL1
	PUSH HANDL_OUTPU
	CALL SetConsoleTextAttribute@8
	
	CALL FreeConsole@0
	PUSH 0
	CALL ExitProcess@4
	RET
	
LENSTR PROC
	ENTER 0,0
	PUSH EAX
	
	CLD
	MOV EDI, DWORD PTR [EBP+08H]
	MOV EBX, EDI
	MOV ECX, 100
	XOR AL, AL
	REPNE SCASB
	SUB EDI, EBX
	MOV EBX, EDI
	
	DEC EBX
	
	POP EAX
	LEAVE
	RET 4

LENSTR ENDP
_TEXT ENDS
END START
