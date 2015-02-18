
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 63 00 00 00       	call   800094 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
	sys_env_destroy(sys_getenvid());
}

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  800046:	c7 04 24 5e 00 80 00 	movl   $0x80005e,(%esp)
  80004d:	e8 d2 0f 00 00       	call   801024 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800052:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800059:	00 00 00 
}
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	83 ec 18             	sub    $0x18,%esp
  800064:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800067:	8b 50 04             	mov    0x4(%eax),%edx
  80006a:	83 e2 07             	and    $0x7,%edx
  80006d:	89 54 24 08          	mov    %edx,0x8(%esp)
  800071:	8b 00                	mov    (%eax),%eax
  800073:	89 44 24 04          	mov    %eax,0x4(%esp)
  800077:	c7 04 24 a0 13 80 00 	movl   $0x8013a0,(%esp)
  80007e:	e8 d6 00 00 00       	call   800159 <cprintf>
	sys_env_destroy(sys_getenvid());
  800083:	e8 09 0f 00 00       	call   800f91 <sys_getenvid>
  800088:	89 04 24             	mov    %eax,(%esp)
  80008b:	e8 35 0f 00 00       	call   800fc5 <sys_env_destroy>
}
  800090:	c9                   	leave  
  800091:	c3                   	ret    
	...

00800094 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 18             	sub    $0x18,%esp
  80009a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80009d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8000a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8000a6:	e8 e6 0e 00 00       	call   800f91 <sys_getenvid>
  8000ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b3:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8000b8:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bd:	85 f6                	test   %esi,%esi
  8000bf:	7e 07                	jle    8000c8 <libmain+0x34>
		binaryname = argv[0];
  8000c1:	8b 03                	mov    (%ebx),%eax
  8000c3:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000cc:	89 34 24             	mov    %esi,(%esp)
  8000cf:	e8 6c ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  8000d4:	e8 0b 00 00 00       	call   8000e4 <exit>
}
  8000d9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000dc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000df:	89 ec                	mov    %ebp,%esp
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    
	...

008000e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8000ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f1:	e8 cf 0e 00 00       	call   800fc5 <sys_env_destroy>
}
  8000f6:	c9                   	leave  
  8000f7:	c3                   	ret    

008000f8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800101:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800108:	00 00 00 
	b.cnt = 0;
  80010b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800112:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800115:	8b 45 0c             	mov    0xc(%ebp),%eax
  800118:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80011c:	8b 45 08             	mov    0x8(%ebp),%eax
  80011f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800123:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800129:	89 44 24 04          	mov    %eax,0x4(%esp)
  80012d:	c7 04 24 73 01 80 00 	movl   $0x800173,(%esp)
  800134:	e8 be 01 00 00       	call   8002f7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800139:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80013f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800143:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800149:	89 04 24             	mov    %eax,(%esp)
  80014c:	e8 1f 0a 00 00       	call   800b70 <sys_cputs>

	return b.cnt;
}
  800151:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80015f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800162:	89 44 24 04          	mov    %eax,0x4(%esp)
  800166:	8b 45 08             	mov    0x8(%ebp),%eax
  800169:	89 04 24             	mov    %eax,(%esp)
  80016c:	e8 87 ff ff ff       	call   8000f8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	53                   	push   %ebx
  800177:	83 ec 14             	sub    $0x14,%esp
  80017a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017d:	8b 03                	mov    (%ebx),%eax
  80017f:	8b 55 08             	mov    0x8(%ebp),%edx
  800182:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800186:	83 c0 01             	add    $0x1,%eax
  800189:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80018b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800190:	75 19                	jne    8001ab <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800192:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800199:	00 
  80019a:	8d 43 08             	lea    0x8(%ebx),%eax
  80019d:	89 04 24             	mov    %eax,(%esp)
  8001a0:	e8 cb 09 00 00       	call   800b70 <sys_cputs>
		b->idx = 0;
  8001a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001ab:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001af:	83 c4 14             	add    $0x14,%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    
  8001b5:	00 00                	add    %al,(%eax)
	...

008001b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	57                   	push   %edi
  8001bc:	56                   	push   %esi
  8001bd:	53                   	push   %ebx
  8001be:	83 ec 4c             	sub    $0x4c,%esp
  8001c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001c4:	89 d6                	mov    %edx,%esi
  8001c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cf:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8001d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001d8:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001e3:	39 d1                	cmp    %edx,%ecx
  8001e5:	72 07                	jb     8001ee <printnum+0x36>
  8001e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001ea:	39 d0                	cmp    %edx,%eax
  8001ec:	77 69                	ja     800257 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ee:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8001f2:	83 eb 01             	sub    $0x1,%ebx
  8001f5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800201:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800205:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800208:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80020b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80020e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800212:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800219:	00 
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	89 04 24             	mov    %eax,(%esp)
  800220:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800223:	89 54 24 04          	mov    %edx,0x4(%esp)
  800227:	e8 f4 0e 00 00       	call   801120 <__udivdi3>
  80022c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80022f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800232:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800236:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80023a:	89 04 24             	mov    %eax,(%esp)
  80023d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800241:	89 f2                	mov    %esi,%edx
  800243:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800246:	e8 6d ff ff ff       	call   8001b8 <printnum>
  80024b:	eb 11                	jmp    80025e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800251:	89 3c 24             	mov    %edi,(%esp)
  800254:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800257:	83 eb 01             	sub    $0x1,%ebx
  80025a:	85 db                	test   %ebx,%ebx
  80025c:	7f ef                	jg     80024d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800262:	8b 74 24 04          	mov    0x4(%esp),%esi
  800266:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800274:	00 
  800275:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800278:	89 14 24             	mov    %edx,(%esp)
  80027b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80027e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800282:	e8 c9 0f 00 00       	call   801250 <__umoddi3>
  800287:	89 74 24 04          	mov    %esi,0x4(%esp)
  80028b:	0f be 80 c6 13 80 00 	movsbl 0x8013c6(%eax),%eax
  800292:	89 04 24             	mov    %eax,(%esp)
  800295:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800298:	83 c4 4c             	add    $0x4c,%esp
  80029b:	5b                   	pop    %ebx
  80029c:	5e                   	pop    %esi
  80029d:	5f                   	pop    %edi
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002a3:	83 fa 01             	cmp    $0x1,%edx
  8002a6:	7e 0e                	jle    8002b6 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002a8:	8b 10                	mov    (%eax),%edx
  8002aa:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002ad:	89 08                	mov    %ecx,(%eax)
  8002af:	8b 02                	mov    (%edx),%eax
  8002b1:	8b 52 04             	mov    0x4(%edx),%edx
  8002b4:	eb 22                	jmp    8002d8 <getuint+0x38>
	else if (lflag)
  8002b6:	85 d2                	test   %edx,%edx
  8002b8:	74 10                	je     8002ca <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002ba:	8b 10                	mov    (%eax),%edx
  8002bc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002bf:	89 08                	mov    %ecx,(%eax)
  8002c1:	8b 02                	mov    (%edx),%eax
  8002c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c8:	eb 0e                	jmp    8002d8 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002ca:	8b 10                	mov    (%eax),%edx
  8002cc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002cf:	89 08                	mov    %ecx,(%eax)
  8002d1:	8b 02                	mov    (%edx),%eax
  8002d3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    

