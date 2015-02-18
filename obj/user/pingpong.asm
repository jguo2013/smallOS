
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
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
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003d:	e8 74 10 00 00       	call   8010b6 <fork>
  800042:	89 c3                	mov    %eax,%ebx
  800044:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800047:	85 c0                	test   %eax,%eax
  800049:	74 3c                	je     800087 <umain+0x53>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004b:	e8 b1 0f 00 00       	call   801001 <sys_getenvid>
  800050:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800054:	89 44 24 04          	mov    %eax,0x4(%esp)
  800058:	c7 04 24 00 19 80 00 	movl   $0x801900,(%esp)
  80005f:	e8 59 01 00 00       	call   8001bd <cprintf>
		ipc_send(who, 0, 0, 0);
  800064:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80006b:	00 
  80006c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800073:	00 
  800074:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007b:	00 
  80007c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 fb 13 00 00       	call   801482 <ipc_send>
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800087:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  80008a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800099:	00 
  80009a:	89 3c 24             	mov    %edi,(%esp)
  80009d:	e8 4c 14 00 00       	call   8014ee <ipc_recv>
  8000a2:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000a4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000a7:	e8 55 0f 00 00       	call   801001 <sys_getenvid>
  8000ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b8:	c7 04 24 16 19 80 00 	movl   $0x801916,(%esp)
  8000bf:	e8 f9 00 00 00       	call   8001bd <cprintf>
		if (i == 10)
  8000c4:	83 fb 0a             	cmp    $0xa,%ebx
  8000c7:	74 27                	je     8000f0 <umain+0xbc>
			return;
		i++;
  8000c9:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d3:	00 
  8000d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000db:	00 
  8000dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e3:	89 04 24             	mov    %eax,(%esp)
  8000e6:	e8 97 13 00 00       	call   801482 <ipc_send>
		if (i == 10)
  8000eb:	83 fb 0a             	cmp    $0xa,%ebx
  8000ee:	75 9a                	jne    80008a <umain+0x56>
			return;
	}

}
  8000f0:	83 c4 2c             	add    $0x2c,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	83 ec 18             	sub    $0x18,%esp
  8000fe:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800101:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800104:	8b 75 08             	mov    0x8(%ebp),%esi
  800107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80010a:	e8 f2 0e 00 00       	call   801001 <sys_getenvid>
  80010f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800114:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800117:	2d 00 00 40 11       	sub    $0x11400000,%eax
  80011c:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800121:	85 f6                	test   %esi,%esi
  800123:	7e 07                	jle    80012c <libmain+0x34>
		binaryname = argv[0];
  800125:	8b 03                	mov    (%ebx),%eax
  800127:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80012c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800130:	89 34 24             	mov    %esi,(%esp)
  800133:	e8 fc fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800138:	e8 0b 00 00 00       	call   800148 <exit>
}
  80013d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800140:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800143:	89 ec                	mov    %ebp,%esp
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    
	...

00800148 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80014e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800155:	e8 db 0e 00 00       	call   801035 <sys_env_destroy>
}
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800165:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016c:	00 00 00 
	b.cnt = 0;
  80016f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800176:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80017c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800180:	8b 45 08             	mov    0x8(%ebp),%eax
  800183:	89 44 24 08          	mov    %eax,0x8(%esp)
  800187:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800191:	c7 04 24 d7 01 80 00 	movl   $0x8001d7,(%esp)
  800198:	e8 be 01 00 00       	call   80035b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80019d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ad:	89 04 24             	mov    %eax,(%esp)
  8001b0:	e8 2b 0a 00 00       	call   800be0 <sys_cputs>

	return b.cnt;
}
  8001b5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    

008001bd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8001c3:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8001c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cd:	89 04 24             	mov    %eax,(%esp)
  8001d0:	e8 87 ff ff ff       	call   80015c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    

008001d7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	53                   	push   %ebx
  8001db:	83 ec 14             	sub    $0x14,%esp
  8001de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e1:	8b 03                	mov    (%ebx),%eax
  8001e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001ea:	83 c0 01             	add    $0x1,%eax
  8001ed:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001ef:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f4:	75 19                	jne    80020f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001f6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001fd:	00 
  8001fe:	8d 43 08             	lea    0x8(%ebx),%eax
  800201:	89 04 24             	mov    %eax,(%esp)
  800204:	e8 d7 09 00 00       	call   800be0 <sys_cputs>
		b->idx = 0;
  800209:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80020f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800213:	83 c4 14             	add    $0x14,%esp
  800216:	5b                   	pop    %ebx
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    
  800219:	00 00                	add    %al,(%eax)
	...

0080021c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	57                   	push   %edi
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	83 ec 4c             	sub    $0x4c,%esp
  800225:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800228:	89 d6                	mov    %edx,%esi
  80022a:	8b 45 08             	mov    0x8(%ebp),%eax
  80022d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800230:	8b 55 0c             	mov    0xc(%ebp),%edx
  800233:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800236:	8b 45 10             	mov    0x10(%ebp),%eax
  800239:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80023c:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	39 d1                	cmp    %edx,%ecx
  800249:	72 07                	jb     800252 <printnum+0x36>
  80024b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80024e:	39 d0                	cmp    %edx,%eax
  800250:	77 69                	ja     8002bb <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800252:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800256:	83 eb 01             	sub    $0x1,%ebx
  800259:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80025d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800261:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800265:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800269:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80026c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80026f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800272:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800276:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80027d:	00 
  80027e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800281:	89 04 24             	mov    %eax,(%esp)
  800284:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800287:	89 54 24 04          	mov    %edx,0x4(%esp)
  80028b:	e8 f0 13 00 00       	call   801680 <__udivdi3>
  800290:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800293:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800296:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80029a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80029e:	89 04 24             	mov    %eax,(%esp)
  8002a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a5:	89 f2                	mov    %esi,%edx
  8002a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002aa:	e8 6d ff ff ff       	call   80021c <printnum>
  8002af:	eb 11                	jmp    8002c2 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b5:	89 3c 24             	mov    %edi,(%esp)
  8002b8:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002bb:	83 eb 01             	sub    $0x1,%ebx
  8002be:	85 db                	test   %ebx,%ebx
  8002c0:	7f ef                	jg     8002b1 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002c6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002d8:	00 
  8002d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002dc:	89 14 24             	mov    %edx,(%esp)
  8002df:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002e6:	e8 c5 14 00 00       	call   8017b0 <__umoddi3>
  8002eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ef:	0f be 80 33 19 80 00 	movsbl 0x801933(%eax),%eax
  8002f6:	89 04 24             	mov    %eax,(%esp)
  8002f9:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002fc:	83 c4 4c             	add    $0x4c,%esp
  8002ff:	5b                   	pop    %ebx
  800300:	5e                   	pop    %esi
  800301:	5f                   	pop    %edi
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    

00800304 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800307:	83 fa 01             	cmp    $0x1,%edx
  80030a:	7e 0e                	jle    80031a <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80030c:	8b 10                	mov    (%eax),%edx
  80030e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800311:	89 08                	mov    %ecx,(%eax)
  800313:	8b 02                	mov    (%edx),%eax
  800315:	8b 52 04             	mov    0x4(%edx),%edx
  800318:	eb 22                	jmp    80033c <getuint+0x38>
	else if (lflag)
  80031a:	85 d2                	test   %edx,%edx
  80031c:	74 10                	je     80032e <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8d 4a 04             	lea    0x4(%edx),%ecx
  800323:	89 08                	mov    %ecx,(%eax)
  800325:	8b 02                	mov    (%edx),%eax
  800327:	ba 00 00 00 00       	mov    $0x0,%edx
  80032c:	eb 0e                	jmp    80033c <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80032e:	8b 10                	mov    (%eax),%edx
  800330:	8d 4a 04             	lea    0x4(%edx),%ecx
  800333:	89 08                	mov    %ecx,(%eax)
  800335:	8b 02                	mov    (%edx),%eax
  800337:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80033c:	5d                   	pop    %ebp
  80033d:	c3                   	ret    

0080033e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800344:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800348:	8b 10                	mov    (%eax),%edx
  80034a:	3b 50 04             	cmp    0x4(%eax),%edx
  80034d:	73 0a                	jae    800359 <sprintputch+0x1b>
		*b->buf++ = ch;
  80034f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800352:	88 0a                	mov    %cl,(%edx)
  800354:	83 c2 01             	add    $0x1,%edx
  800357:	89 10                	mov    %edx,(%eax)
}
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    

