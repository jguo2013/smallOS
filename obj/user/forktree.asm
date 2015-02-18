
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 ef 00 00 00       	call   800120 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 38             	sub    $0x38,%esp
  80003a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80003d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800040:	8b 75 08             	mov    0x8(%ebp),%esi
  800043:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800047:	89 34 24             	mov    %esi,(%esp)
  80004a:	e8 c1 07 00 00       	call   800810 <strlen>
  80004f:	83 f8 02             	cmp    $0x2,%eax
  800052:	7f 63                	jg     8000b7 <forkchild+0x83>
		return;

	cprintf("curr %s branch %c\n",cur, branch);
  800054:	0f be db             	movsbl %bl,%ebx
  800057:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80005b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80005f:	c7 04 24 e0 17 80 00 	movl   $0x8017e0,(%esp)
  800066:	e8 7a 01 00 00       	call   8001e5 <cprintf>
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  80006f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800073:	c7 44 24 08 f3 17 80 	movl   $0x8017f3,0x8(%esp)
  80007a:	00 
  80007b:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  800082:	00 
  800083:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800086:	89 04 24             	mov    %eax,(%esp)
  800089:	e8 2e 07 00 00       	call   8007bc <snprintf>
	//nxt[strlen(cur)+1] = '\0';

	if (fork() == 0) {
  80008e:	e8 43 10 00 00       	call   8010d6 <fork>
  800093:	85 c0                	test   %eax,%eax
  800095:	75 20                	jne    8000b7 <forkchild+0x83>
		cprintf("child nxt %s\n",nxt);
  800097:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80009a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80009e:	c7 04 24 f8 17 80 00 	movl   $0x8017f8,(%esp)
  8000a5:	e8 3b 01 00 00       	call   8001e5 <cprintf>
		forktree(nxt);
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 0f 00 00 00       	call   8000c1 <forktree>
		exit();
  8000b2:	e8 b9 00 00 00       	call   800170 <exit>
	}
}
  8000b7:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000ba:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000bd:	89 ec                	mov    %ebp,%esp
  8000bf:	5d                   	pop    %ebp
  8000c0:	c3                   	ret    

008000c1 <forktree>:

void
forktree(const char *cur)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	53                   	push   %ebx
  8000c5:	83 ec 14             	sub    $0x14,%esp
  8000c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000cb:	e8 51 0f 00 00       	call   801021 <sys_getenvid>
  8000d0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d8:	c7 04 24 06 18 80 00 	movl   $0x801806,(%esp)
  8000df:	e8 01 01 00 00       	call   8001e5 <cprintf>

	forkchild(cur, '0');
  8000e4:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8000eb:	00 
  8000ec:	89 1c 24             	mov    %ebx,(%esp)
  8000ef:	e8 40 ff ff ff       	call   800034 <forkchild>
	forkchild(cur, '1');
  8000f4:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  8000fb:	00 
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 30 ff ff ff       	call   800034 <forkchild>
}
  800104:	83 c4 14             	add    $0x14,%esp
  800107:	5b                   	pop    %ebx
  800108:	5d                   	pop    %ebp
  800109:	c3                   	ret    

0080010a <umain>:

void
umain(int argc, char **argv)
{
  80010a:	55                   	push   %ebp
  80010b:	89 e5                	mov    %esp,%ebp
  80010d:	83 ec 18             	sub    $0x18,%esp
	forktree("");
  800110:	c7 04 24 16 18 80 00 	movl   $0x801816,(%esp)
  800117:	e8 a5 ff ff ff       	call   8000c1 <forktree>
}
  80011c:	c9                   	leave  
  80011d:	c3                   	ret    
	...

00800120 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	83 ec 18             	sub    $0x18,%esp
  800126:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800129:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80012c:	8b 75 08             	mov    0x8(%ebp),%esi
  80012f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800132:	e8 ea 0e 00 00       	call   801021 <sys_getenvid>
  800137:	25 ff 03 00 00       	and    $0x3ff,%eax
  80013c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80013f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800144:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800149:	85 f6                	test   %esi,%esi
  80014b:	7e 07                	jle    800154 <libmain+0x34>
		binaryname = argv[0];
  80014d:	8b 03                	mov    (%ebx),%eax
  80014f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800154:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800158:	89 34 24             	mov    %esi,(%esp)
  80015b:	e8 aa ff ff ff       	call   80010a <umain>

	// exit gracefully
	exit();
  800160:	e8 0b 00 00 00       	call   800170 <exit>
}
  800165:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800168:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80016b:	89 ec                	mov    %ebp,%esp
  80016d:	5d                   	pop    %ebp
  80016e:	c3                   	ret    
	...

00800170 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800176:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017d:	e8 d3 0e 00 00       	call   801055 <sys_env_destroy>
}
  800182:	c9                   	leave  
  800183:	c3                   	ret    

00800184 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80018d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800194:	00 00 00 
	b.cnt = 0;
  800197:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80019e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001af:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b9:	c7 04 24 ff 01 80 00 	movl   $0x8001ff,(%esp)
  8001c0:	e8 be 01 00 00       	call   800383 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cf:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 23 0a 00 00       	call   800c00 <sys_cputs>

	return b.cnt;
}
  8001dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001e3:	c9                   	leave  
  8001e4:	c3                   	ret    

008001e5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8001eb:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f5:	89 04 24             	mov    %eax,(%esp)
  8001f8:	e8 87 ff ff ff       	call   800184 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	53                   	push   %ebx
  800203:	83 ec 14             	sub    $0x14,%esp
  800206:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800209:	8b 03                	mov    (%ebx),%eax
  80020b:	8b 55 08             	mov    0x8(%ebp),%edx
  80020e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800212:	83 c0 01             	add    $0x1,%eax
  800215:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800217:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021c:	75 19                	jne    800237 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80021e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800225:	00 
  800226:	8d 43 08             	lea    0x8(%ebx),%eax
  800229:	89 04 24             	mov    %eax,(%esp)
  80022c:	e8 cf 09 00 00       	call   800c00 <sys_cputs>
		b->idx = 0;
  800231:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800237:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80023b:	83 c4 14             	add    $0x14,%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5d                   	pop    %ebp
  800240:	c3                   	ret    
  800241:	00 00                	add    %al,(%eax)
	...

00800244 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	57                   	push   %edi
  800248:	56                   	push   %esi
  800249:	53                   	push   %ebx
  80024a:	83 ec 4c             	sub    $0x4c,%esp
  80024d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800250:	89 d6                	mov    %edx,%esi
  800252:	8b 45 08             	mov    0x8(%ebp),%eax
  800255:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80025e:	8b 45 10             	mov    0x10(%ebp),%eax
  800261:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800264:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800267:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80026a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80026f:	39 d1                	cmp    %edx,%ecx
  800271:	72 07                	jb     80027a <printnum+0x36>
  800273:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800276:	39 d0                	cmp    %edx,%eax
  800278:	77 69                	ja     8002e3 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80027e:	83 eb 01             	sub    $0x1,%ebx
  800281:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800285:	89 44 24 08          	mov    %eax,0x8(%esp)
  800289:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  80028d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800291:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800294:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800297:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80029a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80029e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002a5:	00 
  8002a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a9:	89 04 24             	mov    %eax,(%esp)
  8002ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002af:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002b3:	e8 b8 12 00 00       	call   801570 <__udivdi3>
  8002b8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002bb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002be:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002c2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002c6:	89 04 24             	mov    %eax,(%esp)
  8002c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002cd:	89 f2                	mov    %esi,%edx
  8002cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d2:	e8 6d ff ff ff       	call   800244 <printnum>
  8002d7:	eb 11                	jmp    8002ea <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002dd:	89 3c 24             	mov    %edi,(%esp)
  8002e0:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002e3:	83 eb 01             	sub    $0x1,%ebx
  8002e6:	85 db                	test   %ebx,%ebx
  8002e8:	7f ef                	jg     8002d9 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ee:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002f9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800300:	00 
  800301:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800304:	89 14 24             	mov    %edx,(%esp)
  800307:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80030a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80030e:	e8 8d 13 00 00       	call   8016a0 <__umoddi3>
  800313:	89 74 24 04          	mov    %esi,0x4(%esp)
  800317:	0f be 80 21 18 80 00 	movsbl 0x801821(%eax),%eax
  80031e:	89 04 24             	mov    %eax,(%esp)
  800321:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800324:	83 c4 4c             	add    $0x4c,%esp
  800327:	5b                   	pop    %ebx
  800328:	5e                   	pop    %esi
  800329:	5f                   	pop    %edi
  80032a:	5d                   	pop    %ebp
  80032b:	c3                   	ret    

