
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 37 00 00 00       	call   800068 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	zero = 0;
  80003a:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800041:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800044:	ba 01 00 00 00       	mov    $0x1,%edx
  800049:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004e:	89 d0                	mov    %edx,%eax
  800050:	c1 fa 1f             	sar    $0x1f,%edx
  800053:	f7 f9                	idiv   %ecx
  800055:	89 44 24 04          	mov    %eax,0x4(%esp)
  800059:	c7 04 24 e0 12 80 00 	movl   $0x8012e0,(%esp)
  800060:	e8 c8 00 00 00       	call   80012d <cprintf>
}
  800065:	c9                   	leave  
  800066:	c3                   	ret    
	...

00800068 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800068:	55                   	push   %ebp
  800069:	89 e5                	mov    %esp,%ebp
  80006b:	83 ec 18             	sub    $0x18,%esp
  80006e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800071:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800074:	8b 75 08             	mov    0x8(%ebp),%esi
  800077:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80007a:	e8 f2 0e 00 00       	call   800f71 <sys_getenvid>
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800087:	2d 00 00 40 11       	sub    $0x11400000,%eax
  80008c:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800091:	85 f6                	test   %esi,%esi
  800093:	7e 07                	jle    80009c <libmain+0x34>
		binaryname = argv[0];
  800095:	8b 03                	mov    (%ebx),%eax
  800097:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80009c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a0:	89 34 24             	mov    %esi,(%esp)
  8000a3:	e8 8c ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000a8:	e8 0b 00 00 00       	call   8000b8 <exit>
}
  8000ad:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000b0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000b3:	89 ec                	mov    %ebp,%esp
  8000b5:	5d                   	pop    %ebp
  8000b6:	c3                   	ret    
	...

008000b8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8000be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000c5:	e8 db 0e 00 00       	call   800fa5 <sys_env_destroy>
}
  8000ca:	c9                   	leave  
  8000cb:	c3                   	ret    

008000cc <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8000d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000dc:	00 00 00 
	b.cnt = 0;
  8000df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	c7 04 24 47 01 80 00 	movl   $0x800147,(%esp)
  800108:	e8 be 01 00 00       	call   8002cb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80010d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800113:	89 44 24 04          	mov    %eax,0x4(%esp)
  800117:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80011d:	89 04 24             	mov    %eax,(%esp)
  800120:	e8 2b 0a 00 00       	call   800b50 <sys_cputs>

	return b.cnt;
}
  800125:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80012b:	c9                   	leave  
  80012c:	c3                   	ret    

0080012d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800133:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013a:	8b 45 08             	mov    0x8(%ebp),%eax
  80013d:	89 04 24             	mov    %eax,(%esp)
  800140:	e8 87 ff ff ff       	call   8000cc <vcprintf>
	va_end(ap);

	return cnt;
}
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	53                   	push   %ebx
  80014b:	83 ec 14             	sub    $0x14,%esp
  80014e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800151:	8b 03                	mov    (%ebx),%eax
  800153:	8b 55 08             	mov    0x8(%ebp),%edx
  800156:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80015a:	83 c0 01             	add    $0x1,%eax
  80015d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80015f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800164:	75 19                	jne    80017f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800166:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80016d:	00 
  80016e:	8d 43 08             	lea    0x8(%ebx),%eax
  800171:	89 04 24             	mov    %eax,(%esp)
  800174:	e8 d7 09 00 00       	call   800b50 <sys_cputs>
		b->idx = 0;
  800179:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80017f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800183:	83 c4 14             	add    $0x14,%esp
  800186:	5b                   	pop    %ebx
  800187:	5d                   	pop    %ebp
  800188:	c3                   	ret    
  800189:	00 00                	add    %al,(%eax)
	...

0080018c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	57                   	push   %edi
  800190:	56                   	push   %esi
  800191:	53                   	push   %ebx
  800192:	83 ec 4c             	sub    $0x4c,%esp
  800195:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800198:	89 d6                	mov    %edx,%esi
  80019a:	8b 45 08             	mov    0x8(%ebp),%eax
  80019d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8001a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001ac:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b7:	39 d1                	cmp    %edx,%ecx
  8001b9:	72 07                	jb     8001c2 <printnum+0x36>
  8001bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001be:	39 d0                	cmp    %edx,%eax
  8001c0:	77 69                	ja     80022b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001c2:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8001c6:	83 eb 01             	sub    $0x1,%ebx
  8001c9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d1:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8001d5:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8001d9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8001dc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8001df:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001e6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001ed:	00 
  8001ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001f1:	89 04 24             	mov    %eax,(%esp)
  8001f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001fb:	e8 60 0e 00 00       	call   801060 <__udivdi3>
  800200:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800203:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800206:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80020a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80020e:	89 04 24             	mov    %eax,(%esp)
  800211:	89 54 24 04          	mov    %edx,0x4(%esp)
  800215:	89 f2                	mov    %esi,%edx
  800217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80021a:	e8 6d ff ff ff       	call   80018c <printnum>
  80021f:	eb 11                	jmp    800232 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800221:	89 74 24 04          	mov    %esi,0x4(%esp)
  800225:	89 3c 24             	mov    %edi,(%esp)
  800228:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80022b:	83 eb 01             	sub    $0x1,%ebx
  80022e:	85 db                	test   %ebx,%ebx
  800230:	7f ef                	jg     800221 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800232:	89 74 24 04          	mov    %esi,0x4(%esp)
  800236:	8b 74 24 04          	mov    0x4(%esp),%esi
  80023a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800241:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800248:	00 
  800249:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80024c:	89 14 24             	mov    %edx,(%esp)
  80024f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800252:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800256:	e8 35 0f 00 00       	call   801190 <__umoddi3>
  80025b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80025f:	0f be 80 f8 12 80 00 	movsbl 0x8012f8(%eax),%eax
  800266:	89 04 24             	mov    %eax,(%esp)
  800269:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80026c:	83 c4 4c             	add    $0x4c,%esp
  80026f:	5b                   	pop    %ebx
  800270:	5e                   	pop    %esi
  800271:	5f                   	pop    %edi
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    

00800274 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800277:	83 fa 01             	cmp    $0x1,%edx
  80027a:	7e 0e                	jle    80028a <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80027c:	8b 10                	mov    (%eax),%edx
  80027e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800281:	89 08                	mov    %ecx,(%eax)
  800283:	8b 02                	mov    (%edx),%eax
  800285:	8b 52 04             	mov    0x4(%edx),%edx
  800288:	eb 22                	jmp    8002ac <getuint+0x38>
	else if (lflag)
  80028a:	85 d2                	test   %edx,%edx
  80028c:	74 10                	je     80029e <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80028e:	8b 10                	mov    (%eax),%edx
  800290:	8d 4a 04             	lea    0x4(%edx),%ecx
  800293:	89 08                	mov    %ecx,(%eax)
  800295:	8b 02                	mov    (%edx),%eax
  800297:	ba 00 00 00 00       	mov    $0x0,%edx
  80029c:	eb 0e                	jmp    8002ac <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80029e:	8b 10                	mov    (%eax),%edx
  8002a0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002a3:	89 08                	mov    %ecx,(%eax)
  8002a5:	8b 02                	mov    (%edx),%eax
  8002a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    

