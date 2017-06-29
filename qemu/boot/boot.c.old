#include "stdint.h"
#include "reg.h"
#include "console.h"



#define MMC                     0x1c000000
#define MMC_MMCIArgument        0x008
#define MMC_MMCICommand         0x00c
#define MMC_MMCIResponse0       0x014
#define MMC_MMCIDataLength      0x028
#define MMC_MMCIDataCtrl        0x02c
#define MMC_MMCIDataCnt         0x030
#define MMC_MMCIStatus          0x034
#define MMC_MMCIClear           0x038
#define MMC_MMCIFIFO            0x080

#define KERNEL_START_ADDRESS    0x04000000



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




    /* Set host controller to 4 byte reads */

    regwrite32(MMC + MMC_MMCIDataLength, 4);



    /* Set card to 4 byte reads */
    regwrite32(MMC + MMC_MMCIArgument, 4);
    regwrite32(MMC + MMC_MMCICommand, 16 | 1024 | 64);



    /* Read first block */
    regwrite32(MMC + MMC_MMCIDataCtrl, 0b10010011);
    regwrite32(MMC + MMC_MMCIArgument, 0);
    regwrite32(MMC + MMC_MMCICommand, 17 | 1024 | 64);


    /* Get size of the kernel */
    int32_t kernel_bytes_left = regread32(MMC + MMC_MMCIFIFO);
    uint32_t mmci_status = regread32(MMC + MMC_MMCIStatus);


    uint32_t address = 0;
    while (kernel_bytes_left > 0)
    {
        regwrite32(MMC + MMC_MMCIDataCtrl, 0b10010011);
        regwrite32(MMC + MMC_MMCIArgument, address + 4);
        regwrite32(MMC + MMC_MMCICommand, 17 | 1024 | 64);

        while (regread32(MMC + MMC_MMCIStatus) & (1 << 21))
        {
            uint32_t word = regread32(MMC + MMC_MMCIFIFO);
            regwrite32(KERNEL_START_ADDRESS + address, word);
            address += 4;
            kernel_bytes_left -= 4;
        }
    }

}
