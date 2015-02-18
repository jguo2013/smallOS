
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 df 00 00 00       	call   800110 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	unsigned now = sys_time_msec();
  800047:	e8 37 0c 00 00       	call   800c83 <sys_time_msec>
	unsigned end = now + sec * 1000;

	if ((int)now < 0 && (int)now > -MAXERROR)
  80004c:	85 c0                	test   %eax,%eax
  80004e:	79 25                	jns    800075 <sleep+0x35>
  800050:	83 f8 ef             	cmp    $0xffffffef,%eax
  800053:	7c 20                	jl     800075 <sleep+0x35>
		panic("sys_time_msec: %e", (int)now);
  800055:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800059:	c7 44 24 08 80 13 80 	movl   $0x801380,0x8(%esp)
  800060:	00 
  800061:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800068:	00 
  800069:	c7 04 24 92 13 80 00 	movl   $0x801392,(%esp)
  800070:	e8 ff 00 00 00       	call   800174 <_panic>

void
sleep(int sec)
{
	unsigned now = sys_time_msec();
	unsigned end = now + sec * 1000;
  800075:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  80007c:	01 c3                	add    %eax,%ebx
  80007e:	73 21                	jae    8000a1 <sleep+0x61>
		panic("sleep: wrap");
  800080:	c7 44 24 08 a2 13 80 	movl   $0x8013a2,0x8(%esp)
  800087:	00 
  800088:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80008f:	00 
  800090:	c7 04 24 92 13 80 00 	movl   $0x801392,(%esp)
  800097:	e8 d8 00 00 00       	call   800174 <_panic>

	while (sys_time_msec() < end)
		sys_yield();
  80009c:	e8 9c 0f 00 00       	call   80103d <sys_yield>
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000a1:	e8 dd 0b 00 00       	call   800c83 <sys_time_msec>
  8000a6:	39 c3                	cmp    %eax,%ebx
  8000a8:	77 f2                	ja     80009c <sleep+0x5c>
		sys_yield();
}
  8000aa:	83 c4 14             	add    $0x14,%esp
  8000ad:	5b                   	pop    %ebx
  8000ae:	5d                   	pop    %ebp
  8000af:	90                   	nop
  8000b0:	c3                   	ret    

008000b1 <umain>:

void
umain(int argc, char **argv)
{
  8000b1:	55                   	push   %ebp
  8000b2:	89 e5                	mov    %esp,%ebp
  8000b4:	53                   	push   %ebx
  8000b5:	83 ec 14             	sub    $0x14,%esp
  8000b8:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  8000bd:	e8 7b 0f 00 00       	call   80103d <sys_yield>
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  8000c2:	83 c3 01             	add    $0x1,%ebx
  8000c5:	83 fb 32             	cmp    $0x32,%ebx
  8000c8:	75 f3                	jne    8000bd <umain+0xc>
		sys_yield();

	cprintf("starting count down: ");
  8000ca:	c7 04 24 ae 13 80 00 	movl   $0x8013ae,(%esp)
  8000d1:	e8 57 01 00 00       	call   80022d <cprintf>
  8000d6:	b3 05                	mov    $0x5,%bl
	for (i = 5; i >= 0; i--) {
		cprintf("%d ", i);
  8000d8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000dc:	c7 04 24 c4 13 80 00 	movl   $0x8013c4,(%esp)
  8000e3:	e8 45 01 00 00       	call   80022d <cprintf>
		sleep(1);
  8000e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ef:	e8 4c ff ff ff       	call   800040 <sleep>
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  8000f4:	83 eb 01             	sub    $0x1,%ebx
  8000f7:	83 fb ff             	cmp    $0xffffffff,%ebx
  8000fa:	75 dc                	jne    8000d8 <umain+0x27>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  8000fc:	c7 04 24 c8 13 80 00 	movl   $0x8013c8,(%esp)
  800103:	e8 25 01 00 00       	call   80022d <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800108:	cc                   	int3   
	breakpoint();
}
  800109:	83 c4 14             	add    $0x14,%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5d                   	pop    %ebp
  80010e:	c3                   	ret    
	...

00800110 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 18             	sub    $0x18,%esp
  800116:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800119:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80011c:	8b 75 08             	mov    0x8(%ebp),%esi
  80011f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800122:	e8 4a 0f 00 00       	call   801071 <sys_getenvid>
  800127:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80012f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800134:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800139:	85 f6                	test   %esi,%esi
  80013b:	7e 07                	jle    800144 <libmain+0x34>
		binaryname = argv[0];
  80013d:	8b 03                	mov    (%ebx),%eax
  80013f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800144:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800148:	89 34 24             	mov    %esi,(%esp)
  80014b:	e8 61 ff ff ff       	call   8000b1 <umain>

	// exit gracefully
	exit();
  800150:	e8 0b 00 00 00       	call   800160 <exit>
}
  800155:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800158:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80015b:	89 ec                	mov    %ebp,%esp
  80015d:	5d                   	pop    %ebp
  80015e:	c3                   	ret    
	...

00800160 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800166:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80016d:	e8 33 0f 00 00       	call   8010a5 <sys_env_destroy>
}
  800172:	c9                   	leave  
  800173:	c3                   	ret    

00800174 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	56                   	push   %esi
  800178:	53                   	push   %ebx
  800179:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  80017c:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80017f:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  800185:	e8 e7 0e 00 00       	call   801071 <sys_getenvid>
  80018a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800191:	8b 55 08             	mov    0x8(%ebp),%edx
  800194:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800198:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80019c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a0:	c7 04 24 d4 13 80 00 	movl   $0x8013d4,(%esp)
  8001a7:	e8 81 00 00 00       	call   80022d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b3:	89 04 24             	mov    %eax,(%esp)
  8001b6:	e8 11 00 00 00       	call   8001cc <vcprintf>
	cprintf("\n");
  8001bb:	c7 04 24 c8 13 80 00 	movl   $0x8013c8,(%esp)
  8001c2:	e8 66 00 00 00       	call   80022d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c7:	cc                   	int3   
  8001c8:	eb fd                	jmp    8001c7 <_panic+0x53>
	...

008001cc <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001dc:	00 00 00 
	b.cnt = 0;
  8001df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800201:	c7 04 24 47 02 80 00 	movl   $0x800247,(%esp)
  800208:	e8 be 01 00 00       	call   8003cb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800213:	89 44 24 04          	mov    %eax,0x4(%esp)
  800217:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021d:	89 04 24             	mov    %eax,(%esp)
  800220:	e8 2b 0a 00 00       	call   800c50 <sys_cputs>

	return b.cnt;
}
  800225:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022b:	c9                   	leave  
  80022c:	c3                   	ret    

0080022d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800233:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023a:	8b 45 08             	mov    0x8(%ebp),%eax
  80023d:	89 04 24             	mov    %eax,(%esp)
  800240:	e8 87 ff ff ff       	call   8001cc <vcprintf>
	va_end(ap);

	return cnt;
}
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	53                   	push   %ebx
  80024b:	83 ec 14             	sub    $0x14,%esp
  80024e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800251:	8b 03                	mov    (%ebx),%eax
  800253:	8b 55 08             	mov    0x8(%ebp),%edx
  800256:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80025a:	83 c0 01             	add    $0x1,%eax
  80025d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80025f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800264:	75 19                	jne    80027f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800266:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80026d:	00 
  80026e:	8d 43 08             	lea    0x8(%ebx),%eax
  800271:	89 04 24             	mov    %eax,(%esp)
  800274:	e8 d7 09 00 00       	call   800c50 <sys_cputs>
		b->idx = 0;
  800279:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80027f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800283:	83 c4 14             	add    $0x14,%esp
  800286:	5b                   	pop    %ebx
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    
  800289:	00 00                	add    %al,(%eax)
	...

