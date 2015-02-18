
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("hello, world\n");
  80003a:	c7 04 24 c0 12 80 00 	movl   $0x8012c0,(%esp)
  800041:	e8 df 00 00 00       	call   800125 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800046:	a1 04 20 80 00       	mov    0x802004,%eax
  80004b:	8b 40 48             	mov    0x48(%eax),%eax
  80004e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800052:	c7 04 24 ce 12 80 00 	movl   $0x8012ce,(%esp)
  800059:	e8 c7 00 00 00       	call   800125 <cprintf>
}
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	83 ec 18             	sub    $0x18,%esp
  800066:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800069:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80006c:	8b 75 08             	mov    0x8(%ebp),%esi
  80006f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800072:	e8 ea 0e 00 00       	call   800f61 <sys_getenvid>
  800077:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800084:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800089:	85 f6                	test   %esi,%esi
  80008b:	7e 07                	jle    800094 <libmain+0x34>
		binaryname = argv[0];
  80008d:	8b 03                	mov    (%ebx),%eax
  80008f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800094:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800098:	89 34 24             	mov    %esi,(%esp)
  80009b:	e8 94 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000a0:	e8 0b 00 00 00       	call   8000b0 <exit>
}
  8000a5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000a8:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000ab:	89 ec                	mov    %ebp,%esp
  8000ad:	5d                   	pop    %ebp
  8000ae:	c3                   	ret    
	...

008000b0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8000b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000bd:	e8 d3 0e 00 00       	call   800f95 <sys_env_destroy>
}
  8000c2:	c9                   	leave  
  8000c3:	c3                   	ret    

008000c4 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8000cd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000d4:	00 00 00 
	b.cnt = 0;
  8000d7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000de:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8000f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f9:	c7 04 24 3f 01 80 00 	movl   $0x80013f,(%esp)
  800100:	e8 be 01 00 00       	call   8002c3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800105:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80010b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80010f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800115:	89 04 24             	mov    %eax,(%esp)
  800118:	e8 23 0a 00 00       	call   800b40 <sys_cputs>

	return b.cnt;
}
  80011d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800123:	c9                   	leave  
  800124:	c3                   	ret    

00800125 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80012b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80012e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800132:	8b 45 08             	mov    0x8(%ebp),%eax
  800135:	89 04 24             	mov    %eax,(%esp)
  800138:	e8 87 ff ff ff       	call   8000c4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    

0080013f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	53                   	push   %ebx
  800143:	83 ec 14             	sub    $0x14,%esp
  800146:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800149:	8b 03                	mov    (%ebx),%eax
  80014b:	8b 55 08             	mov    0x8(%ebp),%edx
  80014e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800152:	83 c0 01             	add    $0x1,%eax
  800155:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800157:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015c:	75 19                	jne    800177 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80015e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800165:	00 
  800166:	8d 43 08             	lea    0x8(%ebx),%eax
  800169:	89 04 24             	mov    %eax,(%esp)
  80016c:	e8 cf 09 00 00       	call   800b40 <sys_cputs>
		b->idx = 0;
  800171:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800177:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017b:	83 c4 14             	add    $0x14,%esp
  80017e:	5b                   	pop    %ebx
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    
  800181:	00 00                	add    %al,(%eax)
	...

00800184 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	57                   	push   %edi
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
  80018a:	83 ec 4c             	sub    $0x4c,%esp
  80018d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800190:	89 d6                	mov    %edx,%esi
  800192:	8b 45 08             	mov    0x8(%ebp),%eax
  800195:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80019e:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001a4:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001af:	39 d1                	cmp    %edx,%ecx
  8001b1:	72 07                	jb     8001ba <printnum+0x36>
  8001b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001b6:	39 d0                	cmp    %edx,%eax
  8001b8:	77 69                	ja     800223 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ba:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8001be:	83 eb 01             	sub    $0x1,%ebx
  8001c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c9:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8001cd:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8001d1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8001d4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8001d7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001de:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001e5:	00 
  8001e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e9:	89 04 24             	mov    %eax,(%esp)
  8001ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001ef:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001f3:	e8 58 0e 00 00       	call   801050 <__udivdi3>
  8001f8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8001fb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8001fe:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800202:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800206:	89 04 24             	mov    %eax,(%esp)
  800209:	89 54 24 04          	mov    %edx,0x4(%esp)
  80020d:	89 f2                	mov    %esi,%edx
  80020f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800212:	e8 6d ff ff ff       	call   800184 <printnum>
  800217:	eb 11                	jmp    80022a <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800219:	89 74 24 04          	mov    %esi,0x4(%esp)
  80021d:	89 3c 24             	mov    %edi,(%esp)
  800220:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800223:	83 eb 01             	sub    $0x1,%ebx
  800226:	85 db                	test   %ebx,%ebx
  800228:	7f ef                	jg     800219 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80022e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800232:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800235:	89 44 24 08          	mov    %eax,0x8(%esp)
  800239:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800240:	00 
  800241:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800244:	89 14 24             	mov    %edx,(%esp)
  800247:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80024a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80024e:	e8 2d 0f 00 00       	call   801180 <__umoddi3>
  800253:	89 74 24 04          	mov    %esi,0x4(%esp)
  800257:	0f be 80 ef 12 80 00 	movsbl 0x8012ef(%eax),%eax
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800264:	83 c4 4c             	add    $0x4c,%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80026f:	83 fa 01             	cmp    $0x1,%edx
  800272:	7e 0e                	jle    800282 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800274:	8b 10                	mov    (%eax),%edx
  800276:	8d 4a 08             	lea    0x8(%edx),%ecx
  800279:	89 08                	mov    %ecx,(%eax)
  80027b:	8b 02                	mov    (%edx),%eax
  80027d:	8b 52 04             	mov    0x4(%edx),%edx
  800280:	eb 22                	jmp    8002a4 <getuint+0x38>
	else if (lflag)
  800282:	85 d2                	test   %edx,%edx
  800284:	74 10                	je     800296 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800286:	8b 10                	mov    (%eax),%edx
  800288:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028b:	89 08                	mov    %ecx,(%eax)
  80028d:	8b 02                	mov    (%edx),%eax
  80028f:	ba 00 00 00 00       	mov    $0x0,%edx
  800294:	eb 0e                	jmp    8002a4 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800296:	8b 10                	mov    (%eax),%edx
  800298:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029b:	89 08                	mov    %ecx,(%eax)
  80029d:	8b 02                	mov    (%edx),%eax
  80029f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002a4:	5d                   	pop    %ebp
  8002a5:	c3                   	ret    

008002a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ac:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b0:	8b 10                	mov    (%eax),%edx
  8002b2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b5:	73 0a                	jae    8002c1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ba:	88 0a                	mov    %cl,(%edx)
  8002bc:	83 c2 01             	add    $0x1,%edx
  8002bf:	89 10                	mov    %edx,(%eax)
}
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    

