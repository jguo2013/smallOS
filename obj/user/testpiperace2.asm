
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 bb 01 00 00       	call   8001ec <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003d:	c7 04 24 c0 2d 80 00 	movl   $0x802dc0,(%esp)
  800044:	e8 c0 02 00 00       	call   800309 <cprintf>
	if ((r = pipe(p)) < 0)
  800049:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 aa 25 00 00       	call   8025fe <pipe>
  800054:	85 c0                	test   %eax,%eax
  800056:	79 20                	jns    800078 <umain+0x44>
		panic("pipe: %e", r);
  800058:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005c:	c7 44 24 08 0e 2e 80 	movl   $0x802e0e,0x8(%esp)
  800063:	00 
  800064:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006b:	00 
  80006c:	c7 04 24 17 2e 80 00 	movl   $0x802e17,(%esp)
  800073:	e8 d8 01 00 00       	call   800250 <_panic>
	if ((r = fork()) < 0)
  800078:	e8 79 11 00 00       	call   8011f6 <fork>
  80007d:	89 c7                	mov    %eax,%edi
  80007f:	85 c0                	test   %eax,%eax
  800081:	79 20                	jns    8000a3 <umain+0x6f>
		panic("fork: %e", r);
  800083:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800087:	c7 44 24 08 1a 32 80 	movl   $0x80321a,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 17 2e 80 00 	movl   $0x802e17,(%esp)
  80009e:	e8 ad 01 00 00       	call   800250 <_panic>
	if (r == 0) {
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	75 75                	jne    80011c <umain+0xe8>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  8000a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000aa:	89 04 24             	mov    %eax,(%esp)
  8000ad:	e8 1c 19 00 00       	call   8019ce <close>
  8000b2:	bb 00 00 00 00       	mov    $0x0,%ebx
		for (i = 0; i < 200; i++) {
			if (i % 10 == 0)
  8000b7:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	f7 ee                	imul   %esi
  8000c0:	c1 fa 02             	sar    $0x2,%edx
  8000c3:	89 d8                	mov    %ebx,%eax
  8000c5:	c1 f8 1f             	sar    $0x1f,%eax
  8000c8:	29 c2                	sub    %eax,%edx
  8000ca:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	39 c3                	cmp    %eax,%ebx
  8000d1:	75 10                	jne    8000e3 <umain+0xaf>
				cprintf("%d.", i);
  8000d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d7:	c7 04 24 2c 2e 80 00 	movl   $0x802e2c,(%esp)
  8000de:	e8 26 02 00 00       	call   800309 <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e3:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000ea:	00 
  8000eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ee:	89 04 24             	mov    %eax,(%esp)
  8000f1:	e8 77 19 00 00       	call   801a6d <dup>
			sys_yield();
  8000f6:	e8 12 10 00 00       	call   80110d <sys_yield>
			close(10);
  8000fb:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800102:	e8 c7 18 00 00       	call   8019ce <close>
			sys_yield();
  800107:	e8 01 10 00 00       	call   80110d <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  80010c:	83 c3 01             	add    $0x1,%ebx
  80010f:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800115:	75 a5                	jne    8000bc <umain+0x88>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  800117:	e8 20 01 00 00       	call   80023c <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  80011c:	89 fb                	mov    %edi,%ebx
  80011e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800124:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800127:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80012d:	eb 28                	jmp    800157 <umain+0x123>
		if (pipeisclosed(p[0]) != 0) {
  80012f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800132:	89 04 24             	mov    %eax,(%esp)
  800135:	e8 91 24 00 00       	call   8025cb <pipeisclosed>
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 19                	je     800157 <umain+0x123>
			cprintf("\nRACE: pipe appears closed\n");
  80013e:	c7 04 24 30 2e 80 00 	movl   $0x802e30,(%esp)
  800145:	e8 bf 01 00 00       	call   800309 <cprintf>
			sys_env_destroy(r);
  80014a:	89 3c 24             	mov    %edi,(%esp)
  80014d:	e8 23 10 00 00       	call   801175 <sys_env_destroy>
			exit();
  800152:	e8 e5 00 00 00       	call   80023c <exit>
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800157:	8b 43 54             	mov    0x54(%ebx),%eax
  80015a:	83 f8 02             	cmp    $0x2,%eax
  80015d:	74 d0                	je     80012f <umain+0xfb>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  80015f:	c7 04 24 4c 2e 80 00 	movl   $0x802e4c,(%esp)
  800166:	e8 9e 01 00 00       	call   800309 <cprintf>
	if (pipeisclosed(p[0]))
  80016b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016e:	89 04 24             	mov    %eax,(%esp)
  800171:	e8 55 24 00 00       	call   8025cb <pipeisclosed>
  800176:	85 c0                	test   %eax,%eax
  800178:	74 1c                	je     800196 <umain+0x162>
		panic("somehow the other end of p[0] got closed!");
  80017a:	c7 44 24 08 e4 2d 80 	movl   $0x802de4,0x8(%esp)
  800181:	00 
  800182:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800189:	00 
  80018a:	c7 04 24 17 2e 80 00 	movl   $0x802e17,(%esp)
  800191:	e8 ba 00 00 00       	call   800250 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800196:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800199:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a0:	89 04 24             	mov    %eax,(%esp)
  8001a3:	e8 68 14 00 00       	call   801610 <fd_lookup>
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	79 20                	jns    8001cc <umain+0x198>
		panic("cannot look up p[0]: %e", r);
  8001ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b0:	c7 44 24 08 62 2e 80 	movl   $0x802e62,0x8(%esp)
  8001b7:	00 
  8001b8:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001bf:	00 
  8001c0:	c7 04 24 17 2e 80 00 	movl   $0x802e17,(%esp)
  8001c7:	e8 84 00 00 00       	call   800250 <_panic>
	(void) fd2data(fd);
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	89 04 24             	mov    %eax,(%esp)
  8001d2:	e8 c5 13 00 00       	call   80159c <fd2data>
	cprintf("race didn't happen\n");
  8001d7:	c7 04 24 7a 2e 80 00 	movl   $0x802e7a,(%esp)
  8001de:	e8 26 01 00 00       	call   800309 <cprintf>
}
  8001e3:	83 c4 2c             	add    $0x2c,%esp
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5f                   	pop    %edi
  8001e9:	5d                   	pop    %ebp
  8001ea:	c3                   	ret    
	...

008001ec <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 18             	sub    $0x18,%esp
  8001f2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001f5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8001fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8001fe:	e8 3e 0f 00 00       	call   801141 <sys_getenvid>
  800203:	25 ff 03 00 00       	and    $0x3ff,%eax
  800208:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020b:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800210:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800215:	85 f6                	test   %esi,%esi
  800217:	7e 07                	jle    800220 <libmain+0x34>
		binaryname = argv[0];
  800219:	8b 03                	mov    (%ebx),%eax
  80021b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800220:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800224:	89 34 24             	mov    %esi,(%esp)
  800227:	e8 08 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80022c:	e8 0b 00 00 00       	call   80023c <exit>
}
  800231:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800234:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800237:	89 ec                	mov    %ebp,%esp
  800239:	5d                   	pop    %ebp
  80023a:	c3                   	ret    
	...

0080023c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800242:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800249:	e8 27 0f 00 00       	call   801175 <sys_env_destroy>
}
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	56                   	push   %esi
  800254:	53                   	push   %ebx
  800255:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800258:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80025b:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  800261:	e8 db 0e 00 00       	call   801141 <sys_getenvid>
  800266:	8b 55 0c             	mov    0xc(%ebp),%edx
  800269:	89 54 24 10          	mov    %edx,0x10(%esp)
  80026d:	8b 55 08             	mov    0x8(%ebp),%edx
  800270:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800274:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027c:	c7 04 24 98 2e 80 00 	movl   $0x802e98,(%esp)
  800283:	e8 81 00 00 00       	call   800309 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800288:	89 74 24 04          	mov    %esi,0x4(%esp)
  80028c:	8b 45 10             	mov    0x10(%ebp),%eax
  80028f:	89 04 24             	mov    %eax,(%esp)
  800292:	e8 11 00 00 00       	call   8002a8 <vcprintf>
	cprintf("\n");
  800297:	c7 04 24 5a 34 80 00 	movl   $0x80345a,(%esp)
  80029e:	e8 66 00 00 00       	call   800309 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a3:	cc                   	int3   
  8002a4:	eb fd                	jmp    8002a3 <_panic+0x53>
	...

008002a8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b8:	00 00 00 
	b.cnt = 0;
  8002bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002dd:	c7 04 24 23 03 80 00 	movl   $0x800323,(%esp)
  8002e4:	e8 be 01 00 00       	call   8004a7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f9:	89 04 24             	mov    %eax,(%esp)
  8002fc:	e8 1f 0a 00 00       	call   800d20 <sys_cputs>

	return b.cnt;
}
  800301:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800307:	c9                   	leave  
  800308:	c3                   	ret    

00800309 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80030f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800312:	89 44 24 04          	mov    %eax,0x4(%esp)
  800316:	8b 45 08             	mov    0x8(%ebp),%eax
  800319:	89 04 24             	mov    %eax,(%esp)
  80031c:	e8 87 ff ff ff       	call   8002a8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	53                   	push   %ebx
  800327:	83 ec 14             	sub    $0x14,%esp
  80032a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80032d:	8b 03                	mov    (%ebx),%eax
  80032f:	8b 55 08             	mov    0x8(%ebp),%edx
  800332:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800336:	83 c0 01             	add    $0x1,%eax
  800339:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80033b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800340:	75 19                	jne    80035b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800342:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800349:	00 
  80034a:	8d 43 08             	lea    0x8(%ebx),%eax
  80034d:	89 04 24             	mov    %eax,(%esp)
  800350:	e8 cb 09 00 00       	call   800d20 <sys_cputs>
		b->idx = 0;
  800355:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80035b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80035f:	83 c4 14             	add    $0x14,%esp
  800362:	5b                   	pop    %ebx
  800363:	5d                   	pop    %ebp
  800364:	c3                   	ret    
  800365:	00 00                	add    %al,(%eax)
	...

00800368 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	57                   	push   %edi
  80036c:	56                   	push   %esi
  80036d:	53                   	push   %ebx
  80036e:	83 ec 4c             	sub    $0x4c,%esp
  800371:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800374:	89 d6                	mov    %edx,%esi
  800376:	8b 45 08             	mov    0x8(%ebp),%eax
  800379:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80037c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80037f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800382:	8b 45 10             	mov    0x10(%ebp),%eax
  800385:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800388:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80038b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800393:	39 d1                	cmp    %edx,%ecx
  800395:	72 07                	jb     80039e <printnum+0x36>
  800397:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80039a:	39 d0                	cmp    %edx,%eax
  80039c:	77 69                	ja     800407 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80039e:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003a2:	83 eb 01             	sub    $0x1,%ebx
  8003a5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8003b1:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8003b5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003b8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8003bb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003be:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003c9:	00 
  8003ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003cd:	89 04 24             	mov    %eax,(%esp)
  8003d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003d7:	e8 64 27 00 00       	call   802b40 <__udivdi3>
  8003dc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003e6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003ea:	89 04 24             	mov    %eax,(%esp)
  8003ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003f1:	89 f2                	mov    %esi,%edx
  8003f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003f6:	e8 6d ff ff ff       	call   800368 <printnum>
  8003fb:	eb 11                	jmp    80040e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800401:	89 3c 24             	mov    %edi,(%esp)
  800404:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800407:	83 eb 01             	sub    $0x1,%ebx
  80040a:	85 db                	test   %ebx,%ebx
  80040c:	7f ef                	jg     8003fd <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800412:	8b 74 24 04          	mov    0x4(%esp),%esi
  800416:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800419:	89 44 24 08          	mov    %eax,0x8(%esp)
  80041d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800424:	00 
  800425:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800428:	89 14 24             	mov    %edx,(%esp)
  80042b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800432:	e8 39 28 00 00       	call   802c70 <__umoddi3>
  800437:	89 74 24 04          	mov    %esi,0x4(%esp)
  80043b:	0f be 80 bb 2e 80 00 	movsbl 0x802ebb(%eax),%eax
  800442:	89 04 24             	mov    %eax,(%esp)
  800445:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800448:	83 c4 4c             	add    $0x4c,%esp
  80044b:	5b                   	pop    %ebx
  80044c:	5e                   	pop    %esi
  80044d:	5f                   	pop    %edi
  80044e:	5d                   	pop    %ebp
  80044f:	c3                   	ret    

00800450 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800453:	83 fa 01             	cmp    $0x1,%edx
  800456:	7e 0e                	jle    800466 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800458:	8b 10                	mov    (%eax),%edx
  80045a:	8d 4a 08             	lea    0x8(%edx),%ecx
  80045d:	89 08                	mov    %ecx,(%eax)
  80045f:	8b 02                	mov    (%edx),%eax
  800461:	8b 52 04             	mov    0x4(%edx),%edx
  800464:	eb 22                	jmp    800488 <getuint+0x38>
	else if (lflag)
  800466:	85 d2                	test   %edx,%edx
  800468:	74 10                	je     80047a <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80046a:	8b 10                	mov    (%eax),%edx
  80046c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80046f:	89 08                	mov    %ecx,(%eax)
  800471:	8b 02                	mov    (%edx),%eax
  800473:	ba 00 00 00 00       	mov    $0x0,%edx
  800478:	eb 0e                	jmp    800488 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80047a:	8b 10                	mov    (%eax),%edx
  80047c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80047f:	89 08                	mov    %ecx,(%eax)
  800481:	8b 02                	mov    (%edx),%eax
  800483:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800488:	5d                   	pop    %ebp
  800489:	c3                   	ret    

0080048a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800490:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800494:	8b 10                	mov    (%eax),%edx
  800496:	3b 50 04             	cmp    0x4(%eax),%edx
  800499:	73 0a                	jae    8004a5 <sprintputch+0x1b>
		*b->buf++ = ch;
  80049b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80049e:	88 0a                	mov    %cl,(%edx)
  8004a0:	83 c2 01             	add    $0x1,%edx
  8004a3:	89 10                	mov    %edx,(%eax)
}
  8004a5:	5d                   	pop    %ebp
  8004a6:	c3                   	ret    

