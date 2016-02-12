#include "screen.h"

// ****************************
// Kernel execution starts here
// ****************************

void main()
{
  int i;
  i = 0;
  while (i < 200000000)
    i++;
  ScrnClear();
  ScrnWrite("&YHello&N &WWorld&N from &BK&Gi&Cs&Rs&MO&Ys&N v.0F!\n");
  ScrnWrite("More stuff!");
}
