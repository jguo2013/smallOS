
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 1f 01 00 00       	call   800150 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003d:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800040:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800047:	00 
  800048:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004f:	00 
  800050:	89 34 24             	mov    %esi,(%esp)
  800053:	e8 46 15 00 00       	call   80159e <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80005a:	a1 04 20 80 00       	mov    0x802004,%eax
  80005f:	8b 40 5c             	mov    0x5c(%eax),%eax
  800062:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800066:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006a:	c7 04 24 40 19 80 00 	movl   $0x801940,(%esp)
  800071:	e8 f7 01 00 00       	call   80026d <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800076:	e8 eb 10 00 00       	call   801166 <fork>
  80007b:	89 c7                	mov    %eax,%edi
  80007d:	85 c0                	test   %eax,%eax
  80007f:	79 20                	jns    8000a1 <primeproc+0x6d>
		panic("fork: %e", id);
  800081:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800085:	c7 44 24 08 da 1c 80 	movl   $0x801cda,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 4c 19 80 00 	movl   $0x80194c,(%esp)
  80009c:	e8 13 01 00 00       	call   8001b4 <_panic>
	if (id == 0)
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	74 9b                	je     800040 <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000a5:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b7:	00 
  8000b8:	89 34 24             	mov    %esi,(%esp)
  8000bb:	e8 de 14 00 00       	call   80159e <ipc_recv>
  8000c0:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000c2:	89 c2                	mov    %eax,%edx
  8000c4:	c1 fa 1f             	sar    $0x1f,%edx
  8000c7:	f7 fb                	idiv   %ebx
  8000c9:	85 d2                	test   %edx,%edx
  8000cb:	74 db                	je     8000a8 <primeproc+0x74>
			ipc_send(id, i, 0, 0);
  8000cd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d4:	00 
  8000d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000dc:	00 
  8000dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000e1:	89 3c 24             	mov    %edi,(%esp)
  8000e4:	e8 49 14 00 00       	call   801532 <ipc_send>
  8000e9:	eb bd                	jmp    8000a8 <primeproc+0x74>

008000eb <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000f3:	e8 6e 10 00 00       	call   801166 <fork>
  8000f8:	89 c6                	mov    %eax,%esi
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	79 20                	jns    80011e <umain+0x33>
		panic("fork: %e", id);
  8000fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800102:	c7 44 24 08 da 1c 80 	movl   $0x801cda,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 4c 19 80 00 	movl   $0x80194c,(%esp)
  800119:	e8 96 00 00 00       	call   8001b4 <_panic>
	if (id == 0)
  80011e:	bb 02 00 00 00       	mov    $0x2,%ebx
  800123:	85 c0                	test   %eax,%eax
  800125:	75 05                	jne    80012c <umain+0x41>
		primeproc();
  800127:	e8 08 ff ff ff       	call   800034 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80013b:	00 
  80013c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800140:	89 34 24             	mov    %esi,(%esp)
  800143:	e8 ea 13 00 00       	call   801532 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  800148:	83 c3 01             	add    $0x1,%ebx
  80014b:	eb df                	jmp    80012c <umain+0x41>
  80014d:	00 00                	add    %al,(%eax)
	...

00800150 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	83 ec 18             	sub    $0x18,%esp
  800156:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800159:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80015c:	8b 75 08             	mov    0x8(%ebp),%esi
  80015f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800162:	e8 4a 0f 00 00       	call   8010b1 <sys_getenvid>
  800167:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80016f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800174:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800179:	85 f6                	test   %esi,%esi
  80017b:	7e 07                	jle    800184 <libmain+0x34>
		binaryname = argv[0];
  80017d:	8b 03                	mov    (%ebx),%eax
  80017f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800184:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800188:	89 34 24             	mov    %esi,(%esp)
  80018b:	e8 5b ff ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  800190:	e8 0b 00 00 00       	call   8001a0 <exit>
}
  800195:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800198:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80019b:	89 ec                	mov    %ebp,%esp
  80019d:	5d                   	pop    %ebp
  80019e:	c3                   	ret    
	...

008001a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8001a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001ad:	e8 33 0f 00 00       	call   8010e5 <sys_env_destroy>
}
  8001b2:	c9                   	leave  
  8001b3:	c3                   	ret    

008001b4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	56                   	push   %esi
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8001bc:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001bf:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8001c5:	e8 e7 0e 00 00       	call   8010b1 <sys_getenvid>
  8001ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cd:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e0:	c7 04 24 64 19 80 00 	movl   $0x801964,(%esp)
  8001e7:	e8 81 00 00 00       	call   80026d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	e8 11 00 00 00       	call   80020c <vcprintf>
	cprintf("\n");
  8001fb:	c7 04 24 7d 1d 80 00 	movl   $0x801d7d,(%esp)
  800202:	e8 66 00 00 00       	call   80026d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800207:	cc                   	int3   
  800208:	eb fd                	jmp    800207 <_panic+0x53>
	...

0080020c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800215:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021c:	00 00 00 
	b.cnt = 0;
  80021f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800226:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800230:	8b 45 08             	mov    0x8(%ebp),%eax
  800233:	89 44 24 08          	mov    %eax,0x8(%esp)
  800237:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800241:	c7 04 24 87 02 80 00 	movl   $0x800287,(%esp)
  800248:	e8 be 01 00 00       	call   80040b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800253:	89 44 24 04          	mov    %eax,0x4(%esp)
  800257:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025d:	89 04 24             	mov    %eax,(%esp)
  800260:	e8 2b 0a 00 00       	call   800c90 <sys_cputs>

	return b.cnt;
}
  800265:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026b:	c9                   	leave  
  80026c:	c3                   	ret    

0080026d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800273:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800276:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027a:	8b 45 08             	mov    0x8(%ebp),%eax
  80027d:	89 04 24             	mov    %eax,(%esp)
  800280:	e8 87 ff ff ff       	call   80020c <vcprintf>
	va_end(ap);

	return cnt;
}
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	53                   	push   %ebx
  80028b:	83 ec 14             	sub    $0x14,%esp
  80028e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800291:	8b 03                	mov    (%ebx),%eax
  800293:	8b 55 08             	mov    0x8(%ebp),%edx
  800296:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80029a:	83 c0 01             	add    $0x1,%eax
  80029d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80029f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a4:	75 19                	jne    8002bf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002a6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002ad:	00 
  8002ae:	8d 43 08             	lea    0x8(%ebx),%eax
  8002b1:	89 04 24             	mov    %eax,(%esp)
  8002b4:	e8 d7 09 00 00       	call   800c90 <sys_cputs>
		b->idx = 0;
  8002b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002bf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002c3:	83 c4 14             	add    $0x14,%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5d                   	pop    %ebp
  8002c8:	c3                   	ret    
  8002c9:	00 00                	add    %al,(%eax)
	...

008002cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	57                   	push   %edi
  8002d0:	56                   	push   %esi
  8002d1:	53                   	push   %ebx
  8002d2:	83 ec 4c             	sub    $0x4c,%esp
  8002d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002d8:	89 d6                	mov    %edx,%esi
  8002da:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ec:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f7:	39 d1                	cmp    %edx,%ecx
  8002f9:	72 07                	jb     800302 <printnum+0x36>
  8002fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002fe:	39 d0                	cmp    %edx,%eax
  800300:	77 69                	ja     80036b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800302:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800306:	83 eb 01             	sub    $0x1,%ebx
  800309:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80030d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800311:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800315:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800319:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80031c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80031f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800322:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800326:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80032d:	00 
  80032e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800331:	89 04 24             	mov    %eax,(%esp)
  800334:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800337:	89 54 24 04          	mov    %edx,0x4(%esp)
  80033b:	e8 90 13 00 00       	call   8016d0 <__udivdi3>
  800340:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800343:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800346:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80034a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80034e:	89 04 24             	mov    %eax,(%esp)
  800351:	89 54 24 04          	mov    %edx,0x4(%esp)
  800355:	89 f2                	mov    %esi,%edx
  800357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80035a:	e8 6d ff ff ff       	call   8002cc <printnum>
  80035f:	eb 11                	jmp    800372 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800361:	89 74 24 04          	mov    %esi,0x4(%esp)
  800365:	89 3c 24             	mov    %edi,(%esp)
  800368:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80036b:	83 eb 01             	sub    $0x1,%ebx
  80036e:	85 db                	test   %ebx,%ebx
  800370:	7f ef                	jg     800361 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800372:	89 74 24 04          	mov    %esi,0x4(%esp)
  800376:	8b 74 24 04          	mov    0x4(%esp),%esi
  80037a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800381:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800388:	00 
  800389:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80038c:	89 14 24             	mov    %edx,(%esp)
  80038f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800392:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800396:	e8 65 14 00 00       	call   801800 <__umoddi3>
  80039b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80039f:	0f be 80 87 19 80 00 	movsbl 0x801987(%eax),%eax
  8003a6:	89 04 24             	mov    %eax,(%esp)
  8003a9:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003ac:	83 c4 4c             	add    $0x4c,%esp
  8003af:	5b                   	pop    %ebx
  8003b0:	5e                   	pop    %esi
  8003b1:	5f                   	pop    %edi
  8003b2:	5d                   	pop    %ebp
  8003b3:	c3                   	ret    

