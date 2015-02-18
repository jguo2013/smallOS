
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 d3 00 00 00       	call   800104 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  80003a:	c7 04 24 80 13 80 00 	movl   $0x801380,(%esp)
  800041:	e8 db 01 00 00       	call   800221 <cprintf>
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)		
  80004b:	ba 20 20 80 00       	mov    $0x802020,%edx
  800050:	83 3c 82 00          	cmpl   $0x0,(%edx,%eax,4)
  800054:	74 20                	je     800076 <umain+0x42>
			panic("bigarray[%d] isn't cleared!\n", i);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 fb 13 80 	movl   $0x8013fb,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 18 14 80 00 	movl   $0x801418,(%esp)
  800071:	e8 f2 00 00 00       	call   800168 <_panic>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  800076:	83 c0 01             	add    $0x1,%eax
  800079:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80007e:	75 d0                	jne    800050 <umain+0x1c>
  800080:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)		
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
  800085:	ba 20 20 80 00       	mov    $0x802020,%edx
  80008a:	89 04 82             	mov    %eax,(%edx,%eax,4)

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)		
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80008d:	83 c0 01             	add    $0x1,%eax
  800090:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800095:	75 f3                	jne    80008a <umain+0x56>
  800097:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != i)
  80009c:	ba 20 20 80 00       	mov    $0x802020,%edx
  8000a1:	39 04 82             	cmp    %eax,(%edx,%eax,4)
  8000a4:	74 20                	je     8000c6 <umain+0x92>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000aa:	c7 44 24 08 a0 13 80 	movl   $0x8013a0,0x8(%esp)
  8000b1:	00 
  8000b2:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  8000b9:	00 
  8000ba:	c7 04 24 18 14 80 00 	movl   $0x801418,(%esp)
  8000c1:	e8 a2 00 00 00       	call   800168 <_panic>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)		
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000c6:	83 c0 01             	add    $0x1,%eax
  8000c9:	3d 00 00 10 00       	cmp    $0x100000,%eax
  8000ce:	75 d1                	jne    8000a1 <umain+0x6d>
		if (bigarray[i] != i)
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000d0:	c7 04 24 c8 13 80 00 	movl   $0x8013c8,(%esp)
  8000d7:	e8 45 01 00 00       	call   800221 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  8000dc:	c7 05 20 30 c0 00 00 	movl   $0x0,0xc03020
  8000e3:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000e6:	c7 44 24 08 27 14 80 	movl   $0x801427,0x8(%esp)
  8000ed:	00 
  8000ee:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8000f5:	00 
  8000f6:	c7 04 24 18 14 80 00 	movl   $0x801418,(%esp)
  8000fd:	e8 66 00 00 00       	call   800168 <_panic>
	...

00800104 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 18             	sub    $0x18,%esp
  80010a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80010d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800110:	8b 75 08             	mov    0x8(%ebp),%esi
  800113:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800116:	e8 46 0f 00 00       	call   801061 <sys_getenvid>
  80011b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800120:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800123:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800128:	a3 20 20 c0 00       	mov    %eax,0xc02020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012d:	85 f6                	test   %esi,%esi
  80012f:	7e 07                	jle    800138 <libmain+0x34>
		binaryname = argv[0];
  800131:	8b 03                	mov    (%ebx),%eax
  800133:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800138:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80013c:	89 34 24             	mov    %esi,(%esp)
  80013f:	e8 f0 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800144:	e8 0b 00 00 00       	call   800154 <exit>
}
  800149:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80014c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80014f:	89 ec                	mov    %ebp,%esp
  800151:	5d                   	pop    %ebp
  800152:	c3                   	ret    
	...

00800154 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80015a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800161:	e8 2f 0f 00 00       	call   801095 <sys_env_destroy>
}
  800166:	c9                   	leave  
  800167:	c3                   	ret    

00800168 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
  80016d:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800170:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800173:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  800179:	e8 e3 0e 00 00       	call   801061 <sys_getenvid>
  80017e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800181:	89 54 24 10          	mov    %edx,0x10(%esp)
  800185:	8b 55 08             	mov    0x8(%ebp),%edx
  800188:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80018c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800190:	89 44 24 04          	mov    %eax,0x4(%esp)
  800194:	c7 04 24 48 14 80 00 	movl   $0x801448,(%esp)
  80019b:	e8 81 00 00 00       	call   800221 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a7:	89 04 24             	mov    %eax,(%esp)
  8001aa:	e8 11 00 00 00       	call   8001c0 <vcprintf>
	cprintf("\n");
  8001af:	c7 04 24 16 14 80 00 	movl   $0x801416,(%esp)
  8001b6:	e8 66 00 00 00       	call   800221 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001bb:	cc                   	int3   
  8001bc:	eb fd                	jmp    8001bb <_panic+0x53>
	...

008001c0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d0:	00 00 00 
	b.cnt = 0;
  8001d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001da:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f5:	c7 04 24 3b 02 80 00 	movl   $0x80023b,(%esp)
  8001fc:	e8 be 01 00 00       	call   8003bf <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800201:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800207:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800211:	89 04 24             	mov    %eax,(%esp)
  800214:	e8 27 0a 00 00       	call   800c40 <sys_cputs>

	return b.cnt;
}
  800219:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800227:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80022a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 04 24             	mov    %eax,(%esp)
  800234:	e8 87 ff ff ff       	call   8001c0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800239:	c9                   	leave  
  80023a:	c3                   	ret    

0080023b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	53                   	push   %ebx
  80023f:	83 ec 14             	sub    $0x14,%esp
  800242:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800245:	8b 03                	mov    (%ebx),%eax
  800247:	8b 55 08             	mov    0x8(%ebp),%edx
  80024a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80024e:	83 c0 01             	add    $0x1,%eax
  800251:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800253:	3d ff 00 00 00       	cmp    $0xff,%eax
  800258:	75 19                	jne    800273 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80025a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800261:	00 
  800262:	8d 43 08             	lea    0x8(%ebx),%eax
  800265:	89 04 24             	mov    %eax,(%esp)
  800268:	e8 d3 09 00 00       	call   800c40 <sys_cputs>
		b->idx = 0;
  80026d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800273:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800277:	83 c4 14             	add    $0x14,%esp
  80027a:	5b                   	pop    %ebx
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    
  80027d:	00 00                	add    %al,(%eax)
	...

