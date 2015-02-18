
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
}

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  80003a:	c7 04 24 5c 00 80 00 	movl   $0x80005c,(%esp)
  800041:	e8 8e 10 00 00       	call   8010d4 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  800046:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  80004d:	00 
  80004e:	c7 04 24 ef be ad de 	movl   $0xdeadbeef,(%esp)
  800055:	e8 c6 0b 00 00       	call   800c20 <sys_cputs>
}
  80005a:	c9                   	leave  
  80005b:	c3                   	ret    

0080005c <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	53                   	push   %ebx
  800060:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800063:	8b 45 08             	mov    0x8(%ebp),%eax
  800066:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  800068:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80006c:	c7 04 24 00 14 80 00 	movl   $0x801400,(%esp)
  800073:	e8 89 01 00 00       	call   800201 <cprintf>
	if ((r = sys_page_alloc(sys_getenvid(), ROUNDDOWN(addr, PGSIZE),
  800078:	e8 c4 0f 00 00       	call   801041 <sys_getenvid>
  80007d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800084:	00 
  800085:	89 da                	mov    %ebx,%edx
  800087:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80008d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800091:	89 04 24             	mov    %eax,(%esp)
  800094:	e8 15 0f 00 00       	call   800fae <sys_page_alloc>
  800099:	85 c0                	test   %eax,%eax
  80009b:	79 24                	jns    8000c1 <handler+0x65>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  80009d:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000a1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000a5:	c7 44 24 08 20 14 80 	movl   $0x801420,0x8(%esp)
  8000ac:	00 
  8000ad:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b4:	00 
  8000b5:	c7 04 24 0a 14 80 00 	movl   $0x80140a,(%esp)
  8000bc:	e8 87 00 00 00       	call   800148 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000c5:	c7 44 24 08 4c 14 80 	movl   $0x80144c,0x8(%esp)
  8000cc:	00 
  8000cd:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000d4:	00 
  8000d5:	89 1c 24             	mov    %ebx,(%esp)
  8000d8:	e8 fb 06 00 00       	call   8007d8 <snprintf>
}
  8000dd:	83 c4 24             	add    $0x24,%esp
  8000e0:	5b                   	pop    %ebx
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    
	...

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 18             	sub    $0x18,%esp
  8000ea:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000ed:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8000f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8000f6:	e8 46 0f 00 00       	call   801041 <sys_getenvid>
  8000fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800100:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800103:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800108:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010d:	85 f6                	test   %esi,%esi
  80010f:	7e 07                	jle    800118 <libmain+0x34>
		binaryname = argv[0];
  800111:	8b 03                	mov    (%ebx),%eax
  800113:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800118:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80011c:	89 34 24             	mov    %esi,(%esp)
  80011f:	e8 10 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800124:	e8 0b 00 00 00       	call   800134 <exit>
}
  800129:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80012c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80012f:	89 ec                	mov    %ebp,%esp
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    
	...

00800134 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80013a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800141:	e8 2f 0f 00 00       	call   801075 <sys_env_destroy>
}
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
  80014d:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800150:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800153:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  800159:	e8 e3 0e 00 00       	call   801041 <sys_getenvid>
  80015e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800161:	89 54 24 10          	mov    %edx,0x10(%esp)
  800165:	8b 55 08             	mov    0x8(%ebp),%edx
  800168:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80016c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800170:	89 44 24 04          	mov    %eax,0x4(%esp)
  800174:	c7 04 24 78 14 80 00 	movl   $0x801478,(%esp)
  80017b:	e8 81 00 00 00       	call   800201 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800180:	89 74 24 04          	mov    %esi,0x4(%esp)
  800184:	8b 45 10             	mov    0x10(%ebp),%eax
  800187:	89 04 24             	mov    %eax,(%esp)
  80018a:	e8 11 00 00 00       	call   8001a0 <vcprintf>
	cprintf("\n");
  80018f:	c7 04 24 08 14 80 00 	movl   $0x801408,(%esp)
  800196:	e8 66 00 00 00       	call   800201 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80019b:	cc                   	int3   
  80019c:	eb fd                	jmp    80019b <_panic+0x53>
	...

008001a0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b0:	00 00 00 
	b.cnt = 0;
  8001b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d5:	c7 04 24 1b 02 80 00 	movl   $0x80021b,(%esp)
  8001dc:	e8 be 01 00 00       	call   80039f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001eb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f1:	89 04 24             	mov    %eax,(%esp)
  8001f4:	e8 27 0a 00 00       	call   800c20 <sys_cputs>

	return b.cnt;
}
  8001f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    

00800201 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800207:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80020a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020e:	8b 45 08             	mov    0x8(%ebp),%eax
  800211:	89 04 24             	mov    %eax,(%esp)
  800214:	e8 87 ff ff ff       	call   8001a0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800219:	c9                   	leave  
  80021a:	c3                   	ret    

0080021b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	53                   	push   %ebx
  80021f:	83 ec 14             	sub    $0x14,%esp
  800222:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800225:	8b 03                	mov    (%ebx),%eax
  800227:	8b 55 08             	mov    0x8(%ebp),%edx
  80022a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80022e:	83 c0 01             	add    $0x1,%eax
  800231:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800233:	3d ff 00 00 00       	cmp    $0xff,%eax
  800238:	75 19                	jne    800253 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80023a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800241:	00 
  800242:	8d 43 08             	lea    0x8(%ebx),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	e8 d3 09 00 00       	call   800c20 <sys_cputs>
		b->idx = 0;
  80024d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800253:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800257:	83 c4 14             	add    $0x14,%esp
  80025a:	5b                   	pop    %ebx
  80025b:	5d                   	pop    %ebp
  80025c:	c3                   	ret    
  80025d:	00 00                	add    %al,(%eax)
	...

00800260 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	83 ec 4c             	sub    $0x4c,%esp
  800269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80026c:	89 d6                	mov    %edx,%esi
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800274:	8b 55 0c             	mov    0xc(%ebp),%edx
  800277:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80027a:	8b 45 10             	mov    0x10(%ebp),%eax
  80027d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800280:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800283:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800286:	b9 00 00 00 00       	mov    $0x0,%ecx
  80028b:	39 d1                	cmp    %edx,%ecx
  80028d:	72 07                	jb     800296 <printnum+0x36>
  80028f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800292:	39 d0                	cmp    %edx,%eax
  800294:	77 69                	ja     8002ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800296:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80029a:	83 eb 01             	sub    $0x1,%ebx
  80029d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8002a9:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8002ad:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8002b0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002b3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002b6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002ba:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002c1:	00 
  8002c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c5:	89 04 24             	mov    %eax,(%esp)
  8002c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002cf:	e8 ac 0e 00 00       	call   801180 <__udivdi3>
  8002d4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002d7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002da:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002de:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002e2:	89 04 24             	mov    %eax,(%esp)
  8002e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e9:	89 f2                	mov    %esi,%edx
  8002eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ee:	e8 6d ff ff ff       	call   800260 <printnum>
  8002f3:	eb 11                	jmp    800306 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002f9:	89 3c 24             	mov    %edi,(%esp)
  8002fc:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002ff:	83 eb 01             	sub    $0x1,%ebx
  800302:	85 db                	test   %ebx,%ebx
  800304:	7f ef                	jg     8002f5 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800306:	89 74 24 04          	mov    %esi,0x4(%esp)
  80030a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80030e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800311:	89 44 24 08          	mov    %eax,0x8(%esp)
  800315:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80031c:	00 
  80031d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800320:	89 14 24             	mov    %edx,(%esp)
  800323:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800326:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80032a:	e8 81 0f 00 00       	call   8012b0 <__umoddi3>
  80032f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800333:	0f be 80 9b 14 80 00 	movsbl 0x80149b(%eax),%eax
  80033a:	89 04 24             	mov    %eax,(%esp)
  80033d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800340:	83 c4 4c             	add    $0x4c,%esp
  800343:	5b                   	pop    %ebx
  800344:	5e                   	pop    %esi
  800345:	5f                   	pop    %edi
  800346:	5d                   	pop    %ebp
  800347:	c3                   	ret    

