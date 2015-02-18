
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 6f 00 00 00       	call   8000a0 <libmain>
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
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003b:	a1 04 20 80 00       	mov    0x802004,%eax
  800040:	8b 40 48             	mov    0x48(%eax),%eax
  800043:	89 44 24 04          	mov    %eax,0x4(%esp)
  800047:	c7 04 24 00 13 80 00 	movl   $0x801300,(%esp)
  80004e:	e8 12 01 00 00       	call   800165 <cprintf>
  800053:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < 5; i++) {
		sys_yield();
  800058:	e8 10 0f 00 00       	call   800f6d <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005d:	a1 04 20 80 00       	mov    0x802004,%eax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  800062:	8b 40 48             	mov    0x48(%eax),%eax
  800065:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800069:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006d:	c7 04 24 20 13 80 00 	movl   $0x801320,(%esp)
  800074:	e8 ec 00 00 00       	call   800165 <cprintf>
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  800079:	83 c3 01             	add    $0x1,%ebx
  80007c:	83 fb 05             	cmp    $0x5,%ebx
  80007f:	75 d7                	jne    800058 <umain+0x24>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800081:	a1 04 20 80 00       	mov    0x802004,%eax
  800086:	8b 40 48             	mov    0x48(%eax),%eax
  800089:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008d:	c7 04 24 4c 13 80 00 	movl   $0x80134c,(%esp)
  800094:	e8 cc 00 00 00       	call   800165 <cprintf>
}
  800099:	83 c4 14             	add    $0x14,%esp
  80009c:	5b                   	pop    %ebx
  80009d:	5d                   	pop    %ebp
  80009e:	c3                   	ret    
	...

008000a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 18             	sub    $0x18,%esp
  8000a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8000af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8000b2:	e8 ea 0e 00 00       	call   800fa1 <sys_getenvid>
  8000b7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000bc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000bf:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8000c4:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c9:	85 f6                	test   %esi,%esi
  8000cb:	7e 07                	jle    8000d4 <libmain+0x34>
		binaryname = argv[0];
  8000cd:	8b 03                	mov    (%ebx),%eax
  8000cf:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d8:	89 34 24             	mov    %esi,(%esp)
  8000db:	e8 54 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000e0:	e8 0b 00 00 00       	call   8000f0 <exit>
}
  8000e5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000e8:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000eb:	89 ec                	mov    %ebp,%esp
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    
	...

008000f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8000f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000fd:	e8 d3 0e 00 00       	call   800fd5 <sys_env_destroy>
}
  800102:	c9                   	leave  
  800103:	c3                   	ret    

00800104 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80010d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800114:	00 00 00 
	b.cnt = 0;
  800117:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800121:	8b 45 0c             	mov    0xc(%ebp),%eax
  800124:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800128:	8b 45 08             	mov    0x8(%ebp),%eax
  80012b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80012f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800135:	89 44 24 04          	mov    %eax,0x4(%esp)
  800139:	c7 04 24 7f 01 80 00 	movl   $0x80017f,(%esp)
  800140:	e8 be 01 00 00       	call   800303 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800145:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80014b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800155:	89 04 24             	mov    %eax,(%esp)
  800158:	e8 23 0a 00 00       	call   800b80 <sys_cputs>

	return b.cnt;
}
  80015d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800163:	c9                   	leave  
  800164:	c3                   	ret    

00800165 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80016b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80016e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800172:	8b 45 08             	mov    0x8(%ebp),%eax
  800175:	89 04 24             	mov    %eax,(%esp)
  800178:	e8 87 ff ff ff       	call   800104 <vcprintf>
	va_end(ap);

	return cnt;
}
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	53                   	push   %ebx
  800183:	83 ec 14             	sub    $0x14,%esp
  800186:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800189:	8b 03                	mov    (%ebx),%eax
  80018b:	8b 55 08             	mov    0x8(%ebp),%edx
  80018e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800192:	83 c0 01             	add    $0x1,%eax
  800195:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800197:	3d ff 00 00 00       	cmp    $0xff,%eax
  80019c:	75 19                	jne    8001b7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80019e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001a5:	00 
  8001a6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a9:	89 04 24             	mov    %eax,(%esp)
  8001ac:	e8 cf 09 00 00       	call   800b80 <sys_cputs>
		b->idx = 0;
  8001b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001b7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001bb:	83 c4 14             	add    $0x14,%esp
  8001be:	5b                   	pop    %ebx
  8001bf:	5d                   	pop    %ebp
  8001c0:	c3                   	ret    
  8001c1:	00 00                	add    %al,(%eax)
	...

008001c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	57                   	push   %edi
  8001c8:	56                   	push   %esi
  8001c9:	53                   	push   %ebx
  8001ca:	83 ec 4c             	sub    $0x4c,%esp
  8001cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001d0:	89 d6                	mov    %edx,%esi
  8001d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001db:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001e4:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	39 d1                	cmp    %edx,%ecx
  8001f1:	72 07                	jb     8001fa <printnum+0x36>
  8001f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001f6:	39 d0                	cmp    %edx,%eax
  8001f8:	77 69                	ja     800263 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001fa:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8001fe:	83 eb 01             	sub    $0x1,%ebx
  800201:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800205:	89 44 24 08          	mov    %eax,0x8(%esp)
  800209:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  80020d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800211:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800214:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800217:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80021a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80021e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800225:	00 
  800226:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800229:	89 04 24             	mov    %eax,(%esp)
  80022c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80022f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800233:	e8 58 0e 00 00       	call   801090 <__udivdi3>
  800238:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80023b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80023e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800242:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800246:	89 04 24             	mov    %eax,(%esp)
  800249:	89 54 24 04          	mov    %edx,0x4(%esp)
  80024d:	89 f2                	mov    %esi,%edx
  80024f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800252:	e8 6d ff ff ff       	call   8001c4 <printnum>
  800257:	eb 11                	jmp    80026a <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800259:	89 74 24 04          	mov    %esi,0x4(%esp)
  80025d:	89 3c 24             	mov    %edi,(%esp)
  800260:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800263:	83 eb 01             	sub    $0x1,%ebx
  800266:	85 db                	test   %ebx,%ebx
  800268:	7f ef                	jg     800259 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80026e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800272:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800275:	89 44 24 08          	mov    %eax,0x8(%esp)
  800279:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800280:	00 
  800281:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800284:	89 14 24             	mov    %edx,(%esp)
  800287:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80028a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80028e:	e8 2d 0f 00 00       	call   8011c0 <__umoddi3>
  800293:	89 74 24 04          	mov    %esi,0x4(%esp)
  800297:	0f be 80 75 13 80 00 	movsbl 0x801375(%eax),%eax
  80029e:	89 04 24             	mov    %eax,(%esp)
  8002a1:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002a4:	83 c4 4c             	add    $0x4c,%esp
  8002a7:	5b                   	pop    %ebx
  8002a8:	5e                   	pop    %esi
  8002a9:	5f                   	pop    %edi
  8002aa:	5d                   	pop    %ebp
  8002ab:	c3                   	ret    