008002da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e4:	8b 10                	mov    (%eax),%edx
  8002e6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e9:	73 0a                	jae    8002f5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ee:	88 0a                	mov    %cl,(%edx)
  8002f0:	83 c2 01             	add    $0x1,%edx
  8002f3:	89 10                	mov    %edx,(%eax)
}
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
  8002fd:	83 ec 4c             	sub    $0x4c,%esp
  800300:	8b 7d 08             	mov    0x8(%ebp),%edi
  800303:	8b 75 0c             	mov    0xc(%ebp),%esi
  800306:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800309:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800310:	eb 11                	jmp    800323 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800312:	85 c0                	test   %eax,%eax
  800314:	0f 84 b6 03 00 00    	je     8006d0 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80031a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80031e:	89 04 24             	mov    %eax,(%esp)
  800321:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800323:	0f b6 03             	movzbl (%ebx),%eax
  800326:	83 c3 01             	add    $0x1,%ebx
  800329:	83 f8 25             	cmp    $0x25,%eax
  80032c:	75 e4                	jne    800312 <vprintfmt+0x1b>
  80032e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800332:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800339:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800340:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800347:	b9 00 00 00 00       	mov    $0x0,%ecx
  80034c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80034f:	eb 06                	jmp    800357 <vprintfmt+0x60>
  800351:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800355:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800357:	0f b6 0b             	movzbl (%ebx),%ecx
  80035a:	0f b6 c1             	movzbl %cl,%eax
  80035d:	8d 53 01             	lea    0x1(%ebx),%edx
  800360:	83 e9 23             	sub    $0x23,%ecx
  800363:	80 f9 55             	cmp    $0x55,%cl
  800366:	0f 87 47 03 00 00    	ja     8006b3 <vprintfmt+0x3bc>
  80036c:	0f b6 c9             	movzbl %cl,%ecx
  80036f:	ff 24 8d 00 15 80 00 	jmp    *0x801500(,%ecx,4)
  800376:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80037a:	eb d9                	jmp    800355 <vprintfmt+0x5e>
  80037c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800383:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800388:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80038b:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80038f:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800392:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800395:	83 fb 09             	cmp    $0x9,%ebx
  800398:	77 30                	ja     8003ca <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80039a:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80039d:	eb e9                	jmp    800388 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	8d 48 04             	lea    0x4(%eax),%ecx
  8003a5:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8003ad:	eb 1e                	jmp    8003cd <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8003af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b8:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8003bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003bf:	eb 94                	jmp    800355 <vprintfmt+0x5e>
  8003c1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003c8:	eb 8b                	jmp    800355 <vprintfmt+0x5e>
  8003ca:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003d1:	79 82                	jns    800355 <vprintfmt+0x5e>
  8003d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8003dc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8003df:	e9 71 ff ff ff       	jmp    800355 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003e4:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003e8:	e9 68 ff ff ff       	jmp    800355 <vprintfmt+0x5e>
  8003ed:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f3:	8d 50 04             	lea    0x4(%eax),%edx
  8003f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8003f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 04 24             	mov    %eax,(%esp)
  800402:	ff d7                	call   *%edi
  800404:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800407:	e9 17 ff ff ff       	jmp    800323 <vprintfmt+0x2c>
  80040c:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80040f:	8b 45 14             	mov    0x14(%ebp),%eax
  800412:	8d 50 04             	lea    0x4(%eax),%edx
  800415:	89 55 14             	mov    %edx,0x14(%ebp)
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	89 c2                	mov    %eax,%edx
  80041c:	c1 fa 1f             	sar    $0x1f,%edx
  80041f:	31 d0                	xor    %edx,%eax
  800421:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800423:	83 f8 11             	cmp    $0x11,%eax
  800426:	7f 0b                	jg     800433 <vprintfmt+0x13c>
  800428:	8b 14 85 60 16 80 00 	mov    0x801660(,%eax,4),%edx
  80042f:	85 d2                	test   %edx,%edx
  800431:	75 20                	jne    800453 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800433:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800437:	c7 44 24 08 d7 13 80 	movl   $0x8013d7,0x8(%esp)
  80043e:	00 
  80043f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800443:	89 3c 24             	mov    %edi,(%esp)
  800446:	e8 0d 03 00 00       	call   800758 <printfmt>
  80044b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044e:	e9 d0 fe ff ff       	jmp    800323 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800453:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800457:	c7 44 24 08 e0 13 80 	movl   $0x8013e0,0x8(%esp)
  80045e:	00 
  80045f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800463:	89 3c 24             	mov    %edi,(%esp)
  800466:	e8 ed 02 00 00       	call   800758 <printfmt>
  80046b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80046e:	e9 b0 fe ff ff       	jmp    800323 <vprintfmt+0x2c>
  800473:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800476:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80047c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80047f:	8b 45 14             	mov    0x14(%ebp),%eax
  800482:	8d 50 04             	lea    0x4(%eax),%edx
  800485:	89 55 14             	mov    %edx,0x14(%ebp)
  800488:	8b 18                	mov    (%eax),%ebx
  80048a:	85 db                	test   %ebx,%ebx
  80048c:	b8 e3 13 80 00       	mov    $0x8013e3,%eax
  800491:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800494:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800498:	7e 76                	jle    800510 <vprintfmt+0x219>
  80049a:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80049e:	74 7a                	je     80051a <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004a4:	89 1c 24             	mov    %ebx,(%esp)
  8004a7:	e8 ec 02 00 00       	call   800798 <strnlen>
  8004ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004af:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8004b1:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8004b5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004b8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004bb:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	eb 0f                	jmp    8004ce <vprintfmt+0x1d7>
					putch(padc, putdat);
  8004bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c6:	89 04 24             	mov    %eax,(%esp)
  8004c9:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cb:	83 eb 01             	sub    $0x1,%ebx
  8004ce:	85 db                	test   %ebx,%ebx
  8004d0:	7f ed                	jg     8004bf <vprintfmt+0x1c8>
  8004d2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8004d5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004d8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004db:	89 f7                	mov    %esi,%edi
  8004dd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004e0:	eb 40                	jmp    800522 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e6:	74 18                	je     800500 <vprintfmt+0x209>
  8004e8:	8d 50 e0             	lea    -0x20(%eax),%edx
  8004eb:	83 fa 5e             	cmp    $0x5e,%edx
  8004ee:	76 10                	jbe    800500 <vprintfmt+0x209>
					putch('?', putdat);
  8004f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8004fb:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004fe:	eb 0a                	jmp    80050a <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800500:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800504:	89 04 24             	mov    %eax,(%esp)
  800507:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80050e:	eb 12                	jmp    800522 <vprintfmt+0x22b>
  800510:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800513:	89 f7                	mov    %esi,%edi
  800515:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800518:	eb 08                	jmp    800522 <vprintfmt+0x22b>
  80051a:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80051d:	89 f7                	mov    %esi,%edi
  80051f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800522:	0f be 03             	movsbl (%ebx),%eax
  800525:	83 c3 01             	add    $0x1,%ebx
  800528:	85 c0                	test   %eax,%eax
  80052a:	74 25                	je     800551 <vprintfmt+0x25a>
  80052c:	85 f6                	test   %esi,%esi
  80052e:	78 b2                	js     8004e2 <vprintfmt+0x1eb>
  800530:	83 ee 01             	sub    $0x1,%esi
  800533:	79 ad                	jns    8004e2 <vprintfmt+0x1eb>
  800535:	89 fe                	mov    %edi,%esi
  800537:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80053a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80053d:	eb 1a                	jmp    800559 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80053f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800543:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80054a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80054c:	83 eb 01             	sub    $0x1,%ebx
  80054f:	eb 08                	jmp    800559 <vprintfmt+0x262>
  800551:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800554:	89 fe                	mov    %edi,%esi
  800556:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800559:	85 db                	test   %ebx,%ebx
  80055b:	7f e2                	jg     80053f <vprintfmt+0x248>
  80055d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800560:	e9 be fd ff ff       	jmp    800323 <vprintfmt+0x2c>
  800565:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800568:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80056b:	83 f9 01             	cmp    $0x1,%ecx
  80056e:	7e 16                	jle    800586 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8d 50 08             	lea    0x8(%eax),%edx
  800576:	89 55 14             	mov    %edx,0x14(%ebp)
  800579:	8b 10                	mov    (%eax),%edx
  80057b:	8b 48 04             	mov    0x4(%eax),%ecx
  80057e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800581:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800584:	eb 32                	jmp    8005b8 <vprintfmt+0x2c1>
	else if (lflag)
  800586:	85 c9                	test   %ecx,%ecx
  800588:	74 18                	je     8005a2 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8d 50 04             	lea    0x4(%eax),%edx
  800590:	89 55 14             	mov    %edx,0x14(%ebp)
  800593:	8b 00                	mov    (%eax),%eax
  800595:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800598:	89 c1                	mov    %eax,%ecx
  80059a:	c1 f9 1f             	sar    $0x1f,%ecx
  80059d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005a0:	eb 16                	jmp    8005b8 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 50 04             	lea    0x4(%eax),%edx
  8005a8:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b0:	89 c2                	mov    %eax,%edx
  8005b2:	c1 fa 1f             	sar    $0x1f,%edx
  8005b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005b8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005bb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005be:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005c7:	0f 89 a7 00 00 00    	jns    800674 <vprintfmt+0x37d>
				putch('-', putdat);
  8005cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005d8:	ff d7                	call   *%edi
				num = -(long long) num;
  8005da:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005dd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005e0:	f7 d9                	neg    %ecx
  8005e2:	83 d3 00             	adc    $0x0,%ebx
  8005e5:	f7 db                	neg    %ebx
  8005e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ec:	e9 83 00 00 00       	jmp    800674 <vprintfmt+0x37d>
  8005f1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005f4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005f7:	89 ca                	mov    %ecx,%edx
  8005f9:	8d 45 14             	lea    0x14(%ebp),%eax
  8005fc:	e8 9f fc ff ff       	call   8002a0 <getuint>
  800601:	89 c1                	mov    %eax,%ecx
  800603:	89 d3                	mov    %edx,%ebx
  800605:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80060a:	eb 68                	jmp    800674 <vprintfmt+0x37d>
  80060c:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80060f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800612:	89 ca                	mov    %ecx,%edx
  800614:	8d 45 14             	lea    0x14(%ebp),%eax
  800617:	e8 84 fc ff ff       	call   8002a0 <getuint>
  80061c:	89 c1                	mov    %eax,%ecx
  80061e:	89 d3                	mov    %edx,%ebx
  800620:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800625:	eb 4d                	jmp    800674 <vprintfmt+0x37d>
  800627:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80062a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800635:	ff d7                	call   *%edi
			putch('x', putdat);
  800637:	89 74 24 04          	mov    %esi,0x4(%esp)
  80063b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800642:	ff d7                	call   *%edi
			num = (unsigned long long)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 50 04             	lea    0x4(%eax),%edx
  80064a:	89 55 14             	mov    %edx,0x14(%ebp)
  80064d:	8b 08                	mov    (%eax),%ecx
  80064f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800654:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800659:	eb 19                	jmp    800674 <vprintfmt+0x37d>
  80065b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800661:	89 ca                	mov    %ecx,%edx
  800663:	8d 45 14             	lea    0x14(%ebp),%eax
  800666:	e8 35 fc ff ff       	call   8002a0 <getuint>
  80066b:	89 c1                	mov    %eax,%ecx
  80066d:	89 d3                	mov    %edx,%ebx
  80066f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800674:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800678:	89 54 24 10          	mov    %edx,0x10(%esp)
  80067c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80067f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800683:	89 44 24 08          	mov    %eax,0x8(%esp)
  800687:	89 0c 24             	mov    %ecx,(%esp)
  80068a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80068e:	89 f2                	mov    %esi,%edx
  800690:	89 f8                	mov    %edi,%eax
  800692:	e8 21 fb ff ff       	call   8001b8 <printnum>
  800697:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80069a:	e9 84 fc ff ff       	jmp    800323 <vprintfmt+0x2c>
  80069f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006a6:	89 04 24             	mov    %eax,(%esp)
  8006a9:	ff d7                	call   *%edi
  8006ab:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006ae:	e9 70 fc ff ff       	jmp    800323 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006b7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006be:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8006c3:	80 38 25             	cmpb   $0x25,(%eax)
  8006c6:	0f 84 57 fc ff ff    	je     800323 <vprintfmt+0x2c>
  8006cc:	89 c3                	mov    %eax,%ebx
  8006ce:	eb f0                	jmp    8006c0 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8006d0:	83 c4 4c             	add    $0x4c,%esp
  8006d3:	5b                   	pop    %ebx
  8006d4:	5e                   	pop    %esi
  8006d5:	5f                   	pop    %edi
  8006d6:	5d                   	pop    %ebp
  8006d7:	c3                   	ret    