0080028c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	57                   	push   %edi
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 4c             	sub    $0x4c,%esp
  800295:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800298:	89 d6                	mov    %edx,%esi
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ac:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b7:	39 d1                	cmp    %edx,%ecx
  8002b9:	72 07                	jb     8002c2 <printnum+0x36>
  8002bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002be:	39 d0                	cmp    %edx,%eax
  8002c0:	77 69                	ja     80032b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c2:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002c6:	83 eb 01             	sub    $0x1,%ebx
  8002c9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d1:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8002d5:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8002d9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8002dc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002df:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002e6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002ed:	00 
  8002ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002f1:	89 04 24             	mov    %eax,(%esp)
  8002f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002fb:	e8 10 0e 00 00       	call   801110 <__udivdi3>
  800300:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800303:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800306:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80030a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80030e:	89 04 24             	mov    %eax,(%esp)
  800311:	89 54 24 04          	mov    %edx,0x4(%esp)
  800315:	89 f2                	mov    %esi,%edx
  800317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031a:	e8 6d ff ff ff       	call   80028c <printnum>
  80031f:	eb 11                	jmp    800332 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800321:	89 74 24 04          	mov    %esi,0x4(%esp)
  800325:	89 3c 24             	mov    %edi,(%esp)
  800328:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80032b:	83 eb 01             	sub    $0x1,%ebx
  80032e:	85 db                	test   %ebx,%ebx
  800330:	7f ef                	jg     800321 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800332:	89 74 24 04          	mov    %esi,0x4(%esp)
  800336:	8b 74 24 04          	mov    0x4(%esp),%esi
  80033a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80033d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800341:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800348:	00 
  800349:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80034c:	89 14 24             	mov    %edx,(%esp)
  80034f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800352:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800356:	e8 e5 0e 00 00       	call   801240 <__umoddi3>
  80035b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80035f:	0f be 80 f7 13 80 00 	movsbl 0x8013f7(%eax),%eax
  800366:	89 04 24             	mov    %eax,(%esp)
  800369:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80036c:	83 c4 4c             	add    $0x4c,%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5f                   	pop    %edi
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    

00800374 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800377:	83 fa 01             	cmp    $0x1,%edx
  80037a:	7e 0e                	jle    80038a <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80037c:	8b 10                	mov    (%eax),%edx
  80037e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800381:	89 08                	mov    %ecx,(%eax)
  800383:	8b 02                	mov    (%edx),%eax
  800385:	8b 52 04             	mov    0x4(%edx),%edx
  800388:	eb 22                	jmp    8003ac <getuint+0x38>
	else if (lflag)
  80038a:	85 d2                	test   %edx,%edx
  80038c:	74 10                	je     80039e <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80038e:	8b 10                	mov    (%eax),%edx
  800390:	8d 4a 04             	lea    0x4(%edx),%ecx
  800393:	89 08                	mov    %ecx,(%eax)
  800395:	8b 02                	mov    (%edx),%eax
  800397:	ba 00 00 00 00       	mov    $0x0,%edx
  80039c:	eb 0e                	jmp    8003ac <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80039e:	8b 10                	mov    (%eax),%edx
  8003a0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a3:	89 08                	mov    %ecx,(%eax)
  8003a5:	8b 02                	mov    (%edx),%eax
  8003a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003ac:	5d                   	pop    %ebp
  8003ad:	c3                   	ret    

008003ae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003b4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b8:	8b 10                	mov    (%eax),%edx
  8003ba:	3b 50 04             	cmp    0x4(%eax),%edx
  8003bd:	73 0a                	jae    8003c9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003c2:	88 0a                	mov    %cl,(%edx)
  8003c4:	83 c2 01             	add    $0x1,%edx
  8003c7:	89 10                	mov    %edx,(%eax)
}
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    

