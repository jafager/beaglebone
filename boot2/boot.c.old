#include "stdint.h"
#include "reg.h"
#include "console.h"



#define MMC                     0x1c000000
#define MMC_MMCIArgument        0x008
#define MMC_MMCICommand         0x00c
#define MMC_MMCIResponse0       0x014
#define MMC_MMCIResponse1       0x018
#define MMC_MMCIResponse2       0x01c
#define MMC_MMCIResponse3       0x020
#define MMC_MMCIDataLength      0x028
#define MMC_MMCIDataCtrl        0x02c
#define MMC_MMCIDataCnt         0x030
#define MMC_MMCIStatus          0x034
#define MMC_MMCIClear           0x038
#define MMC_MMCIFIFO            0x080

#define KERNEL_START_ADDRESS    0x04000000

#define MMC_MMCICommand_Enable      (1 << 10)
#define MMC_MMCICommand_Response    (1 << 6)
#define MMC_MMCICommand_LongRsp     (1 << 7)

#define MMC_MMCIStatus_CmdTimeOut   (1 << 2)
#define MMC_MMCIStatus_CmdRespEnd   (1 << 6)

#define MMC_OCR_Busy                (1 << 31)
#define MMC_OCR_CCS                 (1 << 30)



void boot(void)
{
    /* Send CMD0 to reset the card */
    regwrite32(MMC + MMC_MMCICommand, 0 | MMC_MMCICommand_Enable);

    /* Send CMD8 to see if the card supports the 2.0 standard */
    regwrite32(MMC + MMC_MMCIArgument, (1 << 8) | 0xaa);
    regwrite32(MMC + MMC_MMCICommand, 8 | MMC_MMCICommand_Enable | MMC_MMCICommand_Response);
    uint32_t status;
    do
    {
        status = regread32(MMC + MMC_MMCIStatus);
    }
    while (!((status & MMC_MMCIStatus_CmdTimeOut) | (status & MMC_MMCIStatus_CmdRespEnd)));
    uint32_t response;
    if (status & MMC_MMCIStatus_CmdRespEnd)
    {
        response = regread32(MMC + MMC_MMCIResponse0);
        console_puts("CMD8: Returned response [0x");
        console_hexprint(response);
        console_puts("]\r\n");
        if ((response & 0xff) == 0xaa)
        {
            console_puts("CMD8: Response matches check pattern\r\n");
        }
        else
        {
            console_puts("CMD8: Response does not match check pattern\r\n");
        }
    }
    else if (status & MMC_MMCIStatus_CmdTimeOut)
    {
        console_puts("CMD8: Timed out\r\n");
    }

    /* Send ACMD41 to do voltage/capacity negotiation */
    do
    {
        regwrite32(MMC + MMC_MMCICommand, 55 | MMC_MMCICommand_Enable);
        regwrite32(MMC + MMC_MMCIArgument, 0x40ff8000); /* all voltages plus high capacity support */
        regwrite32(MMC + MMC_MMCICommand, 41 | MMC_MMCICommand_Enable | MMC_MMCICommand_Response);
        response = regread32(MMC + MMC_MMCIResponse0);
    }
    while (!(response & MMC_OCR_Busy));
    console_puts("ACMD41: Card powered up\r\n");
    if (response & MMC_OCR_CCS)
        console_puts("AMCD41: Card is high capacity\r\n");
    else
        console_puts("ACMD41: Card is standard capacity\r\n");

    /* Send CMD2 to get card identification */
    regwrite32(MMC + MMC_MMCICommand, 2 | MMC_MMCICommand_Enable | MMC_MMCICommand_Response);

    /* Send CMD3 to get relative card address */
    regwrite32(MMC + MMC_MMCICommand, 3 | MMC_MMCICommand_Enable | MMC_MMCICommand_Response);
    response = regread32(MMC + MMC_MMCIResponse0);
    uint32_t relative_card_address = response & 0xffff0000;
    
    /* Send CMD9 to get card specific data register and calculate capacity */
    regwrite32(MMC + MMC_MMCIArgument, relative_card_address);
    regwrite32(MMC + MMC_MMCICommand, 9 | MMC_MMCICommand_Enable | MMC_MMCICommand_LongRsp | MMC_MMCICommand_Response);
    console_hexprint(regread32(MMC + MMC_MMCIResponse0));
    console_hexprint(regread32(MMC + MMC_MMCIResponse1));
    console_hexprint(regread32(MMC + MMC_MMCIResponse2));
    console_hexprint(regread32(MMC + MMC_MMCIResponse3));
    console_puts("\r\n");
    uint32_t card_c_size = ((regread32(MMC + MMC_MMCIResponse2) >> 30) & 0b11) | ((regread32(MMC + MMC_MMCIResponse1) & 0b1111111111) << 2);
    console_puts("c_size is: ");
    console_hexprint(card_c_size);
    console_puts("\r\n");
    uint32_t card_c_size_mult = (regread32(MMC + MMC_MMCIResponse2) >> 15) & 0b111;
    console_puts("c_size_mult is: ");
    console_hexprint(card_c_size_mult);
    console_puts("\r\n");
    uint32_t card_read_bl_len = (regread32(MMC + MMC_MMCIResponse1) >> 16) & 0b1111;
    console_puts("read_bl_len is: ");
    console_hexprint(card_read_bl_len);
    console_puts("\r\n");
    uint32_t card_capacity = (card_c_size + 1) * (1 << (card_c_size_mult + 2));
    uint32_t card_block_size = 1 << card_read_bl_len;
    console_puts("Card capacity is: ");
    console_hexprint(card_capacity);
    console_puts("\r\n");
    console_puts("Block size is: ");
    console_hexprint(card_block_size);
    console_puts("\r\n");

    /* Send CMD7 to select card */
    regwrite32(MMC + MMC_MMCIArgument, relative_card_address);
    regwrite32(MMC + MMC_MMCICommand, 7 | MMC_MMCICommand_Enable);


    console_getc();



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
