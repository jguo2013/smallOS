
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
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
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  80003a:	a1 00 00 10 f0       	mov    0xf0100000,%eax
  80003f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800043:	c7 04 24 c0 12 80 00 	movl   $0x8012c0,(%esp)
  80004a:	e8 ca 00 00 00       	call   800119 <cprintf>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    
  800051:	00 00                	add    %al,(%eax)
	...

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
  80005a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80005d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800060:	8b 75 08             	mov    0x8(%ebp),%esi
  800063:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800066:	e8 e6 0e 00 00       	call   800f51 <sys_getenvid>
  80006b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800070:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800073:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800078:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007d:	85 f6                	test   %esi,%esi
  80007f:	7e 07                	jle    800088 <libmain+0x34>
		binaryname = argv[0];
  800081:	8b 03                	mov    (%ebx),%eax
  800083:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800088:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008c:	89 34 24             	mov    %esi,(%esp)
  80008f:	e8 a0 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800094:	e8 0b 00 00 00       	call   8000a4 <exit>
}
  800099:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80009c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80009f:	89 ec                	mov    %ebp,%esp
  8000a1:	5d                   	pop    %ebp
  8000a2:	c3                   	ret    
	...

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8000aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b1:	e8 cf 0e 00 00       	call   800f85 <sys_env_destroy>
}
  8000b6:	c9                   	leave  
  8000b7:	c3                   	ret    

008000b8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8000c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000c8:	00 00 00 
	b.cnt = 0;
  8000cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8000e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ed:	c7 04 24 33 01 80 00 	movl   $0x800133,(%esp)
  8000f4:	e8 be 01 00 00       	call   8002b7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8000f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8000ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800103:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800109:	89 04 24             	mov    %eax,(%esp)
  80010c:	e8 1f 0a 00 00       	call   800b30 <sys_cputs>

	return b.cnt;
}
  800111:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800117:	c9                   	leave  
  800118:	c3                   	ret    

00800119 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80011f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800122:	89 44 24 04          	mov    %eax,0x4(%esp)
  800126:	8b 45 08             	mov    0x8(%ebp),%eax
  800129:	89 04 24             	mov    %eax,(%esp)
  80012c:	e8 87 ff ff ff       	call   8000b8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800131:	c9                   	leave  
  800132:	c3                   	ret    

00800133 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	53                   	push   %ebx
  800137:	83 ec 14             	sub    $0x14,%esp
  80013a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80013d:	8b 03                	mov    (%ebx),%eax
  80013f:	8b 55 08             	mov    0x8(%ebp),%edx
  800142:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800146:	83 c0 01             	add    $0x1,%eax
  800149:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80014b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800150:	75 19                	jne    80016b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800152:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800159:	00 
  80015a:	8d 43 08             	lea    0x8(%ebx),%eax
  80015d:	89 04 24             	mov    %eax,(%esp)
  800160:	e8 cb 09 00 00       	call   800b30 <sys_cputs>
		b->idx = 0;
  800165:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80016b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80016f:	83 c4 14             	add    $0x14,%esp
  800172:	5b                   	pop    %ebx
  800173:	5d                   	pop    %ebp
  800174:	c3                   	ret    
  800175:	00 00                	add    %al,(%eax)
	...

00800178 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	57                   	push   %edi
  80017c:	56                   	push   %esi
  80017d:	53                   	push   %ebx
  80017e:	83 ec 4c             	sub    $0x4c,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800184:	89 d6                	mov    %edx,%esi
  800186:	8b 45 08             	mov    0x8(%ebp),%eax
  800189:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800192:	8b 45 10             	mov    0x10(%ebp),%eax
  800195:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800198:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80019b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80019e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001a3:	39 d1                	cmp    %edx,%ecx
  8001a5:	72 07                	jb     8001ae <printnum+0x36>
  8001a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001aa:	39 d0                	cmp    %edx,%eax
  8001ac:	77 69                	ja     800217 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ae:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8001b2:	83 eb 01             	sub    $0x1,%ebx
  8001b5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8001c1:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8001c5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8001c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8001cb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001d2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001d9:	00 
  8001da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dd:	89 04 24             	mov    %eax,(%esp)
  8001e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001e7:	e8 54 0e 00 00       	call   801040 <__udivdi3>
  8001ec:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8001ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8001f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8001f6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001fa:	89 04 24             	mov    %eax,(%esp)
  8001fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  800201:	89 f2                	mov    %esi,%edx
  800203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800206:	e8 6d ff ff ff       	call   800178 <printnum>
  80020b:	eb 11                	jmp    80021e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800211:	89 3c 24             	mov    %edi,(%esp)
  800214:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800217:	83 eb 01             	sub    $0x1,%ebx
  80021a:	85 db                	test   %ebx,%ebx
  80021c:	7f ef                	jg     80020d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800222:	8b 74 24 04          	mov    0x4(%esp),%esi
  800226:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800229:	89 44 24 08          	mov    %eax,0x8(%esp)
  80022d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800234:	00 
  800235:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800238:	89 14 24             	mov    %edx,(%esp)
  80023b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80023e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800242:	e8 29 0f 00 00       	call   801170 <__umoddi3>
  800247:	89 74 24 04          	mov    %esi,0x4(%esp)
  80024b:	0f be 80 f1 12 80 00 	movsbl 0x8012f1(%eax),%eax
  800252:	89 04 24             	mov    %eax,(%esp)
  800255:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800258:	83 c4 4c             	add    $0x4c,%esp
  80025b:	5b                   	pop    %ebx
  80025c:	5e                   	pop    %esi
  80025d:	5f                   	pop    %edi
  80025e:	5d                   	pop    %ebp
  80025f:	c3                   	ret    

00800260 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800263:	83 fa 01             	cmp    $0x1,%edx
  800266:	7e 0e                	jle    800276 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800268:	8b 10                	mov    (%eax),%edx
  80026a:	8d 4a 08             	lea    0x8(%edx),%ecx
  80026d:	89 08                	mov    %ecx,(%eax)
  80026f:	8b 02                	mov    (%edx),%eax
  800271:	8b 52 04             	mov    0x4(%edx),%edx
  800274:	eb 22                	jmp    800298 <getuint+0x38>
	else if (lflag)
  800276:	85 d2                	test   %edx,%edx
  800278:	74 10                	je     80028a <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80027a:	8b 10                	mov    (%eax),%edx
  80027c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027f:	89 08                	mov    %ecx,(%eax)
  800281:	8b 02                	mov    (%edx),%eax
  800283:	ba 00 00 00 00       	mov    $0x0,%edx
  800288:	eb 0e                	jmp    800298 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80028a:	8b 10                	mov    (%eax),%edx
  80028c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028f:	89 08                	mov    %ecx,(%eax)
  800291:	8b 02                	mov    (%edx),%eax
  800293:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    

0080029a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a4:	8b 10                	mov    (%eax),%edx
  8002a6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a9:	73 0a                	jae    8002b5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ae:	88 0a                	mov    %cl,(%edx)
  8002b0:	83 c2 01             	add    $0x1,%edx
  8002b3:	89 10                	mov    %edx,(%eax)
}
  8002b5:	5d                   	pop    %ebp
  8002b6:	c3                   	ret    

