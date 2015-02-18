
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800047:	c7 04 24 80 17 80 00 	movl   $0x801780,(%esp)
  80004e:	e8 32 01 00 00       	call   800185 <cprintf>
	if ((env = fork()) == 0) {
  800053:	e8 1e 10 00 00       	call   801076 <fork>
  800058:	89 c3                	mov    %eax,%ebx
  80005a:	85 c0                	test   %eax,%eax
  80005c:	75 0e                	jne    80006c <umain+0x2c>
		cprintf("I am the child.  Spinning...\n");
  80005e:	c7 04 24 f8 17 80 00 	movl   $0x8017f8,(%esp)
  800065:	e8 1b 01 00 00       	call   800185 <cprintf>
  80006a:	eb fe                	jmp    80006a <umain+0x2a>
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  80006c:	c7 04 24 a8 17 80 00 	movl   $0x8017a8,(%esp)
  800073:	e8 0d 01 00 00       	call   800185 <cprintf>
	sys_yield();
  800078:	e8 10 0f 00 00       	call   800f8d <sys_yield>
	sys_yield();
  80007d:	e8 0b 0f 00 00       	call   800f8d <sys_yield>
	sys_yield();
  800082:	e8 06 0f 00 00       	call   800f8d <sys_yield>
	sys_yield();
  800087:	e8 01 0f 00 00       	call   800f8d <sys_yield>
	sys_yield();
  80008c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800090:	e8 f8 0e 00 00       	call   800f8d <sys_yield>
	sys_yield();
  800095:	e8 f3 0e 00 00       	call   800f8d <sys_yield>
	sys_yield();
  80009a:	e8 ee 0e 00 00       	call   800f8d <sys_yield>
	sys_yield();
  80009f:	90                   	nop
  8000a0:	e8 e8 0e 00 00       	call   800f8d <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  8000a5:	c7 04 24 d0 17 80 00 	movl   $0x8017d0,(%esp)
  8000ac:	e8 d4 00 00 00       	call   800185 <cprintf>
	sys_env_destroy(env);
  8000b1:	89 1c 24             	mov    %ebx,(%esp)
  8000b4:	e8 3c 0f 00 00       	call   800ff5 <sys_env_destroy>
}
  8000b9:	83 c4 14             	add    $0x14,%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5d                   	pop    %ebp
  8000be:	c3                   	ret    
	...

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 18             	sub    $0x18,%esp
  8000c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000c9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8000cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8000d2:	e8 ea 0e 00 00       	call   800fc1 <sys_getenvid>
  8000d7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000dc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000df:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8000e4:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e9:	85 f6                	test   %esi,%esi
  8000eb:	7e 07                	jle    8000f4 <libmain+0x34>
		binaryname = argv[0];
  8000ed:	8b 03                	mov    (%ebx),%eax
  8000ef:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000f8:	89 34 24             	mov    %esi,(%esp)
  8000fb:	e8 40 ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800100:	e8 0b 00 00 00       	call   800110 <exit>
}
  800105:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800108:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80010b:	89 ec                	mov    %ebp,%esp
  80010d:	5d                   	pop    %ebp
  80010e:	c3                   	ret    
	...

00800110 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800116:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80011d:	e8 d3 0e 00 00       	call   800ff5 <sys_env_destroy>
}
  800122:	c9                   	leave  
  800123:	c3                   	ret    

00800124 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80012d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800134:	00 00 00 
	b.cnt = 0;
  800137:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80013e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800141:	8b 45 0c             	mov    0xc(%ebp),%eax
  800144:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800148:	8b 45 08             	mov    0x8(%ebp),%eax
  80014b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80014f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800155:	89 44 24 04          	mov    %eax,0x4(%esp)
  800159:	c7 04 24 9f 01 80 00 	movl   $0x80019f,(%esp)
  800160:	e8 be 01 00 00       	call   800323 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800165:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800175:	89 04 24             	mov    %eax,(%esp)
  800178:	e8 23 0a 00 00       	call   800ba0 <sys_cputs>

	return b.cnt;
}
  80017d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80018b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80018e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800192:	8b 45 08             	mov    0x8(%ebp),%eax
  800195:	89 04 24             	mov    %eax,(%esp)
  800198:	e8 87 ff ff ff       	call   800124 <vcprintf>
	va_end(ap);

	return cnt;
}
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    

0080019f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	53                   	push   %ebx
  8001a3:	83 ec 14             	sub    $0x14,%esp
  8001a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a9:	8b 03                	mov    (%ebx),%eax
  8001ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ae:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001b2:	83 c0 01             	add    $0x1,%eax
  8001b5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bc:	75 19                	jne    8001d7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001be:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001c5:	00 
  8001c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c9:	89 04 24             	mov    %eax,(%esp)
  8001cc:	e8 cf 09 00 00       	call   800ba0 <sys_cputs>
		b->idx = 0;
  8001d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001d7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001db:	83 c4 14             	add    $0x14,%esp
  8001de:	5b                   	pop    %ebx
  8001df:	5d                   	pop    %ebp
  8001e0:	c3                   	ret    
  8001e1:	00 00                	add    %al,(%eax)
	...

008001e4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	57                   	push   %edi
  8001e8:	56                   	push   %esi
  8001e9:	53                   	push   %ebx
  8001ea:	83 ec 4c             	sub    $0x4c,%esp
  8001ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001f0:	89 d6                	mov    %edx,%esi
  8001f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8001fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800201:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800204:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800207:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80020a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020f:	39 d1                	cmp    %edx,%ecx
  800211:	72 07                	jb     80021a <printnum+0x36>
  800213:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800216:	39 d0                	cmp    %edx,%eax
  800218:	77 69                	ja     800283 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80021a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80021e:	83 eb 01             	sub    $0x1,%ebx
  800221:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800225:	89 44 24 08          	mov    %eax,0x8(%esp)
  800229:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  80022d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800231:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800234:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800237:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80023a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80023e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800245:	00 
  800246:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800249:	89 04 24             	mov    %eax,(%esp)
  80024c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80024f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800253:	e8 b8 12 00 00       	call   801510 <__udivdi3>
  800258:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80025b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80025e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800262:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800266:	89 04 24             	mov    %eax,(%esp)
  800269:	89 54 24 04          	mov    %edx,0x4(%esp)
  80026d:	89 f2                	mov    %esi,%edx
  80026f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800272:	e8 6d ff ff ff       	call   8001e4 <printnum>
  800277:	eb 11                	jmp    80028a <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800279:	89 74 24 04          	mov    %esi,0x4(%esp)
  80027d:	89 3c 24             	mov    %edi,(%esp)
  800280:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800283:	83 eb 01             	sub    $0x1,%ebx
  800286:	85 db                	test   %ebx,%ebx
  800288:	7f ef                	jg     800279 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80028e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800292:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800295:	89 44 24 08          	mov    %eax,0x8(%esp)
  800299:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002a0:	00 
  8002a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002a4:	89 14 24             	mov    %edx,(%esp)
  8002a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002ae:	e8 8d 13 00 00       	call   801640 <__umoddi3>
  8002b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b7:	0f be 80 20 18 80 00 	movsbl 0x801820(%eax),%eax
  8002be:	89 04 24             	mov    %eax,(%esp)
  8002c1:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002c4:	83 c4 4c             	add    $0x4c,%esp
  8002c7:	5b                   	pop    %ebx
  8002c8:	5e                   	pop    %esi
  8002c9:	5f                   	pop    %edi
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    

008002cc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002cf:	83 fa 01             	cmp    $0x1,%edx
  8002d2:	7e 0e                	jle    8002e2 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002d4:	8b 10                	mov    (%eax),%edx
  8002d6:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002d9:	89 08                	mov    %ecx,(%eax)
  8002db:	8b 02                	mov    (%edx),%eax
  8002dd:	8b 52 04             	mov    0x4(%edx),%edx
  8002e0:	eb 22                	jmp    800304 <getuint+0x38>
	else if (lflag)
  8002e2:	85 d2                	test   %edx,%edx
  8002e4:	74 10                	je     8002f6 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002eb:	89 08                	mov    %ecx,(%eax)
  8002ed:	8b 02                	mov    (%edx),%eax
  8002ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f4:	eb 0e                	jmp    800304 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002f6:	8b 10                	mov    (%eax),%edx
  8002f8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002fb:	89 08                	mov    %ecx,(%eax)
  8002fd:	8b 02                	mov    (%edx),%eax
  8002ff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80030c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800310:	8b 10                	mov    (%eax),%edx
  800312:	3b 50 04             	cmp    0x4(%eax),%edx
  800315:	73 0a                	jae    800321 <sprintputch+0x1b>
		*b->buf++ = ch;
  800317:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80031a:	88 0a                	mov    %cl,(%edx)
  80031c:	83 c2 01             	add    $0x1,%edx
  80031f:	89 10                	mov    %edx,(%eax)
}
  800321:	5d                   	pop    %ebp
  800322:	c3                   	ret    

