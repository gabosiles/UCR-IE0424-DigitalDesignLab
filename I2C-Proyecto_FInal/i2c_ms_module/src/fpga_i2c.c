/* *********************
                    Universidad de Costa Rica
                  Escuela de Ingenieria Electrica
             IE0424 - Laboratorio de Circuitos Digitales
                          Proyecto Final

                Autores: Jorge Loría / Gabriel Siles
                      Carnet: C04406 / C17530

********************/


// Direccion del GPIO para controlar LEDs
#define GPIO_LEDs       0x80001404


#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

// Direcciones del modulo maestro I2C
#define I2C_PRER_LO     0x80002800 
#define I2C_PRER_HI     0x80002804 
#define I2C_CTR         0x80002808 // Registro de control del I2C
#define I2C_TXR         0x8000280C // Registro para transmitir datos
#define I2C_RXR         0x8000280C // Registro para recibir datos (mismo que TXR)
#define I2C_CR          0x80002810 // Registro de comandos I2C
#define I2C_SR          0x80002810 // Registro de estado I2C (mismo que CR)


#define GPIO_INOUT      0x80001408 // Configurar entrada/salida
#define GPIO_LEDs       0x80001404 // Control de LEDs

// Lectura y escritura de memoria
#define WRITE(addr, val) (*(volatile unsigned *) (addr) = (val))
#define READ(addr)       (*(volatile unsigned *) (addr))

// Dirección del esclavo I2C
#define I2C_SLAVE_ADDR  0x3C

// Pequeño retardo
void delay(int count) {
    volatile int i;
    for (i = 0; i < count; i++);
}

// Funcion para enviar un byte por I2C a un registro específico del esclavo
void i2c_write_byte(unsigned char slave_addr, unsigned char reg, unsigned char data) {
    // Enviar condicion START + direccion del esclavo con bit de escritura (0)
    WRITE(I2C_TXR, (slave_addr << 1));  // Dirección de 7 bits + W=0
    WRITE(I2C_CR, 0x90); // Iniciar (START) y escribir
    while (READ(I2C_SR) & 0x02); // Esperar a que termine la operación (TIP = 0)

    // Enviar direccion del registro dentro del esclavo
    WRITE(I2C_TXR, reg);
    WRITE(I2C_CR, 0x10); // Solo escribir
    while (READ(I2C_SR) & 0x02);

    // Enviar el dato a ese registro
    WRITE(I2C_TXR, data);
    WRITE(I2C_CR, 0x50); // Escribir y enviar condición STOP
    while (READ(I2C_SR) & 0x02);
}

int main(void) {
  
    WRITE(I2C_PRER_LO, 249);  
    WRITE(I2C_PRER_HI, 0x00); 
    WRITE(I2C_CTR, 0x80);     // Habilitar modulo I2C

    // Configurar todos los pines GPIO como salidas
    WRITE(GPIO_INOUT, 0xFFFF);

    unsigned char value = 0;

    while (1) {
        // Enviar valor al registro 0 del esclavo I2C
        i2c_write_byte(I2C_SLAVE_ADDR, 0x00, value);

        // Mostrar mismo valor en los LEDs de la FPGA
        WRITE(GPIO_LEDs, value);

        // Incrementar valor
        value++;

        // Espera para que el cambio sea visible
        delay(1000000);
    }

    return 0;
}
