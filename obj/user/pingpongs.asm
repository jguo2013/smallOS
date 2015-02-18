
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 1b 01 00 00       	call   80014c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 4c             	sub    $0x4c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003d:	e8 a2 10 00 00       	call   8010e4 <sfork>
  800042:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800045:	85 c0                	test   %eax,%eax
  800047:	74 5e                	je     8000a7 <umain+0x73>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  800049:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80004f:	e8 fd 0f 00 00       	call   801051 <sys_getenvid>
  800054:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005c:	c7 04 24 40 19 80 00 	movl   $0x801940,(%esp)
  800063:	e8 a9 01 00 00       	call   800211 <cprintf>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800068:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80006b:	e8 e1 0f 00 00       	call   801051 <sys_getenvid>
  800070:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800074:	89 44 24 04          	mov    %eax,0x4(%esp)
  800078:	c7 04 24 5a 19 80 00 	movl   $0x80195a,(%esp)
  80007f:	e8 8d 01 00 00       	call   800211 <cprintf>
		ipc_send(who, 0, 0, 0);
  800084:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80008b:	00 
  80008c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009b:	00 
  80009c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009f:	89 04 24             	mov    %eax,(%esp)
  8000a2:	e8 2b 14 00 00       	call   8014d2 <ipc_send>
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  8000a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ae:	00 
  8000af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b6:	00 
  8000b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8000ba:	89 04 24             	mov    %eax,(%esp)
  8000bd:	e8 7c 14 00 00       	call   80153e <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  8000c2:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  8000c8:	8b 73 48             	mov    0x48(%ebx),%esi
  8000cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8000ce:	8b 15 04 20 80 00    	mov    0x802004,%edx
  8000d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8000d7:	e8 75 0f 00 00       	call   801051 <sys_getenvid>
  8000dc:	89 74 24 14          	mov    %esi,0x14(%esp)
  8000e0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8000e4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f3:	c7 04 24 70 19 80 00 	movl   $0x801970,(%esp)
  8000fa:	e8 12 01 00 00       	call   800211 <cprintf>
		if (val == 10)
  8000ff:	a1 04 20 80 00       	mov    0x802004,%eax
  800104:	83 f8 0a             	cmp    $0xa,%eax
  800107:	74 38                	je     800141 <umain+0x10d>
			return;
		++val;
  800109:	83 c0 01             	add    $0x1,%eax
  80010c:	a3 04 20 80 00       	mov    %eax,0x802004
		ipc_send(who, 0, 0, 0);
  800111:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800118:	00 
  800119:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800120:	00 
  800121:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800128:	00 
  800129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012c:	89 04 24             	mov    %eax,(%esp)
  80012f:	e8 9e 13 00 00       	call   8014d2 <ipc_send>
		if (val == 10)
  800134:	83 3d 04 20 80 00 0a 	cmpl   $0xa,0x802004
  80013b:	0f 85 66 ff ff ff    	jne    8000a7 <umain+0x73>
			return;
	}

}
  800141:	83 c4 4c             	add    $0x4c,%esp
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5f                   	pop    %edi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    
  800149:	00 00                	add    %al,(%eax)
	...

0080014c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 18             	sub    $0x18,%esp
  800152:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800155:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800158:	8b 75 08             	mov    0x8(%ebp),%esi
  80015b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80015e:	e8 ee 0e 00 00       	call   801051 <sys_getenvid>
  800163:	25 ff 03 00 00       	and    $0x3ff,%eax
  800168:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80016b:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800170:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800175:	85 f6                	test   %esi,%esi
  800177:	7e 07                	jle    800180 <libmain+0x34>
		binaryname = argv[0];
  800179:	8b 03                	mov    (%ebx),%eax
  80017b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800180:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 a8 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80018c:	e8 0b 00 00 00       	call   80019c <exit>
}
  800191:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800194:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800197:	89 ec                	mov    %ebp,%esp
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    
	...

0080019c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8001a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a9:	e8 d7 0e 00 00       	call   801085 <sys_env_destroy>
}
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c0:	00 00 00 
	b.cnt = 0;
  8001c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e5:	c7 04 24 2b 02 80 00 	movl   $0x80022b,(%esp)
  8001ec:	e8 be 01 00 00       	call   8003af <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800201:	89 04 24             	mov    %eax,(%esp)
  800204:	e8 27 0a 00 00       	call   800c30 <sys_cputs>

	return b.cnt;
}
  800209:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020f:	c9                   	leave  
  800210:	c3                   	ret    

00800211 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800217:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80021a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	89 04 24             	mov    %eax,(%esp)
  800224:	e8 87 ff ff ff       	call   8001b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	53                   	push   %ebx
  80022f:	83 ec 14             	sub    $0x14,%esp
  800232:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800235:	8b 03                	mov    (%ebx),%eax
  800237:	8b 55 08             	mov    0x8(%ebp),%edx
  80023a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80023e:	83 c0 01             	add    $0x1,%eax
  800241:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800243:	3d ff 00 00 00       	cmp    $0xff,%eax
  800248:	75 19                	jne    800263 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80024a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800251:	00 
  800252:	8d 43 08             	lea    0x8(%ebx),%eax
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	e8 d3 09 00 00       	call   800c30 <sys_cputs>
		b->idx = 0;
  80025d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800263:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800267:	83 c4 14             	add    $0x14,%esp
  80026a:	5b                   	pop    %ebx
  80026b:	5d                   	pop    %ebp
  80026c:	c3                   	ret    
  80026d:	00 00                	add    %al,(%eax)
	...

00800270 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 4c             	sub    $0x4c,%esp
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027c:	89 d6                	mov    %edx,%esi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800284:	8b 55 0c             	mov    0xc(%ebp),%edx
  800287:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80028a:	8b 45 10             	mov    0x10(%ebp),%eax
  80028d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800290:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800293:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800296:	b9 00 00 00 00       	mov    $0x0,%ecx
  80029b:	39 d1                	cmp    %edx,%ecx
  80029d:	72 07                	jb     8002a6 <printnum+0x36>
  80029f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002a2:	39 d0                	cmp    %edx,%eax
  8002a4:	77 69                	ja     80030f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a6:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002aa:	83 eb 01             	sub    $0x1,%ebx
  8002ad:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8002b9:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8002bd:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8002c0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002c3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002c6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002ca:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002d1:	00 
  8002d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002df:	e8 ec 13 00 00       	call   8016d0 <__udivdi3>
  8002e4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002e7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002ea:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002f9:	89 f2                	mov    %esi,%edx
  8002fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fe:	e8 6d ff ff ff       	call   800270 <printnum>
  800303:	eb 11                	jmp    800316 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800305:	89 74 24 04          	mov    %esi,0x4(%esp)
  800309:	89 3c 24             	mov    %edi,(%esp)
  80030c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80030f:	83 eb 01             	sub    $0x1,%ebx
  800312:	85 db                	test   %ebx,%ebx
  800314:	7f ef                	jg     800305 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800316:	89 74 24 04          	mov    %esi,0x4(%esp)
  80031a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80031e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800321:	89 44 24 08          	mov    %eax,0x8(%esp)
  800325:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80032c:	00 
  80032d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800330:	89 14 24             	mov    %edx,(%esp)
  800333:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800336:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80033a:	e8 c1 14 00 00       	call   801800 <__umoddi3>
  80033f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800343:	0f be 80 a0 19 80 00 	movsbl 0x8019a0(%eax),%eax
  80034a:	89 04 24             	mov    %eax,(%esp)
  80034d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800350:	83 c4 4c             	add    $0x4c,%esp
  800353:	5b                   	pop    %ebx
  800354:	5e                   	pop    %esi
  800355:	5f                   	pop    %edi
  800356:	5d                   	pop    %ebp
  800357:	c3                   	ret    