008002c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	57                   	push   %edi
  8002c7:	56                   	push   %esi
  8002c8:	53                   	push   %ebx
  8002c9:	83 ec 4c             	sub    $0x4c,%esp
  8002cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8002d5:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8002dc:	eb 11                	jmp    8002ef <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002de:	85 c0                	test   %eax,%eax
  8002e0:	0f 84 b6 03 00 00    	je     80069c <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8002e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ea:	89 04 24             	mov    %eax,(%esp)
  8002ed:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002ef:	0f b6 03             	movzbl (%ebx),%eax
  8002f2:	83 c3 01             	add    $0x1,%ebx
  8002f5:	83 f8 25             	cmp    $0x25,%eax
  8002f8:	75 e4                	jne    8002de <vprintfmt+0x1b>
  8002fa:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8002fe:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800305:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80030c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800313:	b9 00 00 00 00       	mov    $0x0,%ecx
  800318:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80031b:	eb 06                	jmp    800323 <vprintfmt+0x60>
  80031d:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800321:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800323:	0f b6 0b             	movzbl (%ebx),%ecx
  800326:	0f b6 c1             	movzbl %cl,%eax
  800329:	8d 53 01             	lea    0x1(%ebx),%edx
  80032c:	83 e9 23             	sub    $0x23,%ecx
  80032f:	80 f9 55             	cmp    $0x55,%cl
  800332:	0f 87 47 03 00 00    	ja     80067f <vprintfmt+0x3bc>
  800338:	0f b6 c9             	movzbl %cl,%ecx
  80033b:	ff 24 8d 40 14 80 00 	jmp    *0x801440(,%ecx,4)
  800342:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800346:	eb d9                	jmp    800321 <vprintfmt+0x5e>
  800348:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80034f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800354:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800357:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80035b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80035e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800361:	83 fb 09             	cmp    $0x9,%ebx
  800364:	77 30                	ja     800396 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800366:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800369:	eb e9                	jmp    800354 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80036b:	8b 45 14             	mov    0x14(%ebp),%eax
  80036e:	8d 48 04             	lea    0x4(%eax),%ecx
  800371:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800374:	8b 00                	mov    (%eax),%eax
  800376:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800379:	eb 1e                	jmp    800399 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80037b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800388:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038b:	eb 94                	jmp    800321 <vprintfmt+0x5e>
  80038d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800394:	eb 8b                	jmp    800321 <vprintfmt+0x5e>
  800396:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800399:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80039d:	79 82                	jns    800321 <vprintfmt+0x5e>
  80039f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8003a8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8003ab:	e9 71 ff ff ff       	jmp    800321 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003b0:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003b4:	e9 68 ff ff ff       	jmp    800321 <vprintfmt+0x5e>
  8003b9:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bf:	8d 50 04             	lea    0x4(%eax),%edx
  8003c2:	89 55 14             	mov    %edx,0x14(%ebp)
  8003c5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	89 04 24             	mov    %eax,(%esp)
  8003ce:	ff d7                	call   *%edi
  8003d0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8003d3:	e9 17 ff ff ff       	jmp    8002ef <vprintfmt+0x2c>
  8003d8:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	8d 50 04             	lea    0x4(%eax),%edx
  8003e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	89 c2                	mov    %eax,%edx
  8003e8:	c1 fa 1f             	sar    $0x1f,%edx
  8003eb:	31 d0                	xor    %edx,%eax
  8003ed:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ef:	83 f8 11             	cmp    $0x11,%eax
  8003f2:	7f 0b                	jg     8003ff <vprintfmt+0x13c>
  8003f4:	8b 14 85 a0 15 80 00 	mov    0x8015a0(,%eax,4),%edx
  8003fb:	85 d2                	test   %edx,%edx
  8003fd:	75 20                	jne    80041f <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8003ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800403:	c7 44 24 08 00 13 80 	movl   $0x801300,0x8(%esp)
  80040a:	00 
  80040b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80040f:	89 3c 24             	mov    %edi,(%esp)
  800412:	e8 0d 03 00 00       	call   800724 <printfmt>
  800417:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041a:	e9 d0 fe ff ff       	jmp    8002ef <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80041f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800423:	c7 44 24 08 09 13 80 	movl   $0x801309,0x8(%esp)
  80042a:	00 
  80042b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80042f:	89 3c 24             	mov    %edi,(%esp)
  800432:	e8 ed 02 00 00       	call   800724 <printfmt>
  800437:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80043a:	e9 b0 fe ff ff       	jmp    8002ef <vprintfmt+0x2c>
  80043f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800442:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800448:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8d 50 04             	lea    0x4(%eax),%edx
  800451:	89 55 14             	mov    %edx,0x14(%ebp)
  800454:	8b 18                	mov    (%eax),%ebx
  800456:	85 db                	test   %ebx,%ebx
  800458:	b8 0c 13 80 00       	mov    $0x80130c,%eax
  80045d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800460:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800464:	7e 76                	jle    8004dc <vprintfmt+0x219>
  800466:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80046a:	74 7a                	je     8004e6 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  80046c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800470:	89 1c 24             	mov    %ebx,(%esp)
  800473:	e8 f0 02 00 00       	call   800768 <strnlen>
  800478:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80047b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  80047d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800481:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800484:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800487:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800489:	eb 0f                	jmp    80049a <vprintfmt+0x1d7>
					putch(padc, putdat);
  80048b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80048f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800492:	89 04 24             	mov    %eax,(%esp)
  800495:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800497:	83 eb 01             	sub    $0x1,%ebx
  80049a:	85 db                	test   %ebx,%ebx
  80049c:	7f ed                	jg     80048b <vprintfmt+0x1c8>
  80049e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8004a1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004a4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004a7:	89 f7                	mov    %esi,%edi
  8004a9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004ac:	eb 40                	jmp    8004ee <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b2:	74 18                	je     8004cc <vprintfmt+0x209>
  8004b4:	8d 50 e0             	lea    -0x20(%eax),%edx
  8004b7:	83 fa 5e             	cmp    $0x5e,%edx
  8004ba:	76 10                	jbe    8004cc <vprintfmt+0x209>
					putch('?', putdat);
  8004bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004c0:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8004c7:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004ca:	eb 0a                	jmp    8004d6 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8004cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004d0:	89 04 24             	mov    %eax,(%esp)
  8004d3:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d6:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8004da:	eb 12                	jmp    8004ee <vprintfmt+0x22b>
  8004dc:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004df:	89 f7                	mov    %esi,%edi
  8004e1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004e4:	eb 08                	jmp    8004ee <vprintfmt+0x22b>
  8004e6:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004e9:	89 f7                	mov    %esi,%edi
  8004eb:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004ee:	0f be 03             	movsbl (%ebx),%eax
  8004f1:	83 c3 01             	add    $0x1,%ebx
  8004f4:	85 c0                	test   %eax,%eax
  8004f6:	74 25                	je     80051d <vprintfmt+0x25a>
  8004f8:	85 f6                	test   %esi,%esi
  8004fa:	78 b2                	js     8004ae <vprintfmt+0x1eb>
  8004fc:	83 ee 01             	sub    $0x1,%esi
  8004ff:	79 ad                	jns    8004ae <vprintfmt+0x1eb>
  800501:	89 fe                	mov    %edi,%esi
  800503:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800506:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800509:	eb 1a                	jmp    800525 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80050b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80050f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800516:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800518:	83 eb 01             	sub    $0x1,%ebx
  80051b:	eb 08                	jmp    800525 <vprintfmt+0x262>
  80051d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800520:	89 fe                	mov    %edi,%esi
  800522:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800525:	85 db                	test   %ebx,%ebx
  800527:	7f e2                	jg     80050b <vprintfmt+0x248>
  800529:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80052c:	e9 be fd ff ff       	jmp    8002ef <vprintfmt+0x2c>
  800531:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800534:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800537:	83 f9 01             	cmp    $0x1,%ecx
  80053a:	7e 16                	jle    800552 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8d 50 08             	lea    0x8(%eax),%edx
  800542:	89 55 14             	mov    %edx,0x14(%ebp)
  800545:	8b 10                	mov    (%eax),%edx
  800547:	8b 48 04             	mov    0x4(%eax),%ecx
  80054a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  80054d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800550:	eb 32                	jmp    800584 <vprintfmt+0x2c1>
	else if (lflag)
  800552:	85 c9                	test   %ecx,%ecx
  800554:	74 18                	je     80056e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	8d 50 04             	lea    0x4(%eax),%edx
  80055c:	89 55 14             	mov    %edx,0x14(%ebp)
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	89 c1                	mov    %eax,%ecx
  800566:	c1 f9 1f             	sar    $0x1f,%ecx
  800569:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80056c:	eb 16                	jmp    800584 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 50 04             	lea    0x4(%eax),%edx
  800574:	89 55 14             	mov    %edx,0x14(%ebp)
  800577:	8b 00                	mov    (%eax),%eax
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057c:	89 c2                	mov    %eax,%edx
  80057e:	c1 fa 1f             	sar    $0x1f,%edx
  800581:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800584:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800587:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80058a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80058f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800593:	0f 89 a7 00 00 00    	jns    800640 <vprintfmt+0x37d>
				putch('-', putdat);
  800599:	89 74 24 04          	mov    %esi,0x4(%esp)
  80059d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005a4:	ff d7                	call   *%edi
				num = -(long long) num;
  8005a6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005a9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005ac:	f7 d9                	neg    %ecx
  8005ae:	83 d3 00             	adc    $0x0,%ebx
  8005b1:	f7 db                	neg    %ebx
  8005b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b8:	e9 83 00 00 00       	jmp    800640 <vprintfmt+0x37d>
  8005bd:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005c0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005c3:	89 ca                	mov    %ecx,%edx
  8005c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8005c8:	e8 9f fc ff ff       	call   80026c <getuint>
  8005cd:	89 c1                	mov    %eax,%ecx
  8005cf:	89 d3                	mov    %edx,%ebx
  8005d1:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8005d6:	eb 68                	jmp    800640 <vprintfmt+0x37d>
  8005d8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005db:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8005de:	89 ca                	mov    %ecx,%edx
  8005e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e3:	e8 84 fc ff ff       	call   80026c <getuint>
  8005e8:	89 c1                	mov    %eax,%ecx
  8005ea:	89 d3                	mov    %edx,%ebx
  8005ec:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8005f1:	eb 4d                	jmp    800640 <vprintfmt+0x37d>
  8005f3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8005f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fa:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800601:	ff d7                	call   *%edi
			putch('x', putdat);
  800603:	89 74 24 04          	mov    %esi,0x4(%esp)
  800607:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80060e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 50 04             	lea    0x4(%eax),%edx
  800616:	89 55 14             	mov    %edx,0x14(%ebp)
  800619:	8b 08                	mov    (%eax),%ecx
  80061b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800620:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800625:	eb 19                	jmp    800640 <vprintfmt+0x37d>
  800627:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80062a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80062d:	89 ca                	mov    %ecx,%edx
  80062f:	8d 45 14             	lea    0x14(%ebp),%eax
  800632:	e8 35 fc ff ff       	call   80026c <getuint>
  800637:	89 c1                	mov    %eax,%ecx
  800639:	89 d3                	mov    %edx,%ebx
  80063b:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800640:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800644:	89 54 24 10          	mov    %edx,0x10(%esp)
  800648:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80064b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80064f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800653:	89 0c 24             	mov    %ecx,(%esp)
  800656:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80065a:	89 f2                	mov    %esi,%edx
  80065c:	89 f8                	mov    %edi,%eax
  80065e:	e8 21 fb ff ff       	call   800184 <printnum>
  800663:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800666:	e9 84 fc ff ff       	jmp    8002ef <vprintfmt+0x2c>
  80066b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80066e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800672:	89 04 24             	mov    %eax,(%esp)
  800675:	ff d7                	call   *%edi
  800677:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80067a:	e9 70 fc ff ff       	jmp    8002ef <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80067f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800683:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80068a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80068c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80068f:	80 38 25             	cmpb   $0x25,(%eax)
  800692:	0f 84 57 fc ff ff    	je     8002ef <vprintfmt+0x2c>
  800698:	89 c3                	mov    %eax,%ebx
  80069a:	eb f0                	jmp    80068c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  80069c:	83 c4 4c             	add    $0x4c,%esp
  80069f:	5b                   	pop    %ebx
  8006a0:	5e                   	pop    %esi
  8006a1:	5f                   	pop    %edi
  8006a2:	5d                   	pop    %ebp
  8006a3:	c3                   	ret    

