#include "stdint.h"
#include "reg.h"
#include "led.h"
#include "console.h"
#include "mmc.h"



void boot(void)
{
    /* Enable clocks for the MMC0 module */
    regmask32(CM_PER + CM_PER_MMC0_CLKCTRL, CM_PER_MMC0_CLKCTRL_MODULEMODE, CM_PER_MMC0_CLKCTRL_MODULEMODE_ENABLE);
    console_puts("MMC0 clocks enabled.\r\n");

    /* Initiate soft reset */
    regwrite32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_SOFTRESET);
    console_puts("Initiating soft reset.\r\n");

    /* Wait for soft reset to complete */
    while (!(regread32(MMC0 + SD_SYSSTATUS) & SD_SYSSTATUS_RESETDONE));
    console_puts("Soft reset complete.\r\n");

    /* Set controller capabilities (1.8V and 3.0V voltage support) */
    regmask32(MMC0 + SD_CAPA, SD_CAPA_VS, SD_CAPA_VS_18 | SD_CAPA_VS_30);
    console_puts("Controller capabilities set.\r\n");

    /* Disable idle and wakeup behavior */
    regmask32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_CLOCKACTIVITY, SD_SYSCONFIG_CLOCKACTIVITY_BOTH);
    regmask32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_SIDLEMODE, SD_SYSCONFIG_SIDLEMODE_NO_IDLE);
    regmask32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_ENAWAKEUP, SD_SYSCONFIG_ENAWAKEUP_DISABLE);
    regmask32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_AUTOIDLE, SD_SYSCONFIG_AUTOIDLE_DISABLE);
    console_puts("Idle and wakeup behavior disabled.\r\n");

    /* Configure bus transfer modes and bus power */
    regmask32(MMC0 + SD_CON, SD_CON_DW8, SD_CON_DW8_1OR4BIT);
    regmask32(MMC0 + SD_HCTL, SD_HCTL_DTW, SD_HCTL_DTW_1BIT);
    regmask32(MMC0 + SD_HCTL, SD_HCTL_SDVS, SD_HCTL_SDVS_30);
    regmask32(MMC0 + SD_HCTL, SD_HCTL_SDBP, SD_HCTL_SDBP);
    console_puts("Bus transfer modes and bus power configured.\r\n");

    /* Wait for bus power */
    while (!(regread32(MMC0 + SD_HCTL) & SD_HCTL_SDBP));
    console_puts("Bus power online.\r\n");

    /* Enable internal clock */
    regmask32(MMC0 + SD_SYSCTL, SD_SYSCTL_ICE, SD_SYSCTL_ICE);
    regmask32(MMC0 + SD_SYSCTL, SD_SYSCTL_CEN, SD_SYSCTL_CEN);
    regmask32(MMC0 + SD_SYSCTL, SD_SYSCTL_CLKD, SD_SYSCTL_CLKD_1023);
    console_puts("Internal clock enabled.\r\n");

    /* Wait for clock to stabilize */
    while (!(regread32(MMC0 + SD_SYSCTL) & SD_SYSCTL_ICS));
    console_puts("Internal clock stabilized.\r\n");

    /* Enable internal interrupts */
    regmask32(MMC0 + SD_IE, SD_IE_ENABLE_ALL, SD_IE_ENABLE_ALL);
    console_puts("Internal interrupts enabled.\r\n");



    /* This seems like the place where host controller  */
    /* configuration ends and card configuration begins */
    console_puts("Press a key to continue...\r\n");
    console_getc();



    /* Send initialization stream */
    regmask32(MMC0 + SD_CON, SD_CON_INIT, SD_CON_INIT_ENABLE);
    console_puts("Sending initialization stream.\r\n");

    /* Send CMD0 (I don't think this one goes to the card) */
    console_puts("Sending CMD0...\r\n");
    if (!mmc_send_command(0 << SD_CMD_INDX, 0))
    {
        mmc_dump_status();
        while (1);
    }
    console_puts("CMD0 complete.\r\n");

    /* Clear CC internal interrupt */
    regmask32(MMC0 + SD_STAT, SD_STAT_CC, SD_STAT_CC);
    console_puts("CC interrupt cleared.\r\n");

    /* Stop sending initialization stream */
    regmask32(MMC0 + SD_CON, SD_CON_INIT, SD_CON_INIT_DISABLE);
    console_puts("Stopped sending initialization stream.\r\n");

    /* Clear all internal interrupts */
    regmask32(MMC0 + SD_STAT, SD_STAT_CLEAR_ALL, SD_STAT_CLEAR_ALL);
    console_puts("Internal interrupts cleared.\r\n");

    /* TODO: Change clock frequency to fit protocol */

    /* Send CMD0 (this one goes to the card) */
    regwrite32(MMC0 + SD_CMD, 0);
    console_puts("CMD0 sent.\r\n");

    /* Wait for CMD0 to complete */
    do
    {
        status = regread32(MMC0 + SD_STAT);
    }
    while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
    if (status & SD_STAT_ERRI)
    {
        console_puts("Error in CMD0: 0x");
        console_hexprint(status);
        console_puts("\r\n");
        while (1);
    }
    console_puts("CMD0 complete.\r\n");

    /* Clear CC internal interrupt */
    regmask32(MMC0 + SD_STAT, SD_STAT_CC, SD_STAT_CC);
    console_puts("CC interrupt cleared.\r\n");

    /* Send CMD5 */
    regwrite32(MMC0 + SD_ARG, SD_CMD5_VDD_2930 | SD_CMD5_VDD_3031);
    regmask32(MMC0 + SD_CMD, SD_CMD_MASK, (5 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48);
    console_puts("CMD5 sent.\r\n");

    /* Wait for CMD5 to complete */
    do
    {
        status = regread32(MMC0 + SD_STAT);
    }
    while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
    if (status & SD_STAT_CC)
    {
        console_puts("Card is SDIO.\r\n");
        console_puts("SDIO cards are not supported.\r\n");
        while (1);
    }
    if (!(status & SD_STAT_CTO))
    {
        console_puts("Error in CMD5: 0x");
        console_hexprint(status);
        console_puts("\r\n");
        while (1);
    }
    console_puts("CMD5 timed out.\r\n");
    console_puts("Card is not SDIO.\r\n");

    /* Clear CTO internal interrupt */
    regmask32(MMC0 + SD_STAT, SD_STAT_CTO, SD_STAT_CTO);
    console_puts("CTO interrupt cleared.\r\n");

    /* Software reset for mmc_cmd line (yes this is weird but it follows the TRM) */
    regmask32(MMC0 + SD_SYSCTL, SD_SYSCTL_SRC, SD_SYSCTL_SRC);
    while (!(regread32(MMC0 + SD_SYSCTL) & SD_SYSCTL_SRC));
    while (regread32(MMC0 + SD_SYSCTL) & SD_SYSCTL_SRC);
    console_puts("Completed software reset of mmc_cmd line.\r\n");

    /* Send CMD8 */
    regwrite32(MMC0 + SD_ARG, SD_CMD8_VHS_2736 | SD_CMD8_CHECK_PATTERN);
    regmask32(MMC0 + SD_CMD, SD_CMD_MASK, (8 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48);
    console_puts("CMD8 sent.\r\n");

    /* Wait for CMD8 to complete */
    do
    {
        status = regread32(MMC0 + SD_STAT);
    }
    while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
    if ((status & SD_STAT_ERRI) && !(status & SD_STAT_CTO))
    {
        console_puts("Error in CMD8: 0x");
        console_hexprint(status);
        console_puts("\r\n");
        while (1);
    }
    if (status & SD_STAT_CTO)
    {
        console_puts("Card does not support 2.0 specification.\r\n");
        console_puts("Non-2.0 cards are not supported.\r\n");
        while (1);
    }
    if (status & SD_STAT_CC)
    {
        console_puts("Card supports 2.0 specification.\r\n");
        uint32_t response = regread32(MMC0 + SD_RSP10);
        if ((response & 0xff) != SD_CMD8_CHECK_PATTERN)
        {
            console_puts("CMD8 response 0x");
            console_hexprint(response);
            console_puts(" does not match check pattern.\r\n");
            while (1);
        }
        console_puts("CMD8 response matches check pattern.\r\n");
    }

    /* Software reset for mmc_cmd line (yes this is weird but it follows the TRM) */
    regmask32(MMC0 + SD_SYSCTL, SD_SYSCTL_SRC, SD_SYSCTL_SRC);
    while (!(regread32(MMC0 + SD_SYSCTL) & SD_SYSCTL_SRC));
    while (regread32(MMC0 + SD_SYSCTL) & SD_SYSCTL_SRC);
    console_puts("Completed software reset of mmc_cmd line.\r\n");
    /* NOTE: Per the TRM this resets the CC interrupt */

    /* Send CMD55/ACMD41 */
    uint32_t response;
    do
    {
        /* Send CMD55 */
        regwrite32(MMC0 + SD_ARG, 0);
        regmask32(MMC0 + SD_CMD, SD_CMD_MASK, (55 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48);
        do
        {
            status = regread32(MMC0 + SD_STAT);
        }
        while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
        if (status & SD_STAT_ERRI)
        {
            console_puts("Error in CMD55: 0x");
            console_hexprint(status);
            console_puts("\r\n");
            while (1);
        }
        console_puts("CMD55 complete.\r\n");

        /* Clear CC internal interrupt */
        regmask32(MMC0 + SD_STAT, SD_STAT_CC, SD_STAT_CC);
        console_puts("CC interrupt cleared.\r\n");

        /* Send ACMD41 */
        regwrite32(MMC0 + SD_ARG, SD_ACMD41_HCS | SD_ACMD41_VDD_2930 | SD_ACMD41_VDD_3031);
        regmask32(MMC0 + SD_CMD, SD_CMD_MASK, (41 << SD_CMD_INDX) | SD_CMD_RSP_TYPE_48);
        do
        {
            status = regread32(MMC0 + SD_STAT);
        }
        while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
        if (status & SD_STAT_ERRI)
        {
            console_puts("Error in ACMD41: 0x");
            console_hexprint(status);
            console_puts("\r\n");
            console_puts("ACMD41 response: 0x");
            console_hexprint(regread32(MMC0 + SD_RSP10));
            console_puts("\r\n");
            while (1);
        }
        console_puts("ACMD41 complete.\r\n");

        /* Clear CC internal interrupt */
        regmask32(MMC0 + SD_STAT, SD_STAT_CC, SD_STAT_CC);
        console_puts("CC interrupt cleared.\r\n");

        /* Get response */
        response = regread32(MMC0 + SD_RSP10);
    }
    while (!(response & SD_OCR_BUSY));
    console_puts("Card powered up.\r\n");

    /* Determine card capacity type */
    if (response & SD_OCR_CCS)
        console_puts("Card is high capacity.\r\n");
    else
        console_puts("Card is standard capacity.\r\n");

    /* Software reset for mmc_cmd line (yes this is weird but it follows the TRM) */
    regmask32(MMC0 + SD_SYSCTL, SD_SYSCTL_SRC, SD_SYSCTL_SRC);
    while (!(regread32(MMC0 + SD_SYSCTL) & SD_SYSCTL_SRC));
    while (regread32(MMC0 + SD_SYSCTL) & SD_SYSCTL_SRC);
    console_puts("Completed software reset of mmc_cmd line.\r\n");
    /* NOTE: Per the TRM this resets the CC interrupt */

    /* Send CMD2 */
    regwrite32(MMC0 + SD_ARG, 0);
    regmask32(MMC0 + SD_CMD, SD_CMD_MASK, (2 << SD_CMD_INDX) | SD_CMD_RSP_TYPE_48);
    do
    {
        status = regread32(MMC0 + SD_STAT);
    }
    while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
    if (status & SD_STAT_ERRI)
    {
        console_puts("Error in CMD2: 0x");
        console_hexprint(status);
        console_puts("\r\n");
        console_puts("CMD2 response: 0x");
        console_hexprint(regread32(MMC0 + SD_RSP10));
        console_puts("\r\n");
        while (1);
    }
    console_puts("CMD2 complete.\r\n");

    /* Clear CC internal interrupt */
    regwrite32(MMC0 + SD_STAT, 0);
    //regmask32(MMC0 + SD_STAT, SD_STAT_CC, SD_STAT_CC);
    console_puts("CC interrupt cleared.\r\n");

    /* Send CMD3 */
    regwrite32(MMC0 + SD_ARG, 0);
    regmask32(MMC0 + SD_CMD, SD_CMD_MASK, (3 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_48);
    do
    {
        status = regread32(MMC0 + SD_STAT);
    }
    while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
    if (status & SD_STAT_ERRI)
    {
        console_puts("Error in CMD3: 0x");
        console_hexprint(status);
        console_puts("\r\n");
        console_puts("CMD3 response: 0x");
        console_hexprint(regread32(MMC0 + SD_RSP10));
        console_puts("\r\n");
        while (1);
    }
    console_puts("CMD3 complete.\r\n");

    /* Get relative card address from CMD3 response */
    uint32_t relative_card_address = regread32(MMC0 + SD_RSP10) & 0xffff0000;
    console_puts("RCA from CMD3 is ");
    console_hexprint(relative_card_address);
    console_puts("\r\n");

    /* Clear CC internal interrupt */
    regmask32(MMC0 + SD_STAT, SD_STAT_CC, SD_STAT_CC);
    console_puts("CC interrupt cleared.\r\n");

    /* Send CMD9 */
    regwrite32(MMC0 + SD_ARG, relative_card_address);
    regmask32(MMC0 + SD_CMD, SD_CMD_MASK, (9 << SD_CMD_INDX) | SD_CMD_CICE | SD_CMD_CCCE | SD_CMD_RSP_TYPE_136);
    do
    {
        status = regread32(MMC0 + SD_STAT);
    }
    while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
    if (status & SD_STAT_ERRI)
    {
        console_puts("Error in CMD9: 0x");
        console_hexprint(status);
        console_puts("\r\n");
        while (1);
    }
    console_puts("CMD9 complete.\r\n");

    /* Get long response */
    uint32_t long_response[4];
    long_response[0] = regread32(MMC0 + SD_RSP10);
    long_response[1] = regread32(MMC0 + SD_RSP32);
    long_response[2] = regread32(MMC0 + SD_RSP54);
    long_response[3] = regread32(MMC0 + SD_RSP76);

    /* Calculate card capacity */
    uint32_t c_size = ((long_response[1] >> 30) & 0b11) | ((long_response[2] & 0x3ff) << 2);
    uint32_t c_size_mult = (long_response[1] >> 15) & 0b111;
    uint32_t read_bl_len = (long_response[2] >> 16) & 0b1111;
    uint32_t mult = 1 << (c_size_mult + 2);
    uint32_t blocknr = (c_size + 1) * mult;
    uint32_t block_len = 1 << read_bl_len;
    uint32_t capacity = blocknr * block_len;
    console_puts("c_size: ");
    console_hexprint(c_size);
    console_puts("\r\n");
    console_puts("c_size_mult: ");
    console_hexprint(c_size_mult);
    console_puts("\r\n");
    console_puts("read_bl_len: ");
    console_hexprint(read_bl_len);
    console_puts("\r\n");
    console_puts("mult: ");
    console_hexprint(mult);
    console_puts("\r\n");
    console_puts("blocknr: ");
    console_hexprint(blocknr);
    console_puts("\r\n");
    console_puts("block_len: ");
    console_hexprint(block_len);
    console_puts("\r\n");
    console_puts("capacity: ");
    console_hexprint(capacity);
    console_puts("\r\n");
}