008002b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	57                   	push   %edi
  8002bb:	56                   	push   %esi
  8002bc:	53                   	push   %ebx
  8002bd:	83 ec 4c             	sub    $0x4c,%esp
  8002c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8002c9:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8002d0:	eb 11                	jmp    8002e3 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	0f 84 b6 03 00 00    	je     800690 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8002da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002de:	89 04 24             	mov    %eax,(%esp)
  8002e1:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002e3:	0f b6 03             	movzbl (%ebx),%eax
  8002e6:	83 c3 01             	add    $0x1,%ebx
  8002e9:	83 f8 25             	cmp    $0x25,%eax
  8002ec:	75 e4                	jne    8002d2 <vprintfmt+0x1b>
  8002ee:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8002f2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002f9:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800300:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800307:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80030f:	eb 06                	jmp    800317 <vprintfmt+0x60>
  800311:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800315:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800317:	0f b6 0b             	movzbl (%ebx),%ecx
  80031a:	0f b6 c1             	movzbl %cl,%eax
  80031d:	8d 53 01             	lea    0x1(%ebx),%edx
  800320:	83 e9 23             	sub    $0x23,%ecx
  800323:	80 f9 55             	cmp    $0x55,%cl
  800326:	0f 87 47 03 00 00    	ja     800673 <vprintfmt+0x3bc>
  80032c:	0f b6 c9             	movzbl %cl,%ecx
  80032f:	ff 24 8d 40 14 80 00 	jmp    *0x801440(,%ecx,4)
  800336:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80033a:	eb d9                	jmp    800315 <vprintfmt+0x5e>
  80033c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800343:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800348:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80034b:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80034f:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800352:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800355:	83 fb 09             	cmp    $0x9,%ebx
  800358:	77 30                	ja     80038a <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80035a:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80035d:	eb e9                	jmp    800348 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8d 48 04             	lea    0x4(%eax),%ecx
  800365:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800368:	8b 00                	mov    (%eax),%eax
  80036a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  80036d:	eb 1e                	jmp    80038d <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80036f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800373:	b8 00 00 00 00       	mov    $0x0,%eax
  800378:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  80037c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037f:	eb 94                	jmp    800315 <vprintfmt+0x5e>
  800381:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800388:	eb 8b                	jmp    800315 <vprintfmt+0x5e>
  80038a:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  80038d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800391:	79 82                	jns    800315 <vprintfmt+0x5e>
  800393:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800396:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800399:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80039c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80039f:	e9 71 ff ff ff       	jmp    800315 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003a4:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003a8:	e9 68 ff ff ff       	jmp    800315 <vprintfmt+0x5e>
  8003ad:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8d 50 04             	lea    0x4(%eax),%edx
  8003b6:	89 55 14             	mov    %edx,0x14(%ebp)
  8003b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	89 04 24             	mov    %eax,(%esp)
  8003c2:	ff d7                	call   *%edi
  8003c4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8003c7:	e9 17 ff ff ff       	jmp    8002e3 <vprintfmt+0x2c>
  8003cc:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d2:	8d 50 04             	lea    0x4(%eax),%edx
  8003d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	89 c2                	mov    %eax,%edx
  8003dc:	c1 fa 1f             	sar    $0x1f,%edx
  8003df:	31 d0                	xor    %edx,%eax
  8003e1:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e3:	83 f8 11             	cmp    $0x11,%eax
  8003e6:	7f 0b                	jg     8003f3 <vprintfmt+0x13c>
  8003e8:	8b 14 85 a0 15 80 00 	mov    0x8015a0(,%eax,4),%edx
  8003ef:	85 d2                	test   %edx,%edx
  8003f1:	75 20                	jne    800413 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8003f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003f7:	c7 44 24 08 02 13 80 	movl   $0x801302,0x8(%esp)
  8003fe:	00 
  8003ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  800403:	89 3c 24             	mov    %edi,(%esp)
  800406:	e8 0d 03 00 00       	call   800718 <printfmt>
  80040b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040e:	e9 d0 fe ff ff       	jmp    8002e3 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800413:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800417:	c7 44 24 08 0b 13 80 	movl   $0x80130b,0x8(%esp)
  80041e:	00 
  80041f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800423:	89 3c 24             	mov    %edi,(%esp)
  800426:	e8 ed 02 00 00       	call   800718 <printfmt>
  80042b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80042e:	e9 b0 fe ff ff       	jmp    8002e3 <vprintfmt+0x2c>
  800433:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800436:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80043f:	8b 45 14             	mov    0x14(%ebp),%eax
  800442:	8d 50 04             	lea    0x4(%eax),%edx
  800445:	89 55 14             	mov    %edx,0x14(%ebp)
  800448:	8b 18                	mov    (%eax),%ebx
  80044a:	85 db                	test   %ebx,%ebx
  80044c:	b8 0e 13 80 00       	mov    $0x80130e,%eax
  800451:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800454:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800458:	7e 76                	jle    8004d0 <vprintfmt+0x219>
  80045a:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80045e:	74 7a                	je     8004da <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800460:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800464:	89 1c 24             	mov    %ebx,(%esp)
  800467:	e8 ec 02 00 00       	call   800758 <strnlen>
  80046c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80046f:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800471:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800475:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800478:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80047b:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80047d:	eb 0f                	jmp    80048e <vprintfmt+0x1d7>
					putch(padc, putdat);
  80047f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800483:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800486:	89 04 24             	mov    %eax,(%esp)
  800489:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80048b:	83 eb 01             	sub    $0x1,%ebx
  80048e:	85 db                	test   %ebx,%ebx
  800490:	7f ed                	jg     80047f <vprintfmt+0x1c8>
  800492:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800495:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800498:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80049b:	89 f7                	mov    %esi,%edi
  80049d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004a0:	eb 40                	jmp    8004e2 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a6:	74 18                	je     8004c0 <vprintfmt+0x209>
  8004a8:	8d 50 e0             	lea    -0x20(%eax),%edx
  8004ab:	83 fa 5e             	cmp    $0x5e,%edx
  8004ae:	76 10                	jbe    8004c0 <vprintfmt+0x209>
					putch('?', putdat);
  8004b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004b4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8004bb:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004be:	eb 0a                	jmp    8004ca <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8004c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004c4:	89 04 24             	mov    %eax,(%esp)
  8004c7:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ca:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8004ce:	eb 12                	jmp    8004e2 <vprintfmt+0x22b>
  8004d0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004d3:	89 f7                	mov    %esi,%edi
  8004d5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004d8:	eb 08                	jmp    8004e2 <vprintfmt+0x22b>
  8004da:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004dd:	89 f7                	mov    %esi,%edi
  8004df:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004e2:	0f be 03             	movsbl (%ebx),%eax
  8004e5:	83 c3 01             	add    $0x1,%ebx
  8004e8:	85 c0                	test   %eax,%eax
  8004ea:	74 25                	je     800511 <vprintfmt+0x25a>
  8004ec:	85 f6                	test   %esi,%esi
  8004ee:	78 b2                	js     8004a2 <vprintfmt+0x1eb>
  8004f0:	83 ee 01             	sub    $0x1,%esi
  8004f3:	79 ad                	jns    8004a2 <vprintfmt+0x1eb>
  8004f5:	89 fe                	mov    %edi,%esi
  8004f7:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004fd:	eb 1a                	jmp    800519 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8004ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  800503:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80050a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80050c:	83 eb 01             	sub    $0x1,%ebx
  80050f:	eb 08                	jmp    800519 <vprintfmt+0x262>
  800511:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800514:	89 fe                	mov    %edi,%esi
  800516:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800519:	85 db                	test   %ebx,%ebx
  80051b:	7f e2                	jg     8004ff <vprintfmt+0x248>
  80051d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800520:	e9 be fd ff ff       	jmp    8002e3 <vprintfmt+0x2c>
  800525:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800528:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80052b:	83 f9 01             	cmp    $0x1,%ecx
  80052e:	7e 16                	jle    800546 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800530:	8b 45 14             	mov    0x14(%ebp),%eax
  800533:	8d 50 08             	lea    0x8(%eax),%edx
  800536:	89 55 14             	mov    %edx,0x14(%ebp)
  800539:	8b 10                	mov    (%eax),%edx
  80053b:	8b 48 04             	mov    0x4(%eax),%ecx
  80053e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800541:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800544:	eb 32                	jmp    800578 <vprintfmt+0x2c1>
	else if (lflag)
  800546:	85 c9                	test   %ecx,%ecx
  800548:	74 18                	je     800562 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8d 50 04             	lea    0x4(%eax),%edx
  800550:	89 55 14             	mov    %edx,0x14(%ebp)
  800553:	8b 00                	mov    (%eax),%eax
  800555:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800558:	89 c1                	mov    %eax,%ecx
  80055a:	c1 f9 1f             	sar    $0x1f,%ecx
  80055d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800560:	eb 16                	jmp    800578 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8d 50 04             	lea    0x4(%eax),%edx
  800568:	89 55 14             	mov    %edx,0x14(%ebp)
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	89 c2                	mov    %eax,%edx
  800572:	c1 fa 1f             	sar    $0x1f,%edx
  800575:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800578:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80057b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80057e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800583:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800587:	0f 89 a7 00 00 00    	jns    800634 <vprintfmt+0x37d>
				putch('-', putdat);
  80058d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800591:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800598:	ff d7                	call   *%edi
				num = -(long long) num;
  80059a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80059d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005a0:	f7 d9                	neg    %ecx
  8005a2:	83 d3 00             	adc    $0x0,%ebx
  8005a5:	f7 db                	neg    %ebx
  8005a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ac:	e9 83 00 00 00       	jmp    800634 <vprintfmt+0x37d>
  8005b1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005b4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005b7:	89 ca                	mov    %ecx,%edx
  8005b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8005bc:	e8 9f fc ff ff       	call   800260 <getuint>
  8005c1:	89 c1                	mov    %eax,%ecx
  8005c3:	89 d3                	mov    %edx,%ebx
  8005c5:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8005ca:	eb 68                	jmp    800634 <vprintfmt+0x37d>
  8005cc:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005cf:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8005d2:	89 ca                	mov    %ecx,%edx
  8005d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8005d7:	e8 84 fc ff ff       	call   800260 <getuint>
  8005dc:	89 c1                	mov    %eax,%ecx
  8005de:	89 d3                	mov    %edx,%ebx
  8005e0:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8005e5:	eb 4d                	jmp    800634 <vprintfmt+0x37d>
  8005e7:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8005ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ee:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8005f5:	ff d7                	call   *%edi
			putch('x', putdat);
  8005f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fb:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800602:	ff d7                	call   *%edi
			num = (unsigned long long)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 50 04             	lea    0x4(%eax),%edx
  80060a:	89 55 14             	mov    %edx,0x14(%ebp)
  80060d:	8b 08                	mov    (%eax),%ecx
  80060f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800614:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800619:	eb 19                	jmp    800634 <vprintfmt+0x37d>
  80061b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80061e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800621:	89 ca                	mov    %ecx,%edx
  800623:	8d 45 14             	lea    0x14(%ebp),%eax
  800626:	e8 35 fc ff ff       	call   800260 <getuint>
  80062b:	89 c1                	mov    %eax,%ecx
  80062d:	89 d3                	mov    %edx,%ebx
  80062f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800634:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800638:	89 54 24 10          	mov    %edx,0x10(%esp)
  80063c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80063f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800643:	89 44 24 08          	mov    %eax,0x8(%esp)
  800647:	89 0c 24             	mov    %ecx,(%esp)
  80064a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80064e:	89 f2                	mov    %esi,%edx
  800650:	89 f8                	mov    %edi,%eax
  800652:	e8 21 fb ff ff       	call   800178 <printnum>
  800657:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80065a:	e9 84 fc ff ff       	jmp    8002e3 <vprintfmt+0x2c>
  80065f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800662:	89 74 24 04          	mov    %esi,0x4(%esp)
  800666:	89 04 24             	mov    %eax,(%esp)
  800669:	ff d7                	call   *%edi
  80066b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80066e:	e9 70 fc ff ff       	jmp    8002e3 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800673:	89 74 24 04          	mov    %esi,0x4(%esp)
  800677:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80067e:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800680:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800683:	80 38 25             	cmpb   $0x25,(%eax)
  800686:	0f 84 57 fc ff ff    	je     8002e3 <vprintfmt+0x2c>
  80068c:	89 c3                	mov    %eax,%ebx
  80068e:	eb f0                	jmp    800680 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800690:	83 c4 4c             	add    $0x4c,%esp
  800693:	5b                   	pop    %ebx
  800694:	5e                   	pop    %esi
  800695:	5f                   	pop    %edi
  800696:	5d                   	pop    %ebp
  800697:	c3                   	ret    