0080032c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80032f:	83 fa 01             	cmp    $0x1,%edx
  800332:	7e 0e                	jle    800342 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800334:	8b 10                	mov    (%eax),%edx
  800336:	8d 4a 08             	lea    0x8(%edx),%ecx
  800339:	89 08                	mov    %ecx,(%eax)
  80033b:	8b 02                	mov    (%edx),%eax
  80033d:	8b 52 04             	mov    0x4(%edx),%edx
  800340:	eb 22                	jmp    800364 <getuint+0x38>
	else if (lflag)
  800342:	85 d2                	test   %edx,%edx
  800344:	74 10                	je     800356 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800346:	8b 10                	mov    (%eax),%edx
  800348:	8d 4a 04             	lea    0x4(%edx),%ecx
  80034b:	89 08                	mov    %ecx,(%eax)
  80034d:	8b 02                	mov    (%edx),%eax
  80034f:	ba 00 00 00 00       	mov    $0x0,%edx
  800354:	eb 0e                	jmp    800364 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800356:	8b 10                	mov    (%eax),%edx
  800358:	8d 4a 04             	lea    0x4(%edx),%ecx
  80035b:	89 08                	mov    %ecx,(%eax)
  80035d:	8b 02                	mov    (%edx),%eax
  80035f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80036c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800370:	8b 10                	mov    (%eax),%edx
  800372:	3b 50 04             	cmp    0x4(%eax),%edx
  800375:	73 0a                	jae    800381 <sprintputch+0x1b>
		*b->buf++ = ch;
  800377:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037a:	88 0a                	mov    %cl,(%edx)
  80037c:	83 c2 01             	add    $0x1,%edx
  80037f:	89 10                	mov    %edx,(%eax)
}
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	57                   	push   %edi
  800387:	56                   	push   %esi
  800388:	53                   	push   %ebx
  800389:	83 ec 4c             	sub    $0x4c,%esp
  80038c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80038f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800392:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800395:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  80039c:	eb 11                	jmp    8003af <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	0f 84 b6 03 00 00    	je     80075c <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8003a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003aa:	89 04 24             	mov    %eax,(%esp)
  8003ad:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003af:	0f b6 03             	movzbl (%ebx),%eax
  8003b2:	83 c3 01             	add    $0x1,%ebx
  8003b5:	83 f8 25             	cmp    $0x25,%eax
  8003b8:	75 e4                	jne    80039e <vprintfmt+0x1b>
  8003ba:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8003be:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003c5:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8003cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003d8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8003db:	eb 06                	jmp    8003e3 <vprintfmt+0x60>
  8003dd:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8003e1:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e3:	0f b6 0b             	movzbl (%ebx),%ecx
  8003e6:	0f b6 c1             	movzbl %cl,%eax
  8003e9:	8d 53 01             	lea    0x1(%ebx),%edx
  8003ec:	83 e9 23             	sub    $0x23,%ecx
  8003ef:	80 f9 55             	cmp    $0x55,%cl
  8003f2:	0f 87 47 03 00 00    	ja     80073f <vprintfmt+0x3bc>
  8003f8:	0f b6 c9             	movzbl %cl,%ecx
  8003fb:	ff 24 8d 60 19 80 00 	jmp    *0x801960(,%ecx,4)
  800402:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800406:	eb d9                	jmp    8003e1 <vprintfmt+0x5e>
  800408:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80040f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800414:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800417:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80041b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80041e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800421:	83 fb 09             	cmp    $0x9,%ebx
  800424:	77 30                	ja     800456 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800426:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800429:	eb e9                	jmp    800414 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8d 48 04             	lea    0x4(%eax),%ecx
  800431:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800434:	8b 00                	mov    (%eax),%eax
  800436:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800439:	eb 1e                	jmp    800459 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80043b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80043f:	b8 00 00 00 00       	mov    $0x0,%eax
  800444:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800448:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044b:	eb 94                	jmp    8003e1 <vprintfmt+0x5e>
  80044d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800454:	eb 8b                	jmp    8003e1 <vprintfmt+0x5e>
  800456:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800459:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80045d:	79 82                	jns    8003e1 <vprintfmt+0x5e>
  80045f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800465:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800468:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80046b:	e9 71 ff ff ff       	jmp    8003e1 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800470:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800474:	e9 68 ff ff ff       	jmp    8003e1 <vprintfmt+0x5e>
  800479:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 50 04             	lea    0x4(%eax),%edx
  800482:	89 55 14             	mov    %edx,0x14(%ebp)
  800485:	89 74 24 04          	mov    %esi,0x4(%esp)
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	89 04 24             	mov    %eax,(%esp)
  80048e:	ff d7                	call   *%edi
  800490:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800493:	e9 17 ff ff ff       	jmp    8003af <vprintfmt+0x2c>
  800498:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80049b:	8b 45 14             	mov    0x14(%ebp),%eax
  80049e:	8d 50 04             	lea    0x4(%eax),%edx
  8004a1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 c2                	mov    %eax,%edx
  8004a8:	c1 fa 1f             	sar    $0x1f,%edx
  8004ab:	31 d0                	xor    %edx,%eax
  8004ad:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004af:	83 f8 11             	cmp    $0x11,%eax
  8004b2:	7f 0b                	jg     8004bf <vprintfmt+0x13c>
  8004b4:	8b 14 85 c0 1a 80 00 	mov    0x801ac0(,%eax,4),%edx
  8004bb:	85 d2                	test   %edx,%edx
  8004bd:	75 20                	jne    8004df <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8004bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004c3:	c7 44 24 08 32 18 80 	movl   $0x801832,0x8(%esp)
  8004ca:	00 
  8004cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004cf:	89 3c 24             	mov    %edi,(%esp)
  8004d2:	e8 0d 03 00 00       	call   8007e4 <printfmt>
  8004d7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004da:	e9 d0 fe ff ff       	jmp    8003af <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8004df:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004e3:	c7 44 24 08 3b 18 80 	movl   $0x80183b,0x8(%esp)
  8004ea:	00 
  8004eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ef:	89 3c 24             	mov    %edi,(%esp)
  8004f2:	e8 ed 02 00 00       	call   8007e4 <printfmt>
  8004f7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8004fa:	e9 b0 fe ff ff       	jmp    8003af <vprintfmt+0x2c>
  8004ff:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800502:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800508:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 50 04             	lea    0x4(%eax),%edx
  800511:	89 55 14             	mov    %edx,0x14(%ebp)
  800514:	8b 18                	mov    (%eax),%ebx
  800516:	85 db                	test   %ebx,%ebx
  800518:	b8 3e 18 80 00       	mov    $0x80183e,%eax
  80051d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800520:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800524:	7e 76                	jle    80059c <vprintfmt+0x219>
  800526:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80052a:	74 7a                	je     8005a6 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800530:	89 1c 24             	mov    %ebx,(%esp)
  800533:	e8 f0 02 00 00       	call   800828 <strnlen>
  800538:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80053b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  80053d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800541:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800544:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800547:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800549:	eb 0f                	jmp    80055a <vprintfmt+0x1d7>
					putch(padc, putdat);
  80054b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80054f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800552:	89 04 24             	mov    %eax,(%esp)
  800555:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800557:	83 eb 01             	sub    $0x1,%ebx
  80055a:	85 db                	test   %ebx,%ebx
  80055c:	7f ed                	jg     80054b <vprintfmt+0x1c8>
  80055e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800561:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800564:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800567:	89 f7                	mov    %esi,%edi
  800569:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80056c:	eb 40                	jmp    8005ae <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80056e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800572:	74 18                	je     80058c <vprintfmt+0x209>
  800574:	8d 50 e0             	lea    -0x20(%eax),%edx
  800577:	83 fa 5e             	cmp    $0x5e,%edx
  80057a:	76 10                	jbe    80058c <vprintfmt+0x209>
					putch('?', putdat);
  80057c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800580:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800587:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80058a:	eb 0a                	jmp    800596 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  80058c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800590:	89 04 24             	mov    %eax,(%esp)
  800593:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800596:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80059a:	eb 12                	jmp    8005ae <vprintfmt+0x22b>
  80059c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80059f:	89 f7                	mov    %esi,%edi
  8005a1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005a4:	eb 08                	jmp    8005ae <vprintfmt+0x22b>
  8005a6:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005a9:	89 f7                	mov    %esi,%edi
  8005ab:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005ae:	0f be 03             	movsbl (%ebx),%eax
  8005b1:	83 c3 01             	add    $0x1,%ebx
  8005b4:	85 c0                	test   %eax,%eax
  8005b6:	74 25                	je     8005dd <vprintfmt+0x25a>
  8005b8:	85 f6                	test   %esi,%esi
  8005ba:	78 b2                	js     80056e <vprintfmt+0x1eb>
  8005bc:	83 ee 01             	sub    $0x1,%esi
  8005bf:	79 ad                	jns    80056e <vprintfmt+0x1eb>
  8005c1:	89 fe                	mov    %edi,%esi
  8005c3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005c6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005c9:	eb 1a                	jmp    8005e5 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005d6:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d8:	83 eb 01             	sub    $0x1,%ebx
  8005db:	eb 08                	jmp    8005e5 <vprintfmt+0x262>
  8005dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005e0:	89 fe                	mov    %edi,%esi
  8005e2:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005e5:	85 db                	test   %ebx,%ebx
  8005e7:	7f e2                	jg     8005cb <vprintfmt+0x248>
  8005e9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005ec:	e9 be fd ff ff       	jmp    8003af <vprintfmt+0x2c>
  8005f1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005f4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005f7:	83 f9 01             	cmp    $0x1,%ecx
  8005fa:	7e 16                	jle    800612 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8d 50 08             	lea    0x8(%eax),%edx
  800602:	89 55 14             	mov    %edx,0x14(%ebp)
  800605:	8b 10                	mov    (%eax),%edx
  800607:	8b 48 04             	mov    0x4(%eax),%ecx
  80060a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  80060d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800610:	eb 32                	jmp    800644 <vprintfmt+0x2c1>
	else if (lflag)
  800612:	85 c9                	test   %ecx,%ecx
  800614:	74 18                	je     80062e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8d 50 04             	lea    0x4(%eax),%edx
  80061c:	89 55 14             	mov    %edx,0x14(%ebp)
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800624:	89 c1                	mov    %eax,%ecx
  800626:	c1 f9 1f             	sar    $0x1f,%ecx
  800629:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80062c:	eb 16                	jmp    800644 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 50 04             	lea    0x4(%eax),%edx
  800634:	89 55 14             	mov    %edx,0x14(%ebp)
  800637:	8b 00                	mov    (%eax),%eax
  800639:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063c:	89 c2                	mov    %eax,%edx
  80063e:	c1 fa 1f             	sar    $0x1f,%edx
  800641:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800644:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800647:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80064a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80064f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800653:	0f 89 a7 00 00 00    	jns    800700 <vprintfmt+0x37d>
				putch('-', putdat);
  800659:	89 74 24 04          	mov    %esi,0x4(%esp)
  80065d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800664:	ff d7                	call   *%edi
				num = -(long long) num;
  800666:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800669:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80066c:	f7 d9                	neg    %ecx
  80066e:	83 d3 00             	adc    $0x0,%ebx
  800671:	f7 db                	neg    %ebx
  800673:	b8 0a 00 00 00       	mov    $0xa,%eax
  800678:	e9 83 00 00 00       	jmp    800700 <vprintfmt+0x37d>
  80067d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800680:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800683:	89 ca                	mov    %ecx,%edx
  800685:	8d 45 14             	lea    0x14(%ebp),%eax
  800688:	e8 9f fc ff ff       	call   80032c <getuint>
  80068d:	89 c1                	mov    %eax,%ecx
  80068f:	89 d3                	mov    %edx,%ebx
  800691:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800696:	eb 68                	jmp    800700 <vprintfmt+0x37d>
  800698:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80069b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80069e:	89 ca                	mov    %ecx,%edx
  8006a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a3:	e8 84 fc ff ff       	call   80032c <getuint>
  8006a8:	89 c1                	mov    %eax,%ecx
  8006aa:	89 d3                	mov    %edx,%ebx
  8006ac:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8006b1:	eb 4d                	jmp    800700 <vprintfmt+0x37d>
  8006b3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8006b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ba:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006c1:	ff d7                	call   *%edi
			putch('x', putdat);
  8006c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006ce:	ff d7                	call   *%edi
			num = (unsigned long long)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d9:	8b 08                	mov    (%eax),%ecx
  8006db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006e5:	eb 19                	jmp    800700 <vprintfmt+0x37d>
  8006e7:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006ea:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006ed:	89 ca                	mov    %ecx,%edx
  8006ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f2:	e8 35 fc ff ff       	call   80032c <getuint>
  8006f7:	89 c1                	mov    %eax,%ecx
  8006f9:	89 d3                	mov    %edx,%ebx
  8006fb:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800700:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800704:	89 54 24 10          	mov    %edx,0x10(%esp)
  800708:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80070b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80070f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800713:	89 0c 24             	mov    %ecx,(%esp)
  800716:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80071a:	89 f2                	mov    %esi,%edx
  80071c:	89 f8                	mov    %edi,%eax
  80071e:	e8 21 fb ff ff       	call   800244 <printnum>
  800723:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800726:	e9 84 fc ff ff       	jmp    8003af <vprintfmt+0x2c>
  80072b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80072e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800732:	89 04 24             	mov    %eax,(%esp)
  800735:	ff d7                	call   *%edi
  800737:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80073a:	e9 70 fc ff ff       	jmp    8003af <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80073f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800743:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80074a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80074c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80074f:	80 38 25             	cmpb   $0x25,(%eax)
  800752:	0f 84 57 fc ff ff    	je     8003af <vprintfmt+0x2c>
  800758:	89 c3                	mov    %eax,%ebx
  80075a:	eb f0                	jmp    80074c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  80075c:	83 c4 4c             	add    $0x4c,%esp
  80075f:	5b                   	pop    %ebx
  800760:	5e                   	pop    %esi
  800761:	5f                   	pop    %edi
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	83 ec 28             	sub    $0x28,%esp
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800770:	85 c0                	test   %eax,%eax
  800772:	74 04                	je     800778 <vsnprintf+0x14>
  800774:	85 d2                	test   %edx,%edx
  800776:	7f 07                	jg     80077f <vsnprintf+0x1b>
  800778:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80077d:	eb 3b                	jmp    8007ba <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80077f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800782:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800786:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800789:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a5:	c7 04 24 66 03 80 00 	movl   $0x800366,(%esp)
  8007ac:	e8 d2 fb ff ff       	call   800383 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8007c2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8007c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	89 04 24             	mov    %eax,(%esp)
  8007dd:	e8 82 ff ff ff       	call   800764 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    