00800348 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80034b:	83 fa 01             	cmp    $0x1,%edx
  80034e:	7e 0e                	jle    80035e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800350:	8b 10                	mov    (%eax),%edx
  800352:	8d 4a 08             	lea    0x8(%edx),%ecx
  800355:	89 08                	mov    %ecx,(%eax)
  800357:	8b 02                	mov    (%edx),%eax
  800359:	8b 52 04             	mov    0x4(%edx),%edx
  80035c:	eb 22                	jmp    800380 <getuint+0x38>
	else if (lflag)
  80035e:	85 d2                	test   %edx,%edx
  800360:	74 10                	je     800372 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800362:	8b 10                	mov    (%eax),%edx
  800364:	8d 4a 04             	lea    0x4(%edx),%ecx
  800367:	89 08                	mov    %ecx,(%eax)
  800369:	8b 02                	mov    (%edx),%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
  800370:	eb 0e                	jmp    800380 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800372:	8b 10                	mov    (%eax),%edx
  800374:	8d 4a 04             	lea    0x4(%edx),%ecx
  800377:	89 08                	mov    %ecx,(%eax)
  800379:	8b 02                	mov    (%edx),%eax
  80037b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800380:	5d                   	pop    %ebp
  800381:	c3                   	ret    

00800382 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800388:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038c:	8b 10                	mov    (%eax),%edx
  80038e:	3b 50 04             	cmp    0x4(%eax),%edx
  800391:	73 0a                	jae    80039d <sprintputch+0x1b>
		*b->buf++ = ch;
  800393:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800396:	88 0a                	mov    %cl,(%edx)
  800398:	83 c2 01             	add    $0x1,%edx
  80039b:	89 10                	mov    %edx,(%eax)
}
  80039d:	5d                   	pop    %ebp
  80039e:	c3                   	ret    