00800698 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	83 ec 28             	sub    $0x28,%esp
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8006a4:	85 c0                	test   %eax,%eax
  8006a6:	74 04                	je     8006ac <vsnprintf+0x14>
  8006a8:	85 d2                	test   %edx,%edx
  8006aa:	7f 07                	jg     8006b3 <vsnprintf+0x1b>
  8006ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006b1:	eb 3b                	jmp    8006ee <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006b6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8006ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006d9:	c7 04 24 9a 02 80 00 	movl   $0x80029a,(%esp)
  8006e0:	e8 d2 fb ff ff       	call   8002b7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8006f6:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8006f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800700:	89 44 24 08          	mov    %eax,0x8(%esp)
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 04 24             	mov    %eax,(%esp)
  800711:	e8 82 ff ff ff       	call   800698 <vsnprintf>
	va_end(ap);

	return rc;
}
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80071e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800721:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800725:	8b 45 10             	mov    0x10(%ebp),%eax
  800728:	89 44 24 08          	mov    %eax,0x8(%esp)
  80072c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 04 24             	mov    %eax,(%esp)
  800739:	e8 79 fb ff ff       	call   8002b7 <vprintfmt>
	va_end(ap);
}
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	8b 55 08             	mov    0x8(%ebp),%edx
  800746:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80074b:	eb 03                	jmp    800750 <strlen+0x10>
		n++;
  80074d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800750:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800754:	75 f7                	jne    80074d <strlen+0xd>
		n++;
	return n;
}
  800756:	5d                   	pop    %ebp
  800757:	c3                   	ret    