008003cb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	57                   	push   %edi
  8003cf:	56                   	push   %esi
  8003d0:	53                   	push   %ebx
  8003d1:	83 ec 4c             	sub    $0x4c,%esp
  8003d4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003da:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8003dd:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8003e4:	eb 11                	jmp    8003f7 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003e6:	85 c0                	test   %eax,%eax
  8003e8:	0f 84 b6 03 00 00    	je     8007a4 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8003ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f2:	89 04 24             	mov    %eax,(%esp)
  8003f5:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003f7:	0f b6 03             	movzbl (%ebx),%eax
  8003fa:	83 c3 01             	add    $0x1,%ebx
  8003fd:	83 f8 25             	cmp    $0x25,%eax
  800400:	75 e4                	jne    8003e6 <vprintfmt+0x1b>
  800402:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800406:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80040d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800414:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80041b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800420:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800423:	eb 06                	jmp    80042b <vprintfmt+0x60>
  800425:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800429:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	0f b6 0b             	movzbl (%ebx),%ecx
  80042e:	0f b6 c1             	movzbl %cl,%eax
  800431:	8d 53 01             	lea    0x1(%ebx),%edx
  800434:	83 e9 23             	sub    $0x23,%ecx
  800437:	80 f9 55             	cmp    $0x55,%cl
  80043a:	0f 87 47 03 00 00    	ja     800787 <vprintfmt+0x3bc>
  800440:	0f b6 c9             	movzbl %cl,%ecx
  800443:	ff 24 8d 40 15 80 00 	jmp    *0x801540(,%ecx,4)
  80044a:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80044e:	eb d9                	jmp    800429 <vprintfmt+0x5e>
  800450:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800457:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80045c:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80045f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800463:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800466:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800469:	83 fb 09             	cmp    $0x9,%ebx
  80046c:	77 30                	ja     80049e <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80046e:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800471:	eb e9                	jmp    80045c <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	8d 48 04             	lea    0x4(%eax),%ecx
  800479:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800481:	eb 1e                	jmp    8004a1 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800483:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800487:	b8 00 00 00 00       	mov    $0x0,%eax
  80048c:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800493:	eb 94                	jmp    800429 <vprintfmt+0x5e>
  800495:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80049c:	eb 8b                	jmp    800429 <vprintfmt+0x5e>
  80049e:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8004a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004a5:	79 82                	jns    800429 <vprintfmt+0x5e>
  8004a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ad:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004b3:	e9 71 ff ff ff       	jmp    800429 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004b8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004bc:	e9 68 ff ff ff       	jmp    800429 <vprintfmt+0x5e>
  8004c1:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 50 04             	lea    0x4(%eax),%edx
  8004ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8004cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	89 04 24             	mov    %eax,(%esp)
  8004d6:	ff d7                	call   *%edi
  8004d8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8004db:	e9 17 ff ff ff       	jmp    8003f7 <vprintfmt+0x2c>
  8004e0:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e6:	8d 50 04             	lea    0x4(%eax),%edx
  8004e9:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	89 c2                	mov    %eax,%edx
  8004f0:	c1 fa 1f             	sar    $0x1f,%edx
  8004f3:	31 d0                	xor    %edx,%eax
  8004f5:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f7:	83 f8 11             	cmp    $0x11,%eax
  8004fa:	7f 0b                	jg     800507 <vprintfmt+0x13c>
  8004fc:	8b 14 85 a0 16 80 00 	mov    0x8016a0(,%eax,4),%edx
  800503:	85 d2                	test   %edx,%edx
  800505:	75 20                	jne    800527 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800507:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80050b:	c7 44 24 08 08 14 80 	movl   $0x801408,0x8(%esp)
  800512:	00 
  800513:	89 74 24 04          	mov    %esi,0x4(%esp)
  800517:	89 3c 24             	mov    %edi,(%esp)
  80051a:	e8 0d 03 00 00       	call   80082c <printfmt>
  80051f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800522:	e9 d0 fe ff ff       	jmp    8003f7 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800527:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80052b:	c7 44 24 08 11 14 80 	movl   $0x801411,0x8(%esp)
  800532:	00 
  800533:	89 74 24 04          	mov    %esi,0x4(%esp)
  800537:	89 3c 24             	mov    %edi,(%esp)
  80053a:	e8 ed 02 00 00       	call   80082c <printfmt>
  80053f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800542:	e9 b0 fe ff ff       	jmp    8003f7 <vprintfmt+0x2c>
  800547:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80054a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80054d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800550:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8d 50 04             	lea    0x4(%eax),%edx
  800559:	89 55 14             	mov    %edx,0x14(%ebp)
  80055c:	8b 18                	mov    (%eax),%ebx
  80055e:	85 db                	test   %ebx,%ebx
  800560:	b8 14 14 80 00       	mov    $0x801414,%eax
  800565:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800568:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80056c:	7e 76                	jle    8005e4 <vprintfmt+0x219>
  80056e:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800572:	74 7a                	je     8005ee <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800574:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800578:	89 1c 24             	mov    %ebx,(%esp)
  80057b:	e8 f8 02 00 00       	call   800878 <strnlen>
  800580:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800583:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800585:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800589:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80058c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80058f:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800591:	eb 0f                	jmp    8005a2 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800593:	89 74 24 04          	mov    %esi,0x4(%esp)
  800597:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059a:	89 04 24             	mov    %eax,(%esp)
  80059d:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80059f:	83 eb 01             	sub    $0x1,%ebx
  8005a2:	85 db                	test   %ebx,%ebx
  8005a4:	7f ed                	jg     800593 <vprintfmt+0x1c8>
  8005a6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005a9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005ac:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005af:	89 f7                	mov    %esi,%edi
  8005b1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005b4:	eb 40                	jmp    8005f6 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005b6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ba:	74 18                	je     8005d4 <vprintfmt+0x209>
  8005bc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005bf:	83 fa 5e             	cmp    $0x5e,%edx
  8005c2:	76 10                	jbe    8005d4 <vprintfmt+0x209>
					putch('?', putdat);
  8005c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005cf:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005d2:	eb 0a                	jmp    8005de <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8005d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005d8:	89 04 24             	mov    %eax,(%esp)
  8005db:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005de:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005e2:	eb 12                	jmp    8005f6 <vprintfmt+0x22b>
  8005e4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005e7:	89 f7                	mov    %esi,%edi
  8005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005ec:	eb 08                	jmp    8005f6 <vprintfmt+0x22b>
  8005ee:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005f1:	89 f7                	mov    %esi,%edi
  8005f3:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005f6:	0f be 03             	movsbl (%ebx),%eax
  8005f9:	83 c3 01             	add    $0x1,%ebx
  8005fc:	85 c0                	test   %eax,%eax
  8005fe:	74 25                	je     800625 <vprintfmt+0x25a>
  800600:	85 f6                	test   %esi,%esi
  800602:	78 b2                	js     8005b6 <vprintfmt+0x1eb>
  800604:	83 ee 01             	sub    $0x1,%esi
  800607:	79 ad                	jns    8005b6 <vprintfmt+0x1eb>
  800609:	89 fe                	mov    %edi,%esi
  80060b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80060e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800611:	eb 1a                	jmp    80062d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800613:	89 74 24 04          	mov    %esi,0x4(%esp)
  800617:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80061e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800620:	83 eb 01             	sub    $0x1,%ebx
  800623:	eb 08                	jmp    80062d <vprintfmt+0x262>
  800625:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800628:	89 fe                	mov    %edi,%esi
  80062a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80062d:	85 db                	test   %ebx,%ebx
  80062f:	7f e2                	jg     800613 <vprintfmt+0x248>
  800631:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800634:	e9 be fd ff ff       	jmp    8003f7 <vprintfmt+0x2c>
  800639:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80063c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80063f:	83 f9 01             	cmp    $0x1,%ecx
  800642:	7e 16                	jle    80065a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 50 08             	lea    0x8(%eax),%edx
  80064a:	89 55 14             	mov    %edx,0x14(%ebp)
  80064d:	8b 10                	mov    (%eax),%edx
  80064f:	8b 48 04             	mov    0x4(%eax),%ecx
  800652:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800655:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800658:	eb 32                	jmp    80068c <vprintfmt+0x2c1>
	else if (lflag)
  80065a:	85 c9                	test   %ecx,%ecx
  80065c:	74 18                	je     800676 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8d 50 04             	lea    0x4(%eax),%edx
  800664:	89 55 14             	mov    %edx,0x14(%ebp)
  800667:	8b 00                	mov    (%eax),%eax
  800669:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066c:	89 c1                	mov    %eax,%ecx
  80066e:	c1 f9 1f             	sar    $0x1f,%ecx
  800671:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800674:	eb 16                	jmp    80068c <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8d 50 04             	lea    0x4(%eax),%edx
  80067c:	89 55 14             	mov    %edx,0x14(%ebp)
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	89 c2                	mov    %eax,%edx
  800686:	c1 fa 1f             	sar    $0x1f,%edx
  800689:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80068c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80068f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800692:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800697:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80069b:	0f 89 a7 00 00 00    	jns    800748 <vprintfmt+0x37d>
				putch('-', putdat);
  8006a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006a5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006ac:	ff d7                	call   *%edi
				num = -(long long) num;
  8006ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006b1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006b4:	f7 d9                	neg    %ecx
  8006b6:	83 d3 00             	adc    $0x0,%ebx
  8006b9:	f7 db                	neg    %ebx
  8006bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c0:	e9 83 00 00 00       	jmp    800748 <vprintfmt+0x37d>
  8006c5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006c8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006cb:	89 ca                	mov    %ecx,%edx
  8006cd:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d0:	e8 9f fc ff ff       	call   800374 <getuint>
  8006d5:	89 c1                	mov    %eax,%ecx
  8006d7:	89 d3                	mov    %edx,%ebx
  8006d9:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8006de:	eb 68                	jmp    800748 <vprintfmt+0x37d>
  8006e0:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006e3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006e6:	89 ca                	mov    %ecx,%edx
  8006e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006eb:	e8 84 fc ff ff       	call   800374 <getuint>
  8006f0:	89 c1                	mov    %eax,%ecx
  8006f2:	89 d3                	mov    %edx,%ebx
  8006f4:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8006f9:	eb 4d                	jmp    800748 <vprintfmt+0x37d>
  8006fb:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8006fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800702:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800709:	ff d7                	call   *%edi
			putch('x', putdat);
  80070b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800716:	ff d7                	call   *%edi
			num = (unsigned long long)
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8d 50 04             	lea    0x4(%eax),%edx
  80071e:	89 55 14             	mov    %edx,0x14(%ebp)
  800721:	8b 08                	mov    (%eax),%ecx
  800723:	bb 00 00 00 00       	mov    $0x0,%ebx
  800728:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80072d:	eb 19                	jmp    800748 <vprintfmt+0x37d>
  80072f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800732:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800735:	89 ca                	mov    %ecx,%edx
  800737:	8d 45 14             	lea    0x14(%ebp),%eax
  80073a:	e8 35 fc ff ff       	call   800374 <getuint>
  80073f:	89 c1                	mov    %eax,%ecx
  800741:	89 d3                	mov    %edx,%ebx
  800743:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800748:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  80074c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800750:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800753:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800757:	89 44 24 08          	mov    %eax,0x8(%esp)
  80075b:	89 0c 24             	mov    %ecx,(%esp)
  80075e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800762:	89 f2                	mov    %esi,%edx
  800764:	89 f8                	mov    %edi,%eax
  800766:	e8 21 fb ff ff       	call   80028c <printnum>
  80076b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80076e:	e9 84 fc ff ff       	jmp    8003f7 <vprintfmt+0x2c>
  800773:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800776:	89 74 24 04          	mov    %esi,0x4(%esp)
  80077a:	89 04 24             	mov    %eax,(%esp)
  80077d:	ff d7                	call   *%edi
  80077f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800782:	e9 70 fc ff ff       	jmp    8003f7 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800787:	89 74 24 04          	mov    %esi,0x4(%esp)
  80078b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800792:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800794:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800797:	80 38 25             	cmpb   $0x25,(%eax)
  80079a:	0f 84 57 fc ff ff    	je     8003f7 <vprintfmt+0x2c>
  8007a0:	89 c3                	mov    %eax,%ebx
  8007a2:	eb f0                	jmp    800794 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8007a4:	83 c4 4c             	add    $0x4c,%esp
  8007a7:	5b                   	pop    %ebx
  8007a8:	5e                   	pop    %esi
  8007a9:	5f                   	pop    %edi
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	83 ec 28             	sub    $0x28,%esp
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8007b8:	85 c0                	test   %eax,%eax
  8007ba:	74 04                	je     8007c0 <vsnprintf+0x14>
  8007bc:	85 d2                	test   %edx,%edx
  8007be:	7f 07                	jg     8007c7 <vsnprintf+0x1b>
  8007c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c5:	eb 3b                	jmp    800802 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ca:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8007ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007df:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ed:	c7 04 24 ae 03 80 00 	movl   $0x8003ae,(%esp)
  8007f4:	e8 d2 fb ff ff       	call   8003cb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007fc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800802:	c9                   	leave  
  800803:	c3                   	ret    