008002ae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b8:	8b 10                	mov    (%eax),%edx
  8002ba:	3b 50 04             	cmp    0x4(%eax),%edx
  8002bd:	73 0a                	jae    8002c9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c2:	88 0a                	mov    %cl,(%edx)
  8002c4:	83 c2 01             	add    $0x1,%edx
  8002c7:	89 10                	mov    %edx,(%eax)
}
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    

008002cb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	57                   	push   %edi
  8002cf:	56                   	push   %esi
  8002d0:	53                   	push   %ebx
  8002d1:	83 ec 4c             	sub    $0x4c,%esp
  8002d4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002da:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8002dd:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8002e4:	eb 11                	jmp    8002f7 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	0f 84 b6 03 00 00    	je     8006a4 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8002ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002f7:	0f b6 03             	movzbl (%ebx),%eax
  8002fa:	83 c3 01             	add    $0x1,%ebx
  8002fd:	83 f8 25             	cmp    $0x25,%eax
  800300:	75 e4                	jne    8002e6 <vprintfmt+0x1b>
  800302:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800306:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80030d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800314:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80031b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800320:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800323:	eb 06                	jmp    80032b <vprintfmt+0x60>
  800325:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800329:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80032b:	0f b6 0b             	movzbl (%ebx),%ecx
  80032e:	0f b6 c1             	movzbl %cl,%eax
  800331:	8d 53 01             	lea    0x1(%ebx),%edx
  800334:	83 e9 23             	sub    $0x23,%ecx
  800337:	80 f9 55             	cmp    $0x55,%cl
  80033a:	0f 87 47 03 00 00    	ja     800687 <vprintfmt+0x3bc>
  800340:	0f b6 c9             	movzbl %cl,%ecx
  800343:	ff 24 8d 40 14 80 00 	jmp    *0x801440(,%ecx,4)
  80034a:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80034e:	eb d9                	jmp    800329 <vprintfmt+0x5e>
  800350:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800357:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80035c:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80035f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800363:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800366:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800369:	83 fb 09             	cmp    $0x9,%ebx
  80036c:	77 30                	ja     80039e <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80036e:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800371:	eb e9                	jmp    80035c <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800373:	8b 45 14             	mov    0x14(%ebp),%eax
  800376:	8d 48 04             	lea    0x4(%eax),%ecx
  800379:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80037c:	8b 00                	mov    (%eax),%eax
  80037e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800381:	eb 1e                	jmp    8003a1 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800387:	b8 00 00 00 00       	mov    $0x0,%eax
  80038c:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800390:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800393:	eb 94                	jmp    800329 <vprintfmt+0x5e>
  800395:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80039c:	eb 8b                	jmp    800329 <vprintfmt+0x5e>
  80039e:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8003a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003a5:	79 82                	jns    800329 <vprintfmt+0x5e>
  8003a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ad:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8003b0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8003b3:	e9 71 ff ff ff       	jmp    800329 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003b8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003bc:	e9 68 ff ff ff       	jmp    800329 <vprintfmt+0x5e>
  8003c1:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	8d 50 04             	lea    0x4(%eax),%edx
  8003ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8003cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 04 24             	mov    %eax,(%esp)
  8003d6:	ff d7                	call   *%edi
  8003d8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8003db:	e9 17 ff ff ff       	jmp    8002f7 <vprintfmt+0x2c>
  8003e0:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e6:	8d 50 04             	lea    0x4(%eax),%edx
  8003e9:	89 55 14             	mov    %edx,0x14(%ebp)
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	89 c2                	mov    %eax,%edx
  8003f0:	c1 fa 1f             	sar    $0x1f,%edx
  8003f3:	31 d0                	xor    %edx,%eax
  8003f5:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003f7:	83 f8 11             	cmp    $0x11,%eax
  8003fa:	7f 0b                	jg     800407 <vprintfmt+0x13c>
  8003fc:	8b 14 85 a0 15 80 00 	mov    0x8015a0(,%eax,4),%edx
  800403:	85 d2                	test   %edx,%edx
  800405:	75 20                	jne    800427 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800407:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80040b:	c7 44 24 08 09 13 80 	movl   $0x801309,0x8(%esp)
  800412:	00 
  800413:	89 74 24 04          	mov    %esi,0x4(%esp)
  800417:	89 3c 24             	mov    %edi,(%esp)
  80041a:	e8 0d 03 00 00       	call   80072c <printfmt>
  80041f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800422:	e9 d0 fe ff ff       	jmp    8002f7 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800427:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80042b:	c7 44 24 08 12 13 80 	movl   $0x801312,0x8(%esp)
  800432:	00 
  800433:	89 74 24 04          	mov    %esi,0x4(%esp)
  800437:	89 3c 24             	mov    %edi,(%esp)
  80043a:	e8 ed 02 00 00       	call   80072c <printfmt>
  80043f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800442:	e9 b0 fe ff ff       	jmp    8002f7 <vprintfmt+0x2c>
  800447:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80044a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800450:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800453:	8b 45 14             	mov    0x14(%ebp),%eax
  800456:	8d 50 04             	lea    0x4(%eax),%edx
  800459:	89 55 14             	mov    %edx,0x14(%ebp)
  80045c:	8b 18                	mov    (%eax),%ebx
  80045e:	85 db                	test   %ebx,%ebx
  800460:	b8 15 13 80 00       	mov    $0x801315,%eax
  800465:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800468:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80046c:	7e 76                	jle    8004e4 <vprintfmt+0x219>
  80046e:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800472:	74 7a                	je     8004ee <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800474:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800478:	89 1c 24             	mov    %ebx,(%esp)
  80047b:	e8 f8 02 00 00       	call   800778 <strnlen>
  800480:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800483:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800485:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800489:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80048c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80048f:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800491:	eb 0f                	jmp    8004a2 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800493:	89 74 24 04          	mov    %esi,0x4(%esp)
  800497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80049a:	89 04 24             	mov    %eax,(%esp)
  80049d:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80049f:	83 eb 01             	sub    $0x1,%ebx
  8004a2:	85 db                	test   %ebx,%ebx
  8004a4:	7f ed                	jg     800493 <vprintfmt+0x1c8>
  8004a6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8004a9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004ac:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004af:	89 f7                	mov    %esi,%edi
  8004b1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004b4:	eb 40                	jmp    8004f6 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004b6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ba:	74 18                	je     8004d4 <vprintfmt+0x209>
  8004bc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8004bf:	83 fa 5e             	cmp    $0x5e,%edx
  8004c2:	76 10                	jbe    8004d4 <vprintfmt+0x209>
					putch('?', putdat);
  8004c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004c8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8004cf:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004d2:	eb 0a                	jmp    8004de <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8004d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004d8:	89 04 24             	mov    %eax,(%esp)
  8004db:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004de:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8004e2:	eb 12                	jmp    8004f6 <vprintfmt+0x22b>
  8004e4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004e7:	89 f7                	mov    %esi,%edi
  8004e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004ec:	eb 08                	jmp    8004f6 <vprintfmt+0x22b>
  8004ee:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004f1:	89 f7                	mov    %esi,%edi
  8004f3:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004f6:	0f be 03             	movsbl (%ebx),%eax
  8004f9:	83 c3 01             	add    $0x1,%ebx
  8004fc:	85 c0                	test   %eax,%eax
  8004fe:	74 25                	je     800525 <vprintfmt+0x25a>
  800500:	85 f6                	test   %esi,%esi
  800502:	78 b2                	js     8004b6 <vprintfmt+0x1eb>
  800504:	83 ee 01             	sub    $0x1,%esi
  800507:	79 ad                	jns    8004b6 <vprintfmt+0x1eb>
  800509:	89 fe                	mov    %edi,%esi
  80050b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80050e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800511:	eb 1a                	jmp    80052d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800513:	89 74 24 04          	mov    %esi,0x4(%esp)
  800517:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80051e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800520:	83 eb 01             	sub    $0x1,%ebx
  800523:	eb 08                	jmp    80052d <vprintfmt+0x262>
  800525:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800528:	89 fe                	mov    %edi,%esi
  80052a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80052d:	85 db                	test   %ebx,%ebx
  80052f:	7f e2                	jg     800513 <vprintfmt+0x248>
  800531:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800534:	e9 be fd ff ff       	jmp    8002f7 <vprintfmt+0x2c>
  800539:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80053c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80053f:	83 f9 01             	cmp    $0x1,%ecx
  800542:	7e 16                	jle    80055a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 50 08             	lea    0x8(%eax),%edx
  80054a:	89 55 14             	mov    %edx,0x14(%ebp)
  80054d:	8b 10                	mov    (%eax),%edx
  80054f:	8b 48 04             	mov    0x4(%eax),%ecx
  800552:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800555:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800558:	eb 32                	jmp    80058c <vprintfmt+0x2c1>
	else if (lflag)
  80055a:	85 c9                	test   %ecx,%ecx
  80055c:	74 18                	je     800576 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8d 50 04             	lea    0x4(%eax),%edx
  800564:	89 55 14             	mov    %edx,0x14(%ebp)
  800567:	8b 00                	mov    (%eax),%eax
  800569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056c:	89 c1                	mov    %eax,%ecx
  80056e:	c1 f9 1f             	sar    $0x1f,%ecx
  800571:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800574:	eb 16                	jmp    80058c <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800576:	8b 45 14             	mov    0x14(%ebp),%eax
  800579:	8d 50 04             	lea    0x4(%eax),%edx
  80057c:	89 55 14             	mov    %edx,0x14(%ebp)
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800584:	89 c2                	mov    %eax,%edx
  800586:	c1 fa 1f             	sar    $0x1f,%edx
  800589:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80058c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80058f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800592:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800597:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80059b:	0f 89 a7 00 00 00    	jns    800648 <vprintfmt+0x37d>
				putch('-', putdat);
  8005a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005a5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005ac:	ff d7                	call   *%edi
				num = -(long long) num;
  8005ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005b1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005b4:	f7 d9                	neg    %ecx
  8005b6:	83 d3 00             	adc    $0x0,%ebx
  8005b9:	f7 db                	neg    %ebx
  8005bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c0:	e9 83 00 00 00       	jmp    800648 <vprintfmt+0x37d>
  8005c5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005c8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005cb:	89 ca                	mov    %ecx,%edx
  8005cd:	8d 45 14             	lea    0x14(%ebp),%eax
  8005d0:	e8 9f fc ff ff       	call   800274 <getuint>
  8005d5:	89 c1                	mov    %eax,%ecx
  8005d7:	89 d3                	mov    %edx,%ebx
  8005d9:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8005de:	eb 68                	jmp    800648 <vprintfmt+0x37d>
  8005e0:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005e3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8005e6:	89 ca                	mov    %ecx,%edx
  8005e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8005eb:	e8 84 fc ff ff       	call   800274 <getuint>
  8005f0:	89 c1                	mov    %eax,%ecx
  8005f2:	89 d3                	mov    %edx,%ebx
  8005f4:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8005f9:	eb 4d                	jmp    800648 <vprintfmt+0x37d>
  8005fb:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8005fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800602:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800609:	ff d7                	call   *%edi
			putch('x', putdat);
  80060b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800616:	ff d7                	call   *%edi
			num = (unsigned long long)
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 50 04             	lea    0x4(%eax),%edx
  80061e:	89 55 14             	mov    %edx,0x14(%ebp)
  800621:	8b 08                	mov    (%eax),%ecx
  800623:	bb 00 00 00 00       	mov    $0x0,%ebx
  800628:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80062d:	eb 19                	jmp    800648 <vprintfmt+0x37d>
  80062f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800632:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800635:	89 ca                	mov    %ecx,%edx
  800637:	8d 45 14             	lea    0x14(%ebp),%eax
  80063a:	e8 35 fc ff ff       	call   800274 <getuint>
  80063f:	89 c1                	mov    %eax,%ecx
  800641:	89 d3                	mov    %edx,%ebx
  800643:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800648:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  80064c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800650:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800653:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800657:	89 44 24 08          	mov    %eax,0x8(%esp)
  80065b:	89 0c 24             	mov    %ecx,(%esp)
  80065e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800662:	89 f2                	mov    %esi,%edx
  800664:	89 f8                	mov    %edi,%eax
  800666:	e8 21 fb ff ff       	call   80018c <printnum>
  80066b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80066e:	e9 84 fc ff ff       	jmp    8002f7 <vprintfmt+0x2c>
  800673:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800676:	89 74 24 04          	mov    %esi,0x4(%esp)
  80067a:	89 04 24             	mov    %eax,(%esp)
  80067d:	ff d7                	call   *%edi
  80067f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800682:	e9 70 fc ff ff       	jmp    8002f7 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800687:	89 74 24 04          	mov    %esi,0x4(%esp)
  80068b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800692:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800694:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800697:	80 38 25             	cmpb   $0x25,(%eax)
  80069a:	0f 84 57 fc ff ff    	je     8002f7 <vprintfmt+0x2c>
  8006a0:	89 c3                	mov    %eax,%ebx
  8006a2:	eb f0                	jmp    800694 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8006a4:	83 c4 4c             	add    $0x4c,%esp
  8006a7:	5b                   	pop    %ebx
  8006a8:	5e                   	pop    %esi
  8006a9:	5f                   	pop    %edi
  8006aa:	5d                   	pop    %ebp
  8006ab:	c3                   	ret    