00800758 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	53                   	push   %ebx
  80075c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80075f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800762:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800767:	eb 03                	jmp    80076c <strnlen+0x14>
		n++;
  800769:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076c:	39 c1                	cmp    %eax,%ecx
  80076e:	74 06                	je     800776 <strnlen+0x1e>
  800770:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800774:	75 f3                	jne    800769 <strnlen+0x11>
		n++;
	return n;
}
  800776:	5b                   	pop    %ebx
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	53                   	push   %ebx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800783:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800788:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80078c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80078f:	83 c2 01             	add    $0x1,%edx
  800792:	84 c9                	test   %cl,%cl
  800794:	75 f2                	jne    800788 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800796:	5b                   	pop    %ebx
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	53                   	push   %ebx
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a3:	89 1c 24             	mov    %ebx,(%esp)
  8007a6:	e8 95 ff ff ff       	call   800740 <strlen>
	strcpy(dst + len, src);
  8007ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007b2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8007b5:	89 04 24             	mov    %eax,(%esp)
  8007b8:	e8 bc ff ff ff       	call   800779 <strcpy>
	return dst;
}
  8007bd:	89 d8                	mov    %ebx,%eax
  8007bf:	83 c4 08             	add    $0x8,%esp
  8007c2:	5b                   	pop    %ebx
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	56                   	push   %esi
  8007c9:	53                   	push   %ebx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d0:	8b 75 10             	mov    0x10(%ebp),%esi
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007d8:	eb 0f                	jmp    8007e9 <strncpy+0x24>
		*dst++ = *src;
  8007da:	0f b6 19             	movzbl (%ecx),%ebx
  8007dd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007e0:	80 39 01             	cmpb   $0x1,(%ecx)
  8007e3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e6:	83 c2 01             	add    $0x1,%edx
  8007e9:	39 f2                	cmp    %esi,%edx
  8007eb:	72 ed                	jb     8007da <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007ed:	5b                   	pop    %ebx
  8007ee:	5e                   	pop    %esi
  8007ef:	5d                   	pop    %ebp
  8007f0:	c3                   	ret    

008007f1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	56                   	push   %esi
  8007f5:	53                   	push   %ebx
  8007f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007fc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007ff:	89 f0                	mov    %esi,%eax
  800801:	85 d2                	test   %edx,%edx
  800803:	75 0a                	jne    80080f <strlcpy+0x1e>
  800805:	eb 17                	jmp    80081e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800807:	88 18                	mov    %bl,(%eax)
  800809:	83 c0 01             	add    $0x1,%eax
  80080c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80080f:	83 ea 01             	sub    $0x1,%edx
  800812:	74 07                	je     80081b <strlcpy+0x2a>
  800814:	0f b6 19             	movzbl (%ecx),%ebx
  800817:	84 db                	test   %bl,%bl
  800819:	75 ec                	jne    800807 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80081b:	c6 00 00             	movb   $0x0,(%eax)
  80081e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800820:	5b                   	pop    %ebx
  800821:	5e                   	pop    %esi
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80082d:	eb 06                	jmp    800835 <strcmp+0x11>
		p++, q++;
  80082f:	83 c1 01             	add    $0x1,%ecx
  800832:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800835:	0f b6 01             	movzbl (%ecx),%eax
  800838:	84 c0                	test   %al,%al
  80083a:	74 04                	je     800840 <strcmp+0x1c>
  80083c:	3a 02                	cmp    (%edx),%al
  80083e:	74 ef                	je     80082f <strcmp+0xb>
  800840:	0f b6 c0             	movzbl %al,%eax
  800843:	0f b6 12             	movzbl (%edx),%edx
  800846:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	53                   	push   %ebx
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800854:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800857:	eb 09                	jmp    800862 <strncmp+0x18>
		n--, p++, q++;
  800859:	83 ea 01             	sub    $0x1,%edx
  80085c:	83 c0 01             	add    $0x1,%eax
  80085f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800862:	85 d2                	test   %edx,%edx
  800864:	75 07                	jne    80086d <strncmp+0x23>
  800866:	b8 00 00 00 00       	mov    $0x0,%eax
  80086b:	eb 13                	jmp    800880 <strncmp+0x36>
  80086d:	0f b6 18             	movzbl (%eax),%ebx
  800870:	84 db                	test   %bl,%bl
  800872:	74 04                	je     800878 <strncmp+0x2e>
  800874:	3a 19                	cmp    (%ecx),%bl
  800876:	74 e1                	je     800859 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800878:	0f b6 00             	movzbl (%eax),%eax
  80087b:	0f b6 11             	movzbl (%ecx),%edx
  80087e:	29 d0                	sub    %edx,%eax
}
  800880:	5b                   	pop    %ebx
  800881:	5d                   	pop    %ebp
  800882:	c3                   	ret    

00800883 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80088d:	eb 07                	jmp    800896 <strchr+0x13>
		if (*s == c)
  80088f:	38 ca                	cmp    %cl,%dl
  800891:	74 0f                	je     8008a2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800893:	83 c0 01             	add    $0x1,%eax
  800896:	0f b6 10             	movzbl (%eax),%edx
  800899:	84 d2                	test   %dl,%dl
  80089b:	75 f2                	jne    80088f <strchr+0xc>
  80089d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8008a2:	5d                   	pop    %ebp
  8008a3:	c3                   	ret    