00800804 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80080a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  80080d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800811:	8b 45 10             	mov    0x10(%ebp),%eax
  800814:	89 44 24 08          	mov    %eax,0x8(%esp)
  800818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	89 04 24             	mov    %eax,(%esp)
  800825:	e8 82 ff ff ff       	call   8007ac <vsnprintf>
	va_end(ap);

	return rc;
}
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800832:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800835:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800839:	8b 45 10             	mov    0x10(%ebp),%eax
  80083c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800840:	8b 45 0c             	mov    0xc(%ebp),%eax
  800843:	89 44 24 04          	mov    %eax,0x4(%esp)
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	89 04 24             	mov    %eax,(%esp)
  80084d:	e8 79 fb ff ff       	call   8003cb <vprintfmt>
	va_end(ap);
}
  800852:	c9                   	leave  
  800853:	c3                   	ret    
	...

00800860 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 55 08             	mov    0x8(%ebp),%edx
  800866:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80086b:	eb 03                	jmp    800870 <strlen+0x10>
		n++;
  80086d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800870:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800874:	75 f7                	jne    80086d <strlen+0xd>
		n++;
	return n;
}
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	53                   	push   %ebx
  80087c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80087f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800882:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800887:	eb 03                	jmp    80088c <strnlen+0x14>
		n++;
  800889:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088c:	39 c1                	cmp    %eax,%ecx
  80088e:	74 06                	je     800896 <strnlen+0x1e>
  800890:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800894:	75 f3                	jne    800889 <strnlen+0x11>
		n++;
	return n;
}
  800896:	5b                   	pop    %ebx
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	53                   	push   %ebx
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008af:	83 c2 01             	add    $0x1,%edx
  8008b2:	84 c9                	test   %cl,%cl
  8008b4:	75 f2                	jne    8008a8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008b6:	5b                   	pop    %ebx
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	53                   	push   %ebx
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c3:	89 1c 24             	mov    %ebx,(%esp)
  8008c6:	e8 95 ff ff ff       	call   800860 <strlen>
	strcpy(dst + len, src);
  8008cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008d2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8008d5:	89 04 24             	mov    %eax,(%esp)
  8008d8:	e8 bc ff ff ff       	call   800899 <strcpy>
	return dst;
}
  8008dd:	89 d8                	mov    %ebx,%eax
  8008df:	83 c4 08             	add    $0x8,%esp
  8008e2:	5b                   	pop    %ebx
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	56                   	push   %esi
  8008e9:	53                   	push   %ebx
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f0:	8b 75 10             	mov    0x10(%ebp),%esi
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f8:	eb 0f                	jmp    800909 <strncpy+0x24>
		*dst++ = *src;
  8008fa:	0f b6 19             	movzbl (%ecx),%ebx
  8008fd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800900:	80 39 01             	cmpb   $0x1,(%ecx)
  800903:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800906:	83 c2 01             	add    $0x1,%edx
  800909:	39 f2                	cmp    %esi,%edx
  80090b:	72 ed                	jb     8008fa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80090d:	5b                   	pop    %ebx
  80090e:	5e                   	pop    %esi
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	56                   	push   %esi
  800915:	53                   	push   %ebx
  800916:	8b 75 08             	mov    0x8(%ebp),%esi
  800919:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80091f:	89 f0                	mov    %esi,%eax
  800921:	85 d2                	test   %edx,%edx
  800923:	75 0a                	jne    80092f <strlcpy+0x1e>
  800925:	eb 17                	jmp    80093e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800927:	88 18                	mov    %bl,(%eax)
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80092f:	83 ea 01             	sub    $0x1,%edx
  800932:	74 07                	je     80093b <strlcpy+0x2a>
  800934:	0f b6 19             	movzbl (%ecx),%ebx
  800937:	84 db                	test   %bl,%bl
  800939:	75 ec                	jne    800927 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80093b:	c6 00 00             	movb   $0x0,(%eax)
  80093e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800940:	5b                   	pop    %ebx
  800941:	5e                   	pop    %esi
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80094d:	eb 06                	jmp    800955 <strcmp+0x11>
		p++, q++;
  80094f:	83 c1 01             	add    $0x1,%ecx
  800952:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800955:	0f b6 01             	movzbl (%ecx),%eax
  800958:	84 c0                	test   %al,%al
  80095a:	74 04                	je     800960 <strcmp+0x1c>
  80095c:	3a 02                	cmp    (%edx),%al
  80095e:	74 ef                	je     80094f <strcmp+0xb>
  800960:	0f b6 c0             	movzbl %al,%eax
  800963:	0f b6 12             	movzbl (%edx),%edx
  800966:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	53                   	push   %ebx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800974:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800977:	eb 09                	jmp    800982 <strncmp+0x18>
		n--, p++, q++;
  800979:	83 ea 01             	sub    $0x1,%edx
  80097c:	83 c0 01             	add    $0x1,%eax
  80097f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800982:	85 d2                	test   %edx,%edx
  800984:	75 07                	jne    80098d <strncmp+0x23>
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
  80098b:	eb 13                	jmp    8009a0 <strncmp+0x36>
  80098d:	0f b6 18             	movzbl (%eax),%ebx
  800990:	84 db                	test   %bl,%bl
  800992:	74 04                	je     800998 <strncmp+0x2e>
  800994:	3a 19                	cmp    (%ecx),%bl
  800996:	74 e1                	je     800979 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 00             	movzbl (%eax),%eax
  80099b:	0f b6 11             	movzbl (%ecx),%edx
  80099e:	29 d0                	sub    %edx,%eax
}
  8009a0:	5b                   	pop    %ebx
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ad:	eb 07                	jmp    8009b6 <strchr+0x13>
		if (*s == c)
  8009af:	38 ca                	cmp    %cl,%dl
  8009b1:	74 0f                	je     8009c2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	0f b6 10             	movzbl (%eax),%edx
  8009b9:	84 d2                	test   %dl,%dl
  8009bb:	75 f2                	jne    8009af <strchr+0xc>
  8009bd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ce:	eb 07                	jmp    8009d7 <strfind+0x13>
		if (*s == c)
  8009d0:	38 ca                	cmp    %cl,%dl
  8009d2:	74 0a                	je     8009de <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009d4:	83 c0 01             	add    $0x1,%eax
  8009d7:	0f b6 10             	movzbl (%eax),%edx
  8009da:	84 d2                	test   %dl,%dl
  8009dc:	75 f2                	jne    8009d0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009de:	5d                   	pop    %ebp
  8009df:	c3                   	ret    