008007e4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8007ea:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8007ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	89 04 24             	mov    %eax,(%esp)
  800805:	e8 79 fb ff ff       	call   800383 <vprintfmt>
	va_end(ap);
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    
  80080c:	00 00                	add    %al,(%eax)
	...

00800810 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	8b 55 08             	mov    0x8(%ebp),%edx
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80081b:	eb 03                	jmp    800820 <strlen+0x10>
		n++;
  80081d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800820:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800824:	75 f7                	jne    80081d <strlen+0xd>
		n++;
	return n;
}
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	53                   	push   %ebx
  80082c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80082f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800832:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800837:	eb 03                	jmp    80083c <strnlen+0x14>
		n++;
  800839:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083c:	39 c1                	cmp    %eax,%ecx
  80083e:	74 06                	je     800846 <strnlen+0x1e>
  800840:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800844:	75 f3                	jne    800839 <strnlen+0x11>
		n++;
	return n;
}
  800846:	5b                   	pop    %ebx
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	53                   	push   %ebx
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800853:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800858:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80085c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80085f:	83 c2 01             	add    $0x1,%edx
  800862:	84 c9                	test   %cl,%cl
  800864:	75 f2                	jne    800858 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800866:	5b                   	pop    %ebx
  800867:	5d                   	pop    %ebp
  800868:	c3                   	ret    

