
obj/user/dumbfork.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 1b 02 00 00       	call   80024c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 20             	sub    $0x20,%esp
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
  80003f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  800042:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800049:	00 
  80004a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004e:	89 34 24             	mov    %esi,(%esp)
  800051:	e8 b8 10 00 00       	call   80110e <sys_page_alloc>
  800056:	85 c0                	test   %eax,%eax
  800058:	79 20                	jns    80007a <duppage+0x46>
		panic("sys_page_alloc: %e", r);
  80005a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005e:	c7 44 24 08 c0 14 80 	movl   $0x8014c0,0x8(%esp)
  800065:	00 
  800066:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  80006d:	00 
  80006e:	c7 04 24 d3 14 80 00 	movl   $0x8014d3,(%esp)
  800075:	e8 36 02 00 00       	call   8002b0 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80007a:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  800081:	00 
  800082:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  800089:	00 
  80008a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800091:	00 
  800092:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800096:	89 34 24             	mov    %esi,(%esp)
  800099:	e8 12 10 00 00       	call   8010b0 <sys_page_map>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	79 20                	jns    8000c2 <duppage+0x8e>
		panic("sys_page_map: %e", r);
  8000a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a6:	c7 44 24 08 e3 14 80 	movl   $0x8014e3,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 d3 14 80 00 	movl   $0x8014d3,(%esp)
  8000bd:	e8 ee 01 00 00       	call   8002b0 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8000c2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8000c9:	00 
  8000ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000ce:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8000d5:	e8 95 0a 00 00       	call   800b6f <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8000da:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8000e1:	00 
  8000e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000e9:	e8 64 0f 00 00       	call   801052 <sys_page_unmap>
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	79 20                	jns    800112 <duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8000f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f6:	c7 44 24 08 f4 14 80 	movl   $0x8014f4,0x8(%esp)
  8000fd:	00 
  8000fe:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  800105:	00 
  800106:	c7 04 24 d3 14 80 00 	movl   $0x8014d3,(%esp)
  80010d:	e8 9e 01 00 00       	call   8002b0 <_panic>
}
  800112:	83 c4 20             	add    $0x20,%esp
  800115:	5b                   	pop    %ebx
  800116:	5e                   	pop    %esi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <dumbfork>:

envid_t
dumbfork(void)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	53                   	push   %ebx
  80011d:	83 ec 24             	sub    $0x24,%esp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  800120:	bb 07 00 00 00       	mov    $0x7,%ebx
  800125:	89 d8                	mov    %ebx,%eax
  800127:	cd 30                	int    $0x30
  800129:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  80012b:	85 c0                	test   %eax,%eax
  80012d:	79 20                	jns    80014f <dumbfork+0x36>
		panic("sys_exofork: %e", envid);
  80012f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800133:	c7 44 24 08 07 15 80 	movl   $0x801507,0x8(%esp)
  80013a:	00 
  80013b:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  800142:	00 
  800143:	c7 04 24 d3 14 80 00 	movl   $0x8014d3,(%esp)
  80014a:	e8 61 01 00 00       	call   8002b0 <_panic>
	if (envid == 0) {
  80014f:	85 c0                	test   %eax,%eax
  800151:	75 19                	jne    80016c <dumbfork+0x53>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800153:	e8 49 10 00 00       	call   8011a1 <sys_getenvid>
  800158:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  80016a:	eb 6e                	jmp    8001da <dumbfork+0xc1>
	}
	
	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80016c:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800173:	eb 13                	jmp    800188 <dumbfork+0x6f>
		duppage(envid, addr);
  800175:	89 44 24 04          	mov    %eax,0x4(%esp)
  800179:	89 1c 24             	mov    %ebx,(%esp)
  80017c:	e8 b3 fe ff ff       	call   800034 <duppage>
	}
	
	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800181:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80018b:	3d 08 20 80 00       	cmp    $0x802008,%eax
  800190:	72 e3                	jb     800175 <dumbfork+0x5c>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800192:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800195:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	89 1c 24             	mov    %ebx,(%esp)
  8001a1:	e8 8e fe ff ff       	call   800034 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8001a6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8001ad:	00 
  8001ae:	89 1c 24             	mov    %ebx,(%esp)
  8001b1:	e8 3e 0e 00 00       	call   800ff4 <sys_env_set_status>
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	79 20                	jns    8001da <dumbfork+0xc1>
		panic("sys_env_set_status: %e", r);
  8001ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001be:	c7 44 24 08 17 15 80 	movl   $0x801517,0x8(%esp)
  8001c5:	00 
  8001c6:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8001cd:	00 
  8001ce:	c7 04 24 d3 14 80 00 	movl   $0x8014d3,(%esp)
  8001d5:	e8 d6 00 00 00       	call   8002b0 <_panic>

	return envid;
}
  8001da:	89 d8                	mov    %ebx,%eax
  8001dc:	83 c4 24             	add    $0x24,%esp
  8001df:	5b                   	pop    %ebx
  8001e0:	5d                   	pop    %ebp
  8001e1:	c3                   	ret    

008001e2 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	57                   	push   %edi
  8001e6:	56                   	push   %esi
  8001e7:	53                   	push   %ebx
  8001e8:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  8001eb:	e8 29 ff ff ff       	call   800119 <dumbfork>
  8001f0:	89 c6                	mov    %eax,%esi
	cprintf("%d print\n",who);
  8001f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f6:	c7 04 24 2e 15 80 00 	movl   $0x80152e,(%esp)
  8001fd:	e8 67 01 00 00       	call   800369 <cprintf>
  800202:	bb 00 00 00 00       	mov    $0x0,%ebx

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  800207:	bf 3e 15 80 00       	mov    $0x80153e,%edi
	// fork a child process
	who = dumbfork();
	cprintf("%d print\n",who);

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  80020c:	eb 26                	jmp    800234 <umain+0x52>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80020e:	85 f6                	test   %esi,%esi
  800210:	b8 38 15 80 00       	mov    $0x801538,%eax
  800215:	0f 45 c7             	cmovne %edi,%eax
  800218:	89 44 24 08          	mov    %eax,0x8(%esp)
  80021c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800220:	c7 04 24 45 15 80 00 	movl   $0x801545,(%esp)
  800227:	e8 3d 01 00 00       	call   800369 <cprintf>
		sys_yield();
  80022c:	e8 3c 0f 00 00       	call   80116d <sys_yield>
	// fork a child process
	who = dumbfork();
	cprintf("%d print\n",who);

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800231:	83 c3 01             	add    $0x1,%ebx
  800234:	83 fe 01             	cmp    $0x1,%esi
  800237:	19 c0                	sbb    %eax,%eax
  800239:	83 e0 0a             	and    $0xa,%eax
  80023c:	83 c0 0a             	add    $0xa,%eax
  80023f:	39 c3                	cmp    %eax,%ebx
  800241:	7c cb                	jl     80020e <umain+0x2c>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  800243:	83 c4 1c             	add    $0x1c,%esp
  800246:	5b                   	pop    %ebx
  800247:	5e                   	pop    %esi
  800248:	5f                   	pop    %edi
  800249:	5d                   	pop    %ebp
  80024a:	c3                   	ret    
	...

0080024c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	83 ec 18             	sub    $0x18,%esp
  800252:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800255:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800258:	8b 75 08             	mov    0x8(%ebp),%esi
  80025b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80025e:	e8 3e 0f 00 00       	call   8011a1 <sys_getenvid>
  800263:	25 ff 03 00 00       	and    $0x3ff,%eax
  800268:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80026b:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800270:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800275:	85 f6                	test   %esi,%esi
  800277:	7e 07                	jle    800280 <libmain+0x34>
		binaryname = argv[0];
  800279:	8b 03                	mov    (%ebx),%eax
  80027b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800280:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800284:	89 34 24             	mov    %esi,(%esp)
  800287:	e8 56 ff ff ff       	call   8001e2 <umain>

	// exit gracefully
	exit();
  80028c:	e8 0b 00 00 00       	call   80029c <exit>
}
  800291:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800294:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800297:	89 ec                	mov    %ebp,%esp
  800299:	5d                   	pop    %ebp
  80029a:	c3                   	ret    
	...