008006ac <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
  8006af:	83 ec 28             	sub    $0x28,%esp
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8006b8:	85 c0                	test   %eax,%eax
  8006ba:	74 04                	je     8006c0 <vsnprintf+0x14>
  8006bc:	85 d2                	test   %edx,%edx
  8006be:	7f 07                	jg     8006c7 <vsnprintf+0x1b>
  8006c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c5:	eb 3b                	jmp    800702 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006ca:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8006ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006df:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ed:	c7 04 24 ae 02 80 00 	movl   $0x8002ae,(%esp)
  8006f4:	e8 d2 fb ff ff       	call   8002cb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80070a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  80070d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800711:	8b 45 10             	mov    0x10(%ebp),%eax
  800714:	89 44 24 08          	mov    %eax,0x8(%esp)
  800718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 04 24             	mov    %eax,(%esp)
  800725:	e8 82 ff ff ff       	call   8006ac <vsnprintf>
	va_end(ap);

	return rc;
}
  80072a:	c9                   	leave  
  80072b:	c3                   	ret    

0080072c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800732:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800735:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800739:	8b 45 10             	mov    0x10(%ebp),%eax
  80073c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800740:	8b 45 0c             	mov    0xc(%ebp),%eax
  800743:	89 44 24 04          	mov    %eax,0x4(%esp)
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	89 04 24             	mov    %eax,(%esp)
  80074d:	e8 79 fb ff ff       	call   8002cb <vprintfmt>
	va_end(ap);
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    
	...

