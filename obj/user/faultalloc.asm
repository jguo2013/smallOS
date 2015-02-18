
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
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
  80003a:	c7 04 24 70 00 80 00 	movl   $0x800070,(%esp)
  800041:	e8 9e 10 00 00       	call   8010e4 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  800046:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  80004d:	de 
  80004e:	c7 04 24 00 14 80 00 	movl   $0x801400,(%esp)
  800055:	e8 bb 01 00 00       	call   800215 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  80005a:	c7 44 24 04 fe bf fe 	movl   $0xcafebffe,0x4(%esp)
  800061:	ca 
  800062:	c7 04 24 00 14 80 00 	movl   $0x801400,(%esp)
  800069:	e8 a7 01 00 00       	call   800215 <cprintf>
}
  80006e:	c9                   	leave  
  80006f:	c3                   	ret    

00800070 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800070:	55                   	push   %ebp
  800071:	89 e5                	mov    %esp,%ebp
  800073:	53                   	push   %ebx
  800074:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800077:	8b 45 08             	mov    0x8(%ebp),%eax
  80007a:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80007c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800080:	c7 04 24 04 14 80 00 	movl   $0x801404,(%esp)
  800087:	e8 89 01 00 00       	call   800215 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80008c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800093:	00 
  800094:	89 d8                	mov    %ebx,%eax
  800096:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80009b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80009f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a6:	e8 13 0f 00 00       	call   800fbe <sys_page_alloc>
  8000ab:	85 c0                	test   %eax,%eax
  8000ad:	79 24                	jns    8000d3 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  8000af:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000b3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000b7:	c7 44 24 08 20 14 80 	movl   $0x801420,0x8(%esp)
  8000be:	00 
  8000bf:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  8000c6:	00 
  8000c7:	c7 04 24 0e 14 80 00 	movl   $0x80140e,(%esp)
  8000ce:	e8 89 00 00 00       	call   80015c <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000d3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000d7:	c7 44 24 08 4c 14 80 	movl   $0x80144c,0x8(%esp)
  8000de:	00 
  8000df:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000e6:	00 
  8000e7:	89 1c 24             	mov    %ebx,(%esp)
  8000ea:	e8 fd 06 00 00       	call   8007ec <snprintf>
}
  8000ef:	83 c4 24             	add    $0x24,%esp
  8000f2:	5b                   	pop    %ebx
  8000f3:	5d                   	pop    %ebp
  8000f4:	c3                   	ret    
  8000f5:	00 00                	add    %al,(%eax)
	...

008000f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	83 ec 18             	sub    $0x18,%esp
  8000fe:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800101:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800104:	8b 75 08             	mov    0x8(%ebp),%esi
  800107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80010a:	e8 42 0f 00 00       	call   801051 <sys_getenvid>
  80010f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800114:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800117:	2d 00 00 40 11       	sub    $0x11400000,%eax
  80011c:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800121:	85 f6                	test   %esi,%esi
  800123:	7e 07                	jle    80012c <libmain+0x34>
		binaryname = argv[0];
  800125:	8b 03                	mov    (%ebx),%eax
  800127:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80012c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800130:	89 34 24             	mov    %esi,(%esp)
  800133:	e8 fc fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800138:	e8 0b 00 00 00       	call   800148 <exit>
}
  80013d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800140:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800143:	89 ec                	mov    %ebp,%esp
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    
	...

00800148 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80014e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800155:	e8 2b 0f 00 00       	call   801085 <sys_env_destroy>
}
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
  800161:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800164:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800167:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  80016d:	e8 df 0e 00 00       	call   801051 <sys_getenvid>
  800172:	8b 55 0c             	mov    0xc(%ebp),%edx
  800175:	89 54 24 10          	mov    %edx,0x10(%esp)
  800179:	8b 55 08             	mov    0x8(%ebp),%edx
  80017c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800180:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800184:	89 44 24 04          	mov    %eax,0x4(%esp)
  800188:	c7 04 24 78 14 80 00 	movl   $0x801478,(%esp)
  80018f:	e8 81 00 00 00       	call   800215 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800194:	89 74 24 04          	mov    %esi,0x4(%esp)
  800198:	8b 45 10             	mov    0x10(%ebp),%eax
  80019b:	89 04 24             	mov    %eax,(%esp)
  80019e:	e8 11 00 00 00       	call   8001b4 <vcprintf>
	cprintf("\n");
  8001a3:	c7 04 24 02 14 80 00 	movl   $0x801402,(%esp)
  8001aa:	e8 66 00 00 00       	call   800215 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001af:	cc                   	int3   
  8001b0:	eb fd                	jmp    8001af <_panic+0x53>
	...

008001b4 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c4:	00 00 00 
	b.cnt = 0;
  8001c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e9:	c7 04 24 2f 02 80 00 	movl   $0x80022f,(%esp)
  8001f0:	e8 be 01 00 00       	call   8003b3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ff:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800205:	89 04 24             	mov    %eax,(%esp)
  800208:	e8 23 0a 00 00       	call   800c30 <sys_cputs>

	return b.cnt;
}
  80020d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800213:	c9                   	leave  
  800214:	c3                   	ret    

00800215 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80021b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80021e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800222:	8b 45 08             	mov    0x8(%ebp),%eax
  800225:	89 04 24             	mov    %eax,(%esp)
  800228:	e8 87 ff ff ff       	call   8001b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	53                   	push   %ebx
  800233:	83 ec 14             	sub    $0x14,%esp
  800236:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800239:	8b 03                	mov    (%ebx),%eax
  80023b:	8b 55 08             	mov    0x8(%ebp),%edx
  80023e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800242:	83 c0 01             	add    $0x1,%eax
  800245:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800247:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024c:	75 19                	jne    800267 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80024e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800255:	00 
  800256:	8d 43 08             	lea    0x8(%ebx),%eax
  800259:	89 04 24             	mov    %eax,(%esp)
  80025c:	e8 cf 09 00 00       	call   800c30 <sys_cputs>
		b->idx = 0;
  800261:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800267:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80026b:	83 c4 14             	add    $0x14,%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5d                   	pop    %ebp
  800270:	c3                   	ret    
  800271:	00 00                	add    %al,(%eax)
	...

