/* *********************
                    Universidad de Costa Rica
                  Escuela de Ingenieria Electrica
             IE0424 - Laboratorio de Circuitos Digitales
                          Laboratorio 02

                Autores: Jorge Loría / Gabriel Siles
                      Carnet: C04406 / C17530
                        Fecha: 08/05/2025

********************/

// PTC BLUE
#define  LED_B      0x80001280
#define  LRC_B      0x80001288
#define  HRC_B      0x80001284
#define CTRL_B      0x8000128C

// PTC GREEN
#define  LED_G      0x800012C0
#define  LRC_G      0x800012C8
#define  HRC_G      0x800012C4
#define CTRL_G      0x800012CC

// PTC RED
#define  LED_R      0x80001240
#define  LRC_R      0x80001248
#define  HRC_R      0x80001244
#define CTRL_R      0x8000124C

// SWITCHES
#define GPIO_SWs    0x80001400
#define GPIO_INOUT  0x80001408


#define REAS_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) {(*(volatile unsigned *)dir) = (value);}

// PARAMETROS
#define PORCENTAJE  0x0C

int main (void){

    WRITE_GPIO(CTRL_R, 1);
    WRITE_GPIO(LRC_R, 0x80);
    
    WRITE_GPIO(CTRL_G, 1);
    WRITE_GPIO(LRC_G, 0x80);
    
    WRITE_GPIO(CTRL_B, 1);
    WRITE_GPIO(LRC_B, 0x80);
    
    WRITE_GPIO(GPIO_INOUT, 0xFFFF);
    
    unsigned int SWs, RED_SW, GREEN_SW, BLUE_SW;
    unsigned int TEMP_SW = 1;

    while (1){
        SWs = REAS_GPIO(GPIO_SWs);
        SWs = SWs >> 16;

        if (TEMP_SW != SWs) {

            RED_SW = SWs & 0x1F;
            RED_SW = ActiveWorkCycle(RED_SW);
            WorkCycle(RED_SW, HRC_R);

            GREEN_SW = SWs >> 10;
            GREEN_SW = GREEN_SW & 0x1F;
            GREEN_SW = ActiveWorkCycle(GREEN_SW);
            WorkCycle(GREEN_SW, HRC_G);

            BLUE_SW = SWs >> 5;
            BLUE_SW = BLUE_SW & 0x1F;
            BLUE_SW = ActiveWorkCycle(BLUE_SW);
            WorkCycle(BLUE_SW, HRC_B);

            TEMP_SW = SWs;
        }
    }
}


int ActiveWorkCycle(int NUM_SWs){
    int CountSW = 0;
    int i; 
    
    for (i = 0; i < 5; i++){

        if (NUM_SWs & 0x1){
            CountSW++;
        }

        NUM_SWs = NUM_SWs >> 1;
    }
    return CountSW;
}


void WorkCycle(int workCycle, int Address){

    switch (workCycle){
        case 0x1:
            WRITE_GPIO(Address, 0x80 - PORCENTAJE);
            break;
        case 0x2:
            WRITE_GPIO(Address, 0x80 - 2*PORCENTAJE);
            break;
        case 0x3:
            WRITE_GPIO(Address, 0x80 - 3*PORCENTAJE);
            break;
        case 0x4:
            WRITE_GPIO(Address, 0x80 - 4*PORCENTAJE);
            break;
        case 0x5:
            WRITE_GPIO(Address, 0x80 - 5*PORCENTAJE);
            break;
        default:
            WRITE_GPIO(Address, 0x80);
            break;
    } 
}