008008a4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ae:	eb 07                	jmp    8008b7 <strfind+0x13>
		if (*s == c)
  8008b0:	38 ca                	cmp    %cl,%dl
  8008b2:	74 0a                	je     8008be <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008b4:	83 c0 01             	add    $0x1,%eax
  8008b7:	0f b6 10             	movzbl (%eax),%edx
  8008ba:	84 d2                	test   %dl,%dl
  8008bc:	75 f2                	jne    8008b0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	83 ec 0c             	sub    $0xc,%esp
  8008c6:	89 1c 24             	mov    %ebx,(%esp)
  8008c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8008d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008da:	85 c9                	test   %ecx,%ecx
  8008dc:	74 30                	je     80090e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008de:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008e4:	75 25                	jne    80090b <memset+0x4b>
  8008e6:	f6 c1 03             	test   $0x3,%cl
  8008e9:	75 20                	jne    80090b <memset+0x4b>
		c &= 0xFF;
  8008eb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ee:	89 d3                	mov    %edx,%ebx
  8008f0:	c1 e3 08             	shl    $0x8,%ebx
  8008f3:	89 d6                	mov    %edx,%esi
  8008f5:	c1 e6 18             	shl    $0x18,%esi
  8008f8:	89 d0                	mov    %edx,%eax
  8008fa:	c1 e0 10             	shl    $0x10,%eax
  8008fd:	09 f0                	or     %esi,%eax
  8008ff:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800901:	09 d8                	or     %ebx,%eax
  800903:	c1 e9 02             	shr    $0x2,%ecx
  800906:	fc                   	cld    
  800907:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800909:	eb 03                	jmp    80090e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80090b:	fc                   	cld    
  80090c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80090e:	89 f8                	mov    %edi,%eax
  800910:	8b 1c 24             	mov    (%esp),%ebx
  800913:	8b 74 24 04          	mov    0x4(%esp),%esi
  800917:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80091b:	89 ec                	mov    %ebp,%esp
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	89 34 24             	mov    %esi,(%esp)
  800928:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800932:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800935:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800937:	39 c6                	cmp    %eax,%esi
  800939:	73 35                	jae    800970 <memmove+0x51>
  80093b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80093e:	39 d0                	cmp    %edx,%eax
  800940:	73 2e                	jae    800970 <memmove+0x51>
		s += n;
		d += n;
  800942:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800944:	f6 c2 03             	test   $0x3,%dl
  800947:	75 1b                	jne    800964 <memmove+0x45>
  800949:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80094f:	75 13                	jne    800964 <memmove+0x45>
  800951:	f6 c1 03             	test   $0x3,%cl
  800954:	75 0e                	jne    800964 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800956:	83 ef 04             	sub    $0x4,%edi
  800959:	8d 72 fc             	lea    -0x4(%edx),%esi
  80095c:	c1 e9 02             	shr    $0x2,%ecx
  80095f:	fd                   	std    
  800960:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800962:	eb 09                	jmp    80096d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800964:	83 ef 01             	sub    $0x1,%edi
  800967:	8d 72 ff             	lea    -0x1(%edx),%esi
  80096a:	fd                   	std    
  80096b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80096d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80096e:	eb 20                	jmp    800990 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800970:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800976:	75 15                	jne    80098d <memmove+0x6e>
  800978:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80097e:	75 0d                	jne    80098d <memmove+0x6e>
  800980:	f6 c1 03             	test   $0x3,%cl
  800983:	75 08                	jne    80098d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800985:	c1 e9 02             	shr    $0x2,%ecx
  800988:	fc                   	cld    
  800989:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098b:	eb 03                	jmp    800990 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80098d:	fc                   	cld    
  80098e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800990:	8b 34 24             	mov    (%esp),%esi
  800993:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800997:	89 ec                	mov    %ebp,%esp
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	89 04 24             	mov    %eax,(%esp)
  8009b5:	e8 65 ff ff ff       	call   80091f <memmove>
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	57                   	push   %edi
  8009c0:	56                   	push   %esi
  8009c1:	53                   	push   %ebx
  8009c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009cb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009d0:	eb 1c                	jmp    8009ee <memcmp+0x32>
		if (*s1 != *s2)
  8009d2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  8009d6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  8009da:	83 c2 01             	add    $0x1,%edx
  8009dd:	83 e9 01             	sub    $0x1,%ecx
  8009e0:	38 d8                	cmp    %bl,%al
  8009e2:	74 0a                	je     8009ee <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  8009e4:	0f b6 c0             	movzbl %al,%eax
  8009e7:	0f b6 db             	movzbl %bl,%ebx
  8009ea:	29 d8                	sub    %ebx,%eax
  8009ec:	eb 09                	jmp    8009f7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ee:	85 c9                	test   %ecx,%ecx
  8009f0:	75 e0                	jne    8009d2 <memcmp+0x16>
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5e                   	pop    %esi
  8009f9:	5f                   	pop    %edi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a05:	89 c2                	mov    %eax,%edx
  800a07:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a0a:	eb 07                	jmp    800a13 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a0c:	38 08                	cmp    %cl,(%eax)
  800a0e:	74 07                	je     800a17 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a10:	83 c0 01             	add    $0x1,%eax
  800a13:	39 d0                	cmp    %edx,%eax
  800a15:	72 f5                	jb     800a0c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	57                   	push   %edi
  800a1d:	56                   	push   %esi
  800a1e:	53                   	push   %ebx
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	8b 55 08             	mov    0x8(%ebp),%edx
  800a25:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a28:	eb 03                	jmp    800a2d <strtol+0x14>
		s++;
  800a2a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a2d:	0f b6 02             	movzbl (%edx),%eax
  800a30:	3c 20                	cmp    $0x20,%al
  800a32:	74 f6                	je     800a2a <strtol+0x11>
  800a34:	3c 09                	cmp    $0x9,%al
  800a36:	74 f2                	je     800a2a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a38:	3c 2b                	cmp    $0x2b,%al
  800a3a:	75 0c                	jne    800a48 <strtol+0x2f>
		s++;
  800a3c:	8d 52 01             	lea    0x1(%edx),%edx
  800a3f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a46:	eb 15                	jmp    800a5d <strtol+0x44>
	else if (*s == '-')
  800a48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4f:	3c 2d                	cmp    $0x2d,%al
  800a51:	75 0a                	jne    800a5d <strtol+0x44>
		s++, neg = 1;
  800a53:	8d 52 01             	lea    0x1(%edx),%edx
  800a56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a5d:	85 db                	test   %ebx,%ebx
  800a5f:	0f 94 c0             	sete   %al
  800a62:	74 05                	je     800a69 <strtol+0x50>
  800a64:	83 fb 10             	cmp    $0x10,%ebx
  800a67:	75 15                	jne    800a7e <strtol+0x65>
  800a69:	80 3a 30             	cmpb   $0x30,(%edx)
  800a6c:	75 10                	jne    800a7e <strtol+0x65>
  800a6e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a72:	75 0a                	jne    800a7e <strtol+0x65>
		s += 2, base = 16;
  800a74:	83 c2 02             	add    $0x2,%edx
  800a77:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a7c:	eb 13                	jmp    800a91 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a7e:	84 c0                	test   %al,%al
  800a80:	74 0f                	je     800a91 <strtol+0x78>
  800a82:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800a87:	80 3a 30             	cmpb   $0x30,(%edx)
  800a8a:	75 05                	jne    800a91 <strtol+0x78>
		s++, base = 8;
  800a8c:	83 c2 01             	add    $0x1,%edx
  800a8f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a91:	b8 00 00 00 00       	mov    $0x0,%eax
  800a96:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a98:	0f b6 0a             	movzbl (%edx),%ecx
  800a9b:	89 cf                	mov    %ecx,%edi
  800a9d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800aa0:	80 fb 09             	cmp    $0x9,%bl
  800aa3:	77 08                	ja     800aad <strtol+0x94>
			dig = *s - '0';
  800aa5:	0f be c9             	movsbl %cl,%ecx
  800aa8:	83 e9 30             	sub    $0x30,%ecx
  800aab:	eb 1e                	jmp    800acb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800aad:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ab0:	80 fb 19             	cmp    $0x19,%bl
  800ab3:	77 08                	ja     800abd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800ab5:	0f be c9             	movsbl %cl,%ecx
  800ab8:	83 e9 57             	sub    $0x57,%ecx
  800abb:	eb 0e                	jmp    800acb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800abd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ac0:	80 fb 19             	cmp    $0x19,%bl
  800ac3:	77 15                	ja     800ada <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ac5:	0f be c9             	movsbl %cl,%ecx
  800ac8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800acb:	39 f1                	cmp    %esi,%ecx
  800acd:	7d 0b                	jge    800ada <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800acf:	83 c2 01             	add    $0x1,%edx
  800ad2:	0f af c6             	imul   %esi,%eax
  800ad5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ad8:	eb be                	jmp    800a98 <strtol+0x7f>
  800ada:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800adc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae0:	74 05                	je     800ae7 <strtol+0xce>
		*endptr = (char *) s;
  800ae2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ae5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ae7:	89 ca                	mov    %ecx,%edx
  800ae9:	f7 da                	neg    %edx
  800aeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aef:	0f 45 c2             	cmovne %edx,%eax
}
  800af2:	83 c4 04             	add    $0x4,%esp
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5f                   	pop    %edi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    
	...