00800274 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	57                   	push   %edi
  800278:	56                   	push   %esi
  800279:	53                   	push   %ebx
  80027a:	83 ec 4c             	sub    $0x4c,%esp
  80027d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800280:	89 d6                	mov    %edx,%esi
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80028e:	8b 45 10             	mov    0x10(%ebp),%eax
  800291:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800294:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800297:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80029a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80029f:	39 d1                	cmp    %edx,%ecx
  8002a1:	72 07                	jb     8002aa <printnum+0x36>
  8002a3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002a6:	39 d0                	cmp    %edx,%eax
  8002a8:	77 69                	ja     800313 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002aa:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002ae:	83 eb 01             	sub    $0x1,%ebx
  8002b1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b9:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8002bd:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8002c1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8002c4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002c7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002ca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002ce:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002d5:	00 
  8002d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002df:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e3:	e8 a8 0e 00 00       	call   801190 <__udivdi3>
  8002e8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002eb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002ee:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002f6:	89 04 24             	mov    %eax,(%esp)
  8002f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002fd:	89 f2                	mov    %esi,%edx
  8002ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800302:	e8 6d ff ff ff       	call   800274 <printnum>
  800307:	eb 11                	jmp    80031a <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800309:	89 74 24 04          	mov    %esi,0x4(%esp)
  80030d:	89 3c 24             	mov    %edi,(%esp)
  800310:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800313:	83 eb 01             	sub    $0x1,%ebx
  800316:	85 db                	test   %ebx,%ebx
  800318:	7f ef                	jg     800309 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80031e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800322:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800325:	89 44 24 08          	mov    %eax,0x8(%esp)
  800329:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800330:	00 
  800331:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800334:	89 14 24             	mov    %edx,(%esp)
  800337:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80033a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80033e:	e8 7d 0f 00 00       	call   8012c0 <__umoddi3>
  800343:	89 74 24 04          	mov    %esi,0x4(%esp)
  800347:	0f be 80 9b 14 80 00 	movsbl 0x80149b(%eax),%eax
  80034e:	89 04 24             	mov    %eax,(%esp)
  800351:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800354:	83 c4 4c             	add    $0x4c,%esp
  800357:	5b                   	pop    %ebx
  800358:	5e                   	pop    %esi
  800359:	5f                   	pop    %edi
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80035f:	83 fa 01             	cmp    $0x1,%edx
  800362:	7e 0e                	jle    800372 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800364:	8b 10                	mov    (%eax),%edx
  800366:	8d 4a 08             	lea    0x8(%edx),%ecx
  800369:	89 08                	mov    %ecx,(%eax)
  80036b:	8b 02                	mov    (%edx),%eax
  80036d:	8b 52 04             	mov    0x4(%edx),%edx
  800370:	eb 22                	jmp    800394 <getuint+0x38>
	else if (lflag)
  800372:	85 d2                	test   %edx,%edx
  800374:	74 10                	je     800386 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800376:	8b 10                	mov    (%eax),%edx
  800378:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037b:	89 08                	mov    %ecx,(%eax)
  80037d:	8b 02                	mov    (%edx),%eax
  80037f:	ba 00 00 00 00       	mov    $0x0,%edx
  800384:	eb 0e                	jmp    800394 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800386:	8b 10                	mov    (%eax),%edx
  800388:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038b:	89 08                	mov    %ecx,(%eax)
  80038d:	8b 02                	mov    (%edx),%eax
  80038f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80039c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a0:	8b 10                	mov    (%eax),%edx
  8003a2:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a5:	73 0a                	jae    8003b1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003aa:	88 0a                	mov    %cl,(%edx)
  8003ac:	83 c2 01             	add    $0x1,%edx
  8003af:	89 10                	mov    %edx,(%eax)
}
  8003b1:	5d                   	pop    %ebp
  8003b2:	c3                   	ret    

