// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line
#define V_EIP 0
#define V_AR1 1
#define V_AR2 2
#define V_AR3 3
#define V_AR4 4
#define V_AR5 5
#define V_EBP 6

struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Stack backtrace", mon_backtrace },
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

void 
get_reg(int type, uintptr_t bp, uintptr_t *arg)
{
		uintptr_t addr;
		switch(type)
		{
			case V_EBP:	
					 __asm __volatile("movl %%ebp,%0" : "=r" (*arg));
					 break;
			case V_EIP:	
					 addr = bp+4;
					 goto accstack;
			case V_AR1:
					 addr = bp+8;
					 goto accstack;
			case V_AR2:
					 addr = bp+12;
					 goto accstack;				
			case V_AR3:	
					 addr = bp+16;
					 goto accstack;				
			case V_AR4:	
					 addr = bp+20;
					 goto accstack;
			case V_AR5:	
					 addr = bp+24;					 				
					 accstack:				
		   		 __asm __volatile("movl (%1), %%eax;\n\t" 
       		    							"movl %%eax, %0;"
       		   								 :"=r"(*arg)        /* output */
       		   								 :"r"(addr)         /* input  */
       		 	  							 :"%eax");       		/* clobbered register */
        	 break;
    }
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	uintptr_t eip, curr_ebp, prev_ebp;
	uintptr_t arg1, arg2, arg3, arg4, arg5;
	struct Eipdebuginfo info;
	int dist;
	
	//get current ebp
	get_reg(V_EBP,0,&curr_ebp);
	prev_ebp = *(uint32_t *) curr_ebp;
	cprintf("Stack backtrace:\n");
	
	while(prev_ebp) 
	{
			curr_ebp = prev_ebp;
			memset(&info, 0, sizeof(struct Eipdebuginfo)); 
			get_reg(V_EIP,curr_ebp,&eip);
			get_reg(V_AR1,curr_ebp,&arg1);
			get_reg(V_AR2,curr_ebp,&arg2);
			get_reg(V_AR3,curr_ebp,&arg3); 
			get_reg(V_AR4,curr_ebp,&arg4);
			get_reg(V_AR5,curr_ebp,&arg5);
			cprintf("ebp %x eip %x args %08x %08x %08x %08x %08x\n", curr_ebp,eip,arg1,arg2,arg3,arg4,arg5);
			
			if(!debuginfo_eip(eip,&info))
			{
				dist = eip-info.eip_fn_addr;
				cprintf("%s:%d: %.*s+%d\n",info.eip_file,info.eip_line,info.eip_fn_namelen,info.eip_fn_name,dist);
			}
			prev_ebp = *(uint32_t *) curr_ebp;   
	}
	
	return 0;
}

/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