008003b4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003b7:	83 fa 01             	cmp    $0x1,%edx
  8003ba:	7e 0e                	jle    8003ca <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003bc:	8b 10                	mov    (%eax),%edx
  8003be:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003c1:	89 08                	mov    %ecx,(%eax)
  8003c3:	8b 02                	mov    (%edx),%eax
  8003c5:	8b 52 04             	mov    0x4(%edx),%edx
  8003c8:	eb 22                	jmp    8003ec <getuint+0x38>
	else if (lflag)
  8003ca:	85 d2                	test   %edx,%edx
  8003cc:	74 10                	je     8003de <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003ce:	8b 10                	mov    (%eax),%edx
  8003d0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003d3:	89 08                	mov    %ecx,(%eax)
  8003d5:	8b 02                	mov    (%edx),%eax
  8003d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dc:	eb 0e                	jmp    8003ec <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003de:	8b 10                	mov    (%eax),%edx
  8003e0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003e3:	89 08                	mov    %ecx,(%eax)
  8003e5:	8b 02                	mov    (%edx),%eax
  8003e7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003ec:	5d                   	pop    %ebp
  8003ed:	c3                   	ret    

008003ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fd:	73 0a                	jae    800409 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800402:	88 0a                	mov    %cl,(%edx)
  800404:	83 c2 01             	add    $0x1,%edx
  800407:	89 10                	mov    %edx,(%eax)
}
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	57                   	push   %edi
  80040f:	56                   	push   %esi
  800410:	53                   	push   %ebx
  800411:	83 ec 4c             	sub    $0x4c,%esp
  800414:	8b 7d 08             	mov    0x8(%ebp),%edi
  800417:	8b 75 0c             	mov    0xc(%ebp),%esi
  80041a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80041d:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800424:	eb 11                	jmp    800437 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800426:	85 c0                	test   %eax,%eax
  800428:	0f 84 b6 03 00 00    	je     8007e4 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80042e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800432:	89 04 24             	mov    %eax,(%esp)
  800435:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800437:	0f b6 03             	movzbl (%ebx),%eax
  80043a:	83 c3 01             	add    $0x1,%ebx
  80043d:	83 f8 25             	cmp    $0x25,%eax
  800440:	75 e4                	jne    800426 <vprintfmt+0x1b>
  800442:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800446:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80044d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800454:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80045b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800460:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800463:	eb 06                	jmp    80046b <vprintfmt+0x60>
  800465:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800469:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	0f b6 0b             	movzbl (%ebx),%ecx
  80046e:	0f b6 c1             	movzbl %cl,%eax
  800471:	8d 53 01             	lea    0x1(%ebx),%edx
  800474:	83 e9 23             	sub    $0x23,%ecx
  800477:	80 f9 55             	cmp    $0x55,%cl
  80047a:	0f 87 47 03 00 00    	ja     8007c7 <vprintfmt+0x3bc>
  800480:	0f b6 c9             	movzbl %cl,%ecx
  800483:	ff 24 8d c0 1a 80 00 	jmp    *0x801ac0(,%ecx,4)
  80048a:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80048e:	eb d9                	jmp    800469 <vprintfmt+0x5e>
  800490:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800497:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80049c:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80049f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004a3:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8004a6:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004a9:	83 fb 09             	cmp    $0x9,%ebx
  8004ac:	77 30                	ja     8004de <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ae:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004b1:	eb e9                	jmp    80049c <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b6:	8d 48 04             	lea    0x4(%eax),%ecx
  8004b9:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8004c1:	eb 1e                	jmp    8004e1 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8004c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cc:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8004d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004d3:	eb 94                	jmp    800469 <vprintfmt+0x5e>
  8004d5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8004dc:	eb 8b                	jmp    800469 <vprintfmt+0x5e>
  8004de:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8004e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004e5:	79 82                	jns    800469 <vprintfmt+0x5e>
  8004e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ed:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004f0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004f3:	e9 71 ff ff ff       	jmp    800469 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004f8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004fc:	e9 68 ff ff ff       	jmp    800469 <vprintfmt+0x5e>
  800501:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8d 50 04             	lea    0x4(%eax),%edx
  80050a:	89 55 14             	mov    %edx,0x14(%ebp)
  80050d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800511:	8b 00                	mov    (%eax),%eax
  800513:	89 04 24             	mov    %eax,(%esp)
  800516:	ff d7                	call   *%edi
  800518:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80051b:	e9 17 ff ff ff       	jmp    800437 <vprintfmt+0x2c>
  800520:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800523:	8b 45 14             	mov    0x14(%ebp),%eax
  800526:	8d 50 04             	lea    0x4(%eax),%edx
  800529:	89 55 14             	mov    %edx,0x14(%ebp)
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	89 c2                	mov    %eax,%edx
  800530:	c1 fa 1f             	sar    $0x1f,%edx
  800533:	31 d0                	xor    %edx,%eax
  800535:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800537:	83 f8 11             	cmp    $0x11,%eax
  80053a:	7f 0b                	jg     800547 <vprintfmt+0x13c>
  80053c:	8b 14 85 20 1c 80 00 	mov    0x801c20(,%eax,4),%edx
  800543:	85 d2                	test   %edx,%edx
  800545:	75 20                	jne    800567 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800547:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80054b:	c7 44 24 08 98 19 80 	movl   $0x801998,0x8(%esp)
  800552:	00 
  800553:	89 74 24 04          	mov    %esi,0x4(%esp)
  800557:	89 3c 24             	mov    %edi,(%esp)
  80055a:	e8 0d 03 00 00       	call   80086c <printfmt>
  80055f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800562:	e9 d0 fe ff ff       	jmp    800437 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800567:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80056b:	c7 44 24 08 a1 19 80 	movl   $0x8019a1,0x8(%esp)
  800572:	00 
  800573:	89 74 24 04          	mov    %esi,0x4(%esp)
  800577:	89 3c 24             	mov    %edi,(%esp)
  80057a:	e8 ed 02 00 00       	call   80086c <printfmt>
  80057f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800582:	e9 b0 fe ff ff       	jmp    800437 <vprintfmt+0x2c>
  800587:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80058a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80058d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800590:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8d 50 04             	lea    0x4(%eax),%edx
  800599:	89 55 14             	mov    %edx,0x14(%ebp)
  80059c:	8b 18                	mov    (%eax),%ebx
  80059e:	85 db                	test   %ebx,%ebx
  8005a0:	b8 a4 19 80 00       	mov    $0x8019a4,%eax
  8005a5:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8005a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005ac:	7e 76                	jle    800624 <vprintfmt+0x219>
  8005ae:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8005b2:	74 7a                	je     80062e <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005b8:	89 1c 24             	mov    %ebx,(%esp)
  8005bb:	e8 f8 02 00 00       	call   8008b8 <strnlen>
  8005c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005c3:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8005c5:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8005c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005cc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005cf:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d1:	eb 0f                	jmp    8005e2 <vprintfmt+0x1d7>
					putch(padc, putdat);
  8005d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005da:	89 04 24             	mov    %eax,(%esp)
  8005dd:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005df:	83 eb 01             	sub    $0x1,%ebx
  8005e2:	85 db                	test   %ebx,%ebx
  8005e4:	7f ed                	jg     8005d3 <vprintfmt+0x1c8>
  8005e6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005e9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005ec:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005ef:	89 f7                	mov    %esi,%edi
  8005f1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005f4:	eb 40                	jmp    800636 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fa:	74 18                	je     800614 <vprintfmt+0x209>
  8005fc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005ff:	83 fa 5e             	cmp    $0x5e,%edx
  800602:	76 10                	jbe    800614 <vprintfmt+0x209>
					putch('?', putdat);
  800604:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800608:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80060f:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800612:	eb 0a                	jmp    80061e <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800614:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800618:	89 04 24             	mov    %eax,(%esp)
  80061b:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800622:	eb 12                	jmp    800636 <vprintfmt+0x22b>
  800624:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800627:	89 f7                	mov    %esi,%edi
  800629:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80062c:	eb 08                	jmp    800636 <vprintfmt+0x22b>
  80062e:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800631:	89 f7                	mov    %esi,%edi
  800633:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800636:	0f be 03             	movsbl (%ebx),%eax
  800639:	83 c3 01             	add    $0x1,%ebx
  80063c:	85 c0                	test   %eax,%eax
  80063e:	74 25                	je     800665 <vprintfmt+0x25a>
  800640:	85 f6                	test   %esi,%esi
  800642:	78 b2                	js     8005f6 <vprintfmt+0x1eb>
  800644:	83 ee 01             	sub    $0x1,%esi
  800647:	79 ad                	jns    8005f6 <vprintfmt+0x1eb>
  800649:	89 fe                	mov    %edi,%esi
  80064b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80064e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800651:	eb 1a                	jmp    80066d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800653:	89 74 24 04          	mov    %esi,0x4(%esp)
  800657:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80065e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800660:	83 eb 01             	sub    $0x1,%ebx
  800663:	eb 08                	jmp    80066d <vprintfmt+0x262>
  800665:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800668:	89 fe                	mov    %edi,%esi
  80066a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80066d:	85 db                	test   %ebx,%ebx
  80066f:	7f e2                	jg     800653 <vprintfmt+0x248>
  800671:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800674:	e9 be fd ff ff       	jmp    800437 <vprintfmt+0x2c>
  800679:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80067c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80067f:	83 f9 01             	cmp    $0x1,%ecx
  800682:	7e 16                	jle    80069a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 50 08             	lea    0x8(%eax),%edx
  80068a:	89 55 14             	mov    %edx,0x14(%ebp)
  80068d:	8b 10                	mov    (%eax),%edx
  80068f:	8b 48 04             	mov    0x4(%eax),%ecx
  800692:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800695:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800698:	eb 32                	jmp    8006cc <vprintfmt+0x2c1>
	else if (lflag)
  80069a:	85 c9                	test   %ecx,%ecx
  80069c:	74 18                	je     8006b6 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 50 04             	lea    0x4(%eax),%edx
  8006a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ac:	89 c1                	mov    %eax,%ecx
  8006ae:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006b4:	eb 16                	jmp    8006cc <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8d 50 04             	lea    0x4(%eax),%edx
  8006bc:	89 55 14             	mov    %edx,0x14(%ebp)
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c4:	89 c2                	mov    %eax,%edx
  8006c6:	c1 fa 1f             	sar    $0x1f,%edx
  8006c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006cc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006cf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006d2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006db:	0f 89 a7 00 00 00    	jns    800788 <vprintfmt+0x37d>
				putch('-', putdat);
  8006e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006ec:	ff d7                	call   *%edi
				num = -(long long) num;
  8006ee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006f1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006f4:	f7 d9                	neg    %ecx
  8006f6:	83 d3 00             	adc    $0x0,%ebx
  8006f9:	f7 db                	neg    %ebx
  8006fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800700:	e9 83 00 00 00       	jmp    800788 <vprintfmt+0x37d>
  800705:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800708:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80070b:	89 ca                	mov    %ecx,%edx
  80070d:	8d 45 14             	lea    0x14(%ebp),%eax
  800710:	e8 9f fc ff ff       	call   8003b4 <getuint>
  800715:	89 c1                	mov    %eax,%ecx
  800717:	89 d3                	mov    %edx,%ebx
  800719:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80071e:	eb 68                	jmp    800788 <vprintfmt+0x37d>
  800720:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800723:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800726:	89 ca                	mov    %ecx,%edx
  800728:	8d 45 14             	lea    0x14(%ebp),%eax
  80072b:	e8 84 fc ff ff       	call   8003b4 <getuint>
  800730:	89 c1                	mov    %eax,%ecx
  800732:	89 d3                	mov    %edx,%ebx
  800734:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800739:	eb 4d                	jmp    800788 <vprintfmt+0x37d>
  80073b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80073e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800742:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800749:	ff d7                	call   *%edi
			putch('x', putdat);
  80074b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80074f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800756:	ff d7                	call   *%edi
			num = (unsigned long long)
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8d 50 04             	lea    0x4(%eax),%edx
  80075e:	89 55 14             	mov    %edx,0x14(%ebp)
  800761:	8b 08                	mov    (%eax),%ecx
  800763:	bb 00 00 00 00       	mov    $0x0,%ebx
  800768:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80076d:	eb 19                	jmp    800788 <vprintfmt+0x37d>
  80076f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800772:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800775:	89 ca                	mov    %ecx,%edx
  800777:	8d 45 14             	lea    0x14(%ebp),%eax
  80077a:	e8 35 fc ff ff       	call   8003b4 <getuint>
  80077f:	89 c1                	mov    %eax,%ecx
  800781:	89 d3                	mov    %edx,%ebx
  800783:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800788:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  80078c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800790:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800793:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800797:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079b:	89 0c 24             	mov    %ecx,(%esp)
  80079e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007a2:	89 f2                	mov    %esi,%edx
  8007a4:	89 f8                	mov    %edi,%eax
  8007a6:	e8 21 fb ff ff       	call   8002cc <printnum>
  8007ab:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007ae:	e9 84 fc ff ff       	jmp    800437 <vprintfmt+0x2c>
  8007b3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ba:	89 04 24             	mov    %eax,(%esp)
  8007bd:	ff d7                	call   *%edi
  8007bf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007c2:	e9 70 fc ff ff       	jmp    800437 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007cb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007d2:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8007d7:	80 38 25             	cmpb   $0x25,(%eax)
  8007da:	0f 84 57 fc ff ff    	je     800437 <vprintfmt+0x2c>
  8007e0:	89 c3                	mov    %eax,%ebx
  8007e2:	eb f0                	jmp    8007d4 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8007e4:	83 c4 4c             	add    $0x4c,%esp
  8007e7:	5b                   	pop    %ebx
  8007e8:	5e                   	pop    %esi
  8007e9:	5f                   	pop    %edi
  8007ea:	5d                   	pop    %ebp
  8007eb:	c3                   	ret    