008003b3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	57                   	push   %edi
  8003b7:	56                   	push   %esi
  8003b8:	53                   	push   %ebx
  8003b9:	83 ec 4c             	sub    $0x4c,%esp
  8003bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8003c5:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8003cc:	eb 11                	jmp    8003df <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ce:	85 c0                	test   %eax,%eax
  8003d0:	0f 84 b6 03 00 00    	je     80078c <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8003d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003da:	89 04 24             	mov    %eax,(%esp)
  8003dd:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003df:	0f b6 03             	movzbl (%ebx),%eax
  8003e2:	83 c3 01             	add    $0x1,%ebx
  8003e5:	83 f8 25             	cmp    $0x25,%eax
  8003e8:	75 e4                	jne    8003ce <vprintfmt+0x1b>
  8003ea:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8003ee:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003f5:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8003fc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800403:	b9 00 00 00 00       	mov    $0x0,%ecx
  800408:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80040b:	eb 06                	jmp    800413 <vprintfmt+0x60>
  80040d:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800411:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800413:	0f b6 0b             	movzbl (%ebx),%ecx
  800416:	0f b6 c1             	movzbl %cl,%eax
  800419:	8d 53 01             	lea    0x1(%ebx),%edx
  80041c:	83 e9 23             	sub    $0x23,%ecx
  80041f:	80 f9 55             	cmp    $0x55,%cl
  800422:	0f 87 47 03 00 00    	ja     80076f <vprintfmt+0x3bc>
  800428:	0f b6 c9             	movzbl %cl,%ecx
  80042b:	ff 24 8d e0 15 80 00 	jmp    *0x8015e0(,%ecx,4)
  800432:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800436:	eb d9                	jmp    800411 <vprintfmt+0x5e>
  800438:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80043f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800444:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800447:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80044b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80044e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800451:	83 fb 09             	cmp    $0x9,%ebx
  800454:	77 30                	ja     800486 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800456:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800459:	eb e9                	jmp    800444 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 48 04             	lea    0x4(%eax),%ecx
  800461:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800464:	8b 00                	mov    (%eax),%eax
  800466:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800469:	eb 1e                	jmp    800489 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80046b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80046f:	b8 00 00 00 00       	mov    $0x0,%eax
  800474:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047b:	eb 94                	jmp    800411 <vprintfmt+0x5e>
  80047d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800484:	eb 8b                	jmp    800411 <vprintfmt+0x5e>
  800486:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800489:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80048d:	79 82                	jns    800411 <vprintfmt+0x5e>
  80048f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800492:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800495:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800498:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80049b:	e9 71 ff ff ff       	jmp    800411 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004a0:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004a4:	e9 68 ff ff ff       	jmp    800411 <vprintfmt+0x5e>
  8004a9:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8004af:	8d 50 04             	lea    0x4(%eax),%edx
  8004b2:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	89 04 24             	mov    %eax,(%esp)
  8004be:	ff d7                	call   *%edi
  8004c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8004c3:	e9 17 ff ff ff       	jmp    8003df <vprintfmt+0x2c>
  8004c8:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	8d 50 04             	lea    0x4(%eax),%edx
  8004d1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	89 c2                	mov    %eax,%edx
  8004d8:	c1 fa 1f             	sar    $0x1f,%edx
  8004db:	31 d0                	xor    %edx,%eax
  8004dd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004df:	83 f8 11             	cmp    $0x11,%eax
  8004e2:	7f 0b                	jg     8004ef <vprintfmt+0x13c>
  8004e4:	8b 14 85 40 17 80 00 	mov    0x801740(,%eax,4),%edx
  8004eb:	85 d2                	test   %edx,%edx
  8004ed:	75 20                	jne    80050f <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8004ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f3:	c7 44 24 08 ac 14 80 	movl   $0x8014ac,0x8(%esp)
  8004fa:	00 
  8004fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ff:	89 3c 24             	mov    %edi,(%esp)
  800502:	e8 0d 03 00 00       	call   800814 <printfmt>
  800507:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050a:	e9 d0 fe ff ff       	jmp    8003df <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80050f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800513:	c7 44 24 08 b5 14 80 	movl   $0x8014b5,0x8(%esp)
  80051a:	00 
  80051b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80051f:	89 3c 24             	mov    %edi,(%esp)
  800522:	e8 ed 02 00 00       	call   800814 <printfmt>
  800527:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80052a:	e9 b0 fe ff ff       	jmp    8003df <vprintfmt+0x2c>
  80052f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800532:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800535:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800538:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 50 04             	lea    0x4(%eax),%edx
  800541:	89 55 14             	mov    %edx,0x14(%ebp)
  800544:	8b 18                	mov    (%eax),%ebx
  800546:	85 db                	test   %ebx,%ebx
  800548:	b8 b8 14 80 00       	mov    $0x8014b8,%eax
  80054d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800550:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800554:	7e 76                	jle    8005cc <vprintfmt+0x219>
  800556:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80055a:	74 7a                	je     8005d6 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  80055c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800560:	89 1c 24             	mov    %ebx,(%esp)
  800563:	e8 f0 02 00 00       	call   800858 <strnlen>
  800568:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80056b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  80056d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800571:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800574:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800577:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800579:	eb 0f                	jmp    80058a <vprintfmt+0x1d7>
					putch(padc, putdat);
  80057b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800582:	89 04 24             	mov    %eax,(%esp)
  800585:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800587:	83 eb 01             	sub    $0x1,%ebx
  80058a:	85 db                	test   %ebx,%ebx
  80058c:	7f ed                	jg     80057b <vprintfmt+0x1c8>
  80058e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800591:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800594:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800597:	89 f7                	mov    %esi,%edi
  800599:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80059c:	eb 40                	jmp    8005de <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80059e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a2:	74 18                	je     8005bc <vprintfmt+0x209>
  8005a4:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005a7:	83 fa 5e             	cmp    $0x5e,%edx
  8005aa:	76 10                	jbe    8005bc <vprintfmt+0x209>
					putch('?', putdat);
  8005ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b0:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005b7:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005ba:	eb 0a                	jmp    8005c6 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8005bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c0:	89 04 24             	mov    %eax,(%esp)
  8005c3:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c6:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005ca:	eb 12                	jmp    8005de <vprintfmt+0x22b>
  8005cc:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005cf:	89 f7                	mov    %esi,%edi
  8005d1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005d4:	eb 08                	jmp    8005de <vprintfmt+0x22b>
  8005d6:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005d9:	89 f7                	mov    %esi,%edi
  8005db:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005de:	0f be 03             	movsbl (%ebx),%eax
  8005e1:	83 c3 01             	add    $0x1,%ebx
  8005e4:	85 c0                	test   %eax,%eax
  8005e6:	74 25                	je     80060d <vprintfmt+0x25a>
  8005e8:	85 f6                	test   %esi,%esi
  8005ea:	78 b2                	js     80059e <vprintfmt+0x1eb>
  8005ec:	83 ee 01             	sub    $0x1,%esi
  8005ef:	79 ad                	jns    80059e <vprintfmt+0x1eb>
  8005f1:	89 fe                	mov    %edi,%esi
  8005f3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005f6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005f9:	eb 1a                	jmp    800615 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ff:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800606:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800608:	83 eb 01             	sub    $0x1,%ebx
  80060b:	eb 08                	jmp    800615 <vprintfmt+0x262>
  80060d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800610:	89 fe                	mov    %edi,%esi
  800612:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800615:	85 db                	test   %ebx,%ebx
  800617:	7f e2                	jg     8005fb <vprintfmt+0x248>
  800619:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80061c:	e9 be fd ff ff       	jmp    8003df <vprintfmt+0x2c>
  800621:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800624:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7e 16                	jle    800642 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8d 50 08             	lea    0x8(%eax),%edx
  800632:	89 55 14             	mov    %edx,0x14(%ebp)
  800635:	8b 10                	mov    (%eax),%edx
  800637:	8b 48 04             	mov    0x4(%eax),%ecx
  80063a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  80063d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800640:	eb 32                	jmp    800674 <vprintfmt+0x2c1>
	else if (lflag)
  800642:	85 c9                	test   %ecx,%ecx
  800644:	74 18                	je     80065e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 50 04             	lea    0x4(%eax),%edx
  80064c:	89 55 14             	mov    %edx,0x14(%ebp)
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800654:	89 c1                	mov    %eax,%ecx
  800656:	c1 f9 1f             	sar    $0x1f,%ecx
  800659:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80065c:	eb 16                	jmp    800674 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8d 50 04             	lea    0x4(%eax),%edx
  800664:	89 55 14             	mov    %edx,0x14(%ebp)
  800667:	8b 00                	mov    (%eax),%eax
  800669:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066c:	89 c2                	mov    %eax,%edx
  80066e:	c1 fa 1f             	sar    $0x1f,%edx
  800671:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800674:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800677:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80067a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80067f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800683:	0f 89 a7 00 00 00    	jns    800730 <vprintfmt+0x37d>
				putch('-', putdat);
  800689:	89 74 24 04          	mov    %esi,0x4(%esp)
  80068d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800694:	ff d7                	call   *%edi
				num = -(long long) num;
  800696:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800699:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80069c:	f7 d9                	neg    %ecx
  80069e:	83 d3 00             	adc    $0x0,%ebx
  8006a1:	f7 db                	neg    %ebx
  8006a3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a8:	e9 83 00 00 00       	jmp    800730 <vprintfmt+0x37d>
  8006ad:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006b0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006b3:	89 ca                	mov    %ecx,%edx
  8006b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b8:	e8 9f fc ff ff       	call   80035c <getuint>
  8006bd:	89 c1                	mov    %eax,%ecx
  8006bf:	89 d3                	mov    %edx,%ebx
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8006c6:	eb 68                	jmp    800730 <vprintfmt+0x37d>
  8006c8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006cb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006ce:	89 ca                	mov    %ecx,%edx
  8006d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d3:	e8 84 fc ff ff       	call   80035c <getuint>
  8006d8:	89 c1                	mov    %eax,%ecx
  8006da:	89 d3                	mov    %edx,%ebx
  8006dc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8006e1:	eb 4d                	jmp    800730 <vprintfmt+0x37d>
  8006e3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8006e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ea:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006f1:	ff d7                	call   *%edi
			putch('x', putdat);
  8006f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006fe:	ff d7                	call   *%edi
			num = (unsigned long long)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 50 04             	lea    0x4(%eax),%edx
  800706:	89 55 14             	mov    %edx,0x14(%ebp)
  800709:	8b 08                	mov    (%eax),%ecx
  80070b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800710:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800715:	eb 19                	jmp    800730 <vprintfmt+0x37d>
  800717:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80071a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80071d:	89 ca                	mov    %ecx,%edx
  80071f:	8d 45 14             	lea    0x14(%ebp),%eax
  800722:	e8 35 fc ff ff       	call   80035c <getuint>
  800727:	89 c1                	mov    %eax,%ecx
  800729:	89 d3                	mov    %edx,%ebx
  80072b:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800730:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800734:	89 54 24 10          	mov    %edx,0x10(%esp)
  800738:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80073b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80073f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800743:	89 0c 24             	mov    %ecx,(%esp)
  800746:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80074a:	89 f2                	mov    %esi,%edx
  80074c:	89 f8                	mov    %edi,%eax
  80074e:	e8 21 fb ff ff       	call   800274 <printnum>
  800753:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800756:	e9 84 fc ff ff       	jmp    8003df <vprintfmt+0x2c>
  80075b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80075e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800762:	89 04 24             	mov    %eax,(%esp)
  800765:	ff d7                	call   *%edi
  800767:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80076a:	e9 70 fc ff ff       	jmp    8003df <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80076f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800773:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80077a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80077c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80077f:	80 38 25             	cmpb   $0x25,(%eax)
  800782:	0f 84 57 fc ff ff    	je     8003df <vprintfmt+0x2c>
  800788:	89 c3                	mov    %eax,%ebx
  80078a:	eb f0                	jmp    80077c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  80078c:	83 c4 4c             	add    $0x4c,%esp
  80078f:	5b                   	pop    %ebx
  800790:	5e                   	pop    %esi
  800791:	5f                   	pop    %edi
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 28             	sub    $0x28,%esp
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	74 04                	je     8007a8 <vsnprintf+0x14>
  8007a4:	85 d2                	test   %edx,%edx
  8007a6:	7f 07                	jg     8007af <vsnprintf+0x1b>
  8007a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ad:	eb 3b                	jmp    8007ea <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8007b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d5:	c7 04 24 96 03 80 00 	movl   $0x800396,(%esp)
  8007dc:	e8 d2 fb ff ff       	call   8003b3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ea:	c9                   	leave  
  8007eb:	c3                   	ret    