0080035b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	57                   	push   %edi
  80035f:	56                   	push   %esi
  800360:	53                   	push   %ebx
  800361:	83 ec 4c             	sub    $0x4c,%esp
  800364:	8b 7d 08             	mov    0x8(%ebp),%edi
  800367:	8b 75 0c             	mov    0xc(%ebp),%esi
  80036a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80036d:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800374:	eb 11                	jmp    800387 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800376:	85 c0                	test   %eax,%eax
  800378:	0f 84 b6 03 00 00    	je     800734 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80037e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800382:	89 04 24             	mov    %eax,(%esp)
  800385:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800387:	0f b6 03             	movzbl (%ebx),%eax
  80038a:	83 c3 01             	add    $0x1,%ebx
  80038d:	83 f8 25             	cmp    $0x25,%eax
  800390:	75 e4                	jne    800376 <vprintfmt+0x1b>
  800392:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800396:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80039d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8003a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003b0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8003b3:	eb 06                	jmp    8003bb <vprintfmt+0x60>
  8003b5:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8003b9:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	0f b6 0b             	movzbl (%ebx),%ecx
  8003be:	0f b6 c1             	movzbl %cl,%eax
  8003c1:	8d 53 01             	lea    0x1(%ebx),%edx
  8003c4:	83 e9 23             	sub    $0x23,%ecx
  8003c7:	80 f9 55             	cmp    $0x55,%cl
  8003ca:	0f 87 47 03 00 00    	ja     800717 <vprintfmt+0x3bc>
  8003d0:	0f b6 c9             	movzbl %cl,%ecx
  8003d3:	ff 24 8d 80 1a 80 00 	jmp    *0x801a80(,%ecx,4)
  8003da:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8003de:	eb d9                	jmp    8003b9 <vprintfmt+0x5e>
  8003e0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8003e7:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003ec:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003ef:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003f3:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8003f6:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003f9:	83 fb 09             	cmp    $0x9,%ebx
  8003fc:	77 30                	ja     80042e <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003fe:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800401:	eb e9                	jmp    8003ec <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800403:	8b 45 14             	mov    0x14(%ebp),%eax
  800406:	8d 48 04             	lea    0x4(%eax),%ecx
  800409:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800411:	eb 1e                	jmp    800431 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800413:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800417:	b8 00 00 00 00       	mov    $0x0,%eax
  80041c:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800420:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800423:	eb 94                	jmp    8003b9 <vprintfmt+0x5e>
  800425:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80042c:	eb 8b                	jmp    8003b9 <vprintfmt+0x5e>
  80042e:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800431:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800435:	79 82                	jns    8003b9 <vprintfmt+0x5e>
  800437:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80043d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800440:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800443:	e9 71 ff ff ff       	jmp    8003b9 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800448:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80044c:	e9 68 ff ff ff       	jmp    8003b9 <vprintfmt+0x5e>
  800451:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8d 50 04             	lea    0x4(%eax),%edx
  80045a:	89 55 14             	mov    %edx,0x14(%ebp)
  80045d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800461:	8b 00                	mov    (%eax),%eax
  800463:	89 04 24             	mov    %eax,(%esp)
  800466:	ff d7                	call   *%edi
  800468:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80046b:	e9 17 ff ff ff       	jmp    800387 <vprintfmt+0x2c>
  800470:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	8d 50 04             	lea    0x4(%eax),%edx
  800479:	89 55 14             	mov    %edx,0x14(%ebp)
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	89 c2                	mov    %eax,%edx
  800480:	c1 fa 1f             	sar    $0x1f,%edx
  800483:	31 d0                	xor    %edx,%eax
  800485:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800487:	83 f8 11             	cmp    $0x11,%eax
  80048a:	7f 0b                	jg     800497 <vprintfmt+0x13c>
  80048c:	8b 14 85 e0 1b 80 00 	mov    0x801be0(,%eax,4),%edx
  800493:	85 d2                	test   %edx,%edx
  800495:	75 20                	jne    8004b7 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800497:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80049b:	c7 44 24 08 44 19 80 	movl   $0x801944,0x8(%esp)
  8004a2:	00 
  8004a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004a7:	89 3c 24             	mov    %edi,(%esp)
  8004aa:	e8 0d 03 00 00       	call   8007bc <printfmt>
  8004af:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b2:	e9 d0 fe ff ff       	jmp    800387 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8004b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004bb:	c7 44 24 08 4d 19 80 	movl   $0x80194d,0x8(%esp)
  8004c2:	00 
  8004c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004c7:	89 3c 24             	mov    %edi,(%esp)
  8004ca:	e8 ed 02 00 00       	call   8007bc <printfmt>
  8004cf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8004d2:	e9 b0 fe ff ff       	jmp    800387 <vprintfmt+0x2c>
  8004d7:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8004da:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e6:	8d 50 04             	lea    0x4(%eax),%edx
  8004e9:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ec:	8b 18                	mov    (%eax),%ebx
  8004ee:	85 db                	test   %ebx,%ebx
  8004f0:	b8 50 19 80 00       	mov    $0x801950,%eax
  8004f5:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8004f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004fc:	7e 76                	jle    800574 <vprintfmt+0x219>
  8004fe:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800502:	74 7a                	je     80057e <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800504:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800508:	89 1c 24             	mov    %ebx,(%esp)
  80050b:	e8 f8 02 00 00       	call   800808 <strnlen>
  800510:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800513:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800515:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800519:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80051c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80051f:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800521:	eb 0f                	jmp    800532 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800523:	89 74 24 04          	mov    %esi,0x4(%esp)
  800527:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052a:	89 04 24             	mov    %eax,(%esp)
  80052d:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80052f:	83 eb 01             	sub    $0x1,%ebx
  800532:	85 db                	test   %ebx,%ebx
  800534:	7f ed                	jg     800523 <vprintfmt+0x1c8>
  800536:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800539:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80053c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80053f:	89 f7                	mov    %esi,%edi
  800541:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800544:	eb 40                	jmp    800586 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800546:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054a:	74 18                	je     800564 <vprintfmt+0x209>
  80054c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80054f:	83 fa 5e             	cmp    $0x5e,%edx
  800552:	76 10                	jbe    800564 <vprintfmt+0x209>
					putch('?', putdat);
  800554:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800558:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80055f:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800562:	eb 0a                	jmp    80056e <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800564:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800568:	89 04 24             	mov    %eax,(%esp)
  80056b:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80056e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800572:	eb 12                	jmp    800586 <vprintfmt+0x22b>
  800574:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800577:	89 f7                	mov    %esi,%edi
  800579:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80057c:	eb 08                	jmp    800586 <vprintfmt+0x22b>
  80057e:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800581:	89 f7                	mov    %esi,%edi
  800583:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800586:	0f be 03             	movsbl (%ebx),%eax
  800589:	83 c3 01             	add    $0x1,%ebx
  80058c:	85 c0                	test   %eax,%eax
  80058e:	74 25                	je     8005b5 <vprintfmt+0x25a>
  800590:	85 f6                	test   %esi,%esi
  800592:	78 b2                	js     800546 <vprintfmt+0x1eb>
  800594:	83 ee 01             	sub    $0x1,%esi
  800597:	79 ad                	jns    800546 <vprintfmt+0x1eb>
  800599:	89 fe                	mov    %edi,%esi
  80059b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80059e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005a1:	eb 1a                	jmp    8005bd <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005a7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005ae:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005b0:	83 eb 01             	sub    $0x1,%ebx
  8005b3:	eb 08                	jmp    8005bd <vprintfmt+0x262>
  8005b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005b8:	89 fe                	mov    %edi,%esi
  8005ba:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005bd:	85 db                	test   %ebx,%ebx
  8005bf:	7f e2                	jg     8005a3 <vprintfmt+0x248>
  8005c1:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005c4:	e9 be fd ff ff       	jmp    800387 <vprintfmt+0x2c>
  8005c9:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005cc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005cf:	83 f9 01             	cmp    $0x1,%ecx
  8005d2:	7e 16                	jle    8005ea <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8d 50 08             	lea    0x8(%eax),%edx
  8005da:	89 55 14             	mov    %edx,0x14(%ebp)
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e2:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8005e5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e8:	eb 32                	jmp    80061c <vprintfmt+0x2c1>
	else if (lflag)
  8005ea:	85 c9                	test   %ecx,%ecx
  8005ec:	74 18                	je     800606 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8d 50 04             	lea    0x4(%eax),%edx
  8005f4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	89 c1                	mov    %eax,%ecx
  8005fe:	c1 f9 1f             	sar    $0x1f,%ecx
  800601:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800604:	eb 16                	jmp    80061c <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8d 50 04             	lea    0x4(%eax),%edx
  80060c:	89 55 14             	mov    %edx,0x14(%ebp)
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800614:	89 c2                	mov    %eax,%edx
  800616:	c1 fa 1f             	sar    $0x1f,%edx
  800619:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80061c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80061f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800622:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800627:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80062b:	0f 89 a7 00 00 00    	jns    8006d8 <vprintfmt+0x37d>
				putch('-', putdat);
  800631:	89 74 24 04          	mov    %esi,0x4(%esp)
  800635:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80063c:	ff d7                	call   *%edi
				num = -(long long) num;
  80063e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800641:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800644:	f7 d9                	neg    %ecx
  800646:	83 d3 00             	adc    $0x0,%ebx
  800649:	f7 db                	neg    %ebx
  80064b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800650:	e9 83 00 00 00       	jmp    8006d8 <vprintfmt+0x37d>
  800655:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800658:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80065b:	89 ca                	mov    %ecx,%edx
  80065d:	8d 45 14             	lea    0x14(%ebp),%eax
  800660:	e8 9f fc ff ff       	call   800304 <getuint>
  800665:	89 c1                	mov    %eax,%ecx
  800667:	89 d3                	mov    %edx,%ebx
  800669:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80066e:	eb 68                	jmp    8006d8 <vprintfmt+0x37d>
  800670:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800673:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800676:	89 ca                	mov    %ecx,%edx
  800678:	8d 45 14             	lea    0x14(%ebp),%eax
  80067b:	e8 84 fc ff ff       	call   800304 <getuint>
  800680:	89 c1                	mov    %eax,%ecx
  800682:	89 d3                	mov    %edx,%ebx
  800684:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800689:	eb 4d                	jmp    8006d8 <vprintfmt+0x37d>
  80068b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80068e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800692:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800699:	ff d7                	call   *%edi
			putch('x', putdat);
  80069b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80069f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006a6:	ff d7                	call   *%edi
			num = (unsigned long long)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 50 04             	lea    0x4(%eax),%edx
  8006ae:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b1:	8b 08                	mov    (%eax),%ecx
  8006b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b8:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006bd:	eb 19                	jmp    8006d8 <vprintfmt+0x37d>
  8006bf:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006c2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006c5:	89 ca                	mov    %ecx,%edx
  8006c7:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ca:	e8 35 fc ff ff       	call   800304 <getuint>
  8006cf:	89 c1                	mov    %eax,%ecx
  8006d1:	89 d3                	mov    %edx,%ebx
  8006d3:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006d8:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8006dc:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006e3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006eb:	89 0c 24             	mov    %ecx,(%esp)
  8006ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006f2:	89 f2                	mov    %esi,%edx
  8006f4:	89 f8                	mov    %edi,%eax
  8006f6:	e8 21 fb ff ff       	call   80021c <printnum>
  8006fb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006fe:	e9 84 fc ff ff       	jmp    800387 <vprintfmt+0x2c>
  800703:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800706:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070a:	89 04 24             	mov    %eax,(%esp)
  80070d:	ff d7                	call   *%edi
  80070f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800712:	e9 70 fc ff ff       	jmp    800387 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800717:	89 74 24 04          	mov    %esi,0x4(%esp)
  80071b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800722:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800724:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800727:	80 38 25             	cmpb   $0x25,(%eax)
  80072a:	0f 84 57 fc ff ff    	je     800387 <vprintfmt+0x2c>
  800730:	89 c3                	mov    %eax,%ebx
  800732:	eb f0                	jmp    800724 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800734:	83 c4 4c             	add    $0x4c,%esp
  800737:	5b                   	pop    %ebx
  800738:	5e                   	pop    %esi
  800739:	5f                   	pop    %edi
  80073a:	5d                   	pop    %ebp
  80073b:	c3                   	ret    