00800358 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80035b:	83 fa 01             	cmp    $0x1,%edx
  80035e:	7e 0e                	jle    80036e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800360:	8b 10                	mov    (%eax),%edx
  800362:	8d 4a 08             	lea    0x8(%edx),%ecx
  800365:	89 08                	mov    %ecx,(%eax)
  800367:	8b 02                	mov    (%edx),%eax
  800369:	8b 52 04             	mov    0x4(%edx),%edx
  80036c:	eb 22                	jmp    800390 <getuint+0x38>
	else if (lflag)
  80036e:	85 d2                	test   %edx,%edx
  800370:	74 10                	je     800382 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800372:	8b 10                	mov    (%eax),%edx
  800374:	8d 4a 04             	lea    0x4(%edx),%ecx
  800377:	89 08                	mov    %ecx,(%eax)
  800379:	8b 02                	mov    (%edx),%eax
  80037b:	ba 00 00 00 00       	mov    $0x0,%edx
  800380:	eb 0e                	jmp    800390 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800382:	8b 10                	mov    (%eax),%edx
  800384:	8d 4a 04             	lea    0x4(%edx),%ecx
  800387:	89 08                	mov    %ecx,(%eax)
  800389:	8b 02                	mov    (%edx),%eax
  80038b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800390:	5d                   	pop    %ebp
  800391:	c3                   	ret    