008007ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8007f2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8007f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	89 44 24 04          	mov    %eax,0x4(%esp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	89 04 24             	mov    %eax,(%esp)
  80080d:	e8 82 ff ff ff       	call   800794 <vsnprintf>
	va_end(ap);

	return rc;
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80081a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80081d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800821:	8b 45 10             	mov    0x10(%ebp),%eax
  800824:	89 44 24 08          	mov    %eax,0x8(%esp)
  800828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	89 04 24             	mov    %eax,(%esp)
  800835:	e8 79 fb ff ff       	call   8003b3 <vprintfmt>
	va_end(ap);
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    
  80083c:	00 00                	add    %al,(%eax)
	...

00800840 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	8b 55 08             	mov    0x8(%ebp),%edx
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80084b:	eb 03                	jmp    800850 <strlen+0x10>
		n++;
  80084d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800850:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800854:	75 f7                	jne    80084d <strlen+0xd>
		n++;
	return n;
}
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	53                   	push   %ebx
  80085c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80085f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800862:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800867:	eb 03                	jmp    80086c <strnlen+0x14>
		n++;
  800869:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086c:	39 c1                	cmp    %eax,%ecx
  80086e:	74 06                	je     800876 <strnlen+0x1e>
  800870:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800874:	75 f3                	jne    800869 <strnlen+0x11>
		n++;
	return n;
}
  800876:	5b                   	pop    %ebx
  800877:	5d                   	pop    %ebp
  800878:	c3                   	ret    

00800879 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	53                   	push   %ebx
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800883:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800888:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80088c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80088f:	83 c2 01             	add    $0x1,%edx
  800892:	84 c9                	test   %cl,%cl
  800894:	75 f2                	jne    800888 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800896:	5b                   	pop    %ebx
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	53                   	push   %ebx
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a3:	89 1c 24             	mov    %ebx,(%esp)
  8008a6:	e8 95 ff ff ff       	call   800840 <strlen>
	strcpy(dst + len, src);
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008b2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8008b5:	89 04 24             	mov    %eax,(%esp)
  8008b8:	e8 bc ff ff ff       	call   800879 <strcpy>
	return dst;
}
  8008bd:	89 d8                	mov    %ebx,%eax
  8008bf:	83 c4 08             	add    $0x8,%esp
  8008c2:	5b                   	pop    %ebx
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	56                   	push   %esi
  8008c9:	53                   	push   %ebx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d0:	8b 75 10             	mov    0x10(%ebp),%esi
  8008d3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d8:	eb 0f                	jmp    8008e9 <strncpy+0x24>
		*dst++ = *src;
  8008da:	0f b6 19             	movzbl (%ecx),%ebx
  8008dd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e0:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e6:	83 c2 01             	add    $0x1,%edx
  8008e9:	39 f2                	cmp    %esi,%edx
  8008eb:	72 ed                	jb     8008da <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008ed:	5b                   	pop    %ebx
  8008ee:	5e                   	pop    %esi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	56                   	push   %esi
  8008f5:	53                   	push   %ebx
  8008f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008fc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ff:	89 f0                	mov    %esi,%eax
  800901:	85 d2                	test   %edx,%edx
  800903:	75 0a                	jne    80090f <strlcpy+0x1e>
  800905:	eb 17                	jmp    80091e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800907:	88 18                	mov    %bl,(%eax)
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80090f:	83 ea 01             	sub    $0x1,%edx
  800912:	74 07                	je     80091b <strlcpy+0x2a>
  800914:	0f b6 19             	movzbl (%ecx),%ebx
  800917:	84 db                	test   %bl,%bl
  800919:	75 ec                	jne    800907 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80091b:	c6 00 00             	movb   $0x0,(%eax)
  80091e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800920:	5b                   	pop    %ebx
  800921:	5e                   	pop    %esi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80092d:	eb 06                	jmp    800935 <strcmp+0x11>
		p++, q++;
  80092f:	83 c1 01             	add    $0x1,%ecx
  800932:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800935:	0f b6 01             	movzbl (%ecx),%eax
  800938:	84 c0                	test   %al,%al
  80093a:	74 04                	je     800940 <strcmp+0x1c>
  80093c:	3a 02                	cmp    (%edx),%al
  80093e:	74 ef                	je     80092f <strcmp+0xb>
  800940:	0f b6 c0             	movzbl %al,%eax
  800943:	0f b6 12             	movzbl (%edx),%edx
  800946:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800954:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800957:	eb 09                	jmp    800962 <strncmp+0x18>
		n--, p++, q++;
  800959:	83 ea 01             	sub    $0x1,%edx
  80095c:	83 c0 01             	add    $0x1,%eax
  80095f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800962:	85 d2                	test   %edx,%edx
  800964:	75 07                	jne    80096d <strncmp+0x23>
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	eb 13                	jmp    800980 <strncmp+0x36>
  80096d:	0f b6 18             	movzbl (%eax),%ebx
  800970:	84 db                	test   %bl,%bl
  800972:	74 04                	je     800978 <strncmp+0x2e>
  800974:	3a 19                	cmp    (%ecx),%bl
  800976:	74 e1                	je     800959 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800978:	0f b6 00             	movzbl (%eax),%eax
  80097b:	0f b6 11             	movzbl (%ecx),%edx
  80097e:	29 d0                	sub    %edx,%eax
}
  800980:	5b                   	pop    %ebx
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098d:	eb 07                	jmp    800996 <strchr+0x13>
		if (*s == c)
  80098f:	38 ca                	cmp    %cl,%dl
  800991:	74 0f                	je     8009a2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800993:	83 c0 01             	add    $0x1,%eax
  800996:	0f b6 10             	movzbl (%eax),%edx
  800999:	84 d2                	test   %dl,%dl
  80099b:	75 f2                	jne    80098f <strchr+0xc>
  80099d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ae:	eb 07                	jmp    8009b7 <strfind+0x13>
		if (*s == c)
  8009b0:	38 ca                	cmp    %cl,%dl
  8009b2:	74 0a                	je     8009be <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009b4:	83 c0 01             	add    $0x1,%eax
  8009b7:	0f b6 10             	movzbl (%eax),%edx
  8009ba:	84 d2                	test   %dl,%dl
  8009bc:	75 f2                	jne    8009b0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009be:	5d                   	pop    %ebp
  8009bf:	c3                   	ret    