0080039f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	57                   	push   %edi
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
  8003a5:	83 ec 4c             	sub    $0x4c,%esp
  8003a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8003b1:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8003b8:	eb 11                	jmp    8003cb <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ba:	85 c0                	test   %eax,%eax
  8003bc:	0f 84 b6 03 00 00    	je     800778 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8003c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003c6:	89 04 24             	mov    %eax,(%esp)
  8003c9:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003cb:	0f b6 03             	movzbl (%ebx),%eax
  8003ce:	83 c3 01             	add    $0x1,%ebx
  8003d1:	83 f8 25             	cmp    $0x25,%eax
  8003d4:	75 e4                	jne    8003ba <vprintfmt+0x1b>
  8003d6:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8003da:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003e1:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8003e8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8003f7:	eb 06                	jmp    8003ff <vprintfmt+0x60>
  8003f9:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8003fd:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ff:	0f b6 0b             	movzbl (%ebx),%ecx
  800402:	0f b6 c1             	movzbl %cl,%eax
  800405:	8d 53 01             	lea    0x1(%ebx),%edx
  800408:	83 e9 23             	sub    $0x23,%ecx
  80040b:	80 f9 55             	cmp    $0x55,%cl
  80040e:	0f 87 47 03 00 00    	ja     80075b <vprintfmt+0x3bc>
  800414:	0f b6 c9             	movzbl %cl,%ecx
  800417:	ff 24 8d e0 15 80 00 	jmp    *0x8015e0(,%ecx,4)
  80041e:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800422:	eb d9                	jmp    8003fd <vprintfmt+0x5e>
  800424:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80042b:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800430:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800433:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800437:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80043a:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80043d:	83 fb 09             	cmp    $0x9,%ebx
  800440:	77 30                	ja     800472 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800442:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800445:	eb e9                	jmp    800430 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8d 48 04             	lea    0x4(%eax),%ecx
  80044d:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800450:	8b 00                	mov    (%eax),%eax
  800452:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800455:	eb 1e                	jmp    800475 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800457:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800467:	eb 94                	jmp    8003fd <vprintfmt+0x5e>
  800469:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800470:	eb 8b                	jmp    8003fd <vprintfmt+0x5e>
  800472:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800475:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800479:	79 82                	jns    8003fd <vprintfmt+0x5e>
  80047b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80047e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800481:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800484:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800487:	e9 71 ff ff ff       	jmp    8003fd <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80048c:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800490:	e9 68 ff ff ff       	jmp    8003fd <vprintfmt+0x5e>
  800495:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800498:	8b 45 14             	mov    0x14(%ebp),%eax
  80049b:	8d 50 04             	lea    0x4(%eax),%edx
  80049e:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	89 04 24             	mov    %eax,(%esp)
  8004aa:	ff d7                	call   *%edi
  8004ac:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8004af:	e9 17 ff ff ff       	jmp    8003cb <vprintfmt+0x2c>
  8004b4:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	8d 50 04             	lea    0x4(%eax),%edx
  8004bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	c1 fa 1f             	sar    $0x1f,%edx
  8004c7:	31 d0                	xor    %edx,%eax
  8004c9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004cb:	83 f8 11             	cmp    $0x11,%eax
  8004ce:	7f 0b                	jg     8004db <vprintfmt+0x13c>
  8004d0:	8b 14 85 40 17 80 00 	mov    0x801740(,%eax,4),%edx
  8004d7:	85 d2                	test   %edx,%edx
  8004d9:	75 20                	jne    8004fb <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8004db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004df:	c7 44 24 08 ac 14 80 	movl   $0x8014ac,0x8(%esp)
  8004e6:	00 
  8004e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004eb:	89 3c 24             	mov    %edi,(%esp)
  8004ee:	e8 0d 03 00 00       	call   800800 <printfmt>
  8004f3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f6:	e9 d0 fe ff ff       	jmp    8003cb <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8004fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004ff:	c7 44 24 08 b5 14 80 	movl   $0x8014b5,0x8(%esp)
  800506:	00 
  800507:	89 74 24 04          	mov    %esi,0x4(%esp)
  80050b:	89 3c 24             	mov    %edi,(%esp)
  80050e:	e8 ed 02 00 00       	call   800800 <printfmt>
  800513:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800516:	e9 b0 fe ff ff       	jmp    8003cb <vprintfmt+0x2c>
  80051b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80051e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800524:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	8d 50 04             	lea    0x4(%eax),%edx
  80052d:	89 55 14             	mov    %edx,0x14(%ebp)
  800530:	8b 18                	mov    (%eax),%ebx
  800532:	85 db                	test   %ebx,%ebx
  800534:	b8 b8 14 80 00       	mov    $0x8014b8,%eax
  800539:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  80053c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800540:	7e 76                	jle    8005b8 <vprintfmt+0x219>
  800542:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800546:	74 7a                	je     8005c2 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800548:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80054c:	89 1c 24             	mov    %ebx,(%esp)
  80054f:	e8 f4 02 00 00       	call   800848 <strnlen>
  800554:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800557:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800559:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  80055d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800560:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800563:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800565:	eb 0f                	jmp    800576 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800567:	89 74 24 04          	mov    %esi,0x4(%esp)
  80056b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056e:	89 04 24             	mov    %eax,(%esp)
  800571:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800573:	83 eb 01             	sub    $0x1,%ebx
  800576:	85 db                	test   %ebx,%ebx
  800578:	7f ed                	jg     800567 <vprintfmt+0x1c8>
  80057a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80057d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800580:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800583:	89 f7                	mov    %esi,%edi
  800585:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800588:	eb 40                	jmp    8005ca <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80058a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80058e:	74 18                	je     8005a8 <vprintfmt+0x209>
  800590:	8d 50 e0             	lea    -0x20(%eax),%edx
  800593:	83 fa 5e             	cmp    $0x5e,%edx
  800596:	76 10                	jbe    8005a8 <vprintfmt+0x209>
					putch('?', putdat);
  800598:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005a3:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005a6:	eb 0a                	jmp    8005b2 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8005a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ac:	89 04 24             	mov    %eax,(%esp)
  8005af:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005b6:	eb 12                	jmp    8005ca <vprintfmt+0x22b>
  8005b8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005bb:	89 f7                	mov    %esi,%edi
  8005bd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005c0:	eb 08                	jmp    8005ca <vprintfmt+0x22b>
  8005c2:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005c5:	89 f7                	mov    %esi,%edi
  8005c7:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005ca:	0f be 03             	movsbl (%ebx),%eax
  8005cd:	83 c3 01             	add    $0x1,%ebx
  8005d0:	85 c0                	test   %eax,%eax
  8005d2:	74 25                	je     8005f9 <vprintfmt+0x25a>
  8005d4:	85 f6                	test   %esi,%esi
  8005d6:	78 b2                	js     80058a <vprintfmt+0x1eb>
  8005d8:	83 ee 01             	sub    $0x1,%esi
  8005db:	79 ad                	jns    80058a <vprintfmt+0x1eb>
  8005dd:	89 fe                	mov    %edi,%esi
  8005df:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005e5:	eb 1a                	jmp    800601 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005eb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005f2:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005f4:	83 eb 01             	sub    $0x1,%ebx
  8005f7:	eb 08                	jmp    800601 <vprintfmt+0x262>
  8005f9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005fc:	89 fe                	mov    %edi,%esi
  8005fe:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800601:	85 db                	test   %ebx,%ebx
  800603:	7f e2                	jg     8005e7 <vprintfmt+0x248>
  800605:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800608:	e9 be fd ff ff       	jmp    8003cb <vprintfmt+0x2c>
  80060d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800610:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800613:	83 f9 01             	cmp    $0x1,%ecx
  800616:	7e 16                	jle    80062e <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 50 08             	lea    0x8(%eax),%edx
  80061e:	89 55 14             	mov    %edx,0x14(%ebp)
  800621:	8b 10                	mov    (%eax),%edx
  800623:	8b 48 04             	mov    0x4(%eax),%ecx
  800626:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800629:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80062c:	eb 32                	jmp    800660 <vprintfmt+0x2c1>
	else if (lflag)
  80062e:	85 c9                	test   %ecx,%ecx
  800630:	74 18                	je     80064a <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 50 04             	lea    0x4(%eax),%edx
  800638:	89 55 14             	mov    %edx,0x14(%ebp)
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800640:	89 c1                	mov    %eax,%ecx
  800642:	c1 f9 1f             	sar    $0x1f,%ecx
  800645:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800648:	eb 16                	jmp    800660 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8d 50 04             	lea    0x4(%eax),%edx
  800650:	89 55 14             	mov    %edx,0x14(%ebp)
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800658:	89 c2                	mov    %eax,%edx
  80065a:	c1 fa 1f             	sar    $0x1f,%edx
  80065d:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800660:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800663:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800666:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80066b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80066f:	0f 89 a7 00 00 00    	jns    80071c <vprintfmt+0x37d>
				putch('-', putdat);
  800675:	89 74 24 04          	mov    %esi,0x4(%esp)
  800679:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800680:	ff d7                	call   *%edi
				num = -(long long) num;
  800682:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800685:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800688:	f7 d9                	neg    %ecx
  80068a:	83 d3 00             	adc    $0x0,%ebx
  80068d:	f7 db                	neg    %ebx
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800694:	e9 83 00 00 00       	jmp    80071c <vprintfmt+0x37d>
  800699:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80069c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80069f:	89 ca                	mov    %ecx,%edx
  8006a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a4:	e8 9f fc ff ff       	call   800348 <getuint>
  8006a9:	89 c1                	mov    %eax,%ecx
  8006ab:	89 d3                	mov    %edx,%ebx
  8006ad:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8006b2:	eb 68                	jmp    80071c <vprintfmt+0x37d>
  8006b4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006b7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006ba:	89 ca                	mov    %ecx,%edx
  8006bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8006bf:	e8 84 fc ff ff       	call   800348 <getuint>
  8006c4:	89 c1                	mov    %eax,%ecx
  8006c6:	89 d3                	mov    %edx,%ebx
  8006c8:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8006cd:	eb 4d                	jmp    80071c <vprintfmt+0x37d>
  8006cf:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8006d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006d6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006dd:	ff d7                	call   *%edi
			putch('x', putdat);
  8006df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e3:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006ea:	ff d7                	call   *%edi
			num = (unsigned long long)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f5:	8b 08                	mov    (%eax),%ecx
  8006f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fc:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800701:	eb 19                	jmp    80071c <vprintfmt+0x37d>
  800703:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800706:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800709:	89 ca                	mov    %ecx,%edx
  80070b:	8d 45 14             	lea    0x14(%ebp),%eax
  80070e:	e8 35 fc ff ff       	call   800348 <getuint>
  800713:	89 c1                	mov    %eax,%ecx
  800715:	89 d3                	mov    %edx,%ebx
  800717:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80071c:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800720:	89 54 24 10          	mov    %edx,0x10(%esp)
  800724:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800727:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80072b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80072f:	89 0c 24             	mov    %ecx,(%esp)
  800732:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800736:	89 f2                	mov    %esi,%edx
  800738:	89 f8                	mov    %edi,%eax
  80073a:	e8 21 fb ff ff       	call   800260 <printnum>
  80073f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800742:	e9 84 fc ff ff       	jmp    8003cb <vprintfmt+0x2c>
  800747:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80074a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80074e:	89 04 24             	mov    %eax,(%esp)
  800751:	ff d7                	call   *%edi
  800753:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800756:	e9 70 fc ff ff       	jmp    8003cb <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80075b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800766:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800768:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80076b:	80 38 25             	cmpb   $0x25,(%eax)
  80076e:	0f 84 57 fc ff ff    	je     8003cb <vprintfmt+0x2c>
  800774:	89 c3                	mov    %eax,%ebx
  800776:	eb f0                	jmp    800768 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800778:	83 c4 4c             	add    $0x4c,%esp
  80077b:	5b                   	pop    %ebx
  80077c:	5e                   	pop    %esi
  80077d:	5f                   	pop    %edi
  80077e:	5d                   	pop    %ebp
  80077f:	c3                   	ret    

00800780 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 28             	sub    $0x28,%esp
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80078c:	85 c0                	test   %eax,%eax
  80078e:	74 04                	je     800794 <vsnprintf+0x14>
  800790:	85 d2                	test   %edx,%edx
  800792:	7f 07                	jg     80079b <vsnprintf+0x1b>
  800794:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800799:	eb 3b                	jmp    8007d6 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80079e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8007a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c1:	c7 04 24 82 03 80 00 	movl   $0x800382,(%esp)
  8007c8:	e8 d2 fb ff ff       	call   80039f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    