0080029c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8002a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a9:	e8 27 0f 00 00       	call   8011d5 <sys_env_destroy>
}
  8002ae:	c9                   	leave  
  8002af:	c3                   	ret    

008002b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	56                   	push   %esi
  8002b4:	53                   	push   %ebx
  8002b5:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8002b8:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002bb:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8002c1:	e8 db 0e 00 00       	call   8011a1 <sys_getenvid>
  8002c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002dc:	c7 04 24 64 15 80 00 	movl   $0x801564,(%esp)
  8002e3:	e8 81 00 00 00       	call   800369 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ef:	89 04 24             	mov    %eax,(%esp)
  8002f2:	e8 11 00 00 00       	call   800308 <vcprintf>
	cprintf("\n");
  8002f7:	c7 04 24 55 15 80 00 	movl   $0x801555,(%esp)
  8002fe:	e8 66 00 00 00       	call   800369 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800303:	cc                   	int3   
  800304:	eb fd                	jmp    800303 <_panic+0x53>
	...

00800308 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800311:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800318:	00 00 00 
	b.cnt = 0;
  80031b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800322:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800325:	8b 45 0c             	mov    0xc(%ebp),%eax
  800328:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80032c:	8b 45 08             	mov    0x8(%ebp),%eax
  80032f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800339:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033d:	c7 04 24 83 03 80 00 	movl   $0x800383,(%esp)
  800344:	e8 be 01 00 00       	call   800507 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800349:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800359:	89 04 24             	mov    %eax,(%esp)
  80035c:	e8 1f 0a 00 00       	call   800d80 <sys_cputs>

	return b.cnt;
}
  800361:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800367:	c9                   	leave  
  800368:	c3                   	ret    

00800369 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80036f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800372:	89 44 24 04          	mov    %eax,0x4(%esp)
  800376:	8b 45 08             	mov    0x8(%ebp),%eax
  800379:	89 04 24             	mov    %eax,(%esp)
  80037c:	e8 87 ff ff ff       	call   800308 <vcprintf>
	va_end(ap);

	return cnt;
}
  800381:	c9                   	leave  
  800382:	c3                   	ret    

00800383 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	53                   	push   %ebx
  800387:	83 ec 14             	sub    $0x14,%esp
  80038a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80038d:	8b 03                	mov    (%ebx),%eax
  80038f:	8b 55 08             	mov    0x8(%ebp),%edx
  800392:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800396:	83 c0 01             	add    $0x1,%eax
  800399:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80039b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a0:	75 19                	jne    8003bb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003a2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003a9:	00 
  8003aa:	8d 43 08             	lea    0x8(%ebx),%eax
  8003ad:	89 04 24             	mov    %eax,(%esp)
  8003b0:	e8 cb 09 00 00       	call   800d80 <sys_cputs>
		b->idx = 0;
  8003b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003bb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003bf:	83 c4 14             	add    $0x14,%esp
  8003c2:	5b                   	pop    %ebx
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    
  8003c5:	00 00                	add    %al,(%eax)
	...

008003c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	57                   	push   %edi
  8003cc:	56                   	push   %esi
  8003cd:	53                   	push   %ebx
  8003ce:	83 ec 4c             	sub    $0x4c,%esp
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d4:	89 d6                	mov    %edx,%esi
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003df:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8003e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003e8:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f3:	39 d1                	cmp    %edx,%ecx
  8003f5:	72 07                	jb     8003fe <printnum+0x36>
  8003f7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003fa:	39 d0                	cmp    %edx,%eax
  8003fc:	77 69                	ja     800467 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003fe:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800402:	83 eb 01             	sub    $0x1,%ebx
  800405:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800409:	89 44 24 08          	mov    %eax,0x8(%esp)
  80040d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800411:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800415:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800418:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80041b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80041e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800422:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800429:	00 
  80042a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042d:	89 04 24             	mov    %eax,(%esp)
  800430:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800433:	89 54 24 04          	mov    %edx,0x4(%esp)
  800437:	e8 04 0e 00 00       	call   801240 <__udivdi3>
  80043c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80043f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800442:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800446:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80044a:	89 04 24             	mov    %eax,(%esp)
  80044d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800451:	89 f2                	mov    %esi,%edx
  800453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800456:	e8 6d ff ff ff       	call   8003c8 <printnum>
  80045b:	eb 11                	jmp    80046e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80045d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800461:	89 3c 24             	mov    %edi,(%esp)
  800464:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800467:	83 eb 01             	sub    $0x1,%ebx
  80046a:	85 db                	test   %ebx,%ebx
  80046c:	7f ef                	jg     80045d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80046e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800472:	8b 74 24 04          	mov    0x4(%esp),%esi
  800476:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800479:	89 44 24 08          	mov    %eax,0x8(%esp)
  80047d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800484:	00 
  800485:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800488:	89 14 24             	mov    %edx,(%esp)
  80048b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800492:	e8 d9 0e 00 00       	call   801370 <__umoddi3>
  800497:	89 74 24 04          	mov    %esi,0x4(%esp)
  80049b:	0f be 80 87 15 80 00 	movsbl 0x801587(%eax),%eax
  8004a2:	89 04 24             	mov    %eax,(%esp)
  8004a5:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8004a8:	83 c4 4c             	add    $0x4c,%esp
  8004ab:	5b                   	pop    %ebx
  8004ac:	5e                   	pop    %esi
  8004ad:	5f                   	pop    %edi
  8004ae:	5d                   	pop    %ebp
  8004af:	c3                   	ret    

008004b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b3:	83 fa 01             	cmp    $0x1,%edx
  8004b6:	7e 0e                	jle    8004c6 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004b8:	8b 10                	mov    (%eax),%edx
  8004ba:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004bd:	89 08                	mov    %ecx,(%eax)
  8004bf:	8b 02                	mov    (%edx),%eax
  8004c1:	8b 52 04             	mov    0x4(%edx),%edx
  8004c4:	eb 22                	jmp    8004e8 <getuint+0x38>
	else if (lflag)
  8004c6:	85 d2                	test   %edx,%edx
  8004c8:	74 10                	je     8004da <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004ca:	8b 10                	mov    (%eax),%edx
  8004cc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004cf:	89 08                	mov    %ecx,(%eax)
  8004d1:	8b 02                	mov    (%edx),%eax
  8004d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d8:	eb 0e                	jmp    8004e8 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004da:	8b 10                	mov    (%eax),%edx
  8004dc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004df:	89 08                	mov    %ecx,(%eax)
  8004e1:	8b 02                	mov    (%edx),%eax
  8004e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004e8:	5d                   	pop    %ebp
  8004e9:	c3                   	ret    

008004ea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f4:	8b 10                	mov    (%eax),%edx
  8004f6:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f9:	73 0a                	jae    800505 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004fe:	88 0a                	mov    %cl,(%edx)
  800500:	83 c2 01             	add    $0x1,%edx
  800503:	89 10                	mov    %edx,(%eax)
}
  800505:	5d                   	pop    %ebp
  800506:	c3                   	ret    

