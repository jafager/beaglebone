#include "console.h"
#include "mmc.h"
#include "reg.h"



void mmctest(void)
{
    console_puts("mmc_init\r\n");
    mmc_init();

    console_puts("mmc_send_initialization_stream\r\n");
    mmc_send_initialization_stream();

    console_puts("cmd0\r\n");
    if (!mmc_send_command((0 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_NONE, 0))
        while (1);

    console_puts("cmd5\r\n");
    if (!mmc_send_command((5 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48, SD_CMD5_VDD_2930 | SD_CMD5_VDD_3031))
    {
        uint32_t status = regread32(MMC0 + SD_STAT);
        if (status & SD_STAT_CTO)
        {
            console_puts("card is not SDIO\r\n");
            regmask32(MMC0 + SD_STAT, SD_STAT_CTO, SD_STAT_CTO);
        }
        else
            while (1);
    }
    else
    {
        console_puts("card is SDIO\r\n");
        console_puts("SDIO cards are not supported\r\n");
        while (1);
    }

    console_puts("cmd8\r\n");
    if (!mmc_send_command((8 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48, SD_CMD8_VHS_2736 | SD_CMD8_CHECK_PATTERN))
    {
        uint32_t status = regread32(MMC0 + SD_STAT);
        if (status & SD_STAT_CTO)
        {
            console_puts("card is not 2.0\r\n");
            console_puts("only 2.0 cards are supported\r\n");
        }
        while (1);
    }
    else
    {
        uint32_t response = regread32(MMC0 + SD_RSP10);
        if ((response & 0xff) != SD_CMD8_CHECK_PATTERN)
        {
            console_puts("cmd8 response doesn't match check pattern\r\n");
            console_puts("response: ");
            console_print_hexadecimal(response);
            console_puts("\r\n");
            while (1);
        }
    }
    console_puts("card is 2.0\r\n");

    uint32_t response;
    do
    {
        console_puts("acmd55\r\n");
        if (!mmc_send_command((55 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48, 0))
            while (1);

        console_puts("acmd41\r\n");
        if (!mmc_send_command((41 << SD_CMD_INDX) | SD_CMD_RSP_TYPE_48, SD_ACMD41_HCS | SD_ACMD41_VDD_2930 | SD_ACMD41_VDD_3031))
            while (1);

        response = regread32(MMC0 + SD_RSP10);
    }
    while (!(response & SD_OCR_BUSY));
    console_puts("card is powered up\r\n");

    if (response & SD_OCR_CCS)
        console_puts("card is high capacity\r\n");
    else
        console_puts("card is standard capacity\r\n");

    console_puts("cmd2\r\n");
    if (!mmc_send_command((2 << SD_CMD_INDX) | SD_CMD_RSP_TYPE_136, 0))
        while (1);

    console_puts("cmd3\r\n");
    if (!mmc_send_command((3 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48, 0))
        while (1);
    uint32_t relative_card_address = regread32(MMC0 + SD_RSP10) & 0xffff0000;
    console_puts("RCA: ");
    console_print_hexadecimal(relative_card_address);
    console_puts("\r\n");

    console_puts("cmd9\r\n");
    if (!mmc_send_command((9 << SD_CMD_INDX) | SD_CMD_RSP_TYPE_136, relative_card_address))
        while (1);
    uint32_t long_response[4];
    long_response[0] = regread32(MMC0 + SD_RSP10);
    long_response[1] = regread32(MMC0 + SD_RSP32);
    long_response[2] = regread32(MMC0 + SD_RSP54);
    long_response[3] = regread32(MMC0 + SD_RSP76);
    console_puts("response: 0x");
    console_print_hexadecimal(long_response[3]);
    console_print_hexadecimal(long_response[2]);
    console_print_hexadecimal(long_response[1]);
    console_print_hexadecimal(long_response[0]);
    console_puts("\r\n");
    uint32_t c_size = ((long_response[1] >> 16) & 0xffff) | ((long_response[2] << 16) & 0x3ff);
    console_puts("c_size: 0x");
    console_print_hexadecimal(c_size);
    console_puts("\r\n");

    console_puts("cmd7\r\n");
    if (!mmc_send_command((7 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48, relative_card_address))
        while (1);

    console_puts("cmd17\r\n");
    regmask32(MMC0 + SD_BLK, SD_BLK_BLEN, SD_BLK_BLEN_512);
    if (!mmc_send_command((17 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48 | SD_CMD_DP_YES | SD_CMD_DDIR_READ, 0))
        while (1);
    while (!(regread32(MMC0 + SD_PSTATE) & SD_PSTATE_BRE));
    while (regread32(MMC0 + SD_PSTATE) & SD_PSTATE_BRE)
        console_print_hexadecimal(regread32(MMC0 + SD_DATA));

    while(1);
}