008007d8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8007de:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8007e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	89 04 24             	mov    %eax,(%esp)
  8007f9:	e8 82 ff ff ff       	call   800780 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800806:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800809:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80080d:	8b 45 10             	mov    0x10(%ebp),%eax
  800810:	89 44 24 08          	mov    %eax,0x8(%esp)
  800814:	8b 45 0c             	mov    0xc(%ebp),%eax
  800817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	89 04 24             	mov    %eax,(%esp)
  800821:	e8 79 fb ff ff       	call   80039f <vprintfmt>
	va_end(ap);
}
  800826:	c9                   	leave  
  800827:	c3                   	ret    
	...

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80083b:	eb 03                	jmp    800840 <strlen+0x10>
		n++;
  80083d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800840:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800844:	75 f7                	jne    80083d <strlen+0xd>
		n++;
	return n;
}
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	53                   	push   %ebx
  80084c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80084f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800852:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800857:	eb 03                	jmp    80085c <strnlen+0x14>
		n++;
  800859:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085c:	39 c1                	cmp    %eax,%ecx
  80085e:	74 06                	je     800866 <strnlen+0x1e>
  800860:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800864:	75 f3                	jne    800859 <strnlen+0x11>
		n++;
	return n;
}
  800866:	5b                   	pop    %ebx
  800867:	5d                   	pop    %ebp
  800868:	c3                   	ret    

00800869 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	53                   	push   %ebx
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800873:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800878:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80087c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80087f:	83 c2 01             	add    $0x1,%edx
  800882:	84 c9                	test   %cl,%cl
  800884:	75 f2                	jne    800878 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800886:	5b                   	pop    %ebx
  800887:	5d                   	pop    %ebp
  800888:	c3                   	ret    

00800889 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	53                   	push   %ebx
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800893:	89 1c 24             	mov    %ebx,(%esp)
  800896:	e8 95 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008a2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8008a5:	89 04 24             	mov    %eax,(%esp)
  8008a8:	e8 bc ff ff ff       	call   800869 <strcpy>
	return dst;
}
  8008ad:	89 d8                	mov    %ebx,%eax
  8008af:	83 c4 08             	add    $0x8,%esp
  8008b2:	5b                   	pop    %ebx
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	56                   	push   %esi
  8008b9:	53                   	push   %ebx
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c0:	8b 75 10             	mov    0x10(%ebp),%esi
  8008c3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c8:	eb 0f                	jmp    8008d9 <strncpy+0x24>
		*dst++ = *src;
  8008ca:	0f b6 19             	movzbl (%ecx),%ebx
  8008cd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d0:	80 39 01             	cmpb   $0x1,(%ecx)
  8008d3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d6:	83 c2 01             	add    $0x1,%edx
  8008d9:	39 f2                	cmp    %esi,%edx
  8008db:	72 ed                	jb     8008ca <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008dd:	5b                   	pop    %ebx
  8008de:	5e                   	pop    %esi
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	56                   	push   %esi
  8008e5:	53                   	push   %ebx
  8008e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ec:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ef:	89 f0                	mov    %esi,%eax
  8008f1:	85 d2                	test   %edx,%edx
  8008f3:	75 0a                	jne    8008ff <strlcpy+0x1e>
  8008f5:	eb 17                	jmp    80090e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f7:	88 18                	mov    %bl,(%eax)
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008ff:	83 ea 01             	sub    $0x1,%edx
  800902:	74 07                	je     80090b <strlcpy+0x2a>
  800904:	0f b6 19             	movzbl (%ecx),%ebx
  800907:	84 db                	test   %bl,%bl
  800909:	75 ec                	jne    8008f7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80090b:	c6 00 00             	movb   $0x0,(%eax)
  80090e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800910:	5b                   	pop    %ebx
  800911:	5e                   	pop    %esi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80091d:	eb 06                	jmp    800925 <strcmp+0x11>
		p++, q++;
  80091f:	83 c1 01             	add    $0x1,%ecx
  800922:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800925:	0f b6 01             	movzbl (%ecx),%eax
  800928:	84 c0                	test   %al,%al
  80092a:	74 04                	je     800930 <strcmp+0x1c>
  80092c:	3a 02                	cmp    (%edx),%al
  80092e:	74 ef                	je     80091f <strcmp+0xb>
  800930:	0f b6 c0             	movzbl %al,%eax
  800933:	0f b6 12             	movzbl (%edx),%edx
  800936:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	53                   	push   %ebx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800944:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800947:	eb 09                	jmp    800952 <strncmp+0x18>
		n--, p++, q++;
  800949:	83 ea 01             	sub    $0x1,%edx
  80094c:	83 c0 01             	add    $0x1,%eax
  80094f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800952:	85 d2                	test   %edx,%edx
  800954:	75 07                	jne    80095d <strncmp+0x23>
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	eb 13                	jmp    800970 <strncmp+0x36>
  80095d:	0f b6 18             	movzbl (%eax),%ebx
  800960:	84 db                	test   %bl,%bl
  800962:	74 04                	je     800968 <strncmp+0x2e>
  800964:	3a 19                	cmp    (%ecx),%bl
  800966:	74 e1                	je     800949 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 00             	movzbl (%eax),%eax
  80096b:	0f b6 11             	movzbl (%ecx),%edx
  80096e:	29 d0                	sub    %edx,%eax
}
  800970:	5b                   	pop    %ebx
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097d:	eb 07                	jmp    800986 <strchr+0x13>
		if (*s == c)
  80097f:	38 ca                	cmp    %cl,%dl
  800981:	74 0f                	je     800992 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	0f b6 10             	movzbl (%eax),%edx
  800989:	84 d2                	test   %dl,%dl
  80098b:	75 f2                	jne    80097f <strchr+0xc>
  80098d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80099e:	eb 07                	jmp    8009a7 <strfind+0x13>
		if (*s == c)
  8009a0:	38 ca                	cmp    %cl,%dl
  8009a2:	74 0a                	je     8009ae <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009a4:	83 c0 01             	add    $0x1,%eax
  8009a7:	0f b6 10             	movzbl (%eax),%edx
  8009aa:	84 d2                	test   %dl,%dl
  8009ac:	75 f2                	jne    8009a0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009ae:	5d                   	pop    %ebp
  8009af:	c3                   	ret    