00800280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	57                   	push   %edi
  800284:	56                   	push   %esi
  800285:	53                   	push   %ebx
  800286:	83 ec 4c             	sub    $0x4c,%esp
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028c:	89 d6                	mov    %edx,%esi
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800294:	8b 55 0c             	mov    0xc(%ebp),%edx
  800297:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80029a:	8b 45 10             	mov    0x10(%ebp),%eax
  80029d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002a0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ab:	39 d1                	cmp    %edx,%ecx
  8002ad:	72 07                	jb     8002b6 <printnum+0x36>
  8002af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b2:	39 d0                	cmp    %edx,%eax
  8002b4:	77 69                	ja     80031f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b6:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002ba:	83 eb 01             	sub    $0x1,%ebx
  8002bd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8002c9:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8002cd:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8002d0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002d3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002d6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002e1:	00 
  8002e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002ef:	e8 0c 0e 00 00       	call   801100 <__udivdi3>
  8002f4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002f7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002fa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002fe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800302:	89 04 24             	mov    %eax,(%esp)
  800305:	89 54 24 04          	mov    %edx,0x4(%esp)
  800309:	89 f2                	mov    %esi,%edx
  80030b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80030e:	e8 6d ff ff ff       	call   800280 <printnum>
  800313:	eb 11                	jmp    800326 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800315:	89 74 24 04          	mov    %esi,0x4(%esp)
  800319:	89 3c 24             	mov    %edi,(%esp)
  80031c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80031f:	83 eb 01             	sub    $0x1,%ebx
  800322:	85 db                	test   %ebx,%ebx
  800324:	7f ef                	jg     800315 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800326:	89 74 24 04          	mov    %esi,0x4(%esp)
  80032a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80032e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800331:	89 44 24 08          	mov    %eax,0x8(%esp)
  800335:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80033c:	00 
  80033d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800340:	89 14 24             	mov    %edx,(%esp)
  800343:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800346:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80034a:	e8 e1 0e 00 00       	call   801230 <__umoddi3>
  80034f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800353:	0f be 80 6b 14 80 00 	movsbl 0x80146b(%eax),%eax
  80035a:	89 04 24             	mov    %eax,(%esp)
  80035d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800360:	83 c4 4c             	add    $0x4c,%esp
  800363:	5b                   	pop    %ebx
  800364:	5e                   	pop    %esi
  800365:	5f                   	pop    %edi
  800366:	5d                   	pop    %ebp
  800367:	c3                   	ret    

00800368 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80036b:	83 fa 01             	cmp    $0x1,%edx
  80036e:	7e 0e                	jle    80037e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800370:	8b 10                	mov    (%eax),%edx
  800372:	8d 4a 08             	lea    0x8(%edx),%ecx
  800375:	89 08                	mov    %ecx,(%eax)
  800377:	8b 02                	mov    (%edx),%eax
  800379:	8b 52 04             	mov    0x4(%edx),%edx
  80037c:	eb 22                	jmp    8003a0 <getuint+0x38>
	else if (lflag)
  80037e:	85 d2                	test   %edx,%edx
  800380:	74 10                	je     800392 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800382:	8b 10                	mov    (%eax),%edx
  800384:	8d 4a 04             	lea    0x4(%edx),%ecx
  800387:	89 08                	mov    %ecx,(%eax)
  800389:	8b 02                	mov    (%edx),%eax
  80038b:	ba 00 00 00 00       	mov    $0x0,%edx
  800390:	eb 0e                	jmp    8003a0 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800392:	8b 10                	mov    (%eax),%edx
  800394:	8d 4a 04             	lea    0x4(%edx),%ecx
  800397:	89 08                	mov    %ecx,(%eax)
  800399:	8b 02                	mov    (%edx),%eax
  80039b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003a0:	5d                   	pop    %ebp
  8003a1:	c3                   	ret    