008006a4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006a4:	55                   	push   %ebp
  8006a5:	89 e5                	mov    %esp,%ebp
  8006a7:	83 ec 28             	sub    $0x28,%esp
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8006b0:	85 c0                	test   %eax,%eax
  8006b2:	74 04                	je     8006b8 <vsnprintf+0x14>
  8006b4:	85 d2                	test   %edx,%edx
  8006b6:	7f 07                	jg     8006bf <vsnprintf+0x1b>
  8006b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006bd:	eb 3b                	jmp    8006fa <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006c2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8006c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8006da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006de:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e5:	c7 04 24 a6 02 80 00 	movl   $0x8002a6,(%esp)
  8006ec:	e8 d2 fb ff ff       	call   8002c3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800702:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800705:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800709:	8b 45 10             	mov    0x10(%ebp),%eax
  80070c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800710:	8b 45 0c             	mov    0xc(%ebp),%eax
  800713:	89 44 24 04          	mov    %eax,0x4(%esp)
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 04 24             	mov    %eax,(%esp)
  80071d:	e8 82 ff ff ff       	call   8006a4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800722:	c9                   	leave  
  800723:	c3                   	ret    

00800724 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80072a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80072d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800731:	8b 45 10             	mov    0x10(%ebp),%eax
  800734:	89 44 24 08          	mov    %eax,0x8(%esp)
  800738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 04 24             	mov    %eax,(%esp)
  800745:	e8 79 fb ff ff       	call   8002c3 <vprintfmt>
	va_end(ap);
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    
  80074c:	00 00                	add    %al,(%eax)
	...

00800750 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	8b 55 08             	mov    0x8(%ebp),%edx
  800756:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80075b:	eb 03                	jmp    800760 <strlen+0x10>
		n++;
  80075d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800760:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800764:	75 f7                	jne    80075d <strlen+0xd>
		n++;
	return n;
}
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	53                   	push   %ebx
  80076c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80076f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800772:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800777:	eb 03                	jmp    80077c <strnlen+0x14>
		n++;
  800779:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077c:	39 c1                	cmp    %eax,%ecx
  80077e:	74 06                	je     800786 <strnlen+0x1e>
  800780:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800784:	75 f3                	jne    800779 <strnlen+0x11>
		n++;
	return n;
}
  800786:	5b                   	pop    %ebx
  800787:	5d                   	pop    %ebp
  800788:	c3                   	ret    