00800323 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	57                   	push   %edi
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
  800329:	83 ec 4c             	sub    $0x4c,%esp
  80032c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80032f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800332:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800335:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  80033c:	eb 11                	jmp    80034f <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80033e:	85 c0                	test   %eax,%eax
  800340:	0f 84 b6 03 00 00    	je     8006fc <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800346:	89 74 24 04          	mov    %esi,0x4(%esp)
  80034a:	89 04 24             	mov    %eax,(%esp)
  80034d:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80034f:	0f b6 03             	movzbl (%ebx),%eax
  800352:	83 c3 01             	add    $0x1,%ebx
  800355:	83 f8 25             	cmp    $0x25,%eax
  800358:	75 e4                	jne    80033e <vprintfmt+0x1b>
  80035a:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80035e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800365:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80036c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800373:	b9 00 00 00 00       	mov    $0x0,%ecx
  800378:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80037b:	eb 06                	jmp    800383 <vprintfmt+0x60>
  80037d:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800381:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800383:	0f b6 0b             	movzbl (%ebx),%ecx
  800386:	0f b6 c1             	movzbl %cl,%eax
  800389:	8d 53 01             	lea    0x1(%ebx),%edx
  80038c:	83 e9 23             	sub    $0x23,%ecx
  80038f:	80 f9 55             	cmp    $0x55,%cl
  800392:	0f 87 47 03 00 00    	ja     8006df <vprintfmt+0x3bc>
  800398:	0f b6 c9             	movzbl %cl,%ecx
  80039b:	ff 24 8d 60 19 80 00 	jmp    *0x801960(,%ecx,4)
  8003a2:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8003a6:	eb d9                	jmp    800381 <vprintfmt+0x5e>
  8003a8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8003af:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003b4:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003b7:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003bb:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8003be:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003c1:	83 fb 09             	cmp    $0x9,%ebx
  8003c4:	77 30                	ja     8003f6 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003c6:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003c9:	eb e9                	jmp    8003b4 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ce:	8d 48 04             	lea    0x4(%eax),%ecx
  8003d1:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8003d9:	eb 1e                	jmp    8003f9 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8003db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003df:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e4:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8003e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003eb:	eb 94                	jmp    800381 <vprintfmt+0x5e>
  8003ed:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003f4:	eb 8b                	jmp    800381 <vprintfmt+0x5e>
  8003f6:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8003f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003fd:	79 82                	jns    800381 <vprintfmt+0x5e>
  8003ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800402:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800405:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800408:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80040b:	e9 71 ff ff ff       	jmp    800381 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800410:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800414:	e9 68 ff ff ff       	jmp    800381 <vprintfmt+0x5e>
  800419:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80041c:	8b 45 14             	mov    0x14(%ebp),%eax
  80041f:	8d 50 04             	lea    0x4(%eax),%edx
  800422:	89 55 14             	mov    %edx,0x14(%ebp)
  800425:	89 74 24 04          	mov    %esi,0x4(%esp)
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	89 04 24             	mov    %eax,(%esp)
  80042e:	ff d7                	call   *%edi
  800430:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800433:	e9 17 ff ff ff       	jmp    80034f <vprintfmt+0x2c>
  800438:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80043b:	8b 45 14             	mov    0x14(%ebp),%eax
  80043e:	8d 50 04             	lea    0x4(%eax),%edx
  800441:	89 55 14             	mov    %edx,0x14(%ebp)
  800444:	8b 00                	mov    (%eax),%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	c1 fa 1f             	sar    $0x1f,%edx
  80044b:	31 d0                	xor    %edx,%eax
  80044d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044f:	83 f8 11             	cmp    $0x11,%eax
  800452:	7f 0b                	jg     80045f <vprintfmt+0x13c>
  800454:	8b 14 85 c0 1a 80 00 	mov    0x801ac0(,%eax,4),%edx
  80045b:	85 d2                	test   %edx,%edx
  80045d:	75 20                	jne    80047f <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80045f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800463:	c7 44 24 08 31 18 80 	movl   $0x801831,0x8(%esp)
  80046a:	00 
  80046b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80046f:	89 3c 24             	mov    %edi,(%esp)
  800472:	e8 0d 03 00 00       	call   800784 <printfmt>
  800477:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047a:	e9 d0 fe ff ff       	jmp    80034f <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80047f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800483:	c7 44 24 08 3a 18 80 	movl   $0x80183a,0x8(%esp)
  80048a:	00 
  80048b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80048f:	89 3c 24             	mov    %edi,(%esp)
  800492:	e8 ed 02 00 00       	call   800784 <printfmt>
  800497:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80049a:	e9 b0 fe ff ff       	jmp    80034f <vprintfmt+0x2c>
  80049f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8004a2:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ae:	8d 50 04             	lea    0x4(%eax),%edx
  8004b1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b4:	8b 18                	mov    (%eax),%ebx
  8004b6:	85 db                	test   %ebx,%ebx
  8004b8:	b8 3d 18 80 00       	mov    $0x80183d,%eax
  8004bd:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8004c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004c4:	7e 76                	jle    80053c <vprintfmt+0x219>
  8004c6:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8004ca:	74 7a                	je     800546 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004d0:	89 1c 24             	mov    %ebx,(%esp)
  8004d3:	e8 f0 02 00 00       	call   8007c8 <strnlen>
  8004d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004db:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8004dd:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8004e1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004e4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004e7:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e9:	eb 0f                	jmp    8004fa <vprintfmt+0x1d7>
					putch(padc, putdat);
  8004eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	89 04 24             	mov    %eax,(%esp)
  8004f5:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f7:	83 eb 01             	sub    $0x1,%ebx
  8004fa:	85 db                	test   %ebx,%ebx
  8004fc:	7f ed                	jg     8004eb <vprintfmt+0x1c8>
  8004fe:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800501:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800504:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800507:	89 f7                	mov    %esi,%edi
  800509:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80050c:	eb 40                	jmp    80054e <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80050e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800512:	74 18                	je     80052c <vprintfmt+0x209>
  800514:	8d 50 e0             	lea    -0x20(%eax),%edx
  800517:	83 fa 5e             	cmp    $0x5e,%edx
  80051a:	76 10                	jbe    80052c <vprintfmt+0x209>
					putch('?', putdat);
  80051c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800520:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800527:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80052a:	eb 0a                	jmp    800536 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  80052c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800530:	89 04 24             	mov    %eax,(%esp)
  800533:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800536:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80053a:	eb 12                	jmp    80054e <vprintfmt+0x22b>
  80053c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80053f:	89 f7                	mov    %esi,%edi
  800541:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800544:	eb 08                	jmp    80054e <vprintfmt+0x22b>
  800546:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800549:	89 f7                	mov    %esi,%edi
  80054b:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80054e:	0f be 03             	movsbl (%ebx),%eax
  800551:	83 c3 01             	add    $0x1,%ebx
  800554:	85 c0                	test   %eax,%eax
  800556:	74 25                	je     80057d <vprintfmt+0x25a>
  800558:	85 f6                	test   %esi,%esi
  80055a:	78 b2                	js     80050e <vprintfmt+0x1eb>
  80055c:	83 ee 01             	sub    $0x1,%esi
  80055f:	79 ad                	jns    80050e <vprintfmt+0x1eb>
  800561:	89 fe                	mov    %edi,%esi
  800563:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800566:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800569:	eb 1a                	jmp    800585 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80056b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80056f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800576:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800578:	83 eb 01             	sub    $0x1,%ebx
  80057b:	eb 08                	jmp    800585 <vprintfmt+0x262>
  80057d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800580:	89 fe                	mov    %edi,%esi
  800582:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800585:	85 db                	test   %ebx,%ebx
  800587:	7f e2                	jg     80056b <vprintfmt+0x248>
  800589:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80058c:	e9 be fd ff ff       	jmp    80034f <vprintfmt+0x2c>
  800591:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800594:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800597:	83 f9 01             	cmp    $0x1,%ecx
  80059a:	7e 16                	jle    8005b2 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8d 50 08             	lea    0x8(%eax),%edx
  8005a2:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a5:	8b 10                	mov    (%eax),%edx
  8005a7:	8b 48 04             	mov    0x4(%eax),%ecx
  8005aa:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8005ad:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b0:	eb 32                	jmp    8005e4 <vprintfmt+0x2c1>
	else if (lflag)
  8005b2:	85 c9                	test   %ecx,%ecx
  8005b4:	74 18                	je     8005ce <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8d 50 04             	lea    0x4(%eax),%edx
  8005bc:	89 55 14             	mov    %edx,0x14(%ebp)
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c4:	89 c1                	mov    %eax,%ecx
  8005c6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005cc:	eb 16                	jmp    8005e4 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8d 50 04             	lea    0x4(%eax),%edx
  8005d4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dc:	89 c2                	mov    %eax,%edx
  8005de:	c1 fa 1f             	sar    $0x1f,%edx
  8005e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005e4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005e7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005ea:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f3:	0f 89 a7 00 00 00    	jns    8006a0 <vprintfmt+0x37d>
				putch('-', putdat);
  8005f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800604:	ff d7                	call   *%edi
				num = -(long long) num;
  800606:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800609:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80060c:	f7 d9                	neg    %ecx
  80060e:	83 d3 00             	adc    $0x0,%ebx
  800611:	f7 db                	neg    %ebx
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
  800618:	e9 83 00 00 00       	jmp    8006a0 <vprintfmt+0x37d>
  80061d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800620:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800623:	89 ca                	mov    %ecx,%edx
  800625:	8d 45 14             	lea    0x14(%ebp),%eax
  800628:	e8 9f fc ff ff       	call   8002cc <getuint>
  80062d:	89 c1                	mov    %eax,%ecx
  80062f:	89 d3                	mov    %edx,%ebx
  800631:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800636:	eb 68                	jmp    8006a0 <vprintfmt+0x37d>
  800638:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80063b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80063e:	89 ca                	mov    %ecx,%edx
  800640:	8d 45 14             	lea    0x14(%ebp),%eax
  800643:	e8 84 fc ff ff       	call   8002cc <getuint>
  800648:	89 c1                	mov    %eax,%ecx
  80064a:	89 d3                	mov    %edx,%ebx
  80064c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800651:	eb 4d                	jmp    8006a0 <vprintfmt+0x37d>
  800653:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800656:	89 74 24 04          	mov    %esi,0x4(%esp)
  80065a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800661:	ff d7                	call   *%edi
			putch('x', putdat);
  800663:	89 74 24 04          	mov    %esi,0x4(%esp)
  800667:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80066e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 50 04             	lea    0x4(%eax),%edx
  800676:	89 55 14             	mov    %edx,0x14(%ebp)
  800679:	8b 08                	mov    (%eax),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800685:	eb 19                	jmp    8006a0 <vprintfmt+0x37d>
  800687:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80068a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80068d:	89 ca                	mov    %ecx,%edx
  80068f:	8d 45 14             	lea    0x14(%ebp),%eax
  800692:	e8 35 fc ff ff       	call   8002cc <getuint>
  800697:	89 c1                	mov    %eax,%ecx
  800699:	89 d3                	mov    %edx,%ebx
  80069b:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006a0:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8006a4:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006b3:	89 0c 24             	mov    %ecx,(%esp)
  8006b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006ba:	89 f2                	mov    %esi,%edx
  8006bc:	89 f8                	mov    %edi,%eax
  8006be:	e8 21 fb ff ff       	call   8001e4 <printnum>
  8006c3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006c6:	e9 84 fc ff ff       	jmp    80034f <vprintfmt+0x2c>
  8006cb:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006d2:	89 04 24             	mov    %eax,(%esp)
  8006d5:	ff d7                	call   *%edi
  8006d7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006da:	e9 70 fc ff ff       	jmp    80034f <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006ea:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8006ef:	80 38 25             	cmpb   $0x25,(%eax)
  8006f2:	0f 84 57 fc ff ff    	je     80034f <vprintfmt+0x2c>
  8006f8:	89 c3                	mov    %eax,%ebx
  8006fa:	eb f0                	jmp    8006ec <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8006fc:	83 c4 4c             	add    $0x4c,%esp
  8006ff:	5b                   	pop    %ebx
  800700:	5e                   	pop    %esi
  800701:	5f                   	pop    %edi
  800702:	5d                   	pop    %ebp
  800703:	c3                   	ret    