008004a7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	57                   	push   %edi
  8004ab:	56                   	push   %esi
  8004ac:	53                   	push   %ebx
  8004ad:	83 ec 4c             	sub    $0x4c,%esp
  8004b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004b9:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8004c0:	eb 11                	jmp    8004d3 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004c2:	85 c0                	test   %eax,%eax
  8004c4:	0f 84 b6 03 00 00    	je     800880 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8004ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ce:	89 04 24             	mov    %eax,(%esp)
  8004d1:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d3:	0f b6 03             	movzbl (%ebx),%eax
  8004d6:	83 c3 01             	add    $0x1,%ebx
  8004d9:	83 f8 25             	cmp    $0x25,%eax
  8004dc:	75 e4                	jne    8004c2 <vprintfmt+0x1b>
  8004de:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8004e2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004e9:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8004f0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004fc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004ff:	eb 06                	jmp    800507 <vprintfmt+0x60>
  800501:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800505:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800507:	0f b6 0b             	movzbl (%ebx),%ecx
  80050a:	0f b6 c1             	movzbl %cl,%eax
  80050d:	8d 53 01             	lea    0x1(%ebx),%edx
  800510:	83 e9 23             	sub    $0x23,%ecx
  800513:	80 f9 55             	cmp    $0x55,%cl
  800516:	0f 87 47 03 00 00    	ja     800863 <vprintfmt+0x3bc>
  80051c:	0f b6 c9             	movzbl %cl,%ecx
  80051f:	ff 24 8d 00 30 80 00 	jmp    *0x803000(,%ecx,4)
  800526:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80052a:	eb d9                	jmp    800505 <vprintfmt+0x5e>
  80052c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800533:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800538:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80053b:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80053f:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800542:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800545:	83 fb 09             	cmp    $0x9,%ebx
  800548:	77 30                	ja     80057a <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054a:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80054d:	eb e9                	jmp    800538 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 48 04             	lea    0x4(%eax),%ecx
  800555:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  80055d:	eb 1e                	jmp    80057d <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80055f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800563:	b8 00 00 00 00       	mov    $0x0,%eax
  800568:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  80056c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80056f:	eb 94                	jmp    800505 <vprintfmt+0x5e>
  800571:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800578:	eb 8b                	jmp    800505 <vprintfmt+0x5e>
  80057a:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  80057d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800581:	79 82                	jns    800505 <vprintfmt+0x5e>
  800583:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800589:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80058c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80058f:	e9 71 ff ff ff       	jmp    800505 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800594:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800598:	e9 68 ff ff ff       	jmp    800505 <vprintfmt+0x5e>
  80059d:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 50 04             	lea    0x4(%eax),%edx
  8005a6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 04 24             	mov    %eax,(%esp)
  8005b2:	ff d7                	call   *%edi
  8005b4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8005b7:	e9 17 ff ff ff       	jmp    8004d3 <vprintfmt+0x2c>
  8005bc:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 50 04             	lea    0x4(%eax),%edx
  8005c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 c2                	mov    %eax,%edx
  8005cc:	c1 fa 1f             	sar    $0x1f,%edx
  8005cf:	31 d0                	xor    %edx,%eax
  8005d1:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005d3:	83 f8 11             	cmp    $0x11,%eax
  8005d6:	7f 0b                	jg     8005e3 <vprintfmt+0x13c>
  8005d8:	8b 14 85 60 31 80 00 	mov    0x803160(,%eax,4),%edx
  8005df:	85 d2                	test   %edx,%edx
  8005e1:	75 20                	jne    800603 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8005e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005e7:	c7 44 24 08 cc 2e 80 	movl   $0x802ecc,0x8(%esp)
  8005ee:	00 
  8005ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005f3:	89 3c 24             	mov    %edi,(%esp)
  8005f6:	e8 0d 03 00 00       	call   800908 <printfmt>
  8005fb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005fe:	e9 d0 fe ff ff       	jmp    8004d3 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800603:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800607:	c7 44 24 08 72 33 80 	movl   $0x803372,0x8(%esp)
  80060e:	00 
  80060f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800613:	89 3c 24             	mov    %edi,(%esp)
  800616:	e8 ed 02 00 00       	call   800908 <printfmt>
  80061b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80061e:	e9 b0 fe ff ff       	jmp    8004d3 <vprintfmt+0x2c>
  800623:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800626:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8d 50 04             	lea    0x4(%eax),%edx
  800635:	89 55 14             	mov    %edx,0x14(%ebp)
  800638:	8b 18                	mov    (%eax),%ebx
  80063a:	85 db                	test   %ebx,%ebx
  80063c:	b8 d5 2e 80 00       	mov    $0x802ed5,%eax
  800641:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800644:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800648:	7e 76                	jle    8006c0 <vprintfmt+0x219>
  80064a:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80064e:	74 7a                	je     8006ca <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800650:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800654:	89 1c 24             	mov    %ebx,(%esp)
  800657:	e8 ec 02 00 00       	call   800948 <strnlen>
  80065c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80065f:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800661:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800665:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800668:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80066b:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80066d:	eb 0f                	jmp    80067e <vprintfmt+0x1d7>
					putch(padc, putdat);
  80066f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800673:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800676:	89 04 24             	mov    %eax,(%esp)
  800679:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80067b:	83 eb 01             	sub    $0x1,%ebx
  80067e:	85 db                	test   %ebx,%ebx
  800680:	7f ed                	jg     80066f <vprintfmt+0x1c8>
  800682:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800685:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800688:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80068b:	89 f7                	mov    %esi,%edi
  80068d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800690:	eb 40                	jmp    8006d2 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800692:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800696:	74 18                	je     8006b0 <vprintfmt+0x209>
  800698:	8d 50 e0             	lea    -0x20(%eax),%edx
  80069b:	83 fa 5e             	cmp    $0x5e,%edx
  80069e:	76 10                	jbe    8006b0 <vprintfmt+0x209>
					putch('?', putdat);
  8006a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006ab:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006ae:	eb 0a                	jmp    8006ba <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8006b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b4:	89 04 24             	mov    %eax,(%esp)
  8006b7:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ba:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006be:	eb 12                	jmp    8006d2 <vprintfmt+0x22b>
  8006c0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006c3:	89 f7                	mov    %esi,%edi
  8006c5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006c8:	eb 08                	jmp    8006d2 <vprintfmt+0x22b>
  8006ca:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006cd:	89 f7                	mov    %esi,%edi
  8006cf:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006d2:	0f be 03             	movsbl (%ebx),%eax
  8006d5:	83 c3 01             	add    $0x1,%ebx
  8006d8:	85 c0                	test   %eax,%eax
  8006da:	74 25                	je     800701 <vprintfmt+0x25a>
  8006dc:	85 f6                	test   %esi,%esi
  8006de:	78 b2                	js     800692 <vprintfmt+0x1eb>
  8006e0:	83 ee 01             	sub    $0x1,%esi
  8006e3:	79 ad                	jns    800692 <vprintfmt+0x1eb>
  8006e5:	89 fe                	mov    %edi,%esi
  8006e7:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8006ed:	eb 1a                	jmp    800709 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006fa:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fc:	83 eb 01             	sub    $0x1,%ebx
  8006ff:	eb 08                	jmp    800709 <vprintfmt+0x262>
  800701:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800704:	89 fe                	mov    %edi,%esi
  800706:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800709:	85 db                	test   %ebx,%ebx
  80070b:	7f e2                	jg     8006ef <vprintfmt+0x248>
  80070d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800710:	e9 be fd ff ff       	jmp    8004d3 <vprintfmt+0x2c>
  800715:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800718:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80071b:	83 f9 01             	cmp    $0x1,%ecx
  80071e:	7e 16                	jle    800736 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8d 50 08             	lea    0x8(%eax),%edx
  800726:	89 55 14             	mov    %edx,0x14(%ebp)
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	8b 48 04             	mov    0x4(%eax),%ecx
  80072e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800731:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800734:	eb 32                	jmp    800768 <vprintfmt+0x2c1>
	else if (lflag)
  800736:	85 c9                	test   %ecx,%ecx
  800738:	74 18                	je     800752 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 50 04             	lea    0x4(%eax),%edx
  800740:	89 55 14             	mov    %edx,0x14(%ebp)
  800743:	8b 00                	mov    (%eax),%eax
  800745:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800748:	89 c1                	mov    %eax,%ecx
  80074a:	c1 f9 1f             	sar    $0x1f,%ecx
  80074d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800750:	eb 16                	jmp    800768 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 50 04             	lea    0x4(%eax),%edx
  800758:	89 55 14             	mov    %edx,0x14(%ebp)
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800760:	89 c2                	mov    %eax,%edx
  800762:	c1 fa 1f             	sar    $0x1f,%edx
  800765:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800768:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80076b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80076e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800773:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800777:	0f 89 a7 00 00 00    	jns    800824 <vprintfmt+0x37d>
				putch('-', putdat);
  80077d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800781:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800788:	ff d7                	call   *%edi
				num = -(long long) num;
  80078a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80078d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800790:	f7 d9                	neg    %ecx
  800792:	83 d3 00             	adc    $0x0,%ebx
  800795:	f7 db                	neg    %ebx
  800797:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079c:	e9 83 00 00 00       	jmp    800824 <vprintfmt+0x37d>
  8007a1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007a4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007a7:	89 ca                	mov    %ecx,%edx
  8007a9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ac:	e8 9f fc ff ff       	call   800450 <getuint>
  8007b1:	89 c1                	mov    %eax,%ecx
  8007b3:	89 d3                	mov    %edx,%ebx
  8007b5:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007ba:	eb 68                	jmp    800824 <vprintfmt+0x37d>
  8007bc:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007bf:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8007c2:	89 ca                	mov    %ecx,%edx
  8007c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c7:	e8 84 fc ff ff       	call   800450 <getuint>
  8007cc:	89 c1                	mov    %eax,%ecx
  8007ce:	89 d3                	mov    %edx,%ebx
  8007d0:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8007d5:	eb 4d                	jmp    800824 <vprintfmt+0x37d>
  8007d7:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8007da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007de:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007e5:	ff d7                	call   *%edi
			putch('x', putdat);
  8007e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007eb:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007f2:	ff d7                	call   *%edi
			num = (unsigned long long)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8d 50 04             	lea    0x4(%eax),%edx
  8007fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8007fd:	8b 08                	mov    (%eax),%ecx
  8007ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800804:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800809:	eb 19                	jmp    800824 <vprintfmt+0x37d>
  80080b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80080e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800811:	89 ca                	mov    %ecx,%edx
  800813:	8d 45 14             	lea    0x14(%ebp),%eax
  800816:	e8 35 fc ff ff       	call   800450 <getuint>
  80081b:	89 c1                	mov    %eax,%ecx
  80081d:	89 d3                	mov    %edx,%ebx
  80081f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800824:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800828:	89 54 24 10          	mov    %edx,0x10(%esp)
  80082c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80082f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800833:	89 44 24 08          	mov    %eax,0x8(%esp)
  800837:	89 0c 24             	mov    %ecx,(%esp)
  80083a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80083e:	89 f2                	mov    %esi,%edx
  800840:	89 f8                	mov    %edi,%eax
  800842:	e8 21 fb ff ff       	call   800368 <printnum>
  800847:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80084a:	e9 84 fc ff ff       	jmp    8004d3 <vprintfmt+0x2c>
  80084f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800852:	89 74 24 04          	mov    %esi,0x4(%esp)
  800856:	89 04 24             	mov    %eax,(%esp)
  800859:	ff d7                	call   *%edi
  80085b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80085e:	e9 70 fc ff ff       	jmp    8004d3 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800863:	89 74 24 04          	mov    %esi,0x4(%esp)
  800867:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80086e:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800870:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800873:	80 38 25             	cmpb   $0x25,(%eax)
  800876:	0f 84 57 fc ff ff    	je     8004d3 <vprintfmt+0x2c>
  80087c:	89 c3                	mov    %eax,%ebx
  80087e:	eb f0                	jmp    800870 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800880:	83 c4 4c             	add    $0x4c,%esp
  800883:	5b                   	pop    %ebx
  800884:	5e                   	pop    %esi
  800885:	5f                   	pop    %edi
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	83 ec 28             	sub    $0x28,%esp
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800894:	85 c0                	test   %eax,%eax
  800896:	74 04                	je     80089c <vsnprintf+0x14>
  800898:	85 d2                	test   %edx,%edx
  80089a:	7f 07                	jg     8008a3 <vsnprintf+0x1b>
  80089c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a1:	eb 3b                	jmp    8008de <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8008aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c9:	c7 04 24 8a 04 80 00 	movl   $0x80048a,(%esp)
  8008d0:	e8 d2 fb ff ff       	call   8004a7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    

008008e0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008e6:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 04 24             	mov    %eax,(%esp)
  800901:	e8 82 ff ff ff       	call   800888 <vsnprintf>
	va_end(ap);

	return rc;
}
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80090e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800911:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800915:	8b 45 10             	mov    0x10(%ebp),%eax
  800918:	89 44 24 08          	mov    %eax,0x8(%esp)
  80091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 04 24             	mov    %eax,(%esp)
  800929:	e8 79 fb ff ff       	call   8004a7 <vprintfmt>
	va_end(ap);
}
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	8b 55 08             	mov    0x8(%ebp),%edx
  800936:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80093b:	eb 03                	jmp    800940 <strlen+0x10>
		n++;
  80093d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800940:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800944:	75 f7                	jne    80093d <strlen+0xd>
		n++;
	return n;
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	53                   	push   %ebx
  80094c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80094f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800952:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800957:	eb 03                	jmp    80095c <strnlen+0x14>
		n++;
  800959:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80095c:	39 c1                	cmp    %eax,%ecx
  80095e:	74 06                	je     800966 <strnlen+0x1e>
  800960:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800964:	75 f3                	jne    800959 <strnlen+0x11>
		n++;
	return n;
}
  800966:	5b                   	pop    %ebx
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800973:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800978:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80097c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80097f:	83 c2 01             	add    $0x1,%edx
  800982:	84 c9                	test   %cl,%cl
  800984:	75 f2                	jne    800978 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800986:	5b                   	pop    %ebx
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	53                   	push   %ebx
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800993:	89 1c 24             	mov    %ebx,(%esp)
  800996:	e8 95 ff ff ff       	call   800930 <strlen>
	strcpy(dst + len, src);
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009a2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8009a5:	89 04 24             	mov    %eax,(%esp)
  8009a8:	e8 bc ff ff ff       	call   800969 <strcpy>
	return dst;
}
  8009ad:	89 d8                	mov    %ebx,%eax
  8009af:	83 c4 08             	add    $0x8,%esp
  8009b2:	5b                   	pop    %ebx
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    

