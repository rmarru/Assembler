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

WREG_TEMP	EQU 0x00	
STATUS_TEMP	EQU 0x01	
BSR_TEMP	EQU 0x02	


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
	retfie	FAST

LOW_INT
	;condi de interrupció
	retfie	FAST

;***********************************
;* TAULES *
;***********************************

	ORG 0x000020

	DATA  0x067F,0x4F5B

	ORG 0x000024

	DB  0x7F, 0x06

;****************************
;* MAIN I RESTA DE FUNCIONS *
;****************************

;********
;* MAIN *
;********

MAIN
	; Inicialització dels ports i configuració
	clrf TRISB			; tots els bits sel port B, sortida
LOOP
	movlw 0xFF
	movwf PORTB			; LEDS ON	
	movlw 0x00
	movwf PORTB			; LEDS OFF
	bra LOOP


;*******
;* END *
;*******
	END