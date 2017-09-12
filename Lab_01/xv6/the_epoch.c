#include "types.h"
#include "user.h"
#include "x86.h"
#include "the_epoch.h"


uint
UIP_status(void)
{
  uint uip = 0;

  outb(RTC_ADDR, UIP_ADDR); // Escritura de bytes en puerto 0x70 del Registro A.
  uip = inb(RTC_DATA); // Lectura de la direccion de memoria.
  uip = uip & 0x80; // 1000 0000 en Hexadecimal (Mascara para obtener el valor del bit 7).
  uip = uip >> 7; // Desplazamiento de 7 bits hacia la derecha hasta llevarlo al bit 0.

  return uip;
}



/* Al pasarle un valor, la maquina lo lee en binario pero lo interpreta
* como un decimal, se hace una mascara sobre el num_bcd(digito uno)y desplaza
* 4 bits hacia la derecha para hacer nuevamente una mascara pero ahora sobre
* el digito dos.
*/
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