00800869 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	53                   	push   %ebx
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800873:	89 1c 24             	mov    %ebx,(%esp)
  800876:	e8 95 ff ff ff       	call   800810 <strlen>
	strcpy(dst + len, src);
  80087b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800882:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800885:	89 04 24             	mov    %eax,(%esp)
  800888:	e8 bc ff ff ff       	call   800849 <strcpy>
	return dst;
}
  80088d:	89 d8                	mov    %ebx,%eax
  80088f:	83 c4 08             	add    $0x8,%esp
  800892:	5b                   	pop    %ebx
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	56                   	push   %esi
  800899:	53                   	push   %ebx
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a0:	8b 75 10             	mov    0x10(%ebp),%esi
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a8:	eb 0f                	jmp    8008b9 <strncpy+0x24>
		*dst++ = *src;
  8008aa:	0f b6 19             	movzbl (%ecx),%ebx
  8008ad:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b0:	80 39 01             	cmpb   $0x1,(%ecx)
  8008b3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b6:	83 c2 01             	add    $0x1,%edx
  8008b9:	39 f2                	cmp    %esi,%edx
  8008bb:	72 ed                	jb     8008aa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008bd:	5b                   	pop    %ebx
  8008be:	5e                   	pop    %esi
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	56                   	push   %esi
  8008c5:	53                   	push   %ebx
  8008c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	85 d2                	test   %edx,%edx
  8008d3:	75 0a                	jne    8008df <strlcpy+0x1e>
  8008d5:	eb 17                	jmp    8008ee <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008d7:	88 18                	mov    %bl,(%eax)
  8008d9:	83 c0 01             	add    $0x1,%eax
  8008dc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008df:	83 ea 01             	sub    $0x1,%edx
  8008e2:	74 07                	je     8008eb <strlcpy+0x2a>
  8008e4:	0f b6 19             	movzbl (%ecx),%ebx
  8008e7:	84 db                	test   %bl,%bl
  8008e9:	75 ec                	jne    8008d7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  8008eb:	c6 00 00             	movb   $0x0,(%eax)
  8008ee:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008fd:	eb 06                	jmp    800905 <strcmp+0x11>
		p++, q++;
  8008ff:	83 c1 01             	add    $0x1,%ecx
  800902:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800905:	0f b6 01             	movzbl (%ecx),%eax
  800908:	84 c0                	test   %al,%al
  80090a:	74 04                	je     800910 <strcmp+0x1c>
  80090c:	3a 02                	cmp    (%edx),%al
  80090e:	74 ef                	je     8008ff <strcmp+0xb>
  800910:	0f b6 c0             	movzbl %al,%eax
  800913:	0f b6 12             	movzbl (%edx),%edx
  800916:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800924:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800927:	eb 09                	jmp    800932 <strncmp+0x18>
		n--, p++, q++;
  800929:	83 ea 01             	sub    $0x1,%edx
  80092c:	83 c0 01             	add    $0x1,%eax
  80092f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800932:	85 d2                	test   %edx,%edx
  800934:	75 07                	jne    80093d <strncmp+0x23>
  800936:	b8 00 00 00 00       	mov    $0x0,%eax
  80093b:	eb 13                	jmp    800950 <strncmp+0x36>
  80093d:	0f b6 18             	movzbl (%eax),%ebx
  800940:	84 db                	test   %bl,%bl
  800942:	74 04                	je     800948 <strncmp+0x2e>
  800944:	3a 19                	cmp    (%ecx),%bl
  800946:	74 e1                	je     800929 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800948:	0f b6 00             	movzbl (%eax),%eax
  80094b:	0f b6 11             	movzbl (%ecx),%edx
  80094e:	29 d0                	sub    %edx,%eax
}
  800950:	5b                   	pop    %ebx
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095d:	eb 07                	jmp    800966 <strchr+0x13>
		if (*s == c)
  80095f:	38 ca                	cmp    %cl,%dl
  800961:	74 0f                	je     800972 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800963:	83 c0 01             	add    $0x1,%eax
  800966:	0f b6 10             	movzbl (%eax),%edx
  800969:	84 d2                	test   %dl,%dl
  80096b:	75 f2                	jne    80095f <strchr+0xc>
  80096d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097e:	eb 07                	jmp    800987 <strfind+0x13>
		if (*s == c)
  800980:	38 ca                	cmp    %cl,%dl
  800982:	74 0a                	je     80098e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800984:	83 c0 01             	add    $0x1,%eax
  800987:	0f b6 10             	movzbl (%eax),%edx
  80098a:	84 d2                	test   %dl,%dl
  80098c:	75 f2                	jne    800980 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	83 ec 0c             	sub    $0xc,%esp
  800996:	89 1c 24             	mov    %ebx,(%esp)
  800999:	89 74 24 04          	mov    %esi,0x4(%esp)
  80099d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009aa:	85 c9                	test   %ecx,%ecx
  8009ac:	74 30                	je     8009de <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ae:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009b4:	75 25                	jne    8009db <memset+0x4b>
  8009b6:	f6 c1 03             	test   $0x3,%cl
  8009b9:	75 20                	jne    8009db <memset+0x4b>
		c &= 0xFF;
  8009bb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009be:	89 d3                	mov    %edx,%ebx
  8009c0:	c1 e3 08             	shl    $0x8,%ebx
  8009c3:	89 d6                	mov    %edx,%esi
  8009c5:	c1 e6 18             	shl    $0x18,%esi
  8009c8:	89 d0                	mov    %edx,%eax
  8009ca:	c1 e0 10             	shl    $0x10,%eax
  8009cd:	09 f0                	or     %esi,%eax
  8009cf:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  8009d1:	09 d8                	or     %ebx,%eax
  8009d3:	c1 e9 02             	shr    $0x2,%ecx
  8009d6:	fc                   	cld    
  8009d7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d9:	eb 03                	jmp    8009de <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009db:	fc                   	cld    
  8009dc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009de:	89 f8                	mov    %edi,%eax
  8009e0:	8b 1c 24             	mov    (%esp),%ebx
  8009e3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009e7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009eb:	89 ec                	mov    %ebp,%esp
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	89 34 24             	mov    %esi,(%esp)
  8009f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800a02:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a05:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a07:	39 c6                	cmp    %eax,%esi
  800a09:	73 35                	jae    800a40 <memmove+0x51>
  800a0b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a0e:	39 d0                	cmp    %edx,%eax
  800a10:	73 2e                	jae    800a40 <memmove+0x51>
		s += n;
		d += n;
  800a12:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a14:	f6 c2 03             	test   $0x3,%dl
  800a17:	75 1b                	jne    800a34 <memmove+0x45>
  800a19:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a1f:	75 13                	jne    800a34 <memmove+0x45>
  800a21:	f6 c1 03             	test   $0x3,%cl
  800a24:	75 0e                	jne    800a34 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a26:	83 ef 04             	sub    $0x4,%edi
  800a29:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a2c:	c1 e9 02             	shr    $0x2,%ecx
  800a2f:	fd                   	std    
  800a30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a32:	eb 09                	jmp    800a3d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a34:	83 ef 01             	sub    $0x1,%edi
  800a37:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a3a:	fd                   	std    
  800a3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a3d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a3e:	eb 20                	jmp    800a60 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a40:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a46:	75 15                	jne    800a5d <memmove+0x6e>
  800a48:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4e:	75 0d                	jne    800a5d <memmove+0x6e>
  800a50:	f6 c1 03             	test   $0x3,%cl
  800a53:	75 08                	jne    800a5d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a55:	c1 e9 02             	shr    $0x2,%ecx
  800a58:	fc                   	cld    
  800a59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5b:	eb 03                	jmp    800a60 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a5d:	fc                   	cld    
  800a5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a60:	8b 34 24             	mov    (%esp),%esi
  800a63:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a67:	89 ec                	mov    %ebp,%esp
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a71:	8b 45 10             	mov    0x10(%ebp),%eax
  800a74:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	89 04 24             	mov    %eax,(%esp)
  800a85:	e8 65 ff ff ff       	call   8009ef <memmove>
}
  800a8a:	c9                   	leave  
  800a8b:	c3                   	ret    

00800a8c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	57                   	push   %edi
  800a90:	56                   	push   %esi
  800a91:	53                   	push   %ebx
  800a92:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a9b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa0:	eb 1c                	jmp    800abe <memcmp+0x32>
		if (*s1 != *s2)
  800aa2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800aa6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800aaa:	83 c2 01             	add    $0x1,%edx
  800aad:	83 e9 01             	sub    $0x1,%ecx
  800ab0:	38 d8                	cmp    %bl,%al
  800ab2:	74 0a                	je     800abe <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800ab4:	0f b6 c0             	movzbl %al,%eax
  800ab7:	0f b6 db             	movzbl %bl,%ebx
  800aba:	29 d8                	sub    %ebx,%eax
  800abc:	eb 09                	jmp    800ac7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abe:	85 c9                	test   %ecx,%ecx
  800ac0:	75 e0                	jne    800aa2 <memcmp+0x16>
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800ac7:	5b                   	pop    %ebx
  800ac8:	5e                   	pop    %esi
  800ac9:	5f                   	pop    %edi
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ada:	eb 07                	jmp    800ae3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800adc:	38 08                	cmp    %cl,(%eax)
  800ade:	74 07                	je     800ae7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ae0:	83 c0 01             	add    $0x1,%eax
  800ae3:	39 d0                	cmp    %edx,%eax
  800ae5:	72 f5                	jb     800adc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	57                   	push   %edi
  800aed:	56                   	push   %esi
  800aee:	53                   	push   %ebx
  800aef:	83 ec 04             	sub    $0x4,%esp
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
  800af5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af8:	eb 03                	jmp    800afd <strtol+0x14>
		s++;
  800afa:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800afd:	0f b6 02             	movzbl (%edx),%eax
  800b00:	3c 20                	cmp    $0x20,%al
  800b02:	74 f6                	je     800afa <strtol+0x11>
  800b04:	3c 09                	cmp    $0x9,%al
  800b06:	74 f2                	je     800afa <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b08:	3c 2b                	cmp    $0x2b,%al
  800b0a:	75 0c                	jne    800b18 <strtol+0x2f>
		s++;
  800b0c:	8d 52 01             	lea    0x1(%edx),%edx
  800b0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b16:	eb 15                	jmp    800b2d <strtol+0x44>
	else if (*s == '-')
  800b18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b1f:	3c 2d                	cmp    $0x2d,%al
  800b21:	75 0a                	jne    800b2d <strtol+0x44>
		s++, neg = 1;
  800b23:	8d 52 01             	lea    0x1(%edx),%edx
  800b26:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2d:	85 db                	test   %ebx,%ebx
  800b2f:	0f 94 c0             	sete   %al
  800b32:	74 05                	je     800b39 <strtol+0x50>
  800b34:	83 fb 10             	cmp    $0x10,%ebx
  800b37:	75 15                	jne    800b4e <strtol+0x65>
  800b39:	80 3a 30             	cmpb   $0x30,(%edx)
  800b3c:	75 10                	jne    800b4e <strtol+0x65>
  800b3e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b42:	75 0a                	jne    800b4e <strtol+0x65>
		s += 2, base = 16;
  800b44:	83 c2 02             	add    $0x2,%edx
  800b47:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4c:	eb 13                	jmp    800b61 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b4e:	84 c0                	test   %al,%al
  800b50:	74 0f                	je     800b61 <strtol+0x78>
  800b52:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b57:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5a:	75 05                	jne    800b61 <strtol+0x78>
		s++, base = 8;
  800b5c:	83 c2 01             	add    $0x1,%edx
  800b5f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
  800b66:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b68:	0f b6 0a             	movzbl (%edx),%ecx
  800b6b:	89 cf                	mov    %ecx,%edi
  800b6d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b70:	80 fb 09             	cmp    $0x9,%bl
  800b73:	77 08                	ja     800b7d <strtol+0x94>
			dig = *s - '0';
  800b75:	0f be c9             	movsbl %cl,%ecx
  800b78:	83 e9 30             	sub    $0x30,%ecx
  800b7b:	eb 1e                	jmp    800b9b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800b7d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b80:	80 fb 19             	cmp    $0x19,%bl
  800b83:	77 08                	ja     800b8d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800b85:	0f be c9             	movsbl %cl,%ecx
  800b88:	83 e9 57             	sub    $0x57,%ecx
  800b8b:	eb 0e                	jmp    800b9b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800b8d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b90:	80 fb 19             	cmp    $0x19,%bl
  800b93:	77 15                	ja     800baa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b95:	0f be c9             	movsbl %cl,%ecx
  800b98:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b9b:	39 f1                	cmp    %esi,%ecx
  800b9d:	7d 0b                	jge    800baa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b9f:	83 c2 01             	add    $0x1,%edx
  800ba2:	0f af c6             	imul   %esi,%eax
  800ba5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ba8:	eb be                	jmp    800b68 <strtol+0x7f>
  800baa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	74 05                	je     800bb7 <strtol+0xce>
		*endptr = (char *) s;
  800bb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bb5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800bb7:	89 ca                	mov    %ecx,%edx
  800bb9:	f7 da                	neg    %edx
  800bbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bbf:	0f 45 c2             	cmovne %edx,%eax
}
  800bc2:	83 c4 04             	add    $0x4,%esp
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    
	...