00800507 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	57                   	push   %edi
  80050b:	56                   	push   %esi
  80050c:	53                   	push   %ebx
  80050d:	83 ec 4c             	sub    $0x4c,%esp
  800510:	8b 7d 08             	mov    0x8(%ebp),%edi
  800513:	8b 75 0c             	mov    0xc(%ebp),%esi
  800516:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800519:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800520:	eb 11                	jmp    800533 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800522:	85 c0                	test   %eax,%eax
  800524:	0f 84 b6 03 00 00    	je     8008e0 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80052a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800533:	0f b6 03             	movzbl (%ebx),%eax
  800536:	83 c3 01             	add    $0x1,%ebx
  800539:	83 f8 25             	cmp    $0x25,%eax
  80053c:	75 e4                	jne    800522 <vprintfmt+0x1b>
  80053e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800542:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800549:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800550:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800557:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80055f:	eb 06                	jmp    800567 <vprintfmt+0x60>
  800561:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800565:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800567:	0f b6 0b             	movzbl (%ebx),%ecx
  80056a:	0f b6 c1             	movzbl %cl,%eax
  80056d:	8d 53 01             	lea    0x1(%ebx),%edx
  800570:	83 e9 23             	sub    $0x23,%ecx
  800573:	80 f9 55             	cmp    $0x55,%cl
  800576:	0f 87 47 03 00 00    	ja     8008c3 <vprintfmt+0x3bc>
  80057c:	0f b6 c9             	movzbl %cl,%ecx
  80057f:	ff 24 8d c0 16 80 00 	jmp    *0x8016c0(,%ecx,4)
  800586:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80058a:	eb d9                	jmp    800565 <vprintfmt+0x5e>
  80058c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800593:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800598:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80059b:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80059f:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8005a2:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005a5:	83 fb 09             	cmp    $0x9,%ebx
  8005a8:	77 30                	ja     8005da <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005aa:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005ad:	eb e9                	jmp    800598 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 48 04             	lea    0x4(%eax),%ecx
  8005b5:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8005bd:	eb 1e                	jmp    8005dd <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8005bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c8:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8005cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005cf:	eb 94                	jmp    800565 <vprintfmt+0x5e>
  8005d1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8005d8:	eb 8b                	jmp    800565 <vprintfmt+0x5e>
  8005da:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8005dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e1:	79 82                	jns    800565 <vprintfmt+0x5e>
  8005e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005ec:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8005ef:	e9 71 ff ff ff       	jmp    800565 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005f4:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005f8:	e9 68 ff ff ff       	jmp    800565 <vprintfmt+0x5e>
  8005fd:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 50 04             	lea    0x4(%eax),%edx
  800606:	89 55 14             	mov    %edx,0x14(%ebp)
  800609:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	89 04 24             	mov    %eax,(%esp)
  800612:	ff d7                	call   *%edi
  800614:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800617:	e9 17 ff ff ff       	jmp    800533 <vprintfmt+0x2c>
  80061c:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 50 04             	lea    0x4(%eax),%edx
  800625:	89 55 14             	mov    %edx,0x14(%ebp)
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	89 c2                	mov    %eax,%edx
  80062c:	c1 fa 1f             	sar    $0x1f,%edx
  80062f:	31 d0                	xor    %edx,%eax
  800631:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800633:	83 f8 11             	cmp    $0x11,%eax
  800636:	7f 0b                	jg     800643 <vprintfmt+0x13c>
  800638:	8b 14 85 20 18 80 00 	mov    0x801820(,%eax,4),%edx
  80063f:	85 d2                	test   %edx,%edx
  800641:	75 20                	jne    800663 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800643:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800647:	c7 44 24 08 98 15 80 	movl   $0x801598,0x8(%esp)
  80064e:	00 
  80064f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800653:	89 3c 24             	mov    %edi,(%esp)
  800656:	e8 0d 03 00 00       	call   800968 <printfmt>
  80065b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80065e:	e9 d0 fe ff ff       	jmp    800533 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800663:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800667:	c7 44 24 08 a1 15 80 	movl   $0x8015a1,0x8(%esp)
  80066e:	00 
  80066f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800673:	89 3c 24             	mov    %edi,(%esp)
  800676:	e8 ed 02 00 00       	call   800968 <printfmt>
  80067b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80067e:	e9 b0 fe ff ff       	jmp    800533 <vprintfmt+0x2c>
  800683:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800686:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8d 50 04             	lea    0x4(%eax),%edx
  800695:	89 55 14             	mov    %edx,0x14(%ebp)
  800698:	8b 18                	mov    (%eax),%ebx
  80069a:	85 db                	test   %ebx,%ebx
  80069c:	b8 a4 15 80 00       	mov    $0x8015a4,%eax
  8006a1:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8006a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006a8:	7e 76                	jle    800720 <vprintfmt+0x219>
  8006aa:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8006ae:	74 7a                	je     80072a <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006b4:	89 1c 24             	mov    %ebx,(%esp)
  8006b7:	e8 ec 02 00 00       	call   8009a8 <strnlen>
  8006bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006bf:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8006c1:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8006c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8006cb:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cd:	eb 0f                	jmp    8006de <vprintfmt+0x1d7>
					putch(padc, putdat);
  8006cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d6:	89 04 24             	mov    %eax,(%esp)
  8006d9:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006db:	83 eb 01             	sub    $0x1,%ebx
  8006de:	85 db                	test   %ebx,%ebx
  8006e0:	7f ed                	jg     8006cf <vprintfmt+0x1c8>
  8006e2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8006e5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006e8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006eb:	89 f7                	mov    %esi,%edi
  8006ed:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006f0:	eb 40                	jmp    800732 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006f6:	74 18                	je     800710 <vprintfmt+0x209>
  8006f8:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006fb:	83 fa 5e             	cmp    $0x5e,%edx
  8006fe:	76 10                	jbe    800710 <vprintfmt+0x209>
					putch('?', putdat);
  800700:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800704:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80070b:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80070e:	eb 0a                	jmp    80071a <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800710:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800714:	89 04 24             	mov    %eax,(%esp)
  800717:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80071e:	eb 12                	jmp    800732 <vprintfmt+0x22b>
  800720:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800723:	89 f7                	mov    %esi,%edi
  800725:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800728:	eb 08                	jmp    800732 <vprintfmt+0x22b>
  80072a:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80072d:	89 f7                	mov    %esi,%edi
  80072f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800732:	0f be 03             	movsbl (%ebx),%eax
  800735:	83 c3 01             	add    $0x1,%ebx
  800738:	85 c0                	test   %eax,%eax
  80073a:	74 25                	je     800761 <vprintfmt+0x25a>
  80073c:	85 f6                	test   %esi,%esi
  80073e:	78 b2                	js     8006f2 <vprintfmt+0x1eb>
  800740:	83 ee 01             	sub    $0x1,%esi
  800743:	79 ad                	jns    8006f2 <vprintfmt+0x1eb>
  800745:	89 fe                	mov    %edi,%esi
  800747:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80074a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80074d:	eb 1a                	jmp    800769 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80074f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800753:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80075a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80075c:	83 eb 01             	sub    $0x1,%ebx
  80075f:	eb 08                	jmp    800769 <vprintfmt+0x262>
  800761:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800764:	89 fe                	mov    %edi,%esi
  800766:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800769:	85 db                	test   %ebx,%ebx
  80076b:	7f e2                	jg     80074f <vprintfmt+0x248>
  80076d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800770:	e9 be fd ff ff       	jmp    800533 <vprintfmt+0x2c>
  800775:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800778:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80077b:	83 f9 01             	cmp    $0x1,%ecx
  80077e:	7e 16                	jle    800796 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 50 08             	lea    0x8(%eax),%edx
  800786:	89 55 14             	mov    %edx,0x14(%ebp)
  800789:	8b 10                	mov    (%eax),%edx
  80078b:	8b 48 04             	mov    0x4(%eax),%ecx
  80078e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800791:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800794:	eb 32                	jmp    8007c8 <vprintfmt+0x2c1>
	else if (lflag)
  800796:	85 c9                	test   %ecx,%ecx
  800798:	74 18                	je     8007b2 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8d 50 04             	lea    0x4(%eax),%edx
  8007a0:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	89 c1                	mov    %eax,%ecx
  8007aa:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ad:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007b0:	eb 16                	jmp    8007c8 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8d 50 04             	lea    0x4(%eax),%edx
  8007b8:	89 55 14             	mov    %edx,0x14(%ebp)
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	c1 fa 1f             	sar    $0x1f,%edx
  8007c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007c8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007cb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007ce:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007d7:	0f 89 a7 00 00 00    	jns    800884 <vprintfmt+0x37d>
				putch('-', putdat);
  8007dd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007e8:	ff d7                	call   *%edi
				num = -(long long) num;
  8007ea:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007ed:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007f0:	f7 d9                	neg    %ecx
  8007f2:	83 d3 00             	adc    $0x0,%ebx
  8007f5:	f7 db                	neg    %ebx
  8007f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fc:	e9 83 00 00 00       	jmp    800884 <vprintfmt+0x37d>
  800801:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800804:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800807:	89 ca                	mov    %ecx,%edx
  800809:	8d 45 14             	lea    0x14(%ebp),%eax
  80080c:	e8 9f fc ff ff       	call   8004b0 <getuint>
  800811:	89 c1                	mov    %eax,%ecx
  800813:	89 d3                	mov    %edx,%ebx
  800815:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80081a:	eb 68                	jmp    800884 <vprintfmt+0x37d>
  80081c:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80081f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800822:	89 ca                	mov    %ecx,%edx
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
  800827:	e8 84 fc ff ff       	call   8004b0 <getuint>
  80082c:	89 c1                	mov    %eax,%ecx
  80082e:	89 d3                	mov    %edx,%ebx
  800830:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800835:	eb 4d                	jmp    800884 <vprintfmt+0x37d>
  800837:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80083a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80083e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800845:	ff d7                	call   *%edi
			putch('x', putdat);
  800847:	89 74 24 04          	mov    %esi,0x4(%esp)
  80084b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800852:	ff d7                	call   *%edi
			num = (unsigned long long)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8d 50 04             	lea    0x4(%eax),%edx
  80085a:	89 55 14             	mov    %edx,0x14(%ebp)
  80085d:	8b 08                	mov    (%eax),%ecx
  80085f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800864:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800869:	eb 19                	jmp    800884 <vprintfmt+0x37d>
  80086b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80086e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800871:	89 ca                	mov    %ecx,%edx
  800873:	8d 45 14             	lea    0x14(%ebp),%eax
  800876:	e8 35 fc ff ff       	call   8004b0 <getuint>
  80087b:	89 c1                	mov    %eax,%ecx
  80087d:	89 d3                	mov    %edx,%ebx
  80087f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800884:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800888:	89 54 24 10          	mov    %edx,0x10(%esp)
  80088c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80088f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800893:	89 44 24 08          	mov    %eax,0x8(%esp)
  800897:	89 0c 24             	mov    %ecx,(%esp)
  80089a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80089e:	89 f2                	mov    %esi,%edx
  8008a0:	89 f8                	mov    %edi,%eax
  8008a2:	e8 21 fb ff ff       	call   8003c8 <printnum>
  8008a7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8008aa:	e9 84 fc ff ff       	jmp    800533 <vprintfmt+0x2c>
  8008af:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008b6:	89 04 24             	mov    %eax,(%esp)
  8008b9:	ff d7                	call   *%edi
  8008bb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8008be:	e9 70 fc ff ff       	jmp    800533 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008c7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008ce:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8008d3:	80 38 25             	cmpb   $0x25,(%eax)
  8008d6:	0f 84 57 fc ff ff    	je     800533 <vprintfmt+0x2c>
  8008dc:	89 c3                	mov    %eax,%ebx
  8008de:	eb f0                	jmp    8008d0 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8008e0:	83 c4 4c             	add    $0x4c,%esp
  8008e3:	5b                   	pop    %ebx
  8008e4:	5e                   	pop    %esi
  8008e5:	5f                   	pop    %edi
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 28             	sub    $0x28,%esp
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008f4:	85 c0                	test   %eax,%eax
  8008f6:	74 04                	je     8008fc <vsnprintf+0x14>
  8008f8:	85 d2                	test   %edx,%edx
  8008fa:	7f 07                	jg     800903 <vsnprintf+0x1b>
  8008fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800901:	eb 3b                	jmp    80093e <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800903:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800906:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  80090a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80091b:	8b 45 10             	mov    0x10(%ebp),%eax
  80091e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800922:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800925:	89 44 24 04          	mov    %eax,0x4(%esp)
  800929:	c7 04 24 ea 04 80 00 	movl   $0x8004ea,(%esp)
  800930:	e8 d2 fb ff ff       	call   800507 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800935:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800938:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80093b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80093e:	c9                   	leave  
  80093f:	c3                   	ret    

