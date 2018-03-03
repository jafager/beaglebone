#include "stdint.h"
#include "reg.h"
#include "console.h"
#include "mmc.h"



void mmc_init(void)
{
    /* Enable clocks for the MMC0 module */
    regmask32(CM_PER + CM_PER_MMC0_CLKCTRL, CM_PER_MMC0_CLKCTRL_MODULEMODE, CM_PER_MMC0_CLKCTRL_MODULEMODE_ENABLE);

    /* Initiate soft reset */
    regwrite32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_SOFTRESET);

    /* Wait for soft reset to complete */
    while (!(regread32(MMC0 + SD_SYSSTATUS) & SD_SYSSTATUS_RESETDONE));

    /* Set controller capabilities (1.8V and 3.0V voltage support) */
    regmask32(MMC0 + SD_CAPA, SD_CAPA_VS, SD_CAPA_VS_18 | SD_CAPA_VS_30);

    /* Disable idle and wakeup behavior */
    regmask32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_CLOCKACTIVITY, SD_SYSCONFIG_CLOCKACTIVITY_BOTH);
    regmask32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_SIDLEMODE, SD_SYSCONFIG_SIDLEMODE_NO_IDLE);
    regmask32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_ENAWAKEUP, SD_SYSCONFIG_ENAWAKEUP_DISABLE);
    regmask32(MMC0 + SD_SYSCONFIG, SD_SYSCONFIG_AUTOIDLE, SD_SYSCONFIG_AUTOIDLE_DISABLE);

    /* Configure bus transfer modes and bus power */
    regmask32(MMC0 + SD_CON, SD_CON_DW8, SD_CON_DW8_1OR4BIT);
    regmask32(MMC0 + SD_HCTL, SD_HCTL_DTW, SD_HCTL_DTW_1BIT);
    regmask32(MMC0 + SD_HCTL, SD_HCTL_SDVS, SD_HCTL_SDVS_30);
    regmask32(MMC0 + SD_HCTL, SD_HCTL_SDBP, SD_HCTL_SDBP);

    /* Wait for bus power */
    while (!(regread32(MMC0 + SD_HCTL) & SD_HCTL_SDBP));

    /* Enable internal clock */
    regmask32(MMC0 + SD_SYSCTL, SD_SYSCTL_ICE, SD_SYSCTL_ICE);
    regmask32(MMC0 + SD_SYSCTL, SD_SYSCTL_CEN, SD_SYSCTL_CEN);
    regmask32(MMC0 + SD_SYSCTL, SD_SYSCTL_CLKD, SD_SYSCTL_CLKD_1023);

    /* Wait for clock to stabilize */
    while (!(regread32(MMC0 + SD_SYSCTL) & SD_SYSCTL_ICS));

    /* Enable internal interrupts */
    regmask32(MMC0 + SD_IE, SD_IE_ENABLE_ALL, SD_IE_ENABLE_ALL);
}



void mmc_send_initialization_stream(void)
{
    regmask32(MMC0 + SD_CON, SD_CON_INIT, SD_CON_INIT_ENABLE);
    if (!mmc_send_command(0 << SD_CMD_INDX, 0))
        while (1);
    regmask32(MMC0 + SD_CON, SD_CON_INIT, SD_CON_INIT_DISABLE);
    regmask32(MMC0 + SD_STAT, SD_STAT_CLEAR_ALL, SD_STAT_CLEAR_ALL);
}



uint32_t mmc_send_command(uint32_t command, uint32_t argument)
{
    console_puts("mmc_send_command: called\r\n");
    console_puts("command: 0x"); console_hexprint(command); console_puts("\r\n");
    console_puts("argument: 0x"); console_hexprint(argument); console_puts("\r\n");
    regwrite32(MMC0 + SD_ARG, argument);
    regmask32(MMC0 + SD_CMD, SD_CMD_MASK, command);
    uint32_t status;
    uint32_t cycles = 0;
    do
    {
        status = regread32(MMC0 + SD_STAT);
        cycles++;
    }
    while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
    if (status & SD_STAT_ERRI)
    {
        console_puts("mmc_send_command: error\r\n");
        console_puts("cycles: 0x"); console_hexprint(cycles); console_puts("\r\n");
        console_puts("status: 0x"); console_hexprint(status); console_puts("\r\n");
        return MMC_ERROR;
    }
    else if (status & SD_STAT_CC)
    {
        console_puts("mmc_send_command: success\r\n");
        console_puts("cycles: 0x"); console_hexprint(cycles); console_puts("\r\n");
        console_puts("status: 0x"); console_hexprint(status); console_puts("\r\n");
        regmask32(MMC0 + SD_STAT, SD_STAT_CC, SD_STAT_CC);
        return MMC_SUCCESS;
    }
    else
    {
        console_puts("mmc_send_command: wtf\r\n");
        console_puts("cycles: 0x"); console_hexprint(cycles); console_puts("\r\n");
        console_puts("status: 0x"); console_hexprint(status); console_puts("\r\n");
        return MMC_ERROR;
    }
}