008009b0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	89 1c 24             	mov    %ebx,(%esp)
  8009b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009bd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ca:	85 c9                	test   %ecx,%ecx
  8009cc:	74 30                	je     8009fe <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ce:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009d4:	75 25                	jne    8009fb <memset+0x4b>
  8009d6:	f6 c1 03             	test   $0x3,%cl
  8009d9:	75 20                	jne    8009fb <memset+0x4b>
		c &= 0xFF;
  8009db:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009de:	89 d3                	mov    %edx,%ebx
  8009e0:	c1 e3 08             	shl    $0x8,%ebx
  8009e3:	89 d6                	mov    %edx,%esi
  8009e5:	c1 e6 18             	shl    $0x18,%esi
  8009e8:	89 d0                	mov    %edx,%eax
  8009ea:	c1 e0 10             	shl    $0x10,%eax
  8009ed:	09 f0                	or     %esi,%eax
  8009ef:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  8009f1:	09 d8                	or     %ebx,%eax
  8009f3:	c1 e9 02             	shr    $0x2,%ecx
  8009f6:	fc                   	cld    
  8009f7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f9:	eb 03                	jmp    8009fe <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009fb:	fc                   	cld    
  8009fc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fe:	89 f8                	mov    %edi,%eax
  800a00:	8b 1c 24             	mov    (%esp),%ebx
  800a03:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a07:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a0b:	89 ec                	mov    %ebp,%esp
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	89 34 24             	mov    %esi,(%esp)
  800a18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800a22:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a25:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a27:	39 c6                	cmp    %eax,%esi
  800a29:	73 35                	jae    800a60 <memmove+0x51>
  800a2b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a2e:	39 d0                	cmp    %edx,%eax
  800a30:	73 2e                	jae    800a60 <memmove+0x51>
		s += n;
		d += n;
  800a32:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a34:	f6 c2 03             	test   $0x3,%dl
  800a37:	75 1b                	jne    800a54 <memmove+0x45>
  800a39:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a3f:	75 13                	jne    800a54 <memmove+0x45>
  800a41:	f6 c1 03             	test   $0x3,%cl
  800a44:	75 0e                	jne    800a54 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a46:	83 ef 04             	sub    $0x4,%edi
  800a49:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a4c:	c1 e9 02             	shr    $0x2,%ecx
  800a4f:	fd                   	std    
  800a50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a52:	eb 09                	jmp    800a5d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a54:	83 ef 01             	sub    $0x1,%edi
  800a57:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a5a:	fd                   	std    
  800a5b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a5d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a5e:	eb 20                	jmp    800a80 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a60:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a66:	75 15                	jne    800a7d <memmove+0x6e>
  800a68:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a6e:	75 0d                	jne    800a7d <memmove+0x6e>
  800a70:	f6 c1 03             	test   $0x3,%cl
  800a73:	75 08                	jne    800a7d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a75:	c1 e9 02             	shr    $0x2,%ecx
  800a78:	fc                   	cld    
  800a79:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7b:	eb 03                	jmp    800a80 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a7d:	fc                   	cld    
  800a7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a80:	8b 34 24             	mov    (%esp),%esi
  800a83:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a87:	89 ec                	mov    %ebp,%esp
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	89 04 24             	mov    %eax,(%esp)
  800aa5:	e8 65 ff ff ff       	call   800a0f <memmove>
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	57                   	push   %edi
  800ab0:	56                   	push   %esi
  800ab1:	53                   	push   %ebx
  800ab2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800abb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac0:	eb 1c                	jmp    800ade <memcmp+0x32>
		if (*s1 != *s2)
  800ac2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800ac6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800aca:	83 c2 01             	add    $0x1,%edx
  800acd:	83 e9 01             	sub    $0x1,%ecx
  800ad0:	38 d8                	cmp    %bl,%al
  800ad2:	74 0a                	je     800ade <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800ad4:	0f b6 c0             	movzbl %al,%eax
  800ad7:	0f b6 db             	movzbl %bl,%ebx
  800ada:	29 d8                	sub    %ebx,%eax
  800adc:	eb 09                	jmp    800ae7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ade:	85 c9                	test   %ecx,%ecx
  800ae0:	75 e0                	jne    800ac2 <memcmp+0x16>
  800ae2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800ae7:	5b                   	pop    %ebx
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800af5:	89 c2                	mov    %eax,%edx
  800af7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800afa:	eb 07                	jmp    800b03 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800afc:	38 08                	cmp    %cl,(%eax)
  800afe:	74 07                	je     800b07 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b00:	83 c0 01             	add    $0x1,%eax
  800b03:	39 d0                	cmp    %edx,%eax
  800b05:	72 f5                	jb     800afc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	57                   	push   %edi
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b18:	eb 03                	jmp    800b1d <strtol+0x14>
		s++;
  800b1a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1d:	0f b6 02             	movzbl (%edx),%eax
  800b20:	3c 20                	cmp    $0x20,%al
  800b22:	74 f6                	je     800b1a <strtol+0x11>
  800b24:	3c 09                	cmp    $0x9,%al
  800b26:	74 f2                	je     800b1a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b28:	3c 2b                	cmp    $0x2b,%al
  800b2a:	75 0c                	jne    800b38 <strtol+0x2f>
		s++;
  800b2c:	8d 52 01             	lea    0x1(%edx),%edx
  800b2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b36:	eb 15                	jmp    800b4d <strtol+0x44>
	else if (*s == '-')
  800b38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b3f:	3c 2d                	cmp    $0x2d,%al
  800b41:	75 0a                	jne    800b4d <strtol+0x44>
		s++, neg = 1;
  800b43:	8d 52 01             	lea    0x1(%edx),%edx
  800b46:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4d:	85 db                	test   %ebx,%ebx
  800b4f:	0f 94 c0             	sete   %al
  800b52:	74 05                	je     800b59 <strtol+0x50>
  800b54:	83 fb 10             	cmp    $0x10,%ebx
  800b57:	75 15                	jne    800b6e <strtol+0x65>
  800b59:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5c:	75 10                	jne    800b6e <strtol+0x65>
  800b5e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b62:	75 0a                	jne    800b6e <strtol+0x65>
		s += 2, base = 16;
  800b64:	83 c2 02             	add    $0x2,%edx
  800b67:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6c:	eb 13                	jmp    800b81 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b6e:	84 c0                	test   %al,%al
  800b70:	74 0f                	je     800b81 <strtol+0x78>
  800b72:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b77:	80 3a 30             	cmpb   $0x30,(%edx)
  800b7a:	75 05                	jne    800b81 <strtol+0x78>
		s++, base = 8;
  800b7c:	83 c2 01             	add    $0x1,%edx
  800b7f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
  800b86:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b88:	0f b6 0a             	movzbl (%edx),%ecx
  800b8b:	89 cf                	mov    %ecx,%edi
  800b8d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b90:	80 fb 09             	cmp    $0x9,%bl
  800b93:	77 08                	ja     800b9d <strtol+0x94>
			dig = *s - '0';
  800b95:	0f be c9             	movsbl %cl,%ecx
  800b98:	83 e9 30             	sub    $0x30,%ecx
  800b9b:	eb 1e                	jmp    800bbb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800b9d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ba0:	80 fb 19             	cmp    $0x19,%bl
  800ba3:	77 08                	ja     800bad <strtol+0xa4>
			dig = *s - 'a' + 10;
  800ba5:	0f be c9             	movsbl %cl,%ecx
  800ba8:	83 e9 57             	sub    $0x57,%ecx
  800bab:	eb 0e                	jmp    800bbb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800bad:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800bb0:	80 fb 19             	cmp    $0x19,%bl
  800bb3:	77 15                	ja     800bca <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bb5:	0f be c9             	movsbl %cl,%ecx
  800bb8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bbb:	39 f1                	cmp    %esi,%ecx
  800bbd:	7d 0b                	jge    800bca <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bbf:	83 c2 01             	add    $0x1,%edx
  800bc2:	0f af c6             	imul   %esi,%eax
  800bc5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800bc8:	eb be                	jmp    800b88 <strtol+0x7f>
  800bca:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 05                	je     800bd7 <strtol+0xce>
		*endptr = (char *) s;
  800bd2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bd5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800bd7:	89 ca                	mov    %ecx,%edx
  800bd9:	f7 da                	neg    %edx
  800bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bdf:	0f 45 c2             	cmovne %edx,%eax
}
  800be2:	83 c4 04             	add    $0x4,%esp
  800be5:	5b                   	pop    %ebx
  800be6:	5e                   	pop    %esi
  800be7:	5f                   	pop    %edi
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    
	...

