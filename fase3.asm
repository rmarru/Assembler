	LIST P=18F4321, F=INHX32
	#include <P18F4321.INC>	

;******************
;* CONFIGURACIONS *
;******************
	CONFIG	OSC = HS             
	CONFIG	PBADEN = DIG
	CONFIG	WDT = OFF

;*************
;* VARIABLES *
;*************

LINIA_L		EQU 0x00
LINIA_H		EQU 0x01
PIXEL_L		EQU 0x02
PIXEL_H		EQU 0x03	
MAX_LINIA_L	EQU 0x04
MAX_LINIA_H	EQU 0x05
		


;*************
;* CONSTANTS *
;*************


;*********************************
; VECTORS DE RESET I INTERRUPCIÓ *
;*********************************
	ORG 0x000000
RESET_VECTOR
	goto MAIN		

	ORG 0x000008
HI_INT_VECTOR
	bra	HIGH_INT	

	ORG 0x000018
LOW_INT_VECTOR
	bra	LOW_INT		

;***********************************
;* RUTINES DE SERVEI D'INTERRUPCIÓ *
;***********************************
HIGH_INT
	;codi de interrupció
	bsf LATE, 0, 0					;1
	tstfsz LINIA_H, 0				;1 (2 o 3)
	    goto CINC_NOPS				;2  
	movlw 0x01					;1
	cpfsgt LINIA_L, 0				;1 (2 o 3)
	    goto ACTIVATE_VSYNC				;2  		   
	bcf LATE, 1, 0					;1
	goto HIGH_INT_CONTINUE				;2
	
CINC_NOPS	
	NOP						;1
	NOP						;1
	NOP						;1
	goto HIGH_INT_CONTINUE				;2  
	
ACTIVATE_VSYNC
	bsf LATE, 1, 0					;1
	NOP						;1
	    
HIGH_INT_CONTINUE	
	movlw 0xC3					;1
	movwf TMR0L, 0					;1
	movlw 0xFE					;1
	movwf TMR0H, 0					;1
	bcf INTCON, TMR0IF, 0				;1
	clrf PIXEL_L, 0					;1
	clrf PIXEL_H, 0					;1
	
	movf MAX_LINIA_H, 0, 0				;1
	cpfseq LINIA_H, 0				;1 (2 o 3)
	    goto INC_LINIA_H				;2
	call DEU_NOPS					;2  
	NOP						;1
	movf MAX_LINIA_L, 0, 0				;1
	cpfseq LINIA_L, 0				;1 (2 o 3)
	    goto INC_LINIA_L				;2
	    
	clrf LINIA_H, 0					;1
	clrf LINIA_L, 0					;1
	
	bcf LATE, 0, 0					;1
	retfie	FAST					;2
	
INC_LINIA_H
	call DEU_NOPS					;2
	movlw 0xFF					;1
	cpfseq LINIA_L, 0				;1 (2 o 3)
	    goto INC_LINIA_L				;2
	clrf LINIA_L, 0					;1
	incf LINIA_H, 1, 0				;1
	bcf LATE, 0, 0					;1
	retfie FAST					;2
	
INC_LINIA_L
	incf LINIA_L, 1, 0				;1
	bcf LATE, 0, 0					;1
	retfie FAST					;2
	
DEU_NOPS
	NOP						;1
	NOP						;1
	NOP						;1
	NOP						;1
	NOP						;1
	NOP						;1
	return						;2
	
LOW_INT
	;codi de interrupció
	retfie	FAST

;***********************************
;* TAULES *
;***********************************

	;ORG 0x000020

	;DATA  0x067F,0x4F5B

	;ORG 0x000024

	;DB  0x7F, 0x06

;****************************
;* MAIN I RESTA DE FUNCIONS *
;****************************
	
INIT_VARS
	clrf PIXEL_L, 0		;No se si fa falta
	clrf PIXEL_H, 0		
	movlw 0x0D
	movwf MAX_LINIA_L, 0
	movwf LINIA_L, 0		
	movlw 0x02
	movwf MAX_LINIA_H, 0
	movwf LINIA_H, 0	
	return
	
INIT_INTS
	movlw 0xC3
	movwf TMR0L, 0
	movlw 0xFE
	movwf TMR0H, 0
	bsf RCON, IPEN, 0
	movlw 0xE0
	movwf INTCON, 0
	movlw 0x84
	movwf INTCON2, 0
	movlw 0x88
	movwf T0CON, 0
	return
	
INIT_PORTS
	movlw 0xC0
	movwf TRISA, 0
	movlw 0x0F
	movwf ADCON1, 0
	clrf TRISB, 0
	;movlw 0x3F
	;movwf TRISD, 0
	movlw 0x08
	movwf TRISE, 0
	return

;********
;* MAIN *
;********
	ORG 0x0000CE
MAIN
	; Inicialització dels ports i configuració
	;clrf TRISB			; tots els bits sel port B, sortida
	call INIT_VARS
	call INIT_INTS
	call INIT_PORTS
		
LOOP
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	movlw 0x02
	movwf LATA, 0
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	movlw 0x01
	movwf LATA, 0
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	clrf LATA, 0
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	call DEU_NOPS					;2
	NOP
	goto LOOP
	
	
;*******
;* END *
;*******
	END