#include "stdint.h"
#include "mmc.h"



uint32_t mmc_send_command(uint32_t command, uint32_t argument)
{
    regwrite32(MMC0 + SD_ARG, argument);
    regmask32(MMC0 + SD_CMD, SD_CMD_MASK, command);
    uint32_t status;
    do
    {
        status = regread32(MMC0 + SD_STAT);
    }
    while (!((status & SD_STAT_CC) || (status & SD_STAT_ERRI)));
    if (status & SD_STAT_ERRI)
        return MMC_ERROR;
    else
        return MMC_SUCCESS;
}
