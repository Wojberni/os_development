CC = /usr/local/cross/bin/i686-elf-gcc
ASM = nasm
CFLAGS = -O2 -ffreestanding -Wall -Wextra -std=gnu99
ASMFLAGS = -felf32
OSNAME = wojos
LINKER = kernel/arch/linker.ld
SRC = ./kernel ./libc
ISODIR = isodir
CFLAGS += -Ikernel/include
CFLAGS += -Ikernel/arch
CFLAGS += -Ilibc/include

C_SRC = $(shell find $(SRC) -name *.c)
H_SRC = $(shell find $(SRC) -name *.h)
ASM_SRC = $(shell find $(SRC) -name *.asm)

C_OBJECTS = $(C_SRC:.c=.o)
ASM_OBJECTS = $(ASM_SRC:.asm=.o)
OBJECTS = $(C_OBJECTS) $(ASM_OBJECTS)

structure: 
	mkdir -p ./$(ISODIR)/boot/grub
	./add_menuentry.sh

all: $(OSNAME).iso

$(OSNAME).iso: $(ISODIR)/boot/$(OSNAME).bin
	grub-mkrescue -o $@ $(ISODIR)

$(ISODIR)/boot/$(OSNAME).bin: $(OBJECTS)
	$(CC) $(CFLAGS) -T $(LINKER) $^ -o $@ -lgcc -nostdlib

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJECTS) $(ISODIR) $(OSNAME).iso

run:
	bochs -f bochs.txt
