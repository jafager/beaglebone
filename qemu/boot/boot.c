#include "stdint.h"
#include "reg.h"
#include "console.h"



#define MMC                 0x1c000000
#define MMC_MMCIArgument    0x008
#define MMC_MMCICommand     0x00c
#define MMC_MMCIResponse0   0x014
#define MMC_MMCIDataLength  0x028
#define MMC_MMCIDataCtrl    0x02c
#define MMC_MMCIDataCnt     0x030
#define MMC_MMCIStatus      0x034
#define MMC_MMCIClear       0x038
#define MMC_MMCIFIFO        0x080



void boot(void)
{
    regwrite32(MMC + MMC_MMCICommand, 55 | 1024);

    regwrite32(MMC + MMC_MMCIArgument, 123);
    regwrite32(MMC + MMC_MMCICommand, 41 | 1024);

    regwrite32(MMC + MMC_MMCICommand, 2 | 1024 | 128 | 64);

    regwrite32(MMC + MMC_MMCICommand, 3 | 1024 | 64);

    uint32_t rca = regread32(MMC + MMC_MMCIResponse0) & 0xffff0000;
    regwrite32(MMC + MMC_MMCIArgument, rca);
    regwrite32(MMC + MMC_MMCICommand, 7 | 1024 | 64);


    regwrite32(MMC + MMC_MMCIDataLength, 512);

    regwrite32(MMC + MMC_MMCIArgument, 512);
    regwrite32(MMC + MMC_MMCICommand, 16 | 1024 | 64);

    for (int block = 0; block < 2049; block++)
    {
        regwrite32(MMC + MMC_MMCIDataCtrl, 0b10010011);
        regwrite32(MMC + MMC_MMCIArgument, block * 512);
        regwrite32(MMC + MMC_MMCICommand, 17 | 1024 | 64);

        while (regread32(MMC + MMC_MMCIStatus) & (1 << 21))
        {
            uint32_t word = regread32(MMC + MMC_MMCIFIFO);
            console_putc((word >> 0) & 0xff);
            console_putc((word >> 8) & 0xff);
            console_putc((word >> 16) & 0xff);
            console_putc((word >> 24) & 0xff);
        }
    }
}