00800bec <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 0c             	sub    $0xc,%esp
  800bf2:	89 1c 24             	mov    %ebx,(%esp)
  800bf5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bf9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800c02:	b8 01 00 00 00       	mov    $0x1,%eax
  800c07:	89 d1                	mov    %edx,%ecx
  800c09:	89 d3                	mov    %edx,%ebx
  800c0b:	89 d7                	mov    %edx,%edi
  800c0d:	89 d6                	mov    %edx,%esi
  800c0f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c11:	8b 1c 24             	mov    (%esp),%ebx
  800c14:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c18:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c1c:	89 ec                	mov    %ebp,%esp
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 0c             	sub    $0xc,%esp
  800c26:	89 1c 24             	mov    %ebx,(%esp)
  800c29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c2d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
  800c36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c39:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3c:	89 c3                	mov    %eax,%ebx
  800c3e:	89 c7                	mov    %eax,%edi
  800c40:	89 c6                	mov    %eax,%esi
  800c42:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c44:	8b 1c 24             	mov    (%esp),%ebx
  800c47:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c4b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c4f:	89 ec                	mov    %ebp,%esp
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	89 1c 24             	mov    %ebx,(%esp)
  800c5c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c60:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c64:	ba 00 00 00 00       	mov    $0x0,%edx
  800c69:	b8 10 00 00 00       	mov    $0x10,%eax
  800c6e:	89 d1                	mov    %edx,%ecx
  800c70:	89 d3                	mov    %edx,%ebx
  800c72:	89 d7                	mov    %edx,%edi
  800c74:	89 d6                	mov    %edx,%esi
  800c76:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800c78:	8b 1c 24             	mov    (%esp),%ebx
  800c7b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c7f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c83:	89 ec                	mov    %ebp,%esp
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 38             	sub    $0x38,%esp
  800c8d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c90:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c93:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ca0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	89 df                	mov    %ebx,%edi
  800ca8:	89 de                	mov    %ebx,%esi
  800caa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cac:	85 c0                	test   %eax,%eax
  800cae:	7e 28                	jle    800cd8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800cbb:	00 
  800cbc:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800cc3:	00 
  800cc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ccb:	00 
  800ccc:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800cd3:	e8 70 f4 ff ff       	call   800148 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800cd8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cdb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cde:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ce1:	89 ec                	mov    %ebp,%esp
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	83 ec 38             	sub    $0x38,%esp
  800ceb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cf1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d01:	8b 55 08             	mov    0x8(%ebp),%edx
  800d04:	89 df                	mov    %ebx,%edi
  800d06:	89 de                	mov    %ebx,%esi
  800d08:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d0a:	85 c0                	test   %eax,%eax
  800d0c:	7e 28                	jle    800d36 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d12:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800d19:	00 
  800d1a:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800d21:	00 
  800d22:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d29:	00 
  800d2a:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800d31:	e8 12 f4 ff ff       	call   800148 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800d36:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d39:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d3c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d3f:	89 ec                	mov    %ebp,%esp
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 38             	sub    $0x38,%esp
  800d49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d57:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	89 cb                	mov    %ecx,%ebx
  800d61:	89 cf                	mov    %ecx,%edi
  800d63:	89 ce                	mov    %ecx,%esi
  800d65:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d67:	85 c0                	test   %eax,%eax
  800d69:	7e 28                	jle    800d93 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d6f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800d76:	00 
  800d77:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800d7e:	00 
  800d7f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d86:	00 
  800d87:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800d8e:	e8 b5 f3 ff ff       	call   800148 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d93:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d96:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d99:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d9c:	89 ec                	mov    %ebp,%esp
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	89 1c 24             	mov    %ebx,(%esp)
  800da9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db1:	be 00 00 00 00       	mov    $0x0,%esi
  800db6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dbb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc9:	8b 1c 24             	mov    (%esp),%ebx
  800dcc:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dd0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dd4:	89 ec                	mov    %ebp,%esp
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 38             	sub    $0x38,%esp
  800dde:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800de4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	89 df                	mov    %ebx,%edi
  800df9:	89 de                	mov    %ebx,%esi
  800dfb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	7e 28                	jle    800e29 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e01:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e05:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e0c:	00 
  800e0d:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800e14:	00 
  800e15:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1c:	00 
  800e1d:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800e24:	e8 1f f3 ff ff       	call   800148 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e29:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e2c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e2f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e32:	89 ec                	mov    %ebp,%esp
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 38             	sub    $0x38,%esp
  800e3c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e3f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e42:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	89 df                	mov    %ebx,%edi
  800e57:	89 de                	mov    %ebx,%esi
  800e59:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7e 28                	jle    800e87 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e63:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e6a:	00 
  800e6b:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800e72:	00 
  800e73:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7a:	00 
  800e7b:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800e82:	e8 c1 f2 ff ff       	call   800148 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e87:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e8a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e8d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e90:	89 ec                	mov    %ebp,%esp
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    

00800e94 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	83 ec 38             	sub    $0x38,%esp
  800e9a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e9d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	89 de                	mov    %ebx,%esi
  800eb7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7e 28                	jle    800ee5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ec8:	00 
  800ec9:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800ed0:	00 
  800ed1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed8:	00 
  800ed9:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800ee0:	e8 63 f2 ff ff       	call   800148 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ee5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ee8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eeb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eee:	89 ec                	mov    %ebp,%esp
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 38             	sub    $0x38,%esp
  800ef8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800efb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800efe:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f06:	b8 06 00 00 00       	mov    $0x6,%eax
  800f0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	89 df                	mov    %ebx,%edi
  800f13:	89 de                	mov    %ebx,%esi
  800f15:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	7e 28                	jle    800f43 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f26:	00 
  800f27:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800f2e:	00 
  800f2f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f36:	00 
  800f37:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800f3e:	e8 05 f2 ff ff       	call   800148 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f43:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f46:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f49:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f4c:	89 ec                	mov    %ebp,%esp
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 38             	sub    $0x38,%esp
  800f56:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f59:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f5c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f64:	8b 75 18             	mov    0x18(%ebp),%esi
  800f67:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f70:	8b 55 08             	mov    0x8(%ebp),%edx
  800f73:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	7e 28                	jle    800fa1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f79:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f84:	00 
  800f85:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800f8c:	00 
  800f8d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f94:	00 
  800f95:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800f9c:	e8 a7 f1 ff ff       	call   800148 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fa1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fa7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800faa:	89 ec                	mov    %ebp,%esp
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    

