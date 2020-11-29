CC = /usr/local/cross/bin/i686-elf-gcc
ASM = nasm
CFLAGS = -O2 -ffreestanding -Wall -Wextra -std=gnu99
ASMFLAGS = -felf32
OSNAME = wojos
ISODIR ?= ./isodir
SRC ?= ./kernel ./libc
LINKER = kernel/arch/linker.ld
HEADER_LIB = $(ISODIR)/usr/lib
HEADER_INC = $(ISODIR)/usr/include

SOURCES := $(shell find $(SRC) -name *.c -or -name *.asm) 
OBJECTS := $(SOURCES:%=$(ISODIR)/%.o)
DEPS := $(OBJS:.o=.d)

structure: 
	mkdir -p $(HEADER_LIB) $(HEADER_INC) ./$(ISODIR)/boot/grub
	./add_menuentry.sh
	cp -R --preserve=timestamps kernel/include/. $(HEADER_INC)
	cp -R --preserve=timestamps libc/include/. $(HEADER_LIB)

all: $(ISODIR)/$(OSNAME).iso

$(ISODIR)/$(OSNAME).iso: $(ISODIR)/$(OSNAME).bin
	cp $^ ./$(ISODIR)/boot/$(OSNAME).bin
	grub-mkrescue -o $@ $(ISODIR)

$(ISODIR)/$(OSNAME).bin: $(OBJECTS) $(LINKER)
	$(CC) $(CFLAGS) -T $(LINKER) $< -o $@ -lgcc -nostdlib

$(ISODIR)/%.asm.o: %.asm
	mkdir -p $(BUILD)
	$(ASM) $(ASMFLAGS) $< -o $@

%.c.o: %.c
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@


clean:
	rm -rf $(ISODIR)