#include "types.h"
#include "user.h"
#include "x86.h"
#include "time.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
//#include "defs.h"

// SE LLAMA A LAS VARIABLES GLOBALES TICKS Y BOOTTIME CON EXTERN PORQUE
// SI INCLUIMOS LA BIBLIOTECA DEFS.H NOS TIRA UN ERROR DE COMPILACION,
// EL CUAL NO PUDIMOS SOLUCIONAR 

extern uint ticks;
extern int boottime;


uint
UIP_status(void)
{
  uint uip = 0;

  outb(RTC_ADDR, UIP_ADDR);
  uip = inb(RTC_DATA);
  uip = uip & 0x80;
  uip = uip >> 7;

  return uip;
}


uint
bcd_to_binary(uint num_bcd)
{

  uint digit_one = num_bcd & 15;
  uint digit_two = (num_bcd >> 4) & 15;
  uint result = digit_one + (10*digit_two);

  return result;
}


uint mktime(const uint year, const uint month,
                   const uint day, const uint hour,
                   const uint min, const uint sec)
{

  uint mon = month;
  uint year1 = year;

  if(0 >= (int) (mon = mon - 2))
  {
    mon = mon + 12;
    year1 = year1 - 1;
  }

  uint total_seconds = ((((year1/4 - year1/100 + year1/400 + (367*mon)/12 + day) +
                           year1*365 - 719499)*24 + hour)*60 + min)*60 + sec;

  return total_seconds;
}


uint
rtc_data(const ushort port)
{
  outb(RTC_ADDR, port);
  uint result = inb(RTC_DATA);

  result = bcd_to_binary(result);

  return result;
}


int
rtc_read(void)
{
  int result = 0;
  
	while(UIP_status() == 1)
  {
    ;
  } 
 
  uint seg = rtc_data(RTC_SEG); // SEGUNDOS
  uint min = rtc_data(RTC_MIN); // MINUTOS
  uint hour = rtc_data(RTC_HOUR); // HORAS
  uint day = rtc_data(RTC_DAY); // DIAS
  uint month = rtc_data(RTC_MONTH);// MESES
  uint year = rtc_data(RTC_YEAR) + 2000; // AÑO

  result = mktime(year, month, day, hour, min, seg);

  return result;
}


int
rtc_init(void)
{
  uint second = rtc_read();

  return second;
}


int
sys_gettimeofday(void)
{
	uint boottime2 = 0;
	
	boottime2 = boottime + ticks/100; // a boottime le sumo el tiempo de inicio
																		// del sistema (ticks/100)
	return boottime2;
}
