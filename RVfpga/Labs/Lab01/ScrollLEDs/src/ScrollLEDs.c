/* *********************
                    Universidad de Costa Rica
                  Escuela de Ingenieria Electrica
             IE0424 - Laboratorio de Circuitos Digitales
                          Laboratorio 01

                Autores: Jorge Loría / Gabriel Siles
                      Carnet: C04406 / C17530
                        Fecha: 09/04/2025

********************/
#define GPIO_SWs 0x80001400
#define GPIO_LEDs 0x80001404
#define GPIO_INOUT 0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#if defined(D_NEXYS_A7)
   #include <bsp_printf.h>
   #include <bsp_mem_map.h>
   #include <bsp_version.h>
#else
   PRE_COMPILED_MSG("no platform was defined")
#endif
#include <psp_api.h>
#define DELAY 1000000

int ChangingLight(int switches_value, int value_of_lights) {
    WRITE_GPIO(GPIO_INOUT, value_of_lights);
    switches_value = READ_GPIO(GPIO_SWs);
    switches_value = switches_value >> 16;
    WRITE_GPIO(GPIO_LEDs, switches_value);
    return (0);
    }

int ScrollSequence(int switches_value,int resultado, int i, int j, int n, int steps){
    for(i=0; i < steps; i++){                       // Empezamos desde 2^0 y regresamos hasta 2^15
        resultado = (((1 << n) - 1) << i);          // (2^n) - 1 desplazando por lo que se multiplica * 2 
        for (j=0; j < DELAY; j++) ;                 // delay
        ChangingLight(switches_value,resultado);
        for (j=0; j < DELAY; j++) ;                 // delay
    }

    for(i = steps; i >= 0; i--) {                   // Empezamos desde 2^15 y regresamos hasta 2^0
        resultado = (((1 << n) - 1) << i);          // (2^n) - 1 desplazando por lo que se multiplica * 2 
        for (j = 0; j < DELAY; j++) ;               // delay
        ChangingLight(switches_value, resultado); 
        for (j=0; j < DELAY; j++) ;                 // delay   
    }
    return(0);
}

int main ( void )
{   //Definimos los valores de encendido y apagado
    int i,j,k,resultado = 0;                                  //Variables para los ciclos
    int switches_value,n = 1;
    int steps = 15;

    while(1){
        for(k=0; k<16;k++){
            ScrollSequence(switches_value,resultado,i,j,n,steps);
            n++;
            steps--;
        }
    n = 1;
    steps = 15;
    }
return(0);
}