00800afc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 0c             	sub    $0xc,%esp
  800b02:	89 1c 24             	mov    %ebx,(%esp)
  800b05:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b09:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b12:	b8 01 00 00 00       	mov    $0x1,%eax
  800b17:	89 d1                	mov    %edx,%ecx
  800b19:	89 d3                	mov    %edx,%ebx
  800b1b:	89 d7                	mov    %edx,%edi
  800b1d:	89 d6                	mov    %edx,%esi
  800b1f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b21:	8b 1c 24             	mov    (%esp),%ebx
  800b24:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b28:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b2c:	89 ec                	mov    %ebp,%esp
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	83 ec 0c             	sub    $0xc,%esp
  800b36:	89 1c 24             	mov    %ebx,(%esp)
  800b39:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b3d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
  800b46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	89 c3                	mov    %eax,%ebx
  800b4e:	89 c7                	mov    %eax,%edi
  800b50:	89 c6                	mov    %eax,%esi
  800b52:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b54:	8b 1c 24             	mov    (%esp),%ebx
  800b57:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b5b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b5f:	89 ec                	mov    %ebp,%esp
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 0c             	sub    $0xc,%esp
  800b69:	89 1c 24             	mov    %ebx,(%esp)
  800b6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b70:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
  800b79:	b8 10 00 00 00       	mov    $0x10,%eax
  800b7e:	89 d1                	mov    %edx,%ecx
  800b80:	89 d3                	mov    %edx,%ebx
  800b82:	89 d7                	mov    %edx,%edi
  800b84:	89 d6                	mov    %edx,%esi
  800b86:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800b88:	8b 1c 24             	mov    (%esp),%ebx
  800b8b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b8f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b93:	89 ec                	mov    %ebp,%esp
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	83 ec 38             	sub    $0x38,%esp
  800b9d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ba0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ba3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ba6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bab:	b8 0f 00 00 00       	mov    $0xf,%eax
  800bb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb6:	89 df                	mov    %ebx,%edi
  800bb8:	89 de                	mov    %ebx,%esi
  800bba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bbc:	85 c0                	test   %eax,%eax
  800bbe:	7e 28                	jle    800be8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bc4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800bcb:	00 
  800bcc:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800bd3:	00 
  800bd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bdb:	00 
  800bdc:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800be3:	e8 fc 03 00 00       	call   800fe4 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800be8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800beb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bf1:	89 ec                	mov    %ebp,%esp
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 38             	sub    $0x38,%esp
  800bfb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bfe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c01:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c09:	b8 0e 00 00 00       	mov    $0xe,%eax
  800c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c11:	8b 55 08             	mov    0x8(%ebp),%edx
  800c14:	89 df                	mov    %ebx,%edi
  800c16:	89 de                	mov    %ebx,%esi
  800c18:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	7e 28                	jle    800c46 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c22:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800c29:	00 
  800c2a:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800c31:	00 
  800c32:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c39:	00 
  800c3a:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800c41:	e8 9e 03 00 00       	call   800fe4 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800c46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c49:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c4f:	89 ec                	mov    %ebp,%esp
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 38             	sub    $0x38,%esp
  800c59:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c67:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6f:	89 cb                	mov    %ecx,%ebx
  800c71:	89 cf                	mov    %ecx,%edi
  800c73:	89 ce                	mov    %ecx,%esi
  800c75:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c77:	85 c0                	test   %eax,%eax
  800c79:	7e 28                	jle    800ca3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c7f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800c86:	00 
  800c87:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800c8e:	00 
  800c8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c96:	00 
  800c97:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800c9e:	e8 41 03 00 00       	call   800fe4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ca3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ca6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ca9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cac:	89 ec                	mov    %ebp,%esp
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 0c             	sub    $0xc,%esp
  800cb6:	89 1c 24             	mov    %ebx,(%esp)
  800cb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cbd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc1:	be 00 00 00 00       	mov    $0x0,%esi
  800cc6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ccb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cd9:	8b 1c 24             	mov    (%esp),%ebx
  800cdc:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ce0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ce4:	89 ec                	mov    %ebp,%esp
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 38             	sub    $0x38,%esp
  800cee:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cf1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cf4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	89 df                	mov    %ebx,%edi
  800d09:	89 de                	mov    %ebx,%esi
  800d0b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	7e 28                	jle    800d39 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d11:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d15:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d1c:	00 
  800d1d:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800d24:	00 
  800d25:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d2c:	00 
  800d2d:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800d34:	e8 ab 02 00 00       	call   800fe4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d39:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d3c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d3f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d42:	89 ec                	mov    %ebp,%esp
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 38             	sub    $0x38,%esp
  800d4c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d4f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d52:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	89 df                	mov    %ebx,%edi
  800d67:	89 de                	mov    %ebx,%esi
  800d69:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	7e 28                	jle    800d97 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d73:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d7a:	00 
  800d7b:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800d82:	00 
  800d83:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8a:	00 
  800d8b:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800d92:	e8 4d 02 00 00       	call   800fe4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d97:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d9a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d9d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800da0:	89 ec                	mov    %ebp,%esp
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 38             	sub    $0x38,%esp
  800daa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dad:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800db0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	b8 08 00 00 00       	mov    $0x8,%eax
  800dbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7e 28                	jle    800df5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dd8:	00 
  800dd9:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800de0:	00 
  800de1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de8:	00 
  800de9:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800df0:	e8 ef 01 00 00       	call   800fe4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800df5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800df8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dfb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dfe:	89 ec                	mov    %ebp,%esp
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 38             	sub    $0x38,%esp
  800e08:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e0b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e0e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e16:	b8 06 00 00 00       	mov    $0x6,%eax
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	89 df                	mov    %ebx,%edi
  800e23:	89 de                	mov    %ebx,%esi
  800e25:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e27:	85 c0                	test   %eax,%eax
  800e29:	7e 28                	jle    800e53 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e2f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e36:	00 
  800e37:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800e3e:	00 
  800e3f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e46:	00 
  800e47:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800e4e:	e8 91 01 00 00       	call   800fe4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e53:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e56:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e59:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e5c:	89 ec                	mov    %ebp,%esp
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 38             	sub    $0x38,%esp
  800e66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800e74:	8b 75 18             	mov    0x18(%ebp),%esi
  800e77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	7e 28                	jle    800eb1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e89:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e94:	00 
  800e95:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800e9c:	00 
  800e9d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea4:	00 
  800ea5:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800eac:	e8 33 01 00 00       	call   800fe4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eb1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eb4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eb7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eba:	89 ec                	mov    %ebp,%esp
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    

00800ebe <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 38             	sub    $0x38,%esp
  800ec4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ec7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eca:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecd:	be 00 00 00 00       	mov    $0x0,%esi
  800ed2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ed7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	89 f7                	mov    %esi,%edi
  800ee2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	7e 28                	jle    800f10 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eec:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800efb:	00 
  800efc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f03:	00 
  800f04:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800f0b:	e8 d4 00 00 00       	call   800fe4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f10:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f13:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f16:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f19:	89 ec                	mov    %ebp,%esp
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    

