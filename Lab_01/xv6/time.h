#ifndef _TIME_H
#define _TIME_H

// DEFINO LAS DIRRECCIONES DE MEMORIA 
#define RTC_ADDR 0x70
#define RTC_DATA 0x71
#define RTC_SEG 0x00
#define RTC_MIN 0x02
#define RTC_HOUR 0x04
#define RTC_DAY 0x07
#define RTC_MONTH 0x08
#define RTC_YEAR 0x09
#define UIP_ADDR 0x0A

int rtc_init(void);
/*
* DEVUELVE LA CANTIDAD DE SEGUNDOS QUE PASARON DESDE THE EPOCH
*	(1 DE ENERO DE 1970 0:00HS) HASTA QUE SE INICIO EL SISTEMA
* XV6.
*/

int sys_gettimeofday(void);
/*
*	LLAMADA DE SISTEMA GETTIMEOFDAY QUE DEVUEVE LA CANTIDAD DE
* SEGUNDOS QUE PASARON DESDE THE EPOCH HASTA EL MOMENTO QUE SE
* LLAMA AL COMANDO DATE EN XV6.
*/

#endif