008002ac <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002af:	83 fa 01             	cmp    $0x1,%edx
  8002b2:	7e 0e                	jle    8002c2 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002b4:	8b 10                	mov    (%eax),%edx
  8002b6:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002b9:	89 08                	mov    %ecx,(%eax)
  8002bb:	8b 02                	mov    (%edx),%eax
  8002bd:	8b 52 04             	mov    0x4(%edx),%edx
  8002c0:	eb 22                	jmp    8002e4 <getuint+0x38>
	else if (lflag)
  8002c2:	85 d2                	test   %edx,%edx
  8002c4:	74 10                	je     8002d6 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002c6:	8b 10                	mov    (%eax),%edx
  8002c8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002cb:	89 08                	mov    %ecx,(%eax)
  8002cd:	8b 02                	mov    (%edx),%eax
  8002cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d4:	eb 0e                	jmp    8002e4 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002d6:	8b 10                	mov    (%eax),%edx
  8002d8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002db:	89 08                	mov    %ecx,(%eax)
  8002dd:	8b 02                	mov    (%edx),%eax
  8002df:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f5:	73 0a                	jae    800301 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002fa:	88 0a                	mov    %cl,(%edx)
  8002fc:	83 c2 01             	add    $0x1,%edx
  8002ff:	89 10                	mov    %edx,(%eax)
}
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	57                   	push   %edi
  800307:	56                   	push   %esi
  800308:	53                   	push   %ebx
  800309:	83 ec 4c             	sub    $0x4c,%esp
  80030c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80030f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800312:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800315:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  80031c:	eb 11                	jmp    80032f <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80031e:	85 c0                	test   %eax,%eax
  800320:	0f 84 b6 03 00 00    	je     8006dc <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800326:	89 74 24 04          	mov    %esi,0x4(%esp)
  80032a:	89 04 24             	mov    %eax,(%esp)
  80032d:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80032f:	0f b6 03             	movzbl (%ebx),%eax
  800332:	83 c3 01             	add    $0x1,%ebx
  800335:	83 f8 25             	cmp    $0x25,%eax
  800338:	75 e4                	jne    80031e <vprintfmt+0x1b>
  80033a:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80033e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800345:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80034c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800353:	b9 00 00 00 00       	mov    $0x0,%ecx
  800358:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80035b:	eb 06                	jmp    800363 <vprintfmt+0x60>
  80035d:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800361:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800363:	0f b6 0b             	movzbl (%ebx),%ecx
  800366:	0f b6 c1             	movzbl %cl,%eax
  800369:	8d 53 01             	lea    0x1(%ebx),%edx
  80036c:	83 e9 23             	sub    $0x23,%ecx
  80036f:	80 f9 55             	cmp    $0x55,%cl
  800372:	0f 87 47 03 00 00    	ja     8006bf <vprintfmt+0x3bc>
  800378:	0f b6 c9             	movzbl %cl,%ecx
  80037b:	ff 24 8d c0 14 80 00 	jmp    *0x8014c0(,%ecx,4)
  800382:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800386:	eb d9                	jmp    800361 <vprintfmt+0x5e>
  800388:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80038f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800394:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800397:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80039b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80039e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003a1:	83 fb 09             	cmp    $0x9,%ebx
  8003a4:	77 30                	ja     8003d6 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003a6:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003a9:	eb e9                	jmp    800394 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ae:	8d 48 04             	lea    0x4(%eax),%ecx
  8003b1:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003b4:	8b 00                	mov    (%eax),%eax
  8003b6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8003b9:	eb 1e                	jmp    8003d9 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8003bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c4:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8003c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cb:	eb 94                	jmp    800361 <vprintfmt+0x5e>
  8003cd:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003d4:	eb 8b                	jmp    800361 <vprintfmt+0x5e>
  8003d6:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8003d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003dd:	79 82                	jns    800361 <vprintfmt+0x5e>
  8003df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003e5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8003e8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8003eb:	e9 71 ff ff ff       	jmp    800361 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003f0:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003f4:	e9 68 ff ff ff       	jmp    800361 <vprintfmt+0x5e>
  8003f9:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ff:	8d 50 04             	lea    0x4(%eax),%edx
  800402:	89 55 14             	mov    %edx,0x14(%ebp)
  800405:	89 74 24 04          	mov    %esi,0x4(%esp)
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	89 04 24             	mov    %eax,(%esp)
  80040e:	ff d7                	call   *%edi
  800410:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800413:	e9 17 ff ff ff       	jmp    80032f <vprintfmt+0x2c>
  800418:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80041b:	8b 45 14             	mov    0x14(%ebp),%eax
  80041e:	8d 50 04             	lea    0x4(%eax),%edx
  800421:	89 55 14             	mov    %edx,0x14(%ebp)
  800424:	8b 00                	mov    (%eax),%eax
  800426:	89 c2                	mov    %eax,%edx
  800428:	c1 fa 1f             	sar    $0x1f,%edx
  80042b:	31 d0                	xor    %edx,%eax
  80042d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042f:	83 f8 11             	cmp    $0x11,%eax
  800432:	7f 0b                	jg     80043f <vprintfmt+0x13c>
  800434:	8b 14 85 20 16 80 00 	mov    0x801620(,%eax,4),%edx
  80043b:	85 d2                	test   %edx,%edx
  80043d:	75 20                	jne    80045f <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80043f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800443:	c7 44 24 08 86 13 80 	movl   $0x801386,0x8(%esp)
  80044a:	00 
  80044b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80044f:	89 3c 24             	mov    %edi,(%esp)
  800452:	e8 0d 03 00 00       	call   800764 <printfmt>
  800457:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045a:	e9 d0 fe ff ff       	jmp    80032f <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80045f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800463:	c7 44 24 08 8f 13 80 	movl   $0x80138f,0x8(%esp)
  80046a:	00 
  80046b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80046f:	89 3c 24             	mov    %edi,(%esp)
  800472:	e8 ed 02 00 00       	call   800764 <printfmt>
  800477:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80047a:	e9 b0 fe ff ff       	jmp    80032f <vprintfmt+0x2c>
  80047f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800482:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800488:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80048b:	8b 45 14             	mov    0x14(%ebp),%eax
  80048e:	8d 50 04             	lea    0x4(%eax),%edx
  800491:	89 55 14             	mov    %edx,0x14(%ebp)
  800494:	8b 18                	mov    (%eax),%ebx
  800496:	85 db                	test   %ebx,%ebx
  800498:	b8 92 13 80 00       	mov    $0x801392,%eax
  80049d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8004a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a4:	7e 76                	jle    80051c <vprintfmt+0x219>
  8004a6:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8004aa:	74 7a                	je     800526 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ac:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004b0:	89 1c 24             	mov    %ebx,(%esp)
  8004b3:	e8 f0 02 00 00       	call   8007a8 <strnlen>
  8004b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004bb:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8004bd:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8004c1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004c4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004c7:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c9:	eb 0f                	jmp    8004da <vprintfmt+0x1d7>
					putch(padc, putdat);
  8004cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d2:	89 04 24             	mov    %eax,(%esp)
  8004d5:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	83 eb 01             	sub    $0x1,%ebx
  8004da:	85 db                	test   %ebx,%ebx
  8004dc:	7f ed                	jg     8004cb <vprintfmt+0x1c8>
  8004de:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8004e1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004e4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004e7:	89 f7                	mov    %esi,%edi
  8004e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004ec:	eb 40                	jmp    80052e <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f2:	74 18                	je     80050c <vprintfmt+0x209>
  8004f4:	8d 50 e0             	lea    -0x20(%eax),%edx
  8004f7:	83 fa 5e             	cmp    $0x5e,%edx
  8004fa:	76 10                	jbe    80050c <vprintfmt+0x209>
					putch('?', putdat);
  8004fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800500:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800507:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80050a:	eb 0a                	jmp    800516 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  80050c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800510:	89 04 24             	mov    %eax,(%esp)
  800513:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800516:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80051a:	eb 12                	jmp    80052e <vprintfmt+0x22b>
  80051c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80051f:	89 f7                	mov    %esi,%edi
  800521:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800524:	eb 08                	jmp    80052e <vprintfmt+0x22b>
  800526:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800529:	89 f7                	mov    %esi,%edi
  80052b:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80052e:	0f be 03             	movsbl (%ebx),%eax
  800531:	83 c3 01             	add    $0x1,%ebx
  800534:	85 c0                	test   %eax,%eax
  800536:	74 25                	je     80055d <vprintfmt+0x25a>
  800538:	85 f6                	test   %esi,%esi
  80053a:	78 b2                	js     8004ee <vprintfmt+0x1eb>
  80053c:	83 ee 01             	sub    $0x1,%esi
  80053f:	79 ad                	jns    8004ee <vprintfmt+0x1eb>
  800541:	89 fe                	mov    %edi,%esi
  800543:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800546:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800549:	eb 1a                	jmp    800565 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80054b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80054f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800556:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800558:	83 eb 01             	sub    $0x1,%ebx
  80055b:	eb 08                	jmp    800565 <vprintfmt+0x262>
  80055d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800560:	89 fe                	mov    %edi,%esi
  800562:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800565:	85 db                	test   %ebx,%ebx
  800567:	7f e2                	jg     80054b <vprintfmt+0x248>
  800569:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80056c:	e9 be fd ff ff       	jmp    80032f <vprintfmt+0x2c>
  800571:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800574:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800577:	83 f9 01             	cmp    $0x1,%ecx
  80057a:	7e 16                	jle    800592 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 50 08             	lea    0x8(%eax),%edx
  800582:	89 55 14             	mov    %edx,0x14(%ebp)
  800585:	8b 10                	mov    (%eax),%edx
  800587:	8b 48 04             	mov    0x4(%eax),%ecx
  80058a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  80058d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800590:	eb 32                	jmp    8005c4 <vprintfmt+0x2c1>
	else if (lflag)
  800592:	85 c9                	test   %ecx,%ecx
  800594:	74 18                	je     8005ae <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8d 50 04             	lea    0x4(%eax),%edx
  80059c:	89 55 14             	mov    %edx,0x14(%ebp)
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	89 c1                	mov    %eax,%ecx
  8005a6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ac:	eb 16                	jmp    8005c4 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8d 50 04             	lea    0x4(%eax),%edx
  8005b4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bc:	89 c2                	mov    %eax,%edx
  8005be:	c1 fa 1f             	sar    $0x1f,%edx
  8005c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005c4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005c7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005ca:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005d3:	0f 89 a7 00 00 00    	jns    800680 <vprintfmt+0x37d>
				putch('-', putdat);
  8005d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005dd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005e4:	ff d7                	call   *%edi
				num = -(long long) num;
  8005e6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005e9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005ec:	f7 d9                	neg    %ecx
  8005ee:	83 d3 00             	adc    $0x0,%ebx
  8005f1:	f7 db                	neg    %ebx
  8005f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f8:	e9 83 00 00 00       	jmp    800680 <vprintfmt+0x37d>
  8005fd:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800600:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800603:	89 ca                	mov    %ecx,%edx
  800605:	8d 45 14             	lea    0x14(%ebp),%eax
  800608:	e8 9f fc ff ff       	call   8002ac <getuint>
  80060d:	89 c1                	mov    %eax,%ecx
  80060f:	89 d3                	mov    %edx,%ebx
  800611:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800616:	eb 68                	jmp    800680 <vprintfmt+0x37d>
  800618:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80061b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80061e:	89 ca                	mov    %ecx,%edx
  800620:	8d 45 14             	lea    0x14(%ebp),%eax
  800623:	e8 84 fc ff ff       	call   8002ac <getuint>
  800628:	89 c1                	mov    %eax,%ecx
  80062a:	89 d3                	mov    %edx,%ebx
  80062c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800631:	eb 4d                	jmp    800680 <vprintfmt+0x37d>
  800633:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800636:	89 74 24 04          	mov    %esi,0x4(%esp)
  80063a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800641:	ff d7                	call   *%edi
			putch('x', putdat);
  800643:	89 74 24 04          	mov    %esi,0x4(%esp)
  800647:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80064e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	89 55 14             	mov    %edx,0x14(%ebp)
  800659:	8b 08                	mov    (%eax),%ecx
  80065b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800660:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800665:	eb 19                	jmp    800680 <vprintfmt+0x37d>
  800667:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80066a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80066d:	89 ca                	mov    %ecx,%edx
  80066f:	8d 45 14             	lea    0x14(%ebp),%eax
  800672:	e8 35 fc ff ff       	call   8002ac <getuint>
  800677:	89 c1                	mov    %eax,%ecx
  800679:	89 d3                	mov    %edx,%ebx
  80067b:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800680:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800684:	89 54 24 10          	mov    %edx,0x10(%esp)
  800688:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80068b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80068f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800693:	89 0c 24             	mov    %ecx,(%esp)
  800696:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80069a:	89 f2                	mov    %esi,%edx
  80069c:	89 f8                	mov    %edi,%eax
  80069e:	e8 21 fb ff ff       	call   8001c4 <printnum>
  8006a3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006a6:	e9 84 fc ff ff       	jmp    80032f <vprintfmt+0x2c>
  8006ab:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006b2:	89 04 24             	mov    %eax,(%esp)
  8006b5:	ff d7                	call   *%edi
  8006b7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006ba:	e9 70 fc ff ff       	jmp    80032f <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006ca:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8006cf:	80 38 25             	cmpb   $0x25,(%eax)
  8006d2:	0f 84 57 fc ff ff    	je     80032f <vprintfmt+0x2c>
  8006d8:	89 c3                	mov    %eax,%ebx
  8006da:	eb f0                	jmp    8006cc <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8006dc:	83 c4 4c             	add    $0x4c,%esp
  8006df:	5b                   	pop    %ebx
  8006e0:	5e                   	pop    %esi
  8006e1:	5f                   	pop    %edi
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	83 ec 28             	sub    $0x28,%esp
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8006f0:	85 c0                	test   %eax,%eax
  8006f2:	74 04                	je     8006f8 <vsnprintf+0x14>
  8006f4:	85 d2                	test   %edx,%edx
  8006f6:	7f 07                	jg     8006ff <vsnprintf+0x1b>
  8006f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006fd:	eb 3b                	jmp    80073a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800702:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800709:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800717:	8b 45 10             	mov    0x10(%ebp),%eax
  80071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80071e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800721:	89 44 24 04          	mov    %eax,0x4(%esp)
  800725:	c7 04 24 e6 02 80 00 	movl   $0x8002e6,(%esp)
  80072c:	e8 d2 fb ff ff       	call   800303 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800734:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800737:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800742:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800745:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800749:	8b 45 10             	mov    0x10(%ebp),%eax
  80074c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800750:	8b 45 0c             	mov    0xc(%ebp),%eax
  800753:	89 44 24 04          	mov    %eax,0x4(%esp)
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 04 24             	mov    %eax,(%esp)
  80075d:	e8 82 ff ff ff       	call   8006e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800762:	c9                   	leave  
  800763:	c3                   	ret    