00800789 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	53                   	push   %ebx
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800793:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800798:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80079c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80079f:	83 c2 01             	add    $0x1,%edx
  8007a2:	84 c9                	test   %cl,%cl
  8007a4:	75 f2                	jne    800798 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007a6:	5b                   	pop    %ebx
  8007a7:	5d                   	pop    %ebp
  8007a8:	c3                   	ret    

008007a9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	53                   	push   %ebx
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b3:	89 1c 24             	mov    %ebx,(%esp)
  8007b6:	e8 95 ff ff ff       	call   800750 <strlen>
	strcpy(dst + len, src);
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007be:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007c2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8007c5:	89 04 24             	mov    %eax,(%esp)
  8007c8:	e8 bc ff ff ff       	call   800789 <strcpy>
	return dst;
}
  8007cd:	89 d8                	mov    %ebx,%eax
  8007cf:	83 c4 08             	add    $0x8,%esp
  8007d2:	5b                   	pop    %ebx
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e0:	8b 75 10             	mov    0x10(%ebp),%esi
  8007e3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e8:	eb 0f                	jmp    8007f9 <strncpy+0x24>
		*dst++ = *src;
  8007ea:	0f b6 19             	movzbl (%ecx),%ebx
  8007ed:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f0:	80 39 01             	cmpb   $0x1,(%ecx)
  8007f3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f6:	83 c2 01             	add    $0x1,%edx
  8007f9:	39 f2                	cmp    %esi,%edx
  8007fb:	72 ed                	jb     8007ea <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007fd:	5b                   	pop    %ebx
  8007fe:	5e                   	pop    %esi
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	56                   	push   %esi
  800805:	53                   	push   %ebx
  800806:	8b 75 08             	mov    0x8(%ebp),%esi
  800809:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80080c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80080f:	89 f0                	mov    %esi,%eax
  800811:	85 d2                	test   %edx,%edx
  800813:	75 0a                	jne    80081f <strlcpy+0x1e>
  800815:	eb 17                	jmp    80082e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800817:	88 18                	mov    %bl,(%eax)
  800819:	83 c0 01             	add    $0x1,%eax
  80081c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80081f:	83 ea 01             	sub    $0x1,%edx
  800822:	74 07                	je     80082b <strlcpy+0x2a>
  800824:	0f b6 19             	movzbl (%ecx),%ebx
  800827:	84 db                	test   %bl,%bl
  800829:	75 ec                	jne    800817 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80082b:	c6 00 00             	movb   $0x0,(%eax)
  80082e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800830:	5b                   	pop    %ebx
  800831:	5e                   	pop    %esi
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    

00800834 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80083d:	eb 06                	jmp    800845 <strcmp+0x11>
		p++, q++;
  80083f:	83 c1 01             	add    $0x1,%ecx
  800842:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800845:	0f b6 01             	movzbl (%ecx),%eax
  800848:	84 c0                	test   %al,%al
  80084a:	74 04                	je     800850 <strcmp+0x1c>
  80084c:	3a 02                	cmp    (%edx),%al
  80084e:	74 ef                	je     80083f <strcmp+0xb>
  800850:	0f b6 c0             	movzbl %al,%eax
  800853:	0f b6 12             	movzbl (%edx),%edx
  800856:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	53                   	push   %ebx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800864:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800867:	eb 09                	jmp    800872 <strncmp+0x18>
		n--, p++, q++;
  800869:	83 ea 01             	sub    $0x1,%edx
  80086c:	83 c0 01             	add    $0x1,%eax
  80086f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800872:	85 d2                	test   %edx,%edx
  800874:	75 07                	jne    80087d <strncmp+0x23>
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	eb 13                	jmp    800890 <strncmp+0x36>
  80087d:	0f b6 18             	movzbl (%eax),%ebx
  800880:	84 db                	test   %bl,%bl
  800882:	74 04                	je     800888 <strncmp+0x2e>
  800884:	3a 19                	cmp    (%ecx),%bl
  800886:	74 e1                	je     800869 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800888:	0f b6 00             	movzbl (%eax),%eax
  80088b:	0f b6 11             	movzbl (%ecx),%edx
  80088e:	29 d0                	sub    %edx,%eax
}
  800890:	5b                   	pop    %ebx
  800891:	5d                   	pop    %ebp
  800892:	c3                   	ret    

00800893 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80089d:	eb 07                	jmp    8008a6 <strchr+0x13>
		if (*s == c)
  80089f:	38 ca                	cmp    %cl,%dl
  8008a1:	74 0f                	je     8008b2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008a3:	83 c0 01             	add    $0x1,%eax
  8008a6:	0f b6 10             	movzbl (%eax),%edx
  8008a9:	84 d2                	test   %dl,%dl
  8008ab:	75 f2                	jne    80089f <strchr+0xc>
  8008ad:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008be:	eb 07                	jmp    8008c7 <strfind+0x13>
		if (*s == c)
  8008c0:	38 ca                	cmp    %cl,%dl
  8008c2:	74 0a                	je     8008ce <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008c4:	83 c0 01             	add    $0x1,%eax
  8008c7:	0f b6 10             	movzbl (%eax),%edx
  8008ca:	84 d2                	test   %dl,%dl
  8008cc:	75 f2                	jne    8008c0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	89 1c 24             	mov    %ebx,(%esp)
  8008d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008dd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8008e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008ea:	85 c9                	test   %ecx,%ecx
  8008ec:	74 30                	je     80091e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ee:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008f4:	75 25                	jne    80091b <memset+0x4b>
  8008f6:	f6 c1 03             	test   $0x3,%cl
  8008f9:	75 20                	jne    80091b <memset+0x4b>
		c &= 0xFF;
  8008fb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008fe:	89 d3                	mov    %edx,%ebx
  800900:	c1 e3 08             	shl    $0x8,%ebx
  800903:	89 d6                	mov    %edx,%esi
  800905:	c1 e6 18             	shl    $0x18,%esi
  800908:	89 d0                	mov    %edx,%eax
  80090a:	c1 e0 10             	shl    $0x10,%eax
  80090d:	09 f0                	or     %esi,%eax
  80090f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800911:	09 d8                	or     %ebx,%eax
  800913:	c1 e9 02             	shr    $0x2,%ecx
  800916:	fc                   	cld    
  800917:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800919:	eb 03                	jmp    80091e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80091b:	fc                   	cld    
  80091c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80091e:	89 f8                	mov    %edi,%eax
  800920:	8b 1c 24             	mov    (%esp),%ebx
  800923:	8b 74 24 04          	mov    0x4(%esp),%esi
  800927:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80092b:	89 ec                	mov    %ebp,%esp
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	89 34 24             	mov    %esi,(%esp)
  800938:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800942:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800945:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800947:	39 c6                	cmp    %eax,%esi
  800949:	73 35                	jae    800980 <memmove+0x51>
  80094b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80094e:	39 d0                	cmp    %edx,%eax
  800950:	73 2e                	jae    800980 <memmove+0x51>
		s += n;
		d += n;
  800952:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800954:	f6 c2 03             	test   $0x3,%dl
  800957:	75 1b                	jne    800974 <memmove+0x45>
  800959:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80095f:	75 13                	jne    800974 <memmove+0x45>
  800961:	f6 c1 03             	test   $0x3,%cl
  800964:	75 0e                	jne    800974 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800966:	83 ef 04             	sub    $0x4,%edi
  800969:	8d 72 fc             	lea    -0x4(%edx),%esi
  80096c:	c1 e9 02             	shr    $0x2,%ecx
  80096f:	fd                   	std    
  800970:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800972:	eb 09                	jmp    80097d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800974:	83 ef 01             	sub    $0x1,%edi
  800977:	8d 72 ff             	lea    -0x1(%edx),%esi
  80097a:	fd                   	std    
  80097b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80097d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80097e:	eb 20                	jmp    8009a0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800980:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800986:	75 15                	jne    80099d <memmove+0x6e>
  800988:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80098e:	75 0d                	jne    80099d <memmove+0x6e>
  800990:	f6 c1 03             	test   $0x3,%cl
  800993:	75 08                	jne    80099d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800995:	c1 e9 02             	shr    $0x2,%ecx
  800998:	fc                   	cld    
  800999:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099b:	eb 03                	jmp    8009a0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80099d:	fc                   	cld    
  80099e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009a0:	8b 34 24             	mov    (%esp),%esi
  8009a3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009a7:	89 ec                	mov    %ebp,%esp
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	89 04 24             	mov    %eax,(%esp)
  8009c5:	e8 65 ff ff ff       	call   80092f <memmove>
}
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    

