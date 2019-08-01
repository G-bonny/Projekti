#line 1 "C:/Documents and Settings/TestUser/Desktop/PDS/Brzinomer/Timer1_Interrupt.c"
#line 25 "C:/Documents and Settings/TestUser/Desktop/PDS/Brzinomer/Timer1_Interrupt.c"
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


unsigned short cnt;
unsigned int imp;
unsigned long rpm;
char Out_Text[12];

void interrupt() {
 if (TMR1IF_bit) {
 cnt++;
 TMR1IF_bit = 0;
 TMR1H = 0x80;
 TMR1L = 0x00;
 }

 if (TMR0IF_bit) {
 imp=imp+256;
 TMR0IF_bit = 0;
 }
}

void main() {
 ANSEL = 0;
 ANSELH = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;

 TRISA.B4=1;
 OPTION_REG.T0CS=1;
 OPTION_REG.PSA=1;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 Lcd_Out(1,6,"Brojac");
 Lcd_Out(2,5,"obrtaja");

 Delay_ms(2000);

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,6,"Brzina");
 Lcd_Out(2,13,"rpm");

 PORTD = 0xFF;
 TRISD = 0;
 T1CON = 1;
 TMR1IF_bit = 0;
 TMR1H = 0x80;
 TMR1L = 0x00;
 TMR1IE_bit = 1;
 TMR0=0;

 cnt = 0;
 INTCON = 0xE0;

 do {
 if (cnt >= 61) {
 PORTD = ~PORTD;
 cnt = 0;
 imp=imp+TMR0;

 rpm=(imp*60)/36;
 LongToStr(rpm, Out_Text);
 Lcd_Out(2,1,Out_Text);
 TMR0=0;
 imp=0;
 }
 } while (1);
}