008006d8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
  8006db:	83 ec 28             	sub    $0x28,%esp
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8006e4:	85 c0                	test   %eax,%eax
  8006e6:	74 04                	je     8006ec <vsnprintf+0x14>
  8006e8:	85 d2                	test   %edx,%edx
  8006ea:	7f 07                	jg     8006f3 <vsnprintf+0x1b>
  8006ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006f1:	eb 3b                	jmp    80072e <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8006fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80070b:	8b 45 10             	mov    0x10(%ebp),%eax
  80070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800712:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800715:	89 44 24 04          	mov    %eax,0x4(%esp)
  800719:	c7 04 24 da 02 80 00 	movl   $0x8002da,(%esp)
  800720:	e8 d2 fb ff ff       	call   8002f7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800728:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800736:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800739:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80073d:	8b 45 10             	mov    0x10(%ebp),%eax
  800740:	89 44 24 08          	mov    %eax,0x8(%esp)
  800744:	8b 45 0c             	mov    0xc(%ebp),%eax
  800747:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 04 24             	mov    %eax,(%esp)
  800751:	e8 82 ff ff ff       	call   8006d8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80075e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800761:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	89 44 24 08          	mov    %eax,0x8(%esp)
  80076c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	89 04 24             	mov    %eax,(%esp)
  800779:	e8 79 fb ff ff       	call   8002f7 <vprintfmt>
	va_end(ap);
}
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	8b 55 08             	mov    0x8(%ebp),%edx
  800786:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80078b:	eb 03                	jmp    800790 <strlen+0x10>
		n++;
  80078d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800790:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800794:	75 f7                	jne    80078d <strlen+0xd>
		n++;
	return n;
}
  800796:	5d                   	pop    %ebp
  800797:	c3                   	ret    

00800798 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	53                   	push   %ebx
  80079c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80079f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007a7:	eb 03                	jmp    8007ac <strnlen+0x14>
		n++;
  8007a9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ac:	39 c1                	cmp    %eax,%ecx
  8007ae:	74 06                	je     8007b6 <strnlen+0x1e>
  8007b0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8007b4:	75 f3                	jne    8007a9 <strnlen+0x11>
		n++;
	return n;
}
  8007b6:	5b                   	pop    %ebx
  8007b7:	5d                   	pop    %ebp
  8007b8:	c3                   	ret    

