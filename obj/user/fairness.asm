
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 97 00 00 00       	call   8000c8 <libmain>
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
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 20             	sub    $0x20,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003c:	e8 90 0f 00 00       	call   800fd1 <sys_getenvid>
  800041:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800043:	81 3d 04 20 80 00 7c 	cmpl   $0xeec0007c,0x802004
  80004a:	00 c0 ee 
  80004d:	75 34                	jne    800083 <umain+0x4f>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004f:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800052:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800059:	00 
  80005a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800061:	00 
  800062:	89 34 24             	mov    %esi,(%esp)
  800065:	e8 9c 10 00 00       	call   801106 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800071:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800075:	c7 04 24 60 14 80 00 	movl   $0x801460,(%esp)
  80007c:	e8 0c 01 00 00       	call   80018d <cprintf>
  800081:	eb cf                	jmp    800052 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800083:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800088:	89 44 24 08          	mov    %eax,0x8(%esp)
  80008c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800090:	c7 04 24 71 14 80 00 	movl   $0x801471,(%esp)
  800097:	e8 f1 00 00 00       	call   80018d <cprintf>
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80009c:	bb c4 00 c0 ee       	mov    $0xeec000c4,%ebx
  8000a1:	8b 03                	mov    (%ebx),%eax
  8000a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000aa:	00 
  8000ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000b2:	00 
  8000b3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ba:	00 
  8000bb:	89 04 24             	mov    %eax,(%esp)
  8000be:	e8 d7 0f 00 00       	call   80109a <ipc_send>
  8000c3:	eb dc                	jmp    8000a1 <umain+0x6d>
  8000c5:	00 00                	add    %al,(%eax)
	...

008000c8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	83 ec 18             	sub    $0x18,%esp
  8000ce:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000d1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8000d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8000da:	e8 f2 0e 00 00       	call   800fd1 <sys_getenvid>
  8000df:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000e4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e7:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8000ec:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f1:	85 f6                	test   %esi,%esi
  8000f3:	7e 07                	jle    8000fc <libmain+0x34>
		binaryname = argv[0];
  8000f5:	8b 03                	mov    (%ebx),%eax
  8000f7:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800100:	89 34 24             	mov    %esi,(%esp)
  800103:	e8 2c ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800108:	e8 0b 00 00 00       	call   800118 <exit>
}
  80010d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800110:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800113:	89 ec                	mov    %ebp,%esp
  800115:	5d                   	pop    %ebp
  800116:	c3                   	ret    
	...

00800118 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80011e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800125:	e8 db 0e 00 00       	call   801005 <sys_env_destroy>
}
  80012a:	c9                   	leave  
  80012b:	c3                   	ret    

0080012c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800135:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80013c:	00 00 00 
	b.cnt = 0;
  80013f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800146:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800150:	8b 45 08             	mov    0x8(%ebp),%eax
  800153:	89 44 24 08          	mov    %eax,0x8(%esp)
  800157:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800161:	c7 04 24 a7 01 80 00 	movl   $0x8001a7,(%esp)
  800168:	e8 be 01 00 00       	call   80032b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80016d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800173:	89 44 24 04          	mov    %eax,0x4(%esp)
  800177:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80017d:	89 04 24             	mov    %eax,(%esp)
  800180:	e8 2b 0a 00 00       	call   800bb0 <sys_cputs>

	return b.cnt;
}
  800185:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018b:	c9                   	leave  
  80018c:	c3                   	ret    

0080018d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800193:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800196:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019a:	8b 45 08             	mov    0x8(%ebp),%eax
  80019d:	89 04 24             	mov    %eax,(%esp)
  8001a0:	e8 87 ff ff ff       	call   80012c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 14             	sub    $0x14,%esp
  8001ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b1:	8b 03                	mov    (%ebx),%eax
  8001b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001ba:	83 c0 01             	add    $0x1,%eax
  8001bd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c4:	75 19                	jne    8001df <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001c6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001cd:	00 
  8001ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d1:	89 04 24             	mov    %eax,(%esp)
  8001d4:	e8 d7 09 00 00       	call   800bb0 <sys_cputs>
		b->idx = 0;
  8001d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001df:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001e3:	83 c4 14             	add    $0x14,%esp
  8001e6:	5b                   	pop    %ebx
  8001e7:	5d                   	pop    %ebp
  8001e8:	c3                   	ret    
  8001e9:	00 00                	add    %al,(%eax)
	...

008001ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 4c             	sub    $0x4c,%esp
  8001f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001f8:	89 d6                	mov    %edx,%esi
  8001fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800200:	8b 55 0c             	mov    0xc(%ebp),%edx
  800203:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800206:	8b 45 10             	mov    0x10(%ebp),%eax
  800209:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80020c:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80020f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800212:	b9 00 00 00 00       	mov    $0x0,%ecx
  800217:	39 d1                	cmp    %edx,%ecx
  800219:	72 07                	jb     800222 <printnum+0x36>
  80021b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80021e:	39 d0                	cmp    %edx,%eax
  800220:	77 69                	ja     80028b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800222:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800226:	83 eb 01             	sub    $0x1,%ebx
  800229:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80022d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800231:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800235:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800239:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80023c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80023f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800242:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800246:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80024d:	00 
  80024e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800251:	89 04 24             	mov    %eax,(%esp)
  800254:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800257:	89 54 24 04          	mov    %edx,0x4(%esp)
  80025b:	e8 90 0f 00 00       	call   8011f0 <__udivdi3>
  800260:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800263:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800266:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80026a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80026e:	89 04 24             	mov    %eax,(%esp)
  800271:	89 54 24 04          	mov    %edx,0x4(%esp)
  800275:	89 f2                	mov    %esi,%edx
  800277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027a:	e8 6d ff ff ff       	call   8001ec <printnum>
  80027f:	eb 11                	jmp    800292 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800281:	89 74 24 04          	mov    %esi,0x4(%esp)
  800285:	89 3c 24             	mov    %edi,(%esp)
  800288:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80028b:	83 eb 01             	sub    $0x1,%ebx
  80028e:	85 db                	test   %ebx,%ebx
  800290:	7f ef                	jg     800281 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800292:	89 74 24 04          	mov    %esi,0x4(%esp)
  800296:	8b 74 24 04          	mov    0x4(%esp),%esi
  80029a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002a8:	00 
  8002a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002ac:	89 14 24             	mov    %edx,(%esp)
  8002af:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002b6:	e8 65 10 00 00       	call   801320 <__umoddi3>
  8002bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002bf:	0f be 80 92 14 80 00 	movsbl 0x801492(%eax),%eax
  8002c6:	89 04 24             	mov    %eax,(%esp)
  8002c9:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002cc:	83 c4 4c             	add    $0x4c,%esp
  8002cf:	5b                   	pop    %ebx
  8002d0:	5e                   	pop    %esi
  8002d1:	5f                   	pop    %edi
  8002d2:	5d                   	pop    %ebp
  8002d3:	c3                   	ret    

008002d4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002d7:	83 fa 01             	cmp    $0x1,%edx
  8002da:	7e 0e                	jle    8002ea <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002dc:	8b 10                	mov    (%eax),%edx
  8002de:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002e1:	89 08                	mov    %ecx,(%eax)
  8002e3:	8b 02                	mov    (%edx),%eax
  8002e5:	8b 52 04             	mov    0x4(%edx),%edx
  8002e8:	eb 22                	jmp    80030c <getuint+0x38>
	else if (lflag)
  8002ea:	85 d2                	test   %edx,%edx
  8002ec:	74 10                	je     8002fe <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002ee:	8b 10                	mov    (%eax),%edx
  8002f0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002f3:	89 08                	mov    %ecx,(%eax)
  8002f5:	8b 02                	mov    (%edx),%eax
  8002f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fc:	eb 0e                	jmp    80030c <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002fe:	8b 10                	mov    (%eax),%edx
  800300:	8d 4a 04             	lea    0x4(%edx),%ecx
  800303:	89 08                	mov    %ecx,(%eax)
  800305:	8b 02                	mov    (%edx),%eax
  800307:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800314:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800318:	8b 10                	mov    (%eax),%edx
  80031a:	3b 50 04             	cmp    0x4(%eax),%edx
  80031d:	73 0a                	jae    800329 <sprintputch+0x1b>
		*b->buf++ = ch;
  80031f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800322:	88 0a                	mov    %cl,(%edx)
  800324:	83 c2 01             	add    $0x1,%edx
  800327:	89 10                	mov    %edx,(%eax)
}
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    