0080073c <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 28             	sub    $0x28,%esp
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800748:	85 c0                	test   %eax,%eax
  80074a:	74 04                	je     800750 <vsnprintf+0x14>
  80074c:	85 d2                	test   %edx,%edx
  80074e:	7f 07                	jg     800757 <vsnprintf+0x1b>
  800750:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800755:	eb 3b                	jmp    800792 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800757:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075a:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  80075e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800761:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80076f:	8b 45 10             	mov    0x10(%ebp),%eax
  800772:	89 44 24 08          	mov    %eax,0x8(%esp)
  800776:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800779:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077d:	c7 04 24 3e 03 80 00 	movl   $0x80033e,(%esp)
  800784:	e8 d2 fb ff ff       	call   80035b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800789:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800792:	c9                   	leave  
  800793:	c3                   	ret    

00800794 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80079a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  80079d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	89 04 24             	mov    %eax,(%esp)
  8007b5:	e8 82 ff ff ff       	call   80073c <vsnprintf>
	va_end(ap);

	return rc;
}
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8007c2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8007c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	89 04 24             	mov    %eax,(%esp)
  8007dd:	e8 79 fb ff ff       	call   80035b <vprintfmt>
	va_end(ap);
}
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    
	...

008007f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007f6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8007fb:	eb 03                	jmp    800800 <strlen+0x10>
		n++;
  8007fd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800800:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800804:	75 f7                	jne    8007fd <strlen+0xd>
		n++;
	return n;
}
  800806:	5d                   	pop    %ebp
  800807:	c3                   	ret    

00800808 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	53                   	push   %ebx
  80080c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80080f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800812:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800817:	eb 03                	jmp    80081c <strnlen+0x14>
		n++;
  800819:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081c:	39 c1                	cmp    %eax,%ecx
  80081e:	74 06                	je     800826 <strnlen+0x1e>
  800820:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800824:	75 f3                	jne    800819 <strnlen+0x11>
		n++;
	return n;
}
  800826:	5b                   	pop    %ebx
  800827:	5d                   	pop    %ebp
  800828:	c3                   	ret    

00800829 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	53                   	push   %ebx
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800833:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800838:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80083c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80083f:	83 c2 01             	add    $0x1,%edx
  800842:	84 c9                	test   %cl,%cl
  800844:	75 f2                	jne    800838 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800846:	5b                   	pop    %ebx
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	53                   	push   %ebx
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800853:	89 1c 24             	mov    %ebx,(%esp)
  800856:	e8 95 ff ff ff       	call   8007f0 <strlen>
	strcpy(dst + len, src);
  80085b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800862:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800865:	89 04 24             	mov    %eax,(%esp)
  800868:	e8 bc ff ff ff       	call   800829 <strcpy>
	return dst;
}
  80086d:	89 d8                	mov    %ebx,%eax
  80086f:	83 c4 08             	add    $0x8,%esp
  800872:	5b                   	pop    %ebx
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	56                   	push   %esi
  800879:	53                   	push   %ebx
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800880:	8b 75 10             	mov    0x10(%ebp),%esi
  800883:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800888:	eb 0f                	jmp    800899 <strncpy+0x24>
		*dst++ = *src;
  80088a:	0f b6 19             	movzbl (%ecx),%ebx
  80088d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800890:	80 39 01             	cmpb   $0x1,(%ecx)
  800893:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800896:	83 c2 01             	add    $0x1,%edx
  800899:	39 f2                	cmp    %esi,%edx
  80089b:	72 ed                	jb     80088a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80089d:	5b                   	pop    %ebx
  80089e:	5e                   	pop    %esi
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	56                   	push   %esi
  8008a5:	53                   	push   %ebx
  8008a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ac:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008af:	89 f0                	mov    %esi,%eax
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	75 0a                	jne    8008bf <strlcpy+0x1e>
  8008b5:	eb 17                	jmp    8008ce <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b7:	88 18                	mov    %bl,(%eax)
  8008b9:	83 c0 01             	add    $0x1,%eax
  8008bc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008bf:	83 ea 01             	sub    $0x1,%edx
  8008c2:	74 07                	je     8008cb <strlcpy+0x2a>
  8008c4:	0f b6 19             	movzbl (%ecx),%ebx
  8008c7:	84 db                	test   %bl,%bl
  8008c9:	75 ec                	jne    8008b7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  8008cb:	c6 00 00             	movb   $0x0,(%eax)
  8008ce:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8008d0:	5b                   	pop    %ebx
  8008d1:	5e                   	pop    %esi
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008da:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008dd:	eb 06                	jmp    8008e5 <strcmp+0x11>
		p++, q++;
  8008df:	83 c1 01             	add    $0x1,%ecx
  8008e2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008e5:	0f b6 01             	movzbl (%ecx),%eax
  8008e8:	84 c0                	test   %al,%al
  8008ea:	74 04                	je     8008f0 <strcmp+0x1c>
  8008ec:	3a 02                	cmp    (%edx),%al
  8008ee:	74 ef                	je     8008df <strcmp+0xb>
  8008f0:	0f b6 c0             	movzbl %al,%eax
  8008f3:	0f b6 12             	movzbl (%edx),%edx
  8008f6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	53                   	push   %ebx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800904:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800907:	eb 09                	jmp    800912 <strncmp+0x18>
		n--, p++, q++;
  800909:	83 ea 01             	sub    $0x1,%edx
  80090c:	83 c0 01             	add    $0x1,%eax
  80090f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800912:	85 d2                	test   %edx,%edx
  800914:	75 07                	jne    80091d <strncmp+0x23>
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	eb 13                	jmp    800930 <strncmp+0x36>
  80091d:	0f b6 18             	movzbl (%eax),%ebx
  800920:	84 db                	test   %bl,%bl
  800922:	74 04                	je     800928 <strncmp+0x2e>
  800924:	3a 19                	cmp    (%ecx),%bl
  800926:	74 e1                	je     800909 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800928:	0f b6 00             	movzbl (%eax),%eax
  80092b:	0f b6 11             	movzbl (%ecx),%edx
  80092e:	29 d0                	sub    %edx,%eax
}
  800930:	5b                   	pop    %ebx
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093d:	eb 07                	jmp    800946 <strchr+0x13>
		if (*s == c)
  80093f:	38 ca                	cmp    %cl,%dl
  800941:	74 0f                	je     800952 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800943:	83 c0 01             	add    $0x1,%eax
  800946:	0f b6 10             	movzbl (%eax),%edx
  800949:	84 d2                	test   %dl,%dl
  80094b:	75 f2                	jne    80093f <strchr+0xc>
  80094d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800952:	5d                   	pop    %ebp
  800953:	c3                   	ret    