008003a2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ac:	8b 10                	mov    (%eax),%edx
  8003ae:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b1:	73 0a                	jae    8003bd <sprintputch+0x1b>
		*b->buf++ = ch;
  8003b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003b6:	88 0a                	mov    %cl,(%edx)
  8003b8:	83 c2 01             	add    $0x1,%edx
  8003bb:	89 10                	mov    %edx,(%eax)
}
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	57                   	push   %edi
  8003c3:	56                   	push   %esi
  8003c4:	53                   	push   %ebx
  8003c5:	83 ec 4c             	sub    $0x4c,%esp
  8003c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8003d1:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8003d8:	eb 11                	jmp    8003eb <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003da:	85 c0                	test   %eax,%eax
  8003dc:	0f 84 b6 03 00 00    	je     800798 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8003e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003e6:	89 04 24             	mov    %eax,(%esp)
  8003e9:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003eb:	0f b6 03             	movzbl (%ebx),%eax
  8003ee:	83 c3 01             	add    $0x1,%ebx
  8003f1:	83 f8 25             	cmp    $0x25,%eax
  8003f4:	75 e4                	jne    8003da <vprintfmt+0x1b>
  8003f6:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8003fa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800401:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800408:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80040f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800414:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800417:	eb 06                	jmp    80041f <vprintfmt+0x60>
  800419:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  80041d:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041f:	0f b6 0b             	movzbl (%ebx),%ecx
  800422:	0f b6 c1             	movzbl %cl,%eax
  800425:	8d 53 01             	lea    0x1(%ebx),%edx
  800428:	83 e9 23             	sub    $0x23,%ecx
  80042b:	80 f9 55             	cmp    $0x55,%cl
  80042e:	0f 87 47 03 00 00    	ja     80077b <vprintfmt+0x3bc>
  800434:	0f b6 c9             	movzbl %cl,%ecx
  800437:	ff 24 8d c0 15 80 00 	jmp    *0x8015c0(,%ecx,4)
  80043e:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800442:	eb d9                	jmp    80041d <vprintfmt+0x5e>
  800444:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80044b:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800450:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800453:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800457:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80045a:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80045d:	83 fb 09             	cmp    $0x9,%ebx
  800460:	77 30                	ja     800492 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800462:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800465:	eb e9                	jmp    800450 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	8d 48 04             	lea    0x4(%eax),%ecx
  80046d:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800475:	eb 1e                	jmp    800495 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800477:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80047b:	b8 00 00 00 00       	mov    $0x0,%eax
  800480:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800487:	eb 94                	jmp    80041d <vprintfmt+0x5e>
  800489:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800490:	eb 8b                	jmp    80041d <vprintfmt+0x5e>
  800492:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800495:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800499:	79 82                	jns    80041d <vprintfmt+0x5e>
  80049b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80049e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004a4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004a7:	e9 71 ff ff ff       	jmp    80041d <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004ac:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004b0:	e9 68 ff ff ff       	jmp    80041d <vprintfmt+0x5e>
  8004b5:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bb:	8d 50 04             	lea    0x4(%eax),%edx
  8004be:	89 55 14             	mov    %edx,0x14(%ebp)
  8004c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	89 04 24             	mov    %eax,(%esp)
  8004ca:	ff d7                	call   *%edi
  8004cc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8004cf:	e9 17 ff ff ff       	jmp    8003eb <vprintfmt+0x2c>
  8004d4:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004da:	8d 50 04             	lea    0x4(%eax),%edx
  8004dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	c1 fa 1f             	sar    $0x1f,%edx
  8004e7:	31 d0                	xor    %edx,%eax
  8004e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004eb:	83 f8 11             	cmp    $0x11,%eax
  8004ee:	7f 0b                	jg     8004fb <vprintfmt+0x13c>
  8004f0:	8b 14 85 20 17 80 00 	mov    0x801720(,%eax,4),%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	75 20                	jne    80051b <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8004fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ff:	c7 44 24 08 7c 14 80 	movl   $0x80147c,0x8(%esp)
  800506:	00 
  800507:	89 74 24 04          	mov    %esi,0x4(%esp)
  80050b:	89 3c 24             	mov    %edi,(%esp)
  80050e:	e8 0d 03 00 00       	call   800820 <printfmt>
  800513:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800516:	e9 d0 fe ff ff       	jmp    8003eb <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80051b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80051f:	c7 44 24 08 85 14 80 	movl   $0x801485,0x8(%esp)
  800526:	00 
  800527:	89 74 24 04          	mov    %esi,0x4(%esp)
  80052b:	89 3c 24             	mov    %edi,(%esp)
  80052e:	e8 ed 02 00 00       	call   800820 <printfmt>
  800533:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800536:	e9 b0 fe ff ff       	jmp    8003eb <vprintfmt+0x2c>
  80053b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80053e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800544:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 50 04             	lea    0x4(%eax),%edx
  80054d:	89 55 14             	mov    %edx,0x14(%ebp)
  800550:	8b 18                	mov    (%eax),%ebx
  800552:	85 db                	test   %ebx,%ebx
  800554:	b8 88 14 80 00       	mov    $0x801488,%eax
  800559:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  80055c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800560:	7e 76                	jle    8005d8 <vprintfmt+0x219>
  800562:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800566:	74 7a                	je     8005e2 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800568:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80056c:	89 1c 24             	mov    %ebx,(%esp)
  80056f:	e8 f4 02 00 00       	call   800868 <strnlen>
  800574:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800577:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800579:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  80057d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800580:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800583:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800585:	eb 0f                	jmp    800596 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800587:	89 74 24 04          	mov    %esi,0x4(%esp)
  80058b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058e:	89 04 24             	mov    %eax,(%esp)
  800591:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	83 eb 01             	sub    $0x1,%ebx
  800596:	85 db                	test   %ebx,%ebx
  800598:	7f ed                	jg     800587 <vprintfmt+0x1c8>
  80059a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80059d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005a0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005a3:	89 f7                	mov    %esi,%edi
  8005a5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005a8:	eb 40                	jmp    8005ea <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ae:	74 18                	je     8005c8 <vprintfmt+0x209>
  8005b0:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005b3:	83 fa 5e             	cmp    $0x5e,%edx
  8005b6:	76 10                	jbe    8005c8 <vprintfmt+0x209>
					putch('?', putdat);
  8005b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005c3:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005c6:	eb 0a                	jmp    8005d2 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8005c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005cc:	89 04 24             	mov    %eax,(%esp)
  8005cf:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005d2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005d6:	eb 12                	jmp    8005ea <vprintfmt+0x22b>
  8005d8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005db:	89 f7                	mov    %esi,%edi
  8005dd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005e0:	eb 08                	jmp    8005ea <vprintfmt+0x22b>
  8005e2:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005e5:	89 f7                	mov    %esi,%edi
  8005e7:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005ea:	0f be 03             	movsbl (%ebx),%eax
  8005ed:	83 c3 01             	add    $0x1,%ebx
  8005f0:	85 c0                	test   %eax,%eax
  8005f2:	74 25                	je     800619 <vprintfmt+0x25a>
  8005f4:	85 f6                	test   %esi,%esi
  8005f6:	78 b2                	js     8005aa <vprintfmt+0x1eb>
  8005f8:	83 ee 01             	sub    $0x1,%esi
  8005fb:	79 ad                	jns    8005aa <vprintfmt+0x1eb>
  8005fd:	89 fe                	mov    %edi,%esi
  8005ff:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800602:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800605:	eb 1a                	jmp    800621 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800607:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800612:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800614:	83 eb 01             	sub    $0x1,%ebx
  800617:	eb 08                	jmp    800621 <vprintfmt+0x262>
  800619:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80061c:	89 fe                	mov    %edi,%esi
  80061e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800621:	85 db                	test   %ebx,%ebx
  800623:	7f e2                	jg     800607 <vprintfmt+0x248>
  800625:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800628:	e9 be fd ff ff       	jmp    8003eb <vprintfmt+0x2c>
  80062d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800630:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800633:	83 f9 01             	cmp    $0x1,%ecx
  800636:	7e 16                	jle    80064e <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 50 08             	lea    0x8(%eax),%edx
  80063e:	89 55 14             	mov    %edx,0x14(%ebp)
  800641:	8b 10                	mov    (%eax),%edx
  800643:	8b 48 04             	mov    0x4(%eax),%ecx
  800646:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800649:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80064c:	eb 32                	jmp    800680 <vprintfmt+0x2c1>
	else if (lflag)
  80064e:	85 c9                	test   %ecx,%ecx
  800650:	74 18                	je     80066a <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8d 50 04             	lea    0x4(%eax),%edx
  800658:	89 55 14             	mov    %edx,0x14(%ebp)
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800660:	89 c1                	mov    %eax,%ecx
  800662:	c1 f9 1f             	sar    $0x1f,%ecx
  800665:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800668:	eb 16                	jmp    800680 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 50 04             	lea    0x4(%eax),%edx
  800670:	89 55 14             	mov    %edx,0x14(%ebp)
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800678:	89 c2                	mov    %eax,%edx
  80067a:	c1 fa 1f             	sar    $0x1f,%edx
  80067d:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800680:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800683:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800686:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80068b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80068f:	0f 89 a7 00 00 00    	jns    80073c <vprintfmt+0x37d>
				putch('-', putdat);
  800695:	89 74 24 04          	mov    %esi,0x4(%esp)
  800699:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006a0:	ff d7                	call   *%edi
				num = -(long long) num;
  8006a2:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006a5:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006a8:	f7 d9                	neg    %ecx
  8006aa:	83 d3 00             	adc    $0x0,%ebx
  8006ad:	f7 db                	neg    %ebx
  8006af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b4:	e9 83 00 00 00       	jmp    80073c <vprintfmt+0x37d>
  8006b9:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006bc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006bf:	89 ca                	mov    %ecx,%edx
  8006c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c4:	e8 9f fc ff ff       	call   800368 <getuint>
  8006c9:	89 c1                	mov    %eax,%ecx
  8006cb:	89 d3                	mov    %edx,%ebx
  8006cd:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8006d2:	eb 68                	jmp    80073c <vprintfmt+0x37d>
  8006d4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006d7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006da:	89 ca                	mov    %ecx,%edx
  8006dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8006df:	e8 84 fc ff ff       	call   800368 <getuint>
  8006e4:	89 c1                	mov    %eax,%ecx
  8006e6:	89 d3                	mov    %edx,%ebx
  8006e8:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8006ed:	eb 4d                	jmp    80073c <vprintfmt+0x37d>
  8006ef:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8006f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006fd:	ff d7                	call   *%edi
			putch('x', putdat);
  8006ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  800703:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80070a:	ff d7                	call   *%edi
			num = (unsigned long long)
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8d 50 04             	lea    0x4(%eax),%edx
  800712:	89 55 14             	mov    %edx,0x14(%ebp)
  800715:	8b 08                	mov    (%eax),%ecx
  800717:	bb 00 00 00 00       	mov    $0x0,%ebx
  80071c:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800721:	eb 19                	jmp    80073c <vprintfmt+0x37d>
  800723:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800726:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800729:	89 ca                	mov    %ecx,%edx
  80072b:	8d 45 14             	lea    0x14(%ebp),%eax
  80072e:	e8 35 fc ff ff       	call   800368 <getuint>
  800733:	89 c1                	mov    %eax,%ecx
  800735:	89 d3                	mov    %edx,%ebx
  800737:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80073c:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800740:	89 54 24 10          	mov    %edx,0x10(%esp)
  800744:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800747:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80074b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80074f:	89 0c 24             	mov    %ecx,(%esp)
  800752:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800756:	89 f2                	mov    %esi,%edx
  800758:	89 f8                	mov    %edi,%eax
  80075a:	e8 21 fb ff ff       	call   800280 <printnum>
  80075f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800762:	e9 84 fc ff ff       	jmp    8003eb <vprintfmt+0x2c>
  800767:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80076a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80076e:	89 04 24             	mov    %eax,(%esp)
  800771:	ff d7                	call   *%edi
  800773:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800776:	e9 70 fc ff ff       	jmp    8003eb <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80077b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80077f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800786:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800788:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80078b:	80 38 25             	cmpb   $0x25,(%eax)
  80078e:	0f 84 57 fc ff ff    	je     8003eb <vprintfmt+0x2c>
  800794:	89 c3                	mov    %eax,%ebx
  800796:	eb f0                	jmp    800788 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800798:	83 c4 4c             	add    $0x4c,%esp
  80079b:	5b                   	pop    %ebx
  80079c:	5e                   	pop    %esi
  80079d:	5f                   	pop    %edi
  80079e:	5d                   	pop    %ebp
  80079f:	c3                   	ret    