0080032b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	57                   	push   %edi
  80032f:	56                   	push   %esi
  800330:	53                   	push   %ebx
  800331:	83 ec 4c             	sub    $0x4c,%esp
  800334:	8b 7d 08             	mov    0x8(%ebp),%edi
  800337:	8b 75 0c             	mov    0xc(%ebp),%esi
  80033a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80033d:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800344:	eb 11                	jmp    800357 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800346:	85 c0                	test   %eax,%eax
  800348:	0f 84 b6 03 00 00    	je     800704 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80034e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800352:	89 04 24             	mov    %eax,(%esp)
  800355:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800357:	0f b6 03             	movzbl (%ebx),%eax
  80035a:	83 c3 01             	add    $0x1,%ebx
  80035d:	83 f8 25             	cmp    $0x25,%eax
  800360:	75 e4                	jne    800346 <vprintfmt+0x1b>
  800362:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800366:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80036d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800374:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80037b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800380:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800383:	eb 06                	jmp    80038b <vprintfmt+0x60>
  800385:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800389:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80038b:	0f b6 0b             	movzbl (%ebx),%ecx
  80038e:	0f b6 c1             	movzbl %cl,%eax
  800391:	8d 53 01             	lea    0x1(%ebx),%edx
  800394:	83 e9 23             	sub    $0x23,%ecx
  800397:	80 f9 55             	cmp    $0x55,%cl
  80039a:	0f 87 47 03 00 00    	ja     8006e7 <vprintfmt+0x3bc>
  8003a0:	0f b6 c9             	movzbl %cl,%ecx
  8003a3:	ff 24 8d e0 15 80 00 	jmp    *0x8015e0(,%ecx,4)
  8003aa:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8003ae:	eb d9                	jmp    800389 <vprintfmt+0x5e>
  8003b0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8003b7:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003bc:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003bf:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003c3:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8003c6:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003c9:	83 fb 09             	cmp    $0x9,%ebx
  8003cc:	77 30                	ja     8003fe <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003ce:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003d1:	eb e9                	jmp    8003bc <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d6:	8d 48 04             	lea    0x4(%eax),%ecx
  8003d9:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8003e1:	eb 1e                	jmp    800401 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8003e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ec:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8003f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f3:	eb 94                	jmp    800389 <vprintfmt+0x5e>
  8003f5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003fc:	eb 8b                	jmp    800389 <vprintfmt+0x5e>
  8003fe:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800401:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800405:	79 82                	jns    800389 <vprintfmt+0x5e>
  800407:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80040a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80040d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800410:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800413:	e9 71 ff ff ff       	jmp    800389 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800418:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80041c:	e9 68 ff ff ff       	jmp    800389 <vprintfmt+0x5e>
  800421:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	8d 50 04             	lea    0x4(%eax),%edx
  80042a:	89 55 14             	mov    %edx,0x14(%ebp)
  80042d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800431:	8b 00                	mov    (%eax),%eax
  800433:	89 04 24             	mov    %eax,(%esp)
  800436:	ff d7                	call   *%edi
  800438:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80043b:	e9 17 ff ff ff       	jmp    800357 <vprintfmt+0x2c>
  800440:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8d 50 04             	lea    0x4(%eax),%edx
  800449:	89 55 14             	mov    %edx,0x14(%ebp)
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	89 c2                	mov    %eax,%edx
  800450:	c1 fa 1f             	sar    $0x1f,%edx
  800453:	31 d0                	xor    %edx,%eax
  800455:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800457:	83 f8 11             	cmp    $0x11,%eax
  80045a:	7f 0b                	jg     800467 <vprintfmt+0x13c>
  80045c:	8b 14 85 40 17 80 00 	mov    0x801740(,%eax,4),%edx
  800463:	85 d2                	test   %edx,%edx
  800465:	75 20                	jne    800487 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800467:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80046b:	c7 44 24 08 a3 14 80 	movl   $0x8014a3,0x8(%esp)
  800472:	00 
  800473:	89 74 24 04          	mov    %esi,0x4(%esp)
  800477:	89 3c 24             	mov    %edi,(%esp)
  80047a:	e8 0d 03 00 00       	call   80078c <printfmt>
  80047f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800482:	e9 d0 fe ff ff       	jmp    800357 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800487:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048b:	c7 44 24 08 ac 14 80 	movl   $0x8014ac,0x8(%esp)
  800492:	00 
  800493:	89 74 24 04          	mov    %esi,0x4(%esp)
  800497:	89 3c 24             	mov    %edi,(%esp)
  80049a:	e8 ed 02 00 00       	call   80078c <printfmt>
  80049f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8004a2:	e9 b0 fe ff ff       	jmp    800357 <vprintfmt+0x2c>
  8004a7:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8004aa:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b6:	8d 50 04             	lea    0x4(%eax),%edx
  8004b9:	89 55 14             	mov    %edx,0x14(%ebp)
  8004bc:	8b 18                	mov    (%eax),%ebx
  8004be:	85 db                	test   %ebx,%ebx
  8004c0:	b8 af 14 80 00       	mov    $0x8014af,%eax
  8004c5:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8004c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004cc:	7e 76                	jle    800544 <vprintfmt+0x219>
  8004ce:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8004d2:	74 7a                	je     80054e <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004d8:	89 1c 24             	mov    %ebx,(%esp)
  8004db:	e8 f8 02 00 00       	call   8007d8 <strnlen>
  8004e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e3:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8004e5:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8004e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004ec:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004ef:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f1:	eb 0f                	jmp    800502 <vprintfmt+0x1d7>
					putch(padc, putdat);
  8004f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004fa:	89 04 24             	mov    %eax,(%esp)
  8004fd:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ff:	83 eb 01             	sub    $0x1,%ebx
  800502:	85 db                	test   %ebx,%ebx
  800504:	7f ed                	jg     8004f3 <vprintfmt+0x1c8>
  800506:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800509:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80050c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80050f:	89 f7                	mov    %esi,%edi
  800511:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800514:	eb 40                	jmp    800556 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800516:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80051a:	74 18                	je     800534 <vprintfmt+0x209>
  80051c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80051f:	83 fa 5e             	cmp    $0x5e,%edx
  800522:	76 10                	jbe    800534 <vprintfmt+0x209>
					putch('?', putdat);
  800524:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800528:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80052f:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800532:	eb 0a                	jmp    80053e <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800534:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800542:	eb 12                	jmp    800556 <vprintfmt+0x22b>
  800544:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800547:	89 f7                	mov    %esi,%edi
  800549:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80054c:	eb 08                	jmp    800556 <vprintfmt+0x22b>
  80054e:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800551:	89 f7                	mov    %esi,%edi
  800553:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800556:	0f be 03             	movsbl (%ebx),%eax
  800559:	83 c3 01             	add    $0x1,%ebx
  80055c:	85 c0                	test   %eax,%eax
  80055e:	74 25                	je     800585 <vprintfmt+0x25a>
  800560:	85 f6                	test   %esi,%esi
  800562:	78 b2                	js     800516 <vprintfmt+0x1eb>
  800564:	83 ee 01             	sub    $0x1,%esi
  800567:	79 ad                	jns    800516 <vprintfmt+0x1eb>
  800569:	89 fe                	mov    %edi,%esi
  80056b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80056e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800571:	eb 1a                	jmp    80058d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800573:	89 74 24 04          	mov    %esi,0x4(%esp)
  800577:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80057e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800580:	83 eb 01             	sub    $0x1,%ebx
  800583:	eb 08                	jmp    80058d <vprintfmt+0x262>
  800585:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800588:	89 fe                	mov    %edi,%esi
  80058a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80058d:	85 db                	test   %ebx,%ebx
  80058f:	7f e2                	jg     800573 <vprintfmt+0x248>
  800591:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800594:	e9 be fd ff ff       	jmp    800357 <vprintfmt+0x2c>
  800599:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80059c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80059f:	83 f9 01             	cmp    $0x1,%ecx
  8005a2:	7e 16                	jle    8005ba <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 50 08             	lea    0x8(%eax),%edx
  8005aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ad:	8b 10                	mov    (%eax),%edx
  8005af:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b2:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8005b5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b8:	eb 32                	jmp    8005ec <vprintfmt+0x2c1>
	else if (lflag)
  8005ba:	85 c9                	test   %ecx,%ecx
  8005bc:	74 18                	je     8005d6 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8d 50 04             	lea    0x4(%eax),%edx
  8005c4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cc:	89 c1                	mov    %eax,%ecx
  8005ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d4:	eb 16                	jmp    8005ec <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 50 04             	lea    0x4(%eax),%edx
  8005dc:	89 55 14             	mov    %edx,0x14(%ebp)
  8005df:	8b 00                	mov    (%eax),%eax
  8005e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e4:	89 c2                	mov    %eax,%edx
  8005e6:	c1 fa 1f             	sar    $0x1f,%edx
  8005e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005ec:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005ef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005f2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005f7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005fb:	0f 89 a7 00 00 00    	jns    8006a8 <vprintfmt+0x37d>
				putch('-', putdat);
  800601:	89 74 24 04          	mov    %esi,0x4(%esp)
  800605:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80060c:	ff d7                	call   *%edi
				num = -(long long) num;
  80060e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800611:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800614:	f7 d9                	neg    %ecx
  800616:	83 d3 00             	adc    $0x0,%ebx
  800619:	f7 db                	neg    %ebx
  80061b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800620:	e9 83 00 00 00       	jmp    8006a8 <vprintfmt+0x37d>
  800625:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800628:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80062b:	89 ca                	mov    %ecx,%edx
  80062d:	8d 45 14             	lea    0x14(%ebp),%eax
  800630:	e8 9f fc ff ff       	call   8002d4 <getuint>
  800635:	89 c1                	mov    %eax,%ecx
  800637:	89 d3                	mov    %edx,%ebx
  800639:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80063e:	eb 68                	jmp    8006a8 <vprintfmt+0x37d>
  800640:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800643:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800646:	89 ca                	mov    %ecx,%edx
  800648:	8d 45 14             	lea    0x14(%ebp),%eax
  80064b:	e8 84 fc ff ff       	call   8002d4 <getuint>
  800650:	89 c1                	mov    %eax,%ecx
  800652:	89 d3                	mov    %edx,%ebx
  800654:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800659:	eb 4d                	jmp    8006a8 <vprintfmt+0x37d>
  80065b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80065e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800662:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800669:	ff d7                	call   *%edi
			putch('x', putdat);
  80066b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80066f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800676:	ff d7                	call   *%edi
			num = (unsigned long long)
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8d 50 04             	lea    0x4(%eax),%edx
  80067e:	89 55 14             	mov    %edx,0x14(%ebp)
  800681:	8b 08                	mov    (%eax),%ecx
  800683:	bb 00 00 00 00       	mov    $0x0,%ebx
  800688:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80068d:	eb 19                	jmp    8006a8 <vprintfmt+0x37d>
  80068f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800692:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800695:	89 ca                	mov    %ecx,%edx
  800697:	8d 45 14             	lea    0x14(%ebp),%eax
  80069a:	e8 35 fc ff ff       	call   8002d4 <getuint>
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	89 d3                	mov    %edx,%ebx
  8006a3:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006a8:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8006ac:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006bb:	89 0c 24             	mov    %ecx,(%esp)
  8006be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006c2:	89 f2                	mov    %esi,%edx
  8006c4:	89 f8                	mov    %edi,%eax
  8006c6:	e8 21 fb ff ff       	call   8001ec <printnum>
  8006cb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006ce:	e9 84 fc ff ff       	jmp    800357 <vprintfmt+0x2c>
  8006d3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006da:	89 04 24             	mov    %eax,(%esp)
  8006dd:	ff d7                	call   *%edi
  8006df:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006e2:	e9 70 fc ff ff       	jmp    800357 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006eb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006f2:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8006f7:	80 38 25             	cmpb   $0x25,(%eax)
  8006fa:	0f 84 57 fc ff ff    	je     800357 <vprintfmt+0x2c>
  800700:	89 c3                	mov    %eax,%ebx
  800702:	eb f0                	jmp    8006f4 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800704:	83 c4 4c             	add    $0x4c,%esp
  800707:	5b                   	pop    %ebx
  800708:	5e                   	pop    %esi
  800709:	5f                   	pop    %edi
  80070a:	5d                   	pop    %ebp
  80070b:	c3                   	ret    

