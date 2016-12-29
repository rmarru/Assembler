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

PIXEL_L		EQU 0x00
PIXEL_H		EQU 0x01
LINIA_L		EQU 0x02
LINIA_H		EQU 0x03
MAX_PIXEL_L	EQU 0x04
MAX_PIXEL_H	EQU 0x05	
MAX_LINIA_L	EQU 0x06
MAX_LINIA_H	EQU 0x07
		


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
	bcf INTCON, TMR0IF, 0
	retfie	FAST

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

;********
;* MAIN *
;********

MAIN
	; Inicialització dels ports i configuració
	;clrf TRISB			; tots els bits sel port B, sortida
	call INIT_VARS
	call INIT_INTS
	call INIT_PORTS
		
LOOP
	
	goto LOOP
	
INIT_VARS
	clrf PIXEL_L, 0		
	clrf PIXEL_H, 0		
	clrf LINIA_L, 0		
	clrf LINIA_H, 0		
	movlw 0x20
	movwf MAX_PIXEL_L, 0
	movlw 0x03
	movwf MAX_PIXEL_H, 0
	movlw 0x0D
	movwf MAX_LINIA_L, 0
	movlw 0x02
	movwf MAX_LINIA_H, 0
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
	movlw 0x3F
	movwf TRISD, 0
	movlw 0x08
	movwf TRISE, 0
	return

;*******
;* END *
;*******
	END