#!/bin/sh
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "wojos" {
	multiboot /boot/wojos.bin
}
EOF