008007ec <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	83 ec 28             	sub    $0x28,%esp
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8007f8:	85 c0                	test   %eax,%eax
  8007fa:	74 04                	je     800800 <vsnprintf+0x14>
  8007fc:	85 d2                	test   %edx,%edx
  8007fe:	7f 07                	jg     800807 <vsnprintf+0x1b>
  800800:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800805:	eb 3b                	jmp    800842 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800807:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80080a:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80081f:	8b 45 10             	mov    0x10(%ebp),%eax
  800822:	89 44 24 08          	mov    %eax,0x8(%esp)
  800826:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082d:	c7 04 24 ee 03 80 00 	movl   $0x8003ee,(%esp)
  800834:	e8 d2 fb ff ff       	call   80040b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80083c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80083f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800842:	c9                   	leave  
  800843:	c3                   	ret    

00800844 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80084a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  80084d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800851:	8b 45 10             	mov    0x10(%ebp),%eax
  800854:	89 44 24 08          	mov    %eax,0x8(%esp)
  800858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	89 04 24             	mov    %eax,(%esp)
  800865:	e8 82 ff ff ff       	call   8007ec <vsnprintf>
	va_end(ap);

	return rc;
}
  80086a:	c9                   	leave  
  80086b:	c3                   	ret    

0080086c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800872:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800875:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800879:	8b 45 10             	mov    0x10(%ebp),%eax
  80087c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800880:	8b 45 0c             	mov    0xc(%ebp),%eax
  800883:	89 44 24 04          	mov    %eax,0x4(%esp)
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	89 04 24             	mov    %eax,(%esp)
  80088d:	e8 79 fb ff ff       	call   80040b <vprintfmt>
	va_end(ap);
}
  800892:	c9                   	leave  
  800893:	c3                   	ret    
	...

008008a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ab:	eb 03                	jmp    8008b0 <strlen+0x10>
		n++;
  8008ad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b4:	75 f7                	jne    8008ad <strlen+0xd>
		n++;
	return n;
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c7:	eb 03                	jmp    8008cc <strnlen+0x14>
		n++;
  8008c9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cc:	39 c1                	cmp    %eax,%ecx
  8008ce:	74 06                	je     8008d6 <strnlen+0x1e>
  8008d0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8008d4:	75 f3                	jne    8008c9 <strnlen+0x11>
		n++;
	return n;
}
  8008d6:	5b                   	pop    %ebx
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	53                   	push   %ebx
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ef:	83 c2 01             	add    $0x1,%edx
  8008f2:	84 c9                	test   %cl,%cl
  8008f4:	75 f2                	jne    8008e8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008f6:	5b                   	pop    %ebx
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800903:	89 1c 24             	mov    %ebx,(%esp)
  800906:	e8 95 ff ff ff       	call   8008a0 <strlen>
	strcpy(dst + len, src);
  80090b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800912:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800915:	89 04 24             	mov    %eax,(%esp)
  800918:	e8 bc ff ff ff       	call   8008d9 <strcpy>
	return dst;
}
  80091d:	89 d8                	mov    %ebx,%eax
  80091f:	83 c4 08             	add    $0x8,%esp
  800922:	5b                   	pop    %ebx
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	56                   	push   %esi
  800929:	53                   	push   %ebx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800930:	8b 75 10             	mov    0x10(%ebp),%esi
  800933:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800938:	eb 0f                	jmp    800949 <strncpy+0x24>
		*dst++ = *src;
  80093a:	0f b6 19             	movzbl (%ecx),%ebx
  80093d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800940:	80 39 01             	cmpb   $0x1,(%ecx)
  800943:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	39 f2                	cmp    %esi,%edx
  80094b:	72 ed                	jb     80093a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80094d:	5b                   	pop    %ebx
  80094e:	5e                   	pop    %esi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	8b 75 08             	mov    0x8(%ebp),%esi
  800959:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80095f:	89 f0                	mov    %esi,%eax
  800961:	85 d2                	test   %edx,%edx
  800963:	75 0a                	jne    80096f <strlcpy+0x1e>
  800965:	eb 17                	jmp    80097e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800967:	88 18                	mov    %bl,(%eax)
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80096f:	83 ea 01             	sub    $0x1,%edx
  800972:	74 07                	je     80097b <strlcpy+0x2a>
  800974:	0f b6 19             	movzbl (%ecx),%ebx
  800977:	84 db                	test   %bl,%bl
  800979:	75 ec                	jne    800967 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80097b:	c6 00 00             	movb   $0x0,(%eax)
  80097e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800980:	5b                   	pop    %ebx
  800981:	5e                   	pop    %esi
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80098d:	eb 06                	jmp    800995 <strcmp+0x11>
		p++, q++;
  80098f:	83 c1 01             	add    $0x1,%ecx
  800992:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800995:	0f b6 01             	movzbl (%ecx),%eax
  800998:	84 c0                	test   %al,%al
  80099a:	74 04                	je     8009a0 <strcmp+0x1c>
  80099c:	3a 02                	cmp    (%edx),%al
  80099e:	74 ef                	je     80098f <strcmp+0xb>
  8009a0:	0f b6 c0             	movzbl %al,%eax
  8009a3:	0f b6 12             	movzbl (%edx),%edx
  8009a6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	53                   	push   %ebx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8009b7:	eb 09                	jmp    8009c2 <strncmp+0x18>
		n--, p++, q++;
  8009b9:	83 ea 01             	sub    $0x1,%edx
  8009bc:	83 c0 01             	add    $0x1,%eax
  8009bf:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009c2:	85 d2                	test   %edx,%edx
  8009c4:	75 07                	jne    8009cd <strncmp+0x23>
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cb:	eb 13                	jmp    8009e0 <strncmp+0x36>
  8009cd:	0f b6 18             	movzbl (%eax),%ebx
  8009d0:	84 db                	test   %bl,%bl
  8009d2:	74 04                	je     8009d8 <strncmp+0x2e>
  8009d4:	3a 19                	cmp    (%ecx),%bl
  8009d6:	74 e1                	je     8009b9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 00             	movzbl (%eax),%eax
  8009db:	0f b6 11             	movzbl (%ecx),%edx
  8009de:	29 d0                	sub    %edx,%eax
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ed:	eb 07                	jmp    8009f6 <strchr+0x13>
		if (*s == c)
  8009ef:	38 ca                	cmp    %cl,%dl
  8009f1:	74 0f                	je     800a02 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	0f b6 10             	movzbl (%eax),%edx
  8009f9:	84 d2                	test   %dl,%dl
  8009fb:	75 f2                	jne    8009ef <strchr+0xc>
  8009fd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0e:	eb 07                	jmp    800a17 <strfind+0x13>
		if (*s == c)
  800a10:	38 ca                	cmp    %cl,%dl
  800a12:	74 0a                	je     800a1e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a14:	83 c0 01             	add    $0x1,%eax
  800a17:	0f b6 10             	movzbl (%eax),%edx
  800a1a:	84 d2                	test   %dl,%dl
  800a1c:	75 f2                	jne    800a10 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 0c             	sub    $0xc,%esp
  800a26:	89 1c 24             	mov    %ebx,(%esp)
  800a29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a2d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a31:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a3a:	85 c9                	test   %ecx,%ecx
  800a3c:	74 30                	je     800a6e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a44:	75 25                	jne    800a6b <memset+0x4b>
  800a46:	f6 c1 03             	test   $0x3,%cl
  800a49:	75 20                	jne    800a6b <memset+0x4b>
		c &= 0xFF;
  800a4b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4e:	89 d3                	mov    %edx,%ebx
  800a50:	c1 e3 08             	shl    $0x8,%ebx
  800a53:	89 d6                	mov    %edx,%esi
  800a55:	c1 e6 18             	shl    $0x18,%esi
  800a58:	89 d0                	mov    %edx,%eax
  800a5a:	c1 e0 10             	shl    $0x10,%eax
  800a5d:	09 f0                	or     %esi,%eax
  800a5f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a61:	09 d8                	or     %ebx,%eax
  800a63:	c1 e9 02             	shr    $0x2,%ecx
  800a66:	fc                   	cld    
  800a67:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a69:	eb 03                	jmp    800a6e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a6b:	fc                   	cld    
  800a6c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6e:	89 f8                	mov    %edi,%eax
  800a70:	8b 1c 24             	mov    (%esp),%ebx
  800a73:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a77:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a7b:	89 ec                	mov    %ebp,%esp
  800a7d:	5d                   	pop    %ebp
  800a7e:	c3                   	ret    