00800704 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 28             	sub    $0x28,%esp
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800710:	85 c0                	test   %eax,%eax
  800712:	74 04                	je     800718 <vsnprintf+0x14>
  800714:	85 d2                	test   %edx,%edx
  800716:	7f 07                	jg     80071f <vsnprintf+0x1b>
  800718:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80071d:	eb 3b                	jmp    80075a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80071f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800722:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800729:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800737:	8b 45 10             	mov    0x10(%ebp),%eax
  80073a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80073e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800741:	89 44 24 04          	mov    %eax,0x4(%esp)
  800745:	c7 04 24 06 03 80 00 	movl   $0x800306,(%esp)
  80074c:	e8 d2 fb ff ff       	call   800323 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800754:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800757:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800762:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800765:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800769:	8b 45 10             	mov    0x10(%ebp),%eax
  80076c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800770:	8b 45 0c             	mov    0xc(%ebp),%eax
  800773:	89 44 24 04          	mov    %eax,0x4(%esp)
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 04 24             	mov    %eax,(%esp)
  80077d:	e8 82 ff ff ff       	call   800704 <vsnprintf>
	va_end(ap);

	return rc;
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80078a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80078d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800791:	8b 45 10             	mov    0x10(%ebp),%eax
  800794:	89 44 24 08          	mov    %eax,0x8(%esp)
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	89 04 24             	mov    %eax,(%esp)
  8007a5:	e8 79 fb ff ff       	call   800323 <vprintfmt>
	va_end(ap);
}
  8007aa:	c9                   	leave  
  8007ab:	c3                   	ret    
  8007ac:	00 00                	add    %al,(%eax)
	...

008007b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007b6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8007bb:	eb 03                	jmp    8007c0 <strlen+0x10>
		n++;
  8007bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007c4:	75 f7                	jne    8007bd <strlen+0xd>
		n++;
	return n;
}
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	53                   	push   %ebx
  8007cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d7:	eb 03                	jmp    8007dc <strnlen+0x14>
		n++;
  8007d9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007dc:	39 c1                	cmp    %eax,%ecx
  8007de:	74 06                	je     8007e6 <strnlen+0x1e>
  8007e0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8007e4:	75 f3                	jne    8007d9 <strnlen+0x11>
		n++;
	return n;
}
  8007e6:	5b                   	pop    %ebx
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	53                   	push   %ebx
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007f3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007f8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007ff:	83 c2 01             	add    $0x1,%edx
  800802:	84 c9                	test   %cl,%cl
  800804:	75 f2                	jne    8007f8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800806:	5b                   	pop    %ebx
  800807:	5d                   	pop    %ebp
  800808:	c3                   	ret    

00800809 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800809:	55                   	push   %ebp
  80080a:	89 e5                	mov    %esp,%ebp
  80080c:	53                   	push   %ebx
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800813:	89 1c 24             	mov    %ebx,(%esp)
  800816:	e8 95 ff ff ff       	call   8007b0 <strlen>
	strcpy(dst + len, src);
  80081b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800822:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800825:	89 04 24             	mov    %eax,(%esp)
  800828:	e8 bc ff ff ff       	call   8007e9 <strcpy>
	return dst;
}
  80082d:	89 d8                	mov    %ebx,%eax
  80082f:	83 c4 08             	add    $0x8,%esp
  800832:	5b                   	pop    %ebx
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	56                   	push   %esi
  800839:	53                   	push   %ebx
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800840:	8b 75 10             	mov    0x10(%ebp),%esi
  800843:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800848:	eb 0f                	jmp    800859 <strncpy+0x24>
		*dst++ = *src;
  80084a:	0f b6 19             	movzbl (%ecx),%ebx
  80084d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800850:	80 39 01             	cmpb   $0x1,(%ecx)
  800853:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800856:	83 c2 01             	add    $0x1,%edx
  800859:	39 f2                	cmp    %esi,%edx
  80085b:	72 ed                	jb     80084a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80085d:	5b                   	pop    %ebx
  80085e:	5e                   	pop    %esi
  80085f:	5d                   	pop    %ebp
  800860:	c3                   	ret    

00800861 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	56                   	push   %esi
  800865:	53                   	push   %ebx
  800866:	8b 75 08             	mov    0x8(%ebp),%esi
  800869:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80086c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80086f:	89 f0                	mov    %esi,%eax
  800871:	85 d2                	test   %edx,%edx
  800873:	75 0a                	jne    80087f <strlcpy+0x1e>
  800875:	eb 17                	jmp    80088e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800877:	88 18                	mov    %bl,(%eax)
  800879:	83 c0 01             	add    $0x1,%eax
  80087c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80087f:	83 ea 01             	sub    $0x1,%edx
  800882:	74 07                	je     80088b <strlcpy+0x2a>
  800884:	0f b6 19             	movzbl (%ecx),%ebx
  800887:	84 db                	test   %bl,%bl
  800889:	75 ec                	jne    800877 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80088b:	c6 00 00             	movb   $0x0,(%eax)
  80088e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800890:	5b                   	pop    %ebx
  800891:	5e                   	pop    %esi
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80089d:	eb 06                	jmp    8008a5 <strcmp+0x11>
		p++, q++;
  80089f:	83 c1 01             	add    $0x1,%ecx
  8008a2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008a5:	0f b6 01             	movzbl (%ecx),%eax
  8008a8:	84 c0                	test   %al,%al
  8008aa:	74 04                	je     8008b0 <strcmp+0x1c>
  8008ac:	3a 02                	cmp    (%edx),%al
  8008ae:	74 ef                	je     80089f <strcmp+0xb>
  8008b0:	0f b6 c0             	movzbl %al,%eax
  8008b3:	0f b6 12             	movzbl (%edx),%edx
  8008b6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	53                   	push   %ebx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8008c7:	eb 09                	jmp    8008d2 <strncmp+0x18>
		n--, p++, q++;
  8008c9:	83 ea 01             	sub    $0x1,%edx
  8008cc:	83 c0 01             	add    $0x1,%eax
  8008cf:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008d2:	85 d2                	test   %edx,%edx
  8008d4:	75 07                	jne    8008dd <strncmp+0x23>
  8008d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008db:	eb 13                	jmp    8008f0 <strncmp+0x36>
  8008dd:	0f b6 18             	movzbl (%eax),%ebx
  8008e0:	84 db                	test   %bl,%bl
  8008e2:	74 04                	je     8008e8 <strncmp+0x2e>
  8008e4:	3a 19                	cmp    (%ecx),%bl
  8008e6:	74 e1                	je     8008c9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e8:	0f b6 00             	movzbl (%eax),%eax
  8008eb:	0f b6 11             	movzbl (%ecx),%edx
  8008ee:	29 d0                	sub    %edx,%eax
}
  8008f0:	5b                   	pop    %ebx
  8008f1:	5d                   	pop    %ebp
  8008f2:	c3                   	ret    

