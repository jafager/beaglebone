#ifndef MMC_H
#define MMC_H



#include "stdint.h"



#define MMC_ERROR                                   0
#define MMC_SUCCESS                                 1



#define CM_PER                                      0x44e00000
#define CM_PER_MMC0_CLKCTRL                         0x3c
#define CM_PER_MMC0_CLKCTRL_MODULEMODE              (0b11 << 0)
#define CM_PER_MMC0_CLKCTRL_MODULEMODE_ENABLE       (0b10 << 0)
#define MMC0                                        0x48060000
#define SD_ARG                                      0x208
#define SD_CAPA                                     0x240
#define SD_CAPA_VS                                  (0b111 << 24)
#define SD_CAPA_VS_18                               (1 << 26)
#define SD_CAPA_VS_30                               (1 << 25)
#define SD_CMD                                      0x20c
#define SD_CMD_CCCE                                 (1 << 19)
#define SD_CMD_CICE                                 (1 << 20)
#define SD_CMD_INDX                                 24
#define SD_CMD_MASK                                 0x3ffb0037
#define SD_CMD_RSP_TYPE_NONE                        (0x0 << 16)
#define SD_CMD_RSP_TYPE_48                          (0x2 << 16)
#define SD_CMD_RSP_TYPE_136                         (0x1 << 16)
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
#define SD_STAT_CTO                                 (1 << 16)
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
#define SD_SYSCTL_SRC                               (1 << 25)
#define SD_SYSSTATUS                                0x114
#define SD_SYSSTATUS_RESETDONE                      (1 << 0)
#define SD_CMD8_VHS_2736                            (1 << 8)
#define SD_CMD8_CHECK_PATTERN                       (0xaa << 0)
#define SD_RSP10                                    0x210
#define SD_RSP32                                    0x214
#define SD_RSP54                                    0x218
#define SD_RSP76                                    0x21c
#define SD_CMD5_VDD_2930                            (1 << 17)
#define SD_CMD5_VDD_3031                            (1 << 18)
#define SD_ACMD41_VDD_2930                          (1 << 17)
#define SD_ACMD41_VDD_3031                          (1 << 18)
#define SD_ACMD41_HCS                               (1 << 30)
#define SD_OCR_BUSY                                 (1 << 31)
#define SD_OCR_CCS                                  (1 << 30)



uint32_t mmc_send_command(uint32_t command, uint32_t, argument);