008009b5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	56                   	push   %esi
  8009b9:	53                   	push   %ebx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c0:	8b 75 10             	mov    0x10(%ebp),%esi
  8009c3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c8:	eb 0f                	jmp    8009d9 <strncpy+0x24>
		*dst++ = *src;
  8009ca:	0f b6 19             	movzbl (%ecx),%ebx
  8009cd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009d0:	80 39 01             	cmpb   $0x1,(%ecx)
  8009d3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d6:	83 c2 01             	add    $0x1,%edx
  8009d9:	39 f2                	cmp    %esi,%edx
  8009db:	72 ed                	jb     8009ca <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009dd:	5b                   	pop    %ebx
  8009de:	5e                   	pop    %esi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	56                   	push   %esi
  8009e5:	53                   	push   %ebx
  8009e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ec:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009ef:	89 f0                	mov    %esi,%eax
  8009f1:	85 d2                	test   %edx,%edx
  8009f3:	75 0a                	jne    8009ff <strlcpy+0x1e>
  8009f5:	eb 17                	jmp    800a0e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009f7:	88 18                	mov    %bl,(%eax)
  8009f9:	83 c0 01             	add    $0x1,%eax
  8009fc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009ff:	83 ea 01             	sub    $0x1,%edx
  800a02:	74 07                	je     800a0b <strlcpy+0x2a>
  800a04:	0f b6 19             	movzbl (%ecx),%ebx
  800a07:	84 db                	test   %bl,%bl
  800a09:	75 ec                	jne    8009f7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800a0b:	c6 00 00             	movb   $0x0,(%eax)
  800a0e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a10:	5b                   	pop    %ebx
  800a11:	5e                   	pop    %esi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a1d:	eb 06                	jmp    800a25 <strcmp+0x11>
		p++, q++;
  800a1f:	83 c1 01             	add    $0x1,%ecx
  800a22:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a25:	0f b6 01             	movzbl (%ecx),%eax
  800a28:	84 c0                	test   %al,%al
  800a2a:	74 04                	je     800a30 <strcmp+0x1c>
  800a2c:	3a 02                	cmp    (%edx),%al
  800a2e:	74 ef                	je     800a1f <strcmp+0xb>
  800a30:	0f b6 c0             	movzbl %al,%eax
  800a33:	0f b6 12             	movzbl (%edx),%edx
  800a36:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	53                   	push   %ebx
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a44:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800a47:	eb 09                	jmp    800a52 <strncmp+0x18>
		n--, p++, q++;
  800a49:	83 ea 01             	sub    $0x1,%edx
  800a4c:	83 c0 01             	add    $0x1,%eax
  800a4f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a52:	85 d2                	test   %edx,%edx
  800a54:	75 07                	jne    800a5d <strncmp+0x23>
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5b:	eb 13                	jmp    800a70 <strncmp+0x36>
  800a5d:	0f b6 18             	movzbl (%eax),%ebx
  800a60:	84 db                	test   %bl,%bl
  800a62:	74 04                	je     800a68 <strncmp+0x2e>
  800a64:	3a 19                	cmp    (%ecx),%bl
  800a66:	74 e1                	je     800a49 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a68:	0f b6 00             	movzbl (%eax),%eax
  800a6b:	0f b6 11             	movzbl (%ecx),%edx
  800a6e:	29 d0                	sub    %edx,%eax
}
  800a70:	5b                   	pop    %ebx
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7d:	eb 07                	jmp    800a86 <strchr+0x13>
		if (*s == c)
  800a7f:	38 ca                	cmp    %cl,%dl
  800a81:	74 0f                	je     800a92 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a83:	83 c0 01             	add    $0x1,%eax
  800a86:	0f b6 10             	movzbl (%eax),%edx
  800a89:	84 d2                	test   %dl,%dl
  800a8b:	75 f2                	jne    800a7f <strchr+0xc>
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9e:	eb 07                	jmp    800aa7 <strfind+0x13>
		if (*s == c)
  800aa0:	38 ca                	cmp    %cl,%dl
  800aa2:	74 0a                	je     800aae <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aa4:	83 c0 01             	add    $0x1,%eax
  800aa7:	0f b6 10             	movzbl (%eax),%edx
  800aaa:	84 d2                	test   %dl,%dl
  800aac:	75 f2                	jne    800aa0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	89 1c 24             	mov    %ebx,(%esp)
  800ab9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800abd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ac1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aca:	85 c9                	test   %ecx,%ecx
  800acc:	74 30                	je     800afe <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ace:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ad4:	75 25                	jne    800afb <memset+0x4b>
  800ad6:	f6 c1 03             	test   $0x3,%cl
  800ad9:	75 20                	jne    800afb <memset+0x4b>
		c &= 0xFF;
  800adb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ade:	89 d3                	mov    %edx,%ebx
  800ae0:	c1 e3 08             	shl    $0x8,%ebx
  800ae3:	89 d6                	mov    %edx,%esi
  800ae5:	c1 e6 18             	shl    $0x18,%esi
  800ae8:	89 d0                	mov    %edx,%eax
  800aea:	c1 e0 10             	shl    $0x10,%eax
  800aed:	09 f0                	or     %esi,%eax
  800aef:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800af1:	09 d8                	or     %ebx,%eax
  800af3:	c1 e9 02             	shr    $0x2,%ecx
  800af6:	fc                   	cld    
  800af7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af9:	eb 03                	jmp    800afe <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800afb:	fc                   	cld    
  800afc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800afe:	89 f8                	mov    %edi,%eax
  800b00:	8b 1c 24             	mov    (%esp),%ebx
  800b03:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b07:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b0b:	89 ec                	mov    %ebp,%esp
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 08             	sub    $0x8,%esp
  800b15:	89 34 24             	mov    %esi,(%esp)
  800b18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800b22:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b25:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b27:	39 c6                	cmp    %eax,%esi
  800b29:	73 35                	jae    800b60 <memmove+0x51>
  800b2b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b2e:	39 d0                	cmp    %edx,%eax
  800b30:	73 2e                	jae    800b60 <memmove+0x51>
		s += n;
		d += n;
  800b32:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b34:	f6 c2 03             	test   $0x3,%dl
  800b37:	75 1b                	jne    800b54 <memmove+0x45>
  800b39:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b3f:	75 13                	jne    800b54 <memmove+0x45>
  800b41:	f6 c1 03             	test   $0x3,%cl
  800b44:	75 0e                	jne    800b54 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b46:	83 ef 04             	sub    $0x4,%edi
  800b49:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b4c:	c1 e9 02             	shr    $0x2,%ecx
  800b4f:	fd                   	std    
  800b50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b52:	eb 09                	jmp    800b5d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b54:	83 ef 01             	sub    $0x1,%edi
  800b57:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b5a:	fd                   	std    
  800b5b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b5d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b5e:	eb 20                	jmp    800b80 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b60:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b66:	75 15                	jne    800b7d <memmove+0x6e>
  800b68:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b6e:	75 0d                	jne    800b7d <memmove+0x6e>
  800b70:	f6 c1 03             	test   $0x3,%cl
  800b73:	75 08                	jne    800b7d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b75:	c1 e9 02             	shr    $0x2,%ecx
  800b78:	fc                   	cld    
  800b79:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7b:	eb 03                	jmp    800b80 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b7d:	fc                   	cld    
  800b7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b80:	8b 34 24             	mov    (%esp),%esi
  800b83:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b87:	89 ec                	mov    %ebp,%esp
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b91:	8b 45 10             	mov    0x10(%ebp),%eax
  800b94:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	89 04 24             	mov    %eax,(%esp)
  800ba5:	e8 65 ff ff ff       	call   800b0f <memmove>
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	57                   	push   %edi
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
  800bb2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bc0:	eb 1c                	jmp    800bde <memcmp+0x32>
		if (*s1 != *s2)
  800bc2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800bc6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800bca:	83 c2 01             	add    $0x1,%edx
  800bcd:	83 e9 01             	sub    $0x1,%ecx
  800bd0:	38 d8                	cmp    %bl,%al
  800bd2:	74 0a                	je     800bde <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800bd4:	0f b6 c0             	movzbl %al,%eax
  800bd7:	0f b6 db             	movzbl %bl,%ebx
  800bda:	29 d8                	sub    %ebx,%eax
  800bdc:	eb 09                	jmp    800be7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bde:	85 c9                	test   %ecx,%ecx
  800be0:	75 e0                	jne    800bc2 <memcmp+0x16>
  800be2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800be7:	5b                   	pop    %ebx
  800be8:	5e                   	pop    %esi
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bf5:	89 c2                	mov    %eax,%edx
  800bf7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bfa:	eb 07                	jmp    800c03 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bfc:	38 08                	cmp    %cl,(%eax)
  800bfe:	74 07                	je     800c07 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c00:	83 c0 01             	add    $0x1,%eax
  800c03:	39 d0                	cmp    %edx,%eax
  800c05:	72 f5                	jb     800bfc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	83 ec 04             	sub    $0x4,%esp
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c18:	eb 03                	jmp    800c1d <strtol+0x14>
		s++;
  800c1a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c1d:	0f b6 02             	movzbl (%edx),%eax
  800c20:	3c 20                	cmp    $0x20,%al
  800c22:	74 f6                	je     800c1a <strtol+0x11>
  800c24:	3c 09                	cmp    $0x9,%al
  800c26:	74 f2                	je     800c1a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c28:	3c 2b                	cmp    $0x2b,%al
  800c2a:	75 0c                	jne    800c38 <strtol+0x2f>
		s++;
  800c2c:	8d 52 01             	lea    0x1(%edx),%edx
  800c2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c36:	eb 15                	jmp    800c4d <strtol+0x44>
	else if (*s == '-')
  800c38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c3f:	3c 2d                	cmp    $0x2d,%al
  800c41:	75 0a                	jne    800c4d <strtol+0x44>
		s++, neg = 1;
  800c43:	8d 52 01             	lea    0x1(%edx),%edx
  800c46:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4d:	85 db                	test   %ebx,%ebx
  800c4f:	0f 94 c0             	sete   %al
  800c52:	74 05                	je     800c59 <strtol+0x50>
  800c54:	83 fb 10             	cmp    $0x10,%ebx
  800c57:	75 15                	jne    800c6e <strtol+0x65>
  800c59:	80 3a 30             	cmpb   $0x30,(%edx)
  800c5c:	75 10                	jne    800c6e <strtol+0x65>
  800c5e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c62:	75 0a                	jne    800c6e <strtol+0x65>
		s += 2, base = 16;
  800c64:	83 c2 02             	add    $0x2,%edx
  800c67:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c6c:	eb 13                	jmp    800c81 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c6e:	84 c0                	test   %al,%al
  800c70:	74 0f                	je     800c81 <strtol+0x78>
  800c72:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800c77:	80 3a 30             	cmpb   $0x30,(%edx)
  800c7a:	75 05                	jne    800c81 <strtol+0x78>
		s++, base = 8;
  800c7c:	83 c2 01             	add    $0x1,%edx
  800c7f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c81:	b8 00 00 00 00       	mov    $0x0,%eax
  800c86:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c88:	0f b6 0a             	movzbl (%edx),%ecx
  800c8b:	89 cf                	mov    %ecx,%edi
  800c8d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c90:	80 fb 09             	cmp    $0x9,%bl
  800c93:	77 08                	ja     800c9d <strtol+0x94>
			dig = *s - '0';
  800c95:	0f be c9             	movsbl %cl,%ecx
  800c98:	83 e9 30             	sub    $0x30,%ecx
  800c9b:	eb 1e                	jmp    800cbb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800c9d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ca0:	80 fb 19             	cmp    $0x19,%bl
  800ca3:	77 08                	ja     800cad <strtol+0xa4>
			dig = *s - 'a' + 10;
  800ca5:	0f be c9             	movsbl %cl,%ecx
  800ca8:	83 e9 57             	sub    $0x57,%ecx
  800cab:	eb 0e                	jmp    800cbb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800cad:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800cb0:	80 fb 19             	cmp    $0x19,%bl
  800cb3:	77 15                	ja     800cca <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb5:	0f be c9             	movsbl %cl,%ecx
  800cb8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cbb:	39 f1                	cmp    %esi,%ecx
  800cbd:	7d 0b                	jge    800cca <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cbf:	83 c2 01             	add    $0x1,%edx
  800cc2:	0f af c6             	imul   %esi,%eax
  800cc5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800cc8:	eb be                	jmp    800c88 <strtol+0x7f>
  800cca:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800ccc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd0:	74 05                	je     800cd7 <strtol+0xce>
		*endptr = (char *) s;
  800cd2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cd5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800cd7:	89 ca                	mov    %ecx,%edx
  800cd9:	f7 da                	neg    %edx
  800cdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cdf:	0f 45 c2             	cmovne %edx,%eax
}
  800ce2:	83 c4 04             	add    $0x4,%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    
	...

00800cec <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	89 1c 24             	mov    %ebx,(%esp)
  800cf5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cf9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	b8 01 00 00 00       	mov    $0x1,%eax
  800d07:	89 d1                	mov    %edx,%ecx
  800d09:	89 d3                	mov    %edx,%ebx
  800d0b:	89 d7                	mov    %edx,%edi
  800d0d:	89 d6                	mov    %edx,%esi
  800d0f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d11:	8b 1c 24             	mov    (%esp),%ebx
  800d14:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d18:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d1c:	89 ec                	mov    %ebp,%esp
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 0c             	sub    $0xc,%esp
  800d26:	89 1c 24             	mov    %ebx,(%esp)
  800d29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d2d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d31:	b8 00 00 00 00       	mov    $0x0,%eax
  800d36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d39:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3c:	89 c3                	mov    %eax,%ebx
  800d3e:	89 c7                	mov    %eax,%edi
  800d40:	89 c6                	mov    %eax,%esi
  800d42:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d44:	8b 1c 24             	mov    (%esp),%ebx
  800d47:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d4b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d4f:	89 ec                	mov    %ebp,%esp
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 0c             	sub    $0xc,%esp
  800d59:	89 1c 24             	mov    %ebx,(%esp)
  800d5c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d60:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d64:	ba 00 00 00 00       	mov    $0x0,%edx
  800d69:	b8 10 00 00 00       	mov    $0x10,%eax
  800d6e:	89 d1                	mov    %edx,%ecx
  800d70:	89 d3                	mov    %edx,%ebx
  800d72:	89 d7                	mov    %edx,%edi
  800d74:	89 d6                	mov    %edx,%esi
  800d76:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d78:	8b 1c 24             	mov    (%esp),%ebx
  800d7b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d7f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d83:	89 ec                	mov    %ebp,%esp
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 38             	sub    $0x38,%esp
  800d8d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d90:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d93:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	89 df                	mov    %ebx,%edi
  800da8:	89 de                	mov    %ebx,%esi
  800daa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	7e 28                	jle    800dd8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800dbb:	00 
  800dbc:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  800dc3:	00 
  800dc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dcb:	00 
  800dcc:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  800dd3:	e8 78 f4 ff ff       	call   800250 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800dd8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ddb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dde:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800de1:	89 ec                	mov    %ebp,%esp
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    

00800de5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 38             	sub    $0x38,%esp
  800deb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	89 df                	mov    %ebx,%edi
  800e06:	89 de                	mov    %ebx,%esi
  800e08:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	7e 28                	jle    800e36 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e12:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800e19:	00 
  800e1a:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  800e21:	00 
  800e22:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e29:	00 
  800e2a:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  800e31:	e8 1a f4 ff ff       	call   800250 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800e36:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e39:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e3c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e3f:	89 ec                	mov    %ebp,%esp
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    

00800e43 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 38             	sub    $0x38,%esp
  800e49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e57:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	89 cb                	mov    %ecx,%ebx
  800e61:	89 cf                	mov    %ecx,%edi
  800e63:	89 ce                	mov    %ecx,%esi
  800e65:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	7e 28                	jle    800e93 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e76:	00 
  800e77:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  800e7e:	00 
  800e7f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e86:	00 
  800e87:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  800e8e:	e8 bd f3 ff ff       	call   800250 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e93:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e96:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e99:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e9c:	89 ec                	mov    %ebp,%esp
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	89 1c 24             	mov    %ebx,(%esp)
  800ea9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ead:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb1:	be 00 00 00 00       	mov    $0x0,%esi
  800eb6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ebb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ebe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec9:	8b 1c 24             	mov    (%esp),%ebx
  800ecc:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ed0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ed4:	89 ec                	mov    %ebp,%esp
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    

00800ed8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	83 ec 38             	sub    $0x38,%esp
  800ede:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ee4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	89 df                	mov    %ebx,%edi
  800ef9:	89 de                	mov    %ebx,%esi
  800efb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800efd:	85 c0                	test   %eax,%eax
  800eff:	7e 28                	jle    800f29 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f01:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f05:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f0c:	00 
  800f0d:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  800f14:	00 
  800f15:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1c:	00 
  800f1d:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  800f24:	e8 27 f3 ff ff       	call   800250 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f29:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f2c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f2f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f32:	89 ec                	mov    %ebp,%esp
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 38             	sub    $0x38,%esp
  800f3c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f3f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f42:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4a:	b8 09 00 00 00       	mov    $0x9,%eax
  800f4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	89 df                	mov    %ebx,%edi
  800f57:	89 de                	mov    %ebx,%esi
  800f59:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	7e 28                	jle    800f87 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f63:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f6a:	00 
  800f6b:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  800f72:	00 
  800f73:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7a:	00 
  800f7b:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  800f82:	e8 c9 f2 ff ff       	call   800250 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f87:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f8a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f8d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f90:	89 ec                	mov    %ebp,%esp
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    

00800f94 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 38             	sub    $0x38,%esp
  800f9a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f9d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa8:	b8 08 00 00 00       	mov    $0x8,%eax
  800fad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	89 df                	mov    %ebx,%edi
  800fb5:	89 de                	mov    %ebx,%esi
  800fb7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	7e 28                	jle    800fe5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fc8:	00 
  800fc9:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  800fd0:	00 
  800fd1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd8:	00 
  800fd9:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  800fe0:	e8 6b f2 ff ff       	call   800250 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fe5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800feb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fee:	89 ec                	mov    %ebp,%esp
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 38             	sub    $0x38,%esp
  800ff8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ffb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ffe:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801001:	bb 00 00 00 00       	mov    $0x0,%ebx
  801006:	b8 06 00 00 00       	mov    $0x6,%eax
  80100b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
  801011:	89 df                	mov    %ebx,%edi
  801013:	89 de                	mov    %ebx,%esi
  801015:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801017:	85 c0                	test   %eax,%eax
  801019:	7e 28                	jle    801043 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80101f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801026:	00 
  801027:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  80102e:	00 
  80102f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801036:	00 
  801037:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  80103e:	e8 0d f2 ff ff       	call   800250 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801043:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801046:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801049:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80104c:	89 ec                	mov    %ebp,%esp
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	83 ec 38             	sub    $0x38,%esp
  801056:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801059:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80105c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105f:	b8 05 00 00 00       	mov    $0x5,%eax
  801064:	8b 75 18             	mov    0x18(%ebp),%esi
  801067:	8b 7d 14             	mov    0x14(%ebp),%edi
  80106a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80106d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801075:	85 c0                	test   %eax,%eax
  801077:	7e 28                	jle    8010a1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801079:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801084:	00 
  801085:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  80108c:	00 
  80108d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801094:	00 
  801095:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  80109c:	e8 af f1 ff ff       	call   800250 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010a1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010a7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010aa:	89 ec                	mov    %ebp,%esp
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    

008010ae <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 38             	sub    $0x38,%esp
  8010b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bd:	be 00 00 00 00       	mov    $0x0,%esi
  8010c2:	b8 04 00 00 00       	mov    $0x4,%eax
  8010c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d0:	89 f7                	mov    %esi,%edi
  8010d2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	7e 28                	jle    801100 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010dc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010e3:	00 
  8010e4:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  8010eb:	00 
  8010ec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f3:	00 
  8010f4:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  8010fb:	e8 50 f1 ff ff       	call   800250 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801100:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801103:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801106:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801109:	89 ec                	mov    %ebp,%esp
  80110b:	5d                   	pop    %ebp
  80110c:	c3                   	ret    

0080110d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	83 ec 0c             	sub    $0xc,%esp
  801113:	89 1c 24             	mov    %ebx,(%esp)
  801116:	89 74 24 04          	mov    %esi,0x4(%esp)
  80111a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111e:	ba 00 00 00 00       	mov    $0x0,%edx
  801123:	b8 0b 00 00 00       	mov    $0xb,%eax
  801128:	89 d1                	mov    %edx,%ecx
  80112a:	89 d3                	mov    %edx,%ebx
  80112c:	89 d7                	mov    %edx,%edi
  80112e:	89 d6                	mov    %edx,%esi
  801130:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801132:	8b 1c 24             	mov    (%esp),%ebx
  801135:	8b 74 24 04          	mov    0x4(%esp),%esi
  801139:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80113d:	89 ec                	mov    %ebp,%esp
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    