008008f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fd:	eb 07                	jmp    800906 <strchr+0x13>
		if (*s == c)
  8008ff:	38 ca                	cmp    %cl,%dl
  800901:	74 0f                	je     800912 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800903:	83 c0 01             	add    $0x1,%eax
  800906:	0f b6 10             	movzbl (%eax),%edx
  800909:	84 d2                	test   %dl,%dl
  80090b:	75 f2                	jne    8008ff <strchr+0xc>
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091e:	eb 07                	jmp    800927 <strfind+0x13>
		if (*s == c)
  800920:	38 ca                	cmp    %cl,%dl
  800922:	74 0a                	je     80092e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800924:	83 c0 01             	add    $0x1,%eax
  800927:	0f b6 10             	movzbl (%eax),%edx
  80092a:	84 d2                	test   %dl,%dl
  80092c:	75 f2                	jne    800920 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	83 ec 0c             	sub    $0xc,%esp
  800936:	89 1c 24             	mov    %ebx,(%esp)
  800939:	89 74 24 04          	mov    %esi,0x4(%esp)
  80093d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800941:	8b 7d 08             	mov    0x8(%ebp),%edi
  800944:	8b 45 0c             	mov    0xc(%ebp),%eax
  800947:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80094a:	85 c9                	test   %ecx,%ecx
  80094c:	74 30                	je     80097e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80094e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800954:	75 25                	jne    80097b <memset+0x4b>
  800956:	f6 c1 03             	test   $0x3,%cl
  800959:	75 20                	jne    80097b <memset+0x4b>
		c &= 0xFF;
  80095b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095e:	89 d3                	mov    %edx,%ebx
  800960:	c1 e3 08             	shl    $0x8,%ebx
  800963:	89 d6                	mov    %edx,%esi
  800965:	c1 e6 18             	shl    $0x18,%esi
  800968:	89 d0                	mov    %edx,%eax
  80096a:	c1 e0 10             	shl    $0x10,%eax
  80096d:	09 f0                	or     %esi,%eax
  80096f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800971:	09 d8                	or     %ebx,%eax
  800973:	c1 e9 02             	shr    $0x2,%ecx
  800976:	fc                   	cld    
  800977:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800979:	eb 03                	jmp    80097e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80097b:	fc                   	cld    
  80097c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80097e:	89 f8                	mov    %edi,%eax
  800980:	8b 1c 24             	mov    (%esp),%ebx
  800983:	8b 74 24 04          	mov    0x4(%esp),%esi
  800987:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80098b:	89 ec                	mov    %ebp,%esp
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	89 34 24             	mov    %esi,(%esp)
  800998:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  8009a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009a5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009a7:	39 c6                	cmp    %eax,%esi
  8009a9:	73 35                	jae    8009e0 <memmove+0x51>
  8009ab:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ae:	39 d0                	cmp    %edx,%eax
  8009b0:	73 2e                	jae    8009e0 <memmove+0x51>
		s += n;
		d += n;
  8009b2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b4:	f6 c2 03             	test   $0x3,%dl
  8009b7:	75 1b                	jne    8009d4 <memmove+0x45>
  8009b9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009bf:	75 13                	jne    8009d4 <memmove+0x45>
  8009c1:	f6 c1 03             	test   $0x3,%cl
  8009c4:	75 0e                	jne    8009d4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8009c6:	83 ef 04             	sub    $0x4,%edi
  8009c9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009cc:	c1 e9 02             	shr    $0x2,%ecx
  8009cf:	fd                   	std    
  8009d0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d2:	eb 09                	jmp    8009dd <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009d4:	83 ef 01             	sub    $0x1,%edi
  8009d7:	8d 72 ff             	lea    -0x1(%edx),%esi
  8009da:	fd                   	std    
  8009db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009dd:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009de:	eb 20                	jmp    800a00 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e6:	75 15                	jne    8009fd <memmove+0x6e>
  8009e8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ee:	75 0d                	jne    8009fd <memmove+0x6e>
  8009f0:	f6 c1 03             	test   $0x3,%cl
  8009f3:	75 08                	jne    8009fd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8009f5:	c1 e9 02             	shr    $0x2,%ecx
  8009f8:	fc                   	cld    
  8009f9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fb:	eb 03                	jmp    800a00 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009fd:	fc                   	cld    
  8009fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a00:	8b 34 24             	mov    (%esp),%esi
  800a03:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a07:	89 ec                	mov    %ebp,%esp
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a11:	8b 45 10             	mov    0x10(%ebp),%eax
  800a14:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	89 04 24             	mov    %eax,(%esp)
  800a25:	e8 65 ff ff ff       	call   80098f <memmove>
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	57                   	push   %edi
  800a30:	56                   	push   %esi
  800a31:	53                   	push   %ebx
  800a32:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a3b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a40:	eb 1c                	jmp    800a5e <memcmp+0x32>
		if (*s1 != *s2)
  800a42:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800a46:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800a4a:	83 c2 01             	add    $0x1,%edx
  800a4d:	83 e9 01             	sub    $0x1,%ecx
  800a50:	38 d8                	cmp    %bl,%al
  800a52:	74 0a                	je     800a5e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800a54:	0f b6 c0             	movzbl %al,%eax
  800a57:	0f b6 db             	movzbl %bl,%ebx
  800a5a:	29 d8                	sub    %ebx,%eax
  800a5c:	eb 09                	jmp    800a67 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a5e:	85 c9                	test   %ecx,%ecx
  800a60:	75 e0                	jne    800a42 <memcmp+0x16>
  800a62:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800a67:	5b                   	pop    %ebx
  800a68:	5e                   	pop    %esi
  800a69:	5f                   	pop    %edi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a75:	89 c2                	mov    %eax,%edx
  800a77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a7a:	eb 07                	jmp    800a83 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a7c:	38 08                	cmp    %cl,(%eax)
  800a7e:	74 07                	je     800a87 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a80:	83 c0 01             	add    $0x1,%eax
  800a83:	39 d0                	cmp    %edx,%eax
  800a85:	72 f5                	jb     800a7c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	57                   	push   %edi
  800a8d:	56                   	push   %esi
  800a8e:	53                   	push   %ebx
  800a8f:	83 ec 04             	sub    $0x4,%esp
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
  800a95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a98:	eb 03                	jmp    800a9d <strtol+0x14>
		s++;
  800a9a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a9d:	0f b6 02             	movzbl (%edx),%eax
  800aa0:	3c 20                	cmp    $0x20,%al
  800aa2:	74 f6                	je     800a9a <strtol+0x11>
  800aa4:	3c 09                	cmp    $0x9,%al
  800aa6:	74 f2                	je     800a9a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800aa8:	3c 2b                	cmp    $0x2b,%al
  800aaa:	75 0c                	jne    800ab8 <strtol+0x2f>
		s++;
  800aac:	8d 52 01             	lea    0x1(%edx),%edx
  800aaf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ab6:	eb 15                	jmp    800acd <strtol+0x44>
	else if (*s == '-')
  800ab8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800abf:	3c 2d                	cmp    $0x2d,%al
  800ac1:	75 0a                	jne    800acd <strtol+0x44>
		s++, neg = 1;
  800ac3:	8d 52 01             	lea    0x1(%edx),%edx
  800ac6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800acd:	85 db                	test   %ebx,%ebx
  800acf:	0f 94 c0             	sete   %al
  800ad2:	74 05                	je     800ad9 <strtol+0x50>
  800ad4:	83 fb 10             	cmp    $0x10,%ebx
  800ad7:	75 15                	jne    800aee <strtol+0x65>
  800ad9:	80 3a 30             	cmpb   $0x30,(%edx)
  800adc:	75 10                	jne    800aee <strtol+0x65>
  800ade:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ae2:	75 0a                	jne    800aee <strtol+0x65>
		s += 2, base = 16;
  800ae4:	83 c2 02             	add    $0x2,%edx
  800ae7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aec:	eb 13                	jmp    800b01 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aee:	84 c0                	test   %al,%al
  800af0:	74 0f                	je     800b01 <strtol+0x78>
  800af2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800af7:	80 3a 30             	cmpb   $0x30,(%edx)
  800afa:	75 05                	jne    800b01 <strtol+0x78>
		s++, base = 8;
  800afc:	83 c2 01             	add    $0x1,%edx
  800aff:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
  800b06:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b08:	0f b6 0a             	movzbl (%edx),%ecx
  800b0b:	89 cf                	mov    %ecx,%edi
  800b0d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b10:	80 fb 09             	cmp    $0x9,%bl
  800b13:	77 08                	ja     800b1d <strtol+0x94>
			dig = *s - '0';
  800b15:	0f be c9             	movsbl %cl,%ecx
  800b18:	83 e9 30             	sub    $0x30,%ecx
  800b1b:	eb 1e                	jmp    800b3b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800b1d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b20:	80 fb 19             	cmp    $0x19,%bl
  800b23:	77 08                	ja     800b2d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800b25:	0f be c9             	movsbl %cl,%ecx
  800b28:	83 e9 57             	sub    $0x57,%ecx
  800b2b:	eb 0e                	jmp    800b3b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800b2d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b30:	80 fb 19             	cmp    $0x19,%bl
  800b33:	77 15                	ja     800b4a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b35:	0f be c9             	movsbl %cl,%ecx
  800b38:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b3b:	39 f1                	cmp    %esi,%ecx
  800b3d:	7d 0b                	jge    800b4a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b3f:	83 c2 01             	add    $0x1,%edx
  800b42:	0f af c6             	imul   %esi,%eax
  800b45:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800b48:	eb be                	jmp    800b08 <strtol+0x7f>
  800b4a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b50:	74 05                	je     800b57 <strtol+0xce>
		*endptr = (char *) s;
  800b52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b55:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b57:	89 ca                	mov    %ecx,%edx
  800b59:	f7 da                	neg    %edx
  800b5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b5f:	0f 45 c2             	cmovne %edx,%eax
}
  800b62:	83 c4 04             	add    $0x4,%esp
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5f                   	pop    %edi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    
	...

