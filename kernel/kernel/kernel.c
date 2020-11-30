#include <stdio.h>

#include "tty.h"

void kernel_main(void) {
	terminal_initialize();
	printf("Hello, this is wojOS\n");
	printf("Currently under development\n");
}