008007b9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	53                   	push   %ebx
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007c8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007cf:	83 c2 01             	add    $0x1,%edx
  8007d2:	84 c9                	test   %cl,%cl
  8007d4:	75 f2                	jne    8007c8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007d6:	5b                   	pop    %ebx
  8007d7:	5d                   	pop    %ebp
  8007d8:	c3                   	ret    

008007d9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007d9:	55                   	push   %ebp
  8007da:	89 e5                	mov    %esp,%ebp
  8007dc:	53                   	push   %ebx
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e3:	89 1c 24             	mov    %ebx,(%esp)
  8007e6:	e8 95 ff ff ff       	call   800780 <strlen>
	strcpy(dst + len, src);
  8007eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007f2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8007f5:	89 04 24             	mov    %eax,(%esp)
  8007f8:	e8 bc ff ff ff       	call   8007b9 <strcpy>
	return dst;
}
  8007fd:	89 d8                	mov    %ebx,%eax
  8007ff:	83 c4 08             	add    $0x8,%esp
  800802:	5b                   	pop    %ebx
  800803:	5d                   	pop    %ebp
  800804:	c3                   	ret    

00800805 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	56                   	push   %esi
  800809:	53                   	push   %ebx
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800810:	8b 75 10             	mov    0x10(%ebp),%esi
  800813:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800818:	eb 0f                	jmp    800829 <strncpy+0x24>
		*dst++ = *src;
  80081a:	0f b6 19             	movzbl (%ecx),%ebx
  80081d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800820:	80 39 01             	cmpb   $0x1,(%ecx)
  800823:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800826:	83 c2 01             	add    $0x1,%edx
  800829:	39 f2                	cmp    %esi,%edx
  80082b:	72 ed                	jb     80081a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80082d:	5b                   	pop    %ebx
  80082e:	5e                   	pop    %esi
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	56                   	push   %esi
  800835:	53                   	push   %ebx
  800836:	8b 75 08             	mov    0x8(%ebp),%esi
  800839:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80083f:	89 f0                	mov    %esi,%eax
  800841:	85 d2                	test   %edx,%edx
  800843:	75 0a                	jne    80084f <strlcpy+0x1e>
  800845:	eb 17                	jmp    80085e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800847:	88 18                	mov    %bl,(%eax)
  800849:	83 c0 01             	add    $0x1,%eax
  80084c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80084f:	83 ea 01             	sub    $0x1,%edx
  800852:	74 07                	je     80085b <strlcpy+0x2a>
  800854:	0f b6 19             	movzbl (%ecx),%ebx
  800857:	84 db                	test   %bl,%bl
  800859:	75 ec                	jne    800847 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80085b:	c6 00 00             	movb   $0x0,(%eax)
  80085e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800860:	5b                   	pop    %ebx
  800861:	5e                   	pop    %esi
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80086d:	eb 06                	jmp    800875 <strcmp+0x11>
		p++, q++;
  80086f:	83 c1 01             	add    $0x1,%ecx
  800872:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800875:	0f b6 01             	movzbl (%ecx),%eax
  800878:	84 c0                	test   %al,%al
  80087a:	74 04                	je     800880 <strcmp+0x1c>
  80087c:	3a 02                	cmp    (%edx),%al
  80087e:	74 ef                	je     80086f <strcmp+0xb>
  800880:	0f b6 c0             	movzbl %al,%eax
  800883:	0f b6 12             	movzbl (%edx),%edx
  800886:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	53                   	push   %ebx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800894:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800897:	eb 09                	jmp    8008a2 <strncmp+0x18>
		n--, p++, q++;
  800899:	83 ea 01             	sub    $0x1,%edx
  80089c:	83 c0 01             	add    $0x1,%eax
  80089f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008a2:	85 d2                	test   %edx,%edx
  8008a4:	75 07                	jne    8008ad <strncmp+0x23>
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	eb 13                	jmp    8008c0 <strncmp+0x36>
  8008ad:	0f b6 18             	movzbl (%eax),%ebx
  8008b0:	84 db                	test   %bl,%bl
  8008b2:	74 04                	je     8008b8 <strncmp+0x2e>
  8008b4:	3a 19                	cmp    (%ecx),%bl
  8008b6:	74 e1                	je     800899 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b8:	0f b6 00             	movzbl (%eax),%eax
  8008bb:	0f b6 11             	movzbl (%ecx),%edx
  8008be:	29 d0                	sub    %edx,%eax
}
  8008c0:	5b                   	pop    %ebx
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008cd:	eb 07                	jmp    8008d6 <strchr+0x13>
		if (*s == c)
  8008cf:	38 ca                	cmp    %cl,%dl
  8008d1:	74 0f                	je     8008e2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008d3:	83 c0 01             	add    $0x1,%eax
  8008d6:	0f b6 10             	movzbl (%eax),%edx
  8008d9:	84 d2                	test   %dl,%dl
  8008db:	75 f2                	jne    8008cf <strchr+0xc>
  8008dd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ee:	eb 07                	jmp    8008f7 <strfind+0x13>
		if (*s == c)
  8008f0:	38 ca                	cmp    %cl,%dl
  8008f2:	74 0a                	je     8008fe <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008f4:	83 c0 01             	add    $0x1,%eax
  8008f7:	0f b6 10             	movzbl (%eax),%edx
  8008fa:	84 d2                	test   %dl,%dl
  8008fc:	75 f2                	jne    8008f0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	89 1c 24             	mov    %ebx,(%esp)
  800909:	89 74 24 04          	mov    %esi,0x4(%esp)
  80090d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800911:	8b 7d 08             	mov    0x8(%ebp),%edi
  800914:	8b 45 0c             	mov    0xc(%ebp),%eax
  800917:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80091a:	85 c9                	test   %ecx,%ecx
  80091c:	74 30                	je     80094e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80091e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800924:	75 25                	jne    80094b <memset+0x4b>
  800926:	f6 c1 03             	test   $0x3,%cl
  800929:	75 20                	jne    80094b <memset+0x4b>
		c &= 0xFF;
  80092b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80092e:	89 d3                	mov    %edx,%ebx
  800930:	c1 e3 08             	shl    $0x8,%ebx
  800933:	89 d6                	mov    %edx,%esi
  800935:	c1 e6 18             	shl    $0x18,%esi
  800938:	89 d0                	mov    %edx,%eax
  80093a:	c1 e0 10             	shl    $0x10,%eax
  80093d:	09 f0                	or     %esi,%eax
  80093f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800941:	09 d8                	or     %ebx,%eax
  800943:	c1 e9 02             	shr    $0x2,%ecx
  800946:	fc                   	cld    
  800947:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800949:	eb 03                	jmp    80094e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80094b:	fc                   	cld    
  80094c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80094e:	89 f8                	mov    %edi,%eax
  800950:	8b 1c 24             	mov    (%esp),%ebx
  800953:	8b 74 24 04          	mov    0x4(%esp),%esi
  800957:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80095b:	89 ec                	mov    %ebp,%esp
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	89 34 24             	mov    %esi,(%esp)
  800968:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800972:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800975:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800977:	39 c6                	cmp    %eax,%esi
  800979:	73 35                	jae    8009b0 <memmove+0x51>
  80097b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80097e:	39 d0                	cmp    %edx,%eax
  800980:	73 2e                	jae    8009b0 <memmove+0x51>
		s += n;
		d += n;
  800982:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800984:	f6 c2 03             	test   $0x3,%dl
  800987:	75 1b                	jne    8009a4 <memmove+0x45>
  800989:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80098f:	75 13                	jne    8009a4 <memmove+0x45>
  800991:	f6 c1 03             	test   $0x3,%cl
  800994:	75 0e                	jne    8009a4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800996:	83 ef 04             	sub    $0x4,%edi
  800999:	8d 72 fc             	lea    -0x4(%edx),%esi
  80099c:	c1 e9 02             	shr    $0x2,%ecx
  80099f:	fd                   	std    
  8009a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a2:	eb 09                	jmp    8009ad <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009a4:	83 ef 01             	sub    $0x1,%edi
  8009a7:	8d 72 ff             	lea    -0x1(%edx),%esi
  8009aa:	fd                   	std    
  8009ab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ad:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ae:	eb 20                	jmp    8009d0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009b6:	75 15                	jne    8009cd <memmove+0x6e>
  8009b8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009be:	75 0d                	jne    8009cd <memmove+0x6e>
  8009c0:	f6 c1 03             	test   $0x3,%cl
  8009c3:	75 08                	jne    8009cd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8009c5:	c1 e9 02             	shr    $0x2,%ecx
  8009c8:	fc                   	cld    
  8009c9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cb:	eb 03                	jmp    8009d0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009cd:	fc                   	cld    
  8009ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d0:	8b 34 24             	mov    (%esp),%esi
  8009d3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009d7:	89 ec                	mov    %ebp,%esp
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 04 24             	mov    %eax,(%esp)
  8009f5:	e8 65 ff ff ff       	call   80095f <memmove>
}
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	57                   	push   %edi
  800a00:	56                   	push   %esi
  800a01:	53                   	push   %ebx
  800a02:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a0b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a10:	eb 1c                	jmp    800a2e <memcmp+0x32>
		if (*s1 != *s2)
  800a12:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800a16:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800a1a:	83 c2 01             	add    $0x1,%edx
  800a1d:	83 e9 01             	sub    $0x1,%ecx
  800a20:	38 d8                	cmp    %bl,%al
  800a22:	74 0a                	je     800a2e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800a24:	0f b6 c0             	movzbl %al,%eax
  800a27:	0f b6 db             	movzbl %bl,%ebx
  800a2a:	29 d8                	sub    %ebx,%eax
  800a2c:	eb 09                	jmp    800a37 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2e:	85 c9                	test   %ecx,%ecx
  800a30:	75 e0                	jne    800a12 <memcmp+0x16>
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800a37:	5b                   	pop    %ebx
  800a38:	5e                   	pop    %esi
  800a39:	5f                   	pop    %edi
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a4a:	eb 07                	jmp    800a53 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a4c:	38 08                	cmp    %cl,(%eax)
  800a4e:	74 07                	je     800a57 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a50:	83 c0 01             	add    $0x1,%eax
  800a53:	39 d0                	cmp    %edx,%eax
  800a55:	72 f5                	jb     800a4c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	57                   	push   %edi
  800a5d:	56                   	push   %esi
  800a5e:	53                   	push   %ebx
  800a5f:	83 ec 04             	sub    $0x4,%esp
  800a62:	8b 55 08             	mov    0x8(%ebp),%edx
  800a65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a68:	eb 03                	jmp    800a6d <strtol+0x14>
		s++;
  800a6a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6d:	0f b6 02             	movzbl (%edx),%eax
  800a70:	3c 20                	cmp    $0x20,%al
  800a72:	74 f6                	je     800a6a <strtol+0x11>
  800a74:	3c 09                	cmp    $0x9,%al
  800a76:	74 f2                	je     800a6a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a78:	3c 2b                	cmp    $0x2b,%al
  800a7a:	75 0c                	jne    800a88 <strtol+0x2f>
		s++;
  800a7c:	8d 52 01             	lea    0x1(%edx),%edx
  800a7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a86:	eb 15                	jmp    800a9d <strtol+0x44>
	else if (*s == '-')
  800a88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a8f:	3c 2d                	cmp    $0x2d,%al
  800a91:	75 0a                	jne    800a9d <strtol+0x44>
		s++, neg = 1;
  800a93:	8d 52 01             	lea    0x1(%edx),%edx
  800a96:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9d:	85 db                	test   %ebx,%ebx
  800a9f:	0f 94 c0             	sete   %al
  800aa2:	74 05                	je     800aa9 <strtol+0x50>
  800aa4:	83 fb 10             	cmp    $0x10,%ebx
  800aa7:	75 15                	jne    800abe <strtol+0x65>
  800aa9:	80 3a 30             	cmpb   $0x30,(%edx)
  800aac:	75 10                	jne    800abe <strtol+0x65>
  800aae:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ab2:	75 0a                	jne    800abe <strtol+0x65>
		s += 2, base = 16;
  800ab4:	83 c2 02             	add    $0x2,%edx
  800ab7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abc:	eb 13                	jmp    800ad1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800abe:	84 c0                	test   %al,%al
  800ac0:	74 0f                	je     800ad1 <strtol+0x78>
  800ac2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ac7:	80 3a 30             	cmpb   $0x30,(%edx)
  800aca:	75 05                	jne    800ad1 <strtol+0x78>
		s++, base = 8;
  800acc:	83 c2 01             	add    $0x1,%edx
  800acf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ad8:	0f b6 0a             	movzbl (%edx),%ecx
  800adb:	89 cf                	mov    %ecx,%edi
  800add:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ae0:	80 fb 09             	cmp    $0x9,%bl
  800ae3:	77 08                	ja     800aed <strtol+0x94>
			dig = *s - '0';
  800ae5:	0f be c9             	movsbl %cl,%ecx
  800ae8:	83 e9 30             	sub    $0x30,%ecx
  800aeb:	eb 1e                	jmp    800b0b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800aed:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800af0:	80 fb 19             	cmp    $0x19,%bl
  800af3:	77 08                	ja     800afd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800af5:	0f be c9             	movsbl %cl,%ecx
  800af8:	83 e9 57             	sub    $0x57,%ecx
  800afb:	eb 0e                	jmp    800b0b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800afd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b00:	80 fb 19             	cmp    $0x19,%bl
  800b03:	77 15                	ja     800b1a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b05:	0f be c9             	movsbl %cl,%ecx
  800b08:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b0b:	39 f1                	cmp    %esi,%ecx
  800b0d:	7d 0b                	jge    800b1a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b0f:	83 c2 01             	add    $0x1,%edx
  800b12:	0f af c6             	imul   %esi,%eax
  800b15:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800b18:	eb be                	jmp    800ad8 <strtol+0x7f>
  800b1a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800b1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b20:	74 05                	je     800b27 <strtol+0xce>
		*endptr = (char *) s;
  800b22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b25:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b27:	89 ca                	mov    %ecx,%edx
  800b29:	f7 da                	neg    %edx
  800b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b2f:	0f 45 c2             	cmovne %edx,%eax
}
  800b32:	83 c4 04             	add    $0x4,%esp
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5f                   	pop    %edi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    
	...