008009c0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	83 ec 0c             	sub    $0xc,%esp
  8009c6:	89 1c 24             	mov    %ebx,(%esp)
  8009c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009da:	85 c9                	test   %ecx,%ecx
  8009dc:	74 30                	je     800a0e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009de:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009e4:	75 25                	jne    800a0b <memset+0x4b>
  8009e6:	f6 c1 03             	test   $0x3,%cl
  8009e9:	75 20                	jne    800a0b <memset+0x4b>
		c &= 0xFF;
  8009eb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ee:	89 d3                	mov    %edx,%ebx
  8009f0:	c1 e3 08             	shl    $0x8,%ebx
  8009f3:	89 d6                	mov    %edx,%esi
  8009f5:	c1 e6 18             	shl    $0x18,%esi
  8009f8:	89 d0                	mov    %edx,%eax
  8009fa:	c1 e0 10             	shl    $0x10,%eax
  8009fd:	09 f0                	or     %esi,%eax
  8009ff:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a01:	09 d8                	or     %ebx,%eax
  800a03:	c1 e9 02             	shr    $0x2,%ecx
  800a06:	fc                   	cld    
  800a07:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a09:	eb 03                	jmp    800a0e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a0b:	fc                   	cld    
  800a0c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a0e:	89 f8                	mov    %edi,%eax
  800a10:	8b 1c 24             	mov    (%esp),%ebx
  800a13:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a17:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a1b:	89 ec                	mov    %ebp,%esp
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	89 34 24             	mov    %esi,(%esp)
  800a28:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800a32:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a35:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a37:	39 c6                	cmp    %eax,%esi
  800a39:	73 35                	jae    800a70 <memmove+0x51>
  800a3b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a3e:	39 d0                	cmp    %edx,%eax
  800a40:	73 2e                	jae    800a70 <memmove+0x51>
		s += n;
		d += n;
  800a42:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a44:	f6 c2 03             	test   $0x3,%dl
  800a47:	75 1b                	jne    800a64 <memmove+0x45>
  800a49:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4f:	75 13                	jne    800a64 <memmove+0x45>
  800a51:	f6 c1 03             	test   $0x3,%cl
  800a54:	75 0e                	jne    800a64 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a56:	83 ef 04             	sub    $0x4,%edi
  800a59:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a5c:	c1 e9 02             	shr    $0x2,%ecx
  800a5f:	fd                   	std    
  800a60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a62:	eb 09                	jmp    800a6d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a64:	83 ef 01             	sub    $0x1,%edi
  800a67:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a6a:	fd                   	std    
  800a6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a6d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a6e:	eb 20                	jmp    800a90 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a70:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a76:	75 15                	jne    800a8d <memmove+0x6e>
  800a78:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a7e:	75 0d                	jne    800a8d <memmove+0x6e>
  800a80:	f6 c1 03             	test   $0x3,%cl
  800a83:	75 08                	jne    800a8d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a85:	c1 e9 02             	shr    $0x2,%ecx
  800a88:	fc                   	cld    
  800a89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8b:	eb 03                	jmp    800a90 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a8d:	fc                   	cld    
  800a8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a90:	8b 34 24             	mov    (%esp),%esi
  800a93:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a97:	89 ec                	mov    %ebp,%esp
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	89 04 24             	mov    %eax,(%esp)
  800ab5:	e8 65 ff ff ff       	call   800a1f <memmove>
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	57                   	push   %edi
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800acb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad0:	eb 1c                	jmp    800aee <memcmp+0x32>
		if (*s1 != *s2)
  800ad2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800ad6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800ada:	83 c2 01             	add    $0x1,%edx
  800add:	83 e9 01             	sub    $0x1,%ecx
  800ae0:	38 d8                	cmp    %bl,%al
  800ae2:	74 0a                	je     800aee <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800ae4:	0f b6 c0             	movzbl %al,%eax
  800ae7:	0f b6 db             	movzbl %bl,%ebx
  800aea:	29 d8                	sub    %ebx,%eax
  800aec:	eb 09                	jmp    800af7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aee:	85 c9                	test   %ecx,%ecx
  800af0:	75 e0                	jne    800ad2 <memcmp+0x16>
  800af2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800af7:	5b                   	pop    %ebx
  800af8:	5e                   	pop    %esi
  800af9:	5f                   	pop    %edi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b05:	89 c2                	mov    %eax,%edx
  800b07:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b0a:	eb 07                	jmp    800b13 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b0c:	38 08                	cmp    %cl,(%eax)
  800b0e:	74 07                	je     800b17 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b10:	83 c0 01             	add    $0x1,%eax
  800b13:	39 d0                	cmp    %edx,%eax
  800b15:	72 f5                	jb     800b0c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	57                   	push   %edi
  800b1d:	56                   	push   %esi
  800b1e:	53                   	push   %ebx
  800b1f:	83 ec 04             	sub    $0x4,%esp
  800b22:	8b 55 08             	mov    0x8(%ebp),%edx
  800b25:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b28:	eb 03                	jmp    800b2d <strtol+0x14>
		s++;
  800b2a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b2d:	0f b6 02             	movzbl (%edx),%eax
  800b30:	3c 20                	cmp    $0x20,%al
  800b32:	74 f6                	je     800b2a <strtol+0x11>
  800b34:	3c 09                	cmp    $0x9,%al
  800b36:	74 f2                	je     800b2a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b38:	3c 2b                	cmp    $0x2b,%al
  800b3a:	75 0c                	jne    800b48 <strtol+0x2f>
		s++;
  800b3c:	8d 52 01             	lea    0x1(%edx),%edx
  800b3f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b46:	eb 15                	jmp    800b5d <strtol+0x44>
	else if (*s == '-')
  800b48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b4f:	3c 2d                	cmp    $0x2d,%al
  800b51:	75 0a                	jne    800b5d <strtol+0x44>
		s++, neg = 1;
  800b53:	8d 52 01             	lea    0x1(%edx),%edx
  800b56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	0f 94 c0             	sete   %al
  800b62:	74 05                	je     800b69 <strtol+0x50>
  800b64:	83 fb 10             	cmp    $0x10,%ebx
  800b67:	75 15                	jne    800b7e <strtol+0x65>
  800b69:	80 3a 30             	cmpb   $0x30,(%edx)
  800b6c:	75 10                	jne    800b7e <strtol+0x65>
  800b6e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b72:	75 0a                	jne    800b7e <strtol+0x65>
		s += 2, base = 16;
  800b74:	83 c2 02             	add    $0x2,%edx
  800b77:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7c:	eb 13                	jmp    800b91 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b7e:	84 c0                	test   %al,%al
  800b80:	74 0f                	je     800b91 <strtol+0x78>
  800b82:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b87:	80 3a 30             	cmpb   $0x30,(%edx)
  800b8a:	75 05                	jne    800b91 <strtol+0x78>
		s++, base = 8;
  800b8c:	83 c2 01             	add    $0x1,%edx
  800b8f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
  800b96:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b98:	0f b6 0a             	movzbl (%edx),%ecx
  800b9b:	89 cf                	mov    %ecx,%edi
  800b9d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ba0:	80 fb 09             	cmp    $0x9,%bl
  800ba3:	77 08                	ja     800bad <strtol+0x94>
			dig = *s - '0';
  800ba5:	0f be c9             	movsbl %cl,%ecx
  800ba8:	83 e9 30             	sub    $0x30,%ecx
  800bab:	eb 1e                	jmp    800bcb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800bad:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800bb0:	80 fb 19             	cmp    $0x19,%bl
  800bb3:	77 08                	ja     800bbd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800bb5:	0f be c9             	movsbl %cl,%ecx
  800bb8:	83 e9 57             	sub    $0x57,%ecx
  800bbb:	eb 0e                	jmp    800bcb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800bbd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800bc0:	80 fb 19             	cmp    $0x19,%bl
  800bc3:	77 15                	ja     800bda <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bc5:	0f be c9             	movsbl %cl,%ecx
  800bc8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bcb:	39 f1                	cmp    %esi,%ecx
  800bcd:	7d 0b                	jge    800bda <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bcf:	83 c2 01             	add    $0x1,%edx
  800bd2:	0f af c6             	imul   %esi,%eax
  800bd5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800bd8:	eb be                	jmp    800b98 <strtol+0x7f>
  800bda:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be0:	74 05                	je     800be7 <strtol+0xce>
		*endptr = (char *) s;
  800be2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800be5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800be7:	89 ca                	mov    %ecx,%edx
  800be9:	f7 da                	neg    %edx
  800beb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bef:	0f 45 c2             	cmovne %edx,%eax
}
  800bf2:	83 c4 04             	add    $0x4,%esp
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    
	...