00800a7f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	89 34 24             	mov    %esi,(%esp)
  800a88:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800a92:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a95:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a97:	39 c6                	cmp    %eax,%esi
  800a99:	73 35                	jae    800ad0 <memmove+0x51>
  800a9b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9e:	39 d0                	cmp    %edx,%eax
  800aa0:	73 2e                	jae    800ad0 <memmove+0x51>
		s += n;
		d += n;
  800aa2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa4:	f6 c2 03             	test   $0x3,%dl
  800aa7:	75 1b                	jne    800ac4 <memmove+0x45>
  800aa9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aaf:	75 13                	jne    800ac4 <memmove+0x45>
  800ab1:	f6 c1 03             	test   $0x3,%cl
  800ab4:	75 0e                	jne    800ac4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ab6:	83 ef 04             	sub    $0x4,%edi
  800ab9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800abc:	c1 e9 02             	shr    $0x2,%ecx
  800abf:	fd                   	std    
  800ac0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac2:	eb 09                	jmp    800acd <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac4:	83 ef 01             	sub    $0x1,%edi
  800ac7:	8d 72 ff             	lea    -0x1(%edx),%esi
  800aca:	fd                   	std    
  800acb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800acd:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ace:	eb 20                	jmp    800af0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad6:	75 15                	jne    800aed <memmove+0x6e>
  800ad8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ade:	75 0d                	jne    800aed <memmove+0x6e>
  800ae0:	f6 c1 03             	test   $0x3,%cl
  800ae3:	75 08                	jne    800aed <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800ae5:	c1 e9 02             	shr    $0x2,%ecx
  800ae8:	fc                   	cld    
  800ae9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aeb:	eb 03                	jmp    800af0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aed:	fc                   	cld    
  800aee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af0:	8b 34 24             	mov    (%esp),%esi
  800af3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800af7:	89 ec                	mov    %ebp,%esp
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b01:	8b 45 10             	mov    0x10(%ebp),%eax
  800b04:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 04 24             	mov    %eax,(%esp)
  800b15:	e8 65 ff ff ff       	call   800a7f <memmove>
}
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	57                   	push   %edi
  800b20:	56                   	push   %esi
  800b21:	53                   	push   %ebx
  800b22:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b2b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b30:	eb 1c                	jmp    800b4e <memcmp+0x32>
		if (*s1 != *s2)
  800b32:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800b36:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800b3a:	83 c2 01             	add    $0x1,%edx
  800b3d:	83 e9 01             	sub    $0x1,%ecx
  800b40:	38 d8                	cmp    %bl,%al
  800b42:	74 0a                	je     800b4e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800b44:	0f b6 c0             	movzbl %al,%eax
  800b47:	0f b6 db             	movzbl %bl,%ebx
  800b4a:	29 d8                	sub    %ebx,%eax
  800b4c:	eb 09                	jmp    800b57 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4e:	85 c9                	test   %ecx,%ecx
  800b50:	75 e0                	jne    800b32 <memcmp+0x16>
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b65:	89 c2                	mov    %eax,%edx
  800b67:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b6a:	eb 07                	jmp    800b73 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b6c:	38 08                	cmp    %cl,(%eax)
  800b6e:	74 07                	je     800b77 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b70:	83 c0 01             	add    $0x1,%eax
  800b73:	39 d0                	cmp    %edx,%eax
  800b75:	72 f5                	jb     800b6c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	57                   	push   %edi
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	8b 55 08             	mov    0x8(%ebp),%edx
  800b85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b88:	eb 03                	jmp    800b8d <strtol+0x14>
		s++;
  800b8a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8d:	0f b6 02             	movzbl (%edx),%eax
  800b90:	3c 20                	cmp    $0x20,%al
  800b92:	74 f6                	je     800b8a <strtol+0x11>
  800b94:	3c 09                	cmp    $0x9,%al
  800b96:	74 f2                	je     800b8a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b98:	3c 2b                	cmp    $0x2b,%al
  800b9a:	75 0c                	jne    800ba8 <strtol+0x2f>
		s++;
  800b9c:	8d 52 01             	lea    0x1(%edx),%edx
  800b9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ba6:	eb 15                	jmp    800bbd <strtol+0x44>
	else if (*s == '-')
  800ba8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800baf:	3c 2d                	cmp    $0x2d,%al
  800bb1:	75 0a                	jne    800bbd <strtol+0x44>
		s++, neg = 1;
  800bb3:	8d 52 01             	lea    0x1(%edx),%edx
  800bb6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbd:	85 db                	test   %ebx,%ebx
  800bbf:	0f 94 c0             	sete   %al
  800bc2:	74 05                	je     800bc9 <strtol+0x50>
  800bc4:	83 fb 10             	cmp    $0x10,%ebx
  800bc7:	75 15                	jne    800bde <strtol+0x65>
  800bc9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bcc:	75 10                	jne    800bde <strtol+0x65>
  800bce:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bd2:	75 0a                	jne    800bde <strtol+0x65>
		s += 2, base = 16;
  800bd4:	83 c2 02             	add    $0x2,%edx
  800bd7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bdc:	eb 13                	jmp    800bf1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bde:	84 c0                	test   %al,%al
  800be0:	74 0f                	je     800bf1 <strtol+0x78>
  800be2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800be7:	80 3a 30             	cmpb   $0x30,(%edx)
  800bea:	75 05                	jne    800bf1 <strtol+0x78>
		s++, base = 8;
  800bec:	83 c2 01             	add    $0x1,%edx
  800bef:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bf8:	0f b6 0a             	movzbl (%edx),%ecx
  800bfb:	89 cf                	mov    %ecx,%edi
  800bfd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c00:	80 fb 09             	cmp    $0x9,%bl
  800c03:	77 08                	ja     800c0d <strtol+0x94>
			dig = *s - '0';
  800c05:	0f be c9             	movsbl %cl,%ecx
  800c08:	83 e9 30             	sub    $0x30,%ecx
  800c0b:	eb 1e                	jmp    800c2b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800c0d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c10:	80 fb 19             	cmp    $0x19,%bl
  800c13:	77 08                	ja     800c1d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800c15:	0f be c9             	movsbl %cl,%ecx
  800c18:	83 e9 57             	sub    $0x57,%ecx
  800c1b:	eb 0e                	jmp    800c2b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800c1d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c20:	80 fb 19             	cmp    $0x19,%bl
  800c23:	77 15                	ja     800c3a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c25:	0f be c9             	movsbl %cl,%ecx
  800c28:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c2b:	39 f1                	cmp    %esi,%ecx
  800c2d:	7d 0b                	jge    800c3a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c2f:	83 c2 01             	add    $0x1,%edx
  800c32:	0f af c6             	imul   %esi,%eax
  800c35:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c38:	eb be                	jmp    800bf8 <strtol+0x7f>
  800c3a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c40:	74 05                	je     800c47 <strtol+0xce>
		*endptr = (char *) s;
  800c42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c45:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c47:	89 ca                	mov    %ecx,%edx
  800c49:	f7 da                	neg    %edx
  800c4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c4f:	0f 45 c2             	cmovne %edx,%eax
}
  800c52:	83 c4 04             	add    $0x4,%esp
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    
	...