00800940 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800946:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800949:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80094d:	8b 45 10             	mov    0x10(%ebp),%eax
  800950:	89 44 24 08          	mov    %eax,0x8(%esp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 04 24             	mov    %eax,(%esp)
  800961:	e8 82 ff ff ff       	call   8008e8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80096e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800971:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800975:	8b 45 10             	mov    0x10(%ebp),%eax
  800978:	89 44 24 08          	mov    %eax,0x8(%esp)
  80097c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	89 04 24             	mov    %eax,(%esp)
  800989:	e8 79 fb ff ff       	call   800507 <vprintfmt>
	va_end(ap);
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 55 08             	mov    0x8(%ebp),%edx
  800996:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80099b:	eb 03                	jmp    8009a0 <strlen+0x10>
		n++;
  80099d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009a4:	75 f7                	jne    80099d <strlen+0xd>
		n++;
	return n;
}
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	53                   	push   %ebx
  8009ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b7:	eb 03                	jmp    8009bc <strnlen+0x14>
		n++;
  8009b9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009bc:	39 c1                	cmp    %eax,%ecx
  8009be:	74 06                	je     8009c6 <strnlen+0x1e>
  8009c0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8009c4:	75 f3                	jne    8009b9 <strnlen+0x11>
		n++;
	return n;
}
  8009c6:	5b                   	pop    %ebx
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	53                   	push   %ebx
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009d3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009d8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009df:	83 c2 01             	add    $0x1,%edx
  8009e2:	84 c9                	test   %cl,%cl
  8009e4:	75 f2                	jne    8009d8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009e6:	5b                   	pop    %ebx
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	53                   	push   %ebx
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009f3:	89 1c 24             	mov    %ebx,(%esp)
  8009f6:	e8 95 ff ff ff       	call   800990 <strlen>
	strcpy(dst + len, src);
  8009fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a02:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800a05:	89 04 24             	mov    %eax,(%esp)
  800a08:	e8 bc ff ff ff       	call   8009c9 <strcpy>
	return dst;
}
  800a0d:	89 d8                	mov    %ebx,%eax
  800a0f:	83 c4 08             	add    $0x8,%esp
  800a12:	5b                   	pop    %ebx
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a20:	8b 75 10             	mov    0x10(%ebp),%esi
  800a23:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a28:	eb 0f                	jmp    800a39 <strncpy+0x24>
		*dst++ = *src;
  800a2a:	0f b6 19             	movzbl (%ecx),%ebx
  800a2d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a30:	80 39 01             	cmpb   $0x1,(%ecx)
  800a33:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a36:	83 c2 01             	add    $0x1,%edx
  800a39:	39 f2                	cmp    %esi,%edx
  800a3b:	72 ed                	jb     800a2a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a3d:	5b                   	pop    %ebx
  800a3e:	5e                   	pop    %esi
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	56                   	push   %esi
  800a45:	53                   	push   %ebx
  800a46:	8b 75 08             	mov    0x8(%ebp),%esi
  800a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a4f:	89 f0                	mov    %esi,%eax
  800a51:	85 d2                	test   %edx,%edx
  800a53:	75 0a                	jne    800a5f <strlcpy+0x1e>
  800a55:	eb 17                	jmp    800a6e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a57:	88 18                	mov    %bl,(%eax)
  800a59:	83 c0 01             	add    $0x1,%eax
  800a5c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a5f:	83 ea 01             	sub    $0x1,%edx
  800a62:	74 07                	je     800a6b <strlcpy+0x2a>
  800a64:	0f b6 19             	movzbl (%ecx),%ebx
  800a67:	84 db                	test   %bl,%bl
  800a69:	75 ec                	jne    800a57 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800a6b:	c6 00 00             	movb   $0x0,(%eax)
  800a6e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a70:	5b                   	pop    %ebx
  800a71:	5e                   	pop    %esi
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a7d:	eb 06                	jmp    800a85 <strcmp+0x11>
		p++, q++;
  800a7f:	83 c1 01             	add    $0x1,%ecx
  800a82:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a85:	0f b6 01             	movzbl (%ecx),%eax
  800a88:	84 c0                	test   %al,%al
  800a8a:	74 04                	je     800a90 <strcmp+0x1c>
  800a8c:	3a 02                	cmp    (%edx),%al
  800a8e:	74 ef                	je     800a7f <strcmp+0xb>
  800a90:	0f b6 c0             	movzbl %al,%eax
  800a93:	0f b6 12             	movzbl (%edx),%edx
  800a96:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	53                   	push   %ebx
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800aa7:	eb 09                	jmp    800ab2 <strncmp+0x18>
		n--, p++, q++;
  800aa9:	83 ea 01             	sub    $0x1,%edx
  800aac:	83 c0 01             	add    $0x1,%eax
  800aaf:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ab2:	85 d2                	test   %edx,%edx
  800ab4:	75 07                	jne    800abd <strncmp+0x23>
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	eb 13                	jmp    800ad0 <strncmp+0x36>
  800abd:	0f b6 18             	movzbl (%eax),%ebx
  800ac0:	84 db                	test   %bl,%bl
  800ac2:	74 04                	je     800ac8 <strncmp+0x2e>
  800ac4:	3a 19                	cmp    (%ecx),%bl
  800ac6:	74 e1                	je     800aa9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac8:	0f b6 00             	movzbl (%eax),%eax
  800acb:	0f b6 11             	movzbl (%ecx),%edx
  800ace:	29 d0                	sub    %edx,%eax
}
  800ad0:	5b                   	pop    %ebx
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800add:	eb 07                	jmp    800ae6 <strchr+0x13>
		if (*s == c)
  800adf:	38 ca                	cmp    %cl,%dl
  800ae1:	74 0f                	je     800af2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ae3:	83 c0 01             	add    $0x1,%eax
  800ae6:	0f b6 10             	movzbl (%eax),%edx
  800ae9:	84 d2                	test   %dl,%dl
  800aeb:	75 f2                	jne    800adf <strchr+0xc>
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800afe:	eb 07                	jmp    800b07 <strfind+0x13>
		if (*s == c)
  800b00:	38 ca                	cmp    %cl,%dl
  800b02:	74 0a                	je     800b0e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b04:	83 c0 01             	add    $0x1,%eax
  800b07:	0f b6 10             	movzbl (%eax),%edx
  800b0a:	84 d2                	test   %dl,%dl
  800b0c:	75 f2                	jne    800b00 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 0c             	sub    $0xc,%esp
  800b16:	89 1c 24             	mov    %ebx,(%esp)
  800b19:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b1d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b21:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b2a:	85 c9                	test   %ecx,%ecx
  800b2c:	74 30                	je     800b5e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b2e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b34:	75 25                	jne    800b5b <memset+0x4b>
  800b36:	f6 c1 03             	test   $0x3,%cl
  800b39:	75 20                	jne    800b5b <memset+0x4b>
		c &= 0xFF;
  800b3b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b3e:	89 d3                	mov    %edx,%ebx
  800b40:	c1 e3 08             	shl    $0x8,%ebx
  800b43:	89 d6                	mov    %edx,%esi
  800b45:	c1 e6 18             	shl    $0x18,%esi
  800b48:	89 d0                	mov    %edx,%eax
  800b4a:	c1 e0 10             	shl    $0x10,%eax
  800b4d:	09 f0                	or     %esi,%eax
  800b4f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b51:	09 d8                	or     %ebx,%eax
  800b53:	c1 e9 02             	shr    $0x2,%ecx
  800b56:	fc                   	cld    
  800b57:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b59:	eb 03                	jmp    800b5e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b5b:	fc                   	cld    
  800b5c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b5e:	89 f8                	mov    %edi,%eax
  800b60:	8b 1c 24             	mov    (%esp),%ebx
  800b63:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b67:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b6b:	89 ec                	mov    %ebp,%esp
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	89 34 24             	mov    %esi,(%esp)
  800b78:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800b82:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b85:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b87:	39 c6                	cmp    %eax,%esi
  800b89:	73 35                	jae    800bc0 <memmove+0x51>
  800b8b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b8e:	39 d0                	cmp    %edx,%eax
  800b90:	73 2e                	jae    800bc0 <memmove+0x51>
		s += n;
		d += n;
  800b92:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b94:	f6 c2 03             	test   $0x3,%dl
  800b97:	75 1b                	jne    800bb4 <memmove+0x45>
  800b99:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b9f:	75 13                	jne    800bb4 <memmove+0x45>
  800ba1:	f6 c1 03             	test   $0x3,%cl
  800ba4:	75 0e                	jne    800bb4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ba6:	83 ef 04             	sub    $0x4,%edi
  800ba9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bac:	c1 e9 02             	shr    $0x2,%ecx
  800baf:	fd                   	std    
  800bb0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb2:	eb 09                	jmp    800bbd <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bb4:	83 ef 01             	sub    $0x1,%edi
  800bb7:	8d 72 ff             	lea    -0x1(%edx),%esi
  800bba:	fd                   	std    
  800bbb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bbd:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bbe:	eb 20                	jmp    800be0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bc6:	75 15                	jne    800bdd <memmove+0x6e>
  800bc8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bce:	75 0d                	jne    800bdd <memmove+0x6e>
  800bd0:	f6 c1 03             	test   $0x3,%cl
  800bd3:	75 08                	jne    800bdd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800bd5:	c1 e9 02             	shr    $0x2,%ecx
  800bd8:	fc                   	cld    
  800bd9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bdb:	eb 03                	jmp    800be0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bdd:	fc                   	cld    
  800bde:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800be0:	8b 34 24             	mov    (%esp),%esi
  800be3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800be7:	89 ec                	mov    %ebp,%esp
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 04 24             	mov    %eax,(%esp)
  800c05:	e8 65 ff ff ff       	call   800b6f <memmove>
}
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c20:	eb 1c                	jmp    800c3e <memcmp+0x32>
		if (*s1 != *s2)
  800c22:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800c26:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800c2a:	83 c2 01             	add    $0x1,%edx
  800c2d:	83 e9 01             	sub    $0x1,%ecx
  800c30:	38 d8                	cmp    %bl,%al
  800c32:	74 0a                	je     800c3e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800c34:	0f b6 c0             	movzbl %al,%eax
  800c37:	0f b6 db             	movzbl %bl,%ebx
  800c3a:	29 d8                	sub    %ebx,%eax
  800c3c:	eb 09                	jmp    800c47 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3e:	85 c9                	test   %ecx,%ecx
  800c40:	75 e0                	jne    800c22 <memcmp+0x16>
  800c42:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5f                   	pop    %edi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c55:	89 c2                	mov    %eax,%edx
  800c57:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c5a:	eb 07                	jmp    800c63 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c5c:	38 08                	cmp    %cl,(%eax)
  800c5e:	74 07                	je     800c67 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c60:	83 c0 01             	add    $0x1,%eax
  800c63:	39 d0                	cmp    %edx,%eax
  800c65:	72 f5                	jb     800c5c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	83 ec 04             	sub    $0x4,%esp
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c78:	eb 03                	jmp    800c7d <strtol+0x14>
		s++;
  800c7a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7d:	0f b6 02             	movzbl (%edx),%eax
  800c80:	3c 20                	cmp    $0x20,%al
  800c82:	74 f6                	je     800c7a <strtol+0x11>
  800c84:	3c 09                	cmp    $0x9,%al
  800c86:	74 f2                	je     800c7a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c88:	3c 2b                	cmp    $0x2b,%al
  800c8a:	75 0c                	jne    800c98 <strtol+0x2f>
		s++;
  800c8c:	8d 52 01             	lea    0x1(%edx),%edx
  800c8f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c96:	eb 15                	jmp    800cad <strtol+0x44>
	else if (*s == '-')
  800c98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c9f:	3c 2d                	cmp    $0x2d,%al
  800ca1:	75 0a                	jne    800cad <strtol+0x44>
		s++, neg = 1;
  800ca3:	8d 52 01             	lea    0x1(%edx),%edx
  800ca6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cad:	85 db                	test   %ebx,%ebx
  800caf:	0f 94 c0             	sete   %al
  800cb2:	74 05                	je     800cb9 <strtol+0x50>
  800cb4:	83 fb 10             	cmp    $0x10,%ebx
  800cb7:	75 15                	jne    800cce <strtol+0x65>
  800cb9:	80 3a 30             	cmpb   $0x30,(%edx)
  800cbc:	75 10                	jne    800cce <strtol+0x65>
  800cbe:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cc2:	75 0a                	jne    800cce <strtol+0x65>
		s += 2, base = 16;
  800cc4:	83 c2 02             	add    $0x2,%edx
  800cc7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ccc:	eb 13                	jmp    800ce1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cce:	84 c0                	test   %al,%al
  800cd0:	74 0f                	je     800ce1 <strtol+0x78>
  800cd2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800cd7:	80 3a 30             	cmpb   $0x30,(%edx)
  800cda:	75 05                	jne    800ce1 <strtol+0x78>
		s++, base = 8;
  800cdc:	83 c2 01             	add    $0x1,%edx
  800cdf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ce8:	0f b6 0a             	movzbl (%edx),%ecx
  800ceb:	89 cf                	mov    %ecx,%edi
  800ced:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cf0:	80 fb 09             	cmp    $0x9,%bl
  800cf3:	77 08                	ja     800cfd <strtol+0x94>
			dig = *s - '0';
  800cf5:	0f be c9             	movsbl %cl,%ecx
  800cf8:	83 e9 30             	sub    $0x30,%ecx
  800cfb:	eb 1e                	jmp    800d1b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800cfd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d00:	80 fb 19             	cmp    $0x19,%bl
  800d03:	77 08                	ja     800d0d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800d05:	0f be c9             	movsbl %cl,%ecx
  800d08:	83 e9 57             	sub    $0x57,%ecx
  800d0b:	eb 0e                	jmp    800d1b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800d0d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d10:	80 fb 19             	cmp    $0x19,%bl
  800d13:	77 15                	ja     800d2a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d15:	0f be c9             	movsbl %cl,%ecx
  800d18:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d1b:	39 f1                	cmp    %esi,%ecx
  800d1d:	7d 0b                	jge    800d2a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d1f:	83 c2 01             	add    $0x1,%edx
  800d22:	0f af c6             	imul   %esi,%eax
  800d25:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d28:	eb be                	jmp    800ce8 <strtol+0x7f>
  800d2a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d30:	74 05                	je     800d37 <strtol+0xce>
		*endptr = (char *) s;
  800d32:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d35:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d37:	89 ca                	mov    %ecx,%edx
  800d39:	f7 da                	neg    %edx
  800d3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d3f:	0f 45 c2             	cmovne %edx,%eax
}
  800d42:	83 c4 04             	add    $0x4,%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    
	...

