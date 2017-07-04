#include "stdint.h"
#include "reg.h"
#include "led.h"
#include "console.h"



#define CM_PER                                      0x44e00000
#define CM_PER_MMC0_CLKCTRL                         0x3c
#define CM_PER_MMC0_CLKCTRL_MODULEMODE              (0b11 << 0)
#define CM_PER_MMC0_CLKCTRL_MODULEMODE_ENABLE       (0b10 << 0)
#define MMC0                                        0x48060000
#define SD_CAPA                                     0x240
#define SD_CAPA_VS                                  (0b111 << 24)
#define SD_CAPA_VS_18                               (1 << 26)
#define SD_CAPA_VS_30                               (1 << 25)
#define SD_CMD                                      0x20c
#define SD_CON                                      0x12c
#define SD_CON_DW8                                  (1 << 5)
#define SD_CON_DW8_1OR4BIT                          (0 << 5)
#define SD_CON_INIT                                 (1 << 1)
#define SD_CON_INIT_DISABLE                         (0 << 1)
#define SD_CON_INIT_ENABLE                          (1 << 1)
#define SD_HCTL                                     0x228
#define SD_HCTL_DTW                                 (1 << 1)
#define SD_HCTL_DTW_1BIT                            (0 << 1)
#define SD_HCTL_SDBP                                (1 << 8)
#define SD_HCTL_SDVS                                (0b111 << 9)
#define SD_HCTL_SDVS_30                             (0x6 << 9)
#define SD_IE                                       0x234
#define SD_IE_ENABLE_ALL                            0x337f07ff
#define SD_STAT                                     0x230
#define SD_STAT_CC                                  (1 << 0)
#define SD_STAT_CLEAR_ALL                           0x337f07ff
#define SD_STAT_ERRI                                (1 << 15)
#define SD_SYSCONFIG                                0x110
#define SD_SYSCONFIG_AUTOIDLE                       (1 << 0)
#define SD_SYSCONFIG_AUTOIDLE_DISABLE               (0 << 0)
#define SD_SYSCONFIG_CLOCKACTIVITY                  (0b11 << 8)
#define SD_SYSCONFIG_CLOCKACTIVITY_BOTH             (0b11 << 8)
#define SD_SYSCONFIG_ENAWAKEUP                      (1 << 2)
#define SD_SYSCONFIG_ENAWAKEUP_DISABLE              (0 << 2)
#define SD_SYSCONFIG_SIDLEMODE                      (0b11 << 3)
#define SD_SYSCONFIG_SIDLEMODE_NO_IDLE              (0b01 << 3)
#define SD_SYSCONFIG_SOFTRESET                      (1 << 1)
#define SD_SYSCTL                                   0x22c
#define SD_SYSCTL_CEN                               (1 << 2)
#define SD_SYSCTL_CLKD                              (0x3ff << 6)
#define SD_SYSCTL_CLKD_1023                         (0x3ff << 6)
#define SD_SYSCTL_ICE                               (1 << 0)
#define SD_SYSCTL_ICS                               (1 << 1)
#define SD_SYSSTATUS                                0x114
#define SD_SYSSTATUS_RESETDONE                      (1 << 0)



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

    /* Send initialization stream */
    regmask32(MMC0 + SD_CON, SD_CON_INIT, SD_CON_INIT_ENABLE);
    console_puts("Sending initialization stream.\r\n");

    /* Send CMD0 */
    regwrite32(MMC0 + SD_CMD, 0);
    console_puts("CMD0 sent.\r\n");

    /* Wait for CMD0 to complete */
    uint32_t status;
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

    /* Stop sending initialization stream */
    regmask32(MMC0 + SD_CON, SD_CON_INIT, SD_CON_INIT_DISABLE);
    console_puts("Stopped sending initialization stream.\r\n");

    /* Clear all internal interrupts */
    regmask32(MMC0 + SD_STAT, SD_STAT_CLEAR_ALL, SD_STAT_CLEAR_ALL);
    console_puts("Internal interrupts cleared.\r\n");
}