00800764 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80076a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80076d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800771:	8b 45 10             	mov    0x10(%ebp),%eax
  800774:	89 44 24 08          	mov    %eax,0x8(%esp)
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	89 04 24             	mov    %eax,(%esp)
  800785:	e8 79 fb ff ff       	call   800303 <vprintfmt>
	va_end(ap);
}
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    
  80078c:	00 00                	add    %al,(%eax)
	...

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	8b 55 08             	mov    0x8(%ebp),%edx
  800796:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80079b:	eb 03                	jmp    8007a0 <strlen+0x10>
		n++;
  80079d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a4:	75 f7                	jne    80079d <strlen+0xd>
		n++;
	return n;
}
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	53                   	push   %ebx
  8007ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007b2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b7:	eb 03                	jmp    8007bc <strnlen+0x14>
		n++;
  8007b9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bc:	39 c1                	cmp    %eax,%ecx
  8007be:	74 06                	je     8007c6 <strnlen+0x1e>
  8007c0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8007c4:	75 f3                	jne    8007b9 <strnlen+0x11>
		n++;
	return n;
}
  8007c6:	5b                   	pop    %ebx
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007df:	83 c2 01             	add    $0x1,%edx
  8007e2:	84 c9                	test   %cl,%cl
  8007e4:	75 f2                	jne    8007d8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007e6:	5b                   	pop    %ebx
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	53                   	push   %ebx
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f3:	89 1c 24             	mov    %ebx,(%esp)
  8007f6:	e8 95 ff ff ff       	call   800790 <strlen>
	strcpy(dst + len, src);
  8007fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  800802:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800805:	89 04 24             	mov    %eax,(%esp)
  800808:	e8 bc ff ff ff       	call   8007c9 <strcpy>
	return dst;
}
  80080d:	89 d8                	mov    %ebx,%eax
  80080f:	83 c4 08             	add    $0x8,%esp
  800812:	5b                   	pop    %ebx
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	56                   	push   %esi
  800819:	53                   	push   %ebx
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800820:	8b 75 10             	mov    0x10(%ebp),%esi
  800823:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800828:	eb 0f                	jmp    800839 <strncpy+0x24>
		*dst++ = *src;
  80082a:	0f b6 19             	movzbl (%ecx),%ebx
  80082d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800830:	80 39 01             	cmpb   $0x1,(%ecx)
  800833:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800836:	83 c2 01             	add    $0x1,%edx
  800839:	39 f2                	cmp    %esi,%edx
  80083b:	72 ed                	jb     80082a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80083d:	5b                   	pop    %ebx
  80083e:	5e                   	pop    %esi
  80083f:	5d                   	pop    %ebp
  800840:	c3                   	ret    