00800392 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800398:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039c:	8b 10                	mov    (%eax),%edx
  80039e:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a1:	73 0a                	jae    8003ad <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a6:	88 0a                	mov    %cl,(%edx)
  8003a8:	83 c2 01             	add    $0x1,%edx
  8003ab:	89 10                	mov    %edx,(%eax)
}
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	57                   	push   %edi
  8003b3:	56                   	push   %esi
  8003b4:	53                   	push   %ebx
  8003b5:	83 ec 4c             	sub    $0x4c,%esp
  8003b8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003be:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8003c1:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8003c8:	eb 11                	jmp    8003db <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	0f 84 b6 03 00 00    	je     800788 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8003d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d6:	89 04 24             	mov    %eax,(%esp)
  8003d9:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003db:	0f b6 03             	movzbl (%ebx),%eax
  8003de:	83 c3 01             	add    $0x1,%ebx
  8003e1:	83 f8 25             	cmp    $0x25,%eax
  8003e4:	75 e4                	jne    8003ca <vprintfmt+0x1b>
  8003e6:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8003ea:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003f1:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8003f8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800404:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800407:	eb 06                	jmp    80040f <vprintfmt+0x60>
  800409:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  80040d:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040f:	0f b6 0b             	movzbl (%ebx),%ecx
  800412:	0f b6 c1             	movzbl %cl,%eax
  800415:	8d 53 01             	lea    0x1(%ebx),%edx
  800418:	83 e9 23             	sub    $0x23,%ecx
  80041b:	80 f9 55             	cmp    $0x55,%cl
  80041e:	0f 87 47 03 00 00    	ja     80076b <vprintfmt+0x3bc>
  800424:	0f b6 c9             	movzbl %cl,%ecx
  800427:	ff 24 8d e0 1a 80 00 	jmp    *0x801ae0(,%ecx,4)
  80042e:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800432:	eb d9                	jmp    80040d <vprintfmt+0x5e>
  800434:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80043b:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800440:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800443:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800447:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80044a:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80044d:	83 fb 09             	cmp    $0x9,%ebx
  800450:	77 30                	ja     800482 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800452:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800455:	eb e9                	jmp    800440 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800457:	8b 45 14             	mov    0x14(%ebp),%eax
  80045a:	8d 48 04             	lea    0x4(%eax),%ecx
  80045d:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800460:	8b 00                	mov    (%eax),%eax
  800462:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800465:	eb 1e                	jmp    800485 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800467:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
  800470:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800474:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800477:	eb 94                	jmp    80040d <vprintfmt+0x5e>
  800479:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800480:	eb 8b                	jmp    80040d <vprintfmt+0x5e>
  800482:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800485:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800489:	79 82                	jns    80040d <vprintfmt+0x5e>
  80048b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80048e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800491:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800494:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800497:	e9 71 ff ff ff       	jmp    80040d <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80049c:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004a0:	e9 68 ff ff ff       	jmp    80040d <vprintfmt+0x5e>
  8004a5:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 50 04             	lea    0x4(%eax),%edx
  8004ae:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	89 04 24             	mov    %eax,(%esp)
  8004ba:	ff d7                	call   *%edi
  8004bc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8004bf:	e9 17 ff ff ff       	jmp    8003db <vprintfmt+0x2c>
  8004c4:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8d 50 04             	lea    0x4(%eax),%edx
  8004cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	89 c2                	mov    %eax,%edx
  8004d4:	c1 fa 1f             	sar    $0x1f,%edx
  8004d7:	31 d0                	xor    %edx,%eax
  8004d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004db:	83 f8 11             	cmp    $0x11,%eax
  8004de:	7f 0b                	jg     8004eb <vprintfmt+0x13c>
  8004e0:	8b 14 85 40 1c 80 00 	mov    0x801c40(,%eax,4),%edx
  8004e7:	85 d2                	test   %edx,%edx
  8004e9:	75 20                	jne    80050b <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8004eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ef:	c7 44 24 08 b1 19 80 	movl   $0x8019b1,0x8(%esp)
  8004f6:	00 
  8004f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004fb:	89 3c 24             	mov    %edi,(%esp)
  8004fe:	e8 0d 03 00 00       	call   800810 <printfmt>
  800503:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800506:	e9 d0 fe ff ff       	jmp    8003db <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80050b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80050f:	c7 44 24 08 ba 19 80 	movl   $0x8019ba,0x8(%esp)
  800516:	00 
  800517:	89 74 24 04          	mov    %esi,0x4(%esp)
  80051b:	89 3c 24             	mov    %edi,(%esp)
  80051e:	e8 ed 02 00 00       	call   800810 <printfmt>
  800523:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800526:	e9 b0 fe ff ff       	jmp    8003db <vprintfmt+0x2c>
  80052b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80052e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800534:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8d 50 04             	lea    0x4(%eax),%edx
  80053d:	89 55 14             	mov    %edx,0x14(%ebp)
  800540:	8b 18                	mov    (%eax),%ebx
  800542:	85 db                	test   %ebx,%ebx
  800544:	b8 bd 19 80 00       	mov    $0x8019bd,%eax
  800549:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  80054c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800550:	7e 76                	jle    8005c8 <vprintfmt+0x219>
  800552:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800556:	74 7a                	je     8005d2 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800558:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80055c:	89 1c 24             	mov    %ebx,(%esp)
  80055f:	e8 f4 02 00 00       	call   800858 <strnlen>
  800564:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800567:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800569:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  80056d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800570:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800573:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800575:	eb 0f                	jmp    800586 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800577:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057e:	89 04 24             	mov    %eax,(%esp)
  800581:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800583:	83 eb 01             	sub    $0x1,%ebx
  800586:	85 db                	test   %ebx,%ebx
  800588:	7f ed                	jg     800577 <vprintfmt+0x1c8>
  80058a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80058d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800590:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800593:	89 f7                	mov    %esi,%edi
  800595:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800598:	eb 40                	jmp    8005da <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80059a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80059e:	74 18                	je     8005b8 <vprintfmt+0x209>
  8005a0:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005a3:	83 fa 5e             	cmp    $0x5e,%edx
  8005a6:	76 10                	jbe    8005b8 <vprintfmt+0x209>
					putch('?', putdat);
  8005a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ac:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005b3:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005b6:	eb 0a                	jmp    8005c2 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8005b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005bc:	89 04 24             	mov    %eax,(%esp)
  8005bf:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005c6:	eb 12                	jmp    8005da <vprintfmt+0x22b>
  8005c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005cb:	89 f7                	mov    %esi,%edi
  8005cd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005d0:	eb 08                	jmp    8005da <vprintfmt+0x22b>
  8005d2:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005d5:	89 f7                	mov    %esi,%edi
  8005d7:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005da:	0f be 03             	movsbl (%ebx),%eax
  8005dd:	83 c3 01             	add    $0x1,%ebx
  8005e0:	85 c0                	test   %eax,%eax
  8005e2:	74 25                	je     800609 <vprintfmt+0x25a>
  8005e4:	85 f6                	test   %esi,%esi
  8005e6:	78 b2                	js     80059a <vprintfmt+0x1eb>
  8005e8:	83 ee 01             	sub    $0x1,%esi
  8005eb:	79 ad                	jns    80059a <vprintfmt+0x1eb>
  8005ed:	89 fe                	mov    %edi,%esi
  8005ef:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005f2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005f5:	eb 1a                	jmp    800611 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800602:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800604:	83 eb 01             	sub    $0x1,%ebx
  800607:	eb 08                	jmp    800611 <vprintfmt+0x262>
  800609:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80060c:	89 fe                	mov    %edi,%esi
  80060e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800611:	85 db                	test   %ebx,%ebx
  800613:	7f e2                	jg     8005f7 <vprintfmt+0x248>
  800615:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800618:	e9 be fd ff ff       	jmp    8003db <vprintfmt+0x2c>
  80061d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800620:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800623:	83 f9 01             	cmp    $0x1,%ecx
  800626:	7e 16                	jle    80063e <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8d 50 08             	lea    0x8(%eax),%edx
  80062e:	89 55 14             	mov    %edx,0x14(%ebp)
  800631:	8b 10                	mov    (%eax),%edx
  800633:	8b 48 04             	mov    0x4(%eax),%ecx
  800636:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800639:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80063c:	eb 32                	jmp    800670 <vprintfmt+0x2c1>
	else if (lflag)
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	74 18                	je     80065a <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 50 04             	lea    0x4(%eax),%edx
  800648:	89 55 14             	mov    %edx,0x14(%ebp)
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800650:	89 c1                	mov    %eax,%ecx
  800652:	c1 f9 1f             	sar    $0x1f,%ecx
  800655:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800658:	eb 16                	jmp    800670 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8d 50 04             	lea    0x4(%eax),%edx
  800660:	89 55 14             	mov    %edx,0x14(%ebp)
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800668:	89 c2                	mov    %eax,%edx
  80066a:	c1 fa 1f             	sar    $0x1f,%edx
  80066d:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800670:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800673:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800676:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80067b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80067f:	0f 89 a7 00 00 00    	jns    80072c <vprintfmt+0x37d>
				putch('-', putdat);
  800685:	89 74 24 04          	mov    %esi,0x4(%esp)
  800689:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800690:	ff d7                	call   *%edi
				num = -(long long) num;
  800692:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800695:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800698:	f7 d9                	neg    %ecx
  80069a:	83 d3 00             	adc    $0x0,%ebx
  80069d:	f7 db                	neg    %ebx
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a4:	e9 83 00 00 00       	jmp    80072c <vprintfmt+0x37d>
  8006a9:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006ac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006af:	89 ca                	mov    %ecx,%edx
  8006b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b4:	e8 9f fc ff ff       	call   800358 <getuint>
  8006b9:	89 c1                	mov    %eax,%ecx
  8006bb:	89 d3                	mov    %edx,%ebx
  8006bd:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8006c2:	eb 68                	jmp    80072c <vprintfmt+0x37d>
  8006c4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006c7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006ca:	89 ca                	mov    %ecx,%edx
  8006cc:	8d 45 14             	lea    0x14(%ebp),%eax
  8006cf:	e8 84 fc ff ff       	call   800358 <getuint>
  8006d4:	89 c1                	mov    %eax,%ecx
  8006d6:	89 d3                	mov    %edx,%ebx
  8006d8:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8006dd:	eb 4d                	jmp    80072c <vprintfmt+0x37d>
  8006df:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8006e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006ed:	ff d7                	call   *%edi
			putch('x', putdat);
  8006ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f3:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006fa:	ff d7                	call   *%edi
			num = (unsigned long long)
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	89 55 14             	mov    %edx,0x14(%ebp)
  800705:	8b 08                	mov    (%eax),%ecx
  800707:	bb 00 00 00 00       	mov    $0x0,%ebx
  80070c:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800711:	eb 19                	jmp    80072c <vprintfmt+0x37d>
  800713:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800716:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800719:	89 ca                	mov    %ecx,%edx
  80071b:	8d 45 14             	lea    0x14(%ebp),%eax
  80071e:	e8 35 fc ff ff       	call   800358 <getuint>
  800723:	89 c1                	mov    %eax,%ecx
  800725:	89 d3                	mov    %edx,%ebx
  800727:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80072c:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800730:	89 54 24 10          	mov    %edx,0x10(%esp)
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80073b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80073f:	89 0c 24             	mov    %ecx,(%esp)
  800742:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800746:	89 f2                	mov    %esi,%edx
  800748:	89 f8                	mov    %edi,%eax
  80074a:	e8 21 fb ff ff       	call   800270 <printnum>
  80074f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800752:	e9 84 fc ff ff       	jmp    8003db <vprintfmt+0x2c>
  800757:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80075a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075e:	89 04 24             	mov    %eax,(%esp)
  800761:	ff d7                	call   *%edi
  800763:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800766:	e9 70 fc ff ff       	jmp    8003db <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80076b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80076f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800776:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800778:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80077b:	80 38 25             	cmpb   $0x25,(%eax)
  80077e:	0f 84 57 fc ff ff    	je     8003db <vprintfmt+0x2c>
  800784:	89 c3                	mov    %eax,%ebx
  800786:	eb f0                	jmp    800778 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800788:	83 c4 4c             	add    $0x4c,%esp
  80078b:	5b                   	pop    %ebx
  80078c:	5e                   	pop    %esi
  80078d:	5f                   	pop    %edi
  80078e:	5d                   	pop    %ebp
  80078f:	c3                   	ret    