00800c5c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	89 1c 24             	mov    %ebx,(%esp)
  800c65:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c69:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c72:	b8 01 00 00 00       	mov    $0x1,%eax
  800c77:	89 d1                	mov    %edx,%ecx
  800c79:	89 d3                	mov    %edx,%ebx
  800c7b:	89 d7                	mov    %edx,%edi
  800c7d:	89 d6                	mov    %edx,%esi
  800c7f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c81:	8b 1c 24             	mov    (%esp),%ebx
  800c84:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c88:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c8c:	89 ec                	mov    %ebp,%esp
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 0c             	sub    $0xc,%esp
  800c96:	89 1c 24             	mov    %ebx,(%esp)
  800c99:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c9d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	89 c3                	mov    %eax,%ebx
  800cae:	89 c7                	mov    %eax,%edi
  800cb0:	89 c6                	mov    %eax,%esi
  800cb2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb4:	8b 1c 24             	mov    (%esp),%ebx
  800cb7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cbb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cbf:	89 ec                	mov    %ebp,%esp
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	89 1c 24             	mov    %ebx,(%esp)
  800ccc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cd0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd9:	b8 10 00 00 00       	mov    $0x10,%eax
  800cde:	89 d1                	mov    %edx,%ecx
  800ce0:	89 d3                	mov    %edx,%ebx
  800ce2:	89 d7                	mov    %edx,%edi
  800ce4:	89 d6                	mov    %edx,%esi
  800ce6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ce8:	8b 1c 24             	mov    (%esp),%ebx
  800ceb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cef:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cf3:	89 ec                	mov    %ebp,%esp
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 38             	sub    $0x38,%esp
  800cfd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d00:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d03:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	89 df                	mov    %ebx,%edi
  800d18:	89 de                	mov    %ebx,%esi
  800d1a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	7e 28                	jle    800d48 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d24:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d2b:	00 
  800d2c:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  800d33:	00 
  800d34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d3b:	00 
  800d3c:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  800d43:	e8 6c f4 ff ff       	call   8001b4 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800d48:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d51:	89 ec                	mov    %ebp,%esp
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 38             	sub    $0x38,%esp
  800d5b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d5e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d61:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d69:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	89 df                	mov    %ebx,%edi
  800d76:	89 de                	mov    %ebx,%esi
  800d78:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7e 28                	jle    800da6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d82:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800d89:	00 
  800d8a:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  800d91:	00 
  800d92:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d99:	00 
  800d9a:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  800da1:	e8 0e f4 ff ff       	call   8001b4 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800da6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800da9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800daf:	89 ec                	mov    %ebp,%esp
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 38             	sub    $0x38,%esp
  800db9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dbf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	89 cb                	mov    %ecx,%ebx
  800dd1:	89 cf                	mov    %ecx,%edi
  800dd3:	89 ce                	mov    %ecx,%esi
  800dd5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	7e 28                	jle    800e03 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ddf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800de6:	00 
  800de7:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  800dee:	00 
  800def:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df6:	00 
  800df7:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  800dfe:	e8 b1 f3 ff ff       	call   8001b4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e03:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e06:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e09:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e0c:	89 ec                	mov    %ebp,%esp
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	89 1c 24             	mov    %ebx,(%esp)
  800e19:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e1d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e21:	be 00 00 00 00       	mov    $0x0,%esi
  800e26:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e2b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e39:	8b 1c 24             	mov    (%esp),%ebx
  800e3c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e40:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e44:	89 ec                	mov    %ebp,%esp
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 38             	sub    $0x38,%esp
  800e4e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e51:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e54:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	89 df                	mov    %ebx,%edi
  800e69:	89 de                	mov    %ebx,%esi
  800e6b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	7e 28                	jle    800e99 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e75:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e7c:	00 
  800e7d:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  800e84:	00 
  800e85:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8c:	00 
  800e8d:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  800e94:	e8 1b f3 ff ff       	call   8001b4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e99:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e9c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e9f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea2:	89 ec                	mov    %ebp,%esp
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	83 ec 38             	sub    $0x38,%esp
  800eac:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eaf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eba:	b8 09 00 00 00       	mov    $0x9,%eax
  800ebf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	89 df                	mov    %ebx,%edi
  800ec7:	89 de                	mov    %ebx,%esi
  800ec9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	7e 28                	jle    800ef7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eda:	00 
  800edb:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  800ee2:	00 
  800ee3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eea:	00 
  800eeb:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  800ef2:	e8 bd f2 ff ff       	call   8001b4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ef7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800efa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800efd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f00:	89 ec                	mov    %ebp,%esp
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 38             	sub    $0x38,%esp
  800f0a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f10:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f18:	b8 08 00 00 00       	mov    $0x8,%eax
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	89 df                	mov    %ebx,%edi
  800f25:	89 de                	mov    %ebx,%esi
  800f27:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7e 28                	jle    800f55 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  800f50:	e8 5f f2 ff ff       	call   8001b4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f55:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f58:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5e:	89 ec                	mov    %ebp,%esp
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 38             	sub    $0x38,%esp
  800f68:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f76:	b8 06 00 00 00       	mov    $0x6,%eax
  800f7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	89 df                	mov    %ebx,%edi
  800f83:	89 de                	mov    %ebx,%esi
  800f85:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f87:	85 c0                	test   %eax,%eax
  800f89:	7e 28                	jle    800fb3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f96:	00 
  800f97:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  800f9e:	00 
  800f9f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa6:	00 
  800fa7:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  800fae:	e8 01 f2 ff ff       	call   8001b4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fbc:	89 ec                	mov    %ebp,%esp
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 38             	sub    $0x38,%esp
  800fc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fcc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcf:	b8 05 00 00 00       	mov    $0x5,%eax
  800fd4:	8b 75 18             	mov    0x18(%ebp),%esi
  800fd7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	7e 28                	jle    801011 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fed:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ff4:	00 
  800ff5:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  800ffc:	00 
  800ffd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801004:	00 
  801005:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  80100c:	e8 a3 f1 ff ff       	call   8001b4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801011:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801014:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801017:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101a:	89 ec                	mov    %ebp,%esp
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 38             	sub    $0x38,%esp
  801024:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801027:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102d:	be 00 00 00 00       	mov    $0x0,%esi
  801032:	b8 04 00 00 00       	mov    $0x4,%eax
  801037:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	89 f7                	mov    %esi,%edi
  801042:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801044:	85 c0                	test   %eax,%eax
  801046:	7e 28                	jle    801070 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801048:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801053:	00 
  801054:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  80105b:	00 
  80105c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801063:	00 
  801064:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  80106b:	e8 44 f1 ff ff       	call   8001b4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801070:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801073:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801076:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801079:	89 ec                	mov    %ebp,%esp
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 0c             	sub    $0xc,%esp
  801083:	89 1c 24             	mov    %ebx,(%esp)
  801086:	89 74 24 04          	mov    %esi,0x4(%esp)
  80108a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108e:	ba 00 00 00 00       	mov    $0x0,%edx
  801093:	b8 0b 00 00 00       	mov    $0xb,%eax
  801098:	89 d1                	mov    %edx,%ecx
  80109a:	89 d3                	mov    %edx,%ebx
  80109c:	89 d7                	mov    %edx,%edi
  80109e:	89 d6                	mov    %edx,%esi
  8010a0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010a2:	8b 1c 24             	mov    (%esp),%ebx
  8010a5:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010a9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ad:	89 ec                	mov    %ebp,%esp
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    

008010b1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 0c             	sub    $0xc,%esp
  8010b7:	89 1c 24             	mov    %ebx,(%esp)
  8010ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010be:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8010cc:	89 d1                	mov    %edx,%ecx
  8010ce:	89 d3                	mov    %edx,%ebx
  8010d0:	89 d7                	mov    %edx,%edi
  8010d2:	89 d6                	mov    %edx,%esi
  8010d4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010d6:	8b 1c 24             	mov    (%esp),%ebx
  8010d9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010dd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010e1:	89 ec                	mov    %ebp,%esp
  8010e3:	5d                   	pop    %ebp
  8010e4:	c3                   	ret    

008010e5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	83 ec 38             	sub    $0x38,%esp
  8010eb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010f1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f9:	b8 03 00 00 00       	mov    $0x3,%eax
  8010fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801101:	89 cb                	mov    %ecx,%ebx
  801103:	89 cf                	mov    %ecx,%edi
  801105:	89 ce                	mov    %ecx,%esi
  801107:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801109:	85 c0                	test   %eax,%eax
  80110b:	7e 28                	jle    801135 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801111:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801118:	00 
  801119:	c7 44 24 08 87 1c 80 	movl   $0x801c87,0x8(%esp)
  801120:	00 
  801121:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801128:	00 
  801129:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  801130:	e8 7f f0 ff ff       	call   8001b4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801135:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801138:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80113b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80113e:	89 ec                	mov    %ebp,%esp
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    
	...

