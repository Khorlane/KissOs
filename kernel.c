#include "screen.h"

// ****************************
// Kernel execution starts here
// ****************************

void main()
{
  int i;
  i = 0;
  while (i < 500000000)
    i++;
  terminal_initialize();
  terminal_writestring("Hello World from KissOs v.0E!\n"); // No newline support(yet), we get some VGA char
  terminal_writestring("More stuff!");
}