0080070c <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	83 ec 28             	sub    $0x28,%esp
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800718:	85 c0                	test   %eax,%eax
  80071a:	74 04                	je     800720 <vsnprintf+0x14>
  80071c:	85 d2                	test   %edx,%edx
  80071e:	7f 07                	jg     800727 <vsnprintf+0x1b>
  800720:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800725:	eb 3b                	jmp    800762 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800727:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80072a:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  80072e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	89 44 24 08          	mov    %eax,0x8(%esp)
  800746:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800749:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074d:	c7 04 24 0e 03 80 00 	movl   $0x80030e,(%esp)
  800754:	e8 d2 fb ff ff       	call   80032b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80075c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80075f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800762:	c9                   	leave  
  800763:	c3                   	ret    

00800764 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80076a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  80076d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800771:	8b 45 10             	mov    0x10(%ebp),%eax
  800774:	89 44 24 08          	mov    %eax,0x8(%esp)
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	89 04 24             	mov    %eax,(%esp)
  800785:	e8 82 ff ff ff       	call   80070c <vsnprintf>
	va_end(ap);

	return rc;
}
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    

0080078c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800792:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800795:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800799:	8b 45 10             	mov    0x10(%ebp),%eax
  80079c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	89 04 24             	mov    %eax,(%esp)
  8007ad:	e8 79 fb ff ff       	call   80032b <vprintfmt>
	va_end(ap);
}
  8007b2:	c9                   	leave  
  8007b3:	c3                   	ret    
	...

008007c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8007cb:	eb 03                	jmp    8007d0 <strlen+0x10>
		n++;
  8007cd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007d4:	75 f7                	jne    8007cd <strlen+0xd>
		n++;
	return n;
}
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	53                   	push   %ebx
  8007dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e7:	eb 03                	jmp    8007ec <strnlen+0x14>
		n++;
  8007e9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ec:	39 c1                	cmp    %eax,%ecx
  8007ee:	74 06                	je     8007f6 <strnlen+0x1e>
  8007f0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8007f4:	75 f3                	jne    8007e9 <strnlen+0x11>
		n++;
	return n;
}
  8007f6:	5b                   	pop    %ebx
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	53                   	push   %ebx
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800803:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800808:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80080c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80080f:	83 c2 01             	add    $0x1,%edx
  800812:	84 c9                	test   %cl,%cl
  800814:	75 f2                	jne    800808 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800816:	5b                   	pop    %ebx
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	53                   	push   %ebx
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800823:	89 1c 24             	mov    %ebx,(%esp)
  800826:	e8 95 ff ff ff       	call   8007c0 <strlen>
	strcpy(dst + len, src);
  80082b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800832:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800835:	89 04 24             	mov    %eax,(%esp)
  800838:	e8 bc ff ff ff       	call   8007f9 <strcpy>
	return dst;
}
  80083d:	89 d8                	mov    %ebx,%eax
  80083f:	83 c4 08             	add    $0x8,%esp
  800842:	5b                   	pop    %ebx
  800843:	5d                   	pop    %ebp
  800844:	c3                   	ret    

