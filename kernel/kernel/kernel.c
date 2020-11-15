#include <stdio.h>

#include <kernel/tty.h>

void kernel_main(void) {
	terminal_initialize();
	printf("Hello, this is wojOS\n");
	printf("Currently under development\n");
}