00800954 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095e:	eb 07                	jmp    800967 <strfind+0x13>
		if (*s == c)
  800960:	38 ca                	cmp    %cl,%dl
  800962:	74 0a                	je     80096e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	0f b6 10             	movzbl (%eax),%edx
  80096a:	84 d2                	test   %dl,%dl
  80096c:	75 f2                	jne    800960 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 0c             	sub    $0xc,%esp
  800976:	89 1c 24             	mov    %ebx,(%esp)
  800979:	89 74 24 04          	mov    %esi,0x4(%esp)
  80097d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800981:	8b 7d 08             	mov    0x8(%ebp),%edi
  800984:	8b 45 0c             	mov    0xc(%ebp),%eax
  800987:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80098a:	85 c9                	test   %ecx,%ecx
  80098c:	74 30                	je     8009be <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80098e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800994:	75 25                	jne    8009bb <memset+0x4b>
  800996:	f6 c1 03             	test   $0x3,%cl
  800999:	75 20                	jne    8009bb <memset+0x4b>
		c &= 0xFF;
  80099b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80099e:	89 d3                	mov    %edx,%ebx
  8009a0:	c1 e3 08             	shl    $0x8,%ebx
  8009a3:	89 d6                	mov    %edx,%esi
  8009a5:	c1 e6 18             	shl    $0x18,%esi
  8009a8:	89 d0                	mov    %edx,%eax
  8009aa:	c1 e0 10             	shl    $0x10,%eax
  8009ad:	09 f0                	or     %esi,%eax
  8009af:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  8009b1:	09 d8                	or     %ebx,%eax
  8009b3:	c1 e9 02             	shr    $0x2,%ecx
  8009b6:	fc                   	cld    
  8009b7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b9:	eb 03                	jmp    8009be <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009bb:	fc                   	cld    
  8009bc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009be:	89 f8                	mov    %edi,%eax
  8009c0:	8b 1c 24             	mov    (%esp),%ebx
  8009c3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009c7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009cb:	89 ec                	mov    %ebp,%esp
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	89 34 24             	mov    %esi,(%esp)
  8009d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  8009e2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009e5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009e7:	39 c6                	cmp    %eax,%esi
  8009e9:	73 35                	jae    800a20 <memmove+0x51>
  8009eb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ee:	39 d0                	cmp    %edx,%eax
  8009f0:	73 2e                	jae    800a20 <memmove+0x51>
		s += n;
		d += n;
  8009f2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f4:	f6 c2 03             	test   $0x3,%dl
  8009f7:	75 1b                	jne    800a14 <memmove+0x45>
  8009f9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ff:	75 13                	jne    800a14 <memmove+0x45>
  800a01:	f6 c1 03             	test   $0x3,%cl
  800a04:	75 0e                	jne    800a14 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a06:	83 ef 04             	sub    $0x4,%edi
  800a09:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a0c:	c1 e9 02             	shr    $0x2,%ecx
  800a0f:	fd                   	std    
  800a10:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a12:	eb 09                	jmp    800a1d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a14:	83 ef 01             	sub    $0x1,%edi
  800a17:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a1a:	fd                   	std    
  800a1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a1d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1e:	eb 20                	jmp    800a40 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a20:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a26:	75 15                	jne    800a3d <memmove+0x6e>
  800a28:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a2e:	75 0d                	jne    800a3d <memmove+0x6e>
  800a30:	f6 c1 03             	test   $0x3,%cl
  800a33:	75 08                	jne    800a3d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a35:	c1 e9 02             	shr    $0x2,%ecx
  800a38:	fc                   	cld    
  800a39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3b:	eb 03                	jmp    800a40 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a3d:	fc                   	cld    
  800a3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a40:	8b 34 24             	mov    (%esp),%esi
  800a43:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a47:	89 ec                	mov    %ebp,%esp
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a51:	8b 45 10             	mov    0x10(%ebp),%eax
  800a54:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	89 04 24             	mov    %eax,(%esp)
  800a65:	e8 65 ff ff ff       	call   8009cf <memmove>
}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	57                   	push   %edi
  800a70:	56                   	push   %esi
  800a71:	53                   	push   %ebx
  800a72:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a7b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a80:	eb 1c                	jmp    800a9e <memcmp+0x32>
		if (*s1 != *s2)
  800a82:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800a86:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800a8a:	83 c2 01             	add    $0x1,%edx
  800a8d:	83 e9 01             	sub    $0x1,%ecx
  800a90:	38 d8                	cmp    %bl,%al
  800a92:	74 0a                	je     800a9e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800a94:	0f b6 c0             	movzbl %al,%eax
  800a97:	0f b6 db             	movzbl %bl,%ebx
  800a9a:	29 d8                	sub    %ebx,%eax
  800a9c:	eb 09                	jmp    800aa7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9e:	85 c9                	test   %ecx,%ecx
  800aa0:	75 e0                	jne    800a82 <memcmp+0x16>
  800aa2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800aa7:	5b                   	pop    %ebx
  800aa8:	5e                   	pop    %esi
  800aa9:	5f                   	pop    %edi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab5:	89 c2                	mov    %eax,%edx
  800ab7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aba:	eb 07                	jmp    800ac3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800abc:	38 08                	cmp    %cl,(%eax)
  800abe:	74 07                	je     800ac7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ac0:	83 c0 01             	add    $0x1,%eax
  800ac3:	39 d0                	cmp    %edx,%eax
  800ac5:	72 f5                	jb     800abc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	57                   	push   %edi
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	83 ec 04             	sub    $0x4,%esp
  800ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ad8:	eb 03                	jmp    800add <strtol+0x14>
		s++;
  800ada:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800add:	0f b6 02             	movzbl (%edx),%eax
  800ae0:	3c 20                	cmp    $0x20,%al
  800ae2:	74 f6                	je     800ada <strtol+0x11>
  800ae4:	3c 09                	cmp    $0x9,%al
  800ae6:	74 f2                	je     800ada <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ae8:	3c 2b                	cmp    $0x2b,%al
  800aea:	75 0c                	jne    800af8 <strtol+0x2f>
		s++;
  800aec:	8d 52 01             	lea    0x1(%edx),%edx
  800aef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800af6:	eb 15                	jmp    800b0d <strtol+0x44>
	else if (*s == '-')
  800af8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800aff:	3c 2d                	cmp    $0x2d,%al
  800b01:	75 0a                	jne    800b0d <strtol+0x44>
		s++, neg = 1;
  800b03:	8d 52 01             	lea    0x1(%edx),%edx
  800b06:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0d:	85 db                	test   %ebx,%ebx
  800b0f:	0f 94 c0             	sete   %al
  800b12:	74 05                	je     800b19 <strtol+0x50>
  800b14:	83 fb 10             	cmp    $0x10,%ebx
  800b17:	75 15                	jne    800b2e <strtol+0x65>
  800b19:	80 3a 30             	cmpb   $0x30,(%edx)
  800b1c:	75 10                	jne    800b2e <strtol+0x65>
  800b1e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b22:	75 0a                	jne    800b2e <strtol+0x65>
		s += 2, base = 16;
  800b24:	83 c2 02             	add    $0x2,%edx
  800b27:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2c:	eb 13                	jmp    800b41 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b2e:	84 c0                	test   %al,%al
  800b30:	74 0f                	je     800b41 <strtol+0x78>
  800b32:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b37:	80 3a 30             	cmpb   $0x30,(%edx)
  800b3a:	75 05                	jne    800b41 <strtol+0x78>
		s++, base = 8;
  800b3c:	83 c2 01             	add    $0x1,%edx
  800b3f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
  800b46:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b48:	0f b6 0a             	movzbl (%edx),%ecx
  800b4b:	89 cf                	mov    %ecx,%edi
  800b4d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b50:	80 fb 09             	cmp    $0x9,%bl
  800b53:	77 08                	ja     800b5d <strtol+0x94>
			dig = *s - '0';
  800b55:	0f be c9             	movsbl %cl,%ecx
  800b58:	83 e9 30             	sub    $0x30,%ecx
  800b5b:	eb 1e                	jmp    800b7b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800b5d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b60:	80 fb 19             	cmp    $0x19,%bl
  800b63:	77 08                	ja     800b6d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800b65:	0f be c9             	movsbl %cl,%ecx
  800b68:	83 e9 57             	sub    $0x57,%ecx
  800b6b:	eb 0e                	jmp    800b7b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800b6d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b70:	80 fb 19             	cmp    $0x19,%bl
  800b73:	77 15                	ja     800b8a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b75:	0f be c9             	movsbl %cl,%ecx
  800b78:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b7b:	39 f1                	cmp    %esi,%ecx
  800b7d:	7d 0b                	jge    800b8a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b7f:	83 c2 01             	add    $0x1,%edx
  800b82:	0f af c6             	imul   %esi,%eax
  800b85:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800b88:	eb be                	jmp    800b48 <strtol+0x7f>
  800b8a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800b8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b90:	74 05                	je     800b97 <strtol+0xce>
		*endptr = (char *) s;
  800b92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b95:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b97:	89 ca                	mov    %ecx,%edx
  800b99:	f7 da                	neg    %edx
  800b9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b9f:	0f 45 c2             	cmovne %edx,%eax
}
  800ba2:	83 c4 04             	add    $0x4,%esp
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    
	...