008009e0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	83 ec 0c             	sub    $0xc,%esp
  8009e6:	89 1c 24             	mov    %ebx,(%esp)
  8009e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009ed:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009fa:	85 c9                	test   %ecx,%ecx
  8009fc:	74 30                	je     800a2e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009fe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a04:	75 25                	jne    800a2b <memset+0x4b>
  800a06:	f6 c1 03             	test   $0x3,%cl
  800a09:	75 20                	jne    800a2b <memset+0x4b>
		c &= 0xFF;
  800a0b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a0e:	89 d3                	mov    %edx,%ebx
  800a10:	c1 e3 08             	shl    $0x8,%ebx
  800a13:	89 d6                	mov    %edx,%esi
  800a15:	c1 e6 18             	shl    $0x18,%esi
  800a18:	89 d0                	mov    %edx,%eax
  800a1a:	c1 e0 10             	shl    $0x10,%eax
  800a1d:	09 f0                	or     %esi,%eax
  800a1f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a21:	09 d8                	or     %ebx,%eax
  800a23:	c1 e9 02             	shr    $0x2,%ecx
  800a26:	fc                   	cld    
  800a27:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a29:	eb 03                	jmp    800a2e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a2b:	fc                   	cld    
  800a2c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a2e:	89 f8                	mov    %edi,%eax
  800a30:	8b 1c 24             	mov    (%esp),%ebx
  800a33:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a37:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a3b:	89 ec                	mov    %ebp,%esp
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	89 34 24             	mov    %esi,(%esp)
  800a48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800a52:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a55:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a57:	39 c6                	cmp    %eax,%esi
  800a59:	73 35                	jae    800a90 <memmove+0x51>
  800a5b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5e:	39 d0                	cmp    %edx,%eax
  800a60:	73 2e                	jae    800a90 <memmove+0x51>
		s += n;
		d += n;
  800a62:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a64:	f6 c2 03             	test   $0x3,%dl
  800a67:	75 1b                	jne    800a84 <memmove+0x45>
  800a69:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a6f:	75 13                	jne    800a84 <memmove+0x45>
  800a71:	f6 c1 03             	test   $0x3,%cl
  800a74:	75 0e                	jne    800a84 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a76:	83 ef 04             	sub    $0x4,%edi
  800a79:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a7c:	c1 e9 02             	shr    $0x2,%ecx
  800a7f:	fd                   	std    
  800a80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a82:	eb 09                	jmp    800a8d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a84:	83 ef 01             	sub    $0x1,%edi
  800a87:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a8a:	fd                   	std    
  800a8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a8e:	eb 20                	jmp    800ab0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a90:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a96:	75 15                	jne    800aad <memmove+0x6e>
  800a98:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a9e:	75 0d                	jne    800aad <memmove+0x6e>
  800aa0:	f6 c1 03             	test   $0x3,%cl
  800aa3:	75 08                	jne    800aad <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800aa5:	c1 e9 02             	shr    $0x2,%ecx
  800aa8:	fc                   	cld    
  800aa9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aab:	eb 03                	jmp    800ab0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aad:	fc                   	cld    
  800aae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ab0:	8b 34 24             	mov    (%esp),%esi
  800ab3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ab7:	89 ec                	mov    %ebp,%esp
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	89 04 24             	mov    %eax,(%esp)
  800ad5:	e8 65 ff ff ff       	call   800a3f <memmove>
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	57                   	push   %edi
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
  800ae2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ae5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af0:	eb 1c                	jmp    800b0e <memcmp+0x32>
		if (*s1 != *s2)
  800af2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800af6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800afa:	83 c2 01             	add    $0x1,%edx
  800afd:	83 e9 01             	sub    $0x1,%ecx
  800b00:	38 d8                	cmp    %bl,%al
  800b02:	74 0a                	je     800b0e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800b04:	0f b6 c0             	movzbl %al,%eax
  800b07:	0f b6 db             	movzbl %bl,%ebx
  800b0a:	29 d8                	sub    %ebx,%eax
  800b0c:	eb 09                	jmp    800b17 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0e:	85 c9                	test   %ecx,%ecx
  800b10:	75 e0                	jne    800af2 <memcmp+0x16>
  800b12:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b17:	5b                   	pop    %ebx
  800b18:	5e                   	pop    %esi
  800b19:	5f                   	pop    %edi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b25:	89 c2                	mov    %eax,%edx
  800b27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b2a:	eb 07                	jmp    800b33 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b2c:	38 08                	cmp    %cl,(%eax)
  800b2e:	74 07                	je     800b37 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b30:	83 c0 01             	add    $0x1,%eax
  800b33:	39 d0                	cmp    %edx,%eax
  800b35:	72 f5                	jb     800b2c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	57                   	push   %edi
  800b3d:	56                   	push   %esi
  800b3e:	53                   	push   %ebx
  800b3f:	83 ec 04             	sub    $0x4,%esp
  800b42:	8b 55 08             	mov    0x8(%ebp),%edx
  800b45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b48:	eb 03                	jmp    800b4d <strtol+0x14>
		s++;
  800b4a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4d:	0f b6 02             	movzbl (%edx),%eax
  800b50:	3c 20                	cmp    $0x20,%al
  800b52:	74 f6                	je     800b4a <strtol+0x11>
  800b54:	3c 09                	cmp    $0x9,%al
  800b56:	74 f2                	je     800b4a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b58:	3c 2b                	cmp    $0x2b,%al
  800b5a:	75 0c                	jne    800b68 <strtol+0x2f>
		s++;
  800b5c:	8d 52 01             	lea    0x1(%edx),%edx
  800b5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b66:	eb 15                	jmp    800b7d <strtol+0x44>
	else if (*s == '-')
  800b68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b6f:	3c 2d                	cmp    $0x2d,%al
  800b71:	75 0a                	jne    800b7d <strtol+0x44>
		s++, neg = 1;
  800b73:	8d 52 01             	lea    0x1(%edx),%edx
  800b76:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7d:	85 db                	test   %ebx,%ebx
  800b7f:	0f 94 c0             	sete   %al
  800b82:	74 05                	je     800b89 <strtol+0x50>
  800b84:	83 fb 10             	cmp    $0x10,%ebx
  800b87:	75 15                	jne    800b9e <strtol+0x65>
  800b89:	80 3a 30             	cmpb   $0x30,(%edx)
  800b8c:	75 10                	jne    800b9e <strtol+0x65>
  800b8e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b92:	75 0a                	jne    800b9e <strtol+0x65>
		s += 2, base = 16;
  800b94:	83 c2 02             	add    $0x2,%edx
  800b97:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9c:	eb 13                	jmp    800bb1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b9e:	84 c0                	test   %al,%al
  800ba0:	74 0f                	je     800bb1 <strtol+0x78>
  800ba2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ba7:	80 3a 30             	cmpb   $0x30,(%edx)
  800baa:	75 05                	jne    800bb1 <strtol+0x78>
		s++, base = 8;
  800bac:	83 c2 01             	add    $0x1,%edx
  800baf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bb8:	0f b6 0a             	movzbl (%edx),%ecx
  800bbb:	89 cf                	mov    %ecx,%edi
  800bbd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bc0:	80 fb 09             	cmp    $0x9,%bl
  800bc3:	77 08                	ja     800bcd <strtol+0x94>
			dig = *s - '0';
  800bc5:	0f be c9             	movsbl %cl,%ecx
  800bc8:	83 e9 30             	sub    $0x30,%ecx
  800bcb:	eb 1e                	jmp    800beb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800bcd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800bd0:	80 fb 19             	cmp    $0x19,%bl
  800bd3:	77 08                	ja     800bdd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800bd5:	0f be c9             	movsbl %cl,%ecx
  800bd8:	83 e9 57             	sub    $0x57,%ecx
  800bdb:	eb 0e                	jmp    800beb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800bdd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800be0:	80 fb 19             	cmp    $0x19,%bl
  800be3:	77 15                	ja     800bfa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800be5:	0f be c9             	movsbl %cl,%ecx
  800be8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800beb:	39 f1                	cmp    %esi,%ecx
  800bed:	7d 0b                	jge    800bfa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bef:	83 c2 01             	add    $0x1,%edx
  800bf2:	0f af c6             	imul   %esi,%eax
  800bf5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800bf8:	eb be                	jmp    800bb8 <strtol+0x7f>
  800bfa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800bfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c00:	74 05                	je     800c07 <strtol+0xce>
		*endptr = (char *) s;
  800c02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c05:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c07:	89 ca                	mov    %ecx,%edx
  800c09:	f7 da                	neg    %edx
  800c0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c0f:	0f 45 c2             	cmovne %edx,%eax
}
  800c12:	83 c4 04             	add    $0x4,%esp
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5f                   	pop    %edi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    
	...