00800841 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800841:	55                   	push   %ebp
  800842:	89 e5                	mov    %esp,%ebp
  800844:	56                   	push   %esi
  800845:	53                   	push   %ebx
  800846:	8b 75 08             	mov    0x8(%ebp),%esi
  800849:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80084f:	89 f0                	mov    %esi,%eax
  800851:	85 d2                	test   %edx,%edx
  800853:	75 0a                	jne    80085f <strlcpy+0x1e>
  800855:	eb 17                	jmp    80086e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800857:	88 18                	mov    %bl,(%eax)
  800859:	83 c0 01             	add    $0x1,%eax
  80085c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80085f:	83 ea 01             	sub    $0x1,%edx
  800862:	74 07                	je     80086b <strlcpy+0x2a>
  800864:	0f b6 19             	movzbl (%ecx),%ebx
  800867:	84 db                	test   %bl,%bl
  800869:	75 ec                	jne    800857 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80086b:	c6 00 00             	movb   $0x0,(%eax)
  80086e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800870:	5b                   	pop    %ebx
  800871:	5e                   	pop    %esi
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80087d:	eb 06                	jmp    800885 <strcmp+0x11>
		p++, q++;
  80087f:	83 c1 01             	add    $0x1,%ecx
  800882:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800885:	0f b6 01             	movzbl (%ecx),%eax
  800888:	84 c0                	test   %al,%al
  80088a:	74 04                	je     800890 <strcmp+0x1c>
  80088c:	3a 02                	cmp    (%edx),%al
  80088e:	74 ef                	je     80087f <strcmp+0xb>
  800890:	0f b6 c0             	movzbl %al,%eax
  800893:	0f b6 12             	movzbl (%edx),%edx
  800896:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	53                   	push   %ebx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8008a7:	eb 09                	jmp    8008b2 <strncmp+0x18>
		n--, p++, q++;
  8008a9:	83 ea 01             	sub    $0x1,%edx
  8008ac:	83 c0 01             	add    $0x1,%eax
  8008af:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008b2:	85 d2                	test   %edx,%edx
  8008b4:	75 07                	jne    8008bd <strncmp+0x23>
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	eb 13                	jmp    8008d0 <strncmp+0x36>
  8008bd:	0f b6 18             	movzbl (%eax),%ebx
  8008c0:	84 db                	test   %bl,%bl
  8008c2:	74 04                	je     8008c8 <strncmp+0x2e>
  8008c4:	3a 19                	cmp    (%ecx),%bl
  8008c6:	74 e1                	je     8008a9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c8:	0f b6 00             	movzbl (%eax),%eax
  8008cb:	0f b6 11             	movzbl (%ecx),%edx
  8008ce:	29 d0                	sub    %edx,%eax
}
  8008d0:	5b                   	pop    %ebx
  8008d1:	5d                   	pop    %ebp
  8008d2:	c3                   	ret    