00800d4c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	89 1c 24             	mov    %ebx,(%esp)
  800d55:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d59:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d62:	b8 01 00 00 00       	mov    $0x1,%eax
  800d67:	89 d1                	mov    %edx,%ecx
  800d69:	89 d3                	mov    %edx,%ebx
  800d6b:	89 d7                	mov    %edx,%edi
  800d6d:	89 d6                	mov    %edx,%esi
  800d6f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d71:	8b 1c 24             	mov    (%esp),%ebx
  800d74:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d7c:	89 ec                	mov    %ebp,%esp
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	89 1c 24             	mov    %ebx,(%esp)
  800d89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d91:	b8 00 00 00 00       	mov    $0x0,%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	89 c3                	mov    %eax,%ebx
  800d9e:	89 c7                	mov    %eax,%edi
  800da0:	89 c6                	mov    %eax,%esi
  800da2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da4:	8b 1c 24             	mov    (%esp),%ebx
  800da7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800daf:	89 ec                	mov    %ebp,%esp
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	89 1c 24             	mov    %ebx,(%esp)
  800dbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dc0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc9:	b8 10 00 00 00       	mov    $0x10,%eax
  800dce:	89 d1                	mov    %edx,%ecx
  800dd0:	89 d3                	mov    %edx,%ebx
  800dd2:	89 d7                	mov    %edx,%edi
  800dd4:	89 d6                	mov    %edx,%esi
  800dd6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dd8:	8b 1c 24             	mov    (%esp),%ebx
  800ddb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ddf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800de3:	89 ec                	mov    %ebp,%esp
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 38             	sub    $0x38,%esp
  800ded:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	89 df                	mov    %ebx,%edi
  800e08:	89 de                	mov    %ebx,%esi
  800e0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7e 28                	jle    800e38 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e14:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e1b:	00 
  800e1c:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  800e23:	00 
  800e24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2b:	00 
  800e2c:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  800e33:	e8 78 f4 ff ff       	call   8002b0 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800e38:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e3b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e3e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e41:	89 ec                	mov    %ebp,%esp
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 38             	sub    $0x38,%esp
  800e4b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e4e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e51:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e59:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	8b 55 08             	mov    0x8(%ebp),%edx
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	89 de                	mov    %ebx,%esi
  800e68:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7e 28                	jle    800e96 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e72:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800e79:	00 
  800e7a:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  800e81:	00 
  800e82:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e89:	00 
  800e8a:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  800e91:	e8 1a f4 ff ff       	call   8002b0 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800e96:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e99:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e9c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e9f:	89 ec                	mov    %ebp,%esp
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 38             	sub    $0x38,%esp
  800ea9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eaf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	89 cb                	mov    %ecx,%ebx
  800ec1:	89 cf                	mov    %ecx,%edi
  800ec3:	89 ce                	mov    %ecx,%esi
  800ec5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	7e 28                	jle    800ef3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  800ede:	00 
  800edf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee6:	00 
  800ee7:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  800eee:	e8 bd f3 ff ff       	call   8002b0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800efc:	89 ec                	mov    %ebp,%esp
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	89 1c 24             	mov    %ebx,(%esp)
  800f09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f0d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f11:	be 00 00 00 00       	mov    $0x0,%esi
  800f16:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f1b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
  800f27:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f29:	8b 1c 24             	mov    (%esp),%ebx
  800f2c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f30:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f34:	89 ec                	mov    %ebp,%esp
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 38             	sub    $0x38,%esp
  800f3e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f41:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f44:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	89 df                	mov    %ebx,%edi
  800f59:	89 de                	mov    %ebx,%esi
  800f5b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	7e 28                	jle    800f89 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f61:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f65:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f6c:	00 
  800f6d:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  800f74:	00 
  800f75:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7c:	00 
  800f7d:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  800f84:	e8 27 f3 ff ff       	call   8002b0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f89:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f8c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f8f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f92:	89 ec                	mov    %ebp,%esp
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 38             	sub    $0x38,%esp
  800f9c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f9f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800faa:	b8 09 00 00 00       	mov    $0x9,%eax
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	89 df                	mov    %ebx,%edi
  800fb7:	89 de                	mov    %ebx,%esi
  800fb9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	7e 28                	jle    800fe7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fca:	00 
  800fcb:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  800fd2:	00 
  800fd3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fda:	00 
  800fdb:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  800fe2:	e8 c9 f2 ff ff       	call   8002b0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fe7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fed:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ff0:	89 ec                	mov    %ebp,%esp
  800ff2:	5d                   	pop    %ebp
  800ff3:	c3                   	ret    

