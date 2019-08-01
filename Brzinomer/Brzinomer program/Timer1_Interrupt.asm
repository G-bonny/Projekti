
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Timer1_Interrupt.c,45 :: 		void interrupt() {
;Timer1_Interrupt.c,46 :: 		if (TMR1IF_bit) {
	BTFSS      TMR1IF_bit+0, 0
	GOTO       L_interrupt0
;Timer1_Interrupt.c,47 :: 		cnt++;                    // increment counter
	INCF       _cnt+0, 1
;Timer1_Interrupt.c,48 :: 		TMR1IF_bit = 0;           // clear TMR0IF
	BCF        TMR1IF_bit+0, 0
;Timer1_Interrupt.c,49 :: 		TMR1H = 0x80;
	MOVLW      128
	MOVWF      TMR1H+0
;Timer1_Interrupt.c,50 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;Timer1_Interrupt.c,51 :: 		}
L_interrupt0:
;Timer1_Interrupt.c,53 :: 		if (TMR0IF_bit) {
	BTFSS      TMR0IF_bit+0, 2
	GOTO       L_interrupt1
;Timer1_Interrupt.c,54 :: 		imp=imp+256;                    // increment counter
	MOVLW      0
	ADDWF      _imp+0, 1
	MOVLW      1
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _imp+1, 1
;Timer1_Interrupt.c,55 :: 		TMR0IF_bit = 0;           // clear TMR0IF
	BCF        TMR0IF_bit+0, 2
;Timer1_Interrupt.c,56 :: 		}
L_interrupt1:
;Timer1_Interrupt.c,57 :: 		}
L_end_interrupt:
L__interrupt8:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Timer1_Interrupt.c,59 :: 		void main() {
;Timer1_Interrupt.c,60 :: 		ANSEL  = 0;                 // Configure AN pins as digital
	CLRF       ANSEL+0
;Timer1_Interrupt.c,61 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;Timer1_Interrupt.c,62 :: 		C1ON_bit = 0;               // Disable comparators
	BCF        C1ON_bit+0, 7
;Timer1_Interrupt.c,63 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, 7
;Timer1_Interrupt.c,65 :: 		TRISA.B4=1;                 //RA4/TOCKI input
	BSF        TRISA+0, 4
;Timer1_Interrupt.c,66 :: 		OPTION_REG.T0CS=1;
	BSF        OPTION_REG+0, 5
;Timer1_Interrupt.c,67 :: 		OPTION_REG.PSA=1;
	BSF        OPTION_REG+0, 3
;Timer1_Interrupt.c,69 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;Timer1_Interrupt.c,70 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Timer1_Interrupt.c,71 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Timer1_Interrupt.c,73 :: 		Lcd_Out(1,6,"Brojac");                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Timer1_Interrupt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Timer1_Interrupt.c,74 :: 		Lcd_Out(2,5,"obrtaja");                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Timer1_Interrupt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Timer1_Interrupt.c,76 :: 		Delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
	NOP
;Timer1_Interrupt.c,78 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Timer1_Interrupt.c,79 :: 		Lcd_Out(1,6,"Brzina");                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Timer1_Interrupt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Timer1_Interrupt.c,80 :: 		Lcd_Out(2,13,"rpm");                 // Write text in first row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Timer1_Interrupt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Timer1_Interrupt.c,82 :: 		PORTD = 0xFF;               // Initialize PORTB
	MOVLW      255
	MOVWF      PORTD+0
;Timer1_Interrupt.c,83 :: 		TRISD = 0;                  // PORTB is output
	CLRF       TRISD+0
;Timer1_Interrupt.c,84 :: 		T1CON = 1;                  // Timer1 settings
	MOVLW      1
	MOVWF      T1CON+0
;Timer1_Interrupt.c,85 :: 		TMR1IF_bit = 0;             // clear TMR1IF
	BCF        TMR1IF_bit+0, 0
;Timer1_Interrupt.c,86 :: 		TMR1H = 0x80;               // Initialize Timer1 register
	MOVLW      128
	MOVWF      TMR1H+0
;Timer1_Interrupt.c,87 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;Timer1_Interrupt.c,88 :: 		TMR1IE_bit = 1;             // enable Timer1 interrupt
	BSF        TMR1IE_bit+0, 0
;Timer1_Interrupt.c,89 :: 		TMR0=0;
	CLRF       TMR0+0
;Timer1_Interrupt.c,91 :: 		cnt =   0;                  // initialize cnt
	CLRF       _cnt+0
;Timer1_Interrupt.c,92 :: 		INTCON = 0xE0;              // Set GIE, PEIE, TOIE
	MOVLW      224
	MOVWF      INTCON+0
;Timer1_Interrupt.c,94 :: 		do {
L_main3:
;Timer1_Interrupt.c,95 :: 		if (cnt >= 61) {
	MOVLW      61
	SUBWF      _cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main6
;Timer1_Interrupt.c,96 :: 		PORTD  = ~PORTD;        // Toggle PORTB LEDs
	COMF       PORTD+0, 1
;Timer1_Interrupt.c,97 :: 		cnt = 0;                // Reset cnt
	CLRF       _cnt+0
;Timer1_Interrupt.c,98 :: 		imp=imp+TMR0;
	MOVF       TMR0+0, 0
	ADDWF      _imp+0, 1
	BTFSC      STATUS+0, 0
	INCF       _imp+1, 1
;Timer1_Interrupt.c,100 :: 		rpm=(imp*60)/36;
	MOVF       _imp+0, 0
	MOVWF      R0+0
	MOVF       _imp+1, 0
	MOVWF      R0+1
	MOVLW      60
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      36
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _rpm+0
	MOVF       R0+1, 0
	MOVWF      _rpm+1
	CLRF       _rpm+2
	CLRF       _rpm+3
;Timer1_Interrupt.c,101 :: 		LongToStr(rpm, Out_Text);
	MOVF       _rpm+0, 0
	MOVWF      FARG_LongToStr_input+0
	MOVF       _rpm+1, 0
	MOVWF      FARG_LongToStr_input+1
	MOVF       _rpm+2, 0
	MOVWF      FARG_LongToStr_input+2
	MOVF       _rpm+3, 0
	MOVWF      FARG_LongToStr_input+3
	MOVLW      _Out_Text+0
	MOVWF      FARG_LongToStr_output+0
	CALL       _LongToStr+0
;Timer1_Interrupt.c,102 :: 		Lcd_Out(2,1,Out_Text);                 // Write text in first row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _Out_Text+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Timer1_Interrupt.c,103 :: 		TMR0=0;
	CLRF       TMR0+0
;Timer1_Interrupt.c,104 :: 		imp=0;
	CLRF       _imp+0
	CLRF       _imp+1
;Timer1_Interrupt.c,105 :: 		}
L_main6:
;Timer1_Interrupt.c,106 :: 		} while (1);
	GOTO       L_main3
;Timer1_Interrupt.c,107 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
