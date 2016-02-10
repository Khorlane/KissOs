#include "screen.h"

// ****************************
// Kernel execution starts here
// ****************************

void main()
{
  terminal_initialize();
  terminal_writestring("Hello World from KissOs v.0D!\n"); // No newline support(yet), we get some VGA char
}