00800bcc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	83 ec 0c             	sub    $0xc,%esp
  800bd2:	89 1c 24             	mov    %ebx,(%esp)
  800bd5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bd9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800be2:	b8 01 00 00 00       	mov    $0x1,%eax
  800be7:	89 d1                	mov    %edx,%ecx
  800be9:	89 d3                	mov    %edx,%ebx
  800beb:	89 d7                	mov    %edx,%edi
  800bed:	89 d6                	mov    %edx,%esi
  800bef:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf1:	8b 1c 24             	mov    (%esp),%ebx
  800bf4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bf8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bfc:	89 ec                	mov    %ebp,%esp
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	89 1c 24             	mov    %ebx,(%esp)
  800c09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c0d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c11:	b8 00 00 00 00       	mov    $0x0,%eax
  800c16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1c:	89 c3                	mov    %eax,%ebx
  800c1e:	89 c7                	mov    %eax,%edi
  800c20:	89 c6                	mov    %eax,%esi
  800c22:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c24:	8b 1c 24             	mov    (%esp),%ebx
  800c27:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c2b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c2f:	89 ec                	mov    %ebp,%esp
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 0c             	sub    $0xc,%esp
  800c39:	89 1c 24             	mov    %ebx,(%esp)
  800c3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c40:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c44:	ba 00 00 00 00       	mov    $0x0,%edx
  800c49:	b8 10 00 00 00       	mov    $0x10,%eax
  800c4e:	89 d1                	mov    %edx,%ecx
  800c50:	89 d3                	mov    %edx,%ebx
  800c52:	89 d7                	mov    %edx,%edi
  800c54:	89 d6                	mov    %edx,%esi
  800c56:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800c58:	8b 1c 24             	mov    (%esp),%ebx
  800c5b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c5f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c63:	89 ec                	mov    %ebp,%esp
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 38             	sub    $0x38,%esp
  800c6d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c70:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c73:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800c80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c83:	8b 55 08             	mov    0x8(%ebp),%edx
  800c86:	89 df                	mov    %ebx,%edi
  800c88:	89 de                	mov    %ebx,%esi
  800c8a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c8c:	85 c0                	test   %eax,%eax
  800c8e:	7e 28                	jle    800cb8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c90:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c94:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800c9b:	00 
  800c9c:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800ca3:	00 
  800ca4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cab:	00 
  800cac:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800cb3:	e8 b4 07 00 00       	call   80146c <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800cb8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cbb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cbe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cc1:	89 ec                	mov    %ebp,%esp
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 38             	sub    $0x38,%esp
  800ccb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cce:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cd1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	89 df                	mov    %ebx,%edi
  800ce6:	89 de                	mov    %ebx,%esi
  800ce8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cea:	85 c0                	test   %eax,%eax
  800cec:	7e 28                	jle    800d16 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cee:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cf2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800cf9:	00 
  800cfa:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800d01:	00 
  800d02:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d09:	00 
  800d0a:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800d11:	e8 56 07 00 00       	call   80146c <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800d16:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d19:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d1c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d1f:	89 ec                	mov    %ebp,%esp
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 38             	sub    $0x38,%esp
  800d29:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d2c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d2f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d37:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3f:	89 cb                	mov    %ecx,%ebx
  800d41:	89 cf                	mov    %ecx,%edi
  800d43:	89 ce                	mov    %ecx,%esi
  800d45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	7e 28                	jle    800d73 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d4f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800d56:	00 
  800d57:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800d5e:	00 
  800d5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d66:	00 
  800d67:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800d6e:	e8 f9 06 00 00       	call   80146c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d73:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d76:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d79:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d7c:	89 ec                	mov    %ebp,%esp
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	89 1c 24             	mov    %ebx,(%esp)
  800d89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d91:	be 00 00 00 00       	mov    $0x0,%esi
  800d96:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d9b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da9:	8b 1c 24             	mov    (%esp),%ebx
  800dac:	8b 74 24 04          	mov    0x4(%esp),%esi
  800db0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800db4:	89 ec                	mov    %ebp,%esp
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 38             	sub    $0x38,%esp
  800dbe:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dc1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dc4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	89 df                	mov    %ebx,%edi
  800dd9:	89 de                	mov    %ebx,%esi
  800ddb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ddd:	85 c0                	test   %eax,%eax
  800ddf:	7e 28                	jle    800e09 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800dec:	00 
  800ded:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800df4:	00 
  800df5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfc:	00 
  800dfd:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800e04:	e8 63 06 00 00       	call   80146c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e09:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e0c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e0f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e12:	89 ec                	mov    %ebp,%esp
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 38             	sub    $0x38,%esp
  800e1c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e1f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e22:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	89 df                	mov    %ebx,%edi
  800e37:	89 de                	mov    %ebx,%esi
  800e39:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	7e 28                	jle    800e67 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e43:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e4a:	00 
  800e4b:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800e52:	00 
  800e53:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e5a:	00 
  800e5b:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800e62:	e8 05 06 00 00       	call   80146c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e67:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e6a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e6d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e70:	89 ec                	mov    %ebp,%esp
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	83 ec 38             	sub    $0x38,%esp
  800e7a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e7d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e80:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e88:	b8 08 00 00 00       	mov    $0x8,%eax
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e90:	8b 55 08             	mov    0x8(%ebp),%edx
  800e93:	89 df                	mov    %ebx,%edi
  800e95:	89 de                	mov    %ebx,%esi
  800e97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7e 28                	jle    800ec5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ea8:	00 
  800ea9:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb8:	00 
  800eb9:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800ec0:	e8 a7 05 00 00       	call   80146c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ec5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ecb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ece:	89 ec                	mov    %ebp,%esp
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    

00800ed2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 38             	sub    $0x38,%esp
  800ed8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800edb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ede:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee6:	b8 06 00 00 00       	mov    $0x6,%eax
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef1:	89 df                	mov    %ebx,%edi
  800ef3:	89 de                	mov    %ebx,%esi
  800ef5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7e 28                	jle    800f23 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eff:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f06:	00 
  800f07:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800f0e:	00 
  800f0f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f16:	00 
  800f17:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800f1e:	e8 49 05 00 00       	call   80146c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f23:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f26:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f29:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f2c:	89 ec                	mov    %ebp,%esp
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 38             	sub    $0x38,%esp
  800f36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f44:	8b 75 18             	mov    0x18(%ebp),%esi
  800f47:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f55:	85 c0                	test   %eax,%eax
  800f57:	7e 28                	jle    800f81 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f59:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f64:	00 
  800f65:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800f6c:	00 
  800f6d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f74:	00 
  800f75:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800f7c:	e8 eb 04 00 00       	call   80146c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f81:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f84:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f87:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f8a:	89 ec                	mov    %ebp,%esp
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    

00800f8e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 38             	sub    $0x38,%esp
  800f94:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f97:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f9a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9d:	be 00 00 00 00       	mov    $0x0,%esi
  800fa2:	b8 04 00 00 00       	mov    $0x4,%eax
  800fa7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fad:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb0:	89 f7                	mov    %esi,%edi
  800fb2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7e 28                	jle    800fe0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fc3:	00 
  800fc4:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  800fcb:	00 
  800fcc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd3:	00 
  800fd4:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  800fdb:	e8 8c 04 00 00       	call   80146c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fe0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe9:	89 ec                	mov    %ebp,%esp
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    