00801141 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 0c             	sub    $0xc,%esp
  801147:	89 1c 24             	mov    %ebx,(%esp)
  80114a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80114e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801152:	ba 00 00 00 00       	mov    $0x0,%edx
  801157:	b8 02 00 00 00       	mov    $0x2,%eax
  80115c:	89 d1                	mov    %edx,%ecx
  80115e:	89 d3                	mov    %edx,%ebx
  801160:	89 d7                	mov    %edx,%edi
  801162:	89 d6                	mov    %edx,%esi
  801164:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801166:	8b 1c 24             	mov    (%esp),%ebx
  801169:	8b 74 24 04          	mov    0x4(%esp),%esi
  80116d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801171:	89 ec                	mov    %ebp,%esp
  801173:	5d                   	pop    %ebp
  801174:	c3                   	ret    

00801175 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 38             	sub    $0x38,%esp
  80117b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80117e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801181:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801184:	b9 00 00 00 00       	mov    $0x0,%ecx
  801189:	b8 03 00 00 00       	mov    $0x3,%eax
  80118e:	8b 55 08             	mov    0x8(%ebp),%edx
  801191:	89 cb                	mov    %ecx,%ebx
  801193:	89 cf                	mov    %ecx,%edi
  801195:	89 ce                	mov    %ecx,%esi
  801197:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801199:	85 c0                	test   %eax,%eax
  80119b:	7e 28                	jle    8011c5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80119d:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8011a8:	00 
  8011a9:	c7 44 24 08 c7 31 80 	movl   $0x8031c7,0x8(%esp)
  8011b0:	00 
  8011b1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011b8:	00 
  8011b9:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  8011c0:	e8 8b f0 ff ff       	call   800250 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011c5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011c8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011cb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011ce:	89 ec                	mov    %ebp,%esp
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    
	...

008011d4 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8011da:	c7 44 24 08 f2 31 80 	movl   $0x8031f2,0x8(%esp)
  8011e1:	00 
  8011e2:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  8011e9:	00 
  8011ea:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  8011f1:	e8 5a f0 ff ff       	call   800250 <_panic>

008011f6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	57                   	push   %edi
  8011fa:	56                   	push   %esi
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  8011ff:	c7 04 24 64 14 80 00 	movl   $0x801464,(%esp)
  801206:	e8 19 17 00 00       	call   802924 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80120b:	ba 07 00 00 00       	mov    $0x7,%edx
  801210:	89 d0                	mov    %edx,%eax
  801212:	cd 30                	int    $0x30
  801214:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801217:	85 c0                	test   %eax,%eax
  801219:	79 20                	jns    80123b <fork+0x45>
		panic("sys_exofork: %e", envid);
  80121b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80121f:	c7 44 24 08 13 32 80 	movl   $0x803213,0x8(%esp)
  801226:	00 
  801227:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80122e:	00 
  80122f:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  801236:	e8 15 f0 ff ff       	call   800250 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  80123b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801242:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801247:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80124b:	75 21                	jne    80126e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80124d:	e8 ef fe ff ff       	call   801141 <sys_getenvid>
  801252:	25 ff 03 00 00       	and    $0x3ff,%eax
  801257:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80125a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80125f:	a3 08 50 80 00       	mov    %eax,0x805008
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801269:	e9 e5 01 00 00       	jmp    801453 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80126e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801271:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801278:	a8 01                	test   $0x1,%al
  80127a:	0f 84 4c 01 00 00    	je     8013cc <fork+0x1d6>
  801280:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801286:	0f 84 cf 01 00 00    	je     80145b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  80128c:	c1 e2 16             	shl    $0x16,%edx
  80128f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801292:	89 d3                	mov    %edx,%ebx
  801294:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80129b:	00 
  80129c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012a3:	89 04 24             	mov    %eax,(%esp)
  8012a6:	e8 03 fe ff ff       	call   8010ae <sys_page_alloc>
			if(ret < 0) return ret;
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	0f 88 a0 01 00 00    	js     801453 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  8012b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8012ba:	89 14 24             	mov    %edx,(%esp)
  8012bd:	e8 30 fd ff ff       	call   800ff2 <sys_page_unmap>
			if(ret < 0) return ret;
  8012c2:	85 c0                	test   %eax,%eax
  8012c4:	0f 88 89 01 00 00    	js     801453 <fork+0x25d>
  8012ca:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  8012cf:	89 de                	mov    %ebx,%esi
  8012d1:	c1 e6 0c             	shl    $0xc,%esi
  8012d4:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  8012d7:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  8012dd:	0f 84 da 00 00 00    	je     8013bd <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8012e3:	c1 ee 0c             	shr    $0xc,%esi
  8012e6:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8012e9:	a8 01                	test   $0x1,%al
  8012eb:	0f 84 cc 00 00 00    	je     8013bd <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  8012f1:	89 f0                	mov    %esi,%eax
  8012f3:	c1 e0 0c             	shl    $0xc,%eax
  8012f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  8012f9:	e8 43 fe ff ff       	call   801141 <sys_getenvid>
  8012fe:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801301:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801304:	89 c6                	mov    %eax,%esi
  801306:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  80130c:	25 01 04 00 00       	and    $0x401,%eax
  801311:	3d 01 04 00 00       	cmp    $0x401,%eax
  801316:	75 3a                	jne    801352 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801318:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80131f:	00 
  801320:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801323:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801327:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80132a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80132e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801332:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801335:	89 14 24             	mov    %edx,(%esp)
  801338:	e8 13 fd ff ff       	call   801050 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  80133d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801340:	89 44 24 04          	mov    %eax,0x4(%esp)
  801344:	c7 04 24 23 32 80 00 	movl   $0x803223,(%esp)
  80134b:	e8 b9 ef ff ff       	call   800309 <cprintf>
  801350:	eb 6b                	jmp    8013bd <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801352:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801358:	74 14                	je     80136e <fork+0x178>
  80135a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801360:	74 0c                	je     80136e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801362:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801368:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80136e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801371:	89 74 24 10          	mov    %esi,0x10(%esp)
  801375:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801379:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80137c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801380:	89 54 24 04          	mov    %edx,0x4(%esp)
  801384:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801387:	89 14 24             	mov    %edx,(%esp)
  80138a:	e8 c1 fc ff ff       	call   801050 <sys_page_map>
	if(ret<0) return ret;
  80138f:	85 c0                	test   %eax,%eax
  801391:	0f 88 bc 00 00 00    	js     801453 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801397:	89 74 24 10          	mov    %esi,0x10(%esp)
  80139b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ad:	89 14 24             	mov    %edx,(%esp)
  8013b0:	e8 9b fc ff ff       	call   801050 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	0f 88 96 00 00 00    	js     801453 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  8013bd:	83 c3 01             	add    $0x1,%ebx
  8013c0:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8013c6:	0f 85 03 ff ff ff    	jne    8012cf <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8013cc:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  8013d0:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  8013d7:	0f 85 91 fe ff ff    	jne    80126e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  8013dd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013e4:	00 
  8013e5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013ec:	ee 
  8013ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013f0:	89 04 24             	mov    %eax,(%esp)
  8013f3:	e8 b6 fc ff ff       	call   8010ae <sys_page_alloc>
	if(ret < 0) return ret;
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	78 57                	js     801453 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  8013fc:	a1 08 50 80 00       	mov    0x805008,%eax
  801401:	8b 40 64             	mov    0x64(%eax),%eax
  801404:	89 44 24 04          	mov    %eax,0x4(%esp)
  801408:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80140b:	89 14 24             	mov    %edx,(%esp)
  80140e:	e8 c5 fa ff ff       	call   800ed8 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801413:	85 c0                	test   %eax,%eax
  801415:	78 3c                	js     801453 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801417:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80141e:	00 
  80141f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801422:	89 04 24             	mov    %eax,(%esp)
  801425:	e8 6a fb ff ff       	call   800f94 <sys_env_set_status>
  80142a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  80142c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80142f:	85 d2                	test   %edx,%edx
  801431:	79 20                	jns    801453 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801433:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801437:	c7 44 24 08 3a 32 80 	movl   $0x80323a,0x8(%esp)
  80143e:	00 
  80143f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801446:	00 
  801447:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  80144e:	e8 fd ed ff ff       	call   800250 <_panic>

	return envid;
}
  801453:	83 c4 4c             	add    $0x4c,%esp
  801456:	5b                   	pop    %ebx
  801457:	5e                   	pop    %esi
  801458:	5f                   	pop    %edi
  801459:	5d                   	pop    %ebp
  80145a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80145b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80145f:	e9 0a fe ff ff       	jmp    80126e <fork+0x78>

00801464 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	56                   	push   %esi
  801468:	53                   	push   %ebx
  801469:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80146c:	e8 d0 fc ff ff       	call   801141 <sys_getenvid>
  801471:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8b 00                	mov    (%eax),%eax
  801478:	89 c6                	mov    %eax,%esi
  80147a:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  80147d:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801484:	f6 c2 02             	test   $0x2,%dl
  801487:	75 2c                	jne    8014b5 <pgfault+0x51>
  801489:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801490:	f6 c6 08             	test   $0x8,%dh
  801493:	75 20                	jne    8014b5 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801495:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801499:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  8014a0:	00 
  8014a1:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8014a8:	00 
  8014a9:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  8014b0:	e8 9b ed ff ff       	call   800250 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8014b5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014bc:	00 
  8014bd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8014c4:	00 
  8014c5:	89 1c 24             	mov    %ebx,(%esp)
  8014c8:	e8 e1 fb ff ff       	call   8010ae <sys_page_alloc>
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	79 20                	jns    8014f1 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  8014d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d5:	c7 44 24 08 51 32 80 	movl   $0x803251,0x8(%esp)
  8014dc:	00 
  8014dd:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8014e4:	00 
  8014e5:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  8014ec:	e8 5f ed ff ff       	call   800250 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  8014f1:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  8014f4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014fb:	00 
  8014fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801500:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801507:	e8 03 f6 ff ff       	call   800b0f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80150c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801513:	00 
  801514:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801518:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80151c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801523:	00 
  801524:	89 1c 24             	mov    %ebx,(%esp)
  801527:	e8 24 fb ff ff       	call   801050 <sys_page_map>
  80152c:	85 c0                	test   %eax,%eax
  80152e:	79 20                	jns    801550 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801530:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801534:	c7 44 24 08 63 32 80 	movl   $0x803263,0x8(%esp)
  80153b:	00 
  80153c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801543:	00 
  801544:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  80154b:	e8 00 ed ff ff       	call   800250 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801550:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801557:	00 
  801558:	89 1c 24             	mov    %ebx,(%esp)
  80155b:	e8 92 fa ff ff       	call   800ff2 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801560:	85 c0                	test   %eax,%eax
  801562:	74 20                	je     801584 <pgfault+0x120>
  801564:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801568:	c7 44 24 08 73 32 80 	movl   $0x803273,0x8(%esp)
  80156f:	00 
  801570:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801577:	00 
  801578:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  80157f:	e8 cc ec ff ff       	call   800250 <_panic>

}
  801584:	83 c4 20             	add    $0x20,%esp
  801587:	5b                   	pop    %ebx
  801588:	5e                   	pop    %esi
  801589:	5d                   	pop    %ebp
  80158a:	c3                   	ret    
	...

0080158c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	05 00 00 00 30       	add    $0x30000000,%eax
  801597:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 04 24             	mov    %eax,(%esp)
  8015a8:	e8 df ff ff ff       	call   80158c <fd2num>
  8015ad:	05 20 00 0d 00       	add    $0xd0020,%eax
  8015b2:	c1 e0 0c             	shl    $0xc,%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	57                   	push   %edi
  8015bb:	56                   	push   %esi
  8015bc:	53                   	push   %ebx
  8015bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015c0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015c5:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8015ca:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015cf:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015d1:	89 c2                	mov    %eax,%edx
  8015d3:	c1 ea 16             	shr    $0x16,%edx
  8015d6:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8015d9:	f6 c2 01             	test   $0x1,%dl
  8015dc:	74 0d                	je     8015eb <fd_alloc+0x34>
  8015de:	89 c2                	mov    %eax,%edx
  8015e0:	c1 ea 0c             	shr    $0xc,%edx
  8015e3:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  8015e6:	f6 c2 01             	test   $0x1,%dl
  8015e9:	75 09                	jne    8015f4 <fd_alloc+0x3d>
			*fd_store = fd;
  8015eb:	89 37                	mov    %esi,(%edi)
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8015f2:	eb 17                	jmp    80160b <fd_alloc+0x54>
  8015f4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015f9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015fe:	75 cf                	jne    8015cf <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801600:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801606:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  80160b:	5b                   	pop    %ebx
  80160c:	5e                   	pop    %esi
  80160d:	5f                   	pop    %edi
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    

00801610 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	83 f8 1f             	cmp    $0x1f,%eax
  801619:	77 36                	ja     801651 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80161b:	05 00 00 0d 00       	add    $0xd0000,%eax
  801620:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801623:	89 c2                	mov    %eax,%edx
  801625:	c1 ea 16             	shr    $0x16,%edx
  801628:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80162f:	f6 c2 01             	test   $0x1,%dl
  801632:	74 1d                	je     801651 <fd_lookup+0x41>
  801634:	89 c2                	mov    %eax,%edx
  801636:	c1 ea 0c             	shr    $0xc,%edx
  801639:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801640:	f6 c2 01             	test   $0x1,%dl
  801643:	74 0c                	je     801651 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	89 02                	mov    %eax,(%edx)
  80164a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80164f:	eb 05                	jmp    801656 <fd_lookup+0x46>
  801651:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80165e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801661:	89 44 24 04          	mov    %eax,0x4(%esp)
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	89 04 24             	mov    %eax,(%esp)
  80166b:	e8 a0 ff ff ff       	call   801610 <fd_lookup>
  801670:	85 c0                	test   %eax,%eax
  801672:	78 0e                	js     801682 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167a:	89 50 04             	mov    %edx,0x4(%eax)
  80167d:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	83 ec 10             	sub    $0x10,%esp
  80168c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801692:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801697:	be 2c 33 80 00       	mov    $0x80332c,%esi
  80169c:	eb 10                	jmp    8016ae <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  80169e:	39 08                	cmp    %ecx,(%eax)
  8016a0:	75 09                	jne    8016ab <dev_lookup+0x27>
			*dev = devtab[i];
  8016a2:	89 03                	mov    %eax,(%ebx)
  8016a4:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8016a9:	eb 31                	jmp    8016dc <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016ab:	83 c2 01             	add    $0x1,%edx
  8016ae:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	75 e9                	jne    80169e <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016b5:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ba:	8b 40 48             	mov    0x48(%eax),%eax
  8016bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c5:	c7 04 24 ac 32 80 00 	movl   $0x8032ac,(%esp)
  8016cc:	e8 38 ec ff ff       	call   800309 <cprintf>
	*dev = 0;
  8016d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	53                   	push   %ebx
  8016e7:	83 ec 24             	sub    $0x24,%esp
  8016ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	89 04 24             	mov    %eax,(%esp)
  8016fa:	e8 11 ff ff ff       	call   801610 <fd_lookup>
  8016ff:	85 c0                	test   %eax,%eax
  801701:	78 53                	js     801756 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801703:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801706:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170d:	8b 00                	mov    (%eax),%eax
  80170f:	89 04 24             	mov    %eax,(%esp)
  801712:	e8 6d ff ff ff       	call   801684 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801717:	85 c0                	test   %eax,%eax
  801719:	78 3b                	js     801756 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  80171b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801720:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801723:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801727:	74 2d                	je     801756 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801729:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80172c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801733:	00 00 00 
	stat->st_isdir = 0;
  801736:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80173d:	00 00 00 
	stat->st_dev = dev;
  801740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801743:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801749:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80174d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801750:	89 14 24             	mov    %edx,(%esp)
  801753:	ff 50 14             	call   *0x14(%eax)
}
  801756:	83 c4 24             	add    $0x24,%esp
  801759:	5b                   	pop    %ebx
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    

0080175c <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	53                   	push   %ebx
  801760:	83 ec 24             	sub    $0x24,%esp
  801763:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801766:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801769:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176d:	89 1c 24             	mov    %ebx,(%esp)
  801770:	e8 9b fe ff ff       	call   801610 <fd_lookup>
  801775:	85 c0                	test   %eax,%eax
  801777:	78 5f                	js     8017d8 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801779:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801783:	8b 00                	mov    (%eax),%eax
  801785:	89 04 24             	mov    %eax,(%esp)
  801788:	e8 f7 fe ff ff       	call   801684 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178d:	85 c0                	test   %eax,%eax
  80178f:	78 47                	js     8017d8 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801791:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801794:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801798:	75 23                	jne    8017bd <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80179a:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80179f:	8b 40 48             	mov    0x48(%eax),%eax
  8017a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017aa:	c7 04 24 cc 32 80 00 	movl   $0x8032cc,(%esp)
  8017b1:	e8 53 eb ff ff       	call   800309 <cprintf>
  8017b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017bb:	eb 1b                	jmp    8017d8 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8017bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c0:	8b 48 18             	mov    0x18(%eax),%ecx
  8017c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c8:	85 c9                	test   %ecx,%ecx
  8017ca:	74 0c                	je     8017d8 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d3:	89 14 24             	mov    %edx,(%esp)
  8017d6:	ff d1                	call   *%ecx
}
  8017d8:	83 c4 24             	add    $0x24,%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5d                   	pop    %ebp
  8017dd:	c3                   	ret    