00800b3c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 0c             	sub    $0xc,%esp
  800b42:	89 1c 24             	mov    %ebx,(%esp)
  800b45:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b49:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	b8 01 00 00 00       	mov    $0x1,%eax
  800b57:	89 d1                	mov    %edx,%ecx
  800b59:	89 d3                	mov    %edx,%ebx
  800b5b:	89 d7                	mov    %edx,%edi
  800b5d:	89 d6                	mov    %edx,%esi
  800b5f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b61:	8b 1c 24             	mov    (%esp),%ebx
  800b64:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b68:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b6c:	89 ec                	mov    %ebp,%esp
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 0c             	sub    $0xc,%esp
  800b76:	89 1c 24             	mov    %ebx,(%esp)
  800b79:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b7d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
  800b86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b89:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8c:	89 c3                	mov    %eax,%ebx
  800b8e:	89 c7                	mov    %eax,%edi
  800b90:	89 c6                	mov    %eax,%esi
  800b92:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b94:	8b 1c 24             	mov    (%esp),%ebx
  800b97:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b9b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b9f:	89 ec                	mov    %ebp,%esp
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	83 ec 0c             	sub    $0xc,%esp
  800ba9:	89 1c 24             	mov    %ebx,(%esp)
  800bac:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bb0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb9:	b8 10 00 00 00       	mov    $0x10,%eax
  800bbe:	89 d1                	mov    %edx,%ecx
  800bc0:	89 d3                	mov    %edx,%ebx
  800bc2:	89 d7                	mov    %edx,%edi
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800bc8:	8b 1c 24             	mov    (%esp),%ebx
  800bcb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bcf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bd3:	89 ec                	mov    %ebp,%esp
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 38             	sub    $0x38,%esp
  800bdd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800be0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800be3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800be6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800beb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800bf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf6:	89 df                	mov    %ebx,%edi
  800bf8:	89 de                	mov    %ebx,%esi
  800bfa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bfc:	85 c0                	test   %eax,%eax
  800bfe:	7e 28                	jle    800c28 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c04:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800c0b:	00 
  800c0c:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  800c13:	00 
  800c14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c1b:	00 
  800c1c:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  800c23:	e8 a0 04 00 00       	call   8010c8 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800c28:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c2b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c2e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c31:	89 ec                	mov    %ebp,%esp
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 38             	sub    $0x38,%esp
  800c3b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c3e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c41:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c49:	b8 0e 00 00 00       	mov    $0xe,%eax
  800c4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c51:	8b 55 08             	mov    0x8(%ebp),%edx
  800c54:	89 df                	mov    %ebx,%edi
  800c56:	89 de                	mov    %ebx,%esi
  800c58:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c5a:	85 c0                	test   %eax,%eax
  800c5c:	7e 28                	jle    800c86 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c62:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800c69:	00 
  800c6a:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  800c71:	00 
  800c72:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c79:	00 
  800c7a:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  800c81:	e8 42 04 00 00       	call   8010c8 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800c86:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c89:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c8c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c8f:	89 ec                	mov    %ebp,%esp
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 38             	sub    $0x38,%esp
  800c99:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c9c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c9f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	89 cb                	mov    %ecx,%ebx
  800cb1:	89 cf                	mov    %ecx,%edi
  800cb3:	89 ce                	mov    %ecx,%esi
  800cb5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb7:	85 c0                	test   %eax,%eax
  800cb9:	7e 28                	jle    800ce3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cbf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800cc6:	00 
  800cc7:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  800cce:	00 
  800ccf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd6:	00 
  800cd7:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  800cde:	e8 e5 03 00 00       	call   8010c8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ce3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ce6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ce9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cec:	89 ec                	mov    %ebp,%esp
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	89 1c 24             	mov    %ebx,(%esp)
  800cf9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cfd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d01:	be 00 00 00 00       	mov    $0x0,%esi
  800d06:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d0b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d19:	8b 1c 24             	mov    (%esp),%ebx
  800d1c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d20:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d24:	89 ec                	mov    %ebp,%esp
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    