008007a0 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 28             	sub    $0x28,%esp
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	74 04                	je     8007b4 <vsnprintf+0x14>
  8007b0:	85 d2                	test   %edx,%edx
  8007b2:	7f 07                	jg     8007bb <vsnprintf+0x1b>
  8007b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b9:	eb 3b                	jmp    8007f6 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007be:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007da:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e1:	c7 04 24 a2 03 80 00 	movl   $0x8003a2,(%esp)
  8007e8:	e8 d2 fb ff ff       	call   8003bf <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8007fe:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800801:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800805:	8b 45 10             	mov    0x10(%ebp),%eax
  800808:	89 44 24 08          	mov    %eax,0x8(%esp)
  80080c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	89 04 24             	mov    %eax,(%esp)
  800819:	e8 82 ff ff ff       	call   8007a0 <vsnprintf>
	va_end(ap);

	return rc;
}
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800826:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800829:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	89 44 24 08          	mov    %eax,0x8(%esp)
  800834:	8b 45 0c             	mov    0xc(%ebp),%eax
  800837:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	89 04 24             	mov    %eax,(%esp)
  800841:	e8 79 fb ff ff       	call   8003bf <vprintfmt>
	va_end(ap);
}
  800846:	c9                   	leave  
  800847:	c3                   	ret    
	...

00800850 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	8b 55 08             	mov    0x8(%ebp),%edx
  800856:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80085b:	eb 03                	jmp    800860 <strlen+0x10>
		n++;
  80085d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800860:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800864:	75 f7                	jne    80085d <strlen+0xd>
		n++;
	return n;
}
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	53                   	push   %ebx
  80086c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80086f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800872:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800877:	eb 03                	jmp    80087c <strnlen+0x14>
		n++;
  800879:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087c:	39 c1                	cmp    %eax,%ecx
  80087e:	74 06                	je     800886 <strnlen+0x1e>
  800880:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800884:	75 f3                	jne    800879 <strnlen+0x11>
		n++;
	return n;
}
  800886:	5b                   	pop    %ebx
  800887:	5d                   	pop    %ebp
  800888:	c3                   	ret    

00800889 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	53                   	push   %ebx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800898:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80089c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80089f:	83 c2 01             	add    $0x1,%edx
  8008a2:	84 c9                	test   %cl,%cl
  8008a4:	75 f2                	jne    800898 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008a6:	5b                   	pop    %ebx
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	53                   	push   %ebx
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b3:	89 1c 24             	mov    %ebx,(%esp)
  8008b6:	e8 95 ff ff ff       	call   800850 <strlen>
	strcpy(dst + len, src);
  8008bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008be:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008c2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8008c5:	89 04 24             	mov    %eax,(%esp)
  8008c8:	e8 bc ff ff ff       	call   800889 <strcpy>
	return dst;
}
  8008cd:	89 d8                	mov    %ebx,%eax
  8008cf:	83 c4 08             	add    $0x8,%esp
  8008d2:	5b                   	pop    %ebx
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	56                   	push   %esi
  8008d9:	53                   	push   %ebx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e0:	8b 75 10             	mov    0x10(%ebp),%esi
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e8:	eb 0f                	jmp    8008f9 <strncpy+0x24>
		*dst++ = *src;
  8008ea:	0f b6 19             	movzbl (%ecx),%ebx
  8008ed:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008f0:	80 39 01             	cmpb   $0x1,(%ecx)
  8008f3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f6:	83 c2 01             	add    $0x1,%edx
  8008f9:	39 f2                	cmp    %esi,%edx
  8008fb:	72 ed                	jb     8008ea <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008fd:	5b                   	pop    %ebx
  8008fe:	5e                   	pop    %esi
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	56                   	push   %esi
  800905:	53                   	push   %ebx
  800906:	8b 75 08             	mov    0x8(%ebp),%esi
  800909:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80090f:	89 f0                	mov    %esi,%eax
  800911:	85 d2                	test   %edx,%edx
  800913:	75 0a                	jne    80091f <strlcpy+0x1e>
  800915:	eb 17                	jmp    80092e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800917:	88 18                	mov    %bl,(%eax)
  800919:	83 c0 01             	add    $0x1,%eax
  80091c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80091f:	83 ea 01             	sub    $0x1,%edx
  800922:	74 07                	je     80092b <strlcpy+0x2a>
  800924:	0f b6 19             	movzbl (%ecx),%ebx
  800927:	84 db                	test   %bl,%bl
  800929:	75 ec                	jne    800917 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80092b:	c6 00 00             	movb   $0x0,(%eax)
  80092e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800930:	5b                   	pop    %ebx
  800931:	5e                   	pop    %esi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80093d:	eb 06                	jmp    800945 <strcmp+0x11>
		p++, q++;
  80093f:	83 c1 01             	add    $0x1,%ecx
  800942:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800945:	0f b6 01             	movzbl (%ecx),%eax
  800948:	84 c0                	test   %al,%al
  80094a:	74 04                	je     800950 <strcmp+0x1c>
  80094c:	3a 02                	cmp    (%edx),%al
  80094e:	74 ef                	je     80093f <strcmp+0xb>
  800950:	0f b6 c0             	movzbl %al,%eax
  800953:	0f b6 12             	movzbl (%edx),%edx
  800956:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800964:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800967:	eb 09                	jmp    800972 <strncmp+0x18>
		n--, p++, q++;
  800969:	83 ea 01             	sub    $0x1,%edx
  80096c:	83 c0 01             	add    $0x1,%eax
  80096f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800972:	85 d2                	test   %edx,%edx
  800974:	75 07                	jne    80097d <strncmp+0x23>
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
  80097b:	eb 13                	jmp    800990 <strncmp+0x36>
  80097d:	0f b6 18             	movzbl (%eax),%ebx
  800980:	84 db                	test   %bl,%bl
  800982:	74 04                	je     800988 <strncmp+0x2e>
  800984:	3a 19                	cmp    (%ecx),%bl
  800986:	74 e1                	je     800969 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800988:	0f b6 00             	movzbl (%eax),%eax
  80098b:	0f b6 11             	movzbl (%ecx),%edx
  80098e:	29 d0                	sub    %edx,%eax
}
  800990:	5b                   	pop    %ebx
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80099d:	eb 07                	jmp    8009a6 <strchr+0x13>
		if (*s == c)
  80099f:	38 ca                	cmp    %cl,%dl
  8009a1:	74 0f                	je     8009b2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009a3:	83 c0 01             	add    $0x1,%eax
  8009a6:	0f b6 10             	movzbl (%eax),%edx
  8009a9:	84 d2                	test   %dl,%dl
  8009ab:	75 f2                	jne    80099f <strchr+0xc>
  8009ad:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009be:	eb 07                	jmp    8009c7 <strfind+0x13>
		if (*s == c)
  8009c0:	38 ca                	cmp    %cl,%dl
  8009c2:	74 0a                	je     8009ce <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009c4:	83 c0 01             	add    $0x1,%eax
  8009c7:	0f b6 10             	movzbl (%eax),%edx
  8009ca:	84 d2                	test   %dl,%dl
  8009cc:	75 f2                	jne    8009c0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009ce:	5d                   	pop    %ebp
  8009cf:	c3                   	ret    