00800b6c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 0c             	sub    $0xc,%esp
  800b72:	89 1c 24             	mov    %ebx,(%esp)
  800b75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b79:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b82:	b8 01 00 00 00       	mov    $0x1,%eax
  800b87:	89 d1                	mov    %edx,%ecx
  800b89:	89 d3                	mov    %edx,%ebx
  800b8b:	89 d7                	mov    %edx,%edi
  800b8d:	89 d6                	mov    %edx,%esi
  800b8f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b91:	8b 1c 24             	mov    (%esp),%ebx
  800b94:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b98:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b9c:	89 ec                	mov    %ebp,%esp
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 0c             	sub    $0xc,%esp
  800ba6:	89 1c 24             	mov    %ebx,(%esp)
  800ba9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	89 c3                	mov    %eax,%ebx
  800bbe:	89 c7                	mov    %eax,%edi
  800bc0:	89 c6                	mov    %eax,%esi
  800bc2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc4:	8b 1c 24             	mov    (%esp),%ebx
  800bc7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bcb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bcf:	89 ec                	mov    %ebp,%esp
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	83 ec 0c             	sub    $0xc,%esp
  800bd9:	89 1c 24             	mov    %ebx,(%esp)
  800bdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800be0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
  800be9:	b8 10 00 00 00       	mov    $0x10,%eax
  800bee:	89 d1                	mov    %edx,%ecx
  800bf0:	89 d3                	mov    %edx,%ebx
  800bf2:	89 d7                	mov    %edx,%edi
  800bf4:	89 d6                	mov    %edx,%esi
  800bf6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800bf8:	8b 1c 24             	mov    (%esp),%ebx
  800bfb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bff:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c03:	89 ec                	mov    %ebp,%esp
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 38             	sub    $0x38,%esp
  800c0d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c10:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c13:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c1b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800c20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c23:	8b 55 08             	mov    0x8(%ebp),%edx
  800c26:	89 df                	mov    %ebx,%edi
  800c28:	89 de                	mov    %ebx,%esi
  800c2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c2c:	85 c0                	test   %eax,%eax
  800c2e:	7e 28                	jle    800c58 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c34:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800c3b:	00 
  800c3c:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800c43:	00 
  800c44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c4b:	00 
  800c4c:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800c53:	e8 b4 07 00 00       	call   80140c <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800c58:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c5b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c5e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c61:	89 ec                	mov    %ebp,%esp
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 38             	sub    $0x38,%esp
  800c6b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c6e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c71:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c79:	b8 0e 00 00 00       	mov    $0xe,%eax
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	8b 55 08             	mov    0x8(%ebp),%edx
  800c84:	89 df                	mov    %ebx,%edi
  800c86:	89 de                	mov    %ebx,%esi
  800c88:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	7e 28                	jle    800cb6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c92:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800c99:	00 
  800c9a:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800ca1:	00 
  800ca2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca9:	00 
  800caa:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800cb1:	e8 56 07 00 00       	call   80140c <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800cb6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cb9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cbc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cbf:	89 ec                	mov    %ebp,%esp
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 38             	sub    $0x38,%esp
  800cc9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ccc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ccf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdf:	89 cb                	mov    %ecx,%ebx
  800ce1:	89 cf                	mov    %ecx,%edi
  800ce3:	89 ce                	mov    %ecx,%esi
  800ce5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	7e 28                	jle    800d13 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ceb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800cf6:	00 
  800cf7:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800cfe:	00 
  800cff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d06:	00 
  800d07:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800d0e:	e8 f9 06 00 00       	call   80140c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d13:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d16:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d19:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d1c:	89 ec                	mov    %ebp,%esp
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
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
  800d31:	be 00 00 00 00       	mov    $0x0,%esi
  800d36:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d3b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d49:	8b 1c 24             	mov    (%esp),%ebx
  800d4c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d50:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d54:	89 ec                	mov    %ebp,%esp
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 38             	sub    $0x38,%esp
  800d5e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d61:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d64:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	89 df                	mov    %ebx,%edi
  800d79:	89 de                	mov    %ebx,%esi
  800d7b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	7e 28                	jle    800da9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d81:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d85:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d8c:	00 
  800d8d:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800d94:	00 
  800d95:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d9c:	00 
  800d9d:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800da4:	e8 63 06 00 00       	call   80140c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800da9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dac:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800daf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800db2:	89 ec                	mov    %ebp,%esp
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 38             	sub    $0x38,%esp
  800dbc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dbf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dc2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dca:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	89 df                	mov    %ebx,%edi
  800dd7:	89 de                	mov    %ebx,%esi
  800dd9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	7e 28                	jle    800e07 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dea:	00 
  800deb:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800df2:	00 
  800df3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfa:	00 
  800dfb:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800e02:	e8 05 06 00 00       	call   80140c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e07:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e0a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e0d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e10:	89 ec                	mov    %ebp,%esp
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 38             	sub    $0x38,%esp
  800e1a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e1d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e20:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e28:	b8 08 00 00 00       	mov    $0x8,%eax
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	89 df                	mov    %ebx,%edi
  800e35:	89 de                	mov    %ebx,%esi
  800e37:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	7e 28                	jle    800e65 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e41:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e48:	00 
  800e49:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800e50:	00 
  800e51:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e58:	00 
  800e59:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800e60:	e8 a7 05 00 00       	call   80140c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e65:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e68:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e6b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e6e:	89 ec                	mov    %ebp,%esp
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    