00800fed <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 0c             	sub    $0xc,%esp
  800ff3:	89 1c 24             	mov    %ebx,(%esp)
  800ff6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ffa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffe:	ba 00 00 00 00       	mov    $0x0,%edx
  801003:	b8 0b 00 00 00       	mov    $0xb,%eax
  801008:	89 d1                	mov    %edx,%ecx
  80100a:	89 d3                	mov    %edx,%ebx
  80100c:	89 d7                	mov    %edx,%edi
  80100e:	89 d6                	mov    %edx,%esi
  801010:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801012:	8b 1c 24             	mov    (%esp),%ebx
  801015:	8b 74 24 04          	mov    0x4(%esp),%esi
  801019:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80101d:	89 ec                	mov    %ebp,%esp
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 0c             	sub    $0xc,%esp
  801027:	89 1c 24             	mov    %ebx,(%esp)
  80102a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80102e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801032:	ba 00 00 00 00       	mov    $0x0,%edx
  801037:	b8 02 00 00 00       	mov    $0x2,%eax
  80103c:	89 d1                	mov    %edx,%ecx
  80103e:	89 d3                	mov    %edx,%ebx
  801040:	89 d7                	mov    %edx,%edi
  801042:	89 d6                	mov    %edx,%esi
  801044:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801046:	8b 1c 24             	mov    (%esp),%ebx
  801049:	8b 74 24 04          	mov    0x4(%esp),%esi
  80104d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801051:	89 ec                	mov    %ebp,%esp
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	83 ec 38             	sub    $0x38,%esp
  80105b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80105e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801061:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801064:	b9 00 00 00 00       	mov    $0x0,%ecx
  801069:	b8 03 00 00 00       	mov    $0x3,%eax
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	89 cb                	mov    %ecx,%ebx
  801073:	89 cf                	mov    %ecx,%edi
  801075:	89 ce                	mov    %ecx,%esi
  801077:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801079:	85 c0                	test   %eax,%eax
  80107b:	7e 28                	jle    8010a5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801081:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801088:	00 
  801089:	c7 44 24 08 27 1b 80 	movl   $0x801b27,0x8(%esp)
  801090:	00 
  801091:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801098:	00 
  801099:	c7 04 24 44 1b 80 00 	movl   $0x801b44,(%esp)
  8010a0:	e8 c7 03 00 00       	call   80146c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010a5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ae:	89 ec                	mov    %ebp,%esp
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
	...

008010b4 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8010ba:	c7 44 24 08 52 1b 80 	movl   $0x801b52,0x8(%esp)
  8010c1:	00 
  8010c2:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  8010c9:	00 
  8010ca:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  8010d1:	e8 96 03 00 00       	call   80146c <_panic>

008010d6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	57                   	push   %edi
  8010da:	56                   	push   %esi
  8010db:	53                   	push   %ebx
  8010dc:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  8010df:	c7 04 24 44 13 80 00 	movl   $0x801344,(%esp)
  8010e6:	e8 d9 03 00 00       	call   8014c4 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8010eb:	ba 07 00 00 00       	mov    $0x7,%edx
  8010f0:	89 d0                	mov    %edx,%eax
  8010f2:	cd 30                	int    $0x30
  8010f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	79 20                	jns    80111b <fork+0x45>
		panic("sys_exofork: %e", envid);
  8010fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010ff:	c7 44 24 08 73 1b 80 	movl   $0x801b73,0x8(%esp)
  801106:	00 
  801107:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80110e:	00 
  80110f:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  801116:	e8 51 03 00 00       	call   80146c <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  80111b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801122:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801127:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80112b:	75 21                	jne    80114e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80112d:	e8 ef fe ff ff       	call   801021 <sys_getenvid>
  801132:	25 ff 03 00 00       	and    $0x3ff,%eax
  801137:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80113a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80113f:	a3 04 20 80 00       	mov    %eax,0x802004
  801144:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801149:	e9 e5 01 00 00       	jmp    801333 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80114e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801151:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801158:	a8 01                	test   $0x1,%al
  80115a:	0f 84 4c 01 00 00    	je     8012ac <fork+0x1d6>
  801160:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801166:	0f 84 cf 01 00 00    	je     80133b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  80116c:	c1 e2 16             	shl    $0x16,%edx
  80116f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801172:	89 d3                	mov    %edx,%ebx
  801174:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80117b:	00 
  80117c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801180:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801183:	89 04 24             	mov    %eax,(%esp)
  801186:	e8 03 fe ff ff       	call   800f8e <sys_page_alloc>
			if(ret < 0) return ret;
  80118b:	85 c0                	test   %eax,%eax
  80118d:	0f 88 a0 01 00 00    	js     801333 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801193:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801197:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80119a:	89 14 24             	mov    %edx,(%esp)
  80119d:	e8 30 fd ff ff       	call   800ed2 <sys_page_unmap>
			if(ret < 0) return ret;
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	0f 88 89 01 00 00    	js     801333 <fork+0x25d>
  8011aa:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  8011af:	89 de                	mov    %ebx,%esi
  8011b1:	c1 e6 0c             	shl    $0xc,%esi
  8011b4:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  8011b7:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  8011bd:	0f 84 da 00 00 00    	je     80129d <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8011c3:	c1 ee 0c             	shr    $0xc,%esi
  8011c6:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8011c9:	a8 01                	test   $0x1,%al
  8011cb:	0f 84 cc 00 00 00    	je     80129d <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  8011d1:	89 f0                	mov    %esi,%eax
  8011d3:	c1 e0 0c             	shl    $0xc,%eax
  8011d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  8011d9:	e8 43 fe ff ff       	call   801021 <sys_getenvid>
  8011de:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  8011e1:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8011e4:	89 c6                	mov    %eax,%esi
  8011e6:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  8011ec:	25 01 04 00 00       	and    $0x401,%eax
  8011f1:	3d 01 04 00 00       	cmp    $0x401,%eax
  8011f6:	75 3a                	jne    801232 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  8011f8:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  8011ff:	00 
  801200:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801203:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801207:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80120a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80120e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801212:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801215:	89 14 24             	mov    %edx,(%esp)
  801218:	e8 13 fd ff ff       	call   800f30 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  80121d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801220:	89 44 24 04          	mov    %eax,0x4(%esp)
  801224:	c7 04 24 83 1b 80 00 	movl   $0x801b83,(%esp)
  80122b:	e8 b5 ef ff ff       	call   8001e5 <cprintf>
  801230:	eb 6b                	jmp    80129d <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801232:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801238:	74 14                	je     80124e <fork+0x178>
  80123a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801240:	74 0c                	je     80124e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801242:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801248:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80124e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801251:	89 74 24 10          	mov    %esi,0x10(%esp)
  801255:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801259:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80125c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801260:	89 54 24 04          	mov    %edx,0x4(%esp)
  801264:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801267:	89 14 24             	mov    %edx,(%esp)
  80126a:	e8 c1 fc ff ff       	call   800f30 <sys_page_map>
	if(ret<0) return ret;
  80126f:	85 c0                	test   %eax,%eax
  801271:	0f 88 bc 00 00 00    	js     801333 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801277:	89 74 24 10          	mov    %esi,0x10(%esp)
  80127b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80127e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801282:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801285:	89 54 24 08          	mov    %edx,0x8(%esp)
  801289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128d:	89 14 24             	mov    %edx,(%esp)
  801290:	e8 9b fc ff ff       	call   800f30 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801295:	85 c0                	test   %eax,%eax
  801297:	0f 88 96 00 00 00    	js     801333 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  80129d:	83 c3 01             	add    $0x1,%ebx
  8012a0:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8012a6:	0f 85 03 ff ff ff    	jne    8011af <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8012ac:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  8012b0:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  8012b7:	0f 85 91 fe ff ff    	jne    80114e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  8012bd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012c4:	00 
  8012c5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012cc:	ee 
  8012cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012d0:	89 04 24             	mov    %eax,(%esp)
  8012d3:	e8 b6 fc ff ff       	call   800f8e <sys_page_alloc>
	if(ret < 0) return ret;
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	78 57                	js     801333 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  8012dc:	a1 04 20 80 00       	mov    0x802004,%eax
  8012e1:	8b 40 64             	mov    0x64(%eax),%eax
  8012e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8012eb:	89 14 24             	mov    %edx,(%esp)
  8012ee:	e8 c5 fa ff ff       	call   800db8 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	78 3c                	js     801333 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012f7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8012fe:	00 
  8012ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801302:	89 04 24             	mov    %eax,(%esp)
  801305:	e8 6a fb ff ff       	call   800e74 <sys_env_set_status>
  80130a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  80130c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80130f:	85 d2                	test   %edx,%edx
  801311:	79 20                	jns    801333 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801313:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801317:	c7 44 24 08 9a 1b 80 	movl   $0x801b9a,0x8(%esp)
  80131e:	00 
  80131f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801326:	00 
  801327:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  80132e:	e8 39 01 00 00       	call   80146c <_panic>

	return envid;
}
  801333:	83 c4 4c             	add    $0x4c,%esp
  801336:	5b                   	pop    %ebx
  801337:	5e                   	pop    %esi
  801338:	5f                   	pop    %edi
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80133b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80133f:	e9 0a fe ff ff       	jmp    80114e <fork+0x78>

