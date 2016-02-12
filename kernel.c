#include "screen.h"

// ****************************
// Kernel execution starts here
// ****************************

void main()
{
  int i;
  i = 0;
  while (i < 250000000)
    i++;
  ScrnClear();
  ScrnWrite("Hello cWorldn from KissOs v.0E!\n");
  ScrnWrite("More stuff!");
}