008009d0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 0c             	sub    $0xc,%esp
  8009d6:	89 1c 24             	mov    %ebx,(%esp)
  8009d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009dd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ea:	85 c9                	test   %ecx,%ecx
  8009ec:	74 30                	je     800a1e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ee:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009f4:	75 25                	jne    800a1b <memset+0x4b>
  8009f6:	f6 c1 03             	test   $0x3,%cl
  8009f9:	75 20                	jne    800a1b <memset+0x4b>
		c &= 0xFF;
  8009fb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009fe:	89 d3                	mov    %edx,%ebx
  800a00:	c1 e3 08             	shl    $0x8,%ebx
  800a03:	89 d6                	mov    %edx,%esi
  800a05:	c1 e6 18             	shl    $0x18,%esi
  800a08:	89 d0                	mov    %edx,%eax
  800a0a:	c1 e0 10             	shl    $0x10,%eax
  800a0d:	09 f0                	or     %esi,%eax
  800a0f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a11:	09 d8                	or     %ebx,%eax
  800a13:	c1 e9 02             	shr    $0x2,%ecx
  800a16:	fc                   	cld    
  800a17:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a19:	eb 03                	jmp    800a1e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a1b:	fc                   	cld    
  800a1c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a1e:	89 f8                	mov    %edi,%eax
  800a20:	8b 1c 24             	mov    (%esp),%ebx
  800a23:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a27:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a2b:	89 ec                	mov    %ebp,%esp
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	89 34 24             	mov    %esi,(%esp)
  800a38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800a42:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a45:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a47:	39 c6                	cmp    %eax,%esi
  800a49:	73 35                	jae    800a80 <memmove+0x51>
  800a4b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a4e:	39 d0                	cmp    %edx,%eax
  800a50:	73 2e                	jae    800a80 <memmove+0x51>
		s += n;
		d += n;
  800a52:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a54:	f6 c2 03             	test   $0x3,%dl
  800a57:	75 1b                	jne    800a74 <memmove+0x45>
  800a59:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a5f:	75 13                	jne    800a74 <memmove+0x45>
  800a61:	f6 c1 03             	test   $0x3,%cl
  800a64:	75 0e                	jne    800a74 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a66:	83 ef 04             	sub    $0x4,%edi
  800a69:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a6c:	c1 e9 02             	shr    $0x2,%ecx
  800a6f:	fd                   	std    
  800a70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a72:	eb 09                	jmp    800a7d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a74:	83 ef 01             	sub    $0x1,%edi
  800a77:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a7a:	fd                   	std    
  800a7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a7d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a7e:	eb 20                	jmp    800aa0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a80:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a86:	75 15                	jne    800a9d <memmove+0x6e>
  800a88:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a8e:	75 0d                	jne    800a9d <memmove+0x6e>
  800a90:	f6 c1 03             	test   $0x3,%cl
  800a93:	75 08                	jne    800a9d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a95:	c1 e9 02             	shr    $0x2,%ecx
  800a98:	fc                   	cld    
  800a99:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9b:	eb 03                	jmp    800aa0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a9d:	fc                   	cld    
  800a9e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa0:	8b 34 24             	mov    (%esp),%esi
  800aa3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800aa7:	89 ec                	mov    %ebp,%esp
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	89 04 24             	mov    %eax,(%esp)
  800ac5:	e8 65 ff ff ff       	call   800a2f <memmove>
}
  800aca:	c9                   	leave  
  800acb:	c3                   	ret    

00800acc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	57                   	push   %edi
  800ad0:	56                   	push   %esi
  800ad1:	53                   	push   %ebx
  800ad2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae0:	eb 1c                	jmp    800afe <memcmp+0x32>
		if (*s1 != *s2)
  800ae2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800ae6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800aea:	83 c2 01             	add    $0x1,%edx
  800aed:	83 e9 01             	sub    $0x1,%ecx
  800af0:	38 d8                	cmp    %bl,%al
  800af2:	74 0a                	je     800afe <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800af4:	0f b6 c0             	movzbl %al,%eax
  800af7:	0f b6 db             	movzbl %bl,%ebx
  800afa:	29 d8                	sub    %ebx,%eax
  800afc:	eb 09                	jmp    800b07 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afe:	85 c9                	test   %ecx,%ecx
  800b00:	75 e0                	jne    800ae2 <memcmp+0x16>
  800b02:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b07:	5b                   	pop    %ebx
  800b08:	5e                   	pop    %esi
  800b09:	5f                   	pop    %edi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b15:	89 c2                	mov    %eax,%edx
  800b17:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b1a:	eb 07                	jmp    800b23 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b1c:	38 08                	cmp    %cl,(%eax)
  800b1e:	74 07                	je     800b27 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	39 d0                	cmp    %edx,%eax
  800b25:	72 f5                	jb     800b1c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	57                   	push   %edi
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
  800b2f:	83 ec 04             	sub    $0x4,%esp
  800b32:	8b 55 08             	mov    0x8(%ebp),%edx
  800b35:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b38:	eb 03                	jmp    800b3d <strtol+0x14>
		s++;
  800b3a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b3d:	0f b6 02             	movzbl (%edx),%eax
  800b40:	3c 20                	cmp    $0x20,%al
  800b42:	74 f6                	je     800b3a <strtol+0x11>
  800b44:	3c 09                	cmp    $0x9,%al
  800b46:	74 f2                	je     800b3a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b48:	3c 2b                	cmp    $0x2b,%al
  800b4a:	75 0c                	jne    800b58 <strtol+0x2f>
		s++;
  800b4c:	8d 52 01             	lea    0x1(%edx),%edx
  800b4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b56:	eb 15                	jmp    800b6d <strtol+0x44>
	else if (*s == '-')
  800b58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b5f:	3c 2d                	cmp    $0x2d,%al
  800b61:	75 0a                	jne    800b6d <strtol+0x44>
		s++, neg = 1;
  800b63:	8d 52 01             	lea    0x1(%edx),%edx
  800b66:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6d:	85 db                	test   %ebx,%ebx
  800b6f:	0f 94 c0             	sete   %al
  800b72:	74 05                	je     800b79 <strtol+0x50>
  800b74:	83 fb 10             	cmp    $0x10,%ebx
  800b77:	75 15                	jne    800b8e <strtol+0x65>
  800b79:	80 3a 30             	cmpb   $0x30,(%edx)
  800b7c:	75 10                	jne    800b8e <strtol+0x65>
  800b7e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b82:	75 0a                	jne    800b8e <strtol+0x65>
		s += 2, base = 16;
  800b84:	83 c2 02             	add    $0x2,%edx
  800b87:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8c:	eb 13                	jmp    800ba1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b8e:	84 c0                	test   %al,%al
  800b90:	74 0f                	je     800ba1 <strtol+0x78>
  800b92:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b97:	80 3a 30             	cmpb   $0x30,(%edx)
  800b9a:	75 05                	jne    800ba1 <strtol+0x78>
		s++, base = 8;
  800b9c:	83 c2 01             	add    $0x1,%edx
  800b9f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ba1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ba8:	0f b6 0a             	movzbl (%edx),%ecx
  800bab:	89 cf                	mov    %ecx,%edi
  800bad:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bb0:	80 fb 09             	cmp    $0x9,%bl
  800bb3:	77 08                	ja     800bbd <strtol+0x94>
			dig = *s - '0';
  800bb5:	0f be c9             	movsbl %cl,%ecx
  800bb8:	83 e9 30             	sub    $0x30,%ecx
  800bbb:	eb 1e                	jmp    800bdb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800bbd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800bc0:	80 fb 19             	cmp    $0x19,%bl
  800bc3:	77 08                	ja     800bcd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800bc5:	0f be c9             	movsbl %cl,%ecx
  800bc8:	83 e9 57             	sub    $0x57,%ecx
  800bcb:	eb 0e                	jmp    800bdb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800bcd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800bd0:	80 fb 19             	cmp    $0x19,%bl
  800bd3:	77 15                	ja     800bea <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bd5:	0f be c9             	movsbl %cl,%ecx
  800bd8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bdb:	39 f1                	cmp    %esi,%ecx
  800bdd:	7d 0b                	jge    800bea <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bdf:	83 c2 01             	add    $0x1,%edx
  800be2:	0f af c6             	imul   %esi,%eax
  800be5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800be8:	eb be                	jmp    800ba8 <strtol+0x7f>
  800bea:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800bec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf0:	74 05                	je     800bf7 <strtol+0xce>
		*endptr = (char *) s;
  800bf2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bf5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800bf7:	89 ca                	mov    %ecx,%edx
  800bf9:	f7 da                	neg    %edx
  800bfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bff:	0f 45 c2             	cmovne %edx,%eax
}
  800c02:	83 c4 04             	add    $0x4,%esp
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5f                   	pop    %edi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    
	...