00800845 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	56                   	push   %esi
  800849:	53                   	push   %ebx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800850:	8b 75 10             	mov    0x10(%ebp),%esi
  800853:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800858:	eb 0f                	jmp    800869 <strncpy+0x24>
		*dst++ = *src;
  80085a:	0f b6 19             	movzbl (%ecx),%ebx
  80085d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800860:	80 39 01             	cmpb   $0x1,(%ecx)
  800863:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800866:	83 c2 01             	add    $0x1,%edx
  800869:	39 f2                	cmp    %esi,%edx
  80086b:	72 ed                	jb     80085a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80086d:	5b                   	pop    %ebx
  80086e:	5e                   	pop    %esi
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    

00800871 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	56                   	push   %esi
  800875:	53                   	push   %ebx
  800876:	8b 75 08             	mov    0x8(%ebp),%esi
  800879:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80087f:	89 f0                	mov    %esi,%eax
  800881:	85 d2                	test   %edx,%edx
  800883:	75 0a                	jne    80088f <strlcpy+0x1e>
  800885:	eb 17                	jmp    80089e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800887:	88 18                	mov    %bl,(%eax)
  800889:	83 c0 01             	add    $0x1,%eax
  80088c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80088f:	83 ea 01             	sub    $0x1,%edx
  800892:	74 07                	je     80089b <strlcpy+0x2a>
  800894:	0f b6 19             	movzbl (%ecx),%ebx
  800897:	84 db                	test   %bl,%bl
  800899:	75 ec                	jne    800887 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80089b:	c6 00 00             	movb   $0x0,(%eax)
  80089e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8008a0:	5b                   	pop    %ebx
  8008a1:	5e                   	pop    %esi
  8008a2:	5d                   	pop    %ebp
  8008a3:	c3                   	ret    

