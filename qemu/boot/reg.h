#ifndef REG_H
#define REG_H



#include "stdint.h"



#define REG(address)    (*((volatile uint32_t *)(address)))



extern inline uint32_t regread32(uint32_t address)
{
    return REG(address);
}



extern inline void regwrite32(uint32_t address, uint32_t value)
{
    REG(address) = value;
}



extern inline void regmask32(uint32_t address, uint32_t mask, uint32_t value)
{
    uint32_t contents = regread32(address);
    contents &= ~mask;
    contents |= value;
    regwrite32(address, contents);
}



#endif /* REG_H */