00800e72 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 38             	sub    $0x38,%esp
  800e78:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e7b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e7e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e86:	b8 06 00 00 00       	mov    $0x6,%eax
  800e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e91:	89 df                	mov    %ebx,%edi
  800e93:	89 de                	mov    %ebx,%esi
  800e95:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e97:	85 c0                	test   %eax,%eax
  800e99:	7e 28                	jle    800ec3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ea6:	00 
  800ea7:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800eae:	00 
  800eaf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb6:	00 
  800eb7:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800ebe:	e8 49 05 00 00       	call   80140c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ec3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ecc:	89 ec                	mov    %ebp,%esp
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 38             	sub    $0x38,%esp
  800ed6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800edc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edf:	b8 05 00 00 00       	mov    $0x5,%eax
  800ee4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ee7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	7e 28                	jle    800f21 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f04:	00 
  800f05:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800f0c:	00 
  800f0d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f14:	00 
  800f15:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800f1c:	e8 eb 04 00 00       	call   80140c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f21:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f24:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f27:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f2a:	89 ec                	mov    %ebp,%esp
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 38             	sub    $0x38,%esp
  800f34:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f37:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3d:	be 00 00 00 00       	mov    $0x0,%esi
  800f42:	b8 04 00 00 00       	mov    $0x4,%eax
  800f47:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	89 f7                	mov    %esi,%edi
  800f52:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	7e 28                	jle    800f80 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f63:	00 
  800f64:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800f6b:	00 
  800f6c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f73:	00 
  800f74:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800f7b:	e8 8c 04 00 00       	call   80140c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f80:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f83:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f86:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f89:	89 ec                	mov    %ebp,%esp
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	89 1c 24             	mov    %ebx,(%esp)
  800f96:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f9a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fa8:	89 d1                	mov    %edx,%ecx
  800faa:	89 d3                	mov    %edx,%ebx
  800fac:	89 d7                	mov    %edx,%edi
  800fae:	89 d6                	mov    %edx,%esi
  800fb0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fb2:	8b 1c 24             	mov    (%esp),%ebx
  800fb5:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fb9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fbd:	89 ec                	mov    %ebp,%esp
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 0c             	sub    $0xc,%esp
  800fc7:	89 1c 24             	mov    %ebx,(%esp)
  800fca:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fce:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd7:	b8 02 00 00 00       	mov    $0x2,%eax
  800fdc:	89 d1                	mov    %edx,%ecx
  800fde:	89 d3                	mov    %edx,%ebx
  800fe0:	89 d7                	mov    %edx,%edi
  800fe2:	89 d6                	mov    %edx,%esi
  800fe4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fe6:	8b 1c 24             	mov    (%esp),%ebx
  800fe9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fed:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ff1:	89 ec                	mov    %ebp,%esp
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 38             	sub    $0x38,%esp
  800ffb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ffe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801001:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801004:	b9 00 00 00 00       	mov    $0x0,%ecx
  801009:	b8 03 00 00 00       	mov    $0x3,%eax
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
  801011:	89 cb                	mov    %ecx,%ebx
  801013:	89 cf                	mov    %ecx,%edi
  801015:	89 ce                	mov    %ecx,%esi
  801017:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801019:	85 c0                	test   %eax,%eax
  80101b:	7e 28                	jle    801045 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801021:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801028:	00 
  801029:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  801030:	00 
  801031:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801038:	00 
  801039:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  801040:	e8 c7 03 00 00       	call   80140c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801045:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801048:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80104b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80104e:	89 ec                	mov    %ebp,%esp
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    
	...

00801054 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80105a:	c7 44 24 08 52 1b 80 	movl   $0x801b52,0x8(%esp)
  801061:	00 
  801062:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801069:	00 
  80106a:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  801071:	e8 96 03 00 00       	call   80140c <_panic>

00801076 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
  80107c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  80107f:	c7 04 24 e4 12 80 00 	movl   $0x8012e4,(%esp)
  801086:	e8 d9 03 00 00       	call   801464 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80108b:	ba 07 00 00 00       	mov    $0x7,%edx
  801090:	89 d0                	mov    %edx,%eax
  801092:	cd 30                	int    $0x30
  801094:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801097:	85 c0                	test   %eax,%eax
  801099:	79 20                	jns    8010bb <fork+0x45>
		panic("sys_exofork: %e", envid);
  80109b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80109f:	c7 44 24 08 73 1b 80 	movl   $0x801b73,0x8(%esp)
  8010a6:	00 
  8010a7:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8010ae:	00 
  8010af:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  8010b6:	e8 51 03 00 00       	call   80140c <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  8010bb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8010c2:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  8010c7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8010cb:	75 21                	jne    8010ee <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  8010cd:	e8 ef fe ff ff       	call   800fc1 <sys_getenvid>
  8010d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010d7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010df:	a3 04 20 80 00       	mov    %eax,0x802004
  8010e4:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  8010e9:	e9 e5 01 00 00       	jmp    8012d3 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  8010ee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8010f1:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8010f8:	a8 01                	test   $0x1,%al
  8010fa:	0f 84 4c 01 00 00    	je     80124c <fork+0x1d6>
  801100:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801106:	0f 84 cf 01 00 00    	je     8012db <fork+0x265>
		{
			addr = i << PDXSHIFT;
  80110c:	c1 e2 16             	shl    $0x16,%edx
  80110f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801112:	89 d3                	mov    %edx,%ebx
  801114:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80111b:	00 
  80111c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801120:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801123:	89 04 24             	mov    %eax,(%esp)
  801126:	e8 03 fe ff ff       	call   800f2e <sys_page_alloc>
			if(ret < 0) return ret;
  80112b:	85 c0                	test   %eax,%eax
  80112d:	0f 88 a0 01 00 00    	js     8012d3 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801133:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801137:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80113a:	89 14 24             	mov    %edx,(%esp)
  80113d:	e8 30 fd ff ff       	call   800e72 <sys_page_unmap>
			if(ret < 0) return ret;
  801142:	85 c0                	test   %eax,%eax
  801144:	0f 88 89 01 00 00    	js     8012d3 <fork+0x25d>
  80114a:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  80114f:	89 de                	mov    %ebx,%esi
  801151:	c1 e6 0c             	shl    $0xc,%esi
  801154:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801157:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  80115d:	0f 84 da 00 00 00    	je     80123d <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801163:	c1 ee 0c             	shr    $0xc,%esi
  801166:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801169:	a8 01                	test   $0x1,%al
  80116b:	0f 84 cc 00 00 00    	je     80123d <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801171:	89 f0                	mov    %esi,%eax
  801173:	c1 e0 0c             	shl    $0xc,%eax
  801176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801179:	e8 43 fe ff ff       	call   800fc1 <sys_getenvid>
  80117e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801181:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801184:	89 c6                	mov    %eax,%esi
  801186:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  80118c:	25 01 04 00 00       	and    $0x401,%eax
  801191:	3d 01 04 00 00       	cmp    $0x401,%eax
  801196:	75 3a                	jne    8011d2 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801198:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80119f:	00 
  8011a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8011b5:	89 14 24             	mov    %edx,(%esp)
  8011b8:	e8 13 fd ff ff       	call   800ed0 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  8011bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c4:	c7 04 24 83 1b 80 00 	movl   $0x801b83,(%esp)
  8011cb:	e8 b5 ef ff ff       	call   800185 <cprintf>
  8011d0:	eb 6b                	jmp    80123d <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  8011d2:	f7 c6 01 00 00 00    	test   $0x1,%esi
  8011d8:	74 14                	je     8011ee <fork+0x178>
  8011da:	f7 c6 02 08 00 00    	test   $0x802,%esi
  8011e0:	74 0c                	je     8011ee <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  8011e2:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  8011e8:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  8011ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011f1:	89 74 24 10          	mov    %esi,0x10(%esp)
  8011f5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801200:	89 54 24 04          	mov    %edx,0x4(%esp)
  801204:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801207:	89 14 24             	mov    %edx,(%esp)
  80120a:	e8 c1 fc ff ff       	call   800ed0 <sys_page_map>
	if(ret<0) return ret;
  80120f:	85 c0                	test   %eax,%eax
  801211:	0f 88 bc 00 00 00    	js     8012d3 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801217:	89 74 24 10          	mov    %esi,0x10(%esp)
  80121b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80121e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801222:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801225:	89 54 24 08          	mov    %edx,0x8(%esp)
  801229:	89 44 24 04          	mov    %eax,0x4(%esp)
  80122d:	89 14 24             	mov    %edx,(%esp)
  801230:	e8 9b fc ff ff       	call   800ed0 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801235:	85 c0                	test   %eax,%eax
  801237:	0f 88 96 00 00 00    	js     8012d3 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  80123d:	83 c3 01             	add    $0x1,%ebx
  801240:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801246:	0f 85 03 ff ff ff    	jne    80114f <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80124c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801250:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801257:	0f 85 91 fe ff ff    	jne    8010ee <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  80125d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801264:	00 
  801265:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80126c:	ee 
  80126d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801270:	89 04 24             	mov    %eax,(%esp)
  801273:	e8 b6 fc ff ff       	call   800f2e <sys_page_alloc>
	if(ret < 0) return ret;
  801278:	85 c0                	test   %eax,%eax
  80127a:	78 57                	js     8012d3 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  80127c:	a1 04 20 80 00       	mov    0x802004,%eax
  801281:	8b 40 64             	mov    0x64(%eax),%eax
  801284:	89 44 24 04          	mov    %eax,0x4(%esp)
  801288:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80128b:	89 14 24             	mov    %edx,(%esp)
  80128e:	e8 c5 fa ff ff       	call   800d58 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801293:	85 c0                	test   %eax,%eax
  801295:	78 3c                	js     8012d3 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801297:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80129e:	00 
  80129f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012a2:	89 04 24             	mov    %eax,(%esp)
  8012a5:	e8 6a fb ff ff       	call   800e14 <sys_env_set_status>
  8012aa:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  8012ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012af:	85 d2                	test   %edx,%edx
  8012b1:	79 20                	jns    8012d3 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  8012b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012b7:	c7 44 24 08 9a 1b 80 	movl   $0x801b9a,0x8(%esp)
  8012be:	00 
  8012bf:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8012c6:	00 
  8012c7:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  8012ce:	e8 39 01 00 00       	call   80140c <_panic>

	return envid;
}
  8012d3:	83 c4 4c             	add    $0x4c,%esp
  8012d6:	5b                   	pop    %ebx
  8012d7:	5e                   	pop    %esi
  8012d8:	5f                   	pop    %edi
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8012db:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  8012df:	e9 0a fe ff ff       	jmp    8010ee <fork+0x78>