008009cc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	57                   	push   %edi
  8009d0:	56                   	push   %esi
  8009d1:	53                   	push   %ebx
  8009d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009db:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e0:	eb 1c                	jmp    8009fe <memcmp+0x32>
		if (*s1 != *s2)
  8009e2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  8009e6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  8009ea:	83 c2 01             	add    $0x1,%edx
  8009ed:	83 e9 01             	sub    $0x1,%ecx
  8009f0:	38 d8                	cmp    %bl,%al
  8009f2:	74 0a                	je     8009fe <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  8009f4:	0f b6 c0             	movzbl %al,%eax
  8009f7:	0f b6 db             	movzbl %bl,%ebx
  8009fa:	29 d8                	sub    %ebx,%eax
  8009fc:	eb 09                	jmp    800a07 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fe:	85 c9                	test   %ecx,%ecx
  800a00:	75 e0                	jne    8009e2 <memcmp+0x16>
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800a07:	5b                   	pop    %ebx
  800a08:	5e                   	pop    %esi
  800a09:	5f                   	pop    %edi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a15:	89 c2                	mov    %eax,%edx
  800a17:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a1a:	eb 07                	jmp    800a23 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a1c:	38 08                	cmp    %cl,(%eax)
  800a1e:	74 07                	je     800a27 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	39 d0                	cmp    %edx,%eax
  800a25:	72 f5                	jb     800a1c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	57                   	push   %edi
  800a2d:	56                   	push   %esi
  800a2e:	53                   	push   %ebx
  800a2f:	83 ec 04             	sub    $0x4,%esp
  800a32:	8b 55 08             	mov    0x8(%ebp),%edx
  800a35:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a38:	eb 03                	jmp    800a3d <strtol+0x14>
		s++;
  800a3a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a3d:	0f b6 02             	movzbl (%edx),%eax
  800a40:	3c 20                	cmp    $0x20,%al
  800a42:	74 f6                	je     800a3a <strtol+0x11>
  800a44:	3c 09                	cmp    $0x9,%al
  800a46:	74 f2                	je     800a3a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a48:	3c 2b                	cmp    $0x2b,%al
  800a4a:	75 0c                	jne    800a58 <strtol+0x2f>
		s++;
  800a4c:	8d 52 01             	lea    0x1(%edx),%edx
  800a4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a56:	eb 15                	jmp    800a6d <strtol+0x44>
	else if (*s == '-')
  800a58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5f:	3c 2d                	cmp    $0x2d,%al
  800a61:	75 0a                	jne    800a6d <strtol+0x44>
		s++, neg = 1;
  800a63:	8d 52 01             	lea    0x1(%edx),%edx
  800a66:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6d:	85 db                	test   %ebx,%ebx
  800a6f:	0f 94 c0             	sete   %al
  800a72:	74 05                	je     800a79 <strtol+0x50>
  800a74:	83 fb 10             	cmp    $0x10,%ebx
  800a77:	75 15                	jne    800a8e <strtol+0x65>
  800a79:	80 3a 30             	cmpb   $0x30,(%edx)
  800a7c:	75 10                	jne    800a8e <strtol+0x65>
  800a7e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a82:	75 0a                	jne    800a8e <strtol+0x65>
		s += 2, base = 16;
  800a84:	83 c2 02             	add    $0x2,%edx
  800a87:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8c:	eb 13                	jmp    800aa1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a8e:	84 c0                	test   %al,%al
  800a90:	74 0f                	je     800aa1 <strtol+0x78>
  800a92:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800a97:	80 3a 30             	cmpb   $0x30,(%edx)
  800a9a:	75 05                	jne    800aa1 <strtol+0x78>
		s++, base = 8;
  800a9c:	83 c2 01             	add    $0x1,%edx
  800a9f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800aa8:	0f b6 0a             	movzbl (%edx),%ecx
  800aab:	89 cf                	mov    %ecx,%edi
  800aad:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ab0:	80 fb 09             	cmp    $0x9,%bl
  800ab3:	77 08                	ja     800abd <strtol+0x94>
			dig = *s - '0';
  800ab5:	0f be c9             	movsbl %cl,%ecx
  800ab8:	83 e9 30             	sub    $0x30,%ecx
  800abb:	eb 1e                	jmp    800adb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800abd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ac0:	80 fb 19             	cmp    $0x19,%bl
  800ac3:	77 08                	ja     800acd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800ac5:	0f be c9             	movsbl %cl,%ecx
  800ac8:	83 e9 57             	sub    $0x57,%ecx
  800acb:	eb 0e                	jmp    800adb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800acd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ad0:	80 fb 19             	cmp    $0x19,%bl
  800ad3:	77 15                	ja     800aea <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ad5:	0f be c9             	movsbl %cl,%ecx
  800ad8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800adb:	39 f1                	cmp    %esi,%ecx
  800add:	7d 0b                	jge    800aea <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800adf:	83 c2 01             	add    $0x1,%edx
  800ae2:	0f af c6             	imul   %esi,%eax
  800ae5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ae8:	eb be                	jmp    800aa8 <strtol+0x7f>
  800aea:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800aec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af0:	74 05                	je     800af7 <strtol+0xce>
		*endptr = (char *) s;
  800af2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800af5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800af7:	89 ca                	mov    %ecx,%edx
  800af9:	f7 da                	neg    %edx
  800afb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aff:	0f 45 c2             	cmovne %edx,%eax
}
  800b02:	83 c4 04             	add    $0x4,%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5f                   	pop    %edi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    
	...