00801144 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80114a:	c7 44 24 08 b2 1c 80 	movl   $0x801cb2,0x8(%esp)
  801151:	00 
  801152:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801159:	00 
  80115a:	c7 04 24 c8 1c 80 00 	movl   $0x801cc8,(%esp)
  801161:	e8 4e f0 ff ff       	call   8001b4 <_panic>

00801166 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  80116f:	c7 04 24 d4 13 80 00 	movl   $0x8013d4,(%esp)
  801176:	e8 ad 04 00 00       	call   801628 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80117b:	ba 07 00 00 00       	mov    $0x7,%edx
  801180:	89 d0                	mov    %edx,%eax
  801182:	cd 30                	int    $0x30
  801184:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801187:	85 c0                	test   %eax,%eax
  801189:	79 20                	jns    8011ab <fork+0x45>
		panic("sys_exofork: %e", envid);
  80118b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80118f:	c7 44 24 08 d3 1c 80 	movl   $0x801cd3,0x8(%esp)
  801196:	00 
  801197:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80119e:	00 
  80119f:	c7 04 24 c8 1c 80 00 	movl   $0x801cc8,(%esp)
  8011a6:	e8 09 f0 ff ff       	call   8001b4 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  8011ab:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8011b2:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  8011b7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8011bb:	75 21                	jne    8011de <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  8011bd:	e8 ef fe ff ff       	call   8010b1 <sys_getenvid>
  8011c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011c7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011cf:	a3 04 20 80 00       	mov    %eax,0x802004
  8011d4:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  8011d9:	e9 e5 01 00 00       	jmp    8013c3 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  8011de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8011e1:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8011e8:	a8 01                	test   $0x1,%al
  8011ea:	0f 84 4c 01 00 00    	je     80133c <fork+0x1d6>
  8011f0:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  8011f6:	0f 84 cf 01 00 00    	je     8013cb <fork+0x265>
		{
			addr = i << PDXSHIFT;
  8011fc:	c1 e2 16             	shl    $0x16,%edx
  8011ff:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801202:	89 d3                	mov    %edx,%ebx
  801204:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80120b:	00 
  80120c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801210:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801213:	89 04 24             	mov    %eax,(%esp)
  801216:	e8 03 fe ff ff       	call   80101e <sys_page_alloc>
			if(ret < 0) return ret;
  80121b:	85 c0                	test   %eax,%eax
  80121d:	0f 88 a0 01 00 00    	js     8013c3 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801223:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801227:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80122a:	89 14 24             	mov    %edx,(%esp)
  80122d:	e8 30 fd ff ff       	call   800f62 <sys_page_unmap>
			if(ret < 0) return ret;
  801232:	85 c0                	test   %eax,%eax
  801234:	0f 88 89 01 00 00    	js     8013c3 <fork+0x25d>
  80123a:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  80123f:	89 de                	mov    %ebx,%esi
  801241:	c1 e6 0c             	shl    $0xc,%esi
  801244:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801247:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  80124d:	0f 84 da 00 00 00    	je     80132d <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801253:	c1 ee 0c             	shr    $0xc,%esi
  801256:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801259:	a8 01                	test   $0x1,%al
  80125b:	0f 84 cc 00 00 00    	je     80132d <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801261:	89 f0                	mov    %esi,%eax
  801263:	c1 e0 0c             	shl    $0xc,%eax
  801266:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801269:	e8 43 fe ff ff       	call   8010b1 <sys_getenvid>
  80126e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801271:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801274:	89 c6                	mov    %eax,%esi
  801276:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  80127c:	25 01 04 00 00       	and    $0x401,%eax
  801281:	3d 01 04 00 00       	cmp    $0x401,%eax
  801286:	75 3a                	jne    8012c2 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801288:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80128f:	00 
  801290:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801293:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801297:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80129a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80129e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a5:	89 14 24             	mov    %edx,(%esp)
  8012a8:	e8 13 fd ff ff       	call   800fc0 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  8012ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b4:	c7 04 24 e3 1c 80 00 	movl   $0x801ce3,(%esp)
  8012bb:	e8 ad ef ff ff       	call   80026d <cprintf>
  8012c0:	eb 6b                	jmp    80132d <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  8012c2:	f7 c6 01 00 00 00    	test   $0x1,%esi
  8012c8:	74 14                	je     8012de <fork+0x178>
  8012ca:	f7 c6 02 08 00 00    	test   $0x802,%esi
  8012d0:	74 0c                	je     8012de <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  8012d2:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  8012d8:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  8012de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012e1:	89 74 24 10          	mov    %esi,0x10(%esp)
  8012e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012f7:	89 14 24             	mov    %edx,(%esp)
  8012fa:	e8 c1 fc ff ff       	call   800fc0 <sys_page_map>
	if(ret<0) return ret;
  8012ff:	85 c0                	test   %eax,%eax
  801301:	0f 88 bc 00 00 00    	js     8013c3 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801307:	89 74 24 10          	mov    %esi,0x10(%esp)
  80130b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80130e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801312:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801315:	89 54 24 08          	mov    %edx,0x8(%esp)
  801319:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131d:	89 14 24             	mov    %edx,(%esp)
  801320:	e8 9b fc ff ff       	call   800fc0 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801325:	85 c0                	test   %eax,%eax
  801327:	0f 88 96 00 00 00    	js     8013c3 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  80132d:	83 c3 01             	add    $0x1,%ebx
  801330:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801336:	0f 85 03 ff ff ff    	jne    80123f <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80133c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801340:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801347:	0f 85 91 fe ff ff    	jne    8011de <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  80134d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801354:	00 
  801355:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80135c:	ee 
  80135d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801360:	89 04 24             	mov    %eax,(%esp)
  801363:	e8 b6 fc ff ff       	call   80101e <sys_page_alloc>
	if(ret < 0) return ret;
  801368:	85 c0                	test   %eax,%eax
  80136a:	78 57                	js     8013c3 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  80136c:	a1 04 20 80 00       	mov    0x802004,%eax
  801371:	8b 40 64             	mov    0x64(%eax),%eax
  801374:	89 44 24 04          	mov    %eax,0x4(%esp)
  801378:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80137b:	89 14 24             	mov    %edx,(%esp)
  80137e:	e8 c5 fa ff ff       	call   800e48 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801383:	85 c0                	test   %eax,%eax
  801385:	78 3c                	js     8013c3 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801387:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80138e:	00 
  80138f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801392:	89 04 24             	mov    %eax,(%esp)
  801395:	e8 6a fb ff ff       	call   800f04 <sys_env_set_status>
  80139a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  80139c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80139f:	85 d2                	test   %edx,%edx
  8013a1:	79 20                	jns    8013c3 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  8013a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013a7:	c7 44 24 08 fa 1c 80 	movl   $0x801cfa,0x8(%esp)
  8013ae:	00 
  8013af:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8013b6:	00 
  8013b7:	c7 04 24 c8 1c 80 00 	movl   $0x801cc8,(%esp)
  8013be:	e8 f1 ed ff ff       	call   8001b4 <_panic>

	return envid;
}
  8013c3:	83 c4 4c             	add    $0x4c,%esp
  8013c6:	5b                   	pop    %ebx
  8013c7:	5e                   	pop    %esi
  8013c8:	5f                   	pop    %edi
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8013cb:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  8013cf:	e9 0a fe ff ff       	jmp    8011de <fork+0x78>

008013d4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	56                   	push   %esi
  8013d8:	53                   	push   %ebx
  8013d9:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  8013dc:	e8 d0 fc ff ff       	call   8010b1 <sys_getenvid>
  8013e1:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8b 00                	mov    (%eax),%eax
  8013e8:	89 c6                	mov    %eax,%esi
  8013ea:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  8013ed:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8013f4:	f6 c2 02             	test   $0x2,%dl
  8013f7:	75 2c                	jne    801425 <pgfault+0x51>
  8013f9:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801400:	f6 c6 08             	test   $0x8,%dh
  801403:	75 20                	jne    801425 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801405:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801409:	c7 44 24 08 48 1d 80 	movl   $0x801d48,0x8(%esp)
  801410:	00 
  801411:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801418:	00 
  801419:	c7 04 24 c8 1c 80 00 	movl   $0x801cc8,(%esp)
  801420:	e8 8f ed ff ff       	call   8001b4 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801425:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80142c:	00 
  80142d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801434:	00 
  801435:	89 1c 24             	mov    %ebx,(%esp)
  801438:	e8 e1 fb ff ff       	call   80101e <sys_page_alloc>
  80143d:	85 c0                	test   %eax,%eax
  80143f:	79 20                	jns    801461 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801441:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801445:	c7 44 24 08 11 1d 80 	movl   $0x801d11,0x8(%esp)
  80144c:	00 
  80144d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801454:	00 
  801455:	c7 04 24 c8 1c 80 00 	movl   $0x801cc8,(%esp)
  80145c:	e8 53 ed ff ff       	call   8001b4 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801461:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801464:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80146b:	00 
  80146c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801470:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801477:	e8 03 f6 ff ff       	call   800a7f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80147c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801483:	00 
  801484:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801488:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80148c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801493:	00 
  801494:	89 1c 24             	mov    %ebx,(%esp)
  801497:	e8 24 fb ff ff       	call   800fc0 <sys_page_map>
  80149c:	85 c0                	test   %eax,%eax
  80149e:	79 20                	jns    8014c0 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  8014a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014a4:	c7 44 24 08 23 1d 80 	movl   $0x801d23,0x8(%esp)
  8014ab:	00 
  8014ac:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  8014b3:	00 
  8014b4:	c7 04 24 c8 1c 80 00 	movl   $0x801cc8,(%esp)
  8014bb:	e8 f4 ec ff ff       	call   8001b4 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  8014c0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8014c7:	00 
  8014c8:	89 1c 24             	mov    %ebx,(%esp)
  8014cb:	e8 92 fa ff ff       	call   800f62 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	74 20                	je     8014f4 <pgfault+0x120>
  8014d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d8:	c7 44 24 08 33 1d 80 	movl   $0x801d33,0x8(%esp)
  8014df:	00 
  8014e0:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8014e7:	00 
  8014e8:	c7 04 24 c8 1c 80 00 	movl   $0x801cc8,(%esp)
  8014ef:	e8 c0 ec ff ff       	call   8001b4 <_panic>

}
  8014f4:	83 c4 20             	add    $0x20,%esp
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5d                   	pop    %ebp
  8014fa:	c3                   	ret    
	...

