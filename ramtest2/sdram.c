#include "reg.h"
#include "sdram.h"



#define CM_PER                                          0x44e00000
#define CM_PER_EMIF_CLKCTRL                             0x28
#define CM_PER_EMIF_CLKCTRL_MODULEMODE                  (0b11 << 0)
#define CM_PER_EMIF_CLKCTRL_MODULEMODE_ENABLE           (0b10 << 0)
#define CM_WKUP                                         0x44e00400
#define CM_CLKMODE_DPLL_DDR                             0x94
#define CM_IDLEST_DPLL_DDR                              0x34
#define CM_CLKMODE_DPLL_DDR_DPLL_EN                     (0b111 << 0)
#define CM_CLKMODE_DPLL_DDR_DPLL_EN_MN_BYPASS           (0x4 << 0)
#define CM_CLKMODE_DPLL_DDR_DPLL_EN_MN_LOCK             (0x7 << 0)
#define CM_CLKSEL_DPLL_DDR                              0x40
#define CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL              (1 << 23)
#define CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL_CLKINP       (0 << 23)
#define CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL_CLKINPULOW   (1 << 23)
#define CM_CLKSEL_DPLL_DDR_DPLL_MULT                    (0x7ff << 8)
#define CM_CLKSEL_DPLL_DDR_DPLL_MULT_265                (0x109 << 8)
#define CM_CLKSEL_DPLL_DDR_DPLL_DIV                     (0x7f << 0)
#define CM_CLKSEL_DPLL_DDR_DPLL_DIV_23                  (0x17 << 0)
#define CM_DIV_M2_DPLL_DDR                              0xa0
#define CM_DIV_M2_DPLL_DDR_DPLL_CLKOUT_DIV              (0b11111 << 0);
#define CM_DIV_M2_DPLL_DDR_DPLL_CLKOUT_DIV_1            (0x1 << 0);
#define CM_IDLEST_DPLL_DDR_ST_MN_BYPASS                 (1 << 8)
#define CM_IDLEST_DPLL_DDR_ST_DPLL_CLK                  (1 << 0)
#define CTRL                                            0x44e10000
#define CTRL_VTP_CTRL                                   0xe0c
#define CTRL_VTP_CTRL_ENABLE                            (1 << 6)
#define CTRL_VTP_CTRL_CLRZ                              (1 << 1)
#define CTRL_VTP_CTRL_CLRZ_LOW                          (0 << 1)
#define CTRL_VTP_CTRL_CLRZ_HIGH                         (1 << 1)
#define CTRL_VTP_CTRL_READY                             (1 << 5)
#define DDR_PHY                                         0x44e12000
#define CMD0_REG_PHY_CTRL_SLAVE_RATIO_0                 0x01c
#define CMD1_REG_PHY_CTRL_SLAVE_RATIO_0                 0x050
#define CMD2_REG_PHY_CTRL_SLAVE_RATIO_0                 0x084
#define CMD0_REG_PHY_DLL_LOCK_DIFF_0                    0x028
#define CMD1_REG_PHY_DLL_LOCK_DIFF_0                    0x05c
#define CMD2_REG_PHY_DLL_LOCK_DIFF_0                    0x090
#define CMD0_REG_PHY_INVERT_CLKOUT_0                    0x02c
#define CMD1_REG_PHY_INVERT_CLKOUT_0                    0x060
#define CMD2_REG_PHY_INVERT_CLKOUT_0                    0x094
#define DATA0_REG_PHY_RD_DQS_SLAVE_RATIO_0              0x0c8
#define DATA1_REG_PHY_RD_DQS_SLAVE_RATIO_0              0x16c
#define DATA0_REG_PHY_WR_DQS_SLAVE_RATIO_0              0x0dc
#define DATA1_REG_PHY_WR_DQS_SLAVE_RATIO_0              0x180
#define DATA0_REG_PHY_WRLVL_INIT_RATIO_0                0x0f0
#define DATA0_REG_PHY_GATELVL_INIT_RATIO_0              0x0fc
#define DATA0_REG_PHY_USE_RANK0_DELAYS                  0x134
#define DATA0_REG_PHY_DLL_LOCK_DIFF_0                   0x138
#define DATA1_REG_PHY_WRLVL_INIT_RATIO_0                0x194
#define DATA1_REG_PHY_GATELVL_INIT_RATIO_0              0x1a0
#define DATA1_REG_PHY_USE_RANK0_DELAYS                  0x1d8
#define DATA1_REG_PHY_DLL_LOCK_DIFF_0                   0x1dc
#define DATA0_REG_PHY_FIFO_WE_SLAVE_RATIO_0             0x108
#define DATA1_REG_PHY_FIFO_WE_SLAVE_RATIO_0             0x1ac
#define DATA0_REG_PHY_WR_DATA_SLAVE_RATIO_0             0x120
#define DATA1_REG_PHY_WR_DATA_SLAVE_RATIO_0             0x1c4
#define CTRL_DDR_CMD0_IOCTRL                            0x1404
#define CTRL_DDR_CMD1_IOCTRL                            0x1408
#define CTRL_DDR_CMD2_IOCTRL                            0x140c
#define CTRL_DDR_DATA0_IOCTRL                           0x1440
#define CTRL_DDR_DATA1_IOCTRL                           0x1444