00800b0c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 0c             	sub    $0xc,%esp
  800b12:	89 1c 24             	mov    %ebx,(%esp)
  800b15:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b19:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b22:	b8 01 00 00 00       	mov    $0x1,%eax
  800b27:	89 d1                	mov    %edx,%ecx
  800b29:	89 d3                	mov    %edx,%ebx
  800b2b:	89 d7                	mov    %edx,%edi
  800b2d:	89 d6                	mov    %edx,%esi
  800b2f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b31:	8b 1c 24             	mov    (%esp),%ebx
  800b34:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b38:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b3c:	89 ec                	mov    %ebp,%esp
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 0c             	sub    $0xc,%esp
  800b46:	89 1c 24             	mov    %ebx,(%esp)
  800b49:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
  800b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	89 c3                	mov    %eax,%ebx
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	89 c6                	mov    %eax,%esi
  800b62:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b64:	8b 1c 24             	mov    (%esp),%ebx
  800b67:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b6b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b6f:	89 ec                	mov    %ebp,%esp
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	83 ec 0c             	sub    $0xc,%esp
  800b79:	89 1c 24             	mov    %ebx,(%esp)
  800b7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b80:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b84:	ba 00 00 00 00       	mov    $0x0,%edx
  800b89:	b8 10 00 00 00       	mov    $0x10,%eax
  800b8e:	89 d1                	mov    %edx,%ecx
  800b90:	89 d3                	mov    %edx,%ebx
  800b92:	89 d7                	mov    %edx,%edi
  800b94:	89 d6                	mov    %edx,%esi
  800b96:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800b98:	8b 1c 24             	mov    (%esp),%ebx
  800b9b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b9f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ba3:	89 ec                	mov    %ebp,%esp
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 38             	sub    $0x38,%esp
  800bad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bb0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bb3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bbb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800bc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc6:	89 df                	mov    %ebx,%edi
  800bc8:	89 de                	mov    %ebx,%esi
  800bca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bcc:	85 c0                	test   %eax,%eax
  800bce:	7e 28                	jle    800bf8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bd4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800bdb:	00 
  800bdc:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800be3:	00 
  800be4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800beb:	00 
  800bec:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800bf3:	e8 fc 03 00 00       	call   800ff4 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800bf8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bfb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bfe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c01:	89 ec                	mov    %ebp,%esp
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 38             	sub    $0x38,%esp
  800c0b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c0e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c11:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c19:	b8 0e 00 00 00       	mov    $0xe,%eax
  800c1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c21:	8b 55 08             	mov    0x8(%ebp),%edx
  800c24:	89 df                	mov    %ebx,%edi
  800c26:	89 de                	mov    %ebx,%esi
  800c28:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c2a:	85 c0                	test   %eax,%eax
  800c2c:	7e 28                	jle    800c56 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c32:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800c39:	00 
  800c3a:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800c41:	00 
  800c42:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c49:	00 
  800c4a:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800c51:	e8 9e 03 00 00       	call   800ff4 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800c56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c59:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c5c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c5f:	89 ec                	mov    %ebp,%esp
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 38             	sub    $0x38,%esp
  800c69:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c6f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c77:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	89 cb                	mov    %ecx,%ebx
  800c81:	89 cf                	mov    %ecx,%edi
  800c83:	89 ce                	mov    %ecx,%esi
  800c85:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c87:	85 c0                	test   %eax,%eax
  800c89:	7e 28                	jle    800cb3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c8f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800c96:	00 
  800c97:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800c9e:	00 
  800c9f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca6:	00 
  800ca7:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800cae:	e8 41 03 00 00       	call   800ff4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800cb3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cb6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cb9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cbc:	89 ec                	mov    %ebp,%esp
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 0c             	sub    $0xc,%esp
  800cc6:	89 1c 24             	mov    %ebx,(%esp)
  800cc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ccd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd1:	be 00 00 00 00       	mov    $0x0,%esi
  800cd6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cdb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ce9:	8b 1c 24             	mov    (%esp),%ebx
  800cec:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cf0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cf4:	89 ec                	mov    %ebp,%esp
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 38             	sub    $0x38,%esp
  800cfe:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d01:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d04:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	89 df                	mov    %ebx,%edi
  800d19:	89 de                	mov    %ebx,%esi
  800d1b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7e 28                	jle    800d49 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d21:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d25:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d2c:	00 
  800d2d:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800d34:	00 
  800d35:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d3c:	00 
  800d3d:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800d44:	e8 ab 02 00 00       	call   800ff4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d49:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d4c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d4f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d52:	89 ec                	mov    %ebp,%esp
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	83 ec 38             	sub    $0x38,%esp
  800d5c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d5f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d62:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	89 df                	mov    %ebx,%edi
  800d77:	89 de                	mov    %ebx,%esi
  800d79:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d7b:	85 c0                	test   %eax,%eax
  800d7d:	7e 28                	jle    800da7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d83:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d8a:	00 
  800d8b:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800d92:	00 
  800d93:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d9a:	00 
  800d9b:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800da2:	e8 4d 02 00 00       	call   800ff4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800da7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800daa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dad:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800db0:	89 ec                	mov    %ebp,%esp
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 38             	sub    $0x38,%esp
  800dba:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dbd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dc0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc8:	b8 08 00 00 00       	mov    $0x8,%eax
  800dcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	89 df                	mov    %ebx,%edi
  800dd5:	89 de                	mov    %ebx,%esi
  800dd7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7e 28                	jle    800e05 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800de8:	00 
  800de9:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800df0:	00 
  800df1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df8:	00 
  800df9:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800e00:	e8 ef 01 00 00       	call   800ff4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e05:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e08:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e0b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e0e:	89 ec                	mov    %ebp,%esp
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 38             	sub    $0x38,%esp
  800e18:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e1b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e1e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e26:	b8 06 00 00 00       	mov    $0x6,%eax
  800e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	89 df                	mov    %ebx,%edi
  800e33:	89 de                	mov    %ebx,%esi
  800e35:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e37:	85 c0                	test   %eax,%eax
  800e39:	7e 28                	jle    800e63 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e46:	00 
  800e47:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800e4e:	00 
  800e4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e56:	00 
  800e57:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800e5e:	e8 91 01 00 00       	call   800ff4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e63:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e66:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e6c:	89 ec                	mov    %ebp,%esp
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 38             	sub    $0x38,%esp
  800e76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e79:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e7c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7f:	b8 05 00 00 00       	mov    $0x5,%eax
  800e84:	8b 75 18             	mov    0x18(%ebp),%esi
  800e87:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e90:	8b 55 08             	mov    0x8(%ebp),%edx
  800e93:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7e 28                	jle    800ec1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e99:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ea4:	00 
  800ea5:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800eac:	00 
  800ead:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb4:	00 
  800eb5:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800ebc:	e8 33 01 00 00       	call   800ff4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ec1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eca:	89 ec                	mov    %ebp,%esp
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    