00800bfc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 0c             	sub    $0xc,%esp
  800c02:	89 1c 24             	mov    %ebx,(%esp)
  800c05:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c09:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c12:	b8 01 00 00 00       	mov    $0x1,%eax
  800c17:	89 d1                	mov    %edx,%ecx
  800c19:	89 d3                	mov    %edx,%ebx
  800c1b:	89 d7                	mov    %edx,%edi
  800c1d:	89 d6                	mov    %edx,%esi
  800c1f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c21:	8b 1c 24             	mov    (%esp),%ebx
  800c24:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c28:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c2c:	89 ec                	mov    %ebp,%esp
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 0c             	sub    $0xc,%esp
  800c36:	89 1c 24             	mov    %ebx,(%esp)
  800c39:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c3d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c41:	b8 00 00 00 00       	mov    $0x0,%eax
  800c46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	89 c3                	mov    %eax,%ebx
  800c4e:	89 c7                	mov    %eax,%edi
  800c50:	89 c6                	mov    %eax,%esi
  800c52:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c54:	8b 1c 24             	mov    (%esp),%ebx
  800c57:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c5b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c5f:	89 ec                	mov    %ebp,%esp
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 0c             	sub    $0xc,%esp
  800c69:	89 1c 24             	mov    %ebx,(%esp)
  800c6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c70:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c74:	ba 00 00 00 00       	mov    $0x0,%edx
  800c79:	b8 10 00 00 00       	mov    $0x10,%eax
  800c7e:	89 d1                	mov    %edx,%ecx
  800c80:	89 d3                	mov    %edx,%ebx
  800c82:	89 d7                	mov    %edx,%edi
  800c84:	89 d6                	mov    %edx,%esi
  800c86:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800c88:	8b 1c 24             	mov    (%esp),%ebx
  800c8b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c8f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c93:	89 ec                	mov    %ebp,%esp
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 38             	sub    $0x38,%esp
  800c9d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ca0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ca3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cab:	b8 0f 00 00 00       	mov    $0xf,%eax
  800cb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb6:	89 df                	mov    %ebx,%edi
  800cb8:	89 de                	mov    %ebx,%esi
  800cba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cbc:	85 c0                	test   %eax,%eax
  800cbe:	7e 28                	jle    800ce8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ccb:	00 
  800ccc:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800cd3:	00 
  800cd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cdb:	00 
  800cdc:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800ce3:	e8 74 f4 ff ff       	call   80015c <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800ce8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ceb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cf1:	89 ec                	mov    %ebp,%esp
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 38             	sub    $0x38,%esp
  800cfb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cfe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d01:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d09:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	8b 55 08             	mov    0x8(%ebp),%edx
  800d14:	89 df                	mov    %ebx,%edi
  800d16:	89 de                	mov    %ebx,%esi
  800d18:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	7e 28                	jle    800d46 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d22:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800d29:	00 
  800d2a:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800d31:	00 
  800d32:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d39:	00 
  800d3a:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800d41:	e8 16 f4 ff ff       	call   80015c <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800d46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d49:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d4f:	89 ec                	mov    %ebp,%esp
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 38             	sub    $0x38,%esp
  800d59:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d67:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6f:	89 cb                	mov    %ecx,%ebx
  800d71:	89 cf                	mov    %ecx,%edi
  800d73:	89 ce                	mov    %ecx,%esi
  800d75:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7e 28                	jle    800da3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800d86:	00 
  800d87:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800d8e:	00 
  800d8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d96:	00 
  800d97:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800d9e:	e8 b9 f3 ff ff       	call   80015c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800da6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800da9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dac:	89 ec                	mov    %ebp,%esp
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	89 1c 24             	mov    %ebx,(%esp)
  800db9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dbd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc1:	be 00 00 00 00       	mov    $0x0,%esi
  800dc6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dcb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dd9:	8b 1c 24             	mov    (%esp),%ebx
  800ddc:	8b 74 24 04          	mov    0x4(%esp),%esi
  800de0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800de4:	89 ec                	mov    %ebp,%esp
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 38             	sub    $0x38,%esp
  800dee:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	89 df                	mov    %ebx,%edi
  800e09:	89 de                	mov    %ebx,%esi
  800e0b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	7e 28                	jle    800e39 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e11:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e15:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e1c:	00 
  800e1d:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800e24:	00 
  800e25:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2c:	00 
  800e2d:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800e34:	e8 23 f3 ff ff       	call   80015c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e39:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e3c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e3f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e42:	89 ec                	mov    %ebp,%esp
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 38             	sub    $0x38,%esp
  800e4c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e4f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e52:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	89 df                	mov    %ebx,%edi
  800e67:	89 de                	mov    %ebx,%esi
  800e69:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	7e 28                	jle    800e97 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e73:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e7a:	00 
  800e7b:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800e82:	00 
  800e83:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8a:	00 
  800e8b:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800e92:	e8 c5 f2 ff ff       	call   80015c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e97:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e9a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e9d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea0:	89 ec                	mov    %ebp,%esp
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 38             	sub    $0x38,%esp
  800eaa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ead:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ebd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec3:	89 df                	mov    %ebx,%edi
  800ec5:	89 de                	mov    %ebx,%esi
  800ec7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	7e 28                	jle    800ef5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ed8:	00 
  800ed9:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800ee0:	00 
  800ee1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee8:	00 
  800ee9:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800ef0:	e8 67 f2 ff ff       	call   80015c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ef5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800efb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800efe:	89 ec                	mov    %ebp,%esp
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    

00800f02 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 38             	sub    $0x38,%esp
  800f08:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f0e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f16:	b8 06 00 00 00       	mov    $0x6,%eax
  800f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	89 df                	mov    %ebx,%edi
  800f23:	89 de                	mov    %ebx,%esi
  800f25:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f27:	85 c0                	test   %eax,%eax
  800f29:	7e 28                	jle    800f53 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f36:	00 
  800f37:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f46:	00 
  800f47:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800f4e:	e8 09 f2 ff ff       	call   80015c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f53:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f56:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f59:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5c:	89 ec                	mov    %ebp,%esp
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	83 ec 38             	sub    $0x38,%esp
  800f66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f74:	8b 75 18             	mov    0x18(%ebp),%esi
  800f77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	7e 28                	jle    800fb1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f89:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f94:	00 
  800f95:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800f9c:	00 
  800f9d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa4:	00 
  800fa5:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  800fac:	e8 ab f1 ff ff       	call   80015c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fb1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fba:	89 ec                	mov    %ebp,%esp
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 38             	sub    $0x38,%esp
  800fc4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fca:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcd:	be 00 00 00 00       	mov    $0x0,%esi
  800fd2:	b8 04 00 00 00       	mov    $0x4,%eax
  800fd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	89 f7                	mov    %esi,%edi
  800fe2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	7e 28                	jle    801010 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fec:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801003:	00 
  801004:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  80100b:	e8 4c f1 ff ff       	call   80015c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801010:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801013:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801016:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801019:	89 ec                	mov    %ebp,%esp
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 0c             	sub    $0xc,%esp
  801023:	89 1c 24             	mov    %ebx,(%esp)
  801026:	89 74 24 04          	mov    %esi,0x4(%esp)
  80102a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102e:	ba 00 00 00 00       	mov    $0x0,%edx
  801033:	b8 0b 00 00 00       	mov    $0xb,%eax
  801038:	89 d1                	mov    %edx,%ecx
  80103a:	89 d3                	mov    %edx,%ebx
  80103c:	89 d7                	mov    %edx,%edi
  80103e:	89 d6                	mov    %edx,%esi
  801040:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801042:	8b 1c 24             	mov    (%esp),%ebx
  801045:	8b 74 24 04          	mov    0x4(%esp),%esi
  801049:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80104d:	89 ec                	mov    %ebp,%esp
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    