00801344 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	56                   	push   %esi
  801348:	53                   	push   %ebx
  801349:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80134c:	e8 d0 fc ff ff       	call   801021 <sys_getenvid>
  801351:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8b 00                	mov    (%eax),%eax
  801358:	89 c6                	mov    %eax,%esi
  80135a:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  80135d:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801364:	f6 c2 02             	test   $0x2,%dl
  801367:	75 2c                	jne    801395 <pgfault+0x51>
  801369:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801370:	f6 c6 08             	test   $0x8,%dh
  801373:	75 20                	jne    801395 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801375:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801379:	c7 44 24 08 e8 1b 80 	movl   $0x801be8,0x8(%esp)
  801380:	00 
  801381:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801388:	00 
  801389:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  801390:	e8 d7 00 00 00       	call   80146c <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801395:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80139c:	00 
  80139d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8013a4:	00 
  8013a5:	89 1c 24             	mov    %ebx,(%esp)
  8013a8:	e8 e1 fb ff ff       	call   800f8e <sys_page_alloc>
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	79 20                	jns    8013d1 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  8013b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013b5:	c7 44 24 08 b1 1b 80 	movl   $0x801bb1,0x8(%esp)
  8013bc:	00 
  8013bd:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8013c4:	00 
  8013c5:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  8013cc:	e8 9b 00 00 00       	call   80146c <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  8013d1:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  8013d4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013db:	00 
  8013dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013e0:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8013e7:	e8 03 f6 ff ff       	call   8009ef <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8013ec:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8013f3:	00 
  8013f4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013fc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801403:	00 
  801404:	89 1c 24             	mov    %ebx,(%esp)
  801407:	e8 24 fb ff ff       	call   800f30 <sys_page_map>
  80140c:	85 c0                	test   %eax,%eax
  80140e:	79 20                	jns    801430 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801410:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801414:	c7 44 24 08 c3 1b 80 	movl   $0x801bc3,0x8(%esp)
  80141b:	00 
  80141c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801423:	00 
  801424:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  80142b:	e8 3c 00 00 00       	call   80146c <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801430:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801437:	00 
  801438:	89 1c 24             	mov    %ebx,(%esp)
  80143b:	e8 92 fa ff ff       	call   800ed2 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801440:	85 c0                	test   %eax,%eax
  801442:	74 20                	je     801464 <pgfault+0x120>
  801444:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801448:	c7 44 24 08 d3 1b 80 	movl   $0x801bd3,0x8(%esp)
  80144f:	00 
  801450:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801457:	00 
  801458:	c7 04 24 68 1b 80 00 	movl   $0x801b68,(%esp)
  80145f:	e8 08 00 00 00       	call   80146c <_panic>

}
  801464:	83 c4 20             	add    $0x20,%esp
  801467:	5b                   	pop    %ebx
  801468:	5e                   	pop    %esi
  801469:	5d                   	pop    %ebp
  80146a:	c3                   	ret    
	...

0080146c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	56                   	push   %esi
  801470:	53                   	push   %ebx
  801471:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  801474:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801477:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  80147d:	e8 9f fb ff ff       	call   801021 <sys_getenvid>
  801482:	8b 55 0c             	mov    0xc(%ebp),%edx
  801485:	89 54 24 10          	mov    %edx,0x10(%esp)
  801489:	8b 55 08             	mov    0x8(%ebp),%edx
  80148c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801490:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801494:	89 44 24 04          	mov    %eax,0x4(%esp)
  801498:	c7 04 24 0c 1c 80 00 	movl   $0x801c0c,(%esp)
  80149f:	e8 41 ed ff ff       	call   8001e5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014a4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ab:	89 04 24             	mov    %eax,(%esp)
  8014ae:	e8 d1 ec ff ff       	call   800184 <vcprintf>
	cprintf("\n");
  8014b3:	c7 04 24 15 18 80 00 	movl   $0x801815,(%esp)
  8014ba:	e8 26 ed ff ff       	call   8001e5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014bf:	cc                   	int3   
  8014c0:	eb fd                	jmp    8014bf <_panic+0x53>
	...

008014c4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	53                   	push   %ebx
  8014c8:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  8014cb:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8014d2:	75 5b                	jne    80152f <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  8014d4:	e8 48 fb ff ff       	call   801021 <sys_getenvid>
  8014d9:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  8014db:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014e2:	00 
  8014e3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014ea:	ee 
  8014eb:	89 04 24             	mov    %eax,(%esp)
  8014ee:	e8 9b fa ff ff       	call   800f8e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	74 28                	je     80151f <set_pgfault_handler+0x5b>
  8014f7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014fb:	c7 44 24 0c 57 1c 80 	movl   $0x801c57,0xc(%esp)
  801502:	00 
  801503:	c7 44 24 08 30 1c 80 	movl   $0x801c30,0x8(%esp)
  80150a:	00 
  80150b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801512:	00 
  801513:	c7 04 24 49 1c 80 00 	movl   $0x801c49,(%esp)
  80151a:	e8 4d ff ff ff       	call   80146c <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80151f:	c7 44 24 04 40 15 80 	movl   $0x801540,0x4(%esp)
  801526:	00 
  801527:	89 1c 24             	mov    %ebx,(%esp)
  80152a:	e8 89 f8 ff ff       	call   800db8 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	a3 08 20 80 00       	mov    %eax,0x802008
	
}
  801537:	83 c4 24             	add    $0x24,%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5d                   	pop    %ebp
  80153c:	c3                   	ret    
  80153d:	00 00                	add    %al,(%eax)
	...

00801540 <_pgfault_upcall>:
  801540:	54                   	push   %esp
  801541:	a1 08 20 80 00       	mov    0x802008,%eax
  801546:	ff d0                	call   *%eax
  801548:	83 c4 04             	add    $0x4,%esp
  80154b:	83 c4 08             	add    $0x8,%esp
  80154e:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  801552:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801556:	89 59 fc             	mov    %ebx,-0x4(%ecx)
  801559:	83 e9 04             	sub    $0x4,%ecx
  80155c:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  801560:	61                   	popa   
  801561:	83 c4 04             	add    $0x4,%esp
  801564:	9d                   	popf   
  801565:	5c                   	pop    %esp
  801566:	c3                   	ret    
	...