008012e4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  8012ec:	e8 d0 fc ff ff       	call   800fc1 <sys_getenvid>
  8012f1:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8b 00                	mov    (%eax),%eax
  8012f8:	89 c6                	mov    %eax,%esi
  8012fa:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  8012fd:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801304:	f6 c2 02             	test   $0x2,%dl
  801307:	75 2c                	jne    801335 <pgfault+0x51>
  801309:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801310:	f6 c6 08             	test   $0x8,%dh
  801313:	75 20                	jne    801335 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801315:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801319:	c7 44 24 08 e8 1b 80 	movl   $0x801be8,0x8(%esp)
  801320:	00 
  801321:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801328:	00 
  801329:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  801330:	e8 d7 00 00 00       	call   80140c <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801335:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80133c:	00 
  80133d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801344:	00 
  801345:	89 1c 24             	mov    %ebx,(%esp)
  801348:	e8 e1 fb ff ff       	call   800f2e <sys_page_alloc>
  80134d:	85 c0                	test   %eax,%eax
  80134f:	79 20                	jns    801371 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801351:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801355:	c7 44 24 08 b1 1b 80 	movl   $0x801bb1,0x8(%esp)
  80135c:	00 
  80135d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801364:	00 
  801365:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  80136c:	e8 9b 00 00 00       	call   80140c <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801371:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801374:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80137b:	00 
  80137c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801380:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801387:	e8 03 f6 ff ff       	call   80098f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80138c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801393:	00 
  801394:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801398:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80139c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8013a3:	00 
  8013a4:	89 1c 24             	mov    %ebx,(%esp)
  8013a7:	e8 24 fb ff ff       	call   800ed0 <sys_page_map>
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	79 20                	jns    8013d0 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  8013b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013b4:	c7 44 24 08 c3 1b 80 	movl   $0x801bc3,0x8(%esp)
  8013bb:	00 
  8013bc:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  8013c3:	00 
  8013c4:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  8013cb:	e8 3c 00 00 00       	call   80140c <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  8013d0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8013d7:	00 
  8013d8:	89 1c 24             	mov    %ebx,(%esp)
  8013db:	e8 92 fa ff ff       	call   800e72 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	74 20                	je     801404 <pgfault+0x120>
  8013e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013e8:	c7 44 24 08 d3 1b 80 	movl   $0x801bd3,0x8(%esp)
  8013ef:	00 
  8013f0:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8013f7:	00 
  8013f8:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  8013ff:	e8 08 00 00 00       	call   80140c <_panic>

}
  801404:	83 c4 20             	add    $0x20,%esp
  801407:	5b                   	pop    %ebx
  801408:	5e                   	pop    %esi
  801409:	5d                   	pop    %ebp
  80140a:	c3                   	ret    
	...

0080140c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	56                   	push   %esi
  801410:	53                   	push   %ebx
  801411:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  801414:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801417:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  80141d:	e8 9f fb ff ff       	call   800fc1 <sys_getenvid>
  801422:	8b 55 0c             	mov    0xc(%ebp),%edx
  801425:	89 54 24 10          	mov    %edx,0x10(%esp)
  801429:	8b 55 08             	mov    0x8(%ebp),%edx
  80142c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801430:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801434:	89 44 24 04          	mov    %eax,0x4(%esp)
  801438:	c7 04 24 0c 1c 80 00 	movl   $0x801c0c,(%esp)
  80143f:	e8 41 ed ff ff       	call   800185 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801444:	89 74 24 04          	mov    %esi,0x4(%esp)
  801448:	8b 45 10             	mov    0x10(%ebp),%eax
  80144b:	89 04 24             	mov    %eax,(%esp)
  80144e:	e8 d1 ec ff ff       	call   800124 <vcprintf>
	cprintf("\n");
  801453:	c7 04 24 14 18 80 00 	movl   $0x801814,(%esp)
  80145a:	e8 26 ed ff ff       	call   800185 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80145f:	cc                   	int3   
  801460:	eb fd                	jmp    80145f <_panic+0x53>
	...

00801464 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	53                   	push   %ebx
  801468:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  80146b:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801472:	75 5b                	jne    8014cf <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  801474:	e8 48 fb ff ff       	call   800fc1 <sys_getenvid>
  801479:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80147b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801482:	00 
  801483:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80148a:	ee 
  80148b:	89 04 24             	mov    %eax,(%esp)
  80148e:	e8 9b fa ff ff       	call   800f2e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  801493:	85 c0                	test   %eax,%eax
  801495:	74 28                	je     8014bf <set_pgfault_handler+0x5b>
  801497:	89 44 24 10          	mov    %eax,0x10(%esp)
  80149b:	c7 44 24 0c 57 1c 80 	movl   $0x801c57,0xc(%esp)
  8014a2:	00 
  8014a3:	c7 44 24 08 30 1c 80 	movl   $0x801c30,0x8(%esp)
  8014aa:	00 
  8014ab:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8014b2:	00 
  8014b3:	c7 04 24 49 1c 80 00 	movl   $0x801c49,(%esp)
  8014ba:	e8 4d ff ff ff       	call   80140c <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  8014bf:	c7 44 24 04 e0 14 80 	movl   $0x8014e0,0x4(%esp)
  8014c6:	00 
  8014c7:	89 1c 24             	mov    %ebx,(%esp)
  8014ca:	e8 89 f8 ff ff       	call   800d58 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	a3 08 20 80 00       	mov    %eax,0x802008
	
}
  8014d7:	83 c4 24             	add    $0x24,%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5d                   	pop    %ebp
  8014dc:	c3                   	ret    
  8014dd:	00 00                	add    %al,(%eax)
	...

008014e0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014e0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014e1:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8014e6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8014e8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  8014eb:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  8014ee:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  8014f2:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  8014f6:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  8014f9:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  8014fc:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  801500:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  801501:	83 c4 04             	add    $0x4,%esp
	popfl ;
  801504:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  801505:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801506:	c3                   	ret    
	...

