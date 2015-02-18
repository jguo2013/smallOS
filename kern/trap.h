/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_TRAP_H
#define JOS_KERN_TRAP_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

#include <inc/trap.h>
#include <inc/mmu.h>

/* The kernel's interrupt descriptor table */
extern struct Gatedesc idt[];
extern struct Pseudodesc idt_pd;

void trap_init(void);
void trap_init_percpu(void);
void print_regs(struct PushRegs *regs);
void print_trapframe(struct Trapframe *tf);
void page_fault_handler(struct Trapframe *);
void backtrace(struct Trapframe *);

void BRKPT_HANDLER();
void SYSCALL_HANDLER();
void PGFLT_HANDLER();
void DIV_HANDLER();
void GPFLT_HANDLER();

void IRQ_TIMER_HANDLER();
void IRQ_KBD_HANDLER();
void IRQ_SERIAL_HANDLER();
void IRQ_SPURIOUS_HANDLER();
void IRQ_IDE_HANDLER();

#endif /* JOS_KERN_TRAP_H */