00800760 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	8b 55 08             	mov    0x8(%ebp),%edx
  800766:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80076b:	eb 03                	jmp    800770 <strlen+0x10>
		n++;
  80076d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800770:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800774:	75 f7                	jne    80076d <strlen+0xd>
		n++;
	return n;
}
  800776:	5d                   	pop    %ebp
  800777:	c3                   	ret    

00800778 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	53                   	push   %ebx
  80077c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80077f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800782:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800787:	eb 03                	jmp    80078c <strnlen+0x14>
		n++;
  800789:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078c:	39 c1                	cmp    %eax,%ecx
  80078e:	74 06                	je     800796 <strnlen+0x1e>
  800790:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800794:	75 f3                	jne    800789 <strnlen+0x11>
		n++;
	return n;
}
  800796:	5b                   	pop    %ebx
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	53                   	push   %ebx
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007a3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007af:	83 c2 01             	add    $0x1,%edx
  8007b2:	84 c9                	test   %cl,%cl
  8007b4:	75 f2                	jne    8007a8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007b6:	5b                   	pop    %ebx
  8007b7:	5d                   	pop    %ebp
  8007b8:	c3                   	ret    

008007b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	53                   	push   %ebx
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c3:	89 1c 24             	mov    %ebx,(%esp)
  8007c6:	e8 95 ff ff ff       	call   800760 <strlen>
	strcpy(dst + len, src);
  8007cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007d2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8007d5:	89 04 24             	mov    %eax,(%esp)
  8007d8:	e8 bc ff ff ff       	call   800799 <strcpy>
	return dst;
}
  8007dd:	89 d8                	mov    %ebx,%eax
  8007df:	83 c4 08             	add    $0x8,%esp
  8007e2:	5b                   	pop    %ebx
  8007e3:	5d                   	pop    %ebp
  8007e4:	c3                   	ret    

008007e5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	56                   	push   %esi
  8007e9:	53                   	push   %ebx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f0:	8b 75 10             	mov    0x10(%ebp),%esi
  8007f3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f8:	eb 0f                	jmp    800809 <strncpy+0x24>
		*dst++ = *src;
  8007fa:	0f b6 19             	movzbl (%ecx),%ebx
  8007fd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800800:	80 39 01             	cmpb   $0x1,(%ecx)
  800803:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800806:	83 c2 01             	add    $0x1,%edx
  800809:	39 f2                	cmp    %esi,%edx
  80080b:	72 ed                	jb     8007fa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80080d:	5b                   	pop    %ebx
  80080e:	5e                   	pop    %esi
  80080f:	5d                   	pop    %ebp
  800810:	c3                   	ret    