008008d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008dd:	eb 07                	jmp    8008e6 <strchr+0x13>
		if (*s == c)
  8008df:	38 ca                	cmp    %cl,%dl
  8008e1:	74 0f                	je     8008f2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008e3:	83 c0 01             	add    $0x1,%eax
  8008e6:	0f b6 10             	movzbl (%eax),%edx
  8008e9:	84 d2                	test   %dl,%dl
  8008eb:	75 f2                	jne    8008df <strchr+0xc>
  8008ed:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fe:	eb 07                	jmp    800907 <strfind+0x13>
		if (*s == c)
  800900:	38 ca                	cmp    %cl,%dl
  800902:	74 0a                	je     80090e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800904:	83 c0 01             	add    $0x1,%eax
  800907:	0f b6 10             	movzbl (%eax),%edx
  80090a:	84 d2                	test   %dl,%dl
  80090c:	75 f2                	jne    800900 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 0c             	sub    $0xc,%esp
  800916:	89 1c 24             	mov    %ebx,(%esp)
  800919:	89 74 24 04          	mov    %esi,0x4(%esp)
  80091d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800921:	8b 7d 08             	mov    0x8(%ebp),%edi
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80092a:	85 c9                	test   %ecx,%ecx
  80092c:	74 30                	je     80095e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80092e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800934:	75 25                	jne    80095b <memset+0x4b>
  800936:	f6 c1 03             	test   $0x3,%cl
  800939:	75 20                	jne    80095b <memset+0x4b>
		c &= 0xFF;
  80093b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093e:	89 d3                	mov    %edx,%ebx
  800940:	c1 e3 08             	shl    $0x8,%ebx
  800943:	89 d6                	mov    %edx,%esi
  800945:	c1 e6 18             	shl    $0x18,%esi
  800948:	89 d0                	mov    %edx,%eax
  80094a:	c1 e0 10             	shl    $0x10,%eax
  80094d:	09 f0                	or     %esi,%eax
  80094f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800951:	09 d8                	or     %ebx,%eax
  800953:	c1 e9 02             	shr    $0x2,%ecx
  800956:	fc                   	cld    
  800957:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800959:	eb 03                	jmp    80095e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80095b:	fc                   	cld    
  80095c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095e:	89 f8                	mov    %edi,%eax
  800960:	8b 1c 24             	mov    (%esp),%ebx
  800963:	8b 74 24 04          	mov    0x4(%esp),%esi
  800967:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80096b:	89 ec                	mov    %ebp,%esp
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	89 34 24             	mov    %esi,(%esp)
  800978:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800982:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800985:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800987:	39 c6                	cmp    %eax,%esi
  800989:	73 35                	jae    8009c0 <memmove+0x51>
  80098b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80098e:	39 d0                	cmp    %edx,%eax
  800990:	73 2e                	jae    8009c0 <memmove+0x51>
		s += n;
		d += n;
  800992:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800994:	f6 c2 03             	test   $0x3,%dl
  800997:	75 1b                	jne    8009b4 <memmove+0x45>
  800999:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80099f:	75 13                	jne    8009b4 <memmove+0x45>
  8009a1:	f6 c1 03             	test   $0x3,%cl
  8009a4:	75 0e                	jne    8009b4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8009a6:	83 ef 04             	sub    $0x4,%edi
  8009a9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009ac:	c1 e9 02             	shr    $0x2,%ecx
  8009af:	fd                   	std    
  8009b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b2:	eb 09                	jmp    8009bd <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009b4:	83 ef 01             	sub    $0x1,%edi
  8009b7:	8d 72 ff             	lea    -0x1(%edx),%esi
  8009ba:	fd                   	std    
  8009bb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009bd:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009be:	eb 20                	jmp    8009e0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c6:	75 15                	jne    8009dd <memmove+0x6e>
  8009c8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ce:	75 0d                	jne    8009dd <memmove+0x6e>
  8009d0:	f6 c1 03             	test   $0x3,%cl
  8009d3:	75 08                	jne    8009dd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8009d5:	c1 e9 02             	shr    $0x2,%ecx
  8009d8:	fc                   	cld    
  8009d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009db:	eb 03                	jmp    8009e0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009dd:	fc                   	cld    
  8009de:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e0:	8b 34 24             	mov    (%esp),%esi
  8009e3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009e7:	89 ec                	mov    %ebp,%esp
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    

008009eb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	89 04 24             	mov    %eax,(%esp)
  800a05:	e8 65 ff ff ff       	call   80096f <memmove>
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	57                   	push   %edi
  800a10:	56                   	push   %esi
  800a11:	53                   	push   %ebx
  800a12:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a1b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a20:	eb 1c                	jmp    800a3e <memcmp+0x32>
		if (*s1 != *s2)
  800a22:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800a26:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800a2a:	83 c2 01             	add    $0x1,%edx
  800a2d:	83 e9 01             	sub    $0x1,%ecx
  800a30:	38 d8                	cmp    %bl,%al
  800a32:	74 0a                	je     800a3e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800a34:	0f b6 c0             	movzbl %al,%eax
  800a37:	0f b6 db             	movzbl %bl,%ebx
  800a3a:	29 d8                	sub    %ebx,%eax
  800a3c:	eb 09                	jmp    800a47 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a3e:	85 c9                	test   %ecx,%ecx
  800a40:	75 e0                	jne    800a22 <memcmp+0x16>
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800a47:	5b                   	pop    %ebx
  800a48:	5e                   	pop    %esi
  800a49:	5f                   	pop    %edi
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a55:	89 c2                	mov    %eax,%edx
  800a57:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a5a:	eb 07                	jmp    800a63 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a5c:	38 08                	cmp    %cl,(%eax)
  800a5e:	74 07                	je     800a67 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a60:	83 c0 01             	add    $0x1,%eax
  800a63:	39 d0                	cmp    %edx,%eax
  800a65:	72 f5                	jb     800a5c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	57                   	push   %edi
  800a6d:	56                   	push   %esi
  800a6e:	53                   	push   %ebx
  800a6f:	83 ec 04             	sub    $0x4,%esp
  800a72:	8b 55 08             	mov    0x8(%ebp),%edx
  800a75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a78:	eb 03                	jmp    800a7d <strtol+0x14>
		s++;
  800a7a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7d:	0f b6 02             	movzbl (%edx),%eax
  800a80:	3c 20                	cmp    $0x20,%al
  800a82:	74 f6                	je     800a7a <strtol+0x11>
  800a84:	3c 09                	cmp    $0x9,%al
  800a86:	74 f2                	je     800a7a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a88:	3c 2b                	cmp    $0x2b,%al
  800a8a:	75 0c                	jne    800a98 <strtol+0x2f>
		s++;
  800a8c:	8d 52 01             	lea    0x1(%edx),%edx
  800a8f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a96:	eb 15                	jmp    800aad <strtol+0x44>
	else if (*s == '-')
  800a98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a9f:	3c 2d                	cmp    $0x2d,%al
  800aa1:	75 0a                	jne    800aad <strtol+0x44>
		s++, neg = 1;
  800aa3:	8d 52 01             	lea    0x1(%edx),%edx
  800aa6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	0f 94 c0             	sete   %al
  800ab2:	74 05                	je     800ab9 <strtol+0x50>
  800ab4:	83 fb 10             	cmp    $0x10,%ebx
  800ab7:	75 15                	jne    800ace <strtol+0x65>
  800ab9:	80 3a 30             	cmpb   $0x30,(%edx)
  800abc:	75 10                	jne    800ace <strtol+0x65>
  800abe:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ac2:	75 0a                	jne    800ace <strtol+0x65>
		s += 2, base = 16;
  800ac4:	83 c2 02             	add    $0x2,%edx
  800ac7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800acc:	eb 13                	jmp    800ae1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ace:	84 c0                	test   %al,%al
  800ad0:	74 0f                	je     800ae1 <strtol+0x78>
  800ad2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ad7:	80 3a 30             	cmpb   $0x30,(%edx)
  800ada:	75 05                	jne    800ae1 <strtol+0x78>
		s++, base = 8;
  800adc:	83 c2 01             	add    $0x1,%edx
  800adf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ae8:	0f b6 0a             	movzbl (%edx),%ecx
  800aeb:	89 cf                	mov    %ecx,%edi
  800aed:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800af0:	80 fb 09             	cmp    $0x9,%bl
  800af3:	77 08                	ja     800afd <strtol+0x94>
			dig = *s - '0';
  800af5:	0f be c9             	movsbl %cl,%ecx
  800af8:	83 e9 30             	sub    $0x30,%ecx
  800afb:	eb 1e                	jmp    800b1b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800afd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b00:	80 fb 19             	cmp    $0x19,%bl
  800b03:	77 08                	ja     800b0d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800b05:	0f be c9             	movsbl %cl,%ecx
  800b08:	83 e9 57             	sub    $0x57,%ecx
  800b0b:	eb 0e                	jmp    800b1b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800b0d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b10:	80 fb 19             	cmp    $0x19,%bl
  800b13:	77 15                	ja     800b2a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b15:	0f be c9             	movsbl %cl,%ecx
  800b18:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b1b:	39 f1                	cmp    %esi,%ecx
  800b1d:	7d 0b                	jge    800b2a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b1f:	83 c2 01             	add    $0x1,%edx
  800b22:	0f af c6             	imul   %esi,%eax
  800b25:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800b28:	eb be                	jmp    800ae8 <strtol+0x7f>
  800b2a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800b2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b30:	74 05                	je     800b37 <strtol+0xce>
		*endptr = (char *) s;
  800b32:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b35:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b37:	89 ca                	mov    %ecx,%edx
  800b39:	f7 da                	neg    %edx
  800b3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b3f:	0f 45 c2             	cmovne %edx,%eax
}
  800b42:	83 c4 04             	add    $0x4,%esp
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5f                   	pop    %edi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    
	...

