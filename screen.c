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
#define LIGHT_YELLOW  0x0E
#define WHITE         0x0F

#define VGA_WIDTH  80
#define VGA_HEIGHT 25

typedef unsigned char  byte1;
typedef unsigned short byte2;
typedef unsigned int   byte4;

// Global Variables
byte4    ScrnRow;
byte4    ScrnCol;
char*    ScrnBuff;
byte1    fg;
byte1    bg;
byte1    Color;


// ************************************
// outb - talk to the VGA hardware port
// ************************************

void outb(byte2 port, byte1 value)
{
  asm volatile ("outb %1, %0" : : "dN" (port), "a" (value));
}

// ************************
// MoveCursor - move blinky
// ************************

void MoveCursor()
{
  byte4 Loc;

  Loc = ScrnRow * 80 + ScrnCol;
  outb(0x3D4, 14);
  outb(0x3D5, Loc >> 8);
  outb(0x3D4, 15);
  outb(0x3D5, Loc);
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

// **************************************
// SetColor - change the foreground color
// **************************************

void SetColor(char c)
{
  switch(c)
  {
    case 'B' :
      fg = LIGHT_BLUE;
      break;
    case 'G' :
      fg = LIGHT_GREEN;
      break;
    case 'C' :
      fg = LIGHT_CYAN;
      break;
    case 'R' :
      fg = LIGHT_RED;
      break;
    case 'M' :
      fg = LIGHT_MAGENTA;
      break;
    case 'Y' :
      fg = LIGHT_YELLOW;
      break;
    case 'W' :
      fg = WHITE;
      break;
    case 'N' :
      fg = LIGHT_GREY;
      break;
    default :
      fg = LIGHT_GREY;
  }
  MakeColor();
}

// ********************************
// StrLen - return length of string
// ********************************

byte4 StrLen(const char* str)
{
  byte4 Len;

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
  byte4 Index;
  
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
  ScrnRow = 0;
  ScrnCol = 0;
}

// ***************************
// ScrnPutChar - put character
// ***************************

void ScrnPutChar(char c)
{
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

// ************************************
// ScrnWrite - write string to terminal
// ************************************

void ScrnWrite(const char* data)
{
  byte4 i;
  byte4 Len;

  Len = StrLen(data);
  for (i = 0; i < Len; i++)
  {
    if (data[i] == '&')
    {
      i++;
      SetColor(data[i]);
      i++;
    }
    ScrnPutChar(data[i]);
  }
  MoveCursor();
}