00800811 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	56                   	push   %esi
  800815:	53                   	push   %ebx
  800816:	8b 75 08             	mov    0x8(%ebp),%esi
  800819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80081f:	89 f0                	mov    %esi,%eax
  800821:	85 d2                	test   %edx,%edx
  800823:	75 0a                	jne    80082f <strlcpy+0x1e>
  800825:	eb 17                	jmp    80083e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800827:	88 18                	mov    %bl,(%eax)
  800829:	83 c0 01             	add    $0x1,%eax
  80082c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80082f:	83 ea 01             	sub    $0x1,%edx
  800832:	74 07                	je     80083b <strlcpy+0x2a>
  800834:	0f b6 19             	movzbl (%ecx),%ebx
  800837:	84 db                	test   %bl,%bl
  800839:	75 ec                	jne    800827 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80083b:	c6 00 00             	movb   $0x0,(%eax)
  80083e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800840:	5b                   	pop    %ebx
  800841:	5e                   	pop    %esi
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80084d:	eb 06                	jmp    800855 <strcmp+0x11>
		p++, q++;
  80084f:	83 c1 01             	add    $0x1,%ecx
  800852:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800855:	0f b6 01             	movzbl (%ecx),%eax
  800858:	84 c0                	test   %al,%al
  80085a:	74 04                	je     800860 <strcmp+0x1c>
  80085c:	3a 02                	cmp    (%edx),%al
  80085e:	74 ef                	je     80084f <strcmp+0xb>
  800860:	0f b6 c0             	movzbl %al,%eax
  800863:	0f b6 12             	movzbl (%edx),%edx
  800866:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	53                   	push   %ebx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800874:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800877:	eb 09                	jmp    800882 <strncmp+0x18>
		n--, p++, q++;
  800879:	83 ea 01             	sub    $0x1,%edx
  80087c:	83 c0 01             	add    $0x1,%eax
  80087f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800882:	85 d2                	test   %edx,%edx
  800884:	75 07                	jne    80088d <strncmp+0x23>
  800886:	b8 00 00 00 00       	mov    $0x0,%eax
  80088b:	eb 13                	jmp    8008a0 <strncmp+0x36>
  80088d:	0f b6 18             	movzbl (%eax),%ebx
  800890:	84 db                	test   %bl,%bl
  800892:	74 04                	je     800898 <strncmp+0x2e>
  800894:	3a 19                	cmp    (%ecx),%bl
  800896:	74 e1                	je     800879 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800898:	0f b6 00             	movzbl (%eax),%eax
  80089b:	0f b6 11             	movzbl (%ecx),%edx
  80089e:	29 d0                	sub    %edx,%eax
}
  8008a0:	5b                   	pop    %ebx
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ad:	eb 07                	jmp    8008b6 <strchr+0x13>
		if (*s == c)
  8008af:	38 ca                	cmp    %cl,%dl
  8008b1:	74 0f                	je     8008c2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008b3:	83 c0 01             	add    $0x1,%eax
  8008b6:	0f b6 10             	movzbl (%eax),%edx
  8008b9:	84 d2                	test   %dl,%dl
  8008bb:	75 f2                	jne    8008af <strchr+0xc>
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ce:	eb 07                	jmp    8008d7 <strfind+0x13>
		if (*s == c)
  8008d0:	38 ca                	cmp    %cl,%dl
  8008d2:	74 0a                	je     8008de <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008d4:	83 c0 01             	add    $0x1,%eax
  8008d7:	0f b6 10             	movzbl (%eax),%edx
  8008da:	84 d2                	test   %dl,%dl
  8008dc:	75 f2                	jne    8008d0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 0c             	sub    $0xc,%esp
  8008e6:	89 1c 24             	mov    %ebx,(%esp)
  8008e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008ed:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8008f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008fa:	85 c9                	test   %ecx,%ecx
  8008fc:	74 30                	je     80092e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008fe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800904:	75 25                	jne    80092b <memset+0x4b>
  800906:	f6 c1 03             	test   $0x3,%cl
  800909:	75 20                	jne    80092b <memset+0x4b>
		c &= 0xFF;
  80090b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80090e:	89 d3                	mov    %edx,%ebx
  800910:	c1 e3 08             	shl    $0x8,%ebx
  800913:	89 d6                	mov    %edx,%esi
  800915:	c1 e6 18             	shl    $0x18,%esi
  800918:	89 d0                	mov    %edx,%eax
  80091a:	c1 e0 10             	shl    $0x10,%eax
  80091d:	09 f0                	or     %esi,%eax
  80091f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800921:	09 d8                	or     %ebx,%eax
  800923:	c1 e9 02             	shr    $0x2,%ecx
  800926:	fc                   	cld    
  800927:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800929:	eb 03                	jmp    80092e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80092b:	fc                   	cld    
  80092c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80092e:	89 f8                	mov    %edi,%eax
  800930:	8b 1c 24             	mov    (%esp),%ebx
  800933:	8b 74 24 04          	mov    0x4(%esp),%esi
  800937:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80093b:	89 ec                	mov    %ebp,%esp
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	89 34 24             	mov    %esi,(%esp)
  800948:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800952:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800955:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800957:	39 c6                	cmp    %eax,%esi
  800959:	73 35                	jae    800990 <memmove+0x51>
  80095b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80095e:	39 d0                	cmp    %edx,%eax
  800960:	73 2e                	jae    800990 <memmove+0x51>
		s += n;
		d += n;
  800962:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800964:	f6 c2 03             	test   $0x3,%dl
  800967:	75 1b                	jne    800984 <memmove+0x45>
  800969:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80096f:	75 13                	jne    800984 <memmove+0x45>
  800971:	f6 c1 03             	test   $0x3,%cl
  800974:	75 0e                	jne    800984 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800976:	83 ef 04             	sub    $0x4,%edi
  800979:	8d 72 fc             	lea    -0x4(%edx),%esi
  80097c:	c1 e9 02             	shr    $0x2,%ecx
  80097f:	fd                   	std    
  800980:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800982:	eb 09                	jmp    80098d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800984:	83 ef 01             	sub    $0x1,%edi
  800987:	8d 72 ff             	lea    -0x1(%edx),%esi
  80098a:	fd                   	std    
  80098b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80098d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80098e:	eb 20                	jmp    8009b0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800990:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800996:	75 15                	jne    8009ad <memmove+0x6e>
  800998:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80099e:	75 0d                	jne    8009ad <memmove+0x6e>
  8009a0:	f6 c1 03             	test   $0x3,%cl
  8009a3:	75 08                	jne    8009ad <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8009a5:	c1 e9 02             	shr    $0x2,%ecx
  8009a8:	fc                   	cld    
  8009a9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ab:	eb 03                	jmp    8009b0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ad:	fc                   	cld    
  8009ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b0:	8b 34 24             	mov    (%esp),%esi
  8009b3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009b7:	89 ec                	mov    %ebp,%esp
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	89 04 24             	mov    %eax,(%esp)
  8009d5:	e8 65 ff ff ff       	call   80093f <memmove>
}
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	57                   	push   %edi
  8009e0:	56                   	push   %esi
  8009e1:	53                   	push   %ebx
  8009e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009eb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f0:	eb 1c                	jmp    800a0e <memcmp+0x32>
		if (*s1 != *s2)
  8009f2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  8009f6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  8009fa:	83 c2 01             	add    $0x1,%edx
  8009fd:	83 e9 01             	sub    $0x1,%ecx
  800a00:	38 d8                	cmp    %bl,%al
  800a02:	74 0a                	je     800a0e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800a04:	0f b6 c0             	movzbl %al,%eax
  800a07:	0f b6 db             	movzbl %bl,%ebx
  800a0a:	29 d8                	sub    %ebx,%eax
  800a0c:	eb 09                	jmp    800a17 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a0e:	85 c9                	test   %ecx,%ecx
  800a10:	75 e0                	jne    8009f2 <memcmp+0x16>
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800a17:	5b                   	pop    %ebx
  800a18:	5e                   	pop    %esi
  800a19:	5f                   	pop    %edi
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a25:	89 c2                	mov    %eax,%edx
  800a27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a2a:	eb 07                	jmp    800a33 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a2c:	38 08                	cmp    %cl,(%eax)
  800a2e:	74 07                	je     800a37 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a30:	83 c0 01             	add    $0x1,%eax
  800a33:	39 d0                	cmp    %edx,%eax
  800a35:	72 f5                	jb     800a2c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	57                   	push   %edi
  800a3d:	56                   	push   %esi
  800a3e:	53                   	push   %ebx
  800a3f:	83 ec 04             	sub    $0x4,%esp
  800a42:	8b 55 08             	mov    0x8(%ebp),%edx
  800a45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a48:	eb 03                	jmp    800a4d <strtol+0x14>
		s++;
  800a4a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a4d:	0f b6 02             	movzbl (%edx),%eax
  800a50:	3c 20                	cmp    $0x20,%al
  800a52:	74 f6                	je     800a4a <strtol+0x11>
  800a54:	3c 09                	cmp    $0x9,%al
  800a56:	74 f2                	je     800a4a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a58:	3c 2b                	cmp    $0x2b,%al
  800a5a:	75 0c                	jne    800a68 <strtol+0x2f>
		s++;
  800a5c:	8d 52 01             	lea    0x1(%edx),%edx
  800a5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a66:	eb 15                	jmp    800a7d <strtol+0x44>
	else if (*s == '-')
  800a68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a6f:	3c 2d                	cmp    $0x2d,%al
  800a71:	75 0a                	jne    800a7d <strtol+0x44>
		s++, neg = 1;
  800a73:	8d 52 01             	lea    0x1(%edx),%edx
  800a76:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a7d:	85 db                	test   %ebx,%ebx
  800a7f:	0f 94 c0             	sete   %al
  800a82:	74 05                	je     800a89 <strtol+0x50>
  800a84:	83 fb 10             	cmp    $0x10,%ebx
  800a87:	75 15                	jne    800a9e <strtol+0x65>
  800a89:	80 3a 30             	cmpb   $0x30,(%edx)
  800a8c:	75 10                	jne    800a9e <strtol+0x65>
  800a8e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a92:	75 0a                	jne    800a9e <strtol+0x65>
		s += 2, base = 16;
  800a94:	83 c2 02             	add    $0x2,%edx
  800a97:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9c:	eb 13                	jmp    800ab1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a9e:	84 c0                	test   %al,%al
  800aa0:	74 0f                	je     800ab1 <strtol+0x78>
  800aa2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800aa7:	80 3a 30             	cmpb   $0x30,(%edx)
  800aaa:	75 05                	jne    800ab1 <strtol+0x78>
		s++, base = 8;
  800aac:	83 c2 01             	add    $0x1,%edx
  800aaf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ab8:	0f b6 0a             	movzbl (%edx),%ecx
  800abb:	89 cf                	mov    %ecx,%edi
  800abd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ac0:	80 fb 09             	cmp    $0x9,%bl
  800ac3:	77 08                	ja     800acd <strtol+0x94>
			dig = *s - '0';
  800ac5:	0f be c9             	movsbl %cl,%ecx
  800ac8:	83 e9 30             	sub    $0x30,%ecx
  800acb:	eb 1e                	jmp    800aeb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800acd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ad0:	80 fb 19             	cmp    $0x19,%bl
  800ad3:	77 08                	ja     800add <strtol+0xa4>
			dig = *s - 'a' + 10;
  800ad5:	0f be c9             	movsbl %cl,%ecx
  800ad8:	83 e9 57             	sub    $0x57,%ecx
  800adb:	eb 0e                	jmp    800aeb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800add:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ae0:	80 fb 19             	cmp    $0x19,%bl
  800ae3:	77 15                	ja     800afa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ae5:	0f be c9             	movsbl %cl,%ecx
  800ae8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800aeb:	39 f1                	cmp    %esi,%ecx
  800aed:	7d 0b                	jge    800afa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800aef:	83 c2 01             	add    $0x1,%edx
  800af2:	0f af c6             	imul   %esi,%eax
  800af5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800af8:	eb be                	jmp    800ab8 <strtol+0x7f>
  800afa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800afc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b00:	74 05                	je     800b07 <strtol+0xce>
		*endptr = (char *) s;
  800b02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b05:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b07:	89 ca                	mov    %ecx,%edx
  800b09:	f7 da                	neg    %edx
  800b0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b0f:	0f 45 c2             	cmovne %edx,%eax
}
  800b12:	83 c4 04             	add    $0x4,%esp
  800b15:	5b                   	pop    %ebx
  800b16:	5e                   	pop    %esi
  800b17:	5f                   	pop    %edi
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    
	...