00801051 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	89 1c 24             	mov    %ebx,(%esp)
  80105a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80105e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801062:	ba 00 00 00 00       	mov    $0x0,%edx
  801067:	b8 02 00 00 00       	mov    $0x2,%eax
  80106c:	89 d1                	mov    %edx,%ecx
  80106e:	89 d3                	mov    %edx,%ebx
  801070:	89 d7                	mov    %edx,%edi
  801072:	89 d6                	mov    %edx,%esi
  801074:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801076:	8b 1c 24             	mov    (%esp),%ebx
  801079:	8b 74 24 04          	mov    0x4(%esp),%esi
  80107d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801081:	89 ec                	mov    %ebp,%esp
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	83 ec 38             	sub    $0x38,%esp
  80108b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80108e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801091:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801094:	b9 00 00 00 00       	mov    $0x0,%ecx
  801099:	b8 03 00 00 00       	mov    $0x3,%eax
  80109e:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a1:	89 cb                	mov    %ecx,%ebx
  8010a3:	89 cf                	mov    %ecx,%edi
  8010a5:	89 ce                	mov    %ecx,%esi
  8010a7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	7e 28                	jle    8010d5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010b8:	00 
  8010b9:	c7 44 24 08 a8 17 80 	movl   $0x8017a8,0x8(%esp)
  8010c0:	00 
  8010c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c8:	00 
  8010c9:	c7 04 24 c5 17 80 00 	movl   $0x8017c5,(%esp)
  8010d0:	e8 87 f0 ff ff       	call   80015c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010d5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010db:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010de:	89 ec                	mov    %ebp,%esp
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    
	...

008010e4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	53                   	push   %ebx
  8010e8:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  8010eb:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8010f2:	75 5b                	jne    80114f <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  8010f4:	e8 58 ff ff ff       	call   801051 <sys_getenvid>
  8010f9:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  8010fb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801102:	00 
  801103:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80110a:	ee 
  80110b:	89 04 24             	mov    %eax,(%esp)
  80110e:	e8 ab fe ff ff       	call   800fbe <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  801113:	85 c0                	test   %eax,%eax
  801115:	74 28                	je     80113f <set_pgfault_handler+0x5b>
  801117:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111b:	c7 44 24 0c fa 17 80 	movl   $0x8017fa,0xc(%esp)
  801122:	00 
  801123:	c7 44 24 08 d3 17 80 	movl   $0x8017d3,0x8(%esp)
  80112a:	00 
  80112b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801132:	00 
  801133:	c7 04 24 ec 17 80 00 	movl   $0x8017ec,(%esp)
  80113a:	e8 1d f0 ff ff       	call   80015c <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80113f:	c7 44 24 04 60 11 80 	movl   $0x801160,0x4(%esp)
  801146:	00 
  801147:	89 1c 24             	mov    %ebx,(%esp)
  80114a:	e8 99 fc ff ff       	call   800de8 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	a3 08 20 80 00       	mov    %eax,0x802008
	
}
  801157:	83 c4 24             	add    $0x24,%esp
  80115a:	5b                   	pop    %ebx
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    
  80115d:	00 00                	add    %al,(%eax)
	...

00801160 <_pgfault_upcall>:
  801160:	54                   	push   %esp
  801161:	a1 08 20 80 00       	mov    0x802008,%eax
  801166:	ff d0                	call   *%eax
  801168:	83 c4 04             	add    $0x4,%esp
  80116b:	83 c4 08             	add    $0x8,%esp
  80116e:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  801172:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801176:	89 59 fc             	mov    %ebx,-0x4(%ecx)
  801179:	83 e9 04             	sub    $0x4,%ecx
  80117c:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  801180:	61                   	popa   
  801181:	83 c4 04             	add    $0x4,%esp
  801184:	9d                   	popf   
  801185:	5c                   	pop    %esp
  801186:	c3                   	ret    
	...

00801190 <__udivdi3>:
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	57                   	push   %edi
  801194:	56                   	push   %esi
  801195:	83 ec 10             	sub    $0x10,%esp
  801198:	8b 45 14             	mov    0x14(%ebp),%eax
  80119b:	8b 55 08             	mov    0x8(%ebp),%edx
  80119e:	8b 75 10             	mov    0x10(%ebp),%esi
  8011a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8011a9:	75 35                	jne    8011e0 <__udivdi3+0x50>
  8011ab:	39 fe                	cmp    %edi,%esi
  8011ad:	77 61                	ja     801210 <__udivdi3+0x80>
  8011af:	85 f6                	test   %esi,%esi
  8011b1:	75 0b                	jne    8011be <__udivdi3+0x2e>
  8011b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8011b8:	31 d2                	xor    %edx,%edx
  8011ba:	f7 f6                	div    %esi
  8011bc:	89 c6                	mov    %eax,%esi
  8011be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c1:	31 d2                	xor    %edx,%edx
  8011c3:	89 f8                	mov    %edi,%eax
  8011c5:	f7 f6                	div    %esi
  8011c7:	89 c7                	mov    %eax,%edi
  8011c9:	89 c8                	mov    %ecx,%eax
  8011cb:	f7 f6                	div    %esi
  8011cd:	89 c1                	mov    %eax,%ecx
  8011cf:	89 fa                	mov    %edi,%edx
  8011d1:	89 c8                	mov    %ecx,%eax
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    
  8011da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011e0:	39 f8                	cmp    %edi,%eax
  8011e2:	77 1c                	ja     801200 <__udivdi3+0x70>
  8011e4:	0f bd d0             	bsr    %eax,%edx
  8011e7:	83 f2 1f             	xor    $0x1f,%edx
  8011ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011ed:	75 39                	jne    801228 <__udivdi3+0x98>
  8011ef:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8011f2:	0f 86 a0 00 00 00    	jbe    801298 <__udivdi3+0x108>
  8011f8:	39 f8                	cmp    %edi,%eax
  8011fa:	0f 82 98 00 00 00    	jb     801298 <__udivdi3+0x108>
  801200:	31 ff                	xor    %edi,%edi
  801202:	31 c9                	xor    %ecx,%ecx
  801204:	89 c8                	mov    %ecx,%eax
  801206:	89 fa                	mov    %edi,%edx
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	5e                   	pop    %esi
  80120c:	5f                   	pop    %edi
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    
  80120f:	90                   	nop
  801210:	89 d1                	mov    %edx,%ecx
  801212:	89 fa                	mov    %edi,%edx
  801214:	89 c8                	mov    %ecx,%eax
  801216:	31 ff                	xor    %edi,%edi
  801218:	f7 f6                	div    %esi
  80121a:	89 c1                	mov    %eax,%ecx
  80121c:	89 fa                	mov    %edi,%edx
  80121e:	89 c8                	mov    %ecx,%eax
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	5e                   	pop    %esi
  801224:	5f                   	pop    %edi
  801225:	5d                   	pop    %ebp
  801226:	c3                   	ret    
  801227:	90                   	nop
  801228:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80122c:	89 f2                	mov    %esi,%edx
  80122e:	d3 e0                	shl    %cl,%eax
  801230:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801233:	b8 20 00 00 00       	mov    $0x20,%eax
  801238:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80123b:	89 c1                	mov    %eax,%ecx
  80123d:	d3 ea                	shr    %cl,%edx
  80123f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801243:	0b 55 ec             	or     -0x14(%ebp),%edx
  801246:	d3 e6                	shl    %cl,%esi
  801248:	89 c1                	mov    %eax,%ecx
  80124a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80124d:	89 fe                	mov    %edi,%esi
  80124f:	d3 ee                	shr    %cl,%esi
  801251:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801255:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801258:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80125b:	d3 e7                	shl    %cl,%edi
  80125d:	89 c1                	mov    %eax,%ecx
  80125f:	d3 ea                	shr    %cl,%edx
  801261:	09 d7                	or     %edx,%edi
  801263:	89 f2                	mov    %esi,%edx
  801265:	89 f8                	mov    %edi,%eax
  801267:	f7 75 ec             	divl   -0x14(%ebp)
  80126a:	89 d6                	mov    %edx,%esi
  80126c:	89 c7                	mov    %eax,%edi
  80126e:	f7 65 e8             	mull   -0x18(%ebp)
  801271:	39 d6                	cmp    %edx,%esi
  801273:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801276:	72 30                	jb     8012a8 <__udivdi3+0x118>
  801278:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80127f:	d3 e2                	shl    %cl,%edx
  801281:	39 c2                	cmp    %eax,%edx
  801283:	73 05                	jae    80128a <__udivdi3+0xfa>
  801285:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801288:	74 1e                	je     8012a8 <__udivdi3+0x118>
  80128a:	89 f9                	mov    %edi,%ecx
  80128c:	31 ff                	xor    %edi,%edi
  80128e:	e9 71 ff ff ff       	jmp    801204 <__udivdi3+0x74>
  801293:	90                   	nop
  801294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801298:	31 ff                	xor    %edi,%edi
  80129a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80129f:	e9 60 ff ff ff       	jmp    801204 <__udivdi3+0x74>
  8012a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012a8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8012ab:	31 ff                	xor    %edi,%edi
  8012ad:	89 c8                	mov    %ecx,%eax
  8012af:	89 fa                	mov    %edi,%edx
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	5e                   	pop    %esi
  8012b5:	5f                   	pop    %edi
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    
	...