008008a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ad:	eb 06                	jmp    8008b5 <strcmp+0x11>
		p++, q++;
  8008af:	83 c1 01             	add    $0x1,%ecx
  8008b2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008b5:	0f b6 01             	movzbl (%ecx),%eax
  8008b8:	84 c0                	test   %al,%al
  8008ba:	74 04                	je     8008c0 <strcmp+0x1c>
  8008bc:	3a 02                	cmp    (%edx),%al
  8008be:	74 ef                	je     8008af <strcmp+0xb>
  8008c0:	0f b6 c0             	movzbl %al,%eax
  8008c3:	0f b6 12             	movzbl (%edx),%edx
  8008c6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	53                   	push   %ebx
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8008d7:	eb 09                	jmp    8008e2 <strncmp+0x18>
		n--, p++, q++;
  8008d9:	83 ea 01             	sub    $0x1,%edx
  8008dc:	83 c0 01             	add    $0x1,%eax
  8008df:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008e2:	85 d2                	test   %edx,%edx
  8008e4:	75 07                	jne    8008ed <strncmp+0x23>
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	eb 13                	jmp    800900 <strncmp+0x36>
  8008ed:	0f b6 18             	movzbl (%eax),%ebx
  8008f0:	84 db                	test   %bl,%bl
  8008f2:	74 04                	je     8008f8 <strncmp+0x2e>
  8008f4:	3a 19                	cmp    (%ecx),%bl
  8008f6:	74 e1                	je     8008d9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f8:	0f b6 00             	movzbl (%eax),%eax
  8008fb:	0f b6 11             	movzbl (%ecx),%edx
  8008fe:	29 d0                	sub    %edx,%eax
}
  800900:	5b                   	pop    %ebx
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090d:	eb 07                	jmp    800916 <strchr+0x13>
		if (*s == c)
  80090f:	38 ca                	cmp    %cl,%dl
  800911:	74 0f                	je     800922 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800913:	83 c0 01             	add    $0x1,%eax
  800916:	0f b6 10             	movzbl (%eax),%edx
  800919:	84 d2                	test   %dl,%dl
  80091b:	75 f2                	jne    80090f <strchr+0xc>
  80091d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092e:	eb 07                	jmp    800937 <strfind+0x13>
		if (*s == c)
  800930:	38 ca                	cmp    %cl,%dl
  800932:	74 0a                	je     80093e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800934:	83 c0 01             	add    $0x1,%eax
  800937:	0f b6 10             	movzbl (%eax),%edx
  80093a:	84 d2                	test   %dl,%dl
  80093c:	75 f2                	jne    800930 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	83 ec 0c             	sub    $0xc,%esp
  800946:	89 1c 24             	mov    %ebx,(%esp)
  800949:	89 74 24 04          	mov    %esi,0x4(%esp)
  80094d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800951:	8b 7d 08             	mov    0x8(%ebp),%edi
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80095a:	85 c9                	test   %ecx,%ecx
  80095c:	74 30                	je     80098e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80095e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800964:	75 25                	jne    80098b <memset+0x4b>
  800966:	f6 c1 03             	test   $0x3,%cl
  800969:	75 20                	jne    80098b <memset+0x4b>
		c &= 0xFF;
  80096b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80096e:	89 d3                	mov    %edx,%ebx
  800970:	c1 e3 08             	shl    $0x8,%ebx
  800973:	89 d6                	mov    %edx,%esi
  800975:	c1 e6 18             	shl    $0x18,%esi
  800978:	89 d0                	mov    %edx,%eax
  80097a:	c1 e0 10             	shl    $0x10,%eax
  80097d:	09 f0                	or     %esi,%eax
  80097f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800981:	09 d8                	or     %ebx,%eax
  800983:	c1 e9 02             	shr    $0x2,%ecx
  800986:	fc                   	cld    
  800987:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800989:	eb 03                	jmp    80098e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80098b:	fc                   	cld    
  80098c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80098e:	89 f8                	mov    %edi,%eax
  800990:	8b 1c 24             	mov    (%esp),%ebx
  800993:	8b 74 24 04          	mov    0x4(%esp),%esi
  800997:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80099b:	89 ec                	mov    %ebp,%esp
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	89 34 24             	mov    %esi,(%esp)
  8009a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  8009b2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009b5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009b7:	39 c6                	cmp    %eax,%esi
  8009b9:	73 35                	jae    8009f0 <memmove+0x51>
  8009bb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009be:	39 d0                	cmp    %edx,%eax
  8009c0:	73 2e                	jae    8009f0 <memmove+0x51>
		s += n;
		d += n;
  8009c2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c4:	f6 c2 03             	test   $0x3,%dl
  8009c7:	75 1b                	jne    8009e4 <memmove+0x45>
  8009c9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009cf:	75 13                	jne    8009e4 <memmove+0x45>
  8009d1:	f6 c1 03             	test   $0x3,%cl
  8009d4:	75 0e                	jne    8009e4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8009d6:	83 ef 04             	sub    $0x4,%edi
  8009d9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
  8009df:	fd                   	std    
  8009e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e2:	eb 09                	jmp    8009ed <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009e4:	83 ef 01             	sub    $0x1,%edi
  8009e7:	8d 72 ff             	lea    -0x1(%edx),%esi
  8009ea:	fd                   	std    
  8009eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ed:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ee:	eb 20                	jmp    800a10 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f6:	75 15                	jne    800a0d <memmove+0x6e>
  8009f8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009fe:	75 0d                	jne    800a0d <memmove+0x6e>
  800a00:	f6 c1 03             	test   $0x3,%cl
  800a03:	75 08                	jne    800a0d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a05:	c1 e9 02             	shr    $0x2,%ecx
  800a08:	fc                   	cld    
  800a09:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0b:	eb 03                	jmp    800a10 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a0d:	fc                   	cld    
  800a0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a10:	8b 34 24             	mov    (%esp),%esi
  800a13:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a17:	89 ec                	mov    %ebp,%esp
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a21:	8b 45 10             	mov    0x10(%ebp),%eax
  800a24:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	89 04 24             	mov    %eax,(%esp)
  800a35:	e8 65 ff ff ff       	call   80099f <memmove>
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	57                   	push   %edi
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a45:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a4b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a50:	eb 1c                	jmp    800a6e <memcmp+0x32>
		if (*s1 != *s2)
  800a52:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800a56:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800a5a:	83 c2 01             	add    $0x1,%edx
  800a5d:	83 e9 01             	sub    $0x1,%ecx
  800a60:	38 d8                	cmp    %bl,%al
  800a62:	74 0a                	je     800a6e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800a64:	0f b6 c0             	movzbl %al,%eax
  800a67:	0f b6 db             	movzbl %bl,%ebx
  800a6a:	29 d8                	sub    %ebx,%eax
  800a6c:	eb 09                	jmp    800a77 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6e:	85 c9                	test   %ecx,%ecx
  800a70:	75 e0                	jne    800a52 <memcmp+0x16>
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800a77:	5b                   	pop    %ebx
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a85:	89 c2                	mov    %eax,%edx
  800a87:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a8a:	eb 07                	jmp    800a93 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a8c:	38 08                	cmp    %cl,(%eax)
  800a8e:	74 07                	je     800a97 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	39 d0                	cmp    %edx,%eax
  800a95:	72 f5                	jb     800a8c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	57                   	push   %edi
  800a9d:	56                   	push   %esi
  800a9e:	53                   	push   %ebx
  800a9f:	83 ec 04             	sub    $0x4,%esp
  800aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa8:	eb 03                	jmp    800aad <strtol+0x14>
		s++;
  800aaa:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aad:	0f b6 02             	movzbl (%edx),%eax
  800ab0:	3c 20                	cmp    $0x20,%al
  800ab2:	74 f6                	je     800aaa <strtol+0x11>
  800ab4:	3c 09                	cmp    $0x9,%al
  800ab6:	74 f2                	je     800aaa <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ab8:	3c 2b                	cmp    $0x2b,%al
  800aba:	75 0c                	jne    800ac8 <strtol+0x2f>
		s++;
  800abc:	8d 52 01             	lea    0x1(%edx),%edx
  800abf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ac6:	eb 15                	jmp    800add <strtol+0x44>
	else if (*s == '-')
  800ac8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800acf:	3c 2d                	cmp    $0x2d,%al
  800ad1:	75 0a                	jne    800add <strtol+0x44>
		s++, neg = 1;
  800ad3:	8d 52 01             	lea    0x1(%edx),%edx
  800ad6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800add:	85 db                	test   %ebx,%ebx
  800adf:	0f 94 c0             	sete   %al
  800ae2:	74 05                	je     800ae9 <strtol+0x50>
  800ae4:	83 fb 10             	cmp    $0x10,%ebx
  800ae7:	75 15                	jne    800afe <strtol+0x65>
  800ae9:	80 3a 30             	cmpb   $0x30,(%edx)
  800aec:	75 10                	jne    800afe <strtol+0x65>
  800aee:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800af2:	75 0a                	jne    800afe <strtol+0x65>
		s += 2, base = 16;
  800af4:	83 c2 02             	add    $0x2,%edx
  800af7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afc:	eb 13                	jmp    800b11 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800afe:	84 c0                	test   %al,%al
  800b00:	74 0f                	je     800b11 <strtol+0x78>
  800b02:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b07:	80 3a 30             	cmpb   $0x30,(%edx)
  800b0a:	75 05                	jne    800b11 <strtol+0x78>
		s++, base = 8;
  800b0c:	83 c2 01             	add    $0x1,%edx
  800b0f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
  800b16:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b18:	0f b6 0a             	movzbl (%edx),%ecx
  800b1b:	89 cf                	mov    %ecx,%edi
  800b1d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b20:	80 fb 09             	cmp    $0x9,%bl
  800b23:	77 08                	ja     800b2d <strtol+0x94>
			dig = *s - '0';
  800b25:	0f be c9             	movsbl %cl,%ecx
  800b28:	83 e9 30             	sub    $0x30,%ecx
  800b2b:	eb 1e                	jmp    800b4b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800b2d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b30:	80 fb 19             	cmp    $0x19,%bl
  800b33:	77 08                	ja     800b3d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800b35:	0f be c9             	movsbl %cl,%ecx
  800b38:	83 e9 57             	sub    $0x57,%ecx
  800b3b:	eb 0e                	jmp    800b4b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800b3d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b40:	80 fb 19             	cmp    $0x19,%bl
  800b43:	77 15                	ja     800b5a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b45:	0f be c9             	movsbl %cl,%ecx
  800b48:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b4b:	39 f1                	cmp    %esi,%ecx
  800b4d:	7d 0b                	jge    800b5a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b4f:	83 c2 01             	add    $0x1,%edx
  800b52:	0f af c6             	imul   %esi,%eax
  800b55:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800b58:	eb be                	jmp    800b18 <strtol+0x7f>
  800b5a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800b5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b60:	74 05                	je     800b67 <strtol+0xce>
		*endptr = (char *) s;
  800b62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b65:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b67:	89 ca                	mov    %ecx,%edx
  800b69:	f7 da                	neg    %edx
  800b6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b6f:	0f 45 c2             	cmovne %edx,%eax
}
  800b72:	83 c4 04             	add    $0x4,%esp
  800b75:	5b                   	pop    %ebx
  800b76:	5e                   	pop    %esi
  800b77:	5f                   	pop    %edi
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    
	...