void sdram_init(void)
{
    /* Enable EMIF clocks */
    regmask32(CM_PER + CM_PER_EMIF_CLKCTRL, CM_PER_EMIF_CLKCTRL_MODULEMODE, CM_PER_EMIF_CLKCTRL_MODULEMODE_ENABLE);

    /* Wait for EMIF clocks to stabilize */
    while (!((regread32(CM_PER + CM_PER_EMIF_CLKCTRL) & CM_PER_EMIF_CLKCTRL_MODULEMODE) != CM_PER_EMIF_CLKCTRL_MODULEMODE_ENABLE));

    /* Put DPLL in MN_Bypass status */
    regmask32(CM_WKUP + CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DDR_DPLL_EN, CM_CLKMODE_DPLL_DDR_DPLL_EN_MN_BYPASS);

    /* Wait for DPLL to go into MN_Bypass status */
    while(!(regread32(CM_WKUP + CM_IDLEST_DPLL_DDR) & CM_IDLEST_DPLL_DDR_ST_MN_BYPASS));

    /* Set DPLL bypass clock, multiplier, and divider */
    regmask32(CM_WKUP + CM_CLKSEL_DPLL_DDR, CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL | CM_CLKSEL_DPLL_DDR_DPLL_MULT | CM_CLKSEL_DPLL_DDR_DPLL_DIV,
        CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL_CLKINP | CM_CLKSEL_DPLL_DDR_DPLL_MULT_265 | CM_CLKSEL_DPLL_DDR_DPLL_DIV_23);

    /* Set DPLL M2 post-divider factor */
    regmask32(CM_WKUP + CM_DIV_M2_DPLL_DDR, CM_DIV_M2_DPLL_DDR_DPLL_CLKOUT_DIV, CM_DIV_M2_DPLL_DDR_DPLL_CLKOUT_DIV_1);

    /* Enable DPLL in lock mode */
    regmask32(CM_WKUP + CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DDR_DPLL_EN, CM_CLKMODE_DPLL_DDR_DPLL_EN_LOCK);

    /* Wait for lock */
    while(!(regread32(CM_WKUP + CM_IDLEST_DPLL_DDR) & CM_IDLEST_DPLL_DDR_ST_DPLL_CLK));

    /* Enable dynamic VTP compensation mode */
    regmask32(CTRL + CTRL_VTP_CTRL, CTRL_VTP_CTRL_ENABLE, CTRL_VTP_CTRL_ENABLE);

    /* TRM: "clears flops, start count again, after low going pulse"
    /* I assume this is a sort of software reset for VTP */
    regmask32(CTRL + CTRL_VTP_CTRL, CTRL_VTP_CTRL_CLRZ, CTRL_VTP_CTRL_CLRZ_LOW);
    regmask32(CTRL + CTRL_VTP_CTRL, CTRL_VTP_CTRL_CLRZ, CTRL_VTP_CTRL_CLRZ_HIGH);

    /* Wait for training sequence to complete */
    while(!(regread32(CTRL + CTRL_VTP_CTRL) & CTRL_VTP_CTRL_READY));

    /* Configure command control registers */
    regwrite32(DDR_PHY + CMD0_REG_PHY_CTRL_SLAVE_RATIO_0, 0x80);
    regwrite32(DDR_PHY + CMD1_REG_PHY_CTRL_SLAVE_RATIO_0, 0x80);
    regwrite32(DDR_PHY + CMD2_REG_PHY_CTRL_SLAVE_RATIO_0, 0x80);
    regwrite32(DDR_PHY + CMD0_REG_PHY_DLL_LOCK_DIFF_0, 1);
    regwrite32(DDR_PHY + CMD1_REG_PHY_DLL_LOCK_DIFF_0, 1);
    regwrite32(DDR_PHY + CMD2_REG_PHY_DLL_LOCK_DIFF_0, 1);
    regwrite32(DDR_PHY + CMD0_REG_PHY_INVERT_CLKOUT_0, 0);
    regwrite32(DDR_PHY + CMD1_REG_PHY_INVERT_CLKOUT_0, 0);
    regwrite32(DDR_PHY + CMD2_REG_PHY_INVERT_CLKOUT_0, 0);

    /* Configure data registers */
    regwrite32(DDR_PHY + DATA0_REG_PHY_RD_DQS_SLAVE_RATIO_0, 0x38);
    regwrite32(DDR_PHY + DATA1_REG_PHY_RD_DQS_SLAVE_RATIO_0, 0x38);
    regwrite32(DDR_PHY + DATA0_REG_PHY_WR_DQS_SLAVE_RATIO_0, 0x44);
    regwrite32(DDR_PHY + DATA1_REG_PHY_WR_DQS_SLAVE_RATIO_0, 0x44);
    regwrite32(DDR_PHY + DATA0_REG_PHY_WRLVL_INIT_RATIO_0, 0);
    regwrite32(DDR_PHY + DATA1_REG_PHY_WRLVL_INIT_RATIO_0, 0);
    regwrite32(DDR_PHY + DATA0_REG_PHY_GATELVL_INIT_RATIO_0, 0);
    regwrite32(DDR_PHY + DATA1_REG_PHY_GATELVL_INIT_RATIO_0, 0);
    regwrite32(DDR_PHY + DATA0_REG_PHY_USE_RANK0_DELAYS, 0);
    regwrite32(DDR_PHY + DATA1_REG_PHY_USE_RANK0_DELAYS, 0);
    regwrite32(DDR_PHY + DATA0_REG_PHY_DLL_LOCK_DIFF_0, 0);
    regwrite32(DDR_PHY + DATA1_REG_PHY_DLL_LOCK_DIFF_0, 0);
    regwrite32(DDR_PHY + DATA0_REG_PHY_FIFO_WE_SLAVE_RATIO_0, 0x7d);
    regwrite32(DDR_PHY + DATA1_REG_PHY_FIFO_WE_SLAVE_RATIO_0, 0x7d);
    regwrite32(DDR_PHY + DATA0_REG_PHY_WR_DATA_SLAVE_RATIO_0, 0x7d);
    regwrite32(DDR_PHY + DATA1_REG_PHY_WR_DATA_SLAVE_RATIO_0, 0x7d);

    /* Configure I/O control registers */
    regwrite32(CTRL + CTRL_DDR_CMD0_IOCTRL, 0x18b);
    regwrite32(CTRL + CTRL_DDR_CMD1_IOCTRL, 0x18b);
    regwrite32(CTRL + CTRL_DDR_CMD2_IOCTRL, 0x18b);
    regwrite32(CTRL + CTRL_DDR_DATA0_IOCTRL, 0x18b);
    regwrite32(CTRL + CTRL_DDR_DATA1_IOCTRL, 0x18b);

    /* Configure PHY */
    regwrite32(EMIF0 + EMIF_DDR_PHY_CTRL_1, 0x00100007);
    regwrite32(EMIF0 + EMIF_DDR_PHY_CTRL_1_SHDW, 0x00100007);

    /* Set CKE to be controlled by EMIF/DDR PHY */
    regwrite32(CTRL + CTRL_DDR_CKE_CTRL, 1);

    /* Set SDRAM timings */