00800790 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 28             	sub    $0x28,%esp
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80079c:	85 c0                	test   %eax,%eax
  80079e:	74 04                	je     8007a4 <vsnprintf+0x14>
  8007a0:	85 d2                	test   %edx,%edx
  8007a2:	7f 07                	jg     8007ab <vsnprintf+0x1b>
  8007a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a9:	eb 3b                	jmp    8007e6 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ae:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8007b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d1:	c7 04 24 92 03 80 00 	movl   $0x800392,(%esp)
  8007d8:	e8 d2 fb ff ff       	call   8003af <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8007ee:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8007f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	89 04 24             	mov    %eax,(%esp)
  800809:	e8 82 ff ff ff       	call   800790 <vsnprintf>
	va_end(ap);

	return rc;
}
  80080e:	c9                   	leave  
  80080f:	c3                   	ret    

00800810 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800816:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800819:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	89 44 24 08          	mov    %eax,0x8(%esp)
  800824:	8b 45 0c             	mov    0xc(%ebp),%eax
  800827:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	89 04 24             	mov    %eax,(%esp)
  800831:	e8 79 fb ff ff       	call   8003af <vprintfmt>
	va_end(ap);
}
  800836:	c9                   	leave  
  800837:	c3                   	ret    
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
  800ccc:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  800cd3:	00 
  800cd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cdb:	00 
  800cdc:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  800ce3:	e8 e0 08 00 00       	call   8015c8 <_panic>

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
  800d2a:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  800d31:	00 
  800d32:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d39:	00 
  800d3a:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  800d41:	e8 82 08 00 00       	call   8015c8 <_panic>

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
  800d87:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  800d8e:	00 
  800d8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d96:	00 
  800d97:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  800d9e:	e8 25 08 00 00       	call   8015c8 <_panic>

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
  800e1d:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  800e24:	00 
  800e25:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2c:	00 
  800e2d:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  800e34:	e8 8f 07 00 00       	call   8015c8 <_panic>

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
  800e7b:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  800e82:	00 
  800e83:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8a:	00 
  800e8b:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  800e92:	e8 31 07 00 00       	call   8015c8 <_panic>

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
  800ed9:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  800ee0:	00 
  800ee1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee8:	00 
  800ee9:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  800ef0:	e8 d3 06 00 00       	call   8015c8 <_panic>

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
  800f37:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f46:	00 
  800f47:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  800f4e:	e8 75 06 00 00       	call   8015c8 <_panic>

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
  800f95:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  800f9c:	00 
  800f9d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa4:	00 
  800fa5:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  800fac:	e8 17 06 00 00       	call   8015c8 <_panic>

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
  800ff4:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801003:	00 
  801004:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  80100b:	e8 b8 05 00 00       	call   8015c8 <_panic>

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
  8010b9:	c7 44 24 08 a7 1c 80 	movl   $0x801ca7,0x8(%esp)
  8010c0:	00 
  8010c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c8:	00 
  8010c9:	c7 04 24 c4 1c 80 00 	movl   $0x801cc4,(%esp)
  8010d0:	e8 f3 04 00 00       	call   8015c8 <_panic>

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

008010e4 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8010ea:	c7 44 24 08 d2 1c 80 	movl   $0x801cd2,0x8(%esp)
  8010f1:	00 
  8010f2:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  8010f9:	00 
  8010fa:	c7 04 24 e8 1c 80 00 	movl   $0x801ce8,(%esp)
  801101:	e8 c2 04 00 00       	call   8015c8 <_panic>

