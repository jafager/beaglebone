#include "stdint.h"
#include "reg.h"



uint32_t regread32(uint32_t address)
{
    return REG(address);
}



void regwrite32(uint32_t address, uint32_t value)
{
    REG(address) = value;
}



void regmask32(uint32_t address, uint32_t mask, uint32_t value)
{
    uint32_t contents = regread32(address);
    contents &= ~mask;
    contents |= value;
    regwrite32(address, contents);
}
