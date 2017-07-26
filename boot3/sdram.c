#include "reg.h"
#include "sdram.h"

void sdram_init(void)
{
    /* Enable EMIF clocks */
    regmask32(CM_PER + CM_PER_EMIF_CLKCTRL, CM_PER_EMIF_CLKCTRL_MODULEMODE, CM_PER_EMIF_CLKCTRL_MODULEMODE_ENABLE);

    /* Wait for EMIF clocks to stabilize */
    while ((regread32(CM_PER + CM_PER_EMIF_CLKCTRL) & CM_PER_EMIF_CLKCTRL_MODULEMODE) != CM_PER_EMIF_CLKCTRL_MODULEMODE_ENABLE);

    /* Put DPLL in MN_Bypass status */
    regmask32(CM_WKUP + CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DDR_DPLL_EN, CM_CLKMODE_DPLL_DDR_DPLL_EN_MN_BYPASS);

    /* Wait for DPLL to go into MN_Bypass status */
    while(!(regread32(CM_WKUP + CM_IDLEST_DPLL_DDR) & CM_IDLEST_DPLL_DDR_ST_MN_BYPASS));

    /* Set DPLL bypass clock, multiplier, and divider */
    regmask32(CM_WKUP + CM_CLKSEL_DPLL_DDR, CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL | CM_CLKSEL_DPLL_DDR_DPLL_MULT | CM_CLKSEL_DPLL_DDR_DPLL_DIV, CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL_CLKINP | CM_CLKSEL_DPLL_DDR_DPLL_MULT_265 | CM_CLKSEL_DPLL_DDR_DPLL_DIV_23);

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
    regwrite32(EMIF0 + EMIF_SDRAM_TIM_1, 0x0aaad4db);
    regwrite32(EMIF0 + EMIF_SDRAM_TIM_1_SHDW, 0x0aaad4db);
    regwrite32(EMIF0 + EMIF_SDRAM_TIM_2, 0x266b7fda);
    regwrite32(EMIF0 + EMIF_SDRAM_TIM_2_SHDW, 0x266b7fda);
    regwrite32(EMIF0 + EMIF_SDRAM_TIM_3, 0x501f867f);
    regwrite32(EMIF0 + EMIF_SDRAM_TIM_3_SHDW, 0x501f867f);

    /* Configure SDRAM */
    regwrite32(EMIF0 + EMIF_SDRAM_REF_CTRL, 0x2800);
    regwrite32(EMIF0 + EMIF_ZQ_CONFIG, 0x50074be4);
    regwrite32(CTRL + CTRL_CONTROL_EMIF_SDRAM_CONFIG, 0x61c05332);
    regwrite32(EMIF0 + EMIF_SDRAM_CONFIG, 0x61c05332);
    regwrite32(EMIF0 + EMIF_SDRAM_REF_CTRL, 0xc30);
    regwrite32(EMIF0 + EMIF_SDRAM_REF_CTRL_SHDW, 0xc30);
    regwrite32(EMIF0 + EMIF_SDRAM_CONFIG, 0x61c05332);

}