00800fae <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	83 ec 38             	sub    $0x38,%esp
  800fb4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fba:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbd:	be 00 00 00 00       	mov    $0x0,%esi
  800fc2:	b8 04 00 00 00       	mov    $0x4,%eax
  800fc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd0:	89 f7                	mov    %esi,%edi
  800fd2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	7e 28                	jle    801000 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fdc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fe3:	00 
  800fe4:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800feb:	00 
  800fec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff3:	00 
  800ff4:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800ffb:	e8 48 f1 ff ff       	call   800148 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801000:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801003:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801006:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801009:	89 ec                	mov    %ebp,%esp
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 0c             	sub    $0xc,%esp
  801013:	89 1c 24             	mov    %ebx,(%esp)
  801016:	89 74 24 04          	mov    %esi,0x4(%esp)
  80101a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101e:	ba 00 00 00 00       	mov    $0x0,%edx
  801023:	b8 0b 00 00 00       	mov    $0xb,%eax
  801028:	89 d1                	mov    %edx,%ecx
  80102a:	89 d3                	mov    %edx,%ebx
  80102c:	89 d7                	mov    %edx,%edi
  80102e:	89 d6                	mov    %edx,%esi
  801030:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801032:	8b 1c 24             	mov    (%esp),%ebx
  801035:	8b 74 24 04          	mov    0x4(%esp),%esi
  801039:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80103d:	89 ec                	mov    %ebp,%esp
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 0c             	sub    $0xc,%esp
  801047:	89 1c 24             	mov    %ebx,(%esp)
  80104a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80104e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801052:	ba 00 00 00 00       	mov    $0x0,%edx
  801057:	b8 02 00 00 00       	mov    $0x2,%eax
  80105c:	89 d1                	mov    %edx,%ecx
  80105e:	89 d3                	mov    %edx,%ebx
  801060:	89 d7                	mov    %edx,%edi
  801062:	89 d6                	mov    %edx,%esi
  801064:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801066:	8b 1c 24             	mov    (%esp),%ebx
  801069:	8b 74 24 04          	mov    0x4(%esp),%esi
  80106d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801071:	89 ec                	mov    %ebp,%esp
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    

00801075 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 38             	sub    $0x38,%esp
  80107b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80107e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801081:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801084:	b9 00 00 00 00       	mov    $0x0,%ecx
  801089:	b8 03 00 00 00       	mov    $0x3,%eax
  80108e:	8b 55 08             	mov    0x8(%ebp),%edx
  801091:	89 cb                	mov    %ecx,%ebx
  801093:	89 cf                	mov    %ecx,%edi
  801095:	89 ce                	mov    %ecx,%esi
  801097:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801099:	85 c0                	test   %eax,%eax
  80109b:	7e 28                	jle    8010c5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80109d:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010a8:	00 
  8010a9:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  8010b0:	00 
  8010b1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b8:	00 
  8010b9:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  8010c0:	e8 83 f0 ff ff       	call   800148 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010c5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010c8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010cb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ce:	89 ec                	mov    %ebp,%esp
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    
	...

008010d4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  8010db:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8010e2:	75 5b                	jne    80113f <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  8010e4:	e8 58 ff ff ff       	call   801041 <sys_getenvid>
  8010e9:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  8010eb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010f2:	00 
  8010f3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8010fa:	ee 
  8010fb:	89 04 24             	mov    %eax,(%esp)
  8010fe:	e8 ab fe ff ff       	call   800fae <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  801103:	85 c0                	test   %eax,%eax
  801105:	74 28                	je     80112f <set_pgfault_handler+0x5b>
  801107:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110b:	c7 44 24 0c fa 17 80 	movl   $0x8017fa,0xc(%esp)
  801112:	00 
  801113:	c7 44 24 08 d3 17 80 	movl   $0x8017d3,0x8(%esp)
  80111a:	00 
  80111b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801122:	00 
  801123:	c7 04 24 ec 17 80 00 	movl   $0x8017ec,(%esp)
  80112a:	e8 19 f0 ff ff       	call   800148 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80112f:	c7 44 24 04 50 11 80 	movl   $0x801150,0x4(%esp)
  801136:	00 
  801137:	89 1c 24             	mov    %ebx,(%esp)
  80113a:	e8 99 fc ff ff       	call   800dd8 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	a3 08 20 80 00       	mov    %eax,0x802008
	
}
  801147:	83 c4 24             	add    $0x24,%esp
  80114a:	5b                   	pop    %ebx
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    
  80114d:	00 00                	add    %al,(%eax)
	...

00801150 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801150:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801151:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801156:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801158:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  80115b:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  80115e:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  801162:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  801166:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  801169:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  80116c:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  801170:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  801171:	83 c4 04             	add    $0x4,%esp
	popfl ;
  801174:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  801175:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801176:	c3                   	ret    
	...

00801180 <__udivdi3>:
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	57                   	push   %edi
  801184:	56                   	push   %esi
  801185:	83 ec 10             	sub    $0x10,%esp
  801188:	8b 45 14             	mov    0x14(%ebp),%eax
  80118b:	8b 55 08             	mov    0x8(%ebp),%edx
  80118e:	8b 75 10             	mov    0x10(%ebp),%esi
  801191:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801194:	85 c0                	test   %eax,%eax
  801196:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801199:	75 35                	jne    8011d0 <__udivdi3+0x50>
  80119b:	39 fe                	cmp    %edi,%esi
  80119d:	77 61                	ja     801200 <__udivdi3+0x80>
  80119f:	85 f6                	test   %esi,%esi
  8011a1:	75 0b                	jne    8011ae <__udivdi3+0x2e>
  8011a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8011a8:	31 d2                	xor    %edx,%edx
  8011aa:	f7 f6                	div    %esi
  8011ac:	89 c6                	mov    %eax,%esi
  8011ae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b1:	31 d2                	xor    %edx,%edx
  8011b3:	89 f8                	mov    %edi,%eax
  8011b5:	f7 f6                	div    %esi
  8011b7:	89 c7                	mov    %eax,%edi
  8011b9:	89 c8                	mov    %ecx,%eax
  8011bb:	f7 f6                	div    %esi
  8011bd:	89 c1                	mov    %eax,%ecx
  8011bf:	89 fa                	mov    %edi,%edx
  8011c1:	89 c8                	mov    %ecx,%eax
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    
  8011ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011d0:	39 f8                	cmp    %edi,%eax
  8011d2:	77 1c                	ja     8011f0 <__udivdi3+0x70>
  8011d4:	0f bd d0             	bsr    %eax,%edx
  8011d7:	83 f2 1f             	xor    $0x1f,%edx
  8011da:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011dd:	75 39                	jne    801218 <__udivdi3+0x98>
  8011df:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8011e2:	0f 86 a0 00 00 00    	jbe    801288 <__udivdi3+0x108>
  8011e8:	39 f8                	cmp    %edi,%eax
  8011ea:	0f 82 98 00 00 00    	jb     801288 <__udivdi3+0x108>
  8011f0:	31 ff                	xor    %edi,%edi
  8011f2:	31 c9                	xor    %ecx,%ecx
  8011f4:	89 c8                	mov    %ecx,%eax
  8011f6:	89 fa                	mov    %edi,%edx
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	5e                   	pop    %esi
  8011fc:	5f                   	pop    %edi
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    
  8011ff:	90                   	nop
  801200:	89 d1                	mov    %edx,%ecx
  801202:	89 fa                	mov    %edi,%edx
  801204:	89 c8                	mov    %ecx,%eax
  801206:	31 ff                	xor    %edi,%edi
  801208:	f7 f6                	div    %esi
  80120a:	89 c1                	mov    %eax,%ecx
  80120c:	89 fa                	mov    %edi,%edx
  80120e:	89 c8                	mov    %ecx,%eax
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	5e                   	pop    %esi
  801214:	5f                   	pop    %edi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    
  801217:	90                   	nop
  801218:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80121c:	89 f2                	mov    %esi,%edx
  80121e:	d3 e0                	shl    %cl,%eax
  801220:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801223:	b8 20 00 00 00       	mov    $0x20,%eax
  801228:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80122b:	89 c1                	mov    %eax,%ecx
  80122d:	d3 ea                	shr    %cl,%edx
  80122f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801233:	0b 55 ec             	or     -0x14(%ebp),%edx
  801236:	d3 e6                	shl    %cl,%esi
  801238:	89 c1                	mov    %eax,%ecx
  80123a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80123d:	89 fe                	mov    %edi,%esi
  80123f:	d3 ee                	shr    %cl,%esi
  801241:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801245:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124b:	d3 e7                	shl    %cl,%edi
  80124d:	89 c1                	mov    %eax,%ecx
  80124f:	d3 ea                	shr    %cl,%edx
  801251:	09 d7                	or     %edx,%edi
  801253:	89 f2                	mov    %esi,%edx
  801255:	89 f8                	mov    %edi,%eax
  801257:	f7 75 ec             	divl   -0x14(%ebp)
  80125a:	89 d6                	mov    %edx,%esi
  80125c:	89 c7                	mov    %eax,%edi
  80125e:	f7 65 e8             	mull   -0x18(%ebp)
  801261:	39 d6                	cmp    %edx,%esi
  801263:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801266:	72 30                	jb     801298 <__udivdi3+0x118>
  801268:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80126b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80126f:	d3 e2                	shl    %cl,%edx
  801271:	39 c2                	cmp    %eax,%edx
  801273:	73 05                	jae    80127a <__udivdi3+0xfa>
  801275:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801278:	74 1e                	je     801298 <__udivdi3+0x118>
  80127a:	89 f9                	mov    %edi,%ecx
  80127c:	31 ff                	xor    %edi,%edi
  80127e:	e9 71 ff ff ff       	jmp    8011f4 <__udivdi3+0x74>
  801283:	90                   	nop
  801284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801288:	31 ff                	xor    %edi,%edi
  80128a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80128f:	e9 60 ff ff ff       	jmp    8011f4 <__udivdi3+0x74>
  801294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801298:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80129b:	31 ff                	xor    %edi,%edi
  80129d:	89 c8                	mov    %ecx,%eax
  80129f:	89 fa                	mov    %edi,%edx
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	5e                   	pop    %esi
  8012a5:	5f                   	pop    %edi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    
	...

