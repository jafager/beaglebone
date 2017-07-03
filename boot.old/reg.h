#include <stdint.h>



#ifndef _REG_H_
#define _REG_H_



#define REG(address)    (*((volatile uint32_t *)(address)))



inline uint32_t read32(uint32_t address)
{
    return REG(address);
}



inline void write32(uint32_t address, uint32_t value)
{
    REG(address) = value;
}



inline void mask32(uint32_t address, uint32_t mask, uint32_t value)
{
    uint32_t contents = read32(address);
    contents &= ~(mask);
    contents |= (value & mask);
    write32(address, contents);
}



#endif