00800f1d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	83 ec 0c             	sub    $0xc,%esp
  800f23:	89 1c 24             	mov    %ebx,(%esp)
  800f26:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f2a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f33:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f38:	89 d1                	mov    %edx,%ecx
  800f3a:	89 d3                	mov    %edx,%ebx
  800f3c:	89 d7                	mov    %edx,%edi
  800f3e:	89 d6                	mov    %edx,%esi
  800f40:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f42:	8b 1c 24             	mov    (%esp),%ebx
  800f45:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f49:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f4d:	89 ec                	mov    %ebp,%esp
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 0c             	sub    $0xc,%esp
  800f57:	89 1c 24             	mov    %ebx,(%esp)
  800f5a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	ba 00 00 00 00       	mov    $0x0,%edx
  800f67:	b8 02 00 00 00       	mov    $0x2,%eax
  800f6c:	89 d1                	mov    %edx,%ecx
  800f6e:	89 d3                	mov    %edx,%ebx
  800f70:	89 d7                	mov    %edx,%edi
  800f72:	89 d6                	mov    %edx,%esi
  800f74:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f76:	8b 1c 24             	mov    (%esp),%ebx
  800f79:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f7d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f81:	89 ec                	mov    %ebp,%esp
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 38             	sub    $0x38,%esp
  800f8b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f8e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f91:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f99:	b8 03 00 00 00       	mov    $0x3,%eax
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	89 cb                	mov    %ecx,%ebx
  800fa3:	89 cf                	mov    %ecx,%edi
  800fa5:	89 ce                	mov    %ecx,%esi
  800fa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	7e 28                	jle    800fd5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800fb8:	00 
  800fb9:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800fc0:	00 
  800fc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc8:	00 
  800fc9:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800fd0:	e8 0f 00 00 00       	call   800fe4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fd5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fd8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fdb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fde:	89 ec                	mov    %ebp,%esp
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    
	...

00800fe4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	56                   	push   %esi
  800fe8:	53                   	push   %ebx
  800fe9:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800fec:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fef:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  800ff5:	e8 57 ff ff ff       	call   800f51 <sys_getenvid>
  800ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffd:	89 54 24 10          	mov    %edx,0x10(%esp)
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801008:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80100c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801010:	c7 04 24 34 16 80 00 	movl   $0x801634,(%esp)
  801017:	e8 fd f0 ff ff       	call   800119 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80101c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801020:	8b 45 10             	mov    0x10(%ebp),%eax
  801023:	89 04 24             	mov    %eax,(%esp)
  801026:	e8 8d f0 ff ff       	call   8000b8 <vcprintf>
	cprintf("\n");
  80102b:	c7 04 24 58 16 80 00 	movl   $0x801658,(%esp)
  801032:	e8 e2 f0 ff ff       	call   800119 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801037:	cc                   	int3   
  801038:	eb fd                	jmp    801037 <_panic+0x53>
  80103a:	00 00                	add    %al,(%eax)
  80103c:	00 00                	add    %al,(%eax)
	...

00801040 <__udivdi3>:
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	57                   	push   %edi
  801044:	56                   	push   %esi
  801045:	83 ec 10             	sub    $0x10,%esp
  801048:	8b 45 14             	mov    0x14(%ebp),%eax
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	8b 75 10             	mov    0x10(%ebp),%esi
  801051:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801054:	85 c0                	test   %eax,%eax
  801056:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801059:	75 35                	jne    801090 <__udivdi3+0x50>
  80105b:	39 fe                	cmp    %edi,%esi
  80105d:	77 61                	ja     8010c0 <__udivdi3+0x80>
  80105f:	85 f6                	test   %esi,%esi
  801061:	75 0b                	jne    80106e <__udivdi3+0x2e>
  801063:	b8 01 00 00 00       	mov    $0x1,%eax
  801068:	31 d2                	xor    %edx,%edx
  80106a:	f7 f6                	div    %esi
  80106c:	89 c6                	mov    %eax,%esi
  80106e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801071:	31 d2                	xor    %edx,%edx
  801073:	89 f8                	mov    %edi,%eax
  801075:	f7 f6                	div    %esi
  801077:	89 c7                	mov    %eax,%edi
  801079:	89 c8                	mov    %ecx,%eax
  80107b:	f7 f6                	div    %esi
  80107d:	89 c1                	mov    %eax,%ecx
  80107f:	89 fa                	mov    %edi,%edx
  801081:	89 c8                	mov    %ecx,%eax
  801083:	83 c4 10             	add    $0x10,%esp
  801086:	5e                   	pop    %esi
  801087:	5f                   	pop    %edi
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    
  80108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801090:	39 f8                	cmp    %edi,%eax
  801092:	77 1c                	ja     8010b0 <__udivdi3+0x70>
  801094:	0f bd d0             	bsr    %eax,%edx
  801097:	83 f2 1f             	xor    $0x1f,%edx
  80109a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80109d:	75 39                	jne    8010d8 <__udivdi3+0x98>
  80109f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8010a2:	0f 86 a0 00 00 00    	jbe    801148 <__udivdi3+0x108>
  8010a8:	39 f8                	cmp    %edi,%eax
  8010aa:	0f 82 98 00 00 00    	jb     801148 <__udivdi3+0x108>
  8010b0:	31 ff                	xor    %edi,%edi
  8010b2:	31 c9                	xor    %ecx,%ecx
  8010b4:	89 c8                	mov    %ecx,%eax
  8010b6:	89 fa                	mov    %edi,%edx
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	5e                   	pop    %esi
  8010bc:	5f                   	pop    %edi
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    
  8010bf:	90                   	nop
  8010c0:	89 d1                	mov    %edx,%ecx
  8010c2:	89 fa                	mov    %edi,%edx
  8010c4:	89 c8                	mov    %ecx,%eax
  8010c6:	31 ff                	xor    %edi,%edi
  8010c8:	f7 f6                	div    %esi
  8010ca:	89 c1                	mov    %eax,%ecx
  8010cc:	89 fa                	mov    %edi,%edx
  8010ce:	89 c8                	mov    %ecx,%eax
  8010d0:	83 c4 10             	add    $0x10,%esp
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    
  8010d7:	90                   	nop
  8010d8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8010dc:	89 f2                	mov    %esi,%edx
  8010de:	d3 e0                	shl    %cl,%eax
  8010e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e3:	b8 20 00 00 00       	mov    $0x20,%eax
  8010e8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8010eb:	89 c1                	mov    %eax,%ecx
  8010ed:	d3 ea                	shr    %cl,%edx
  8010ef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8010f3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8010f6:	d3 e6                	shl    %cl,%esi
  8010f8:	89 c1                	mov    %eax,%ecx
  8010fa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8010fd:	89 fe                	mov    %edi,%esi
  8010ff:	d3 ee                	shr    %cl,%esi
  801101:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801105:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801108:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80110b:	d3 e7                	shl    %cl,%edi
  80110d:	89 c1                	mov    %eax,%ecx
  80110f:	d3 ea                	shr    %cl,%edx
  801111:	09 d7                	or     %edx,%edi
  801113:	89 f2                	mov    %esi,%edx
  801115:	89 f8                	mov    %edi,%eax
  801117:	f7 75 ec             	divl   -0x14(%ebp)
  80111a:	89 d6                	mov    %edx,%esi
  80111c:	89 c7                	mov    %eax,%edi
  80111e:	f7 65 e8             	mull   -0x18(%ebp)
  801121:	39 d6                	cmp    %edx,%esi
  801123:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801126:	72 30                	jb     801158 <__udivdi3+0x118>
  801128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80112f:	d3 e2                	shl    %cl,%edx
  801131:	39 c2                	cmp    %eax,%edx
  801133:	73 05                	jae    80113a <__udivdi3+0xfa>
  801135:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801138:	74 1e                	je     801158 <__udivdi3+0x118>
  80113a:	89 f9                	mov    %edi,%ecx
  80113c:	31 ff                	xor    %edi,%edi
  80113e:	e9 71 ff ff ff       	jmp    8010b4 <__udivdi3+0x74>
  801143:	90                   	nop
  801144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801148:	31 ff                	xor    %edi,%edi
  80114a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80114f:	e9 60 ff ff ff       	jmp    8010b4 <__udivdi3+0x74>
  801154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801158:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80115b:	31 ff                	xor    %edi,%edi
  80115d:	89 c8                	mov    %ecx,%eax
  80115f:	89 fa                	mov    %edi,%edx
  801161:	83 c4 10             	add    $0x10,%esp
  801164:	5e                   	pop    %esi
  801165:	5f                   	pop    %edi
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    
	...