00801510 <__udivdi3>:
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	57                   	push   %edi
  801514:	56                   	push   %esi
  801515:	83 ec 10             	sub    $0x10,%esp
  801518:	8b 45 14             	mov    0x14(%ebp),%eax
  80151b:	8b 55 08             	mov    0x8(%ebp),%edx
  80151e:	8b 75 10             	mov    0x10(%ebp),%esi
  801521:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801524:	85 c0                	test   %eax,%eax
  801526:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801529:	75 35                	jne    801560 <__udivdi3+0x50>
  80152b:	39 fe                	cmp    %edi,%esi
  80152d:	77 61                	ja     801590 <__udivdi3+0x80>
  80152f:	85 f6                	test   %esi,%esi
  801531:	75 0b                	jne    80153e <__udivdi3+0x2e>
  801533:	b8 01 00 00 00       	mov    $0x1,%eax
  801538:	31 d2                	xor    %edx,%edx
  80153a:	f7 f6                	div    %esi
  80153c:	89 c6                	mov    %eax,%esi
  80153e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801541:	31 d2                	xor    %edx,%edx
  801543:	89 f8                	mov    %edi,%eax
  801545:	f7 f6                	div    %esi
  801547:	89 c7                	mov    %eax,%edi
  801549:	89 c8                	mov    %ecx,%eax
  80154b:	f7 f6                	div    %esi
  80154d:	89 c1                	mov    %eax,%ecx
  80154f:	89 fa                	mov    %edi,%edx
  801551:	89 c8                	mov    %ecx,%eax
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	5e                   	pop    %esi
  801557:	5f                   	pop    %edi
  801558:	5d                   	pop    %ebp
  801559:	c3                   	ret    
  80155a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801560:	39 f8                	cmp    %edi,%eax
  801562:	77 1c                	ja     801580 <__udivdi3+0x70>
  801564:	0f bd d0             	bsr    %eax,%edx
  801567:	83 f2 1f             	xor    $0x1f,%edx
  80156a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80156d:	75 39                	jne    8015a8 <__udivdi3+0x98>
  80156f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801572:	0f 86 a0 00 00 00    	jbe    801618 <__udivdi3+0x108>
  801578:	39 f8                	cmp    %edi,%eax
  80157a:	0f 82 98 00 00 00    	jb     801618 <__udivdi3+0x108>
  801580:	31 ff                	xor    %edi,%edi
  801582:	31 c9                	xor    %ecx,%ecx
  801584:	89 c8                	mov    %ecx,%eax
  801586:	89 fa                	mov    %edi,%edx
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	5e                   	pop    %esi
  80158c:	5f                   	pop    %edi
  80158d:	5d                   	pop    %ebp
  80158e:	c3                   	ret    
  80158f:	90                   	nop
  801590:	89 d1                	mov    %edx,%ecx
  801592:	89 fa                	mov    %edi,%edx
  801594:	89 c8                	mov    %ecx,%eax
  801596:	31 ff                	xor    %edi,%edi
  801598:	f7 f6                	div    %esi
  80159a:	89 c1                	mov    %eax,%ecx
  80159c:	89 fa                	mov    %edi,%edx
  80159e:	89 c8                	mov    %ecx,%eax
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	5e                   	pop    %esi
  8015a4:	5f                   	pop    %edi
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    
  8015a7:	90                   	nop
  8015a8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8015ac:	89 f2                	mov    %esi,%edx
  8015ae:	d3 e0                	shl    %cl,%eax
  8015b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015b3:	b8 20 00 00 00       	mov    $0x20,%eax
  8015b8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8015bb:	89 c1                	mov    %eax,%ecx
  8015bd:	d3 ea                	shr    %cl,%edx
  8015bf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8015c3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8015c6:	d3 e6                	shl    %cl,%esi
  8015c8:	89 c1                	mov    %eax,%ecx
  8015ca:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8015cd:	89 fe                	mov    %edi,%esi
  8015cf:	d3 ee                	shr    %cl,%esi
  8015d1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8015d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8015d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015db:	d3 e7                	shl    %cl,%edi
  8015dd:	89 c1                	mov    %eax,%ecx
  8015df:	d3 ea                	shr    %cl,%edx
  8015e1:	09 d7                	or     %edx,%edi
  8015e3:	89 f2                	mov    %esi,%edx
  8015e5:	89 f8                	mov    %edi,%eax
  8015e7:	f7 75 ec             	divl   -0x14(%ebp)
  8015ea:	89 d6                	mov    %edx,%esi
  8015ec:	89 c7                	mov    %eax,%edi
  8015ee:	f7 65 e8             	mull   -0x18(%ebp)
  8015f1:	39 d6                	cmp    %edx,%esi
  8015f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8015f6:	72 30                	jb     801628 <__udivdi3+0x118>
  8015f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8015ff:	d3 e2                	shl    %cl,%edx
  801601:	39 c2                	cmp    %eax,%edx
  801603:	73 05                	jae    80160a <__udivdi3+0xfa>
  801605:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801608:	74 1e                	je     801628 <__udivdi3+0x118>
  80160a:	89 f9                	mov    %edi,%ecx
  80160c:	31 ff                	xor    %edi,%edi
  80160e:	e9 71 ff ff ff       	jmp    801584 <__udivdi3+0x74>
  801613:	90                   	nop
  801614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801618:	31 ff                	xor    %edi,%edi
  80161a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80161f:	e9 60 ff ff ff       	jmp    801584 <__udivdi3+0x74>
  801624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801628:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80162b:	31 ff                	xor    %edi,%edi
  80162d:	89 c8                	mov    %ecx,%eax
  80162f:	89 fa                	mov    %edi,%edx
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	5e                   	pop    %esi
  801635:	5f                   	pop    %edi
  801636:	5d                   	pop    %ebp
  801637:	c3                   	ret    
	...

00801640 <__umoddi3>:
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	57                   	push   %edi
  801644:	56                   	push   %esi
  801645:	83 ec 20             	sub    $0x20,%esp
  801648:	8b 55 14             	mov    0x14(%ebp),%edx
  80164b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80164e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801651:	8b 75 0c             	mov    0xc(%ebp),%esi
  801654:	85 d2                	test   %edx,%edx
  801656:	89 c8                	mov    %ecx,%eax
  801658:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80165b:	75 13                	jne    801670 <__umoddi3+0x30>
  80165d:	39 f7                	cmp    %esi,%edi
  80165f:	76 3f                	jbe    8016a0 <__umoddi3+0x60>
  801661:	89 f2                	mov    %esi,%edx
  801663:	f7 f7                	div    %edi
  801665:	89 d0                	mov    %edx,%eax
  801667:	31 d2                	xor    %edx,%edx
  801669:	83 c4 20             	add    $0x20,%esp
  80166c:	5e                   	pop    %esi
  80166d:	5f                   	pop    %edi
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    
  801670:	39 f2                	cmp    %esi,%edx
  801672:	77 4c                	ja     8016c0 <__umoddi3+0x80>
  801674:	0f bd ca             	bsr    %edx,%ecx
  801677:	83 f1 1f             	xor    $0x1f,%ecx
  80167a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80167d:	75 51                	jne    8016d0 <__umoddi3+0x90>
  80167f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801682:	0f 87 e0 00 00 00    	ja     801768 <__umoddi3+0x128>
  801688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168b:	29 f8                	sub    %edi,%eax
  80168d:	19 d6                	sbb    %edx,%esi
  80168f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801695:	89 f2                	mov    %esi,%edx
  801697:	83 c4 20             	add    $0x20,%esp
  80169a:	5e                   	pop    %esi
  80169b:	5f                   	pop    %edi
  80169c:	5d                   	pop    %ebp
  80169d:	c3                   	ret    
  80169e:	66 90                	xchg   %ax,%ax
  8016a0:	85 ff                	test   %edi,%edi
  8016a2:	75 0b                	jne    8016af <__umoddi3+0x6f>
  8016a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a9:	31 d2                	xor    %edx,%edx
  8016ab:	f7 f7                	div    %edi
  8016ad:	89 c7                	mov    %eax,%edi
  8016af:	89 f0                	mov    %esi,%eax
  8016b1:	31 d2                	xor    %edx,%edx
  8016b3:	f7 f7                	div    %edi
  8016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b8:	f7 f7                	div    %edi
  8016ba:	eb a9                	jmp    801665 <__umoddi3+0x25>
  8016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8016c0:	89 c8                	mov    %ecx,%eax
  8016c2:	89 f2                	mov    %esi,%edx
  8016c4:	83 c4 20             	add    $0x20,%esp
  8016c7:	5e                   	pop    %esi
  8016c8:	5f                   	pop    %edi
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    
  8016cb:	90                   	nop
  8016cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8016d0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8016d4:	d3 e2                	shl    %cl,%edx
  8016d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8016d9:	ba 20 00 00 00       	mov    $0x20,%edx
  8016de:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8016e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8016e4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8016e8:	89 fa                	mov    %edi,%edx
  8016ea:	d3 ea                	shr    %cl,%edx
  8016ec:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8016f0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8016f3:	d3 e7                	shl    %cl,%edi
  8016f5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8016f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8016fc:	89 f2                	mov    %esi,%edx
  8016fe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801701:	89 c7                	mov    %eax,%edi
  801703:	d3 ea                	shr    %cl,%edx
  801705:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801709:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80170c:	89 c2                	mov    %eax,%edx
  80170e:	d3 e6                	shl    %cl,%esi
  801710:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801714:	d3 ea                	shr    %cl,%edx
  801716:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80171a:	09 d6                	or     %edx,%esi
  80171c:	89 f0                	mov    %esi,%eax
  80171e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801721:	d3 e7                	shl    %cl,%edi
  801723:	89 f2                	mov    %esi,%edx
  801725:	f7 75 f4             	divl   -0xc(%ebp)
  801728:	89 d6                	mov    %edx,%esi
  80172a:	f7 65 e8             	mull   -0x18(%ebp)
  80172d:	39 d6                	cmp    %edx,%esi
  80172f:	72 2b                	jb     80175c <__umoddi3+0x11c>
  801731:	39 c7                	cmp    %eax,%edi
  801733:	72 23                	jb     801758 <__umoddi3+0x118>
  801735:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801739:	29 c7                	sub    %eax,%edi
  80173b:	19 d6                	sbb    %edx,%esi
  80173d:	89 f0                	mov    %esi,%eax
  80173f:	89 f2                	mov    %esi,%edx
  801741:	d3 ef                	shr    %cl,%edi
  801743:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801747:	d3 e0                	shl    %cl,%eax
  801749:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80174d:	09 f8                	or     %edi,%eax
  80174f:	d3 ea                	shr    %cl,%edx
  801751:	83 c4 20             	add    $0x20,%esp
  801754:	5e                   	pop    %esi
  801755:	5f                   	pop    %edi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    
  801758:	39 d6                	cmp    %edx,%esi
  80175a:	75 d9                	jne    801735 <__umoddi3+0xf5>
  80175c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80175f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801762:	eb d1                	jmp    801735 <__umoddi3+0xf5>
  801764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801768:	39 f2                	cmp    %esi,%edx
  80176a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801770:	0f 82 12 ff ff ff    	jb     801688 <__umoddi3+0x48>
  801776:	e9 17 ff ff ff       	jmp    801692 <__umoddi3+0x52>