00801106 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	57                   	push   %edi
  80110a:	56                   	push   %esi
  80110b:	53                   	push   %ebx
  80110c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  80110f:	c7 04 24 74 13 80 00 	movl   $0x801374,(%esp)
  801116:	e8 05 05 00 00       	call   801620 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80111b:	ba 07 00 00 00       	mov    $0x7,%edx
  801120:	89 d0                	mov    %edx,%eax
  801122:	cd 30                	int    $0x30
  801124:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801127:	85 c0                	test   %eax,%eax
  801129:	79 20                	jns    80114b <fork+0x45>
		panic("sys_exofork: %e", envid);
  80112b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80112f:	c7 44 24 08 f3 1c 80 	movl   $0x801cf3,0x8(%esp)
  801136:	00 
  801137:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80113e:	00 
  80113f:	c7 04 24 e8 1c 80 00 	movl   $0x801ce8,(%esp)
  801146:	e8 7d 04 00 00       	call   8015c8 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  80114b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801152:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801157:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80115b:	75 21                	jne    80117e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80115d:	e8 ef fe ff ff       	call   801051 <sys_getenvid>
  801162:	25 ff 03 00 00       	and    $0x3ff,%eax
  801167:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80116a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80116f:	a3 08 20 80 00       	mov    %eax,0x802008
  801174:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801179:	e9 e5 01 00 00       	jmp    801363 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80117e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801181:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801188:	a8 01                	test   $0x1,%al
  80118a:	0f 84 4c 01 00 00    	je     8012dc <fork+0x1d6>
  801190:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801196:	0f 84 cf 01 00 00    	je     80136b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  80119c:	c1 e2 16             	shl    $0x16,%edx
  80119f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  8011a2:	89 d3                	mov    %edx,%ebx
  8011a4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011ab:	00 
  8011ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011b3:	89 04 24             	mov    %eax,(%esp)
  8011b6:	e8 03 fe ff ff       	call   800fbe <sys_page_alloc>
			if(ret < 0) return ret;
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	0f 88 a0 01 00 00    	js     801363 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  8011c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8011ca:	89 14 24             	mov    %edx,(%esp)
  8011cd:	e8 30 fd ff ff       	call   800f02 <sys_page_unmap>
			if(ret < 0) return ret;
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	0f 88 89 01 00 00    	js     801363 <fork+0x25d>
  8011da:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  8011df:	89 de                	mov    %ebx,%esi
  8011e1:	c1 e6 0c             	shl    $0xc,%esi
  8011e4:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  8011e7:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  8011ed:	0f 84 da 00 00 00    	je     8012cd <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8011f3:	c1 ee 0c             	shr    $0xc,%esi
  8011f6:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8011f9:	a8 01                	test   $0x1,%al
  8011fb:	0f 84 cc 00 00 00    	je     8012cd <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801201:	89 f0                	mov    %esi,%eax
  801203:	c1 e0 0c             	shl    $0xc,%eax
  801206:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801209:	e8 43 fe ff ff       	call   801051 <sys_getenvid>
  80120e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801211:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801214:	89 c6                	mov    %eax,%esi
  801216:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  80121c:	25 01 04 00 00       	and    $0x401,%eax
  801221:	3d 01 04 00 00       	cmp    $0x401,%eax
  801226:	75 3a                	jne    801262 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801228:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80122f:	00 
  801230:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801233:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801237:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80123a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80123e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801242:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801245:	89 14 24             	mov    %edx,(%esp)
  801248:	e8 13 fd ff ff       	call   800f60 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  80124d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801250:	89 44 24 04          	mov    %eax,0x4(%esp)
  801254:	c7 04 24 03 1d 80 00 	movl   $0x801d03,(%esp)
  80125b:	e8 b1 ef ff ff       	call   800211 <cprintf>
  801260:	eb 6b                	jmp    8012cd <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801262:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801268:	74 14                	je     80127e <fork+0x178>
  80126a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801270:	74 0c                	je     80127e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801272:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801278:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80127e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801281:	89 74 24 10          	mov    %esi,0x10(%esp)
  801285:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801289:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80128c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801290:	89 54 24 04          	mov    %edx,0x4(%esp)
  801294:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801297:	89 14 24             	mov    %edx,(%esp)
  80129a:	e8 c1 fc ff ff       	call   800f60 <sys_page_map>
	if(ret<0) return ret;
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	0f 88 bc 00 00 00    	js     801363 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  8012a7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8012ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012b5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8012b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012bd:	89 14 24             	mov    %edx,(%esp)
  8012c0:	e8 9b fc ff ff       	call   800f60 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	0f 88 96 00 00 00    	js     801363 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  8012cd:	83 c3 01             	add    $0x1,%ebx
  8012d0:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8012d6:	0f 85 03 ff ff ff    	jne    8011df <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8012dc:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  8012e0:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  8012e7:	0f 85 91 fe ff ff    	jne    80117e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  8012ed:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012f4:	00 
  8012f5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012fc:	ee 
  8012fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801300:	89 04 24             	mov    %eax,(%esp)
  801303:	e8 b6 fc ff ff       	call   800fbe <sys_page_alloc>
	if(ret < 0) return ret;
  801308:	85 c0                	test   %eax,%eax
  80130a:	78 57                	js     801363 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  80130c:	a1 08 20 80 00       	mov    0x802008,%eax
  801311:	8b 40 64             	mov    0x64(%eax),%eax
  801314:	89 44 24 04          	mov    %eax,0x4(%esp)
  801318:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80131b:	89 14 24             	mov    %edx,(%esp)
  80131e:	e8 c5 fa ff ff       	call   800de8 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801323:	85 c0                	test   %eax,%eax
  801325:	78 3c                	js     801363 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801327:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80132e:	00 
  80132f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801332:	89 04 24             	mov    %eax,(%esp)
  801335:	e8 6a fb ff ff       	call   800ea4 <sys_env_set_status>
  80133a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  80133c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80133f:	85 d2                	test   %edx,%edx
  801341:	79 20                	jns    801363 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801343:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801347:	c7 44 24 08 1a 1d 80 	movl   $0x801d1a,0x8(%esp)
  80134e:	00 
  80134f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801356:	00 
  801357:	c7 04 24 e8 1c 80 00 	movl   $0x801ce8,(%esp)
  80135e:	e8 65 02 00 00       	call   8015c8 <_panic>

	return envid;
}
  801363:	83 c4 4c             	add    $0x4c,%esp
  801366:	5b                   	pop    %ebx
  801367:	5e                   	pop    %esi
  801368:	5f                   	pop    %edi
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80136b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80136f:	e9 0a fe ff ff       	jmp    80117e <fork+0x78>

00801374 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	56                   	push   %esi
  801378:	53                   	push   %ebx
  801379:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80137c:	e8 d0 fc ff ff       	call   801051 <sys_getenvid>
  801381:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8b 00                	mov    (%eax),%eax
  801388:	89 c6                	mov    %eax,%esi
  80138a:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  80138d:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801394:	f6 c2 02             	test   $0x2,%dl
  801397:	75 2c                	jne    8013c5 <pgfault+0x51>
  801399:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8013a0:	f6 c6 08             	test   $0x8,%dh
  8013a3:	75 20                	jne    8013c5 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  8013a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013a9:	c7 44 24 08 68 1d 80 	movl   $0x801d68,0x8(%esp)
  8013b0:	00 
  8013b1:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8013b8:	00 
  8013b9:	c7 04 24 e8 1c 80 00 	movl   $0x801ce8,(%esp)
  8013c0:	e8 03 02 00 00       	call   8015c8 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8013c5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013cc:	00 
  8013cd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8013d4:	00 
  8013d5:	89 1c 24             	mov    %ebx,(%esp)
  8013d8:	e8 e1 fb ff ff       	call   800fbe <sys_page_alloc>
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	79 20                	jns    801401 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  8013e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013e5:	c7 44 24 08 31 1d 80 	movl   $0x801d31,0x8(%esp)
  8013ec:	00 
  8013ed:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8013f4:	00 
  8013f5:	c7 04 24 e8 1c 80 00 	movl   $0x801ce8,(%esp)
  8013fc:	e8 c7 01 00 00       	call   8015c8 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801401:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801404:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80140b:	00 
  80140c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801410:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801417:	e8 03 f6 ff ff       	call   800a1f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80141c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801423:	00 
  801424:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801428:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80142c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801433:	00 
  801434:	89 1c 24             	mov    %ebx,(%esp)
  801437:	e8 24 fb ff ff       	call   800f60 <sys_page_map>
  80143c:	85 c0                	test   %eax,%eax
  80143e:	79 20                	jns    801460 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801440:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801444:	c7 44 24 08 43 1d 80 	movl   $0x801d43,0x8(%esp)
  80144b:	00 
  80144c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801453:	00 
  801454:	c7 04 24 e8 1c 80 00 	movl   $0x801ce8,(%esp)
  80145b:	e8 68 01 00 00       	call   8015c8 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801460:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801467:	00 
  801468:	89 1c 24             	mov    %ebx,(%esp)
  80146b:	e8 92 fa ff ff       	call   800f02 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801470:	85 c0                	test   %eax,%eax
  801472:	74 20                	je     801494 <pgfault+0x120>
  801474:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801478:	c7 44 24 08 53 1d 80 	movl   $0x801d53,0x8(%esp)
  80147f:	00 
  801480:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801487:	00 
  801488:	c7 04 24 e8 1c 80 00 	movl   $0x801ce8,(%esp)
  80148f:	e8 34 01 00 00       	call   8015c8 <_panic>

}
  801494:	83 c4 20             	add    $0x20,%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    
	...