008014fc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801502:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801507:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80150a:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  801510:	8b 12                	mov    (%edx),%edx
  801512:	39 ca                	cmp    %ecx,%edx
  801514:	75 0c                	jne    801522 <ipc_find_env+0x26>
			return envs[i].env_id;
  801516:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801519:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  80151e:	8b 00                	mov    (%eax),%eax
  801520:	eb 0e                	jmp    801530 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801522:	83 c0 01             	add    $0x1,%eax
  801525:	3d 00 04 00 00       	cmp    $0x400,%eax
  80152a:	75 db                	jne    801507 <ipc_find_env+0xb>
  80152c:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  801530:	5d                   	pop    %ebp
  801531:	c3                   	ret    

00801532 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	57                   	push   %edi
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
  801538:	83 ec 2c             	sub    $0x2c,%esp
  80153b:	8b 75 08             	mov    0x8(%ebp),%esi
  80153e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801541:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  801544:	85 db                	test   %ebx,%ebx
  801546:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80154b:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  80154e:	8b 45 14             	mov    0x14(%ebp),%eax
  801551:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801555:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801559:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80155d:	89 34 24             	mov    %esi,(%esp)
  801560:	e8 ab f8 ff ff       	call   800e10 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  801565:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801568:	74 e4                	je     80154e <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  80156a:	85 c0                	test   %eax,%eax
  80156c:	74 28                	je     801596 <ipc_send+0x64>
  80156e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801572:	c7 44 24 0c 89 1d 80 	movl   $0x801d89,0xc(%esp)
  801579:	00 
  80157a:	c7 44 24 08 6c 1d 80 	movl   $0x801d6c,0x8(%esp)
  801581:	00 
  801582:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801589:	00 
  80158a:	c7 04 24 7f 1d 80 00 	movl   $0x801d7f,(%esp)
  801591:	e8 1e ec ff ff       	call   8001b4 <_panic>
	//if(!ret) sys_yield();
}
  801596:	83 c4 2c             	add    $0x2c,%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5f                   	pop    %edi
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    

0080159e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 28             	sub    $0x28,%esp
  8015a4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015a7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015aa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b3:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015bd:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015c0:	89 04 24             	mov    %eax,(%esp)
  8015c3:	e8 eb f7 ff ff       	call   800db3 <sys_ipc_recv>
  8015c8:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  8015ca:	e8 e2 fa ff ff       	call   8010b1 <sys_getenvid>
  8015cf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015d4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8015d7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015dc:	a3 04 20 80 00       	mov    %eax,0x802004
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  8015e1:	85 f6                	test   %esi,%esi
  8015e3:	74 0e                	je     8015f3 <ipc_recv+0x55>
  8015e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ea:	85 db                	test   %ebx,%ebx
  8015ec:	75 03                	jne    8015f1 <ipc_recv+0x53>
  8015ee:	8b 50 74             	mov    0x74(%eax),%edx
  8015f1:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  8015f3:	85 ff                	test   %edi,%edi
  8015f5:	74 13                	je     80160a <ipc_recv+0x6c>
  8015f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fc:	85 db                	test   %ebx,%ebx
  8015fe:	75 08                	jne    801608 <ipc_recv+0x6a>
  801600:	a1 04 20 80 00       	mov    0x802004,%eax
  801605:	8b 40 78             	mov    0x78(%eax),%eax
  801608:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  80160a:	85 db                	test   %ebx,%ebx
  80160c:	75 08                	jne    801616 <ipc_recv+0x78>
  80160e:	a1 04 20 80 00       	mov    0x802004,%eax
  801613:	8b 58 70             	mov    0x70(%eax),%ebx
}
  801616:	89 d8                	mov    %ebx,%eax
  801618:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80161b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80161e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801621:	89 ec                	mov    %ebp,%esp
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    
  801625:	00 00                	add    %al,(%eax)
	...

00801628 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	53                   	push   %ebx
  80162c:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  80162f:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801636:	75 5b                	jne    801693 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  801638:	e8 74 fa ff ff       	call   8010b1 <sys_getenvid>
  80163d:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80163f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801646:	00 
  801647:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80164e:	ee 
  80164f:	89 04 24             	mov    %eax,(%esp)
  801652:	e8 c7 f9 ff ff       	call   80101e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  801657:	85 c0                	test   %eax,%eax
  801659:	74 28                	je     801683 <set_pgfault_handler+0x5b>
  80165b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80165f:	c7 44 24 0c b9 1d 80 	movl   $0x801db9,0xc(%esp)
  801666:	00 
  801667:	c7 44 24 08 92 1d 80 	movl   $0x801d92,0x8(%esp)
  80166e:	00 
  80166f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801676:	00 
  801677:	c7 04 24 ab 1d 80 00 	movl   $0x801dab,(%esp)
  80167e:	e8 31 eb ff ff       	call   8001b4 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  801683:	c7 44 24 04 a4 16 80 	movl   $0x8016a4,0x4(%esp)
  80168a:	00 
  80168b:	89 1c 24             	mov    %ebx,(%esp)
  80168e:	e8 b5 f7 ff ff       	call   800e48 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	a3 08 20 80 00       	mov    %eax,0x802008
	
}
  80169b:	83 c4 24             	add    $0x24,%esp
  80169e:	5b                   	pop    %ebx
  80169f:	5d                   	pop    %ebp
  8016a0:	c3                   	ret    
  8016a1:	00 00                	add    %al,(%eax)
	...

008016a4 <_pgfault_upcall>:
  8016a4:	54                   	push   %esp
  8016a5:	a1 08 20 80 00       	mov    0x802008,%eax
  8016aa:	ff d0                	call   *%eax
  8016ac:	83 c4 04             	add    $0x4,%esp
  8016af:	83 c4 08             	add    $0x8,%esp
  8016b2:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  8016b6:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8016ba:	89 59 fc             	mov    %ebx,-0x4(%ecx)
  8016bd:	83 e9 04             	sub    $0x4,%ecx
  8016c0:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  8016c4:	61                   	popa   
  8016c5:	83 c4 04             	add    $0x4,%esp
  8016c8:	9d                   	popf   
  8016c9:	5c                   	pop    %esp
  8016ca:	c3                   	ret    
  8016cb:	00 00                	add    %al,(%eax)
  8016cd:	00 00                	add    %al,(%eax)
	...