00800ece <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	83 ec 38             	sub    $0x38,%esp
  800ed4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eda:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edd:	be 00 00 00 00       	mov    $0x0,%esi
  800ee2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ee7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	89 f7                	mov    %esi,%edi
  800ef2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	7e 28                	jle    800f20 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f03:	00 
  800f04:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800f0b:	00 
  800f0c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f13:	00 
  800f14:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800f1b:	e8 d4 00 00 00       	call   800ff4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f20:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f23:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f26:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f29:	89 ec                	mov    %ebp,%esp
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 0c             	sub    $0xc,%esp
  800f33:	89 1c 24             	mov    %ebx,(%esp)
  800f36:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f3a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f43:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f48:	89 d1                	mov    %edx,%ecx
  800f4a:	89 d3                	mov    %edx,%ebx
  800f4c:	89 d7                	mov    %edx,%edi
  800f4e:	89 d6                	mov    %edx,%esi
  800f50:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f52:	8b 1c 24             	mov    (%esp),%ebx
  800f55:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f59:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f5d:	89 ec                	mov    %ebp,%esp
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 0c             	sub    $0xc,%esp
  800f67:	89 1c 24             	mov    %ebx,(%esp)
  800f6a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f6e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f72:	ba 00 00 00 00       	mov    $0x0,%edx
  800f77:	b8 02 00 00 00       	mov    $0x2,%eax
  800f7c:	89 d1                	mov    %edx,%ecx
  800f7e:	89 d3                	mov    %edx,%ebx
  800f80:	89 d7                	mov    %edx,%edi
  800f82:	89 d6                	mov    %edx,%esi
  800f84:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f86:	8b 1c 24             	mov    (%esp),%ebx
  800f89:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f8d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f91:	89 ec                	mov    %ebp,%esp
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 38             	sub    $0x38,%esp
  800f9b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f9e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa9:	b8 03 00 00 00       	mov    $0x3,%eax
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	89 cb                	mov    %ecx,%ebx
  800fb3:	89 cf                	mov    %ecx,%edi
  800fb5:	89 ce                	mov    %ecx,%esi
  800fb7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	7e 28                	jle    800fe5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800fc8:	00 
  800fc9:	c7 44 24 08 07 16 80 	movl   $0x801607,0x8(%esp)
  800fd0:	00 
  800fd1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd8:	00 
  800fd9:	c7 04 24 24 16 80 00 	movl   $0x801624,(%esp)
  800fe0:	e8 0f 00 00 00       	call   800ff4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fe5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800feb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fee:	89 ec                	mov    %ebp,%esp
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    
	...

00800ff4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	56                   	push   %esi
  800ff8:	53                   	push   %ebx
  800ff9:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800ffc:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fff:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  801005:	e8 57 ff ff ff       	call   800f61 <sys_getenvid>
  80100a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100d:	89 54 24 10          	mov    %edx,0x10(%esp)
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801018:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80101c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801020:	c7 04 24 34 16 80 00 	movl   $0x801634,(%esp)
  801027:	e8 f9 f0 ff ff       	call   800125 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80102c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801030:	8b 45 10             	mov    0x10(%ebp),%eax
  801033:	89 04 24             	mov    %eax,(%esp)
  801036:	e8 89 f0 ff ff       	call   8000c4 <vcprintf>
	cprintf("\n");
  80103b:	c7 04 24 cc 12 80 00 	movl   $0x8012cc,(%esp)
  801042:	e8 de f0 ff ff       	call   800125 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801047:	cc                   	int3   
  801048:	eb fd                	jmp    801047 <_panic+0x53>
  80104a:	00 00                	add    %al,(%eax)
  80104c:	00 00                	add    %al,(%eax)
	...

00801050 <__udivdi3>:
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	57                   	push   %edi
  801054:	56                   	push   %esi
  801055:	83 ec 10             	sub    $0x10,%esp
  801058:	8b 45 14             	mov    0x14(%ebp),%eax
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	8b 75 10             	mov    0x10(%ebp),%esi
  801061:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801064:	85 c0                	test   %eax,%eax
  801066:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801069:	75 35                	jne    8010a0 <__udivdi3+0x50>
  80106b:	39 fe                	cmp    %edi,%esi
  80106d:	77 61                	ja     8010d0 <__udivdi3+0x80>
  80106f:	85 f6                	test   %esi,%esi
  801071:	75 0b                	jne    80107e <__udivdi3+0x2e>
  801073:	b8 01 00 00 00       	mov    $0x1,%eax
  801078:	31 d2                	xor    %edx,%edx
  80107a:	f7 f6                	div    %esi
  80107c:	89 c6                	mov    %eax,%esi
  80107e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801081:	31 d2                	xor    %edx,%edx
  801083:	89 f8                	mov    %edi,%eax
  801085:	f7 f6                	div    %esi
  801087:	89 c7                	mov    %eax,%edi
  801089:	89 c8                	mov    %ecx,%eax
  80108b:	f7 f6                	div    %esi
  80108d:	89 c1                	mov    %eax,%ecx
  80108f:	89 fa                	mov    %edi,%edx
  801091:	89 c8                	mov    %ecx,%eax
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	5e                   	pop    %esi
  801097:	5f                   	pop    %edi
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    
  80109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010a0:	39 f8                	cmp    %edi,%eax
  8010a2:	77 1c                	ja     8010c0 <__udivdi3+0x70>
  8010a4:	0f bd d0             	bsr    %eax,%edx
  8010a7:	83 f2 1f             	xor    $0x1f,%edx
  8010aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010ad:	75 39                	jne    8010e8 <__udivdi3+0x98>
  8010af:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8010b2:	0f 86 a0 00 00 00    	jbe    801158 <__udivdi3+0x108>
  8010b8:	39 f8                	cmp    %edi,%eax
  8010ba:	0f 82 98 00 00 00    	jb     801158 <__udivdi3+0x108>
  8010c0:	31 ff                	xor    %edi,%edi
  8010c2:	31 c9                	xor    %ecx,%ecx
  8010c4:	89 c8                	mov    %ecx,%eax
  8010c6:	89 fa                	mov    %edi,%edx
  8010c8:	83 c4 10             	add    $0x10,%esp
  8010cb:	5e                   	pop    %esi
  8010cc:	5f                   	pop    %edi
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    
  8010cf:	90                   	nop
  8010d0:	89 d1                	mov    %edx,%ecx
  8010d2:	89 fa                	mov    %edi,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	31 ff                	xor    %edi,%edi
  8010d8:	f7 f6                	div    %esi
  8010da:	89 c1                	mov    %eax,%ecx
  8010dc:	89 fa                	mov    %edi,%edx
  8010de:	89 c8                	mov    %ecx,%eax
  8010e0:	83 c4 10             	add    $0x10,%esp
  8010e3:	5e                   	pop    %esi
  8010e4:	5f                   	pop    %edi
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    
  8010e7:	90                   	nop
  8010e8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8010ec:	89 f2                	mov    %esi,%edx
  8010ee:	d3 e0                	shl    %cl,%eax
  8010f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010f3:	b8 20 00 00 00       	mov    $0x20,%eax
  8010f8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8010fb:	89 c1                	mov    %eax,%ecx
  8010fd:	d3 ea                	shr    %cl,%edx
  8010ff:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801103:	0b 55 ec             	or     -0x14(%ebp),%edx
  801106:	d3 e6                	shl    %cl,%esi
  801108:	89 c1                	mov    %eax,%ecx
  80110a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80110d:	89 fe                	mov    %edi,%esi
  80110f:	d3 ee                	shr    %cl,%esi
  801111:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801115:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801118:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111b:	d3 e7                	shl    %cl,%edi
  80111d:	89 c1                	mov    %eax,%ecx
  80111f:	d3 ea                	shr    %cl,%edx
  801121:	09 d7                	or     %edx,%edi
  801123:	89 f2                	mov    %esi,%edx
  801125:	89 f8                	mov    %edi,%eax
  801127:	f7 75 ec             	divl   -0x14(%ebp)
  80112a:	89 d6                	mov    %edx,%esi
  80112c:	89 c7                	mov    %eax,%edi
  80112e:	f7 65 e8             	mull   -0x18(%ebp)
  801131:	39 d6                	cmp    %edx,%esi
  801133:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801136:	72 30                	jb     801168 <__udivdi3+0x118>
  801138:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80113f:	d3 e2                	shl    %cl,%edx
  801141:	39 c2                	cmp    %eax,%edx
  801143:	73 05                	jae    80114a <__udivdi3+0xfa>
  801145:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801148:	74 1e                	je     801168 <__udivdi3+0x118>
  80114a:	89 f9                	mov    %edi,%ecx
  80114c:	31 ff                	xor    %edi,%edi
  80114e:	e9 71 ff ff ff       	jmp    8010c4 <__udivdi3+0x74>
  801153:	90                   	nop
  801154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801158:	31 ff                	xor    %edi,%edi
  80115a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80115f:	e9 60 ff ff ff       	jmp    8010c4 <__udivdi3+0x74>
  801164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801168:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80116b:	31 ff                	xor    %edi,%edi
  80116d:	89 c8                	mov    %ecx,%eax
  80116f:	89 fa                	mov    %edi,%edx
  801171:	83 c4 10             	add    $0x10,%esp
  801174:	5e                   	pop    %esi
  801175:	5f                   	pop    %edi
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    
	...

