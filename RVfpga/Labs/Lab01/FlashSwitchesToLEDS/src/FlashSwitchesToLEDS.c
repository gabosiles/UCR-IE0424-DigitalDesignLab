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
#define DELAY 10000000

int main ( void )
{   //Definimos los valores de encendido y apagado
    int ON_Value=0xFFFF, OFF_Value = 0x0000, switches_value;
    int variable = 0; //Funcion similar a un clock
    int i;//Variable para los ciclos

    uartInit();
    
    while (1) {
        /*
            Inicialmente va a ingresar al else dada la inicializacion de variable, ahi se le suma una a su valor.
            Cuando la variable sea 1 los LEDS se van a activar y variable se le quita 1 a su valor.
            De esta forma vamos a ir alternando, simulando un funcionamiento de un clock.
         
        */
        if (variable) {
             ChangingLight(switches_value,ON_Value);
             for (i=0; i < DELAY; i++) ;  // delay between printf's
             variable = variable - 1;
        }
        else {
             ChangingLight(switches_value,OFF_Value);
             printfNexys("FLASH OFF\n");
             for (i=0; i < DELAY; i++) ;  // delay between printf's
             printfNexys("CHANGING variable TO 1");
             variable++;
             
        }
    }

return(0);
}

int ChangingLight(int switches_value, int value_of_lights) {
WRITE_GPIO(GPIO_INOUT, value_of_lights);
switches_value = READ_GPIO(GPIO_SWs);
switches_value = switches_value >> 16;
WRITE_GPIO(GPIO_LEDs, switches_value);
return (0);
}