0080149c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a2:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8014a7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8014aa:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  8014b0:	8b 12                	mov    (%edx),%edx
  8014b2:	39 ca                	cmp    %ecx,%edx
  8014b4:	75 0c                	jne    8014c2 <ipc_find_env+0x26>
			return envs[i].env_id;
  8014b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014b9:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8014be:	8b 00                	mov    (%eax),%eax
  8014c0:	eb 0e                	jmp    8014d0 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8014c2:	83 c0 01             	add    $0x1,%eax
  8014c5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8014ca:	75 db                	jne    8014a7 <ipc_find_env+0xb>
  8014cc:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    

008014d2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	57                   	push   %edi
  8014d6:	56                   	push   %esi
  8014d7:	53                   	push   %ebx
  8014d8:	83 ec 2c             	sub    $0x2c,%esp
  8014db:	8b 75 08             	mov    0x8(%ebp),%esi
  8014de:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8014e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  8014e4:	85 db                	test   %ebx,%ebx
  8014e6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8014eb:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  8014ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014f5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014fd:	89 34 24             	mov    %esi,(%esp)
  801500:	e8 ab f8 ff ff       	call   800db0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  801505:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801508:	74 e4                	je     8014ee <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  80150a:	85 c0                	test   %eax,%eax
  80150c:	74 28                	je     801536 <ipc_send+0x64>
  80150e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801512:	c7 44 24 0c a6 1d 80 	movl   $0x801da6,0xc(%esp)
  801519:	00 
  80151a:	c7 44 24 08 89 1d 80 	movl   $0x801d89,0x8(%esp)
  801521:	00 
  801522:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801529:	00 
  80152a:	c7 04 24 9c 1d 80 00 	movl   $0x801d9c,(%esp)
  801531:	e8 92 00 00 00       	call   8015c8 <_panic>
	//if(!ret) sys_yield();
}
  801536:	83 c4 2c             	add    $0x2c,%esp
  801539:	5b                   	pop    %ebx
  80153a:	5e                   	pop    %esi
  80153b:	5f                   	pop    %edi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    

0080153e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 28             	sub    $0x28,%esp
  801544:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801547:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80154a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80154d:	8b 75 08             	mov    0x8(%ebp),%esi
  801550:	8b 45 0c             	mov    0xc(%ebp),%eax
  801553:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  801556:	85 c0                	test   %eax,%eax
  801558:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80155d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801560:	89 04 24             	mov    %eax,(%esp)
  801563:	e8 eb f7 ff ff       	call   800d53 <sys_ipc_recv>
  801568:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  80156a:	e8 e2 fa ff ff       	call   801051 <sys_getenvid>
  80156f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801574:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801577:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80157c:	a3 08 20 80 00       	mov    %eax,0x802008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  801581:	85 f6                	test   %esi,%esi
  801583:	74 0e                	je     801593 <ipc_recv+0x55>
  801585:	ba 00 00 00 00       	mov    $0x0,%edx
  80158a:	85 db                	test   %ebx,%ebx
  80158c:	75 03                	jne    801591 <ipc_recv+0x53>
  80158e:	8b 50 74             	mov    0x74(%eax),%edx
  801591:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  801593:	85 ff                	test   %edi,%edi
  801595:	74 13                	je     8015aa <ipc_recv+0x6c>
  801597:	b8 00 00 00 00       	mov    $0x0,%eax
  80159c:	85 db                	test   %ebx,%ebx
  80159e:	75 08                	jne    8015a8 <ipc_recv+0x6a>
  8015a0:	a1 08 20 80 00       	mov    0x802008,%eax
  8015a5:	8b 40 78             	mov    0x78(%eax),%eax
  8015a8:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  8015aa:	85 db                	test   %ebx,%ebx
  8015ac:	75 08                	jne    8015b6 <ipc_recv+0x78>
  8015ae:	a1 08 20 80 00       	mov    0x802008,%eax
  8015b3:	8b 58 70             	mov    0x70(%eax),%ebx
}
  8015b6:	89 d8                	mov    %ebx,%eax
  8015b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015bb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015be:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015c1:	89 ec                	mov    %ebp,%esp
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    
  8015c5:	00 00                	add    %al,(%eax)
	...

008015c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	56                   	push   %esi
  8015cc:	53                   	push   %ebx
  8015cd:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8015d0:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015d3:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8015d9:	e8 73 fa ff ff       	call   801051 <sys_getenvid>
  8015de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f4:	c7 04 24 b0 1d 80 00 	movl   $0x801db0,(%esp)
  8015fb:	e8 11 ec ff ff       	call   800211 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801600:	89 74 24 04          	mov    %esi,0x4(%esp)
  801604:	8b 45 10             	mov    0x10(%ebp),%eax
  801607:	89 04 24             	mov    %eax,(%esp)
  80160a:	e8 a1 eb ff ff       	call   8001b0 <vcprintf>
	cprintf("\n");
  80160f:	c7 04 24 9a 1d 80 00 	movl   $0x801d9a,(%esp)
  801616:	e8 f6 eb ff ff       	call   800211 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80161b:	cc                   	int3   
  80161c:	eb fd                	jmp    80161b <_panic+0x53>
	...