00800b1c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 0c             	sub    $0xc,%esp
  800b22:	89 1c 24             	mov    %ebx,(%esp)
  800b25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b29:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b32:	b8 01 00 00 00       	mov    $0x1,%eax
  800b37:	89 d1                	mov    %edx,%ecx
  800b39:	89 d3                	mov    %edx,%ebx
  800b3b:	89 d7                	mov    %edx,%edi
  800b3d:	89 d6                	mov    %edx,%esi
  800b3f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b41:	8b 1c 24             	mov    (%esp),%ebx
  800b44:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b48:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b4c:	89 ec                	mov    %ebp,%esp
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	83 ec 0c             	sub    $0xc,%esp
  800b56:	89 1c 24             	mov    %ebx,(%esp)
  800b59:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b5d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
  800b66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	89 c3                	mov    %eax,%ebx
  800b6e:	89 c7                	mov    %eax,%edi
  800b70:	89 c6                	mov    %eax,%esi
  800b72:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b74:	8b 1c 24             	mov    (%esp),%ebx
  800b77:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b7b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b7f:	89 ec                	mov    %ebp,%esp
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	89 1c 24             	mov    %ebx,(%esp)
  800b8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b90:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
  800b99:	b8 10 00 00 00       	mov    $0x10,%eax
  800b9e:	89 d1                	mov    %edx,%ecx
  800ba0:	89 d3                	mov    %edx,%ebx
  800ba2:	89 d7                	mov    %edx,%edi
  800ba4:	89 d6                	mov    %edx,%esi
  800ba6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ba8:	8b 1c 24             	mov    (%esp),%ebx
  800bab:	8b 74 24 04          	mov    0x4(%esp),%esi
  800baf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bb3:	89 ec                	mov    %ebp,%esp
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 38             	sub    $0x38,%esp
  800bbd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bc0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bc3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bcb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800bd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd6:	89 df                	mov    %ebx,%edi
  800bd8:	89 de                	mov    %ebx,%esi
  800bda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bdc:	85 c0                	test   %eax,%eax
  800bde:	7e 28                	jle    800c08 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800be0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800be4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800beb:	00 
  800bec:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800bf3:	00 
  800bf4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bfb:	00 
  800bfc:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800c03:	e8 fc 03 00 00       	call   801004 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800c08:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c0b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c0e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c11:	89 ec                	mov    %ebp,%esp
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 38             	sub    $0x38,%esp
  800c1b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c1e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c21:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c29:	b8 0e 00 00 00       	mov    $0xe,%eax
  800c2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c31:	8b 55 08             	mov    0x8(%ebp),%edx
  800c34:	89 df                	mov    %ebx,%edi
  800c36:	89 de                	mov    %ebx,%esi
  800c38:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c3a:	85 c0                	test   %eax,%eax
  800c3c:	7e 28                	jle    800c66 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c42:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800c49:	00 
  800c4a:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800c51:	00 
  800c52:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c59:	00 
  800c5a:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800c61:	e8 9e 03 00 00       	call   801004 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800c66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c69:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c6c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c6f:	89 ec                	mov    %ebp,%esp
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 38             	sub    $0x38,%esp
  800c79:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c7f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c87:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	89 cb                	mov    %ecx,%ebx
  800c91:	89 cf                	mov    %ecx,%edi
  800c93:	89 ce                	mov    %ecx,%esi
  800c95:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	7e 28                	jle    800cc3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c9f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ca6:	00 
  800ca7:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800cae:	00 
  800caf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb6:	00 
  800cb7:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800cbe:	e8 41 03 00 00       	call   801004 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800cc3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cc6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cc9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ccc:	89 ec                	mov    %ebp,%esp
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	89 1c 24             	mov    %ebx,(%esp)
  800cd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cdd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce1:	be 00 00 00 00       	mov    $0x0,%esi
  800ce6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ceb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cf9:	8b 1c 24             	mov    (%esp),%ebx
  800cfc:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d00:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d04:	89 ec                	mov    %ebp,%esp
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 38             	sub    $0x38,%esp
  800d0e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d11:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d14:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	89 df                	mov    %ebx,%edi
  800d29:	89 de                	mov    %ebx,%esi
  800d2b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	7e 28                	jle    800d59 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d31:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d35:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d3c:	00 
  800d3d:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800d44:	00 
  800d45:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d4c:	00 
  800d4d:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800d54:	e8 ab 02 00 00       	call   801004 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d59:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d5c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d5f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d62:	89 ec                	mov    %ebp,%esp
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 38             	sub    $0x38,%esp
  800d6c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d6f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d72:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	89 df                	mov    %ebx,%edi
  800d87:	89 de                	mov    %ebx,%esi
  800d89:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d8b:	85 c0                	test   %eax,%eax
  800d8d:	7e 28                	jle    800db7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d93:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d9a:	00 
  800d9b:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800da2:	00 
  800da3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800daa:	00 
  800dab:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800db2:	e8 4d 02 00 00       	call   801004 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800db7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dbd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dc0:	89 ec                	mov    %ebp,%esp
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    

00800dc4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 38             	sub    $0x38,%esp
  800dca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dcd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dd0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	89 df                	mov    %ebx,%edi
  800de5:	89 de                	mov    %ebx,%esi
  800de7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	7e 28                	jle    800e15 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800df8:	00 
  800df9:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800e00:	00 
  800e01:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e08:	00 
  800e09:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800e10:	e8 ef 01 00 00       	call   801004 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e15:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e18:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e1b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e1e:	89 ec                	mov    %ebp,%esp
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 38             	sub    $0x38,%esp
  800e28:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e2b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e2e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e31:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e36:	b8 06 00 00 00       	mov    $0x6,%eax
  800e3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e41:	89 df                	mov    %ebx,%edi
  800e43:	89 de                	mov    %ebx,%esi
  800e45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e47:	85 c0                	test   %eax,%eax
  800e49:	7e 28                	jle    800e73 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e56:	00 
  800e57:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e66:	00 
  800e67:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800e6e:	e8 91 01 00 00       	call   801004 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e73:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e76:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e79:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e7c:	89 ec                	mov    %ebp,%esp
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 38             	sub    $0x38,%esp
  800e86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e89:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e8c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800e94:	8b 75 18             	mov    0x18(%ebp),%esi
  800e97:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7e 28                	jle    800ed1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ead:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800eb4:	00 
  800eb5:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800ebc:	00 
  800ebd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec4:	00 
  800ec5:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800ecc:	e8 33 01 00 00       	call   801004 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ed1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ed4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ed7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eda:	89 ec                	mov    %ebp,%esp
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    