008012c0 <__umoddi3>:
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	57                   	push   %edi
  8012c4:	56                   	push   %esi
  8012c5:	83 ec 20             	sub    $0x20,%esp
  8012c8:	8b 55 14             	mov    0x14(%ebp),%edx
  8012cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ce:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012d4:	85 d2                	test   %edx,%edx
  8012d6:	89 c8                	mov    %ecx,%eax
  8012d8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012db:	75 13                	jne    8012f0 <__umoddi3+0x30>
  8012dd:	39 f7                	cmp    %esi,%edi
  8012df:	76 3f                	jbe    801320 <__umoddi3+0x60>
  8012e1:	89 f2                	mov    %esi,%edx
  8012e3:	f7 f7                	div    %edi
  8012e5:	89 d0                	mov    %edx,%eax
  8012e7:	31 d2                	xor    %edx,%edx
  8012e9:	83 c4 20             	add    $0x20,%esp
  8012ec:	5e                   	pop    %esi
  8012ed:	5f                   	pop    %edi
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    
  8012f0:	39 f2                	cmp    %esi,%edx
  8012f2:	77 4c                	ja     801340 <__umoddi3+0x80>
  8012f4:	0f bd ca             	bsr    %edx,%ecx
  8012f7:	83 f1 1f             	xor    $0x1f,%ecx
  8012fa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8012fd:	75 51                	jne    801350 <__umoddi3+0x90>
  8012ff:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801302:	0f 87 e0 00 00 00    	ja     8013e8 <__umoddi3+0x128>
  801308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130b:	29 f8                	sub    %edi,%eax
  80130d:	19 d6                	sbb    %edx,%esi
  80130f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801315:	89 f2                	mov    %esi,%edx
  801317:	83 c4 20             	add    $0x20,%esp
  80131a:	5e                   	pop    %esi
  80131b:	5f                   	pop    %edi
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    
  80131e:	66 90                	xchg   %ax,%ax
  801320:	85 ff                	test   %edi,%edi
  801322:	75 0b                	jne    80132f <__umoddi3+0x6f>
  801324:	b8 01 00 00 00       	mov    $0x1,%eax
  801329:	31 d2                	xor    %edx,%edx
  80132b:	f7 f7                	div    %edi
  80132d:	89 c7                	mov    %eax,%edi
  80132f:	89 f0                	mov    %esi,%eax
  801331:	31 d2                	xor    %edx,%edx
  801333:	f7 f7                	div    %edi
  801335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801338:	f7 f7                	div    %edi
  80133a:	eb a9                	jmp    8012e5 <__umoddi3+0x25>
  80133c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801340:	89 c8                	mov    %ecx,%eax
  801342:	89 f2                	mov    %esi,%edx
  801344:	83 c4 20             	add    $0x20,%esp
  801347:	5e                   	pop    %esi
  801348:	5f                   	pop    %edi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    
  80134b:	90                   	nop
  80134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801350:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801354:	d3 e2                	shl    %cl,%edx
  801356:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801359:	ba 20 00 00 00       	mov    $0x20,%edx
  80135e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801361:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801364:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801368:	89 fa                	mov    %edi,%edx
  80136a:	d3 ea                	shr    %cl,%edx
  80136c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801370:	0b 55 f4             	or     -0xc(%ebp),%edx
  801373:	d3 e7                	shl    %cl,%edi
  801375:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801379:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80137c:	89 f2                	mov    %esi,%edx
  80137e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801381:	89 c7                	mov    %eax,%edi
  801383:	d3 ea                	shr    %cl,%edx
  801385:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801389:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80138c:	89 c2                	mov    %eax,%edx
  80138e:	d3 e6                	shl    %cl,%esi
  801390:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801394:	d3 ea                	shr    %cl,%edx
  801396:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80139a:	09 d6                	or     %edx,%esi
  80139c:	89 f0                	mov    %esi,%eax
  80139e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8013a1:	d3 e7                	shl    %cl,%edi
  8013a3:	89 f2                	mov    %esi,%edx
  8013a5:	f7 75 f4             	divl   -0xc(%ebp)
  8013a8:	89 d6                	mov    %edx,%esi
  8013aa:	f7 65 e8             	mull   -0x18(%ebp)
  8013ad:	39 d6                	cmp    %edx,%esi
  8013af:	72 2b                	jb     8013dc <__umoddi3+0x11c>
  8013b1:	39 c7                	cmp    %eax,%edi
  8013b3:	72 23                	jb     8013d8 <__umoddi3+0x118>
  8013b5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8013b9:	29 c7                	sub    %eax,%edi
  8013bb:	19 d6                	sbb    %edx,%esi
  8013bd:	89 f0                	mov    %esi,%eax
  8013bf:	89 f2                	mov    %esi,%edx
  8013c1:	d3 ef                	shr    %cl,%edi
  8013c3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8013c7:	d3 e0                	shl    %cl,%eax
  8013c9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8013cd:	09 f8                	or     %edi,%eax
  8013cf:	d3 ea                	shr    %cl,%edx
  8013d1:	83 c4 20             	add    $0x20,%esp
  8013d4:	5e                   	pop    %esi
  8013d5:	5f                   	pop    %edi
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    
  8013d8:	39 d6                	cmp    %edx,%esi
  8013da:	75 d9                	jne    8013b5 <__umoddi3+0xf5>
  8013dc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8013df:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8013e2:	eb d1                	jmp    8013b5 <__umoddi3+0xf5>
  8013e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013e8:	39 f2                	cmp    %esi,%edx
  8013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8013f0:	0f 82 12 ff ff ff    	jb     801308 <__umoddi3+0x48>
  8013f6:	e9 17 ff ff ff       	jmp    801312 <__umoddi3+0x52>
