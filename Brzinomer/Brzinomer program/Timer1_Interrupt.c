/*
 * Project name:
     Timer1_Interrupt (Using Timer1 to obtain interrupts)
 * Copyright:
     (c) Mikroelektronika, 2008.
 * Revision History:
     20080930:
       - initial release;
 * Description:
     This code demonstrates how to use Timer1 and it's interrupt.
     Program toggles LEDs on PORTB.
 * Test configuration:
     MCU:             PIC16F887
                      http://ww1.microchip.com/downloads/en/DeviceDoc/41291F.pdf
     Dev.Board:       EasyPIC7
                      http://www.mikroe.com/eng/products/view/757/easypic-v7-development-system/
     Oscillator:      HS, 08.0000 MHz
     Ext. Modules:    -
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/eng/products/view/7/mikroc-pro-for-pic/
 * NOTES:
     - Turn on LEDs on PORTB switch SW9.2 (board specific).
*/
// LCD module connections
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
// End LCD module connections

unsigned short cnt;
unsigned int imp;
unsigned long rpm;
char Out_Text[12];

void interrupt() {
  if (TMR1IF_bit) {
    cnt++;                    // increment counter
    TMR1IF_bit = 0;           // clear TMR0IF
    TMR1H = 0x80;
    TMR1L = 0x00;
  }
  
    if (TMR0IF_bit) {
    imp=imp+256;                    // increment counter
    TMR0IF_bit = 0;           // clear TMR0IF
  }
}

void main() {
  ANSEL  = 0;                 // Configure AN pins as digital
  ANSELH = 0;
  C1ON_bit = 0;               // Disable comparators
  C2ON_bit = 0;
  
  TRISA.B4=1;                 //RA4/TOCKI input
  OPTION_REG.T0CS=1;
  OPTION_REG.PSA=1;
  
  Lcd_Init();                        // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  
  Lcd_Out(1,6,"Brojac");                 // Write text in first row
  Lcd_Out(2,5,"obrtaja");                 // Write text in second row
  
  Delay_ms(2000);
  
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Out(1,6,"Brzina");                 // Write text in first row
  Lcd_Out(2,13,"rpm");                 // Write text in first row
  
  PORTD = 0xFF;               // Initialize PORTB
  TRISD = 0;                  // PORTB is output
  T1CON = 1;                  // Timer1 settings
  TMR1IF_bit = 0;             // clear TMR1IF
  TMR1H = 0x80;               // Initialize Timer1 register
  TMR1L = 0x00;
  TMR1IE_bit = 1;             // enable Timer1 interrupt
  TMR0=0;
  
  cnt =   0;                  // initialize cnt
  INTCON = 0xE0;              // Set GIE, PEIE, TOIE

  do {
    if (cnt >= 61) {
      PORTD  = ~PORTD;        // Toggle PORTB LEDs
      cnt = 0;                // Reset cnt
      imp=imp+TMR0;

      rpm=(imp*60)/36;
      LongToStr(rpm, Out_Text);
      Lcd_Out(2,1,Out_Text);                 // Write text in first row
      TMR0=0;
      imp=0;
    }
  } while (1);
}