00800c1c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 0c             	sub    $0xc,%esp
  800c22:	89 1c 24             	mov    %ebx,(%esp)
  800c25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c29:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c32:	b8 01 00 00 00       	mov    $0x1,%eax
  800c37:	89 d1                	mov    %edx,%ecx
  800c39:	89 d3                	mov    %edx,%ebx
  800c3b:	89 d7                	mov    %edx,%edi
  800c3d:	89 d6                	mov    %edx,%esi
  800c3f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c41:	8b 1c 24             	mov    (%esp),%ebx
  800c44:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c48:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c4c:	89 ec                	mov    %ebp,%esp
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 0c             	sub    $0xc,%esp
  800c56:	89 1c 24             	mov    %ebx,(%esp)
  800c59:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c5d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c61:	b8 00 00 00 00       	mov    $0x0,%eax
  800c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	89 c3                	mov    %eax,%ebx
  800c6e:	89 c7                	mov    %eax,%edi
  800c70:	89 c6                	mov    %eax,%esi
  800c72:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c74:	8b 1c 24             	mov    (%esp),%ebx
  800c77:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c7b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c7f:	89 ec                	mov    %ebp,%esp
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 0c             	sub    $0xc,%esp
  800c89:	89 1c 24             	mov    %ebx,(%esp)
  800c8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c90:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c94:	ba 00 00 00 00       	mov    $0x0,%edx
  800c99:	b8 10 00 00 00       	mov    $0x10,%eax
  800c9e:	89 d1                	mov    %edx,%ecx
  800ca0:	89 d3                	mov    %edx,%ebx
  800ca2:	89 d7                	mov    %edx,%edi
  800ca4:	89 d6                	mov    %edx,%esi
  800ca6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ca8:	8b 1c 24             	mov    (%esp),%ebx
  800cab:	8b 74 24 04          	mov    0x4(%esp),%esi
  800caf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cb3:	89 ec                	mov    %ebp,%esp
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 38             	sub    $0x38,%esp
  800cbd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cc0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cc3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ccb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800cd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd6:	89 df                	mov    %ebx,%edi
  800cd8:	89 de                	mov    %ebx,%esi
  800cda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cdc:	85 c0                	test   %eax,%eax
  800cde:	7e 28                	jle    800d08 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ce4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ceb:	00 
  800cec:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  800cf3:	00 
  800cf4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cfb:	00 
  800cfc:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  800d03:	e8 6c f4 ff ff       	call   800174 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800d08:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d0b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d0e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d11:	89 ec                	mov    %ebp,%esp
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 38             	sub    $0x38,%esp
  800d1b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d1e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d21:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d29:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d31:	8b 55 08             	mov    0x8(%ebp),%edx
  800d34:	89 df                	mov    %ebx,%edi
  800d36:	89 de                	mov    %ebx,%esi
  800d38:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	7e 28                	jle    800d66 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d42:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800d49:	00 
  800d4a:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  800d51:	00 
  800d52:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d59:	00 
  800d5a:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  800d61:	e8 0e f4 ff ff       	call   800174 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800d66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d69:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d6c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d6f:	89 ec                	mov    %ebp,%esp
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 38             	sub    $0x38,%esp
  800d79:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d7f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d87:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8f:	89 cb                	mov    %ecx,%ebx
  800d91:	89 cf                	mov    %ecx,%edi
  800d93:	89 ce                	mov    %ecx,%esi
  800d95:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7e 28                	jle    800dc3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d9f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800da6:	00 
  800da7:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  800dae:	00 
  800daf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db6:	00 
  800db7:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  800dbe:	e8 b1 f3 ff ff       	call   800174 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dc3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dc6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dc9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dcc:	89 ec                	mov    %ebp,%esp
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	89 1c 24             	mov    %ebx,(%esp)
  800dd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ddd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de1:	be 00 00 00 00       	mov    $0x0,%esi
  800de6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800deb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df9:	8b 1c 24             	mov    (%esp),%ebx
  800dfc:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e00:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e04:	89 ec                	mov    %ebp,%esp
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    

00800e08 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 38             	sub    $0x38,%esp
  800e0e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e11:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e14:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	89 de                	mov    %ebx,%esi
  800e2b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7e 28                	jle    800e59 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e31:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e35:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e3c:	00 
  800e3d:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  800e44:	00 
  800e45:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e4c:	00 
  800e4d:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  800e54:	e8 1b f3 ff ff       	call   800174 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e59:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e5c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e5f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e62:	89 ec                	mov    %ebp,%esp
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    

00800e66 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 38             	sub    $0x38,%esp
  800e6c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e6f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e72:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	89 df                	mov    %ebx,%edi
  800e87:	89 de                	mov    %ebx,%esi
  800e89:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	7e 28                	jle    800eb7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e93:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e9a:	00 
  800e9b:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  800ea2:	00 
  800ea3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eaa:	00 
  800eab:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  800eb2:	e8 bd f2 ff ff       	call   800174 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ebd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ec0:	89 ec                	mov    %ebp,%esp
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 38             	sub    $0x38,%esp
  800eca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ecd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ed0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed8:	b8 08 00 00 00       	mov    $0x8,%eax
  800edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	89 df                	mov    %ebx,%edi
  800ee5:	89 de                	mov    %ebx,%esi
  800ee7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	7e 28                	jle    800f15 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eed:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ef8:	00 
  800ef9:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  800f00:	00 
  800f01:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f08:	00 
  800f09:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  800f10:	e8 5f f2 ff ff       	call   800174 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f15:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f18:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f1b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f1e:	89 ec                	mov    %ebp,%esp
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    