00800bac <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 0c             	sub    $0xc,%esp
  800bb2:	89 1c 24             	mov    %ebx,(%esp)
  800bb5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bb9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc7:	89 d1                	mov    %edx,%ecx
  800bc9:	89 d3                	mov    %edx,%ebx
  800bcb:	89 d7                	mov    %edx,%edi
  800bcd:	89 d6                	mov    %edx,%esi
  800bcf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bd1:	8b 1c 24             	mov    (%esp),%ebx
  800bd4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bd8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bdc:	89 ec                	mov    %ebp,%esp
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	89 1c 24             	mov    %ebx,(%esp)
  800be9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bed:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	89 c3                	mov    %eax,%ebx
  800bfe:	89 c7                	mov    %eax,%edi
  800c00:	89 c6                	mov    %eax,%esi
  800c02:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c04:	8b 1c 24             	mov    (%esp),%ebx
  800c07:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c0b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c0f:	89 ec                	mov    %ebp,%esp
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	89 1c 24             	mov    %ebx,(%esp)
  800c1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c20:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	b8 10 00 00 00       	mov    $0x10,%eax
  800c2e:	89 d1                	mov    %edx,%ecx
  800c30:	89 d3                	mov    %edx,%ebx
  800c32:	89 d7                	mov    %edx,%edi
  800c34:	89 d6                	mov    %edx,%esi
  800c36:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800c38:	8b 1c 24             	mov    (%esp),%ebx
  800c3b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c3f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c43:	89 ec                	mov    %ebp,%esp
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	83 ec 38             	sub    $0x38,%esp
  800c4d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c50:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c53:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c5b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800c60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	89 df                	mov    %ebx,%edi
  800c68:	89 de                	mov    %ebx,%esi
  800c6a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c6c:	85 c0                	test   %eax,%eax
  800c6e:	7e 28                	jle    800c98 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c70:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c74:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800c7b:	00 
  800c7c:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  800c83:	00 
  800c84:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c8b:	00 
  800c8c:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  800c93:	e8 e0 08 00 00       	call   801578 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800c98:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c9b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c9e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ca1:	89 ec                	mov    %ebp,%esp
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	83 ec 38             	sub    $0x38,%esp
  800cab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cb1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc4:	89 df                	mov    %ebx,%edi
  800cc6:	89 de                	mov    %ebx,%esi
  800cc8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	7e 28                	jle    800cf6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cce:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cd2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800cd9:	00 
  800cda:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  800ce1:	00 
  800ce2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce9:	00 
  800cea:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  800cf1:	e8 82 08 00 00       	call   801578 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800cf6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cf9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cfc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cff:	89 ec                	mov    %ebp,%esp
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 38             	sub    $0x38,%esp
  800d09:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d0f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d17:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1f:	89 cb                	mov    %ecx,%ebx
  800d21:	89 cf                	mov    %ecx,%edi
  800d23:	89 ce                	mov    %ecx,%esi
  800d25:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d27:	85 c0                	test   %eax,%eax
  800d29:	7e 28                	jle    800d53 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800d36:	00 
  800d37:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  800d3e:	00 
  800d3f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d46:	00 
  800d47:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  800d4e:	e8 25 08 00 00       	call   801578 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d53:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d56:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d59:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d5c:	89 ec                	mov    %ebp,%esp
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	89 1c 24             	mov    %ebx,(%esp)
  800d69:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d6d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d71:	be 00 00 00 00       	mov    $0x0,%esi
  800d76:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d7b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
  800d87:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d89:	8b 1c 24             	mov    (%esp),%ebx
  800d8c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d90:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d94:	89 ec                	mov    %ebp,%esp
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 38             	sub    $0x38,%esp
  800d9e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800da1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800da4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dac:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	89 df                	mov    %ebx,%edi
  800db9:	89 de                	mov    %ebx,%esi
  800dbb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	7e 28                	jle    800de9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800dcc:	00 
  800dcd:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  800dd4:	00 
  800dd5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ddc:	00 
  800ddd:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  800de4:	e8 8f 07 00 00       	call   801578 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800de9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dec:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800def:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800df2:	89 ec                	mov    %ebp,%esp
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 38             	sub    $0x38,%esp
  800dfc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dff:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e02:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7e 28                	jle    800e47 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e23:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e2a:	00 
  800e2b:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  800e32:	00 
  800e33:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3a:	00 
  800e3b:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  800e42:	e8 31 07 00 00       	call   801578 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e47:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e4a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e4d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e50:	89 ec                	mov    %ebp,%esp
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 38             	sub    $0x38,%esp
  800e5a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e5d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e60:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e68:	b8 08 00 00 00       	mov    $0x8,%eax
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	8b 55 08             	mov    0x8(%ebp),%edx
  800e73:	89 df                	mov    %ebx,%edi
  800e75:	89 de                	mov    %ebx,%esi
  800e77:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	7e 28                	jle    800ea5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e81:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e88:	00 
  800e89:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  800e90:	00 
  800e91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e98:	00 
  800e99:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  800ea0:	e8 d3 06 00 00       	call   801578 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ea5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ea8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eae:	89 ec                	mov    %ebp,%esp
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	83 ec 38             	sub    $0x38,%esp
  800eb8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ebb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ebe:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec6:	b8 06 00 00 00       	mov    $0x6,%eax
  800ecb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	89 df                	mov    %ebx,%edi
  800ed3:	89 de                	mov    %ebx,%esi
  800ed5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	7e 28                	jle    800f03 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800edb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800edf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ee6:	00 
  800ee7:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  800eee:	00 
  800eef:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef6:	00 
  800ef7:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  800efe:	e8 75 06 00 00       	call   801578 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f03:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f06:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f09:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f0c:	89 ec                	mov    %ebp,%esp
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 38             	sub    $0x38,%esp
  800f16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f19:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f1c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f24:	8b 75 18             	mov    0x18(%ebp),%esi
  800f27:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	7e 28                	jle    800f61 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f39:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f44:	00 
  800f45:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  800f4c:	00 
  800f4d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f54:	00 
  800f55:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  800f5c:	e8 17 06 00 00       	call   801578 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f61:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f64:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f67:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f6a:	89 ec                	mov    %ebp,%esp
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    

00800f6e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 38             	sub    $0x38,%esp
  800f74:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f77:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f7a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7d:	be 00 00 00 00       	mov    $0x0,%esi
  800f82:	b8 04 00 00 00       	mov    $0x4,%eax
  800f87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	89 f7                	mov    %esi,%edi
  800f92:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f94:	85 c0                	test   %eax,%eax
  800f96:	7e 28                	jle    800fc0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f98:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fa3:	00 
  800fa4:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  800fab:	00 
  800fac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb3:	00 
  800fb4:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  800fbb:	e8 b8 05 00 00       	call   801578 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fc0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fc3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fc6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fc9:	89 ec                	mov    %ebp,%esp
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 0c             	sub    $0xc,%esp
  800fd3:	89 1c 24             	mov    %ebx,(%esp)
  800fd6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fda:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fde:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fe8:	89 d1                	mov    %edx,%ecx
  800fea:	89 d3                	mov    %edx,%ebx
  800fec:	89 d7                	mov    %edx,%edi
  800fee:	89 d6                	mov    %edx,%esi
  800ff0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ff2:	8b 1c 24             	mov    (%esp),%ebx
  800ff5:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ff9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ffd:	89 ec                	mov    %ebp,%esp
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	89 1c 24             	mov    %ebx,(%esp)
  80100a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80100e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801012:	ba 00 00 00 00       	mov    $0x0,%edx
  801017:	b8 02 00 00 00       	mov    $0x2,%eax
  80101c:	89 d1                	mov    %edx,%ecx
  80101e:	89 d3                	mov    %edx,%ebx
  801020:	89 d7                	mov    %edx,%edi
  801022:	89 d6                	mov    %edx,%esi
  801024:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801026:	8b 1c 24             	mov    (%esp),%ebx
  801029:	8b 74 24 04          	mov    0x4(%esp),%esi
  80102d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801031:	89 ec                	mov    %ebp,%esp
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    

00801035 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 38             	sub    $0x38,%esp
  80103b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80103e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801041:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801044:	b9 00 00 00 00       	mov    $0x0,%ecx
  801049:	b8 03 00 00 00       	mov    $0x3,%eax
  80104e:	8b 55 08             	mov    0x8(%ebp),%edx
  801051:	89 cb                	mov    %ecx,%ebx
  801053:	89 cf                	mov    %ecx,%edi
  801055:	89 ce                	mov    %ecx,%esi
  801057:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801059:	85 c0                	test   %eax,%eax
  80105b:	7e 28                	jle    801085 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80105d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801061:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801068:	00 
  801069:	c7 44 24 08 47 1c 80 	movl   $0x801c47,0x8(%esp)
  801070:	00 
  801071:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801078:	00 
  801079:	c7 04 24 64 1c 80 00 	movl   $0x801c64,(%esp)
  801080:	e8 f3 04 00 00       	call   801578 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801085:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801088:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80108b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80108e:	89 ec                	mov    %ebp,%esp
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    
	...

00801094 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80109a:	c7 44 24 08 72 1c 80 	movl   $0x801c72,0x8(%esp)
  8010a1:	00 
  8010a2:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  8010a9:	00 
  8010aa:	c7 04 24 88 1c 80 00 	movl   $0x801c88,(%esp)
  8010b1:	e8 c2 04 00 00       	call   801578 <_panic>