008017de <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 24             	sub    $0x24,%esp
  8017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ef:	89 1c 24             	mov    %ebx,(%esp)
  8017f2:	e8 19 fe ff ff       	call   801610 <fd_lookup>
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 66                	js     801861 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	8b 00                	mov    (%eax),%eax
  801807:	89 04 24             	mov    %eax,(%esp)
  80180a:	e8 75 fe ff ff       	call   801684 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 4e                	js     801861 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801813:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801816:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80181a:	75 23                	jne    80183f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80181c:	a1 08 50 80 00       	mov    0x805008,%eax
  801821:	8b 40 48             	mov    0x48(%eax),%eax
  801824:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182c:	c7 04 24 f0 32 80 00 	movl   $0x8032f0,(%esp)
  801833:	e8 d1 ea ff ff       	call   800309 <cprintf>
  801838:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  80183d:	eb 22                	jmp    801861 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801842:	8b 48 0c             	mov    0xc(%eax),%ecx
  801845:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80184a:	85 c9                	test   %ecx,%ecx
  80184c:	74 13                	je     801861 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80184e:	8b 45 10             	mov    0x10(%ebp),%eax
  801851:	89 44 24 08          	mov    %eax,0x8(%esp)
  801855:	8b 45 0c             	mov    0xc(%ebp),%eax
  801858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185c:	89 14 24             	mov    %edx,(%esp)
  80185f:	ff d1                	call   *%ecx
}
  801861:	83 c4 24             	add    $0x24,%esp
  801864:	5b                   	pop    %ebx
  801865:	5d                   	pop    %ebp
  801866:	c3                   	ret    

00801867 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	53                   	push   %ebx
  80186b:	83 ec 24             	sub    $0x24,%esp
  80186e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801871:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801874:	89 44 24 04          	mov    %eax,0x4(%esp)
  801878:	89 1c 24             	mov    %ebx,(%esp)
  80187b:	e8 90 fd ff ff       	call   801610 <fd_lookup>
  801880:	85 c0                	test   %eax,%eax
  801882:	78 6b                	js     8018ef <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801884:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801887:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188e:	8b 00                	mov    (%eax),%eax
  801890:	89 04 24             	mov    %eax,(%esp)
  801893:	e8 ec fd ff ff       	call   801684 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801898:	85 c0                	test   %eax,%eax
  80189a:	78 53                	js     8018ef <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80189c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80189f:	8b 42 08             	mov    0x8(%edx),%eax
  8018a2:	83 e0 03             	and    $0x3,%eax
  8018a5:	83 f8 01             	cmp    $0x1,%eax
  8018a8:	75 23                	jne    8018cd <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8018af:	8b 40 48             	mov    0x48(%eax),%eax
  8018b2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ba:	c7 04 24 0d 33 80 00 	movl   $0x80330d,(%esp)
  8018c1:	e8 43 ea ff ff       	call   800309 <cprintf>
  8018c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8018cb:	eb 22                	jmp    8018ef <read+0x88>
	}
	if (!dev->dev_read)
  8018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d0:	8b 48 08             	mov    0x8(%eax),%ecx
  8018d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d8:	85 c9                	test   %ecx,%ecx
  8018da:	74 13                	je     8018ef <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ea:	89 14 24             	mov    %edx,(%esp)
  8018ed:	ff d1                	call   *%ecx
}
  8018ef:	83 c4 24             	add    $0x24,%esp
  8018f2:	5b                   	pop    %ebx
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    

008018f5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	57                   	push   %edi
  8018f9:	56                   	push   %esi
  8018fa:	53                   	push   %ebx
  8018fb:	83 ec 1c             	sub    $0x1c,%esp
  8018fe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801901:	8b 75 10             	mov    0x10(%ebp),%esi
  801904:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801909:	eb 21                	jmp    80192c <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80190b:	89 f2                	mov    %esi,%edx
  80190d:	29 c2                	sub    %eax,%edx
  80190f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801913:	03 45 0c             	add    0xc(%ebp),%eax
  801916:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191a:	89 3c 24             	mov    %edi,(%esp)
  80191d:	e8 45 ff ff ff       	call   801867 <read>
		if (m < 0)
  801922:	85 c0                	test   %eax,%eax
  801924:	78 0e                	js     801934 <readn+0x3f>
			return m;
		if (m == 0)
  801926:	85 c0                	test   %eax,%eax
  801928:	74 08                	je     801932 <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80192a:	01 c3                	add    %eax,%ebx
  80192c:	89 d8                	mov    %ebx,%eax
  80192e:	39 f3                	cmp    %esi,%ebx
  801930:	72 d9                	jb     80190b <readn+0x16>
  801932:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801934:	83 c4 1c             	add    $0x1c,%esp
  801937:	5b                   	pop    %ebx
  801938:	5e                   	pop    %esi
  801939:	5f                   	pop    %edi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 38             	sub    $0x38,%esp
  801942:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801945:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801948:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80194b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80194e:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801952:	89 3c 24             	mov    %edi,(%esp)
  801955:	e8 32 fc ff ff       	call   80158c <fd2num>
  80195a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80195d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801961:	89 04 24             	mov    %eax,(%esp)
  801964:	e8 a7 fc ff ff       	call   801610 <fd_lookup>
  801969:	89 c3                	mov    %eax,%ebx
  80196b:	85 c0                	test   %eax,%eax
  80196d:	78 05                	js     801974 <fd_close+0x38>
  80196f:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801972:	74 0e                	je     801982 <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801974:	89 f0                	mov    %esi,%eax
  801976:	84 c0                	test   %al,%al
  801978:	b8 00 00 00 00       	mov    $0x0,%eax
  80197d:	0f 44 d8             	cmove  %eax,%ebx
  801980:	eb 3d                	jmp    8019bf <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801982:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801985:	89 44 24 04          	mov    %eax,0x4(%esp)
  801989:	8b 07                	mov    (%edi),%eax
  80198b:	89 04 24             	mov    %eax,(%esp)
  80198e:	e8 f1 fc ff ff       	call   801684 <dev_lookup>
  801993:	89 c3                	mov    %eax,%ebx
  801995:	85 c0                	test   %eax,%eax
  801997:	78 16                	js     8019af <fd_close+0x73>
		if (dev->dev_close)
  801999:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80199c:	8b 40 10             	mov    0x10(%eax),%eax
  80199f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	74 07                	je     8019af <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8019a8:	89 3c 24             	mov    %edi,(%esp)
  8019ab:	ff d0                	call   *%eax
  8019ad:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8019af:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ba:	e8 33 f6 ff ff       	call   800ff2 <sys_page_unmap>
	return r;
}
  8019bf:	89 d8                	mov    %ebx,%eax
  8019c1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019c4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019ca:	89 ec                	mov    %ebp,%esp
  8019cc:	5d                   	pop    %ebp
  8019cd:	c3                   	ret    

008019ce <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	89 04 24             	mov    %eax,(%esp)
  8019e1:	e8 2a fc ff ff       	call   801610 <fd_lookup>
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 13                	js     8019fd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8019ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019f1:	00 
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	89 04 24             	mov    %eax,(%esp)
  8019f8:	e8 3f ff ff ff       	call   80193c <fd_close>
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 18             	sub    $0x18,%esp
  801a05:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a08:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a12:	00 
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	89 04 24             	mov    %eax,(%esp)
  801a19:	e8 25 04 00 00       	call   801e43 <open>
  801a1e:	89 c3                	mov    %eax,%ebx
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 1b                	js     801a3f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2b:	89 1c 24             	mov    %ebx,(%esp)
  801a2e:	e8 b0 fc ff ff       	call   8016e3 <fstat>
  801a33:	89 c6                	mov    %eax,%esi
	close(fd);
  801a35:	89 1c 24             	mov    %ebx,(%esp)
  801a38:	e8 91 ff ff ff       	call   8019ce <close>
  801a3d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801a3f:	89 d8                	mov    %ebx,%eax
  801a41:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a44:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a47:	89 ec                	mov    %ebp,%esp
  801a49:	5d                   	pop    %ebp
  801a4a:	c3                   	ret    

00801a4b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	53                   	push   %ebx
  801a4f:	83 ec 14             	sub    $0x14,%esp
  801a52:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801a57:	89 1c 24             	mov    %ebx,(%esp)
  801a5a:	e8 6f ff ff ff       	call   8019ce <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801a5f:	83 c3 01             	add    $0x1,%ebx
  801a62:	83 fb 20             	cmp    $0x20,%ebx
  801a65:	75 f0                	jne    801a57 <close_all+0xc>
		close(i);
}
  801a67:	83 c4 14             	add    $0x14,%esp
  801a6a:	5b                   	pop    %ebx
  801a6b:	5d                   	pop    %ebp
  801a6c:	c3                   	ret    

00801a6d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 58             	sub    $0x58,%esp
  801a73:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a76:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a79:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a7f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	89 04 24             	mov    %eax,(%esp)
  801a8c:	e8 7f fb ff ff       	call   801610 <fd_lookup>
  801a91:	89 c3                	mov    %eax,%ebx
  801a93:	85 c0                	test   %eax,%eax
  801a95:	0f 88 e0 00 00 00    	js     801b7b <dup+0x10e>
		return r;
	close(newfdnum);
  801a9b:	89 3c 24             	mov    %edi,(%esp)
  801a9e:	e8 2b ff ff ff       	call   8019ce <close>

	newfd = INDEX2FD(newfdnum);
  801aa3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801aa9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801aac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aaf:	89 04 24             	mov    %eax,(%esp)
  801ab2:	e8 e5 fa ff ff       	call   80159c <fd2data>
  801ab7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801ab9:	89 34 24             	mov    %esi,(%esp)
  801abc:	e8 db fa ff ff       	call   80159c <fd2data>
  801ac1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ac4:	89 da                	mov    %ebx,%edx
  801ac6:	89 d8                	mov    %ebx,%eax
  801ac8:	c1 e8 16             	shr    $0x16,%eax
  801acb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ad2:	a8 01                	test   $0x1,%al
  801ad4:	74 43                	je     801b19 <dup+0xac>
  801ad6:	c1 ea 0c             	shr    $0xc,%edx
  801ad9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801ae0:	a8 01                	test   $0x1,%al
  801ae2:	74 35                	je     801b19 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ae4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801aeb:	25 07 0e 00 00       	and    $0xe07,%eax
  801af0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801af4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801af7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801afb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b02:	00 
  801b03:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b0e:	e8 3d f5 ff ff       	call   801050 <sys_page_map>
  801b13:	89 c3                	mov    %eax,%ebx
  801b15:	85 c0                	test   %eax,%eax
  801b17:	78 3f                	js     801b58 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b1c:	89 c2                	mov    %eax,%edx
  801b1e:	c1 ea 0c             	shr    $0xc,%edx
  801b21:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b28:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801b2e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801b32:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801b36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b3d:	00 
  801b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b49:	e8 02 f5 ff ff       	call   801050 <sys_page_map>
  801b4e:	89 c3                	mov    %eax,%ebx
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 04                	js     801b58 <dup+0xeb>
  801b54:	89 fb                	mov    %edi,%ebx
  801b56:	eb 23                	jmp    801b7b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b58:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b63:	e8 8a f4 ff ff       	call   800ff2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b76:	e8 77 f4 ff ff       	call   800ff2 <sys_page_unmap>
	return r;
}
  801b7b:	89 d8                	mov    %ebx,%eax
  801b7d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b80:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b83:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b86:	89 ec                	mov    %ebp,%esp
  801b88:	5d                   	pop    %ebp
  801b89:	c3                   	ret    
	...

00801b8c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	56                   	push   %esi
  801b90:	53                   	push   %ebx
  801b91:	83 ec 10             	sub    $0x10,%esp
  801b94:	89 c3                	mov    %eax,%ebx
  801b96:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801b98:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b9f:	75 11                	jne    801bb2 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ba1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801ba8:	e8 1b 0e 00 00       	call   8029c8 <ipc_find_env>
  801bad:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801bb2:	a1 08 50 80 00       	mov    0x805008,%eax
  801bb7:	8b 40 48             	mov    0x48(%eax),%eax
  801bba:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801bc0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801bc4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcc:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  801bd3:	e8 31 e7 ff ff       	call   800309 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bd8:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bdf:	00 
  801be0:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801be7:	00 
  801be8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bec:	a1 00 50 80 00       	mov    0x805000,%eax
  801bf1:	89 04 24             	mov    %eax,(%esp)
  801bf4:	e8 05 0e 00 00       	call   8029fe <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bf9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c00:	00 
  801c01:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0c:	e8 59 0e 00 00       	call   802a6a <ipc_recv>
}
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	5b                   	pop    %ebx
  801c15:	5e                   	pop    %esi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    

00801c18 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	8b 40 0c             	mov    0xc(%eax),%eax
  801c24:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c31:	ba 00 00 00 00       	mov    $0x0,%edx
  801c36:	b8 02 00 00 00       	mov    $0x2,%eax
  801c3b:	e8 4c ff ff ff       	call   801b8c <fsipc>
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c4e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c53:	ba 00 00 00 00       	mov    $0x0,%edx
  801c58:	b8 06 00 00 00       	mov    $0x6,%eax
  801c5d:	e8 2a ff ff ff       	call   801b8c <fsipc>
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6f:	b8 08 00 00 00       	mov    $0x8,%eax
  801c74:	e8 13 ff ff ff       	call   801b8c <fsipc>
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	53                   	push   %ebx
  801c7f:	83 ec 14             	sub    $0x14,%esp
  801c82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c90:	ba 00 00 00 00       	mov    $0x0,%edx
  801c95:	b8 05 00 00 00       	mov    $0x5,%eax
  801c9a:	e8 ed fe ff ff       	call   801b8c <fsipc>
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 2b                	js     801cce <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ca3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801caa:	00 
  801cab:	89 1c 24             	mov    %ebx,(%esp)
  801cae:	e8 b6 ec ff ff       	call   800969 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cb3:	a1 80 60 80 00       	mov    0x806080,%eax
  801cb8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cbe:	a1 84 60 80 00       	mov    0x806084,%eax
  801cc3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801cce:	83 c4 14             	add    $0x14,%esp
  801cd1:	5b                   	pop    %ebx
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    

00801cd4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 14             	sub    $0x14,%esp
  801cdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ce9:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801cef:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801cf5:	76 24                	jbe    801d1b <devfile_write+0x47>
  801cf7:	c7 44 24 0c 56 33 80 	movl   $0x803356,0xc(%esp)
  801cfe:	00 
  801cff:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  801d06:	00 
  801d07:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801d0e:	00 
  801d0f:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801d16:	e8 35 e5 ff ff       	call   800250 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801d1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d26:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801d2d:	e8 dd ed ff ff       	call   800b0f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801d32:	ba 00 00 00 00       	mov    $0x0,%edx
  801d37:	b8 04 00 00 00       	mov    $0x4,%eax
  801d3c:	e8 4b fe ff ff       	call   801b8c <fsipc>
	if(ret<0) return ret;
  801d41:	85 c0                	test   %eax,%eax
  801d43:	78 53                	js     801d98 <devfile_write+0xc4>
	
	assert(ret <= n);
  801d45:	39 c3                	cmp    %eax,%ebx
  801d47:	73 24                	jae    801d6d <devfile_write+0x99>
  801d49:	c7 44 24 0c 80 33 80 	movl   $0x803380,0xc(%esp)
  801d50:	00 
  801d51:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  801d58:	00 
  801d59:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801d60:	00 
  801d61:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801d68:	e8 e3 e4 ff ff       	call   800250 <_panic>
	assert(ret <= PGSIZE);
  801d6d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d72:	7e 24                	jle    801d98 <devfile_write+0xc4>
  801d74:	c7 44 24 0c 89 33 80 	movl   $0x803389,0xc(%esp)
  801d7b:	00 
  801d7c:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  801d83:	00 
  801d84:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801d8b:	00 
  801d8c:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801d93:	e8 b8 e4 ff ff       	call   800250 <_panic>
	return ret;
}
  801d98:	83 c4 14             	add    $0x14,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5d                   	pop    %ebp
  801d9d:	c3                   	ret    