00800f22 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	83 ec 38             	sub    $0x38,%esp
  800f28:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f2b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f2e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f31:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f36:	b8 06 00 00 00       	mov    $0x6,%eax
  800f3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	89 df                	mov    %ebx,%edi
  800f43:	89 de                	mov    %ebx,%esi
  800f45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f47:	85 c0                	test   %eax,%eax
  800f49:	7e 28                	jle    800f73 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f4f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f56:	00 
  800f57:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  800f5e:	00 
  800f5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f66:	00 
  800f67:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  800f6e:	e8 01 f2 ff ff       	call   800174 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f73:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f76:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f79:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f7c:	89 ec                	mov    %ebp,%esp
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 38             	sub    $0x38,%esp
  800f86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f89:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f8c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f94:	8b 75 18             	mov    0x18(%ebp),%esi
  800f97:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	7e 28                	jle    800fd1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fad:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fb4:	00 
  800fb5:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  800fbc:	00 
  800fbd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc4:	00 
  800fc5:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  800fcc:	e8 a3 f1 ff ff       	call   800174 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fd1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fd4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fd7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fda:	89 ec                	mov    %ebp,%esp
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    

00800fde <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	83 ec 38             	sub    $0x38,%esp
  800fe4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fe7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fed:	be 00 00 00 00       	mov    $0x0,%esi
  800ff2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ff7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ffa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  801000:	89 f7                	mov    %esi,%edi
  801002:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801004:	85 c0                	test   %eax,%eax
  801006:	7e 28                	jle    801030 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801008:	89 44 24 10          	mov    %eax,0x10(%esp)
  80100c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801013:	00 
  801014:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  80101b:	00 
  80101c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801023:	00 
  801024:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  80102b:	e8 44 f1 ff ff       	call   800174 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801030:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801033:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801036:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801039:	89 ec                	mov    %ebp,%esp
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 0c             	sub    $0xc,%esp
  801043:	89 1c 24             	mov    %ebx,(%esp)
  801046:	89 74 24 04          	mov    %esi,0x4(%esp)
  80104a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	b8 0b 00 00 00       	mov    $0xb,%eax
  801058:	89 d1                	mov    %edx,%ecx
  80105a:	89 d3                	mov    %edx,%ebx
  80105c:	89 d7                	mov    %edx,%edi
  80105e:	89 d6                	mov    %edx,%esi
  801060:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801062:	8b 1c 24             	mov    (%esp),%ebx
  801065:	8b 74 24 04          	mov    0x4(%esp),%esi
  801069:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80106d:	89 ec                	mov    %ebp,%esp
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    

00801071 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	89 1c 24             	mov    %ebx,(%esp)
  80107a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80107e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801082:	ba 00 00 00 00       	mov    $0x0,%edx
  801087:	b8 02 00 00 00       	mov    $0x2,%eax
  80108c:	89 d1                	mov    %edx,%ecx
  80108e:	89 d3                	mov    %edx,%ebx
  801090:	89 d7                	mov    %edx,%edi
  801092:	89 d6                	mov    %edx,%esi
  801094:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801096:	8b 1c 24             	mov    (%esp),%ebx
  801099:	8b 74 24 04          	mov    0x4(%esp),%esi
  80109d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010a1:	89 ec                	mov    %ebp,%esp
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 38             	sub    $0x38,%esp
  8010ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8010be:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c1:	89 cb                	mov    %ecx,%ebx
  8010c3:	89 cf                	mov    %ecx,%edi
  8010c5:	89 ce                	mov    %ecx,%esi
  8010c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	7e 28                	jle    8010f5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010d8:	00 
  8010d9:	c7 44 24 08 08 17 80 	movl   $0x801708,0x8(%esp)
  8010e0:	00 
  8010e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e8:	00 
  8010e9:	c7 04 24 25 17 80 00 	movl   $0x801725,(%esp)
  8010f0:	e8 7f f0 ff ff       	call   800174 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010fe:	89 ec                	mov    %ebp,%esp
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    
	...

00801110 <__udivdi3>:
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	57                   	push   %edi
  801114:	56                   	push   %esi
  801115:	83 ec 10             	sub    $0x10,%esp
  801118:	8b 45 14             	mov    0x14(%ebp),%eax
  80111b:	8b 55 08             	mov    0x8(%ebp),%edx
  80111e:	8b 75 10             	mov    0x10(%ebp),%esi
  801121:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801124:	85 c0                	test   %eax,%eax
  801126:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801129:	75 35                	jne    801160 <__udivdi3+0x50>
  80112b:	39 fe                	cmp    %edi,%esi
  80112d:	77 61                	ja     801190 <__udivdi3+0x80>
  80112f:	85 f6                	test   %esi,%esi
  801131:	75 0b                	jne    80113e <__udivdi3+0x2e>
  801133:	b8 01 00 00 00       	mov    $0x1,%eax
  801138:	31 d2                	xor    %edx,%edx
  80113a:	f7 f6                	div    %esi
  80113c:	89 c6                	mov    %eax,%esi
  80113e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801141:	31 d2                	xor    %edx,%edx
  801143:	89 f8                	mov    %edi,%eax
  801145:	f7 f6                	div    %esi
  801147:	89 c7                	mov    %eax,%edi
  801149:	89 c8                	mov    %ecx,%eax
  80114b:	f7 f6                	div    %esi
  80114d:	89 c1                	mov    %eax,%ecx
  80114f:	89 fa                	mov    %edi,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    
  80115a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801160:	39 f8                	cmp    %edi,%eax
  801162:	77 1c                	ja     801180 <__udivdi3+0x70>
  801164:	0f bd d0             	bsr    %eax,%edx
  801167:	83 f2 1f             	xor    $0x1f,%edx
  80116a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80116d:	75 39                	jne    8011a8 <__udivdi3+0x98>
  80116f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801172:	0f 86 a0 00 00 00    	jbe    801218 <__udivdi3+0x108>
  801178:	39 f8                	cmp    %edi,%eax
  80117a:	0f 82 98 00 00 00    	jb     801218 <__udivdi3+0x108>
  801180:	31 ff                	xor    %edi,%edi
  801182:	31 c9                	xor    %ecx,%ecx
  801184:	89 c8                	mov    %ecx,%eax
  801186:	89 fa                	mov    %edi,%edx
  801188:	83 c4 10             	add    $0x10,%esp
  80118b:	5e                   	pop    %esi
  80118c:	5f                   	pop    %edi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    
  80118f:	90                   	nop
  801190:	89 d1                	mov    %edx,%ecx
  801192:	89 fa                	mov    %edi,%edx
  801194:	89 c8                	mov    %ecx,%eax
  801196:	31 ff                	xor    %edi,%edi
  801198:	f7 f6                	div    %esi
  80119a:	89 c1                	mov    %eax,%ecx
  80119c:	89 fa                	mov    %edi,%edx
  80119e:	89 c8                	mov    %ecx,%eax
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	5e                   	pop    %esi
  8011a4:	5f                   	pop    %edi
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    
  8011a7:	90                   	nop
  8011a8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011ac:	89 f2                	mov    %esi,%edx
  8011ae:	d3 e0                	shl    %cl,%eax
  8011b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b3:	b8 20 00 00 00       	mov    $0x20,%eax
  8011b8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8011bb:	89 c1                	mov    %eax,%ecx
  8011bd:	d3 ea                	shr    %cl,%edx
  8011bf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011c3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8011c6:	d3 e6                	shl    %cl,%esi
  8011c8:	89 c1                	mov    %eax,%ecx
  8011ca:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8011cd:	89 fe                	mov    %edi,%esi
  8011cf:	d3 ee                	shr    %cl,%esi
  8011d1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8011d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011db:	d3 e7                	shl    %cl,%edi
  8011dd:	89 c1                	mov    %eax,%ecx
  8011df:	d3 ea                	shr    %cl,%edx
  8011e1:	09 d7                	or     %edx,%edi
  8011e3:	89 f2                	mov    %esi,%edx
  8011e5:	89 f8                	mov    %edi,%eax
  8011e7:	f7 75 ec             	divl   -0x14(%ebp)
  8011ea:	89 d6                	mov    %edx,%esi
  8011ec:	89 c7                	mov    %eax,%edi
  8011ee:	f7 65 e8             	mull   -0x18(%ebp)
  8011f1:	39 d6                	cmp    %edx,%esi
  8011f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8011f6:	72 30                	jb     801228 <__udivdi3+0x118>
  8011f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011fb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011ff:	d3 e2                	shl    %cl,%edx
  801201:	39 c2                	cmp    %eax,%edx
  801203:	73 05                	jae    80120a <__udivdi3+0xfa>
  801205:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801208:	74 1e                	je     801228 <__udivdi3+0x118>
  80120a:	89 f9                	mov    %edi,%ecx
  80120c:	31 ff                	xor    %edi,%edi
  80120e:	e9 71 ff ff ff       	jmp    801184 <__udivdi3+0x74>
  801213:	90                   	nop
  801214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801218:	31 ff                	xor    %edi,%edi
  80121a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80121f:	e9 60 ff ff ff       	jmp    801184 <__udivdi3+0x74>
  801224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801228:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80122b:	31 ff                	xor    %edi,%edi
  80122d:	89 c8                	mov    %ecx,%eax
  80122f:	89 fa                	mov    %edi,%edx
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	5e                   	pop    %esi
  801235:	5f                   	pop    %edi
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    
	...