00800d28 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 38             	sub    $0x38,%esp
  800d2e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d31:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d34:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	89 df                	mov    %ebx,%edi
  800d49:	89 de                	mov    %ebx,%esi
  800d4b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7e 28                	jle    800d79 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d55:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d5c:	00 
  800d5d:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  800d64:	00 
  800d65:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6c:	00 
  800d6d:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  800d74:	e8 4f 03 00 00       	call   8010c8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d79:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d7c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d7f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d82:	89 ec                	mov    %ebp,%esp
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 38             	sub    $0x38,%esp
  800d8c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d8f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d92:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da2:	8b 55 08             	mov    0x8(%ebp),%edx
  800da5:	89 df                	mov    %ebx,%edi
  800da7:	89 de                	mov    %ebx,%esi
  800da9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dab:	85 c0                	test   %eax,%eax
  800dad:	7e 28                	jle    800dd7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dba:	00 
  800dbb:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  800dc2:	00 
  800dc3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dca:	00 
  800dcb:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  800dd2:	e8 f1 02 00 00       	call   8010c8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dda:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ddd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800de0:	89 ec                	mov    %ebp,%esp
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 38             	sub    $0x38,%esp
  800dea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ded:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df8:	b8 08 00 00 00       	mov    $0x8,%eax
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	8b 55 08             	mov    0x8(%ebp),%edx
  800e03:	89 df                	mov    %ebx,%edi
  800e05:	89 de                	mov    %ebx,%esi
  800e07:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	7e 28                	jle    800e35 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e11:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e18:	00 
  800e19:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  800e20:	00 
  800e21:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e28:	00 
  800e29:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  800e30:	e8 93 02 00 00       	call   8010c8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e35:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e38:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e3b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e3e:	89 ec                	mov    %ebp,%esp
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    

00800e42 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 38             	sub    $0x38,%esp
  800e48:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e4b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e4e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e56:	b8 06 00 00 00       	mov    $0x6,%eax
  800e5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	89 df                	mov    %ebx,%edi
  800e63:	89 de                	mov    %ebx,%esi
  800e65:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	7e 28                	jle    800e93 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e76:	00 
  800e77:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  800e7e:	00 
  800e7f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e86:	00 
  800e87:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  800e8e:	e8 35 02 00 00       	call   8010c8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e93:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e96:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e99:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e9c:	89 ec                	mov    %ebp,%esp
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	83 ec 38             	sub    $0x38,%esp
  800ea6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eac:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eaf:	b8 05 00 00 00       	mov    $0x5,%eax
  800eb4:	8b 75 18             	mov    0x18(%ebp),%esi
  800eb7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	7e 28                	jle    800ef1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ed4:	00 
  800ed5:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  800edc:	00 
  800edd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee4:	00 
  800ee5:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  800eec:	e8 d7 01 00 00       	call   8010c8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ef1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800efa:	89 ec                	mov    %ebp,%esp
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    

00800efe <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 38             	sub    $0x38,%esp
  800f04:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f07:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f0a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0d:	be 00 00 00 00       	mov    $0x0,%esi
  800f12:	b8 04 00 00 00       	mov    $0x4,%eax
  800f17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	89 f7                	mov    %esi,%edi
  800f22:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	7e 28                	jle    800f50 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f28:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f33:	00 
  800f34:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  800f3b:	00 
  800f3c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f43:	00 
  800f44:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  800f4b:	e8 78 01 00 00       	call   8010c8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f50:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f53:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f56:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f59:	89 ec                	mov    %ebp,%esp
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	83 ec 0c             	sub    $0xc,%esp
  800f63:	89 1c 24             	mov    %ebx,(%esp)
  800f66:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f6a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f73:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f78:	89 d1                	mov    %edx,%ecx
  800f7a:	89 d3                	mov    %edx,%ebx
  800f7c:	89 d7                	mov    %edx,%edi
  800f7e:	89 d6                	mov    %edx,%esi
  800f80:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f82:	8b 1c 24             	mov    (%esp),%ebx
  800f85:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f89:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f8d:	89 ec                	mov    %ebp,%esp
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    