00801570 <__udivdi3>:
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	57                   	push   %edi
  801574:	56                   	push   %esi
  801575:	83 ec 10             	sub    $0x10,%esp
  801578:	8b 45 14             	mov    0x14(%ebp),%eax
  80157b:	8b 55 08             	mov    0x8(%ebp),%edx
  80157e:	8b 75 10             	mov    0x10(%ebp),%esi
  801581:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801584:	85 c0                	test   %eax,%eax
  801586:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801589:	75 35                	jne    8015c0 <__udivdi3+0x50>
  80158b:	39 fe                	cmp    %edi,%esi
  80158d:	77 61                	ja     8015f0 <__udivdi3+0x80>
  80158f:	85 f6                	test   %esi,%esi
  801591:	75 0b                	jne    80159e <__udivdi3+0x2e>
  801593:	b8 01 00 00 00       	mov    $0x1,%eax
  801598:	31 d2                	xor    %edx,%edx
  80159a:	f7 f6                	div    %esi
  80159c:	89 c6                	mov    %eax,%esi
  80159e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015a1:	31 d2                	xor    %edx,%edx
  8015a3:	89 f8                	mov    %edi,%eax
  8015a5:	f7 f6                	div    %esi
  8015a7:	89 c7                	mov    %eax,%edi
  8015a9:	89 c8                	mov    %ecx,%eax
  8015ab:	f7 f6                	div    %esi
  8015ad:	89 c1                	mov    %eax,%ecx
  8015af:	89 fa                	mov    %edi,%edx
  8015b1:	89 c8                	mov    %ecx,%eax
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	5e                   	pop    %esi
  8015b7:	5f                   	pop    %edi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    
  8015ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8015c0:	39 f8                	cmp    %edi,%eax
  8015c2:	77 1c                	ja     8015e0 <__udivdi3+0x70>
  8015c4:	0f bd d0             	bsr    %eax,%edx
  8015c7:	83 f2 1f             	xor    $0x1f,%edx
  8015ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8015cd:	75 39                	jne    801608 <__udivdi3+0x98>
  8015cf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8015d2:	0f 86 a0 00 00 00    	jbe    801678 <__udivdi3+0x108>
  8015d8:	39 f8                	cmp    %edi,%eax
  8015da:	0f 82 98 00 00 00    	jb     801678 <__udivdi3+0x108>
  8015e0:	31 ff                	xor    %edi,%edi
  8015e2:	31 c9                	xor    %ecx,%ecx
  8015e4:	89 c8                	mov    %ecx,%eax
  8015e6:	89 fa                	mov    %edi,%edx
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	5e                   	pop    %esi
  8015ec:	5f                   	pop    %edi
  8015ed:	5d                   	pop    %ebp
  8015ee:	c3                   	ret    
  8015ef:	90                   	nop
  8015f0:	89 d1                	mov    %edx,%ecx
  8015f2:	89 fa                	mov    %edi,%edx
  8015f4:	89 c8                	mov    %ecx,%eax
  8015f6:	31 ff                	xor    %edi,%edi
  8015f8:	f7 f6                	div    %esi
  8015fa:	89 c1                	mov    %eax,%ecx
  8015fc:	89 fa                	mov    %edi,%edx
  8015fe:	89 c8                	mov    %ecx,%eax
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	5e                   	pop    %esi
  801604:	5f                   	pop    %edi
  801605:	5d                   	pop    %ebp
  801606:	c3                   	ret    
  801607:	90                   	nop
  801608:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80160c:	89 f2                	mov    %esi,%edx
  80160e:	d3 e0                	shl    %cl,%eax
  801610:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801613:	b8 20 00 00 00       	mov    $0x20,%eax
  801618:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80161b:	89 c1                	mov    %eax,%ecx
  80161d:	d3 ea                	shr    %cl,%edx
  80161f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801623:	0b 55 ec             	or     -0x14(%ebp),%edx
  801626:	d3 e6                	shl    %cl,%esi
  801628:	89 c1                	mov    %eax,%ecx
  80162a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80162d:	89 fe                	mov    %edi,%esi
  80162f:	d3 ee                	shr    %cl,%esi
  801631:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801635:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801638:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163b:	d3 e7                	shl    %cl,%edi
  80163d:	89 c1                	mov    %eax,%ecx
  80163f:	d3 ea                	shr    %cl,%edx
  801641:	09 d7                	or     %edx,%edi
  801643:	89 f2                	mov    %esi,%edx
  801645:	89 f8                	mov    %edi,%eax
  801647:	f7 75 ec             	divl   -0x14(%ebp)
  80164a:	89 d6                	mov    %edx,%esi
  80164c:	89 c7                	mov    %eax,%edi
  80164e:	f7 65 e8             	mull   -0x18(%ebp)
  801651:	39 d6                	cmp    %edx,%esi
  801653:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801656:	72 30                	jb     801688 <__udivdi3+0x118>
  801658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80165f:	d3 e2                	shl    %cl,%edx
  801661:	39 c2                	cmp    %eax,%edx
  801663:	73 05                	jae    80166a <__udivdi3+0xfa>
  801665:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801668:	74 1e                	je     801688 <__udivdi3+0x118>
  80166a:	89 f9                	mov    %edi,%ecx
  80166c:	31 ff                	xor    %edi,%edi
  80166e:	e9 71 ff ff ff       	jmp    8015e4 <__udivdi3+0x74>
  801673:	90                   	nop
  801674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801678:	31 ff                	xor    %edi,%edi
  80167a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80167f:	e9 60 ff ff ff       	jmp    8015e4 <__udivdi3+0x74>
  801684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801688:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80168b:	31 ff                	xor    %edi,%edi
  80168d:	89 c8                	mov    %ecx,%eax
  80168f:	89 fa                	mov    %edi,%edx
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	5e                   	pop    %esi
  801695:	5f                   	pop    %edi
  801696:	5d                   	pop    %ebp
  801697:	c3                   	ret    
	...

008016a0 <__umoddi3>:
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	57                   	push   %edi
  8016a4:	56                   	push   %esi
  8016a5:	83 ec 20             	sub    $0x20,%esp
  8016a8:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016b4:	85 d2                	test   %edx,%edx
  8016b6:	89 c8                	mov    %ecx,%eax
  8016b8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8016bb:	75 13                	jne    8016d0 <__umoddi3+0x30>
  8016bd:	39 f7                	cmp    %esi,%edi
  8016bf:	76 3f                	jbe    801700 <__umoddi3+0x60>
  8016c1:	89 f2                	mov    %esi,%edx
  8016c3:	f7 f7                	div    %edi
  8016c5:	89 d0                	mov    %edx,%eax
  8016c7:	31 d2                	xor    %edx,%edx
  8016c9:	83 c4 20             	add    $0x20,%esp
  8016cc:	5e                   	pop    %esi
  8016cd:	5f                   	pop    %edi
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    
  8016d0:	39 f2                	cmp    %esi,%edx
  8016d2:	77 4c                	ja     801720 <__umoddi3+0x80>
  8016d4:	0f bd ca             	bsr    %edx,%ecx
  8016d7:	83 f1 1f             	xor    $0x1f,%ecx
  8016da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8016dd:	75 51                	jne    801730 <__umoddi3+0x90>
  8016df:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8016e2:	0f 87 e0 00 00 00    	ja     8017c8 <__umoddi3+0x128>
  8016e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016eb:	29 f8                	sub    %edi,%eax
  8016ed:	19 d6                	sbb    %edx,%esi
  8016ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f5:	89 f2                	mov    %esi,%edx
  8016f7:	83 c4 20             	add    $0x20,%esp
  8016fa:	5e                   	pop    %esi
  8016fb:	5f                   	pop    %edi
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    
  8016fe:	66 90                	xchg   %ax,%ax
  801700:	85 ff                	test   %edi,%edi
  801702:	75 0b                	jne    80170f <__umoddi3+0x6f>
  801704:	b8 01 00 00 00       	mov    $0x1,%eax
  801709:	31 d2                	xor    %edx,%edx
  80170b:	f7 f7                	div    %edi
  80170d:	89 c7                	mov    %eax,%edi
  80170f:	89 f0                	mov    %esi,%eax
  801711:	31 d2                	xor    %edx,%edx
  801713:	f7 f7                	div    %edi
  801715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801718:	f7 f7                	div    %edi
  80171a:	eb a9                	jmp    8016c5 <__umoddi3+0x25>
  80171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801720:	89 c8                	mov    %ecx,%eax
  801722:	89 f2                	mov    %esi,%edx
  801724:	83 c4 20             	add    $0x20,%esp
  801727:	5e                   	pop    %esi
  801728:	5f                   	pop    %edi
  801729:	5d                   	pop    %ebp
  80172a:	c3                   	ret    
  80172b:	90                   	nop
  80172c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801730:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801734:	d3 e2                	shl    %cl,%edx
  801736:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801739:	ba 20 00 00 00       	mov    $0x20,%edx
  80173e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801741:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801744:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801748:	89 fa                	mov    %edi,%edx
  80174a:	d3 ea                	shr    %cl,%edx
  80174c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801750:	0b 55 f4             	or     -0xc(%ebp),%edx
  801753:	d3 e7                	shl    %cl,%edi
  801755:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801759:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80175c:	89 f2                	mov    %esi,%edx
  80175e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801761:	89 c7                	mov    %eax,%edi
  801763:	d3 ea                	shr    %cl,%edx
  801765:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801769:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80176c:	89 c2                	mov    %eax,%edx
  80176e:	d3 e6                	shl    %cl,%esi
  801770:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801774:	d3 ea                	shr    %cl,%edx
  801776:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80177a:	09 d6                	or     %edx,%esi
  80177c:	89 f0                	mov    %esi,%eax
  80177e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801781:	d3 e7                	shl    %cl,%edi
  801783:	89 f2                	mov    %esi,%edx
  801785:	f7 75 f4             	divl   -0xc(%ebp)
  801788:	89 d6                	mov    %edx,%esi
  80178a:	f7 65 e8             	mull   -0x18(%ebp)
  80178d:	39 d6                	cmp    %edx,%esi
  80178f:	72 2b                	jb     8017bc <__umoddi3+0x11c>
  801791:	39 c7                	cmp    %eax,%edi
  801793:	72 23                	jb     8017b8 <__umoddi3+0x118>
  801795:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801799:	29 c7                	sub    %eax,%edi
  80179b:	19 d6                	sbb    %edx,%esi
  80179d:	89 f0                	mov    %esi,%eax
  80179f:	89 f2                	mov    %esi,%edx
  8017a1:	d3 ef                	shr    %cl,%edi
  8017a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8017a7:	d3 e0                	shl    %cl,%eax
  8017a9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8017ad:	09 f8                	or     %edi,%eax
  8017af:	d3 ea                	shr    %cl,%edx
  8017b1:	83 c4 20             	add    $0x20,%esp
  8017b4:	5e                   	pop    %esi
  8017b5:	5f                   	pop    %edi
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    
  8017b8:	39 d6                	cmp    %edx,%esi
  8017ba:	75 d9                	jne    801795 <__umoddi3+0xf5>
  8017bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8017bf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8017c2:	eb d1                	jmp    801795 <__umoddi3+0xf5>
  8017c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8017c8:	39 f2                	cmp    %esi,%edx
  8017ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8017d0:	0f 82 12 ff ff ff    	jb     8016e8 <__umoddi3+0x48>
  8017d6:	e9 17 ff ff ff       	jmp    8016f2 <__umoddi3+0x52>