00800c0c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	83 ec 0c             	sub    $0xc,%esp
  800c12:	89 1c 24             	mov    %ebx,(%esp)
  800c15:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c19:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c22:	b8 01 00 00 00       	mov    $0x1,%eax
  800c27:	89 d1                	mov    %edx,%ecx
  800c29:	89 d3                	mov    %edx,%ebx
  800c2b:	89 d7                	mov    %edx,%edi
  800c2d:	89 d6                	mov    %edx,%esi
  800c2f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c31:	8b 1c 24             	mov    (%esp),%ebx
  800c34:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c38:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c3c:	89 ec                	mov    %ebp,%esp
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 0c             	sub    $0xc,%esp
  800c46:	89 1c 24             	mov    %ebx,(%esp)
  800c49:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	89 c3                	mov    %eax,%ebx
  800c5e:	89 c7                	mov    %eax,%edi
  800c60:	89 c6                	mov    %eax,%esi
  800c62:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c64:	8b 1c 24             	mov    (%esp),%ebx
  800c67:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c6b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c6f:	89 ec                	mov    %ebp,%esp
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 0c             	sub    $0xc,%esp
  800c79:	89 1c 24             	mov    %ebx,(%esp)
  800c7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c80:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c84:	ba 00 00 00 00       	mov    $0x0,%edx
  800c89:	b8 10 00 00 00       	mov    $0x10,%eax
  800c8e:	89 d1                	mov    %edx,%ecx
  800c90:	89 d3                	mov    %edx,%ebx
  800c92:	89 d7                	mov    %edx,%edi
  800c94:	89 d6                	mov    %edx,%esi
  800c96:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800c98:	8b 1c 24             	mov    (%esp),%ebx
  800c9b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c9f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ca3:	89 ec                	mov    %ebp,%esp
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 38             	sub    $0x38,%esp
  800cad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cb0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cb3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800cc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc6:	89 df                	mov    %ebx,%edi
  800cc8:	89 de                	mov    %ebx,%esi
  800cca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ccc:	85 c0                	test   %eax,%eax
  800cce:	7e 28                	jle    800cf8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cd4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800cdb:	00 
  800cdc:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  800ce3:	00 
  800ce4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ceb:	00 
  800cec:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  800cf3:	e8 70 f4 ff ff       	call   800168 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800cf8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cfb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cfe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d01:	89 ec                	mov    %ebp,%esp
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 38             	sub    $0x38,%esp
  800d0b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d0e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d11:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d19:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	89 de                	mov    %ebx,%esi
  800d28:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	7e 28                	jle    800d56 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d32:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800d39:	00 
  800d3a:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  800d41:	00 
  800d42:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d49:	00 
  800d4a:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  800d51:	e8 12 f4 ff ff       	call   800168 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800d56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d59:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d5c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d5f:	89 ec                	mov    %ebp,%esp
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 38             	sub    $0x38,%esp
  800d69:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d6f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d77:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	89 cb                	mov    %ecx,%ebx
  800d81:	89 cf                	mov    %ecx,%edi
  800d83:	89 ce                	mov    %ecx,%esi
  800d85:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7e 28                	jle    800db3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d8f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800d96:	00 
  800d97:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  800d9e:	00 
  800d9f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da6:	00 
  800da7:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  800dae:	e8 b5 f3 ff ff       	call   800168 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800db3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800db6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800db9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dbc:	89 ec                	mov    %ebp,%esp
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	89 1c 24             	mov    %ebx,(%esp)
  800dc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dcd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd1:	be 00 00 00 00       	mov    $0x0,%esi
  800dd6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ddb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de4:	8b 55 08             	mov    0x8(%ebp),%edx
  800de7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800de9:	8b 1c 24             	mov    (%esp),%ebx
  800dec:	8b 74 24 04          	mov    0x4(%esp),%esi
  800df0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800df4:	89 ec                	mov    %ebp,%esp
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 38             	sub    $0x38,%esp
  800dfe:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e01:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e04:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	89 df                	mov    %ebx,%edi
  800e19:	89 de                	mov    %ebx,%esi
  800e1b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	7e 28                	jle    800e49 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e21:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e25:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e2c:	00 
  800e2d:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  800e34:	00 
  800e35:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3c:	00 
  800e3d:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  800e44:	e8 1f f3 ff ff       	call   800168 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e49:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e4c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e4f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e52:	89 ec                	mov    %ebp,%esp
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 38             	sub    $0x38,%esp
  800e5c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e5f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e62:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	89 df                	mov    %ebx,%edi
  800e77:	89 de                	mov    %ebx,%esi
  800e79:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7e 28                	jle    800ea7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e83:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e8a:	00 
  800e8b:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  800e92:	00 
  800e93:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e9a:	00 
  800e9b:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  800ea2:	e8 c1 f2 ff ff       	call   800168 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eaa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ead:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eb0:	89 ec                	mov    %ebp,%esp
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 38             	sub    $0x38,%esp
  800eba:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ebd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ec0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ecd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	89 df                	mov    %ebx,%edi
  800ed5:	89 de                	mov    %ebx,%esi
  800ed7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	7e 28                	jle    800f05 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800edd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ee8:	00 
  800ee9:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  800ef0:	00 
  800ef1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef8:	00 
  800ef9:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  800f00:	e8 63 f2 ff ff       	call   800168 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f05:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f08:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f0b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f0e:	89 ec                	mov    %ebp,%esp
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 38             	sub    $0x38,%esp
  800f18:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f1b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f1e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f26:	b8 06 00 00 00       	mov    $0x6,%eax
  800f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	89 df                	mov    %ebx,%edi
  800f33:	89 de                	mov    %ebx,%esi
  800f35:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	7e 28                	jle    800f63 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f46:	00 
  800f47:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  800f4e:	00 
  800f4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f56:	00 
  800f57:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  800f5e:	e8 05 f2 ff ff       	call   800168 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f63:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f66:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f6c:	89 ec                	mov    %ebp,%esp
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    

