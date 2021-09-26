ORG 00H
SJMP SETUP

ORG 13H
LJMP MOTOR

; =========== SUBROTINA PARA CONFIGURAR OS PERIFERICOS =============
ORG 30H
SETUP: 		MOV P2, #11H	; INICIALIZA O MOTOR DE PASSO
		MOV IE, #84H	; EA = 1, EX1 = 1
		MOV TCON, #04H	; IT1 = 0 INTERRUPÇÕES POR TRANSIÇÃO
		MOV TMOD, #10H	; TIMER 1 MODO 1 (M10=0 M00=1)

MAIN: 		SJMP $		; ESPERA AS INTERRUPÇÕES

; =========== SUBROTINA DE MOVIMENTAÇÃO DO MOTOR ===================
MOTOR:		MOV A, P2		; RECUPERA A POSIÇÃO QUE PAROU O MOTOR
		MOV R0, #6
RECARGA_1:	MOV R1, #144
RECARGA_2:	RR A			; DETERMINA A PRÓXIMA POSIÇÃO
		MOV P2, A		; MOVIMENTA O MOTOR
		LCALL DELAY		; DELAY DE 69.4444444442 MS
		DJNZ R1, RECARGA_2	; 144 CONTAGENS DE DT = 10 S
		DJNZ R0, RECARGA_1	; 6 CONTAGENS DE 10 S = 60 S
		RETI

; =========== SUBROTINA DE ATRASO ==================================
DELAY:		SETB TR1		; DISPARA CONTAGEM
		MOV TH1, #05H		; RECARRREGA O TIMER
		MOV TL1, #0FFH
		JNB TF1, $		; DT= 69.4444444442 MS
		CLR TF1
		CLR TR1
		RET
END