008010b6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
  8010bc:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  8010bf:	c7 04 24 24 13 80 00 	movl   $0x801324,(%esp)
  8010c6:	e8 05 05 00 00       	call   8015d0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8010cb:	ba 07 00 00 00       	mov    $0x7,%edx
  8010d0:	89 d0                	mov    %edx,%eax
  8010d2:	cd 30                	int    $0x30
  8010d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	79 20                	jns    8010fb <fork+0x45>
		panic("sys_exofork: %e", envid);
  8010db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010df:	c7 44 24 08 93 1c 80 	movl   $0x801c93,0x8(%esp)
  8010e6:	00 
  8010e7:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8010ee:	00 
  8010ef:	c7 04 24 88 1c 80 00 	movl   $0x801c88,(%esp)
  8010f6:	e8 7d 04 00 00       	call   801578 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  8010fb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801102:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801107:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80110b:	75 21                	jne    80112e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80110d:	e8 ef fe ff ff       	call   801001 <sys_getenvid>
  801112:	25 ff 03 00 00       	and    $0x3ff,%eax
  801117:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80111a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80111f:	a3 04 20 80 00       	mov    %eax,0x802004
  801124:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801129:	e9 e5 01 00 00       	jmp    801313 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80112e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801131:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801138:	a8 01                	test   $0x1,%al
  80113a:	0f 84 4c 01 00 00    	je     80128c <fork+0x1d6>
  801140:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801146:	0f 84 cf 01 00 00    	je     80131b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  80114c:	c1 e2 16             	shl    $0x16,%edx
  80114f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801152:	89 d3                	mov    %edx,%ebx
  801154:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80115b:	00 
  80115c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801160:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801163:	89 04 24             	mov    %eax,(%esp)
  801166:	e8 03 fe ff ff       	call   800f6e <sys_page_alloc>
			if(ret < 0) return ret;
  80116b:	85 c0                	test   %eax,%eax
  80116d:	0f 88 a0 01 00 00    	js     801313 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801173:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801177:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80117a:	89 14 24             	mov    %edx,(%esp)
  80117d:	e8 30 fd ff ff       	call   800eb2 <sys_page_unmap>
			if(ret < 0) return ret;
  801182:	85 c0                	test   %eax,%eax
  801184:	0f 88 89 01 00 00    	js     801313 <fork+0x25d>
  80118a:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  80118f:	89 de                	mov    %ebx,%esi
  801191:	c1 e6 0c             	shl    $0xc,%esi
  801194:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801197:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  80119d:	0f 84 da 00 00 00    	je     80127d <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8011a3:	c1 ee 0c             	shr    $0xc,%esi
  8011a6:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8011a9:	a8 01                	test   $0x1,%al
  8011ab:	0f 84 cc 00 00 00    	je     80127d <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  8011b1:	89 f0                	mov    %esi,%eax
  8011b3:	c1 e0 0c             	shl    $0xc,%eax
  8011b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  8011b9:	e8 43 fe ff ff       	call   801001 <sys_getenvid>
  8011be:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  8011c1:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8011c4:	89 c6                	mov    %eax,%esi
  8011c6:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  8011cc:	25 01 04 00 00       	and    $0x401,%eax
  8011d1:	3d 01 04 00 00       	cmp    $0x401,%eax
  8011d6:	75 3a                	jne    801212 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  8011d8:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  8011df:	00 
  8011e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011e3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8011f5:	89 14 24             	mov    %edx,(%esp)
  8011f8:	e8 13 fd ff ff       	call   800f10 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  8011fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801200:	89 44 24 04          	mov    %eax,0x4(%esp)
  801204:	c7 04 24 a3 1c 80 00 	movl   $0x801ca3,(%esp)
  80120b:	e8 ad ef ff ff       	call   8001bd <cprintf>
  801210:	eb 6b                	jmp    80127d <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801212:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801218:	74 14                	je     80122e <fork+0x178>
  80121a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801220:	74 0c                	je     80122e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801222:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801228:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80122e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801231:	89 74 24 10          	mov    %esi,0x10(%esp)
  801235:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801239:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80123c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801240:	89 54 24 04          	mov    %edx,0x4(%esp)
  801244:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801247:	89 14 24             	mov    %edx,(%esp)
  80124a:	e8 c1 fc ff ff       	call   800f10 <sys_page_map>
	if(ret<0) return ret;
  80124f:	85 c0                	test   %eax,%eax
  801251:	0f 88 bc 00 00 00    	js     801313 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801257:	89 74 24 10          	mov    %esi,0x10(%esp)
  80125b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80125e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801262:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801265:	89 54 24 08          	mov    %edx,0x8(%esp)
  801269:	89 44 24 04          	mov    %eax,0x4(%esp)
  80126d:	89 14 24             	mov    %edx,(%esp)
  801270:	e8 9b fc ff ff       	call   800f10 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801275:	85 c0                	test   %eax,%eax
  801277:	0f 88 96 00 00 00    	js     801313 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  80127d:	83 c3 01             	add    $0x1,%ebx
  801280:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801286:	0f 85 03 ff ff ff    	jne    80118f <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80128c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801290:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801297:	0f 85 91 fe ff ff    	jne    80112e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  80129d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012a4:	00 
  8012a5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012ac:	ee 
  8012ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012b0:	89 04 24             	mov    %eax,(%esp)
  8012b3:	e8 b6 fc ff ff       	call   800f6e <sys_page_alloc>
	if(ret < 0) return ret;
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	78 57                	js     801313 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  8012bc:	a1 04 20 80 00       	mov    0x802004,%eax
  8012c1:	8b 40 64             	mov    0x64(%eax),%eax
  8012c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8012cb:	89 14 24             	mov    %edx,(%esp)
  8012ce:	e8 c5 fa ff ff       	call   800d98 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 3c                	js     801313 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012d7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8012de:	00 
  8012df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012e2:	89 04 24             	mov    %eax,(%esp)
  8012e5:	e8 6a fb ff ff       	call   800e54 <sys_env_set_status>
  8012ea:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  8012ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012ef:	85 d2                	test   %edx,%edx
  8012f1:	79 20                	jns    801313 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  8012f3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012f7:	c7 44 24 08 ba 1c 80 	movl   $0x801cba,0x8(%esp)
  8012fe:	00 
  8012ff:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801306:	00 
  801307:	c7 04 24 88 1c 80 00 	movl   $0x801c88,(%esp)
  80130e:	e8 65 02 00 00       	call   801578 <_panic>

	return envid;
}
  801313:	83 c4 4c             	add    $0x4c,%esp
  801316:	5b                   	pop    %ebx
  801317:	5e                   	pop    %esi
  801318:	5f                   	pop    %edi
  801319:	5d                   	pop    %ebp
  80131a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80131b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80131f:	e9 0a fe ff ff       	jmp    80112e <fork+0x78>

00801324 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
  801329:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80132c:	e8 d0 fc ff ff       	call   801001 <sys_getenvid>
  801331:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	89 c6                	mov    %eax,%esi
  80133a:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  80133d:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801344:	f6 c2 02             	test   $0x2,%dl
  801347:	75 2c                	jne    801375 <pgfault+0x51>
  801349:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801350:	f6 c6 08             	test   $0x8,%dh
  801353:	75 20                	jne    801375 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801355:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801359:	c7 44 24 08 08 1d 80 	movl   $0x801d08,0x8(%esp)
  801360:	00 
  801361:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801368:	00 
  801369:	c7 04 24 88 1c 80 00 	movl   $0x801c88,(%esp)
  801370:	e8 03 02 00 00       	call   801578 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801375:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80137c:	00 
  80137d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801384:	00 
  801385:	89 1c 24             	mov    %ebx,(%esp)
  801388:	e8 e1 fb ff ff       	call   800f6e <sys_page_alloc>
  80138d:	85 c0                	test   %eax,%eax
  80138f:	79 20                	jns    8013b1 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801391:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801395:	c7 44 24 08 d1 1c 80 	movl   $0x801cd1,0x8(%esp)
  80139c:	00 
  80139d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8013a4:	00 
  8013a5:	c7 04 24 88 1c 80 00 	movl   $0x801c88,(%esp)
  8013ac:	e8 c7 01 00 00       	call   801578 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  8013b1:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  8013b4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013bb:	00 
  8013bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c0:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8013c7:	e8 03 f6 ff ff       	call   8009cf <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8013cc:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8013d3:	00 
  8013d4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013dc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8013e3:	00 
  8013e4:	89 1c 24             	mov    %ebx,(%esp)
  8013e7:	e8 24 fb ff ff       	call   800f10 <sys_page_map>
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	79 20                	jns    801410 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  8013f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013f4:	c7 44 24 08 e3 1c 80 	movl   $0x801ce3,0x8(%esp)
  8013fb:	00 
  8013fc:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801403:	00 
  801404:	c7 04 24 88 1c 80 00 	movl   $0x801c88,(%esp)
  80140b:	e8 68 01 00 00       	call   801578 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801410:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801417:	00 
  801418:	89 1c 24             	mov    %ebx,(%esp)
  80141b:	e8 92 fa ff ff       	call   800eb2 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801420:	85 c0                	test   %eax,%eax
  801422:	74 20                	je     801444 <pgfault+0x120>
  801424:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801428:	c7 44 24 08 f3 1c 80 	movl   $0x801cf3,0x8(%esp)
  80142f:	00 
  801430:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801437:	00 
  801438:	c7 04 24 88 1c 80 00 	movl   $0x801c88,(%esp)
  80143f:	e8 34 01 00 00       	call   801578 <_panic>

}
  801444:	83 c4 20             	add    $0x20,%esp
  801447:	5b                   	pop    %ebx
  801448:	5e                   	pop    %esi
  801449:	5d                   	pop    %ebp
  80144a:	c3                   	ret    
	...

