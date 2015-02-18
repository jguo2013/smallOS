// buggy program - causes an illegal software interrupt

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("movw $0x28,%ax; movw %ax,%cs");//asm volatile("int $13");	// page fault
}

