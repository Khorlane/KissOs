// Hardware text mode Color constants
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
unsigned int    ScrnRow;
unsigned int    ScrnCol;
unsigned char   Color;
         char*  ScrnBuff;
unsigned int		Len;
unsigned int    Index;
unsigned int    i;
unsigned int    x;
unsigned int    y;
unsigned int    CursorLoc;
unsigned char   fg;
unsigned char   bg;

void outb(unsigned short port, unsigned char value)
{
  asm volatile ("outb %1, %0" : : "dN" (port), "a" (value));
}

void MoveCursor()
{
  CursorLoc = ScrnRow * 80 + ScrnCol;
  outb(0x3D4, 14);
  outb(0x3D5, CursorLoc >> 8);
  outb(0x3D4, 15);
  outb(0x3D5, CursorLoc);
}

// *****************************
// MakeColor - combine fg and bg
// *****************************

void MakeColor()
{
  Color = bg;
  Color = Color << 4;
  Color = Color | fg;
}

// ********************************
// StrLen - return length of string
// ********************************
unsigned int StrLen(const char* str)
{
  unsigned int Len;
  Len = 0;
  while (str[Len] != 0)
    Len++;
  return Len;
}

// *********************************
// ScrnPutCell - put char plus color
// *********************************

void ScrnPutCell(char c)
{
  Index = ScrnRow * VGA_WIDTH + ScrnCol;
  Index = Index * 2;
  ScrnBuff[Index] = c;
  Index++;
  ScrnBuff[Index] = Color;
}

// *************************************
// ScrnClear - write blanks to all cells
// *************************************
 
void ScrnClear()
{
  fg = LIGHT_GREY;
  bg = BLACK;
  MakeColor();
  ScrnBuff = (char*) 0xB8000;
  for (ScrnRow = 0; ScrnRow < VGA_HEIGHT; ScrnRow++)
  {
    for (ScrnCol = 0; ScrnCol < VGA_WIDTH; ScrnCol++)
    {
      ScrnPutCell(' ');
    }
  }
  ScrnRow    = 0;
  ScrnCol = 0;
}

// ***************************
// ScrnPutChar - put character
// ***************************

void ScrnPutChar(char c)
{
  if (c == 'c')
  {
    fg = LIGHT_CYAN;
    MakeColor();
    return;
  }
  if (c == 'n')
  {
    fg = LIGHT_GREY;
    MakeColor();
    return;
  }
  if (c == '\n')
  {
    ScrnRow++;
    ScrnCol = 0;
    return;
  }
  ScrnPutCell(c);
  ScrnCol++;
  if (ScrnCol == VGA_WIDTH)
  {
    ScrnCol = 0;
    ScrnRow++;
    if (ScrnRow == VGA_HEIGHT)
    {
      ScrnRow = 0;
    }
  }
}

// ScrnWrite - write string to termianl
void ScrnWrite(const char* data)
{
  Len = StrLen(data);
  for (i = 0; i < Len; i++)
    ScrnPutChar(data[i]);
  MoveCursor();
}