00801d9e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	56                   	push   %esi
  801da2:	53                   	push   %ebx
  801da3:	83 ec 10             	sub    $0x10,%esp
  801da6:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	8b 40 0c             	mov    0xc(%eax),%eax
  801daf:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801db4:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dba:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbf:	b8 03 00 00 00       	mov    $0x3,%eax
  801dc4:	e8 c3 fd ff ff       	call   801b8c <fsipc>
  801dc9:	89 c3                	mov    %eax,%ebx
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 6b                	js     801e3a <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801dcf:	39 de                	cmp    %ebx,%esi
  801dd1:	73 24                	jae    801df7 <devfile_read+0x59>
  801dd3:	c7 44 24 0c 97 33 80 	movl   $0x803397,0xc(%esp)
  801dda:	00 
  801ddb:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  801de2:	00 
  801de3:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801dea:	00 
  801deb:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801df2:	e8 59 e4 ff ff       	call   800250 <_panic>
	assert(r <= PGSIZE);
  801df7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801dfd:	7e 24                	jle    801e23 <devfile_read+0x85>
  801dff:	c7 44 24 0c 9e 33 80 	movl   $0x80339e,0xc(%esp)
  801e06:	00 
  801e07:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  801e0e:	00 
  801e0f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e16:	00 
  801e17:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801e1e:	e8 2d e4 ff ff       	call   800250 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e23:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e27:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e2e:	00 
  801e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e32:	89 04 24             	mov    %eax,(%esp)
  801e35:	e8 d5 ec ff ff       	call   800b0f <memmove>
	return r;
}
  801e3a:	89 d8                	mov    %ebx,%eax
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	5b                   	pop    %ebx
  801e40:	5e                   	pop    %esi
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    

00801e43 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 28             	sub    $0x28,%esp
  801e49:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e4c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e4f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e52:	89 34 24             	mov    %esi,(%esp)
  801e55:	e8 d6 ea ff ff       	call   800930 <strlen>
  801e5a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e5f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e64:	7f 5e                	jg     801ec4 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e69:	89 04 24             	mov    %eax,(%esp)
  801e6c:	e8 46 f7 ff ff       	call   8015b7 <fd_alloc>
  801e71:	89 c3                	mov    %eax,%ebx
  801e73:	85 c0                	test   %eax,%eax
  801e75:	78 4d                	js     801ec4 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e77:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e7b:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e82:	e8 e2 ea ff ff       	call   800969 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8a:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e92:	b8 01 00 00 00       	mov    $0x1,%eax
  801e97:	e8 f0 fc ff ff       	call   801b8c <fsipc>
  801e9c:	89 c3                	mov    %eax,%ebx
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	79 15                	jns    801eb7 <open+0x74>
		fd_close(fd, 0);
  801ea2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ea9:	00 
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	89 04 24             	mov    %eax,(%esp)
  801eb0:	e8 87 fa ff ff       	call   80193c <fd_close>
		return r;
  801eb5:	eb 0d                	jmp    801ec4 <open+0x81>
	}

	return fd2num(fd);
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	89 04 24             	mov    %eax,(%esp)
  801ebd:	e8 ca f6 ff ff       	call   80158c <fd2num>
  801ec2:	89 c3                	mov    %eax,%ebx
}
  801ec4:	89 d8                	mov    %ebx,%eax
  801ec6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ec9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ecc:	89 ec                	mov    %ebp,%esp
  801ece:	5d                   	pop    %ebp
  801ecf:	c3                   	ret    

00801ed0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ed6:	c7 44 24 04 aa 33 80 	movl   $0x8033aa,0x4(%esp)
  801edd:	00 
  801ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee1:	89 04 24             	mov    %eax,(%esp)
  801ee4:	e8 80 ea ff ff       	call   800969 <strcpy>
	return 0;
}
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	53                   	push   %ebx
  801ef4:	83 ec 14             	sub    $0x14,%esp
  801ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801efa:	89 1c 24             	mov    %ebx,(%esp)
  801efd:	e8 f2 0b 00 00       	call   802af4 <pageref>
  801f02:	89 c2                	mov    %eax,%edx
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
  801f09:	83 fa 01             	cmp    $0x1,%edx
  801f0c:	75 0b                	jne    801f19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f0e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f11:	89 04 24             	mov    %eax,(%esp)
  801f14:	e8 b1 02 00 00       	call   8021ca <nsipc_close>
	else
		return 0;
}
  801f19:	83 c4 14             	add    $0x14,%esp
  801f1c:	5b                   	pop    %ebx
  801f1d:	5d                   	pop    %ebp
  801f1e:	c3                   	ret    

00801f1f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f25:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f2c:	00 
  801f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f30:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f41:	89 04 24             	mov    %eax,(%esp)
  801f44:	e8 bd 02 00 00       	call   802206 <nsipc_send>
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f51:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f58:	00 
  801f59:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6d:	89 04 24             	mov    %eax,(%esp)
  801f70:	e8 04 03 00 00       	call   802279 <nsipc_recv>
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	56                   	push   %esi
  801f7b:	53                   	push   %ebx
  801f7c:	83 ec 20             	sub    $0x20,%esp
  801f7f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f84:	89 04 24             	mov    %eax,(%esp)
  801f87:	e8 2b f6 ff ff       	call   8015b7 <fd_alloc>
  801f8c:	89 c3                	mov    %eax,%ebx
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 21                	js     801fb3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f92:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f99:	00 
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fa8:	e8 01 f1 ff ff       	call   8010ae <sys_page_alloc>
  801fad:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	79 0a                	jns    801fbd <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801fb3:	89 34 24             	mov    %esi,(%esp)
  801fb6:	e8 0f 02 00 00       	call   8021ca <nsipc_close>
		return r;
  801fbb:	eb 28                	jmp    801fe5 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fbd:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdb:	89 04 24             	mov    %eax,(%esp)
  801fde:	e8 a9 f5 ff ff       	call   80158c <fd2num>
  801fe3:	89 c3                	mov    %eax,%ebx
}
  801fe5:	89 d8                	mov    %ebx,%eax
  801fe7:	83 c4 20             	add    $0x20,%esp
  801fea:	5b                   	pop    %ebx
  801feb:	5e                   	pop    %esi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    

00801fee <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	89 04 24             	mov    %eax,(%esp)
  802008:	e8 71 01 00 00       	call   80217e <nsipc_socket>
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 05                	js     802016 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802011:	e8 61 ff ff ff       	call   801f77 <alloc_sockfd>
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80201e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802021:	89 54 24 04          	mov    %edx,0x4(%esp)
  802025:	89 04 24             	mov    %eax,(%esp)
  802028:	e8 e3 f5 ff ff       	call   801610 <fd_lookup>
  80202d:	85 c0                	test   %eax,%eax
  80202f:	78 15                	js     802046 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802031:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802034:	8b 0a                	mov    (%edx),%ecx
  802036:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80203b:	3b 0d 20 40 80 00    	cmp    0x804020,%ecx
  802041:	75 03                	jne    802046 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802043:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	e8 c2 ff ff ff       	call   802018 <fd2sockid>
  802056:	85 c0                	test   %eax,%eax
  802058:	78 0f                	js     802069 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80205a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802061:	89 04 24             	mov    %eax,(%esp)
  802064:	e8 3f 01 00 00       	call   8021a8 <nsipc_listen>
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	e8 9f ff ff ff       	call   802018 <fd2sockid>
  802079:	85 c0                	test   %eax,%eax
  80207b:	78 16                	js     802093 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  80207d:	8b 55 10             	mov    0x10(%ebp),%edx
  802080:	89 54 24 08          	mov    %edx,0x8(%esp)
  802084:	8b 55 0c             	mov    0xc(%ebp),%edx
  802087:	89 54 24 04          	mov    %edx,0x4(%esp)
  80208b:	89 04 24             	mov    %eax,(%esp)
  80208e:	e8 66 02 00 00       	call   8022f9 <nsipc_connect>
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	e8 75 ff ff ff       	call   802018 <fd2sockid>
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	78 0f                	js     8020b6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8020a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ae:	89 04 24             	mov    %eax,(%esp)
  8020b1:	e8 2e 01 00 00       	call   8021e4 <nsipc_shutdown>
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	e8 52 ff ff ff       	call   802018 <fd2sockid>
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	78 16                	js     8020e0 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8020ca:	8b 55 10             	mov    0x10(%ebp),%edx
  8020cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020d8:	89 04 24             	mov    %eax,(%esp)
  8020db:	e8 58 02 00 00       	call   802338 <nsipc_bind>
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	e8 28 ff ff ff       	call   802018 <fd2sockid>
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	78 1f                	js     802113 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020f4:	8b 55 10             	mov    0x10(%ebp),%edx
  8020f7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  802102:	89 04 24             	mov    %eax,(%esp)
  802105:	e8 6d 02 00 00       	call   802377 <nsipc_accept>
  80210a:	85 c0                	test   %eax,%eax
  80210c:	78 05                	js     802113 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80210e:	e8 64 fe ff ff       	call   801f77 <alloc_sockfd>
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    
  802115:	00 00                	add    %al,(%eax)
	...

00802118 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	53                   	push   %ebx
  80211c:	83 ec 14             	sub    $0x14,%esp
  80211f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802121:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802128:	75 11                	jne    80213b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80212a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802131:	e8 92 08 00 00       	call   8029c8 <ipc_find_env>
  802136:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80213b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802142:	00 
  802143:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  80214a:	00 
  80214b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80214f:	a1 04 50 80 00       	mov    0x805004,%eax
  802154:	89 04 24             	mov    %eax,(%esp)
  802157:	e8 a2 08 00 00       	call   8029fe <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80215c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802163:	00 
  802164:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80216b:	00 
  80216c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802173:	e8 f2 08 00 00       	call   802a6a <ipc_recv>
}
  802178:	83 c4 14             	add    $0x14,%esp
  80217b:	5b                   	pop    %ebx
  80217c:	5d                   	pop    %ebp
  80217d:	c3                   	ret    

0080217e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80218c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802194:	8b 45 10             	mov    0x10(%ebp),%eax
  802197:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80219c:	b8 09 00 00 00       	mov    $0x9,%eax
  8021a1:	e8 72 ff ff ff       	call   802118 <nsipc>
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8021b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b9:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8021be:	b8 06 00 00 00       	mov    $0x6,%eax
  8021c3:	e8 50 ff ff ff       	call   802118 <nsipc>
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8021d8:	b8 04 00 00 00       	mov    $0x4,%eax
  8021dd:	e8 36 ff ff ff       	call   802118 <nsipc>
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8021f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f5:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8021fa:	b8 03 00 00 00       	mov    $0x3,%eax
  8021ff:	e8 14 ff ff ff       	call   802118 <nsipc>
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	53                   	push   %ebx
  80220a:	83 ec 14             	sub    $0x14,%esp
  80220d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802218:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80221e:	7e 24                	jle    802244 <nsipc_send+0x3e>
  802220:	c7 44 24 0c b6 33 80 	movl   $0x8033b6,0xc(%esp)
  802227:	00 
  802228:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  80222f:	00 
  802230:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802237:	00 
  802238:	c7 04 24 c2 33 80 00 	movl   $0x8033c2,(%esp)
  80223f:	e8 0c e0 ff ff       	call   800250 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802244:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802256:	e8 b4 e8 ff ff       	call   800b0f <memmove>
	nsipcbuf.send.req_size = size;
  80225b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802261:	8b 45 14             	mov    0x14(%ebp),%eax
  802264:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802269:	b8 08 00 00 00       	mov    $0x8,%eax
  80226e:	e8 a5 fe ff ff       	call   802118 <nsipc>
}
  802273:	83 c4 14             	add    $0x14,%esp
  802276:	5b                   	pop    %ebx
  802277:	5d                   	pop    %ebp
  802278:	c3                   	ret    

00802279 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	56                   	push   %esi
  80227d:	53                   	push   %ebx
  80227e:	83 ec 10             	sub    $0x10,%esp
  802281:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80228c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802292:	8b 45 14             	mov    0x14(%ebp),%eax
  802295:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80229a:	b8 07 00 00 00       	mov    $0x7,%eax
  80229f:	e8 74 fe ff ff       	call   802118 <nsipc>
  8022a4:	89 c3                	mov    %eax,%ebx
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	78 46                	js     8022f0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022aa:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022af:	7f 04                	jg     8022b5 <nsipc_recv+0x3c>
  8022b1:	39 c6                	cmp    %eax,%esi
  8022b3:	7d 24                	jge    8022d9 <nsipc_recv+0x60>
  8022b5:	c7 44 24 0c ce 33 80 	movl   $0x8033ce,0xc(%esp)
  8022bc:	00 
  8022bd:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  8022c4:	00 
  8022c5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8022cc:	00 
  8022cd:	c7 04 24 c2 33 80 00 	movl   $0x8033c2,(%esp)
  8022d4:	e8 77 df ff ff       	call   800250 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022dd:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8022e4:	00 
  8022e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e8:	89 04 24             	mov    %eax,(%esp)
  8022eb:	e8 1f e8 ff ff       	call   800b0f <memmove>
	}

	return r;
}
  8022f0:	89 d8                	mov    %ebx,%eax
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	5b                   	pop    %ebx
  8022f6:	5e                   	pop    %esi
  8022f7:	5d                   	pop    %ebp
  8022f8:	c3                   	ret    

008022f9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	53                   	push   %ebx
  8022fd:	83 ec 14             	sub    $0x14,%esp
  802300:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80230b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80230f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802312:	89 44 24 04          	mov    %eax,0x4(%esp)
  802316:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80231d:	e8 ed e7 ff ff       	call   800b0f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802322:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802328:	b8 05 00 00 00       	mov    $0x5,%eax
  80232d:	e8 e6 fd ff ff       	call   802118 <nsipc>
}
  802332:	83 c4 14             	add    $0x14,%esp
  802335:	5b                   	pop    %ebx
  802336:	5d                   	pop    %ebp
  802337:	c3                   	ret    

00802338 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	53                   	push   %ebx
  80233c:	83 ec 14             	sub    $0x14,%esp
  80233f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80234a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80234e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802351:	89 44 24 04          	mov    %eax,0x4(%esp)
  802355:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80235c:	e8 ae e7 ff ff       	call   800b0f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802361:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802367:	b8 02 00 00 00       	mov    $0x2,%eax
  80236c:	e8 a7 fd ff ff       	call   802118 <nsipc>
}
  802371:	83 c4 14             	add    $0x14,%esp
  802374:	5b                   	pop    %ebx
  802375:	5d                   	pop    %ebp
  802376:	c3                   	ret    

00802377 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	83 ec 28             	sub    $0x28,%esp
  80237d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802380:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802383:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802386:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802391:	8b 07                	mov    (%edi),%eax
  802393:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802398:	b8 01 00 00 00       	mov    $0x1,%eax
  80239d:	e8 76 fd ff ff       	call   802118 <nsipc>
  8023a2:	89 c6                	mov    %eax,%esi
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	78 22                	js     8023ca <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023a8:	bb 10 80 80 00       	mov    $0x808010,%ebx
  8023ad:	8b 03                	mov    (%ebx),%eax
  8023af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023b3:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8023ba:	00 
  8023bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023be:	89 04 24             	mov    %eax,(%esp)
  8023c1:	e8 49 e7 ff ff       	call   800b0f <memmove>
		*addrlen = ret->ret_addrlen;
  8023c6:	8b 03                	mov    (%ebx),%eax
  8023c8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8023ca:	89 f0                	mov    %esi,%eax
  8023cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023cf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8023d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8023d5:	89 ec                	mov    %ebp,%esp
  8023d7:	5d                   	pop    %ebp
  8023d8:	c3                   	ret    
  8023d9:	00 00                	add    %al,(%eax)
	...

008023dc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 18             	sub    $0x18,%esp
  8023e2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023e5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	89 04 24             	mov    %eax,(%esp)
  8023f1:	e8 a6 f1 ff ff       	call   80159c <fd2data>
  8023f6:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8023f8:	c7 44 24 04 e3 33 80 	movl   $0x8033e3,0x4(%esp)
  8023ff:	00 
  802400:	89 34 24             	mov    %esi,(%esp)
  802403:	e8 61 e5 ff ff       	call   800969 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802408:	8b 43 04             	mov    0x4(%ebx),%eax
  80240b:	2b 03                	sub    (%ebx),%eax
  80240d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802413:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80241a:	00 00 00 
	stat->st_dev = &devpipe;
  80241d:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  802424:	40 80 00 
	return 0;
}
  802427:	b8 00 00 00 00       	mov    $0x0,%eax
  80242c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80242f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802432:	89 ec                	mov    %ebp,%esp
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    

