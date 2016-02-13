#---------------
# Build KissOs -
#---------------

# Make requires that first character of a recipe is a TAB!!

# Build it all
all : KissOs.bin

# Build KissOs.bin
KissOs.bin : BootSector.bin Kernel.bin
	cat BootSector.bin Kernel.bin > KissOs.bin

# Build Kernel.bin
Kernel.bin : KernelEntry.o Kernel.o Screen.o
	ld -o Kernel.bin -Ttext 0x1000 KernelEntry.o Kernel.o Screen.o --oformat binary --entry main

# Build Screen.o
Screen.o : Screen.c
	gcc -ffreestanding -c Screen.c -o Screen.o

# Build Kernel.o
Kernel.o : Kernel.c
	gcc -ffreestanding -c Kernel.c -o Kernel.o

# Build KernelEntry.o
KernelEntry.o : KernelEntry.asm
	nasm KernelEntry.asm -f elf -o KernelEntry.o

# Build the boot sector 
BootSector.bin : BootSector.asm
	nasm BootSector.asm -f bin -o BootSector.bin

# Clean Up
clean :
	rm -fr KissOs.bin
	rm -fr Kernel.bin
	rm -fr BootSector.bin
	rm -fr KernelEntry.o
	rm -fr Kernel.o
	rm -fr Screen.o
