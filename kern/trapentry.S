/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>

###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	cli;					\
	pushl $(num);					\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;						\
	name:								\
	cli;					\
	pushl $0;						\
	pushl $(num);				\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(BRKPT_HANDLER, T_BRKPT)	

TRAPHANDLER_NOEC(SYSCALL_HANDLER,T_SYSCALL)

TRAPHANDLER(PGFLT_HANDLER,T_PGFLT) 

TRAPHANDLER_NOEC(DIV_HANDLER,T_DIVIDE)

TRAPHANDLER(GPFLT_HANDLER,T_GPFLT)

TRAPHANDLER_NOEC(IRQ_TIMER_HANDLER,IRQ_OFFSET+IRQ_TIMER)

TRAPHANDLER_NOEC(IRQ_KBD_HANDLER,IRQ_OFFSET+IRQ_KBD)

TRAPHANDLER_NOEC(IRQ_SERIAL_HANDLER,IRQ_OFFSET+IRQ_SERIAL)

TRAPHANDLER_NOEC(IRQ_SPURIOUS_HANDLER,IRQ_OFFSET+IRQ_SPURIOUS)

TRAPHANDLER_NOEC(IRQ_IDE_HANDLER,IRQ_OFFSET+IRQ_IDE)

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds;
	pushl %es;

	pushl %eax;
	pushl %ecx;
	pushl %edx;
	pushl %ebx;
	pushl $0;
	pushl %ebp;	
	pushl %esi;
	pushl %edi;
	
#	mov  $0x08,%eax
#	mov	 %eax,%cs

	mov  $0x10,%eax	
	mov	 %eax,%ds
	mov	 %eax,%ss
	mov	 %eax,%es

	mov	 %esp,%eax
#	mov	 $4,%ebx
#	sub  %ebx,%eax
	pushl %eax
	
call trap