00801620 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	53                   	push   %ebx
  801624:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  801627:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  80162e:	75 5b                	jne    80168b <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  801630:	e8 1c fa ff ff       	call   801051 <sys_getenvid>
  801635:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  801637:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80163e:	00 
  80163f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801646:	ee 
  801647:	89 04 24             	mov    %eax,(%esp)
  80164a:	e8 6f f9 ff ff       	call   800fbe <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  80164f:	85 c0                	test   %eax,%eax
  801651:	74 28                	je     80167b <set_pgfault_handler+0x5b>
  801653:	89 44 24 10          	mov    %eax,0x10(%esp)
  801657:	c7 44 24 0c fb 1d 80 	movl   $0x801dfb,0xc(%esp)
  80165e:	00 
  80165f:	c7 44 24 08 d4 1d 80 	movl   $0x801dd4,0x8(%esp)
  801666:	00 
  801667:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80166e:	00 
  80166f:	c7 04 24 ed 1d 80 00 	movl   $0x801ded,(%esp)
  801676:	e8 4d ff ff ff       	call   8015c8 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80167b:	c7 44 24 04 9c 16 80 	movl   $0x80169c,0x4(%esp)
  801682:	00 
  801683:	89 1c 24             	mov    %ebx,(%esp)
  801686:	e8 5d f7 ff ff       	call   800de8 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	a3 0c 20 80 00       	mov    %eax,0x80200c
	
}
  801693:	83 c4 24             	add    $0x24,%esp
  801696:	5b                   	pop    %ebx
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    
  801699:	00 00                	add    %al,(%eax)
	...

0080169c <_pgfault_upcall>:
  80169c:	54                   	push   %esp
  80169d:	a1 0c 20 80 00       	mov    0x80200c,%eax
  8016a2:	ff d0                	call   *%eax
  8016a4:	83 c4 04             	add    $0x4,%esp
  8016a7:	83 c4 08             	add    $0x8,%esp
  8016aa:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  8016ae:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8016b2:	89 59 fc             	mov    %ebx,-0x4(%ecx)
  8016b5:	83 e9 04             	sub    $0x4,%ecx
  8016b8:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  8016bc:	61                   	popa   
  8016bd:	83 c4 04             	add    $0x4,%esp
  8016c0:	9d                   	popf   
  8016c1:	5c                   	pop    %esp
  8016c2:	c3                   	ret    
	...

008016d0 <__udivdi3>:
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	57                   	push   %edi
  8016d4:	56                   	push   %esi
  8016d5:	83 ec 10             	sub    $0x10,%esp
  8016d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016db:	8b 55 08             	mov    0x8(%ebp),%edx
  8016de:	8b 75 10             	mov    0x10(%ebp),%esi
  8016e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8016e9:	75 35                	jne    801720 <__udivdi3+0x50>
  8016eb:	39 fe                	cmp    %edi,%esi
  8016ed:	77 61                	ja     801750 <__udivdi3+0x80>
  8016ef:	85 f6                	test   %esi,%esi
  8016f1:	75 0b                	jne    8016fe <__udivdi3+0x2e>
  8016f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f8:	31 d2                	xor    %edx,%edx
  8016fa:	f7 f6                	div    %esi
  8016fc:	89 c6                	mov    %eax,%esi
  8016fe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801701:	31 d2                	xor    %edx,%edx
  801703:	89 f8                	mov    %edi,%eax
  801705:	f7 f6                	div    %esi
  801707:	89 c7                	mov    %eax,%edi
  801709:	89 c8                	mov    %ecx,%eax
  80170b:	f7 f6                	div    %esi
  80170d:	89 c1                	mov    %eax,%ecx
  80170f:	89 fa                	mov    %edi,%edx
  801711:	89 c8                	mov    %ecx,%eax
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	5e                   	pop    %esi
  801717:	5f                   	pop    %edi
  801718:	5d                   	pop    %ebp
  801719:	c3                   	ret    
  80171a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801720:	39 f8                	cmp    %edi,%eax
  801722:	77 1c                	ja     801740 <__udivdi3+0x70>
  801724:	0f bd d0             	bsr    %eax,%edx
  801727:	83 f2 1f             	xor    $0x1f,%edx
  80172a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80172d:	75 39                	jne    801768 <__udivdi3+0x98>
  80172f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801732:	0f 86 a0 00 00 00    	jbe    8017d8 <__udivdi3+0x108>
  801738:	39 f8                	cmp    %edi,%eax
  80173a:	0f 82 98 00 00 00    	jb     8017d8 <__udivdi3+0x108>
  801740:	31 ff                	xor    %edi,%edi
  801742:	31 c9                	xor    %ecx,%ecx
  801744:	89 c8                	mov    %ecx,%eax
  801746:	89 fa                	mov    %edi,%edx
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	5e                   	pop    %esi
  80174c:	5f                   	pop    %edi
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    
  80174f:	90                   	nop
  801750:	89 d1                	mov    %edx,%ecx
  801752:	89 fa                	mov    %edi,%edx
  801754:	89 c8                	mov    %ecx,%eax
  801756:	31 ff                	xor    %edi,%edi
  801758:	f7 f6                	div    %esi
  80175a:	89 c1                	mov    %eax,%ecx
  80175c:	89 fa                	mov    %edi,%edx
  80175e:	89 c8                	mov    %ecx,%eax
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	5e                   	pop    %esi
  801764:	5f                   	pop    %edi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    
  801767:	90                   	nop
  801768:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80176c:	89 f2                	mov    %esi,%edx
  80176e:	d3 e0                	shl    %cl,%eax
  801770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801773:	b8 20 00 00 00       	mov    $0x20,%eax
  801778:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80177b:	89 c1                	mov    %eax,%ecx
  80177d:	d3 ea                	shr    %cl,%edx
  80177f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801783:	0b 55 ec             	or     -0x14(%ebp),%edx
  801786:	d3 e6                	shl    %cl,%esi
  801788:	89 c1                	mov    %eax,%ecx
  80178a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80178d:	89 fe                	mov    %edi,%esi
  80178f:	d3 ee                	shr    %cl,%esi
  801791:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801795:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801798:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80179b:	d3 e7                	shl    %cl,%edi
  80179d:	89 c1                	mov    %eax,%ecx
  80179f:	d3 ea                	shr    %cl,%edx
  8017a1:	09 d7                	or     %edx,%edi
  8017a3:	89 f2                	mov    %esi,%edx
  8017a5:	89 f8                	mov    %edi,%eax
  8017a7:	f7 75 ec             	divl   -0x14(%ebp)
  8017aa:	89 d6                	mov    %edx,%esi
  8017ac:	89 c7                	mov    %eax,%edi
  8017ae:	f7 65 e8             	mull   -0x18(%ebp)
  8017b1:	39 d6                	cmp    %edx,%esi
  8017b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8017b6:	72 30                	jb     8017e8 <__udivdi3+0x118>
  8017b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017bb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8017bf:	d3 e2                	shl    %cl,%edx
  8017c1:	39 c2                	cmp    %eax,%edx
  8017c3:	73 05                	jae    8017ca <__udivdi3+0xfa>
  8017c5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8017c8:	74 1e                	je     8017e8 <__udivdi3+0x118>
  8017ca:	89 f9                	mov    %edi,%ecx
  8017cc:	31 ff                	xor    %edi,%edi
  8017ce:	e9 71 ff ff ff       	jmp    801744 <__udivdi3+0x74>
  8017d3:	90                   	nop
  8017d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8017d8:	31 ff                	xor    %edi,%edi
  8017da:	b9 01 00 00 00       	mov    $0x1,%ecx
  8017df:	e9 60 ff ff ff       	jmp    801744 <__udivdi3+0x74>
  8017e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8017e8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8017eb:	31 ff                	xor    %edi,%edi
  8017ed:	89 c8                	mov    %ecx,%eax
  8017ef:	89 fa                	mov    %edi,%edx
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	5e                   	pop    %esi
  8017f5:	5f                   	pop    %edi
  8017f6:	5d                   	pop    %ebp
  8017f7:	c3                   	ret    
	...