00800ede <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	83 ec 38             	sub    $0x38,%esp
  800ee4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eed:	be 00 00 00 00       	mov    $0x0,%esi
  800ef2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ef7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	89 f7                	mov    %esi,%edi
  800f02:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	7e 28                	jle    800f30 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f08:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f13:	00 
  800f14:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800f1b:	00 
  800f1c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f23:	00 
  800f24:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800f2b:	e8 d4 00 00 00       	call   801004 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f30:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f33:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f36:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f39:	89 ec                	mov    %ebp,%esp
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	83 ec 0c             	sub    $0xc,%esp
  800f43:	89 1c 24             	mov    %ebx,(%esp)
  800f46:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f4a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f53:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f58:	89 d1                	mov    %edx,%ecx
  800f5a:	89 d3                	mov    %edx,%ebx
  800f5c:	89 d7                	mov    %edx,%edi
  800f5e:	89 d6                	mov    %edx,%esi
  800f60:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f62:	8b 1c 24             	mov    (%esp),%ebx
  800f65:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f69:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f6d:	89 ec                	mov    %ebp,%esp
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    

00800f71 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	89 1c 24             	mov    %ebx,(%esp)
  800f7a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f7e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	ba 00 00 00 00       	mov    $0x0,%edx
  800f87:	b8 02 00 00 00       	mov    $0x2,%eax
  800f8c:	89 d1                	mov    %edx,%ecx
  800f8e:	89 d3                	mov    %edx,%ebx
  800f90:	89 d7                	mov    %edx,%edi
  800f92:	89 d6                	mov    %edx,%esi
  800f94:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f96:	8b 1c 24             	mov    (%esp),%ebx
  800f99:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f9d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fa1:	89 ec                	mov    %ebp,%esp
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 38             	sub    $0x38,%esp
  800fab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fb1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb9:	b8 03 00 00 00       	mov    $0x3,%eax
  800fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc1:	89 cb                	mov    %ecx,%ebx
  800fc3:	89 cf                	mov    %ecx,%edi
  800fc5:	89 ce                	mov    %ecx,%esi
  800fc7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	7e 28                	jle    800ff5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800fd8:	00 
  800fd9:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800fe0:	00 
  800fe1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe8:	00 
  800fe9:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800ff0:	e8 0f 00 00 00       	call   801004 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ff5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ff8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ffb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ffe:	89 ec                	mov    %ebp,%esp
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    
	...

00801004 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  80100c:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80100f:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  801015:	e8 57 ff ff ff       	call   800f71 <sys_getenvid>
  80101a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101d:	89 54 24 10          	mov    %edx,0x10(%esp)
  801021:	8b 55 08             	mov    0x8(%ebp),%edx
  801024:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801028:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80102c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801030:	c7 04 24 34 16 80 00 	movl   $0x801634,(%esp)
  801037:	e8 f1 f0 ff ff       	call   80012d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80103c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	89 04 24             	mov    %eax,(%esp)
  801046:	e8 81 f0 ff ff       	call   8000cc <vcprintf>
	cprintf("\n");
  80104b:	c7 04 24 ec 12 80 00 	movl   $0x8012ec,(%esp)
  801052:	e8 d6 f0 ff ff       	call   80012d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801057:	cc                   	int3   
  801058:	eb fd                	jmp    801057 <_panic+0x53>
  80105a:	00 00                	add    %al,(%eax)
  80105c:	00 00                	add    %al,(%eax)
	...

00801060 <__udivdi3>:
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	83 ec 10             	sub    $0x10,%esp
  801068:	8b 45 14             	mov    0x14(%ebp),%eax
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	8b 75 10             	mov    0x10(%ebp),%esi
  801071:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801074:	85 c0                	test   %eax,%eax
  801076:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801079:	75 35                	jne    8010b0 <__udivdi3+0x50>
  80107b:	39 fe                	cmp    %edi,%esi
  80107d:	77 61                	ja     8010e0 <__udivdi3+0x80>
  80107f:	85 f6                	test   %esi,%esi
  801081:	75 0b                	jne    80108e <__udivdi3+0x2e>
  801083:	b8 01 00 00 00       	mov    $0x1,%eax
  801088:	31 d2                	xor    %edx,%edx
  80108a:	f7 f6                	div    %esi
  80108c:	89 c6                	mov    %eax,%esi
  80108e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801091:	31 d2                	xor    %edx,%edx
  801093:	89 f8                	mov    %edi,%eax
  801095:	f7 f6                	div    %esi
  801097:	89 c7                	mov    %eax,%edi
  801099:	89 c8                	mov    %ecx,%eax
  80109b:	f7 f6                	div    %esi
  80109d:	89 c1                	mov    %eax,%ecx
  80109f:	89 fa                	mov    %edi,%edx
  8010a1:	89 c8                	mov    %ecx,%eax
  8010a3:	83 c4 10             	add    $0x10,%esp
  8010a6:	5e                   	pop    %esi
  8010a7:	5f                   	pop    %edi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    
  8010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010b0:	39 f8                	cmp    %edi,%eax
  8010b2:	77 1c                	ja     8010d0 <__udivdi3+0x70>
  8010b4:	0f bd d0             	bsr    %eax,%edx
  8010b7:	83 f2 1f             	xor    $0x1f,%edx
  8010ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010bd:	75 39                	jne    8010f8 <__udivdi3+0x98>
  8010bf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8010c2:	0f 86 a0 00 00 00    	jbe    801168 <__udivdi3+0x108>
  8010c8:	39 f8                	cmp    %edi,%eax
  8010ca:	0f 82 98 00 00 00    	jb     801168 <__udivdi3+0x108>
  8010d0:	31 ff                	xor    %edi,%edi
  8010d2:	31 c9                	xor    %ecx,%ecx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	89 fa                	mov    %edi,%edx
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	5e                   	pop    %esi
  8010dc:	5f                   	pop    %edi
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    
  8010df:	90                   	nop
  8010e0:	89 d1                	mov    %edx,%ecx
  8010e2:	89 fa                	mov    %edi,%edx
  8010e4:	89 c8                	mov    %ecx,%eax
  8010e6:	31 ff                	xor    %edi,%edi
  8010e8:	f7 f6                	div    %esi
  8010ea:	89 c1                	mov    %eax,%ecx
  8010ec:	89 fa                	mov    %edi,%edx
  8010ee:	89 c8                	mov    %ecx,%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	5e                   	pop    %esi
  8010f4:	5f                   	pop    %edi
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    
  8010f7:	90                   	nop
  8010f8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8010fc:	89 f2                	mov    %esi,%edx
  8010fe:	d3 e0                	shl    %cl,%eax
  801100:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801103:	b8 20 00 00 00       	mov    $0x20,%eax
  801108:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80110b:	89 c1                	mov    %eax,%ecx
  80110d:	d3 ea                	shr    %cl,%edx
  80110f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801113:	0b 55 ec             	or     -0x14(%ebp),%edx
  801116:	d3 e6                	shl    %cl,%esi
  801118:	89 c1                	mov    %eax,%ecx
  80111a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80111d:	89 fe                	mov    %edi,%esi
  80111f:	d3 ee                	shr    %cl,%esi
  801121:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801125:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112b:	d3 e7                	shl    %cl,%edi
  80112d:	89 c1                	mov    %eax,%ecx
  80112f:	d3 ea                	shr    %cl,%edx
  801131:	09 d7                	or     %edx,%edi
  801133:	89 f2                	mov    %esi,%edx
  801135:	89 f8                	mov    %edi,%eax
  801137:	f7 75 ec             	divl   -0x14(%ebp)
  80113a:	89 d6                	mov    %edx,%esi
  80113c:	89 c7                	mov    %eax,%edi
  80113e:	f7 65 e8             	mull   -0x18(%ebp)
  801141:	39 d6                	cmp    %edx,%esi
  801143:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801146:	72 30                	jb     801178 <__udivdi3+0x118>
  801148:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80114b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80114f:	d3 e2                	shl    %cl,%edx
  801151:	39 c2                	cmp    %eax,%edx
  801153:	73 05                	jae    80115a <__udivdi3+0xfa>
  801155:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801158:	74 1e                	je     801178 <__udivdi3+0x118>
  80115a:	89 f9                	mov    %edi,%ecx
  80115c:	31 ff                	xor    %edi,%edi
  80115e:	e9 71 ff ff ff       	jmp    8010d4 <__udivdi3+0x74>
  801163:	90                   	nop
  801164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801168:	31 ff                	xor    %edi,%edi
  80116a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80116f:	e9 60 ff ff ff       	jmp    8010d4 <__udivdi3+0x74>
  801174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801178:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80117b:	31 ff                	xor    %edi,%edi
  80117d:	89 c8                	mov    %ecx,%eax
  80117f:	89 fa                	mov    %edi,%edx
  801181:	83 c4 10             	add    $0x10,%esp
  801184:	5e                   	pop    %esi
  801185:	5f                   	pop    %edi
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    
	...

