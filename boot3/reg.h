#ifndef REG_H
#define REG_H



#include "stdint.h"



#define REG(address)    (*((volatile uint32_t *)(address)))



uint32_t regread32(uint32_t address);
void regwrite32(uint32_t address, uint32_t value);
void regmask32(uint32_t address, uint32_t mask, uint32_t value);



#endif /* REG_H */
