# Make requires that first character of a recipe is a TAB!!

# Build it all
all : kissos.bin

# Build kissos.bin
kissos.bin : boot_sect.bin kernel.bin
	cat boot_sect.bin kernel.bin > kissos.bin

# Build kernel.bin
kernel.bin : kernel_entry.o kernel.o screen.o
	ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o screen.o --oformat binary --entry main

# Build screen.o
screen.o : screen.c
	gcc -ffreestanding -c screen.c -o screen.o

# Build kernel.o
kernel.o : kernel.c
	gcc -ffreestanding -c kernel.c -o kernel.o

# Build kernel_entry.o
kernel_entry.o : kernel_entry.asm
	nasm kernel_entry.asm -f elf -o kernel_entry.o

# Build the boot sector 
boot_sect.bin : boot_sect.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin

# Clean Up
clean :
	rm -fr kissos.bin
	rm -fr kernel.bin
	rm -fr boot_sect.bin
	rm -fr kernel_entry.o
	rm -fr kernel.o
	rm -fr screen.o