0080144c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801452:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801457:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80145a:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  801460:	8b 12                	mov    (%edx),%edx
  801462:	39 ca                	cmp    %ecx,%edx
  801464:	75 0c                	jne    801472 <ipc_find_env+0x26>
			return envs[i].env_id;
  801466:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801469:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  80146e:	8b 00                	mov    (%eax),%eax
  801470:	eb 0e                	jmp    801480 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801472:	83 c0 01             	add    $0x1,%eax
  801475:	3d 00 04 00 00       	cmp    $0x400,%eax
  80147a:	75 db                	jne    801457 <ipc_find_env+0xb>
  80147c:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    

00801482 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	57                   	push   %edi
  801486:	56                   	push   %esi
  801487:	53                   	push   %ebx
  801488:	83 ec 2c             	sub    $0x2c,%esp
  80148b:	8b 75 08             	mov    0x8(%ebp),%esi
  80148e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801491:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  801494:	85 db                	test   %ebx,%ebx
  801496:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80149b:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  80149e:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014a5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014ad:	89 34 24             	mov    %esi,(%esp)
  8014b0:	e8 ab f8 ff ff       	call   800d60 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  8014b5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014b8:	74 e4                	je     80149e <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	74 28                	je     8014e6 <ipc_send+0x64>
  8014be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014c2:	c7 44 24 0c 46 1d 80 	movl   $0x801d46,0xc(%esp)
  8014c9:	00 
  8014ca:	c7 44 24 08 29 1d 80 	movl   $0x801d29,0x8(%esp)
  8014d1:	00 
  8014d2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8014d9:	00 
  8014da:	c7 04 24 3c 1d 80 00 	movl   $0x801d3c,(%esp)
  8014e1:	e8 92 00 00 00       	call   801578 <_panic>
	//if(!ret) sys_yield();
}
  8014e6:	83 c4 2c             	add    $0x2c,%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5e                   	pop    %esi
  8014eb:	5f                   	pop    %edi
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    

008014ee <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 28             	sub    $0x28,%esp
  8014f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8014fd:	8b 75 08             	mov    0x8(%ebp),%esi
  801500:	8b 45 0c             	mov    0xc(%ebp),%eax
  801503:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  801506:	85 c0                	test   %eax,%eax
  801508:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80150d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801510:	89 04 24             	mov    %eax,(%esp)
  801513:	e8 eb f7 ff ff       	call   800d03 <sys_ipc_recv>
  801518:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  80151a:	e8 e2 fa ff ff       	call   801001 <sys_getenvid>
  80151f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801524:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801527:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80152c:	a3 04 20 80 00       	mov    %eax,0x802004
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  801531:	85 f6                	test   %esi,%esi
  801533:	74 0e                	je     801543 <ipc_recv+0x55>
  801535:	ba 00 00 00 00       	mov    $0x0,%edx
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	75 03                	jne    801541 <ipc_recv+0x53>
  80153e:	8b 50 74             	mov    0x74(%eax),%edx
  801541:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  801543:	85 ff                	test   %edi,%edi
  801545:	74 13                	je     80155a <ipc_recv+0x6c>
  801547:	b8 00 00 00 00       	mov    $0x0,%eax
  80154c:	85 db                	test   %ebx,%ebx
  80154e:	75 08                	jne    801558 <ipc_recv+0x6a>
  801550:	a1 04 20 80 00       	mov    0x802004,%eax
  801555:	8b 40 78             	mov    0x78(%eax),%eax
  801558:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  80155a:	85 db                	test   %ebx,%ebx
  80155c:	75 08                	jne    801566 <ipc_recv+0x78>
  80155e:	a1 04 20 80 00       	mov    0x802004,%eax
  801563:	8b 58 70             	mov    0x70(%eax),%ebx
}
  801566:	89 d8                	mov    %ebx,%eax
  801568:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80156b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80156e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801571:	89 ec                	mov    %ebp,%esp
  801573:	5d                   	pop    %ebp
  801574:	c3                   	ret    
  801575:	00 00                	add    %al,(%eax)
	...

00801578 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	56                   	push   %esi
  80157c:	53                   	push   %ebx
  80157d:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  801580:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801583:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  801589:	e8 73 fa ff ff       	call   801001 <sys_getenvid>
  80158e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801591:	89 54 24 10          	mov    %edx,0x10(%esp)
  801595:	8b 55 08             	mov    0x8(%ebp),%edx
  801598:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80159c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a4:	c7 04 24 50 1d 80 00 	movl   $0x801d50,(%esp)
  8015ab:	e8 0d ec ff ff       	call   8001bd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8015b0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b7:	89 04 24             	mov    %eax,(%esp)
  8015ba:	e8 9d eb ff ff       	call   80015c <vcprintf>
	cprintf("\n");
  8015bf:	c7 04 24 3a 1d 80 00 	movl   $0x801d3a,(%esp)
  8015c6:	e8 f2 eb ff ff       	call   8001bd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8015cb:	cc                   	int3   
  8015cc:	eb fd                	jmp    8015cb <_panic+0x53>
	...

008015d0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  8015d7:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8015de:	75 5b                	jne    80163b <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  8015e0:	e8 1c fa ff ff       	call   801001 <sys_getenvid>
  8015e5:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  8015e7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015ee:	00 
  8015ef:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015f6:	ee 
  8015f7:	89 04 24             	mov    %eax,(%esp)
  8015fa:	e8 6f f9 ff ff       	call   800f6e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  8015ff:	85 c0                	test   %eax,%eax
  801601:	74 28                	je     80162b <set_pgfault_handler+0x5b>
  801603:	89 44 24 10          	mov    %eax,0x10(%esp)
  801607:	c7 44 24 0c 9b 1d 80 	movl   $0x801d9b,0xc(%esp)
  80160e:	00 
  80160f:	c7 44 24 08 74 1d 80 	movl   $0x801d74,0x8(%esp)
  801616:	00 
  801617:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80161e:	00 
  80161f:	c7 04 24 8d 1d 80 00 	movl   $0x801d8d,(%esp)
  801626:	e8 4d ff ff ff       	call   801578 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80162b:	c7 44 24 04 4c 16 80 	movl   $0x80164c,0x4(%esp)
  801632:	00 
  801633:	89 1c 24             	mov    %ebx,(%esp)
  801636:	e8 5d f7 ff ff       	call   800d98 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	a3 08 20 80 00       	mov    %eax,0x802008
	
}
  801643:	83 c4 24             	add    $0x24,%esp
  801646:	5b                   	pop    %ebx
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    
  801649:	00 00                	add    %al,(%eax)
	...

0080164c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80164c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80164d:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801652:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801654:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  801657:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  80165a:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  80165e:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  801662:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  801665:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  801668:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  80166c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  80166d:	83 c4 04             	add    $0x4,%esp
	popfl ;
  801670:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  801671:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801672:	c3                   	ret    
	...