00800b4c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 0c             	sub    $0xc,%esp
  800b52:	89 1c 24             	mov    %ebx,(%esp)
  800b55:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b59:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b62:	b8 01 00 00 00       	mov    $0x1,%eax
  800b67:	89 d1                	mov    %edx,%ecx
  800b69:	89 d3                	mov    %edx,%ebx
  800b6b:	89 d7                	mov    %edx,%edi
  800b6d:	89 d6                	mov    %edx,%esi
  800b6f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b71:	8b 1c 24             	mov    (%esp),%ebx
  800b74:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b7c:	89 ec                	mov    %ebp,%esp
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 0c             	sub    $0xc,%esp
  800b86:	89 1c 24             	mov    %ebx,(%esp)
  800b89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
  800b96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b99:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9c:	89 c3                	mov    %eax,%ebx
  800b9e:	89 c7                	mov    %eax,%edi
  800ba0:	89 c6                	mov    %eax,%esi
  800ba2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba4:	8b 1c 24             	mov    (%esp),%ebx
  800ba7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800baf:	89 ec                	mov    %ebp,%esp
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 0c             	sub    $0xc,%esp
  800bb9:	89 1c 24             	mov    %ebx,(%esp)
  800bbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bc0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	b8 10 00 00 00       	mov    $0x10,%eax
  800bce:	89 d1                	mov    %edx,%ecx
  800bd0:	89 d3                	mov    %edx,%ebx
  800bd2:	89 d7                	mov    %edx,%edi
  800bd4:	89 d6                	mov    %edx,%esi
  800bd6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800bd8:	8b 1c 24             	mov    (%esp),%ebx
  800bdb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bdf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800be3:	89 ec                	mov    %ebp,%esp
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 38             	sub    $0x38,%esp
  800bed:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bf0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bf3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bf6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bfb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800c00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c03:	8b 55 08             	mov    0x8(%ebp),%edx
  800c06:	89 df                	mov    %ebx,%edi
  800c08:	89 de                	mov    %ebx,%esi
  800c0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c0c:	85 c0                	test   %eax,%eax
  800c0e:	7e 28                	jle    800c38 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c14:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800c1b:	00 
  800c1c:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  800c23:	00 
  800c24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c2b:	00 
  800c2c:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800c33:	e8 fc 03 00 00       	call   801034 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800c38:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c3b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c3e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c41:	89 ec                	mov    %ebp,%esp
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	83 ec 38             	sub    $0x38,%esp
  800c4b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c4e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c51:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c59:	b8 0e 00 00 00       	mov    $0xe,%eax
  800c5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c61:	8b 55 08             	mov    0x8(%ebp),%edx
  800c64:	89 df                	mov    %ebx,%edi
  800c66:	89 de                	mov    %ebx,%esi
  800c68:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7e 28                	jle    800c96 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c72:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800c79:	00 
  800c7a:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  800c81:	00 
  800c82:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c89:	00 
  800c8a:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800c91:	e8 9e 03 00 00       	call   801034 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800c96:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c99:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c9c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c9f:	89 ec                	mov    %ebp,%esp
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	83 ec 38             	sub    $0x38,%esp
  800ca9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800caf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbf:	89 cb                	mov    %ecx,%ebx
  800cc1:	89 cf                	mov    %ecx,%edi
  800cc3:	89 ce                	mov    %ecx,%esi
  800cc5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	7e 28                	jle    800cf3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ccf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800cd6:	00 
  800cd7:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  800cde:	00 
  800cdf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce6:	00 
  800ce7:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800cee:	e8 41 03 00 00       	call   801034 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800cf3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cf6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cf9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cfc:	89 ec                	mov    %ebp,%esp
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	89 1c 24             	mov    %ebx,(%esp)
  800d09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d0d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d11:	be 00 00 00 00       	mov    $0x0,%esi
  800d16:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d1b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d29:	8b 1c 24             	mov    (%esp),%ebx
  800d2c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d30:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d34:	89 ec                	mov    %ebp,%esp
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 38             	sub    $0x38,%esp
  800d3e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d41:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d44:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	89 df                	mov    %ebx,%edi
  800d59:	89 de                	mov    %ebx,%esi
  800d5b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	7e 28                	jle    800d89 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d61:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d65:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d6c:	00 
  800d6d:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  800d74:	00 
  800d75:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d7c:	00 
  800d7d:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800d84:	e8 ab 02 00 00       	call   801034 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d89:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d8c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d8f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d92:	89 ec                	mov    %ebp,%esp
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 38             	sub    $0x38,%esp
  800d9c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d9f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800da2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800daa:	b8 09 00 00 00       	mov    $0x9,%eax
  800daf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db2:	8b 55 08             	mov    0x8(%ebp),%edx
  800db5:	89 df                	mov    %ebx,%edi
  800db7:	89 de                	mov    %ebx,%esi
  800db9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dbb:	85 c0                	test   %eax,%eax
  800dbd:	7e 28                	jle    800de7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dca:	00 
  800dcb:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  800dd2:	00 
  800dd3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dda:	00 
  800ddb:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800de2:	e8 4d 02 00 00       	call   801034 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800de7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ded:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800df0:	89 ec                	mov    %ebp,%esp
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 38             	sub    $0x38,%esp
  800dfa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dfd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e00:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	8b 55 08             	mov    0x8(%ebp),%edx
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7e 28                	jle    800e45 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e21:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e28:	00 
  800e29:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  800e30:	00 
  800e31:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e38:	00 
  800e39:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800e40:	e8 ef 01 00 00       	call   801034 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e45:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e48:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e4b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e4e:	89 ec                	mov    %ebp,%esp
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 38             	sub    $0x38,%esp
  800e58:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e5b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e5e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e66:	b8 06 00 00 00       	mov    $0x6,%eax
  800e6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	89 df                	mov    %ebx,%edi
  800e73:	89 de                	mov    %ebx,%esi
  800e75:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	7e 28                	jle    800ea3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e86:	00 
  800e87:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  800e8e:	00 
  800e8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e96:	00 
  800e97:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800e9e:	e8 91 01 00 00       	call   801034 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ea3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ea6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ea9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eac:	89 ec                	mov    %ebp,%esp
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 38             	sub    $0x38,%esp
  800eb6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eb9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ebc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebf:	b8 05 00 00 00       	mov    $0x5,%eax
  800ec4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ec7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	7e 28                	jle    800f01 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800edd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ee4:	00 
  800ee5:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  800eec:	00 
  800eed:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef4:	00 
  800ef5:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800efc:	e8 33 01 00 00       	call   801034 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f01:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f04:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f07:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f0a:	89 ec                	mov    %ebp,%esp
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    