00800f91 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	89 1c 24             	mov    %ebx,(%esp)
  800f9a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f9e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa7:	b8 02 00 00 00       	mov    $0x2,%eax
  800fac:	89 d1                	mov    %edx,%ecx
  800fae:	89 d3                	mov    %edx,%ebx
  800fb0:	89 d7                	mov    %edx,%edi
  800fb2:	89 d6                	mov    %edx,%esi
  800fb4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fb6:	8b 1c 24             	mov    (%esp),%ebx
  800fb9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fbd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fc1:	89 ec                	mov    %ebp,%esp
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 38             	sub    $0x38,%esp
  800fcb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fce:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fd1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd9:	b8 03 00 00 00       	mov    $0x3,%eax
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	89 cb                	mov    %ecx,%ebx
  800fe3:	89 cf                	mov    %ecx,%edi
  800fe5:	89 ce                	mov    %ecx,%esi
  800fe7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7e 28                	jle    801015 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fed:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ff8:	00 
  800ff9:	c7 44 24 08 c7 16 80 	movl   $0x8016c7,0x8(%esp)
  801000:	00 
  801001:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801008:	00 
  801009:	c7 04 24 e4 16 80 00 	movl   $0x8016e4,(%esp)
  801010:	e8 b3 00 00 00       	call   8010c8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801015:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801018:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80101b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101e:	89 ec                	mov    %ebp,%esp
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    
	...

00801024 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	53                   	push   %ebx
  801028:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  80102b:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801032:	75 5b                	jne    80108f <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  801034:	e8 58 ff ff ff       	call   800f91 <sys_getenvid>
  801039:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80103b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801042:	00 
  801043:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80104a:	ee 
  80104b:	89 04 24             	mov    %eax,(%esp)
  80104e:	e8 ab fe ff ff       	call   800efe <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  801053:	85 c0                	test   %eax,%eax
  801055:	74 28                	je     80107f <set_pgfault_handler+0x5b>
  801057:	89 44 24 10          	mov    %eax,0x10(%esp)
  80105b:	c7 44 24 0c 19 17 80 	movl   $0x801719,0xc(%esp)
  801062:	00 
  801063:	c7 44 24 08 f2 16 80 	movl   $0x8016f2,0x8(%esp)
  80106a:	00 
  80106b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801072:	00 
  801073:	c7 04 24 0b 17 80 00 	movl   $0x80170b,(%esp)
  80107a:	e8 49 00 00 00       	call   8010c8 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80107f:	c7 44 24 04 a0 10 80 	movl   $0x8010a0,0x4(%esp)
  801086:	00 
  801087:	89 1c 24             	mov    %ebx,(%esp)
  80108a:	e8 99 fc ff ff       	call   800d28 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	a3 08 20 80 00       	mov    %eax,0x802008
	
}
  801097:	83 c4 24             	add    $0x24,%esp
  80109a:	5b                   	pop    %ebx
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    
  80109d:	00 00                	add    %al,(%eax)
	...

008010a0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010a0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010a1:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8010a6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010a8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  8010ab:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  8010ae:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  8010b2:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  8010b6:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  8010b9:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  8010bc:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  8010c0:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  8010c1:	83 c4 04             	add    $0x4,%esp
	popfl ;
  8010c4:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8010c5:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8010c6:	c3                   	ret    
	...

008010c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
  8010cd:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8010d0:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010d3:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8010d9:	e8 b3 fe ff ff       	call   800f91 <sys_getenvid>
  8010de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8010e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8010ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8010f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f4:	c7 04 24 30 17 80 00 	movl   $0x801730,(%esp)
  8010fb:	e8 59 f0 ff ff       	call   800159 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801100:	89 74 24 04          	mov    %esi,0x4(%esp)
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	89 04 24             	mov    %eax,(%esp)
  80110a:	e8 e9 ef ff ff       	call   8000f8 <vcprintf>
	cprintf("\n");
  80110f:	c7 04 24 ba 13 80 00 	movl   $0x8013ba,(%esp)
  801116:	e8 3e f0 ff ff       	call   800159 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80111b:	cc                   	int3   
  80111c:	eb fd                	jmp    80111b <_panic+0x53>
	...

00801120 <__udivdi3>:
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	57                   	push   %edi
  801124:	56                   	push   %esi
  801125:	83 ec 10             	sub    $0x10,%esp
  801128:	8b 45 14             	mov    0x14(%ebp),%eax
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	8b 75 10             	mov    0x10(%ebp),%esi
  801131:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801134:	85 c0                	test   %eax,%eax
  801136:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801139:	75 35                	jne    801170 <__udivdi3+0x50>
  80113b:	39 fe                	cmp    %edi,%esi
  80113d:	77 61                	ja     8011a0 <__udivdi3+0x80>
  80113f:	85 f6                	test   %esi,%esi
  801141:	75 0b                	jne    80114e <__udivdi3+0x2e>
  801143:	b8 01 00 00 00       	mov    $0x1,%eax
  801148:	31 d2                	xor    %edx,%edx
  80114a:	f7 f6                	div    %esi
  80114c:	89 c6                	mov    %eax,%esi
  80114e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801151:	31 d2                	xor    %edx,%edx
  801153:	89 f8                	mov    %edi,%eax
  801155:	f7 f6                	div    %esi
  801157:	89 c7                	mov    %eax,%edi
  801159:	89 c8                	mov    %ecx,%eax
  80115b:	f7 f6                	div    %esi
  80115d:	89 c1                	mov    %eax,%ecx
  80115f:	89 fa                	mov    %edi,%edx
  801161:	89 c8                	mov    %ecx,%eax
  801163:	83 c4 10             	add    $0x10,%esp
  801166:	5e                   	pop    %esi
  801167:	5f                   	pop    %edi
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    
  80116a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801170:	39 f8                	cmp    %edi,%eax
  801172:	77 1c                	ja     801190 <__udivdi3+0x70>
  801174:	0f bd d0             	bsr    %eax,%edx
  801177:	83 f2 1f             	xor    $0x1f,%edx
  80117a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80117d:	75 39                	jne    8011b8 <__udivdi3+0x98>
  80117f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801182:	0f 86 a0 00 00 00    	jbe    801228 <__udivdi3+0x108>
  801188:	39 f8                	cmp    %edi,%eax
  80118a:	0f 82 98 00 00 00    	jb     801228 <__udivdi3+0x108>
  801190:	31 ff                	xor    %edi,%edi
  801192:	31 c9                	xor    %ecx,%ecx
  801194:	89 c8                	mov    %ecx,%eax
  801196:	89 fa                	mov    %edi,%edx
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	5e                   	pop    %esi
  80119c:	5f                   	pop    %edi
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    
  80119f:	90                   	nop
  8011a0:	89 d1                	mov    %edx,%ecx
  8011a2:	89 fa                	mov    %edi,%edx
  8011a4:	89 c8                	mov    %ecx,%eax
  8011a6:	31 ff                	xor    %edi,%edi
  8011a8:	f7 f6                	div    %esi
  8011aa:	89 c1                	mov    %eax,%ecx
  8011ac:	89 fa                	mov    %edi,%edx
  8011ae:	89 c8                	mov    %ecx,%eax
  8011b0:	83 c4 10             	add    $0x10,%esp
  8011b3:	5e                   	pop    %esi
  8011b4:	5f                   	pop    %edi
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    
  8011b7:	90                   	nop
  8011b8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011bc:	89 f2                	mov    %esi,%edx
  8011be:	d3 e0                	shl    %cl,%eax
  8011c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c3:	b8 20 00 00 00       	mov    $0x20,%eax
  8011c8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8011cb:	89 c1                	mov    %eax,%ecx
  8011cd:	d3 ea                	shr    %cl,%edx
  8011cf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011d3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8011d6:	d3 e6                	shl    %cl,%esi
  8011d8:	89 c1                	mov    %eax,%ecx
  8011da:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8011dd:	89 fe                	mov    %edi,%esi
  8011df:	d3 ee                	shr    %cl,%esi
  8011e1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8011e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011eb:	d3 e7                	shl    %cl,%edi
  8011ed:	89 c1                	mov    %eax,%ecx
  8011ef:	d3 ea                	shr    %cl,%edx
  8011f1:	09 d7                	or     %edx,%edi
  8011f3:	89 f2                	mov    %esi,%edx
  8011f5:	89 f8                	mov    %edi,%eax
  8011f7:	f7 75 ec             	divl   -0x14(%ebp)
  8011fa:	89 d6                	mov    %edx,%esi
  8011fc:	89 c7                	mov    %eax,%edi
  8011fe:	f7 65 e8             	mull   -0x18(%ebp)
  801201:	39 d6                	cmp    %edx,%esi
  801203:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801206:	72 30                	jb     801238 <__udivdi3+0x118>
  801208:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80120b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80120f:	d3 e2                	shl    %cl,%edx
  801211:	39 c2                	cmp    %eax,%edx
  801213:	73 05                	jae    80121a <__udivdi3+0xfa>
  801215:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801218:	74 1e                	je     801238 <__udivdi3+0x118>
  80121a:	89 f9                	mov    %edi,%ecx
  80121c:	31 ff                	xor    %edi,%edi
  80121e:	e9 71 ff ff ff       	jmp    801194 <__udivdi3+0x74>
  801223:	90                   	nop
  801224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801228:	31 ff                	xor    %edi,%edi
  80122a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80122f:	e9 60 ff ff ff       	jmp    801194 <__udivdi3+0x74>
  801234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801238:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80123b:	31 ff                	xor    %edi,%edi
  80123d:	89 c8                	mov    %ecx,%eax
  80123f:	89 fa                	mov    %edi,%edx
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	5e                   	pop    %esi
  801245:	5f                   	pop    %edi
  801246:	5d                   	pop    %ebp
  801247:	c3                   	ret    
	...