00802436 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	53                   	push   %ebx
  80243a:	83 ec 14             	sub    $0x14,%esp
  80243d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802440:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802444:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80244b:	e8 a2 eb ff ff       	call   800ff2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802450:	89 1c 24             	mov    %ebx,(%esp)
  802453:	e8 44 f1 ff ff       	call   80159c <fd2data>
  802458:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802463:	e8 8a eb ff ff       	call   800ff2 <sys_page_unmap>
}
  802468:	83 c4 14             	add    $0x14,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5d                   	pop    %ebp
  80246d:	c3                   	ret    

0080246e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	53                   	push   %ebx
  802474:	83 ec 2c             	sub    $0x2c,%esp
  802477:	89 c7                	mov    %eax,%edi
  802479:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80247c:	a1 08 50 80 00       	mov    0x805008,%eax
  802481:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802484:	89 3c 24             	mov    %edi,(%esp)
  802487:	e8 68 06 00 00       	call   802af4 <pageref>
  80248c:	89 c6                	mov    %eax,%esi
  80248e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802491:	89 04 24             	mov    %eax,(%esp)
  802494:	e8 5b 06 00 00       	call   802af4 <pageref>
  802499:	39 c6                	cmp    %eax,%esi
  80249b:	0f 94 c0             	sete   %al
  80249e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8024a1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024a7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024aa:	39 cb                	cmp    %ecx,%ebx
  8024ac:	75 08                	jne    8024b6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8024ae:	83 c4 2c             	add    $0x2c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8024b6:	83 f8 01             	cmp    $0x1,%eax
  8024b9:	75 c1                	jne    80247c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024bb:	8b 52 58             	mov    0x58(%edx),%edx
  8024be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024ca:	c7 04 24 ea 33 80 00 	movl   $0x8033ea,(%esp)
  8024d1:	e8 33 de ff ff       	call   800309 <cprintf>
  8024d6:	eb a4                	jmp    80247c <_pipeisclosed+0xe>

008024d8 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	57                   	push   %edi
  8024dc:	56                   	push   %esi
  8024dd:	53                   	push   %ebx
  8024de:	83 ec 1c             	sub    $0x1c,%esp
  8024e1:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024e4:	89 34 24             	mov    %esi,(%esp)
  8024e7:	e8 b0 f0 ff ff       	call   80159c <fd2data>
  8024ec:	89 c3                	mov    %eax,%ebx
  8024ee:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024f3:	eb 48                	jmp    80253d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024f5:	89 da                	mov    %ebx,%edx
  8024f7:	89 f0                	mov    %esi,%eax
  8024f9:	e8 70 ff ff ff       	call   80246e <_pipeisclosed>
  8024fe:	85 c0                	test   %eax,%eax
  802500:	74 07                	je     802509 <devpipe_write+0x31>
  802502:	b8 00 00 00 00       	mov    $0x0,%eax
  802507:	eb 3b                	jmp    802544 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802509:	e8 ff eb ff ff       	call   80110d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80250e:	8b 43 04             	mov    0x4(%ebx),%eax
  802511:	8b 13                	mov    (%ebx),%edx
  802513:	83 c2 20             	add    $0x20,%edx
  802516:	39 d0                	cmp    %edx,%eax
  802518:	73 db                	jae    8024f5 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80251a:	89 c2                	mov    %eax,%edx
  80251c:	c1 fa 1f             	sar    $0x1f,%edx
  80251f:	c1 ea 1b             	shr    $0x1b,%edx
  802522:	01 d0                	add    %edx,%eax
  802524:	83 e0 1f             	and    $0x1f,%eax
  802527:	29 d0                	sub    %edx,%eax
  802529:	89 c2                	mov    %eax,%edx
  80252b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80252e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802532:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802536:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80253a:	83 c7 01             	add    $0x1,%edi
  80253d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802540:	72 cc                	jb     80250e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802542:	89 f8                	mov    %edi,%eax
}
  802544:	83 c4 1c             	add    $0x1c,%esp
  802547:	5b                   	pop    %ebx
  802548:	5e                   	pop    %esi
  802549:	5f                   	pop    %edi
  80254a:	5d                   	pop    %ebp
  80254b:	c3                   	ret    

0080254c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	83 ec 28             	sub    $0x28,%esp
  802552:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802555:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802558:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80255b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80255e:	89 3c 24             	mov    %edi,(%esp)
  802561:	e8 36 f0 ff ff       	call   80159c <fd2data>
  802566:	89 c3                	mov    %eax,%ebx
  802568:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80256d:	eb 48                	jmp    8025b7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80256f:	85 f6                	test   %esi,%esi
  802571:	74 04                	je     802577 <devpipe_read+0x2b>
				return i;
  802573:	89 f0                	mov    %esi,%eax
  802575:	eb 47                	jmp    8025be <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802577:	89 da                	mov    %ebx,%edx
  802579:	89 f8                	mov    %edi,%eax
  80257b:	e8 ee fe ff ff       	call   80246e <_pipeisclosed>
  802580:	85 c0                	test   %eax,%eax
  802582:	74 07                	je     80258b <devpipe_read+0x3f>
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
  802589:	eb 33                	jmp    8025be <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80258b:	e8 7d eb ff ff       	call   80110d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802590:	8b 03                	mov    (%ebx),%eax
  802592:	3b 43 04             	cmp    0x4(%ebx),%eax
  802595:	74 d8                	je     80256f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802597:	89 c2                	mov    %eax,%edx
  802599:	c1 fa 1f             	sar    $0x1f,%edx
  80259c:	c1 ea 1b             	shr    $0x1b,%edx
  80259f:	01 d0                	add    %edx,%eax
  8025a1:	83 e0 1f             	and    $0x1f,%eax
  8025a4:	29 d0                	sub    %edx,%eax
  8025a6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ae:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8025b1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025b4:	83 c6 01             	add    $0x1,%esi
  8025b7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ba:	72 d4                	jb     802590 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025bc:	89 f0                	mov    %esi,%eax
}
  8025be:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025c1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025c7:	89 ec                	mov    %ebp,%esp
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    

008025cb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	89 04 24             	mov    %eax,(%esp)
  8025de:	e8 2d f0 ff ff       	call   801610 <fd_lookup>
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	78 15                	js     8025fc <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	89 04 24             	mov    %eax,(%esp)
  8025ed:	e8 aa ef ff ff       	call   80159c <fd2data>
	return _pipeisclosed(fd, p);
  8025f2:	89 c2                	mov    %eax,%edx
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	e8 72 fe ff ff       	call   80246e <_pipeisclosed>
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 48             	sub    $0x48,%esp
  802604:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802607:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80260a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80260d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802610:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802613:	89 04 24             	mov    %eax,(%esp)
  802616:	e8 9c ef ff ff       	call   8015b7 <fd_alloc>
  80261b:	89 c3                	mov    %eax,%ebx
  80261d:	85 c0                	test   %eax,%eax
  80261f:	0f 88 42 01 00 00    	js     802767 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802625:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80262c:	00 
  80262d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802630:	89 44 24 04          	mov    %eax,0x4(%esp)
  802634:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80263b:	e8 6e ea ff ff       	call   8010ae <sys_page_alloc>
  802640:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802642:	85 c0                	test   %eax,%eax
  802644:	0f 88 1d 01 00 00    	js     802767 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80264a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80264d:	89 04 24             	mov    %eax,(%esp)
  802650:	e8 62 ef ff ff       	call   8015b7 <fd_alloc>
  802655:	89 c3                	mov    %eax,%ebx
  802657:	85 c0                	test   %eax,%eax
  802659:	0f 88 f5 00 00 00    	js     802754 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802666:	00 
  802667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80266e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802675:	e8 34 ea ff ff       	call   8010ae <sys_page_alloc>
  80267a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80267c:	85 c0                	test   %eax,%eax
  80267e:	0f 88 d0 00 00 00    	js     802754 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802687:	89 04 24             	mov    %eax,(%esp)
  80268a:	e8 0d ef ff ff       	call   80159c <fd2data>
  80268f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802691:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802698:	00 
  802699:	89 44 24 04          	mov    %eax,0x4(%esp)
  80269d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a4:	e8 05 ea ff ff       	call   8010ae <sys_page_alloc>
  8026a9:	89 c3                	mov    %eax,%ebx
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	0f 88 8e 00 00 00    	js     802741 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b6:	89 04 24             	mov    %eax,(%esp)
  8026b9:	e8 de ee ff ff       	call   80159c <fd2data>
  8026be:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026c5:	00 
  8026c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026d1:	00 
  8026d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026dd:	e8 6e e9 ff ff       	call   801050 <sys_page_map>
  8026e2:	89 c3                	mov    %eax,%ebx
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	78 49                	js     802731 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026e8:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  8026ed:	8b 08                	mov    (%eax),%ecx
  8026ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f2:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8026fe:	8b 10                	mov    (%eax),%edx
  802700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802703:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802705:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802708:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80270f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802712:	89 04 24             	mov    %eax,(%esp)
  802715:	e8 72 ee ff ff       	call   80158c <fd2num>
  80271a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80271c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271f:	89 04 24             	mov    %eax,(%esp)
  802722:	e8 65 ee ff ff       	call   80158c <fd2num>
  802727:	89 47 04             	mov    %eax,0x4(%edi)
  80272a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80272f:	eb 36                	jmp    802767 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802731:	89 74 24 04          	mov    %esi,0x4(%esp)
  802735:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80273c:	e8 b1 e8 ff ff       	call   800ff2 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802744:	89 44 24 04          	mov    %eax,0x4(%esp)
  802748:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80274f:	e8 9e e8 ff ff       	call   800ff2 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802757:	89 44 24 04          	mov    %eax,0x4(%esp)
  80275b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802762:	e8 8b e8 ff ff       	call   800ff2 <sys_page_unmap>
    err:
	return r;
}
  802767:	89 d8                	mov    %ebx,%eax
  802769:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80276c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80276f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802772:	89 ec                	mov    %ebp,%esp
  802774:	5d                   	pop    %ebp
  802775:	c3                   	ret    
	...

00802780 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    

0080278a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802790:	c7 44 24 04 02 34 80 	movl   $0x803402,0x4(%esp)
  802797:	00 
  802798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279b:	89 04 24             	mov    %eax,(%esp)
  80279e:	e8 c6 e1 ff ff       	call   800969 <strcpy>
	return 0;
}
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	57                   	push   %edi
  8027ae:	56                   	push   %esi
  8027af:	53                   	push   %ebx
  8027b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8027b6:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027c1:	eb 34                	jmp    8027f7 <devcons_write+0x4d>
		m = n - tot;
  8027c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027c6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8027c8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8027ce:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8027d3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027d6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027da:	03 45 0c             	add    0xc(%ebp),%eax
  8027dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e1:	89 3c 24             	mov    %edi,(%esp)
  8027e4:	e8 26 e3 ff ff       	call   800b0f <memmove>
		sys_cputs(buf, m);
  8027e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027ed:	89 3c 24             	mov    %edi,(%esp)
  8027f0:	e8 2b e5 ff ff       	call   800d20 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027f5:	01 de                	add    %ebx,%esi
  8027f7:	89 f0                	mov    %esi,%eax
  8027f9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027fc:	72 c5                	jb     8027c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027fe:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802804:	5b                   	pop    %ebx
  802805:	5e                   	pop    %esi
  802806:	5f                   	pop    %edi
  802807:	5d                   	pop    %ebp
  802808:	c3                   	ret    

00802809 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80280f:	8b 45 08             	mov    0x8(%ebp),%eax
  802812:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802815:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80281c:	00 
  80281d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802820:	89 04 24             	mov    %eax,(%esp)
  802823:	e8 f8 e4 ff ff       	call   800d20 <sys_cputs>
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802834:	75 07                	jne    80283d <devcons_read+0x13>
  802836:	eb 28                	jmp    802860 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802838:	e8 d0 e8 ff ff       	call   80110d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80283d:	8d 76 00             	lea    0x0(%esi),%esi
  802840:	e8 a7 e4 ff ff       	call   800cec <sys_cgetc>
  802845:	85 c0                	test   %eax,%eax
  802847:	74 ef                	je     802838 <devcons_read+0xe>
  802849:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80284b:	85 c0                	test   %eax,%eax
  80284d:	78 16                	js     802865 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80284f:	83 f8 04             	cmp    $0x4,%eax
  802852:	74 0c                	je     802860 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802854:	8b 45 0c             	mov    0xc(%ebp),%eax
  802857:	88 10                	mov    %dl,(%eax)
  802859:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80285e:	eb 05                	jmp    802865 <devcons_read+0x3b>
  802860:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802865:	c9                   	leave  
  802866:	c3                   	ret    

00802867 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
  80286a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80286d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802870:	89 04 24             	mov    %eax,(%esp)
  802873:	e8 3f ed ff ff       	call   8015b7 <fd_alloc>
  802878:	85 c0                	test   %eax,%eax
  80287a:	78 3f                	js     8028bb <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80287c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802883:	00 
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	89 44 24 04          	mov    %eax,0x4(%esp)
  80288b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802892:	e8 17 e8 ff ff       	call   8010ae <sys_page_alloc>
  802897:	85 c0                	test   %eax,%eax
  802899:	78 20                	js     8028bb <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80289b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	89 04 24             	mov    %eax,(%esp)
  8028b6:	e8 d1 ec ff ff       	call   80158c <fd2num>
}
  8028bb:	c9                   	leave  
  8028bc:	c3                   	ret    

008028bd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
  8028c0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	89 04 24             	mov    %eax,(%esp)
  8028d0:	e8 3b ed ff ff       	call   801610 <fd_lookup>
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	78 11                	js     8028ea <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	3b 05 58 40 80 00    	cmp    0x804058,%eax
  8028e4:	0f 94 c0             	sete   %al
  8028e7:	0f b6 c0             	movzbl %al,%eax
}
  8028ea:	c9                   	leave  
  8028eb:	c3                   	ret    

008028ec <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
  8028ef:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8028f9:	00 
  8028fa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802901:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802908:	e8 5a ef ff ff       	call   801867 <read>
	if (r < 0)
  80290d:	85 c0                	test   %eax,%eax
  80290f:	78 0f                	js     802920 <getchar+0x34>
		return r;
	if (r < 1)
  802911:	85 c0                	test   %eax,%eax
  802913:	7f 07                	jg     80291c <getchar+0x30>
  802915:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80291a:	eb 04                	jmp    802920 <getchar+0x34>
		return -E_EOF;
	return c;
  80291c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    
	...

00802924 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
  802927:	53                   	push   %ebx
  802928:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  80292b:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  802932:	75 5b                	jne    80298f <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  802934:	e8 08 e8 ff ff       	call   801141 <sys_getenvid>
  802939:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80293b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802942:	00 
  802943:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80294a:	ee 
  80294b:	89 04 24             	mov    %eax,(%esp)
  80294e:	e8 5b e7 ff ff       	call   8010ae <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  802953:	85 c0                	test   %eax,%eax
  802955:	74 28                	je     80297f <set_pgfault_handler+0x5b>
  802957:	89 44 24 10          	mov    %eax,0x10(%esp)
  80295b:	c7 44 24 0c 35 34 80 	movl   $0x803435,0xc(%esp)
  802962:	00 
  802963:	c7 44 24 08 0e 34 80 	movl   $0x80340e,0x8(%esp)
  80296a:	00 
  80296b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802972:	00 
  802973:	c7 04 24 27 34 80 00 	movl   $0x803427,(%esp)
  80297a:	e8 d1 d8 ff ff       	call   800250 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80297f:	c7 44 24 04 a0 29 80 	movl   $0x8029a0,0x4(%esp)
  802986:	00 
  802987:	89 1c 24             	mov    %ebx,(%esp)
  80298a:	e8 49 e5 ff ff       	call   800ed8 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	a3 00 90 80 00       	mov    %eax,0x809000
	
}
  802997:	83 c4 24             	add    $0x24,%esp
  80299a:	5b                   	pop    %ebx
  80299b:	5d                   	pop    %ebp
  80299c:	c3                   	ret    
  80299d:	00 00                	add    %al,(%eax)
	...

008029a0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029a0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029a1:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  8029a6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029a8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  8029ab:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  8029ae:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  8029b2:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  8029b6:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  8029b9:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  8029bc:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  8029c0:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  8029c1:	83 c4 04             	add    $0x4,%esp
	popfl ;
  8029c4:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8029c5:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029c6:	c3                   	ret    
	...