008016d0 <__udivdi3>:
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	57                   	push   %edi
  8016d4:	56                   	push   %esi
  8016d5:	83 ec 10             	sub    $0x10,%esp
  8016d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016db:	8b 55 08             	mov    0x8(%ebp),%edx
  8016de:	8b 75 10             	mov    0x10(%ebp),%esi
  8016e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8016e9:	75 35                	jne    801720 <__udivdi3+0x50>
  8016eb:	39 fe                	cmp    %edi,%esi
  8016ed:	77 61                	ja     801750 <__udivdi3+0x80>
  8016ef:	85 f6                	test   %esi,%esi
  8016f1:	75 0b                	jne    8016fe <__udivdi3+0x2e>
  8016f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f8:	31 d2                	xor    %edx,%edx
  8016fa:	f7 f6                	div    %esi
  8016fc:	89 c6                	mov    %eax,%esi
  8016fe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801701:	31 d2                	xor    %edx,%edx
  801703:	89 f8                	mov    %edi,%eax
  801705:	f7 f6                	div    %esi
  801707:	89 c7                	mov    %eax,%edi
  801709:	89 c8                	mov    %ecx,%eax
  80170b:	f7 f6                	div    %esi
  80170d:	89 c1                	mov    %eax,%ecx
  80170f:	89 fa                	mov    %edi,%edx
  801711:	89 c8                	mov    %ecx,%eax
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	5e                   	pop    %esi
  801717:	5f                   	pop    %edi
  801718:	5d                   	pop    %ebp
  801719:	c3                   	ret    
  80171a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801720:	39 f8                	cmp    %edi,%eax
  801722:	77 1c                	ja     801740 <__udivdi3+0x70>
  801724:	0f bd d0             	bsr    %eax,%edx
  801727:	83 f2 1f             	xor    $0x1f,%edx
  80172a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80172d:	75 39                	jne    801768 <__udivdi3+0x98>
  80172f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801732:	0f 86 a0 00 00 00    	jbe    8017d8 <__udivdi3+0x108>
  801738:	39 f8                	cmp    %edi,%eax
  80173a:	0f 82 98 00 00 00    	jb     8017d8 <__udivdi3+0x108>
  801740:	31 ff                	xor    %edi,%edi
  801742:	31 c9                	xor    %ecx,%ecx
  801744:	89 c8                	mov    %ecx,%eax
  801746:	89 fa                	mov    %edi,%edx
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	5e                   	pop    %esi
  80174c:	5f                   	pop    %edi
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    
  80174f:	90                   	nop
  801750:	89 d1                	mov    %edx,%ecx
  801752:	89 fa                	mov    %edi,%edx
  801754:	89 c8                	mov    %ecx,%eax
  801756:	31 ff                	xor    %edi,%edi
  801758:	f7 f6                	div    %esi
  80175a:	89 c1                	mov    %eax,%ecx
  80175c:	89 fa                	mov    %edi,%edx
  80175e:	89 c8                	mov    %ecx,%eax
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	5e                   	pop    %esi
  801764:	5f                   	pop    %edi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    
  801767:	90                   	nop
  801768:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80176c:	89 f2                	mov    %esi,%edx
  80176e:	d3 e0                	shl    %cl,%eax
  801770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801773:	b8 20 00 00 00       	mov    $0x20,%eax
  801778:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80177b:	89 c1                	mov    %eax,%ecx
  80177d:	d3 ea                	shr    %cl,%edx
  80177f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801783:	0b 55 ec             	or     -0x14(%ebp),%edx
  801786:	d3 e6                	shl    %cl,%esi
  801788:	89 c1                	mov    %eax,%ecx
  80178a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80178d:	89 fe                	mov    %edi,%esi
  80178f:	d3 ee                	shr    %cl,%esi
  801791:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801795:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801798:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80179b:	d3 e7                	shl    %cl,%edi
  80179d:	89 c1                	mov    %eax,%ecx
  80179f:	d3 ea                	shr    %cl,%edx
  8017a1:	09 d7                	or     %edx,%edi
  8017a3:	89 f2                	mov    %esi,%edx
  8017a5:	89 f8                	mov    %edi,%eax
  8017a7:	f7 75 ec             	divl   -0x14(%ebp)
  8017aa:	89 d6                	mov    %edx,%esi
  8017ac:	89 c7                	mov    %eax,%edi
  8017ae:	f7 65 e8             	mull   -0x18(%ebp)
  8017b1:	39 d6                	cmp    %edx,%esi
  8017b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8017b6:	72 30                	jb     8017e8 <__udivdi3+0x118>
  8017b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017bb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8017bf:	d3 e2                	shl    %cl,%edx
  8017c1:	39 c2                	cmp    %eax,%edx
  8017c3:	73 05                	jae    8017ca <__udivdi3+0xfa>
  8017c5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8017c8:	74 1e                	je     8017e8 <__udivdi3+0x118>
  8017ca:	89 f9                	mov    %edi,%ecx
  8017cc:	31 ff                	xor    %edi,%edi
  8017ce:	e9 71 ff ff ff       	jmp    801744 <__udivdi3+0x74>
  8017d3:	90                   	nop
  8017d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8017d8:	31 ff                	xor    %edi,%edi
  8017da:	b9 01 00 00 00       	mov    $0x1,%ecx
  8017df:	e9 60 ff ff ff       	jmp    801744 <__udivdi3+0x74>
  8017e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8017e8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8017eb:	31 ff                	xor    %edi,%edi
  8017ed:	89 c8                	mov    %ecx,%eax
  8017ef:	89 fa                	mov    %edi,%edx
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	5e                   	pop    %esi
  8017f5:	5f                   	pop    %edi
  8017f6:	5d                   	pop    %ebp
  8017f7:	c3                   	ret    
	...

00801800 <__umoddi3>:
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	57                   	push   %edi
  801804:	56                   	push   %esi
  801805:	83 ec 20             	sub    $0x20,%esp
  801808:	8b 55 14             	mov    0x14(%ebp),%edx
  80180b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801811:	8b 75 0c             	mov    0xc(%ebp),%esi
  801814:	85 d2                	test   %edx,%edx
  801816:	89 c8                	mov    %ecx,%eax
  801818:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80181b:	75 13                	jne    801830 <__umoddi3+0x30>
  80181d:	39 f7                	cmp    %esi,%edi
  80181f:	76 3f                	jbe    801860 <__umoddi3+0x60>
  801821:	89 f2                	mov    %esi,%edx
  801823:	f7 f7                	div    %edi
  801825:	89 d0                	mov    %edx,%eax
  801827:	31 d2                	xor    %edx,%edx
  801829:	83 c4 20             	add    $0x20,%esp
  80182c:	5e                   	pop    %esi
  80182d:	5f                   	pop    %edi
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    
  801830:	39 f2                	cmp    %esi,%edx
  801832:	77 4c                	ja     801880 <__umoddi3+0x80>
  801834:	0f bd ca             	bsr    %edx,%ecx
  801837:	83 f1 1f             	xor    $0x1f,%ecx
  80183a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80183d:	75 51                	jne    801890 <__umoddi3+0x90>
  80183f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801842:	0f 87 e0 00 00 00    	ja     801928 <__umoddi3+0x128>
  801848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184b:	29 f8                	sub    %edi,%eax
  80184d:	19 d6                	sbb    %edx,%esi
  80184f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801855:	89 f2                	mov    %esi,%edx
  801857:	83 c4 20             	add    $0x20,%esp
  80185a:	5e                   	pop    %esi
  80185b:	5f                   	pop    %edi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    
  80185e:	66 90                	xchg   %ax,%ax
  801860:	85 ff                	test   %edi,%edi
  801862:	75 0b                	jne    80186f <__umoddi3+0x6f>
  801864:	b8 01 00 00 00       	mov    $0x1,%eax
  801869:	31 d2                	xor    %edx,%edx
  80186b:	f7 f7                	div    %edi
  80186d:	89 c7                	mov    %eax,%edi
  80186f:	89 f0                	mov    %esi,%eax
  801871:	31 d2                	xor    %edx,%edx
  801873:	f7 f7                	div    %edi
  801875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801878:	f7 f7                	div    %edi
  80187a:	eb a9                	jmp    801825 <__umoddi3+0x25>
  80187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801880:	89 c8                	mov    %ecx,%eax
  801882:	89 f2                	mov    %esi,%edx
  801884:	83 c4 20             	add    $0x20,%esp
  801887:	5e                   	pop    %esi
  801888:	5f                   	pop    %edi
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    
  80188b:	90                   	nop
  80188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801890:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801894:	d3 e2                	shl    %cl,%edx
  801896:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801899:	ba 20 00 00 00       	mov    $0x20,%edx
  80189e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8018a1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8018a4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8018a8:	89 fa                	mov    %edi,%edx
  8018aa:	d3 ea                	shr    %cl,%edx
  8018ac:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018b0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8018b3:	d3 e7                	shl    %cl,%edi
  8018b5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8018b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8018bc:	89 f2                	mov    %esi,%edx
  8018be:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8018c1:	89 c7                	mov    %eax,%edi
  8018c3:	d3 ea                	shr    %cl,%edx
  8018c5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8018cc:	89 c2                	mov    %eax,%edx
  8018ce:	d3 e6                	shl    %cl,%esi
  8018d0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8018d4:	d3 ea                	shr    %cl,%edx
  8018d6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018da:	09 d6                	or     %edx,%esi
  8018dc:	89 f0                	mov    %esi,%eax
  8018de:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8018e1:	d3 e7                	shl    %cl,%edi
  8018e3:	89 f2                	mov    %esi,%edx
  8018e5:	f7 75 f4             	divl   -0xc(%ebp)
  8018e8:	89 d6                	mov    %edx,%esi
  8018ea:	f7 65 e8             	mull   -0x18(%ebp)
  8018ed:	39 d6                	cmp    %edx,%esi
  8018ef:	72 2b                	jb     80191c <__umoddi3+0x11c>
  8018f1:	39 c7                	cmp    %eax,%edi
  8018f3:	72 23                	jb     801918 <__umoddi3+0x118>
  8018f5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018f9:	29 c7                	sub    %eax,%edi
  8018fb:	19 d6                	sbb    %edx,%esi
  8018fd:	89 f0                	mov    %esi,%eax
  8018ff:	89 f2                	mov    %esi,%edx
  801901:	d3 ef                	shr    %cl,%edi
  801903:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801907:	d3 e0                	shl    %cl,%eax
  801909:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80190d:	09 f8                	or     %edi,%eax
  80190f:	d3 ea                	shr    %cl,%edx
  801911:	83 c4 20             	add    $0x20,%esp
  801914:	5e                   	pop    %esi
  801915:	5f                   	pop    %edi
  801916:	5d                   	pop    %ebp
  801917:	c3                   	ret    
  801918:	39 d6                	cmp    %edx,%esi
  80191a:	75 d9                	jne    8018f5 <__umoddi3+0xf5>
  80191c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80191f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801922:	eb d1                	jmp    8018f5 <__umoddi3+0xf5>
  801924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801928:	39 f2                	cmp    %esi,%edx
  80192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801930:	0f 82 12 ff ff ff    	jb     801848 <__umoddi3+0x48>
  801936:	e9 17 ff ff ff       	jmp    801852 <__umoddi3+0x52>
