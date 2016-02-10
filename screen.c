// Hardware text mode color constants
enum vga_color
{
  COLOR_BLACK         = 0,
  COLOR_BLUE          = 1,
  COLOR_GREEN         = 2,
  COLOR_CYAN          = 3,
  COLOR_RED           = 4,
  COLOR_MAGENTA       = 5,
  COLOR_BROWN         = 6,
  COLOR_LIGHT_GREY    = 7,
  COLOR_DARK_GREY     = 8,
  COLOR_LIGHT_BLUE    = 9,
  COLOR_LIGHT_GREEN   = 10,
  COLOR_LIGHT_CYAN    = 11,
  COLOR_LIGHT_RED     = 12,
  COLOR_LIGHT_MAGENTA = 13,
  COLOR_LIGHT_BROWN   = 14,
  COLOR_WHITE         = 15,
};

#define VGA_WIDTH  80
#define VGA_HEIGHT 25
 
// Global Variables
unsigned short  c16;
unsigned short  color16;
unsigned int    terminal_row;
unsigned int    terminal_column;
unsigned char   terminal_color;
unsigned short* terminal_buffer;
unsigned int		ret;
unsigned int    index;
unsigned int    i;
unsigned int    x;
unsigned int    y;
unsigned int    datalen;

// ********************************************
// Supporting functions
// ********************************************

unsigned char make_color(enum vga_color fg, enum vga_color bg)
{
  return fg | bg << 4;
}
 
unsigned short make_vgaentry(char c, unsigned char color)
{
  c16     = c;
  color16 = color;
  return c16 | color16 << 8;
}

// *******************
// Terminal Initialize
// *******************
 
void terminal_initialize()
{
  terminal_row    = 0;
  terminal_column = 0;
  terminal_color  = make_color(COLOR_LIGHT_GREY, COLOR_BLUE);
  terminal_buffer = (unsigned short*) 0xB8000;
  for (y = 0; y < VGA_HEIGHT; y++)
  {
    for (x = 0; x < VGA_WIDTH; x++)
    {
      index = y * VGA_WIDTH + x;
      terminal_buffer[index] = make_vgaentry(' ', terminal_color);
    }
  }
}

// *************************************
// Write String and supporting functions
// *************************************

void terminal_putentryat(char c)
{
  index = terminal_row * VGA_WIDTH + terminal_column;
  terminal_buffer[index] = make_vgaentry(c, terminal_color);
}

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
  ret = 0;
  while (str[ret] != 0)
    ret++;
  return ret;
}

void terminal_writestring(const char* data)
{
  datalen = strlen(data);
  for (i = 0; i < datalen; i++)
    terminal_putchar(data[i]);
}
