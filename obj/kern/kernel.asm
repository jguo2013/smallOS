
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 30 12 f0       	mov    $0xf0123000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 99 01 00 00       	call   f01001d7 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 14             	sub    $0x14,%esp
		monitor(NULL);
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
f0100047:	8d 5d 14             	lea    0x14(%ebp),%ebx
{
	va_list ap;

	va_start(ap, fmt);
	cprintf("kernel warning at %s:%d: ", file, line);
f010004a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010004d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100051:	8b 45 08             	mov    0x8(%ebp),%eax
f0100054:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100058:	c7 04 24 c0 7e 10 f0 	movl   $0xf0107ec0,(%esp)
f010005f:	e8 9b 45 00 00       	call   f01045ff <cprintf>
	vcprintf(fmt, ap);
f0100064:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100068:	8b 45 10             	mov    0x10(%ebp),%eax
f010006b:	89 04 24             	mov    %eax,(%esp)
f010006e:	e8 59 45 00 00       	call   f01045cc <vcprintf>
	cprintf("\n");
f0100073:	c7 04 24 f2 90 10 f0 	movl   $0xf01090f2,(%esp)
f010007a:	e8 80 45 00 00       	call   f01045ff <cprintf>
	va_end(ap);
}
f010007f:	83 c4 14             	add    $0x14,%esp
f0100082:	5b                   	pop    %ebx
f0100083:	5d                   	pop    %ebp
f0100084:	c3                   	ret    

f0100085 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100085:	55                   	push   %ebp
f0100086:	89 e5                	mov    %esp,%ebp
f0100088:	56                   	push   %esi
f0100089:	53                   	push   %ebx
f010008a:	83 ec 10             	sub    $0x10,%esp
f010008d:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100090:	83 3d 9c 1e 27 f0 00 	cmpl   $0x0,0xf0271e9c
f0100097:	75 46                	jne    f01000df <_panic+0x5a>
		goto dead;
	panicstr = fmt;
f0100099:	89 35 9c 1e 27 f0    	mov    %esi,0xf0271e9c

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f010009f:	fa                   	cli    
f01000a0:	fc                   	cld    
/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
f01000a1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");

	va_start(ap, fmt);
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f01000a4:	e8 5d 69 00 00       	call   f0106a06 <cpunum>
f01000a9:	8b 55 0c             	mov    0xc(%ebp),%edx
f01000ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01000b0:	8b 55 08             	mov    0x8(%ebp),%edx
f01000b3:	89 54 24 08          	mov    %edx,0x8(%esp)
f01000b7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01000bb:	c7 04 24 50 7f 10 f0 	movl   $0xf0107f50,(%esp)
f01000c2:	e8 38 45 00 00       	call   f01045ff <cprintf>
	vcprintf(fmt, ap);
f01000c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000cb:	89 34 24             	mov    %esi,(%esp)
f01000ce:	e8 f9 44 00 00       	call   f01045cc <vcprintf>
	cprintf("\n");
f01000d3:	c7 04 24 f2 90 10 f0 	movl   $0xf01090f2,(%esp)
f01000da:	e8 20 45 00 00       	call   f01045ff <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000e6:	e8 18 09 00 00       	call   f0100a03 <monitor>
f01000eb:	eb f2                	jmp    f01000df <_panic+0x5a>

f01000ed <mp_main>:
}

// Setup code for APs
void
mp_main(void)
{
f01000ed:	55                   	push   %ebp
f01000ee:	89 e5                	mov    %esp,%ebp
f01000f0:	83 ec 18             	sub    $0x18,%esp
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
f01000f3:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01000f8:	89 c2                	mov    %eax,%edx
f01000fa:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01000ff:	77 20                	ja     f0100121 <mp_main+0x34>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100101:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100105:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f010010c:	f0 
f010010d:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
f0100114:	00 
f0100115:	c7 04 24 da 7e 10 f0 	movl   $0xf0107eda,(%esp)
f010011c:	e8 64 ff ff ff       	call   f0100085 <_panic>
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0100121:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0100127:	0f 22 da             	mov    %edx,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f010012a:	e8 d7 68 00 00       	call   f0106a06 <cpunum>
f010012f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100133:	c7 04 24 e6 7e 10 f0 	movl   $0xf0107ee6,(%esp)
f010013a:	e8 c0 44 00 00       	call   f01045ff <cprintf>

	lapic_init();
f010013f:	e8 fb 69 00 00       	call   f0106b3f <lapic_init>

	env_init_percpu();
f0100144:	e8 e7 38 00 00       	call   f0103a30 <env_init_percpu>
	trap_init_percpu();
f0100149:	e8 e2 44 00 00       	call   f0104630 <trap_init_percpu>

	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f010014e:	66 90                	xchg   %ax,%ax
f0100150:	e8 b1 68 00 00       	call   f0106a06 <cpunum>
f0100155:	6b d0 74             	imul   $0x74,%eax,%edx
f0100158:	81 c2 24 20 27 f0    	add    $0xf0272024,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f010015e:	b8 01 00 00 00       	mov    $0x1,%eax
f0100163:	f0 87 02             	lock xchg %eax,(%edx)

static __inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	__asm __volatile("pushfl; popl %0" : "=r" (eflags));
f0100166:	9c                   	pushf  
f0100167:	58                   	pop    %eax

	assert(!(read_eflags() & FL_IF));
f0100168:	f6 c4 02             	test   $0x2,%ah
f010016b:	74 24                	je     f0100191 <mp_main+0xa4>
f010016d:	c7 44 24 0c fc 7e 10 	movl   $0xf0107efc,0xc(%esp)
f0100174:	f0 
f0100175:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010017c:	f0 
f010017d:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
f0100184:	00 
f0100185:	c7 04 24 da 7e 10 f0 	movl   $0xf0107eda,(%esp)
f010018c:	e8 f4 fe ff ff       	call   f0100085 <_panic>
	assert(!curenv);
f0100191:	e8 70 68 00 00       	call   f0106a06 <cpunum>
f0100196:	6b c0 74             	imul   $0x74,%eax,%eax
f0100199:	83 b8 28 20 27 f0 00 	cmpl   $0x0,-0xfd8dfd8(%eax)
f01001a0:	74 24                	je     f01001c6 <mp_main+0xd9>
f01001a2:	c7 44 24 0c 2a 7f 10 	movl   $0xf0107f2a,0xc(%esp)
f01001a9:	f0 
f01001aa:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01001b1:	f0 
f01001b2:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
f01001b9:	00 
f01001ba:	c7 04 24 da 7e 10 f0 	movl   $0xf0107eda,(%esp)
f01001c1:	e8 bf fe ff ff       	call   f0100085 <_panic>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01001c6:	c7 04 24 a0 53 12 f0 	movl   $0xf01253a0,(%esp)
f01001cd:	e8 ff 6b 00 00       	call   f0106dd1 <spin_lock>
	// to start running processes on this CPU.  But make sure that
	// only one CPU can enter the scheduler at a time!
	//
	// Your code here:
	lock_kernel();
	sched_yield();
f01001d2:	e8 c4 4e 00 00       	call   f010509b <sched_yield>

f01001d7 <i386_init>:
static void boot_aps(void);


void
i386_init(void)
{
f01001d7:	55                   	push   %ebp
f01001d8:	89 e5                	mov    %esp,%ebp
f01001da:	53                   	push   %ebx
f01001db:	83 ec 14             	sub    $0x14,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f01001de:	b8 14 30 2b f0       	mov    $0xf02b3014,%eax
f01001e3:	2d 51 0b 27 f0       	sub    $0xf0270b51,%eax
f01001e8:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01001f3:	00 
f01001f4:	c7 04 24 51 0b 27 f0 	movl   $0xf0270b51,(%esp)
f01001fb:	e8 90 61 00 00       	call   f0106390 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f0100200:	e8 5c 05 00 00       	call   f0100761 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100205:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f010020c:	00 
f010020d:	c7 04 24 32 7f 10 f0 	movl   $0xf0107f32,(%esp)
f0100214:	e8 e6 43 00 00       	call   f01045ff <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f0100219:	e8 84 1a 00 00       	call   f0101ca2 <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f010021e:	e8 37 38 00 00       	call   f0103a5a <env_init>
	trap_init();	
f0100223:	e8 e9 44 00 00       	call   f0104711 <trap_init>

	// Lab 4 multiprocessor initialization functions
	mp_init();
f0100228:	e8 f9 64 00 00       	call   f0106726 <mp_init>
	lapic_init();
f010022d:	8d 76 00             	lea    0x0(%esi),%esi
f0100230:	e8 0a 69 00 00       	call   f0106b3f <lapic_init>
	
	// Lab 4 multitasking initialization functions
	pic_init();
f0100235:	e8 06 43 00 00       	call   f0104540 <pic_init>

	// Lab 6 hardware initialization functions
	time_init();
f010023a:	e8 b9 79 00 00       	call   f0107bf8 <time_init>
	pci_init();
f010023f:	90                   	nop
f0100240:	e8 e8 76 00 00       	call   f010792d <pci_init>
f0100245:	c7 04 24 a0 53 12 f0 	movl   $0xf01253a0,(%esp)
f010024c:	e8 80 6b 00 00       	call   f0106dd1 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100251:	83 3d a4 1e 27 f0 07 	cmpl   $0x7,0xf0271ea4
f0100258:	77 24                	ja     f010027e <i386_init+0xa7>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010025a:	c7 44 24 0c 00 70 00 	movl   $0x7000,0xc(%esp)
f0100261:	00 
f0100262:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0100269:	f0 
f010026a:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
f0100271:	00 
f0100272:	c7 04 24 da 7e 10 f0 	movl   $0xf0107eda,(%esp)
f0100279:	e8 07 fe ff ff       	call   f0100085 <_panic>
	void *code;
	struct CpuInfo *c;

	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f010027e:	b8 46 66 10 f0       	mov    $0xf0106646,%eax
f0100283:	2d cc 65 10 f0       	sub    $0xf01065cc,%eax
f0100288:	89 44 24 08          	mov    %eax,0x8(%esp)
f010028c:	c7 44 24 04 cc 65 10 	movl   $0xf01065cc,0x4(%esp)
f0100293:	f0 
f0100294:	c7 04 24 00 70 00 f0 	movl   $0xf0007000,(%esp)
f010029b:	e8 4f 61 00 00       	call   f01063ef <memmove>
f01002a0:	bb 20 20 27 f0       	mov    $0xf0272020,%ebx
f01002a5:	eb 4d                	jmp    f01002f4 <i386_init+0x11d>

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
		if (c == cpus + cpunum())  // We've started already.
f01002a7:	e8 5a 67 00 00       	call   f0106a06 <cpunum>
f01002ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01002af:	05 20 20 27 f0       	add    $0xf0272020,%eax
f01002b4:	39 c3                	cmp    %eax,%ebx
f01002b6:	74 39                	je     f01002f1 <i386_init+0x11a>
			continue;

		// Tell mpentry.S what stack to use 
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f01002b8:	89 d8                	mov    %ebx,%eax
f01002ba:	2d 20 20 27 f0       	sub    $0xf0272020,%eax
f01002bf:	c1 f8 02             	sar    $0x2,%eax
f01002c2:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f01002c8:	c1 e0 0f             	shl    $0xf,%eax
f01002cb:	8d 80 00 b0 27 f0    	lea    -0xfd85000(%eax),%eax
f01002d1:	a3 a0 1e 27 f0       	mov    %eax,0xf0271ea0
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_id, PADDR(code));
f01002d6:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
f01002dd:	00 
f01002de:	0f b6 03             	movzbl (%ebx),%eax
f01002e1:	89 04 24             	mov    %eax,(%esp)
f01002e4:	e8 86 67 00 00       	call   f0106a6f <lapic_startap>
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED);
f01002e9:	8b 43 04             	mov    0x4(%ebx),%eax
f01002ec:	83 f8 01             	cmp    $0x1,%eax
f01002ef:	75 f8                	jne    f01002e9 <i386_init+0x112>
	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f01002f1:	83 c3 74             	add    $0x74,%ebx
f01002f4:	6b 05 c4 23 27 f0 74 	imul   $0x74,0xf02723c4,%eax
f01002fb:	05 20 20 27 f0       	add    $0xf0272020,%eax
f0100300:	39 c3                	cmp    %eax,%ebx
f0100302:	72 a3                	jb     f01002a7 <i386_init+0xd0>
	lock_kernel(); 
	// Starting non-boot CPUs
	boot_aps();

	// Start fs.
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100304:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f010030b:	00 
f010030c:	c7 04 24 12 6f 1a f0 	movl   $0xf01a6f12,(%esp)
f0100313:	e8 2e 3f 00 00       	call   f0104246 <env_create>

#if !defined(TEST_NO_NS)
	// Start ns.
	ENV_CREATE(net_ns, ENV_TYPE_NS);	
f0100318:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f010031f:	00 
f0100320:	c7 04 24 6d 76 1f f0 	movl   $0xf01f766d,(%esp)
f0100327:	e8 1a 3f 00 00       	call   f0104246 <env_create>
#endif

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f010032c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100333:	00 
f0100334:	c7 04 24 22 61 1c f0 	movl   $0xf01c6122,(%esp)
f010033b:	e8 06 3f 00 00       	call   f0104246 <env_create>
f0100340:	9c                   	pushf  
f0100341:	58                   	pop    %eax
	//ENV_CREATE(user_yield, ENV_TYPE_USER);
	//ENV_CREATE(user_yield, ENV_TYPE_USER);
	//ENV_CREATE(user_forktree, ENV_TYPE_USER);	
//#endif // TEST
	
	assert(!(read_eflags() & FL_IF));
f0100342:	f6 c4 02             	test   $0x2,%ah
f0100345:	74 24                	je     f010036b <i386_init+0x194>
f0100347:	c7 44 24 0c fc 7e 10 	movl   $0xf0107efc,0xc(%esp)
f010034e:	f0 
f010034f:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0100356:	f0 
f0100357:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f010035e:	00 
f010035f:	c7 04 24 da 7e 10 f0 	movl   $0xf0107eda,(%esp)
f0100366:	e8 1a fd ff ff       	call   f0100085 <_panic>

	// Should not be necessary - drains keyboard because interrupt has given up.
	//kbd_intr();

	// Schedule and run the first user environment!
	sched_yield();
f010036b:	e8 2b 4d 00 00       	call   f010509b <sched_yield>

f0100370 <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f0100370:	55                   	push   %ebp
f0100371:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100373:	ba 84 00 00 00       	mov    $0x84,%edx
f0100378:	ec                   	in     (%dx),%al
f0100379:	ec                   	in     (%dx),%al
f010037a:	ec                   	in     (%dx),%al
f010037b:	ec                   	in     (%dx),%al
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
f010037c:	5d                   	pop    %ebp
f010037d:	c3                   	ret    

f010037e <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010037e:	55                   	push   %ebp
f010037f:	89 e5                	mov    %esp,%ebp
f0100381:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100386:	ec                   	in     (%dx),%al
f0100387:	89 c2                	mov    %eax,%edx
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100389:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010038e:	f6 c2 01             	test   $0x1,%dl
f0100391:	74 09                	je     f010039c <serial_proc_data+0x1e>
f0100393:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100398:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100399:	0f b6 c0             	movzbl %al,%eax
}
f010039c:	5d                   	pop    %ebp
f010039d:	c3                   	ret    

f010039e <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010039e:	55                   	push   %ebp
f010039f:	89 e5                	mov    %esp,%ebp
f01003a1:	57                   	push   %edi
f01003a2:	56                   	push   %esi
f01003a3:	53                   	push   %ebx
f01003a4:	83 ec 0c             	sub    $0xc,%esp
f01003a7:	89 c6                	mov    %eax,%esi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f01003a9:	bb 24 12 27 f0       	mov    $0xf0271224,%ebx
f01003ae:	bf 20 10 27 f0       	mov    $0xf0271020,%edi
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f01003b3:	eb 1b                	jmp    f01003d0 <cons_intr+0x32>
		if (c == 0)
f01003b5:	85 c0                	test   %eax,%eax
f01003b7:	74 17                	je     f01003d0 <cons_intr+0x32>
			continue;
		cons.buf[cons.wpos++] = c;
f01003b9:	8b 13                	mov    (%ebx),%edx
f01003bb:	88 04 17             	mov    %al,(%edi,%edx,1)
f01003be:	8d 42 01             	lea    0x1(%edx),%eax
		if (cons.wpos == CONSBUFSIZE)
f01003c1:	3d 00 02 00 00       	cmp    $0x200,%eax
			cons.wpos = 0;
f01003c6:	ba 00 00 00 00       	mov    $0x0,%edx
f01003cb:	0f 44 c2             	cmove  %edx,%eax
f01003ce:	89 03                	mov    %eax,(%ebx)
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f01003d0:	ff d6                	call   *%esi
f01003d2:	83 f8 ff             	cmp    $0xffffffff,%eax
f01003d5:	75 de                	jne    f01003b5 <cons_intr+0x17>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f01003d7:	83 c4 0c             	add    $0xc,%esp
f01003da:	5b                   	pop    %ebx
f01003db:	5e                   	pop    %esi
f01003dc:	5f                   	pop    %edi
f01003dd:	5d                   	pop    %ebp
f01003de:	c3                   	ret    

f01003df <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f01003df:	55                   	push   %ebp
f01003e0:	89 e5                	mov    %esp,%ebp
f01003e2:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01003e5:	b8 62 06 10 f0       	mov    $0xf0100662,%eax
f01003ea:	e8 af ff ff ff       	call   f010039e <cons_intr>
}
f01003ef:	c9                   	leave  
f01003f0:	c3                   	ret    

f01003f1 <serial_intr>:
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f01003f1:	55                   	push   %ebp
f01003f2:	89 e5                	mov    %esp,%ebp
f01003f4:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
f01003f7:	80 3d 04 10 27 f0 00 	cmpb   $0x0,0xf0271004
f01003fe:	74 0a                	je     f010040a <serial_intr+0x19>
		cons_intr(serial_proc_data);
f0100400:	b8 7e 03 10 f0       	mov    $0xf010037e,%eax
f0100405:	e8 94 ff ff ff       	call   f010039e <cons_intr>
}
f010040a:	c9                   	leave  
f010040b:	c3                   	ret    

f010040c <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f010040c:	55                   	push   %ebp
f010040d:	89 e5                	mov    %esp,%ebp
f010040f:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f0100412:	e8 da ff ff ff       	call   f01003f1 <serial_intr>
	kbd_intr();
f0100417:	e8 c3 ff ff ff       	call   f01003df <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f010041c:	8b 15 20 12 27 f0    	mov    0xf0271220,%edx
f0100422:	b8 00 00 00 00       	mov    $0x0,%eax
f0100427:	3b 15 24 12 27 f0    	cmp    0xf0271224,%edx
f010042d:	74 1e                	je     f010044d <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f010042f:	0f b6 82 20 10 27 f0 	movzbl -0xfd8efe0(%edx),%eax
f0100436:	83 c2 01             	add    $0x1,%edx
		if (cons.rpos == CONSBUFSIZE)
f0100439:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.rpos = 0;
f010043f:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100444:	0f 44 d1             	cmove  %ecx,%edx
f0100447:	89 15 20 12 27 f0    	mov    %edx,0xf0271220
		return c;
	}
	return 0;
}
f010044d:	c9                   	leave  
f010044e:	c3                   	ret    

f010044f <getchar>:
	cons_putc(c);
}

int
getchar(void)
{
f010044f:	55                   	push   %ebp
f0100450:	89 e5                	mov    %esp,%ebp
f0100452:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100455:	e8 b2 ff ff ff       	call   f010040c <cons_getc>
f010045a:	85 c0                	test   %eax,%eax
f010045c:	74 f7                	je     f0100455 <getchar+0x6>
		/* do nothing */;
	return c;
}
f010045e:	c9                   	leave  
f010045f:	c3                   	ret    

f0100460 <iscons>:

int
iscons(int fdnum)
{
f0100460:	55                   	push   %ebp
f0100461:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f0100463:	b8 01 00 00 00       	mov    $0x1,%eax
f0100468:	5d                   	pop    %ebp
f0100469:	c3                   	ret    

f010046a <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f010046a:	55                   	push   %ebp
f010046b:	89 e5                	mov    %esp,%ebp
f010046d:	57                   	push   %edi
f010046e:	56                   	push   %esi
f010046f:	53                   	push   %ebx
f0100470:	83 ec 2c             	sub    $0x2c,%esp
f0100473:	89 c7                	mov    %eax,%edi
f0100475:	bb 00 00 00 00       	mov    $0x0,%ebx
f010047a:	be fd 03 00 00       	mov    $0x3fd,%esi
f010047f:	eb 08                	jmp    f0100489 <cons_putc+0x1f>
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f0100481:	e8 ea fe ff ff       	call   f0100370 <delay>
{
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
f0100486:	83 c3 01             	add    $0x1,%ebx
f0100489:	89 f2                	mov    %esi,%edx
f010048b:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f010048c:	a8 20                	test   $0x20,%al
f010048e:	75 08                	jne    f0100498 <cons_putc+0x2e>
f0100490:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f0100496:	75 e9                	jne    f0100481 <cons_putc+0x17>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
f0100498:	89 fa                	mov    %edi,%edx
f010049a:	89 f8                	mov    %edi,%eax
f010049c:	88 55 e7             	mov    %dl,-0x19(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010049f:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01004a4:	ee                   	out    %al,(%dx)
f01004a5:	bb 00 00 00 00       	mov    $0x0,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004aa:	be 79 03 00 00       	mov    $0x379,%esi
f01004af:	eb 08                	jmp    f01004b9 <cons_putc+0x4f>
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
		delay();
f01004b1:	e8 ba fe ff ff       	call   f0100370 <delay>
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01004b6:	83 c3 01             	add    $0x1,%ebx
f01004b9:	89 f2                	mov    %esi,%edx
f01004bb:	ec                   	in     (%dx),%al
f01004bc:	84 c0                	test   %al,%al
f01004be:	78 08                	js     f01004c8 <cons_putc+0x5e>
f01004c0:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f01004c6:	75 e9                	jne    f01004b1 <cons_putc+0x47>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004c8:	ba 78 03 00 00       	mov    $0x378,%edx
f01004cd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f01004d1:	ee                   	out    %al,(%dx)
f01004d2:	b2 7a                	mov    $0x7a,%dl
f01004d4:	b8 0d 00 00 00       	mov    $0xd,%eax
f01004d9:	ee                   	out    %al,(%dx)
f01004da:	b8 08 00 00 00       	mov    $0x8,%eax
f01004df:	ee                   	out    %al,(%dx)
static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
		c |= 0x0700;
f01004e0:	89 f8                	mov    %edi,%eax
f01004e2:	80 cc 07             	or     $0x7,%ah
f01004e5:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f01004eb:	0f 44 f8             	cmove  %eax,%edi

	switch (c & 0xff) {
f01004ee:	89 f8                	mov    %edi,%eax
f01004f0:	25 ff 00 00 00       	and    $0xff,%eax
f01004f5:	83 f8 09             	cmp    $0x9,%eax
f01004f8:	0f 84 7e 00 00 00    	je     f010057c <cons_putc+0x112>
f01004fe:	83 f8 09             	cmp    $0x9,%eax
f0100501:	7f 0f                	jg     f0100512 <cons_putc+0xa8>
f0100503:	83 f8 08             	cmp    $0x8,%eax
f0100506:	0f 85 a4 00 00 00    	jne    f01005b0 <cons_putc+0x146>
f010050c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100510:	eb 10                	jmp    f0100522 <cons_putc+0xb8>
f0100512:	83 f8 0a             	cmp    $0xa,%eax
f0100515:	74 3b                	je     f0100552 <cons_putc+0xe8>
f0100517:	83 f8 0d             	cmp    $0xd,%eax
f010051a:	0f 85 90 00 00 00    	jne    f01005b0 <cons_putc+0x146>
f0100520:	eb 38                	jmp    f010055a <cons_putc+0xf0>
	case '\b':
		if (crt_pos > 0) {
f0100522:	0f b7 05 10 10 27 f0 	movzwl 0xf0271010,%eax
f0100529:	66 85 c0             	test   %ax,%ax
f010052c:	0f 84 e8 00 00 00    	je     f010061a <cons_putc+0x1b0>
			crt_pos--;
f0100532:	83 e8 01             	sub    $0x1,%eax
f0100535:	66 a3 10 10 27 f0    	mov    %ax,0xf0271010
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f010053b:	0f b7 c0             	movzwl %ax,%eax
f010053e:	66 81 e7 00 ff       	and    $0xff00,%di
f0100543:	83 cf 20             	or     $0x20,%edi
f0100546:	8b 15 0c 10 27 f0    	mov    0xf027100c,%edx
f010054c:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100550:	eb 7b                	jmp    f01005cd <cons_putc+0x163>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f0100552:	66 83 05 10 10 27 f0 	addw   $0x50,0xf0271010
f0100559:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f010055a:	0f b7 05 10 10 27 f0 	movzwl 0xf0271010,%eax
f0100561:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100567:	c1 e8 10             	shr    $0x10,%eax
f010056a:	66 c1 e8 06          	shr    $0x6,%ax
f010056e:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100571:	c1 e0 04             	shl    $0x4,%eax
f0100574:	66 a3 10 10 27 f0    	mov    %ax,0xf0271010
f010057a:	eb 51                	jmp    f01005cd <cons_putc+0x163>
		break;
	case '\t':
		cons_putc(' ');
f010057c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100581:	e8 e4 fe ff ff       	call   f010046a <cons_putc>
		cons_putc(' ');
f0100586:	b8 20 00 00 00       	mov    $0x20,%eax
f010058b:	e8 da fe ff ff       	call   f010046a <cons_putc>
		cons_putc(' ');
f0100590:	b8 20 00 00 00       	mov    $0x20,%eax
f0100595:	e8 d0 fe ff ff       	call   f010046a <cons_putc>
		cons_putc(' ');
f010059a:	b8 20 00 00 00       	mov    $0x20,%eax
f010059f:	e8 c6 fe ff ff       	call   f010046a <cons_putc>
		cons_putc(' ');
f01005a4:	b8 20 00 00 00       	mov    $0x20,%eax
f01005a9:	e8 bc fe ff ff       	call   f010046a <cons_putc>
f01005ae:	eb 1d                	jmp    f01005cd <cons_putc+0x163>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f01005b0:	0f b7 05 10 10 27 f0 	movzwl 0xf0271010,%eax
f01005b7:	0f b7 c8             	movzwl %ax,%ecx
f01005ba:	8b 15 0c 10 27 f0    	mov    0xf027100c,%edx
f01005c0:	66 89 3c 4a          	mov    %di,(%edx,%ecx,2)
f01005c4:	83 c0 01             	add    $0x1,%eax
f01005c7:	66 a3 10 10 27 f0    	mov    %ax,0xf0271010
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f01005cd:	66 81 3d 10 10 27 f0 	cmpw   $0x7cf,0xf0271010
f01005d4:	cf 07 
f01005d6:	76 42                	jbe    f010061a <cons_putc+0x1b0>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005d8:	a1 0c 10 27 f0       	mov    0xf027100c,%eax
f01005dd:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f01005e4:	00 
f01005e5:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005eb:	89 54 24 04          	mov    %edx,0x4(%esp)
f01005ef:	89 04 24             	mov    %eax,(%esp)
f01005f2:	e8 f8 5d 00 00       	call   f01063ef <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f01005f7:	8b 15 0c 10 27 f0    	mov    0xf027100c,%edx
f01005fd:	b8 80 07 00 00       	mov    $0x780,%eax
f0100602:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100608:	83 c0 01             	add    $0x1,%eax
f010060b:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100610:	75 f0                	jne    f0100602 <cons_putc+0x198>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f0100612:	66 83 2d 10 10 27 f0 	subw   $0x50,0xf0271010
f0100619:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f010061a:	8b 0d 08 10 27 f0    	mov    0xf0271008,%ecx
f0100620:	89 cb                	mov    %ecx,%ebx
f0100622:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100627:	89 ca                	mov    %ecx,%edx
f0100629:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010062a:	0f b7 35 10 10 27 f0 	movzwl 0xf0271010,%esi
f0100631:	83 c1 01             	add    $0x1,%ecx
f0100634:	89 f0                	mov    %esi,%eax
f0100636:	66 c1 e8 08          	shr    $0x8,%ax
f010063a:	89 ca                	mov    %ecx,%edx
f010063c:	ee                   	out    %al,(%dx)
f010063d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100642:	89 da                	mov    %ebx,%edx
f0100644:	ee                   	out    %al,(%dx)
f0100645:	89 f0                	mov    %esi,%eax
f0100647:	89 ca                	mov    %ecx,%edx
f0100649:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010064a:	83 c4 2c             	add    $0x2c,%esp
f010064d:	5b                   	pop    %ebx
f010064e:	5e                   	pop    %esi
f010064f:	5f                   	pop    %edi
f0100650:	5d                   	pop    %ebp
f0100651:	c3                   	ret    

f0100652 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100652:	55                   	push   %ebp
f0100653:	89 e5                	mov    %esp,%ebp
f0100655:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100658:	8b 45 08             	mov    0x8(%ebp),%eax
f010065b:	e8 0a fe ff ff       	call   f010046a <cons_putc>
}
f0100660:	c9                   	leave  
f0100661:	c3                   	ret    

f0100662 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f0100662:	55                   	push   %ebp
f0100663:	89 e5                	mov    %esp,%ebp
f0100665:	53                   	push   %ebx
f0100666:	83 ec 14             	sub    $0x14,%esp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100669:	ba 64 00 00 00       	mov    $0x64,%edx
f010066e:	ec                   	in     (%dx),%al
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f010066f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100674:	a8 01                	test   $0x1,%al
f0100676:	0f 84 dd 00 00 00    	je     f0100759 <kbd_proc_data+0xf7>
f010067c:	b2 60                	mov    $0x60,%dl
f010067e:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f010067f:	3c e0                	cmp    $0xe0,%al
f0100681:	75 11                	jne    f0100694 <kbd_proc_data+0x32>
		// E0 escape character
		shift |= E0ESC;
f0100683:	83 0d 00 10 27 f0 40 	orl    $0x40,0xf0271000
f010068a:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f010068f:	e9 c5 00 00 00       	jmp    f0100759 <kbd_proc_data+0xf7>
	} else if (data & 0x80) {
f0100694:	84 c0                	test   %al,%al
f0100696:	79 35                	jns    f01006cd <kbd_proc_data+0x6b>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f0100698:	8b 15 00 10 27 f0    	mov    0xf0271000,%edx
f010069e:	89 c1                	mov    %eax,%ecx
f01006a0:	83 e1 7f             	and    $0x7f,%ecx
f01006a3:	f6 c2 40             	test   $0x40,%dl
f01006a6:	0f 44 c1             	cmove  %ecx,%eax
		shift &= ~(shiftcode[data] | E0ESC);
f01006a9:	0f b6 c0             	movzbl %al,%eax
f01006ac:	0f b6 80 00 80 10 f0 	movzbl -0xfef8000(%eax),%eax
f01006b3:	83 c8 40             	or     $0x40,%eax
f01006b6:	0f b6 c0             	movzbl %al,%eax
f01006b9:	f7 d0                	not    %eax
f01006bb:	21 c2                	and    %eax,%edx
f01006bd:	89 15 00 10 27 f0    	mov    %edx,0xf0271000
f01006c3:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f01006c8:	e9 8c 00 00 00       	jmp    f0100759 <kbd_proc_data+0xf7>
	} else if (shift & E0ESC) {
f01006cd:	8b 15 00 10 27 f0    	mov    0xf0271000,%edx
f01006d3:	f6 c2 40             	test   $0x40,%dl
f01006d6:	74 0c                	je     f01006e4 <kbd_proc_data+0x82>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f01006d8:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
f01006db:	83 e2 bf             	and    $0xffffffbf,%edx
f01006de:	89 15 00 10 27 f0    	mov    %edx,0xf0271000
	}

	shift |= shiftcode[data];
f01006e4:	0f b6 c0             	movzbl %al,%eax
	shift ^= togglecode[data];
f01006e7:	0f b6 90 00 80 10 f0 	movzbl -0xfef8000(%eax),%edx
f01006ee:	0b 15 00 10 27 f0    	or     0xf0271000,%edx
f01006f4:	0f b6 88 00 81 10 f0 	movzbl -0xfef7f00(%eax),%ecx
f01006fb:	31 ca                	xor    %ecx,%edx
f01006fd:	89 15 00 10 27 f0    	mov    %edx,0xf0271000

	c = charcode[shift & (CTL | SHIFT)][data];
f0100703:	89 d1                	mov    %edx,%ecx
f0100705:	83 e1 03             	and    $0x3,%ecx
f0100708:	8b 0c 8d 00 82 10 f0 	mov    -0xfef7e00(,%ecx,4),%ecx
f010070f:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
	if (shift & CAPSLOCK) {
f0100713:	f6 c2 08             	test   $0x8,%dl
f0100716:	74 1b                	je     f0100733 <kbd_proc_data+0xd1>
		if ('a' <= c && c <= 'z')
f0100718:	89 d9                	mov    %ebx,%ecx
f010071a:	8d 43 9f             	lea    -0x61(%ebx),%eax
f010071d:	83 f8 19             	cmp    $0x19,%eax
f0100720:	77 05                	ja     f0100727 <kbd_proc_data+0xc5>
			c += 'A' - 'a';
f0100722:	83 eb 20             	sub    $0x20,%ebx
f0100725:	eb 0c                	jmp    f0100733 <kbd_proc_data+0xd1>
		else if ('A' <= c && c <= 'Z')
f0100727:	83 e9 41             	sub    $0x41,%ecx
			c += 'a' - 'A';
f010072a:	8d 43 20             	lea    0x20(%ebx),%eax
f010072d:	83 f9 19             	cmp    $0x19,%ecx
f0100730:	0f 46 d8             	cmovbe %eax,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100733:	f7 d2                	not    %edx
f0100735:	f6 c2 06             	test   $0x6,%dl
f0100738:	75 1f                	jne    f0100759 <kbd_proc_data+0xf7>
f010073a:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100740:	75 17                	jne    f0100759 <kbd_proc_data+0xf7>
		cprintf("Rebooting!\n");
f0100742:	c7 04 24 bb 7f 10 f0 	movl   $0xf0107fbb,(%esp)
f0100749:	e8 b1 3e 00 00       	call   f01045ff <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010074e:	ba 92 00 00 00       	mov    $0x92,%edx
f0100753:	b8 03 00 00 00       	mov    $0x3,%eax
f0100758:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f0100759:	89 d8                	mov    %ebx,%eax
f010075b:	83 c4 14             	add    $0x14,%esp
f010075e:	5b                   	pop    %ebx
f010075f:	5d                   	pop    %ebp
f0100760:	c3                   	ret    

f0100761 <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f0100761:	55                   	push   %ebp
f0100762:	89 e5                	mov    %esp,%ebp
f0100764:	57                   	push   %edi
f0100765:	56                   	push   %esi
f0100766:	53                   	push   %ebx
f0100767:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f010076a:	b8 00 80 0b f0       	mov    $0xf00b8000,%eax
f010076f:	0f b7 10             	movzwl (%eax),%edx
	*cp = (uint16_t) 0xA55A;
f0100772:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
	if (*cp != 0xA55A) {
f0100777:	0f b7 00             	movzwl (%eax),%eax
f010077a:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010077e:	74 11                	je     f0100791 <cons_init+0x30>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f0100780:	c7 05 08 10 27 f0 b4 	movl   $0x3b4,0xf0271008
f0100787:	03 00 00 
f010078a:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f010078f:	eb 16                	jmp    f01007a7 <cons_init+0x46>
	} else {
		*cp = was;
f0100791:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100798:	c7 05 08 10 27 f0 d4 	movl   $0x3d4,0xf0271008
f010079f:	03 00 00 
f01007a2:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f01007a7:	8b 0d 08 10 27 f0    	mov    0xf0271008,%ecx
f01007ad:	89 cb                	mov    %ecx,%ebx
f01007af:	b8 0e 00 00 00       	mov    $0xe,%eax
f01007b4:	89 ca                	mov    %ecx,%edx
f01007b6:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01007b7:	83 c1 01             	add    $0x1,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007ba:	89 ca                	mov    %ecx,%edx
f01007bc:	ec                   	in     (%dx),%al
f01007bd:	0f b6 f8             	movzbl %al,%edi
f01007c0:	c1 e7 08             	shl    $0x8,%edi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01007c3:	b8 0f 00 00 00       	mov    $0xf,%eax
f01007c8:	89 da                	mov    %ebx,%edx
f01007ca:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007cb:	89 ca                	mov    %ecx,%edx
f01007cd:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f01007ce:	89 35 0c 10 27 f0    	mov    %esi,0xf027100c
	crt_pos = pos;
f01007d4:	0f b6 c8             	movzbl %al,%ecx
f01007d7:	09 cf                	or     %ecx,%edi
f01007d9:	66 89 3d 10 10 27 f0 	mov    %di,0xf0271010

static void
kbd_init(void)
{
	// Drain the kbd buffer so that QEMU generates interrupts.
	kbd_intr();
f01007e0:	e8 fa fb ff ff       	call   f01003df <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f01007e5:	0f b7 05 90 53 12 f0 	movzwl 0xf0125390,%eax
f01007ec:	25 fd ff 00 00       	and    $0xfffd,%eax
f01007f1:	89 04 24             	mov    %eax,(%esp)
f01007f4:	e8 d6 3c 00 00       	call   f01044cf <irq_setmask_8259A>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01007f9:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f01007fe:	b8 00 00 00 00       	mov    $0x0,%eax
f0100803:	89 da                	mov    %ebx,%edx
f0100805:	ee                   	out    %al,(%dx)
f0100806:	b2 fb                	mov    $0xfb,%dl
f0100808:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010080d:	ee                   	out    %al,(%dx)
f010080e:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
f0100813:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100818:	89 ca                	mov    %ecx,%edx
f010081a:	ee                   	out    %al,(%dx)
f010081b:	b2 f9                	mov    $0xf9,%dl
f010081d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100822:	ee                   	out    %al,(%dx)
f0100823:	b2 fb                	mov    $0xfb,%dl
f0100825:	b8 03 00 00 00       	mov    $0x3,%eax
f010082a:	ee                   	out    %al,(%dx)
f010082b:	b2 fc                	mov    $0xfc,%dl
f010082d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100832:	ee                   	out    %al,(%dx)
f0100833:	b2 f9                	mov    $0xf9,%dl
f0100835:	b8 01 00 00 00       	mov    $0x1,%eax
f010083a:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010083b:	b2 fd                	mov    $0xfd,%dl
f010083d:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f010083e:	3c ff                	cmp    $0xff,%al
f0100840:	0f 95 c0             	setne  %al
f0100843:	89 c6                	mov    %eax,%esi
f0100845:	a2 04 10 27 f0       	mov    %al,0xf0271004
f010084a:	89 da                	mov    %ebx,%edx
f010084c:	ec                   	in     (%dx),%al
f010084d:	89 ca                	mov    %ecx,%edx
f010084f:	ec                   	in     (%dx),%al
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f0100850:	89 f0                	mov    %esi,%eax
f0100852:	84 c0                	test   %al,%al
f0100854:	74 1d                	je     f0100873 <cons_init+0x112>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f0100856:	0f b7 05 90 53 12 f0 	movzwl 0xf0125390,%eax
f010085d:	25 ef ff 00 00       	and    $0xffef,%eax
f0100862:	89 04 24             	mov    %eax,(%esp)
f0100865:	e8 65 3c 00 00       	call   f01044cf <irq_setmask_8259A>
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f010086a:	80 3d 04 10 27 f0 00 	cmpb   $0x0,0xf0271004
f0100871:	75 0c                	jne    f010087f <cons_init+0x11e>
		cprintf("Serial port does not exist!\n");
f0100873:	c7 04 24 c7 7f 10 f0 	movl   $0xf0107fc7,(%esp)
f010087a:	e8 80 3d 00 00       	call   f01045ff <cprintf>
}
f010087f:	83 c4 1c             	add    $0x1c,%esp
f0100882:	5b                   	pop    %ebx
f0100883:	5e                   	pop    %esi
f0100884:	5f                   	pop    %edi
f0100885:	5d                   	pop    %ebp
f0100886:	c3                   	ret    
	...

f0100890 <get_reg>:
	return 0;
}

void 
get_reg(int type, uintptr_t bp, uintptr_t *arg)
{
f0100890:	55                   	push   %ebp
f0100891:	89 e5                	mov    %esp,%ebp
f0100893:	8b 45 08             	mov    0x8(%ebp),%eax
f0100896:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0100899:	8b 55 10             	mov    0x10(%ebp),%edx
		uintptr_t addr;
		switch(type)
f010089c:	83 f8 06             	cmp    $0x6,%eax
f010089f:	77 2f                	ja     f01008d0 <get_reg+0x40>
f01008a1:	ff 24 85 20 82 10 f0 	jmp    *-0xfef7de0(,%eax,4)
		{
			case V_EBP:	
					 __asm __volatile("movl %%ebp,%0" : "=r" (*arg));
f01008a8:	89 e8                	mov    %ebp,%eax
f01008aa:	89 02                	mov    %eax,(%edx)
					 break;
f01008ac:	eb 22                	jmp    f01008d0 <get_reg+0x40>
			case V_EIP:	
					 addr = bp+4;
f01008ae:	83 c1 04             	add    $0x4,%ecx
					 goto accstack;
f01008b1:	eb 17                	jmp    f01008ca <get_reg+0x3a>
			case V_AR1:
					 addr = bp+8;
f01008b3:	83 c1 08             	add    $0x8,%ecx
					 goto accstack;
f01008b6:	eb 12                	jmp    f01008ca <get_reg+0x3a>
			case V_AR2:
					 addr = bp+12;
f01008b8:	83 c1 0c             	add    $0xc,%ecx
					 goto accstack;				
f01008bb:	eb 0d                	jmp    f01008ca <get_reg+0x3a>
			case V_AR3:	
					 addr = bp+16;
f01008bd:	83 c1 10             	add    $0x10,%ecx
					 goto accstack;				
f01008c0:	eb 08                	jmp    f01008ca <get_reg+0x3a>
			case V_AR4:	
					 addr = bp+20;
f01008c2:	83 c1 14             	add    $0x14,%ecx
					 goto accstack;
f01008c5:	eb 03                	jmp    f01008ca <get_reg+0x3a>
			case V_AR5:	
					 addr = bp+24;					 				
f01008c7:	83 c1 18             	add    $0x18,%ecx
					 accstack:				
		   		 __asm __volatile("movl (%1), %%eax;\n\t" 
f01008ca:	8b 01                	mov    (%ecx),%eax
f01008cc:	89 c1                	mov    %eax,%ecx
f01008ce:	89 0a                	mov    %ecx,(%edx)
       		   								 :"=r"(*arg)        /* output */
       		   								 :"r"(addr)         /* input  */
       		 	  							 :"%eax");       		/* clobbered register */
        	 break;
    }
}
f01008d0:	5d                   	pop    %ebp
f01008d1:	c3                   	ret    

f01008d2 <mon_kerninfo>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01008d2:	55                   	push   %ebp
f01008d3:	89 e5                	mov    %esp,%ebp
f01008d5:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01008d8:	c7 04 24 64 82 10 f0 	movl   $0xf0108264,(%esp)
f01008df:	e8 1b 3d 00 00       	call   f01045ff <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01008e4:	c7 44 24 04 0c 00 10 	movl   $0x10000c,0x4(%esp)
f01008eb:	00 
f01008ec:	c7 04 24 20 83 10 f0 	movl   $0xf0108320,(%esp)
f01008f3:	e8 07 3d 00 00       	call   f01045ff <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01008f8:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f01008ff:	00 
f0100900:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f0100907:	f0 
f0100908:	c7 04 24 48 83 10 f0 	movl   $0xf0108348,(%esp)
f010090f:	e8 eb 3c 00 00       	call   f01045ff <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100914:	c7 44 24 08 bb 7e 10 	movl   $0x107ebb,0x8(%esp)
f010091b:	00 
f010091c:	c7 44 24 04 bb 7e 10 	movl   $0xf0107ebb,0x4(%esp)
f0100923:	f0 
f0100924:	c7 04 24 6c 83 10 f0 	movl   $0xf010836c,(%esp)
f010092b:	e8 cf 3c 00 00       	call   f01045ff <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100930:	c7 44 24 08 51 0b 27 	movl   $0x270b51,0x8(%esp)
f0100937:	00 
f0100938:	c7 44 24 04 51 0b 27 	movl   $0xf0270b51,0x4(%esp)
f010093f:	f0 
f0100940:	c7 04 24 90 83 10 f0 	movl   $0xf0108390,(%esp)
f0100947:	e8 b3 3c 00 00       	call   f01045ff <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010094c:	c7 44 24 08 14 30 2b 	movl   $0x2b3014,0x8(%esp)
f0100953:	00 
f0100954:	c7 44 24 04 14 30 2b 	movl   $0xf02b3014,0x4(%esp)
f010095b:	f0 
f010095c:	c7 04 24 b4 83 10 f0 	movl   $0xf01083b4,(%esp)
f0100963:	e8 97 3c 00 00       	call   f01045ff <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
f0100968:	b8 13 34 2b f0       	mov    $0xf02b3413,%eax
f010096d:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100972:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0100977:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f010097d:	85 c0                	test   %eax,%eax
f010097f:	0f 48 c2             	cmovs  %edx,%eax
f0100982:	c1 f8 0a             	sar    $0xa,%eax
f0100985:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100989:	c7 04 24 d8 83 10 f0 	movl   $0xf01083d8,(%esp)
f0100990:	e8 6a 3c 00 00       	call   f01045ff <cprintf>
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}
f0100995:	b8 00 00 00 00       	mov    $0x0,%eax
f010099a:	c9                   	leave  
f010099b:	c3                   	ret    

f010099c <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f010099c:	55                   	push   %ebp
f010099d:	89 e5                	mov    %esp,%ebp
f010099f:	83 ec 18             	sub    $0x18,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01009a2:	a1 44 82 10 f0       	mov    0xf0108244,%eax
f01009a7:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009ab:	a1 40 82 10 f0       	mov    0xf0108240,%eax
f01009b0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009b4:	c7 04 24 7d 82 10 f0 	movl   $0xf010827d,(%esp)
f01009bb:	e8 3f 3c 00 00       	call   f01045ff <cprintf>
f01009c0:	a1 50 82 10 f0       	mov    0xf0108250,%eax
f01009c5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009c9:	a1 4c 82 10 f0       	mov    0xf010824c,%eax
f01009ce:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009d2:	c7 04 24 7d 82 10 f0 	movl   $0xf010827d,(%esp)
f01009d9:	e8 21 3c 00 00       	call   f01045ff <cprintf>
f01009de:	a1 5c 82 10 f0       	mov    0xf010825c,%eax
f01009e3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009e7:	a1 58 82 10 f0       	mov    0xf0108258,%eax
f01009ec:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009f0:	c7 04 24 7d 82 10 f0 	movl   $0xf010827d,(%esp)
f01009f7:	e8 03 3c 00 00       	call   f01045ff <cprintf>
	return 0;
}
f01009fc:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a01:	c9                   	leave  
f0100a02:	c3                   	ret    

f0100a03 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100a03:	55                   	push   %ebp
f0100a04:	89 e5                	mov    %esp,%ebp
f0100a06:	57                   	push   %edi
f0100a07:	56                   	push   %esi
f0100a08:	53                   	push   %ebx
f0100a09:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100a0c:	c7 04 24 04 84 10 f0 	movl   $0xf0108404,(%esp)
f0100a13:	e8 e7 3b 00 00       	call   f01045ff <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100a18:	c7 04 24 28 84 10 f0 	movl   $0xf0108428,(%esp)
f0100a1f:	e8 db 3b 00 00       	call   f01045ff <cprintf>

	if (tf != NULL)
f0100a24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100a28:	74 0b                	je     f0100a35 <monitor+0x32>
		print_trapframe(tf);
f0100a2a:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a2d:	89 04 24             	mov    %eax,(%esp)
f0100a30:	e8 3e 3f 00 00       	call   f0104973 <print_trapframe>

	while (1) {
		buf = readline("K> ");
f0100a35:	c7 04 24 86 82 10 f0 	movl   $0xf0108286,(%esp)
f0100a3c:	e8 ef 56 00 00       	call   f0106130 <readline>
f0100a41:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a43:	85 c0                	test   %eax,%eax
f0100a45:	74 ee                	je     f0100a35 <monitor+0x32>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100a47:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f0100a4e:	be 00 00 00 00       	mov    $0x0,%esi
f0100a53:	eb 06                	jmp    f0100a5b <monitor+0x58>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100a55:	c6 03 00             	movb   $0x0,(%ebx)
f0100a58:	83 c3 01             	add    $0x1,%ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100a5b:	0f b6 03             	movzbl (%ebx),%eax
f0100a5e:	84 c0                	test   %al,%al
f0100a60:	74 63                	je     f0100ac5 <monitor+0xc2>
f0100a62:	0f be c0             	movsbl %al,%eax
f0100a65:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a69:	c7 04 24 8a 82 10 f0 	movl   $0xf010828a,(%esp)
f0100a70:	e8 de 58 00 00       	call   f0106353 <strchr>
f0100a75:	85 c0                	test   %eax,%eax
f0100a77:	75 dc                	jne    f0100a55 <monitor+0x52>
			*buf++ = 0;
		if (*buf == 0)
f0100a79:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a7c:	74 47                	je     f0100ac5 <monitor+0xc2>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100a7e:	83 fe 0f             	cmp    $0xf,%esi
f0100a81:	75 16                	jne    f0100a99 <monitor+0x96>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a83:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100a8a:	00 
f0100a8b:	c7 04 24 8f 82 10 f0 	movl   $0xf010828f,(%esp)
f0100a92:	e8 68 3b 00 00       	call   f01045ff <cprintf>
f0100a97:	eb 9c                	jmp    f0100a35 <monitor+0x32>
			return 0;
		}
		argv[argc++] = buf;
f0100a99:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100a9d:	83 c6 01             	add    $0x1,%esi
f0100aa0:	eb 03                	jmp    f0100aa5 <monitor+0xa2>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
f0100aa2:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100aa5:	0f b6 03             	movzbl (%ebx),%eax
f0100aa8:	84 c0                	test   %al,%al
f0100aaa:	74 af                	je     f0100a5b <monitor+0x58>
f0100aac:	0f be c0             	movsbl %al,%eax
f0100aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ab3:	c7 04 24 8a 82 10 f0 	movl   $0xf010828a,(%esp)
f0100aba:	e8 94 58 00 00       	call   f0106353 <strchr>
f0100abf:	85 c0                	test   %eax,%eax
f0100ac1:	74 df                	je     f0100aa2 <monitor+0x9f>
f0100ac3:	eb 96                	jmp    f0100a5b <monitor+0x58>
			buf++;
	}
	argv[argc] = 0;
f0100ac5:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100acc:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100acd:	85 f6                	test   %esi,%esi
f0100acf:	0f 84 60 ff ff ff    	je     f0100a35 <monitor+0x32>
f0100ad5:	bb 40 82 10 f0       	mov    $0xf0108240,%ebx
f0100ada:	bf 00 00 00 00       	mov    $0x0,%edi
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100adf:	8b 03                	mov    (%ebx),%eax
f0100ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ae5:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100ae8:	89 04 24             	mov    %eax,(%esp)
f0100aeb:	e8 04 58 00 00       	call   f01062f4 <strcmp>
f0100af0:	85 c0                	test   %eax,%eax
f0100af2:	75 23                	jne    f0100b17 <monitor+0x114>
			return commands[i].func(argc, argv, tf);
f0100af4:	6b ff 0c             	imul   $0xc,%edi,%edi
f0100af7:	8b 45 08             	mov    0x8(%ebp),%eax
f0100afa:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100afe:	8d 45 a8             	lea    -0x58(%ebp),%eax
f0100b01:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b05:	89 34 24             	mov    %esi,(%esp)
f0100b08:	ff 97 48 82 10 f0    	call   *-0xfef7db8(%edi)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100b0e:	85 c0                	test   %eax,%eax
f0100b10:	78 28                	js     f0100b3a <monitor+0x137>
f0100b12:	e9 1e ff ff ff       	jmp    f0100a35 <monitor+0x32>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f0100b17:	83 c7 01             	add    $0x1,%edi
f0100b1a:	83 c3 0c             	add    $0xc,%ebx
f0100b1d:	83 ff 03             	cmp    $0x3,%edi
f0100b20:	75 bd                	jne    f0100adf <monitor+0xdc>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100b22:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100b25:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b29:	c7 04 24 ac 82 10 f0 	movl   $0xf01082ac,(%esp)
f0100b30:	e8 ca 3a 00 00       	call   f01045ff <cprintf>
f0100b35:	e9 fb fe ff ff       	jmp    f0100a35 <monitor+0x32>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100b3a:	83 c4 5c             	add    $0x5c,%esp
f0100b3d:	5b                   	pop    %ebx
f0100b3e:	5e                   	pop    %esi
f0100b3f:	5f                   	pop    %edi
f0100b40:	5d                   	pop    %ebp
f0100b41:	c3                   	ret    

f0100b42 <mon_backtrace>:
    }
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100b42:	55                   	push   %ebp
f0100b43:	89 e5                	mov    %esp,%ebp
f0100b45:	57                   	push   %edi
f0100b46:	56                   	push   %esi
f0100b47:	53                   	push   %ebx
f0100b48:	83 ec 6c             	sub    $0x6c,%esp
	uintptr_t arg1, arg2, arg3, arg4, arg5;
	struct Eipdebuginfo info;
	int dist;
	
	//get current ebp
	get_reg(V_EBP,0,&curr_ebp);
f0100b4b:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0100b4e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b52:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100b59:	00 
f0100b5a:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
f0100b61:	e8 2a fd ff ff       	call   f0100890 <get_reg>
	prev_ebp = *(uint32_t *) curr_ebp;
f0100b66:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100b69:	8b 18                	mov    (%eax),%ebx
	cprintf("Stack backtrace:\n");
f0100b6b:	c7 04 24 c2 82 10 f0 	movl   $0xf01082c2,(%esp)
f0100b72:	e8 88 3a 00 00       	call   f01045ff <cprintf>
	
	while(prev_ebp) 
	{
			curr_ebp = prev_ebp;
			memset(&info, 0, sizeof(struct Eipdebuginfo)); 
f0100b77:	8d 75 b4             	lea    -0x4c(%ebp),%esi
			get_reg(V_EIP,curr_ebp,&eip);
f0100b7a:	8d 7d e4             	lea    -0x1c(%ebp),%edi
	//get current ebp
	get_reg(V_EBP,0,&curr_ebp);
	prev_ebp = *(uint32_t *) curr_ebp;
	cprintf("Stack backtrace:\n");
	
	while(prev_ebp) 
f0100b7d:	e9 3b 01 00 00       	jmp    f0100cbd <mon_backtrace+0x17b>
	{
			curr_ebp = prev_ebp;
f0100b82:	89 5d e0             	mov    %ebx,-0x20(%ebp)
			memset(&info, 0, sizeof(struct Eipdebuginfo)); 
f0100b85:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
f0100b8c:	00 
f0100b8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100b94:	00 
f0100b95:	89 34 24             	mov    %esi,(%esp)
f0100b98:	e8 f3 57 00 00       	call   f0106390 <memset>
			get_reg(V_EIP,curr_ebp,&eip);
f0100b9d:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0100ba1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ba8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100baf:	e8 dc fc ff ff       	call   f0100890 <get_reg>
			get_reg(V_AR1,curr_ebp,&arg1);
f0100bb4:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0100bb7:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0100bc9:	e8 c2 fc ff ff       	call   f0100890 <get_reg>
			get_reg(V_AR2,curr_ebp,&arg2);
f0100bce:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0100bd1:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100bd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bdc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
f0100be3:	e8 a8 fc ff ff       	call   f0100890 <get_reg>
			get_reg(V_AR3,curr_ebp,&arg3); 
f0100be8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
f0100beb:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bf6:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
f0100bfd:	e8 8e fc ff ff       	call   f0100890 <get_reg>
			get_reg(V_AR4,curr_ebp,&arg4);
f0100c02:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100c05:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c10:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
f0100c17:	e8 74 fc ff ff       	call   f0100890 <get_reg>
			get_reg(V_AR5,curr_ebp,&arg5);
f0100c1c:	8d 45 cc             	lea    -0x34(%ebp),%eax
f0100c1f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100c26:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c2a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f0100c31:	e8 5a fc ff ff       	call   f0100890 <get_reg>
			cprintf("ebp %x eip %x args %08x %08x %08x %08x %08x\n", curr_ebp,eip,arg1,arg2,arg3,arg4,arg5);
f0100c36:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0100c39:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0100c3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100c40:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100c44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100c47:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100c4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100c4e:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100c52:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100c55:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100c5c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100c63:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c67:	c7 04 24 50 84 10 f0 	movl   $0xf0108450,(%esp)
f0100c6e:	e8 8c 39 00 00       	call   f01045ff <cprintf>
			
			if(!debuginfo_eip(eip,&info))
f0100c73:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100c7a:	89 04 24             	mov    %eax,(%esp)
f0100c7d:	e8 d0 4c 00 00       	call   f0105952 <debuginfo_eip>
f0100c82:	85 c0                	test   %eax,%eax
f0100c84:	75 32                	jne    f0100cb8 <mon_backtrace+0x176>
			{
				dist = eip-info.eip_fn_addr;
				cprintf("%s:%d: %.*s+%d\n",info.eip_file,info.eip_line,info.eip_fn_namelen,info.eip_fn_name,dist);
f0100c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100c89:	2b 45 c4             	sub    -0x3c(%ebp),%eax
f0100c8c:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100c90:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0100c93:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100c97:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0100c9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100c9e:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0100ca1:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100ca5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
f0100ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100cac:	c7 04 24 d4 82 10 f0 	movl   $0xf01082d4,(%esp)
f0100cb3:	e8 47 39 00 00       	call   f01045ff <cprintf>
			}
			prev_ebp = *(uint32_t *) curr_ebp;   
f0100cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100cbb:	8b 18                	mov    (%eax),%ebx
	//get current ebp
	get_reg(V_EBP,0,&curr_ebp);
	prev_ebp = *(uint32_t *) curr_ebp;
	cprintf("Stack backtrace:\n");
	
	while(prev_ebp) 
f0100cbd:	85 db                	test   %ebx,%ebx
f0100cbf:	0f 85 bd fe ff ff    	jne    f0100b82 <mon_backtrace+0x40>
			}
			prev_ebp = *(uint32_t *) curr_ebp;   
	}
	
	return 0;
}
f0100cc5:	b8 00 00 00 00       	mov    $0x0,%eax
f0100cca:	83 c4 6c             	add    $0x6c,%esp
f0100ccd:	5b                   	pop    %ebx
f0100cce:	5e                   	pop    %esi
f0100ccf:	5f                   	pop    %edi
f0100cd0:	5d                   	pop    %ebp
f0100cd1:	c3                   	ret    
	...

f0100ce0 <alloc_user_page>:
}


struct PageInfo *
alloc_user_page()
{
f0100ce0:	55                   	push   %ebp
f0100ce1:	89 e5                	mov    %esp,%ebp
f0100ce3:	56                   	push   %esi
f0100ce4:	53                   	push   %ebx
	struct PageInfo * prev, * temp;
	ppn_t  kbound = PGNUM(ROUNDUP(0-KERNBASE,PGSIZE));
		
	for(temp=page_free_list,prev=page_free_list;temp;temp=temp->pp_link)
f0100ce5:	8b 35 30 12 27 f0    	mov    0xf0271230,%esi
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100ceb:	8b 1d ac 1e 27 f0    	mov    0xf0271eac,%ebx
f0100cf1:	89 f0                	mov    %esi,%eax
f0100cf3:	89 f1                	mov    %esi,%ecx
f0100cf5:	eb 32                	jmp    f0100d29 <alloc_user_page+0x49>
f0100cf7:	89 c2                	mov    %eax,%edx
f0100cf9:	29 da                	sub    %ebx,%edx
f0100cfb:	c1 fa 03             	sar    $0x3,%edx
f0100cfe:	c1 e2 0c             	shl    $0xc,%edx
	{ 
		if(page2pa(temp)>=kbound) 
f0100d01:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
f0100d07:	76 1c                	jbe    f0100d25 <alloc_user_page+0x45>
f0100d09:	89 c2                	mov    %eax,%edx
		{  
			if(prev==page_free_list) page_free_list = temp->pp_link;
f0100d0b:	39 f1                	cmp    %esi,%ecx
f0100d0d:	75 0a                	jne    f0100d19 <alloc_user_page+0x39>
f0100d0f:	8b 08                	mov    (%eax),%ecx
f0100d11:	89 0d 30 12 27 f0    	mov    %ecx,0xf0271230
f0100d17:	eb 04                	jmp    f0100d1d <alloc_user_page+0x3d>
			else prev->pp_link = temp->pp_link;
f0100d19:	8b 18                	mov    (%eax),%ebx
f0100d1b:	89 19                	mov    %ebx,(%ecx)
			temp->pp_link=NULL; break;
f0100d1d:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
f0100d23:	eb 08                	jmp    f0100d2d <alloc_user_page+0x4d>
alloc_user_page()
{
	struct PageInfo * prev, * temp;
	ppn_t  kbound = PGNUM(ROUNDUP(0-KERNBASE,PGSIZE));
		
	for(temp=page_free_list,prev=page_free_list;temp;temp=temp->pp_link)
f0100d25:	89 c1                	mov    %eax,%ecx
f0100d27:	8b 00                	mov    (%eax),%eax
f0100d29:	85 c0                	test   %eax,%eax
f0100d2b:	75 ca                	jne    f0100cf7 <alloc_user_page+0x17>
		prev=temp;

	}
	
	return temp;
}
f0100d2d:	5b                   	pop    %ebx
f0100d2e:	5e                   	pop    %esi
f0100d2f:	5d                   	pop    %ebp
f0100d30:	c3                   	ret    

f0100d31 <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100d31:	55                   	push   %ebp
f0100d32:	89 e5                	mov    %esp,%ebp
f0100d34:	83 ec 18             	sub    $0x18,%esp
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
f0100d37:	89 d1                	mov    %edx,%ecx
f0100d39:	c1 e9 16             	shr    $0x16,%ecx
f0100d3c:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100d3f:	a8 01                	test   $0x1,%al
f0100d41:	74 4d                	je     f0100d90 <check_va2pa+0x5f>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100d43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100d48:	89 c1                	mov    %eax,%ecx
f0100d4a:	c1 e9 0c             	shr    $0xc,%ecx
f0100d4d:	3b 0d a4 1e 27 f0    	cmp    0xf0271ea4,%ecx
f0100d53:	72 20                	jb     f0100d75 <check_va2pa+0x44>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d55:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100d59:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0100d60:	f0 
f0100d61:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
f0100d68:	00 
f0100d69:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0100d70:	e8 10 f3 ff ff       	call   f0100085 <_panic>
	if (!(p[PTX(va)] & PTE_P))
f0100d75:	c1 ea 0c             	shr    $0xc,%edx
f0100d78:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100d7e:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100d85:	a8 01                	test   $0x1,%al
f0100d87:	74 07                	je     f0100d90 <check_va2pa+0x5f>
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100d89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d8e:	eb 05                	jmp    f0100d95 <check_va2pa+0x64>
f0100d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100d95:	c9                   	leave  
f0100d96:	c3                   	ret    

f0100d97 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f0100d97:	55                   	push   %ebp
f0100d98:	89 e5                	mov    %esp,%ebp
f0100d9a:	83 ec 18             	sub    $0x18,%esp
f0100d9d:	8b 45 08             	mov    0x8(%ebp),%eax
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	struct PageInfo * curr, *prev = NULL;
	
	if(pp->pp_ref || pp->pp_link) {panic("pp_ref or pp_link is not correct!\n");}
f0100da0:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0100da5:	75 05                	jne    f0100dac <page_free+0x15>
f0100da7:	83 38 00             	cmpl   $0x0,(%eax)
f0100daa:	74 1c                	je     f0100dc8 <page_free+0x31>
f0100dac:	c7 44 24 08 a8 84 10 	movl   $0xf01084a8,0x8(%esp)
f0100db3:	f0 
f0100db4:	c7 44 24 04 d5 01 00 	movl   $0x1d5,0x4(%esp)
f0100dbb:	00 
f0100dbc:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0100dc3:	e8 bd f2 ff ff       	call   f0100085 <_panic>

	pp->pp_link = page_free_list; page_free_list = pp;
f0100dc8:	8b 15 30 12 27 f0    	mov    0xf0271230,%edx
f0100dce:	89 10                	mov    %edx,(%eax)
f0100dd0:	a3 30 12 27 f0       	mov    %eax,0xf0271230
	//	if((!prev || prev < pp) && curr > pp) break;

	//pp->pp_link = curr;		
	//if(prev) prev->pp_link = pp;
	//else page_free_list = pp;
}
f0100dd5:	c9                   	leave  
f0100dd6:	c3                   	ret    

f0100dd7 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f0100dd7:	55                   	push   %ebp
f0100dd8:	89 e5                	mov    %esp,%ebp
f0100dda:	83 ec 18             	sub    $0x18,%esp
f0100ddd:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0100de0:	0f b7 50 04          	movzwl 0x4(%eax),%edx
f0100de4:	83 ea 01             	sub    $0x1,%edx
f0100de7:	66 89 50 04          	mov    %dx,0x4(%eax)
f0100deb:	66 85 d2             	test   %dx,%dx
f0100dee:	75 08                	jne    f0100df8 <page_decref+0x21>
		page_free(pp);
f0100df0:	89 04 24             	mov    %eax,(%esp)
f0100df3:	e8 9f ff ff ff       	call   f0100d97 <page_free>
}
f0100df8:	c9                   	leave  
f0100df9:	c3                   	ret    

f0100dfa <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100dfa:	55                   	push   %ebp
f0100dfb:	89 e5                	mov    %esp,%ebp
f0100dfd:	83 ec 18             	sub    $0x18,%esp
f0100e00:	89 c2                	mov    %eax,%edx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100e02:	83 3d 28 12 27 f0 00 	cmpl   $0x0,0xf0271228
f0100e09:	75 0f                	jne    f0100e1a <boot_alloc+0x20>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e0b:	b8 13 40 2b f0       	mov    $0xf02b4013,%eax
f0100e10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100e15:	a3 28 12 27 f0       	mov    %eax,0xf0271228
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	// return NULL;
	result = nextfree;
f0100e1a:	a1 28 12 27 f0       	mov    0xf0271228,%eax
	if(!n) {goto cplalloc;}
f0100e1f:	85 d2                	test   %edx,%edx
f0100e21:	74 32                	je     f0100e55 <boot_alloc+0x5b>
	
	n = ROUNDUP((uint32_t) n, PGSIZE);
f0100e23:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
	if((size_t)(nextfree+n) < (size_t)nextfree)
f0100e29:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100e2f:	01 c2                	add    %eax,%edx
f0100e31:	73 1c                	jae    f0100e4f <boot_alloc+0x55>
	{panic("no enough memory can be allocated!");}
f0100e33:	c7 44 24 08 cc 84 10 	movl   $0xf01084cc,0x8(%esp)
f0100e3a:	f0 
f0100e3b:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
f0100e42:	00 
f0100e43:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0100e4a:	e8 36 f2 ff ff       	call   f0100085 <_panic>
	nextfree += n;
f0100e4f:	89 15 28 12 27 f0    	mov    %edx,0xf0271228
		
cplalloc:		
	return (void *)result;
}
f0100e55:	c9                   	leave  
f0100e56:	c3                   	ret    

f0100e57 <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0100e57:	55                   	push   %ebp
f0100e58:	89 e5                	mov    %esp,%ebp
f0100e5a:	83 ec 08             	sub    $0x8,%esp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0100e5d:	e8 a4 5b 00 00       	call   f0106a06 <cpunum>
f0100e62:	6b c0 74             	imul   $0x74,%eax,%eax
f0100e65:	83 b8 28 20 27 f0 00 	cmpl   $0x0,-0xfd8dfd8(%eax)
f0100e6c:	74 16                	je     f0100e84 <tlb_invalidate+0x2d>
f0100e6e:	e8 93 5b 00 00       	call   f0106a06 <cpunum>
f0100e73:	6b c0 74             	imul   $0x74,%eax,%eax
f0100e76:	8b 90 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%edx
f0100e7c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e7f:	39 42 60             	cmp    %eax,0x60(%edx)
f0100e82:	75 06                	jne    f0100e8a <tlb_invalidate+0x33>
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0100e84:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100e87:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f0100e8a:	c9                   	leave  
f0100e8b:	c3                   	ret    

f0100e8c <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100e8c:	55                   	push   %ebp
f0100e8d:	89 e5                	mov    %esp,%ebp
f0100e8f:	83 ec 18             	sub    $0x18,%esp
f0100e92:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0100e95:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0100e98:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100e9a:	89 04 24             	mov    %eax,(%esp)
f0100e9d:	e8 f2 35 00 00       	call   f0104494 <mc146818_read>
f0100ea2:	89 c6                	mov    %eax,%esi
f0100ea4:	83 c3 01             	add    $0x1,%ebx
f0100ea7:	89 1c 24             	mov    %ebx,(%esp)
f0100eaa:	e8 e5 35 00 00       	call   f0104494 <mc146818_read>
f0100eaf:	c1 e0 08             	shl    $0x8,%eax
f0100eb2:	09 f0                	or     %esi,%eax
}
f0100eb4:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0100eb7:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0100eba:	89 ec                	mov    %ebp,%esp
f0100ebc:	5d                   	pop    %ebp
f0100ebd:	c3                   	ret    

f0100ebe <i386_detect_memory>:

static void
i386_detect_memory(void)
{
f0100ebe:	55                   	push   %ebp
f0100ebf:	89 e5                	mov    %esp,%ebp
f0100ec1:	83 ec 18             	sub    $0x18,%esp
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0100ec4:	b8 15 00 00 00       	mov    $0x15,%eax
f0100ec9:	e8 be ff ff ff       	call   f0100e8c <nvram_read>
f0100ece:	c1 e0 0a             	shl    $0xa,%eax
f0100ed1:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100ed7:	85 c0                	test   %eax,%eax
f0100ed9:	0f 48 c2             	cmovs  %edx,%eax
f0100edc:	c1 f8 0c             	sar    $0xc,%eax
f0100edf:	a3 2c 12 27 f0       	mov    %eax,0xf027122c
	npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f0100ee4:	b8 17 00 00 00       	mov    $0x17,%eax
f0100ee9:	e8 9e ff ff ff       	call   f0100e8c <nvram_read>
f0100eee:	c1 e0 0a             	shl    $0xa,%eax
f0100ef1:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100ef7:	85 c0                	test   %eax,%eax
f0100ef9:	0f 48 c2             	cmovs  %edx,%eax
f0100efc:	c1 f8 0c             	sar    $0xc,%eax

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (npages_extmem)
f0100eff:	85 c0                	test   %eax,%eax
f0100f01:	74 0e                	je     f0100f11 <i386_detect_memory+0x53>
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f0100f03:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
f0100f09:	89 15 a4 1e 27 f0    	mov    %edx,0xf0271ea4
f0100f0f:	eb 0c                	jmp    f0100f1d <i386_detect_memory+0x5f>
	else
		npages = npages_basemem;
f0100f11:	8b 15 2c 12 27 f0    	mov    0xf027122c,%edx
f0100f17:	89 15 a4 1e 27 f0    	mov    %edx,0xf0271ea4

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0100f1d:	c1 e0 0c             	shl    $0xc,%eax
f0100f20:	c1 e8 0a             	shr    $0xa,%eax
f0100f23:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100f27:	a1 2c 12 27 f0       	mov    0xf027122c,%eax
f0100f2c:	c1 e0 0c             	shl    $0xc,%eax
f0100f2f:	c1 e8 0a             	shr    $0xa,%eax
f0100f32:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100f36:	a1 a4 1e 27 f0       	mov    0xf0271ea4,%eax
f0100f3b:	c1 e0 0c             	shl    $0xc,%eax
f0100f3e:	c1 e8 0a             	shr    $0xa,%eax
f0100f41:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100f45:	c7 04 24 f0 84 10 f0 	movl   $0xf01084f0,(%esp)
f0100f4c:	e8 ae 36 00 00       	call   f01045ff <cprintf>
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
		npages_extmem * PGSIZE / 1024);
}
f0100f51:	c9                   	leave  
f0100f52:	c3                   	ret    

f0100f53 <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f0100f53:	55                   	push   %ebp
f0100f54:	89 e5                	mov    %esp,%ebp
f0100f56:	83 ec 18             	sub    $0x18,%esp
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100f59:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f0100f5f:	c1 f8 03             	sar    $0x3,%eax
f0100f62:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100f65:	89 c2                	mov    %eax,%edx
f0100f67:	c1 ea 0c             	shr    $0xc,%edx
f0100f6a:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0100f70:	72 20                	jb     f0100f92 <page2kva+0x3f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f72:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100f76:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0100f7d:	f0 
f0100f7e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0100f85:	00 
f0100f86:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0100f8d:	e8 f3 f0 ff ff       	call   f0100085 <_panic>
f0100f92:	2d 00 00 00 10       	sub    $0x10000000,%eax

static inline void*
page2kva(struct PageInfo *pp)
{
	return KADDR(page2pa(pp));
}
f0100f97:	c9                   	leave  
f0100f98:	c3                   	ret    

f0100f99 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f0100f99:	55                   	push   %ebp
f0100f9a:	89 e5                	mov    %esp,%ebp
f0100f9c:	57                   	push   %edi
f0100f9d:	56                   	push   %esi
f0100f9e:	53                   	push   %ebx
f0100f9f:	83 ec 3c             	sub    $0x3c,%esp

	// LAB 4:
	// Change your code to mark the physical page at MPENTRY_PADDR
	// as in use	
  	 size_t i,j; 
  	 uint32_t page_end = PADDR(boot_alloc(0));
f0100fa2:	b8 00 00 00 00       	mov    $0x0,%eax
f0100fa7:	e8 4e fe ff ff       	call   f0100dfa <boot_alloc>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0100fac:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100fb1:	77 20                	ja     f0100fd3 <page_init+0x3a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100fb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100fb7:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0100fbe:	f0 
f0100fbf:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
f0100fc6:	00 
f0100fc7:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0100fce:	e8 b2 f0 ff ff       	call   f0100085 <_panic>
  	 struct range {uint32_t start; uint32_t end;}; 
  	 struct range used_range[4] = {{.start = 0,.end = 1},
  	 				 			   {.start = IOPHYSMEM/PGSIZE, .end = EXTPHYSMEM/PGSIZE},
  	 				 			   {.start = EXTPHYSMEM/PGSIZE,.end = page_end/PGSIZE},
  	 				 			   {.start = MPENTRY_PADDR/PGSIZE,.end = MPENTRY_PADDR/PGSIZE+1}};
f0100fd3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f0100fda:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
f0100fe1:	c7 45 d0 a0 00 00 00 	movl   $0xa0,-0x30(%ebp)
f0100fe8:	c7 45 d4 00 01 00 00 	movl   $0x100,-0x2c(%ebp)
f0100fef:	c7 45 d8 00 01 00 00 	movl   $0x100,-0x28(%ebp)
f0100ff6:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f0100ffc:	c1 e8 0c             	shr    $0xc,%eax
f0100fff:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0101002:	c7 45 e0 07 00 00 00 	movl   $0x7,-0x20(%ebp)
f0101009:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)

  	for(i=npages,page_free_list=NULL;i>0;) //put the memory part in kernel space first
f0101010:	8b 15 a4 1e 27 f0    	mov    0xf0271ea4,%edx
f0101016:	be 00 00 00 00       	mov    $0x0,%esi
  	{
  		i--;
 		for(j=0;j<4;j++){if(used_range[j].start<=i && used_range[j].end>i)break;}
f010101b:	8d 4d c8             	lea    -0x38(%ebp),%ecx
  	 struct range used_range[4] = {{.start = 0,.end = 1},
  	 				 			   {.start = IOPHYSMEM/PGSIZE, .end = EXTPHYSMEM/PGSIZE},
  	 				 			   {.start = EXTPHYSMEM/PGSIZE,.end = page_end/PGSIZE},
  	 				 			   {.start = MPENTRY_PADDR/PGSIZE,.end = MPENTRY_PADDR/PGSIZE+1}};

  	for(i=npages,page_free_list=NULL;i>0;) //put the memory part in kernel space first
f010101e:	eb 46                	jmp    f0101066 <page_init+0xcd>
  	{
  		i--;
f0101020:	83 ea 01             	sub    $0x1,%edx
f0101023:	b8 00 00 00 00       	mov    $0x0,%eax
 		for(j=0;j<4;j++){if(used_range[j].start<=i && used_range[j].end>i)break;}
f0101028:	3b 14 c1             	cmp    (%ecx,%eax,8),%edx
f010102b:	72 06                	jb     f0101033 <page_init+0x9a>
f010102d:	3b 54 c1 04          	cmp    0x4(%ecx,%eax,8),%edx
f0101031:	72 0a                	jb     f010103d <page_init+0xa4>
f0101033:	83 c0 01             	add    $0x1,%eax
f0101036:	83 f8 04             	cmp    $0x4,%eax
f0101039:	75 ed                	jne    f0101028 <page_init+0x8f>
f010103b:	eb 3b                	jmp    f0101078 <page_init+0xdf>
f010103d:	8d 1c d5 00 00 00 00 	lea    0x0(,%edx,8),%ebx
 		pages[i].pp_ref = 0;				 //both free page and used page for kernel, ref count = 0	
f0101044:	8b 3d ac 1e 27 f0    	mov    0xf0271eac,%edi
f010104a:	66 c7 44 1f 04 00 00 	movw   $0x0,0x4(%edi,%ebx,1)
 		if(j==4) { pages[i].pp_link = page_free_list; page_free_list = &pages[i];}
f0101051:	83 f8 04             	cmp    $0x4,%eax
f0101054:	75 10                	jne    f0101066 <page_init+0xcd>
f0101056:	a1 ac 1e 27 f0       	mov    0xf0271eac,%eax
f010105b:	89 34 18             	mov    %esi,(%eax,%ebx,1)
f010105e:	89 de                	mov    %ebx,%esi
f0101060:	03 35 ac 1e 27 f0    	add    0xf0271eac,%esi
  	 struct range used_range[4] = {{.start = 0,.end = 1},
  	 				 			   {.start = IOPHYSMEM/PGSIZE, .end = EXTPHYSMEM/PGSIZE},
  	 				 			   {.start = EXTPHYSMEM/PGSIZE,.end = page_end/PGSIZE},
  	 				 			   {.start = MPENTRY_PADDR/PGSIZE,.end = MPENTRY_PADDR/PGSIZE+1}};

  	for(i=npages,page_free_list=NULL;i>0;) //put the memory part in kernel space first
f0101066:	85 d2                	test   %edx,%edx
f0101068:	75 b6                	jne    f0101020 <page_init+0x87>
f010106a:	89 35 30 12 27 f0    	mov    %esi,0xf0271230
 		for(j=0;j<4;j++){if(used_range[j].start<=i && used_range[j].end>i)break;}
 		pages[i].pp_ref = 0;				 //both free page and used page for kernel, ref count = 0	
 		if(j==4) { pages[i].pp_link = page_free_list; page_free_list = &pages[i];}
  	} 
  	
}
f0101070:	83 c4 3c             	add    $0x3c,%esp
f0101073:	5b                   	pop    %ebx
f0101074:	5e                   	pop    %esi
f0101075:	5f                   	pop    %edi
f0101076:	5d                   	pop    %ebp
f0101077:	c3                   	ret    
f0101078:	8d 1c d5 00 00 00 00 	lea    0x0(,%edx,8),%ebx

  	for(i=npages,page_free_list=NULL;i>0;) //put the memory part in kernel space first
  	{
  		i--;
 		for(j=0;j<4;j++){if(used_range[j].start<=i && used_range[j].end>i)break;}
 		pages[i].pp_ref = 0;				 //both free page and used page for kernel, ref count = 0	
f010107f:	a1 ac 1e 27 f0       	mov    0xf0271eac,%eax
f0101084:	66 c7 44 18 04 00 00 	movw   $0x0,0x4(%eax,%ebx,1)
f010108b:	eb c9                	jmp    f0101056 <page_init+0xbd>

f010108d <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f010108d:	55                   	push   %ebp
f010108e:	89 e5                	mov    %esp,%ebp
f0101090:	57                   	push   %edi
f0101091:	56                   	push   %esi
f0101092:	53                   	push   %ebx
f0101093:	83 ec 5c             	sub    $0x5c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101096:	3c 01                	cmp    $0x1,%al
f0101098:	19 f6                	sbb    %esi,%esi
f010109a:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
f01010a0:	83 c6 01             	add    $0x1,%esi
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f01010a3:	8b 15 30 12 27 f0    	mov    0xf0271230,%edx
f01010a9:	85 d2                	test   %edx,%edx
f01010ab:	75 1c                	jne    f01010c9 <check_page_free_list+0x3c>
		panic("'page_free_list' is a null pointer!");
f01010ad:	c7 44 24 08 2c 85 10 	movl   $0xf010852c,0x8(%esp)
f01010b4:	f0 
f01010b5:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
f01010bc:	00 
f01010bd:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01010c4:	e8 bc ef ff ff       	call   f0100085 <_panic>

	if (only_low_memory) {
f01010c9:	84 c0                	test   %al,%al
f01010cb:	74 4d                	je     f010111a <check_page_free_list+0x8d>
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f01010cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01010d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01010d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01010d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01010d9:	8b 1d ac 1e 27 f0    	mov    0xf0271eac,%ebx
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f01010df:	89 d0                	mov    %edx,%eax
f01010e1:	29 d8                	sub    %ebx,%eax
f01010e3:	c1 e0 09             	shl    $0x9,%eax
f01010e6:	c1 e8 16             	shr    $0x16,%eax
f01010e9:	39 c6                	cmp    %eax,%esi
f01010eb:	0f 96 c0             	setbe  %al
f01010ee:	0f b6 c0             	movzbl %al,%eax
			*tp[pagetype] = pp;
f01010f1:	8b 4c 85 d8          	mov    -0x28(%ebp,%eax,4),%ecx
f01010f5:	89 11                	mov    %edx,(%ecx)
			tp[pagetype] = &pp->pp_link;
f01010f7:	89 54 85 d8          	mov    %edx,-0x28(%ebp,%eax,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f01010fb:	8b 12                	mov    (%edx),%edx
f01010fd:	85 d2                	test   %edx,%edx
f01010ff:	75 de                	jne    f01010df <check_page_free_list+0x52>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f0101101:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101104:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f010110a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010110d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101110:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0101112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101115:	a3 30 12 27 f0       	mov    %eax,0xf0271230
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010111a:	8b 1d 30 12 27 f0    	mov    0xf0271230,%ebx
f0101120:	eb 63                	jmp    f0101185 <check_page_free_list+0xf8>
f0101122:	89 d8                	mov    %ebx,%eax
f0101124:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f010112a:	c1 f8 03             	sar    $0x3,%eax
f010112d:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0101130:	89 c2                	mov    %eax,%edx
f0101132:	c1 ea 16             	shr    $0x16,%edx
f0101135:	39 d6                	cmp    %edx,%esi
f0101137:	76 4a                	jbe    f0101183 <check_page_free_list+0xf6>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101139:	89 c2                	mov    %eax,%edx
f010113b:	c1 ea 0c             	shr    $0xc,%edx
f010113e:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0101144:	72 20                	jb     f0101166 <check_page_free_list+0xd9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101146:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010114a:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0101151:	f0 
f0101152:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101159:	00 
f010115a:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0101161:	e8 1f ef ff ff       	call   f0100085 <_panic>
			memset(page2kva(pp), 0x97, 128);
f0101166:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f010116d:	00 
f010116e:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0101175:	00 
f0101176:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010117b:	89 04 24             	mov    %eax,(%esp)
f010117e:	e8 0d 52 00 00       	call   f0106390 <memset>
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101183:	8b 1b                	mov    (%ebx),%ebx
f0101185:	85 db                	test   %ebx,%ebx
f0101187:	75 99                	jne    f0101122 <check_page_free_list+0x95>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f0101189:	b8 00 00 00 00       	mov    $0x0,%eax
f010118e:	e8 67 fc ff ff       	call   f0100dfa <boot_alloc>
f0101193:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101196:	8b 15 30 12 27 f0    	mov    0xf0271230,%edx
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f010119c:	8b 1d ac 1e 27 f0    	mov    0xf0271eac,%ebx
		assert(pp < pages + npages);
f01011a2:	a1 a4 1e 27 f0       	mov    0xf0271ea4,%eax
f01011a7:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01011aa:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
f01011ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f01011b0:	89 5d d0             	mov    %ebx,-0x30(%ebp)
f01011b3:	be 00 00 00 00       	mov    $0x0,%esi
f01011b8:	bf 00 00 00 00       	mov    $0x0,%edi
f01011bd:	89 5d b4             	mov    %ebx,-0x4c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01011c0:	e9 cd 01 00 00       	jmp    f0101392 <check_page_free_list+0x305>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f01011c5:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
f01011c8:	73 24                	jae    f01011ee <check_page_free_list+0x161>
f01011ca:	c7 44 24 0c 2d 8e 10 	movl   $0xf0108e2d,0xc(%esp)
f01011d1:	f0 
f01011d2:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01011d9:	f0 
f01011da:	c7 44 24 04 37 03 00 	movl   $0x337,0x4(%esp)
f01011e1:	00 
f01011e2:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01011e9:	e8 97 ee ff ff       	call   f0100085 <_panic>
		assert(pp < pages + npages);
f01011ee:	3b 55 cc             	cmp    -0x34(%ebp),%edx
f01011f1:	72 24                	jb     f0101217 <check_page_free_list+0x18a>
f01011f3:	c7 44 24 0c 39 8e 10 	movl   $0xf0108e39,0xc(%esp)
f01011fa:	f0 
f01011fb:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101202:	f0 
f0101203:	c7 44 24 04 38 03 00 	movl   $0x338,0x4(%esp)
f010120a:	00 
f010120b:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101212:	e8 6e ee ff ff       	call   f0100085 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101217:	89 d0                	mov    %edx,%eax
f0101219:	2b 45 d0             	sub    -0x30(%ebp),%eax
f010121c:	a8 07                	test   $0x7,%al
f010121e:	74 24                	je     f0101244 <check_page_free_list+0x1b7>
f0101220:	c7 44 24 0c 50 85 10 	movl   $0xf0108550,0xc(%esp)
f0101227:	f0 
f0101228:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010122f:	f0 
f0101230:	c7 44 24 04 39 03 00 	movl   $0x339,0x4(%esp)
f0101237:	00 
f0101238:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010123f:	e8 41 ee ff ff       	call   f0100085 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101244:	c1 f8 03             	sar    $0x3,%eax
f0101247:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f010124a:	85 c0                	test   %eax,%eax
f010124c:	75 24                	jne    f0101272 <check_page_free_list+0x1e5>
f010124e:	c7 44 24 0c 4d 8e 10 	movl   $0xf0108e4d,0xc(%esp)
f0101255:	f0 
f0101256:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010125d:	f0 
f010125e:	c7 44 24 04 3c 03 00 	movl   $0x33c,0x4(%esp)
f0101265:	00 
f0101266:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010126d:	e8 13 ee ff ff       	call   f0100085 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0101272:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101277:	75 24                	jne    f010129d <check_page_free_list+0x210>
f0101279:	c7 44 24 0c 5e 8e 10 	movl   $0xf0108e5e,0xc(%esp)
f0101280:	f0 
f0101281:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101288:	f0 
f0101289:	c7 44 24 04 3d 03 00 	movl   $0x33d,0x4(%esp)
f0101290:	00 
f0101291:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101298:	e8 e8 ed ff ff       	call   f0100085 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f010129d:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f01012a2:	75 24                	jne    f01012c8 <check_page_free_list+0x23b>
f01012a4:	c7 44 24 0c 84 85 10 	movl   $0xf0108584,0xc(%esp)
f01012ab:	f0 
f01012ac:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01012b3:	f0 
f01012b4:	c7 44 24 04 3e 03 00 	movl   $0x33e,0x4(%esp)
f01012bb:	00 
f01012bc:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01012c3:	e8 bd ed ff ff       	call   f0100085 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f01012c8:	3d 00 00 10 00       	cmp    $0x100000,%eax
f01012cd:	75 24                	jne    f01012f3 <check_page_free_list+0x266>
f01012cf:	c7 44 24 0c 77 8e 10 	movl   $0xf0108e77,0xc(%esp)
f01012d6:	f0 
f01012d7:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01012de:	f0 
f01012df:	c7 44 24 04 3f 03 00 	movl   $0x33f,0x4(%esp)
f01012e6:	00 
f01012e7:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01012ee:	e8 92 ed ff ff       	call   f0100085 <_panic>
f01012f3:	89 c1                	mov    %eax,%ecx
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01012f5:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f01012fa:	76 59                	jbe    f0101355 <check_page_free_list+0x2c8>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01012fc:	89 c3                	mov    %eax,%ebx
f01012fe:	c1 eb 0c             	shr    $0xc,%ebx
f0101301:	39 5d c8             	cmp    %ebx,-0x38(%ebp)
f0101304:	77 20                	ja     f0101326 <check_page_free_list+0x299>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101306:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010130a:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0101311:	f0 
f0101312:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101319:	00 
f010131a:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0101321:	e8 5f ed ff ff       	call   f0100085 <_panic>
	return (void *)(pa + KERNBASE);
f0101326:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f010132c:	39 5d c4             	cmp    %ebx,-0x3c(%ebp)
f010132f:	76 24                	jbe    f0101355 <check_page_free_list+0x2c8>
f0101331:	c7 44 24 0c a8 85 10 	movl   $0xf01085a8,0xc(%esp)
f0101338:	f0 
f0101339:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101340:	f0 
f0101341:	c7 44 24 04 40 03 00 	movl   $0x340,0x4(%esp)
f0101348:	00 
f0101349:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101350:	e8 30 ed ff ff       	call   f0100085 <_panic>
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f0101355:	3d 00 70 00 00       	cmp    $0x7000,%eax
f010135a:	75 24                	jne    f0101380 <check_page_free_list+0x2f3>
f010135c:	c7 44 24 0c 91 8e 10 	movl   $0xf0108e91,0xc(%esp)
f0101363:	f0 
f0101364:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010136b:	f0 
f010136c:	c7 44 24 04 42 03 00 	movl   $0x342,0x4(%esp)
f0101373:	00 
f0101374:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010137b:	e8 05 ed ff ff       	call   f0100085 <_panic>

		if (page2pa(pp) < EXTPHYSMEM)
f0101380:	81 f9 ff ff 0f 00    	cmp    $0xfffff,%ecx
f0101386:	77 05                	ja     f010138d <check_page_free_list+0x300>
			++nfree_basemem;
f0101388:	83 c7 01             	add    $0x1,%edi
f010138b:	eb 03                	jmp    f0101390 <check_page_free_list+0x303>
		else
			++nfree_extmem;
f010138d:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101390:	8b 12                	mov    (%edx),%edx
f0101392:	85 d2                	test   %edx,%edx
f0101394:	0f 85 2b fe ff ff    	jne    f01011c5 <check_page_free_list+0x138>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f010139a:	85 ff                	test   %edi,%edi
f010139c:	7f 24                	jg     f01013c2 <check_page_free_list+0x335>
f010139e:	c7 44 24 0c ae 8e 10 	movl   $0xf0108eae,0xc(%esp)
f01013a5:	f0 
f01013a6:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01013ad:	f0 
f01013ae:	c7 44 24 04 4a 03 00 	movl   $0x34a,0x4(%esp)
f01013b5:	00 
f01013b6:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01013bd:	e8 c3 ec ff ff       	call   f0100085 <_panic>
	assert(nfree_extmem > 0);
f01013c2:	85 f6                	test   %esi,%esi
f01013c4:	7f 24                	jg     f01013ea <check_page_free_list+0x35d>
f01013c6:	c7 44 24 0c c0 8e 10 	movl   $0xf0108ec0,0xc(%esp)
f01013cd:	f0 
f01013ce:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01013d5:	f0 
f01013d6:	c7 44 24 04 4b 03 00 	movl   $0x34b,0x4(%esp)
f01013dd:	00 
f01013de:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01013e5:	e8 9b ec ff ff       	call   f0100085 <_panic>
	
}
f01013ea:	83 c4 5c             	add    $0x5c,%esp
f01013ed:	5b                   	pop    %ebx
f01013ee:	5e                   	pop    %esi
f01013ef:	5f                   	pop    %edi
f01013f0:	5d                   	pop    %ebp
f01013f1:	c3                   	ret    

f01013f2 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f01013f2:	55                   	push   %ebp
f01013f3:	89 e5                	mov    %esp,%ebp
f01013f5:	56                   	push   %esi
f01013f6:	53                   	push   %ebx
f01013f7:	83 ec 10             	sub    $0x10,%esp
	// Fill this function in
	struct PageInfo * prev, * temp;
	void * temp_kva;
	physaddr_t kbound = ROUNDUP(0-KERNBASE,PGSIZE);
	
	for(temp=page_free_list,prev=page_free_list;temp;temp=temp->pp_link)
f01013fa:	8b 35 30 12 27 f0    	mov    0xf0271230,%esi
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101400:	8b 0d ac 1e 27 f0    	mov    0xf0271eac,%ecx
f0101406:	89 f3                	mov    %esi,%ebx
f0101408:	89 f2                	mov    %esi,%edx
f010140a:	eb 37                	jmp    f0101443 <page_alloc+0x51>
f010140c:	89 d8                	mov    %ebx,%eax
f010140e:	29 c8                	sub    %ecx,%eax
f0101410:	c1 f8 03             	sar    $0x3,%eax
f0101413:	c1 e0 0c             	shl    $0xc,%eax
	{ 
		if(page2pa(temp)<kbound) 
f0101416:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
f010141b:	77 22                	ja     f010143f <page_alloc+0x4d>
f010141d:	89 d8                	mov    %ebx,%eax
		{  
		   if(prev==page_free_list) page_free_list = temp->pp_link;
f010141f:	39 f2                	cmp    %esi,%edx
f0101421:	75 0a                	jne    f010142d <page_alloc+0x3b>
f0101423:	8b 13                	mov    (%ebx),%edx
f0101425:	89 15 30 12 27 f0    	mov    %edx,0xf0271230
f010142b:	eb 04                	jmp    f0101431 <page_alloc+0x3f>
		   else prev->pp_link = temp->pp_link;
f010142d:	8b 0b                	mov    (%ebx),%ecx
f010142f:	89 0a                	mov    %ecx,(%edx)
		   temp->pp_link=NULL; break;
f0101431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		}
		prev=temp;
	}

	if(temp && (alloc_flags & ALLOC_ZERO))
f0101437:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f010143b:	74 62                	je     f010149f <page_alloc+0xad>
f010143d:	eb 0a                	jmp    f0101449 <page_alloc+0x57>
	// Fill this function in
	struct PageInfo * prev, * temp;
	void * temp_kva;
	physaddr_t kbound = ROUNDUP(0-KERNBASE,PGSIZE);
	
	for(temp=page_free_list,prev=page_free_list;temp;temp=temp->pp_link)
f010143f:	89 da                	mov    %ebx,%edx
f0101441:	8b 1b                	mov    (%ebx),%ebx
f0101443:	85 db                	test   %ebx,%ebx
f0101445:	75 c5                	jne    f010140c <page_alloc+0x1a>
f0101447:	eb 56                	jmp    f010149f <page_alloc+0xad>
f0101449:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f010144f:	c1 f8 03             	sar    $0x3,%eax
f0101452:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101455:	89 c2                	mov    %eax,%edx
f0101457:	c1 ea 0c             	shr    $0xc,%edx
f010145a:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0101460:	72 20                	jb     f0101482 <page_alloc+0x90>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101462:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101466:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f010146d:	f0 
f010146e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101475:	00 
f0101476:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f010147d:	e8 03 ec ff ff       	call   f0100085 <_panic>
		}
		prev=temp;
	}

	if(temp && (alloc_flags & ALLOC_ZERO))
	{temp_kva = page2kva(temp); memset(temp_kva,0,PGSIZE);}
f0101482:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101489:	00 
f010148a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101491:	00 
f0101492:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101497:	89 04 24             	mov    %eax,(%esp)
f010149a:	e8 f1 4e 00 00       	call   f0106390 <memset>
//	{ 
//		page_free_list = page_free_list->pp_link; temp->pp_link=NULL;
//		if(alloc_flags & ALLOC_ZERO){temp_kva = page2kva(temp); memset(temp_kva,0,PGSIZE);}
//	}
	return temp;
}
f010149f:	89 d8                	mov    %ebx,%eax
f01014a1:	83 c4 10             	add    $0x10,%esp
f01014a4:	5b                   	pop    %ebx
f01014a5:	5e                   	pop    %esi
f01014a6:	5d                   	pop    %ebp
f01014a7:	c3                   	ret    

f01014a8 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f01014a8:	55                   	push   %ebp
f01014a9:	89 e5                	mov    %esp,%ebp
f01014ab:	83 ec 18             	sub    $0x18,%esp
f01014ae:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f01014b1:	89 75 fc             	mov    %esi,-0x4(%ebp)
	// Fill this function in
	pte_t * p1;			struct PageInfo *pp;		
	pte_t pt = pgdir[PDX(va)];
f01014b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01014b7:	89 de                	mov    %ebx,%esi
f01014b9:	c1 ee 16             	shr    $0x16,%esi
f01014bc:	c1 e6 02             	shl    $0x2,%esi
f01014bf:	03 75 08             	add    0x8(%ebp),%esi
f01014c2:	8b 06                	mov    (%esi),%eax
	if(!(pt & PTE_P) && !create) return 0;
f01014c4:	89 c2                	mov    %eax,%edx
f01014c6:	83 e2 01             	and    $0x1,%edx
f01014c9:	75 06                	jne    f01014d1 <pgdir_walk+0x29>
f01014cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01014cf:	74 6e                	je     f010153f <pgdir_walk+0x97>
		
	if(!(pt & PTE_P)) 
f01014d1:	85 d2                	test   %edx,%edx
f01014d3:	75 26                	jne    f01014fb <pgdir_walk+0x53>
	{		
			pp = page_alloc(ALLOC_ZERO);	//allocate and initialize to 0
f01014d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01014dc:	e8 11 ff ff ff       	call   f01013f2 <page_alloc>
			if(!pp) return 0; 						
f01014e1:	85 c0                	test   %eax,%eax
f01014e3:	74 5a                	je     f010153f <pgdir_walk+0x97>
			pp->pp_ref++;
f01014e5:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
			pt = page2pa(pp) | PTE_P | PTE_W | PTE_U;
f01014ea:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f01014f0:	c1 f8 03             	sar    $0x3,%eax
f01014f3:	c1 e0 0c             	shl    $0xc,%eax
f01014f6:	83 c8 07             	or     $0x7,%eax
			pgdir[PDX(va)] = pt;
f01014f9:	89 06                	mov    %eax,(%esi)
	} 		
	
	p1 = (pte_t*)KADDR(PTE_ADDR(pt)); 
f01014fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101500:	89 c2                	mov    %eax,%edx
f0101502:	c1 ea 0c             	shr    $0xc,%edx
f0101505:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f010150b:	72 20                	jb     f010152d <pgdir_walk+0x85>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010150d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101511:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0101518:	f0 
f0101519:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
f0101520:	00 
f0101521:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101528:	e8 58 eb ff ff       	call   f0100085 <_panic>
//			if(!pp) return 0; pp.pp_ref++;
//			pt = page2pa(pp) | PTE_P;
//			p1[PTX(va)] =	pt;
//	}		

	return &p1[PTX(va)];
f010152d:	c1 eb 0a             	shr    $0xa,%ebx
f0101530:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
f0101536:	8d 84 18 00 00 00 f0 	lea    -0x10000000(%eax,%ebx,1),%eax
f010153d:	eb 05                	jmp    f0101544 <pgdir_walk+0x9c>
f010153f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101544:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0101547:	8b 75 fc             	mov    -0x4(%ebp),%esi
f010154a:	89 ec                	mov    %ebp,%esp
f010154c:	5d                   	pop    %ebp
f010154d:	c3                   	ret    

f010154e <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f010154e:	55                   	push   %ebp
f010154f:	89 e5                	mov    %esp,%ebp
f0101551:	57                   	push   %edi
f0101552:	56                   	push   %esi
f0101553:	53                   	push   %ebx
f0101554:	83 ec 2c             	sub    $0x2c,%esp
f0101557:	8b 75 08             	mov    0x8(%ebp),%esi
	// LAB 3: Your code here.
	void * start = ROUNDDOWN((void *)va,PGSIZE);
f010155a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010155d:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0101560:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101565:	89 45 d8             	mov    %eax,-0x28(%ebp)
	void * end	 = ROUNDUP((void *)(va+len),PGSIZE);
f0101568:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010156b:	03 45 10             	add    0x10(%ebp),%eax
f010156e:	05 ff 0f 00 00       	add    $0xfff,%eax
f0101573:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101578:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010157b:	8b 5d d8             	mov    -0x28(%ebp),%ebx

	while(start<end)
	{
		if((uint32_t)start >= ULIM) {goto err;}
		pte_t * p = pgdir_walk(env->env_pgdir,start,0);
		if( !p || !(*p & (perm|PTE_P))) {goto err;}
f010157e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101581:	83 c8 01             	or     $0x1,%eax
f0101584:	89 45 e0             	mov    %eax,-0x20(%ebp)
{
	// LAB 3: Your code here.
	void * start = ROUNDDOWN((void *)va,PGSIZE);
	void * end	 = ROUNDUP((void *)(va+len),PGSIZE);

	while(start<end)
f0101587:	eb 32                	jmp    f01015bb <user_mem_check+0x6d>
f0101589:	89 df                	mov    %ebx,%edi
	{
		if((uint32_t)start >= ULIM) {goto err;}
f010158b:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0101591:	77 34                	ja     f01015c7 <user_mem_check+0x79>
		pte_t * p = pgdir_walk(env->env_pgdir,start,0);
f0101593:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010159a:	00 
f010159b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010159f:	8b 46 60             	mov    0x60(%esi),%eax
f01015a2:	89 04 24             	mov    %eax,(%esp)
f01015a5:	e8 fe fe ff ff       	call   f01014a8 <pgdir_walk>
		if( !p || !(*p & (perm|PTE_P))) {goto err;}
f01015aa:	85 c0                	test   %eax,%eax
f01015ac:	74 19                	je     f01015c7 <user_mem_check+0x79>
f01015ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01015b1:	85 10                	test   %edx,(%eax)
f01015b3:	74 12                	je     f01015c7 <user_mem_check+0x79>
		start+=PGSIZE;
f01015b5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
{
	// LAB 3: Your code here.
	void * start = ROUNDDOWN((void *)va,PGSIZE);
	void * end	 = ROUNDUP((void *)(va+len),PGSIZE);

	while(start<end)
f01015bb:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01015be:	72 c9                	jb     f0101589 <user_mem_check+0x3b>
f01015c0:	b8 00 00 00 00       	mov    $0x0,%eax
f01015c5:	eb 1f                	jmp    f01015e6 <user_mem_check+0x98>
		if( !p || !(*p & (perm|PTE_P))) {goto err;}
		start+=PGSIZE;
	}
	return 0;
err:
	if(start==ROUNDDOWN((void *)va,PGSIZE)) user_mem_check_addr = (uint32_t)va;	
f01015c7:	3b 5d d8             	cmp    -0x28(%ebp),%ebx
f01015ca:	75 0f                	jne    f01015db <user_mem_check+0x8d>
f01015cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01015cf:	a3 34 12 27 f0       	mov    %eax,0xf0271234
f01015d4:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01015d9:	eb 0b                	jmp    f01015e6 <user_mem_check+0x98>
	else user_mem_check_addr = (uint32_t)start;
f01015db:	89 3d 34 12 27 f0    	mov    %edi,0xf0271234
f01015e1:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
	return -E_FAULT;
}
f01015e6:	83 c4 2c             	add    $0x2c,%esp
f01015e9:	5b                   	pop    %ebx
f01015ea:	5e                   	pop    %esi
f01015eb:	5f                   	pop    %edi
f01015ec:	5d                   	pop    %ebp
f01015ed:	c3                   	ret    

f01015ee <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f01015ee:	55                   	push   %ebp
f01015ef:	89 e5                	mov    %esp,%ebp
f01015f1:	53                   	push   %ebx
f01015f2:	83 ec 14             	sub    $0x14,%esp
f01015f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f01015f8:	8b 45 14             	mov    0x14(%ebp),%eax
f01015fb:	83 c8 04             	or     $0x4,%eax
f01015fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101602:	8b 45 10             	mov    0x10(%ebp),%eax
f0101605:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101609:	8b 45 0c             	mov    0xc(%ebp),%eax
f010160c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101610:	89 1c 24             	mov    %ebx,(%esp)
f0101613:	e8 36 ff ff ff       	call   f010154e <user_mem_check>
f0101618:	85 c0                	test   %eax,%eax
f010161a:	79 24                	jns    f0101640 <user_mem_assert+0x52>
		cprintf("[%08x] user_mem_check assertion failure for "
f010161c:	a1 34 12 27 f0       	mov    0xf0271234,%eax
f0101621:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101625:	8b 43 48             	mov    0x48(%ebx),%eax
f0101628:	89 44 24 04          	mov    %eax,0x4(%esp)
f010162c:	c7 04 24 f0 85 10 f0 	movl   $0xf01085f0,(%esp)
f0101633:	e8 c7 2f 00 00       	call   f01045ff <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0101638:	89 1c 24             	mov    %ebx,(%esp)
f010163b:	e8 05 29 00 00       	call   f0103f45 <env_destroy>
	}
}
f0101640:	83 c4 14             	add    $0x14,%esp
f0101643:	5b                   	pop    %ebx
f0101644:	5d                   	pop    %ebp
f0101645:	c3                   	ret    

f0101646 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f0101646:	55                   	push   %ebp
f0101647:	89 e5                	mov    %esp,%ebp
f0101649:	57                   	push   %edi
f010164a:	56                   	push   %esi
f010164b:	53                   	push   %ebx
f010164c:	83 ec 2c             	sub    $0x2c,%esp
f010164f:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101652:	89 d3                	mov    %edx,%ebx
f0101654:	8b 7d 08             	mov    0x8(%ebp),%edi
	// Fill this function in
	size_t i,t=size/PGSIZE;		pte_t *p;
f0101657:	c1 e9 0c             	shr    $0xc,%ecx
f010165a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f010165d:	be 00 00 00 00       	mov    $0x0,%esi
	for(i=0;i<t;i++)
	{
		 p = pgdir_walk(pgdir,(void *)va,1);
		*p = pa | perm | PTE_P;
f0101662:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101665:	83 c8 01             	or     $0x1,%eax
f0101668:	89 45 dc             	mov    %eax,-0x24(%ebp)
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	// Fill this function in
	size_t i,t=size/PGSIZE;		pte_t *p;
	for(i=0;i<t;i++)
f010166b:	eb 2d                	jmp    f010169a <boot_map_region+0x54>
	{
		 p = pgdir_walk(pgdir,(void *)va,1);
f010166d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0101674:	00 
f0101675:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101679:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010167c:	89 04 24             	mov    %eax,(%esp)
f010167f:	e8 24 fe ff ff       	call   f01014a8 <pgdir_walk>
		*p = pa | perm | PTE_P;
f0101684:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101687:	09 fa                	or     %edi,%edx
f0101689:	89 10                	mov    %edx,(%eax)
		va+=PGSIZE; pa+=PGSIZE;
f010168b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101691:	81 c7 00 10 00 00    	add    $0x1000,%edi
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	// Fill this function in
	size_t i,t=size/PGSIZE;		pte_t *p;
	for(i=0;i<t;i++)
f0101697:	83 c6 01             	add    $0x1,%esi
f010169a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f010169d:	72 ce                	jb     f010166d <boot_map_region+0x27>
	{
		 p = pgdir_walk(pgdir,(void *)va,1);
		*p = pa | perm | PTE_P;
		va+=PGSIZE; pa+=PGSIZE;
	}
}
f010169f:	83 c4 2c             	add    $0x2c,%esp
f01016a2:	5b                   	pop    %ebx
f01016a3:	5e                   	pop    %esi
f01016a4:	5f                   	pop    %edi
f01016a5:	5d                   	pop    %ebp
f01016a6:	c3                   	ret    

f01016a7 <mmio_map_region>:
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
//
void *
mmio_map_region(physaddr_t pa, size_t size)
{
f01016a7:	55                   	push   %ebp
f01016a8:	89 e5                	mov    %esp,%ebp
f01016aa:	53                   	push   %ebx
f01016ab:	83 ec 14             	sub    $0x14,%esp
f01016ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// okay to simply panic if this happens).
	//
	// Hint: The staff solution uses boot_map_region.
	//
	// Your code here:
	uintptr_t align_start = ROUNDDOWN(pa,PGSIZE);
f01016b1:	89 c8                	mov    %ecx,%eax
f01016b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	uintptr_t align_end = ROUNDUP(pa+size,PGSIZE);
f01016b8:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f01016be:	03 4d 0c             	add    0xc(%ebp),%ecx
f01016c1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx

	uintptr_t curr_base = base;
f01016c7:	8b 1d 00 53 12 f0    	mov    0xf0125300,%ebx
	if(base+align_end-align_start > MMIOLIM)
f01016cd:	89 da                	mov    %ebx,%edx
f01016cf:	29 c2                	sub    %eax,%edx
f01016d1:	01 ca                	add    %ecx,%edx
f01016d3:	81 fa 00 00 c0 ef    	cmp    $0xefc00000,%edx
f01016d9:	76 1c                	jbe    f01016f7 <mmio_map_region+0x50>
		panic("mmio area overflow\n");
f01016db:	c7 44 24 08 d1 8e 10 	movl   $0xf0108ed1,0x8(%esp)
f01016e2:	f0 
f01016e3:	c7 44 24 04 ca 02 00 	movl   $0x2ca,0x4(%esp)
f01016ea:	00 
f01016eb:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01016f2:	e8 8e e9 ff ff       	call   f0100085 <_panic>
	base+=align_end-align_start;
f01016f7:	29 c1                	sub    %eax,%ecx
f01016f9:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f01016fc:	89 15 00 53 12 f0    	mov    %edx,0xf0125300
		
	boot_map_region(kern_pgdir,curr_base,align_end-align_start,(physaddr_t)align_start,PTE_PCD|PTE_PWT|PTE_W);
f0101702:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
f0101709:	00 
f010170a:	89 04 24             	mov    %eax,(%esp)
f010170d:	89 da                	mov    %ebx,%edx
f010170f:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0101714:	e8 2d ff ff ff       	call   f0101646 <boot_map_region>
	//cprintf("map va %x pa %x(%x) len %u\n",curr_base,align_start,pa,align_end-align_start);
	return (void *) curr_base;
}
f0101719:	89 d8                	mov    %ebx,%eax
f010171b:	83 c4 14             	add    $0x14,%esp
f010171e:	5b                   	pop    %ebx
f010171f:	5d                   	pop    %ebp
f0101720:	c3                   	ret    

f0101721 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f0101721:	55                   	push   %ebp
f0101722:	89 e5                	mov    %esp,%ebp
f0101724:	53                   	push   %ebx
f0101725:	83 ec 14             	sub    $0x14,%esp
f0101728:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// Fill this function in
	pte_t * p = pgdir_walk(pgdir,va,0);
f010172b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101732:	00 
f0101733:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101736:	89 44 24 04          	mov    %eax,0x4(%esp)
f010173a:	8b 45 08             	mov    0x8(%ebp),%eax
f010173d:	89 04 24             	mov    %eax,(%esp)
f0101740:	e8 63 fd ff ff       	call   f01014a8 <pgdir_walk>
	if(pte_store) *pte_store = p;
f0101745:	85 db                	test   %ebx,%ebx
f0101747:	74 02                	je     f010174b <page_lookup+0x2a>
f0101749:	89 03                	mov    %eax,(%ebx)
	if(p && *p & PTE_P) 
f010174b:	85 c0                	test   %eax,%eax
f010174d:	74 38                	je     f0101787 <page_lookup+0x66>
f010174f:	8b 00                	mov    (%eax),%eax
f0101751:	a8 01                	test   $0x1,%al
f0101753:	74 32                	je     f0101787 <page_lookup+0x66>
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101755:	c1 e8 0c             	shr    $0xc,%eax
f0101758:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f010175e:	72 1c                	jb     f010177c <page_lookup+0x5b>
		panic("pa2page called with invalid pa");
f0101760:	c7 44 24 08 28 86 10 	movl   $0xf0108628,0x8(%esp)
f0101767:	f0 
f0101768:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f010176f:	00 
f0101770:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0101777:	e8 09 e9 ff ff       	call   f0100085 <_panic>
	return &pages[PGNUM(pa)];
f010177c:	c1 e0 03             	shl    $0x3,%eax
f010177f:	03 05 ac 1e 27 f0    	add    0xf0271eac,%eax
	{ return pa2page(PTE_ADDR(*p));} 
f0101785:	eb 05                	jmp    f010178c <page_lookup+0x6b>
f0101787:	b8 00 00 00 00       	mov    $0x0,%eax
	return NULL;
}
f010178c:	83 c4 14             	add    $0x14,%esp
f010178f:	5b                   	pop    %ebx
f0101790:	5d                   	pop    %ebp
f0101791:	c3                   	ret    

f0101792 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0101792:	55                   	push   %ebp
f0101793:	89 e5                	mov    %esp,%ebp
f0101795:	83 ec 38             	sub    $0x38,%esp
f0101798:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f010179b:	89 75 f8             	mov    %esi,-0x8(%ebp)
f010179e:	89 7d fc             	mov    %edi,-0x4(%ebp)
f01017a1:	8b 7d 08             	mov    0x8(%ebp),%edi
f01017a4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// Fill this function in
	pte_t * pte_store;	struct PageInfo *pp;
	
	pp = page_lookup(pgdir,va,&pte_store);
f01017a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01017aa:	89 44 24 08          	mov    %eax,0x8(%esp)
f01017ae:	89 74 24 04          	mov    %esi,0x4(%esp)
f01017b2:	89 3c 24             	mov    %edi,(%esp)
f01017b5:	e8 67 ff ff ff       	call   f0101721 <page_lookup>
f01017ba:	89 c3                	mov    %eax,%ebx
	if(pp) 
f01017bc:	85 c0                	test   %eax,%eax
f01017be:	74 1d                	je     f01017dd <page_remove+0x4b>
	{
		tlb_invalidate(pgdir,va);
f01017c0:	89 74 24 04          	mov    %esi,0x4(%esp)
f01017c4:	89 3c 24             	mov    %edi,(%esp)
f01017c7:	e8 8b f6 ff ff       	call   f0100e57 <tlb_invalidate>
		*pte_store = 0;	page_decref(pp);	
f01017cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01017cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01017d5:	89 1c 24             	mov    %ebx,(%esp)
f01017d8:	e8 fa f5 ff ff       	call   f0100dd7 <page_decref>
	} 		
}
f01017dd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f01017e0:	8b 75 f8             	mov    -0x8(%ebp),%esi
f01017e3:	8b 7d fc             	mov    -0x4(%ebp),%edi
f01017e6:	89 ec                	mov    %ebp,%esp
f01017e8:	5d                   	pop    %ebp
f01017e9:	c3                   	ret    

f01017ea <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f01017ea:	55                   	push   %ebp
f01017eb:	89 e5                	mov    %esp,%ebp
f01017ed:	83 ec 28             	sub    $0x28,%esp
f01017f0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f01017f3:	89 75 f8             	mov    %esi,-0x8(%ebp)
f01017f6:	89 7d fc             	mov    %edi,-0x4(%ebp)
f01017f9:	8b 75 0c             	mov    0xc(%ebp),%esi
f01017fc:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Fill this function in
	struct PageInfo *pp1;
	pte_t *p = pgdir_walk(pgdir,va,1);
f01017ff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0101806:	00 
f0101807:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010180b:	8b 45 08             	mov    0x8(%ebp),%eax
f010180e:	89 04 24             	mov    %eax,(%esp)
f0101811:	e8 92 fc ff ff       	call   f01014a8 <pgdir_walk>
f0101816:	89 c3                	mov    %eax,%ebx
	if(!p)	return -E_NO_MEM;
f0101818:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010181d:	85 db                	test   %ebx,%ebx
f010181f:	0f 84 9b 00 00 00    	je     f01018c0 <page_insert+0xd6>
	
	if(*p & PTE_P)
f0101825:	8b 03                	mov    (%ebx),%eax
f0101827:	a8 01                	test   $0x1,%al
f0101829:	74 73                	je     f010189e <page_insert+0xb4>
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010182b:	c1 e8 0c             	shr    $0xc,%eax
f010182e:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f0101834:	72 1c                	jb     f0101852 <page_insert+0x68>
		panic("pa2page called with invalid pa");
f0101836:	c7 44 24 08 28 86 10 	movl   $0xf0108628,0x8(%esp)
f010183d:	f0 
f010183e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0101845:	00 
f0101846:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f010184d:	e8 33 e8 ff ff       	call   f0100085 <_panic>
	return &pages[PGNUM(pa)];
f0101852:	c1 e0 03             	shl    $0x3,%eax
f0101855:	03 05 ac 1e 27 f0    	add    0xf0271eac,%eax
	{
		pp1 = pa2page(PTE_ADDR(*p));
		if(pp1!=pp){page_remove(pgdir,va);}
f010185b:	39 c6                	cmp    %eax,%esi
f010185d:	74 11                	je     f0101870 <page_insert+0x86>
f010185f:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101863:	8b 45 08             	mov    0x8(%ebp),%eax
f0101866:	89 04 24             	mov    %eax,(%esp)
f0101869:	e8 24 ff ff ff       	call   f0101792 <page_remove>
f010186e:	eb 2e                	jmp    f010189e <page_insert+0xb4>
		else if(pp->pp_ref){pp->pp_ref--;}
f0101870:	0f b7 46 04          	movzwl 0x4(%esi),%eax
f0101874:	66 85 c0             	test   %ax,%ax
f0101877:	74 09                	je     f0101882 <page_insert+0x98>
f0101879:	83 e8 01             	sub    $0x1,%eax
f010187c:	66 89 46 04          	mov    %ax,0x4(%esi)
f0101880:	eb 1c                	jmp    f010189e <page_insert+0xb4>
		else {panic("page is referred but ref count is 0");}
f0101882:	c7 44 24 08 48 86 10 	movl   $0xf0108648,0x8(%esp)
f0101889:	f0 
f010188a:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
f0101891:	00 
f0101892:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101899:	e8 e7 e7 ff ff       	call   f0100085 <_panic>
	}
	*p = page2pa(pp) | perm | PTE_P; pp->pp_ref++; 
f010189e:	8b 45 14             	mov    0x14(%ebp),%eax
f01018a1:	83 c8 01             	or     $0x1,%eax
f01018a4:	89 f2                	mov    %esi,%edx
f01018a6:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f01018ac:	c1 fa 03             	sar    $0x3,%edx
f01018af:	c1 e2 0c             	shl    $0xc,%edx
f01018b2:	09 d0                	or     %edx,%eax
f01018b4:	89 03                	mov    %eax,(%ebx)
f01018b6:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
f01018bb:	b8 00 00 00 00       	mov    $0x0,%eax
	
	return 0; 
}
f01018c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f01018c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
f01018c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
f01018c9:	89 ec                	mov    %ebp,%esp
f01018cb:	5d                   	pop    %ebp
f01018cc:	c3                   	ret    

f01018cd <check_page_installed_pgdir>:
}

// check page_insert, page_remove, &c, with an installed kern_pgdir
static void
check_page_installed_pgdir(void)
{
f01018cd:	55                   	push   %ebp
f01018ce:	89 e5                	mov    %esp,%ebp
f01018d0:	57                   	push   %edi
f01018d1:	56                   	push   %esi
f01018d2:	53                   	push   %ebx
f01018d3:	83 ec 2c             	sub    $0x2c,%esp
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01018d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01018dd:	e8 10 fb ff ff       	call   f01013f2 <page_alloc>
f01018e2:	89 c3                	mov    %eax,%ebx
f01018e4:	85 c0                	test   %eax,%eax
f01018e6:	75 24                	jne    f010190c <check_page_installed_pgdir+0x3f>
f01018e8:	c7 44 24 0c e5 8e 10 	movl   $0xf0108ee5,0xc(%esp)
f01018ef:	f0 
f01018f0:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01018f7:	f0 
f01018f8:	c7 44 24 04 ac 04 00 	movl   $0x4ac,0x4(%esp)
f01018ff:	00 
f0101900:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101907:	e8 79 e7 ff ff       	call   f0100085 <_panic>
	assert((pp1 = page_alloc(0)));
f010190c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101913:	e8 da fa ff ff       	call   f01013f2 <page_alloc>
f0101918:	89 c7                	mov    %eax,%edi
f010191a:	85 c0                	test   %eax,%eax
f010191c:	75 24                	jne    f0101942 <check_page_installed_pgdir+0x75>
f010191e:	c7 44 24 0c fb 8e 10 	movl   $0xf0108efb,0xc(%esp)
f0101925:	f0 
f0101926:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010192d:	f0 
f010192e:	c7 44 24 04 ad 04 00 	movl   $0x4ad,0x4(%esp)
f0101935:	00 
f0101936:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010193d:	e8 43 e7 ff ff       	call   f0100085 <_panic>
	assert((pp2 = page_alloc(0)));
f0101942:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101949:	e8 a4 fa ff ff       	call   f01013f2 <page_alloc>
f010194e:	89 c6                	mov    %eax,%esi
f0101950:	85 c0                	test   %eax,%eax
f0101952:	75 24                	jne    f0101978 <check_page_installed_pgdir+0xab>
f0101954:	c7 44 24 0c 11 8f 10 	movl   $0xf0108f11,0xc(%esp)
f010195b:	f0 
f010195c:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101963:	f0 
f0101964:	c7 44 24 04 ae 04 00 	movl   $0x4ae,0x4(%esp)
f010196b:	00 
f010196c:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101973:	e8 0d e7 ff ff       	call   f0100085 <_panic>
	page_free(pp0);
f0101978:	89 1c 24             	mov    %ebx,(%esp)
f010197b:	e8 17 f4 ff ff       	call   f0100d97 <page_free>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101980:	89 f8                	mov    %edi,%eax
f0101982:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f0101988:	c1 f8 03             	sar    $0x3,%eax
f010198b:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010198e:	89 c2                	mov    %eax,%edx
f0101990:	c1 ea 0c             	shr    $0xc,%edx
f0101993:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0101999:	72 20                	jb     f01019bb <check_page_installed_pgdir+0xee>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010199b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010199f:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f01019a6:	f0 
f01019a7:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f01019ae:	00 
f01019af:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f01019b6:	e8 ca e6 ff ff       	call   f0100085 <_panic>
	memset(page2kva(pp1), 1, PGSIZE);
f01019bb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01019c2:	00 
f01019c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f01019ca:	00 
f01019cb:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01019d0:	89 04 24             	mov    %eax,(%esp)
f01019d3:	e8 b8 49 00 00       	call   f0106390 <memset>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01019d8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f01019db:	89 f0                	mov    %esi,%eax
f01019dd:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f01019e3:	c1 f8 03             	sar    $0x3,%eax
f01019e6:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01019e9:	89 c2                	mov    %eax,%edx
f01019eb:	c1 ea 0c             	shr    $0xc,%edx
f01019ee:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f01019f4:	72 20                	jb     f0101a16 <check_page_installed_pgdir+0x149>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01019f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01019fa:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0101a01:	f0 
f0101a02:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101a09:	00 
f0101a0a:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0101a11:	e8 6f e6 ff ff       	call   f0100085 <_panic>
	memset(page2kva(pp2), 2, PGSIZE);
f0101a16:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101a1d:	00 
f0101a1e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f0101a25:	00 
f0101a26:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a2b:	89 04 24             	mov    %eax,(%esp)
f0101a2e:	e8 5d 49 00 00       	call   f0106390 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0101a33:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0101a3a:	00 
f0101a3b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101a42:	00 
f0101a43:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101a47:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0101a4c:	89 04 24             	mov    %eax,(%esp)
f0101a4f:	e8 96 fd ff ff       	call   f01017ea <page_insert>
	assert(pp1->pp_ref == 1);
f0101a54:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101a59:	74 24                	je     f0101a7f <check_page_installed_pgdir+0x1b2>
f0101a5b:	c7 44 24 0c 27 8f 10 	movl   $0xf0108f27,0xc(%esp)
f0101a62:	f0 
f0101a63:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101a6a:	f0 
f0101a6b:	c7 44 24 04 b3 04 00 	movl   $0x4b3,0x4(%esp)
f0101a72:	00 
f0101a73:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101a7a:	e8 06 e6 ff ff       	call   f0100085 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0101a7f:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0101a86:	01 01 01 
f0101a89:	74 24                	je     f0101aaf <check_page_installed_pgdir+0x1e2>
f0101a8b:	c7 44 24 0c 6c 86 10 	movl   $0xf010866c,0xc(%esp)
f0101a92:	f0 
f0101a93:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101a9a:	f0 
f0101a9b:	c7 44 24 04 b4 04 00 	movl   $0x4b4,0x4(%esp)
f0101aa2:	00 
f0101aa3:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101aaa:	e8 d6 e5 ff ff       	call   f0100085 <_panic>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0101aaf:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0101ab6:	00 
f0101ab7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101abe:	00 
f0101abf:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101ac3:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0101ac8:	89 04 24             	mov    %eax,(%esp)
f0101acb:	e8 1a fd ff ff       	call   f01017ea <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0101ad0:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0101ad7:	02 02 02 
f0101ada:	74 24                	je     f0101b00 <check_page_installed_pgdir+0x233>
f0101adc:	c7 44 24 0c 90 86 10 	movl   $0xf0108690,0xc(%esp)
f0101ae3:	f0 
f0101ae4:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101aeb:	f0 
f0101aec:	c7 44 24 04 b6 04 00 	movl   $0x4b6,0x4(%esp)
f0101af3:	00 
f0101af4:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101afb:	e8 85 e5 ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 1);
f0101b00:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101b05:	74 24                	je     f0101b2b <check_page_installed_pgdir+0x25e>
f0101b07:	c7 44 24 0c 38 8f 10 	movl   $0xf0108f38,0xc(%esp)
f0101b0e:	f0 
f0101b0f:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101b16:	f0 
f0101b17:	c7 44 24 04 b7 04 00 	movl   $0x4b7,0x4(%esp)
f0101b1e:	00 
f0101b1f:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101b26:	e8 5a e5 ff ff       	call   f0100085 <_panic>
	assert(pp1->pp_ref == 0);
f0101b2b:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101b30:	74 24                	je     f0101b56 <check_page_installed_pgdir+0x289>
f0101b32:	c7 44 24 0c 49 8f 10 	movl   $0xf0108f49,0xc(%esp)
f0101b39:	f0 
f0101b3a:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101b41:	f0 
f0101b42:	c7 44 24 04 b8 04 00 	movl   $0x4b8,0x4(%esp)
f0101b49:	00 
f0101b4a:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101b51:	e8 2f e5 ff ff       	call   f0100085 <_panic>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0101b56:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0101b5d:	03 03 03 
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101b60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101b63:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f0101b69:	c1 f8 03             	sar    $0x3,%eax
f0101b6c:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101b6f:	89 c2                	mov    %eax,%edx
f0101b71:	c1 ea 0c             	shr    $0xc,%edx
f0101b74:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0101b7a:	72 20                	jb     f0101b9c <check_page_installed_pgdir+0x2cf>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101b7c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101b80:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0101b87:	f0 
f0101b88:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101b8f:	00 
f0101b90:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0101b97:	e8 e9 e4 ff ff       	call   f0100085 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0101b9c:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0101ba3:	03 03 03 
f0101ba6:	74 24                	je     f0101bcc <check_page_installed_pgdir+0x2ff>
f0101ba8:	c7 44 24 0c b4 86 10 	movl   $0xf01086b4,0xc(%esp)
f0101baf:	f0 
f0101bb0:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101bb7:	f0 
f0101bb8:	c7 44 24 04 ba 04 00 	movl   $0x4ba,0x4(%esp)
f0101bbf:	00 
f0101bc0:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101bc7:	e8 b9 e4 ff ff       	call   f0100085 <_panic>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101bcc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0101bd3:	00 
f0101bd4:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0101bd9:	89 04 24             	mov    %eax,(%esp)
f0101bdc:	e8 b1 fb ff ff       	call   f0101792 <page_remove>
	assert(pp2->pp_ref == 0);
f0101be1:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101be6:	74 24                	je     f0101c0c <check_page_installed_pgdir+0x33f>
f0101be8:	c7 44 24 0c 5a 8f 10 	movl   $0xf0108f5a,0xc(%esp)
f0101bef:	f0 
f0101bf0:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101bf7:	f0 
f0101bf8:	c7 44 24 04 bc 04 00 	movl   $0x4bc,0x4(%esp)
f0101bff:	00 
f0101c00:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101c07:	e8 79 e4 ff ff       	call   f0100085 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101c0c:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0101c11:	8b 08                	mov    (%eax),%ecx
f0101c13:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101c19:	89 da                	mov    %ebx,%edx
f0101c1b:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f0101c21:	c1 fa 03             	sar    $0x3,%edx
f0101c24:	c1 e2 0c             	shl    $0xc,%edx
f0101c27:	39 d1                	cmp    %edx,%ecx
f0101c29:	74 24                	je     f0101c4f <check_page_installed_pgdir+0x382>
f0101c2b:	c7 44 24 0c e0 86 10 	movl   $0xf01086e0,0xc(%esp)
f0101c32:	f0 
f0101c33:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101c3a:	f0 
f0101c3b:	c7 44 24 04 bf 04 00 	movl   $0x4bf,0x4(%esp)
f0101c42:	00 
f0101c43:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101c4a:	e8 36 e4 ff ff       	call   f0100085 <_panic>
	kern_pgdir[0] = 0;
f0101c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0101c55:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c5a:	74 24                	je     f0101c80 <check_page_installed_pgdir+0x3b3>
f0101c5c:	c7 44 24 0c 6b 8f 10 	movl   $0xf0108f6b,0xc(%esp)
f0101c63:	f0 
f0101c64:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101c6b:	f0 
f0101c6c:	c7 44 24 04 c1 04 00 	movl   $0x4c1,0x4(%esp)
f0101c73:	00 
f0101c74:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101c7b:	e8 05 e4 ff ff       	call   f0100085 <_panic>
	pp0->pp_ref = 0;
f0101c80:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);	
f0101c86:	89 1c 24             	mov    %ebx,(%esp)
f0101c89:	e8 09 f1 ff ff       	call   f0100d97 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0101c8e:	c7 04 24 08 87 10 f0 	movl   $0xf0108708,(%esp)
f0101c95:	e8 65 29 00 00       	call   f01045ff <cprintf>
}
f0101c9a:	83 c4 2c             	add    $0x2c,%esp
f0101c9d:	5b                   	pop    %ebx
f0101c9e:	5e                   	pop    %esi
f0101c9f:	5f                   	pop    %edi
f0101ca0:	5d                   	pop    %ebp
f0101ca1:	c3                   	ret    

f0101ca2 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0101ca2:	55                   	push   %ebp
f0101ca3:	89 e5                	mov    %esp,%ebp
f0101ca5:	57                   	push   %edi
f0101ca6:	56                   	push   %esi
f0101ca7:	53                   	push   %ebx
f0101ca8:	83 ec 3c             	sub    $0x3c,%esp
	uint32_t cr0;
	size_t i,n;

	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();
f0101cab:	e8 0e f2 ff ff       	call   f0100ebe <i386_detect_memory>
	// Remove this line when you're ready to test this function.
	//panic("mem_init: This function is not finished\n");

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101cb0:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101cb5:	e8 40 f1 ff ff       	call   f0100dfa <boot_alloc>
f0101cba:	a3 a8 1e 27 f0       	mov    %eax,0xf0271ea8
	memset(kern_pgdir, 0, PGSIZE);
f0101cbf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101cc6:	00 
f0101cc7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101cce:	00 
f0101ccf:	89 04 24             	mov    %eax,(%esp)
f0101cd2:	e8 b9 46 00 00       	call   f0106390 <memset>
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101cd7:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101cdc:	89 c2                	mov    %eax,%edx
f0101cde:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101ce3:	77 20                	ja     f0101d05 <mem_init+0x63>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101ce5:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101ce9:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0101cf0:	f0 
f0101cf1:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
f0101cf8:	00 
f0101cf9:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101d00:	e8 80 e3 ff ff       	call   f0100085 <_panic>
f0101d05:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0101d0b:	83 ca 05             	or     $0x5,%edx
f0101d0e:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// The kernel uses this array to keep track of physical pages: for
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
	n = ROUNDUP(sizeof(struct PageInfo)*npages,PGSIZE);
f0101d14:	a1 a4 1e 27 f0       	mov    0xf0271ea4,%eax
f0101d19:	8d 1c c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%ebx
f0101d20:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	pages = (struct PageInfo *) boot_alloc(n);
f0101d26:	89 d8                	mov    %ebx,%eax
f0101d28:	e8 cd f0 ff ff       	call   f0100dfa <boot_alloc>
f0101d2d:	a3 ac 1e 27 f0       	mov    %eax,0xf0271eac
	memset(pages, 0, n);
f0101d32:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0101d36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101d3d:	00 
f0101d3e:	89 04 24             	mov    %eax,(%esp)
f0101d41:	e8 4a 46 00 00       	call   f0106390 <memset>

	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
	n = ROUNDUP(sizeof(struct Env)*NENV,PGSIZE);
	envs = (struct Env *) boot_alloc(n);
f0101d46:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101d4b:	e8 aa f0 ff ff       	call   f0100dfa <boot_alloc>
f0101d50:	a3 38 12 27 f0       	mov    %eax,0xf0271238
	memset(envs, 0, n);	
f0101d55:	c7 44 24 08 00 f0 01 	movl   $0x1f000,0x8(%esp)
f0101d5c:	00 
f0101d5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101d64:	00 
f0101d65:	89 04 24             	mov    %eax,(%esp)
f0101d68:	e8 23 46 00 00       	call   f0106390 <memset>
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f0101d6d:	e8 27 f2 ff ff       	call   f0100f99 <page_init>

	check_page_free_list(1);
f0101d72:	b8 01 00 00 00       	mov    $0x1,%eax
f0101d77:	e8 11 f3 ff ff       	call   f010108d <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f0101d7c:	83 3d ac 1e 27 f0 00 	cmpl   $0x0,0xf0271eac
f0101d83:	75 1c                	jne    f0101da1 <mem_init+0xff>
		panic("'pages' is a null pointer!");
f0101d85:	c7 44 24 08 7c 8f 10 	movl   $0xf0108f7c,0x8(%esp)
f0101d8c:	f0 
f0101d8d:	c7 44 24 04 5d 03 00 	movl   $0x35d,0x4(%esp)
f0101d94:	00 
f0101d95:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101d9c:	e8 e4 e2 ff ff       	call   f0100085 <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101da1:	a1 30 12 27 f0       	mov    0xf0271230,%eax
f0101da6:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101dab:	eb 05                	jmp    f0101db2 <mem_init+0x110>
		++nfree;
f0101dad:	83 c3 01             	add    $0x1,%ebx

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101db0:	8b 00                	mov    (%eax),%eax
f0101db2:	85 c0                	test   %eax,%eax
f0101db4:	75 f7                	jne    f0101dad <mem_init+0x10b>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101db6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101dbd:	e8 30 f6 ff ff       	call   f01013f2 <page_alloc>
f0101dc2:	89 c6                	mov    %eax,%esi
f0101dc4:	85 c0                	test   %eax,%eax
f0101dc6:	75 24                	jne    f0101dec <mem_init+0x14a>
f0101dc8:	c7 44 24 0c e5 8e 10 	movl   $0xf0108ee5,0xc(%esp)
f0101dcf:	f0 
f0101dd0:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101dd7:	f0 
f0101dd8:	c7 44 24 04 65 03 00 	movl   $0x365,0x4(%esp)
f0101ddf:	00 
f0101de0:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101de7:	e8 99 e2 ff ff       	call   f0100085 <_panic>
	assert((pp1 = page_alloc(0)));
f0101dec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101df3:	e8 fa f5 ff ff       	call   f01013f2 <page_alloc>
f0101df8:	89 c7                	mov    %eax,%edi
f0101dfa:	85 c0                	test   %eax,%eax
f0101dfc:	75 24                	jne    f0101e22 <mem_init+0x180>
f0101dfe:	c7 44 24 0c fb 8e 10 	movl   $0xf0108efb,0xc(%esp)
f0101e05:	f0 
f0101e06:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101e0d:	f0 
f0101e0e:	c7 44 24 04 66 03 00 	movl   $0x366,0x4(%esp)
f0101e15:	00 
f0101e16:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101e1d:	e8 63 e2 ff ff       	call   f0100085 <_panic>
	assert((pp2 = page_alloc(0)));
f0101e22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e29:	e8 c4 f5 ff ff       	call   f01013f2 <page_alloc>
f0101e2e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101e31:	85 c0                	test   %eax,%eax
f0101e33:	75 24                	jne    f0101e59 <mem_init+0x1b7>
f0101e35:	c7 44 24 0c 11 8f 10 	movl   $0xf0108f11,0xc(%esp)
f0101e3c:	f0 
f0101e3d:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101e44:	f0 
f0101e45:	c7 44 24 04 67 03 00 	movl   $0x367,0x4(%esp)
f0101e4c:	00 
f0101e4d:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101e54:	e8 2c e2 ff ff       	call   f0100085 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101e59:	39 fe                	cmp    %edi,%esi
f0101e5b:	75 24                	jne    f0101e81 <mem_init+0x1df>
f0101e5d:	c7 44 24 0c 97 8f 10 	movl   $0xf0108f97,0xc(%esp)
f0101e64:	f0 
f0101e65:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101e6c:	f0 
f0101e6d:	c7 44 24 04 6a 03 00 	movl   $0x36a,0x4(%esp)
f0101e74:	00 
f0101e75:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101e7c:	e8 04 e2 ff ff       	call   f0100085 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101e81:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
f0101e84:	74 05                	je     f0101e8b <mem_init+0x1e9>
f0101e86:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
f0101e89:	75 24                	jne    f0101eaf <mem_init+0x20d>
f0101e8b:	c7 44 24 0c 34 87 10 	movl   $0xf0108734,0xc(%esp)
f0101e92:	f0 
f0101e93:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101e9a:	f0 
f0101e9b:	c7 44 24 04 6b 03 00 	movl   $0x36b,0x4(%esp)
f0101ea2:	00 
f0101ea3:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101eaa:	e8 d6 e1 ff ff       	call   f0100085 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101eaf:	8b 15 ac 1e 27 f0    	mov    0xf0271eac,%edx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101eb5:	a1 a4 1e 27 f0       	mov    0xf0271ea4,%eax
f0101eba:	c1 e0 0c             	shl    $0xc,%eax
f0101ebd:	89 f1                	mov    %esi,%ecx
f0101ebf:	29 d1                	sub    %edx,%ecx
f0101ec1:	c1 f9 03             	sar    $0x3,%ecx
f0101ec4:	c1 e1 0c             	shl    $0xc,%ecx
f0101ec7:	39 c1                	cmp    %eax,%ecx
f0101ec9:	72 24                	jb     f0101eef <mem_init+0x24d>
f0101ecb:	c7 44 24 0c a9 8f 10 	movl   $0xf0108fa9,0xc(%esp)
f0101ed2:	f0 
f0101ed3:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101eda:	f0 
f0101edb:	c7 44 24 04 6c 03 00 	movl   $0x36c,0x4(%esp)
f0101ee2:	00 
f0101ee3:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101eea:	e8 96 e1 ff ff       	call   f0100085 <_panic>
f0101eef:	89 f9                	mov    %edi,%ecx
f0101ef1:	29 d1                	sub    %edx,%ecx
f0101ef3:	c1 f9 03             	sar    $0x3,%ecx
f0101ef6:	c1 e1 0c             	shl    $0xc,%ecx
	assert(page2pa(pp1) < npages*PGSIZE);
f0101ef9:	39 c8                	cmp    %ecx,%eax
f0101efb:	77 24                	ja     f0101f21 <mem_init+0x27f>
f0101efd:	c7 44 24 0c c6 8f 10 	movl   $0xf0108fc6,0xc(%esp)
f0101f04:	f0 
f0101f05:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101f0c:	f0 
f0101f0d:	c7 44 24 04 6d 03 00 	movl   $0x36d,0x4(%esp)
f0101f14:	00 
f0101f15:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101f1c:	e8 64 e1 ff ff       	call   f0100085 <_panic>
f0101f21:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101f24:	29 d1                	sub    %edx,%ecx
f0101f26:	89 ca                	mov    %ecx,%edx
f0101f28:	c1 fa 03             	sar    $0x3,%edx
f0101f2b:	c1 e2 0c             	shl    $0xc,%edx
	assert(page2pa(pp2) < npages*PGSIZE);
f0101f2e:	39 d0                	cmp    %edx,%eax
f0101f30:	77 24                	ja     f0101f56 <mem_init+0x2b4>
f0101f32:	c7 44 24 0c e3 8f 10 	movl   $0xf0108fe3,0xc(%esp)
f0101f39:	f0 
f0101f3a:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101f41:	f0 
f0101f42:	c7 44 24 04 6e 03 00 	movl   $0x36e,0x4(%esp)
f0101f49:	00 
f0101f4a:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101f51:	e8 2f e1 ff ff       	call   f0100085 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101f56:	a1 30 12 27 f0       	mov    0xf0271230,%eax
f0101f5b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101f5e:	c7 05 30 12 27 f0 00 	movl   $0x0,0xf0271230
f0101f65:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101f68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101f6f:	e8 7e f4 ff ff       	call   f01013f2 <page_alloc>
f0101f74:	85 c0                	test   %eax,%eax
f0101f76:	74 24                	je     f0101f9c <mem_init+0x2fa>
f0101f78:	c7 44 24 0c 00 90 10 	movl   $0xf0109000,0xc(%esp)
f0101f7f:	f0 
f0101f80:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101f87:	f0 
f0101f88:	c7 44 24 04 75 03 00 	movl   $0x375,0x4(%esp)
f0101f8f:	00 
f0101f90:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101f97:	e8 e9 e0 ff ff       	call   f0100085 <_panic>

	// free and re-allocate?
	page_free(pp0);
f0101f9c:	89 34 24             	mov    %esi,(%esp)
f0101f9f:	e8 f3 ed ff ff       	call   f0100d97 <page_free>
	page_free(pp1);
f0101fa4:	89 3c 24             	mov    %edi,(%esp)
f0101fa7:	e8 eb ed ff ff       	call   f0100d97 <page_free>
	page_free(pp2);
f0101fac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101faf:	89 14 24             	mov    %edx,(%esp)
f0101fb2:	e8 e0 ed ff ff       	call   f0100d97 <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101fb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101fbe:	e8 2f f4 ff ff       	call   f01013f2 <page_alloc>
f0101fc3:	89 c6                	mov    %eax,%esi
f0101fc5:	85 c0                	test   %eax,%eax
f0101fc7:	75 24                	jne    f0101fed <mem_init+0x34b>
f0101fc9:	c7 44 24 0c e5 8e 10 	movl   $0xf0108ee5,0xc(%esp)
f0101fd0:	f0 
f0101fd1:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0101fd8:	f0 
f0101fd9:	c7 44 24 04 7c 03 00 	movl   $0x37c,0x4(%esp)
f0101fe0:	00 
f0101fe1:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0101fe8:	e8 98 e0 ff ff       	call   f0100085 <_panic>
	assert((pp1 = page_alloc(0)));
f0101fed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ff4:	e8 f9 f3 ff ff       	call   f01013f2 <page_alloc>
f0101ff9:	89 c7                	mov    %eax,%edi
f0101ffb:	85 c0                	test   %eax,%eax
f0101ffd:	75 24                	jne    f0102023 <mem_init+0x381>
f0101fff:	c7 44 24 0c fb 8e 10 	movl   $0xf0108efb,0xc(%esp)
f0102006:	f0 
f0102007:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010200e:	f0 
f010200f:	c7 44 24 04 7d 03 00 	movl   $0x37d,0x4(%esp)
f0102016:	00 
f0102017:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010201e:	e8 62 e0 ff ff       	call   f0100085 <_panic>
	assert((pp2 = page_alloc(0)));
f0102023:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010202a:	e8 c3 f3 ff ff       	call   f01013f2 <page_alloc>
f010202f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102032:	85 c0                	test   %eax,%eax
f0102034:	75 24                	jne    f010205a <mem_init+0x3b8>
f0102036:	c7 44 24 0c 11 8f 10 	movl   $0xf0108f11,0xc(%esp)
f010203d:	f0 
f010203e:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102045:	f0 
f0102046:	c7 44 24 04 7e 03 00 	movl   $0x37e,0x4(%esp)
f010204d:	00 
f010204e:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102055:	e8 2b e0 ff ff       	call   f0100085 <_panic>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f010205a:	39 fe                	cmp    %edi,%esi
f010205c:	75 24                	jne    f0102082 <mem_init+0x3e0>
f010205e:	c7 44 24 0c 97 8f 10 	movl   $0xf0108f97,0xc(%esp)
f0102065:	f0 
f0102066:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010206d:	f0 
f010206e:	c7 44 24 04 80 03 00 	movl   $0x380,0x4(%esp)
f0102075:	00 
f0102076:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010207d:	e8 03 e0 ff ff       	call   f0100085 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102082:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
f0102085:	74 05                	je     f010208c <mem_init+0x3ea>
f0102087:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
f010208a:	75 24                	jne    f01020b0 <mem_init+0x40e>
f010208c:	c7 44 24 0c 34 87 10 	movl   $0xf0108734,0xc(%esp)
f0102093:	f0 
f0102094:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010209b:	f0 
f010209c:	c7 44 24 04 81 03 00 	movl   $0x381,0x4(%esp)
f01020a3:	00 
f01020a4:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01020ab:	e8 d5 df ff ff       	call   f0100085 <_panic>
	assert(!page_alloc(0));
f01020b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01020b7:	e8 36 f3 ff ff       	call   f01013f2 <page_alloc>
f01020bc:	85 c0                	test   %eax,%eax
f01020be:	74 24                	je     f01020e4 <mem_init+0x442>
f01020c0:	c7 44 24 0c 00 90 10 	movl   $0xf0109000,0xc(%esp)
f01020c7:	f0 
f01020c8:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01020cf:	f0 
f01020d0:	c7 44 24 04 82 03 00 	movl   $0x382,0x4(%esp)
f01020d7:	00 
f01020d8:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01020df:	e8 a1 df ff ff       	call   f0100085 <_panic>
f01020e4:	89 75 d0             	mov    %esi,-0x30(%ebp)
f01020e7:	89 f0                	mov    %esi,%eax
f01020e9:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f01020ef:	c1 f8 03             	sar    $0x3,%eax
f01020f2:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01020f5:	89 c2                	mov    %eax,%edx
f01020f7:	c1 ea 0c             	shr    $0xc,%edx
f01020fa:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0102100:	72 20                	jb     f0102122 <mem_init+0x480>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102102:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102106:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f010210d:	f0 
f010210e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0102115:	00 
f0102116:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f010211d:	e8 63 df ff ff       	call   f0100085 <_panic>
	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0102122:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102129:	00 
f010212a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0102131:	00 
f0102132:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102137:	89 04 24             	mov    %eax,(%esp)
f010213a:	e8 51 42 00 00       	call   f0106390 <memset>
	page_free(pp0);
f010213f:	89 34 24             	mov    %esi,(%esp)
f0102142:	e8 50 ec ff ff       	call   f0100d97 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0102147:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010214e:	e8 9f f2 ff ff       	call   f01013f2 <page_alloc>
f0102153:	85 c0                	test   %eax,%eax
f0102155:	75 24                	jne    f010217b <mem_init+0x4d9>
f0102157:	c7 44 24 0c 0f 90 10 	movl   $0xf010900f,0xc(%esp)
f010215e:	f0 
f010215f:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102166:	f0 
f0102167:	c7 44 24 04 86 03 00 	movl   $0x386,0x4(%esp)
f010216e:	00 
f010216f:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102176:	e8 0a df ff ff       	call   f0100085 <_panic>
	assert(pp && pp0 == pp);
f010217b:	39 c6                	cmp    %eax,%esi
f010217d:	74 24                	je     f01021a3 <mem_init+0x501>
f010217f:	c7 44 24 0c 2d 90 10 	movl   $0xf010902d,0xc(%esp)
f0102186:	f0 
f0102187:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010218e:	f0 
f010218f:	c7 44 24 04 87 03 00 	movl   $0x387,0x4(%esp)
f0102196:	00 
f0102197:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010219e:	e8 e2 de ff ff       	call   f0100085 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01021a3:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01021a6:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f01021ac:	c1 fa 03             	sar    $0x3,%edx
f01021af:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01021b2:	89 d0                	mov    %edx,%eax
f01021b4:	c1 e8 0c             	shr    $0xc,%eax
f01021b7:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f01021bd:	72 20                	jb     f01021df <mem_init+0x53d>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01021bf:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01021c3:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f01021ca:	f0 
f01021cb:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f01021d2:	00 
f01021d3:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f01021da:	e8 a6 de ff ff       	call   f0100085 <_panic>
	return (void *)(pa + KERNBASE);
f01021df:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f01021e5:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);
f01021eb:	80 38 00             	cmpb   $0x0,(%eax)
f01021ee:	74 24                	je     f0102214 <mem_init+0x572>
f01021f0:	c7 44 24 0c 3d 90 10 	movl   $0xf010903d,0xc(%esp)
f01021f7:	f0 
f01021f8:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01021ff:	f0 
f0102200:	c7 44 24 04 8a 03 00 	movl   $0x38a,0x4(%esp)
f0102207:	00 
f0102208:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010220f:	e8 71 de ff ff       	call   f0100085 <_panic>
f0102214:	83 c0 01             	add    $0x1,%eax
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f0102217:	39 d0                	cmp    %edx,%eax
f0102219:	75 d0                	jne    f01021eb <mem_init+0x549>
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f010221b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010221e:	89 0d 30 12 27 f0    	mov    %ecx,0xf0271230

	// free the pages we took
	page_free(pp0);
f0102224:	89 34 24             	mov    %esi,(%esp)
f0102227:	e8 6b eb ff ff       	call   f0100d97 <page_free>
	page_free(pp1);
f010222c:	89 3c 24             	mov    %edi,(%esp)
f010222f:	e8 63 eb ff ff       	call   f0100d97 <page_free>
	page_free(pp2);
f0102234:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102237:	89 04 24             	mov    %eax,(%esp)
f010223a:	e8 58 eb ff ff       	call   f0100d97 <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010223f:	a1 30 12 27 f0       	mov    0xf0271230,%eax
f0102244:	eb 05                	jmp    f010224b <mem_init+0x5a9>
		--nfree;
f0102246:	83 eb 01             	sub    $0x1,%ebx
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102249:	8b 00                	mov    (%eax),%eax
f010224b:	85 c0                	test   %eax,%eax
f010224d:	75 f7                	jne    f0102246 <mem_init+0x5a4>
		--nfree;
	assert(nfree == 0);
f010224f:	85 db                	test   %ebx,%ebx
f0102251:	74 24                	je     f0102277 <mem_init+0x5d5>
f0102253:	c7 44 24 0c 47 90 10 	movl   $0xf0109047,0xc(%esp)
f010225a:	f0 
f010225b:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102262:	f0 
f0102263:	c7 44 24 04 97 03 00 	movl   $0x397,0x4(%esp)
f010226a:	00 
f010226b:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102272:	e8 0e de ff ff       	call   f0100085 <_panic>

	cprintf("check_page_alloc() succeeded!\n");
f0102277:	c7 04 24 54 87 10 f0 	movl   $0xf0108754,(%esp)
f010227e:	e8 7c 23 00 00       	call   f01045ff <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102283:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010228a:	e8 63 f1 ff ff       	call   f01013f2 <page_alloc>
f010228f:	89 c7                	mov    %eax,%edi
f0102291:	85 c0                	test   %eax,%eax
f0102293:	75 24                	jne    f01022b9 <mem_init+0x617>
f0102295:	c7 44 24 0c e5 8e 10 	movl   $0xf0108ee5,0xc(%esp)
f010229c:	f0 
f010229d:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01022a4:	f0 
f01022a5:	c7 44 24 04 fd 03 00 	movl   $0x3fd,0x4(%esp)
f01022ac:	00 
f01022ad:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01022b4:	e8 cc dd ff ff       	call   f0100085 <_panic>
	assert((pp1 = page_alloc(0)));
f01022b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01022c0:	e8 2d f1 ff ff       	call   f01013f2 <page_alloc>
f01022c5:	89 c3                	mov    %eax,%ebx
f01022c7:	85 c0                	test   %eax,%eax
f01022c9:	75 24                	jne    f01022ef <mem_init+0x64d>
f01022cb:	c7 44 24 0c fb 8e 10 	movl   $0xf0108efb,0xc(%esp)
f01022d2:	f0 
f01022d3:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01022da:	f0 
f01022db:	c7 44 24 04 fe 03 00 	movl   $0x3fe,0x4(%esp)
f01022e2:	00 
f01022e3:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01022ea:	e8 96 dd ff ff       	call   f0100085 <_panic>
	assert((pp2 = page_alloc(0)));
f01022ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01022f6:	e8 f7 f0 ff ff       	call   f01013f2 <page_alloc>
f01022fb:	89 c6                	mov    %eax,%esi
f01022fd:	85 c0                	test   %eax,%eax
f01022ff:	75 24                	jne    f0102325 <mem_init+0x683>
f0102301:	c7 44 24 0c 11 8f 10 	movl   $0xf0108f11,0xc(%esp)
f0102308:	f0 
f0102309:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102310:	f0 
f0102311:	c7 44 24 04 ff 03 00 	movl   $0x3ff,0x4(%esp)
f0102318:	00 
f0102319:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102320:	e8 60 dd ff ff       	call   f0100085 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102325:	39 df                	cmp    %ebx,%edi
f0102327:	75 24                	jne    f010234d <mem_init+0x6ab>
f0102329:	c7 44 24 0c 97 8f 10 	movl   $0xf0108f97,0xc(%esp)
f0102330:	f0 
f0102331:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102338:	f0 
f0102339:	c7 44 24 04 02 04 00 	movl   $0x402,0x4(%esp)
f0102340:	00 
f0102341:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102348:	e8 38 dd ff ff       	call   f0100085 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010234d:	39 c3                	cmp    %eax,%ebx
f010234f:	74 04                	je     f0102355 <mem_init+0x6b3>
f0102351:	39 c7                	cmp    %eax,%edi
f0102353:	75 24                	jne    f0102379 <mem_init+0x6d7>
f0102355:	c7 44 24 0c 34 87 10 	movl   $0xf0108734,0xc(%esp)
f010235c:	f0 
f010235d:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102364:	f0 
f0102365:	c7 44 24 04 03 04 00 	movl   $0x403,0x4(%esp)
f010236c:	00 
f010236d:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102374:	e8 0c dd ff ff       	call   f0100085 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102379:	8b 15 30 12 27 f0    	mov    0xf0271230,%edx
f010237f:	89 55 c8             	mov    %edx,-0x38(%ebp)
	page_free_list = 0;
f0102382:	c7 05 30 12 27 f0 00 	movl   $0x0,0xf0271230
f0102389:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f010238c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102393:	e8 5a f0 ff ff       	call   f01013f2 <page_alloc>
f0102398:	85 c0                	test   %eax,%eax
f010239a:	74 24                	je     f01023c0 <mem_init+0x71e>
f010239c:	c7 44 24 0c 00 90 10 	movl   $0xf0109000,0xc(%esp)
f01023a3:	f0 
f01023a4:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01023ab:	f0 
f01023ac:	c7 44 24 04 0a 04 00 	movl   $0x40a,0x4(%esp)
f01023b3:	00 
f01023b4:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01023bb:	e8 c5 dc ff ff       	call   f0100085 <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01023c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01023c3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01023c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01023ce:	00 
f01023cf:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01023d4:	89 04 24             	mov    %eax,(%esp)
f01023d7:	e8 45 f3 ff ff       	call   f0101721 <page_lookup>
f01023dc:	85 c0                	test   %eax,%eax
f01023de:	74 24                	je     f0102404 <mem_init+0x762>
f01023e0:	c7 44 24 0c 74 87 10 	movl   $0xf0108774,0xc(%esp)
f01023e7:	f0 
f01023e8:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01023ef:	f0 
f01023f0:	c7 44 24 04 0d 04 00 	movl   $0x40d,0x4(%esp)
f01023f7:	00 
f01023f8:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01023ff:	e8 81 dc ff ff       	call   f0100085 <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102404:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010240b:	00 
f010240c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102413:	00 
f0102414:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102418:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f010241d:	89 04 24             	mov    %eax,(%esp)
f0102420:	e8 c5 f3 ff ff       	call   f01017ea <page_insert>
f0102425:	85 c0                	test   %eax,%eax
f0102427:	78 24                	js     f010244d <mem_init+0x7ab>
f0102429:	c7 44 24 0c ac 87 10 	movl   $0xf01087ac,0xc(%esp)
f0102430:	f0 
f0102431:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102438:	f0 
f0102439:	c7 44 24 04 10 04 00 	movl   $0x410,0x4(%esp)
f0102440:	00 
f0102441:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102448:	e8 38 dc ff ff       	call   f0100085 <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f010244d:	89 3c 24             	mov    %edi,(%esp)
f0102450:	e8 42 e9 ff ff       	call   f0100d97 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102455:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010245c:	00 
f010245d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102464:	00 
f0102465:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102469:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f010246e:	89 04 24             	mov    %eax,(%esp)
f0102471:	e8 74 f3 ff ff       	call   f01017ea <page_insert>
f0102476:	85 c0                	test   %eax,%eax
f0102478:	74 24                	je     f010249e <mem_init+0x7fc>
f010247a:	c7 44 24 0c dc 87 10 	movl   $0xf01087dc,0xc(%esp)
f0102481:	f0 
f0102482:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102489:	f0 
f010248a:	c7 44 24 04 14 04 00 	movl   $0x414,0x4(%esp)
f0102491:	00 
f0102492:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102499:	e8 e7 db ff ff       	call   f0100085 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010249e:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01024a3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01024a6:	8b 08                	mov    (%eax),%ecx
f01024a8:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01024ae:	89 fa                	mov    %edi,%edx
f01024b0:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f01024b6:	c1 fa 03             	sar    $0x3,%edx
f01024b9:	c1 e2 0c             	shl    $0xc,%edx
f01024bc:	39 d1                	cmp    %edx,%ecx
f01024be:	74 24                	je     f01024e4 <mem_init+0x842>
f01024c0:	c7 44 24 0c e0 86 10 	movl   $0xf01086e0,0xc(%esp)
f01024c7:	f0 
f01024c8:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01024cf:	f0 
f01024d0:	c7 44 24 04 15 04 00 	movl   $0x415,0x4(%esp)
f01024d7:	00 
f01024d8:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01024df:	e8 a1 db ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01024e4:	ba 00 00 00 00       	mov    $0x0,%edx
f01024e9:	e8 43 e8 ff ff       	call   f0100d31 <check_va2pa>
f01024ee:	89 5d d0             	mov    %ebx,-0x30(%ebp)
f01024f1:	89 da                	mov    %ebx,%edx
f01024f3:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f01024f9:	c1 fa 03             	sar    $0x3,%edx
f01024fc:	c1 e2 0c             	shl    $0xc,%edx
f01024ff:	39 d0                	cmp    %edx,%eax
f0102501:	74 24                	je     f0102527 <mem_init+0x885>
f0102503:	c7 44 24 0c 0c 88 10 	movl   $0xf010880c,0xc(%esp)
f010250a:	f0 
f010250b:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102512:	f0 
f0102513:	c7 44 24 04 16 04 00 	movl   $0x416,0x4(%esp)
f010251a:	00 
f010251b:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102522:	e8 5e db ff ff       	call   f0100085 <_panic>
	assert(pp1->pp_ref == 1);
f0102527:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010252c:	74 24                	je     f0102552 <mem_init+0x8b0>
f010252e:	c7 44 24 0c 27 8f 10 	movl   $0xf0108f27,0xc(%esp)
f0102535:	f0 
f0102536:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010253d:	f0 
f010253e:	c7 44 24 04 17 04 00 	movl   $0x417,0x4(%esp)
f0102545:	00 
f0102546:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010254d:	e8 33 db ff ff       	call   f0100085 <_panic>
	assert(pp0->pp_ref == 1);
f0102552:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102557:	74 24                	je     f010257d <mem_init+0x8db>
f0102559:	c7 44 24 0c 6b 8f 10 	movl   $0xf0108f6b,0xc(%esp)
f0102560:	f0 
f0102561:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102568:	f0 
f0102569:	c7 44 24 04 18 04 00 	movl   $0x418,0x4(%esp)
f0102570:	00 
f0102571:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102578:	e8 08 db ff ff       	call   f0100085 <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010257d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102584:	00 
f0102585:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010258c:	00 
f010258d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102591:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102596:	89 04 24             	mov    %eax,(%esp)
f0102599:	e8 4c f2 ff ff       	call   f01017ea <page_insert>
f010259e:	85 c0                	test   %eax,%eax
f01025a0:	74 24                	je     f01025c6 <mem_init+0x924>
f01025a2:	c7 44 24 0c 3c 88 10 	movl   $0xf010883c,0xc(%esp)
f01025a9:	f0 
f01025aa:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01025b1:	f0 
f01025b2:	c7 44 24 04 1b 04 00 	movl   $0x41b,0x4(%esp)
f01025b9:	00 
f01025ba:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01025c1:	e8 bf da ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01025c6:	ba 00 10 00 00       	mov    $0x1000,%edx
f01025cb:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01025d0:	e8 5c e7 ff ff       	call   f0100d31 <check_va2pa>
f01025d5:	89 75 cc             	mov    %esi,-0x34(%ebp)
f01025d8:	89 f2                	mov    %esi,%edx
f01025da:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f01025e0:	c1 fa 03             	sar    $0x3,%edx
f01025e3:	c1 e2 0c             	shl    $0xc,%edx
f01025e6:	39 d0                	cmp    %edx,%eax
f01025e8:	74 24                	je     f010260e <mem_init+0x96c>
f01025ea:	c7 44 24 0c 78 88 10 	movl   $0xf0108878,0xc(%esp)
f01025f1:	f0 
f01025f2:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01025f9:	f0 
f01025fa:	c7 44 24 04 1c 04 00 	movl   $0x41c,0x4(%esp)
f0102601:	00 
f0102602:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102609:	e8 77 da ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 1);
f010260e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102613:	74 24                	je     f0102639 <mem_init+0x997>
f0102615:	c7 44 24 0c 38 8f 10 	movl   $0xf0108f38,0xc(%esp)
f010261c:	f0 
f010261d:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102624:	f0 
f0102625:	c7 44 24 04 1d 04 00 	movl   $0x41d,0x4(%esp)
f010262c:	00 
f010262d:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102634:	e8 4c da ff ff       	call   f0100085 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0102639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102640:	e8 ad ed ff ff       	call   f01013f2 <page_alloc>
f0102645:	85 c0                	test   %eax,%eax
f0102647:	74 24                	je     f010266d <mem_init+0x9cb>
f0102649:	c7 44 24 0c 00 90 10 	movl   $0xf0109000,0xc(%esp)
f0102650:	f0 
f0102651:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102658:	f0 
f0102659:	c7 44 24 04 20 04 00 	movl   $0x420,0x4(%esp)
f0102660:	00 
f0102661:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102668:	e8 18 da ff ff       	call   f0100085 <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010266d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102674:	00 
f0102675:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010267c:	00 
f010267d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102681:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102686:	89 04 24             	mov    %eax,(%esp)
f0102689:	e8 5c f1 ff ff       	call   f01017ea <page_insert>
f010268e:	85 c0                	test   %eax,%eax
f0102690:	74 24                	je     f01026b6 <mem_init+0xa14>
f0102692:	c7 44 24 0c 3c 88 10 	movl   $0xf010883c,0xc(%esp)
f0102699:	f0 
f010269a:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01026a1:	f0 
f01026a2:	c7 44 24 04 23 04 00 	movl   $0x423,0x4(%esp)
f01026a9:	00 
f01026aa:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01026b1:	e8 cf d9 ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01026b6:	ba 00 10 00 00       	mov    $0x1000,%edx
f01026bb:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01026c0:	e8 6c e6 ff ff       	call   f0100d31 <check_va2pa>
f01026c5:	8b 55 cc             	mov    -0x34(%ebp),%edx
f01026c8:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f01026ce:	c1 fa 03             	sar    $0x3,%edx
f01026d1:	c1 e2 0c             	shl    $0xc,%edx
f01026d4:	39 d0                	cmp    %edx,%eax
f01026d6:	74 24                	je     f01026fc <mem_init+0xa5a>
f01026d8:	c7 44 24 0c 78 88 10 	movl   $0xf0108878,0xc(%esp)
f01026df:	f0 
f01026e0:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01026e7:	f0 
f01026e8:	c7 44 24 04 24 04 00 	movl   $0x424,0x4(%esp)
f01026ef:	00 
f01026f0:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01026f7:	e8 89 d9 ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 1);
f01026fc:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102701:	74 24                	je     f0102727 <mem_init+0xa85>
f0102703:	c7 44 24 0c 38 8f 10 	movl   $0xf0108f38,0xc(%esp)
f010270a:	f0 
f010270b:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102712:	f0 
f0102713:	c7 44 24 04 25 04 00 	movl   $0x425,0x4(%esp)
f010271a:	00 
f010271b:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102722:	e8 5e d9 ff ff       	call   f0100085 <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0102727:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010272e:	e8 bf ec ff ff       	call   f01013f2 <page_alloc>
f0102733:	85 c0                	test   %eax,%eax
f0102735:	74 24                	je     f010275b <mem_init+0xab9>
f0102737:	c7 44 24 0c 00 90 10 	movl   $0xf0109000,0xc(%esp)
f010273e:	f0 
f010273f:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102746:	f0 
f0102747:	c7 44 24 04 29 04 00 	movl   $0x429,0x4(%esp)
f010274e:	00 
f010274f:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102756:	e8 2a d9 ff ff       	call   f0100085 <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f010275b:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102760:	8b 00                	mov    (%eax),%eax
f0102762:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102767:	89 c2                	mov    %eax,%edx
f0102769:	c1 ea 0c             	shr    $0xc,%edx
f010276c:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0102772:	72 20                	jb     f0102794 <mem_init+0xaf2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102774:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102778:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f010277f:	f0 
f0102780:	c7 44 24 04 2c 04 00 	movl   $0x42c,0x4(%esp)
f0102787:	00 
f0102788:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010278f:	e8 f1 d8 ff ff       	call   f0100085 <_panic>
f0102794:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f010279c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01027a3:	00 
f01027a4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01027ab:	00 
f01027ac:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01027b1:	89 04 24             	mov    %eax,(%esp)
f01027b4:	e8 ef ec ff ff       	call   f01014a8 <pgdir_walk>
f01027b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01027bc:	83 c2 04             	add    $0x4,%edx
f01027bf:	39 d0                	cmp    %edx,%eax
f01027c1:	74 24                	je     f01027e7 <mem_init+0xb45>
f01027c3:	c7 44 24 0c a8 88 10 	movl   $0xf01088a8,0xc(%esp)
f01027ca:	f0 
f01027cb:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01027d2:	f0 
f01027d3:	c7 44 24 04 2d 04 00 	movl   $0x42d,0x4(%esp)
f01027da:	00 
f01027db:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01027e2:	e8 9e d8 ff ff       	call   f0100085 <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01027e7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f01027ee:	00 
f01027ef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01027f6:	00 
f01027f7:	89 74 24 04          	mov    %esi,0x4(%esp)
f01027fb:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102800:	89 04 24             	mov    %eax,(%esp)
f0102803:	e8 e2 ef ff ff       	call   f01017ea <page_insert>
f0102808:	85 c0                	test   %eax,%eax
f010280a:	74 24                	je     f0102830 <mem_init+0xb8e>
f010280c:	c7 44 24 0c e8 88 10 	movl   $0xf01088e8,0xc(%esp)
f0102813:	f0 
f0102814:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010281b:	f0 
f010281c:	c7 44 24 04 30 04 00 	movl   $0x430,0x4(%esp)
f0102823:	00 
f0102824:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010282b:	e8 55 d8 ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102830:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102835:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f010283a:	e8 f2 e4 ff ff       	call   f0100d31 <check_va2pa>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010283f:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0102842:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f0102848:	c1 fa 03             	sar    $0x3,%edx
f010284b:	c1 e2 0c             	shl    $0xc,%edx
f010284e:	39 d0                	cmp    %edx,%eax
f0102850:	74 24                	je     f0102876 <mem_init+0xbd4>
f0102852:	c7 44 24 0c 78 88 10 	movl   $0xf0108878,0xc(%esp)
f0102859:	f0 
f010285a:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102861:	f0 
f0102862:	c7 44 24 04 31 04 00 	movl   $0x431,0x4(%esp)
f0102869:	00 
f010286a:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102871:	e8 0f d8 ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 1);
f0102876:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010287b:	74 24                	je     f01028a1 <mem_init+0xbff>
f010287d:	c7 44 24 0c 38 8f 10 	movl   $0xf0108f38,0xc(%esp)
f0102884:	f0 
f0102885:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010288c:	f0 
f010288d:	c7 44 24 04 32 04 00 	movl   $0x432,0x4(%esp)
f0102894:	00 
f0102895:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010289c:	e8 e4 d7 ff ff       	call   f0100085 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01028a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01028a8:	00 
f01028a9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01028b0:	00 
f01028b1:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01028b6:	89 04 24             	mov    %eax,(%esp)
f01028b9:	e8 ea eb ff ff       	call   f01014a8 <pgdir_walk>
f01028be:	f6 00 04             	testb  $0x4,(%eax)
f01028c1:	75 24                	jne    f01028e7 <mem_init+0xc45>
f01028c3:	c7 44 24 0c 28 89 10 	movl   $0xf0108928,0xc(%esp)
f01028ca:	f0 
f01028cb:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01028d2:	f0 
f01028d3:	c7 44 24 04 33 04 00 	movl   $0x433,0x4(%esp)
f01028da:	00 
f01028db:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01028e2:	e8 9e d7 ff ff       	call   f0100085 <_panic>
	assert(kern_pgdir[0] & PTE_W);//question: original PTE_U
f01028e7:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01028ec:	f6 00 02             	testb  $0x2,(%eax)
f01028ef:	75 24                	jne    f0102915 <mem_init+0xc73>
f01028f1:	c7 44 24 0c 52 90 10 	movl   $0xf0109052,0xc(%esp)
f01028f8:	f0 
f01028f9:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102900:	f0 
f0102901:	c7 44 24 04 34 04 00 	movl   $0x434,0x4(%esp)
f0102908:	00 
f0102909:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102910:	e8 70 d7 ff ff       	call   f0100085 <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102915:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010291c:	00 
f010291d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102924:	00 
f0102925:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102929:	89 04 24             	mov    %eax,(%esp)
f010292c:	e8 b9 ee ff ff       	call   f01017ea <page_insert>
f0102931:	85 c0                	test   %eax,%eax
f0102933:	74 24                	je     f0102959 <mem_init+0xcb7>
f0102935:	c7 44 24 0c 3c 88 10 	movl   $0xf010883c,0xc(%esp)
f010293c:	f0 
f010293d:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102944:	f0 
f0102945:	c7 44 24 04 37 04 00 	movl   $0x437,0x4(%esp)
f010294c:	00 
f010294d:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102954:	e8 2c d7 ff ff       	call   f0100085 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102959:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102960:	00 
f0102961:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102968:	00 
f0102969:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f010296e:	89 04 24             	mov    %eax,(%esp)
f0102971:	e8 32 eb ff ff       	call   f01014a8 <pgdir_walk>
f0102976:	f6 00 02             	testb  $0x2,(%eax)
f0102979:	75 24                	jne    f010299f <mem_init+0xcfd>
f010297b:	c7 44 24 0c 5c 89 10 	movl   $0xf010895c,0xc(%esp)
f0102982:	f0 
f0102983:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010298a:	f0 
f010298b:	c7 44 24 04 38 04 00 	movl   $0x438,0x4(%esp)
f0102992:	00 
f0102993:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010299a:	e8 e6 d6 ff ff       	call   f0100085 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010299f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01029a6:	00 
f01029a7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01029ae:	00 
f01029af:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01029b4:	89 04 24             	mov    %eax,(%esp)
f01029b7:	e8 ec ea ff ff       	call   f01014a8 <pgdir_walk>
f01029bc:	f6 00 04             	testb  $0x4,(%eax)
f01029bf:	74 24                	je     f01029e5 <mem_init+0xd43>
f01029c1:	c7 44 24 0c 90 89 10 	movl   $0xf0108990,0xc(%esp)
f01029c8:	f0 
f01029c9:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01029d0:	f0 
f01029d1:	c7 44 24 04 39 04 00 	movl   $0x439,0x4(%esp)
f01029d8:	00 
f01029d9:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01029e0:	e8 a0 d6 ff ff       	call   f0100085 <_panic>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01029e5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01029ec:	00 
f01029ed:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f01029f4:	00 
f01029f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01029f9:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01029fe:	89 04 24             	mov    %eax,(%esp)
f0102a01:	e8 e4 ed ff ff       	call   f01017ea <page_insert>
f0102a06:	85 c0                	test   %eax,%eax
f0102a08:	78 24                	js     f0102a2e <mem_init+0xd8c>
f0102a0a:	c7 44 24 0c c8 89 10 	movl   $0xf01089c8,0xc(%esp)
f0102a11:	f0 
f0102a12:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102a19:	f0 
f0102a1a:	c7 44 24 04 3c 04 00 	movl   $0x43c,0x4(%esp)
f0102a21:	00 
f0102a22:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102a29:	e8 57 d6 ff ff       	call   f0100085 <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102a2e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102a35:	00 
f0102a36:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102a3d:	00 
f0102a3e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102a42:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102a47:	89 04 24             	mov    %eax,(%esp)
f0102a4a:	e8 9b ed ff ff       	call   f01017ea <page_insert>
f0102a4f:	85 c0                	test   %eax,%eax
f0102a51:	74 24                	je     f0102a77 <mem_init+0xdd5>
f0102a53:	c7 44 24 0c 00 8a 10 	movl   $0xf0108a00,0xc(%esp)
f0102a5a:	f0 
f0102a5b:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102a62:	f0 
f0102a63:	c7 44 24 04 3f 04 00 	movl   $0x43f,0x4(%esp)
f0102a6a:	00 
f0102a6b:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102a72:	e8 0e d6 ff ff       	call   f0100085 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102a77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102a7e:	00 
f0102a7f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102a86:	00 
f0102a87:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102a8c:	89 04 24             	mov    %eax,(%esp)
f0102a8f:	e8 14 ea ff ff       	call   f01014a8 <pgdir_walk>
f0102a94:	f6 00 04             	testb  $0x4,(%eax)
f0102a97:	74 24                	je     f0102abd <mem_init+0xe1b>
f0102a99:	c7 44 24 0c 90 89 10 	movl   $0xf0108990,0xc(%esp)
f0102aa0:	f0 
f0102aa1:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102aa8:	f0 
f0102aa9:	c7 44 24 04 40 04 00 	movl   $0x440,0x4(%esp)
f0102ab0:	00 
f0102ab1:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102ab8:	e8 c8 d5 ff ff       	call   f0100085 <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102abd:	ba 00 00 00 00       	mov    $0x0,%edx
f0102ac2:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102ac7:	e8 65 e2 ff ff       	call   f0100d31 <check_va2pa>
f0102acc:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0102acf:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f0102ad5:	c1 fa 03             	sar    $0x3,%edx
f0102ad8:	c1 e2 0c             	shl    $0xc,%edx
f0102adb:	39 d0                	cmp    %edx,%eax
f0102add:	74 24                	je     f0102b03 <mem_init+0xe61>
f0102adf:	c7 44 24 0c 3c 8a 10 	movl   $0xf0108a3c,0xc(%esp)
f0102ae6:	f0 
f0102ae7:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102aee:	f0 
f0102aef:	c7 44 24 04 43 04 00 	movl   $0x443,0x4(%esp)
f0102af6:	00 
f0102af7:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102afe:	e8 82 d5 ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102b03:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102b08:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102b0d:	e8 1f e2 ff ff       	call   f0100d31 <check_va2pa>
f0102b12:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0102b15:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f0102b1b:	c1 fa 03             	sar    $0x3,%edx
f0102b1e:	c1 e2 0c             	shl    $0xc,%edx
f0102b21:	39 d0                	cmp    %edx,%eax
f0102b23:	74 24                	je     f0102b49 <mem_init+0xea7>
f0102b25:	c7 44 24 0c 68 8a 10 	movl   $0xf0108a68,0xc(%esp)
f0102b2c:	f0 
f0102b2d:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102b34:	f0 
f0102b35:	c7 44 24 04 44 04 00 	movl   $0x444,0x4(%esp)
f0102b3c:	00 
f0102b3d:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102b44:	e8 3c d5 ff ff       	call   f0100085 <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0102b49:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0102b4e:	74 24                	je     f0102b74 <mem_init+0xed2>
f0102b50:	c7 44 24 0c 68 90 10 	movl   $0xf0109068,0xc(%esp)
f0102b57:	f0 
f0102b58:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102b5f:	f0 
f0102b60:	c7 44 24 04 46 04 00 	movl   $0x446,0x4(%esp)
f0102b67:	00 
f0102b68:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102b6f:	e8 11 d5 ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 0);
f0102b74:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102b79:	74 24                	je     f0102b9f <mem_init+0xefd>
f0102b7b:	c7 44 24 0c 5a 8f 10 	movl   $0xf0108f5a,0xc(%esp)
f0102b82:	f0 
f0102b83:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102b8a:	f0 
f0102b8b:	c7 44 24 04 47 04 00 	movl   $0x447,0x4(%esp)
f0102b92:	00 
f0102b93:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102b9a:	e8 e6 d4 ff ff       	call   f0100085 <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0102b9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102ba6:	e8 47 e8 ff ff       	call   f01013f2 <page_alloc>
f0102bab:	85 c0                	test   %eax,%eax
f0102bad:	74 04                	je     f0102bb3 <mem_init+0xf11>
f0102baf:	39 c6                	cmp    %eax,%esi
f0102bb1:	74 24                	je     f0102bd7 <mem_init+0xf35>
f0102bb3:	c7 44 24 0c 98 8a 10 	movl   $0xf0108a98,0xc(%esp)
f0102bba:	f0 
f0102bbb:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102bc2:	f0 
f0102bc3:	c7 44 24 04 4a 04 00 	movl   $0x44a,0x4(%esp)
f0102bca:	00 
f0102bcb:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102bd2:	e8 ae d4 ff ff       	call   f0100085 <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0102bd7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102bde:	00 
f0102bdf:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102be4:	89 04 24             	mov    %eax,(%esp)
f0102be7:	e8 a6 eb ff ff       	call   f0101792 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102bec:	ba 00 00 00 00       	mov    $0x0,%edx
f0102bf1:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102bf6:	e8 36 e1 ff ff       	call   f0100d31 <check_va2pa>
f0102bfb:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102bfe:	74 24                	je     f0102c24 <mem_init+0xf82>
f0102c00:	c7 44 24 0c bc 8a 10 	movl   $0xf0108abc,0xc(%esp)
f0102c07:	f0 
f0102c08:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102c0f:	f0 
f0102c10:	c7 44 24 04 4e 04 00 	movl   $0x44e,0x4(%esp)
f0102c17:	00 
f0102c18:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102c1f:	e8 61 d4 ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102c24:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102c29:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102c2e:	e8 fe e0 ff ff       	call   f0100d31 <check_va2pa>
f0102c33:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0102c36:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f0102c3c:	c1 fa 03             	sar    $0x3,%edx
f0102c3f:	c1 e2 0c             	shl    $0xc,%edx
f0102c42:	39 d0                	cmp    %edx,%eax
f0102c44:	74 24                	je     f0102c6a <mem_init+0xfc8>
f0102c46:	c7 44 24 0c 68 8a 10 	movl   $0xf0108a68,0xc(%esp)
f0102c4d:	f0 
f0102c4e:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102c55:	f0 
f0102c56:	c7 44 24 04 4f 04 00 	movl   $0x44f,0x4(%esp)
f0102c5d:	00 
f0102c5e:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102c65:	e8 1b d4 ff ff       	call   f0100085 <_panic>
	assert(pp1->pp_ref == 1);
f0102c6a:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102c6f:	74 24                	je     f0102c95 <mem_init+0xff3>
f0102c71:	c7 44 24 0c 27 8f 10 	movl   $0xf0108f27,0xc(%esp)
f0102c78:	f0 
f0102c79:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102c80:	f0 
f0102c81:	c7 44 24 04 50 04 00 	movl   $0x450,0x4(%esp)
f0102c88:	00 
f0102c89:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102c90:	e8 f0 d3 ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 0);
f0102c95:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102c9a:	74 24                	je     f0102cc0 <mem_init+0x101e>
f0102c9c:	c7 44 24 0c 5a 8f 10 	movl   $0xf0108f5a,0xc(%esp)
f0102ca3:	f0 
f0102ca4:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102cab:	f0 
f0102cac:	c7 44 24 04 51 04 00 	movl   $0x451,0x4(%esp)
f0102cb3:	00 
f0102cb4:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102cbb:	e8 c5 d3 ff ff       	call   f0100085 <_panic>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102cc0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0102cc7:	00 
f0102cc8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102ccf:	00 
f0102cd0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102cd4:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102cd9:	89 04 24             	mov    %eax,(%esp)
f0102cdc:	e8 09 eb ff ff       	call   f01017ea <page_insert>
f0102ce1:	85 c0                	test   %eax,%eax
f0102ce3:	74 24                	je     f0102d09 <mem_init+0x1067>
f0102ce5:	c7 44 24 0c e0 8a 10 	movl   $0xf0108ae0,0xc(%esp)
f0102cec:	f0 
f0102ced:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102cf4:	f0 
f0102cf5:	c7 44 24 04 54 04 00 	movl   $0x454,0x4(%esp)
f0102cfc:	00 
f0102cfd:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102d04:	e8 7c d3 ff ff       	call   f0100085 <_panic>
	assert(pp1->pp_ref);
f0102d09:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102d0e:	75 24                	jne    f0102d34 <mem_init+0x1092>
f0102d10:	c7 44 24 0c 79 90 10 	movl   $0xf0109079,0xc(%esp)
f0102d17:	f0 
f0102d18:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102d1f:	f0 
f0102d20:	c7 44 24 04 55 04 00 	movl   $0x455,0x4(%esp)
f0102d27:	00 
f0102d28:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102d2f:	e8 51 d3 ff ff       	call   f0100085 <_panic>
	assert(pp1->pp_link == NULL);
f0102d34:	83 3b 00             	cmpl   $0x0,(%ebx)
f0102d37:	74 24                	je     f0102d5d <mem_init+0x10bb>
f0102d39:	c7 44 24 0c 85 90 10 	movl   $0xf0109085,0xc(%esp)
f0102d40:	f0 
f0102d41:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102d48:	f0 
f0102d49:	c7 44 24 04 56 04 00 	movl   $0x456,0x4(%esp)
f0102d50:	00 
f0102d51:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102d58:	e8 28 d3 ff ff       	call   f0100085 <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102d5d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102d64:	00 
f0102d65:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102d6a:	89 04 24             	mov    %eax,(%esp)
f0102d6d:	e8 20 ea ff ff       	call   f0101792 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102d72:	ba 00 00 00 00       	mov    $0x0,%edx
f0102d77:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102d7c:	e8 b0 df ff ff       	call   f0100d31 <check_va2pa>
f0102d81:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102d84:	74 24                	je     f0102daa <mem_init+0x1108>
f0102d86:	c7 44 24 0c bc 8a 10 	movl   $0xf0108abc,0xc(%esp)
f0102d8d:	f0 
f0102d8e:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102d95:	f0 
f0102d96:	c7 44 24 04 5a 04 00 	movl   $0x45a,0x4(%esp)
f0102d9d:	00 
f0102d9e:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102da5:	e8 db d2 ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102daa:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102daf:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102db4:	e8 78 df ff ff       	call   f0100d31 <check_va2pa>
f0102db9:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102dbc:	74 24                	je     f0102de2 <mem_init+0x1140>
f0102dbe:	c7 44 24 0c 18 8b 10 	movl   $0xf0108b18,0xc(%esp)
f0102dc5:	f0 
f0102dc6:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102dcd:	f0 
f0102dce:	c7 44 24 04 5b 04 00 	movl   $0x45b,0x4(%esp)
f0102dd5:	00 
f0102dd6:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102ddd:	e8 a3 d2 ff ff       	call   f0100085 <_panic>
	assert(pp1->pp_ref == 0);
f0102de2:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102de7:	74 24                	je     f0102e0d <mem_init+0x116b>
f0102de9:	c7 44 24 0c 49 8f 10 	movl   $0xf0108f49,0xc(%esp)
f0102df0:	f0 
f0102df1:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102df8:	f0 
f0102df9:	c7 44 24 04 5c 04 00 	movl   $0x45c,0x4(%esp)
f0102e00:	00 
f0102e01:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102e08:	e8 78 d2 ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 0);
f0102e0d:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102e12:	74 24                	je     f0102e38 <mem_init+0x1196>
f0102e14:	c7 44 24 0c 5a 8f 10 	movl   $0xf0108f5a,0xc(%esp)
f0102e1b:	f0 
f0102e1c:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102e23:	f0 
f0102e24:	c7 44 24 04 5d 04 00 	movl   $0x45d,0x4(%esp)
f0102e2b:	00 
f0102e2c:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102e33:	e8 4d d2 ff ff       	call   f0100085 <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0102e38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102e3f:	e8 ae e5 ff ff       	call   f01013f2 <page_alloc>
f0102e44:	85 c0                	test   %eax,%eax
f0102e46:	74 04                	je     f0102e4c <mem_init+0x11aa>
f0102e48:	39 c3                	cmp    %eax,%ebx
f0102e4a:	74 24                	je     f0102e70 <mem_init+0x11ce>
f0102e4c:	c7 44 24 0c 40 8b 10 	movl   $0xf0108b40,0xc(%esp)
f0102e53:	f0 
f0102e54:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102e5b:	f0 
f0102e5c:	c7 44 24 04 60 04 00 	movl   $0x460,0x4(%esp)
f0102e63:	00 
f0102e64:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102e6b:	e8 15 d2 ff ff       	call   f0100085 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0102e70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102e77:	e8 76 e5 ff ff       	call   f01013f2 <page_alloc>
f0102e7c:	85 c0                	test   %eax,%eax
f0102e7e:	74 24                	je     f0102ea4 <mem_init+0x1202>
f0102e80:	c7 44 24 0c 00 90 10 	movl   $0xf0109000,0xc(%esp)
f0102e87:	f0 
f0102e88:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102e8f:	f0 
f0102e90:	c7 44 24 04 63 04 00 	movl   $0x463,0x4(%esp)
f0102e97:	00 
f0102e98:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102e9f:	e8 e1 d1 ff ff       	call   f0100085 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102ea4:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102ea9:	8b 08                	mov    (%eax),%ecx
f0102eab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102eb1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102eb4:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f0102eba:	c1 fa 03             	sar    $0x3,%edx
f0102ebd:	c1 e2 0c             	shl    $0xc,%edx
f0102ec0:	39 d1                	cmp    %edx,%ecx
f0102ec2:	74 24                	je     f0102ee8 <mem_init+0x1246>
f0102ec4:	c7 44 24 0c e0 86 10 	movl   $0xf01086e0,0xc(%esp)
f0102ecb:	f0 
f0102ecc:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102ed3:	f0 
f0102ed4:	c7 44 24 04 66 04 00 	movl   $0x466,0x4(%esp)
f0102edb:	00 
f0102edc:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102ee3:	e8 9d d1 ff ff       	call   f0100085 <_panic>
	kern_pgdir[0] = 0;
f0102ee8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0102eee:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102ef3:	74 24                	je     f0102f19 <mem_init+0x1277>
f0102ef5:	c7 44 24 0c 6b 8f 10 	movl   $0xf0108f6b,0xc(%esp)
f0102efc:	f0 
f0102efd:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102f04:	f0 
f0102f05:	c7 44 24 04 68 04 00 	movl   $0x468,0x4(%esp)
f0102f0c:	00 
f0102f0d:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102f14:	e8 6c d1 ff ff       	call   f0100085 <_panic>
	pp0->pp_ref = 0;
f0102f19:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102f1f:	89 3c 24             	mov    %edi,(%esp)
f0102f22:	e8 70 de ff ff       	call   f0100d97 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102f27:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102f2e:	00 
f0102f2f:	c7 44 24 04 00 10 40 	movl   $0x401000,0x4(%esp)
f0102f36:	00 
f0102f37:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0102f3c:	89 04 24             	mov    %eax,(%esp)
f0102f3f:	e8 64 e5 ff ff       	call   f01014a8 <pgdir_walk>
f0102f44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102f47:	8b 0d a8 1e 27 f0    	mov    0xf0271ea8,%ecx
f0102f4d:	83 c1 04             	add    $0x4,%ecx
f0102f50:	8b 11                	mov    (%ecx),%edx
f0102f52:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102f58:	89 55 cc             	mov    %edx,-0x34(%ebp)
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102f5b:	c1 ea 0c             	shr    $0xc,%edx
f0102f5e:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0102f64:	72 23                	jb     f0102f89 <mem_init+0x12e7>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102f66:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102f69:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0102f6d:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0102f74:	f0 
f0102f75:	c7 44 24 04 6f 04 00 	movl   $0x46f,0x4(%esp)
f0102f7c:	00 
f0102f7d:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102f84:	e8 fc d0 ff ff       	call   f0100085 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102f89:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0102f8c:	81 ea fc ff ff 0f    	sub    $0xffffffc,%edx
f0102f92:	39 d0                	cmp    %edx,%eax
f0102f94:	74 24                	je     f0102fba <mem_init+0x1318>
f0102f96:	c7 44 24 0c 9a 90 10 	movl   $0xf010909a,0xc(%esp)
f0102f9d:	f0 
f0102f9e:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0102fa5:	f0 
f0102fa6:	c7 44 24 04 70 04 00 	movl   $0x470,0x4(%esp)
f0102fad:	00 
f0102fae:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0102fb5:	e8 cb d0 ff ff       	call   f0100085 <_panic>
	kern_pgdir[PDX(va)] = 0;
f0102fba:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	pp0->pp_ref = 0;
f0102fc0:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102fc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fc9:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f0102fcf:	c1 f8 03             	sar    $0x3,%eax
f0102fd2:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102fd5:	89 c2                	mov    %eax,%edx
f0102fd7:	c1 ea 0c             	shr    $0xc,%edx
f0102fda:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0102fe0:	72 20                	jb     f0103002 <mem_init+0x1360>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102fe2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102fe6:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0102fed:	f0 
f0102fee:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0102ff5:	00 
f0102ff6:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0102ffd:	e8 83 d0 ff ff       	call   f0100085 <_panic>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0103002:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103009:	00 
f010300a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f0103011:	00 
f0103012:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103017:	89 04 24             	mov    %eax,(%esp)
f010301a:	e8 71 33 00 00       	call   f0106390 <memset>
	page_free(pp0);
f010301f:	89 3c 24             	mov    %edi,(%esp)
f0103022:	e8 70 dd ff ff       	call   f0100d97 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0103027:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010302e:	00 
f010302f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103036:	00 
f0103037:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f010303c:	89 04 24             	mov    %eax,(%esp)
f010303f:	e8 64 e4 ff ff       	call   f01014a8 <pgdir_walk>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103044:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103047:	2b 15 ac 1e 27 f0    	sub    0xf0271eac,%edx
f010304d:	c1 fa 03             	sar    $0x3,%edx
f0103050:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103053:	89 d0                	mov    %edx,%eax
f0103055:	c1 e8 0c             	shr    $0xc,%eax
f0103058:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f010305e:	72 20                	jb     f0103080 <mem_init+0x13de>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103060:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103064:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f010306b:	f0 
f010306c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0103073:	00 
f0103074:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f010307b:	e8 05 d0 ff ff       	call   f0100085 <_panic>
	return (void *)(pa + KERNBASE);
f0103080:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0103086:	89 45 e4             	mov    %eax,-0x1c(%ebp)
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0103089:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f010308f:	f6 00 01             	testb  $0x1,(%eax)
f0103092:	74 24                	je     f01030b8 <mem_init+0x1416>
f0103094:	c7 44 24 0c b2 90 10 	movl   $0xf01090b2,0xc(%esp)
f010309b:	f0 
f010309c:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01030a3:	f0 
f01030a4:	c7 44 24 04 7a 04 00 	movl   $0x47a,0x4(%esp)
f01030ab:	00 
f01030ac:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01030b3:	e8 cd cf ff ff       	call   f0100085 <_panic>
f01030b8:	83 c0 04             	add    $0x4,%eax
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f01030bb:	39 d0                	cmp    %edx,%eax
f01030bd:	75 d0                	jne    f010308f <mem_init+0x13ed>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f01030bf:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01030c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f01030ca:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)

	// give free list back
	page_free_list = fl;
f01030d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01030d3:	a3 30 12 27 f0       	mov    %eax,0xf0271230

	// free the pages we took
	page_free(pp0);
f01030d8:	89 3c 24             	mov    %edi,(%esp)
f01030db:	e8 b7 dc ff ff       	call   f0100d97 <page_free>
	page_free(pp1);
f01030e0:	89 1c 24             	mov    %ebx,(%esp)
f01030e3:	e8 af dc ff ff       	call   f0100d97 <page_free>
	page_free(pp2);
f01030e8:	89 34 24             	mov    %esi,(%esp)
f01030eb:	e8 a7 dc ff ff       	call   f0100d97 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f01030f0:	c7 44 24 04 01 10 00 	movl   $0x1001,0x4(%esp)
f01030f7:	00 
f01030f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01030ff:	e8 a3 e5 ff ff       	call   f01016a7 <mmio_map_region>
f0103104:	89 c3                	mov    %eax,%ebx
f0103106:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0103109:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0103110:	00 
f0103111:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103118:	e8 8a e5 ff ff       	call   f01016a7 <mmio_map_region>
f010311d:	89 c7                	mov    %eax,%edi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f010311f:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f0103125:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010312b:	76 07                	jbe    f0103134 <mem_init+0x1492>
f010312d:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0103132:	76 24                	jbe    f0103158 <mem_init+0x14b6>
f0103134:	c7 44 24 0c 64 8b 10 	movl   $0xf0108b64,0xc(%esp)
f010313b:	f0 
f010313c:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0103143:	f0 
f0103144:	c7 44 24 04 8a 04 00 	movl   $0x48a,0x4(%esp)
f010314b:	00 
f010314c:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0103153:	e8 2d cf ff ff       	call   f0100085 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0103158:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f010315e:	76 0e                	jbe    f010316e <mem_init+0x14cc>
f0103160:	8d 97 a0 1f 00 00    	lea    0x1fa0(%edi),%edx
f0103166:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f010316c:	76 24                	jbe    f0103192 <mem_init+0x14f0>
f010316e:	c7 44 24 0c 8c 8b 10 	movl   $0xf0108b8c,0xc(%esp)
f0103175:	f0 
f0103176:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010317d:	f0 
f010317e:	c7 44 24 04 8b 04 00 	movl   $0x48b,0x4(%esp)
f0103185:	00 
f0103186:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010318d:	e8 f3 ce ff ff       	call   f0100085 <_panic>
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0103192:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103195:	09 fa                	or     %edi,%edx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0103197:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010319d:	74 24                	je     f01031c3 <mem_init+0x1521>
f010319f:	c7 44 24 0c b4 8b 10 	movl   $0xf0108bb4,0xc(%esp)
f01031a6:	f0 
f01031a7:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01031ae:	f0 
f01031af:	c7 44 24 04 8d 04 00 	movl   $0x48d,0x4(%esp)
f01031b6:	00 
f01031b7:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01031be:	e8 c2 ce ff ff       	call   f0100085 <_panic>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f01031c3:	39 c7                	cmp    %eax,%edi
f01031c5:	73 24                	jae    f01031eb <mem_init+0x1549>
f01031c7:	c7 44 24 0c c9 90 10 	movl   $0xf01090c9,0xc(%esp)
f01031ce:	f0 
f01031cf:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01031d6:	f0 
f01031d7:	c7 44 24 04 8f 04 00 	movl   $0x48f,0x4(%esp)
f01031de:	00 
f01031df:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01031e6:	e8 9a ce ff ff       	call   f0100085 <_panic>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01031eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01031ee:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01031f3:	e8 39 db ff ff       	call   f0100d31 <check_va2pa>
f01031f8:	85 c0                	test   %eax,%eax
f01031fa:	74 24                	je     f0103220 <mem_init+0x157e>
f01031fc:	c7 44 24 0c dc 8b 10 	movl   $0xf0108bdc,0xc(%esp)
f0103203:	f0 
f0103204:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010320b:	f0 
f010320c:	c7 44 24 04 91 04 00 	movl   $0x491,0x4(%esp)
f0103213:	00 
f0103214:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010321b:	e8 65 ce ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0103220:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103223:	81 c2 00 10 00 00    	add    $0x1000,%edx
f0103229:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f010322c:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0103231:	e8 fb da ff ff       	call   f0100d31 <check_va2pa>
f0103236:	3d 00 10 00 00       	cmp    $0x1000,%eax
f010323b:	74 24                	je     f0103261 <mem_init+0x15bf>
f010323d:	c7 44 24 0c 00 8c 10 	movl   $0xf0108c00,0xc(%esp)
f0103244:	f0 
f0103245:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010324c:	f0 
f010324d:	c7 44 24 04 92 04 00 	movl   $0x492,0x4(%esp)
f0103254:	00 
f0103255:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010325c:	e8 24 ce ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0103261:	89 fa                	mov    %edi,%edx
f0103263:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0103268:	e8 c4 da ff ff       	call   f0100d31 <check_va2pa>
f010326d:	85 c0                	test   %eax,%eax
f010326f:	74 24                	je     f0103295 <mem_init+0x15f3>
f0103271:	c7 44 24 0c 30 8c 10 	movl   $0xf0108c30,0xc(%esp)
f0103278:	f0 
f0103279:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0103280:	f0 
f0103281:	c7 44 24 04 93 04 00 	movl   $0x493,0x4(%esp)
f0103288:	00 
f0103289:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0103290:	e8 f0 cd ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0103295:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
f010329b:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01032a0:	e8 8c da ff ff       	call   f0100d31 <check_va2pa>
f01032a5:	83 f8 ff             	cmp    $0xffffffff,%eax
f01032a8:	74 24                	je     f01032ce <mem_init+0x162c>
f01032aa:	c7 44 24 0c 54 8c 10 	movl   $0xf0108c54,0xc(%esp)
f01032b1:	f0 
f01032b2:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01032b9:	f0 
f01032ba:	c7 44 24 04 94 04 00 	movl   $0x494,0x4(%esp)
f01032c1:	00 
f01032c2:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01032c9:	e8 b7 cd ff ff       	call   f0100085 <_panic>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f01032ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01032d5:	00 
f01032d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01032da:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01032df:	89 04 24             	mov    %eax,(%esp)
f01032e2:	e8 c1 e1 ff ff       	call   f01014a8 <pgdir_walk>
f01032e7:	f6 00 1a             	testb  $0x1a,(%eax)
f01032ea:	75 24                	jne    f0103310 <mem_init+0x166e>
f01032ec:	c7 44 24 0c 80 8c 10 	movl   $0xf0108c80,0xc(%esp)
f01032f3:	f0 
f01032f4:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01032fb:	f0 
f01032fc:	c7 44 24 04 96 04 00 	movl   $0x496,0x4(%esp)
f0103303:	00 
f0103304:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010330b:	e8 75 cd ff ff       	call   f0100085 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0103310:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0103317:	00 
f0103318:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010331c:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0103321:	89 04 24             	mov    %eax,(%esp)
f0103324:	e8 7f e1 ff ff       	call   f01014a8 <pgdir_walk>
f0103329:	f6 00 04             	testb  $0x4,(%eax)
f010332c:	74 24                	je     f0103352 <mem_init+0x16b0>
f010332e:	c7 44 24 0c c4 8c 10 	movl   $0xf0108cc4,0xc(%esp)
f0103335:	f0 
f0103336:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010333d:	f0 
f010333e:	c7 44 24 04 97 04 00 	movl   $0x497,0x4(%esp)
f0103345:	00 
f0103346:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010334d:	e8 33 cd ff ff       	call   f0100085 <_panic>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0103352:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0103359:	00 
f010335a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010335e:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0103363:	89 04 24             	mov    %eax,(%esp)
f0103366:	e8 3d e1 ff ff       	call   f01014a8 <pgdir_walk>
f010336b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0103371:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0103378:	00 
f0103379:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010337c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0103380:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0103385:	89 04 24             	mov    %eax,(%esp)
f0103388:	e8 1b e1 ff ff       	call   f01014a8 <pgdir_walk>
f010338d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0103393:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010339a:	00 
f010339b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010339f:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01033a4:	89 04 24             	mov    %eax,(%esp)
f01033a7:	e8 fc e0 ff ff       	call   f01014a8 <pgdir_walk>
f01033ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f01033b2:	c7 04 24 db 90 10 f0 	movl   $0xf01090db,(%esp)
f01033b9:	e8 41 12 00 00       	call   f01045ff <cprintf>
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
	boot_map_region(kern_pgdir,UPAGES,PTSIZE,PADDR(pages),PTE_U);
f01033be:	a1 ac 1e 27 f0       	mov    0xf0271eac,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01033c3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01033c8:	77 20                	ja     f01033ea <mem_init+0x1748>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01033ce:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f01033d5:	f0 
f01033d6:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
f01033dd:	00 
f01033de:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01033e5:	e8 9b cc ff ff       	call   f0100085 <_panic>
f01033ea:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
f01033f1:	00 
f01033f2:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f01033f8:	89 04 24             	mov    %eax,(%esp)
f01033fb:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0103400:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0103405:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f010340a:	e8 37 e2 ff ff       	call   f0101646 <boot_map_region>
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
	boot_map_region(kern_pgdir,UENVS,PTSIZE,PADDR(envs),PTE_U);
f010340f:	a1 38 12 27 f0       	mov    0xf0271238,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103414:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103419:	77 20                	ja     f010343b <mem_init+0x1799>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010341b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010341f:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0103426:	f0 
f0103427:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
f010342e:	00 
f010342f:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0103436:	e8 4a cc ff ff       	call   f0100085 <_panic>
f010343b:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
f0103442:	00 
f0103443:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f0103449:	89 04 24             	mov    %eax,(%esp)
f010344c:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0103451:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0103456:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f010345b:	e8 e6 e1 ff ff       	call   f0101646 <boot_map_region>
f0103460:	c7 45 cc 00 30 27 f0 	movl   $0xf0273000,-0x34(%ebp)
f0103467:	c7 45 d4 00 30 27 f0 	movl   $0xf0273000,-0x2c(%ebp)
f010346e:	c7 45 d0 00 80 ff ef 	movl   $0xefff8000,-0x30(%ebp)
f0103475:	bf 00 80 ff ef       	mov    $0xefff8000,%edi
f010347a:	e9 72 04 00 00       	jmp    f01038f1 <mem_init+0x1c4f>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010347f:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0103485:	77 20                	ja     f01034a7 <mem_init+0x1805>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103487:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010348b:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0103492:	f0 
f0103493:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
f010349a:	00 
f010349b:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01034a2:	e8 de cb ff ff       	call   f0100085 <_panic>
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01034a7:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f01034ad:	c1 e8 0c             	shr    $0xc,%eax
f01034b0:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f01034b6:	72 1c                	jb     f01034d4 <mem_init+0x1832>
		panic("pa2page called with invalid pa");
f01034b8:	c7 44 24 08 28 86 10 	movl   $0xf0108628,0x8(%esp)
f01034bf:	f0 
f01034c0:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f01034c7:	00 
f01034c8:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f01034cf:	e8 b1 cb ff ff       	call   f0100085 <_panic>
	for(i=0,stack_start=KSTACKTOP-KSTKSIZE;i<NCPU;i++)
	{
		for(j=0,percpu_stack_start=stack_start;j<KSTKSIZE;j+=PGSIZE)
		{	
			kpage = pa2page(PADDR(percpu_kstacks[i]+j));
			page_insert(kern_pgdir,kpage,(void *)percpu_stack_start,PTE_W); 
f01034d4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01034db:	00 
f01034dc:	8d 14 3e             	lea    (%esi,%edi,1),%edx
f01034df:	89 54 24 08          	mov    %edx,0x8(%esp)
f01034e3:	c1 e0 03             	shl    $0x3,%eax
f01034e6:	03 05 ac 1e 27 f0    	add    0xf0271eac,%eax
f01034ec:	89 44 24 04          	mov    %eax,0x4(%esp)
f01034f0:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f01034f5:	89 04 24             	mov    %eax,(%esp)
f01034f8:	e8 ed e2 ff ff       	call   f01017ea <page_insert>
	size_t stack_start,percpu_stack_start;
	struct PageInfo * kpage; 
		
	for(i=0,stack_start=KSTACKTOP-KSTKSIZE;i<NCPU;i++)
	{
		for(j=0,percpu_stack_start=stack_start;j<KSTKSIZE;j+=PGSIZE)
f01034fd:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103503:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103509:	81 fe 00 80 00 00    	cmp    $0x8000,%esi
f010350f:	0f 85 6a ff ff ff    	jne    f010347f <mem_init+0x17dd>
f0103515:	81 45 d4 00 80 00 00 	addl   $0x8000,-0x2c(%ebp)
	// LAB 4: Your code here:
	int i,j;
	size_t stack_start,percpu_stack_start;
	struct PageInfo * kpage; 
		
	for(i=0,stack_start=KSTACKTOP-KSTKSIZE;i<NCPU;i++)
f010351c:	81 7d d0 00 80 f8 ef 	cmpl   $0xeff88000,-0x30(%ebp)
f0103523:	0f 85 bc 03 00 00    	jne    f01038e5 <mem_init+0x1c43>
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
	
	size_t size = ROUNDUP(0-KERNBASE,PGSIZE);
	boot_map_region(kern_pgdir,KERNBASE,size,0,PTE_W);
f0103529:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f0103530:	00 
f0103531:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103538:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010353d:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103542:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0103547:	e8 fa e0 ff ff       	call   f0101646 <boot_map_region>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f010354c:	8b 1d a8 1e 27 f0    	mov    0xf0271ea8,%ebx

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0103552:	a1 a4 1e 27 f0       	mov    0xf0271ea4,%eax
f0103557:	8d 3c c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%edi
f010355e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
f0103564:	66 be 00 00          	mov    $0x0,%si
f0103568:	eb 70                	jmp    f01035da <mem_init+0x1938>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010356a:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
f0103570:	89 d8                	mov    %ebx,%eax
f0103572:	e8 ba d7 ff ff       	call   f0100d31 <check_va2pa>
f0103577:	8b 15 ac 1e 27 f0    	mov    0xf0271eac,%edx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010357d:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0103583:	77 20                	ja     f01035a5 <mem_init+0x1903>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103585:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103589:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0103590:	f0 
f0103591:	c7 44 24 04 af 03 00 	movl   $0x3af,0x4(%esp)
f0103598:	00 
f0103599:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01035a0:	e8 e0 ca ff ff       	call   f0100085 <_panic>
f01035a5:	8d 94 32 00 00 00 10 	lea    0x10000000(%edx,%esi,1),%edx
f01035ac:	39 d0                	cmp    %edx,%eax
f01035ae:	74 24                	je     f01035d4 <mem_init+0x1932>
f01035b0:	c7 44 24 0c f8 8c 10 	movl   $0xf0108cf8,0xc(%esp)
f01035b7:	f0 
f01035b8:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01035bf:	f0 
f01035c0:	c7 44 24 04 af 03 00 	movl   $0x3af,0x4(%esp)
f01035c7:	00 
f01035c8:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01035cf:	e8 b1 ca ff ff       	call   f0100085 <_panic>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f01035d4:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01035da:	39 f7                	cmp    %esi,%edi
f01035dc:	77 8c                	ja     f010356a <mem_init+0x18c8>
f01035de:	be 00 00 00 00       	mov    $0x0,%esi
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01035e3:	8d 96 00 00 c0 ee    	lea    -0x11400000(%esi),%edx
f01035e9:	89 d8                	mov    %ebx,%eax
f01035eb:	e8 41 d7 ff ff       	call   f0100d31 <check_va2pa>
f01035f0:	8b 15 38 12 27 f0    	mov    0xf0271238,%edx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01035f6:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01035fc:	77 20                	ja     f010361e <mem_init+0x197c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01035fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103602:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0103609:	f0 
f010360a:	c7 44 24 04 b4 03 00 	movl   $0x3b4,0x4(%esp)
f0103611:	00 
f0103612:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0103619:	e8 67 ca ff ff       	call   f0100085 <_panic>
f010361e:	8d 94 32 00 00 00 10 	lea    0x10000000(%edx,%esi,1),%edx
f0103625:	39 d0                	cmp    %edx,%eax
f0103627:	74 24                	je     f010364d <mem_init+0x19ab>
f0103629:	c7 44 24 0c 2c 8d 10 	movl   $0xf0108d2c,0xc(%esp)
f0103630:	f0 
f0103631:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0103638:	f0 
f0103639:	c7 44 24 04 b4 03 00 	movl   $0x3b4,0x4(%esp)
f0103640:	00 
f0103641:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0103648:	e8 38 ca ff ff       	call   f0100085 <_panic>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f010364d:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103653:	81 fe 00 f0 01 00    	cmp    $0x1f000,%esi
f0103659:	75 88                	jne    f01035e3 <mem_init+0x1941>
f010365b:	be 00 00 00 00       	mov    $0x0,%esi
f0103660:	eb 3b                	jmp    f010369d <mem_init+0x19fb>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0103662:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f0103668:	89 d8                	mov    %ebx,%eax
f010366a:	e8 c2 d6 ff ff       	call   f0100d31 <check_va2pa>
f010366f:	39 c6                	cmp    %eax,%esi
f0103671:	74 24                	je     f0103697 <mem_init+0x19f5>
f0103673:	c7 44 24 0c 60 8d 10 	movl   $0xf0108d60,0xc(%esp)
f010367a:	f0 
f010367b:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0103682:	f0 
f0103683:	c7 44 24 04 b8 03 00 	movl   $0x3b8,0x4(%esp)
f010368a:	00 
f010368b:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0103692:	e8 ee c9 ff ff       	call   f0100085 <_panic>
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103697:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010369d:	a1 a4 1e 27 f0       	mov    0xf0271ea4,%eax
f01036a2:	c1 e0 0c             	shl    $0xc,%eax
f01036a5:	39 c6                	cmp    %eax,%esi
f01036a7:	72 b9                	jb     f0103662 <mem_init+0x19c0>
f01036a9:	c7 45 d0 00 00 ff ef 	movl   $0xefff0000,-0x30(%ebp)

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01036b0:	89 df                	mov    %ebx,%edi
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01036b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01036b5:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01036b8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f01036bb:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f01036c1:	89 c6                	mov    %eax,%esi
f01036c3:	81 c6 00 00 00 10    	add    $0x10000000,%esi
f01036c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01036cc:	81 c2 00 00 01 00    	add    $0x10000,%edx
f01036d2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f01036d5:	89 da                	mov    %ebx,%edx
f01036d7:	89 f8                	mov    %edi,%eax
f01036d9:	e8 53 d6 ff ff       	call   f0100d31 <check_va2pa>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01036de:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f01036e5:	77 23                	ja     f010370a <mem_init+0x1a68>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01036e7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01036ea:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f01036ee:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f01036f5:	f0 
f01036f6:	c7 44 24 04 c0 03 00 	movl   $0x3c0,0x4(%esp)
f01036fd:	00 
f01036fe:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0103705:	e8 7b c9 ff ff       	call   f0100085 <_panic>
f010370a:	39 f0                	cmp    %esi,%eax
f010370c:	74 24                	je     f0103732 <mem_init+0x1a90>
f010370e:	c7 44 24 0c 88 8d 10 	movl   $0xf0108d88,0xc(%esp)
f0103715:	f0 
f0103716:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010371d:	f0 
f010371e:	c7 44 24 04 c0 03 00 	movl   $0x3c0,0x4(%esp)
f0103725:	00 
f0103726:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010372d:	e8 53 c9 ff ff       	call   f0100085 <_panic>
f0103732:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103738:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f010373e:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0103741:	0f 85 b7 01 00 00    	jne    f01038fe <mem_init+0x1c5c>
f0103747:	bb 00 00 00 00       	mov    $0x0,%ebx
f010374c:	8b 75 d0             	mov    -0x30(%ebp),%esi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
f010374f:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f0103752:	89 f8                	mov    %edi,%eax
f0103754:	e8 d8 d5 ff ff       	call   f0100d31 <check_va2pa>
f0103759:	83 f8 ff             	cmp    $0xffffffff,%eax
f010375c:	74 24                	je     f0103782 <mem_init+0x1ae0>
f010375e:	c7 44 24 0c d0 8d 10 	movl   $0xf0108dd0,0xc(%esp)
f0103765:	f0 
f0103766:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010376d:	f0 
f010376e:	c7 44 24 04 c2 03 00 	movl   $0x3c2,0x4(%esp)
f0103775:	00 
f0103776:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010377d:	e8 03 c9 ff ff       	call   f0100085 <_panic>
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0103782:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103788:	81 fb 00 80 00 00    	cmp    $0x8000,%ebx
f010378e:	75 bf                	jne    f010374f <mem_init+0x1aad>
f0103790:	81 6d d0 00 00 01 00 	subl   $0x10000,-0x30(%ebp)
f0103797:	81 45 cc 00 80 00 00 	addl   $0x8000,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
f010379e:	81 7d d0 00 00 f7 ef 	cmpl   $0xeff70000,-0x30(%ebp)
f01037a5:	0f 85 07 ff ff ff    	jne    f01036b2 <mem_init+0x1a10>
f01037ab:	89 fb                	mov    %edi,%ebx
f01037ad:	b8 00 00 00 00       	mov    $0x0,%eax
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f01037b2:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f01037b8:	83 fa 04             	cmp    $0x4,%edx
f01037bb:	77 2e                	ja     f01037eb <mem_init+0x1b49>
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
		case PDX(MMIOBASE):
			assert(pgdir[i] & PTE_P);
f01037bd:	f6 04 83 01          	testb  $0x1,(%ebx,%eax,4)
f01037c1:	0f 85 aa 00 00 00    	jne    f0103871 <mem_init+0x1bcf>
f01037c7:	c7 44 24 0c f4 90 10 	movl   $0xf01090f4,0xc(%esp)
f01037ce:	f0 
f01037cf:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01037d6:	f0 
f01037d7:	c7 44 24 04 cd 03 00 	movl   $0x3cd,0x4(%esp)
f01037de:	00 
f01037df:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01037e6:	e8 9a c8 ff ff       	call   f0100085 <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f01037eb:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f01037f0:	76 55                	jbe    f0103847 <mem_init+0x1ba5>
				assert(pgdir[i] & PTE_P);
f01037f2:	8b 14 83             	mov    (%ebx,%eax,4),%edx
f01037f5:	f6 c2 01             	test   $0x1,%dl
f01037f8:	75 24                	jne    f010381e <mem_init+0x1b7c>
f01037fa:	c7 44 24 0c f4 90 10 	movl   $0xf01090f4,0xc(%esp)
f0103801:	f0 
f0103802:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0103809:	f0 
f010380a:	c7 44 24 04 d1 03 00 	movl   $0x3d1,0x4(%esp)
f0103811:	00 
f0103812:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0103819:	e8 67 c8 ff ff       	call   f0100085 <_panic>
				assert(pgdir[i] & PTE_W);
f010381e:	f6 c2 02             	test   $0x2,%dl
f0103821:	75 4e                	jne    f0103871 <mem_init+0x1bcf>
f0103823:	c7 44 24 0c 05 91 10 	movl   $0xf0109105,0xc(%esp)
f010382a:	f0 
f010382b:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0103832:	f0 
f0103833:	c7 44 24 04 d2 03 00 	movl   $0x3d2,0x4(%esp)
f010383a:	00 
f010383b:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f0103842:	e8 3e c8 ff ff       	call   f0100085 <_panic>
			} else
				{assert(pgdir[i] == 0);}
f0103847:	83 3c 83 00          	cmpl   $0x0,(%ebx,%eax,4)
f010384b:	74 24                	je     f0103871 <mem_init+0x1bcf>
f010384d:	c7 44 24 0c 16 91 10 	movl   $0xf0109116,0xc(%esp)
f0103854:	f0 
f0103855:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f010385c:	f0 
f010385d:	c7 44 24 04 d4 03 00 	movl   $0x3d4,0x4(%esp)
f0103864:	00 
f0103865:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f010386c:	e8 14 c8 ff ff       	call   f0100085 <_panic>
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f0103871:	83 c0 01             	add    $0x1,%eax
f0103874:	3d 00 04 00 00       	cmp    $0x400,%eax
f0103879:	0f 85 33 ff ff ff    	jne    f01037b2 <mem_init+0x1b10>
			} else
				{assert(pgdir[i] == 0);}
			break;
		}
	}
	cprintf("check_kern_pgdir() succeeded!\n");
f010387f:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0103886:	e8 74 0d 00 00       	call   f01045ff <cprintf>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f010388b:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103890:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103895:	77 20                	ja     f01038b7 <mem_init+0x1c15>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103897:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010389b:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f01038a2:	f0 
f01038a3:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
f01038aa:	00 
f01038ab:	c7 04 24 13 8e 10 f0 	movl   $0xf0108e13,(%esp)
f01038b2:	e8 ce c7 ff ff       	call   f0100085 <_panic>
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f01038b7:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f01038bd:	0f 22 d8             	mov    %eax,%cr3

	check_page_free_list(0);
f01038c0:	b8 00 00 00 00       	mov    $0x0,%eax
f01038c5:	e8 c3 d7 ff ff       	call   f010108d <check_page_free_list>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f01038ca:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
f01038cd:	0d 23 00 05 80       	or     $0x80050023,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f01038d2:	83 e0 f3             	and    $0xfffffff3,%eax
f01038d5:	0f 22 c0             	mov    %eax,%cr0
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
f01038d8:	e8 f0 df ff ff       	call   f01018cd <check_page_installed_pgdir>

}
f01038dd:	83 c4 3c             	add    $0x3c,%esp
f01038e0:	5b                   	pop    %ebx
f01038e1:	5e                   	pop    %esi
f01038e2:	5f                   	pop    %edi
f01038e3:	5d                   	pop    %ebp
f01038e4:	c3                   	ret    
		{	
			kpage = pa2page(PADDR(percpu_kstacks[i]+j));
			page_insert(kern_pgdir,kpage,(void *)percpu_stack_start,PTE_W); 
			percpu_stack_start+=PGSIZE;
		}	
		stack_start-=(KSTKSIZE+KSTKGAP);
f01038e5:	8b 7d d0             	mov    -0x30(%ebp),%edi
f01038e8:	81 ef 00 00 01 00    	sub    $0x10000,%edi
f01038ee:	89 7d d0             	mov    %edi,-0x30(%ebp)
f01038f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01038f4:	be 00 00 00 00       	mov    $0x0,%esi
f01038f9:	e9 81 fb ff ff       	jmp    f010347f <mem_init+0x17dd>
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f01038fe:	89 da                	mov    %ebx,%edx
f0103900:	89 f8                	mov    %edi,%eax
f0103902:	e8 2a d4 ff ff       	call   f0100d31 <check_va2pa>
f0103907:	e9 fe fd ff ff       	jmp    f010370a <mem_init+0x1a68>

f010390c <page_kalloc>:
//	}
	return temp;
}

void * page_kalloc(uint32_t size,int alloc_flags)
{
f010390c:	55                   	push   %ebp
f010390d:	89 e5                	mov    %esp,%ebp
f010390f:	57                   	push   %edi
f0103910:	56                   	push   %esi
f0103911:	53                   	push   %ebx
f0103912:	83 ec 2c             	sub    $0x2c,%esp
	// Fill this function in
	struct PageInfo *curr, *prev, *start_prev = NULL;	
	uint32_t alloc_size = ROUNDUP(size,PGSIZE);
f0103915:	8b 45 08             	mov    0x8(%ebp),%eax
f0103918:	05 ff 0f 00 00       	add    $0xfff,%eax
f010391d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103922:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32_t pgn = alloc_size/PGSIZE;
f0103925:	89 c6                	mov    %eax,%esi
f0103927:	c1 ee 0c             	shr    $0xc,%esi
	void * va = NULL; 
	int i = 0;
	
	for(curr=page_free_list,prev=NULL;curr;prev=curr,curr=curr->pp_link)
f010392a:	8b 1d 30 12 27 f0    	mov    0xf0271230,%ebx
f0103930:	ba 00 00 00 00       	mov    $0x0,%edx
f0103935:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f010393c:	b8 00 00 00 00       	mov    $0x0,%eax
	{ 
		if(i==pgn)break;
		
		if(prev && prev+1 != curr) 
f0103941:	bf 00 00 00 00       	mov    $0x0,%edi
	uint32_t alloc_size = ROUNDUP(size,PGSIZE);
	uint32_t pgn = alloc_size/PGSIZE;
	void * va = NULL; 
	int i = 0;
	
	for(curr=page_free_list,prev=NULL;curr;prev=curr,curr=curr->pp_link)
f0103946:	eb 1d                	jmp    f0103965 <page_kalloc+0x59>
	{ 
		if(i==pgn)break;
f0103948:	39 f2                	cmp    %esi,%edx
f010394a:	74 22                	je     f010396e <page_kalloc+0x62>
		
		if(prev && prev+1 != curr) 
f010394c:	85 c0                	test   %eax,%eax
f010394e:	74 0e                	je     f010395e <page_kalloc+0x52>
f0103950:	8d 48 08             	lea    0x8(%eax),%ecx
f0103953:	39 cb                	cmp    %ecx,%ebx
f0103955:	74 07                	je     f010395e <page_kalloc+0x52>
f0103957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010395a:	89 fa                	mov    %edi,%edx
f010395c:	eb 03                	jmp    f0103961 <page_kalloc+0x55>
		{
			start_prev = prev; i=0;
		}
		else i++;
f010395e:	83 c2 01             	add    $0x1,%edx
	uint32_t alloc_size = ROUNDUP(size,PGSIZE);
	uint32_t pgn = alloc_size/PGSIZE;
	void * va = NULL; 
	int i = 0;
	
	for(curr=page_free_list,prev=NULL;curr;prev=curr,curr=curr->pp_link)
f0103961:	89 d8                	mov    %ebx,%eax
f0103963:	8b 1b                	mov    (%ebx),%ebx
f0103965:	85 db                	test   %ebx,%ebx
f0103967:	75 df                	jne    f0103948 <page_kalloc+0x3c>
f0103969:	e9 b2 00 00 00       	jmp    f0103a20 <page_kalloc+0x114>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010396e:	89 d8                	mov    %ebx,%eax
f0103970:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f0103976:	c1 f8 03             	sar    $0x3,%eax
f0103979:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010397c:	89 c2                	mov    %eax,%edx
f010397e:	c1 ea 0c             	shr    $0xc,%edx
f0103981:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0103987:	72 20                	jb     f01039a9 <page_kalloc+0x9d>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103989:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010398d:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0103994:	f0 
f0103995:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f010399c:	00 
f010399d:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f01039a4:	e8 dc c6 ff ff       	call   f0100085 <_panic>
	return (void *)(pa + KERNBASE);
f01039a9:	2d 00 00 00 10       	sub    $0x10000000,%eax
	}

	if(curr)
	{	

		if((uintptr_t)page2kva(curr) < KERNBASE || 
f01039ae:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039b3:	76 6b                	jbe    f0103a20 <page_kalloc+0x114>
		   (uintptr_t)page2kva(curr-(pgn-1)) < KERNBASE) 
f01039b5:	b8 01 00 00 00       	mov    $0x1,%eax
f01039ba:	29 f0                	sub    %esi,%eax
f01039bc:	8d 34 c3             	lea    (%ebx,%eax,8),%esi
f01039bf:	89 f0                	mov    %esi,%eax
f01039c1:	e8 8d d5 ff ff       	call   f0100f53 <page2kva>
	}

	if(curr)
	{	

		if((uintptr_t)page2kva(curr) < KERNBASE || 
f01039c6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039cb:	76 53                	jbe    f0103a20 <page_kalloc+0x114>
		   (uintptr_t)page2kva(curr-(pgn-1)) < KERNBASE) 
		   return NULL;

		if(start_prev) start_prev->pp_link = curr->pp_link;
f01039cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01039d1:	74 09                	je     f01039dc <page_kalloc+0xd0>
f01039d3:	8b 03                	mov    (%ebx),%eax
f01039d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01039d8:	89 02                	mov    %eax,(%edx)
f01039da:	eb 07                	jmp    f01039e3 <page_kalloc+0xd7>
		else page_free_list = curr->pp_link;
f01039dc:	8b 03                	mov    (%ebx),%eax
f01039de:	a3 30 12 27 f0       	mov    %eax,0xf0271230

		for(prev=curr-(pgn-1),curr->pp_link = NULL;prev<curr;prev++) 
f01039e3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
f01039e9:	eb 09                	jmp    f01039f4 <page_kalloc+0xe8>
			prev->pp_link = NULL;
f01039eb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		   return NULL;

		if(start_prev) start_prev->pp_link = curr->pp_link;
		else page_free_list = curr->pp_link;

		for(prev=curr-(pgn-1),curr->pp_link = NULL;prev<curr;prev++) 
f01039f1:	83 c6 08             	add    $0x8,%esi
f01039f4:	39 de                	cmp    %ebx,%esi
f01039f6:	72 f3                	jb     f01039eb <page_kalloc+0xdf>
			prev->pp_link = NULL;

		va = page2kva(curr);		
f01039f8:	89 d8                	mov    %ebx,%eax
f01039fa:	e8 54 d5 ff ff       	call   f0100f53 <page2kva>
f01039ff:	89 c3                	mov    %eax,%ebx
		if(alloc_flags) memset(va,0,alloc_size);
f0103a01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0103a05:	74 1e                	je     f0103a25 <page_kalloc+0x119>
f0103a07:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103a0a:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103a0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103a15:	00 
f0103a16:	89 1c 24             	mov    %ebx,(%esp)
f0103a19:	e8 72 29 00 00       	call   f0106390 <memset>
f0103a1e:	eb 05                	jmp    f0103a25 <page_kalloc+0x119>
f0103a20:	bb 00 00 00 00       	mov    $0x0,%ebx
	}	
	return va;
}
f0103a25:	89 d8                	mov    %ebx,%eax
f0103a27:	83 c4 2c             	add    $0x2c,%esp
f0103a2a:	5b                   	pop    %ebx
f0103a2b:	5e                   	pop    %esi
f0103a2c:	5f                   	pop    %edi
f0103a2d:	5d                   	pop    %ebp
f0103a2e:	c3                   	ret    
	...

f0103a30 <env_init_percpu>:
}

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f0103a30:	55                   	push   %ebp
f0103a31:	89 e5                	mov    %esp,%ebp
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
f0103a33:	b8 88 53 12 f0       	mov    $0xf0125388,%eax
f0103a38:	0f 01 10             	lgdtl  (%eax)
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));	//volatile: assembly statement must execute where we put it
f0103a3b:	b8 23 00 00 00       	mov    $0x23,%eax
f0103a40:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0103a42:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0103a44:	b0 10                	mov    $0x10,%al
f0103a46:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0103a48:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f0103a4a:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));	//why need 0x1f??
f0103a4c:	ea 53 3a 10 f0 08 00 	ljmp   $0x8,$0xf0103a53
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
f0103a53:	b0 00                	mov    $0x0,%al
f0103a55:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
f0103a58:	5d                   	pop    %ebp
f0103a59:	c3                   	ret    

f0103a5a <env_init>:
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f0103a5a:	55                   	push   %ebp
f0103a5b:	89 e5                	mov    %esp,%ebp
f0103a5d:	53                   	push   %ebx
f0103a5e:	b8 84 ef 01 00       	mov    $0x1ef84,%eax
f0103a63:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103a68:	ba 00 04 00 00       	mov    $0x400,%edx
	// LAB 3: Your code here: Set up envs array
	size_t i;
	for(i=NENV,env_free_list=NULL;i>0;)
	{
		i--;
f0103a6d:	83 ea 01             	sub    $0x1,%edx
		envs[i].env_id = i;	//no need to specifically initialize env_status since ENV_FREE = 0;
f0103a70:	8b 1d 38 12 27 f0    	mov    0xf0271238,%ebx
f0103a76:	89 54 03 48          	mov    %edx,0x48(%ebx,%eax,1)
		envs[i].env_link = env_free_list;
f0103a7a:	8b 1d 38 12 27 f0    	mov    0xf0271238,%ebx
f0103a80:	89 4c 03 44          	mov    %ecx,0x44(%ebx,%eax,1)
		envs[i].env_status = ENV_FREE;
f0103a84:	8b 0d 38 12 27 f0    	mov    0xf0271238,%ecx
f0103a8a:	c7 44 01 54 00 00 00 	movl   $0x0,0x54(%ecx,%eax,1)
f0103a91:	00 
		env_free_list = &envs[i];
f0103a92:	89 c1                	mov    %eax,%ecx
f0103a94:	03 0d 38 12 27 f0    	add    0xf0271238,%ecx
f0103a9a:	83 e8 7c             	sub    $0x7c,%eax
void
env_init(void)
{
	// LAB 3: Your code here: Set up envs array
	size_t i;
	for(i=NENV,env_free_list=NULL;i>0;)
f0103a9d:	85 d2                	test   %edx,%edx
f0103a9f:	75 cc                	jne    f0103a6d <env_init+0x13>
f0103aa1:	89 0d 3c 12 27 f0    	mov    %ecx,0xf027123c
		envs[i].env_status = ENV_FREE;
		env_free_list = &envs[i];
	}

	// Per-CPU part of the initialization
	env_init_percpu();
f0103aa7:	e8 84 ff ff ff       	call   f0103a30 <env_init_percpu>
}
f0103aac:	5b                   	pop    %ebx
f0103aad:	5d                   	pop    %ebp
f0103aae:	c3                   	ret    

f0103aaf <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0103aaf:	55                   	push   %ebp
f0103ab0:	89 e5                	mov    %esp,%ebp
f0103ab2:	83 ec 18             	sub    $0x18,%esp
f0103ab5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0103ab8:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0103abb:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0103abe:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ac1:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103ac4:	0f b6 55 10          	movzbl 0x10(%ebp),%edx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103ac8:	85 c0                	test   %eax,%eax
f0103aca:	75 17                	jne    f0103ae3 <envid2env+0x34>
		*env_store = curenv;
f0103acc:	e8 35 2f 00 00       	call   f0106a06 <cpunum>
f0103ad1:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ad4:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0103ada:	89 06                	mov    %eax,(%esi)
f0103adc:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
f0103ae1:	eb 67                	jmp    f0103b4a <envid2env+0x9b>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f0103ae3:	89 c3                	mov    %eax,%ebx
f0103ae5:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103aeb:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103aee:	03 1d 38 12 27 f0    	add    0xf0271238,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103af4:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103af8:	74 05                	je     f0103aff <envid2env+0x50>
f0103afa:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103afd:	74 0d                	je     f0103b0c <envid2env+0x5d>
		*env_store = 0;
f0103aff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
f0103b05:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return -E_BAD_ENV;
f0103b0a:	eb 3e                	jmp    f0103b4a <envid2env+0x9b>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103b0c:	84 d2                	test   %dl,%dl
f0103b0e:	74 33                	je     f0103b43 <envid2env+0x94>
f0103b10:	e8 f1 2e 00 00       	call   f0106a06 <cpunum>
f0103b15:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b18:	39 98 28 20 27 f0    	cmp    %ebx,-0xfd8dfd8(%eax)
f0103b1e:	74 23                	je     f0103b43 <envid2env+0x94>
f0103b20:	8b 7b 4c             	mov    0x4c(%ebx),%edi
f0103b23:	e8 de 2e 00 00       	call   f0106a06 <cpunum>
f0103b28:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b2b:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0103b31:	3b 78 48             	cmp    0x48(%eax),%edi
f0103b34:	74 0d                	je     f0103b43 <envid2env+0x94>
		*env_store = 0;
f0103b36:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
f0103b3c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return -E_BAD_ENV;
f0103b41:	eb 07                	jmp    f0103b4a <envid2env+0x9b>
	}

	*env_store = e;
f0103b43:	89 1e                	mov    %ebx,(%esi)
f0103b45:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
f0103b4a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0103b4d:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0103b50:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0103b53:	89 ec                	mov    %ebp,%esp
f0103b55:	5d                   	pop    %ebp
f0103b56:	c3                   	ret    

f0103b57 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103b57:	55                   	push   %ebp
f0103b58:	89 e5                	mov    %esp,%ebp
f0103b5a:	53                   	push   %ebx
f0103b5b:	83 ec 14             	sub    $0x14,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103b5e:	e8 a3 2e 00 00       	call   f0106a06 <cpunum>
f0103b63:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b66:	8b 98 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%ebx
f0103b6c:	e8 95 2e 00 00       	call   f0106a06 <cpunum>
f0103b71:	89 43 5c             	mov    %eax,0x5c(%ebx)

static __inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	__asm __volatile("pushfl; popl %0" : "=r" (eflags));
f0103b74:	9c                   	pushf  
f0103b75:	58                   	pop    %eax
	//cprintf("%s curr cpu %d env %x\n",__func__,cpunum(),curenv->env_id);
	//print_env(curenv);	
	assert(!(read_eflags() & FL_IF));
f0103b76:	f6 c4 02             	test   $0x2,%ah
f0103b79:	74 24                	je     f0103b9f <env_pop_tf+0x48>
f0103b7b:	c7 44 24 0c fc 7e 10 	movl   $0xf0107efc,0xc(%esp)
f0103b82:	f0 
f0103b83:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0103b8a:	f0 
f0103b8b:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
f0103b92:	00 
f0103b93:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f0103b9a:	e8 e6 c4 ff ff       	call   f0100085 <_panic>
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103b9f:	c7 04 24 a0 53 12 f0 	movl   $0xf01253a0,(%esp)
f0103ba6:	e8 15 31 00 00       	call   f0106cc0 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103bab:	f3 90                	pause  
	unlock_kernel();	
	__asm __volatile("movl %0,%%esp\n"
f0103bad:	8b 65 08             	mov    0x8(%ebp),%esp
f0103bb0:	61                   	popa   
f0103bb1:	07                   	pop    %es
f0103bb2:	1f                   	pop    %ds
f0103bb3:	83 c4 08             	add    $0x8,%esp
f0103bb6:	f0 cf                	lock iret 
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tlock iret"
		: : "g" (tf) : "memory");
	panic("iret failed");  	/* mostly to placate the compiler */
f0103bb8:	c7 44 24 08 2f 91 10 	movl   $0xf010912f,0x8(%esp)
f0103bbf:	f0 
f0103bc0:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
f0103bc7:	00 
f0103bc8:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f0103bcf:	e8 b1 c4 ff ff       	call   f0100085 <_panic>

f0103bd4 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103bd4:	55                   	push   %ebp
f0103bd5:	89 e5                	mov    %esp,%ebp
f0103bd7:	53                   	push   %ebx
f0103bd8:	83 ec 14             	sub    $0x14,%esp
	// Step 1: If this is a context switch (a new environment is running):
	//	   1. Set the current environment (if any) back to
	//	      ENV_RUNNABLE if it is ENV_RUNNING (think about
	//	      what other states it can be in),
	if(curenv && curenv->env_status == ENV_RUNNING) 
f0103bdb:	e8 26 2e 00 00       	call   f0106a06 <cpunum>
f0103be0:	6b c0 74             	imul   $0x74,%eax,%eax
f0103be3:	83 b8 28 20 27 f0 00 	cmpl   $0x0,-0xfd8dfd8(%eax)
f0103bea:	74 29                	je     f0103c15 <env_run+0x41>
f0103bec:	e8 15 2e 00 00       	call   f0106a06 <cpunum>
f0103bf1:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bf4:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0103bfa:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103bfe:	75 15                	jne    f0103c15 <env_run+0x41>
		curenv->env_status = ENV_RUNNABLE;
f0103c00:	e8 01 2e 00 00       	call   f0106a06 <cpunum>
f0103c05:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c08:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0103c0e:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	//	   2. Set 'curenv' to the new environment,
	//	   3. Set its status to ENV_RUNNING,
	curenv = e; curenv->env_status = ENV_RUNNING;	
f0103c15:	e8 ec 2d 00 00       	call   f0106a06 <cpunum>
f0103c1a:	bb 20 20 27 f0       	mov    $0xf0272020,%ebx
f0103c1f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c22:	8b 55 08             	mov    0x8(%ebp),%edx
f0103c25:	89 54 18 08          	mov    %edx,0x8(%eax,%ebx,1)
f0103c29:	e8 d8 2d 00 00       	call   f0106a06 <cpunum>
f0103c2e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c31:	8b 44 18 08          	mov    0x8(%eax,%ebx,1),%eax
f0103c35:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	//	   4. Update its 'env_runs' counter,
	curenv->env_runs++;
f0103c3c:	e8 c5 2d 00 00       	call   f0106a06 <cpunum>
f0103c41:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c44:	8b 44 18 08          	mov    0x8(%eax,%ebx,1),%eax
f0103c48:	83 40 58 01          	addl   $0x1,0x58(%eax)
	//cprintf("curenv->env_pgdir=%x e->env_pgdir=%x\n",curenv->env_pgdir,e->env_pgdir);	
	//	   5. Use lcr3() to switch to its address space.
	lcr3(PADDR(curenv->env_pgdir)); 	
f0103c4c:	e8 b5 2d 00 00       	call   f0106a06 <cpunum>
f0103c51:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c54:	8b 44 18 08          	mov    0x8(%eax,%ebx,1),%eax
f0103c58:	8b 40 60             	mov    0x60(%eax),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103c5b:	89 c2                	mov    %eax,%edx
f0103c5d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c62:	77 20                	ja     f0103c84 <env_run+0xb0>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103c64:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103c68:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0103c6f:	f0 
f0103c70:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
f0103c77:	00 
f0103c78:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f0103c7f:	e8 01 c4 ff ff       	call   f0100085 <_panic>
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103c84:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0103c8a:	0f 22 da             	mov    %edx,%cr3
	//	   registers and drop into user mode in the
	//	   environment.
	//((void (*)(void)) (curenv->env_tf.tf_eip))();
	//print_env(e);
	//cprintf("%s switch to %x!\n\n",__func__,e->env_id);
	env_pop_tf(&(curenv->env_tf));
f0103c8d:	e8 74 2d 00 00       	call   f0106a06 <cpunum>
f0103c92:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c95:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0103c9b:	89 04 24             	mov    %eax,(%esp)
f0103c9e:	e8 b4 fe ff ff       	call   f0103b57 <env_pop_tf>

f0103ca3 <print_env>:

	return 0;
}

void print_env(struct Env *e)
{
f0103ca3:	55                   	push   %ebp
f0103ca4:	89 e5                	mov    %esp,%ebp
f0103ca6:	53                   	push   %ebx
f0103ca7:	83 ec 14             	sub    $0x14,%esp
f0103caa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("tf_es = %x\n",e->env_tf.tf_es);
f0103cad:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103cb5:	c7 04 24 3b 91 10 f0 	movl   $0xf010913b,(%esp)
f0103cbc:	e8 3e 09 00 00       	call   f01045ff <cprintf>
	cprintf("tf_ds = %x\n",e->env_tf.tf_ds);
f0103cc1:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103cc9:	c7 04 24 47 91 10 f0 	movl   $0xf0109147,(%esp)
f0103cd0:	e8 2a 09 00 00       	call   f01045ff <cprintf>
	cprintf("tf_cs = %x\n",e->env_tf.tf_cs);	
f0103cd5:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103cdd:	c7 04 24 53 91 10 f0 	movl   $0xf0109153,(%esp)
f0103ce4:	e8 16 09 00 00       	call   f01045ff <cprintf>
	cprintf("tf_eip = %x\n",e->env_tf.tf_eip);
f0103ce9:	8b 43 30             	mov    0x30(%ebx),%eax
f0103cec:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103cf0:	c7 04 24 5f 91 10 f0 	movl   $0xf010915f,(%esp)
f0103cf7:	e8 03 09 00 00       	call   f01045ff <cprintf>
	cprintf("tf_eflags = %x\n",e->env_tf.tf_eflags);
f0103cfc:	8b 43 38             	mov    0x38(%ebx),%eax
f0103cff:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103d03:	c7 04 24 6c 91 10 f0 	movl   $0xf010916c,(%esp)
f0103d0a:	e8 f0 08 00 00       	call   f01045ff <cprintf>
	cprintf("tf_esp = %x\n",e->env_tf.tf_esp);
f0103d0f:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103d12:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103d16:	c7 04 24 7c 91 10 f0 	movl   $0xf010917c,(%esp)
f0103d1d:	e8 dd 08 00 00       	call   f01045ff <cprintf>
	cprintf("tf_ss = %x\n",e->env_tf.tf_ss);
f0103d22:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103d26:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103d2a:	c7 04 24 89 91 10 f0 	movl   $0xf0109189,(%esp)
f0103d31:	e8 c9 08 00 00       	call   f01045ff <cprintf>
	//cprintf("env_pgdir = %x\n",PADDR(e->env_pgdir));
}
f0103d36:	83 c4 14             	add    $0x14,%esp
f0103d39:	5b                   	pop    %ebx
f0103d3a:	5d                   	pop    %ebp
f0103d3b:	c3                   	ret    

f0103d3c <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103d3c:	55                   	push   %ebp
f0103d3d:	89 e5                	mov    %esp,%ebp
f0103d3f:	57                   	push   %edi
f0103d40:	56                   	push   %esi
f0103d41:	53                   	push   %ebx
f0103d42:	83 ec 2c             	sub    $0x2c,%esp
f0103d45:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103d48:	e8 b9 2c 00 00       	call   f0106a06 <cpunum>
f0103d4d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d50:	39 b8 28 20 27 f0    	cmp    %edi,-0xfd8dfd8(%eax)
f0103d56:	75 35                	jne    f0103d8d <env_free+0x51>
		lcr3(PADDR(kern_pgdir));
f0103d58:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103d5d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103d62:	77 20                	ja     f0103d84 <env_free+0x48>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103d64:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103d68:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0103d6f:	f0 
f0103d70:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
f0103d77:	00 
f0103d78:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f0103d7f:	e8 01 c3 ff ff       	call   f0100085 <_panic>
f0103d84:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f0103d8a:	0f 22 d8             	mov    %eax,%cr3

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103d8d:	8b 5f 48             	mov    0x48(%edi),%ebx
f0103d90:	e8 71 2c 00 00       	call   f0106a06 <cpunum>
f0103d95:	6b d0 74             	imul   $0x74,%eax,%edx
f0103d98:	b8 00 00 00 00       	mov    $0x0,%eax
f0103d9d:	83 ba 28 20 27 f0 00 	cmpl   $0x0,-0xfd8dfd8(%edx)
f0103da4:	74 11                	je     f0103db7 <env_free+0x7b>
f0103da6:	e8 5b 2c 00 00       	call   f0106a06 <cpunum>
f0103dab:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dae:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0103db4:	8b 40 48             	mov    0x48(%eax),%eax
f0103db7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0103dbb:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103dbf:	c7 04 24 95 91 10 f0 	movl   $0xf0109195,(%esp)
f0103dc6:	e8 34 08 00 00       	call   f01045ff <cprintf>
f0103dcb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103dd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103dd5:	c1 e0 02             	shl    $0x2,%eax
f0103dd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103ddb:	8b 47 60             	mov    0x60(%edi),%eax
f0103dde:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103de1:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103de4:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103dea:	0f 84 b8 00 00 00    	je     f0103ea8 <env_free+0x16c>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103df0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103df6:	89 f0                	mov    %esi,%eax
f0103df8:	c1 e8 0c             	shr    $0xc,%eax
f0103dfb:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103dfe:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f0103e04:	72 20                	jb     f0103e26 <env_free+0xea>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103e06:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0103e0a:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0103e11:	f0 
f0103e12:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
f0103e19:	00 
f0103e1a:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f0103e21:	e8 5f c2 ff ff       	call   f0100085 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103e26:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103e29:	c1 e2 16             	shl    $0x16,%edx
f0103e2c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103e2f:	bb 00 00 00 00       	mov    $0x0,%ebx
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
f0103e34:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f0103e3b:	01 
f0103e3c:	74 17                	je     f0103e55 <env_free+0x119>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103e3e:	89 d8                	mov    %ebx,%eax
f0103e40:	c1 e0 0c             	shl    $0xc,%eax
f0103e43:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103e46:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103e4a:	8b 47 60             	mov    0x60(%edi),%eax
f0103e4d:	89 04 24             	mov    %eax,(%esp)
f0103e50:	e8 3d d9 ff ff       	call   f0101792 <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103e55:	83 c3 01             	add    $0x1,%ebx
f0103e58:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103e5e:	75 d4                	jne    f0103e34 <env_free+0xf8>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103e60:	8b 47 60             	mov    0x60(%edi),%eax
f0103e63:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103e66:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103e6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103e70:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f0103e76:	72 1c                	jb     f0103e94 <env_free+0x158>
		panic("pa2page called with invalid pa");
f0103e78:	c7 44 24 08 28 86 10 	movl   $0xf0108628,0x8(%esp)
f0103e7f:	f0 
f0103e80:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0103e87:	00 
f0103e88:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0103e8f:	e8 f1 c1 ff ff       	call   f0100085 <_panic>
		page_decref(pa2page(pa));
f0103e94:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103e97:	c1 e0 03             	shl    $0x3,%eax
f0103e9a:	03 05 ac 1e 27 f0    	add    0xf0271eac,%eax
f0103ea0:	89 04 24             	mov    %eax,(%esp)
f0103ea3:	e8 2f cf ff ff       	call   f0100dd7 <page_decref>
	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103ea8:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0103eac:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f0103eb3:	0f 85 19 ff ff ff    	jne    f0103dd2 <env_free+0x96>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103eb9:	8b 47 60             	mov    0x60(%edi),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103ebc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103ec1:	77 20                	ja     f0103ee3 <env_free+0x1a7>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103ec3:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103ec7:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0103ece:	f0 
f0103ecf:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
f0103ed6:	00 
f0103ed7:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f0103ede:	e8 a2 c1 ff ff       	call   f0100085 <_panic>
	e->env_pgdir = 0;
f0103ee3:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103eea:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f0103ef0:	c1 e8 0c             	shr    $0xc,%eax
f0103ef3:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f0103ef9:	72 1c                	jb     f0103f17 <env_free+0x1db>
		panic("pa2page called with invalid pa");
f0103efb:	c7 44 24 08 28 86 10 	movl   $0xf0108628,0x8(%esp)
f0103f02:	f0 
f0103f03:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0103f0a:	00 
f0103f0b:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0103f12:	e8 6e c1 ff ff       	call   f0100085 <_panic>
	page_decref(pa2page(pa));
f0103f17:	c1 e0 03             	shl    $0x3,%eax
f0103f1a:	03 05 ac 1e 27 f0    	add    0xf0271eac,%eax
f0103f20:	89 04 24             	mov    %eax,(%esp)
f0103f23:	e8 af ce ff ff       	call   f0100dd7 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103f28:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103f2f:	a1 3c 12 27 f0       	mov    0xf027123c,%eax
f0103f34:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103f37:	89 3d 3c 12 27 f0    	mov    %edi,0xf027123c
}
f0103f3d:	83 c4 2c             	add    $0x2c,%esp
f0103f40:	5b                   	pop    %ebx
f0103f41:	5e                   	pop    %esi
f0103f42:	5f                   	pop    %edi
f0103f43:	5d                   	pop    %ebp
f0103f44:	c3                   	ret    

f0103f45 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103f45:	55                   	push   %ebp
f0103f46:	89 e5                	mov    %esp,%ebp
f0103f48:	53                   	push   %ebx
f0103f49:	83 ec 14             	sub    $0x14,%esp
f0103f4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103f4f:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103f53:	75 19                	jne    f0103f6e <env_destroy+0x29>
f0103f55:	e8 ac 2a 00 00       	call   f0106a06 <cpunum>
f0103f5a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f5d:	39 98 28 20 27 f0    	cmp    %ebx,-0xfd8dfd8(%eax)
f0103f63:	74 09                	je     f0103f6e <env_destroy+0x29>
		e->env_status = ENV_DYING;
f0103f65:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103f6c:	eb 2f                	jmp    f0103f9d <env_destroy+0x58>
	}

	env_free(e);
f0103f6e:	89 1c 24             	mov    %ebx,(%esp)
f0103f71:	e8 c6 fd ff ff       	call   f0103d3c <env_free>

	if (curenv == e) {
f0103f76:	e8 8b 2a 00 00       	call   f0106a06 <cpunum>
f0103f7b:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f7e:	39 98 28 20 27 f0    	cmp    %ebx,-0xfd8dfd8(%eax)
f0103f84:	75 17                	jne    f0103f9d <env_destroy+0x58>
		curenv = NULL;
f0103f86:	e8 7b 2a 00 00       	call   f0106a06 <cpunum>
f0103f8b:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f8e:	c7 80 28 20 27 f0 00 	movl   $0x0,-0xfd8dfd8(%eax)
f0103f95:	00 00 00 
		sched_yield();
f0103f98:	e8 fe 10 00 00       	call   f010509b <sched_yield>
	}
}
f0103f9d:	83 c4 14             	add    $0x14,%esp
f0103fa0:	5b                   	pop    %ebx
f0103fa1:	5d                   	pop    %ebp
f0103fa2:	c3                   	ret    

f0103fa3 <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103fa3:	55                   	push   %ebp
f0103fa4:	89 e5                	mov    %esp,%ebp
f0103fa6:	53                   	push   %ebx
f0103fa7:	83 ec 14             	sub    $0x14,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f0103faa:	8b 1d 3c 12 27 f0    	mov    0xf027123c,%ebx
f0103fb0:	ba fb ff ff ff       	mov    $0xfffffffb,%edx
f0103fb5:	85 db                	test   %ebx,%ebx
f0103fb7:	0f 84 be 01 00 00    	je     f010417b <env_alloc+0x1d8>
{
	size_t i, offset;
	struct PageInfo *p = NULL;
	
	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103fbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0103fc4:	e8 29 d4 ff ff       	call   f01013f2 <page_alloc>
f0103fc9:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
f0103fce:	85 c0                	test   %eax,%eax
f0103fd0:	0f 84 a5 01 00 00    	je     f010417b <env_alloc+0x1d8>
		return -E_NO_MEM;

	// Now, set e->env_pgdir and initialize the page directory.
	p->pp_ref++; 
f0103fd6:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103fdb:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f0103fe1:	c1 f8 03             	sar    $0x3,%eax
f0103fe4:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103fe7:	89 c2                	mov    %eax,%edx
f0103fe9:	c1 ea 0c             	shr    $0xc,%edx
f0103fec:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0103ff2:	72 20                	jb     f0104014 <env_alloc+0x71>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103ff4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103ff8:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0103fff:	f0 
f0104000:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0104007:	00 
f0104008:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f010400f:	e8 71 c0 ff ff       	call   f0100085 <_panic>
	e->env_pgdir = (pde_t *)page2kva(p);
f0104014:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0104019:	89 43 60             	mov    %eax,0x60(%ebx)
//	cprintf("e->env_pgdir = %x\n",e->env_pgdir);
	memset(e->env_pgdir,0,PGSIZE);
f010401c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0104023:	00 
f0104024:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010402b:	00 
f010402c:	89 04 24             	mov    %eax,(%esp)
f010402f:	e8 5c 23 00 00       	call   f0106390 <memset>
	//	physical pages mapped only above UTOP, but env_pgdir
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.
	offset = PDX(UTOP);
	memcpy((void *)(e->env_pgdir+offset),(void *)(kern_pgdir+offset),(NPDENTRIES-offset)*sizeof(pde_t));		
f0104034:	c7 44 24 08 14 01 00 	movl   $0x114,0x8(%esp)
f010403b:	00 
f010403c:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
f0104041:	05 ec 0e 00 00       	add    $0xeec,%eax
f0104046:	89 44 24 04          	mov    %eax,0x4(%esp)
f010404a:	8b 43 60             	mov    0x60(%ebx),%eax
f010404d:	05 ec 0e 00 00       	add    $0xeec,%eax
f0104052:	89 04 24             	mov    %eax,(%esp)
f0104055:	e8 11 24 00 00       	call   f010646b <memcpy>

	// LAB 3: Your code here.

	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f010405a:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010405d:	89 c2                	mov    %eax,%edx
f010405f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104064:	77 20                	ja     f0104086 <env_alloc+0xe3>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104066:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010406a:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0104071:	f0 
f0104072:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
f0104079:	00 
f010407a:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f0104081:	e8 ff bf ff ff       	call   f0100085 <_panic>
f0104086:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f010408c:	83 ca 05             	or     $0x5,%edx
f010408f:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0104095:	8b 43 48             	mov    0x48(%ebx),%eax
f0104098:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f010409d:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f01040a2:	ba 00 10 00 00       	mov    $0x1000,%edx
f01040a7:	0f 4e c2             	cmovle %edx,%eax
		generation = 1 << ENVGENSHIFT;
	e->env_id = generation | (e - envs);
f01040aa:	89 da                	mov    %ebx,%edx
f01040ac:	2b 15 38 12 27 f0    	sub    0xf0271238,%edx
f01040b2:	c1 fa 02             	sar    $0x2,%edx
f01040b5:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01040bb:	09 d0                	or     %edx,%eax
f01040bd:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f01040c0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01040c3:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01040c6:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01040cd:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01040d4:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01040db:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f01040e2:	00 
f01040e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01040ea:	00 
f01040eb:	89 1c 24             	mov    %ebx,(%esp)
f01040ee:	e8 9d 22 00 00       	call   f0106390 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f01040f3:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01040f9:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01040ff:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0104105:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;	
f010410c:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_regs.reg_ebp = e->env_tf.tf_esp;
f0104112:	c7 43 08 00 e0 bf ee 	movl   $0xeebfe000,0x8(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags = FL_IF;
f0104119:	c7 43 38 00 02 00 00 	movl   $0x200,0x38(%ebx)
	
	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = NULL;
f0104120:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0104127:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f010412b:	8b 43 44             	mov    0x44(%ebx),%eax
f010412e:	a3 3c 12 27 f0       	mov    %eax,0xf027123c
	*newenv_store = e;
f0104133:	8b 45 08             	mov    0x8(%ebp),%eax
f0104136:	89 18                	mov    %ebx,(%eax)

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0104138:	8b 5b 48             	mov    0x48(%ebx),%ebx
f010413b:	e8 c6 28 00 00       	call   f0106a06 <cpunum>
f0104140:	6b c0 74             	imul   $0x74,%eax,%eax
f0104143:	ba 00 00 00 00       	mov    $0x0,%edx
f0104148:	83 b8 28 20 27 f0 00 	cmpl   $0x0,-0xfd8dfd8(%eax)
f010414f:	74 11                	je     f0104162 <env_alloc+0x1bf>
f0104151:	e8 b0 28 00 00       	call   f0106a06 <cpunum>
f0104156:	6b c0 74             	imul   $0x74,%eax,%eax
f0104159:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f010415f:	8b 50 48             	mov    0x48(%eax),%edx
f0104162:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0104166:	89 54 24 04          	mov    %edx,0x4(%esp)
f010416a:	c7 04 24 ab 91 10 f0 	movl   $0xf01091ab,(%esp)
f0104171:	e8 89 04 00 00       	call   f01045ff <cprintf>
f0104176:	ba 00 00 00 00       	mov    $0x0,%edx
	//print_env(e);
	return 0;
}
f010417b:	89 d0                	mov    %edx,%eax
f010417d:	83 c4 14             	add    $0x14,%esp
f0104180:	5b                   	pop    %ebx
f0104181:	5d                   	pop    %ebp
f0104182:	c3                   	ret    

f0104183 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0104183:	55                   	push   %ebp
f0104184:	89 e5                	mov    %esp,%ebp
f0104186:	57                   	push   %edi
f0104187:	56                   	push   %esi
f0104188:	53                   	push   %ebx
f0104189:	83 ec 3c             	sub    $0x3c,%esp
f010418c:	89 c6                	mov    %eax,%esi
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	size_t i = 0;
	struct PageInfo * pp;	
	pte_t * pte_store;
	char * aligned_start = ROUNDDOWN((char *)va,PGSIZE);
f010418e:	89 d3                	mov    %edx,%ebx
f0104190:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	char * aligned_end = ROUNDUP((char *)(va+len),PGSIZE);
f0104196:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f010419d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01041a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//cprintf("start address=%x end address =%x diff=%u\n",aligned_start,aligned_end,(aligned_end-aligned_start));
	for(i=(size_t)aligned_start;i<(size_t)aligned_end;i+=PGSIZE)
f01041a5:	e9 8b 00 00 00       	jmp    f0104235 <region_alloc+0xb2>
	{
		if((pp = page_lookup(e->env_pgdir,(void *)i,&pte_store))) 
f01041aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01041ad:	89 44 24 08          	mov    %eax,0x8(%esp)
f01041b1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01041b5:	8b 46 60             	mov    0x60(%esi),%eax
f01041b8:	89 04 24             	mov    %eax,(%esp)
f01041bb:	e8 61 d5 ff ff       	call   f0101721 <page_lookup>
f01041c0:	85 c0                	test   %eax,%eax
f01041c2:	74 22                	je     f01041e6 <region_alloc+0x63>
		{ cprintf("no need to alloc virtual address=%x at physical address=%x\n",i,page2pa(pp)); continue;}
f01041c4:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f01041ca:	c1 f8 03             	sar    $0x3,%eax
f01041cd:	c1 e0 0c             	shl    $0xc,%eax
f01041d0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01041d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01041d8:	c7 04 24 dc 91 10 f0 	movl   $0xf01091dc,(%esp)
f01041df:	e8 1b 04 00 00       	call   f01045ff <cprintf>
f01041e4:	eb 49                	jmp    f010422f <region_alloc+0xac>
		pp = page_alloc(0);
f01041e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01041ed:	e8 00 d2 ff ff       	call   f01013f2 <page_alloc>
		//cprintf("alloc virtual address=%x physical address=%x\n",i,page2pa(pp));		
		if(pp) page_insert(e->env_pgdir,pp,(void *)i,PTE_U | PTE_W);
f01041f2:	85 c0                	test   %eax,%eax
f01041f4:	74 1d                	je     f0104213 <region_alloc+0x90>
f01041f6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f01041fd:	00 
f01041fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0104202:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104206:	8b 46 60             	mov    0x60(%esi),%eax
f0104209:	89 04 24             	mov    %eax,(%esp)
f010420c:	e8 d9 d5 ff ff       	call   f01017ea <page_insert>
f0104211:	eb 1c                	jmp    f010422f <region_alloc+0xac>
		else panic("no free page can be allocated in region_alloc\n");
f0104213:	c7 44 24 08 18 92 10 	movl   $0xf0109218,0x8(%esp)
f010421a:	f0 
f010421b:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
f0104222:	00 
f0104223:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f010422a:	e8 56 be ff ff       	call   f0100085 <_panic>
	pte_t * pte_store;
	char * aligned_start = ROUNDDOWN((char *)va,PGSIZE);
	char * aligned_end = ROUNDUP((char *)(va+len),PGSIZE);

	//cprintf("start address=%x end address =%x diff=%u\n",aligned_start,aligned_end,(aligned_end-aligned_start));
	for(i=(size_t)aligned_start;i<(size_t)aligned_end;i+=PGSIZE)
f010422f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0104235:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0104238:	0f 82 6c ff ff ff    	jb     f01041aa <region_alloc+0x27>
		pp = page_alloc(0);
		//cprintf("alloc virtual address=%x physical address=%x\n",i,page2pa(pp));		
		if(pp) page_insert(e->env_pgdir,pp,(void *)i,PTE_U | PTE_W);
		else panic("no free page can be allocated in region_alloc\n");
	}	
}
f010423e:	83 c4 3c             	add    $0x3c,%esp
f0104241:	5b                   	pop    %ebx
f0104242:	5e                   	pop    %esi
f0104243:	5f                   	pop    %edi
f0104244:	5d                   	pop    %ebp
f0104245:	c3                   	ret    

f0104246 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0104246:	55                   	push   %ebp
f0104247:	89 e5                	mov    %esp,%ebp
f0104249:	57                   	push   %edi
f010424a:	56                   	push   %esi
f010424b:	53                   	push   %ebx
f010424c:	83 ec 3c             	sub    $0x3c,%esp
f010424f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	
	struct Env* e;	env_alloc(&e,0);
f0104252:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0104259:	00 
f010425a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010425d:	89 04 24             	mov    %eax,(%esp)
f0104260:	e8 3e fd ff ff       	call   f0103fa3 <env_alloc>
	if(type == ENV_TYPE_FS) e->env_tf.tf_eflags |= FL_IOPL_3;
f0104265:	83 fb 01             	cmp    $0x1,%ebx
f0104268:	75 0a                	jne    f0104274 <env_create+0x2e>
f010426a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010426d:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
	e->env_type = type;	
f0104274:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104277:	89 58 50             	mov    %ebx,0x50(%eax)
	e->env_parent_id = 0;
f010427a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010427d:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
	load_icode(e,binary);
f0104284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104287:	89 45 d0             	mov    %eax,-0x30(%ebp)
	//  (The ELF header should have ph->p_filesz <= ph->p_memsz.)
	//  Use functions from the previous lab to allocate and map pages.

	struct Proghdr *ph, *eph;
	void * va0, *va1; int i;
	struct Elf * tmp =  (struct Elf *)binary;
f010428a:	8b 55 08             	mov    0x8(%ebp),%edx
f010428d:	89 55 c8             	mov    %edx,-0x38(%ebp)
	uint32_t cp_size,remain_size;
		
	if (tmp->e_magic != ELF_MAGIC)panic("initial binary has bad magic word\n");
f0104290:	81 3a 7f 45 4c 46    	cmpl   $0x464c457f,(%edx)
f0104296:	74 1c                	je     f01042b4 <env_create+0x6e>
f0104298:	c7 44 24 08 48 92 10 	movl   $0xf0109248,0x8(%esp)
f010429f:	f0 
f01042a0:	c7 44 24 04 74 01 00 	movl   $0x174,0x4(%esp)
f01042a7:	00 
f01042a8:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f01042af:	e8 d1 bd ff ff       	call   f0100085 <_panic>
	
	ph = (struct Proghdr *) (binary + tmp->e_phoff);	
f01042b4:	8b 7d 08             	mov    0x8(%ebp),%edi
f01042b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01042ba:	03 78 1c             	add    0x1c(%eax),%edi
	eph = ph + tmp->e_phnum;	
f01042bd:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f01042c1:	c1 e0 05             	shl    $0x5,%eax
f01042c4:	8d 04 07             	lea    (%edi,%eax,1),%eax
f01042c7:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01042ca:	e9 89 01 00 00       	jmp    f0104458 <env_create+0x212>
	for (; ph < eph; ph++)	
	{
		if(ph->p_type != ELF_PROG_LOAD) continue;
f01042cf:	83 3f 01             	cmpl   $0x1,(%edi)
f01042d2:	0f 85 7d 01 00 00    	jne    f0104455 <env_create+0x20f>
		if(ph->p_filesz > ph->p_memsz) panic ("ph->p_filesz > ph->p_memsz\n");
f01042d8:	8b 4f 14             	mov    0x14(%edi),%ecx
f01042db:	39 4f 10             	cmp    %ecx,0x10(%edi)
f01042de:	76 1c                	jbe    f01042fc <env_create+0xb6>
f01042e0:	c7 44 24 08 c0 91 10 	movl   $0xf01091c0,0x8(%esp)
f01042e7:	f0 
f01042e8:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
f01042ef:	00 
f01042f0:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f01042f7:	e8 89 bd ff ff       	call   f0100085 <_panic>
		region_alloc(e,(void *)ph->p_va,ph->p_memsz);
f01042fc:	8b 57 08             	mov    0x8(%edi),%edx
f01042ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0104302:	e8 7c fe ff ff       	call   f0104183 <region_alloc>

		va0= (void *)ph->p_va;
f0104307:	8b 57 08             	mov    0x8(%edi),%edx
f010430a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		remain_size = ph->p_filesz;
f010430d:	8b 77 10             	mov    0x10(%edi),%esi
f0104310:	e9 8d 00 00 00       	jmp    f01043a2 <env_create+0x15c>
		while(remain_size)
		{
			va1 = KADDR(PTE_ADDR(*pgdir_walk(e->env_pgdir,va0,0)))+ PGOFF(va0);
f0104315:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010431c:	00 
f010431d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104320:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104324:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0104327:	8b 42 60             	mov    0x60(%edx),%eax
f010432a:	89 04 24             	mov    %eax,(%esp)
f010432d:	e8 76 d1 ff ff       	call   f01014a8 <pgdir_walk>
f0104332:	8b 00                	mov    (%eax),%eax
f0104334:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0104339:	89 c2                	mov    %eax,%edx
f010433b:	c1 ea 0c             	shr    $0xc,%edx
f010433e:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0104344:	72 20                	jb     f0104366 <env_create+0x120>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0104346:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010434a:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0104351:	f0 
f0104352:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
f0104359:	00 
f010435a:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f0104361:	e8 1f bd ff ff       	call   f0100085 <_panic>
f0104366:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104369:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
			cp_size = (PGSIZE-PGOFF(va0))>remain_size?remain_size:(PGSIZE-PGOFF(va0));
f010436f:	bb 00 10 00 00       	mov    $0x1000,%ebx
f0104374:	29 d3                	sub    %edx,%ebx
f0104376:	39 f3                	cmp    %esi,%ebx
f0104378:	0f 47 de             	cmova  %esi,%ebx
			memcpy(va1,(void *)(binary+ph->p_offset+ph->p_filesz-remain_size),cp_size);
f010437b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010437f:	8b 4f 10             	mov    0x10(%edi),%ecx
f0104382:	03 4f 04             	add    0x4(%edi),%ecx
f0104385:	29 f1                	sub    %esi,%ecx
f0104387:	03 4d 08             	add    0x8(%ebp),%ecx
f010438a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f010438e:	8d 84 10 00 00 00 f0 	lea    -0x10000000(%eax,%edx,1),%eax
f0104395:	89 04 24             	mov    %eax,(%esp)
f0104398:	e8 ce 20 00 00       	call   f010646b <memcpy>
			//cprintf("copy %x bytes from va=%x to va=%x\n",cp_size,binary+ph->p_offset+ph->p_memsz-remain_size,va0);
			remain_size-=cp_size;va0+=cp_size;
f010439d:	29 de                	sub    %ebx,%esi
f010439f:	01 5d d4             	add    %ebx,-0x2c(%ebp)
		if(ph->p_filesz > ph->p_memsz) panic ("ph->p_filesz > ph->p_memsz\n");
		region_alloc(e,(void *)ph->p_va,ph->p_memsz);

		va0= (void *)ph->p_va;
		remain_size = ph->p_filesz;
		while(remain_size)
f01043a2:	85 f6                	test   %esi,%esi
f01043a4:	0f 85 6b ff ff ff    	jne    f0104315 <env_create+0xcf>
			cp_size = (PGSIZE-PGOFF(va0))>remain_size?remain_size:(PGSIZE-PGOFF(va0));
			memcpy(va1,(void *)(binary+ph->p_offset+ph->p_filesz-remain_size),cp_size);
			//cprintf("copy %x bytes from va=%x to va=%x\n",cp_size,binary+ph->p_offset+ph->p_memsz-remain_size,va0);
			remain_size-=cp_size;va0+=cp_size;
		}
		if(ph->p_filesz < ph->p_memsz)
f01043aa:	8b 47 10             	mov    0x10(%edi),%eax
f01043ad:	8b 77 14             	mov    0x14(%edi),%esi
f01043b0:	39 f0                	cmp    %esi,%eax
f01043b2:	0f 83 9d 00 00 00    	jae    f0104455 <env_create+0x20f>
		{
			va0= (void *)ph->p_va+ph->p_filesz;
f01043b8:	89 c3                	mov    %eax,%ebx
f01043ba:	03 5f 08             	add    0x8(%edi),%ebx
			remain_size = ph->p_memsz-ph->p_filesz;
f01043bd:	29 c6                	sub    %eax,%esi
f01043bf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01043c2:	89 df                	mov    %ebx,%edi
f01043c4:	e9 81 00 00 00       	jmp    f010444a <env_create+0x204>
			while(remain_size)
			{
				va1 = KADDR(PTE_ADDR(*pgdir_walk(e->env_pgdir,va0,0)))+ PGOFF(va0);
f01043c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01043d0:	00 
f01043d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01043d5:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01043d8:	8b 42 60             	mov    0x60(%edx),%eax
f01043db:	89 04 24             	mov    %eax,(%esp)
f01043de:	e8 c5 d0 ff ff       	call   f01014a8 <pgdir_walk>
f01043e3:	8b 00                	mov    (%eax),%eax
f01043e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01043ea:	89 c2                	mov    %eax,%edx
f01043ec:	c1 ea 0c             	shr    $0xc,%edx
f01043ef:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f01043f5:	72 20                	jb     f0104417 <env_create+0x1d1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01043f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01043fb:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0104402:	f0 
f0104403:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
f010440a:	00 
f010440b:	c7 04 24 24 91 10 f0 	movl   $0xf0109124,(%esp)
f0104412:	e8 6e bc ff ff       	call   f0100085 <_panic>
f0104417:	89 fa                	mov    %edi,%edx
f0104419:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
				cp_size = (PGSIZE-PGOFF(va0))>remain_size?remain_size:(PGSIZE-PGOFF(va0));
f010441f:	bb 00 10 00 00       	mov    $0x1000,%ebx
f0104424:	29 d3                	sub    %edx,%ebx
f0104426:	39 f3                	cmp    %esi,%ebx
f0104428:	0f 47 de             	cmova  %esi,%ebx
				memset(va1,0,cp_size);
f010442b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010442f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0104436:	00 
f0104437:	8d 84 02 00 00 00 f0 	lea    -0x10000000(%edx,%eax,1),%eax
f010443e:	89 04 24             	mov    %eax,(%esp)
f0104441:	e8 4a 1f 00 00       	call   f0106390 <memset>
				remain_size-=cp_size;va0+=cp_size;
f0104446:	29 de                	sub    %ebx,%esi
f0104448:	01 df                	add    %ebx,%edi
		}
		if(ph->p_filesz < ph->p_memsz)
		{
			va0= (void *)ph->p_va+ph->p_filesz;
			remain_size = ph->p_memsz-ph->p_filesz;
			while(remain_size)
f010444a:	85 f6                	test   %esi,%esi
f010444c:	0f 85 77 ff ff ff    	jne    f01043c9 <env_create+0x183>
f0104452:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		
	if (tmp->e_magic != ELF_MAGIC)panic("initial binary has bad magic word\n");
	
	ph = (struct Proghdr *) (binary + tmp->e_phoff);	
	eph = ph + tmp->e_phnum;	
	for (; ph < eph; ph++)	
f0104455:	83 c7 20             	add    $0x20,%edi
f0104458:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f010445b:	0f 87 6e fe ff ff    	ja     f01042cf <env_create+0x89>
				memset(va1,0,cp_size);
				remain_size-=cp_size;va0+=cp_size;
			}			
		}
	}
	e->env_tf.tf_eip = tmp->e_entry;
f0104461:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0104464:	8b 42 18             	mov    0x18(%edx),%eax
f0104467:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010446a:	89 42 30             	mov    %eax,0x30(%edx)

	// LAB 3: Your code here.

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.
	region_alloc(e,(void *)(USTACKTOP - PGSIZE),2*PGSIZE);
f010446d:	b9 00 20 00 00       	mov    $0x2000,%ecx
f0104472:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0104477:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010447a:	e8 04 fd ff ff       	call   f0104183 <region_alloc>
	e->env_tf.tf_esp = USTACKTOP;
f010447f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0104482:	c7 40 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%eax)
	struct Env* e;	env_alloc(&e,0);
	if(type == ENV_TYPE_FS) e->env_tf.tf_eflags |= FL_IOPL_3;
	e->env_type = type;	
	e->env_parent_id = 0;
	load_icode(e,binary);
}
f0104489:	83 c4 3c             	add    $0x3c,%esp
f010448c:	5b                   	pop    %ebx
f010448d:	5e                   	pop    %esi
f010448e:	5f                   	pop    %edi
f010448f:	5d                   	pop    %ebp
f0104490:	c3                   	ret    
f0104491:	00 00                	add    %al,(%eax)
	...

f0104494 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0104494:	55                   	push   %ebp
f0104495:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104497:	ba 70 00 00 00       	mov    $0x70,%edx
f010449c:	8b 45 08             	mov    0x8(%ebp),%eax
f010449f:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01044a0:	b2 71                	mov    $0x71,%dl
f01044a2:	ec                   	in     (%dx),%al
f01044a3:	0f b6 c0             	movzbl %al,%eax
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
}
f01044a6:	5d                   	pop    %ebp
f01044a7:	c3                   	ret    

f01044a8 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01044a8:	55                   	push   %ebp
f01044a9:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01044ab:	ba 70 00 00 00       	mov    $0x70,%edx
f01044b0:	8b 45 08             	mov    0x8(%ebp),%eax
f01044b3:	ee                   	out    %al,(%dx)
f01044b4:	b2 71                	mov    $0x71,%dl
f01044b6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01044b9:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01044ba:	5d                   	pop    %ebp
f01044bb:	c3                   	ret    

f01044bc <irq_eoi>:
	cprintf("\n");
}

void
irq_eoi(void)
{
f01044bc:	55                   	push   %ebp
f01044bd:	89 e5                	mov    %esp,%ebp
f01044bf:	ba 20 00 00 00       	mov    $0x20,%edx
f01044c4:	b8 20 00 00 00       	mov    $0x20,%eax
f01044c9:	ee                   	out    %al,(%dx)
f01044ca:	b2 a0                	mov    $0xa0,%dl
f01044cc:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f01044cd:	5d                   	pop    %ebp
f01044ce:	c3                   	ret    

f01044cf <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01044cf:	55                   	push   %ebp
f01044d0:	89 e5                	mov    %esp,%ebp
f01044d2:	56                   	push   %esi
f01044d3:	53                   	push   %ebx
f01044d4:	83 ec 10             	sub    $0x10,%esp
f01044d7:	8b 45 08             	mov    0x8(%ebp),%eax
f01044da:	89 c6                	mov    %eax,%esi
	int i;
	irq_mask_8259A = mask;
f01044dc:	66 a3 90 53 12 f0    	mov    %ax,0xf0125390
	if (!didinit)
f01044e2:	80 3d 40 12 27 f0 00 	cmpb   $0x0,0xf0271240
f01044e9:	74 4e                	je     f0104539 <irq_setmask_8259A+0x6a>
f01044eb:	ba 21 00 00 00       	mov    $0x21,%edx
f01044f0:	ee                   	out    %al,(%dx)
f01044f1:	89 f0                	mov    %esi,%eax
f01044f3:	66 c1 e8 08          	shr    $0x8,%ax
f01044f7:	b2 a1                	mov    $0xa1,%dl
f01044f9:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
f01044fa:	c7 04 24 6b 92 10 f0 	movl   $0xf010926b,(%esp)
f0104501:	e8 f9 00 00 00       	call   f01045ff <cprintf>
f0104506:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
f010450b:	0f b7 f6             	movzwl %si,%esi
f010450e:	f7 d6                	not    %esi
f0104510:	0f a3 de             	bt     %ebx,%esi
f0104513:	73 10                	jae    f0104525 <irq_setmask_8259A+0x56>
			cprintf(" %d", i);
f0104515:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104519:	c7 04 24 24 98 10 f0 	movl   $0xf0109824,(%esp)
f0104520:	e8 da 00 00 00       	call   f01045ff <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f0104525:	83 c3 01             	add    $0x1,%ebx
f0104528:	83 fb 10             	cmp    $0x10,%ebx
f010452b:	75 e3                	jne    f0104510 <irq_setmask_8259A+0x41>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f010452d:	c7 04 24 f2 90 10 f0 	movl   $0xf01090f2,(%esp)
f0104534:	e8 c6 00 00 00       	call   f01045ff <cprintf>
}
f0104539:	83 c4 10             	add    $0x10,%esp
f010453c:	5b                   	pop    %ebx
f010453d:	5e                   	pop    %esi
f010453e:	5d                   	pop    %ebp
f010453f:	c3                   	ret    

f0104540 <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0104540:	55                   	push   %ebp
f0104541:	89 e5                	mov    %esp,%ebp
f0104543:	83 ec 18             	sub    $0x18,%esp
	didinit = 1;
f0104546:	c6 05 40 12 27 f0 01 	movb   $0x1,0xf0271240
f010454d:	ba 21 00 00 00       	mov    $0x21,%edx
f0104552:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104557:	ee                   	out    %al,(%dx)
f0104558:	b2 a1                	mov    $0xa1,%dl
f010455a:	ee                   	out    %al,(%dx)
f010455b:	b2 20                	mov    $0x20,%dl
f010455d:	b8 11 00 00 00       	mov    $0x11,%eax
f0104562:	ee                   	out    %al,(%dx)
f0104563:	b2 21                	mov    $0x21,%dl
f0104565:	b8 20 00 00 00       	mov    $0x20,%eax
f010456a:	ee                   	out    %al,(%dx)
f010456b:	b8 04 00 00 00       	mov    $0x4,%eax
f0104570:	ee                   	out    %al,(%dx)
f0104571:	b8 03 00 00 00       	mov    $0x3,%eax
f0104576:	ee                   	out    %al,(%dx)
f0104577:	b2 a0                	mov    $0xa0,%dl
f0104579:	b8 11 00 00 00       	mov    $0x11,%eax
f010457e:	ee                   	out    %al,(%dx)
f010457f:	b2 a1                	mov    $0xa1,%dl
f0104581:	b8 28 00 00 00       	mov    $0x28,%eax
f0104586:	ee                   	out    %al,(%dx)
f0104587:	b8 02 00 00 00       	mov    $0x2,%eax
f010458c:	ee                   	out    %al,(%dx)
f010458d:	b8 01 00 00 00       	mov    $0x1,%eax
f0104592:	ee                   	out    %al,(%dx)
f0104593:	b2 20                	mov    $0x20,%dl
f0104595:	b8 68 00 00 00       	mov    $0x68,%eax
f010459a:	ee                   	out    %al,(%dx)
f010459b:	b8 0a 00 00 00       	mov    $0xa,%eax
f01045a0:	ee                   	out    %al,(%dx)
f01045a1:	b2 a0                	mov    $0xa0,%dl
f01045a3:	b8 68 00 00 00       	mov    $0x68,%eax
f01045a8:	ee                   	out    %al,(%dx)
f01045a9:	b8 0a 00 00 00       	mov    $0xa,%eax
f01045ae:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f01045af:	0f b7 05 90 53 12 f0 	movzwl 0xf0125390,%eax
f01045b6:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f01045ba:	74 0b                	je     f01045c7 <pic_init+0x87>
		irq_setmask_8259A(irq_mask_8259A);
f01045bc:	0f b7 c0             	movzwl %ax,%eax
f01045bf:	89 04 24             	mov    %eax,(%esp)
f01045c2:	e8 08 ff ff ff       	call   f01044cf <irq_setmask_8259A>
}
f01045c7:	c9                   	leave  
f01045c8:	c3                   	ret    
f01045c9:	00 00                	add    %al,(%eax)
	...

f01045cc <vcprintf>:
	*cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
f01045cc:	55                   	push   %ebp
f01045cd:	89 e5                	mov    %esp,%ebp
f01045cf:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f01045d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01045d9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01045dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01045e0:	8b 45 08             	mov    0x8(%ebp),%eax
f01045e3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01045e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01045ea:	89 44 24 04          	mov    %eax,0x4(%esp)
f01045ee:	c7 04 24 19 46 10 f0 	movl   $0xf0104619,(%esp)
f01045f5:	e8 a9 16 00 00       	call   f0105ca3 <vprintfmt>
	return cnt;
}
f01045fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01045fd:	c9                   	leave  
f01045fe:	c3                   	ret    

f01045ff <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01045ff:	55                   	push   %ebp
f0104600:	89 e5                	mov    %esp,%ebp
f0104602:	83 ec 18             	sub    $0x18,%esp
	vprintfmt((void*)putch, &cnt, fmt, ap);
	return cnt;
}

int
cprintf(const char *fmt, ...)
f0104605:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
f0104608:	89 44 24 04          	mov    %eax,0x4(%esp)
f010460c:	8b 45 08             	mov    0x8(%ebp),%eax
f010460f:	89 04 24             	mov    %eax,(%esp)
f0104612:	e8 b5 ff ff ff       	call   f01045cc <vcprintf>
	va_end(ap);

	return cnt;
}
f0104617:	c9                   	leave  
f0104618:	c3                   	ret    

f0104619 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0104619:	55                   	push   %ebp
f010461a:	89 e5                	mov    %esp,%ebp
f010461c:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f010461f:	8b 45 08             	mov    0x8(%ebp),%eax
f0104622:	89 04 24             	mov    %eax,(%esp)
f0104625:	e8 28 c0 ff ff       	call   f0100652 <cputchar>
	*cnt++;
}
f010462a:	c9                   	leave  
f010462b:	c3                   	ret    
f010462c:	00 00                	add    %al,(%eax)
	...

f0104630 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0104630:	55                   	push   %ebp
f0104631:	89 e5                	mov    %esp,%ebp
f0104633:	57                   	push   %edi
f0104634:	56                   	push   %esi
f0104635:	53                   	push   %ebx
f0104636:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.

	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP-cpunum()*(KSTKSIZE+KSTKGAP);
f0104639:	e8 c8 23 00 00       	call   f0106a06 <cpunum>
f010463e:	89 c6                	mov    %eax,%esi
f0104640:	e8 c1 23 00 00       	call   f0106a06 <cpunum>
f0104645:	bb 20 20 27 f0       	mov    $0xf0272020,%ebx
f010464a:	6b f6 74             	imul   $0x74,%esi,%esi
f010464d:	c1 e0 10             	shl    $0x10,%eax
f0104650:	f7 d8                	neg    %eax
f0104652:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0104657:	89 44 1e 10          	mov    %eax,0x10(%esi,%ebx,1)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f010465b:	e8 a6 23 00 00       	call   f0106a06 <cpunum>
f0104660:	6b c0 74             	imul   $0x74,%eax,%eax
f0104663:	66 c7 44 18 14 10 00 	movw   $0x10,0x14(%eax,%ebx,1)
	thiscpu->cpu_ts.ts_eflags = 0;
f010466a:	e8 97 23 00 00       	call   f0106a06 <cpunum>
f010466f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104672:	c7 44 18 30 00 00 00 	movl   $0x0,0x30(%eax,%ebx,1)
f0104679:	00 
	thiscpu->cpu_ts.ts_iomb = 0;
f010467a:	e8 87 23 00 00       	call   f0106a06 <cpunum>
f010467f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104682:	66 c7 44 18 72 00 00 	movw   $0x0,0x72(%eax,%ebx,1)

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3)+cpunum()] = SEG16(STS_T32A, (uint32_t)(&(thiscpu->cpu_ts)),
f0104689:	e8 78 23 00 00       	call   f0106a06 <cpunum>
f010468e:	8d 70 05             	lea    0x5(%eax),%esi
f0104691:	e8 70 23 00 00       	call   f0106a06 <cpunum>
f0104696:	89 c7                	mov    %eax,%edi
f0104698:	e8 69 23 00 00       	call   f0106a06 <cpunum>
f010469d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01046a0:	e8 61 23 00 00       	call   f0106a06 <cpunum>
f01046a5:	bb 20 53 12 f0       	mov    $0xf0125320,%ebx
f01046aa:	66 c7 04 f3 67 00    	movw   $0x67,(%ebx,%esi,8)
f01046b0:	6b ff 74             	imul   $0x74,%edi,%edi
f01046b3:	81 c7 2c 20 27 f0    	add    $0xf027202c,%edi
f01046b9:	66 89 7c f3 02       	mov    %di,0x2(%ebx,%esi,8)
f01046be:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f01046c2:	81 c2 2c 20 27 f0    	add    $0xf027202c,%edx
f01046c8:	c1 ea 10             	shr    $0x10,%edx
f01046cb:	88 54 f3 04          	mov    %dl,0x4(%ebx,%esi,8)
f01046cf:	c6 44 f3 05 99       	movb   $0x99,0x5(%ebx,%esi,8)
f01046d4:	c6 44 f3 06 40       	movb   $0x40,0x6(%ebx,%esi,8)
f01046d9:	6b c0 74             	imul   $0x74,%eax,%eax
f01046dc:	05 2c 20 27 f0       	add    $0xf027202c,%eax
f01046e1:	c1 e8 18             	shr    $0x18,%eax
f01046e4:	88 44 f3 07          	mov    %al,0x7(%ebx,%esi,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3)+cpunum()].sd_s = 0;
f01046e8:	e8 19 23 00 00       	call   f0106a06 <cpunum>
f01046ed:	80 64 c3 2d ef       	andb   $0xef,0x2d(%ebx,%eax,8)

	ltr(GD_TSS0+cpunum()*sizeof(struct Segdesc));
f01046f2:	e8 0f 23 00 00       	call   f0106a06 <cpunum>
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f01046f7:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
f01046fe:	0f 00 d8             	ltr    %ax
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
f0104701:	b8 94 53 12 f0       	mov    $0xf0125394,%eax
f0104706:	0f 01 18             	lidtl  (%eax)
	ltr(GD_TSS0+cpunum()*sizeof(struct Segdesc));*/

	// Load the IDT
	lidt(&idt_pd);

}
f0104709:	83 c4 1c             	add    $0x1c,%esp
f010470c:	5b                   	pop    %ebx
f010470d:	5e                   	pop    %esi
f010470e:	5f                   	pop    %edi
f010470f:	5d                   	pop    %ebp
f0104710:	c3                   	ret    

f0104711 <trap_init>:
}


void
trap_init(void)
{
f0104711:	55                   	push   %ebp
f0104712:	89 e5                	mov    %esp,%ebp
f0104714:	83 ec 08             	sub    $0x8,%esp
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.
	SETGATE(idt[T_DIVIDE],0,GD_KT,DIV_HANDLER,3);
f0104717:	b8 6e 4f 10 f0       	mov    $0xf0104f6e,%eax
f010471c:	66 a3 60 12 27 f0    	mov    %ax,0xf0271260
f0104722:	66 c7 05 62 12 27 f0 	movw   $0x8,0xf0271262
f0104729:	08 00 
f010472b:	c6 05 64 12 27 f0 00 	movb   $0x0,0xf0271264
f0104732:	c6 05 65 12 27 f0 ee 	movb   $0xee,0xf0271265
f0104739:	c1 e8 10             	shr    $0x10,%eax
f010473c:	66 a3 66 12 27 f0    	mov    %ax,0xf0271266
	SETGATE(idt[T_BRKPT],0,GD_KT,BRKPT_HANDLER,3);
f0104742:	b8 58 4f 10 f0       	mov    $0xf0104f58,%eax
f0104747:	66 a3 78 12 27 f0    	mov    %ax,0xf0271278
f010474d:	66 c7 05 7a 12 27 f0 	movw   $0x8,0xf027127a
f0104754:	08 00 
f0104756:	c6 05 7c 12 27 f0 00 	movb   $0x0,0xf027127c
f010475d:	c6 05 7d 12 27 f0 ee 	movb   $0xee,0xf027127d
f0104764:	c1 e8 10             	shr    $0x10,%eax
f0104767:	66 a3 7e 12 27 f0    	mov    %ax,0xf027127e
	SETGATE(idt[T_GPFLT],0,GD_KT,GPFLT_HANDLER,3); 
f010476d:	b8 76 4f 10 f0       	mov    $0xf0104f76,%eax
f0104772:	66 a3 c8 12 27 f0    	mov    %ax,0xf02712c8
f0104778:	66 c7 05 ca 12 27 f0 	movw   $0x8,0xf02712ca
f010477f:	08 00 
f0104781:	c6 05 cc 12 27 f0 00 	movb   $0x0,0xf02712cc
f0104788:	c6 05 cd 12 27 f0 ee 	movb   $0xee,0xf02712cd
f010478f:	c1 e8 10             	shr    $0x10,%eax
f0104792:	66 a3 ce 12 27 f0    	mov    %ax,0xf02712ce
	SETGATE(idt[T_SYSCALL],0,GD_KT,SYSCALL_HANDLER,3);
f0104798:	b8 60 4f 10 f0       	mov    $0xf0104f60,%eax
f010479d:	66 a3 e0 13 27 f0    	mov    %ax,0xf02713e0
f01047a3:	66 c7 05 e2 13 27 f0 	movw   $0x8,0xf02713e2
f01047aa:	08 00 
f01047ac:	c6 05 e4 13 27 f0 00 	movb   $0x0,0xf02713e4
f01047b3:	c6 05 e5 13 27 f0 ee 	movb   $0xee,0xf02713e5
f01047ba:	c1 e8 10             	shr    $0x10,%eax
f01047bd:	66 a3 e6 13 27 f0    	mov    %ax,0xf02713e6
	SETGATE(idt[T_PGFLT],0,GD_KT,PGFLT_HANDLER,3); 
f01047c3:	b8 68 4f 10 f0       	mov    $0xf0104f68,%eax
f01047c8:	66 a3 d0 12 27 f0    	mov    %ax,0xf02712d0
f01047ce:	66 c7 05 d2 12 27 f0 	movw   $0x8,0xf02712d2
f01047d5:	08 00 
f01047d7:	c6 05 d4 12 27 f0 00 	movb   $0x0,0xf02712d4
f01047de:	c6 05 d5 12 27 f0 ee 	movb   $0xee,0xf02712d5
f01047e5:	c1 e8 10             	shr    $0x10,%eax
f01047e8:	66 a3 d6 12 27 f0    	mov    %ax,0xf02712d6
	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER],0,GD_KT,IRQ_TIMER_HANDLER,3);
f01047ee:	b8 7c 4f 10 f0       	mov    $0xf0104f7c,%eax
f01047f3:	66 a3 60 13 27 f0    	mov    %ax,0xf0271360
f01047f9:	66 c7 05 62 13 27 f0 	movw   $0x8,0xf0271362
f0104800:	08 00 
f0104802:	c6 05 64 13 27 f0 00 	movb   $0x0,0xf0271364
f0104809:	c6 05 65 13 27 f0 ee 	movb   $0xee,0xf0271365
f0104810:	c1 e8 10             	shr    $0x10,%eax
f0104813:	66 a3 66 13 27 f0    	mov    %ax,0xf0271366
	SETGATE(idt[IRQ_OFFSET+IRQ_KBD],0,GD_KT,IRQ_KBD_HANDLER,3); 
f0104819:	b8 84 4f 10 f0       	mov    $0xf0104f84,%eax
f010481e:	66 a3 68 13 27 f0    	mov    %ax,0xf0271368
f0104824:	66 c7 05 6a 13 27 f0 	movw   $0x8,0xf027136a
f010482b:	08 00 
f010482d:	c6 05 6c 13 27 f0 00 	movb   $0x0,0xf027136c
f0104834:	c6 05 6d 13 27 f0 ee 	movb   $0xee,0xf027136d
f010483b:	c1 e8 10             	shr    $0x10,%eax
f010483e:	66 a3 6e 13 27 f0    	mov    %ax,0xf027136e
	SETGATE(idt[IRQ_OFFSET+IRQ_SERIAL],0,GD_KT,IRQ_SERIAL_HANDLER,3);
f0104844:	b8 8c 4f 10 f0       	mov    $0xf0104f8c,%eax
f0104849:	66 a3 80 13 27 f0    	mov    %ax,0xf0271380
f010484f:	66 c7 05 82 13 27 f0 	movw   $0x8,0xf0271382
f0104856:	08 00 
f0104858:	c6 05 84 13 27 f0 00 	movb   $0x0,0xf0271384
f010485f:	c6 05 85 13 27 f0 ee 	movb   $0xee,0xf0271385
f0104866:	c1 e8 10             	shr    $0x10,%eax
f0104869:	66 a3 86 13 27 f0    	mov    %ax,0xf0271386
	SETGATE(idt[IRQ_OFFSET+IRQ_SPURIOUS],0,GD_KT,IRQ_SPURIOUS_HANDLER,3);
f010486f:	b8 94 4f 10 f0       	mov    $0xf0104f94,%eax
f0104874:	66 a3 98 13 27 f0    	mov    %ax,0xf0271398
f010487a:	66 c7 05 9a 13 27 f0 	movw   $0x8,0xf027139a
f0104881:	08 00 
f0104883:	c6 05 9c 13 27 f0 00 	movb   $0x0,0xf027139c
f010488a:	c6 05 9d 13 27 f0 ee 	movb   $0xee,0xf027139d
f0104891:	c1 e8 10             	shr    $0x10,%eax
f0104894:	66 a3 9e 13 27 f0    	mov    %ax,0xf027139e
	SETGATE(idt[IRQ_OFFSET+IRQ_IDE],0,GD_KT,IRQ_IDE_HANDLER,3);
f010489a:	b8 9c 4f 10 f0       	mov    $0xf0104f9c,%eax
f010489f:	66 a3 d0 13 27 f0    	mov    %ax,0xf02713d0
f01048a5:	66 c7 05 d2 13 27 f0 	movw   $0x8,0xf02713d2
f01048ac:	08 00 
f01048ae:	c6 05 d4 13 27 f0 00 	movb   $0x0,0xf02713d4
f01048b5:	c6 05 d5 13 27 f0 ee 	movb   $0xee,0xf02713d5
f01048bc:	c1 e8 10             	shr    $0x10,%eax
f01048bf:	66 a3 d6 13 27 f0    	mov    %ax,0xf02713d6
	
	// Per-CPU setup 
	trap_init_percpu();	
f01048c5:	e8 66 fd ff ff       	call   f0104630 <trap_init_percpu>
}
f01048ca:	c9                   	leave  
f01048cb:	c3                   	ret    

f01048cc <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f01048cc:	55                   	push   %ebp
f01048cd:	89 e5                	mov    %esp,%ebp
f01048cf:	53                   	push   %ebx
f01048d0:	83 ec 14             	sub    $0x14,%esp
f01048d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f01048d6:	8b 03                	mov    (%ebx),%eax
f01048d8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01048dc:	c7 04 24 7f 92 10 f0 	movl   $0xf010927f,(%esp)
f01048e3:	e8 17 fd ff ff       	call   f01045ff <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f01048e8:	8b 43 04             	mov    0x4(%ebx),%eax
f01048eb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01048ef:	c7 04 24 8e 92 10 f0 	movl   $0xf010928e,(%esp)
f01048f6:	e8 04 fd ff ff       	call   f01045ff <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01048fb:	8b 43 08             	mov    0x8(%ebx),%eax
f01048fe:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104902:	c7 04 24 9d 92 10 f0 	movl   $0xf010929d,(%esp)
f0104909:	e8 f1 fc ff ff       	call   f01045ff <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f010490e:	8b 43 0c             	mov    0xc(%ebx),%eax
f0104911:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104915:	c7 04 24 ac 92 10 f0 	movl   $0xf01092ac,(%esp)
f010491c:	e8 de fc ff ff       	call   f01045ff <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104921:	8b 43 10             	mov    0x10(%ebx),%eax
f0104924:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104928:	c7 04 24 bb 92 10 f0 	movl   $0xf01092bb,(%esp)
f010492f:	e8 cb fc ff ff       	call   f01045ff <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104934:	8b 43 14             	mov    0x14(%ebx),%eax
f0104937:	89 44 24 04          	mov    %eax,0x4(%esp)
f010493b:	c7 04 24 ca 92 10 f0 	movl   $0xf01092ca,(%esp)
f0104942:	e8 b8 fc ff ff       	call   f01045ff <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104947:	8b 43 18             	mov    0x18(%ebx),%eax
f010494a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010494e:	c7 04 24 d9 92 10 f0 	movl   $0xf01092d9,(%esp)
f0104955:	e8 a5 fc ff ff       	call   f01045ff <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f010495a:	8b 43 1c             	mov    0x1c(%ebx),%eax
f010495d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104961:	c7 04 24 e8 92 10 f0 	movl   $0xf01092e8,(%esp)
f0104968:	e8 92 fc ff ff       	call   f01045ff <cprintf>
}
f010496d:	83 c4 14             	add    $0x14,%esp
f0104970:	5b                   	pop    %ebx
f0104971:	5d                   	pop    %ebp
f0104972:	c3                   	ret    

f0104973 <print_trapframe>:

}

void
print_trapframe(struct Trapframe *tf)
{
f0104973:	55                   	push   %ebp
f0104974:	89 e5                	mov    %esp,%ebp
f0104976:	56                   	push   %esi
f0104977:	53                   	push   %ebx
f0104978:	83 ec 10             	sub    $0x10,%esp
f010497b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f010497e:	e8 83 20 00 00       	call   f0106a06 <cpunum>
f0104983:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104987:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010498b:	c7 04 24 f7 92 10 f0 	movl   $0xf01092f7,(%esp)
f0104992:	e8 68 fc ff ff       	call   f01045ff <cprintf>
	print_regs(&tf->tf_regs);
f0104997:	89 1c 24             	mov    %ebx,(%esp)
f010499a:	e8 2d ff ff ff       	call   f01048cc <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f010499f:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01049a3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01049a7:	c7 04 24 15 93 10 f0 	movl   $0xf0109315,(%esp)
f01049ae:	e8 4c fc ff ff       	call   f01045ff <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01049b3:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01049b7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01049bb:	c7 04 24 28 93 10 f0 	movl   $0xf0109328,(%esp)
f01049c2:	e8 38 fc ff ff       	call   f01045ff <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01049c7:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f01049ca:	83 f8 13             	cmp    $0x13,%eax
f01049cd:	77 09                	ja     f01049d8 <print_trapframe+0x65>
		return excnames[trapno];
f01049cf:	8b 14 85 00 97 10 f0 	mov    -0xfef6900(,%eax,4),%edx
f01049d6:	eb 1d                	jmp    f01049f5 <print_trapframe+0x82>
	if (trapno == T_SYSCALL)
f01049d8:	ba 3b 93 10 f0       	mov    $0xf010933b,%edx
f01049dd:	83 f8 30             	cmp    $0x30,%eax
f01049e0:	74 13                	je     f01049f5 <print_trapframe+0x82>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01049e2:	8d 50 e0             	lea    -0x20(%eax),%edx
f01049e5:	83 fa 10             	cmp    $0x10,%edx
f01049e8:	ba 47 93 10 f0       	mov    $0xf0109347,%edx
f01049ed:	b9 56 93 10 f0       	mov    $0xf0109356,%ecx
f01049f2:	0f 42 d1             	cmovb  %ecx,%edx
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01049f5:	89 54 24 08          	mov    %edx,0x8(%esp)
f01049f9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01049fd:	c7 04 24 69 93 10 f0 	movl   $0xf0109369,(%esp)
f0104a04:	e8 f6 fb ff ff       	call   f01045ff <cprintf>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0104a09:	0f 20 d0             	mov    %cr2,%eax
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	//if (tf == last_tf && tf->tf_trapno == T_PGFLT)
		cprintf("  cr2  0x%08x\n", rcr2());
f0104a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a10:	c7 04 24 7b 93 10 f0 	movl   $0xf010937b,(%esp)
f0104a17:	e8 e3 fb ff ff       	call   f01045ff <cprintf>
	cprintf("  err  0x%08x", tf->tf_err);
f0104a1c:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a23:	c7 04 24 8a 93 10 f0 	movl   $0xf010938a,(%esp)
f0104a2a:	e8 d0 fb ff ff       	call   f01045ff <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0104a2f:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104a33:	75 4a                	jne    f0104a7f <print_trapframe+0x10c>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f0104a35:	8b 43 2c             	mov    0x2c(%ebx),%eax
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
f0104a38:	a8 01                	test   $0x1,%al
f0104a3a:	ba 98 93 10 f0       	mov    $0xf0109398,%edx
f0104a3f:	b9 a4 93 10 f0       	mov    $0xf01093a4,%ecx
f0104a44:	0f 44 ca             	cmove  %edx,%ecx
f0104a47:	a8 02                	test   $0x2,%al
f0104a49:	ba af 93 10 f0       	mov    $0xf01093af,%edx
f0104a4e:	be b4 93 10 f0       	mov    $0xf01093b4,%esi
f0104a53:	0f 45 d6             	cmovne %esi,%edx
f0104a56:	a8 04                	test   $0x4,%al
f0104a58:	b8 75 94 10 f0       	mov    $0xf0109475,%eax
f0104a5d:	be ba 93 10 f0       	mov    $0xf01093ba,%esi
f0104a62:	0f 45 c6             	cmovne %esi,%eax
f0104a65:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0104a69:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a71:	c7 04 24 bf 93 10 f0 	movl   $0xf01093bf,(%esp)
f0104a78:	e8 82 fb ff ff       	call   f01045ff <cprintf>
f0104a7d:	eb 0c                	jmp    f0104a8b <print_trapframe+0x118>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
f0104a7f:	c7 04 24 f2 90 10 f0 	movl   $0xf01090f2,(%esp)
f0104a86:	e8 74 fb ff ff       	call   f01045ff <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104a8b:	8b 43 30             	mov    0x30(%ebx),%eax
f0104a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a92:	c7 04 24 ce 93 10 f0 	movl   $0xf01093ce,(%esp)
f0104a99:	e8 61 fb ff ff       	call   f01045ff <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104a9e:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104aa6:	c7 04 24 dd 93 10 f0 	movl   $0xf01093dd,(%esp)
f0104aad:	e8 4d fb ff ff       	call   f01045ff <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104ab2:	8b 43 38             	mov    0x38(%ebx),%eax
f0104ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ab9:	c7 04 24 f0 93 10 f0 	movl   $0xf01093f0,(%esp)
f0104ac0:	e8 3a fb ff ff       	call   f01045ff <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104ac5:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104ac9:	74 27                	je     f0104af2 <print_trapframe+0x17f>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104acb:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104ace:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ad2:	c7 04 24 ff 93 10 f0 	movl   $0xf01093ff,(%esp)
f0104ad9:	e8 21 fb ff ff       	call   f01045ff <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104ade:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ae6:	c7 04 24 0e 94 10 f0 	movl   $0xf010940e,(%esp)
f0104aed:	e8 0d fb ff ff       	call   f01045ff <cprintf>
	}
}
f0104af2:	83 c4 10             	add    $0x10,%esp
f0104af5:	5b                   	pop    %ebx
f0104af6:	5e                   	pop    %esi
f0104af7:	5d                   	pop    %ebp
f0104af8:	c3                   	ret    

f0104af9 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104af9:	55                   	push   %ebp
f0104afa:	89 e5                	mov    %esp,%ebp
f0104afc:	57                   	push   %edi
f0104afd:	56                   	push   %esi
f0104afe:	53                   	push   %ebx
f0104aff:	83 ec 6c             	sub    $0x6c,%esp
f0104b02:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104b05:	0f 20 d7             	mov    %cr2,%edi
	uint8_t * curr_stack;
	struct UTrapframe curr_frame;

	// Handle kernel-mode page faults.
	//deal with softint in which case error is not pushed to stack
	if(!(tf->tf_cs & 3)) 
f0104b08:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104b0c:	75 24                	jne    f0104b32 <page_fault_handler+0x39>
	{	
		print_trapframe(tf);
f0104b0e:	89 1c 24             	mov    %ebx,(%esp)
f0104b11:	e8 5d fe ff ff       	call   f0104973 <print_trapframe>
		panic("page fault occurs in kernel mode\n");
f0104b16:	c7 44 24 08 c0 95 10 	movl   $0xf01095c0,0x8(%esp)
f0104b1d:	f0 
f0104b1e:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
f0104b25:	00 
f0104b26:	c7 04 24 21 94 10 f0 	movl   $0xf0109421,(%esp)
f0104b2d:	e8 53 b5 ff ff       	call   f0100085 <_panic>
	}

	if(!curenv->env_pgfault_upcall)
f0104b32:	e8 cf 1e 00 00       	call   f0106a06 <cpunum>
f0104b37:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b3a:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0104b40:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0104b44:	0f 84 17 01 00 00    	je     f0104c61 <page_fault_handler+0x168>
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	// Jie's Note : x86 first dec stack pointer and then store the value

	user_mem_assert(curenv,(void *)(UXSTACKTOP-PGSIZE),PGSIZE,PTE_U|PTE_W|PTE_P);
f0104b4a:	e8 b7 1e 00 00       	call   f0106a06 <cpunum>
f0104b4f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0104b56:	00 
f0104b57:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0104b5e:	00 
f0104b5f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
f0104b66:	ee 
f0104b67:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b6a:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0104b70:	89 04 24             	mov    %eax,(%esp)
f0104b73:	e8 76 ca ff ff       	call   f01015ee <user_mem_assert>
	
	if(tf->tf_esp < USTACKTOP)
f0104b78:	8b 43 3c             	mov    0x3c(%ebx),%eax
		curr_stack-=sizeof(uint32_t);	
		memset(curr_stack,0,sizeof(uint32_t)); 
	}

	if((uint32_t)curr_stack <= UXSTACKTOP-PGSIZE+sizeof(struct UTrapframe)+sizeof(uint32_t))
		panic("exception stack overflow");
f0104b7b:	be 00 00 c0 ee       	mov    $0xeec00000,%esi
	// page fault stack frame on top of the user exception stack.
	// Jie's Note : x86 first dec stack pointer and then store the value

	user_mem_assert(curenv,(void *)(UXSTACKTOP-PGSIZE),PGSIZE,PTE_U|PTE_W|PTE_P);
	
	if(tf->tf_esp < USTACKTOP)
f0104b80:	3d ff df bf ee       	cmp    $0xeebfdfff,%eax
f0104b85:	76 3f                	jbe    f0104bc6 <page_fault_handler+0xcd>
		curr_stack = (uint8_t *)UXSTACKTOP;
	}
	else
	{
		curr_stack = (uint8_t *) tf->tf_esp;
		curr_stack-=sizeof(uint32_t);	
f0104b87:	8d 70 fc             	lea    -0x4(%eax),%esi
		memset(curr_stack,0,sizeof(uint32_t)); 
f0104b8a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0104b91:	00 
f0104b92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0104b99:	00 
f0104b9a:	89 34 24             	mov    %esi,(%esp)
f0104b9d:	e8 ee 17 00 00       	call   f0106390 <memset>
	}

	if((uint32_t)curr_stack <= UXSTACKTOP-PGSIZE+sizeof(struct UTrapframe)+sizeof(uint32_t))
f0104ba2:	81 fe 38 f0 bf ee    	cmp    $0xeebff038,%esi
f0104ba8:	77 1c                	ja     f0104bc6 <page_fault_handler+0xcd>
		panic("exception stack overflow");
f0104baa:	c7 44 24 08 2d 94 10 	movl   $0xf010942d,0x8(%esp)
f0104bb1:	f0 
f0104bb2:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
f0104bb9:	00 
f0104bba:	c7 04 24 21 94 10 f0 	movl   $0xf0109421,(%esp)
f0104bc1:	e8 bf b4 ff ff       	call   f0100085 <_panic>
	
	curr_stack-=sizeof(struct UTrapframe);
f0104bc6:	83 ee 34             	sub    $0x34,%esi
f0104bc9:	89 75 a4             	mov    %esi,-0x5c(%ebp)
	// don't have to worry about this because the top of the regular user
	// stack is free.  In the recursive case, this means we have to leave
	// an extra word between the current top of the exception stack and
	// the new stack frame because the exception stack _is_ the trap-time
	// stack.
	curr_frame.utf_fault_va = fault_va;
f0104bcc:	89 7d b4             	mov    %edi,-0x4c(%ebp)
	curr_frame.utf_err = tf->tf_err;
f0104bcf:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104bd2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	curr_frame.utf_eip = tf->tf_eip;
f0104bd5:	8b 43 30             	mov    0x30(%ebx),%eax
f0104bd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	curr_frame.utf_esp = tf->tf_esp;
f0104bdb:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104bde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	curr_frame.utf_eflags = tf->tf_eflags;
f0104be1:	8b 43 38             	mov    0x38(%ebx),%eax
f0104be4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memcpy(&(curr_frame.utf_regs),&(tf->tf_regs),sizeof(struct PushRegs));
f0104be7:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
f0104bee:	00 
f0104bef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104bf3:	8d 5d b4             	lea    -0x4c(%ebp),%ebx
f0104bf6:	8d 45 bc             	lea    -0x44(%ebp),%eax
f0104bf9:	89 04 24             	mov    %eax,(%esp)
f0104bfc:	e8 6a 18 00 00       	call   f010646b <memcpy>
	memcpy(curr_stack,&curr_frame,sizeof(struct UTrapframe));
f0104c01:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
f0104c08:	00 
f0104c09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104c0d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0104c10:	89 04 24             	mov    %eax,(%esp)
f0104c13:	e8 53 18 00 00       	call   f010646b <memcpy>
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').
	// LAB 4: Your code here.
	curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0104c18:	e8 e9 1d 00 00       	call   f0106a06 <cpunum>
f0104c1d:	bb 20 20 27 f0       	mov    $0xf0272020,%ebx
f0104c22:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c25:	8b 74 18 08          	mov    0x8(%eax,%ebx,1),%esi
f0104c29:	e8 d8 1d 00 00       	call   f0106a06 <cpunum>
f0104c2e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c31:	8b 44 18 08          	mov    0x8(%eax,%ebx,1),%eax
f0104c35:	8b 40 64             	mov    0x64(%eax),%eax
f0104c38:	89 46 30             	mov    %eax,0x30(%esi)
	curenv->env_tf.tf_esp = (uintptr_t)curr_stack;
f0104c3b:	e8 c6 1d 00 00       	call   f0106a06 <cpunum>
f0104c40:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c43:	8b 44 18 08          	mov    0x8(%eax,%ebx,1),%eax
f0104c47:	8b 55 a4             	mov    -0x5c(%ebp),%edx
f0104c4a:	89 50 3c             	mov    %edx,0x3c(%eax)
	env_run(curenv);
f0104c4d:	e8 b4 1d 00 00       	call   f0106a06 <cpunum>
f0104c52:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c55:	8b 44 18 08          	mov    0x8(%eax,%ebx,1),%eax
f0104c59:	89 04 24             	mov    %eax,(%esp)
f0104c5c:	e8 73 ef ff ff       	call   f0103bd4 <env_run>
	
	// Destroy the environment that caused the fault.
no_page_fault_handler:

	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104c61:	8b 73 30             	mov    0x30(%ebx),%esi
		curenv->env_id, fault_va, tf->tf_eip);
f0104c64:	e8 9d 1d 00 00       	call   f0106a06 <cpunum>
	env_run(curenv);
	
	// Destroy the environment that caused the fault.
no_page_fault_handler:

	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104c69:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0104c6d:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0104c71:	be 20 20 27 f0       	mov    $0xf0272020,%esi
f0104c76:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c79:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f0104c7d:	8b 40 48             	mov    0x48(%eax),%eax
f0104c80:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104c84:	c7 04 24 e4 95 10 f0 	movl   $0xf01095e4,(%esp)
f0104c8b:	e8 6f f9 ff ff       	call   f01045ff <cprintf>
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
f0104c90:	89 1c 24             	mov    %ebx,(%esp)
f0104c93:	e8 db fc ff ff       	call   f0104973 <print_trapframe>
	env_destroy(curenv);
f0104c98:	e8 69 1d 00 00       	call   f0106a06 <cpunum>
f0104c9d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ca0:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f0104ca4:	89 04 24             	mov    %eax,(%esp)
f0104ca7:	e8 99 f2 ff ff       	call   f0103f45 <env_destroy>
}
f0104cac:	83 c4 6c             	add    $0x6c,%esp
f0104caf:	5b                   	pop    %ebx
f0104cb0:	5e                   	pop    %esi
f0104cb1:	5f                   	pop    %edi
f0104cb2:	5d                   	pop    %ebp
f0104cb3:	c3                   	ret    

f0104cb4 <trap>:
	}
}

void
trap(struct Trapframe *tf)
{
f0104cb4:	55                   	push   %ebp
f0104cb5:	89 e5                	mov    %esp,%ebp
f0104cb7:	57                   	push   %edi
f0104cb8:	56                   	push   %esi
f0104cb9:	53                   	push   %ebx
f0104cba:	83 ec 2c             	sub    $0x2c,%esp
f0104cbd:	8b 75 08             	mov    0x8(%ebp),%esi

	// The environment may have set DF and some versions
	// of GCC rely on DF being clear		
	asm volatile("cld" ::: "cc");
f0104cc0:	fc                   	cld    

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
f0104cc1:	83 3d 9c 1e 27 f0 00 	cmpl   $0x0,0xf0271e9c
f0104cc8:	74 01                	je     f0104ccb <trap+0x17>
		asm volatile("hlt");
f0104cca:	f4                   	hlt    
	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	//if(tf->tf_eip >= KERNBASE && tf->tf_trapno >= IRQ_OFFSET)
	//	lock_kernel();
	
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104ccb:	e8 36 1d 00 00       	call   f0106a06 <cpunum>
f0104cd0:	6b d0 74             	imul   $0x74,%eax,%edx
f0104cd3:	81 c2 24 20 27 f0    	add    $0xf0272024,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0104cd9:	b8 01 00 00 00       	mov    $0x1,%eax
f0104cde:	f0 87 02             	lock xchg %eax,(%edx)
f0104ce1:	83 f8 02             	cmp    $0x2,%eax
f0104ce4:	75 0c                	jne    f0104cf2 <trap+0x3e>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0104ce6:	c7 04 24 a0 53 12 f0 	movl   $0xf01253a0,(%esp)
f0104ced:	e8 df 20 00 00       	call   f0106dd1 <spin_lock>

static __inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	__asm __volatile("pushfl; popl %0" : "=r" (eflags));
f0104cf2:	9c                   	pushf  
f0104cf3:	58                   	pop    %eax
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0104cf4:	f6 c4 02             	test   $0x2,%ah
f0104cf7:	74 24                	je     f0104d1d <trap+0x69>
f0104cf9:	c7 44 24 0c fc 7e 10 	movl   $0xf0107efc,0xc(%esp)
f0104d00:	f0 
f0104d01:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0104d08:	f0 
f0104d09:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
f0104d10:	00 
f0104d11:	c7 04 24 21 94 10 f0 	movl   $0xf0109421,(%esp)
f0104d18:	e8 68 b3 ff ff       	call   f0100085 <_panic>

	if ((tf->tf_cs & 3) == 3) {
f0104d1d:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104d21:	83 e0 03             	and    $0x3,%eax
f0104d24:	83 f8 03             	cmp    $0x3,%eax
f0104d27:	0f 85 a9 00 00 00    	jne    f0104dd6 <trap+0x122>
f0104d2d:	c7 04 24 a0 53 12 f0 	movl   $0xf01253a0,(%esp)
f0104d34:	e8 98 20 00 00       	call   f0106dd1 <spin_lock>
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		lock_kernel();
		assert(curenv);
f0104d39:	e8 c8 1c 00 00       	call   f0106a06 <cpunum>
f0104d3e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d41:	83 b8 28 20 27 f0 00 	cmpl   $0x0,-0xfd8dfd8(%eax)
f0104d48:	75 24                	jne    f0104d6e <trap+0xba>
f0104d4a:	c7 44 24 0c 2b 7f 10 	movl   $0xf0107f2b,0xc(%esp)
f0104d51:	f0 
f0104d52:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0104d59:	f0 
f0104d5a:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
f0104d61:	00 
f0104d62:	c7 04 24 21 94 10 f0 	movl   $0xf0109421,(%esp)
f0104d69:	e8 17 b3 ff ff       	call   f0100085 <_panic>

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
f0104d6e:	e8 93 1c 00 00       	call   f0106a06 <cpunum>
f0104d73:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d76:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0104d7c:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104d80:	75 2e                	jne    f0104db0 <trap+0xfc>
			env_free(curenv);
f0104d82:	e8 7f 1c 00 00       	call   f0106a06 <cpunum>
f0104d87:	be 20 20 27 f0       	mov    $0xf0272020,%esi
f0104d8c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d8f:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f0104d93:	89 04 24             	mov    %eax,(%esp)
f0104d96:	e8 a1 ef ff ff       	call   f0103d3c <env_free>
			curenv = NULL;
f0104d9b:	e8 66 1c 00 00       	call   f0106a06 <cpunum>
f0104da0:	6b c0 74             	imul   $0x74,%eax,%eax
f0104da3:	c7 44 30 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,1)
f0104daa:	00 
			sched_yield();
f0104dab:	e8 eb 02 00 00       	call   f010509b <sched_yield>
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f0104db0:	e8 51 1c 00 00       	call   f0106a06 <cpunum>
f0104db5:	bb 20 20 27 f0       	mov    $0xf0272020,%ebx
f0104dba:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dbd:	8b 44 18 08          	mov    0x8(%eax,%ebx,1),%eax
f0104dc1:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104dc6:	89 c7                	mov    %eax,%edi
f0104dc8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0104dca:	e8 37 1c 00 00       	call   f0106a06 <cpunum>
f0104dcf:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dd2:	8b 74 18 08          	mov    0x8(%eax,%ebx,1),%esi
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f0104dd6:	89 35 60 1a 27 f0    	mov    %esi,0xf0271a60
	// LAB 3: Your code here.

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104ddc:	8b 46 28             	mov    0x28(%esi),%eax
f0104ddf:	83 f8 27             	cmp    $0x27,%eax
f0104de2:	75 19                	jne    f0104dfd <trap+0x149>
		cprintf("Spurious interrupt on irq 7\n");
f0104de4:	c7 04 24 46 94 10 f0 	movl   $0xf0109446,(%esp)
f0104deb:	e8 0f f8 ff ff       	call   f01045ff <cprintf>
		print_trapframe(tf);
f0104df0:	89 34 24             	mov    %esi,(%esp)
f0104df3:	e8 7b fb ff ff       	call   f0104973 <print_trapframe>
f0104df8:	e9 dc 00 00 00       	jmp    f0104ed9 <trap+0x225>
	//if(tf->tf_trapno == 48 && tf->tf_regs.reg_eax==7)
	//{
		//cprintf("trap no = %d at cpu %d env %x\n",tf->tf_trapno,cpunum(),curenv->env_id);		
		//print_trapframe(tf);
	//}
	switch(tf->tf_trapno)
f0104dfd:	83 f8 30             	cmp    $0x30,%eax
f0104e00:	0f 87 92 00 00 00    	ja     f0104e98 <trap+0x1e4>
f0104e06:	ff 24 85 20 96 10 f0 	jmp    *-0xfef69e0(,%eax,4)
		case IRQ_OFFSET + IRQ_TIMER:
			//cprintf("clock interrupt on irq 7 on cpu %d\n",cpunum());
			//print_trapframe(tf);
			//cprintf("  eip  0x%08x\n", tf->tf_eip);
			//cprintf("  esp  0x%08x\n", tf->tf_esp);
			 lapic_eoi();
f0104e0d:	8d 76 00             	lea    0x0(%esi),%esi
f0104e10:	e8 0d 1c 00 00       	call   f0106a22 <lapic_eoi>
			 time_tick();
f0104e15:	e8 fc 2d 00 00       	call   f0107c16 <time_tick>
			 sched_yield();			
f0104e1a:	e8 7c 02 00 00       	call   f010509b <sched_yield>
			 break;
		case IRQ_OFFSET + IRQ_SERIAL:
			 serial_intr(); break;
f0104e1f:	90                   	nop
f0104e20:	e8 cc b5 ff ff       	call   f01003f1 <serial_intr>
f0104e25:	e9 af 00 00 00       	jmp    f0104ed9 <trap+0x225>
		case IRQ_OFFSET + IRQ_KBD:
			 kbd_intr(); break;
f0104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0104e30:	e8 aa b5 ff ff       	call   f01003df <kbd_intr>
f0104e35:	e9 9f 00 00 00       	jmp    f0104ed9 <trap+0x225>
		case T_DIVIDE: tf->tf_regs.reg_ecx = 1; break; 
f0104e3a:	c7 46 18 01 00 00 00 	movl   $0x1,0x18(%esi)
f0104e41:	e9 93 00 00 00       	jmp    f0104ed9 <trap+0x225>
		case T_PGFLT: page_fault_handler(tf); goto err;
f0104e46:	89 34 24             	mov    %esi,(%esp)
f0104e49:	e8 ab fc ff ff       	call   f0104af9 <page_fault_handler>
f0104e4e:	eb 48                	jmp    f0104e98 <trap+0x1e4>
		case T_SYSCALL:
			 res = syscall(tf->tf_regs.reg_eax,tf->tf_regs.reg_edx,tf->tf_regs.reg_ecx,tf->tf_regs.reg_ebx,tf->tf_regs.reg_edi,tf->tf_regs.reg_esi); 
f0104e50:	8b 46 04             	mov    0x4(%esi),%eax
f0104e53:	89 44 24 14          	mov    %eax,0x14(%esp)
f0104e57:	8b 06                	mov    (%esi),%eax
f0104e59:	89 44 24 10          	mov    %eax,0x10(%esp)
f0104e5d:	8b 46 10             	mov    0x10(%esi),%eax
f0104e60:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104e64:	8b 46 18             	mov    0x18(%esi),%eax
f0104e67:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104e6b:	8b 46 14             	mov    0x14(%esi),%eax
f0104e6e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104e72:	8b 46 1c             	mov    0x1c(%esi),%eax
f0104e75:	89 04 24             	mov    %eax,(%esp)
f0104e78:	e8 27 04 00 00       	call   f01052a4 <syscall>
			 tf->tf_regs.reg_eax = res; break;
f0104e7d:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104e80:	eb 57                	jmp    f0104ed9 <trap+0x225>
		case T_BRKPT:print_trapframe(tf);monitor(NULL);break;
f0104e82:	89 34 24             	mov    %esi,(%esp)
f0104e85:	e8 e9 fa ff ff       	call   f0104973 <print_trapframe>
f0104e8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0104e91:	e8 6d bb ff ff       	call   f0100a03 <monitor>
f0104e96:	eb 41                	jmp    f0104ed9 <trap+0x225>
	}
	
	return;
err:
	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f0104e98:	89 34 24             	mov    %esi,(%esp)
f0104e9b:	e8 d3 fa ff ff       	call   f0104973 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0104ea0:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104ea5:	75 1c                	jne    f0104ec3 <trap+0x20f>
		panic("unhandled trap in kernel");
f0104ea7:	c7 44 24 08 63 94 10 	movl   $0xf0109463,0x8(%esp)
f0104eae:	f0 
f0104eaf:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
f0104eb6:	00 
f0104eb7:	c7 04 24 21 94 10 f0 	movl   $0xf0109421,(%esp)
f0104ebe:	e8 c2 b1 ff ff       	call   f0100085 <_panic>
	else {
		env_destroy(curenv);
f0104ec3:	e8 3e 1b 00 00       	call   f0106a06 <cpunum>
f0104ec8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ecb:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0104ed1:	89 04 24             	mov    %eax,(%esp)
f0104ed4:	e8 6c f0 ff ff       	call   f0103f45 <env_destroy>
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP-cpunum()*(KSTKSIZE+KSTKGAP);
f0104ed9:	e8 28 1b 00 00       	call   f0106a06 <cpunum>
f0104ede:	89 c7                	mov    %eax,%edi
f0104ee0:	e8 21 1b 00 00       	call   f0106a06 <cpunum>
f0104ee5:	be 20 20 27 f0       	mov    $0xf0272020,%esi
f0104eea:	6b ff 74             	imul   $0x74,%edi,%edi
f0104eed:	c1 e0 10             	shl    $0x10,%eax
f0104ef0:	f7 d8                	neg    %eax
f0104ef2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0104ef7:	89 44 37 10          	mov    %eax,0x10(%edi,%esi,1)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0104efb:	e8 06 1b 00 00       	call   f0106a06 <cpunum>
f0104f00:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f03:	66 c7 44 30 14 10 00 	movw   $0x10,0x14(%eax,%esi,1)
	thiscpu->cpu_ts.ts_eflags = 0;
f0104f0a:	e8 f7 1a 00 00       	call   f0106a06 <cpunum>
f0104f0f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f12:	c7 44 30 30 00 00 00 	movl   $0x0,0x30(%eax,%esi,1)
f0104f19:	00 
	
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104f1a:	e8 e7 1a 00 00       	call   f0106a06 <cpunum>
f0104f1f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f22:	83 7c 30 08 00       	cmpl   $0x0,0x8(%eax,%esi,1)
f0104f27:	74 2a                	je     f0104f53 <trap+0x29f>
f0104f29:	e8 d8 1a 00 00       	call   f0106a06 <cpunum>
f0104f2e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f31:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0104f37:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104f3b:	75 16                	jne    f0104f53 <trap+0x29f>
		env_run(curenv);
f0104f3d:	e8 c4 1a 00 00       	call   f0106a06 <cpunum>
f0104f42:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f45:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0104f4b:	89 04 24             	mov    %eax,(%esp)
f0104f4e:	e8 81 ec ff ff       	call   f0103bd4 <env_run>
	else
		sched_yield();
f0104f53:	e8 43 01 00 00       	call   f010509b <sched_yield>

f0104f58 <BRKPT_HANDLER>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(BRKPT_HANDLER, T_BRKPT)	
f0104f58:	fa                   	cli    
f0104f59:	6a 00                	push   $0x0
f0104f5b:	6a 03                	push   $0x3
f0104f5d:	eb 44                	jmp    f0104fa3 <_alltraps>
f0104f5f:	90                   	nop

f0104f60 <SYSCALL_HANDLER>:

TRAPHANDLER_NOEC(SYSCALL_HANDLER,T_SYSCALL)
f0104f60:	fa                   	cli    
f0104f61:	6a 00                	push   $0x0
f0104f63:	6a 30                	push   $0x30
f0104f65:	eb 3c                	jmp    f0104fa3 <_alltraps>
f0104f67:	90                   	nop

f0104f68 <PGFLT_HANDLER>:

TRAPHANDLER(PGFLT_HANDLER,T_PGFLT) 
f0104f68:	fa                   	cli    
f0104f69:	6a 0e                	push   $0xe
f0104f6b:	eb 36                	jmp    f0104fa3 <_alltraps>
f0104f6d:	90                   	nop

f0104f6e <DIV_HANDLER>:

TRAPHANDLER_NOEC(DIV_HANDLER,T_DIVIDE)
f0104f6e:	fa                   	cli    
f0104f6f:	6a 00                	push   $0x0
f0104f71:	6a 00                	push   $0x0
f0104f73:	eb 2e                	jmp    f0104fa3 <_alltraps>
f0104f75:	90                   	nop

f0104f76 <GPFLT_HANDLER>:

TRAPHANDLER(GPFLT_HANDLER,T_GPFLT)
f0104f76:	fa                   	cli    
f0104f77:	6a 0d                	push   $0xd
f0104f79:	eb 28                	jmp    f0104fa3 <_alltraps>
f0104f7b:	90                   	nop

f0104f7c <IRQ_TIMER_HANDLER>:

TRAPHANDLER_NOEC(IRQ_TIMER_HANDLER,IRQ_OFFSET+IRQ_TIMER)
f0104f7c:	fa                   	cli    
f0104f7d:	6a 00                	push   $0x0
f0104f7f:	6a 20                	push   $0x20
f0104f81:	eb 20                	jmp    f0104fa3 <_alltraps>
f0104f83:	90                   	nop

f0104f84 <IRQ_KBD_HANDLER>:

TRAPHANDLER_NOEC(IRQ_KBD_HANDLER,IRQ_OFFSET+IRQ_KBD)
f0104f84:	fa                   	cli    
f0104f85:	6a 00                	push   $0x0
f0104f87:	6a 21                	push   $0x21
f0104f89:	eb 18                	jmp    f0104fa3 <_alltraps>
f0104f8b:	90                   	nop

f0104f8c <IRQ_SERIAL_HANDLER>:

TRAPHANDLER_NOEC(IRQ_SERIAL_HANDLER,IRQ_OFFSET+IRQ_SERIAL)
f0104f8c:	fa                   	cli    
f0104f8d:	6a 00                	push   $0x0
f0104f8f:	6a 24                	push   $0x24
f0104f91:	eb 10                	jmp    f0104fa3 <_alltraps>
f0104f93:	90                   	nop

f0104f94 <IRQ_SPURIOUS_HANDLER>:

TRAPHANDLER_NOEC(IRQ_SPURIOUS_HANDLER,IRQ_OFFSET+IRQ_SPURIOUS)
f0104f94:	fa                   	cli    
f0104f95:	6a 00                	push   $0x0
f0104f97:	6a 27                	push   $0x27
f0104f99:	eb 08                	jmp    f0104fa3 <_alltraps>
f0104f9b:	90                   	nop

f0104f9c <IRQ_IDE_HANDLER>:

TRAPHANDLER_NOEC(IRQ_IDE_HANDLER,IRQ_OFFSET+IRQ_IDE)
f0104f9c:	fa                   	cli    
f0104f9d:	6a 00                	push   $0x0
f0104f9f:	6a 2e                	push   $0x2e
f0104fa1:	eb 00                	jmp    f0104fa3 <_alltraps>

f0104fa3 <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds;
f0104fa3:	1e                   	push   %ds
	pushl %es;
f0104fa4:	06                   	push   %es

	pushl %eax;
f0104fa5:	50                   	push   %eax
	pushl %ecx;
f0104fa6:	51                   	push   %ecx
	pushl %edx;
f0104fa7:	52                   	push   %edx
	pushl %ebx;
f0104fa8:	53                   	push   %ebx
	pushl $0;
f0104fa9:	6a 00                	push   $0x0
	pushl %ebp;	
f0104fab:	55                   	push   %ebp
	pushl %esi;
f0104fac:	56                   	push   %esi
	pushl %edi;
f0104fad:	57                   	push   %edi
	
#	mov  $0x08,%eax
#	mov	 %eax,%cs

	mov  $0x10,%eax	
f0104fae:	b8 10 00 00 00       	mov    $0x10,%eax
	mov	 %eax,%ds
f0104fb3:	8e d8                	mov    %eax,%ds
	mov	 %eax,%ss
f0104fb5:	8e d0                	mov    %eax,%ss
	mov	 %eax,%es
f0104fb7:	8e c0                	mov    %eax,%es

	mov	 %esp,%eax
f0104fb9:	89 e0                	mov    %esp,%eax
#	mov	 $4,%ebx
#	sub  %ebx,%eax
	pushl %eax
f0104fbb:	50                   	push   %eax
	
call trap
f0104fbc:	e8 f3 fc ff ff       	call   f0104cb4 <trap>
f0104fc1:	00 00                	add    %al,(%eax)
	...

f0104fc4 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104fc4:	55                   	push   %ebp
f0104fc5:	89 e5                	mov    %esp,%ebp
f0104fc7:	83 ec 18             	sub    $0x18,%esp
f0104fca:	8b 15 38 12 27 f0    	mov    0xf0271238,%edx
f0104fd0:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104fd5:	8b 4a 54             	mov    0x54(%edx),%ecx
f0104fd8:	83 e9 01             	sub    $0x1,%ecx
f0104fdb:	83 f9 02             	cmp    $0x2,%ecx
f0104fde:	76 0f                	jbe    f0104fef <sched_halt+0x2b>
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104fe0:	83 c0 01             	add    $0x1,%eax
f0104fe3:	83 c2 7c             	add    $0x7c,%edx
f0104fe6:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104feb:	75 e8                	jne    f0104fd5 <sched_halt+0x11>
f0104fed:	eb 07                	jmp    f0104ff6 <sched_halt+0x32>
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
f0104fef:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104ff4:	75 1a                	jne    f0105010 <sched_halt+0x4c>
		cprintf("No runnable environments in the system!\n");
f0104ff6:	c7 04 24 50 97 10 f0 	movl   $0xf0109750,(%esp)
f0104ffd:	e8 fd f5 ff ff       	call   f01045ff <cprintf>
		while (1)
			monitor(NULL);
f0105002:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0105009:	e8 f5 b9 ff ff       	call   f0100a03 <monitor>
f010500e:	eb f2                	jmp    f0105002 <sched_halt+0x3e>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0105010:	e8 f1 19 00 00       	call   f0106a06 <cpunum>
f0105015:	6b c0 74             	imul   $0x74,%eax,%eax
f0105018:	c7 80 28 20 27 f0 00 	movl   $0x0,-0xfd8dfd8(%eax)
f010501f:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0105022:	a1 a8 1e 27 f0       	mov    0xf0271ea8,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0105027:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010502c:	77 20                	ja     f010504e <sched_halt+0x8a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010502e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105032:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0105039:	f0 
f010503a:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
f0105041:	00 
f0105042:	c7 04 24 79 97 10 f0 	movl   $0xf0109779,(%esp)
f0105049:	e8 37 b0 ff ff       	call   f0100085 <_panic>
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f010504e:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f0105054:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0105057:	e8 aa 19 00 00       	call   f0106a06 <cpunum>
f010505c:	6b d0 74             	imul   $0x74,%eax,%edx
f010505f:	81 c2 24 20 27 f0    	add    $0xf0272024,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0105065:	b8 02 00 00 00       	mov    $0x2,%eax
f010506a:	f0 87 02             	lock xchg %eax,(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f010506d:	c7 04 24 a0 53 12 f0 	movl   $0xf01253a0,(%esp)
f0105074:	e8 47 1c 00 00       	call   f0106cc0 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0105079:	f3 90                	pause  
		"pushl $0\n"
		"sti\n"
		"1:\n"
		"lock hlt\n"
		"lock jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f010507b:	e8 86 19 00 00       	call   f0106a06 <cpunum>

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
f0105080:	6b c0 74             	imul   $0x74,%eax,%eax
f0105083:	8b 80 30 20 27 f0    	mov    -0xfd8dfd0(%eax),%eax
f0105089:	bd 00 00 00 00       	mov    $0x0,%ebp
f010508e:	89 c4                	mov    %eax,%esp
f0105090:	6a 00                	push   $0x0
f0105092:	6a 00                	push   $0x0
f0105094:	fb                   	sti    
f0105095:	f0 f4                	lock hlt 
f0105097:	eb fc                	jmp    f0105095 <sched_halt+0xd1>
		"sti\n"
		"1:\n"
		"lock hlt\n"
		"lock jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
}
f0105099:	c9                   	leave  
f010509a:	c3                   	ret    

f010509b <sched_yield>:
void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f010509b:	55                   	push   %ebp
f010509c:	89 e5                	mov    %esp,%ebp
f010509e:	56                   	push   %esi
f010509f:	53                   	push   %ebx
f01050a0:	83 ec 10             	sub    $0x10,%esp
	// no runnable environments, simply drop through to the code
	// below to halt the cpu.

	// LAB 4: Your code here.
	
	if(!curenv) curr = &envs[0];
f01050a3:	e8 5e 19 00 00       	call   f0106a06 <cpunum>
f01050a8:	6b c0 74             	imul   $0x74,%eax,%eax
f01050ab:	83 b8 28 20 27 f0 00 	cmpl   $0x0,-0xfd8dfd8(%eax)
f01050b2:	75 07                	jne    f01050bb <sched_yield+0x20>
f01050b4:	a1 38 12 27 f0       	mov    0xf0271238,%eax
f01050b9:	eb 0e                	jmp    f01050c9 <sched_yield+0x2e>
	else curr = curenv;
f01050bb:	e8 46 19 00 00       	call   f0106a06 <cpunum>
f01050c0:	6b c0 74             	imul   $0x74,%eax,%eax
f01050c3:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax

	if(curr-envs == NENV-1)
f01050c9:	8b 1d 38 12 27 f0    	mov    0xf0271238,%ebx
f01050cf:	89 de                	mov    %ebx,%esi
f01050d1:	89 c2                	mov    %eax,%edx
f01050d3:	29 da                	sub    %ebx,%edx
f01050d5:	81 ea 84 ef 01 00    	sub    $0x1ef84,%edx
		sel = envs;
	else
		sel = curr+1;
f01050db:	83 c0 7c             	add    $0x7c,%eax
f01050de:	83 fa 7c             	cmp    $0x7c,%edx
f01050e1:	0f 42 c3             	cmovb  %ebx,%eax
	if(curenv && curenv->env_status == ENV_RUNNING)
		env_run(curenv);

	// sched_halt never returns
	sched_halt();
}
f01050e4:	ba 00 00 00 00       	mov    $0x0,%edx
	else
		sel = curr+1;
	
	for (i = 0; i < NENV; i++) 
	{
		if (sel->env_status == ENV_RUNNABLE) break;
f01050e9:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01050ed:	74 20                	je     f010510f <sched_yield+0x74>
		if(sel-envs == NENV-1) sel = envs;
f01050ef:	89 c1                	mov    %eax,%ecx
f01050f1:	29 f1                	sub    %esi,%ecx
f01050f3:	81 e9 84 ef 01 00    	sub    $0x1ef84,%ecx
f01050f9:	83 c0 7c             	add    $0x7c,%eax
f01050fc:	83 f9 7b             	cmp    $0x7b,%ecx
f01050ff:	0f 46 c3             	cmovbe %ebx,%eax
	if(curr-envs == NENV-1)
		sel = envs;
	else
		sel = curr+1;
	
	for (i = 0; i < NENV; i++) 
f0105102:	83 c2 01             	add    $0x1,%edx
f0105105:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f010510b:	75 dc                	jne    f01050e9 <sched_yield+0x4e>
f010510d:	eb 10                	jmp    f010511f <sched_yield+0x84>
		
	}
	//cprintf("env %x is selected on round %d at cpu %d\n", sel->env_id, i, cpunum());	
	//cprintf("%s %x state = %d selected %d\n",__func__, envs[0].env_id,envs[0].env_status,i);

	if (i != NENV)	env_run(sel);
f010510f:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f0105115:	74 08                	je     f010511f <sched_yield+0x84>
f0105117:	89 04 24             	mov    %eax,(%esp)
f010511a:	e8 b5 ea ff ff       	call   f0103bd4 <env_run>

	if(curenv && curenv->env_status == ENV_RUNNING)
f010511f:	e8 e2 18 00 00       	call   f0106a06 <cpunum>
f0105124:	6b c0 74             	imul   $0x74,%eax,%eax
f0105127:	83 b8 28 20 27 f0 00 	cmpl   $0x0,-0xfd8dfd8(%eax)
f010512e:	74 2a                	je     f010515a <sched_yield+0xbf>
f0105130:	e8 d1 18 00 00       	call   f0106a06 <cpunum>
f0105135:	6b c0 74             	imul   $0x74,%eax,%eax
f0105138:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f010513e:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0105142:	75 16                	jne    f010515a <sched_yield+0xbf>
		env_run(curenv);
f0105144:	e8 bd 18 00 00       	call   f0106a06 <cpunum>
f0105149:	6b c0 74             	imul   $0x74,%eax,%eax
f010514c:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0105152:	89 04 24             	mov    %eax,(%esp)
f0105155:	e8 7a ea ff ff       	call   f0103bd4 <env_run>

	// sched_halt never returns
	sched_halt();
f010515a:	e8 65 fe ff ff       	call   f0104fc4 <sched_halt>
}
f010515f:	83 c4 10             	add    $0x10,%esp
f0105162:	5b                   	pop    %ebx
f0105163:	5e                   	pop    %esi
f0105164:	5d                   	pop    %ebp
f0105165:	c3                   	ret    
	...

f0105170 <sys_print_trapframe>:
{
	sched_yield();
}

void sys_print_trapframe(struct Trapframe *tf)
{
f0105170:	55                   	push   %ebp
f0105171:	89 e5                	mov    %esp,%ebp
f0105173:	53                   	push   %ebx
f0105174:	83 ec 14             	sub    $0x14,%esp
f0105177:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f010517a:	e8 87 18 00 00       	call   f0106a06 <cpunum>
f010517f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105183:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105187:	c7 04 24 f7 92 10 f0 	movl   $0xf01092f7,(%esp)
f010518e:	e8 6c f4 ff ff       	call   f01045ff <cprintf>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0105193:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0105197:	89 44 24 04          	mov    %eax,0x4(%esp)
f010519b:	c7 04 24 15 93 10 f0 	movl   $0xf0109315,(%esp)
f01051a2:	e8 58 f4 ff ff       	call   f01045ff <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01051a7:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01051ab:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051af:	c7 04 24 28 93 10 f0 	movl   $0xf0109328,(%esp)
f01051b6:	e8 44 f4 ff ff       	call   f01045ff <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f01051bb:	8b 43 30             	mov    0x30(%ebx),%eax
f01051be:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051c2:	c7 04 24 ce 93 10 f0 	movl   $0xf01093ce,(%esp)
f01051c9:	e8 31 f4 ff ff       	call   f01045ff <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f01051ce:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01051d2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051d6:	c7 04 24 dd 93 10 f0 	movl   $0xf01093dd,(%esp)
f01051dd:	e8 1d f4 ff ff       	call   f01045ff <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01051e2:	8b 43 38             	mov    0x38(%ebx),%eax
f01051e5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051e9:	c7 04 24 f0 93 10 f0 	movl   $0xf01093f0,(%esp)
f01051f0:	e8 0a f4 ff ff       	call   f01045ff <cprintf>
	cprintf("  esp  0x%08x\n", tf->tf_esp);
f01051f5:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01051f8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051fc:	c7 04 24 ff 93 10 f0 	movl   $0xf01093ff,(%esp)
f0105203:	e8 f7 f3 ff ff       	call   f01045ff <cprintf>
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0105208:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f010520c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105210:	c7 04 24 0e 94 10 f0 	movl   $0xf010940e,(%esp)
f0105217:	e8 e3 f3 ff ff       	call   f01045ff <cprintf>
}
f010521c:	83 c4 14             	add    $0x14,%esp
f010521f:	5b                   	pop    %ebx
f0105220:	5d                   	pop    %ebp
f0105221:	c3                   	ret    

f0105222 <sys_page_map>:
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
f0105222:	55                   	push   %ebp
f0105223:	89 e5                	mov    %esp,%ebp
f0105225:	56                   	push   %esi
f0105226:	53                   	push   %ebx
f0105227:	83 ec 20             	sub    $0x20,%esp
f010522a:	89 d6                	mov    %edx,%esi
f010522c:	89 cb                	mov    %ecx,%ebx

	// LAB 4: Your code here.
	struct Env * src_env, *dest_env;
	pte_t * pte;
	int ret;
	ret = envid2env(srcenvid,&src_env,0);
f010522e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0105235:	00 
f0105236:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0105239:	89 54 24 04          	mov    %edx,0x4(%esp)
f010523d:	89 04 24             	mov    %eax,(%esp)
f0105240:	e8 6a e8 ff ff       	call   f0103aaf <envid2env>
	if(ret < 0) return ret;
f0105245:	85 c0                	test   %eax,%eax
f0105247:	78 54                	js     f010529d <sys_page_map+0x7b>
	ret = envid2env(dstenvid,&dest_env,0);
f0105249:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0105250:	00 
f0105251:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0105254:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105258:	89 1c 24             	mov    %ebx,(%esp)
f010525b:	e8 4f e8 ff ff       	call   f0103aaf <envid2env>
	if(ret < 0) return ret;	
f0105260:	85 c0                	test   %eax,%eax
f0105262:	78 39                	js     f010529d <sys_page_map+0x7b>

	struct PageInfo *pp = page_lookup(src_env->env_pgdir,srcva,&pte);
f0105264:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105267:	89 44 24 08          	mov    %eax,0x8(%esp)
f010526b:	89 74 24 04          	mov    %esi,0x4(%esp)
f010526f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105272:	8b 40 60             	mov    0x60(%eax),%eax
f0105275:	89 04 24             	mov    %eax,(%esp)
f0105278:	e8 a4 c4 ff ff       	call   f0101721 <page_lookup>
	ret = page_insert(dest_env->env_pgdir,pp,dstva,perm);
f010527d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105280:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105284:	8b 55 08             	mov    0x8(%ebp),%edx
f0105287:	89 54 24 08          	mov    %edx,0x8(%esp)
f010528b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010528f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105292:	8b 40 60             	mov    0x60(%eax),%eax
f0105295:	89 04 24             	mov    %eax,(%esp)
f0105298:	e8 4d c5 ff ff       	call   f01017ea <page_insert>
	return ret;

}
f010529d:	83 c4 20             	add    $0x20,%esp
f01052a0:	5b                   	pop    %ebx
f01052a1:	5e                   	pop    %esi
f01052a2:	5d                   	pop    %ebp
f01052a3:	c3                   	ret    

f01052a4 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01052a4:	55                   	push   %ebp
f01052a5:	89 e5                	mov    %esp,%ebp
f01052a7:	83 ec 48             	sub    $0x48,%esp
f01052aa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f01052ad:	89 75 f8             	mov    %esi,-0x8(%ebp)
f01052b0:	89 7d fc             	mov    %edi,-0x4(%ebp)
f01052b3:	8b 55 08             	mov    0x8(%ebp),%edx
f01052b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01052b9:	8b 7d 10             	mov    0x10(%ebp),%edi
f01052bc:	8b 75 18             	mov    0x18(%ebp),%esi
	//panic("syscall not implemented");
	int32_t res = 0;

	//cprintf("syscall no = %d\n",syscallno);
		
	switch (syscallno) {
f01052bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01052c4:	83 fa 10             	cmp    $0x10,%edx
f01052c7:	0f 87 5a 05 00 00    	ja     f0105827 <syscall+0x583>
f01052cd:	ff 24 95 c0 97 10 f0 	jmp    *-0xfef6840(,%edx,4)
	default:
		return -E_INVAL;
		case SYS_cputs: sys_cputs((char *)a1, (size_t)a2); break;
f01052d4:	89 5d d0             	mov    %ebx,-0x30(%ebp)
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).	
	user_mem_assert(curenv,(void *)s,len,PTE_P);
f01052d7:	e8 2a 17 00 00       	call   f0106a06 <cpunum>
f01052dc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
f01052e3:	00 
f01052e4:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01052e8:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01052eb:	89 54 24 04          	mov    %edx,0x4(%esp)
f01052ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01052f2:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f01052f8:	89 04 24             	mov    %eax,(%esp)
f01052fb:	e8 ee c2 ff ff       	call   f01015ee <user_mem_assert>
	void * end = ROUNDUP((void *)(s+len),PGSIZE);
f0105300:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0105303:	8d 84 3a ff 0f 00 00 	lea    0xfff(%edx,%edi,1),%eax
f010530a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010530f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105312:	89 d3                	mov    %edx,%ebx
	void * start = (void *)s;
	while(start < end)
	{
		pte_t *p = pgdir_walk(curenv->env_pgdir,start,0);
f0105314:	be 20 20 27 f0       	mov    $0xf0272020,%esi
f0105319:	eb 46                	jmp    f0105361 <syscall+0xbd>
f010531b:	e8 e6 16 00 00       	call   f0106a06 <cpunum>
f0105320:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0105327:	00 
f0105328:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010532c:	6b c0 74             	imul   $0x74,%eax,%eax
f010532f:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f0105333:	8b 40 60             	mov    0x60(%eax),%eax
f0105336:	89 04 24             	mov    %eax,(%esp)
f0105339:	e8 6a c1 ff ff       	call   f01014a8 <pgdir_walk>
		// Destroy the environment if not.
		if(!p || !(*p & PTE_U)) env_destroy(curenv);
f010533e:	85 c0                	test   %eax,%eax
f0105340:	74 05                	je     f0105347 <syscall+0xa3>
f0105342:	f6 00 04             	testb  $0x4,(%eax)
f0105345:	75 14                	jne    f010535b <syscall+0xb7>
f0105347:	e8 ba 16 00 00       	call   f0106a06 <cpunum>
f010534c:	6b c0 74             	imul   $0x74,%eax,%eax
f010534f:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f0105353:	89 04 24             	mov    %eax,(%esp)
f0105356:	e8 ea eb ff ff       	call   f0103f45 <env_destroy>
		start+=PGSIZE;
f010535b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
{
	// Check that the user has permission to read memory [s, s+len).	
	user_mem_assert(curenv,(void *)s,len,PTE_P);
	void * end = ROUNDUP((void *)(s+len),PGSIZE);
	void * start = (void *)s;
	while(start < end)
f0105361:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0105364:	77 b5                	ja     f010531b <syscall+0x77>
		if(!p || !(*p & PTE_U)) env_destroy(curenv);
		start+=PGSIZE;
	}

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f0105366:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105369:	89 44 24 08          	mov    %eax,0x8(%esp)
f010536d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105371:	c7 04 24 86 97 10 f0 	movl   $0xf0109786,(%esp)
f0105378:	e8 82 f2 ff ff       	call   f01045ff <cprintf>
f010537d:	b8 00 00 00 00       	mov    $0x0,%eax
	//cprintf("syscall no = %d\n",syscallno);
		
	switch (syscallno) {
	default:
		return -E_INVAL;
		case SYS_cputs: sys_cputs((char *)a1, (size_t)a2); break;
f0105382:	e9 a0 04 00 00       	jmp    f0105827 <syscall+0x583>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f0105387:	e8 80 b0 ff ff       	call   f010040c <cons_getc>
f010538c:	b8 00 00 00 00       	mov    $0x0,%eax
		
	switch (syscallno) {
	default:
		return -E_INVAL;
		case SYS_cputs: sys_cputs((char *)a1, (size_t)a2); break;
		case SYS_cgetc: sys_cgetc(); break;
f0105391:	e9 91 04 00 00       	jmp    f0105827 <syscall+0x583>

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f0105396:	e8 6b 16 00 00       	call   f0106a06 <cpunum>
f010539b:	6b c0 74             	imul   $0x74,%eax,%eax
f010539e:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f01053a4:	8b 40 48             	mov    0x48(%eax),%eax
	switch (syscallno) {
	default:
		return -E_INVAL;
		case SYS_cputs: sys_cputs((char *)a1, (size_t)a2); break;
		case SYS_cgetc: sys_cgetc(); break;
		case SYS_getenvid: res = (int)sys_getenvid(); break;
f01053a7:	e9 7b 04 00 00       	jmp    f0105827 <syscall+0x583>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f01053ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01053b3:	00 
f01053b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01053b7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053bb:	89 1c 24             	mov    %ebx,(%esp)
f01053be:	e8 ec e6 ff ff       	call   f0103aaf <envid2env>
f01053c3:	85 c0                	test   %eax,%eax
f01053c5:	0f 88 5c 04 00 00    	js     f0105827 <syscall+0x583>
		return r;
	if (e == curenv)
f01053cb:	e8 36 16 00 00       	call   f0106a06 <cpunum>
f01053d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01053d3:	6b c0 74             	imul   $0x74,%eax,%eax
f01053d6:	39 90 28 20 27 f0    	cmp    %edx,-0xfd8dfd8(%eax)
f01053dc:	75 23                	jne    f0105401 <syscall+0x15d>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01053de:	e8 23 16 00 00       	call   f0106a06 <cpunum>
f01053e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01053e6:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f01053ec:	8b 40 48             	mov    0x48(%eax),%eax
f01053ef:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053f3:	c7 04 24 8b 97 10 f0 	movl   $0xf010978b,(%esp)
f01053fa:	e8 00 f2 ff ff       	call   f01045ff <cprintf>
f01053ff:	eb 28                	jmp    f0105429 <syscall+0x185>
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0105401:	8b 5a 48             	mov    0x48(%edx),%ebx
f0105404:	e8 fd 15 00 00       	call   f0106a06 <cpunum>
f0105409:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010540d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105410:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0105416:	8b 40 48             	mov    0x48(%eax),%eax
f0105419:	89 44 24 04          	mov    %eax,0x4(%esp)
f010541d:	c7 04 24 a6 97 10 f0 	movl   $0xf01097a6,(%esp)
f0105424:	e8 d6 f1 ff ff       	call   f01045ff <cprintf>
	env_destroy(e);
f0105429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010542c:	89 04 24             	mov    %eax,(%esp)
f010542f:	e8 11 eb ff ff       	call   f0103f45 <env_destroy>
f0105434:	b8 00 00 00 00       	mov    $0x0,%eax
f0105439:	e9 e9 03 00 00       	jmp    f0105827 <syscall+0x583>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f010543e:	e8 58 fc ff ff       	call   f010509b <sched_yield>
	// will appear to return 0.

	// LAB 4: Your code here.
	struct Env * new_env;
	
	env_alloc(&new_env,curenv->env_id);
f0105443:	e8 be 15 00 00       	call   f0106a06 <cpunum>
f0105448:	bb 20 20 27 f0       	mov    $0xf0272020,%ebx
f010544d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105450:	8b 44 18 08          	mov    0x8(%eax,%ebx,1),%eax
f0105454:	8b 40 48             	mov    0x48(%eax),%eax
f0105457:	89 44 24 04          	mov    %eax,0x4(%esp)
f010545b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010545e:	89 04 24             	mov    %eax,(%esp)
f0105461:	e8 3d eb ff ff       	call   f0103fa3 <env_alloc>
	new_env->env_status = ENV_NOT_RUNNABLE;
f0105466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105469:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	memcpy(&(new_env->env_tf),&(curenv->env_tf),sizeof(struct Trapframe));
f0105470:	e8 91 15 00 00       	call   f0106a06 <cpunum>
f0105475:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f010547c:	00 
f010547d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105480:	8b 44 18 08          	mov    0x8(%eax,%ebx,1),%eax
f0105484:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010548b:	89 04 24             	mov    %eax,(%esp)
f010548e:	e8 d8 0f 00 00       	call   f010646b <memcpy>
	new_env->env_tf.tf_regs.reg_eax = 0;
f0105493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105496:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	return new_env->env_id;
f010549d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01054a0:	8b 40 48             	mov    0x48(%eax),%eax
		case SYS_cputs: sys_cputs((char *)a1, (size_t)a2); break;
		case SYS_cgetc: sys_cgetc(); break;
		case SYS_getenvid: res = (int)sys_getenvid(); break;
		case SYS_env_destroy: res = sys_env_destroy((envid_t)a1); break;
		case SYS_yield: sys_yield(); break;
		case SYS_exofork: res = sys_exofork(); break;
f01054a3:	e9 7f 03 00 00       	jmp    f0105827 <syscall+0x583>
	// envid's status.

	// LAB 4: Your code here.
	struct Env * curr_env;
	int ret;
	ret = envid2env(envid,&curr_env,1);
f01054a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01054af:	00 
f01054b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01054b3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01054b7:	89 1c 24             	mov    %ebx,(%esp)
f01054ba:	e8 f0 e5 ff ff       	call   f0103aaf <envid2env>
	if(ret < 0) return ret;
f01054bf:	85 c0                	test   %eax,%eax
f01054c1:	0f 88 60 03 00 00    	js     f0105827 <syscall+0x583>
	curr_env->env_status = status;
f01054c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01054ca:	89 78 54             	mov    %edi,0x54(%eax)
f01054cd:	b8 00 00 00 00       	mov    $0x0,%eax
f01054d2:	e9 50 03 00 00       	jmp    f0105827 <syscall+0x583>

	// LAB 4: Your code here.
	struct Env * curr_env;
	int ret;

	ret = envid2env(envid,&curr_env,1);
f01054d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01054de:	00 
f01054df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01054e2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01054e6:	89 1c 24             	mov    %ebx,(%esp)
f01054e9:	e8 c1 e5 ff ff       	call   f0103aaf <envid2env>
	if(ret < 0) return ret;
f01054ee:	85 c0                	test   %eax,%eax
f01054f0:	0f 88 31 03 00 00    	js     f0105827 <syscall+0x583>

	if(curr_env->env_status == ENV_FREE || curr_env->env_status == ENV_DYING)
f01054f6:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01054fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01054fe:	83 7a 54 01          	cmpl   $0x1,0x54(%edx)
f0105502:	0f 86 1f 03 00 00    	jbe    f0105827 <syscall+0x583>
		return -E_BAD_ENV;
	if((uintptr_t)va >= UTOP || (uintptr_t)va%PGSIZE) return -E_INVAL;
f0105508:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f010550e:	77 58                	ja     f0105568 <syscall+0x2c4>
f0105510:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f0105516:	75 50                	jne    f0105568 <syscall+0x2c4>
	if( !(perm & PTE_U) || !(perm & PTE_P)) return -E_INVAL;
f0105518:	8b 45 14             	mov    0x14(%ebp),%eax
f010551b:	83 e0 05             	and    $0x5,%eax
f010551e:	83 f8 05             	cmp    $0x5,%eax
f0105521:	75 45                	jne    f0105568 <syscall+0x2c4>

	struct PageInfo *pp = page_alloc(1);
f0105523:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010552a:	e8 c3 be ff ff       	call   f01013f2 <page_alloc>
f010552f:	89 c3                	mov    %eax,%ebx
	ret = page_insert(curr_env->env_pgdir,pp,va,perm);
f0105531:	8b 55 14             	mov    0x14(%ebp),%edx
f0105534:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105538:	89 7c 24 08          	mov    %edi,0x8(%esp)
f010553c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105543:	8b 40 60             	mov    0x60(%eax),%eax
f0105546:	89 04 24             	mov    %eax,(%esp)
f0105549:	e8 9c c2 ff ff       	call   f01017ea <page_insert>
	if(ret<0)	{page_free(pp); return -E_NO_MEM;}
f010554e:	85 c0                	test   %eax,%eax
f0105550:	0f 89 d1 02 00 00    	jns    f0105827 <syscall+0x583>
f0105556:	89 1c 24             	mov    %ebx,(%esp)
f0105559:	e8 39 b8 ff ff       	call   f0100d97 <page_free>
f010555e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105563:	e9 bf 02 00 00       	jmp    f0105827 <syscall+0x583>
f0105568:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010556d:	e9 b5 02 00 00       	jmp    f0105827 <syscall+0x583>
		case SYS_env_destroy: res = sys_env_destroy((envid_t)a1); break;
		case SYS_yield: sys_yield(); break;
		case SYS_exofork: res = sys_exofork(); break;
		case SYS_env_set_status: res = sys_env_set_status(a1,a2); break;
		case SYS_page_alloc: res = sys_page_alloc(a1,(void *)a2,a3); break;
		case SYS_page_map: res = sys_page_map((envid_t)a1,(void *)a2,(envid_t)a3,(void *)a4,a5); break;
f0105572:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105575:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105579:	89 34 24             	mov    %esi,(%esp)
f010557c:	8b 4d 14             	mov    0x14(%ebp),%ecx
f010557f:	89 fa                	mov    %edi,%edx
f0105581:	89 d8                	mov    %ebx,%eax
f0105583:	e8 9a fc ff ff       	call   f0105222 <sys_page_map>
f0105588:	e9 9a 02 00 00       	jmp    f0105827 <syscall+0x583>

	// LAB 4: Your code here.
	struct Env * curr_env;
	int ret;
	
	ret = envid2env(envid,&curr_env,1);
f010558d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105594:	00 
f0105595:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105598:	89 44 24 04          	mov    %eax,0x4(%esp)
f010559c:	89 1c 24             	mov    %ebx,(%esp)
f010559f:	e8 0b e5 ff ff       	call   f0103aaf <envid2env>
	if(ret < 0) return ret;
f01055a4:	85 c0                	test   %eax,%eax
f01055a6:	0f 88 7b 02 00 00    	js     f0105827 <syscall+0x583>
	
	page_remove(curr_env->env_pgdir,va);
f01055ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01055b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01055b3:	8b 40 60             	mov    0x60(%eax),%eax
f01055b6:	89 04 24             	mov    %eax,(%esp)
f01055b9:	e8 d4 c1 ff ff       	call   f0101792 <page_remove>
f01055be:	b8 00 00 00 00       	mov    $0x0,%eax
f01055c3:	e9 5f 02 00 00       	jmp    f0105827 <syscall+0x583>
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	struct Env * curr_env;
	int ret;
	ret = envid2env(envid,&curr_env,1);
f01055c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01055cf:	00 
f01055d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01055d3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01055d7:	89 1c 24             	mov    %ebx,(%esp)
f01055da:	e8 d0 e4 ff ff       	call   f0103aaf <envid2env>
	if(ret < 0) return ret;
f01055df:	85 c0                	test   %eax,%eax
f01055e1:	0f 88 3b 02 00 00    	js     f0105822 <syscall+0x57e>

	if(curr_env->env_status == ENV_DYING || curr_env->env_status == ENV_FREE)
f01055e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01055ea:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01055ee:	0f 86 2e 02 00 00    	jbe    f0105822 <syscall+0x57e>
		return -E_BAD_ENV;

	user_mem_assert(curr_env,func,5,PTE_U|PTE_P);
f01055f4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f01055fb:	00 
f01055fc:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
f0105603:	00 
f0105604:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105608:	89 04 24             	mov    %eax,(%esp)
f010560b:	e8 de bf ff ff       	call   f01015ee <user_mem_assert>
		
	curr_env->env_pgfault_upcall = func;
f0105610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105613:	89 78 64             	mov    %edi,0x64(%eax)
f0105616:	b8 00 00 00 00       	mov    $0x0,%eax
f010561b:	e9 07 02 00 00       	jmp    f0105827 <syscall+0x583>
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
	if((uintptr_t)dstva%PGSIZE && (uintptr_t)dstva < UTOP)
f0105620:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f0105626:	74 12                	je     f010563a <syscall+0x396>
f0105628:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f010562e:	77 0a                	ja     f010563a <syscall+0x396>
f0105630:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105635:	e9 ed 01 00 00       	jmp    f0105827 <syscall+0x583>
		return -E_INVAL;

	curenv->env_ipc_recving = 1;
f010563a:	e8 c7 13 00 00       	call   f0106a06 <cpunum>
f010563f:	be 20 20 27 f0       	mov    $0xf0272020,%esi
f0105644:	6b c0 74             	imul   $0x74,%eax,%eax
f0105647:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f010564b:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f010564f:	e8 b2 13 00 00       	call   f0106a06 <cpunum>
f0105654:	6b c0 74             	imul   $0x74,%eax,%eax
f0105657:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f010565b:	89 58 6c             	mov    %ebx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f010565e:	e8 a3 13 00 00       	call   f0106a06 <cpunum>
f0105663:	6b c0 74             	imul   $0x74,%eax,%eax
f0105666:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f010566a:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	curenv->env_ipc_perm = 0;
f0105671:	e8 90 13 00 00       	call   f0106a06 <cpunum>
f0105676:	6b c0 74             	imul   $0x74,%eax,%eax
f0105679:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f010567d:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	curenv->env_tf.tf_regs.reg_eax = 0;
f0105684:	e8 7d 13 00 00       	call   f0106a06 <cpunum>
f0105689:	6b c0 74             	imul   $0x74,%eax,%eax
f010568c:	8b 44 30 08          	mov    0x8(%eax,%esi,1),%eax
f0105690:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	//cprintf("%s env %x recving is completed\n",__func__,curenv->env_id);
	sched_yield();
f0105697:	e8 ff f9 ff ff       	call   f010509b <sched_yield>
	// LAB 4: Your code here.
	int ret;
	pte_t * src_pte;
	struct Env * dst_env; 

	ret = envid2env(envid,&dst_env,0);
f010569c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01056a3:	00 
f01056a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01056a7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01056ab:	89 1c 24             	mov    %ebx,(%esp)
f01056ae:	e8 fc e3 ff ff       	call   f0103aaf <envid2env>
	if(ret<0) return ret;
f01056b3:	85 c0                	test   %eax,%eax
f01056b5:	0f 88 6c 01 00 00    	js     f0105827 <syscall+0x583>

	//dst_env->env_ipc_perm = 0;

	if(dst_env->env_status == ENV_DYING || dst_env->env_status == ENV_FREE)
f01056bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01056be:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01056c3:	83 7a 54 01          	cmpl   $0x1,0x54(%edx)
f01056c7:	0f 86 5a 01 00 00    	jbe    f0105827 <syscall+0x583>
		return -E_BAD_ENV;
	if(!dst_env->env_ipc_recving)return -E_IPC_NOT_RECV;
f01056cd:	b0 f9                	mov    $0xf9,%al
f01056cf:	80 7a 68 00          	cmpb   $0x0,0x68(%edx)
f01056d3:	0f 84 4e 01 00 00    	je     f0105827 <syscall+0x583>

	if((uintptr_t)srcva < UTOP)
f01056d9:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01056e0:	0f 87 9d 00 00 00    	ja     f0105783 <syscall+0x4df>
	{
		if((uintptr_t)srcva%PGSIZE) return -E_INVAL;			
f01056e6:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f01056ed:	0f 85 c5 00 00 00    	jne    f01057b8 <syscall+0x514>
		case SYS_page_alloc: res = sys_page_alloc(a1,(void *)a2,a3); break;
		case SYS_page_map: res = sys_page_map((envid_t)a1,(void *)a2,(envid_t)a3,(void *)a4,a5); break;
		case SYS_page_unmap : res = sys_page_unmap((envid_t)a1,(void *)a2); break;
		case SYS_env_set_pgfault_upcall : sys_env_set_pgfault_upcall((envid_t)a1,(void *)a2); break;
		case SYS_ipc_recv: res = sys_ipc_recv((void *)a1); break;
		case SYS_ipc_try_send: res = sys_ipc_try_send((envid_t)a1,a2,(void *)a3,a4); break;
f01056f3:	8b 45 14             	mov    0x14(%ebp),%eax
f01056f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if((uintptr_t)srcva < UTOP)
	{
		if((uintptr_t)srcva%PGSIZE) return -E_INVAL;			
		
		struct PageInfo *pp = page_lookup(curenv->env_pgdir,srcva,&src_pte);
f01056f9:	e8 08 13 00 00       	call   f0106a06 <cpunum>
f01056fe:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105701:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105705:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105708:	89 54 24 04          	mov    %edx,0x4(%esp)
f010570c:	6b c0 74             	imul   $0x74,%eax,%eax
f010570f:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0105715:	8b 40 60             	mov    0x60(%eax),%eax
f0105718:	89 04 24             	mov    %eax,(%esp)
f010571b:	e8 01 c0 ff ff       	call   f0101721 <page_lookup>
		if(!pp) return -E_INVAL;
f0105720:	85 c0                	test   %eax,%eax
f0105722:	0f 84 90 00 00 00    	je     f01057b8 <syscall+0x514>
		
		if(!(*src_pte & PTE_P) || (!(*src_pte & PTE_W) && (perm & PTE_W)))
f0105728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010572b:	8b 00                	mov    (%eax),%eax
f010572d:	a8 01                	test   $0x1,%al
f010572f:	0f 84 83 00 00 00    	je     f01057b8 <syscall+0x514>
f0105735:	a8 02                	test   $0x2,%al
f0105737:	75 08                	jne    f0105741 <syscall+0x49d>
f0105739:	f7 c6 02 00 00 00    	test   $0x2,%esi
f010573f:	75 77                	jne    f01057b8 <syscall+0x514>
			return -E_INVAL;
		
		if(!(perm & PTE_U) || !(perm & PTE_P)) return -E_INVAL;
f0105741:	89 f0                	mov    %esi,%eax
f0105743:	83 e0 05             	and    $0x5,%eax
f0105746:	83 f8 05             	cmp    $0x5,%eax
f0105749:	75 6d                	jne    f01057b8 <syscall+0x514>
f010574b:	e9 e4 00 00 00       	jmp    f0105834 <syscall+0x590>
	}	

	if((uintptr_t)srcva < UTOP && (uintptr_t)dst_env->env_ipc_dstva < UTOP)
	{
		ret = sys_page_map(curenv->env_id,srcva,envid,dst_env->env_ipc_dstva,perm);
f0105750:	e8 b1 12 00 00       	call   f0106a06 <cpunum>
f0105755:	6b c0 74             	imul   $0x74,%eax,%eax
f0105758:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f010575e:	8b 40 48             	mov    0x48(%eax),%eax
f0105761:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105765:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0105768:	89 14 24             	mov    %edx,(%esp)
f010576b:	89 d9                	mov    %ebx,%ecx
f010576d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105770:	e8 ad fa ff ff       	call   f0105222 <sys_page_map>
		if(ret<0) return ret;		
f0105775:	85 c0                	test   %eax,%eax
f0105777:	0f 88 aa 00 00 00    	js     f0105827 <syscall+0x583>
		dst_env->env_ipc_perm = perm;
f010577d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105780:	89 70 78             	mov    %esi,0x78(%eax)
	}
	dst_env->env_ipc_recving = 0;
f0105783:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105786:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f010578a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010578d:	e8 74 12 00 00       	call   f0106a06 <cpunum>
f0105792:	6b c0 74             	imul   $0x74,%eax,%eax
f0105795:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f010579b:	8b 40 48             	mov    0x48(%eax),%eax
f010579e:	89 43 74             	mov    %eax,0x74(%ebx)
	dst_env->env_ipc_value = value;
f01057a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057a4:	89 78 70             	mov    %edi,0x70(%eax)
	dst_env->env_status = ENV_RUNNABLE;
f01057a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057aa:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f01057b1:	b8 00 00 00 00       	mov    $0x0,%eax
f01057b6:	eb 6f                	jmp    f0105827 <syscall+0x583>
f01057b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01057bd:	eb 68                	jmp    f0105827 <syscall+0x583>
	// address!	
	//tf->tf_ds = GD_UD | 3;
	//tf->tf_es = GD_UD | 3;
	//tf->tf_ss = GD_UD | 3;
	//tf->tf_cs = GD_UT | 3;	
	tf->tf_regs.reg_ebp = tf->tf_esp;
f01057bf:	8b 47 3c             	mov    0x3c(%edi),%eax
f01057c2:	89 47 08             	mov    %eax,0x8(%edi)
	tf->tf_eflags = FL_IF;
f01057c5:	c7 47 38 00 02 00 00 	movl   $0x200,0x38(%edi)

	memcpy(&(envs[ENVX(envid)].env_tf),tf,sizeof(struct Trapframe)); 
f01057cc:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f01057d3:	00 
f01057d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01057d8:	89 d8                	mov    %ebx,%eax
f01057da:	25 ff 03 00 00       	and    $0x3ff,%eax
f01057df:	6b c0 7c             	imul   $0x7c,%eax,%eax
f01057e2:	03 05 38 12 27 f0    	add    0xf0271238,%eax
f01057e8:	89 04 24             	mov    %eax,(%esp)
f01057eb:	e8 7b 0c 00 00       	call   f010646b <memcpy>
f01057f0:	b8 00 00 00 00       	mov    $0x0,%eax
		case SYS_page_map: res = sys_page_map((envid_t)a1,(void *)a2,(envid_t)a3,(void *)a4,a5); break;
		case SYS_page_unmap : res = sys_page_unmap((envid_t)a1,(void *)a2); break;
		case SYS_env_set_pgfault_upcall : sys_env_set_pgfault_upcall((envid_t)a1,(void *)a2); break;
		case SYS_ipc_recv: res = sys_ipc_recv((void *)a1); break;
		case SYS_ipc_try_send: res = sys_ipc_try_send((envid_t)a1,a2,(void *)a3,a4); break;
		case SYS_env_set_trapframe: res = sys_env_set_trapframe((envid_t)a1,(struct Trapframe *)a2); break;
f01057f5:	eb 30                	jmp    f0105827 <syscall+0x583>
}

static int
sys_net_send(void *buf, uint32_t size)
{
	return e1000_tx_packet(buf,size);
f01057f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01057fb:	89 1c 24             	mov    %ebx,(%esp)
f01057fe:	e8 08 19 00 00       	call   f010710b <e1000_tx_packet>
		case SYS_page_unmap : res = sys_page_unmap((envid_t)a1,(void *)a2); break;
		case SYS_env_set_pgfault_upcall : sys_env_set_pgfault_upcall((envid_t)a1,(void *)a2); break;
		case SYS_ipc_recv: res = sys_ipc_recv((void *)a1); break;
		case SYS_ipc_try_send: res = sys_ipc_try_send((envid_t)a1,a2,(void *)a3,a4); break;
		case SYS_env_set_trapframe: res = sys_env_set_trapframe((envid_t)a1,(struct Trapframe *)a2); break;
		case SYS_net_send:  res = sys_net_send((void *)a1,a2); break;
f0105803:	eb 22                	jmp    f0105827 <syscall+0x583>
}

static int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return e1000_rx_packet(buf,size);
f0105805:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105809:	89 1c 24             	mov    %ebx,(%esp)
f010580c:	e8 a4 16 00 00       	call   f0106eb5 <e1000_rx_packet>
		case SYS_env_set_pgfault_upcall : sys_env_set_pgfault_upcall((envid_t)a1,(void *)a2); break;
		case SYS_ipc_recv: res = sys_ipc_recv((void *)a1); break;
		case SYS_ipc_try_send: res = sys_ipc_try_send((envid_t)a1,a2,(void *)a3,a4); break;
		case SYS_env_set_trapframe: res = sys_env_set_trapframe((envid_t)a1,(struct Trapframe *)a2); break;
		case SYS_net_send:  res = sys_net_send((void *)a1,a2); break;
		case SYS_net_recv:  res = sys_net_receive((void *)a1,(uint32_t *)a2); break;
f0105811:	eb 14                	jmp    f0105827 <syscall+0x583>
// Return the current time.
static int
sys_time_msec(void)
{
	// LAB 6: Your code here.
	return time_msec();
f0105813:	e8 ef 23 00 00       	call   f0107c07 <time_msec>
f0105818:	90                   	nop
f0105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105820:	eb 05                	jmp    f0105827 <syscall+0x583>
f0105822:	b8 00 00 00 00       	mov    $0x0,%eax
		case SYS_net_recv:  res = sys_net_receive((void *)a1,(uint32_t *)a2); break;
		case SYS_time_msec: res = sys_time_msec();break;
		//default:return -E_NO_SYS;
	}
	return res;
}
f0105827:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f010582a:	8b 75 f8             	mov    -0x8(%ebp),%esi
f010582d:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0105830:	89 ec                	mov    %ebp,%esp
f0105832:	5d                   	pop    %ebp
f0105833:	c3                   	ret    
			return -E_INVAL;
		
		if(!(perm & PTE_U) || !(perm & PTE_P)) return -E_INVAL;
	}	

	if((uintptr_t)srcva < UTOP && (uintptr_t)dst_env->env_ipc_dstva < UTOP)
f0105834:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105837:	8b 40 6c             	mov    0x6c(%eax),%eax
f010583a:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010583d:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
f0105842:	0f 87 3b ff ff ff    	ja     f0105783 <syscall+0x4df>
f0105848:	e9 03 ff ff ff       	jmp    f0105750 <syscall+0x4ac>
f010584d:	00 00                	add    %al,(%eax)
	...

f0105850 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105850:	55                   	push   %ebp
f0105851:	89 e5                	mov    %esp,%ebp
f0105853:	57                   	push   %edi
f0105854:	56                   	push   %esi
f0105855:	53                   	push   %ebx
f0105856:	83 ec 14             	sub    $0x14,%esp
f0105859:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010585c:	89 55 e8             	mov    %edx,-0x18(%ebp)
f010585f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105862:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105865:	8b 1a                	mov    (%edx),%ebx
f0105867:	8b 01                	mov    (%ecx),%eax
f0105869:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010586c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	while (l <= r) {
f0105873:	e9 88 00 00 00       	jmp    f0105900 <stab_binsearch+0xb0>
		int true_m = (l + r) / 2, m = true_m;
f0105878:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010587b:	01 d8                	add    %ebx,%eax
f010587d:	89 c7                	mov    %eax,%edi
f010587f:	c1 ef 1f             	shr    $0x1f,%edi
f0105882:	01 c7                	add    %eax,%edi
f0105884:	d1 ff                	sar    %edi
f0105886:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0105889:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010588c:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0105890:	89 f8                	mov    %edi,%eax

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105892:	eb 03                	jmp    f0105897 <stab_binsearch+0x47>
			m--;
f0105894:	83 e8 01             	sub    $0x1,%eax

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105897:	39 c3                	cmp    %eax,%ebx
f0105899:	7f 0c                	jg     f01058a7 <stab_binsearch+0x57>
f010589b:	0f b6 0a             	movzbl (%edx),%ecx
f010589e:	83 ea 0c             	sub    $0xc,%edx
f01058a1:	39 f1                	cmp    %esi,%ecx
f01058a3:	75 ef                	jne    f0105894 <stab_binsearch+0x44>
f01058a5:	eb 05                	jmp    f01058ac <stab_binsearch+0x5c>
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f01058a7:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f01058aa:	eb 54                	jmp    f0105900 <stab_binsearch+0xb0>
f01058ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01058af:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01058b2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01058b5:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01058b9:	39 55 0c             	cmp    %edx,0xc(%ebp)
f01058bc:	76 11                	jbe    f01058cf <stab_binsearch+0x7f>
			*region_left = m;
f01058be:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f01058c1:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01058c3:	8d 5f 01             	lea    0x1(%edi),%ebx
f01058c6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f01058cd:	eb 31                	jmp    f0105900 <stab_binsearch+0xb0>
		} else if (stabs[m].n_value > addr) {
f01058cf:	39 55 0c             	cmp    %edx,0xc(%ebp)
f01058d2:	73 17                	jae    f01058eb <stab_binsearch+0x9b>
			*region_right = m - 1;
f01058d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01058d7:	83 e8 01             	sub    $0x1,%eax
f01058da:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01058dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01058e0:	89 02                	mov    %eax,(%edx)
f01058e2:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f01058e9:	eb 15                	jmp    f0105900 <stab_binsearch+0xb0>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f01058eb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01058ee:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f01058f1:	89 19                	mov    %ebx,(%ecx)
			l = m;
			addr++;
f01058f3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f01058f7:	89 c3                	mov    %eax,%ebx
f01058f9:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
f0105900:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0105903:	0f 8e 6f ff ff ff    	jle    f0105878 <stab_binsearch+0x28>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0105909:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010590d:	75 0f                	jne    f010591e <stab_binsearch+0xce>
		*region_right = *region_left - 1;
f010590f:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105912:	8b 02                	mov    (%edx),%eax
f0105914:	83 e8 01             	sub    $0x1,%eax
f0105917:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010591a:	89 01                	mov    %eax,(%ecx)
f010591c:	eb 2c                	jmp    f010594a <stab_binsearch+0xfa>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f010591e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0105921:	8b 03                	mov    (%ebx),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105923:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105926:	8b 0a                	mov    (%edx),%ecx
f0105928:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010592b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f010592e:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105932:	eb 03                	jmp    f0105937 <stab_binsearch+0xe7>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
f0105934:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105937:	39 c8                	cmp    %ecx,%eax
f0105939:	7e 0a                	jle    f0105945 <stab_binsearch+0xf5>
		     l > *region_left && stabs[l].n_type != type;
f010593b:	0f b6 1a             	movzbl (%edx),%ebx
f010593e:	83 ea 0c             	sub    $0xc,%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105941:	39 f3                	cmp    %esi,%ebx
f0105943:	75 ef                	jne    f0105934 <stab_binsearch+0xe4>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f0105945:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105948:	89 02                	mov    %eax,(%edx)
	}
}
f010594a:	83 c4 14             	add    $0x14,%esp
f010594d:	5b                   	pop    %ebx
f010594e:	5e                   	pop    %esi
f010594f:	5f                   	pop    %edi
f0105950:	5d                   	pop    %ebp
f0105951:	c3                   	ret    

f0105952 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105952:	55                   	push   %ebp
f0105953:	89 e5                	mov    %esp,%ebp
f0105955:	83 ec 68             	sub    $0x68,%esp
f0105958:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f010595b:	89 75 f8             	mov    %esi,-0x8(%ebp)
f010595e:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0105961:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105964:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105967:	c7 03 04 98 10 f0    	movl   $0xf0109804,(%ebx)
	info->eip_line = 0;
f010596d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105974:	c7 43 08 04 98 10 f0 	movl   $0xf0109804,0x8(%ebx)
	info->eip_fn_namelen = 9;
f010597b:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105982:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105985:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f010598c:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0105992:	76 1a                	jbe    f01059ae <debuginfo_eip+0x5c>
f0105994:	be e3 ad 11 f0       	mov    $0xf011ade3,%esi
f0105999:	c7 45 c4 4d 64 11 f0 	movl   $0xf011644d,-0x3c(%ebp)
f01059a0:	b8 4c 64 11 f0       	mov    $0xf011644c,%eax
f01059a5:	c7 45 c0 10 a1 10 f0 	movl   $0xf010a110,-0x40(%ebp)
f01059ac:	eb 16                	jmp    f01059c4 <debuginfo_eip+0x72>

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.

		stabs = usd->stabs;
f01059ae:	ba 00 00 20 00       	mov    $0x200000,%edx
f01059b3:	8b 02                	mov    (%edx),%eax
f01059b5:	89 45 c0             	mov    %eax,-0x40(%ebp)
		stab_end = usd->stab_end;
f01059b8:	8b 42 04             	mov    0x4(%edx),%eax
		stabstr = usd->stabstr;
f01059bb:	8b 4a 08             	mov    0x8(%edx),%ecx
f01059be:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
		stabstr_end = usd->stabstr_end;
f01059c1:	8b 72 0c             	mov    0xc(%edx),%esi
		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01059c4:	39 75 c4             	cmp    %esi,-0x3c(%ebp)
f01059c7:	0f 83 68 01 00 00    	jae    f0105b35 <debuginfo_eip+0x1e3>
f01059cd:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
f01059d1:	0f 85 5e 01 00 00    	jne    f0105b35 <debuginfo_eip+0x1e3>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01059d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01059de:	2b 45 c0             	sub    -0x40(%ebp),%eax
f01059e1:	c1 f8 02             	sar    $0x2,%eax
f01059e4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f01059ea:	83 e8 01             	sub    $0x1,%eax
f01059ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01059f0:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f01059f3:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01059f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01059fa:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0105a01:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0105a04:	e8 47 fe ff ff       	call   f0105850 <stab_binsearch>
	if (lfile == 0)
f0105a09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a0c:	85 c0                	test   %eax,%eax
f0105a0e:	0f 84 21 01 00 00    	je     f0105b35 <debuginfo_eip+0x1e3>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105a14:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105a17:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105a1d:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0105a20:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105a23:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105a27:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0105a2e:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0105a31:	e8 1a fe ff ff       	call   f0105850 <stab_binsearch>

	if (lfun <= rfun) {
f0105a36:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105a39:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0105a3c:	7f 35                	jg     f0105a73 <debuginfo_eip+0x121>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105a3e:	6b c0 0c             	imul   $0xc,%eax,%eax
f0105a41:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0105a44:	8b 04 10             	mov    (%eax,%edx,1),%eax
f0105a47:	89 f2                	mov    %esi,%edx
f0105a49:	2b 55 c4             	sub    -0x3c(%ebp),%edx
f0105a4c:	39 d0                	cmp    %edx,%eax
f0105a4e:	73 06                	jae    f0105a56 <debuginfo_eip+0x104>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105a50:	03 45 c4             	add    -0x3c(%ebp),%eax
f0105a53:	89 43 08             	mov    %eax,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105a56:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105a59:	6b c2 0c             	imul   $0xc,%edx,%eax
f0105a5c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105a5f:	8b 44 08 08          	mov    0x8(%eax,%ecx,1),%eax
f0105a63:	89 43 10             	mov    %eax,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105a66:	29 c7                	sub    %eax,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0105a68:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		rline = rfun;
f0105a6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105a6e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105a71:	eb 0f                	jmp    f0105a82 <debuginfo_eip+0x130>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0105a73:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105a7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a7f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105a82:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0105a89:	00 
f0105a8a:	8b 43 08             	mov    0x8(%ebx),%eax
f0105a8d:	89 04 24             	mov    %eax,(%esp)
f0105a90:	e8 df 08 00 00       	call   f0106374 <strfind>
f0105a95:	2b 43 08             	sub    0x8(%ebx),%eax
f0105a98:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105a9b:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105a9e:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105aa1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105aa5:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0105aac:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0105aaf:	e8 9c fd ff ff       	call   f0105850 <stab_binsearch>
	if(lline==rline)
f0105ab4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105ab7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0105aba:	75 0e                	jne    f0105aca <debuginfo_eip+0x178>
	{info->eip_line = stabs[rline].n_desc;}
f0105abc:	6b c0 0c             	imul   $0xc,%eax,%eax
f0105abf:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0105ac2:	0f b7 44 10 06       	movzwl 0x6(%eax,%edx,1),%eax
f0105ac7:	89 43 04             	mov    %eax,0x4(%ebx)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0105aca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105acd:	89 75 b4             	mov    %esi,-0x4c(%ebp)
f0105ad0:	eb 06                	jmp    f0105ad8 <debuginfo_eip+0x186>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0105ad2:	83 e8 01             	sub    $0x1,%eax
f0105ad5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0105ad8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105adb:	39 f8                	cmp    %edi,%eax
f0105add:	7c 27                	jl     f0105b06 <debuginfo_eip+0x1b4>
	       && stabs[lline].n_type != N_SOL
f0105adf:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105ae2:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0105ae5:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105ae8:	0f b6 51 04          	movzbl 0x4(%ecx),%edx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105aec:	80 fa 84             	cmp    $0x84,%dl
f0105aef:	74 5d                	je     f0105b4e <debuginfo_eip+0x1fc>
f0105af1:	80 fa 64             	cmp    $0x64,%dl
f0105af4:	75 dc                	jne    f0105ad2 <debuginfo_eip+0x180>
f0105af6:	83 79 08 00          	cmpl   $0x0,0x8(%ecx)
f0105afa:	74 d6                	je     f0105ad2 <debuginfo_eip+0x180>
f0105afc:	8b 75 b4             	mov    -0x4c(%ebp),%esi
f0105aff:	eb 50                	jmp    f0105b51 <debuginfo_eip+0x1ff>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105b01:	03 45 c4             	add    -0x3c(%ebp),%eax
f0105b04:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105b06:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105b09:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0105b0c:	7d 2e                	jge    f0105b3c <debuginfo_eip+0x1ea>
		for (lline = lfun + 1;
f0105b0e:	83 c0 01             	add    $0x1,%eax
f0105b11:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105b14:	eb 08                	jmp    f0105b1e <debuginfo_eip+0x1cc>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0105b16:	83 43 14 01          	addl   $0x1,0x14(%ebx)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
f0105b1a:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105b1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0105b21:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0105b24:	7d 16                	jge    f0105b3c <debuginfo_eip+0x1ea>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105b26:	8d 04 40             	lea    (%eax,%eax,2),%eax


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0105b29:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0105b2c:	80 7c 82 04 a0       	cmpb   $0xa0,0x4(%edx,%eax,4)
f0105b31:	74 e3                	je     f0105b16 <debuginfo_eip+0x1c4>
f0105b33:	eb 07                	jmp    f0105b3c <debuginfo_eip+0x1ea>
f0105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b3a:	eb 05                	jmp    f0105b41 <debuginfo_eip+0x1ef>
f0105b3c:	b8 00 00 00 00       	mov    $0x0,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
}
f0105b41:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0105b44:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0105b47:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0105b4a:	89 ec                	mov    %ebp,%esp
f0105b4c:	5d                   	pop    %ebp
f0105b4d:	c3                   	ret    
f0105b4e:	8b 75 b4             	mov    -0x4c(%ebp),%esi
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105b51:	6b c0 0c             	imul   $0xc,%eax,%eax
f0105b54:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105b57:	8b 04 08             	mov    (%eax,%ecx,1),%eax
f0105b5a:	2b 75 c4             	sub    -0x3c(%ebp),%esi
f0105b5d:	39 f0                	cmp    %esi,%eax
f0105b5f:	72 a0                	jb     f0105b01 <debuginfo_eip+0x1af>
f0105b61:	eb a3                	jmp    f0105b06 <debuginfo_eip+0x1b4>
	...

f0105b64 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105b64:	55                   	push   %ebp
f0105b65:	89 e5                	mov    %esp,%ebp
f0105b67:	57                   	push   %edi
f0105b68:	56                   	push   %esi
f0105b69:	53                   	push   %ebx
f0105b6a:	83 ec 4c             	sub    $0x4c,%esp
f0105b6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105b70:	89 d6                	mov    %edx,%esi
f0105b72:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b75:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105b78:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105b7b:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0105b7e:	8b 45 10             	mov    0x10(%ebp),%eax
f0105b81:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105b84:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105b87:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0105b8a:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105b8f:	39 d1                	cmp    %edx,%ecx
f0105b91:	72 07                	jb     f0105b9a <printnum+0x36>
f0105b93:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105b96:	39 d0                	cmp    %edx,%eax
f0105b98:	77 69                	ja     f0105c03 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105b9a:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0105b9e:	83 eb 01             	sub    $0x1,%ebx
f0105ba1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0105ba5:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105ba9:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0105bad:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
f0105bb1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0105bb4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0105bb7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0105bba:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0105bbe:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0105bc5:	00 
f0105bc6:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105bc9:	89 04 24             	mov    %eax,(%esp)
f0105bcc:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105bcf:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105bd3:	e8 78 20 00 00       	call   f0107c50 <__udivdi3>
f0105bd8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0105bdb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0105bde:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105be2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0105be6:	89 04 24             	mov    %eax,(%esp)
f0105be9:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105bed:	89 f2                	mov    %esi,%edx
f0105bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105bf2:	e8 6d ff ff ff       	call   f0105b64 <printnum>
f0105bf7:	eb 11                	jmp    f0105c0a <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0105bf9:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105bfd:	89 3c 24             	mov    %edi,(%esp)
f0105c00:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0105c03:	83 eb 01             	sub    $0x1,%ebx
f0105c06:	85 db                	test   %ebx,%ebx
f0105c08:	7f ef                	jg     f0105bf9 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105c0a:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105c0e:	8b 74 24 04          	mov    0x4(%esp),%esi
f0105c12:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105c15:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105c19:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0105c20:	00 
f0105c21:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105c24:	89 14 24             	mov    %edx,(%esp)
f0105c27:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105c2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105c2e:	e8 4d 21 00 00       	call   f0107d80 <__umoddi3>
f0105c33:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105c37:	0f be 80 0e 98 10 f0 	movsbl -0xfef67f2(%eax),%eax
f0105c3e:	89 04 24             	mov    %eax,(%esp)
f0105c41:	ff 55 e4             	call   *-0x1c(%ebp)
}
f0105c44:	83 c4 4c             	add    $0x4c,%esp
f0105c47:	5b                   	pop    %ebx
f0105c48:	5e                   	pop    %esi
f0105c49:	5f                   	pop    %edi
f0105c4a:	5d                   	pop    %ebp
f0105c4b:	c3                   	ret    

f0105c4c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0105c4c:	55                   	push   %ebp
f0105c4d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0105c4f:	83 fa 01             	cmp    $0x1,%edx
f0105c52:	7e 0e                	jle    f0105c62 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f0105c54:	8b 10                	mov    (%eax),%edx
f0105c56:	8d 4a 08             	lea    0x8(%edx),%ecx
f0105c59:	89 08                	mov    %ecx,(%eax)
f0105c5b:	8b 02                	mov    (%edx),%eax
f0105c5d:	8b 52 04             	mov    0x4(%edx),%edx
f0105c60:	eb 22                	jmp    f0105c84 <getuint+0x38>
	else if (lflag)
f0105c62:	85 d2                	test   %edx,%edx
f0105c64:	74 10                	je     f0105c76 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0105c66:	8b 10                	mov    (%eax),%edx
f0105c68:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105c6b:	89 08                	mov    %ecx,(%eax)
f0105c6d:	8b 02                	mov    (%edx),%eax
f0105c6f:	ba 00 00 00 00       	mov    $0x0,%edx
f0105c74:	eb 0e                	jmp    f0105c84 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0105c76:	8b 10                	mov    (%eax),%edx
f0105c78:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105c7b:	89 08                	mov    %ecx,(%eax)
f0105c7d:	8b 02                	mov    (%edx),%eax
f0105c7f:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0105c84:	5d                   	pop    %ebp
f0105c85:	c3                   	ret    

f0105c86 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105c86:	55                   	push   %ebp
f0105c87:	89 e5                	mov    %esp,%ebp
f0105c89:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105c8c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105c90:	8b 10                	mov    (%eax),%edx
f0105c92:	3b 50 04             	cmp    0x4(%eax),%edx
f0105c95:	73 0a                	jae    f0105ca1 <sprintputch+0x1b>
		*b->buf++ = ch;
f0105c97:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105c9a:	88 0a                	mov    %cl,(%edx)
f0105c9c:	83 c2 01             	add    $0x1,%edx
f0105c9f:	89 10                	mov    %edx,(%eax)
}
f0105ca1:	5d                   	pop    %ebp
f0105ca2:	c3                   	ret    

f0105ca3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0105ca3:	55                   	push   %ebp
f0105ca4:	89 e5                	mov    %esp,%ebp
f0105ca6:	57                   	push   %edi
f0105ca7:	56                   	push   %esi
f0105ca8:	53                   	push   %ebx
f0105ca9:	83 ec 4c             	sub    $0x4c,%esp
f0105cac:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105caf:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105cb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f0105cb5:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
f0105cbc:	eb 11                	jmp    f0105ccf <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f0105cbe:	85 c0                	test   %eax,%eax
f0105cc0:	0f 84 b6 03 00 00    	je     f010607c <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
f0105cc6:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105cca:	89 04 24             	mov    %eax,(%esp)
f0105ccd:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105ccf:	0f b6 03             	movzbl (%ebx),%eax
f0105cd2:	83 c3 01             	add    $0x1,%ebx
f0105cd5:	83 f8 25             	cmp    $0x25,%eax
f0105cd8:	75 e4                	jne    f0105cbe <vprintfmt+0x1b>
f0105cda:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
f0105cde:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0105ce5:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
f0105cec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f0105cf3:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105cf8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105cfb:	eb 06                	jmp    f0105d03 <vprintfmt+0x60>
f0105cfd:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
f0105d01:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105d03:	0f b6 0b             	movzbl (%ebx),%ecx
f0105d06:	0f b6 c1             	movzbl %cl,%eax
f0105d09:	8d 53 01             	lea    0x1(%ebx),%edx
f0105d0c:	83 e9 23             	sub    $0x23,%ecx
f0105d0f:	80 f9 55             	cmp    $0x55,%cl
f0105d12:	0f 87 47 03 00 00    	ja     f010605f <vprintfmt+0x3bc>
f0105d18:	0f b6 c9             	movzbl %cl,%ecx
f0105d1b:	ff 24 8d 60 99 10 f0 	jmp    *-0xfef66a0(,%ecx,4)
f0105d22:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
f0105d26:	eb d9                	jmp    f0105d01 <vprintfmt+0x5e>
f0105d28:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
f0105d2f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f0105d34:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
f0105d37:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
f0105d3b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
f0105d3e:	8d 58 d0             	lea    -0x30(%eax),%ebx
f0105d41:	83 fb 09             	cmp    $0x9,%ebx
f0105d44:	77 30                	ja     f0105d76 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0105d46:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
f0105d49:	eb e9                	jmp    f0105d34 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0105d4b:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d4e:	8d 48 04             	lea    0x4(%eax),%ecx
f0105d51:	89 4d 14             	mov    %ecx,0x14(%ebp)
f0105d54:	8b 00                	mov    (%eax),%eax
f0105d56:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
f0105d59:	eb 1e                	jmp    f0105d79 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
f0105d5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105d5f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105d64:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
f0105d68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105d6b:	eb 94                	jmp    f0105d01 <vprintfmt+0x5e>
f0105d6d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
f0105d74:	eb 8b                	jmp    f0105d01 <vprintfmt+0x5e>
f0105d76:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
f0105d79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105d7d:	79 82                	jns    f0105d01 <vprintfmt+0x5e>
f0105d7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0105d82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105d85:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0105d88:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0105d8b:	e9 71 ff ff ff       	jmp    f0105d01 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f0105d90:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
f0105d94:	e9 68 ff ff ff       	jmp    f0105d01 <vprintfmt+0x5e>
f0105d99:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0105d9c:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d9f:	8d 50 04             	lea    0x4(%eax),%edx
f0105da2:	89 55 14             	mov    %edx,0x14(%ebp)
f0105da5:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105da9:	8b 00                	mov    (%eax),%eax
f0105dab:	89 04 24             	mov    %eax,(%esp)
f0105dae:	ff d7                	call   *%edi
f0105db0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
f0105db3:	e9 17 ff ff ff       	jmp    f0105ccf <vprintfmt+0x2c>
f0105db8:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
f0105dbb:	8b 45 14             	mov    0x14(%ebp),%eax
f0105dbe:	8d 50 04             	lea    0x4(%eax),%edx
f0105dc1:	89 55 14             	mov    %edx,0x14(%ebp)
f0105dc4:	8b 00                	mov    (%eax),%eax
f0105dc6:	89 c2                	mov    %eax,%edx
f0105dc8:	c1 fa 1f             	sar    $0x1f,%edx
f0105dcb:	31 d0                	xor    %edx,%eax
f0105dcd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105dcf:	83 f8 11             	cmp    $0x11,%eax
f0105dd2:	7f 0b                	jg     f0105ddf <vprintfmt+0x13c>
f0105dd4:	8b 14 85 c0 9a 10 f0 	mov    -0xfef6540(,%eax,4),%edx
f0105ddb:	85 d2                	test   %edx,%edx
f0105ddd:	75 20                	jne    f0105dff <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
f0105ddf:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105de3:	c7 44 24 08 1f 98 10 	movl   $0xf010981f,0x8(%esp)
f0105dea:	f0 
f0105deb:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105def:	89 3c 24             	mov    %edi,(%esp)
f0105df2:	e8 0d 03 00 00       	call   f0106104 <printfmt>
f0105df7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105dfa:	e9 d0 fe ff ff       	jmp    f0105ccf <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f0105dff:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105e03:	c7 44 24 08 27 7f 10 	movl   $0xf0107f27,0x8(%esp)
f0105e0a:	f0 
f0105e0b:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105e0f:	89 3c 24             	mov    %edi,(%esp)
f0105e12:	e8 ed 02 00 00       	call   f0106104 <printfmt>
f0105e17:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0105e1a:	e9 b0 fe ff ff       	jmp    f0105ccf <vprintfmt+0x2c>
f0105e1f:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0105e22:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0105e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e28:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0105e2b:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e2e:	8d 50 04             	lea    0x4(%eax),%edx
f0105e31:	89 55 14             	mov    %edx,0x14(%ebp)
f0105e34:	8b 18                	mov    (%eax),%ebx
f0105e36:	85 db                	test   %ebx,%ebx
f0105e38:	b8 28 98 10 f0       	mov    $0xf0109828,%eax
f0105e3d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
f0105e40:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105e44:	7e 76                	jle    f0105ebc <vprintfmt+0x219>
f0105e46:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
f0105e4a:	74 7a                	je     f0105ec6 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105e4c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105e50:	89 1c 24             	mov    %ebx,(%esp)
f0105e53:	e8 d0 03 00 00       	call   f0106228 <strnlen>
f0105e58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105e5b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
f0105e5d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
f0105e61:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105e64:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0105e67:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0105e69:	eb 0f                	jmp    f0105e7a <vprintfmt+0x1d7>
					putch(padc, putdat);
f0105e6b:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105e6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e72:	89 04 24             	mov    %eax,(%esp)
f0105e75:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0105e77:	83 eb 01             	sub    $0x1,%ebx
f0105e7a:	85 db                	test   %ebx,%ebx
f0105e7c:	7f ed                	jg     f0105e6b <vprintfmt+0x1c8>
f0105e7e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0105e81:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0105e84:	89 7d e0             	mov    %edi,-0x20(%ebp)
f0105e87:	89 f7                	mov    %esi,%edi
f0105e89:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0105e8c:	eb 40                	jmp    f0105ece <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f0105e8e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105e92:	74 18                	je     f0105eac <vprintfmt+0x209>
f0105e94:	8d 50 e0             	lea    -0x20(%eax),%edx
f0105e97:	83 fa 5e             	cmp    $0x5e,%edx
f0105e9a:	76 10                	jbe    f0105eac <vprintfmt+0x209>
					putch('?', putdat);
f0105e9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105ea0:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f0105ea7:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f0105eaa:	eb 0a                	jmp    f0105eb6 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
f0105eac:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105eb0:	89 04 24             	mov    %eax,(%esp)
f0105eb3:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105eb6:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0105eba:	eb 12                	jmp    f0105ece <vprintfmt+0x22b>
f0105ebc:	89 7d e0             	mov    %edi,-0x20(%ebp)
f0105ebf:	89 f7                	mov    %esi,%edi
f0105ec1:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0105ec4:	eb 08                	jmp    f0105ece <vprintfmt+0x22b>
f0105ec6:	89 7d e0             	mov    %edi,-0x20(%ebp)
f0105ec9:	89 f7                	mov    %esi,%edi
f0105ecb:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0105ece:	0f be 03             	movsbl (%ebx),%eax
f0105ed1:	83 c3 01             	add    $0x1,%ebx
f0105ed4:	85 c0                	test   %eax,%eax
f0105ed6:	74 25                	je     f0105efd <vprintfmt+0x25a>
f0105ed8:	85 f6                	test   %esi,%esi
f0105eda:	78 b2                	js     f0105e8e <vprintfmt+0x1eb>
f0105edc:	83 ee 01             	sub    $0x1,%esi
f0105edf:	79 ad                	jns    f0105e8e <vprintfmt+0x1eb>
f0105ee1:	89 fe                	mov    %edi,%esi
f0105ee3:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105ee6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105ee9:	eb 1a                	jmp    f0105f05 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0105eeb:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105eef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0105ef6:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0105ef8:	83 eb 01             	sub    $0x1,%ebx
f0105efb:	eb 08                	jmp    f0105f05 <vprintfmt+0x262>
f0105efd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105f00:	89 fe                	mov    %edi,%esi
f0105f02:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105f05:	85 db                	test   %ebx,%ebx
f0105f07:	7f e2                	jg     f0105eeb <vprintfmt+0x248>
f0105f09:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0105f0c:	e9 be fd ff ff       	jmp    f0105ccf <vprintfmt+0x2c>
f0105f11:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0105f14:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0105f17:	83 f9 01             	cmp    $0x1,%ecx
f0105f1a:	7e 16                	jle    f0105f32 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
f0105f1c:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f1f:	8d 50 08             	lea    0x8(%eax),%edx
f0105f22:	89 55 14             	mov    %edx,0x14(%ebp)
f0105f25:	8b 10                	mov    (%eax),%edx
f0105f27:	8b 48 04             	mov    0x4(%eax),%ecx
f0105f2a:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0105f2d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105f30:	eb 32                	jmp    f0105f64 <vprintfmt+0x2c1>
	else if (lflag)
f0105f32:	85 c9                	test   %ecx,%ecx
f0105f34:	74 18                	je     f0105f4e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
f0105f36:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f39:	8d 50 04             	lea    0x4(%eax),%edx
f0105f3c:	89 55 14             	mov    %edx,0x14(%ebp)
f0105f3f:	8b 00                	mov    (%eax),%eax
f0105f41:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f44:	89 c1                	mov    %eax,%ecx
f0105f46:	c1 f9 1f             	sar    $0x1f,%ecx
f0105f49:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105f4c:	eb 16                	jmp    f0105f64 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
f0105f4e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f51:	8d 50 04             	lea    0x4(%eax),%edx
f0105f54:	89 55 14             	mov    %edx,0x14(%ebp)
f0105f57:	8b 00                	mov    (%eax),%eax
f0105f59:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f5c:	89 c2                	mov    %eax,%edx
f0105f5e:	c1 fa 1f             	sar    $0x1f,%edx
f0105f61:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f0105f64:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105f67:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0105f6a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f0105f6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0105f73:	0f 89 a7 00 00 00    	jns    f0106020 <vprintfmt+0x37d>
				putch('-', putdat);
f0105f79:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105f7d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f0105f84:	ff d7                	call   *%edi
				num = -(long long) num;
f0105f86:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105f89:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0105f8c:	f7 d9                	neg    %ecx
f0105f8e:	83 d3 00             	adc    $0x0,%ebx
f0105f91:	f7 db                	neg    %ebx
f0105f93:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f98:	e9 83 00 00 00       	jmp    f0106020 <vprintfmt+0x37d>
f0105f9d:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0105fa0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0105fa3:	89 ca                	mov    %ecx,%edx
f0105fa5:	8d 45 14             	lea    0x14(%ebp),%eax
f0105fa8:	e8 9f fc ff ff       	call   f0105c4c <getuint>
f0105fad:	89 c1                	mov    %eax,%ecx
f0105faf:	89 d3                	mov    %edx,%ebx
f0105fb1:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
f0105fb6:	eb 68                	jmp    f0106020 <vprintfmt+0x37d>
f0105fb8:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0105fbb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
f0105fbe:	89 ca                	mov    %ecx,%edx
f0105fc0:	8d 45 14             	lea    0x14(%ebp),%eax
f0105fc3:	e8 84 fc ff ff       	call   f0105c4c <getuint>
f0105fc8:	89 c1                	mov    %eax,%ecx
f0105fca:	89 d3                	mov    %edx,%ebx
f0105fcc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
f0105fd1:	eb 4d                	jmp    f0106020 <vprintfmt+0x37d>
f0105fd3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
f0105fd6:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105fda:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0105fe1:	ff d7                	call   *%edi
			putch('x', putdat);
f0105fe3:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105fe7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0105fee:	ff d7                	call   *%edi
			num = (unsigned long long)
f0105ff0:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ff3:	8d 50 04             	lea    0x4(%eax),%edx
f0105ff6:	89 55 14             	mov    %edx,0x14(%ebp)
f0105ff9:	8b 08                	mov    (%eax),%ecx
f0105ffb:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106000:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
f0106005:	eb 19                	jmp    f0106020 <vprintfmt+0x37d>
f0106007:	89 55 d0             	mov    %edx,-0x30(%ebp)
f010600a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f010600d:	89 ca                	mov    %ecx,%edx
f010600f:	8d 45 14             	lea    0x14(%ebp),%eax
f0106012:	e8 35 fc ff ff       	call   f0105c4c <getuint>
f0106017:	89 c1                	mov    %eax,%ecx
f0106019:	89 d3                	mov    %edx,%ebx
f010601b:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
f0106020:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
f0106024:	89 54 24 10          	mov    %edx,0x10(%esp)
f0106028:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010602b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010602f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106033:	89 0c 24             	mov    %ecx,(%esp)
f0106036:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010603a:	89 f2                	mov    %esi,%edx
f010603c:	89 f8                	mov    %edi,%eax
f010603e:	e8 21 fb ff ff       	call   f0105b64 <printnum>
f0106043:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
f0106046:	e9 84 fc ff ff       	jmp    f0105ccf <vprintfmt+0x2c>
f010604b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f010604e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0106052:	89 04 24             	mov    %eax,(%esp)
f0106055:	ff d7                	call   *%edi
f0106057:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
f010605a:	e9 70 fc ff ff       	jmp    f0105ccf <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f010605f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0106063:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f010606a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
f010606c:	8d 43 ff             	lea    -0x1(%ebx),%eax
f010606f:	80 38 25             	cmpb   $0x25,(%eax)
f0106072:	0f 84 57 fc ff ff    	je     f0105ccf <vprintfmt+0x2c>
f0106078:	89 c3                	mov    %eax,%ebx
f010607a:	eb f0                	jmp    f010606c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
f010607c:	83 c4 4c             	add    $0x4c,%esp
f010607f:	5b                   	pop    %ebx
f0106080:	5e                   	pop    %esi
f0106081:	5f                   	pop    %edi
f0106082:	5d                   	pop    %ebp
f0106083:	c3                   	ret    

f0106084 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0106084:	55                   	push   %ebp
f0106085:	89 e5                	mov    %esp,%ebp
f0106087:	83 ec 28             	sub    $0x28,%esp
f010608a:	8b 45 08             	mov    0x8(%ebp),%eax
f010608d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
f0106090:	85 c0                	test   %eax,%eax
f0106092:	74 04                	je     f0106098 <vsnprintf+0x14>
f0106094:	85 d2                	test   %edx,%edx
f0106096:	7f 07                	jg     f010609f <vsnprintf+0x1b>
f0106098:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010609d:	eb 3b                	jmp    f01060da <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
f010609f:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01060a2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
f01060a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01060a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01060b0:	8b 45 14             	mov    0x14(%ebp),%eax
f01060b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01060b7:	8b 45 10             	mov    0x10(%ebp),%eax
f01060ba:	89 44 24 08          	mov    %eax,0x8(%esp)
f01060be:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01060c1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01060c5:	c7 04 24 86 5c 10 f0 	movl   $0xf0105c86,(%esp)
f01060cc:	e8 d2 fb ff ff       	call   f0105ca3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01060d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01060d4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01060d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f01060da:	c9                   	leave  
f01060db:	c3                   	ret    

f01060dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01060dc:	55                   	push   %ebp
f01060dd:	89 e5                	mov    %esp,%ebp
f01060df:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
f01060e2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
f01060e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01060e9:	8b 45 10             	mov    0x10(%ebp),%eax
f01060ec:	89 44 24 08          	mov    %eax,0x8(%esp)
f01060f0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01060f3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01060f7:	8b 45 08             	mov    0x8(%ebp),%eax
f01060fa:	89 04 24             	mov    %eax,(%esp)
f01060fd:	e8 82 ff ff ff       	call   f0106084 <vsnprintf>
	va_end(ap);

	return rc;
}
f0106102:	c9                   	leave  
f0106103:	c3                   	ret    

f0106104 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0106104:	55                   	push   %ebp
f0106105:	89 e5                	mov    %esp,%ebp
f0106107:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
f010610a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
f010610d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106111:	8b 45 10             	mov    0x10(%ebp),%eax
f0106114:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106118:	8b 45 0c             	mov    0xc(%ebp),%eax
f010611b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010611f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106122:	89 04 24             	mov    %eax,(%esp)
f0106125:	e8 79 fb ff ff       	call   f0105ca3 <vprintfmt>
	va_end(ap);
}
f010612a:	c9                   	leave  
f010612b:	c3                   	ret    
f010612c:	00 00                	add    %al,(%eax)
	...

f0106130 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106130:	55                   	push   %ebp
f0106131:	89 e5                	mov    %esp,%ebp
f0106133:	57                   	push   %edi
f0106134:	56                   	push   %esi
f0106135:	53                   	push   %ebx
f0106136:	83 ec 1c             	sub    $0x1c,%esp
f0106139:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f010613c:	85 c0                	test   %eax,%eax
f010613e:	74 10                	je     f0106150 <readline+0x20>
		cprintf("%s", prompt);
f0106140:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106144:	c7 04 24 27 7f 10 f0 	movl   $0xf0107f27,(%esp)
f010614b:	e8 af e4 ff ff       	call   f01045ff <cprintf>
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0106150:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0106157:	e8 04 a3 ff ff       	call   f0100460 <iscons>
f010615c:	89 c7                	mov    %eax,%edi
f010615e:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
f0106163:	e8 e7 a2 ff ff       	call   f010044f <getchar>
f0106168:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010616a:	85 c0                	test   %eax,%eax
f010616c:	79 25                	jns    f0106193 <readline+0x63>
			if (c != -E_EOF)
f010616e:	b8 00 00 00 00       	mov    $0x0,%eax
f0106173:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0106176:	0f 84 89 00 00 00    	je     f0106205 <readline+0xd5>
				cprintf("read error: %e\n", c);
f010617c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0106180:	c7 04 24 27 9b 10 f0 	movl   $0xf0109b27,(%esp)
f0106187:	e8 73 e4 ff ff       	call   f01045ff <cprintf>
f010618c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106191:	eb 72                	jmp    f0106205 <readline+0xd5>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0106193:	83 f8 08             	cmp    $0x8,%eax
f0106196:	74 05                	je     f010619d <readline+0x6d>
f0106198:	83 f8 7f             	cmp    $0x7f,%eax
f010619b:	75 1a                	jne    f01061b7 <readline+0x87>
f010619d:	85 f6                	test   %esi,%esi
f010619f:	90                   	nop
f01061a0:	7e 15                	jle    f01061b7 <readline+0x87>
			if (echoing)
f01061a2:	85 ff                	test   %edi,%edi
f01061a4:	74 0c                	je     f01061b2 <readline+0x82>
				cputchar('\b');
f01061a6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f01061ad:	e8 a0 a4 ff ff       	call   f0100652 <cputchar>
			i--;
f01061b2:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01061b5:	eb ac                	jmp    f0106163 <readline+0x33>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
f01061b7:	83 fb 1f             	cmp    $0x1f,%ebx
f01061ba:	7e 1f                	jle    f01061db <readline+0xab>
f01061bc:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01061c2:	7f 17                	jg     f01061db <readline+0xab>
			if (echoing)
f01061c4:	85 ff                	test   %edi,%edi
f01061c6:	74 08                	je     f01061d0 <readline+0xa0>
				cputchar(c);
f01061c8:	89 1c 24             	mov    %ebx,(%esp)
f01061cb:	e8 82 a4 ff ff       	call   f0100652 <cputchar>
			buf[i++] = c;
f01061d0:	88 9e 80 1a 27 f0    	mov    %bl,-0xfd8e580(%esi)
f01061d6:	83 c6 01             	add    $0x1,%esi
f01061d9:	eb 88                	jmp    f0106163 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f01061db:	83 fb 0a             	cmp    $0xa,%ebx
f01061de:	74 09                	je     f01061e9 <readline+0xb9>
f01061e0:	83 fb 0d             	cmp    $0xd,%ebx
f01061e3:	0f 85 7a ff ff ff    	jne    f0106163 <readline+0x33>
			if (echoing)
f01061e9:	85 ff                	test   %edi,%edi
f01061eb:	74 0c                	je     f01061f9 <readline+0xc9>
				cputchar('\n');
f01061ed:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f01061f4:	e8 59 a4 ff ff       	call   f0100652 <cputchar>
			buf[i] = 0;
f01061f9:	c6 86 80 1a 27 f0 00 	movb   $0x0,-0xfd8e580(%esi)
f0106200:	b8 80 1a 27 f0       	mov    $0xf0271a80,%eax
			return buf;
		}
	}
}
f0106205:	83 c4 1c             	add    $0x1c,%esp
f0106208:	5b                   	pop    %ebx
f0106209:	5e                   	pop    %esi
f010620a:	5f                   	pop    %edi
f010620b:	5d                   	pop    %ebp
f010620c:	c3                   	ret    
f010620d:	00 00                	add    %al,(%eax)
	...

f0106210 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106210:	55                   	push   %ebp
f0106211:	89 e5                	mov    %esp,%ebp
f0106213:	8b 55 08             	mov    0x8(%ebp),%edx
f0106216:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
f010621b:	eb 03                	jmp    f0106220 <strlen+0x10>
		n++;
f010621d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0106220:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106224:	75 f7                	jne    f010621d <strlen+0xd>
		n++;
	return n;
}
f0106226:	5d                   	pop    %ebp
f0106227:	c3                   	ret    

f0106228 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0106228:	55                   	push   %ebp
f0106229:	89 e5                	mov    %esp,%ebp
f010622b:	53                   	push   %ebx
f010622c:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010622f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106232:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106237:	eb 03                	jmp    f010623c <strnlen+0x14>
		n++;
f0106239:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010623c:	39 c1                	cmp    %eax,%ecx
f010623e:	74 06                	je     f0106246 <strnlen+0x1e>
f0106240:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
f0106244:	75 f3                	jne    f0106239 <strnlen+0x11>
		n++;
	return n;
}
f0106246:	5b                   	pop    %ebx
f0106247:	5d                   	pop    %ebp
f0106248:	c3                   	ret    

f0106249 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0106249:	55                   	push   %ebp
f010624a:	89 e5                	mov    %esp,%ebp
f010624c:	53                   	push   %ebx
f010624d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106250:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106253:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0106258:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f010625c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f010625f:	83 c2 01             	add    $0x1,%edx
f0106262:	84 c9                	test   %cl,%cl
f0106264:	75 f2                	jne    f0106258 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0106266:	5b                   	pop    %ebx
f0106267:	5d                   	pop    %ebp
f0106268:	c3                   	ret    

f0106269 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0106269:	55                   	push   %ebp
f010626a:	89 e5                	mov    %esp,%ebp
f010626c:	53                   	push   %ebx
f010626d:	83 ec 08             	sub    $0x8,%esp
f0106270:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0106273:	89 1c 24             	mov    %ebx,(%esp)
f0106276:	e8 95 ff ff ff       	call   f0106210 <strlen>
	strcpy(dst + len, src);
f010627b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010627e:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106282:	8d 04 03             	lea    (%ebx,%eax,1),%eax
f0106285:	89 04 24             	mov    %eax,(%esp)
f0106288:	e8 bc ff ff ff       	call   f0106249 <strcpy>
	return dst;
}
f010628d:	89 d8                	mov    %ebx,%eax
f010628f:	83 c4 08             	add    $0x8,%esp
f0106292:	5b                   	pop    %ebx
f0106293:	5d                   	pop    %ebp
f0106294:	c3                   	ret    

f0106295 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0106295:	55                   	push   %ebp
f0106296:	89 e5                	mov    %esp,%ebp
f0106298:	56                   	push   %esi
f0106299:	53                   	push   %ebx
f010629a:	8b 45 08             	mov    0x8(%ebp),%eax
f010629d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01062a0:	8b 75 10             	mov    0x10(%ebp),%esi
f01062a3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01062a8:	eb 0f                	jmp    f01062b9 <strncpy+0x24>
		*dst++ = *src;
f01062aa:	0f b6 19             	movzbl (%ecx),%ebx
f01062ad:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01062b0:	80 39 01             	cmpb   $0x1,(%ecx)
f01062b3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01062b6:	83 c2 01             	add    $0x1,%edx
f01062b9:	39 f2                	cmp    %esi,%edx
f01062bb:	72 ed                	jb     f01062aa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f01062bd:	5b                   	pop    %ebx
f01062be:	5e                   	pop    %esi
f01062bf:	5d                   	pop    %ebp
f01062c0:	c3                   	ret    

f01062c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01062c1:	55                   	push   %ebp
f01062c2:	89 e5                	mov    %esp,%ebp
f01062c4:	56                   	push   %esi
f01062c5:	53                   	push   %ebx
f01062c6:	8b 75 08             	mov    0x8(%ebp),%esi
f01062c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01062cc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01062cf:	89 f0                	mov    %esi,%eax
f01062d1:	85 d2                	test   %edx,%edx
f01062d3:	75 0a                	jne    f01062df <strlcpy+0x1e>
f01062d5:	eb 17                	jmp    f01062ee <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01062d7:	88 18                	mov    %bl,(%eax)
f01062d9:	83 c0 01             	add    $0x1,%eax
f01062dc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01062df:	83 ea 01             	sub    $0x1,%edx
f01062e2:	74 07                	je     f01062eb <strlcpy+0x2a>
f01062e4:	0f b6 19             	movzbl (%ecx),%ebx
f01062e7:	84 db                	test   %bl,%bl
f01062e9:	75 ec                	jne    f01062d7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
f01062eb:	c6 00 00             	movb   $0x0,(%eax)
f01062ee:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
f01062f0:	5b                   	pop    %ebx
f01062f1:	5e                   	pop    %esi
f01062f2:	5d                   	pop    %ebp
f01062f3:	c3                   	ret    

f01062f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01062f4:	55                   	push   %ebp
f01062f5:	89 e5                	mov    %esp,%ebp
f01062f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01062fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01062fd:	eb 06                	jmp    f0106305 <strcmp+0x11>
		p++, q++;
f01062ff:	83 c1 01             	add    $0x1,%ecx
f0106302:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0106305:	0f b6 01             	movzbl (%ecx),%eax
f0106308:	84 c0                	test   %al,%al
f010630a:	74 04                	je     f0106310 <strcmp+0x1c>
f010630c:	3a 02                	cmp    (%edx),%al
f010630e:	74 ef                	je     f01062ff <strcmp+0xb>
f0106310:	0f b6 c0             	movzbl %al,%eax
f0106313:	0f b6 12             	movzbl (%edx),%edx
f0106316:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0106318:	5d                   	pop    %ebp
f0106319:	c3                   	ret    

f010631a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010631a:	55                   	push   %ebp
f010631b:	89 e5                	mov    %esp,%ebp
f010631d:	53                   	push   %ebx
f010631e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106321:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106324:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
f0106327:	eb 09                	jmp    f0106332 <strncmp+0x18>
		n--, p++, q++;
f0106329:	83 ea 01             	sub    $0x1,%edx
f010632c:	83 c0 01             	add    $0x1,%eax
f010632f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0106332:	85 d2                	test   %edx,%edx
f0106334:	75 07                	jne    f010633d <strncmp+0x23>
f0106336:	b8 00 00 00 00       	mov    $0x0,%eax
f010633b:	eb 13                	jmp    f0106350 <strncmp+0x36>
f010633d:	0f b6 18             	movzbl (%eax),%ebx
f0106340:	84 db                	test   %bl,%bl
f0106342:	74 04                	je     f0106348 <strncmp+0x2e>
f0106344:	3a 19                	cmp    (%ecx),%bl
f0106346:	74 e1                	je     f0106329 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106348:	0f b6 00             	movzbl (%eax),%eax
f010634b:	0f b6 11             	movzbl (%ecx),%edx
f010634e:	29 d0                	sub    %edx,%eax
}
f0106350:	5b                   	pop    %ebx
f0106351:	5d                   	pop    %ebp
f0106352:	c3                   	ret    

f0106353 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0106353:	55                   	push   %ebp
f0106354:	89 e5                	mov    %esp,%ebp
f0106356:	8b 45 08             	mov    0x8(%ebp),%eax
f0106359:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010635d:	eb 07                	jmp    f0106366 <strchr+0x13>
		if (*s == c)
f010635f:	38 ca                	cmp    %cl,%dl
f0106361:	74 0f                	je     f0106372 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f0106363:	83 c0 01             	add    $0x1,%eax
f0106366:	0f b6 10             	movzbl (%eax),%edx
f0106369:	84 d2                	test   %dl,%dl
f010636b:	75 f2                	jne    f010635f <strchr+0xc>
f010636d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
f0106372:	5d                   	pop    %ebp
f0106373:	c3                   	ret    

f0106374 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0106374:	55                   	push   %ebp
f0106375:	89 e5                	mov    %esp,%ebp
f0106377:	8b 45 08             	mov    0x8(%ebp),%eax
f010637a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010637e:	eb 07                	jmp    f0106387 <strfind+0x13>
		if (*s == c)
f0106380:	38 ca                	cmp    %cl,%dl
f0106382:	74 0a                	je     f010638e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f0106384:	83 c0 01             	add    $0x1,%eax
f0106387:	0f b6 10             	movzbl (%eax),%edx
f010638a:	84 d2                	test   %dl,%dl
f010638c:	75 f2                	jne    f0106380 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
f010638e:	5d                   	pop    %ebp
f010638f:	c3                   	ret    

f0106390 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0106390:	55                   	push   %ebp
f0106391:	89 e5                	mov    %esp,%ebp
f0106393:	83 ec 0c             	sub    $0xc,%esp
f0106396:	89 1c 24             	mov    %ebx,(%esp)
f0106399:	89 74 24 04          	mov    %esi,0x4(%esp)
f010639d:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01063a1:	8b 7d 08             	mov    0x8(%ebp),%edi
f01063a4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01063a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01063aa:	85 c9                	test   %ecx,%ecx
f01063ac:	74 30                	je     f01063de <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01063ae:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01063b4:	75 25                	jne    f01063db <memset+0x4b>
f01063b6:	f6 c1 03             	test   $0x3,%cl
f01063b9:	75 20                	jne    f01063db <memset+0x4b>
		c &= 0xFF;
f01063bb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01063be:	89 d3                	mov    %edx,%ebx
f01063c0:	c1 e3 08             	shl    $0x8,%ebx
f01063c3:	89 d6                	mov    %edx,%esi
f01063c5:	c1 e6 18             	shl    $0x18,%esi
f01063c8:	89 d0                	mov    %edx,%eax
f01063ca:	c1 e0 10             	shl    $0x10,%eax
f01063cd:	09 f0                	or     %esi,%eax
f01063cf:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
f01063d1:	09 d8                	or     %ebx,%eax
f01063d3:	c1 e9 02             	shr    $0x2,%ecx
f01063d6:	fc                   	cld    
f01063d7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01063d9:	eb 03                	jmp    f01063de <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01063db:	fc                   	cld    
f01063dc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01063de:	89 f8                	mov    %edi,%eax
f01063e0:	8b 1c 24             	mov    (%esp),%ebx
f01063e3:	8b 74 24 04          	mov    0x4(%esp),%esi
f01063e7:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01063eb:	89 ec                	mov    %ebp,%esp
f01063ed:	5d                   	pop    %ebp
f01063ee:	c3                   	ret    

f01063ef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01063ef:	55                   	push   %ebp
f01063f0:	89 e5                	mov    %esp,%ebp
f01063f2:	83 ec 08             	sub    $0x8,%esp
f01063f5:	89 34 24             	mov    %esi,(%esp)
f01063f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01063fc:	8b 45 08             	mov    0x8(%ebp),%eax
f01063ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
f0106402:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f0106405:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f0106407:	39 c6                	cmp    %eax,%esi
f0106409:	73 35                	jae    f0106440 <memmove+0x51>
f010640b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010640e:	39 d0                	cmp    %edx,%eax
f0106410:	73 2e                	jae    f0106440 <memmove+0x51>
		s += n;
		d += n;
f0106412:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106414:	f6 c2 03             	test   $0x3,%dl
f0106417:	75 1b                	jne    f0106434 <memmove+0x45>
f0106419:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010641f:	75 13                	jne    f0106434 <memmove+0x45>
f0106421:	f6 c1 03             	test   $0x3,%cl
f0106424:	75 0e                	jne    f0106434 <memmove+0x45>
			asm volatile("std; rep movsl\n"
f0106426:	83 ef 04             	sub    $0x4,%edi
f0106429:	8d 72 fc             	lea    -0x4(%edx),%esi
f010642c:	c1 e9 02             	shr    $0x2,%ecx
f010642f:	fd                   	std    
f0106430:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106432:	eb 09                	jmp    f010643d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0106434:	83 ef 01             	sub    $0x1,%edi
f0106437:	8d 72 ff             	lea    -0x1(%edx),%esi
f010643a:	fd                   	std    
f010643b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010643d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010643e:	eb 20                	jmp    f0106460 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106440:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106446:	75 15                	jne    f010645d <memmove+0x6e>
f0106448:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010644e:	75 0d                	jne    f010645d <memmove+0x6e>
f0106450:	f6 c1 03             	test   $0x3,%cl
f0106453:	75 08                	jne    f010645d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
f0106455:	c1 e9 02             	shr    $0x2,%ecx
f0106458:	fc                   	cld    
f0106459:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010645b:	eb 03                	jmp    f0106460 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f010645d:	fc                   	cld    
f010645e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0106460:	8b 34 24             	mov    (%esp),%esi
f0106463:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0106467:	89 ec                	mov    %ebp,%esp
f0106469:	5d                   	pop    %ebp
f010646a:	c3                   	ret    

f010646b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010646b:	55                   	push   %ebp
f010646c:	89 e5                	mov    %esp,%ebp
f010646e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106471:	8b 45 10             	mov    0x10(%ebp),%eax
f0106474:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106478:	8b 45 0c             	mov    0xc(%ebp),%eax
f010647b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010647f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106482:	89 04 24             	mov    %eax,(%esp)
f0106485:	e8 65 ff ff ff       	call   f01063ef <memmove>
}
f010648a:	c9                   	leave  
f010648b:	c3                   	ret    

f010648c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010648c:	55                   	push   %ebp
f010648d:	89 e5                	mov    %esp,%ebp
f010648f:	57                   	push   %edi
f0106490:	56                   	push   %esi
f0106491:	53                   	push   %ebx
f0106492:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106495:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106498:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010649b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01064a0:	eb 1c                	jmp    f01064be <memcmp+0x32>
		if (*s1 != *s2)
f01064a2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
f01064a6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
f01064aa:	83 c2 01             	add    $0x1,%edx
f01064ad:	83 e9 01             	sub    $0x1,%ecx
f01064b0:	38 d8                	cmp    %bl,%al
f01064b2:	74 0a                	je     f01064be <memcmp+0x32>
			return (int) *s1 - (int) *s2;
f01064b4:	0f b6 c0             	movzbl %al,%eax
f01064b7:	0f b6 db             	movzbl %bl,%ebx
f01064ba:	29 d8                	sub    %ebx,%eax
f01064bc:	eb 09                	jmp    f01064c7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01064be:	85 c9                	test   %ecx,%ecx
f01064c0:	75 e0                	jne    f01064a2 <memcmp+0x16>
f01064c2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
f01064c7:	5b                   	pop    %ebx
f01064c8:	5e                   	pop    %esi
f01064c9:	5f                   	pop    %edi
f01064ca:	5d                   	pop    %ebp
f01064cb:	c3                   	ret    

f01064cc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01064cc:	55                   	push   %ebp
f01064cd:	89 e5                	mov    %esp,%ebp
f01064cf:	8b 45 08             	mov    0x8(%ebp),%eax
f01064d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01064d5:	89 c2                	mov    %eax,%edx
f01064d7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01064da:	eb 07                	jmp    f01064e3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
f01064dc:	38 08                	cmp    %cl,(%eax)
f01064de:	74 07                	je     f01064e7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f01064e0:	83 c0 01             	add    $0x1,%eax
f01064e3:	39 d0                	cmp    %edx,%eax
f01064e5:	72 f5                	jb     f01064dc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f01064e7:	5d                   	pop    %ebp
f01064e8:	c3                   	ret    

f01064e9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01064e9:	55                   	push   %ebp
f01064ea:	89 e5                	mov    %esp,%ebp
f01064ec:	57                   	push   %edi
f01064ed:	56                   	push   %esi
f01064ee:	53                   	push   %ebx
f01064ef:	83 ec 04             	sub    $0x4,%esp
f01064f2:	8b 55 08             	mov    0x8(%ebp),%edx
f01064f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01064f8:	eb 03                	jmp    f01064fd <strtol+0x14>
		s++;
f01064fa:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01064fd:	0f b6 02             	movzbl (%edx),%eax
f0106500:	3c 20                	cmp    $0x20,%al
f0106502:	74 f6                	je     f01064fa <strtol+0x11>
f0106504:	3c 09                	cmp    $0x9,%al
f0106506:	74 f2                	je     f01064fa <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
f0106508:	3c 2b                	cmp    $0x2b,%al
f010650a:	75 0c                	jne    f0106518 <strtol+0x2f>
		s++;
f010650c:	8d 52 01             	lea    0x1(%edx),%edx
f010650f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0106516:	eb 15                	jmp    f010652d <strtol+0x44>
	else if (*s == '-')
f0106518:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f010651f:	3c 2d                	cmp    $0x2d,%al
f0106521:	75 0a                	jne    f010652d <strtol+0x44>
		s++, neg = 1;
f0106523:	8d 52 01             	lea    0x1(%edx),%edx
f0106526:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010652d:	85 db                	test   %ebx,%ebx
f010652f:	0f 94 c0             	sete   %al
f0106532:	74 05                	je     f0106539 <strtol+0x50>
f0106534:	83 fb 10             	cmp    $0x10,%ebx
f0106537:	75 15                	jne    f010654e <strtol+0x65>
f0106539:	80 3a 30             	cmpb   $0x30,(%edx)
f010653c:	75 10                	jne    f010654e <strtol+0x65>
f010653e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0106542:	75 0a                	jne    f010654e <strtol+0x65>
		s += 2, base = 16;
f0106544:	83 c2 02             	add    $0x2,%edx
f0106547:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010654c:	eb 13                	jmp    f0106561 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f010654e:	84 c0                	test   %al,%al
f0106550:	74 0f                	je     f0106561 <strtol+0x78>
f0106552:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0106557:	80 3a 30             	cmpb   $0x30,(%edx)
f010655a:	75 05                	jne    f0106561 <strtol+0x78>
		s++, base = 8;
f010655c:	83 c2 01             	add    $0x1,%edx
f010655f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0106561:	b8 00 00 00 00       	mov    $0x0,%eax
f0106566:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0106568:	0f b6 0a             	movzbl (%edx),%ecx
f010656b:	89 cf                	mov    %ecx,%edi
f010656d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f0106570:	80 fb 09             	cmp    $0x9,%bl
f0106573:	77 08                	ja     f010657d <strtol+0x94>
			dig = *s - '0';
f0106575:	0f be c9             	movsbl %cl,%ecx
f0106578:	83 e9 30             	sub    $0x30,%ecx
f010657b:	eb 1e                	jmp    f010659b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
f010657d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
f0106580:	80 fb 19             	cmp    $0x19,%bl
f0106583:	77 08                	ja     f010658d <strtol+0xa4>
			dig = *s - 'a' + 10;
f0106585:	0f be c9             	movsbl %cl,%ecx
f0106588:	83 e9 57             	sub    $0x57,%ecx
f010658b:	eb 0e                	jmp    f010659b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
f010658d:	8d 5f bf             	lea    -0x41(%edi),%ebx
f0106590:	80 fb 19             	cmp    $0x19,%bl
f0106593:	77 15                	ja     f01065aa <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106595:	0f be c9             	movsbl %cl,%ecx
f0106598:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f010659b:	39 f1                	cmp    %esi,%ecx
f010659d:	7d 0b                	jge    f01065aa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010659f:	83 c2 01             	add    $0x1,%edx
f01065a2:	0f af c6             	imul   %esi,%eax
f01065a5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f01065a8:	eb be                	jmp    f0106568 <strtol+0x7f>
f01065aa:	89 c1                	mov    %eax,%ecx

	if (endptr)
f01065ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01065b0:	74 05                	je     f01065b7 <strtol+0xce>
		*endptr = (char *) s;
f01065b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01065b5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f01065b7:	89 ca                	mov    %ecx,%edx
f01065b9:	f7 da                	neg    %edx
f01065bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f01065bf:	0f 45 c2             	cmovne %edx,%eax
}
f01065c2:	83 c4 04             	add    $0x4,%esp
f01065c5:	5b                   	pop    %ebx
f01065c6:	5e                   	pop    %esi
f01065c7:	5f                   	pop    %edi
f01065c8:	5d                   	pop    %ebp
f01065c9:	c3                   	ret    
	...

f01065cc <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01065cc:	fa                   	cli    

	xorw    %ax, %ax
f01065cd:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01065cf:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01065d1:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01065d3:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01065d5:	0f 01 16             	lgdtl  (%esi)
f01065d8:	74 70                	je     f010664a <mpentry_end+0x4>
	movl    %cr0, %eax
f01065da:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01065dd:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01065e1:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01065e4:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01065ea:	08 00                	or     %al,(%eax)

f01065ec <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01065ec:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01065f0:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01065f2:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01065f4:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01065f6:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01065fa:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01065fc:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01065fe:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl    %eax, %cr3
f0106603:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0106606:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0106609:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f010660e:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106611:	8b 25 a0 1e 27 f0    	mov    0xf0271ea0,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106617:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f010661c:	b8 ed 00 10 f0       	mov    $0xf01000ed,%eax
	call    *%eax
f0106621:	ff d0                	call   *%eax

f0106623 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106623:	eb fe                	jmp    f0106623 <spin>
f0106625:	8d 76 00             	lea    0x0(%esi),%esi

f0106628 <gdt>:
	...
f0106630:	ff                   	(bad)  
f0106631:	ff 00                	incl   (%eax)
f0106633:	00 00                	add    %al,(%eax)
f0106635:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f010663c:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f0106640 <gdtdesc>:
f0106640:	17                   	pop    %ss
f0106641:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0106646 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106646:	90                   	nop
	...

f0106650 <sum>:
#define MPIOINTR  0x03  // One per bus interrupt source
#define MPLINTR   0x04  // One per system interrupt source

static uint8_t
sum(void *addr, int len)
{
f0106650:	55                   	push   %ebp
f0106651:	89 e5                	mov    %esp,%ebp
f0106653:	56                   	push   %esi
f0106654:	53                   	push   %ebx
f0106655:	bb 00 00 00 00       	mov    $0x0,%ebx
f010665a:	b9 00 00 00 00       	mov    $0x0,%ecx
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f010665f:	eb 09                	jmp    f010666a <sum+0x1a>
		sum += ((uint8_t *)addr)[i];
f0106661:	0f b6 34 08          	movzbl (%eax,%ecx,1),%esi
f0106665:	01 f3                	add    %esi,%ebx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106667:	83 c1 01             	add    $0x1,%ecx
f010666a:	39 d1                	cmp    %edx,%ecx
f010666c:	7c f3                	jl     f0106661 <sum+0x11>
		sum += ((uint8_t *)addr)[i];
	return sum;
}
f010666e:	89 d8                	mov    %ebx,%eax
f0106670:	5b                   	pop    %ebx
f0106671:	5e                   	pop    %esi
f0106672:	5d                   	pop    %ebp
f0106673:	c3                   	ret    

f0106674 <mpsearch1>:

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106674:	55                   	push   %ebp
f0106675:	89 e5                	mov    %esp,%ebp
f0106677:	56                   	push   %esi
f0106678:	53                   	push   %ebx
f0106679:	83 ec 10             	sub    $0x10,%esp
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010667c:	8b 0d a4 1e 27 f0    	mov    0xf0271ea4,%ecx
f0106682:	89 c3                	mov    %eax,%ebx
f0106684:	c1 eb 0c             	shr    $0xc,%ebx
f0106687:	39 cb                	cmp    %ecx,%ebx
f0106689:	72 20                	jb     f01066ab <mpsearch1+0x37>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010668b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010668f:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0106696:	f0 
f0106697:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f010669e:	00 
f010669f:	c7 04 24 c5 9c 10 f0 	movl   $0xf0109cc5,(%esp)
f01066a6:	e8 da 99 ff ff       	call   f0100085 <_panic>
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f01066ab:	8d 34 02             	lea    (%edx,%eax,1),%esi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01066ae:	89 f2                	mov    %esi,%edx
f01066b0:	c1 ea 0c             	shr    $0xc,%edx
f01066b3:	39 d1                	cmp    %edx,%ecx
f01066b5:	77 20                	ja     f01066d7 <mpsearch1+0x63>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01066b7:	89 74 24 0c          	mov    %esi,0xc(%esp)
f01066bb:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f01066c2:	f0 
f01066c3:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f01066ca:	00 
f01066cb:	c7 04 24 c5 9c 10 f0 	movl   $0xf0109cc5,(%esp)
f01066d2:	e8 ae 99 ff ff       	call   f0100085 <_panic>
f01066d7:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f01066dd:	81 ee 00 00 00 10    	sub    $0x10000000,%esi

	for (; mp < end; mp++)
f01066e3:	eb 2f                	jmp    f0106714 <mpsearch1+0xa0>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01066e5:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f01066ec:	00 
f01066ed:	c7 44 24 04 d5 9c 10 	movl   $0xf0109cd5,0x4(%esp)
f01066f4:	f0 
f01066f5:	89 1c 24             	mov    %ebx,(%esp)
f01066f8:	e8 8f fd ff ff       	call   f010648c <memcmp>
f01066fd:	85 c0                	test   %eax,%eax
f01066ff:	75 10                	jne    f0106711 <mpsearch1+0x9d>
		    sum(mp, sizeof(*mp)) == 0)
f0106701:	ba 10 00 00 00       	mov    $0x10,%edx
f0106706:	89 d8                	mov    %ebx,%eax
f0106708:	e8 43 ff ff ff       	call   f0106650 <sum>
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010670d:	84 c0                	test   %al,%al
f010670f:	74 0c                	je     f010671d <mpsearch1+0xa9>
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
f0106711:	83 c3 10             	add    $0x10,%ebx
f0106714:	39 f3                	cmp    %esi,%ebx
f0106716:	72 cd                	jb     f01066e5 <mpsearch1+0x71>
f0106718:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
}
f010671d:	89 d8                	mov    %ebx,%eax
f010671f:	83 c4 10             	add    $0x10,%esp
f0106722:	5b                   	pop    %ebx
f0106723:	5e                   	pop    %esi
f0106724:	5d                   	pop    %ebp
f0106725:	c3                   	ret    

f0106726 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0106726:	55                   	push   %ebp
f0106727:	89 e5                	mov    %esp,%ebp
f0106729:	57                   	push   %edi
f010672a:	56                   	push   %esi
f010672b:	53                   	push   %ebx
f010672c:	83 ec 2c             	sub    $0x2c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f010672f:	c7 05 c0 23 27 f0 20 	movl   $0xf0272020,0xf02723c0
f0106736:	20 27 f0 
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106739:	83 3d a4 1e 27 f0 00 	cmpl   $0x0,0xf0271ea4
f0106740:	75 24                	jne    f0106766 <mp_init+0x40>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106742:	c7 44 24 0c 00 04 00 	movl   $0x400,0xc(%esp)
f0106749:	00 
f010674a:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0106751:	f0 
f0106752:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
f0106759:	00 
f010675a:	c7 04 24 c5 9c 10 f0 	movl   $0xf0109cc5,(%esp)
f0106761:	e8 1f 99 ff ff       	call   f0100085 <_panic>
	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0106766:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f010676d:	85 c0                	test   %eax,%eax
f010676f:	74 16                	je     f0106787 <mp_init+0x61>
		p <<= 4;	// Translate from segment to PA
		if ((mp = mpsearch1(p, 1024)))
f0106771:	c1 e0 04             	shl    $0x4,%eax
f0106774:	ba 00 04 00 00       	mov    $0x400,%edx
f0106779:	e8 f6 fe ff ff       	call   f0106674 <mpsearch1>
f010677e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106781:	85 c0                	test   %eax,%eax
f0106783:	75 3c                	jne    f01067c1 <mp_init+0x9b>
f0106785:	eb 20                	jmp    f01067a7 <mp_init+0x81>
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
		if ((mp = mpsearch1(p - 1024, 1024)))
f0106787:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f010678e:	c1 e0 0a             	shl    $0xa,%eax
f0106791:	2d 00 04 00 00       	sub    $0x400,%eax
f0106796:	ba 00 04 00 00       	mov    $0x400,%edx
f010679b:	e8 d4 fe ff ff       	call   f0106674 <mpsearch1>
f01067a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01067a3:	85 c0                	test   %eax,%eax
f01067a5:	75 1a                	jne    f01067c1 <mp_init+0x9b>
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f01067a7:	ba 00 00 01 00       	mov    $0x10000,%edx
f01067ac:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f01067b1:	e8 be fe ff ff       	call   f0106674 <mpsearch1>
f01067b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f01067b9:	85 c0                	test   %eax,%eax
f01067bb:	0f 84 23 02 00 00    	je     f01069e4 <mp_init+0x2be>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f01067c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01067c4:	8b 78 04             	mov    0x4(%eax),%edi
f01067c7:	85 ff                	test   %edi,%edi
f01067c9:	74 06                	je     f01067d1 <mp_init+0xab>
f01067cb:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f01067cf:	74 11                	je     f01067e2 <mp_init+0xbc>
		cprintf("SMP: Default configurations not implemented\n");
f01067d1:	c7 04 24 38 9b 10 f0 	movl   $0xf0109b38,(%esp)
f01067d8:	e8 22 de ff ff       	call   f01045ff <cprintf>
f01067dd:	e9 02 02 00 00       	jmp    f01069e4 <mp_init+0x2be>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01067e2:	89 f8                	mov    %edi,%eax
f01067e4:	c1 e8 0c             	shr    $0xc,%eax
f01067e7:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f01067ed:	72 20                	jb     f010680f <mp_init+0xe9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01067ef:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01067f3:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f01067fa:	f0 
f01067fb:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
f0106802:	00 
f0106803:	c7 04 24 c5 9c 10 f0 	movl   $0xf0109cc5,(%esp)
f010680a:	e8 76 98 ff ff       	call   f0100085 <_panic>
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
f010680f:	81 ef 00 00 00 10    	sub    $0x10000000,%edi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106815:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f010681c:	00 
f010681d:	c7 44 24 04 da 9c 10 	movl   $0xf0109cda,0x4(%esp)
f0106824:	f0 
f0106825:	89 3c 24             	mov    %edi,(%esp)
f0106828:	e8 5f fc ff ff       	call   f010648c <memcmp>
f010682d:	85 c0                	test   %eax,%eax
f010682f:	74 11                	je     f0106842 <mp_init+0x11c>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106831:	c7 04 24 68 9b 10 f0 	movl   $0xf0109b68,(%esp)
f0106838:	e8 c2 dd ff ff       	call   f01045ff <cprintf>
f010683d:	e9 a2 01 00 00       	jmp    f01069e4 <mp_init+0x2be>
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0106842:	0f b7 57 04          	movzwl 0x4(%edi),%edx
f0106846:	89 f8                	mov    %edi,%eax
f0106848:	e8 03 fe ff ff       	call   f0106650 <sum>
f010684d:	84 c0                	test   %al,%al
f010684f:	74 11                	je     f0106862 <mp_init+0x13c>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106851:	c7 04 24 9c 9b 10 f0 	movl   $0xf0109b9c,(%esp)
f0106858:	e8 a2 dd ff ff       	call   f01045ff <cprintf>
f010685d:	e9 82 01 00 00       	jmp    f01069e4 <mp_init+0x2be>
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f0106862:	0f b6 47 06          	movzbl 0x6(%edi),%eax
f0106866:	3c 01                	cmp    $0x1,%al
f0106868:	74 1c                	je     f0106886 <mp_init+0x160>
f010686a:	3c 04                	cmp    $0x4,%al
f010686c:	74 18                	je     f0106886 <mp_init+0x160>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f010686e:	0f b6 c0             	movzbl %al,%eax
f0106871:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106875:	c7 04 24 c0 9b 10 f0 	movl   $0xf0109bc0,(%esp)
f010687c:	e8 7e dd ff ff       	call   f01045ff <cprintf>
f0106881:	e9 5e 01 00 00       	jmp    f01069e4 <mp_init+0x2be>
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106886:	0f b7 57 28          	movzwl 0x28(%edi),%edx
f010688a:	0f b7 47 04          	movzwl 0x4(%edi),%eax
f010688e:	8d 04 07             	lea    (%edi,%eax,1),%eax
f0106891:	e8 ba fd ff ff       	call   f0106650 <sum>
f0106896:	02 47 2a             	add    0x2a(%edi),%al
f0106899:	84 c0                	test   %al,%al
f010689b:	74 11                	je     f01068ae <mp_init+0x188>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f010689d:	c7 04 24 e0 9b 10 f0 	movl   $0xf0109be0,(%esp)
f01068a4:	e8 56 dd ff ff       	call   f01045ff <cprintf>
f01068a9:	e9 36 01 00 00       	jmp    f01069e4 <mp_init+0x2be>
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
f01068ae:	85 ff                	test   %edi,%edi
f01068b0:	0f 84 2e 01 00 00    	je     f01069e4 <mp_init+0x2be>
		return;
	ismp = 1;
f01068b6:	c7 05 00 20 27 f0 01 	movl   $0x1,0xf0272000
f01068bd:	00 00 00 
	lapicaddr = conf->lapicaddr;
f01068c0:	8b 47 24             	mov    0x24(%edi),%eax
f01068c3:	a3 00 30 2b f0       	mov    %eax,0xf02b3000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01068c8:	8d 77 2c             	lea    0x2c(%edi),%esi
f01068cb:	bb 00 00 00 00       	mov    $0x0,%ebx
f01068d0:	e9 84 00 00 00       	jmp    f0106959 <mp_init+0x233>
		switch (*p) {
f01068d5:	0f b6 06             	movzbl (%esi),%eax
f01068d8:	84 c0                	test   %al,%al
f01068da:	74 06                	je     f01068e2 <mp_init+0x1bc>
f01068dc:	3c 04                	cmp    $0x4,%al
f01068de:	77 55                	ja     f0106935 <mp_init+0x20f>
f01068e0:	eb 4e                	jmp    f0106930 <mp_init+0x20a>
		case MPPROC:
			proc = (struct mpproc *)p;
f01068e2:	89 f2                	mov    %esi,%edx
			if (proc->flags & MPPROC_BOOT)
f01068e4:	f6 46 03 02          	testb  $0x2,0x3(%esi)
f01068e8:	74 11                	je     f01068fb <mp_init+0x1d5>
				bootcpu = &cpus[ncpu];
f01068ea:	6b 05 c4 23 27 f0 74 	imul   $0x74,0xf02723c4,%eax
f01068f1:	05 20 20 27 f0       	add    $0xf0272020,%eax
f01068f6:	a3 c0 23 27 f0       	mov    %eax,0xf02723c0
			if (ncpu < NCPU) {
f01068fb:	a1 c4 23 27 f0       	mov    0xf02723c4,%eax
f0106900:	83 f8 07             	cmp    $0x7,%eax
f0106903:	7f 12                	jg     f0106917 <mp_init+0x1f1>
				cpus[ncpu].cpu_id = ncpu;
f0106905:	6b d0 74             	imul   $0x74,%eax,%edx
f0106908:	88 82 20 20 27 f0    	mov    %al,-0xfd8dfe0(%edx)
				ncpu++;
f010690e:	83 05 c4 23 27 f0 01 	addl   $0x1,0xf02723c4
f0106915:	eb 14                	jmp    f010692b <mp_init+0x205>
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106917:	0f b6 42 01          	movzbl 0x1(%edx),%eax
f010691b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010691f:	c7 04 24 10 9c 10 f0 	movl   $0xf0109c10,(%esp)
f0106926:	e8 d4 dc ff ff       	call   f01045ff <cprintf>
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f010692b:	83 c6 14             	add    $0x14,%esi
			continue;
f010692e:	eb 26                	jmp    f0106956 <mp_init+0x230>
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106930:	83 c6 08             	add    $0x8,%esi
			continue;
f0106933:	eb 21                	jmp    f0106956 <mp_init+0x230>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106935:	0f b6 c0             	movzbl %al,%eax
f0106938:	89 44 24 04          	mov    %eax,0x4(%esp)
f010693c:	c7 04 24 38 9c 10 f0 	movl   $0xf0109c38,(%esp)
f0106943:	e8 b7 dc ff ff       	call   f01045ff <cprintf>
			ismp = 0;
f0106948:	c7 05 00 20 27 f0 00 	movl   $0x0,0xf0272000
f010694f:	00 00 00 
			i = conf->entry;
f0106952:	0f b7 5f 22          	movzwl 0x22(%edi),%ebx
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106956:	83 c3 01             	add    $0x1,%ebx
f0106959:	0f b7 47 22          	movzwl 0x22(%edi),%eax
f010695d:	39 c3                	cmp    %eax,%ebx
f010695f:	0f 82 70 ff ff ff    	jb     f01068d5 <mp_init+0x1af>
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106965:	a1 c0 23 27 f0       	mov    0xf02723c0,%eax
f010696a:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106971:	83 3d 00 20 27 f0 00 	cmpl   $0x0,0xf0272000
f0106978:	75 22                	jne    f010699c <mp_init+0x276>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f010697a:	c7 05 c4 23 27 f0 01 	movl   $0x1,0xf02723c4
f0106981:	00 00 00 
		lapicaddr = 0;
f0106984:	c7 05 00 30 2b f0 00 	movl   $0x0,0xf02b3000
f010698b:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f010698e:	c7 04 24 58 9c 10 f0 	movl   $0xf0109c58,(%esp)
f0106995:	e8 65 dc ff ff       	call   f01045ff <cprintf>
		return;
f010699a:	eb 48                	jmp    f01069e4 <mp_init+0x2be>
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f010699c:	a1 c4 23 27 f0       	mov    0xf02723c4,%eax
f01069a1:	89 44 24 08          	mov    %eax,0x8(%esp)
f01069a5:	a1 c0 23 27 f0       	mov    0xf02723c0,%eax
f01069aa:	0f b6 00             	movzbl (%eax),%eax
f01069ad:	89 44 24 04          	mov    %eax,0x4(%esp)
f01069b1:	c7 04 24 df 9c 10 f0 	movl   $0xf0109cdf,(%esp)
f01069b8:	e8 42 dc ff ff       	call   f01045ff <cprintf>

	if (mp->imcrp) {
f01069bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01069c0:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f01069c4:	74 1e                	je     f01069e4 <mp_init+0x2be>
		// [MP 3.2.6.1] If the hardware implements PIC mode,
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f01069c6:	c7 04 24 84 9c 10 f0 	movl   $0xf0109c84,(%esp)
f01069cd:	e8 2d dc ff ff       	call   f01045ff <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01069d2:	ba 22 00 00 00       	mov    $0x22,%edx
f01069d7:	b8 70 00 00 00       	mov    $0x70,%eax
f01069dc:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01069dd:	b2 23                	mov    $0x23,%dl
f01069df:	ec                   	in     (%dx),%al
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01069e0:	83 c8 01             	or     $0x1,%eax
f01069e3:	ee                   	out    %al,(%dx)
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f01069e4:	83 c4 2c             	add    $0x2c,%esp
f01069e7:	5b                   	pop    %ebx
f01069e8:	5e                   	pop    %esi
f01069e9:	5f                   	pop    %edi
f01069ea:	5d                   	pop    %ebp
f01069eb:	c3                   	ret    

f01069ec <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f01069ec:	55                   	push   %ebp
f01069ed:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f01069ef:	c1 e0 02             	shl    $0x2,%eax
f01069f2:	03 05 04 30 2b f0    	add    0xf02b3004,%eax
f01069f8:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f01069fa:	a1 04 30 2b f0       	mov    0xf02b3004,%eax
f01069ff:	83 c0 20             	add    $0x20,%eax
f0106a02:	8b 00                	mov    (%eax),%eax
}
f0106a04:	5d                   	pop    %ebp
f0106a05:	c3                   	ret    

f0106a06 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0106a06:	55                   	push   %ebp
f0106a07:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0106a09:	8b 15 04 30 2b f0    	mov    0xf02b3004,%edx
f0106a0f:	b8 00 00 00 00       	mov    $0x0,%eax
f0106a14:	85 d2                	test   %edx,%edx
f0106a16:	74 08                	je     f0106a20 <cpunum+0x1a>
		return lapic[ID] >> 24;
f0106a18:	83 c2 20             	add    $0x20,%edx
f0106a1b:	8b 02                	mov    (%edx),%eax
f0106a1d:	c1 e8 18             	shr    $0x18,%eax
	return 0;
}
f0106a20:	5d                   	pop    %ebp
f0106a21:	c3                   	ret    

f0106a22 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0106a22:	55                   	push   %ebp
f0106a23:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0106a25:	83 3d 04 30 2b f0 00 	cmpl   $0x0,0xf02b3004
f0106a2c:	74 0f                	je     f0106a3d <lapic_eoi+0x1b>
		lapicw(EOI, 0);
f0106a2e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106a33:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106a38:	e8 af ff ff ff       	call   f01069ec <lapicw>
}
f0106a3d:	5d                   	pop    %ebp
f0106a3e:	c3                   	ret    

f0106a3f <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
f0106a3f:	55                   	push   %ebp
f0106a40:	89 e5                	mov    %esp,%ebp
}
f0106a42:	5d                   	pop    %ebp
f0106a43:	c3                   	ret    

f0106a44 <lapic_ipi>:
	}
}

void
lapic_ipi(int vector)
{
f0106a44:	55                   	push   %ebp
f0106a45:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106a47:	8b 55 08             	mov    0x8(%ebp),%edx
f0106a4a:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106a50:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106a55:	e8 92 ff ff ff       	call   f01069ec <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106a5a:	8b 15 04 30 2b f0    	mov    0xf02b3004,%edx
f0106a60:	81 c2 00 03 00 00    	add    $0x300,%edx
f0106a66:	8b 02                	mov    (%edx),%eax
f0106a68:	f6 c4 10             	test   $0x10,%ah
f0106a6b:	75 f9                	jne    f0106a66 <lapic_ipi+0x22>
		;
}
f0106a6d:	5d                   	pop    %ebp
f0106a6e:	c3                   	ret    

f0106a6f <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106a6f:	55                   	push   %ebp
f0106a70:	89 e5                	mov    %esp,%ebp
f0106a72:	56                   	push   %esi
f0106a73:	53                   	push   %ebx
f0106a74:	83 ec 10             	sub    $0x10,%esp
f0106a77:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106a7a:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
f0106a7e:	ba 70 00 00 00       	mov    $0x70,%edx
f0106a83:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106a88:	ee                   	out    %al,(%dx)
f0106a89:	b2 71                	mov    $0x71,%dl
f0106a8b:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106a90:	ee                   	out    %al,(%dx)
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106a91:	83 3d a4 1e 27 f0 00 	cmpl   $0x0,0xf0271ea4
f0106a98:	75 24                	jne    f0106abe <lapic_startap+0x4f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106a9a:	c7 44 24 0c 67 04 00 	movl   $0x467,0xc(%esp)
f0106aa1:	00 
f0106aa2:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0106aa9:	f0 
f0106aaa:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0106ab1:	00 
f0106ab2:	c7 04 24 fc 9c 10 f0 	movl   $0xf0109cfc,(%esp)
f0106ab9:	e8 c7 95 ff ff       	call   f0100085 <_panic>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106abe:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106ac5:	00 00 
	wrv[1] = addr >> 4;
f0106ac7:	89 f0                	mov    %esi,%eax
f0106ac9:	c1 e8 04             	shr    $0x4,%eax
f0106acc:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106ad2:	c1 e3 18             	shl    $0x18,%ebx
f0106ad5:	89 da                	mov    %ebx,%edx
f0106ad7:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106adc:	e8 0b ff ff ff       	call   f01069ec <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106ae1:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106ae6:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106aeb:	e8 fc fe ff ff       	call   f01069ec <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106af0:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106af5:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106afa:	e8 ed fe ff ff       	call   f01069ec <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106aff:	c1 ee 0c             	shr    $0xc,%esi
f0106b02:	81 ce 00 06 00 00    	or     $0x600,%esi
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0106b08:	89 da                	mov    %ebx,%edx
f0106b0a:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106b0f:	e8 d8 fe ff ff       	call   f01069ec <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106b14:	89 f2                	mov    %esi,%edx
f0106b16:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106b1b:	e8 cc fe ff ff       	call   f01069ec <lapicw>
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0106b20:	89 da                	mov    %ebx,%edx
f0106b22:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106b27:	e8 c0 fe ff ff       	call   f01069ec <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106b2c:	89 f2                	mov    %esi,%edx
f0106b2e:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106b33:	e8 b4 fe ff ff       	call   f01069ec <lapicw>
		microdelay(200);
	}
}
f0106b38:	83 c4 10             	add    $0x10,%esp
f0106b3b:	5b                   	pop    %ebx
f0106b3c:	5e                   	pop    %esi
f0106b3d:	5d                   	pop    %ebp
f0106b3e:	c3                   	ret    

f0106b3f <lapic_init>:
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
f0106b3f:	55                   	push   %ebp
f0106b40:	89 e5                	mov    %esp,%ebp
f0106b42:	83 ec 18             	sub    $0x18,%esp
	if (!lapicaddr)
f0106b45:	a1 00 30 2b f0       	mov    0xf02b3000,%eax
f0106b4a:	85 c0                	test   %eax,%eax
f0106b4c:	0f 84 20 01 00 00    	je     f0106c72 <lapic_init+0x133>
		return;

	// lapicaddr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	lapic = mmio_map_region(lapicaddr, 4096);
f0106b52:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0106b59:	00 
f0106b5a:	89 04 24             	mov    %eax,(%esp)
f0106b5d:	e8 45 ab ff ff       	call   f01016a7 <mmio_map_region>
f0106b62:	a3 04 30 2b f0       	mov    %eax,0xf02b3004

	// Enable local APIC; set spurious interrupt vector.
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106b67:	ba 27 01 00 00       	mov    $0x127,%edx
f0106b6c:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106b71:	e8 76 fe ff ff       	call   f01069ec <lapicw>

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.  
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapicw(TDCR, X1);
f0106b76:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106b7b:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106b80:	e8 67 fe ff ff       	call   f01069ec <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106b85:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106b8a:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106b8f:	e8 58 fe ff ff       	call   f01069ec <lapicw>
	lapicw(TICR, 10000000); 
f0106b94:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106b99:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106b9e:	e8 49 fe ff ff       	call   f01069ec <lapicw>
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)
f0106ba3:	e8 5e fe ff ff       	call   f0106a06 <cpunum>
f0106ba8:	6b c0 74             	imul   $0x74,%eax,%eax
f0106bab:	05 20 20 27 f0       	add    $0xf0272020,%eax
f0106bb0:	39 05 c0 23 27 f0    	cmp    %eax,0xf02723c0
f0106bb6:	74 0f                	je     f0106bc7 <lapic_init+0x88>
		lapicw(LINT0, MASKED);
f0106bb8:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106bbd:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106bc2:	e8 25 fe ff ff       	call   f01069ec <lapicw>

	// Disable NMI (LINT1) on all CPUs
	lapicw(LINT1, MASKED);
f0106bc7:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106bcc:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106bd1:	e8 16 fe ff ff       	call   f01069ec <lapicw>

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106bd6:	a1 04 30 2b f0       	mov    0xf02b3004,%eax
f0106bdb:	83 c0 30             	add    $0x30,%eax
f0106bde:	8b 00                	mov    (%eax),%eax
f0106be0:	c1 e8 10             	shr    $0x10,%eax
f0106be3:	3c 03                	cmp    $0x3,%al
f0106be5:	76 0f                	jbe    f0106bf6 <lapic_init+0xb7>
		lapicw(PCINT, MASKED);
f0106be7:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106bec:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106bf1:	e8 f6 fd ff ff       	call   f01069ec <lapicw>

	// Map error interrupt to IRQ_ERROR.
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106bf6:	ba 33 00 00 00       	mov    $0x33,%edx
f0106bfb:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106c00:	e8 e7 fd ff ff       	call   f01069ec <lapicw>

	// Clear error status register (requires back-to-back writes).
	lapicw(ESR, 0);
f0106c05:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c0a:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106c0f:	e8 d8 fd ff ff       	call   f01069ec <lapicw>
	lapicw(ESR, 0);
f0106c14:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c19:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106c1e:	e8 c9 fd ff ff       	call   f01069ec <lapicw>

	// Ack any outstanding interrupts.
	lapicw(EOI, 0);
f0106c23:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c28:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106c2d:	e8 ba fd ff ff       	call   f01069ec <lapicw>

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapicw(ICRHI, 0);
f0106c32:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c37:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106c3c:	e8 ab fd ff ff       	call   f01069ec <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106c41:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106c46:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106c4b:	e8 9c fd ff ff       	call   f01069ec <lapicw>
	while(lapic[ICRLO] & DELIVS);
f0106c50:	8b 15 04 30 2b f0    	mov    0xf02b3004,%edx
f0106c56:	81 c2 00 03 00 00    	add    $0x300,%edx
f0106c5c:	8b 02                	mov    (%edx),%eax
f0106c5e:	f6 c4 10             	test   $0x10,%ah
f0106c61:	75 f9                	jne    f0106c5c <lapic_init+0x11d>

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f0106c63:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c68:	b8 20 00 00 00       	mov    $0x20,%eax
f0106c6d:	e8 7a fd ff ff       	call   f01069ec <lapicw>
}
f0106c72:	c9                   	leave  
f0106c73:	c3                   	ret    

f0106c74 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106c74:	55                   	push   %ebp
f0106c75:	89 e5                	mov    %esp,%ebp
f0106c77:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106c7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106c80:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106c83:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106c86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106c8d:	5d                   	pop    %ebp
f0106c8e:	c3                   	ret    

f0106c8f <holding>:
}

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
f0106c8f:	55                   	push   %ebp
f0106c90:	89 e5                	mov    %esp,%ebp
f0106c92:	53                   	push   %ebx
f0106c93:	83 ec 04             	sub    $0x4,%esp
f0106c96:	89 c2                	mov    %eax,%edx
	return lock->locked && lock->cpu == thiscpu;
f0106c98:	b8 00 00 00 00       	mov    $0x0,%eax
f0106c9d:	83 3a 00             	cmpl   $0x0,(%edx)
f0106ca0:	74 18                	je     f0106cba <holding+0x2b>
f0106ca2:	8b 5a 08             	mov    0x8(%edx),%ebx
f0106ca5:	e8 5c fd ff ff       	call   f0106a06 <cpunum>
f0106caa:	6b c0 74             	imul   $0x74,%eax,%eax
f0106cad:	05 20 20 27 f0       	add    $0xf0272020,%eax
f0106cb2:	39 c3                	cmp    %eax,%ebx
f0106cb4:	0f 94 c0             	sete   %al
f0106cb7:	0f b6 c0             	movzbl %al,%eax
}
f0106cba:	83 c4 04             	add    $0x4,%esp
f0106cbd:	5b                   	pop    %ebx
f0106cbe:	5d                   	pop    %ebp
f0106cbf:	c3                   	ret    

f0106cc0 <spin_unlock>:
}

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106cc0:	55                   	push   %ebp
f0106cc1:	89 e5                	mov    %esp,%ebp
f0106cc3:	83 ec 78             	sub    $0x78,%esp
f0106cc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0106cc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0106ccc:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0106ccf:	8b 5d 08             	mov    0x8(%ebp),%ebx
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f0106cd2:	89 d8                	mov    %ebx,%eax
f0106cd4:	e8 b6 ff ff ff       	call   f0106c8f <holding>
f0106cd9:	85 c0                	test   %eax,%eax
f0106cdb:	0f 85 cd 00 00 00    	jne    f0106dae <spin_unlock+0xee>
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106ce1:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
f0106ce8:	00 
f0106ce9:	8d 43 0c             	lea    0xc(%ebx),%eax
f0106cec:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106cf0:	8d 75 a8             	lea    -0x58(%ebp),%esi
f0106cf3:	89 34 24             	mov    %esi,(%esp)
f0106cf6:	e8 f4 f6 ff ff       	call   f01063ef <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106cfb:	8b 43 08             	mov    0x8(%ebx),%eax
f0106cfe:	0f b6 38             	movzbl (%eax),%edi
f0106d01:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106d04:	e8 fd fc ff ff       	call   f0106a06 <cpunum>
f0106d09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0106d0d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0106d11:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d15:	c7 04 24 0c 9d 10 f0 	movl   $0xf0109d0c,(%esp)
f0106d1c:	e8 de d8 ff ff       	call   f01045ff <cprintf>
f0106d21:	89 f3                	mov    %esi,%ebx
#endif
}

// Release the lock.
void
spin_unlock(struct spinlock *lk)
f0106d23:	8d 7d d0             	lea    -0x30(%ebp),%edi
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106d26:	89 fe                	mov    %edi,%esi
f0106d28:	eb 62                	jmp    f0106d8c <spin_unlock+0xcc>
f0106d2a:	89 74 24 04          	mov    %esi,0x4(%esp)
f0106d2e:	89 04 24             	mov    %eax,(%esp)
f0106d31:	e8 1c ec ff ff       	call   f0105952 <debuginfo_eip>
f0106d36:	85 c0                	test   %eax,%eax
f0106d38:	78 39                	js     f0106d73 <spin_unlock+0xb3>
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
f0106d3a:	8b 03                	mov    (%ebx),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106d3c:	89 c2                	mov    %eax,%edx
f0106d3e:	2b 55 e0             	sub    -0x20(%ebp),%edx
f0106d41:	89 54 24 18          	mov    %edx,0x18(%esp)
f0106d45:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0106d48:	89 54 24 14          	mov    %edx,0x14(%esp)
f0106d4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0106d4f:	89 54 24 10          	mov    %edx,0x10(%esp)
f0106d53:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106d56:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106d5a:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0106d5d:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106d61:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d65:	c7 04 24 6e 9d 10 f0 	movl   $0xf0109d6e,(%esp)
f0106d6c:	e8 8e d8 ff ff       	call   f01045ff <cprintf>
f0106d71:	eb 12                	jmp    f0106d85 <spin_unlock+0xc5>
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
f0106d73:	8b 03                	mov    (%ebx),%eax
f0106d75:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d79:	c7 04 24 85 9d 10 f0 	movl   $0xf0109d85,(%esp)
f0106d80:	e8 7a d8 ff ff       	call   f01045ff <cprintf>
f0106d85:	83 c3 04             	add    $0x4,%ebx
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106d88:	39 fb                	cmp    %edi,%ebx
f0106d8a:	74 06                	je     f0106d92 <spin_unlock+0xd2>
f0106d8c:	8b 03                	mov    (%ebx),%eax
f0106d8e:	85 c0                	test   %eax,%eax
f0106d90:	75 98                	jne    f0106d2a <spin_unlock+0x6a>
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
f0106d92:	c7 44 24 08 8d 9d 10 	movl   $0xf0109d8d,0x8(%esp)
f0106d99:	f0 
f0106d9a:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
f0106da1:	00 
f0106da2:	c7 04 24 99 9d 10 f0 	movl   $0xf0109d99,(%esp)
f0106da9:	e8 d7 92 ff ff       	call   f0100085 <_panic>
	}

	lk->pcs[0] = 0;
f0106dae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	lk->cpu = 0;
f0106db5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0106dbc:	b8 00 00 00 00       	mov    $0x0,%eax
f0106dc1:	f0 87 03             	lock xchg %eax,(%ebx)
	// Paper says that Intel 64 and IA-32 will not move a load
	// after a store. So lock->locked = 0 would work here.
	// The xchg being asm volatile ensures gcc emits it after
	// the above assignments (and after the critical section).
	xchg(&lk->locked, 0);
}
f0106dc4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0106dc7:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0106dca:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0106dcd:	89 ec                	mov    %ebp,%esp
f0106dcf:	5d                   	pop    %ebp
f0106dd0:	c3                   	ret    

f0106dd1 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106dd1:	55                   	push   %ebp
f0106dd2:	89 e5                	mov    %esp,%ebp
f0106dd4:	53                   	push   %ebx
f0106dd5:	83 ec 24             	sub    $0x24,%esp
f0106dd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0106ddb:	89 d8                	mov    %ebx,%eax
f0106ddd:	e8 ad fe ff ff       	call   f0106c8f <holding>
f0106de2:	85 c0                	test   %eax,%eax
f0106de4:	75 09                	jne    f0106def <spin_lock+0x1e>
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106de6:	89 da                	mov    %ebx,%edx
f0106de8:	b9 01 00 00 00       	mov    $0x1,%ecx
f0106ded:	eb 2e                	jmp    f0106e1d <spin_lock+0x4c>
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106def:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106df2:	e8 0f fc ff ff       	call   f0106a06 <cpunum>
f0106df7:	89 5c 24 10          	mov    %ebx,0x10(%esp)
f0106dfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106dff:	c7 44 24 08 44 9d 10 	movl   $0xf0109d44,0x8(%esp)
f0106e06:	f0 
f0106e07:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
f0106e0e:	00 
f0106e0f:	c7 04 24 99 9d 10 f0 	movl   $0xf0109d99,(%esp)
f0106e16:	e8 6a 92 ff ff       	call   f0100085 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0106e1b:	f3 90                	pause  
f0106e1d:	89 c8                	mov    %ecx,%eax
f0106e1f:	f0 87 02             	lock xchg %eax,(%edx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106e22:	85 c0                	test   %eax,%eax
f0106e24:	75 f5                	jne    f0106e1b <spin_lock+0x4a>
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106e26:	e8 db fb ff ff       	call   f0106a06 <cpunum>
f0106e2b:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e2e:	05 20 20 27 f0       	add    $0xf0272020,%eax
f0106e33:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0106e36:	83 c3 0c             	add    $0xc,%ebx
get_caller_pcs(uint32_t pcs[])
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
f0106e39:	89 ea                	mov    %ebp,%edx
f0106e3b:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < 10; i++){
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106e40:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106e46:	76 12                	jbe    f0106e5a <spin_lock+0x89>
			break;
		pcs[i] = ebp[1];          // saved %eip
f0106e48:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106e4b:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106e4e:	8b 12                	mov    (%edx),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0106e50:	83 c0 01             	add    $0x1,%eax
f0106e53:	83 f8 0a             	cmp    $0xa,%eax
f0106e56:	75 e8                	jne    f0106e40 <spin_lock+0x6f>
f0106e58:	eb 0f                	jmp    f0106e69 <spin_lock+0x98>
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f0106e5a:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
f0106e61:	83 c0 01             	add    $0x1,%eax
f0106e64:	83 f8 09             	cmp    $0x9,%eax
f0106e67:	7e f1                	jle    f0106e5a <spin_lock+0x89>
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
	get_caller_pcs(lk->pcs);
#endif
}
f0106e69:	83 c4 24             	add    $0x24,%esp
f0106e6c:	5b                   	pop    %ebx
f0106e6d:	5d                   	pop    %ebp
f0106e6e:	c3                   	ret    
	...

f0106e70 <e1000w>:
int tx_tail = 0;
int rx_head = 0;
int rx_tail = 0;

inline void e1000w(int index, int value)
{
f0106e70:	55                   	push   %ebp
f0106e71:	89 e5                	mov    %esp,%ebp
	e1000[index] = value;
f0106e73:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e76:	c1 e0 02             	shl    $0x2,%eax
f0106e79:	03 05 08 30 2b f0    	add    0xf02b3008,%eax
f0106e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106e82:	89 10                	mov    %edx,(%eax)
	//cprintf("%s set %x to addr %x\n",__func__,value,index);
}
f0106e84:	5d                   	pop    %ebp
f0106e85:	c3                   	ret    

f0106e86 <e1000r>:

inline uint32_t e1000r(int index)
{
f0106e86:	55                   	push   %ebp
f0106e87:	89 e5                	mov    %esp,%ebp
	return e1000[index];
f0106e89:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e8c:	c1 e0 02             	shl    $0x2,%eax
f0106e8f:	03 05 08 30 2b f0    	add    0xf02b3008,%eax
f0106e95:	8b 00                	mov    (%eax),%eax
}
f0106e97:	5d                   	pop    %ebp
f0106e98:	c3                   	ret    

f0106e99 <e1000_rx_queue_empty>:
	e1000w(E1000_TDT_REG,tx_tail);
	return 0;
}

int e1000_rx_queue_empty()
{
f0106e99:	55                   	push   %ebp
f0106e9a:	89 e5                	mov    %esp,%ebp
	int i;
	int dd = E1000_GET_RDESC_DD(rdesc_addr[rx_tail].status);
f0106e9c:	a1 8c 1e 27 f0       	mov    0xf0271e8c,%eax
f0106ea1:	c1 e0 04             	shl    $0x4,%eax
f0106ea4:	03 05 10 30 2b f0    	add    0xf02b3010,%eax
f0106eaa:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
f0106eae:	f7 d0                	not    %eax
f0106eb0:	83 e0 01             	and    $0x1,%eax
	if(!dd) return 1;
	//if(rx_head==rx_tail) return 1;
	else return 0;
}
f0106eb3:	5d                   	pop    %ebp
f0106eb4:	c3                   	ret    

f0106eb5 <e1000_rx_packet>:

//if rx queue is empty, return -E_NO_RDESC
//otherwise, return size
int e1000_rx_packet(void * buf, uint32_t * size)
{
f0106eb5:	55                   	push   %ebp
f0106eb6:	89 e5                	mov    %esp,%ebp
f0106eb8:	56                   	push   %esi
f0106eb9:	53                   	push   %ebx
f0106eba:	83 ec 20             	sub    $0x20,%esp
	struct PageInfo *pp;
	int ret;
	
	if(e1000_rx_queue_empty()) return -E_NO_RDESC;
f0106ebd:	e8 d7 ff ff ff       	call   f0106e99 <e1000_rx_queue_empty>
f0106ec2:	89 c2                	mov    %eax,%edx
f0106ec4:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
f0106ec9:	85 d2                	test   %edx,%edx
f0106ecb:	0f 85 33 01 00 00    	jne    f0107004 <e1000_rx_packet+0x14f>

	//cprintf("get a message rx_tail %d rx_head %d rx_head status %d rx_tail status %d\n",
	//		rx_tail, rx_head, rdesc_addr[rx_head].status, rdesc_addr[rx_tail].status);
	
	if(rdesc_addr[rx_tail].length>PGSIZE)panic("rx size overflow\n");
f0106ed1:	a1 8c 1e 27 f0       	mov    0xf0271e8c,%eax
f0106ed6:	c1 e0 04             	shl    $0x4,%eax
f0106ed9:	03 05 10 30 2b f0    	add    0xf02b3010,%eax
f0106edf:	0f b7 50 08          	movzwl 0x8(%eax),%edx
f0106ee3:	66 81 fa 00 10       	cmp    $0x1000,%dx
f0106ee8:	76 1c                	jbe    f0106f06 <e1000_rx_packet+0x51>
f0106eea:	c7 44 24 08 b5 9d 10 	movl   $0xf0109db5,0x8(%esp)
f0106ef1:	f0 
f0106ef2:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
f0106ef9:	00 
f0106efa:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f0106f01:	e8 7f 91 ff ff       	call   f0100085 <_panic>

	*size = rdesc_addr[rx_tail].length;
f0106f06:	0f b7 50 08          	movzwl 0x8(%eax),%edx
f0106f0a:	0f b7 d2             	movzwl %dx,%edx
f0106f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106f10:	89 10                	mov    %edx,(%eax)
	//map the value to 	
	ret = page_insert(curenv->env_pgdir,pa2page(rdesc_addr[rx_tail].addr),buf,PTE_P|PTE_U|PTE_W);
f0106f12:	a1 8c 1e 27 f0       	mov    0xf0271e8c,%eax
f0106f17:	c1 e0 04             	shl    $0x4,%eax
f0106f1a:	03 05 10 30 2b f0    	add    0xf02b3010,%eax
f0106f20:	8b 18                	mov    (%eax),%ebx
f0106f22:	8b 70 04             	mov    0x4(%eax),%esi
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106f25:	c1 eb 0c             	shr    $0xc,%ebx
f0106f28:	3b 1d a4 1e 27 f0    	cmp    0xf0271ea4,%ebx
f0106f2e:	72 1c                	jb     f0106f4c <e1000_rx_packet+0x97>
		panic("pa2page called with invalid pa");
f0106f30:	c7 44 24 08 28 86 10 	movl   $0xf0108628,0x8(%esp)
f0106f37:	f0 
f0106f38:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0106f3f:	00 
f0106f40:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0106f47:	e8 39 91 ff ff       	call   f0100085 <_panic>
	return &pages[PGNUM(pa)];
f0106f4c:	c1 e3 03             	shl    $0x3,%ebx
f0106f4f:	03 1d ac 1e 27 f0    	add    0xf0271eac,%ebx
f0106f55:	e8 ac fa ff ff       	call   f0106a06 <cpunum>
f0106f5a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0106f61:	00 
f0106f62:	8b 55 08             	mov    0x8(%ebp),%edx
f0106f65:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106f69:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0106f6d:	6b c0 74             	imul   $0x74,%eax,%eax
f0106f70:	8b 80 28 20 27 f0    	mov    -0xfd8dfd8(%eax),%eax
f0106f76:	8b 40 60             	mov    0x60(%eax),%eax
f0106f79:	89 04 24             	mov    %eax,(%esp)
f0106f7c:	e8 69 a8 ff ff       	call   f01017ea <page_insert>
	if(ret) panic("%s page insert error %e",__func__,ret);
f0106f81:	85 c0                	test   %eax,%eax
f0106f83:	74 28                	je     f0106fad <e1000_rx_packet+0xf8>
f0106f85:	89 44 24 10          	mov    %eax,0x10(%esp)
f0106f89:	c7 44 24 0c 89 9e 10 	movl   $0xf0109e89,0xc(%esp)
f0106f90:	f0 
f0106f91:	c7 44 24 08 d4 9d 10 	movl   $0xf0109dd4,0x8(%esp)
f0106f98:	f0 
f0106f99:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
f0106fa0:	00 
f0106fa1:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f0106fa8:	e8 d8 90 ff ff       	call   f0100085 <_panic>
	
	rdesc_addr[rx_tail].length = 0;
f0106fad:	a1 8c 1e 27 f0       	mov    0xf0271e8c,%eax
f0106fb2:	c1 e0 04             	shl    $0x4,%eax
f0106fb5:	03 05 10 30 2b f0    	add    0xf02b3010,%eax
f0106fbb:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
	rdesc_addr[rx_tail].status = 0;
f0106fc1:	a1 8c 1e 27 f0       	mov    0xf0271e8c,%eax
f0106fc6:	c1 e0 04             	shl    $0x4,%eax
f0106fc9:	03 05 10 30 2b f0    	add    0xf02b3010,%eax
f0106fcf:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
	rx_tail = (rx_tail+1)%RDESC_ARRAY_SIZE;
f0106fd3:	8b 0d 8c 1e 27 f0    	mov    0xf0271e8c,%ecx
f0106fd9:	83 c1 01             	add    $0x1,%ecx
f0106fdc:	89 ca                	mov    %ecx,%edx
f0106fde:	c1 fa 1f             	sar    $0x1f,%edx
f0106fe1:	c1 ea 19             	shr    $0x19,%edx
f0106fe4:	8d 04 11             	lea    (%ecx,%edx,1),%eax
f0106fe7:	83 e0 7f             	and    $0x7f,%eax
f0106fea:	29 d0                	sub    %edx,%eax
f0106fec:	a3 8c 1e 27 f0       	mov    %eax,0xf0271e8c
int rx_head = 0;
int rx_tail = 0;

inline void e1000w(int index, int value)
{
	e1000[index] = value;
f0106ff1:	8b 15 08 30 2b f0    	mov    0xf02b3008,%edx
f0106ff7:	81 c2 18 28 00 00    	add    $0x2818,%edx
f0106ffd:	89 02                	mov    %eax,(%edx)
f0106fff:	b8 00 00 00 00       	mov    $0x0,%eax
	rdesc_addr[rx_tail].length = 0;
	rdesc_addr[rx_tail].status = 0;
	rx_tail = (rx_tail+1)%RDESC_ARRAY_SIZE;
	e1000w(E1000_RDT_REG,rx_tail);
	return 0;
}
f0107004:	83 c4 20             	add    $0x20,%esp
f0107007:	5b                   	pop    %ebx
f0107008:	5e                   	pop    %esi
f0107009:	5d                   	pop    %ebp
f010700a:	c3                   	ret    

f010700b <e1000_tx_queue_full>:
		   E1000_RCTRL_EN|E1000_RCTRL_SBP|E1000_RCTRL_UPE|E1000_RCTRL_UPE|E1000_RCTRL_LPE|E1000_RCTRL_LBM|
		   E1000_RCTRL_RDMTS|E1000_RCTRL_MO|E1000_RCTRL_BAM|E1000_RCTRL_BSIZE|E1000_RCTRL_BSE|E1000_RCTRL_SECRC);
}

int e1000_tx_queue_full()
{
f010700b:	55                   	push   %ebp
f010700c:	89 e5                	mov    %esp,%ebp
f010700e:	83 ec 18             	sub    $0x18,%esp
	
	if(tx_head==tx_tail && !tdesc_addr[tx_head].cmd) return 0;
f0107011:	8b 15 80 1e 27 f0    	mov    0xf0271e80,%edx
f0107017:	3b 15 84 1e 27 f0    	cmp    0xf0271e84,%edx
f010701d:	75 1c                	jne    f010703b <e1000_tx_queue_full+0x30>
f010701f:	89 d0                	mov    %edx,%eax
f0107021:	c1 e0 04             	shl    $0x4,%eax
f0107024:	03 05 0c 30 2b f0    	add    0xf02b300c,%eax
f010702a:	0f b6 48 0b          	movzbl 0xb(%eax),%ecx
f010702e:	b8 00 00 00 00       	mov    $0x0,%eax
f0107033:	84 c9                	test   %cl,%cl
f0107035:	0f 84 ce 00 00 00    	je     f0107109 <e1000_tx_queue_full+0xfe>

	if(!E1000_GET_TDESC_DD(tdesc_addr[tx_head].status)) return -E_NO_TXDESC;
f010703b:	c1 e2 04             	shl    $0x4,%edx
f010703e:	03 15 0c 30 2b f0    	add    0xf02b300c,%edx
f0107044:	0f b6 4a 0c          	movzbl 0xc(%edx),%ecx
f0107048:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
f010704d:	f6 c1 01             	test   $0x1,%cl
f0107050:	0f 84 b3 00 00 00    	je     f0107109 <e1000_tx_queue_full+0xfe>

	page_free(pa2page(tdesc_addr[tx_head].addr));
f0107056:	8b 02                	mov    (%edx),%eax
f0107058:	8b 52 04             	mov    0x4(%edx),%edx
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010705b:	c1 e8 0c             	shr    $0xc,%eax
f010705e:	3b 05 a4 1e 27 f0    	cmp    0xf0271ea4,%eax
f0107064:	72 1c                	jb     f0107082 <e1000_tx_queue_full+0x77>
		panic("pa2page called with invalid pa");
f0107066:	c7 44 24 08 28 86 10 	movl   $0xf0108628,0x8(%esp)
f010706d:	f0 
f010706e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0107075:	00 
f0107076:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f010707d:	e8 03 90 ff ff       	call   f0100085 <_panic>
f0107082:	c1 e0 03             	shl    $0x3,%eax
f0107085:	03 05 ac 1e 27 f0    	add    0xf0271eac,%eax
f010708b:	89 04 24             	mov    %eax,(%esp)
f010708e:	e8 04 9d ff ff       	call   f0100d97 <page_free>
	tdesc_addr[tx_head].addr = 0;
f0107093:	a1 80 1e 27 f0       	mov    0xf0271e80,%eax
f0107098:	c1 e0 04             	shl    $0x4,%eax
f010709b:	03 05 0c 30 2b f0    	add    0xf02b300c,%eax
f01070a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01070a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	tdesc_addr[tx_head].cmd = 0;
f01070ae:	a1 80 1e 27 f0       	mov    0xf0271e80,%eax
f01070b3:	c1 e0 04             	shl    $0x4,%eax
f01070b6:	03 05 0c 30 2b f0    	add    0xf02b300c,%eax
f01070bc:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
	tdesc_addr[tx_head].status = 0;
f01070c0:	a1 80 1e 27 f0       	mov    0xf0271e80,%eax
f01070c5:	c1 e0 04             	shl    $0x4,%eax
f01070c8:	03 05 0c 30 2b f0    	add    0xf02b300c,%eax
f01070ce:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
	tdesc_addr[tx_head].length = 0;
f01070d2:	a1 80 1e 27 f0       	mov    0xf0271e80,%eax
f01070d7:	c1 e0 04             	shl    $0x4,%eax
f01070da:	03 05 0c 30 2b f0    	add    0xf02b300c,%eax
f01070e0:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
	
	tx_head = (tx_head+1)%TDESC_ARRAY_SIZE;
f01070e6:	8b 15 80 1e 27 f0    	mov    0xf0271e80,%edx
f01070ec:	83 c2 01             	add    $0x1,%edx
f01070ef:	89 d0                	mov    %edx,%eax
f01070f1:	c1 f8 1f             	sar    $0x1f,%eax
f01070f4:	c1 e8 19             	shr    $0x19,%eax
f01070f7:	01 c2                	add    %eax,%edx
f01070f9:	83 e2 7f             	and    $0x7f,%edx
f01070fc:	29 c2                	sub    %eax,%edx
f01070fe:	89 15 80 1e 27 f0    	mov    %edx,0xf0271e80
f0107104:	b8 00 00 00 00       	mov    $0x0,%eax

	return 0;
}
f0107109:	c9                   	leave  
f010710a:	c3                   	ret    

f010710b <e1000_tx_packet>:
//if the tx desc queue is not full, alloc a space and set rs, move tail
//if tx desc queue is full and then head is empty
//if empty, clean and inc head
//if not empty, return -E_NO_TXDESC
int e1000_tx_packet(void * buf, uint32_t size)
{
f010710b:	55                   	push   %ebp
f010710c:	89 e5                	mov    %esp,%ebp
f010710e:	56                   	push   %esi
f010710f:	53                   	push   %ebx
f0107110:	83 ec 10             	sub    $0x10,%esp
f0107113:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *pp;
	struct tx_desc * curr;
	int i;
	
	if(e1000_tx_queue_full()) return -E_NO_TXDESC;
f0107116:	e8 f0 fe ff ff       	call   f010700b <e1000_tx_queue_full>
f010711b:	89 c2                	mov    %eax,%edx
f010711d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
f0107122:	85 d2                	test   %edx,%edx
f0107124:	0f 85 16 01 00 00    	jne    f0107240 <e1000_tx_packet+0x135>

	if(size>PGSIZE)panic("tx size overflow\n");
f010712a:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
f0107130:	76 1c                	jbe    f010714e <e1000_tx_packet+0x43>
f0107132:	c7 44 24 08 ec 9d 10 	movl   $0xf0109dec,0x8(%esp)
f0107139:	f0 
f010713a:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
f0107141:	00 
f0107142:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f0107149:	e8 37 8f ff ff       	call   f0100085 <_panic>
	pp = page_alloc(1);
f010714e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0107155:	e8 98 a2 ff ff       	call   f01013f2 <page_alloc>
f010715a:	89 c3                	mov    %eax,%ebx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010715c:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f0107162:	c1 f8 03             	sar    $0x3,%eax
f0107165:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0107168:	89 c2                	mov    %eax,%edx
f010716a:	c1 ea 0c             	shr    $0xc,%edx
f010716d:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0107173:	72 20                	jb     f0107195 <e1000_tx_packet+0x8a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107175:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107179:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0107180:	f0 
f0107181:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0107188:	00 
f0107189:	c7 04 24 1f 8e 10 f0 	movl   $0xf0108e1f,(%esp)
f0107190:	e8 f0 8e ff ff       	call   f0100085 <_panic>
	memmove(page2kva(pp),buf,size);
f0107195:	89 74 24 08          	mov    %esi,0x8(%esp)
f0107199:	8b 55 08             	mov    0x8(%ebp),%edx
f010719c:	89 54 24 04          	mov    %edx,0x4(%esp)
f01071a0:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01071a5:	89 04 24             	mov    %eax,(%esp)
f01071a8:	e8 42 f2 ff ff       	call   f01063ef <memmove>
	
	tdesc_addr[tx_tail].addr = page2pa(pp);
f01071ad:	a1 84 1e 27 f0       	mov    0xf0271e84,%eax
f01071b2:	c1 e0 04             	shl    $0x4,%eax
f01071b5:	03 05 0c 30 2b f0    	add    0xf02b300c,%eax
f01071bb:	2b 1d ac 1e 27 f0    	sub    0xf0271eac,%ebx
f01071c1:	c1 fb 03             	sar    $0x3,%ebx
f01071c4:	89 da                	mov    %ebx,%edx
f01071c6:	c1 e2 0c             	shl    $0xc,%edx
f01071c9:	b9 00 00 00 00       	mov    $0x0,%ecx
f01071ce:	89 10                	mov    %edx,(%eax)
f01071d0:	89 48 04             	mov    %ecx,0x4(%eax)
	tdesc_addr[tx_tail].length = size;
f01071d3:	a1 84 1e 27 f0       	mov    0xf0271e84,%eax
f01071d8:	c1 e0 04             	shl    $0x4,%eax
f01071db:	03 05 0c 30 2b f0    	add    0xf02b300c,%eax
f01071e1:	66 89 70 08          	mov    %si,0x8(%eax)
	tdesc_addr[tx_tail].cmd = E1000_TDESC_IFCS|E1000_TDESC_IC|E1000_TDESC_RS;
f01071e5:	a1 84 1e 27 f0       	mov    0xf0271e84,%eax
f01071ea:	c1 e0 04             	shl    $0x4,%eax
f01071ed:	03 05 0c 30 2b f0    	add    0xf02b300c,%eax
f01071f3:	c6 40 0b 0e          	movb   $0xe,0xb(%eax)
	tdesc_addr[tx_tail].cmd = E1000_SET_TDESC_EOP(tdesc_addr[tx_tail].cmd,1);
f01071f7:	a1 84 1e 27 f0       	mov    0xf0271e84,%eax
f01071fc:	c1 e0 04             	shl    $0x4,%eax
f01071ff:	03 05 0c 30 2b f0    	add    0xf02b300c,%eax
f0107205:	0f b6 50 0b          	movzbl 0xb(%eax),%edx
f0107209:	83 ca 01             	or     $0x1,%edx
f010720c:	88 50 0b             	mov    %dl,0xb(%eax)
	tx_tail = (tx_tail+1)%TDESC_ARRAY_SIZE;	
f010720f:	8b 0d 84 1e 27 f0    	mov    0xf0271e84,%ecx
f0107215:	83 c1 01             	add    $0x1,%ecx
f0107218:	89 ca                	mov    %ecx,%edx
f010721a:	c1 fa 1f             	sar    $0x1f,%edx
f010721d:	c1 ea 19             	shr    $0x19,%edx
f0107220:	8d 04 11             	lea    (%ecx,%edx,1),%eax
f0107223:	83 e0 7f             	and    $0x7f,%eax
f0107226:	29 d0                	sub    %edx,%eax
f0107228:	a3 84 1e 27 f0       	mov    %eax,0xf0271e84
int rx_head = 0;
int rx_tail = 0;

inline void e1000w(int index, int value)
{
	e1000[index] = value;
f010722d:	8b 15 08 30 2b f0    	mov    0xf02b3008,%edx
f0107233:	81 c2 18 38 00 00    	add    $0x3818,%edx
f0107239:	89 02                	mov    %eax,(%edx)
f010723b:	b8 00 00 00 00       	mov    $0x0,%eax
	tdesc_addr[tx_tail].cmd = E1000_TDESC_IFCS|E1000_TDESC_IC|E1000_TDESC_RS;
	tdesc_addr[tx_tail].cmd = E1000_SET_TDESC_EOP(tdesc_addr[tx_tail].cmd,1);
	tx_tail = (tx_tail+1)%TDESC_ARRAY_SIZE;	
	e1000w(E1000_TDT_REG,tx_tail);
	return 0;
}
f0107240:	83 c4 10             	add    $0x10,%esp
f0107243:	5b                   	pop    %ebx
f0107244:	5e                   	pop    %esi
f0107245:	5d                   	pop    %ebp
f0107246:	c3                   	ret    

f0107247 <e1000_init>:
{
	return e1000[index];
}

void e1000_init(physaddr_t pa, size_t size)
{
f0107247:	55                   	push   %ebp
f0107248:	89 e5                	mov    %esp,%ebp
f010724a:	57                   	push   %edi
f010724b:	56                   	push   %esi
f010724c:	53                   	push   %ebx
f010724d:	83 ec 1c             	sub    $0x1c,%esp
f0107250:	8b 75 08             	mov    0x8(%ebp),%esi
f0107253:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	uint32_t ssize,i;	
	struct PageInfo *pp;
	
	e1000 = mmio_map_region(pa,size);
f0107256:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010725a:	89 34 24             	mov    %esi,(%esp)
f010725d:	e8 45 a4 ff ff       	call   f01016a7 <mmio_map_region>
f0107262:	a3 08 30 2b f0       	mov    %eax,0xf02b3008
	cprintf("physical addr %x (size %u) mapped to %x\n",pa, size, (uint32_t)e1000);
f0107267:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010726b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010726f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0107273:	c7 04 24 60 9e 10 f0 	movl   $0xf0109e60,(%esp)
f010727a:	e8 80 d3 ff ff       	call   f01045ff <cprintf>
	//transmit configuration
	//alloc tdesc frame
	ssize = TDESC_ARRAY_SIZE*sizeof(struct tx_desc);
	if(ssize > PGSIZE) panic("tdesc array size overflow\n");
	
	pp = page_alloc(1);
f010727f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0107286:	e8 67 a1 ff ff       	call   f01013f2 <page_alloc>
	if(!pp)	panic("tdesc alloc page error\n");
f010728b:	85 c0                	test   %eax,%eax
f010728d:	75 1c                	jne    f01072ab <e1000_init+0x64>
f010728f:	c7 44 24 08 fe 9d 10 	movl   $0xf0109dfe,0x8(%esp)
f0107296:	f0 
f0107297:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
f010729e:	00 
f010729f:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f01072a6:	e8 da 8d ff ff       	call   f0100085 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01072ab:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f01072b1:	c1 f8 03             	sar    $0x3,%eax
f01072b4:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01072b7:	89 c2                	mov    %eax,%edx
f01072b9:	c1 ea 0c             	shr    $0xc,%edx
f01072bc:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f01072c2:	72 20                	jb     f01072e4 <e1000_init+0x9d>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01072c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01072c8:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f01072cf:	f0 
f01072d0:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
f01072d7:	00 
f01072d8:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f01072df:	e8 a1 8d ff ff       	call   f0100085 <_panic>
	return (void *)(pa + KERNBASE);
f01072e4:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	tdesc_addr = KADDR(page2pa(pp));
f01072ea:	89 15 0c 30 2b f0    	mov    %edx,0xf02b300c
	if((uint32_t)tdesc_addr < KERNBASE) panic("test_addr is out of range");
f01072f0:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01072f6:	77 1c                	ja     f0107314 <e1000_init+0xcd>
f01072f8:	c7 44 24 08 16 9e 10 	movl   $0xf0109e16,0x8(%esp)
f01072ff:	f0 
f0107300:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
f0107307:	00 
f0107308:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f010730f:	e8 71 8d ff ff       	call   f0100085 <_panic>
int rx_head = 0;
int rx_tail = 0;

inline void e1000w(int index, int value)
{
	e1000[index] = value;
f0107314:	8b 15 08 30 2b f0    	mov    0xf02b3008,%edx
f010731a:	81 c2 00 38 00 00    	add    $0x3800,%edx
f0107320:	89 02                	mov    %eax,(%edx)
f0107322:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f0107327:	05 04 38 00 00       	add    $0x3804,%eax
f010732c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0107332:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f0107337:	05 08 38 00 00       	add    $0x3808,%eax
f010733c:	c7 00 00 08 00 00    	movl   $0x800,(%eax)
f0107342:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f0107347:	05 10 38 00 00       	add    $0x3810,%eax
f010734c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0107352:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f0107357:	05 18 38 00 00       	add    $0x3818,%eax
f010735c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0107362:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f0107367:	05 10 04 00 00       	add    $0x410,%eax
f010736c:	c7 00 10 00 00 00    	movl   $0x10,(%eax)
f0107372:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f0107377:	05 00 04 00 00       	add    $0x400,%eax
f010737c:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)
f0107382:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f0107387:	05 00 54 00 00       	add    $0x5400,%eax
f010738c:	c7 00 52 54 00 12    	movl   $0x12005452,(%eax)
f0107392:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f0107397:	05 04 54 00 00       	add    $0x5404,%eax
f010739c:	c7 00 34 56 00 80    	movl   $0x80005634,(%eax)
f01073a2:	b8 00 52 00 00       	mov    $0x5200,%eax
f01073a7:	89 c2                	mov    %eax,%edx
f01073a9:	03 15 08 30 2b f0    	add    0xf02b3008,%edx
f01073af:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
f01073b5:	83 c0 10             	add    $0x10,%eax
	//init rda and mar
	//alloc rx buf
	e1000w(E1000_RDAL_REG,L32_MAC_ADDR);
	e1000w(E1000_RDAH_REG,H16_MAC_ADDR|E1000_RDAH_AS|E1000_RDAH_AV);

	for(i=E1000_MTA_START_REG;i<E1000_MTA_END_REG;i+=4) e1000w(i,0);
f01073b8:	3d 00 54 00 00       	cmp    $0x5400,%eax
f01073bd:	75 e8                	jne    f01073a7 <e1000_init+0x160>
int rx_head = 0;
int rx_tail = 0;

inline void e1000w(int index, int value)
{
	e1000[index] = value;
f01073bf:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f01073c4:	05 d0 00 00 00       	add    $0xd0,%eax
f01073c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01073cf:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f01073d4:	05 10 28 00 00       	add    $0x2810,%eax
f01073d9:	8b 15 88 1e 27 f0    	mov    0xf0271e88,%edx
f01073df:	89 10                	mov    %edx,(%eax)
f01073e1:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f01073e6:	05 18 28 00 00       	add    $0x2818,%eax
f01073eb:	8b 15 8c 1e 27 f0    	mov    0xf0271e8c,%edx
f01073f1:	89 10                	mov    %edx,(%eax)
	e1000w(E1000_RDT_REG,rx_tail);

	ssize = RDESC_ARRAY_SIZE*sizeof(struct rx_desc);
	if(ssize > PGSIZE) panic("rdesc array size overflow\n");
	
	pp = page_alloc(1);
f01073f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01073fa:	e8 f3 9f ff ff       	call   f01013f2 <page_alloc>
	if(!pp)	panic("rdesc alloc page error\n");
f01073ff:	85 c0                	test   %eax,%eax
f0107401:	75 1c                	jne    f010741f <e1000_init+0x1d8>
f0107403:	c7 44 24 08 30 9e 10 	movl   $0xf0109e30,0x8(%esp)
f010740a:	f0 
f010740b:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
f0107412:	00 
f0107413:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f010741a:	e8 66 8c ff ff       	call   f0100085 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010741f:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f0107425:	c1 f8 03             	sar    $0x3,%eax
f0107428:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010742b:	89 c2                	mov    %eax,%edx
f010742d:	c1 ea 0c             	shr    $0xc,%edx
f0107430:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f0107436:	72 20                	jb     f0107458 <e1000_init+0x211>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107438:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010743c:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f0107443:	f0 
f0107444:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
f010744b:	00 
f010744c:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f0107453:	e8 2d 8c ff ff       	call   f0100085 <_panic>
	rdesc_addr = KADDR(page2pa(pp));
f0107458:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f010745e:	89 15 10 30 2b f0    	mov    %edx,0xf02b3010
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0107464:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010746a:	77 20                	ja     f010748c <e1000_init+0x245>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010746c:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0107470:	c7 44 24 08 74 7f 10 	movl   $0xf0107f74,0x8(%esp)
f0107477:	f0 
f0107478:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
f010747f:	00 
f0107480:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f0107487:	e8 f9 8b ff ff       	call   f0100085 <_panic>
int rx_head = 0;
int rx_tail = 0;

inline void e1000w(int index, int value)
{
	e1000[index] = value;
f010748c:	8b 15 08 30 2b f0    	mov    0xf02b3008,%edx
f0107492:	81 c2 00 28 00 00    	add    $0x2800,%edx
f0107498:	89 02                	mov    %eax,(%edx)
f010749a:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f010749f:	05 04 28 00 00       	add    $0x2804,%eax
f01074a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01074aa:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f01074af:	05 08 28 00 00       	add    $0x2808,%eax
f01074b4:	c7 00 00 08 00 00    	movl   $0x800,(%eax)
f01074ba:	bb 00 00 00 00       	mov    $0x0,%ebx
	e1000w(E1000_RDBAH_REG,0);
	e1000w(E1000_RDLEN_REG,ssize);

	for(i=0;i<RDESC_ARRAY_SIZE;i++)
	{
		memset((void *)KADDR(rdesc_addr[i].addr),0,sizeof(struct rx_desc));
f01074bf:	89 d8                	mov    %ebx,%eax
f01074c1:	03 05 10 30 2b f0    	add    0xf02b3010,%eax
f01074c7:	8b 50 04             	mov    0x4(%eax),%edx
f01074ca:	8b 00                	mov    (%eax),%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01074cc:	89 c2                	mov    %eax,%edx
f01074ce:	c1 ea 0c             	shr    $0xc,%edx
f01074d1:	3b 15 a4 1e 27 f0    	cmp    0xf0271ea4,%edx
f01074d7:	72 20                	jb     f01074f9 <e1000_init+0x2b2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01074d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01074dd:	c7 44 24 08 98 7f 10 	movl   $0xf0107f98,0x8(%esp)
f01074e4:	f0 
f01074e5:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
f01074ec:	00 
f01074ed:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f01074f4:	e8 8c 8b ff ff       	call   f0100085 <_panic>
f01074f9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0107500:	00 
f0107501:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107508:	00 
f0107509:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010750e:	89 04 24             	mov    %eax,(%esp)
f0107511:	e8 7a ee ff ff       	call   f0106390 <memset>
		pp = page_alloc(1);
f0107516:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010751d:	e8 d0 9e ff ff       	call   f01013f2 <page_alloc>
		if(!pp) panic("buf alloc page error\n");
f0107522:	85 c0                	test   %eax,%eax
f0107524:	75 1c                	jne    f0107542 <e1000_init+0x2fb>
f0107526:	c7 44 24 08 48 9e 10 	movl   $0xf0109e48,0x8(%esp)
f010752d:	f0 
f010752e:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
f0107535:	00 
f0107536:	c7 04 24 c7 9d 10 f0 	movl   $0xf0109dc7,(%esp)
f010753d:	e8 43 8b ff ff       	call   f0100085 <_panic>
		rdesc_addr[i].addr = page2pa(pp);	
f0107542:	89 da                	mov    %ebx,%edx
f0107544:	03 15 10 30 2b f0    	add    0xf02b3010,%edx
f010754a:	2b 05 ac 1e 27 f0    	sub    0xf0271eac,%eax
f0107550:	c1 f8 03             	sar    $0x3,%eax
f0107553:	89 c6                	mov    %eax,%esi
f0107555:	c1 e6 0c             	shl    $0xc,%esi
f0107558:	bf 00 00 00 00       	mov    $0x0,%edi
f010755d:	89 32                	mov    %esi,(%edx)
f010755f:	89 7a 04             	mov    %edi,0x4(%edx)
f0107562:	83 c3 10             	add    $0x10,%ebx

	e1000w(E1000_RDBAL_REG,PADDR((void *)rdesc_addr));
	e1000w(E1000_RDBAH_REG,0);
	e1000w(E1000_RDLEN_REG,ssize);

	for(i=0;i<RDESC_ARRAY_SIZE;i++)
f0107565:	81 fb 00 08 00 00    	cmp    $0x800,%ebx
f010756b:	0f 85 4e ff ff ff    	jne    f01074bf <e1000_init+0x278>
int rx_head = 0;
int rx_tail = 0;

inline void e1000w(int index, int value)
{
	e1000[index] = value;
f0107571:	a1 08 30 2b f0       	mov    0xf02b3008,%eax
f0107576:	05 00 01 00 00       	add    $0x100,%eax
f010757b:	c7 00 02 02 00 04    	movl   $0x4000202,(%eax)
	}	

	e1000w(E1000_RCTRL_REG,
		   E1000_RCTRL_EN|E1000_RCTRL_SBP|E1000_RCTRL_UPE|E1000_RCTRL_UPE|E1000_RCTRL_LPE|E1000_RCTRL_LBM|
		   E1000_RCTRL_RDMTS|E1000_RCTRL_MO|E1000_RCTRL_BAM|E1000_RCTRL_BSIZE|E1000_RCTRL_BSE|E1000_RCTRL_SECRC);
}
f0107581:	83 c4 1c             	add    $0x1c,%esp
f0107584:	5b                   	pop    %ebx
f0107585:	5e                   	pop    %esi
f0107586:	5f                   	pop    %edi
f0107587:	5d                   	pop    %ebp
f0107588:	c3                   	ret    
f0107589:	00 00                	add    %al,(%eax)
	...

f010758c <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f010758c:	55                   	push   %ebp
f010758d:	89 e5                	mov    %esp,%ebp
f010758f:	57                   	push   %edi
f0107590:	56                   	push   %esi
f0107591:	53                   	push   %ebx
f0107592:	83 ec 2c             	sub    $0x2c,%esp
f0107595:	89 c6                	mov    %eax,%esi
f0107597:	89 d7                	mov    %edx,%edi
f0107599:	89 cb                	mov    %ecx,%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f010759b:	eb 3b                	jmp    f01075d8 <pci_attach_match+0x4c>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f010759d:	39 33                	cmp    %esi,(%ebx)
f010759f:	75 34                	jne    f01075d5 <pci_attach_match+0x49>
f01075a1:	39 7b 04             	cmp    %edi,0x4(%ebx)
f01075a4:	75 2f                	jne    f01075d5 <pci_attach_match+0x49>
			int r = list[i].attachfn(pcif);
f01075a6:	8b 55 08             	mov    0x8(%ebp),%edx
f01075a9:	89 14 24             	mov    %edx,(%esp)
f01075ac:	ff d0                	call   *%eax
			if (r > 0)
f01075ae:	85 c0                	test   %eax,%eax
f01075b0:	7f 2d                	jg     f01075df <pci_attach_match+0x53>
				return r;
			if (r < 0)
f01075b2:	85 c0                	test   %eax,%eax
f01075b4:	79 1f                	jns    f01075d5 <pci_attach_match+0x49>
				cprintf("pci_attach_match: attaching "
f01075b6:	89 44 24 10          	mov    %eax,0x10(%esp)
f01075ba:	8b 43 08             	mov    0x8(%ebx),%eax
f01075bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01075c1:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01075c5:	89 74 24 04          	mov    %esi,0x4(%esp)
f01075c9:	c7 04 24 9c 9e 10 f0 	movl   $0xf0109e9c,(%esp)
f01075d0:	e8 2a d0 ff ff       	call   f01045ff <cprintf>
f01075d5:	83 c3 0c             	add    $0xc,%ebx
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f01075d8:	8b 43 08             	mov    0x8(%ebx),%eax
f01075db:	85 c0                	test   %eax,%eax
f01075dd:	75 be                	jne    f010759d <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f01075df:	83 c4 2c             	add    $0x2c,%esp
f01075e2:	5b                   	pop    %ebx
f01075e3:	5e                   	pop    %esi
f01075e4:	5f                   	pop    %edi
f01075e5:	5d                   	pop    %ebp
f01075e6:	c3                   	ret    

f01075e7 <pci_conf1_set_addr>:
static void
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f01075e7:	55                   	push   %ebp
f01075e8:	89 e5                	mov    %esp,%ebp
f01075ea:	53                   	push   %ebx
f01075eb:	83 ec 14             	sub    $0x14,%esp
f01075ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f01075f1:	3d ff 00 00 00       	cmp    $0xff,%eax
f01075f6:	76 24                	jbe    f010761c <pci_conf1_set_addr+0x35>
f01075f8:	c7 44 24 0c f4 9f 10 	movl   $0xf0109ff4,0xc(%esp)
f01075ff:	f0 
f0107600:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0107607:	f0 
f0107608:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
f010760f:	00 
f0107610:	c7 04 24 fe 9f 10 f0 	movl   $0xf0109ffe,(%esp)
f0107617:	e8 69 8a ff ff       	call   f0100085 <_panic>
	assert(dev < 32);
f010761c:	83 fa 1f             	cmp    $0x1f,%edx
f010761f:	76 24                	jbe    f0107645 <pci_conf1_set_addr+0x5e>
f0107621:	c7 44 24 0c 09 a0 10 	movl   $0xf010a009,0xc(%esp)
f0107628:	f0 
f0107629:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0107630:	f0 
f0107631:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
f0107638:	00 
f0107639:	c7 04 24 fe 9f 10 f0 	movl   $0xf0109ffe,(%esp)
f0107640:	e8 40 8a ff ff       	call   f0100085 <_panic>
	assert(func < 8);
f0107645:	83 f9 07             	cmp    $0x7,%ecx
f0107648:	76 24                	jbe    f010766e <pci_conf1_set_addr+0x87>
f010764a:	c7 44 24 0c 12 a0 10 	movl   $0xf010a012,0xc(%esp)
f0107651:	f0 
f0107652:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0107659:	f0 
f010765a:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
f0107661:	00 
f0107662:	c7 04 24 fe 9f 10 f0 	movl   $0xf0109ffe,(%esp)
f0107669:	e8 17 8a ff ff       	call   f0100085 <_panic>
	assert(offset < 256);
f010766e:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0107674:	76 24                	jbe    f010769a <pci_conf1_set_addr+0xb3>
f0107676:	c7 44 24 0c 1b a0 10 	movl   $0xf010a01b,0xc(%esp)
f010767d:	f0 
f010767e:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f0107685:	f0 
f0107686:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
f010768d:	00 
f010768e:	c7 04 24 fe 9f 10 f0 	movl   $0xf0109ffe,(%esp)
f0107695:	e8 eb 89 ff ff       	call   f0100085 <_panic>
	assert((offset & 0x3) == 0);
f010769a:	f6 c3 03             	test   $0x3,%bl
f010769d:	74 24                	je     f01076c3 <pci_conf1_set_addr+0xdc>
f010769f:	c7 44 24 0c 28 a0 10 	movl   $0xf010a028,0xc(%esp)
f01076a6:	f0 
f01076a7:	c7 44 24 08 15 7f 10 	movl   $0xf0107f15,0x8(%esp)
f01076ae:	f0 
f01076af:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
f01076b6:	00 
f01076b7:	c7 04 24 fe 9f 10 f0 	movl   $0xf0109ffe,(%esp)
f01076be:	e8 c2 89 ff ff       	call   f0100085 <_panic>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01076c3:	c1 e0 10             	shl    $0x10,%eax
f01076c6:	0d 00 00 00 80       	or     $0x80000000,%eax
f01076cb:	c1 e2 0b             	shl    $0xb,%edx
f01076ce:	09 d0                	or     %edx,%eax
f01076d0:	09 d8                	or     %ebx,%eax
f01076d2:	c1 e1 08             	shl    $0x8,%ecx
f01076d5:	09 c8                	or     %ecx,%eax
f01076d7:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f01076dc:	ef                   	out    %eax,(%dx)

	uint32_t v = (1 << 31) |		// config-space
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
	outl(pci_conf1_addr_ioport, v);
}
f01076dd:	83 c4 14             	add    $0x14,%esp
f01076e0:	5b                   	pop    %ebx
f01076e1:	5d                   	pop    %ebp
f01076e2:	c3                   	ret    

f01076e3 <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f01076e3:	55                   	push   %ebp
f01076e4:	89 e5                	mov    %esp,%ebp
f01076e6:	53                   	push   %ebx
f01076e7:	83 ec 14             	sub    $0x14,%esp
f01076ea:	89 d3                	mov    %edx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01076ec:	8b 48 08             	mov    0x8(%eax),%ecx
f01076ef:	8b 50 04             	mov    0x4(%eax),%edx
f01076f2:	8b 00                	mov    (%eax),%eax
f01076f4:	8b 40 04             	mov    0x4(%eax),%eax
f01076f7:	89 1c 24             	mov    %ebx,(%esp)
f01076fa:	e8 e8 fe ff ff       	call   f01075e7 <pci_conf1_set_addr>

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f01076ff:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107704:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f0107705:	83 c4 14             	add    $0x14,%esp
f0107708:	5b                   	pop    %ebx
f0107709:	5d                   	pop    %ebp
f010770a:	c3                   	ret    

f010770b <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f010770b:	55                   	push   %ebp
f010770c:	89 e5                	mov    %esp,%ebp
f010770e:	57                   	push   %edi
f010770f:	56                   	push   %esi
f0107710:	53                   	push   %ebx
f0107711:	81 ec 3c 01 00 00    	sub    $0x13c,%esp
f0107717:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0107719:	c7 44 24 08 48 00 00 	movl   $0x48,0x8(%esp)
f0107720:	00 
f0107721:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107728:	00 
f0107729:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010772c:	89 04 24             	mov    %eax,(%esp)
f010772f:	e8 5c ec ff ff       	call   f0106390 <memset>
	df.bus = bus;
f0107734:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107737:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
};

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
f010773e:	c7 85 fc fe ff ff 00 	movl   $0x0,-0x104(%ebp)
f0107745:	00 00 00 
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107748:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010774b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
			continue;

		totaldev++;

		struct pci_func f = df;
f0107751:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
f0107757:	89 8d f4 fe ff ff    	mov    %ecx,-0x10c(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
			struct pci_func af = f;
f010775d:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107763:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
f0107769:	89 8d 00 ff ff ff    	mov    %ecx,-0x100(%ebp)
f010776f:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107775:	ba 0c 00 00 00       	mov    $0xc,%edx
f010777a:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010777d:	e8 61 ff ff ff       	call   f01076e3 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0107782:	89 c2                	mov    %eax,%edx
f0107784:	c1 ea 10             	shr    $0x10,%edx
f0107787:	83 e2 7f             	and    $0x7f,%edx
f010778a:	83 fa 01             	cmp    $0x1,%edx
f010778d:	0f 87 77 01 00 00    	ja     f010790a <pci_scan_bus+0x1ff>
			continue;

		totaldev++;

		struct pci_func f = df;
f0107793:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107798:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
f010779e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
f01077a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01077a6:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
f01077ad:	00 00 00 
f01077b0:	89 c3                	mov    %eax,%ebx
f01077b2:	81 e3 00 00 80 00    	and    $0x800000,%ebx
f01077b8:	e9 2f 01 00 00       	jmp    f01078ec <pci_scan_bus+0x1e1>
		     f.func++) {
			struct pci_func af = f;
f01077bd:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
f01077c3:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
f01077c9:	b9 12 00 00 00       	mov    $0x12,%ecx
f01077ce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f01077d0:	ba 00 00 00 00       	mov    $0x0,%edx
f01077d5:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f01077db:	e8 03 ff ff ff       	call   f01076e3 <pci_conf_read>
f01077e0:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f01077e6:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f01077ea:	0f 84 f5 00 00 00    	je     f01078e5 <pci_scan_bus+0x1da>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01077f0:	ba 3c 00 00 00       	mov    $0x3c,%edx
f01077f5:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f01077fb:	e8 e3 fe ff ff       	call   f01076e3 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0107800:	88 85 54 ff ff ff    	mov    %al,-0xac(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107806:	ba 08 00 00 00       	mov    $0x8,%edx
f010780b:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0107811:	e8 cd fe ff ff       	call   f01076e3 <pci_conf_read>
f0107816:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f010781c:	89 c2                	mov    %eax,%edx
f010781e:	c1 ea 18             	shr    $0x18,%edx
f0107821:	b9 3c a0 10 f0       	mov    $0xf010a03c,%ecx
f0107826:	83 fa 06             	cmp    $0x6,%edx
f0107829:	77 07                	ja     f0107832 <pci_scan_bus+0x127>
		class = pci_class[PCI_CLASS(f->dev_class)];
f010782b:	8b 0c 95 cc a0 10 f0 	mov    -0xfef5f34(,%edx,4),%ecx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107832:	8b bd 1c ff ff ff    	mov    -0xe4(%ebp),%edi
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107838:	0f b6 b5 54 ff ff ff 	movzbl -0xac(%ebp),%esi
f010783f:	89 74 24 24          	mov    %esi,0x24(%esp)
f0107843:	89 4c 24 20          	mov    %ecx,0x20(%esp)
f0107847:	c1 e8 10             	shr    $0x10,%eax
f010784a:	25 ff 00 00 00       	and    $0xff,%eax
f010784f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0107853:	89 54 24 18          	mov    %edx,0x18(%esp)
f0107857:	89 f8                	mov    %edi,%eax
f0107859:	c1 e8 10             	shr    $0x10,%eax
f010785c:	89 44 24 14          	mov    %eax,0x14(%esp)
f0107860:	81 e7 ff ff 00 00    	and    $0xffff,%edi
f0107866:	89 7c 24 10          	mov    %edi,0x10(%esp)
f010786a:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
f0107870:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107874:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
f010787a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010787e:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
f0107884:	8b 40 04             	mov    0x4(%eax),%eax
f0107887:	89 44 24 04          	mov    %eax,0x4(%esp)
f010788b:	c7 04 24 c8 9e 10 f0 	movl   $0xf0109ec8,(%esp)
f0107892:	e8 68 cd ff ff       	call   f01045ff <cprintf>
static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
f0107897:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
				 &pci_attach_class[0], f) ||
f010789d:	89 c2                	mov    %eax,%edx
f010789f:	c1 ea 10             	shr    $0x10,%edx
f01078a2:	81 e2 ff 00 00 00    	and    $0xff,%edx
f01078a8:	c1 e8 18             	shr    $0x18,%eax
f01078ab:	8b 8d 04 ff ff ff    	mov    -0xfc(%ebp),%ecx
f01078b1:	89 0c 24             	mov    %ecx,(%esp)
f01078b4:	b9 e0 53 12 f0       	mov    $0xf01253e0,%ecx
f01078b9:	e8 ce fc ff ff       	call   f010758c <pci_attach_match>

static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
f01078be:	85 c0                	test   %eax,%eax
f01078c0:	75 23                	jne    f01078e5 <pci_scan_bus+0x1da>
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
		pci_attach_match(PCI_VENDOR(f->dev_id),
				 PCI_PRODUCT(f->dev_id),
f01078c2:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
				 &pci_attach_vendor[0], f);
f01078c8:	89 c2                	mov    %eax,%edx
f01078ca:	c1 ea 10             	shr    $0x10,%edx
f01078cd:	25 ff ff 00 00       	and    $0xffff,%eax
f01078d2:	8b 8d 04 ff ff ff    	mov    -0xfc(%ebp),%ecx
f01078d8:	89 0c 24             	mov    %ecx,(%esp)
f01078db:	b9 00 54 12 f0       	mov    $0xf0125400,%ecx
f01078e0:	e8 a7 fc ff ff       	call   f010758c <pci_attach_match>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f01078e5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01078ec:	83 fb 01             	cmp    $0x1,%ebx
f01078ef:	19 c0                	sbb    %eax,%eax
f01078f1:	83 e0 f9             	and    $0xfffffff9,%eax
f01078f4:	83 c0 08             	add    $0x8,%eax
f01078f7:	3b 85 60 ff ff ff    	cmp    -0xa0(%ebp),%eax
f01078fd:	0f 87 ba fe ff ff    	ja     f01077bd <pci_scan_bus+0xb2>
	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
			continue;

		totaldev++;
f0107903:	83 85 fc fe ff ff 01 	addl   $0x1,-0x104(%ebp)
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
f010790a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f010790d:	83 c0 01             	add    $0x1,%eax
f0107910:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0107913:	83 f8 1f             	cmp    $0x1f,%eax
f0107916:	0f 86 59 fe ff ff    	jbe    f0107775 <pci_scan_bus+0x6a>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f010791c:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
f0107922:	81 c4 3c 01 00 00    	add    $0x13c,%esp
f0107928:	5b                   	pop    %ebx
f0107929:	5e                   	pop    %esi
f010792a:	5f                   	pop    %edi
f010792b:	5d                   	pop    %ebp
f010792c:	c3                   	ret    

f010792d <pci_init>:

}

int
pci_init(void)
{
f010792d:	55                   	push   %ebp
f010792e:	89 e5                	mov    %esp,%ebp
f0107930:	83 ec 18             	sub    $0x18,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107933:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f010793a:	00 
f010793b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107942:	00 
f0107943:	c7 04 24 90 1e 27 f0 	movl   $0xf0271e90,(%esp)
f010794a:	e8 41 ea ff ff       	call   f0106390 <memset>

	return pci_scan_bus(&root_bus);
f010794f:	b8 90 1e 27 f0       	mov    $0xf0271e90,%eax
f0107954:	e8 b2 fd ff ff       	call   f010770b <pci_scan_bus>
}
f0107959:	c9                   	leave  
f010795a:	c3                   	ret    

f010795b <pci_bridge_attach>:
	return totaldev;
}

static int
pci_bridge_attach(struct pci_func *pcif)
{
f010795b:	55                   	push   %ebp
f010795c:	89 e5                	mov    %esp,%ebp
f010795e:	83 ec 48             	sub    $0x48,%esp
f0107961:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0107964:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0107967:	89 7d fc             	mov    %edi,-0x4(%ebp)
f010796a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f010796d:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0107972:	89 d8                	mov    %ebx,%eax
f0107974:	e8 6a fd ff ff       	call   f01076e3 <pci_conf_read>
f0107979:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f010797b:	ba 18 00 00 00       	mov    $0x18,%edx
f0107980:	89 d8                	mov    %ebx,%eax
f0107982:	e8 5c fd ff ff       	call   f01076e3 <pci_conf_read>
f0107987:	89 c6                	mov    %eax,%esi

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0107989:	83 e7 0f             	and    $0xf,%edi
f010798c:	83 ff 01             	cmp    $0x1,%edi
f010798f:	75 2a                	jne    f01079bb <pci_bridge_attach+0x60>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0107991:	8b 43 08             	mov    0x8(%ebx),%eax
f0107994:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107998:	8b 43 04             	mov    0x4(%ebx),%eax
f010799b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010799f:	8b 03                	mov    (%ebx),%eax
f01079a1:	8b 40 04             	mov    0x4(%eax),%eax
f01079a4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01079a8:	c7 04 24 04 9f 10 f0 	movl   $0xf0109f04,(%esp)
f01079af:	e8 4b cc ff ff       	call   f01045ff <cprintf>
f01079b4:	b8 00 00 00 00       	mov    $0x0,%eax
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
f01079b9:	eb 66                	jmp    f0107a21 <pci_bridge_attach+0xc6>
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f01079bb:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f01079c2:	00 
f01079c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01079ca:	00 
f01079cb:	8d 7d e0             	lea    -0x20(%ebp),%edi
f01079ce:	89 3c 24             	mov    %edi,(%esp)
f01079d1:	e8 ba e9 ff ff       	call   f0106390 <memset>
	nbus.parent_bridge = pcif;
f01079d6:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f01079d9:	89 f2                	mov    %esi,%edx
f01079db:	0f b6 c6             	movzbl %dh,%eax
f01079de:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f01079e1:	c1 ee 10             	shr    $0x10,%esi
f01079e4:	81 e6 ff 00 00 00    	and    $0xff,%esi
f01079ea:	89 74 24 14          	mov    %esi,0x14(%esp)
f01079ee:	89 44 24 10          	mov    %eax,0x10(%esp)
f01079f2:	8b 43 08             	mov    0x8(%ebx),%eax
f01079f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01079f9:	8b 43 04             	mov    0x4(%ebx),%eax
f01079fc:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107a00:	8b 03                	mov    (%ebx),%eax
f0107a02:	8b 40 04             	mov    0x4(%eax),%eax
f0107a05:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107a09:	c7 04 24 38 9f 10 f0 	movl   $0xf0109f38,(%esp)
f0107a10:	e8 ea cb ff ff       	call   f01045ff <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);

	pci_scan_bus(&nbus);
f0107a15:	89 f8                	mov    %edi,%eax
f0107a17:	e8 ef fc ff ff       	call   f010770b <pci_scan_bus>
f0107a1c:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
}
f0107a21:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0107a24:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0107a27:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0107a2a:	89 ec                	mov    %ebp,%esp
f0107a2c:	5d                   	pop    %ebp
f0107a2d:	c3                   	ret    

f0107a2e <pci_conf_write>:
	return inl(pci_conf1_data_ioport);
}

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f0107a2e:	55                   	push   %ebp
f0107a2f:	89 e5                	mov    %esp,%ebp
f0107a31:	83 ec 18             	sub    $0x18,%esp
f0107a34:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0107a37:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0107a3a:	89 d3                	mov    %edx,%ebx
f0107a3c:	89 ce                	mov    %ecx,%esi
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107a3e:	8b 48 08             	mov    0x8(%eax),%ecx
f0107a41:	8b 50 04             	mov    0x4(%eax),%edx
f0107a44:	8b 00                	mov    (%eax),%eax
f0107a46:	8b 40 04             	mov    0x4(%eax),%eax
f0107a49:	89 1c 24             	mov    %ebx,(%esp)
f0107a4c:	e8 96 fb ff ff       	call   f01075e7 <pci_conf1_set_addr>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107a51:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107a56:	89 f0                	mov    %esi,%eax
f0107a58:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f0107a59:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0107a5c:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0107a5f:	89 ec                	mov    %ebp,%esp
f0107a61:	5d                   	pop    %ebp
f0107a62:	c3                   	ret    

f0107a63 <pci_func_enable>:

// External PCI subsystem interface

int
pci_func_enable(struct pci_func *f)
{
f0107a63:	55                   	push   %ebp
f0107a64:	89 e5                	mov    %esp,%ebp
f0107a66:	57                   	push   %edi
f0107a67:	56                   	push   %esi
f0107a68:	53                   	push   %ebx
f0107a69:	83 ec 4c             	sub    $0x4c,%esp
f0107a6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0107a6f:	b9 07 00 00 00       	mov    $0x7,%ecx
f0107a74:	ba 04 00 00 00       	mov    $0x4,%edx
f0107a79:	89 d8                	mov    %ebx,%eax
f0107a7b:	e8 ae ff ff ff       	call   f0107a2e <pci_conf_write>
f0107a80:	be 10 00 00 00       	mov    $0x10,%esi
	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f0107a85:	89 f2                	mov    %esi,%edx
f0107a87:	89 d8                	mov    %ebx,%eax
f0107a89:	e8 55 fc ff ff       	call   f01076e3 <pci_conf_read>
f0107a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		bar_width = 4;
		pci_conf_write(f, bar, 0xffffffff);
f0107a91:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0107a96:	89 f2                	mov    %esi,%edx
f0107a98:	89 d8                	mov    %ebx,%eax
f0107a9a:	e8 8f ff ff ff       	call   f0107a2e <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0107a9f:	89 f2                	mov    %esi,%edx
f0107aa1:	89 d8                	mov    %ebx,%eax
f0107aa3:	e8 3b fc ff ff       	call   f01076e3 <pci_conf_read>

		if (rv == 0) continue;
f0107aa8:	bf 04 00 00 00       	mov    $0x4,%edi
f0107aad:	85 c0                	test   %eax,%eax
f0107aaf:	0f 84 c4 00 00 00    	je     f0107b79 <pci_func_enable+0x116>

		int regnum = PCI_MAPREG_NUM(bar);
f0107ab5:	8d 56 f0             	lea    -0x10(%esi),%edx
f0107ab8:	c1 ea 02             	shr    $0x2,%edx
f0107abb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0107abe:	a8 01                	test   $0x1,%al
f0107ac0:	75 2c                	jne    f0107aee <pci_func_enable+0x8b>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0107ac2:	89 c2                	mov    %eax,%edx
f0107ac4:	83 e2 06             	and    $0x6,%edx
f0107ac7:	83 fa 04             	cmp    $0x4,%edx
f0107aca:	0f 94 c2             	sete   %dl
f0107acd:	0f b6 fa             	movzbl %dl,%edi
f0107ad0:	8d 3c bd 04 00 00 00 	lea    0x4(,%edi,4),%edi
				bar_width = 8;

			size = PCI_MAPREG_MEM_SIZE(rv);
f0107ad7:	83 e0 f0             	and    $0xfffffff0,%eax
f0107ada:	89 c2                	mov    %eax,%edx
f0107adc:	f7 da                	neg    %edx
f0107ade:	21 d0                	and    %edx,%eax
f0107ae0:	89 45 dc             	mov    %eax,-0x24(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0107ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0107ae6:	83 e0 f0             	and    $0xfffffff0,%eax
f0107ae9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0107aec:	eb 1a                	jmp    f0107b08 <pci_func_enable+0xa5>
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0107aee:	83 e0 fc             	and    $0xfffffffc,%eax
f0107af1:	89 c2                	mov    %eax,%edx
f0107af3:	f7 da                	neg    %edx
f0107af5:	21 d0                	and    %edx,%eax
f0107af7:	89 45 dc             	mov    %eax,-0x24(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
f0107afa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0107afd:	83 e2 fc             	and    $0xfffffffc,%edx
f0107b00:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0107b03:	bf 04 00 00 00       	mov    $0x4,%edi
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0107b08:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0107b0b:	89 f2                	mov    %esi,%edx
f0107b0d:	89 d8                	mov    %ebx,%eax
f0107b0f:	e8 1a ff ff ff       	call   f0107a2e <pci_conf_write>
		f->reg_base[regnum] = base;
f0107b14:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0107b17:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107b1a:	89 54 83 14          	mov    %edx,0x14(%ebx,%eax,4)
		f->reg_size[regnum] = size;
f0107b1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0107b21:	89 54 83 2c          	mov    %edx,0x2c(%ebx,%eax,4)

		if (size && !base)
f0107b25:	85 d2                	test   %edx,%edx
f0107b27:	74 50                	je     f0107b79 <pci_func_enable+0x116>
f0107b29:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0107b2d:	75 4a                	jne    f0107b79 <pci_func_enable+0x116>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107b2f:	8b 43 0c             	mov    0xc(%ebx),%eax
		pci_conf_write(f, bar, oldv);
		f->reg_base[regnum] = base;
		f->reg_size[regnum] = size;

		if (size && !base)
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0107b32:	89 54 24 20          	mov    %edx,0x20(%esp)
f0107b36:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0107b39:	89 54 24 1c          	mov    %edx,0x1c(%esp)
f0107b3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0107b40:	89 54 24 18          	mov    %edx,0x18(%esp)
f0107b44:	89 c2                	mov    %eax,%edx
f0107b46:	c1 ea 10             	shr    $0x10,%edx
f0107b49:	89 54 24 14          	mov    %edx,0x14(%esp)
f0107b4d:	25 ff ff 00 00       	and    $0xffff,%eax
f0107b52:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107b56:	8b 43 08             	mov    0x8(%ebx),%eax
f0107b59:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107b5d:	8b 43 04             	mov    0x4(%ebx),%eax
f0107b60:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107b64:	8b 03                	mov    (%ebx),%eax
f0107b66:	8b 40 04             	mov    0x4(%eax),%eax
f0107b69:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107b6d:	c7 04 24 68 9f 10 f0 	movl   $0xf0109f68,(%esp)
f0107b74:	e8 86 ca ff ff       	call   f01045ff <cprintf>
		       		  PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
f0107b79:	01 fe                	add    %edi,%esi
		       		  PCI_COMMAND_MEM_ENABLE |
		       		  PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107b7b:	83 fe 27             	cmp    $0x27,%esi
f0107b7e:	0f 86 01 ff ff ff    	jbe    f0107a85 <pci_func_enable+0x22>
				regnum, base, size);
	}
	
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0107b84:	8b 43 0c             	mov    0xc(%ebx),%eax
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
	}
	
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0107b87:	89 c2                	mov    %eax,%edx
f0107b89:	c1 ea 10             	shr    $0x10,%edx
f0107b8c:	89 54 24 14          	mov    %edx,0x14(%esp)
f0107b90:	25 ff ff 00 00       	and    $0xffff,%eax
f0107b95:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107b99:	8b 43 08             	mov    0x8(%ebx),%eax
f0107b9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107ba0:	8b 43 04             	mov    0x4(%ebx),%eax
f0107ba3:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107ba7:	8b 03                	mov    (%ebx),%eax
f0107ba9:	8b 40 04             	mov    0x4(%eax),%eax
f0107bac:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107bb0:	c7 04 24 c4 9f 10 f0 	movl   $0xf0109fc4,(%esp)
f0107bb7:	e8 43 ca ff ff       	call   f01045ff <cprintf>
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));

	//map register to virtual mem space
	e1000_init(f->reg_base[0],f->reg_size[0]);
f0107bbc:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0107bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107bc3:	8b 43 14             	mov    0x14(%ebx),%eax
f0107bc6:	89 04 24             	mov    %eax,(%esp)
f0107bc9:	e8 79 f6 ff ff       	call   f0107247 <e1000_init>
	
	cprintf("PCI status register %08x\n",e1000r(E1000_STATUS_REG/4));
f0107bce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0107bd5:	e8 ac f2 ff ff       	call   f0106e86 <e1000r>
f0107bda:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107bde:	c7 04 24 44 a0 10 f0 	movl   $0xf010a044,(%esp)
f0107be5:	e8 15 ca ff ff       	call   f01045ff <cprintf>
	return 0;

}
f0107bea:	b8 00 00 00 00       	mov    $0x0,%eax
f0107bef:	83 c4 4c             	add    $0x4c,%esp
f0107bf2:	5b                   	pop    %ebx
f0107bf3:	5e                   	pop    %esi
f0107bf4:	5f                   	pop    %edi
f0107bf5:	5d                   	pop    %ebp
f0107bf6:	c3                   	ret    
	...

f0107bf8 <time_init>:

static unsigned int ticks;

void
time_init(void)
{
f0107bf8:	55                   	push   %ebp
f0107bf9:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f0107bfb:	c7 05 98 1e 27 f0 00 	movl   $0x0,0xf0271e98
f0107c02:	00 00 00 
}
f0107c05:	5d                   	pop    %ebp
f0107c06:	c3                   	ret    

f0107c07 <time_msec>:
		panic("time_tick: time overflowed");
}

unsigned int
time_msec(void)
{
f0107c07:	55                   	push   %ebp
f0107c08:	89 e5                	mov    %esp,%ebp
f0107c0a:	a1 98 1e 27 f0       	mov    0xf0271e98,%eax
f0107c0f:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0107c12:	01 c0                	add    %eax,%eax
	return ticks * 10;
}
f0107c14:	5d                   	pop    %ebp
f0107c15:	c3                   	ret    

f0107c16 <time_tick>:

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
f0107c16:	55                   	push   %ebp
f0107c17:	89 e5                	mov    %esp,%ebp
f0107c19:	83 ec 18             	sub    $0x18,%esp
	ticks++;
f0107c1c:	a1 98 1e 27 f0       	mov    0xf0271e98,%eax
f0107c21:	83 c0 01             	add    $0x1,%eax
f0107c24:	a3 98 1e 27 f0       	mov    %eax,0xf0271e98
	if (ticks * 10 < ticks)
f0107c29:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0107c2c:	01 d2                	add    %edx,%edx
f0107c2e:	39 d0                	cmp    %edx,%eax
f0107c30:	76 1c                	jbe    f0107c4e <time_tick+0x38>
		panic("time_tick: time overflowed");
f0107c32:	c7 44 24 08 e8 a0 10 	movl   $0xf010a0e8,0x8(%esp)
f0107c39:	f0 
f0107c3a:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
f0107c41:	00 
f0107c42:	c7 04 24 03 a1 10 f0 	movl   $0xf010a103,(%esp)
f0107c49:	e8 37 84 ff ff       	call   f0100085 <_panic>
}
f0107c4e:	c9                   	leave  
f0107c4f:	c3                   	ret    

f0107c50 <__udivdi3>:
f0107c50:	55                   	push   %ebp
f0107c51:	89 e5                	mov    %esp,%ebp
f0107c53:	57                   	push   %edi
f0107c54:	56                   	push   %esi
f0107c55:	83 ec 10             	sub    $0x10,%esp
f0107c58:	8b 45 14             	mov    0x14(%ebp),%eax
f0107c5b:	8b 55 08             	mov    0x8(%ebp),%edx
f0107c5e:	8b 75 10             	mov    0x10(%ebp),%esi
f0107c61:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0107c64:	85 c0                	test   %eax,%eax
f0107c66:	89 55 f0             	mov    %edx,-0x10(%ebp)
f0107c69:	75 35                	jne    f0107ca0 <__udivdi3+0x50>
f0107c6b:	39 fe                	cmp    %edi,%esi
f0107c6d:	77 61                	ja     f0107cd0 <__udivdi3+0x80>
f0107c6f:	85 f6                	test   %esi,%esi
f0107c71:	75 0b                	jne    f0107c7e <__udivdi3+0x2e>
f0107c73:	b8 01 00 00 00       	mov    $0x1,%eax
f0107c78:	31 d2                	xor    %edx,%edx
f0107c7a:	f7 f6                	div    %esi
f0107c7c:	89 c6                	mov    %eax,%esi
f0107c7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0107c81:	31 d2                	xor    %edx,%edx
f0107c83:	89 f8                	mov    %edi,%eax
f0107c85:	f7 f6                	div    %esi
f0107c87:	89 c7                	mov    %eax,%edi
f0107c89:	89 c8                	mov    %ecx,%eax
f0107c8b:	f7 f6                	div    %esi
f0107c8d:	89 c1                	mov    %eax,%ecx
f0107c8f:	89 fa                	mov    %edi,%edx
f0107c91:	89 c8                	mov    %ecx,%eax
f0107c93:	83 c4 10             	add    $0x10,%esp
f0107c96:	5e                   	pop    %esi
f0107c97:	5f                   	pop    %edi
f0107c98:	5d                   	pop    %ebp
f0107c99:	c3                   	ret    
f0107c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107ca0:	39 f8                	cmp    %edi,%eax
f0107ca2:	77 1c                	ja     f0107cc0 <__udivdi3+0x70>
f0107ca4:	0f bd d0             	bsr    %eax,%edx
f0107ca7:	83 f2 1f             	xor    $0x1f,%edx
f0107caa:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0107cad:	75 39                	jne    f0107ce8 <__udivdi3+0x98>
f0107caf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0107cb2:	0f 86 a0 00 00 00    	jbe    f0107d58 <__udivdi3+0x108>
f0107cb8:	39 f8                	cmp    %edi,%eax
f0107cba:	0f 82 98 00 00 00    	jb     f0107d58 <__udivdi3+0x108>
f0107cc0:	31 ff                	xor    %edi,%edi
f0107cc2:	31 c9                	xor    %ecx,%ecx
f0107cc4:	89 c8                	mov    %ecx,%eax
f0107cc6:	89 fa                	mov    %edi,%edx
f0107cc8:	83 c4 10             	add    $0x10,%esp
f0107ccb:	5e                   	pop    %esi
f0107ccc:	5f                   	pop    %edi
f0107ccd:	5d                   	pop    %ebp
f0107cce:	c3                   	ret    
f0107ccf:	90                   	nop
f0107cd0:	89 d1                	mov    %edx,%ecx
f0107cd2:	89 fa                	mov    %edi,%edx
f0107cd4:	89 c8                	mov    %ecx,%eax
f0107cd6:	31 ff                	xor    %edi,%edi
f0107cd8:	f7 f6                	div    %esi
f0107cda:	89 c1                	mov    %eax,%ecx
f0107cdc:	89 fa                	mov    %edi,%edx
f0107cde:	89 c8                	mov    %ecx,%eax
f0107ce0:	83 c4 10             	add    $0x10,%esp
f0107ce3:	5e                   	pop    %esi
f0107ce4:	5f                   	pop    %edi
f0107ce5:	5d                   	pop    %ebp
f0107ce6:	c3                   	ret    
f0107ce7:	90                   	nop
f0107ce8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0107cec:	89 f2                	mov    %esi,%edx
f0107cee:	d3 e0                	shl    %cl,%eax
f0107cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0107cf3:	b8 20 00 00 00       	mov    $0x20,%eax
f0107cf8:	2b 45 f4             	sub    -0xc(%ebp),%eax
f0107cfb:	89 c1                	mov    %eax,%ecx
f0107cfd:	d3 ea                	shr    %cl,%edx
f0107cff:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0107d03:	0b 55 ec             	or     -0x14(%ebp),%edx
f0107d06:	d3 e6                	shl    %cl,%esi
f0107d08:	89 c1                	mov    %eax,%ecx
f0107d0a:	89 75 e8             	mov    %esi,-0x18(%ebp)
f0107d0d:	89 fe                	mov    %edi,%esi
f0107d0f:	d3 ee                	shr    %cl,%esi
f0107d11:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0107d15:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0107d18:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0107d1b:	d3 e7                	shl    %cl,%edi
f0107d1d:	89 c1                	mov    %eax,%ecx
f0107d1f:	d3 ea                	shr    %cl,%edx
f0107d21:	09 d7                	or     %edx,%edi
f0107d23:	89 f2                	mov    %esi,%edx
f0107d25:	89 f8                	mov    %edi,%eax
f0107d27:	f7 75 ec             	divl   -0x14(%ebp)
f0107d2a:	89 d6                	mov    %edx,%esi
f0107d2c:	89 c7                	mov    %eax,%edi
f0107d2e:	f7 65 e8             	mull   -0x18(%ebp)
f0107d31:	39 d6                	cmp    %edx,%esi
f0107d33:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0107d36:	72 30                	jb     f0107d68 <__udivdi3+0x118>
f0107d38:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0107d3b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0107d3f:	d3 e2                	shl    %cl,%edx
f0107d41:	39 c2                	cmp    %eax,%edx
f0107d43:	73 05                	jae    f0107d4a <__udivdi3+0xfa>
f0107d45:	3b 75 ec             	cmp    -0x14(%ebp),%esi
f0107d48:	74 1e                	je     f0107d68 <__udivdi3+0x118>
f0107d4a:	89 f9                	mov    %edi,%ecx
f0107d4c:	31 ff                	xor    %edi,%edi
f0107d4e:	e9 71 ff ff ff       	jmp    f0107cc4 <__udivdi3+0x74>
f0107d53:	90                   	nop
f0107d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107d58:	31 ff                	xor    %edi,%edi
f0107d5a:	b9 01 00 00 00       	mov    $0x1,%ecx
f0107d5f:	e9 60 ff ff ff       	jmp    f0107cc4 <__udivdi3+0x74>
f0107d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107d68:	8d 4f ff             	lea    -0x1(%edi),%ecx
f0107d6b:	31 ff                	xor    %edi,%edi
f0107d6d:	89 c8                	mov    %ecx,%eax
f0107d6f:	89 fa                	mov    %edi,%edx
f0107d71:	83 c4 10             	add    $0x10,%esp
f0107d74:	5e                   	pop    %esi
f0107d75:	5f                   	pop    %edi
f0107d76:	5d                   	pop    %ebp
f0107d77:	c3                   	ret    
	...

f0107d80 <__umoddi3>:
f0107d80:	55                   	push   %ebp
f0107d81:	89 e5                	mov    %esp,%ebp
f0107d83:	57                   	push   %edi
f0107d84:	56                   	push   %esi
f0107d85:	83 ec 20             	sub    $0x20,%esp
f0107d88:	8b 55 14             	mov    0x14(%ebp),%edx
f0107d8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0107d8e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0107d91:	8b 75 0c             	mov    0xc(%ebp),%esi
f0107d94:	85 d2                	test   %edx,%edx
f0107d96:	89 c8                	mov    %ecx,%eax
f0107d98:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f0107d9b:	75 13                	jne    f0107db0 <__umoddi3+0x30>
f0107d9d:	39 f7                	cmp    %esi,%edi
f0107d9f:	76 3f                	jbe    f0107de0 <__umoddi3+0x60>
f0107da1:	89 f2                	mov    %esi,%edx
f0107da3:	f7 f7                	div    %edi
f0107da5:	89 d0                	mov    %edx,%eax
f0107da7:	31 d2                	xor    %edx,%edx
f0107da9:	83 c4 20             	add    $0x20,%esp
f0107dac:	5e                   	pop    %esi
f0107dad:	5f                   	pop    %edi
f0107dae:	5d                   	pop    %ebp
f0107daf:	c3                   	ret    
f0107db0:	39 f2                	cmp    %esi,%edx
f0107db2:	77 4c                	ja     f0107e00 <__umoddi3+0x80>
f0107db4:	0f bd ca             	bsr    %edx,%ecx
f0107db7:	83 f1 1f             	xor    $0x1f,%ecx
f0107dba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0107dbd:	75 51                	jne    f0107e10 <__umoddi3+0x90>
f0107dbf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
f0107dc2:	0f 87 e0 00 00 00    	ja     f0107ea8 <__umoddi3+0x128>
f0107dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0107dcb:	29 f8                	sub    %edi,%eax
f0107dcd:	19 d6                	sbb    %edx,%esi
f0107dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0107dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0107dd5:	89 f2                	mov    %esi,%edx
f0107dd7:	83 c4 20             	add    $0x20,%esp
f0107dda:	5e                   	pop    %esi
f0107ddb:	5f                   	pop    %edi
f0107ddc:	5d                   	pop    %ebp
f0107ddd:	c3                   	ret    
f0107dde:	66 90                	xchg   %ax,%ax
f0107de0:	85 ff                	test   %edi,%edi
f0107de2:	75 0b                	jne    f0107def <__umoddi3+0x6f>
f0107de4:	b8 01 00 00 00       	mov    $0x1,%eax
f0107de9:	31 d2                	xor    %edx,%edx
f0107deb:	f7 f7                	div    %edi
f0107ded:	89 c7                	mov    %eax,%edi
f0107def:	89 f0                	mov    %esi,%eax
f0107df1:	31 d2                	xor    %edx,%edx
f0107df3:	f7 f7                	div    %edi
f0107df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0107df8:	f7 f7                	div    %edi
f0107dfa:	eb a9                	jmp    f0107da5 <__umoddi3+0x25>
f0107dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107e00:	89 c8                	mov    %ecx,%eax
f0107e02:	89 f2                	mov    %esi,%edx
f0107e04:	83 c4 20             	add    $0x20,%esp
f0107e07:	5e                   	pop    %esi
f0107e08:	5f                   	pop    %edi
f0107e09:	5d                   	pop    %ebp
f0107e0a:	c3                   	ret    
f0107e0b:	90                   	nop
f0107e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107e10:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0107e14:	d3 e2                	shl    %cl,%edx
f0107e16:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0107e19:	ba 20 00 00 00       	mov    $0x20,%edx
f0107e1e:	2b 55 f0             	sub    -0x10(%ebp),%edx
f0107e21:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0107e24:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0107e28:	89 fa                	mov    %edi,%edx
f0107e2a:	d3 ea                	shr    %cl,%edx
f0107e2c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0107e30:	0b 55 f4             	or     -0xc(%ebp),%edx
f0107e33:	d3 e7                	shl    %cl,%edi
f0107e35:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0107e39:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0107e3c:	89 f2                	mov    %esi,%edx
f0107e3e:	89 7d e8             	mov    %edi,-0x18(%ebp)
f0107e41:	89 c7                	mov    %eax,%edi
f0107e43:	d3 ea                	shr    %cl,%edx
f0107e45:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0107e49:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0107e4c:	89 c2                	mov    %eax,%edx
f0107e4e:	d3 e6                	shl    %cl,%esi
f0107e50:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0107e54:	d3 ea                	shr    %cl,%edx
f0107e56:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0107e5a:	09 d6                	or     %edx,%esi
f0107e5c:	89 f0                	mov    %esi,%eax
f0107e5e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0107e61:	d3 e7                	shl    %cl,%edi
f0107e63:	89 f2                	mov    %esi,%edx
f0107e65:	f7 75 f4             	divl   -0xc(%ebp)
f0107e68:	89 d6                	mov    %edx,%esi
f0107e6a:	f7 65 e8             	mull   -0x18(%ebp)
f0107e6d:	39 d6                	cmp    %edx,%esi
f0107e6f:	72 2b                	jb     f0107e9c <__umoddi3+0x11c>
f0107e71:	39 c7                	cmp    %eax,%edi
f0107e73:	72 23                	jb     f0107e98 <__umoddi3+0x118>
f0107e75:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0107e79:	29 c7                	sub    %eax,%edi
f0107e7b:	19 d6                	sbb    %edx,%esi
f0107e7d:	89 f0                	mov    %esi,%eax
f0107e7f:	89 f2                	mov    %esi,%edx
f0107e81:	d3 ef                	shr    %cl,%edi
f0107e83:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0107e87:	d3 e0                	shl    %cl,%eax
f0107e89:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0107e8d:	09 f8                	or     %edi,%eax
f0107e8f:	d3 ea                	shr    %cl,%edx
f0107e91:	83 c4 20             	add    $0x20,%esp
f0107e94:	5e                   	pop    %esi
f0107e95:	5f                   	pop    %edi
f0107e96:	5d                   	pop    %ebp
f0107e97:	c3                   	ret    
f0107e98:	39 d6                	cmp    %edx,%esi
f0107e9a:	75 d9                	jne    f0107e75 <__umoddi3+0xf5>
f0107e9c:	2b 45 e8             	sub    -0x18(%ebp),%eax
f0107e9f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
f0107ea2:	eb d1                	jmp    f0107e75 <__umoddi3+0xf5>
f0107ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107ea8:	39 f2                	cmp    %esi,%edx
f0107eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107eb0:	0f 82 12 ff ff ff    	jb     f0107dc8 <__umoddi3+0x48>
f0107eb6:	e9 17 ff ff ff       	jmp    f0107dd2 <__umoddi3+0x52>
