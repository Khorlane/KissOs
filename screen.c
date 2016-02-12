// Hardware text mode color constants
#define BLACK         0x00
#define BLUE          0x01
#define GREEN         0x02
#define CYAN          0x03
#define RED           0x04
#define MAGENTA       0x05
#define BROWN         0x06
#define LIGHT_GREY    0x07
#define DARK_GREY     0x08
#define LIGHT_BLUE    0x09
#define LIGHT_GREEN   0x0A
#define LIGHT_CYAN    0x0B
#define LIGHT_RED     0x0C
#define LIGHT_MAGENTA 0x0D
#define LIGHT_BROWN   0x0E
#define WHITE         0x0F

#define VGA_WIDTH  80
#define VGA_HEIGHT 25
 
// Global Variables
unsigned int    terminal_row;
unsigned int    terminal_column;
unsigned char   color;
         char*  TermBuff;
unsigned int		len;
unsigned int    index;
unsigned int    i;
unsigned int    x;
unsigned int    y;
unsigned int    CursorLoc;

void outb(unsigned short port, unsigned char value)
{
  asm volatile ("outb %1, %0" : : "dN" (port), "a" (value));
}

void MoveCursor()
{
  CursorLoc = terminal_row * 80 + terminal_column;
  outb(0x3D4, 14);
  outb(0x3D5, CursorLoc >> 8);
  outb(0x3D4, 15);
  outb(0x3D5, CursorLoc);
}

// ********************************************
// Supporting functions
// ********************************************

void make_color(unsigned char fg, unsigned char bg)
{
  color = bg;
  color = color << 4;
  color = color | fg;
}

void terminal_putentryat(char c)
{
  index = terminal_row * VGA_WIDTH + terminal_column;
  index = index * 2;
  TermBuff[index] = c;
  index++;
  TermBuff[index] = color;
}

// *******************
// Terminal Initialize
// *******************
 
void terminal_initialize()
{
  make_color(LIGHT_BLUE, BLACK);
  TermBuff = (char*) 0xB8000;
  for (terminal_row = 0; terminal_row < VGA_HEIGHT; terminal_row++)
  {
    for (terminal_column = 0; terminal_column < VGA_WIDTH; terminal_column++)
    {
      terminal_putentryat(' ');
    }
  }
  terminal_row    = 0;
  terminal_column = 0;
}

// *************************************
// Write String and supporting functions
// *************************************

void terminal_putchar(char c)
{
  if (c == '\n')
  {
    terminal_row++;
    terminal_column = 0;
    return;
  }
  terminal_putentryat(c);
  terminal_column++;
  if (terminal_column == VGA_WIDTH)
  {
    terminal_column = 0;
    terminal_row++;
    if (terminal_row == VGA_HEIGHT)
    {
      terminal_row = 0;
    }
  }
}
 
unsigned int strlen(const char* str)
{
  unsigned int len;
  len = 0;
  while (str[len] != 0)
    len++;
  return len;
}

void terminal_writestring(const char* data)
{
  len = strlen(data);
  for (i = 0; i < len; i++)
    terminal_putchar(data[i]);
  MoveCursor();
}