008029c8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
  8029cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029ce:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8029d3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8029d6:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  8029dc:	8b 12                	mov    (%edx),%edx
  8029de:	39 ca                	cmp    %ecx,%edx
  8029e0:	75 0c                	jne    8029ee <ipc_find_env+0x26>
			return envs[i].env_id;
  8029e2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8029e5:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8029ea:	8b 00                	mov    (%eax),%eax
  8029ec:	eb 0e                	jmp    8029fc <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8029ee:	83 c0 01             	add    $0x1,%eax
  8029f1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029f6:	75 db                	jne    8029d3 <ipc_find_env+0xb>
  8029f8:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8029fc:	5d                   	pop    %ebp
  8029fd:	c3                   	ret    

008029fe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029fe:	55                   	push   %ebp
  8029ff:	89 e5                	mov    %esp,%ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	53                   	push   %ebx
  802a04:	83 ec 2c             	sub    $0x2c,%esp
  802a07:	8b 75 08             	mov    0x8(%ebp),%esi
  802a0a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802a10:	85 db                	test   %ebx,%ebx
  802a12:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a17:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  802a1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a21:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a25:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a29:	89 34 24             	mov    %esi,(%esp)
  802a2c:	e8 6f e4 ff ff       	call   800ea0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802a31:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a34:	74 e4                	je     802a1a <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 28                	je     802a62 <ipc_send+0x64>
  802a3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a3e:	c7 44 24 0c 66 34 80 	movl   $0x803466,0xc(%esp)
  802a45:	00 
  802a46:	c7 44 24 08 49 34 80 	movl   $0x803449,0x8(%esp)
  802a4d:	00 
  802a4e:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802a55:	00 
  802a56:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  802a5d:	e8 ee d7 ff ff       	call   800250 <_panic>
	//if(!ret) sys_yield();
}
  802a62:	83 c4 2c             	add    $0x2c,%esp
  802a65:	5b                   	pop    %ebx
  802a66:	5e                   	pop    %esi
  802a67:	5f                   	pop    %edi
  802a68:	5d                   	pop    %ebp
  802a69:	c3                   	ret    

00802a6a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
  802a6d:	83 ec 28             	sub    $0x28,%esp
  802a70:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a73:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a76:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802a79:	8b 75 08             	mov    0x8(%ebp),%esi
  802a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a7f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802a82:	85 c0                	test   %eax,%eax
  802a84:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a89:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a8c:	89 04 24             	mov    %eax,(%esp)
  802a8f:	e8 af e3 ff ff       	call   800e43 <sys_ipc_recv>
  802a94:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802a96:	e8 a6 e6 ff ff       	call   801141 <sys_getenvid>
  802a9b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802aa0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802aa3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802aa8:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802aad:	85 f6                	test   %esi,%esi
  802aaf:	74 0e                	je     802abf <ipc_recv+0x55>
  802ab1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ab6:	85 db                	test   %ebx,%ebx
  802ab8:	75 03                	jne    802abd <ipc_recv+0x53>
  802aba:	8b 50 74             	mov    0x74(%eax),%edx
  802abd:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802abf:	85 ff                	test   %edi,%edi
  802ac1:	74 13                	je     802ad6 <ipc_recv+0x6c>
  802ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac8:	85 db                	test   %ebx,%ebx
  802aca:	75 08                	jne    802ad4 <ipc_recv+0x6a>
  802acc:	a1 08 50 80 00       	mov    0x805008,%eax
  802ad1:	8b 40 78             	mov    0x78(%eax),%eax
  802ad4:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802ad6:	85 db                	test   %ebx,%ebx
  802ad8:	75 08                	jne    802ae2 <ipc_recv+0x78>
  802ada:	a1 08 50 80 00       	mov    0x805008,%eax
  802adf:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802ae2:	89 d8                	mov    %ebx,%eax
  802ae4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ae7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802aea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802aed:	89 ec                	mov    %ebp,%esp
  802aef:	5d                   	pop    %ebp
  802af0:	c3                   	ret    
  802af1:	00 00                	add    %al,(%eax)
	...

00802af4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802af4:	55                   	push   %ebp
  802af5:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	89 c2                	mov    %eax,%edx
  802afc:	c1 ea 16             	shr    $0x16,%edx
  802aff:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802b06:	f6 c2 01             	test   $0x1,%dl
  802b09:	74 20                	je     802b2b <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b0b:	c1 e8 0c             	shr    $0xc,%eax
  802b0e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802b15:	a8 01                	test   $0x1,%al
  802b17:	74 12                	je     802b2b <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b19:	c1 e8 0c             	shr    $0xc,%eax
  802b1c:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802b21:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802b26:	0f b7 c0             	movzwl %ax,%eax
  802b29:	eb 05                	jmp    802b30 <pageref+0x3c>
  802b2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b30:	5d                   	pop    %ebp
  802b31:	c3                   	ret    
	...

00802b40 <__udivdi3>:
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
  802b43:	57                   	push   %edi
  802b44:	56                   	push   %esi
  802b45:	83 ec 10             	sub    $0x10,%esp
  802b48:	8b 45 14             	mov    0x14(%ebp),%eax
  802b4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4e:	8b 75 10             	mov    0x10(%ebp),%esi
  802b51:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b54:	85 c0                	test   %eax,%eax
  802b56:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802b59:	75 35                	jne    802b90 <__udivdi3+0x50>
  802b5b:	39 fe                	cmp    %edi,%esi
  802b5d:	77 61                	ja     802bc0 <__udivdi3+0x80>
  802b5f:	85 f6                	test   %esi,%esi
  802b61:	75 0b                	jne    802b6e <__udivdi3+0x2e>
  802b63:	b8 01 00 00 00       	mov    $0x1,%eax
  802b68:	31 d2                	xor    %edx,%edx
  802b6a:	f7 f6                	div    %esi
  802b6c:	89 c6                	mov    %eax,%esi
  802b6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b71:	31 d2                	xor    %edx,%edx
  802b73:	89 f8                	mov    %edi,%eax
  802b75:	f7 f6                	div    %esi
  802b77:	89 c7                	mov    %eax,%edi
  802b79:	89 c8                	mov    %ecx,%eax
  802b7b:	f7 f6                	div    %esi
  802b7d:	89 c1                	mov    %eax,%ecx
  802b7f:	89 fa                	mov    %edi,%edx
  802b81:	89 c8                	mov    %ecx,%eax
  802b83:	83 c4 10             	add    $0x10,%esp
  802b86:	5e                   	pop    %esi
  802b87:	5f                   	pop    %edi
  802b88:	5d                   	pop    %ebp
  802b89:	c3                   	ret    
  802b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b90:	39 f8                	cmp    %edi,%eax
  802b92:	77 1c                	ja     802bb0 <__udivdi3+0x70>
  802b94:	0f bd d0             	bsr    %eax,%edx
  802b97:	83 f2 1f             	xor    $0x1f,%edx
  802b9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802b9d:	75 39                	jne    802bd8 <__udivdi3+0x98>
  802b9f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802ba2:	0f 86 a0 00 00 00    	jbe    802c48 <__udivdi3+0x108>
  802ba8:	39 f8                	cmp    %edi,%eax
  802baa:	0f 82 98 00 00 00    	jb     802c48 <__udivdi3+0x108>
  802bb0:	31 ff                	xor    %edi,%edi
  802bb2:	31 c9                	xor    %ecx,%ecx
  802bb4:	89 c8                	mov    %ecx,%eax
  802bb6:	89 fa                	mov    %edi,%edx
  802bb8:	83 c4 10             	add    $0x10,%esp
  802bbb:	5e                   	pop    %esi
  802bbc:	5f                   	pop    %edi
  802bbd:	5d                   	pop    %ebp
  802bbe:	c3                   	ret    
  802bbf:	90                   	nop
  802bc0:	89 d1                	mov    %edx,%ecx
  802bc2:	89 fa                	mov    %edi,%edx
  802bc4:	89 c8                	mov    %ecx,%eax
  802bc6:	31 ff                	xor    %edi,%edi
  802bc8:	f7 f6                	div    %esi
  802bca:	89 c1                	mov    %eax,%ecx
  802bcc:	89 fa                	mov    %edi,%edx
  802bce:	89 c8                	mov    %ecx,%eax
  802bd0:	83 c4 10             	add    $0x10,%esp
  802bd3:	5e                   	pop    %esi
  802bd4:	5f                   	pop    %edi
  802bd5:	5d                   	pop    %ebp
  802bd6:	c3                   	ret    
  802bd7:	90                   	nop
  802bd8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bdc:	89 f2                	mov    %esi,%edx
  802bde:	d3 e0                	shl    %cl,%eax
  802be0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802be3:	b8 20 00 00 00       	mov    $0x20,%eax
  802be8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802beb:	89 c1                	mov    %eax,%ecx
  802bed:	d3 ea                	shr    %cl,%edx
  802bef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bf3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802bf6:	d3 e6                	shl    %cl,%esi
  802bf8:	89 c1                	mov    %eax,%ecx
  802bfa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802bfd:	89 fe                	mov    %edi,%esi
  802bff:	d3 ee                	shr    %cl,%esi
  802c01:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c05:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c0b:	d3 e7                	shl    %cl,%edi
  802c0d:	89 c1                	mov    %eax,%ecx
  802c0f:	d3 ea                	shr    %cl,%edx
  802c11:	09 d7                	or     %edx,%edi
  802c13:	89 f2                	mov    %esi,%edx
  802c15:	89 f8                	mov    %edi,%eax
  802c17:	f7 75 ec             	divl   -0x14(%ebp)
  802c1a:	89 d6                	mov    %edx,%esi
  802c1c:	89 c7                	mov    %eax,%edi
  802c1e:	f7 65 e8             	mull   -0x18(%ebp)
  802c21:	39 d6                	cmp    %edx,%esi
  802c23:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c26:	72 30                	jb     802c58 <__udivdi3+0x118>
  802c28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c2f:	d3 e2                	shl    %cl,%edx
  802c31:	39 c2                	cmp    %eax,%edx
  802c33:	73 05                	jae    802c3a <__udivdi3+0xfa>
  802c35:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802c38:	74 1e                	je     802c58 <__udivdi3+0x118>
  802c3a:	89 f9                	mov    %edi,%ecx
  802c3c:	31 ff                	xor    %edi,%edi
  802c3e:	e9 71 ff ff ff       	jmp    802bb4 <__udivdi3+0x74>
  802c43:	90                   	nop
  802c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c48:	31 ff                	xor    %edi,%edi
  802c4a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802c4f:	e9 60 ff ff ff       	jmp    802bb4 <__udivdi3+0x74>
  802c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c58:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802c5b:	31 ff                	xor    %edi,%edi
  802c5d:	89 c8                	mov    %ecx,%eax
  802c5f:	89 fa                	mov    %edi,%edx
  802c61:	83 c4 10             	add    $0x10,%esp
  802c64:	5e                   	pop    %esi
  802c65:	5f                   	pop    %edi
  802c66:	5d                   	pop    %ebp
  802c67:	c3                   	ret    
	...

00802c70 <__umoddi3>:
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
  802c73:	57                   	push   %edi
  802c74:	56                   	push   %esi
  802c75:	83 ec 20             	sub    $0x20,%esp
  802c78:	8b 55 14             	mov    0x14(%ebp),%edx
  802c7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c7e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802c81:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c84:	85 d2                	test   %edx,%edx
  802c86:	89 c8                	mov    %ecx,%eax
  802c88:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802c8b:	75 13                	jne    802ca0 <__umoddi3+0x30>
  802c8d:	39 f7                	cmp    %esi,%edi
  802c8f:	76 3f                	jbe    802cd0 <__umoddi3+0x60>
  802c91:	89 f2                	mov    %esi,%edx
  802c93:	f7 f7                	div    %edi
  802c95:	89 d0                	mov    %edx,%eax
  802c97:	31 d2                	xor    %edx,%edx
  802c99:	83 c4 20             	add    $0x20,%esp
  802c9c:	5e                   	pop    %esi
  802c9d:	5f                   	pop    %edi
  802c9e:	5d                   	pop    %ebp
  802c9f:	c3                   	ret    
  802ca0:	39 f2                	cmp    %esi,%edx
  802ca2:	77 4c                	ja     802cf0 <__umoddi3+0x80>
  802ca4:	0f bd ca             	bsr    %edx,%ecx
  802ca7:	83 f1 1f             	xor    $0x1f,%ecx
  802caa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802cad:	75 51                	jne    802d00 <__umoddi3+0x90>
  802caf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802cb2:	0f 87 e0 00 00 00    	ja     802d98 <__umoddi3+0x128>
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	29 f8                	sub    %edi,%eax
  802cbd:	19 d6                	sbb    %edx,%esi
  802cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	89 f2                	mov    %esi,%edx
  802cc7:	83 c4 20             	add    $0x20,%esp
  802cca:	5e                   	pop    %esi
  802ccb:	5f                   	pop    %edi
  802ccc:	5d                   	pop    %ebp
  802ccd:	c3                   	ret    
  802cce:	66 90                	xchg   %ax,%ax
  802cd0:	85 ff                	test   %edi,%edi
  802cd2:	75 0b                	jne    802cdf <__umoddi3+0x6f>
  802cd4:	b8 01 00 00 00       	mov    $0x1,%eax
  802cd9:	31 d2                	xor    %edx,%edx
  802cdb:	f7 f7                	div    %edi
  802cdd:	89 c7                	mov    %eax,%edi
  802cdf:	89 f0                	mov    %esi,%eax
  802ce1:	31 d2                	xor    %edx,%edx
  802ce3:	f7 f7                	div    %edi
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	f7 f7                	div    %edi
  802cea:	eb a9                	jmp    802c95 <__umoddi3+0x25>
  802cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cf0:	89 c8                	mov    %ecx,%eax
  802cf2:	89 f2                	mov    %esi,%edx
  802cf4:	83 c4 20             	add    $0x20,%esp
  802cf7:	5e                   	pop    %esi
  802cf8:	5f                   	pop    %edi
  802cf9:	5d                   	pop    %ebp
  802cfa:	c3                   	ret    
  802cfb:	90                   	nop
  802cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d00:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d04:	d3 e2                	shl    %cl,%edx
  802d06:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d09:	ba 20 00 00 00       	mov    $0x20,%edx
  802d0e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802d11:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d14:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d18:	89 fa                	mov    %edi,%edx
  802d1a:	d3 ea                	shr    %cl,%edx
  802d1c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d20:	0b 55 f4             	or     -0xc(%ebp),%edx
  802d23:	d3 e7                	shl    %cl,%edi
  802d25:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d29:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d2c:	89 f2                	mov    %esi,%edx
  802d2e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802d31:	89 c7                	mov    %eax,%edi
  802d33:	d3 ea                	shr    %cl,%edx
  802d35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802d3c:	89 c2                	mov    %eax,%edx
  802d3e:	d3 e6                	shl    %cl,%esi
  802d40:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d44:	d3 ea                	shr    %cl,%edx
  802d46:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d4a:	09 d6                	or     %edx,%esi
  802d4c:	89 f0                	mov    %esi,%eax
  802d4e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802d51:	d3 e7                	shl    %cl,%edi
  802d53:	89 f2                	mov    %esi,%edx
  802d55:	f7 75 f4             	divl   -0xc(%ebp)
  802d58:	89 d6                	mov    %edx,%esi
  802d5a:	f7 65 e8             	mull   -0x18(%ebp)
  802d5d:	39 d6                	cmp    %edx,%esi
  802d5f:	72 2b                	jb     802d8c <__umoddi3+0x11c>
  802d61:	39 c7                	cmp    %eax,%edi
  802d63:	72 23                	jb     802d88 <__umoddi3+0x118>
  802d65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d69:	29 c7                	sub    %eax,%edi
  802d6b:	19 d6                	sbb    %edx,%esi
  802d6d:	89 f0                	mov    %esi,%eax
  802d6f:	89 f2                	mov    %esi,%edx
  802d71:	d3 ef                	shr    %cl,%edi
  802d73:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d77:	d3 e0                	shl    %cl,%eax
  802d79:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d7d:	09 f8                	or     %edi,%eax
  802d7f:	d3 ea                	shr    %cl,%edx
  802d81:	83 c4 20             	add    $0x20,%esp
  802d84:	5e                   	pop    %esi
  802d85:	5f                   	pop    %edi
  802d86:	5d                   	pop    %ebp
  802d87:	c3                   	ret    
  802d88:	39 d6                	cmp    %edx,%esi
  802d8a:	75 d9                	jne    802d65 <__umoddi3+0xf5>
  802d8c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802d8f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802d92:	eb d1                	jmp    802d65 <__umoddi3+0xf5>
  802d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d98:	39 f2                	cmp    %esi,%edx
  802d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802da0:	0f 82 12 ff ff ff    	jb     802cb8 <__umoddi3+0x48>
  802da6:	e9 17 ff ff ff       	jmp    802cc2 <__umoddi3+0x52>