00800ff4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 38             	sub    $0x38,%esp
  800ffa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ffd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801000:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801003:	bb 00 00 00 00       	mov    $0x0,%ebx
  801008:	b8 08 00 00 00       	mov    $0x8,%eax
  80100d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801010:	8b 55 08             	mov    0x8(%ebp),%edx
  801013:	89 df                	mov    %ebx,%edi
  801015:	89 de                	mov    %ebx,%esi
  801017:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801019:	85 c0                	test   %eax,%eax
  80101b:	7e 28                	jle    801045 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801021:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801028:	00 
  801029:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  801030:	00 
  801031:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801038:	00 
  801039:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  801040:	e8 6b f2 ff ff       	call   8002b0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801045:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801048:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80104b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80104e:	89 ec                	mov    %ebp,%esp
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 38             	sub    $0x38,%esp
  801058:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80105b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80105e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801061:	bb 00 00 00 00       	mov    $0x0,%ebx
  801066:	b8 06 00 00 00       	mov    $0x6,%eax
  80106b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	89 df                	mov    %ebx,%edi
  801073:	89 de                	mov    %ebx,%esi
  801075:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801077:	85 c0                	test   %eax,%eax
  801079:	7e 28                	jle    8010a3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801086:	00 
  801087:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  80108e:	00 
  80108f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801096:	00 
  801097:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  80109e:	e8 0d f2 ff ff       	call   8002b0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010a3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010a9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ac:	89 ec                	mov    %ebp,%esp
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 38             	sub    $0x38,%esp
  8010b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8010c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8010c7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	7e 28                	jle    801101 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010dd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010e4:	00 
  8010e5:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  8010ec:	00 
  8010ed:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f4:	00 
  8010f5:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  8010fc:	e8 af f1 ff ff       	call   8002b0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801101:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801104:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801107:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80110a:	89 ec                	mov    %ebp,%esp
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 38             	sub    $0x38,%esp
  801114:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801117:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80111a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111d:	be 00 00 00 00       	mov    $0x0,%esi
  801122:	b8 04 00 00 00       	mov    $0x4,%eax
  801127:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80112a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112d:	8b 55 08             	mov    0x8(%ebp),%edx
  801130:	89 f7                	mov    %esi,%edi
  801132:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801134:	85 c0                	test   %eax,%eax
  801136:	7e 28                	jle    801160 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801138:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801143:	00 
  801144:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  80115b:	e8 50 f1 ff ff       	call   8002b0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801160:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801163:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801166:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801169:	89 ec                	mov    %ebp,%esp
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	89 1c 24             	mov    %ebx,(%esp)
  801176:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117e:	ba 00 00 00 00       	mov    $0x0,%edx
  801183:	b8 0b 00 00 00       	mov    $0xb,%eax
  801188:	89 d1                	mov    %edx,%ecx
  80118a:	89 d3                	mov    %edx,%ebx
  80118c:	89 d7                	mov    %edx,%edi
  80118e:	89 d6                	mov    %edx,%esi
  801190:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801192:	8b 1c 24             	mov    (%esp),%ebx
  801195:	8b 74 24 04          	mov    0x4(%esp),%esi
  801199:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80119d:	89 ec                	mov    %ebp,%esp
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    