00801250 <__umoddi3>:
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	57                   	push   %edi
  801254:	56                   	push   %esi
  801255:	83 ec 20             	sub    $0x20,%esp
  801258:	8b 55 14             	mov    0x14(%ebp),%edx
  80125b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801261:	8b 75 0c             	mov    0xc(%ebp),%esi
  801264:	85 d2                	test   %edx,%edx
  801266:	89 c8                	mov    %ecx,%eax
  801268:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80126b:	75 13                	jne    801280 <__umoddi3+0x30>
  80126d:	39 f7                	cmp    %esi,%edi
  80126f:	76 3f                	jbe    8012b0 <__umoddi3+0x60>
  801271:	89 f2                	mov    %esi,%edx
  801273:	f7 f7                	div    %edi
  801275:	89 d0                	mov    %edx,%eax
  801277:	31 d2                	xor    %edx,%edx
  801279:	83 c4 20             	add    $0x20,%esp
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    
  801280:	39 f2                	cmp    %esi,%edx
  801282:	77 4c                	ja     8012d0 <__umoddi3+0x80>
  801284:	0f bd ca             	bsr    %edx,%ecx
  801287:	83 f1 1f             	xor    $0x1f,%ecx
  80128a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80128d:	75 51                	jne    8012e0 <__umoddi3+0x90>
  80128f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801292:	0f 87 e0 00 00 00    	ja     801378 <__umoddi3+0x128>
  801298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129b:	29 f8                	sub    %edi,%eax
  80129d:	19 d6                	sbb    %edx,%esi
  80129f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a5:	89 f2                	mov    %esi,%edx
  8012a7:	83 c4 20             	add    $0x20,%esp
  8012aa:	5e                   	pop    %esi
  8012ab:	5f                   	pop    %edi
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    
  8012ae:	66 90                	xchg   %ax,%ax
  8012b0:	85 ff                	test   %edi,%edi
  8012b2:	75 0b                	jne    8012bf <__umoddi3+0x6f>
  8012b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8012b9:	31 d2                	xor    %edx,%edx
  8012bb:	f7 f7                	div    %edi
  8012bd:	89 c7                	mov    %eax,%edi
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	31 d2                	xor    %edx,%edx
  8012c3:	f7 f7                	div    %edi
  8012c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c8:	f7 f7                	div    %edi
  8012ca:	eb a9                	jmp    801275 <__umoddi3+0x25>
  8012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012d0:	89 c8                	mov    %ecx,%eax
  8012d2:	89 f2                	mov    %esi,%edx
  8012d4:	83 c4 20             	add    $0x20,%esp
  8012d7:	5e                   	pop    %esi
  8012d8:	5f                   	pop    %edi
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    
  8012db:	90                   	nop
  8012dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012e0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012e4:	d3 e2                	shl    %cl,%edx
  8012e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012e9:	ba 20 00 00 00       	mov    $0x20,%edx
  8012ee:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8012f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8012f4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012f8:	89 fa                	mov    %edi,%edx
  8012fa:	d3 ea                	shr    %cl,%edx
  8012fc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801300:	0b 55 f4             	or     -0xc(%ebp),%edx
  801303:	d3 e7                	shl    %cl,%edi
  801305:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801309:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80130c:	89 f2                	mov    %esi,%edx
  80130e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801311:	89 c7                	mov    %eax,%edi
  801313:	d3 ea                	shr    %cl,%edx
  801315:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801319:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80131c:	89 c2                	mov    %eax,%edx
  80131e:	d3 e6                	shl    %cl,%esi
  801320:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801324:	d3 ea                	shr    %cl,%edx
  801326:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80132a:	09 d6                	or     %edx,%esi
  80132c:	89 f0                	mov    %esi,%eax
  80132e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801331:	d3 e7                	shl    %cl,%edi
  801333:	89 f2                	mov    %esi,%edx
  801335:	f7 75 f4             	divl   -0xc(%ebp)
  801338:	89 d6                	mov    %edx,%esi
  80133a:	f7 65 e8             	mull   -0x18(%ebp)
  80133d:	39 d6                	cmp    %edx,%esi
  80133f:	72 2b                	jb     80136c <__umoddi3+0x11c>
  801341:	39 c7                	cmp    %eax,%edi
  801343:	72 23                	jb     801368 <__umoddi3+0x118>
  801345:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801349:	29 c7                	sub    %eax,%edi
  80134b:	19 d6                	sbb    %edx,%esi
  80134d:	89 f0                	mov    %esi,%eax
  80134f:	89 f2                	mov    %esi,%edx
  801351:	d3 ef                	shr    %cl,%edi
  801353:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801357:	d3 e0                	shl    %cl,%eax
  801359:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80135d:	09 f8                	or     %edi,%eax
  80135f:	d3 ea                	shr    %cl,%edx
  801361:	83 c4 20             	add    $0x20,%esp
  801364:	5e                   	pop    %esi
  801365:	5f                   	pop    %edi
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    
  801368:	39 d6                	cmp    %edx,%esi
  80136a:	75 d9                	jne    801345 <__umoddi3+0xf5>
  80136c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80136f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801372:	eb d1                	jmp    801345 <__umoddi3+0xf5>
  801374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801378:	39 f2                	cmp    %esi,%edx
  80137a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801380:	0f 82 12 ff ff ff    	jb     801298 <__umoddi3+0x48>
  801386:	e9 17 ff ff ff       	jmp    8012a2 <__umoddi3+0x52>
