/* *********************
                    Universidad de Costa Rica
                  Escuela de Ingenieria Electrica
             IE0424 - Laboratorio de Circuitos Digitales
                          Proyecto Final

                Autores: Jorge Loría / Gabriel Siles
                      Carnet: C04406 / C17530

********************/

#include "psp_api.h"

#define SegEn_ADDR    0x80001038
#define SegDig_ADDR   0x8000103C

#define GPIO_SWs      0x80001400
#define GPIO_LEDs     0x80001404
#define GPIO_INOUT    0x80001408

#define I2C_PRER_LO     0x80002800 
#define I2C_PRER_HI     0x80002804 
#define I2C_CTR         0x80002808
#define I2C_TXR         0x8000280C
#define I2C_RXR         0x8000280C
#define I2C_CR          0x80002810
#define I2C_SR          0x80002810

#define I2C_SLAVE_ADDR  0x3C
#define WRITE(addr, val) (*(volatile unsigned *) (addr) = (val))
#define READ(addr)       (*(volatile unsigned *) (addr))


// Función para contar cuántos switches están activos
int count_active_switches(u16_t switches) {
    int count = 0;
    for (int i = 0; i < 16; i++) {
        if (switches & (1 << i)) {
            count++;
        }
    }
    return count;
}

void i2c_write_byte(unsigned char slave_addr, unsigned char reg, unsigned char data) {
    //START
    WRITE(I2C_TXR, (slave_addr << 1));
    WRITE(I2C_CR, 0x90); // START + Write
    while (READ(I2C_SR) & 0x02);

    // Registro
    WRITE(I2C_TXR, reg);
    WRITE(I2C_CR, 0x10);
    while (READ(I2C_SR) & 0x02);

    // WRITE Dato 
    WRITE(I2C_TXR, data);
    WRITE(I2C_CR, 0x50); // Write + STOP
    while (READ(I2C_SR) & 0x02);
}

void delay() {
    volatile int i;
    for (i = 0; i < 100000; i++);
}

int main(void) {
    u16_t sw_values;
    int sw_count;
    WRITE(GPIO_INOUT, 0xFFFF);
    WRITE(SegEn_ADDR, 0x0);

    WRITE(I2C_PRER_LO, 249);   // PRER = (50e6 / (5 * 100e3)) - 1 = 249
    WRITE(I2C_PRER_HI, 0x00);
    WRITE(I2C_CTR, 0x80);

    while (1) {
        sw_values = (READ(GPIO_SWs) >> 16) & 0xFFFF;
        WRITE(GPIO_LEDs, sw_values);
        sw_count = count_active_switches(sw_values);
        WRITE(SegDig_ADDR, sw_count);
        i2c_write_byte(I2C_SLAVE_ADDR, 0x00, (unsigned char)sw_count);
        delay();
    }

    return 0;
}