008011a1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	89 1c 24             	mov    %ebx,(%esp)
  8011aa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8011bc:	89 d1                	mov    %edx,%ecx
  8011be:	89 d3                	mov    %edx,%ebx
  8011c0:	89 d7                	mov    %edx,%edi
  8011c2:	89 d6                	mov    %edx,%esi
  8011c4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011c6:	8b 1c 24             	mov    (%esp),%ebx
  8011c9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011cd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011d1:	89 ec                	mov    %ebp,%esp
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    

008011d5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	83 ec 38             	sub    $0x38,%esp
  8011db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8011ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f1:	89 cb                	mov    %ecx,%ebx
  8011f3:	89 cf                	mov    %ecx,%edi
  8011f5:	89 ce                	mov    %ecx,%esi
  8011f7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	7e 28                	jle    801225 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801201:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801208:	00 
  801209:	c7 44 24 08 88 18 80 	movl   $0x801888,0x8(%esp)
  801210:	00 
  801211:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801218:	00 
  801219:	c7 04 24 a5 18 80 00 	movl   $0x8018a5,(%esp)
  801220:	e8 8b f0 ff ff       	call   8002b0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801225:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801228:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80122b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80122e:	89 ec                	mov    %ebp,%esp
  801230:	5d                   	pop    %ebp
  801231:	c3                   	ret    
	...

00801240 <__udivdi3>:
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	57                   	push   %edi
  801244:	56                   	push   %esi
  801245:	83 ec 10             	sub    $0x10,%esp
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	8b 55 08             	mov    0x8(%ebp),%edx
  80124e:	8b 75 10             	mov    0x10(%ebp),%esi
  801251:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801254:	85 c0                	test   %eax,%eax
  801256:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801259:	75 35                	jne    801290 <__udivdi3+0x50>
  80125b:	39 fe                	cmp    %edi,%esi
  80125d:	77 61                	ja     8012c0 <__udivdi3+0x80>
  80125f:	85 f6                	test   %esi,%esi
  801261:	75 0b                	jne    80126e <__udivdi3+0x2e>
  801263:	b8 01 00 00 00       	mov    $0x1,%eax
  801268:	31 d2                	xor    %edx,%edx
  80126a:	f7 f6                	div    %esi
  80126c:	89 c6                	mov    %eax,%esi
  80126e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801271:	31 d2                	xor    %edx,%edx
  801273:	89 f8                	mov    %edi,%eax
  801275:	f7 f6                	div    %esi
  801277:	89 c7                	mov    %eax,%edi
  801279:	89 c8                	mov    %ecx,%eax
  80127b:	f7 f6                	div    %esi
  80127d:	89 c1                	mov    %eax,%ecx
  80127f:	89 fa                	mov    %edi,%edx
  801281:	89 c8                	mov    %ecx,%eax
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	5e                   	pop    %esi
  801287:	5f                   	pop    %edi
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    
  80128a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801290:	39 f8                	cmp    %edi,%eax
  801292:	77 1c                	ja     8012b0 <__udivdi3+0x70>
  801294:	0f bd d0             	bsr    %eax,%edx
  801297:	83 f2 1f             	xor    $0x1f,%edx
  80129a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129d:	75 39                	jne    8012d8 <__udivdi3+0x98>
  80129f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8012a2:	0f 86 a0 00 00 00    	jbe    801348 <__udivdi3+0x108>
  8012a8:	39 f8                	cmp    %edi,%eax
  8012aa:	0f 82 98 00 00 00    	jb     801348 <__udivdi3+0x108>
  8012b0:	31 ff                	xor    %edi,%edi
  8012b2:	31 c9                	xor    %ecx,%ecx
  8012b4:	89 c8                	mov    %ecx,%eax
  8012b6:	89 fa                	mov    %edi,%edx
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	5e                   	pop    %esi
  8012bc:	5f                   	pop    %edi
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    
  8012bf:	90                   	nop
  8012c0:	89 d1                	mov    %edx,%ecx
  8012c2:	89 fa                	mov    %edi,%edx
  8012c4:	89 c8                	mov    %ecx,%eax
  8012c6:	31 ff                	xor    %edi,%edi
  8012c8:	f7 f6                	div    %esi
  8012ca:	89 c1                	mov    %eax,%ecx
  8012cc:	89 fa                	mov    %edi,%edx
  8012ce:	89 c8                	mov    %ecx,%eax
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    
  8012d7:	90                   	nop
  8012d8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8012dc:	89 f2                	mov    %esi,%edx
  8012de:	d3 e0                	shl    %cl,%eax
  8012e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e3:	b8 20 00 00 00       	mov    $0x20,%eax
  8012e8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8012eb:	89 c1                	mov    %eax,%ecx
  8012ed:	d3 ea                	shr    %cl,%edx
  8012ef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8012f3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8012f6:	d3 e6                	shl    %cl,%esi
  8012f8:	89 c1                	mov    %eax,%ecx
  8012fa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8012fd:	89 fe                	mov    %edi,%esi
  8012ff:	d3 ee                	shr    %cl,%esi
  801301:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801305:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801308:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80130b:	d3 e7                	shl    %cl,%edi
  80130d:	89 c1                	mov    %eax,%ecx
  80130f:	d3 ea                	shr    %cl,%edx
  801311:	09 d7                	or     %edx,%edi
  801313:	89 f2                	mov    %esi,%edx
  801315:	89 f8                	mov    %edi,%eax
  801317:	f7 75 ec             	divl   -0x14(%ebp)
  80131a:	89 d6                	mov    %edx,%esi
  80131c:	89 c7                	mov    %eax,%edi
  80131e:	f7 65 e8             	mull   -0x18(%ebp)
  801321:	39 d6                	cmp    %edx,%esi
  801323:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801326:	72 30                	jb     801358 <__udivdi3+0x118>
  801328:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80132b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80132f:	d3 e2                	shl    %cl,%edx
  801331:	39 c2                	cmp    %eax,%edx
  801333:	73 05                	jae    80133a <__udivdi3+0xfa>
  801335:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801338:	74 1e                	je     801358 <__udivdi3+0x118>
  80133a:	89 f9                	mov    %edi,%ecx
  80133c:	31 ff                	xor    %edi,%edi
  80133e:	e9 71 ff ff ff       	jmp    8012b4 <__udivdi3+0x74>
  801343:	90                   	nop
  801344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801348:	31 ff                	xor    %edi,%edi
  80134a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80134f:	e9 60 ff ff ff       	jmp    8012b4 <__udivdi3+0x74>
  801354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801358:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80135b:	31 ff                	xor    %edi,%edi
  80135d:	89 c8                	mov    %ecx,%eax
  80135f:	89 fa                	mov    %edi,%edx
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	5e                   	pop    %esi
  801365:	5f                   	pop    %edi
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    
	...