00800f70 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	83 ec 38             	sub    $0x38,%esp
  800f76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f79:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f7c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f84:	8b 75 18             	mov    0x18(%ebp),%esi
  800f87:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f95:	85 c0                	test   %eax,%eax
  800f97:	7e 28                	jle    800fc1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f99:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fa4:	00 
  800fa5:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  800fac:	00 
  800fad:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb4:	00 
  800fb5:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  800fbc:	e8 a7 f1 ff ff       	call   800168 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fc1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fc4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fc7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fca:	89 ec                	mov    %ebp,%esp
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    

00800fce <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 38             	sub    $0x38,%esp
  800fd4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fd7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fda:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fdd:	be 00 00 00 00       	mov    $0x0,%esi
  800fe2:	b8 04 00 00 00       	mov    $0x4,%eax
  800fe7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff0:	89 f7                	mov    %esi,%edi
  800ff2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff4:	85 c0                	test   %eax,%eax
  800ff6:	7e 28                	jle    801020 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ffc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801003:	00 
  801004:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  80100b:	00 
  80100c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801013:	00 
  801014:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  80101b:	e8 48 f1 ff ff       	call   800168 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801020:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801023:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801026:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801029:	89 ec                	mov    %ebp,%esp
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 0c             	sub    $0xc,%esp
  801033:	89 1c 24             	mov    %ebx,(%esp)
  801036:	89 74 24 04          	mov    %esi,0x4(%esp)
  80103a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103e:	ba 00 00 00 00       	mov    $0x0,%edx
  801043:	b8 0b 00 00 00       	mov    $0xb,%eax
  801048:	89 d1                	mov    %edx,%ecx
  80104a:	89 d3                	mov    %edx,%ebx
  80104c:	89 d7                	mov    %edx,%edi
  80104e:	89 d6                	mov    %edx,%esi
  801050:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801052:	8b 1c 24             	mov    (%esp),%ebx
  801055:	8b 74 24 04          	mov    0x4(%esp),%esi
  801059:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80105d:	89 ec                	mov    %ebp,%esp
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    

00801061 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 0c             	sub    $0xc,%esp
  801067:	89 1c 24             	mov    %ebx,(%esp)
  80106a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80106e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801072:	ba 00 00 00 00       	mov    $0x0,%edx
  801077:	b8 02 00 00 00       	mov    $0x2,%eax
  80107c:	89 d1                	mov    %edx,%ecx
  80107e:	89 d3                	mov    %edx,%ebx
  801080:	89 d7                	mov    %edx,%edi
  801082:	89 d6                	mov    %edx,%esi
  801084:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801086:	8b 1c 24             	mov    (%esp),%ebx
  801089:	8b 74 24 04          	mov    0x4(%esp),%esi
  80108d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801091:	89 ec                	mov    %ebp,%esp
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 38             	sub    $0x38,%esp
  80109b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80109e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 cb                	mov    %ecx,%ebx
  8010b3:	89 cf                	mov    %ecx,%edi
  8010b5:	89 ce                	mov    %ecx,%esi
  8010b7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	7e 28                	jle    8010e5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010c8:	00 
  8010c9:	c7 44 24 08 88 17 80 	movl   $0x801788,0x8(%esp)
  8010d0:	00 
  8010d1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d8:	00 
  8010d9:	c7 04 24 a5 17 80 00 	movl   $0x8017a5,(%esp)
  8010e0:	e8 83 f0 ff ff       	call   800168 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010e5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010eb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ee:	89 ec                	mov    %ebp,%esp
  8010f0:	5d                   	pop    %ebp
  8010f1:	c3                   	ret    
	...

00801100 <__udivdi3>:
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	57                   	push   %edi
  801104:	56                   	push   %esi
  801105:	83 ec 10             	sub    $0x10,%esp
  801108:	8b 45 14             	mov    0x14(%ebp),%eax
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 75 10             	mov    0x10(%ebp),%esi
  801111:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801114:	85 c0                	test   %eax,%eax
  801116:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801119:	75 35                	jne    801150 <__udivdi3+0x50>
  80111b:	39 fe                	cmp    %edi,%esi
  80111d:	77 61                	ja     801180 <__udivdi3+0x80>
  80111f:	85 f6                	test   %esi,%esi
  801121:	75 0b                	jne    80112e <__udivdi3+0x2e>
  801123:	b8 01 00 00 00       	mov    $0x1,%eax
  801128:	31 d2                	xor    %edx,%edx
  80112a:	f7 f6                	div    %esi
  80112c:	89 c6                	mov    %eax,%esi
  80112e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801131:	31 d2                	xor    %edx,%edx
  801133:	89 f8                	mov    %edi,%eax
  801135:	f7 f6                	div    %esi
  801137:	89 c7                	mov    %eax,%edi
  801139:	89 c8                	mov    %ecx,%eax
  80113b:	f7 f6                	div    %esi
  80113d:	89 c1                	mov    %eax,%ecx
  80113f:	89 fa                	mov    %edi,%edx
  801141:	89 c8                	mov    %ecx,%eax
  801143:	83 c4 10             	add    $0x10,%esp
  801146:	5e                   	pop    %esi
  801147:	5f                   	pop    %edi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    
  80114a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801150:	39 f8                	cmp    %edi,%eax
  801152:	77 1c                	ja     801170 <__udivdi3+0x70>
  801154:	0f bd d0             	bsr    %eax,%edx
  801157:	83 f2 1f             	xor    $0x1f,%edx
  80115a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80115d:	75 39                	jne    801198 <__udivdi3+0x98>
  80115f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801162:	0f 86 a0 00 00 00    	jbe    801208 <__udivdi3+0x108>
  801168:	39 f8                	cmp    %edi,%eax
  80116a:	0f 82 98 00 00 00    	jb     801208 <__udivdi3+0x108>
  801170:	31 ff                	xor    %edi,%edi
  801172:	31 c9                	xor    %ecx,%ecx
  801174:	89 c8                	mov    %ecx,%eax
  801176:	89 fa                	mov    %edi,%edx
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	5e                   	pop    %esi
  80117c:	5f                   	pop    %edi
  80117d:	5d                   	pop    %ebp
  80117e:	c3                   	ret    
  80117f:	90                   	nop
  801180:	89 d1                	mov    %edx,%ecx
  801182:	89 fa                	mov    %edi,%edx
  801184:	89 c8                	mov    %ecx,%eax
  801186:	31 ff                	xor    %edi,%edi
  801188:	f7 f6                	div    %esi
  80118a:	89 c1                	mov    %eax,%ecx
  80118c:	89 fa                	mov    %edi,%edx
  80118e:	89 c8                	mov    %ecx,%eax
  801190:	83 c4 10             	add    $0x10,%esp
  801193:	5e                   	pop    %esi
  801194:	5f                   	pop    %edi
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    
  801197:	90                   	nop
  801198:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80119c:	89 f2                	mov    %esi,%edx
  80119e:	d3 e0                	shl    %cl,%eax
  8011a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011a3:	b8 20 00 00 00       	mov    $0x20,%eax
  8011a8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8011ab:	89 c1                	mov    %eax,%ecx
  8011ad:	d3 ea                	shr    %cl,%edx
  8011af:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011b3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8011b6:	d3 e6                	shl    %cl,%esi
  8011b8:	89 c1                	mov    %eax,%ecx
  8011ba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8011bd:	89 fe                	mov    %edi,%esi
  8011bf:	d3 ee                	shr    %cl,%esi
  8011c1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8011c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cb:	d3 e7                	shl    %cl,%edi
  8011cd:	89 c1                	mov    %eax,%ecx
  8011cf:	d3 ea                	shr    %cl,%edx
  8011d1:	09 d7                	or     %edx,%edi
  8011d3:	89 f2                	mov    %esi,%edx
  8011d5:	89 f8                	mov    %edi,%eax
  8011d7:	f7 75 ec             	divl   -0x14(%ebp)
  8011da:	89 d6                	mov    %edx,%esi
  8011dc:	89 c7                	mov    %eax,%edi
  8011de:	f7 65 e8             	mull   -0x18(%ebp)
  8011e1:	39 d6                	cmp    %edx,%esi
  8011e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8011e6:	72 30                	jb     801218 <__udivdi3+0x118>
  8011e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011eb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011ef:	d3 e2                	shl    %cl,%edx
  8011f1:	39 c2                	cmp    %eax,%edx
  8011f3:	73 05                	jae    8011fa <__udivdi3+0xfa>
  8011f5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8011f8:	74 1e                	je     801218 <__udivdi3+0x118>
  8011fa:	89 f9                	mov    %edi,%ecx
  8011fc:	31 ff                	xor    %edi,%edi
  8011fe:	e9 71 ff ff ff       	jmp    801174 <__udivdi3+0x74>
  801203:	90                   	nop
  801204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801208:	31 ff                	xor    %edi,%edi
  80120a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80120f:	e9 60 ff ff ff       	jmp    801174 <__udivdi3+0x74>
  801214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801218:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80121b:	31 ff                	xor    %edi,%edi
  80121d:	89 c8                	mov    %ecx,%eax
  80121f:	89 fa                	mov    %edi,%edx
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	5e                   	pop    %esi
  801225:	5f                   	pop    %edi
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    
	...