008012b0 <__umoddi3>:
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	57                   	push   %edi
  8012b4:	56                   	push   %esi
  8012b5:	83 ec 20             	sub    $0x20,%esp
  8012b8:	8b 55 14             	mov    0x14(%ebp),%edx
  8012bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012be:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012c4:	85 d2                	test   %edx,%edx
  8012c6:	89 c8                	mov    %ecx,%eax
  8012c8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012cb:	75 13                	jne    8012e0 <__umoddi3+0x30>
  8012cd:	39 f7                	cmp    %esi,%edi
  8012cf:	76 3f                	jbe    801310 <__umoddi3+0x60>
  8012d1:	89 f2                	mov    %esi,%edx
  8012d3:	f7 f7                	div    %edi
  8012d5:	89 d0                	mov    %edx,%eax
  8012d7:	31 d2                	xor    %edx,%edx
  8012d9:	83 c4 20             	add    $0x20,%esp
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
  8012e0:	39 f2                	cmp    %esi,%edx
  8012e2:	77 4c                	ja     801330 <__umoddi3+0x80>
  8012e4:	0f bd ca             	bsr    %edx,%ecx
  8012e7:	83 f1 1f             	xor    $0x1f,%ecx
  8012ea:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8012ed:	75 51                	jne    801340 <__umoddi3+0x90>
  8012ef:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8012f2:	0f 87 e0 00 00 00    	ja     8013d8 <__umoddi3+0x128>
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	29 f8                	sub    %edi,%eax
  8012fd:	19 d6                	sbb    %edx,%esi
  8012ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801305:	89 f2                	mov    %esi,%edx
  801307:	83 c4 20             	add    $0x20,%esp
  80130a:	5e                   	pop    %esi
  80130b:	5f                   	pop    %edi
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    
  80130e:	66 90                	xchg   %ax,%ax
  801310:	85 ff                	test   %edi,%edi
  801312:	75 0b                	jne    80131f <__umoddi3+0x6f>
  801314:	b8 01 00 00 00       	mov    $0x1,%eax
  801319:	31 d2                	xor    %edx,%edx
  80131b:	f7 f7                	div    %edi
  80131d:	89 c7                	mov    %eax,%edi
  80131f:	89 f0                	mov    %esi,%eax
  801321:	31 d2                	xor    %edx,%edx
  801323:	f7 f7                	div    %edi
  801325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801328:	f7 f7                	div    %edi
  80132a:	eb a9                	jmp    8012d5 <__umoddi3+0x25>
  80132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801330:	89 c8                	mov    %ecx,%eax
  801332:	89 f2                	mov    %esi,%edx
  801334:	83 c4 20             	add    $0x20,%esp
  801337:	5e                   	pop    %esi
  801338:	5f                   	pop    %edi
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    
  80133b:	90                   	nop
  80133c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801340:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801344:	d3 e2                	shl    %cl,%edx
  801346:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801349:	ba 20 00 00 00       	mov    $0x20,%edx
  80134e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801351:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801354:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801358:	89 fa                	mov    %edi,%edx
  80135a:	d3 ea                	shr    %cl,%edx
  80135c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801360:	0b 55 f4             	or     -0xc(%ebp),%edx
  801363:	d3 e7                	shl    %cl,%edi
  801365:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801369:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136c:	89 f2                	mov    %esi,%edx
  80136e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801371:	89 c7                	mov    %eax,%edi
  801373:	d3 ea                	shr    %cl,%edx
  801375:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801379:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80137c:	89 c2                	mov    %eax,%edx
  80137e:	d3 e6                	shl    %cl,%esi
  801380:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801384:	d3 ea                	shr    %cl,%edx
  801386:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80138a:	09 d6                	or     %edx,%esi
  80138c:	89 f0                	mov    %esi,%eax
  80138e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801391:	d3 e7                	shl    %cl,%edi
  801393:	89 f2                	mov    %esi,%edx
  801395:	f7 75 f4             	divl   -0xc(%ebp)
  801398:	89 d6                	mov    %edx,%esi
  80139a:	f7 65 e8             	mull   -0x18(%ebp)
  80139d:	39 d6                	cmp    %edx,%esi
  80139f:	72 2b                	jb     8013cc <__umoddi3+0x11c>
  8013a1:	39 c7                	cmp    %eax,%edi
  8013a3:	72 23                	jb     8013c8 <__umoddi3+0x118>
  8013a5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8013a9:	29 c7                	sub    %eax,%edi
  8013ab:	19 d6                	sbb    %edx,%esi
  8013ad:	89 f0                	mov    %esi,%eax
  8013af:	89 f2                	mov    %esi,%edx
  8013b1:	d3 ef                	shr    %cl,%edi
  8013b3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8013b7:	d3 e0                	shl    %cl,%eax
  8013b9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8013bd:	09 f8                	or     %edi,%eax
  8013bf:	d3 ea                	shr    %cl,%edx
  8013c1:	83 c4 20             	add    $0x20,%esp
  8013c4:	5e                   	pop    %esi
  8013c5:	5f                   	pop    %edi
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    
  8013c8:	39 d6                	cmp    %edx,%esi
  8013ca:	75 d9                	jne    8013a5 <__umoddi3+0xf5>
  8013cc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8013cf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8013d2:	eb d1                	jmp    8013a5 <__umoddi3+0xf5>
  8013d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013d8:	39 f2                	cmp    %esi,%edx
  8013da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8013e0:	0f 82 12 ff ff ff    	jb     8012f8 <__umoddi3+0x48>
  8013e6:	e9 17 ff ff ff       	jmp    801302 <__umoddi3+0x52>