00801370 <__umoddi3>:
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	57                   	push   %edi
  801374:	56                   	push   %esi
  801375:	83 ec 20             	sub    $0x20,%esp
  801378:	8b 55 14             	mov    0x14(%ebp),%edx
  80137b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801381:	8b 75 0c             	mov    0xc(%ebp),%esi
  801384:	85 d2                	test   %edx,%edx
  801386:	89 c8                	mov    %ecx,%eax
  801388:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80138b:	75 13                	jne    8013a0 <__umoddi3+0x30>
  80138d:	39 f7                	cmp    %esi,%edi
  80138f:	76 3f                	jbe    8013d0 <__umoddi3+0x60>
  801391:	89 f2                	mov    %esi,%edx
  801393:	f7 f7                	div    %edi
  801395:	89 d0                	mov    %edx,%eax
  801397:	31 d2                	xor    %edx,%edx
  801399:	83 c4 20             	add    $0x20,%esp
  80139c:	5e                   	pop    %esi
  80139d:	5f                   	pop    %edi
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    
  8013a0:	39 f2                	cmp    %esi,%edx
  8013a2:	77 4c                	ja     8013f0 <__umoddi3+0x80>
  8013a4:	0f bd ca             	bsr    %edx,%ecx
  8013a7:	83 f1 1f             	xor    $0x1f,%ecx
  8013aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8013ad:	75 51                	jne    801400 <__umoddi3+0x90>
  8013af:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8013b2:	0f 87 e0 00 00 00    	ja     801498 <__umoddi3+0x128>
  8013b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bb:	29 f8                	sub    %edi,%eax
  8013bd:	19 d6                	sbb    %edx,%esi
  8013bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c5:	89 f2                	mov    %esi,%edx
  8013c7:	83 c4 20             	add    $0x20,%esp
  8013ca:	5e                   	pop    %esi
  8013cb:	5f                   	pop    %edi
  8013cc:	5d                   	pop    %ebp
  8013cd:	c3                   	ret    
  8013ce:	66 90                	xchg   %ax,%ax
  8013d0:	85 ff                	test   %edi,%edi
  8013d2:	75 0b                	jne    8013df <__umoddi3+0x6f>
  8013d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8013d9:	31 d2                	xor    %edx,%edx
  8013db:	f7 f7                	div    %edi
  8013dd:	89 c7                	mov    %eax,%edi
  8013df:	89 f0                	mov    %esi,%eax
  8013e1:	31 d2                	xor    %edx,%edx
  8013e3:	f7 f7                	div    %edi
  8013e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e8:	f7 f7                	div    %edi
  8013ea:	eb a9                	jmp    801395 <__umoddi3+0x25>
  8013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013f0:	89 c8                	mov    %ecx,%eax
  8013f2:	89 f2                	mov    %esi,%edx
  8013f4:	83 c4 20             	add    $0x20,%esp
  8013f7:	5e                   	pop    %esi
  8013f8:	5f                   	pop    %edi
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    
  8013fb:	90                   	nop
  8013fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801400:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801404:	d3 e2                	shl    %cl,%edx
  801406:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801409:	ba 20 00 00 00       	mov    $0x20,%edx
  80140e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801411:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801414:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801418:	89 fa                	mov    %edi,%edx
  80141a:	d3 ea                	shr    %cl,%edx
  80141c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801420:	0b 55 f4             	or     -0xc(%ebp),%edx
  801423:	d3 e7                	shl    %cl,%edi
  801425:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801429:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80142c:	89 f2                	mov    %esi,%edx
  80142e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801431:	89 c7                	mov    %eax,%edi
  801433:	d3 ea                	shr    %cl,%edx
  801435:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801439:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80143c:	89 c2                	mov    %eax,%edx
  80143e:	d3 e6                	shl    %cl,%esi
  801440:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801444:	d3 ea                	shr    %cl,%edx
  801446:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80144a:	09 d6                	or     %edx,%esi
  80144c:	89 f0                	mov    %esi,%eax
  80144e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801451:	d3 e7                	shl    %cl,%edi
  801453:	89 f2                	mov    %esi,%edx
  801455:	f7 75 f4             	divl   -0xc(%ebp)
  801458:	89 d6                	mov    %edx,%esi
  80145a:	f7 65 e8             	mull   -0x18(%ebp)
  80145d:	39 d6                	cmp    %edx,%esi
  80145f:	72 2b                	jb     80148c <__umoddi3+0x11c>
  801461:	39 c7                	cmp    %eax,%edi
  801463:	72 23                	jb     801488 <__umoddi3+0x118>
  801465:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801469:	29 c7                	sub    %eax,%edi
  80146b:	19 d6                	sbb    %edx,%esi
  80146d:	89 f0                	mov    %esi,%eax
  80146f:	89 f2                	mov    %esi,%edx
  801471:	d3 ef                	shr    %cl,%edi
  801473:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801477:	d3 e0                	shl    %cl,%eax
  801479:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80147d:	09 f8                	or     %edi,%eax
  80147f:	d3 ea                	shr    %cl,%edx
  801481:	83 c4 20             	add    $0x20,%esp
  801484:	5e                   	pop    %esi
  801485:	5f                   	pop    %edi
  801486:	5d                   	pop    %ebp
  801487:	c3                   	ret    
  801488:	39 d6                	cmp    %edx,%esi
  80148a:	75 d9                	jne    801465 <__umoddi3+0xf5>
  80148c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80148f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801492:	eb d1                	jmp    801465 <__umoddi3+0xf5>
  801494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801498:	39 f2                	cmp    %esi,%edx
  80149a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8014a0:	0f 82 12 ff ff ff    	jb     8013b8 <__umoddi3+0x48>
  8014a6:	e9 17 ff ff ff       	jmp    8013c2 <__umoddi3+0x52>