00801230 <__umoddi3>:
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	83 ec 20             	sub    $0x20,%esp
  801238:	8b 55 14             	mov    0x14(%ebp),%edx
  80123b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801241:	8b 75 0c             	mov    0xc(%ebp),%esi
  801244:	85 d2                	test   %edx,%edx
  801246:	89 c8                	mov    %ecx,%eax
  801248:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80124b:	75 13                	jne    801260 <__umoddi3+0x30>
  80124d:	39 f7                	cmp    %esi,%edi
  80124f:	76 3f                	jbe    801290 <__umoddi3+0x60>
  801251:	89 f2                	mov    %esi,%edx
  801253:	f7 f7                	div    %edi
  801255:	89 d0                	mov    %edx,%eax
  801257:	31 d2                	xor    %edx,%edx
  801259:	83 c4 20             	add    $0x20,%esp
  80125c:	5e                   	pop    %esi
  80125d:	5f                   	pop    %edi
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    
  801260:	39 f2                	cmp    %esi,%edx
  801262:	77 4c                	ja     8012b0 <__umoddi3+0x80>
  801264:	0f bd ca             	bsr    %edx,%ecx
  801267:	83 f1 1f             	xor    $0x1f,%ecx
  80126a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80126d:	75 51                	jne    8012c0 <__umoddi3+0x90>
  80126f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801272:	0f 87 e0 00 00 00    	ja     801358 <__umoddi3+0x128>
  801278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127b:	29 f8                	sub    %edi,%eax
  80127d:	19 d6                	sbb    %edx,%esi
  80127f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801285:	89 f2                	mov    %esi,%edx
  801287:	83 c4 20             	add    $0x20,%esp
  80128a:	5e                   	pop    %esi
  80128b:	5f                   	pop    %edi
  80128c:	5d                   	pop    %ebp
  80128d:	c3                   	ret    
  80128e:	66 90                	xchg   %ax,%ax
  801290:	85 ff                	test   %edi,%edi
  801292:	75 0b                	jne    80129f <__umoddi3+0x6f>
  801294:	b8 01 00 00 00       	mov    $0x1,%eax
  801299:	31 d2                	xor    %edx,%edx
  80129b:	f7 f7                	div    %edi
  80129d:	89 c7                	mov    %eax,%edi
  80129f:	89 f0                	mov    %esi,%eax
  8012a1:	31 d2                	xor    %edx,%edx
  8012a3:	f7 f7                	div    %edi
  8012a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a8:	f7 f7                	div    %edi
  8012aa:	eb a9                	jmp    801255 <__umoddi3+0x25>
  8012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012b0:	89 c8                	mov    %ecx,%eax
  8012b2:	89 f2                	mov    %esi,%edx
  8012b4:	83 c4 20             	add    $0x20,%esp
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    
  8012bb:	90                   	nop
  8012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012c0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012c4:	d3 e2                	shl    %cl,%edx
  8012c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c9:	ba 20 00 00 00       	mov    $0x20,%edx
  8012ce:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8012d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8012d4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012d8:	89 fa                	mov    %edi,%edx
  8012da:	d3 ea                	shr    %cl,%edx
  8012dc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012e0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8012e3:	d3 e7                	shl    %cl,%edi
  8012e5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012ec:	89 f2                	mov    %esi,%edx
  8012ee:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8012f1:	89 c7                	mov    %eax,%edi
  8012f3:	d3 ea                	shr    %cl,%edx
  8012f5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8012fc:	89 c2                	mov    %eax,%edx
  8012fe:	d3 e6                	shl    %cl,%esi
  801300:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801304:	d3 ea                	shr    %cl,%edx
  801306:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80130a:	09 d6                	or     %edx,%esi
  80130c:	89 f0                	mov    %esi,%eax
  80130e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801311:	d3 e7                	shl    %cl,%edi
  801313:	89 f2                	mov    %esi,%edx
  801315:	f7 75 f4             	divl   -0xc(%ebp)
  801318:	89 d6                	mov    %edx,%esi
  80131a:	f7 65 e8             	mull   -0x18(%ebp)
  80131d:	39 d6                	cmp    %edx,%esi
  80131f:	72 2b                	jb     80134c <__umoddi3+0x11c>
  801321:	39 c7                	cmp    %eax,%edi
  801323:	72 23                	jb     801348 <__umoddi3+0x118>
  801325:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801329:	29 c7                	sub    %eax,%edi
  80132b:	19 d6                	sbb    %edx,%esi
  80132d:	89 f0                	mov    %esi,%eax
  80132f:	89 f2                	mov    %esi,%edx
  801331:	d3 ef                	shr    %cl,%edi
  801333:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801337:	d3 e0                	shl    %cl,%eax
  801339:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80133d:	09 f8                	or     %edi,%eax
  80133f:	d3 ea                	shr    %cl,%edx
  801341:	83 c4 20             	add    $0x20,%esp
  801344:	5e                   	pop    %esi
  801345:	5f                   	pop    %edi
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    
  801348:	39 d6                	cmp    %edx,%esi
  80134a:	75 d9                	jne    801325 <__umoddi3+0xf5>
  80134c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80134f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801352:	eb d1                	jmp    801325 <__umoddi3+0xf5>
  801354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801358:	39 f2                	cmp    %esi,%edx
  80135a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801360:	0f 82 12 ff ff ff    	jb     801278 <__umoddi3+0x48>
  801366:	e9 17 ff ff ff       	jmp    801282 <__umoddi3+0x52>