00801190 <__umoddi3>:
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	57                   	push   %edi
  801194:	56                   	push   %esi
  801195:	83 ec 20             	sub    $0x20,%esp
  801198:	8b 55 14             	mov    0x14(%ebp),%edx
  80119b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8011a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011a4:	85 d2                	test   %edx,%edx
  8011a6:	89 c8                	mov    %ecx,%eax
  8011a8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8011ab:	75 13                	jne    8011c0 <__umoddi3+0x30>
  8011ad:	39 f7                	cmp    %esi,%edi
  8011af:	76 3f                	jbe    8011f0 <__umoddi3+0x60>
  8011b1:	89 f2                	mov    %esi,%edx
  8011b3:	f7 f7                	div    %edi
  8011b5:	89 d0                	mov    %edx,%eax
  8011b7:	31 d2                	xor    %edx,%edx
  8011b9:	83 c4 20             	add    $0x20,%esp
  8011bc:	5e                   	pop    %esi
  8011bd:	5f                   	pop    %edi
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    
  8011c0:	39 f2                	cmp    %esi,%edx
  8011c2:	77 4c                	ja     801210 <__umoddi3+0x80>
  8011c4:	0f bd ca             	bsr    %edx,%ecx
  8011c7:	83 f1 1f             	xor    $0x1f,%ecx
  8011ca:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8011cd:	75 51                	jne    801220 <__umoddi3+0x90>
  8011cf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8011d2:	0f 87 e0 00 00 00    	ja     8012b8 <__umoddi3+0x128>
  8011d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011db:	29 f8                	sub    %edi,%eax
  8011dd:	19 d6                	sbb    %edx,%esi
  8011df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e5:	89 f2                	mov    %esi,%edx
  8011e7:	83 c4 20             	add    $0x20,%esp
  8011ea:	5e                   	pop    %esi
  8011eb:	5f                   	pop    %edi
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    
  8011ee:	66 90                	xchg   %ax,%ax
  8011f0:	85 ff                	test   %edi,%edi
  8011f2:	75 0b                	jne    8011ff <__umoddi3+0x6f>
  8011f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8011f9:	31 d2                	xor    %edx,%edx
  8011fb:	f7 f7                	div    %edi
  8011fd:	89 c7                	mov    %eax,%edi
  8011ff:	89 f0                	mov    %esi,%eax
  801201:	31 d2                	xor    %edx,%edx
  801203:	f7 f7                	div    %edi
  801205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801208:	f7 f7                	div    %edi
  80120a:	eb a9                	jmp    8011b5 <__umoddi3+0x25>
  80120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801210:	89 c8                	mov    %ecx,%eax
  801212:	89 f2                	mov    %esi,%edx
  801214:	83 c4 20             	add    $0x20,%esp
  801217:	5e                   	pop    %esi
  801218:	5f                   	pop    %edi
  801219:	5d                   	pop    %ebp
  80121a:	c3                   	ret    
  80121b:	90                   	nop
  80121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801220:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801224:	d3 e2                	shl    %cl,%edx
  801226:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801229:	ba 20 00 00 00       	mov    $0x20,%edx
  80122e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801231:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801234:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801238:	89 fa                	mov    %edi,%edx
  80123a:	d3 ea                	shr    %cl,%edx
  80123c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801240:	0b 55 f4             	or     -0xc(%ebp),%edx
  801243:	d3 e7                	shl    %cl,%edi
  801245:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801249:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80124c:	89 f2                	mov    %esi,%edx
  80124e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801251:	89 c7                	mov    %eax,%edi
  801253:	d3 ea                	shr    %cl,%edx
  801255:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801259:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80125c:	89 c2                	mov    %eax,%edx
  80125e:	d3 e6                	shl    %cl,%esi
  801260:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801264:	d3 ea                	shr    %cl,%edx
  801266:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80126a:	09 d6                	or     %edx,%esi
  80126c:	89 f0                	mov    %esi,%eax
  80126e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801271:	d3 e7                	shl    %cl,%edi
  801273:	89 f2                	mov    %esi,%edx
  801275:	f7 75 f4             	divl   -0xc(%ebp)
  801278:	89 d6                	mov    %edx,%esi
  80127a:	f7 65 e8             	mull   -0x18(%ebp)
  80127d:	39 d6                	cmp    %edx,%esi
  80127f:	72 2b                	jb     8012ac <__umoddi3+0x11c>
  801281:	39 c7                	cmp    %eax,%edi
  801283:	72 23                	jb     8012a8 <__umoddi3+0x118>
  801285:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801289:	29 c7                	sub    %eax,%edi
  80128b:	19 d6                	sbb    %edx,%esi
  80128d:	89 f0                	mov    %esi,%eax
  80128f:	89 f2                	mov    %esi,%edx
  801291:	d3 ef                	shr    %cl,%edi
  801293:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801297:	d3 e0                	shl    %cl,%eax
  801299:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80129d:	09 f8                	or     %edi,%eax
  80129f:	d3 ea                	shr    %cl,%edx
  8012a1:	83 c4 20             	add    $0x20,%esp
  8012a4:	5e                   	pop    %esi
  8012a5:	5f                   	pop    %edi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    
  8012a8:	39 d6                	cmp    %edx,%esi
  8012aa:	75 d9                	jne    801285 <__umoddi3+0xf5>
  8012ac:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8012af:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8012b2:	eb d1                	jmp    801285 <__umoddi3+0xf5>
  8012b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012b8:	39 f2                	cmp    %esi,%edx
  8012ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012c0:	0f 82 12 ff ff ff    	jb     8011d8 <__umoddi3+0x48>
  8012c6:	e9 17 ff ff ff       	jmp    8011e2 <__umoddi3+0x52>
