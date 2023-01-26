myss     SEGMENT PARA STACK 'yigin'
         DW 20 DUP(?)
myss     ENDS
myds     SEGMENT PARA 'data'
n        DW 10
myds     ENDS
mycs     SEGMENT PARA 'kod'
         ASSUME SS:myss,CS:mycs,DS:myds
ANA      PROC FAR
	     PUSH DS
	     XOR AX,AX
	     PUSH AX
	     MOV AX,myds
	     MOV DS,AX
	     PUSH n
	     CALL FAR PTR DNUM
		 CALL PRINTINT
	     RETF
ANA      ENDP
DNUM     PROC FAR
         PUSH AX
         PUSH BX
	     PUSH CX
	     PUSH BP
	     MOV BP,SP
	     MOV AX,[BP+12]
         CMP AX,0
	     JE ret0
	     CMP AX,1
	     JE re1
	     CMP AX,2
	     JE re1
         DEC AX
	     MOV CX,AX;cx=n-1
	     PUSH AX
         CALL DNUM
         POP AX ;ax=d(n-1);
	     PUSH AX
	     CALL DNUM
	     POP AX; ax=d(d(n-1))
	     PUSH CX
	     DEC CX ;cx=n-2
	     PUSH CX
	     CALL DNUM 
	     POP CX ;CX=D(n-2)
	     POP BX;BX=n-1
	     SUB BX,CX;BX=n-1-D(n-2)
	     PUSH BX
	     CALL DNUM
	     POP BX;BX=D(n-1-D(n-2))
	     ADD AX,BX;AX=D(n)
	     MOV [BP+12],AX
	     JMP ok
ret0:    XOR AX,AX
         MOV [BP+12],AX
         JMP ok
re1:     MOV AX,1
         MOV [BP+12],AX
         JMP ok
ok:      POP BP
	     POP CX
	     POP BX
	     POP AX
         RETF 
DNUM     ENDP

PRINTINT PROC NEAR
         PUSH CX
		 PUSH DX
		 PUSH BP
		 MOV BP, SP
		 MOV AX,[BP+8]
		 XOR DX,DX
		 PUSH DX 
		 MOV CX,10
J1:	     DIV CX
		 ADD DX,48;'0'
		 PUSH DX
		 XOR DX, DX
		 CMP AX, 0
		 JNZ J1
J2:      POP AX
		 CMP AX, 0
		 JZ J3
		 MOV DL, AL
		 MOV AH, 2
		 INT 21h
		 JMP J2
J3:	     POP BP
         POP DX
		 POP CX
		 RET 2
PRINTINT ENDP
mycs     ENDS
         END ANA