00801240 <__umoddi3>:
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	57                   	push   %edi
  801244:	56                   	push   %esi
  801245:	83 ec 20             	sub    $0x20,%esp
  801248:	8b 55 14             	mov    0x14(%ebp),%edx
  80124b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80124e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801251:	8b 75 0c             	mov    0xc(%ebp),%esi
  801254:	85 d2                	test   %edx,%edx
  801256:	89 c8                	mov    %ecx,%eax
  801258:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80125b:	75 13                	jne    801270 <__umoddi3+0x30>
  80125d:	39 f7                	cmp    %esi,%edi
  80125f:	76 3f                	jbe    8012a0 <__umoddi3+0x60>
  801261:	89 f2                	mov    %esi,%edx
  801263:	f7 f7                	div    %edi
  801265:	89 d0                	mov    %edx,%eax
  801267:	31 d2                	xor    %edx,%edx
  801269:	83 c4 20             	add    $0x20,%esp
  80126c:	5e                   	pop    %esi
  80126d:	5f                   	pop    %edi
  80126e:	5d                   	pop    %ebp
  80126f:	c3                   	ret    
  801270:	39 f2                	cmp    %esi,%edx
  801272:	77 4c                	ja     8012c0 <__umoddi3+0x80>
  801274:	0f bd ca             	bsr    %edx,%ecx
  801277:	83 f1 1f             	xor    $0x1f,%ecx
  80127a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80127d:	75 51                	jne    8012d0 <__umoddi3+0x90>
  80127f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801282:	0f 87 e0 00 00 00    	ja     801368 <__umoddi3+0x128>
  801288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128b:	29 f8                	sub    %edi,%eax
  80128d:	19 d6                	sbb    %edx,%esi
  80128f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801295:	89 f2                	mov    %esi,%edx
  801297:	83 c4 20             	add    $0x20,%esp
  80129a:	5e                   	pop    %esi
  80129b:	5f                   	pop    %edi
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    
  80129e:	66 90                	xchg   %ax,%ax
  8012a0:	85 ff                	test   %edi,%edi
  8012a2:	75 0b                	jne    8012af <__umoddi3+0x6f>
  8012a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8012a9:	31 d2                	xor    %edx,%edx
  8012ab:	f7 f7                	div    %edi
  8012ad:	89 c7                	mov    %eax,%edi
  8012af:	89 f0                	mov    %esi,%eax
  8012b1:	31 d2                	xor    %edx,%edx
  8012b3:	f7 f7                	div    %edi
  8012b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b8:	f7 f7                	div    %edi
  8012ba:	eb a9                	jmp    801265 <__umoddi3+0x25>
  8012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012c0:	89 c8                	mov    %ecx,%eax
  8012c2:	89 f2                	mov    %esi,%edx
  8012c4:	83 c4 20             	add    $0x20,%esp
  8012c7:	5e                   	pop    %esi
  8012c8:	5f                   	pop    %edi
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    
  8012cb:	90                   	nop
  8012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012d0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012d4:	d3 e2                	shl    %cl,%edx
  8012d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012d9:	ba 20 00 00 00       	mov    $0x20,%edx
  8012de:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8012e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8012e4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012e8:	89 fa                	mov    %edi,%edx
  8012ea:	d3 ea                	shr    %cl,%edx
  8012ec:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012f0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8012f3:	d3 e7                	shl    %cl,%edi
  8012f5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012fc:	89 f2                	mov    %esi,%edx
  8012fe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801301:	89 c7                	mov    %eax,%edi
  801303:	d3 ea                	shr    %cl,%edx
  801305:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801309:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80130c:	89 c2                	mov    %eax,%edx
  80130e:	d3 e6                	shl    %cl,%esi
  801310:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801314:	d3 ea                	shr    %cl,%edx
  801316:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80131a:	09 d6                	or     %edx,%esi
  80131c:	89 f0                	mov    %esi,%eax
  80131e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801321:	d3 e7                	shl    %cl,%edi
  801323:	89 f2                	mov    %esi,%edx
  801325:	f7 75 f4             	divl   -0xc(%ebp)
  801328:	89 d6                	mov    %edx,%esi
  80132a:	f7 65 e8             	mull   -0x18(%ebp)
  80132d:	39 d6                	cmp    %edx,%esi
  80132f:	72 2b                	jb     80135c <__umoddi3+0x11c>
  801331:	39 c7                	cmp    %eax,%edi
  801333:	72 23                	jb     801358 <__umoddi3+0x118>
  801335:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801339:	29 c7                	sub    %eax,%edi
  80133b:	19 d6                	sbb    %edx,%esi
  80133d:	89 f0                	mov    %esi,%eax
  80133f:	89 f2                	mov    %esi,%edx
  801341:	d3 ef                	shr    %cl,%edi
  801343:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801347:	d3 e0                	shl    %cl,%eax
  801349:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80134d:	09 f8                	or     %edi,%eax
  80134f:	d3 ea                	shr    %cl,%edx
  801351:	83 c4 20             	add    $0x20,%esp
  801354:	5e                   	pop    %esi
  801355:	5f                   	pop    %edi
  801356:	5d                   	pop    %ebp
  801357:	c3                   	ret    
  801358:	39 d6                	cmp    %edx,%esi
  80135a:	75 d9                	jne    801335 <__umoddi3+0xf5>
  80135c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80135f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801362:	eb d1                	jmp    801335 <__umoddi3+0xf5>
  801364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801368:	39 f2                	cmp    %esi,%edx
  80136a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801370:	0f 82 12 ff ff ff    	jb     801288 <__umoddi3+0x48>
  801376:	e9 17 ff ff ff       	jmp    801292 <__umoddi3+0x52>