00801680 <__udivdi3>:
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	57                   	push   %edi
  801684:	56                   	push   %esi
  801685:	83 ec 10             	sub    $0x10,%esp
  801688:	8b 45 14             	mov    0x14(%ebp),%eax
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 75 10             	mov    0x10(%ebp),%esi
  801691:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801694:	85 c0                	test   %eax,%eax
  801696:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801699:	75 35                	jne    8016d0 <__udivdi3+0x50>
  80169b:	39 fe                	cmp    %edi,%esi
  80169d:	77 61                	ja     801700 <__udivdi3+0x80>
  80169f:	85 f6                	test   %esi,%esi
  8016a1:	75 0b                	jne    8016ae <__udivdi3+0x2e>
  8016a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a8:	31 d2                	xor    %edx,%edx
  8016aa:	f7 f6                	div    %esi
  8016ac:	89 c6                	mov    %eax,%esi
  8016ae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016b1:	31 d2                	xor    %edx,%edx
  8016b3:	89 f8                	mov    %edi,%eax
  8016b5:	f7 f6                	div    %esi
  8016b7:	89 c7                	mov    %eax,%edi
  8016b9:	89 c8                	mov    %ecx,%eax
  8016bb:	f7 f6                	div    %esi
  8016bd:	89 c1                	mov    %eax,%ecx
  8016bf:	89 fa                	mov    %edi,%edx
  8016c1:	89 c8                	mov    %ecx,%eax
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	5e                   	pop    %esi
  8016c7:	5f                   	pop    %edi
  8016c8:	5d                   	pop    %ebp
  8016c9:	c3                   	ret    
  8016ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8016d0:	39 f8                	cmp    %edi,%eax
  8016d2:	77 1c                	ja     8016f0 <__udivdi3+0x70>
  8016d4:	0f bd d0             	bsr    %eax,%edx
  8016d7:	83 f2 1f             	xor    $0x1f,%edx
  8016da:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8016dd:	75 39                	jne    801718 <__udivdi3+0x98>
  8016df:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8016e2:	0f 86 a0 00 00 00    	jbe    801788 <__udivdi3+0x108>
  8016e8:	39 f8                	cmp    %edi,%eax
  8016ea:	0f 82 98 00 00 00    	jb     801788 <__udivdi3+0x108>
  8016f0:	31 ff                	xor    %edi,%edi
  8016f2:	31 c9                	xor    %ecx,%ecx
  8016f4:	89 c8                	mov    %ecx,%eax
  8016f6:	89 fa                	mov    %edi,%edx
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	5e                   	pop    %esi
  8016fc:	5f                   	pop    %edi
  8016fd:	5d                   	pop    %ebp
  8016fe:	c3                   	ret    
  8016ff:	90                   	nop
  801700:	89 d1                	mov    %edx,%ecx
  801702:	89 fa                	mov    %edi,%edx
  801704:	89 c8                	mov    %ecx,%eax
  801706:	31 ff                	xor    %edi,%edi
  801708:	f7 f6                	div    %esi
  80170a:	89 c1                	mov    %eax,%ecx
  80170c:	89 fa                	mov    %edi,%edx
  80170e:	89 c8                	mov    %ecx,%eax
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	5e                   	pop    %esi
  801714:	5f                   	pop    %edi
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    
  801717:	90                   	nop
  801718:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80171c:	89 f2                	mov    %esi,%edx
  80171e:	d3 e0                	shl    %cl,%eax
  801720:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801723:	b8 20 00 00 00       	mov    $0x20,%eax
  801728:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80172b:	89 c1                	mov    %eax,%ecx
  80172d:	d3 ea                	shr    %cl,%edx
  80172f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801733:	0b 55 ec             	or     -0x14(%ebp),%edx
  801736:	d3 e6                	shl    %cl,%esi
  801738:	89 c1                	mov    %eax,%ecx
  80173a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80173d:	89 fe                	mov    %edi,%esi
  80173f:	d3 ee                	shr    %cl,%esi
  801741:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801745:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801748:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174b:	d3 e7                	shl    %cl,%edi
  80174d:	89 c1                	mov    %eax,%ecx
  80174f:	d3 ea                	shr    %cl,%edx
  801751:	09 d7                	or     %edx,%edi
  801753:	89 f2                	mov    %esi,%edx
  801755:	89 f8                	mov    %edi,%eax
  801757:	f7 75 ec             	divl   -0x14(%ebp)
  80175a:	89 d6                	mov    %edx,%esi
  80175c:	89 c7                	mov    %eax,%edi
  80175e:	f7 65 e8             	mull   -0x18(%ebp)
  801761:	39 d6                	cmp    %edx,%esi
  801763:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801766:	72 30                	jb     801798 <__udivdi3+0x118>
  801768:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80176b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80176f:	d3 e2                	shl    %cl,%edx
  801771:	39 c2                	cmp    %eax,%edx
  801773:	73 05                	jae    80177a <__udivdi3+0xfa>
  801775:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801778:	74 1e                	je     801798 <__udivdi3+0x118>
  80177a:	89 f9                	mov    %edi,%ecx
  80177c:	31 ff                	xor    %edi,%edi
  80177e:	e9 71 ff ff ff       	jmp    8016f4 <__udivdi3+0x74>
  801783:	90                   	nop
  801784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801788:	31 ff                	xor    %edi,%edi
  80178a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80178f:	e9 60 ff ff ff       	jmp    8016f4 <__udivdi3+0x74>
  801794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801798:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80179b:	31 ff                	xor    %edi,%edi
  80179d:	89 c8                	mov    %ecx,%eax
  80179f:	89 fa                	mov    %edi,%edx
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	5e                   	pop    %esi
  8017a5:	5f                   	pop    %edi
  8017a6:	5d                   	pop    %ebp
  8017a7:	c3                   	ret    
	...

008017b0 <__umoddi3>:
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	57                   	push   %edi
  8017b4:	56                   	push   %esi
  8017b5:	83 ec 20             	sub    $0x20,%esp
  8017b8:	8b 55 14             	mov    0x14(%ebp),%edx
  8017bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017be:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017c4:	85 d2                	test   %edx,%edx
  8017c6:	89 c8                	mov    %ecx,%eax
  8017c8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8017cb:	75 13                	jne    8017e0 <__umoddi3+0x30>
  8017cd:	39 f7                	cmp    %esi,%edi
  8017cf:	76 3f                	jbe    801810 <__umoddi3+0x60>
  8017d1:	89 f2                	mov    %esi,%edx
  8017d3:	f7 f7                	div    %edi
  8017d5:	89 d0                	mov    %edx,%eax
  8017d7:	31 d2                	xor    %edx,%edx
  8017d9:	83 c4 20             	add    $0x20,%esp
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    
  8017e0:	39 f2                	cmp    %esi,%edx
  8017e2:	77 4c                	ja     801830 <__umoddi3+0x80>
  8017e4:	0f bd ca             	bsr    %edx,%ecx
  8017e7:	83 f1 1f             	xor    $0x1f,%ecx
  8017ea:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8017ed:	75 51                	jne    801840 <__umoddi3+0x90>
  8017ef:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8017f2:	0f 87 e0 00 00 00    	ja     8018d8 <__umoddi3+0x128>
  8017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fb:	29 f8                	sub    %edi,%eax
  8017fd:	19 d6                	sbb    %edx,%esi
  8017ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801805:	89 f2                	mov    %esi,%edx
  801807:	83 c4 20             	add    $0x20,%esp
  80180a:	5e                   	pop    %esi
  80180b:	5f                   	pop    %edi
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    
  80180e:	66 90                	xchg   %ax,%ax
  801810:	85 ff                	test   %edi,%edi
  801812:	75 0b                	jne    80181f <__umoddi3+0x6f>
  801814:	b8 01 00 00 00       	mov    $0x1,%eax
  801819:	31 d2                	xor    %edx,%edx
  80181b:	f7 f7                	div    %edi
  80181d:	89 c7                	mov    %eax,%edi
  80181f:	89 f0                	mov    %esi,%eax
  801821:	31 d2                	xor    %edx,%edx
  801823:	f7 f7                	div    %edi
  801825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801828:	f7 f7                	div    %edi
  80182a:	eb a9                	jmp    8017d5 <__umoddi3+0x25>
  80182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801830:	89 c8                	mov    %ecx,%eax
  801832:	89 f2                	mov    %esi,%edx
  801834:	83 c4 20             	add    $0x20,%esp
  801837:	5e                   	pop    %esi
  801838:	5f                   	pop    %edi
  801839:	5d                   	pop    %ebp
  80183a:	c3                   	ret    
  80183b:	90                   	nop
  80183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801840:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801844:	d3 e2                	shl    %cl,%edx
  801846:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801849:	ba 20 00 00 00       	mov    $0x20,%edx
  80184e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801851:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801854:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801858:	89 fa                	mov    %edi,%edx
  80185a:	d3 ea                	shr    %cl,%edx
  80185c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801860:	0b 55 f4             	or     -0xc(%ebp),%edx
  801863:	d3 e7                	shl    %cl,%edi
  801865:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801869:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80186c:	89 f2                	mov    %esi,%edx
  80186e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801871:	89 c7                	mov    %eax,%edi
  801873:	d3 ea                	shr    %cl,%edx
  801875:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801879:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80187c:	89 c2                	mov    %eax,%edx
  80187e:	d3 e6                	shl    %cl,%esi
  801880:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801884:	d3 ea                	shr    %cl,%edx
  801886:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80188a:	09 d6                	or     %edx,%esi
  80188c:	89 f0                	mov    %esi,%eax
  80188e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801891:	d3 e7                	shl    %cl,%edi
  801893:	89 f2                	mov    %esi,%edx
  801895:	f7 75 f4             	divl   -0xc(%ebp)
  801898:	89 d6                	mov    %edx,%esi
  80189a:	f7 65 e8             	mull   -0x18(%ebp)
  80189d:	39 d6                	cmp    %edx,%esi
  80189f:	72 2b                	jb     8018cc <__umoddi3+0x11c>
  8018a1:	39 c7                	cmp    %eax,%edi
  8018a3:	72 23                	jb     8018c8 <__umoddi3+0x118>
  8018a5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018a9:	29 c7                	sub    %eax,%edi
  8018ab:	19 d6                	sbb    %edx,%esi
  8018ad:	89 f0                	mov    %esi,%eax
  8018af:	89 f2                	mov    %esi,%edx
  8018b1:	d3 ef                	shr    %cl,%edi
  8018b3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8018b7:	d3 e0                	shl    %cl,%eax
  8018b9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8018bd:	09 f8                	or     %edi,%eax
  8018bf:	d3 ea                	shr    %cl,%edx
  8018c1:	83 c4 20             	add    $0x20,%esp
  8018c4:	5e                   	pop    %esi
  8018c5:	5f                   	pop    %edi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    
  8018c8:	39 d6                	cmp    %edx,%esi
  8018ca:	75 d9                	jne    8018a5 <__umoddi3+0xf5>
  8018cc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8018cf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8018d2:	eb d1                	jmp    8018a5 <__umoddi3+0xf5>
  8018d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8018d8:	39 f2                	cmp    %esi,%edx
  8018da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8018e0:	0f 82 12 ff ff ff    	jb     8017f8 <__umoddi3+0x48>
  8018e6:	e9 17 ff ff ff       	jmp    801802 <__umoddi3+0x52>