00800b7c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 0c             	sub    $0xc,%esp
  800b82:	89 1c 24             	mov    %ebx,(%esp)
  800b85:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b89:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b92:	b8 01 00 00 00       	mov    $0x1,%eax
  800b97:	89 d1                	mov    %edx,%ecx
  800b99:	89 d3                	mov    %edx,%ebx
  800b9b:	89 d7                	mov    %edx,%edi
  800b9d:	89 d6                	mov    %edx,%esi
  800b9f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ba1:	8b 1c 24             	mov    (%esp),%ebx
  800ba4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ba8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bac:	89 ec                	mov    %ebp,%esp
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 0c             	sub    $0xc,%esp
  800bb6:	89 1c 24             	mov    %ebx,(%esp)
  800bb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bbd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	89 c3                	mov    %eax,%ebx
  800bce:	89 c7                	mov    %eax,%edi
  800bd0:	89 c6                	mov    %eax,%esi
  800bd2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bd4:	8b 1c 24             	mov    (%esp),%ebx
  800bd7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bdb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bdf:	89 ec                	mov    %ebp,%esp
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 0c             	sub    $0xc,%esp
  800be9:	89 1c 24             	mov    %ebx,(%esp)
  800bec:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bf0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bf4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf9:	b8 10 00 00 00       	mov    $0x10,%eax
  800bfe:	89 d1                	mov    %edx,%ecx
  800c00:	89 d3                	mov    %edx,%ebx
  800c02:	89 d7                	mov    %edx,%edi
  800c04:	89 d6                	mov    %edx,%esi
  800c06:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800c08:	8b 1c 24             	mov    (%esp),%ebx
  800c0b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c0f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c13:	89 ec                	mov    %ebp,%esp
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 38             	sub    $0x38,%esp
  800c1d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c20:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c23:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800c30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c33:	8b 55 08             	mov    0x8(%ebp),%edx
  800c36:	89 df                	mov    %ebx,%edi
  800c38:	89 de                	mov    %ebx,%esi
  800c3a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	7e 28                	jle    800c68 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c40:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c44:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800c4b:	00 
  800c4c:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  800c53:	00 
  800c54:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c5b:	00 
  800c5c:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  800c63:	e8 28 05 00 00       	call   801190 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800c68:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c6b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c6e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c71:	89 ec                	mov    %ebp,%esp
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 38             	sub    $0x38,%esp
  800c7b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c7e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c81:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c89:	b8 0e 00 00 00       	mov    $0xe,%eax
  800c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	89 df                	mov    %ebx,%edi
  800c96:	89 de                	mov    %ebx,%esi
  800c98:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c9a:	85 c0                	test   %eax,%eax
  800c9c:	7e 28                	jle    800cc6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ca2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800ca9:	00 
  800caa:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  800cb1:	00 
  800cb2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb9:	00 
  800cba:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  800cc1:	e8 ca 04 00 00       	call   801190 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800cc6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cc9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ccc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ccf:	89 ec                	mov    %ebp,%esp
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 38             	sub    $0x38,%esp
  800cd9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cdc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cdf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	89 cb                	mov    %ecx,%ebx
  800cf1:	89 cf                	mov    %ecx,%edi
  800cf3:	89 ce                	mov    %ecx,%esi
  800cf5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7e 28                	jle    800d23 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800d06:	00 
  800d07:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  800d0e:	00 
  800d0f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d16:	00 
  800d17:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  800d1e:	e8 6d 04 00 00       	call   801190 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d23:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d26:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d29:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d2c:	89 ec                	mov    %ebp,%esp
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 0c             	sub    $0xc,%esp
  800d36:	89 1c 24             	mov    %ebx,(%esp)
  800d39:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d3d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d41:	be 00 00 00 00       	mov    $0x0,%esi
  800d46:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d4b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d59:	8b 1c 24             	mov    (%esp),%ebx
  800d5c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d60:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d64:	89 ec                	mov    %ebp,%esp
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	83 ec 38             	sub    $0x38,%esp
  800d6e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d71:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d74:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
  800d87:	89 df                	mov    %ebx,%edi
  800d89:	89 de                	mov    %ebx,%esi
  800d8b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	7e 28                	jle    800db9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d91:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d95:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d9c:	00 
  800d9d:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  800da4:	00 
  800da5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dac:	00 
  800dad:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  800db4:	e8 d7 03 00 00       	call   801190 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800db9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dbc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dbf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dc2:	89 ec                	mov    %ebp,%esp
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 38             	sub    $0x38,%esp
  800dcc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dcf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dd2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dda:	b8 09 00 00 00       	mov    $0x9,%eax
  800ddf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	89 df                	mov    %ebx,%edi
  800de7:	89 de                	mov    %ebx,%esi
  800de9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800deb:	85 c0                	test   %eax,%eax
  800ded:	7e 28                	jle    800e17 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800def:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dfa:	00 
  800dfb:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  800e02:	00 
  800e03:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0a:	00 
  800e0b:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  800e12:	e8 79 03 00 00       	call   801190 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e17:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e1a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e1d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e20:	89 ec                	mov    %ebp,%esp
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 38             	sub    $0x38,%esp
  800e2a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e2d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e30:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e38:	b8 08 00 00 00       	mov    $0x8,%eax
  800e3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	89 df                	mov    %ebx,%edi
  800e45:	89 de                	mov    %ebx,%esi
  800e47:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	7e 28                	jle    800e75 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e51:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e58:	00 
  800e59:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  800e60:	00 
  800e61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e68:	00 
  800e69:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  800e70:	e8 1b 03 00 00       	call   801190 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e75:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e78:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e7b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e7e:	89 ec                	mov    %ebp,%esp
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 38             	sub    $0x38,%esp
  800e88:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e8b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e8e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e96:	b8 06 00 00 00       	mov    $0x6,%eax
  800e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea1:	89 df                	mov    %ebx,%edi
  800ea3:	89 de                	mov    %ebx,%esi
  800ea5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	7e 28                	jle    800ed3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eab:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eaf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800eb6:	00 
  800eb7:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  800ebe:	00 
  800ebf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec6:	00 
  800ec7:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  800ece:	e8 bd 02 00 00       	call   801190 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ed3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ed6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ed9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800edc:	89 ec                	mov    %ebp,%esp
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 38             	sub    $0x38,%esp
  800ee6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eec:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eef:	b8 05 00 00 00       	mov    $0x5,%eax
  800ef4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ef7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f00:	8b 55 08             	mov    0x8(%ebp),%edx
  800f03:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	7e 28                	jle    800f31 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f09:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f14:	00 
  800f15:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  800f1c:	00 
  800f1d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f24:	00 
  800f25:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  800f2c:	e8 5f 02 00 00       	call   801190 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f31:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f34:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f37:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f3a:	89 ec                	mov    %ebp,%esp
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 38             	sub    $0x38,%esp
  800f44:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f47:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f4a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4d:	be 00 00 00 00       	mov    $0x0,%esi
  800f52:	b8 04 00 00 00       	mov    $0x4,%eax
  800f57:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f60:	89 f7                	mov    %esi,%edi
  800f62:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f64:	85 c0                	test   %eax,%eax
  800f66:	7e 28                	jle    800f90 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f68:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f6c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f73:	00 
  800f74:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  800f7b:	00 
  800f7c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f83:	00 
  800f84:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  800f8b:	e8 00 02 00 00       	call   801190 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f90:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f93:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f96:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f99:	89 ec                	mov    %ebp,%esp
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	83 ec 0c             	sub    $0xc,%esp
  800fa3:	89 1c 24             	mov    %ebx,(%esp)
  800fa6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800faa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fb8:	89 d1                	mov    %edx,%ecx
  800fba:	89 d3                	mov    %edx,%ebx
  800fbc:	89 d7                	mov    %edx,%edi
  800fbe:	89 d6                	mov    %edx,%esi
  800fc0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fc2:	8b 1c 24             	mov    (%esp),%ebx
  800fc5:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fc9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fcd:	89 ec                	mov    %ebp,%esp
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	89 1c 24             	mov    %ebx,(%esp)
  800fda:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fde:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe7:	b8 02 00 00 00       	mov    $0x2,%eax
  800fec:	89 d1                	mov    %edx,%ecx
  800fee:	89 d3                	mov    %edx,%ebx
  800ff0:	89 d7                	mov    %edx,%edi
  800ff2:	89 d6                	mov    %edx,%esi
  800ff4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ff6:	8b 1c 24             	mov    (%esp),%ebx
  800ff9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ffd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801001:	89 ec                	mov    %ebp,%esp
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    

00801005 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 38             	sub    $0x38,%esp
  80100b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80100e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801011:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801014:	b9 00 00 00 00       	mov    $0x0,%ecx
  801019:	b8 03 00 00 00       	mov    $0x3,%eax
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	89 cb                	mov    %ecx,%ebx
  801023:	89 cf                	mov    %ecx,%edi
  801025:	89 ce                	mov    %ecx,%esi
  801027:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801029:	85 c0                	test   %eax,%eax
  80102b:	7e 28                	jle    801055 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80102d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801031:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801038:	00 
  801039:	c7 44 24 08 a7 17 80 	movl   $0x8017a7,0x8(%esp)
  801040:	00 
  801041:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801048:	00 
  801049:	c7 04 24 c4 17 80 00 	movl   $0x8017c4,(%esp)
  801050:	e8 3b 01 00 00       	call   801190 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801055:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801058:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80105b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80105e:	89 ec                	mov    %ebp,%esp
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    
	...