00801180 <__umoddi3>:
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	57                   	push   %edi
  801184:	56                   	push   %esi
  801185:	83 ec 20             	sub    $0x20,%esp
  801188:	8b 55 14             	mov    0x14(%ebp),%edx
  80118b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80118e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801191:	8b 75 0c             	mov    0xc(%ebp),%esi
  801194:	85 d2                	test   %edx,%edx
  801196:	89 c8                	mov    %ecx,%eax
  801198:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80119b:	75 13                	jne    8011b0 <__umoddi3+0x30>
  80119d:	39 f7                	cmp    %esi,%edi
  80119f:	76 3f                	jbe    8011e0 <__umoddi3+0x60>
  8011a1:	89 f2                	mov    %esi,%edx
  8011a3:	f7 f7                	div    %edi
  8011a5:	89 d0                	mov    %edx,%eax
  8011a7:	31 d2                	xor    %edx,%edx
  8011a9:	83 c4 20             	add    $0x20,%esp
  8011ac:	5e                   	pop    %esi
  8011ad:	5f                   	pop    %edi
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    
  8011b0:	39 f2                	cmp    %esi,%edx
  8011b2:	77 4c                	ja     801200 <__umoddi3+0x80>
  8011b4:	0f bd ca             	bsr    %edx,%ecx
  8011b7:	83 f1 1f             	xor    $0x1f,%ecx
  8011ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8011bd:	75 51                	jne    801210 <__umoddi3+0x90>
  8011bf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8011c2:	0f 87 e0 00 00 00    	ja     8012a8 <__umoddi3+0x128>
  8011c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cb:	29 f8                	sub    %edi,%eax
  8011cd:	19 d6                	sbb    %edx,%esi
  8011cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d5:	89 f2                	mov    %esi,%edx
  8011d7:	83 c4 20             	add    $0x20,%esp
  8011da:	5e                   	pop    %esi
  8011db:	5f                   	pop    %edi
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    
  8011de:	66 90                	xchg   %ax,%ax
  8011e0:	85 ff                	test   %edi,%edi
  8011e2:	75 0b                	jne    8011ef <__umoddi3+0x6f>
  8011e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8011e9:	31 d2                	xor    %edx,%edx
  8011eb:	f7 f7                	div    %edi
  8011ed:	89 c7                	mov    %eax,%edi
  8011ef:	89 f0                	mov    %esi,%eax
  8011f1:	31 d2                	xor    %edx,%edx
  8011f3:	f7 f7                	div    %edi
  8011f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f8:	f7 f7                	div    %edi
  8011fa:	eb a9                	jmp    8011a5 <__umoddi3+0x25>
  8011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801200:	89 c8                	mov    %ecx,%eax
  801202:	89 f2                	mov    %esi,%edx
  801204:	83 c4 20             	add    $0x20,%esp
  801207:	5e                   	pop    %esi
  801208:	5f                   	pop    %edi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    
  80120b:	90                   	nop
  80120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801210:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801214:	d3 e2                	shl    %cl,%edx
  801216:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801219:	ba 20 00 00 00       	mov    $0x20,%edx
  80121e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801221:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801224:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801228:	89 fa                	mov    %edi,%edx
  80122a:	d3 ea                	shr    %cl,%edx
  80122c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801230:	0b 55 f4             	or     -0xc(%ebp),%edx
  801233:	d3 e7                	shl    %cl,%edi
  801235:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801239:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80123c:	89 f2                	mov    %esi,%edx
  80123e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801241:	89 c7                	mov    %eax,%edi
  801243:	d3 ea                	shr    %cl,%edx
  801245:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	d3 e6                	shl    %cl,%esi
  801250:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801254:	d3 ea                	shr    %cl,%edx
  801256:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80125a:	09 d6                	or     %edx,%esi
  80125c:	89 f0                	mov    %esi,%eax
  80125e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801261:	d3 e7                	shl    %cl,%edi
  801263:	89 f2                	mov    %esi,%edx
  801265:	f7 75 f4             	divl   -0xc(%ebp)
  801268:	89 d6                	mov    %edx,%esi
  80126a:	f7 65 e8             	mull   -0x18(%ebp)
  80126d:	39 d6                	cmp    %edx,%esi
  80126f:	72 2b                	jb     80129c <__umoddi3+0x11c>
  801271:	39 c7                	cmp    %eax,%edi
  801273:	72 23                	jb     801298 <__umoddi3+0x118>
  801275:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801279:	29 c7                	sub    %eax,%edi
  80127b:	19 d6                	sbb    %edx,%esi
  80127d:	89 f0                	mov    %esi,%eax
  80127f:	89 f2                	mov    %esi,%edx
  801281:	d3 ef                	shr    %cl,%edi
  801283:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801287:	d3 e0                	shl    %cl,%eax
  801289:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80128d:	09 f8                	or     %edi,%eax
  80128f:	d3 ea                	shr    %cl,%edx
  801291:	83 c4 20             	add    $0x20,%esp
  801294:	5e                   	pop    %esi
  801295:	5f                   	pop    %edi
  801296:	5d                   	pop    %ebp
  801297:	c3                   	ret    
  801298:	39 d6                	cmp    %edx,%esi
  80129a:	75 d9                	jne    801275 <__umoddi3+0xf5>
  80129c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80129f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8012a2:	eb d1                	jmp    801275 <__umoddi3+0xf5>
  8012a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012a8:	39 f2                	cmp    %esi,%edx
  8012aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012b0:	0f 82 12 ff ff ff    	jb     8011c8 <__umoddi3+0x48>
  8012b6:	e9 17 ff ff ff       	jmp    8011d2 <__umoddi3+0x52>
