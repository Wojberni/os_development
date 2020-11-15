CC = /usr/local/cross/bin/i686-elf-gcc
ASM = nasm
CFLAGS = -O2 -ffreestanding -Wall -Wextra -std=gnu99
ASMFLAGS = -felf32
KERNELARCH = kernel/arch
OSNAME = wojos
ISODIR = isodir
OUTPUT = ./build-debug

all: $(OSNAME).iso

$(OUTPUT)/%.o: $(KERNELARCH)/%.asm
	mkdir -p $(OUTPUT)
	$(ASM) $(ASMFLAGS) $^ -o $@

$(OUTPUT)/%.o: %.c
	mkdir -p $(OUTPUT)
	$(CC) $(CFLAGS) -c $^ -o $@

$(OSNAME).bin: $(OUTPUT)/* $(KERNELARCH)/linker.ld
	$(CC) $(CFLAGS) -T $(KERNELARCH)/linker.ld $< -o $@ -lgcc -nostdlib
	
$(OSNAME).iso: $(OSNAME).bin
	mkdir -p ./$(ISODIR)/boot/grub
	./add_menuentry.sh
	cp $^ ./$(ISODIR)/boot/$^
	grub-mkrescue -o $@ $(ISODIR)
	rm -r ./$(ISODIR)

clean:
	rm -r -f *.iso *.o *.bin build-debug