00801064 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106a:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80106f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801072:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  801078:	8b 12                	mov    (%edx),%edx
  80107a:	39 ca                	cmp    %ecx,%edx
  80107c:	75 0c                	jne    80108a <ipc_find_env+0x26>
			return envs[i].env_id;
  80107e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801081:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  801086:	8b 00                	mov    (%eax),%eax
  801088:	eb 0e                	jmp    801098 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80108a:	83 c0 01             	add    $0x1,%eax
  80108d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801092:	75 db                	jne    80106f <ipc_find_env+0xb>
  801094:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	57                   	push   %edi
  80109e:	56                   	push   %esi
  80109f:	53                   	push   %ebx
  8010a0:	83 ec 2c             	sub    $0x2c,%esp
  8010a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8010a6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8010a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  8010ac:	85 db                	test   %ebx,%ebx
  8010ae:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8010b3:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  8010b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010bd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8010c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010c5:	89 34 24             	mov    %esi,(%esp)
  8010c8:	e8 63 fc ff ff       	call   800d30 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  8010cd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8010d0:	74 e4                	je     8010b6 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	74 28                	je     8010fe <ipc_send+0x64>
  8010d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010da:	c7 44 24 0c ef 17 80 	movl   $0x8017ef,0xc(%esp)
  8010e1:	00 
  8010e2:	c7 44 24 08 d2 17 80 	movl   $0x8017d2,0x8(%esp)
  8010e9:	00 
  8010ea:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8010f1:	00 
  8010f2:	c7 04 24 e5 17 80 00 	movl   $0x8017e5,(%esp)
  8010f9:	e8 92 00 00 00       	call   801190 <_panic>
	//if(!ret) sys_yield();
}
  8010fe:	83 c4 2c             	add    $0x2c,%esp
  801101:	5b                   	pop    %ebx
  801102:	5e                   	pop    %esi
  801103:	5f                   	pop    %edi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    

00801106 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 28             	sub    $0x28,%esp
  80110c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80110f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801112:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801115:	8b 75 08             	mov    0x8(%ebp),%esi
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  80111e:	85 c0                	test   %eax,%eax
  801120:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801125:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801128:	89 04 24             	mov    %eax,(%esp)
  80112b:	e8 a3 fb ff ff       	call   800cd3 <sys_ipc_recv>
  801130:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  801132:	e8 9a fe ff ff       	call   800fd1 <sys_getenvid>
  801137:	25 ff 03 00 00       	and    $0x3ff,%eax
  80113c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80113f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801144:	a3 04 20 80 00       	mov    %eax,0x802004
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  801149:	85 f6                	test   %esi,%esi
  80114b:	74 0e                	je     80115b <ipc_recv+0x55>
  80114d:	ba 00 00 00 00       	mov    $0x0,%edx
  801152:	85 db                	test   %ebx,%ebx
  801154:	75 03                	jne    801159 <ipc_recv+0x53>
  801156:	8b 50 74             	mov    0x74(%eax),%edx
  801159:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  80115b:	85 ff                	test   %edi,%edi
  80115d:	74 13                	je     801172 <ipc_recv+0x6c>
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
  801164:	85 db                	test   %ebx,%ebx
  801166:	75 08                	jne    801170 <ipc_recv+0x6a>
  801168:	a1 04 20 80 00       	mov    0x802004,%eax
  80116d:	8b 40 78             	mov    0x78(%eax),%eax
  801170:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  801172:	85 db                	test   %ebx,%ebx
  801174:	75 08                	jne    80117e <ipc_recv+0x78>
  801176:	a1 04 20 80 00       	mov    0x802004,%eax
  80117b:	8b 58 70             	mov    0x70(%eax),%ebx
}
  80117e:	89 d8                	mov    %ebx,%eax
  801180:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801183:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801186:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801189:	89 ec                	mov    %ebp,%esp
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    
  80118d:	00 00                	add    %al,(%eax)
	...

00801190 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	56                   	push   %esi
  801194:	53                   	push   %ebx
  801195:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  801198:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80119b:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8011a1:	e8 2b fe ff ff       	call   800fd1 <sys_getenvid>
  8011a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011bc:	c7 04 24 f8 17 80 00 	movl   $0x8017f8,(%esp)
  8011c3:	e8 c5 ef ff ff       	call   80018d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8011c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	89 04 24             	mov    %eax,(%esp)
  8011d2:	e8 55 ef ff ff       	call   80012c <vcprintf>
	cprintf("\n");
  8011d7:	c7 04 24 e3 17 80 00 	movl   $0x8017e3,(%esp)
  8011de:	e8 aa ef ff ff       	call   80018d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8011e3:	cc                   	int3   
  8011e4:	eb fd                	jmp    8011e3 <_panic+0x53>
	...

008011f0 <__udivdi3>:
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	57                   	push   %edi
  8011f4:	56                   	push   %esi
  8011f5:	83 ec 10             	sub    $0x10,%esp
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fe:	8b 75 10             	mov    0x10(%ebp),%esi
  801201:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801204:	85 c0                	test   %eax,%eax
  801206:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801209:	75 35                	jne    801240 <__udivdi3+0x50>
  80120b:	39 fe                	cmp    %edi,%esi
  80120d:	77 61                	ja     801270 <__udivdi3+0x80>
  80120f:	85 f6                	test   %esi,%esi
  801211:	75 0b                	jne    80121e <__udivdi3+0x2e>
  801213:	b8 01 00 00 00       	mov    $0x1,%eax
  801218:	31 d2                	xor    %edx,%edx
  80121a:	f7 f6                	div    %esi
  80121c:	89 c6                	mov    %eax,%esi
  80121e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801221:	31 d2                	xor    %edx,%edx
  801223:	89 f8                	mov    %edi,%eax
  801225:	f7 f6                	div    %esi
  801227:	89 c7                	mov    %eax,%edi
  801229:	89 c8                	mov    %ecx,%eax
  80122b:	f7 f6                	div    %esi
  80122d:	89 c1                	mov    %eax,%ecx
  80122f:	89 fa                	mov    %edi,%edx
  801231:	89 c8                	mov    %ecx,%eax
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	5e                   	pop    %esi
  801237:	5f                   	pop    %edi
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    
  80123a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801240:	39 f8                	cmp    %edi,%eax
  801242:	77 1c                	ja     801260 <__udivdi3+0x70>
  801244:	0f bd d0             	bsr    %eax,%edx
  801247:	83 f2 1f             	xor    $0x1f,%edx
  80124a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80124d:	75 39                	jne    801288 <__udivdi3+0x98>
  80124f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801252:	0f 86 a0 00 00 00    	jbe    8012f8 <__udivdi3+0x108>
  801258:	39 f8                	cmp    %edi,%eax
  80125a:	0f 82 98 00 00 00    	jb     8012f8 <__udivdi3+0x108>
  801260:	31 ff                	xor    %edi,%edi
  801262:	31 c9                	xor    %ecx,%ecx
  801264:	89 c8                	mov    %ecx,%eax
  801266:	89 fa                	mov    %edi,%edx
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	5e                   	pop    %esi
  80126c:	5f                   	pop    %edi
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    
  80126f:	90                   	nop
  801270:	89 d1                	mov    %edx,%ecx
  801272:	89 fa                	mov    %edi,%edx
  801274:	89 c8                	mov    %ecx,%eax
  801276:	31 ff                	xor    %edi,%edi
  801278:	f7 f6                	div    %esi
  80127a:	89 c1                	mov    %eax,%ecx
  80127c:	89 fa                	mov    %edi,%edx
  80127e:	89 c8                	mov    %ecx,%eax
  801280:	83 c4 10             	add    $0x10,%esp
  801283:	5e                   	pop    %esi
  801284:	5f                   	pop    %edi
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    
  801287:	90                   	nop
  801288:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80128c:	89 f2                	mov    %esi,%edx
  80128e:	d3 e0                	shl    %cl,%eax
  801290:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801293:	b8 20 00 00 00       	mov    $0x20,%eax
  801298:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80129b:	89 c1                	mov    %eax,%ecx
  80129d:	d3 ea                	shr    %cl,%edx
  80129f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8012a3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8012a6:	d3 e6                	shl    %cl,%esi
  8012a8:	89 c1                	mov    %eax,%ecx
  8012aa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8012ad:	89 fe                	mov    %edi,%esi
  8012af:	d3 ee                	shr    %cl,%esi
  8012b1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8012b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8012b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012bb:	d3 e7                	shl    %cl,%edi
  8012bd:	89 c1                	mov    %eax,%ecx
  8012bf:	d3 ea                	shr    %cl,%edx
  8012c1:	09 d7                	or     %edx,%edi
  8012c3:	89 f2                	mov    %esi,%edx
  8012c5:	89 f8                	mov    %edi,%eax
  8012c7:	f7 75 ec             	divl   -0x14(%ebp)
  8012ca:	89 d6                	mov    %edx,%esi
  8012cc:	89 c7                	mov    %eax,%edi
  8012ce:	f7 65 e8             	mull   -0x18(%ebp)
  8012d1:	39 d6                	cmp    %edx,%esi
  8012d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8012d6:	72 30                	jb     801308 <__udivdi3+0x118>
  8012d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012db:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8012df:	d3 e2                	shl    %cl,%edx
  8012e1:	39 c2                	cmp    %eax,%edx
  8012e3:	73 05                	jae    8012ea <__udivdi3+0xfa>
  8012e5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8012e8:	74 1e                	je     801308 <__udivdi3+0x118>
  8012ea:	89 f9                	mov    %edi,%ecx
  8012ec:	31 ff                	xor    %edi,%edi
  8012ee:	e9 71 ff ff ff       	jmp    801264 <__udivdi3+0x74>
  8012f3:	90                   	nop
  8012f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012f8:	31 ff                	xor    %edi,%edi
  8012fa:	b9 01 00 00 00       	mov    $0x1,%ecx
  8012ff:	e9 60 ff ff ff       	jmp    801264 <__udivdi3+0x74>
  801304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801308:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80130b:	31 ff                	xor    %edi,%edi
  80130d:	89 c8                	mov    %ecx,%eax
  80130f:	89 fa                	mov    %edi,%edx
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	5e                   	pop    %esi
  801315:	5f                   	pop    %edi
  801316:	5d                   	pop    %ebp
  801317:	c3                   	ret    
	...