00801800 <__umoddi3>:
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	57                   	push   %edi
  801804:	56                   	push   %esi
  801805:	83 ec 20             	sub    $0x20,%esp
  801808:	8b 55 14             	mov    0x14(%ebp),%edx
  80180b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801811:	8b 75 0c             	mov    0xc(%ebp),%esi
  801814:	85 d2                	test   %edx,%edx
  801816:	89 c8                	mov    %ecx,%eax
  801818:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80181b:	75 13                	jne    801830 <__umoddi3+0x30>
  80181d:	39 f7                	cmp    %esi,%edi
  80181f:	76 3f                	jbe    801860 <__umoddi3+0x60>
  801821:	89 f2                	mov    %esi,%edx
  801823:	f7 f7                	div    %edi
  801825:	89 d0                	mov    %edx,%eax
  801827:	31 d2                	xor    %edx,%edx
  801829:	83 c4 20             	add    $0x20,%esp
  80182c:	5e                   	pop    %esi
  80182d:	5f                   	pop    %edi
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    
  801830:	39 f2                	cmp    %esi,%edx
  801832:	77 4c                	ja     801880 <__umoddi3+0x80>
  801834:	0f bd ca             	bsr    %edx,%ecx
  801837:	83 f1 1f             	xor    $0x1f,%ecx
  80183a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80183d:	75 51                	jne    801890 <__umoddi3+0x90>
  80183f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801842:	0f 87 e0 00 00 00    	ja     801928 <__umoddi3+0x128>
  801848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184b:	29 f8                	sub    %edi,%eax
  80184d:	19 d6                	sbb    %edx,%esi
  80184f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801855:	89 f2                	mov    %esi,%edx
  801857:	83 c4 20             	add    $0x20,%esp
  80185a:	5e                   	pop    %esi
  80185b:	5f                   	pop    %edi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    
  80185e:	66 90                	xchg   %ax,%ax
  801860:	85 ff                	test   %edi,%edi
  801862:	75 0b                	jne    80186f <__umoddi3+0x6f>
  801864:	b8 01 00 00 00       	mov    $0x1,%eax
  801869:	31 d2                	xor    %edx,%edx
  80186b:	f7 f7                	div    %edi
  80186d:	89 c7                	mov    %eax,%edi
  80186f:	89 f0                	mov    %esi,%eax
  801871:	31 d2                	xor    %edx,%edx
  801873:	f7 f7                	div    %edi
  801875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801878:	f7 f7                	div    %edi
  80187a:	eb a9                	jmp    801825 <__umoddi3+0x25>
  80187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801880:	89 c8                	mov    %ecx,%eax
  801882:	89 f2                	mov    %esi,%edx
  801884:	83 c4 20             	add    $0x20,%esp
  801887:	5e                   	pop    %esi
  801888:	5f                   	pop    %edi
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    
  80188b:	90                   	nop
  80188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801890:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801894:	d3 e2                	shl    %cl,%edx
  801896:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801899:	ba 20 00 00 00       	mov    $0x20,%edx
  80189e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8018a1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8018a4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8018a8:	89 fa                	mov    %edi,%edx
  8018aa:	d3 ea                	shr    %cl,%edx
  8018ac:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018b0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8018b3:	d3 e7                	shl    %cl,%edi
  8018b5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8018b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8018bc:	89 f2                	mov    %esi,%edx
  8018be:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8018c1:	89 c7                	mov    %eax,%edi
  8018c3:	d3 ea                	shr    %cl,%edx
  8018c5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8018cc:	89 c2                	mov    %eax,%edx
  8018ce:	d3 e6                	shl    %cl,%esi
  8018d0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8018d4:	d3 ea                	shr    %cl,%edx
  8018d6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018da:	09 d6                	or     %edx,%esi
  8018dc:	89 f0                	mov    %esi,%eax
  8018de:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8018e1:	d3 e7                	shl    %cl,%edi
  8018e3:	89 f2                	mov    %esi,%edx
  8018e5:	f7 75 f4             	divl   -0xc(%ebp)
  8018e8:	89 d6                	mov    %edx,%esi
  8018ea:	f7 65 e8             	mull   -0x18(%ebp)
  8018ed:	39 d6                	cmp    %edx,%esi
  8018ef:	72 2b                	jb     80191c <__umoddi3+0x11c>
  8018f1:	39 c7                	cmp    %eax,%edi
  8018f3:	72 23                	jb     801918 <__umoddi3+0x118>
  8018f5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018f9:	29 c7                	sub    %eax,%edi
  8018fb:	19 d6                	sbb    %edx,%esi
  8018fd:	89 f0                	mov    %esi,%eax
  8018ff:	89 f2                	mov    %esi,%edx
  801901:	d3 ef                	shr    %cl,%edi
  801903:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801907:	d3 e0                	shl    %cl,%eax
  801909:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80190d:	09 f8                	or     %edi,%eax
  80190f:	d3 ea                	shr    %cl,%edx
  801911:	83 c4 20             	add    $0x20,%esp
  801914:	5e                   	pop    %esi
  801915:	5f                   	pop    %edi
  801916:	5d                   	pop    %ebp
  801917:	c3                   	ret    
  801918:	39 d6                	cmp    %edx,%esi
  80191a:	75 d9                	jne    8018f5 <__umoddi3+0xf5>
  80191c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80191f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801922:	eb d1                	jmp    8018f5 <__umoddi3+0xf5>
  801924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801928:	39 f2                	cmp    %esi,%edx
  80192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801930:	0f 82 12 ff ff ff    	jb     801848 <__umoddi3+0x48>
  801936:	e9 17 ff ff ff       	jmp    801852 <__umoddi3+0x52>
