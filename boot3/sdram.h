#ifndef SDRAM_H
#define SDRAM_H



#define CM_CLKMODE_DPLL_DDR                             0x94
#define CM_CLKMODE_DPLL_DDR_DPLL_EN                     (0b111 << 0)
#define CM_CLKMODE_DPLL_DDR_DPLL_EN_MN_BYPASS           (0x4 << 0)
#define CM_CLKMODE_DPLL_DDR_DPLL_EN_LOCK                (0x7 << 0)
#define CM_CLKSEL_DPLL_DDR                              0x40
#define CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL              (1 << 23)
#define CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL_CLKINP       (0 << 23)
#define CM_CLKSEL_DPLL_DDR_DPLL_BYP_CLKSEL_CLKINPULOW   (1 << 23)
#define CM_CLKSEL_DPLL_DDR_DPLL_DIV                     (0x7f << 0)
#define CM_CLKSEL_DPLL_DDR_DPLL_DIV_23                  (0x17 << 0)
#define CM_CLKSEL_DPLL_DDR_DPLL_MULT                    (0x7ff << 8)
#define CM_CLKSEL_DPLL_DDR_DPLL_MULT_265                (0x109 << 8)
#define CMD0_REG_PHY_CTRL_SLAVE_RATIO_0                 0x01c
#define CMD0_REG_PHY_DLL_LOCK_DIFF_0                    0x028
#define CMD0_REG_PHY_INVERT_CLKOUT_0                    0x02c
#define CMD1_REG_PHY_CTRL_SLAVE_RATIO_0                 0x050
#define CMD1_REG_PHY_DLL_LOCK_DIFF_0                    0x05c
#define CMD1_REG_PHY_INVERT_CLKOUT_0                    0x060
#define CMD2_REG_PHY_CTRL_SLAVE_RATIO_0                 0x084
#define CMD2_REG_PHY_DLL_LOCK_DIFF_0                    0x090
#define CMD2_REG_PHY_INVERT_CLKOUT_0                    0x094
#define CM_DIV_M2_DPLL_DDR                              0xa0
#define CM_DIV_M2_DPLL_DDR_DPLL_CLKOUT_DIV              (0b11111 << 0)
#define CM_DIV_M2_DPLL_DDR_DPLL_CLKOUT_DIV_1            (0x1 << 0)
#define CM_IDLEST_DPLL_DDR                              0x34
#define CM_IDLEST_DPLL_DDR_ST_DPLL_CLK                  (1 << 0)
#define CM_IDLEST_DPLL_DDR_ST_MN_BYPASS                 (1 << 8)
#define CM_PER                                          0x44e00000
#define CM_PER_EMIF_CLKCTRL                             0x28
#define CM_PER_EMIF_CLKCTRL_MODULEMODE                  (0b11 << 0)
#define CM_PER_EMIF_CLKCTRL_MODULEMODE_ENABLE           (0b10 << 0)
#define CM_WKUP                                         0x44e00400
#define CTRL                                            0x44e10000
#define CTRL_CONTROL_EMIF_SDRAM_CONFIG                  0x110
#define CTRL_DDR_CKE_CTRL                               0x131c
#define CTRL_DDR_CMD0_IOCTRL                            0x1404
#define CTRL_DDR_CMD1_IOCTRL                            0x1408
#define CTRL_DDR_CMD2_IOCTRL                            0x140c
#define CTRL_DDR_DATA0_IOCTRL                           0x1440
#define CTRL_DDR_DATA1_IOCTRL                           0x1444
#define CTRL_VTP_CTRL                                   0xe0c
#define CTRL_VTP_CTRL_CLRZ                              (1 << 1)
#define CTRL_VTP_CTRL_CLRZ_HIGH                         (1 << 1)
#define CTRL_VTP_CTRL_CLRZ_LOW                          (0 << 1)
#define CTRL_VTP_CTRL_ENABLE                            (1 << 6)
#define CTRL_VTP_CTRL_READY                             (1 << 5)
#define DATA0_REG_PHY_DLL_LOCK_DIFF_0                   0x138
#define DATA0_REG_PHY_FIFO_WE_SLAVE_RATIO_0             0x108
#define DATA0_REG_PHY_GATELVL_INIT_RATIO_0              0x0fc
#define DATA0_REG_PHY_RD_DQS_SLAVE_RATIO_0              0x0c8
#define DATA0_REG_PHY_USE_RANK0_DELAYS                  0x134
#define DATA0_REG_PHY_WR_DATA_SLAVE_RATIO_0             0x120
#define DATA0_REG_PHY_WR_DQS_SLAVE_RATIO_0              0x0dc
#define DATA0_REG_PHY_WRLVL_INIT_RATIO_0                0x0f0
#define DATA1_REG_PHY_DLL_LOCK_DIFF_0                   0x1dc
#define DATA1_REG_PHY_FIFO_WE_SLAVE_RATIO_0             0x1ac
#define DATA1_REG_PHY_GATELVL_INIT_RATIO_0              0x1a0
#define DATA1_REG_PHY_RD_DQS_SLAVE_RATIO_0              0x16c
#define DATA1_REG_PHY_USE_RANK0_DELAYS                  0x1d8
#define DATA1_REG_PHY_WR_DATA_SLAVE_RATIO_0             0x1c4
#define DATA1_REG_PHY_WR_DQS_SLAVE_RATIO_0              0x180
#define DATA1_REG_PHY_WRLVL_INIT_RATIO_0                0x194
#define DDR_PHY                                         0x44e12000
#define EMIF0                                           0x4c000000
#define EMIF_DDR_PHY_CTRL_1                             0xe4
#define EMIF_DDR_PHY_CTRL_1_SHDW                        0xe8
#define EMIF_SDRAM_CONFIG                               0x08
#define EMIF_SDRAM_REF_CTRL                             0x10
#define EMIF_SDRAM_REF_CTRL_SHDW                        0x14
#define EMIF_SDRAM_TIM_1                                0x18
#define EMIF_SDRAM_TIM_1_SHDW                           0x1c
#define EMIF_SDRAM_TIM_2                                0x20
#define EMIF_SDRAM_TIM_2_SHDW                           0x24
#define EMIF_SDRAM_TIM_3                                0x28
#define EMIF_SDRAM_TIM_3_SHDW                           0x2c
#define EMIF_ZQ_CONFIG                                  0xc8



void sdram_init(void);



#endif /* SDRAM_H */