00801320 <__umoddi3>:
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	57                   	push   %edi
  801324:	56                   	push   %esi
  801325:	83 ec 20             	sub    $0x20,%esp
  801328:	8b 55 14             	mov    0x14(%ebp),%edx
  80132b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801331:	8b 75 0c             	mov    0xc(%ebp),%esi
  801334:	85 d2                	test   %edx,%edx
  801336:	89 c8                	mov    %ecx,%eax
  801338:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80133b:	75 13                	jne    801350 <__umoddi3+0x30>
  80133d:	39 f7                	cmp    %esi,%edi
  80133f:	76 3f                	jbe    801380 <__umoddi3+0x60>
  801341:	89 f2                	mov    %esi,%edx
  801343:	f7 f7                	div    %edi
  801345:	89 d0                	mov    %edx,%eax
  801347:	31 d2                	xor    %edx,%edx
  801349:	83 c4 20             	add    $0x20,%esp
  80134c:	5e                   	pop    %esi
  80134d:	5f                   	pop    %edi
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    
  801350:	39 f2                	cmp    %esi,%edx
  801352:	77 4c                	ja     8013a0 <__umoddi3+0x80>
  801354:	0f bd ca             	bsr    %edx,%ecx
  801357:	83 f1 1f             	xor    $0x1f,%ecx
  80135a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80135d:	75 51                	jne    8013b0 <__umoddi3+0x90>
  80135f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801362:	0f 87 e0 00 00 00    	ja     801448 <__umoddi3+0x128>
  801368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136b:	29 f8                	sub    %edi,%eax
  80136d:	19 d6                	sbb    %edx,%esi
  80136f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801375:	89 f2                	mov    %esi,%edx
  801377:	83 c4 20             	add    $0x20,%esp
  80137a:	5e                   	pop    %esi
  80137b:	5f                   	pop    %edi
  80137c:	5d                   	pop    %ebp
  80137d:	c3                   	ret    
  80137e:	66 90                	xchg   %ax,%ax
  801380:	85 ff                	test   %edi,%edi
  801382:	75 0b                	jne    80138f <__umoddi3+0x6f>
  801384:	b8 01 00 00 00       	mov    $0x1,%eax
  801389:	31 d2                	xor    %edx,%edx
  80138b:	f7 f7                	div    %edi
  80138d:	89 c7                	mov    %eax,%edi
  80138f:	89 f0                	mov    %esi,%eax
  801391:	31 d2                	xor    %edx,%edx
  801393:	f7 f7                	div    %edi
  801395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801398:	f7 f7                	div    %edi
  80139a:	eb a9                	jmp    801345 <__umoddi3+0x25>
  80139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013a0:	89 c8                	mov    %ecx,%eax
  8013a2:	89 f2                	mov    %esi,%edx
  8013a4:	83 c4 20             	add    $0x20,%esp
  8013a7:	5e                   	pop    %esi
  8013a8:	5f                   	pop    %edi
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    
  8013ab:	90                   	nop
  8013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8013b4:	d3 e2                	shl    %cl,%edx
  8013b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013b9:	ba 20 00 00 00       	mov    $0x20,%edx
  8013be:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8013c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8013c4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8013c8:	89 fa                	mov    %edi,%edx
  8013ca:	d3 ea                	shr    %cl,%edx
  8013cc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8013d0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8013d3:	d3 e7                	shl    %cl,%edi
  8013d5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8013d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013dc:	89 f2                	mov    %esi,%edx
  8013de:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8013e1:	89 c7                	mov    %eax,%edi
  8013e3:	d3 ea                	shr    %cl,%edx
  8013e5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8013e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8013ec:	89 c2                	mov    %eax,%edx
  8013ee:	d3 e6                	shl    %cl,%esi
  8013f0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8013f4:	d3 ea                	shr    %cl,%edx
  8013f6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8013fa:	09 d6                	or     %edx,%esi
  8013fc:	89 f0                	mov    %esi,%eax
  8013fe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801401:	d3 e7                	shl    %cl,%edi
  801403:	89 f2                	mov    %esi,%edx
  801405:	f7 75 f4             	divl   -0xc(%ebp)
  801408:	89 d6                	mov    %edx,%esi
  80140a:	f7 65 e8             	mull   -0x18(%ebp)
  80140d:	39 d6                	cmp    %edx,%esi
  80140f:	72 2b                	jb     80143c <__umoddi3+0x11c>
  801411:	39 c7                	cmp    %eax,%edi
  801413:	72 23                	jb     801438 <__umoddi3+0x118>
  801415:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801419:	29 c7                	sub    %eax,%edi
  80141b:	19 d6                	sbb    %edx,%esi
  80141d:	89 f0                	mov    %esi,%eax
  80141f:	89 f2                	mov    %esi,%edx
  801421:	d3 ef                	shr    %cl,%edi
  801423:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801427:	d3 e0                	shl    %cl,%eax
  801429:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80142d:	09 f8                	or     %edi,%eax
  80142f:	d3 ea                	shr    %cl,%edx
  801431:	83 c4 20             	add    $0x20,%esp
  801434:	5e                   	pop    %esi
  801435:	5f                   	pop    %edi
  801436:	5d                   	pop    %ebp
  801437:	c3                   	ret    
  801438:	39 d6                	cmp    %edx,%esi
  80143a:	75 d9                	jne    801415 <__umoddi3+0xf5>
  80143c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80143f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801442:	eb d1                	jmp    801415 <__umoddi3+0xf5>
  801444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801448:	39 f2                	cmp    %esi,%edx
  80144a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801450:	0f 82 12 ff ff ff    	jb     801368 <__umoddi3+0x48>
  801456:	e9 17 ff ff ff       	jmp    801372 <__umoddi3+0x52>
