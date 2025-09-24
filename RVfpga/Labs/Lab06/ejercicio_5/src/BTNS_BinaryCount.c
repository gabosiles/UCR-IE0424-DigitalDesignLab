/* *********************
                    Universidad de Costa Rica
                  Escuela de Ingenieria Electrica
             IE0424 - Laboratorio de Circuitos Digitales
                          Laboratorio 02

                Autores: Jorge Loría / Gabriel Siles
                      Carnet: C04406 / C17530
                        Fecha: 07/05/2025

********************/
#define GPIO_SWs        0x80001400
#define GPIO_LEDs       0x80001404
#define GPIO_INOUT      0x80001408
#define GPIO_BTN        0x80001800
#define GPIO2_INOUT     0x80001808

#define DelayFactor 100
#define DELAY 1000000

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

int main ( void )
{
    int i, speed_BTNC, reset_BTNU, delay;
    int sumador = 0;

    // Enable OE
    WRITE_GPIO(GPIO_INOUT, 0xFFFF);
    WRITE_GPIO(GPIO2_INOUT, 0x0);

    while (1) {
        // Button BTNC - Increase Speed
        speed_BTNC = READ_GPIO(GPIO_BTN);
        if ((speed_BTNC & 0x01) == 0x1) {
            delay = DELAY/DelayFactor;
        }
        else delay = DELAY;

        // Button BTNU - Reset Count
        reset_BTNU = READ_GPIO(GPIO_BTN);
        if ((reset_BTNU & 0x2) == 0x2) {
            sumador = 0;
        }

        // Counter and Display
        sumador++;
		WRITE_GPIO(GPIO_LEDs, sumador);

        // Delay
		for (i=0; i<delay; i++);
    }

    return(0);
}