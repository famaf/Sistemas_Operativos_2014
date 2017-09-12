#include <stdio.h>

#define SEG_YEAR 31557600
#define SEG_MONTH 2629743
#define SEG_DAY 31557600
#define SEG_HOUR 31557600
#define SEG_MIN 31557600

//-------------------------------------------
int entero(double a) {
    int b = a / 1;

    return b;
}

//-------------------------------------------
double decimal(double a) {
    double b = a - entero(a);

    return b;
}

//-------------------------------------------
int main() {
    unsigned int th = 1409807350;

    unsigned int seg_year = 31557600;
    unsigned int seg_month = 2629743;
    unsigned int seg_day = 86400;
    unsigned int seg_hour = 3600;
    unsigned int seg_min = 60;

    double a, c, d,a1, c1;
    int b, b1;

//-----------------------------------------------------	
    // AÑOS
    a = (double)th / seg_year; // VALOR REAL cantidad de años

    b = a / 1; // VALOR ENTERO
    b1 = b + 1970;

    c = a - b; // VALOR DECIMAL

    printf("Año: %d\n", b1);

//-----------------------------------------------------
    // MESES
    // a = c * 12;

    // b = a/1; 

    // c = a - b;

    // printf("Mes: %d\n", b);

//-----------------------------------------------------
    // DIAS
    a = c * 365.25;

    a1 = a;

    b = a/1; 

    c = a - b;

    printf("Dia: %d\n", b);

//-----------------------------------------------------
    // HORAS
    a = c * 24;

    b = a/1; 

    c = a - b;

    printf("Hora: %d\n", b);

//-----------------------------------------------------
    // MINUTOS
    a = c * 60;

    b = a/1; 

    c = a - b;

    printf("Minutos: %d\n", b);

//-----------------------------------------------------
    // SEGUNDOS
    a = c * 60;

    b = a/1; 

    c = a - b;

    printf("Segundos: %d\n", b);
//-----------------------------------------------------

    return 0;
}