00800f0e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 38             	sub    $0x38,%esp
  800f14:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f17:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f1a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1d:	be 00 00 00 00       	mov    $0x0,%esi
  800f22:	b8 04 00 00 00       	mov    $0x4,%eax
  800f27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	89 f7                	mov    %esi,%edi
  800f32:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	7e 28                	jle    800f60 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f38:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f43:	00 
  800f44:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  800f4b:	00 
  800f4c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f53:	00 
  800f54:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800f5b:	e8 d4 00 00 00       	call   801034 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f60:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f63:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f66:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f69:	89 ec                	mov    %ebp,%esp
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	89 1c 24             	mov    %ebx,(%esp)
  800f76:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f7a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f83:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f88:	89 d1                	mov    %edx,%ecx
  800f8a:	89 d3                	mov    %edx,%ebx
  800f8c:	89 d7                	mov    %edx,%edi
  800f8e:	89 d6                	mov    %edx,%esi
  800f90:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f92:	8b 1c 24             	mov    (%esp),%ebx
  800f95:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f99:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f9d:	89 ec                	mov    %ebp,%esp
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 0c             	sub    $0xc,%esp
  800fa7:	89 1c 24             	mov    %ebx,(%esp)
  800faa:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fae:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb7:	b8 02 00 00 00       	mov    $0x2,%eax
  800fbc:	89 d1                	mov    %edx,%ecx
  800fbe:	89 d3                	mov    %edx,%ebx
  800fc0:	89 d7                	mov    %edx,%edi
  800fc2:	89 d6                	mov    %edx,%esi
  800fc4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fc6:	8b 1c 24             	mov    (%esp),%ebx
  800fc9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fcd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fd1:	89 ec                	mov    %ebp,%esp
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 38             	sub    $0x38,%esp
  800fdb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fde:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fe1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe9:	b8 03 00 00 00       	mov    $0x3,%eax
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	89 cb                	mov    %ecx,%ebx
  800ff3:	89 cf                	mov    %ecx,%edi
  800ff5:	89 ce                	mov    %ecx,%esi
  800ff7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	7e 28                	jle    801025 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801001:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801008:	00 
  801009:	c7 44 24 08 87 16 80 	movl   $0x801687,0x8(%esp)
  801010:	00 
  801011:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801018:	00 
  801019:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  801020:	e8 0f 00 00 00       	call   801034 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801025:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801028:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80102b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80102e:	89 ec                	mov    %ebp,%esp
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    
	...

00801034 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
  801039:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  80103c:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80103f:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  801045:	e8 57 ff ff ff       	call   800fa1 <sys_getenvid>
  80104a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104d:	89 54 24 10          	mov    %edx,0x10(%esp)
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
  801054:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801058:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80105c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801060:	c7 04 24 b4 16 80 00 	movl   $0x8016b4,(%esp)
  801067:	e8 f9 f0 ff ff       	call   800165 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80106c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	89 04 24             	mov    %eax,(%esp)
  801076:	e8 89 f0 ff ff       	call   800104 <vcprintf>
	cprintf("\n");
  80107b:	c7 04 24 d8 16 80 00 	movl   $0x8016d8,(%esp)
  801082:	e8 de f0 ff ff       	call   800165 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801087:	cc                   	int3   
  801088:	eb fd                	jmp    801087 <_panic+0x53>
  80108a:	00 00                	add    %al,(%eax)
  80108c:	00 00                	add    %al,(%eax)
	...

00801090 <__udivdi3>:
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	83 ec 10             	sub    $0x10,%esp
  801098:	8b 45 14             	mov    0x14(%ebp),%eax
  80109b:	8b 55 08             	mov    0x8(%ebp),%edx
  80109e:	8b 75 10             	mov    0x10(%ebp),%esi
  8010a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010a9:	75 35                	jne    8010e0 <__udivdi3+0x50>
  8010ab:	39 fe                	cmp    %edi,%esi
  8010ad:	77 61                	ja     801110 <__udivdi3+0x80>
  8010af:	85 f6                	test   %esi,%esi
  8010b1:	75 0b                	jne    8010be <__udivdi3+0x2e>
  8010b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8010b8:	31 d2                	xor    %edx,%edx
  8010ba:	f7 f6                	div    %esi
  8010bc:	89 c6                	mov    %eax,%esi
  8010be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010c1:	31 d2                	xor    %edx,%edx
  8010c3:	89 f8                	mov    %edi,%eax
  8010c5:	f7 f6                	div    %esi
  8010c7:	89 c7                	mov    %eax,%edi
  8010c9:	89 c8                	mov    %ecx,%eax
  8010cb:	f7 f6                	div    %esi
  8010cd:	89 c1                	mov    %eax,%ecx
  8010cf:	89 fa                	mov    %edi,%edx
  8010d1:	89 c8                	mov    %ecx,%eax
  8010d3:	83 c4 10             	add    $0x10,%esp
  8010d6:	5e                   	pop    %esi
  8010d7:	5f                   	pop    %edi
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    
  8010da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010e0:	39 f8                	cmp    %edi,%eax
  8010e2:	77 1c                	ja     801100 <__udivdi3+0x70>
  8010e4:	0f bd d0             	bsr    %eax,%edx
  8010e7:	83 f2 1f             	xor    $0x1f,%edx
  8010ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010ed:	75 39                	jne    801128 <__udivdi3+0x98>
  8010ef:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8010f2:	0f 86 a0 00 00 00    	jbe    801198 <__udivdi3+0x108>
  8010f8:	39 f8                	cmp    %edi,%eax
  8010fa:	0f 82 98 00 00 00    	jb     801198 <__udivdi3+0x108>
  801100:	31 ff                	xor    %edi,%edi
  801102:	31 c9                	xor    %ecx,%ecx
  801104:	89 c8                	mov    %ecx,%eax
  801106:	89 fa                	mov    %edi,%edx
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	5e                   	pop    %esi
  80110c:	5f                   	pop    %edi
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    
  80110f:	90                   	nop
  801110:	89 d1                	mov    %edx,%ecx
  801112:	89 fa                	mov    %edi,%edx
  801114:	89 c8                	mov    %ecx,%eax
  801116:	31 ff                	xor    %edi,%edi
  801118:	f7 f6                	div    %esi
  80111a:	89 c1                	mov    %eax,%ecx
  80111c:	89 fa                	mov    %edi,%edx
  80111e:	89 c8                	mov    %ecx,%eax
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    
  801127:	90                   	nop
  801128:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80112c:	89 f2                	mov    %esi,%edx
  80112e:	d3 e0                	shl    %cl,%eax
  801130:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801133:	b8 20 00 00 00       	mov    $0x20,%eax
  801138:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80113b:	89 c1                	mov    %eax,%ecx
  80113d:	d3 ea                	shr    %cl,%edx
  80113f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801143:	0b 55 ec             	or     -0x14(%ebp),%edx
  801146:	d3 e6                	shl    %cl,%esi
  801148:	89 c1                	mov    %eax,%ecx
  80114a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80114d:	89 fe                	mov    %edi,%esi
  80114f:	d3 ee                	shr    %cl,%esi
  801151:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801155:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801158:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80115b:	d3 e7                	shl    %cl,%edi
  80115d:	89 c1                	mov    %eax,%ecx
  80115f:	d3 ea                	shr    %cl,%edx
  801161:	09 d7                	or     %edx,%edi
  801163:	89 f2                	mov    %esi,%edx
  801165:	89 f8                	mov    %edi,%eax
  801167:	f7 75 ec             	divl   -0x14(%ebp)
  80116a:	89 d6                	mov    %edx,%esi
  80116c:	89 c7                	mov    %eax,%edi
  80116e:	f7 65 e8             	mull   -0x18(%ebp)
  801171:	39 d6                	cmp    %edx,%esi
  801173:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801176:	72 30                	jb     8011a8 <__udivdi3+0x118>
  801178:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80117f:	d3 e2                	shl    %cl,%edx
  801181:	39 c2                	cmp    %eax,%edx
  801183:	73 05                	jae    80118a <__udivdi3+0xfa>
  801185:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801188:	74 1e                	je     8011a8 <__udivdi3+0x118>
  80118a:	89 f9                	mov    %edi,%ecx
  80118c:	31 ff                	xor    %edi,%edi
  80118e:	e9 71 ff ff ff       	jmp    801104 <__udivdi3+0x74>
  801193:	90                   	nop
  801194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801198:	31 ff                	xor    %edi,%edi
  80119a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80119f:	e9 60 ff ff ff       	jmp    801104 <__udivdi3+0x74>
  8011a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8011a8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8011ab:	31 ff                	xor    %edi,%edi
  8011ad:	89 c8                	mov    %ecx,%eax
  8011af:	89 fa                	mov    %edi,%edx
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	5e                   	pop    %esi
  8011b5:	5f                   	pop    %edi
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    
	...