00801170 <__umoddi3>:
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	83 ec 20             	sub    $0x20,%esp
  801178:	8b 55 14             	mov    0x14(%ebp),%edx
  80117b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80117e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801181:	8b 75 0c             	mov    0xc(%ebp),%esi
  801184:	85 d2                	test   %edx,%edx
  801186:	89 c8                	mov    %ecx,%eax
  801188:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80118b:	75 13                	jne    8011a0 <__umoddi3+0x30>
  80118d:	39 f7                	cmp    %esi,%edi
  80118f:	76 3f                	jbe    8011d0 <__umoddi3+0x60>
  801191:	89 f2                	mov    %esi,%edx
  801193:	f7 f7                	div    %edi
  801195:	89 d0                	mov    %edx,%eax
  801197:	31 d2                	xor    %edx,%edx
  801199:	83 c4 20             	add    $0x20,%esp
  80119c:	5e                   	pop    %esi
  80119d:	5f                   	pop    %edi
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    
  8011a0:	39 f2                	cmp    %esi,%edx
  8011a2:	77 4c                	ja     8011f0 <__umoddi3+0x80>
  8011a4:	0f bd ca             	bsr    %edx,%ecx
  8011a7:	83 f1 1f             	xor    $0x1f,%ecx
  8011aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8011ad:	75 51                	jne    801200 <__umoddi3+0x90>
  8011af:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8011b2:	0f 87 e0 00 00 00    	ja     801298 <__umoddi3+0x128>
  8011b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bb:	29 f8                	sub    %edi,%eax
  8011bd:	19 d6                	sbb    %edx,%esi
  8011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c5:	89 f2                	mov    %esi,%edx
  8011c7:	83 c4 20             	add    $0x20,%esp
  8011ca:	5e                   	pop    %esi
  8011cb:	5f                   	pop    %edi
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    
  8011ce:	66 90                	xchg   %ax,%ax
  8011d0:	85 ff                	test   %edi,%edi
  8011d2:	75 0b                	jne    8011df <__umoddi3+0x6f>
  8011d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8011d9:	31 d2                	xor    %edx,%edx
  8011db:	f7 f7                	div    %edi
  8011dd:	89 c7                	mov    %eax,%edi
  8011df:	89 f0                	mov    %esi,%eax
  8011e1:	31 d2                	xor    %edx,%edx
  8011e3:	f7 f7                	div    %edi
  8011e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e8:	f7 f7                	div    %edi
  8011ea:	eb a9                	jmp    801195 <__umoddi3+0x25>
  8011ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8011f0:	89 c8                	mov    %ecx,%eax
  8011f2:	89 f2                	mov    %esi,%edx
  8011f4:	83 c4 20             	add    $0x20,%esp
  8011f7:	5e                   	pop    %esi
  8011f8:	5f                   	pop    %edi
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    
  8011fb:	90                   	nop
  8011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801200:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801204:	d3 e2                	shl    %cl,%edx
  801206:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801209:	ba 20 00 00 00       	mov    $0x20,%edx
  80120e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801211:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801214:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801218:	89 fa                	mov    %edi,%edx
  80121a:	d3 ea                	shr    %cl,%edx
  80121c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801220:	0b 55 f4             	or     -0xc(%ebp),%edx
  801223:	d3 e7                	shl    %cl,%edi
  801225:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801229:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80122c:	89 f2                	mov    %esi,%edx
  80122e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801231:	89 c7                	mov    %eax,%edi
  801233:	d3 ea                	shr    %cl,%edx
  801235:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80123c:	89 c2                	mov    %eax,%edx
  80123e:	d3 e6                	shl    %cl,%esi
  801240:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801244:	d3 ea                	shr    %cl,%edx
  801246:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80124a:	09 d6                	or     %edx,%esi
  80124c:	89 f0                	mov    %esi,%eax
  80124e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801251:	d3 e7                	shl    %cl,%edi
  801253:	89 f2                	mov    %esi,%edx
  801255:	f7 75 f4             	divl   -0xc(%ebp)
  801258:	89 d6                	mov    %edx,%esi
  80125a:	f7 65 e8             	mull   -0x18(%ebp)
  80125d:	39 d6                	cmp    %edx,%esi
  80125f:	72 2b                	jb     80128c <__umoddi3+0x11c>
  801261:	39 c7                	cmp    %eax,%edi
  801263:	72 23                	jb     801288 <__umoddi3+0x118>
  801265:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801269:	29 c7                	sub    %eax,%edi
  80126b:	19 d6                	sbb    %edx,%esi
  80126d:	89 f0                	mov    %esi,%eax
  80126f:	89 f2                	mov    %esi,%edx
  801271:	d3 ef                	shr    %cl,%edi
  801273:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801277:	d3 e0                	shl    %cl,%eax
  801279:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80127d:	09 f8                	or     %edi,%eax
  80127f:	d3 ea                	shr    %cl,%edx
  801281:	83 c4 20             	add    $0x20,%esp
  801284:	5e                   	pop    %esi
  801285:	5f                   	pop    %edi
  801286:	5d                   	pop    %ebp
  801287:	c3                   	ret    
  801288:	39 d6                	cmp    %edx,%esi
  80128a:	75 d9                	jne    801265 <__umoddi3+0xf5>
  80128c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80128f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801292:	eb d1                	jmp    801265 <__umoddi3+0xf5>
  801294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801298:	39 f2                	cmp    %esi,%edx
  80129a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012a0:	0f 82 12 ff ff ff    	jb     8011b8 <__umoddi3+0x48>
  8012a6:	e9 17 ff ff ff       	jmp    8011c2 <__umoddi3+0x52>