008011c0 <__umoddi3>:
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	57                   	push   %edi
  8011c4:	56                   	push   %esi
  8011c5:	83 ec 20             	sub    $0x20,%esp
  8011c8:	8b 55 14             	mov    0x14(%ebp),%edx
  8011cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ce:	8b 7d 10             	mov    0x10(%ebp),%edi
  8011d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011d4:	85 d2                	test   %edx,%edx
  8011d6:	89 c8                	mov    %ecx,%eax
  8011d8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8011db:	75 13                	jne    8011f0 <__umoddi3+0x30>
  8011dd:	39 f7                	cmp    %esi,%edi
  8011df:	76 3f                	jbe    801220 <__umoddi3+0x60>
  8011e1:	89 f2                	mov    %esi,%edx
  8011e3:	f7 f7                	div    %edi
  8011e5:	89 d0                	mov    %edx,%eax
  8011e7:	31 d2                	xor    %edx,%edx
  8011e9:	83 c4 20             	add    $0x20,%esp
  8011ec:	5e                   	pop    %esi
  8011ed:	5f                   	pop    %edi
  8011ee:	5d                   	pop    %ebp
  8011ef:	c3                   	ret    
  8011f0:	39 f2                	cmp    %esi,%edx
  8011f2:	77 4c                	ja     801240 <__umoddi3+0x80>
  8011f4:	0f bd ca             	bsr    %edx,%ecx
  8011f7:	83 f1 1f             	xor    $0x1f,%ecx
  8011fa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8011fd:	75 51                	jne    801250 <__umoddi3+0x90>
  8011ff:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801202:	0f 87 e0 00 00 00    	ja     8012e8 <__umoddi3+0x128>
  801208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120b:	29 f8                	sub    %edi,%eax
  80120d:	19 d6                	sbb    %edx,%esi
  80120f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801215:	89 f2                	mov    %esi,%edx
  801217:	83 c4 20             	add    $0x20,%esp
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    
  80121e:	66 90                	xchg   %ax,%ax
  801220:	85 ff                	test   %edi,%edi
  801222:	75 0b                	jne    80122f <__umoddi3+0x6f>
  801224:	b8 01 00 00 00       	mov    $0x1,%eax
  801229:	31 d2                	xor    %edx,%edx
  80122b:	f7 f7                	div    %edi
  80122d:	89 c7                	mov    %eax,%edi
  80122f:	89 f0                	mov    %esi,%eax
  801231:	31 d2                	xor    %edx,%edx
  801233:	f7 f7                	div    %edi
  801235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801238:	f7 f7                	div    %edi
  80123a:	eb a9                	jmp    8011e5 <__umoddi3+0x25>
  80123c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801240:	89 c8                	mov    %ecx,%eax
  801242:	89 f2                	mov    %esi,%edx
  801244:	83 c4 20             	add    $0x20,%esp
  801247:	5e                   	pop    %esi
  801248:	5f                   	pop    %edi
  801249:	5d                   	pop    %ebp
  80124a:	c3                   	ret    
  80124b:	90                   	nop
  80124c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801250:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801254:	d3 e2                	shl    %cl,%edx
  801256:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801259:	ba 20 00 00 00       	mov    $0x20,%edx
  80125e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801261:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801264:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801268:	89 fa                	mov    %edi,%edx
  80126a:	d3 ea                	shr    %cl,%edx
  80126c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801270:	0b 55 f4             	or     -0xc(%ebp),%edx
  801273:	d3 e7                	shl    %cl,%edi
  801275:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801279:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80127c:	89 f2                	mov    %esi,%edx
  80127e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801281:	89 c7                	mov    %eax,%edi
  801283:	d3 ea                	shr    %cl,%edx
  801285:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801289:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80128c:	89 c2                	mov    %eax,%edx
  80128e:	d3 e6                	shl    %cl,%esi
  801290:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801294:	d3 ea                	shr    %cl,%edx
  801296:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80129a:	09 d6                	or     %edx,%esi
  80129c:	89 f0                	mov    %esi,%eax
  80129e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8012a1:	d3 e7                	shl    %cl,%edi
  8012a3:	89 f2                	mov    %esi,%edx
  8012a5:	f7 75 f4             	divl   -0xc(%ebp)
  8012a8:	89 d6                	mov    %edx,%esi
  8012aa:	f7 65 e8             	mull   -0x18(%ebp)
  8012ad:	39 d6                	cmp    %edx,%esi
  8012af:	72 2b                	jb     8012dc <__umoddi3+0x11c>
  8012b1:	39 c7                	cmp    %eax,%edi
  8012b3:	72 23                	jb     8012d8 <__umoddi3+0x118>
  8012b5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012b9:	29 c7                	sub    %eax,%edi
  8012bb:	19 d6                	sbb    %edx,%esi
  8012bd:	89 f0                	mov    %esi,%eax
  8012bf:	89 f2                	mov    %esi,%edx
  8012c1:	d3 ef                	shr    %cl,%edi
  8012c3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012c7:	d3 e0                	shl    %cl,%eax
  8012c9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012cd:	09 f8                	or     %edi,%eax
  8012cf:	d3 ea                	shr    %cl,%edx
  8012d1:	83 c4 20             	add    $0x20,%esp
  8012d4:	5e                   	pop    %esi
  8012d5:	5f                   	pop    %edi
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    
  8012d8:	39 d6                	cmp    %edx,%esi
  8012da:	75 d9                	jne    8012b5 <__umoddi3+0xf5>
  8012dc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8012df:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8012e2:	eb d1                	jmp    8012b5 <__umoddi3+0xf5>
  8012e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012e8:	39 f2                	cmp    %esi,%edx
  8012ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012f0:	0f 82 12 ff ff ff    	jb     801208 <__umoddi3+0x48>
  8012f6:	e9 17 ff ff ff       	jmp    801212 <__umoddi3+0x52>
