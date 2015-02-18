
obj/user/spawnhello.debug:     file format elf32-i386


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

00800034 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  80003a:	a1 08 50 80 00       	mov    0x805008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	89 44 24 04          	mov    %eax,0x4(%esp)
  800046:	c7 04 24 c0 2e 80 00 	movl   $0x802ec0,(%esp)
  80004d:	e8 5f 01 00 00       	call   8001b1 <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  800052:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800059:	00 
  80005a:	c7 44 24 04 de 2e 80 	movl   $0x802ede,0x4(%esp)
  800061:	00 
  800062:	c7 04 24 de 2e 80 00 	movl   $0x802ede,(%esp)
  800069:	e8 5f 16 00 00       	call   8016cd <spawnl>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 20                	jns    800092 <umain+0x5e>
		panic("spawn(hello) failed: %e", r);
  800072:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800076:	c7 44 24 08 e4 2e 80 	movl   $0x802ee4,0x8(%esp)
  80007d:	00 
  80007e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800085:	00 
  800086:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  80008d:	e8 66 00 00 00       	call   8000f8 <_panic>
}
  800092:	c9                   	leave  
  800093:	c3                   	ret    

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
  8000a6:	e8 46 0f 00 00       	call   800ff1 <sys_getenvid>
  8000ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b3:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8000b8:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bd:	85 f6                	test   %esi,%esi
  8000bf:	7e 07                	jle    8000c8 <libmain+0x34>
		binaryname = argv[0];
  8000c1:	8b 03                	mov    (%ebx),%eax
  8000c3:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000cc:	89 34 24             	mov    %esi,(%esp)
  8000cf:	e8 60 ff ff ff       	call   800034 <umain>

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
  8000f1:	e8 2f 0f 00 00       	call   801025 <sys_env_destroy>
}
  8000f6:	c9                   	leave  
  8000f7:	c3                   	ret    

008000f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800100:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800103:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  800109:	e8 e3 0e 00 00       	call   800ff1 <sys_getenvid>
  80010e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800111:	89 54 24 10          	mov    %edx,0x10(%esp)
  800115:	8b 55 08             	mov    0x8(%ebp),%edx
  800118:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80011c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800120:	89 44 24 04          	mov    %eax,0x4(%esp)
  800124:	c7 04 24 18 2f 80 00 	movl   $0x802f18,(%esp)
  80012b:	e8 81 00 00 00       	call   8001b1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800130:	89 74 24 04          	mov    %esi,0x4(%esp)
  800134:	8b 45 10             	mov    0x10(%ebp),%eax
  800137:	89 04 24             	mov    %eax,(%esp)
  80013a:	e8 11 00 00 00       	call   800150 <vcprintf>
	cprintf("\n");
  80013f:	c7 04 24 b2 34 80 00 	movl   $0x8034b2,(%esp)
  800146:	e8 66 00 00 00       	call   8001b1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80014b:	cc                   	int3   
  80014c:	eb fd                	jmp    80014b <_panic+0x53>
	...

00800150 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800159:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800160:	00 00 00 
	b.cnt = 0;
  800163:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800170:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800174:	8b 45 08             	mov    0x8(%ebp),%eax
  800177:	89 44 24 08          	mov    %eax,0x8(%esp)
  80017b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 cb 01 80 00 	movl   $0x8001cb,(%esp)
  80018c:	e8 be 01 00 00       	call   80034f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800191:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a1:	89 04 24             	mov    %eax,(%esp)
  8001a4:	e8 27 0a 00 00       	call   800bd0 <sys_cputs>

	return b.cnt;
}
  8001a9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8001b7:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8001ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001be:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c1:	89 04 24             	mov    %eax,(%esp)
  8001c4:	e8 87 ff ff ff       	call   800150 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c9:	c9                   	leave  
  8001ca:	c3                   	ret    

008001cb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 14             	sub    $0x14,%esp
  8001d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d5:	8b 03                	mov    (%ebx),%eax
  8001d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001da:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001de:	83 c0 01             	add    $0x1,%eax
  8001e1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e8:	75 19                	jne    800203 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001ea:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001f1:	00 
  8001f2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f5:	89 04 24             	mov    %eax,(%esp)
  8001f8:	e8 d3 09 00 00       	call   800bd0 <sys_cputs>
		b->idx = 0;
  8001fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800203:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800207:	83 c4 14             	add    $0x14,%esp
  80020a:	5b                   	pop    %ebx
  80020b:	5d                   	pop    %ebp
  80020c:	c3                   	ret    
  80020d:	00 00                	add    %al,(%eax)
	...

00800210 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 4c             	sub    $0x4c,%esp
  800219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80021c:	89 d6                	mov    %edx,%esi
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800224:	8b 55 0c             	mov    0xc(%ebp),%edx
  800227:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80022a:	8b 45 10             	mov    0x10(%ebp),%eax
  80022d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800230:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800233:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800236:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023b:	39 d1                	cmp    %edx,%ecx
  80023d:	72 07                	jb     800246 <printnum+0x36>
  80023f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800242:	39 d0                	cmp    %edx,%eax
  800244:	77 69                	ja     8002af <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800246:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80024a:	83 eb 01             	sub    $0x1,%ebx
  80024d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800251:	89 44 24 08          	mov    %eax,0x8(%esp)
  800255:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800259:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80025d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800260:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800263:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800266:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80026a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800271:	00 
  800272:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800275:	89 04 24             	mov    %eax,(%esp)
  800278:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80027b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80027f:	e8 bc 29 00 00       	call   802c40 <__udivdi3>
  800284:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800287:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80028a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80028e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800292:	89 04 24             	mov    %eax,(%esp)
  800295:	89 54 24 04          	mov    %edx,0x4(%esp)
  800299:	89 f2                	mov    %esi,%edx
  80029b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029e:	e8 6d ff ff ff       	call   800210 <printnum>
  8002a3:	eb 11                	jmp    8002b6 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002a9:	89 3c 24             	mov    %edi,(%esp)
  8002ac:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002af:	83 eb 01             	sub    $0x1,%ebx
  8002b2:	85 db                	test   %ebx,%ebx
  8002b4:	7f ef                	jg     8002a5 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ba:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002cc:	00 
  8002cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002d0:	89 14 24             	mov    %edx,(%esp)
  8002d3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002da:	e8 91 2a 00 00       	call   802d70 <__umoddi3>
  8002df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002e3:	0f be 80 3b 2f 80 00 	movsbl 0x802f3b(%eax),%eax
  8002ea:	89 04 24             	mov    %eax,(%esp)
  8002ed:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002f0:	83 c4 4c             	add    $0x4c,%esp
  8002f3:	5b                   	pop    %ebx
  8002f4:	5e                   	pop    %esi
  8002f5:	5f                   	pop    %edi
  8002f6:	5d                   	pop    %ebp
  8002f7:	c3                   	ret    

008002f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002fb:	83 fa 01             	cmp    $0x1,%edx
  8002fe:	7e 0e                	jle    80030e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800300:	8b 10                	mov    (%eax),%edx
  800302:	8d 4a 08             	lea    0x8(%edx),%ecx
  800305:	89 08                	mov    %ecx,(%eax)
  800307:	8b 02                	mov    (%edx),%eax
  800309:	8b 52 04             	mov    0x4(%edx),%edx
  80030c:	eb 22                	jmp    800330 <getuint+0x38>
	else if (lflag)
  80030e:	85 d2                	test   %edx,%edx
  800310:	74 10                	je     800322 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800312:	8b 10                	mov    (%eax),%edx
  800314:	8d 4a 04             	lea    0x4(%edx),%ecx
  800317:	89 08                	mov    %ecx,(%eax)
  800319:	8b 02                	mov    (%edx),%eax
  80031b:	ba 00 00 00 00       	mov    $0x0,%edx
  800320:	eb 0e                	jmp    800330 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800322:	8b 10                	mov    (%eax),%edx
  800324:	8d 4a 04             	lea    0x4(%edx),%ecx
  800327:	89 08                	mov    %ecx,(%eax)
  800329:	8b 02                	mov    (%edx),%eax
  80032b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    

00800332 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800338:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033c:	8b 10                	mov    (%eax),%edx
  80033e:	3b 50 04             	cmp    0x4(%eax),%edx
  800341:	73 0a                	jae    80034d <sprintputch+0x1b>
		*b->buf++ = ch;
  800343:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800346:	88 0a                	mov    %cl,(%edx)
  800348:	83 c2 01             	add    $0x1,%edx
  80034b:	89 10                	mov    %edx,(%eax)
}
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	57                   	push   %edi
  800353:	56                   	push   %esi
  800354:	53                   	push   %ebx
  800355:	83 ec 4c             	sub    $0x4c,%esp
  800358:	8b 7d 08             	mov    0x8(%ebp),%edi
  80035b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80035e:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800361:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800368:	eb 11                	jmp    80037b <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80036a:	85 c0                	test   %eax,%eax
  80036c:	0f 84 b6 03 00 00    	je     800728 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800372:	89 74 24 04          	mov    %esi,0x4(%esp)
  800376:	89 04 24             	mov    %eax,(%esp)
  800379:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80037b:	0f b6 03             	movzbl (%ebx),%eax
  80037e:	83 c3 01             	add    $0x1,%ebx
  800381:	83 f8 25             	cmp    $0x25,%eax
  800384:	75 e4                	jne    80036a <vprintfmt+0x1b>
  800386:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80038a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800391:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800398:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80039f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003a4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8003a7:	eb 06                	jmp    8003af <vprintfmt+0x60>
  8003a9:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8003ad:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	0f b6 0b             	movzbl (%ebx),%ecx
  8003b2:	0f b6 c1             	movzbl %cl,%eax
  8003b5:	8d 53 01             	lea    0x1(%ebx),%edx
  8003b8:	83 e9 23             	sub    $0x23,%ecx
  8003bb:	80 f9 55             	cmp    $0x55,%cl
  8003be:	0f 87 47 03 00 00    	ja     80070b <vprintfmt+0x3bc>
  8003c4:	0f b6 c9             	movzbl %cl,%ecx
  8003c7:	ff 24 8d 80 30 80 00 	jmp    *0x803080(,%ecx,4)
  8003ce:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8003d2:	eb d9                	jmp    8003ad <vprintfmt+0x5e>
  8003d4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8003db:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003e0:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003e3:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003e7:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8003ea:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003ed:	83 fb 09             	cmp    $0x9,%ebx
  8003f0:	77 30                	ja     800422 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003f2:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003f5:	eb e9                	jmp    8003e0 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fa:	8d 48 04             	lea    0x4(%eax),%ecx
  8003fd:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800400:	8b 00                	mov    (%eax),%eax
  800402:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800405:	eb 1e                	jmp    800425 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800407:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80040b:	b8 00 00 00 00       	mov    $0x0,%eax
  800410:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800417:	eb 94                	jmp    8003ad <vprintfmt+0x5e>
  800419:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800420:	eb 8b                	jmp    8003ad <vprintfmt+0x5e>
  800422:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800425:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800429:	79 82                	jns    8003ad <vprintfmt+0x5e>
  80042b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80042e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800431:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800434:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800437:	e9 71 ff ff ff       	jmp    8003ad <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80043c:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800440:	e9 68 ff ff ff       	jmp    8003ad <vprintfmt+0x5e>
  800445:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800448:	8b 45 14             	mov    0x14(%ebp),%eax
  80044b:	8d 50 04             	lea    0x4(%eax),%edx
  80044e:	89 55 14             	mov    %edx,0x14(%ebp)
  800451:	89 74 24 04          	mov    %esi,0x4(%esp)
  800455:	8b 00                	mov    (%eax),%eax
  800457:	89 04 24             	mov    %eax,(%esp)
  80045a:	ff d7                	call   *%edi
  80045c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80045f:	e9 17 ff ff ff       	jmp    80037b <vprintfmt+0x2c>
  800464:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	8d 50 04             	lea    0x4(%eax),%edx
  80046d:	89 55 14             	mov    %edx,0x14(%ebp)
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 c2                	mov    %eax,%edx
  800474:	c1 fa 1f             	sar    $0x1f,%edx
  800477:	31 d0                	xor    %edx,%eax
  800479:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047b:	83 f8 11             	cmp    $0x11,%eax
  80047e:	7f 0b                	jg     80048b <vprintfmt+0x13c>
  800480:	8b 14 85 e0 31 80 00 	mov    0x8031e0(,%eax,4),%edx
  800487:	85 d2                	test   %edx,%edx
  800489:	75 20                	jne    8004ab <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80048b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80048f:	c7 44 24 08 4c 2f 80 	movl   $0x802f4c,0x8(%esp)
  800496:	00 
  800497:	89 74 24 04          	mov    %esi,0x4(%esp)
  80049b:	89 3c 24             	mov    %edi,(%esp)
  80049e:	e8 0d 03 00 00       	call   8007b0 <printfmt>
  8004a3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a6:	e9 d0 fe ff ff       	jmp    80037b <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8004ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004af:	c7 44 24 08 9e 32 80 	movl   $0x80329e,0x8(%esp)
  8004b6:	00 
  8004b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004bb:	89 3c 24             	mov    %edi,(%esp)
  8004be:	e8 ed 02 00 00       	call   8007b0 <printfmt>
  8004c3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8004c6:	e9 b0 fe ff ff       	jmp    80037b <vprintfmt+0x2c>
  8004cb:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8004ce:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004da:	8d 50 04             	lea    0x4(%eax),%edx
  8004dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e0:	8b 18                	mov    (%eax),%ebx
  8004e2:	85 db                	test   %ebx,%ebx
  8004e4:	b8 55 2f 80 00       	mov    $0x802f55,%eax
  8004e9:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8004ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f0:	7e 76                	jle    800568 <vprintfmt+0x219>
  8004f2:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8004f6:	74 7a                	je     800572 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004fc:	89 1c 24             	mov    %ebx,(%esp)
  8004ff:	e8 f4 02 00 00       	call   8007f8 <strnlen>
  800504:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800507:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800509:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  80050d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800510:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800513:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800515:	eb 0f                	jmp    800526 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800517:	89 74 24 04          	mov    %esi,0x4(%esp)
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800523:	83 eb 01             	sub    $0x1,%ebx
  800526:	85 db                	test   %ebx,%ebx
  800528:	7f ed                	jg     800517 <vprintfmt+0x1c8>
  80052a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80052d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800530:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800533:	89 f7                	mov    %esi,%edi
  800535:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800538:	eb 40                	jmp    80057a <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80053a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80053e:	74 18                	je     800558 <vprintfmt+0x209>
  800540:	8d 50 e0             	lea    -0x20(%eax),%edx
  800543:	83 fa 5e             	cmp    $0x5e,%edx
  800546:	76 10                	jbe    800558 <vprintfmt+0x209>
					putch('?', putdat);
  800548:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800553:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800556:	eb 0a                	jmp    800562 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800558:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055c:	89 04 24             	mov    %eax,(%esp)
  80055f:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800562:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800566:	eb 12                	jmp    80057a <vprintfmt+0x22b>
  800568:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80056b:	89 f7                	mov    %esi,%edi
  80056d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800570:	eb 08                	jmp    80057a <vprintfmt+0x22b>
  800572:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800575:	89 f7                	mov    %esi,%edi
  800577:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80057a:	0f be 03             	movsbl (%ebx),%eax
  80057d:	83 c3 01             	add    $0x1,%ebx
  800580:	85 c0                	test   %eax,%eax
  800582:	74 25                	je     8005a9 <vprintfmt+0x25a>
  800584:	85 f6                	test   %esi,%esi
  800586:	78 b2                	js     80053a <vprintfmt+0x1eb>
  800588:	83 ee 01             	sub    $0x1,%esi
  80058b:	79 ad                	jns    80053a <vprintfmt+0x1eb>
  80058d:	89 fe                	mov    %edi,%esi
  80058f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800592:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800595:	eb 1a                	jmp    8005b1 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800597:	89 74 24 04          	mov    %esi,0x4(%esp)
  80059b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005a2:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005a4:	83 eb 01             	sub    $0x1,%ebx
  8005a7:	eb 08                	jmp    8005b1 <vprintfmt+0x262>
  8005a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005ac:	89 fe                	mov    %edi,%esi
  8005ae:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005b1:	85 db                	test   %ebx,%ebx
  8005b3:	7f e2                	jg     800597 <vprintfmt+0x248>
  8005b5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005b8:	e9 be fd ff ff       	jmp    80037b <vprintfmt+0x2c>
  8005bd:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005c0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005c3:	83 f9 01             	cmp    $0x1,%ecx
  8005c6:	7e 16                	jle    8005de <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8d 50 08             	lea    0x8(%eax),%edx
  8005ce:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d6:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8005d9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005dc:	eb 32                	jmp    800610 <vprintfmt+0x2c1>
	else if (lflag)
  8005de:	85 c9                	test   %ecx,%ecx
  8005e0:	74 18                	je     8005fa <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 50 04             	lea    0x4(%eax),%edx
  8005e8:	89 55 14             	mov    %edx,0x14(%ebp)
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	89 c1                	mov    %eax,%ecx
  8005f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f8:	eb 16                	jmp    800610 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 50 04             	lea    0x4(%eax),%edx
  800600:	89 55 14             	mov    %edx,0x14(%ebp)
  800603:	8b 00                	mov    (%eax),%eax
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 c2                	mov    %eax,%edx
  80060a:	c1 fa 1f             	sar    $0x1f,%edx
  80060d:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800610:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800613:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800616:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80061b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80061f:	0f 89 a7 00 00 00    	jns    8006cc <vprintfmt+0x37d>
				putch('-', putdat);
  800625:	89 74 24 04          	mov    %esi,0x4(%esp)
  800629:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800630:	ff d7                	call   *%edi
				num = -(long long) num;
  800632:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800635:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800638:	f7 d9                	neg    %ecx
  80063a:	83 d3 00             	adc    $0x0,%ebx
  80063d:	f7 db                	neg    %ebx
  80063f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800644:	e9 83 00 00 00       	jmp    8006cc <vprintfmt+0x37d>
  800649:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80064c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80064f:	89 ca                	mov    %ecx,%edx
  800651:	8d 45 14             	lea    0x14(%ebp),%eax
  800654:	e8 9f fc ff ff       	call   8002f8 <getuint>
  800659:	89 c1                	mov    %eax,%ecx
  80065b:	89 d3                	mov    %edx,%ebx
  80065d:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800662:	eb 68                	jmp    8006cc <vprintfmt+0x37d>
  800664:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800667:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80066a:	89 ca                	mov    %ecx,%edx
  80066c:	8d 45 14             	lea    0x14(%ebp),%eax
  80066f:	e8 84 fc ff ff       	call   8002f8 <getuint>
  800674:	89 c1                	mov    %eax,%ecx
  800676:	89 d3                	mov    %edx,%ebx
  800678:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  80067d:	eb 4d                	jmp    8006cc <vprintfmt+0x37d>
  80067f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800682:	89 74 24 04          	mov    %esi,0x4(%esp)
  800686:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80068d:	ff d7                	call   *%edi
			putch('x', putdat);
  80068f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800693:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80069a:	ff d7                	call   *%edi
			num = (unsigned long long)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 50 04             	lea    0x4(%eax),%edx
  8006a2:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a5:	8b 08                	mov    (%eax),%ecx
  8006a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ac:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006b1:	eb 19                	jmp    8006cc <vprintfmt+0x37d>
  8006b3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006b6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006b9:	89 ca                	mov    %ecx,%edx
  8006bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8006be:	e8 35 fc ff ff       	call   8002f8 <getuint>
  8006c3:	89 c1                	mov    %eax,%ecx
  8006c5:	89 d3                	mov    %edx,%ebx
  8006c7:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006cc:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8006d0:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006df:	89 0c 24             	mov    %ecx,(%esp)
  8006e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006e6:	89 f2                	mov    %esi,%edx
  8006e8:	89 f8                	mov    %edi,%eax
  8006ea:	e8 21 fb ff ff       	call   800210 <printnum>
  8006ef:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006f2:	e9 84 fc ff ff       	jmp    80037b <vprintfmt+0x2c>
  8006f7:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006fe:	89 04 24             	mov    %eax,(%esp)
  800701:	ff d7                	call   *%edi
  800703:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800706:	e9 70 fc ff ff       	jmp    80037b <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80070b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800716:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800718:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80071b:	80 38 25             	cmpb   $0x25,(%eax)
  80071e:	0f 84 57 fc ff ff    	je     80037b <vprintfmt+0x2c>
  800724:	89 c3                	mov    %eax,%ebx
  800726:	eb f0                	jmp    800718 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800728:	83 c4 4c             	add    $0x4c,%esp
  80072b:	5b                   	pop    %ebx
  80072c:	5e                   	pop    %esi
  80072d:	5f                   	pop    %edi
  80072e:	5d                   	pop    %ebp
  80072f:	c3                   	ret    

00800730 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 28             	sub    $0x28,%esp
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80073c:	85 c0                	test   %eax,%eax
  80073e:	74 04                	je     800744 <vsnprintf+0x14>
  800740:	85 d2                	test   %edx,%edx
  800742:	7f 07                	jg     80074b <vsnprintf+0x1b>
  800744:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800749:	eb 3b                	jmp    800786 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80074b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80074e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800752:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800755:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800763:	8b 45 10             	mov    0x10(%ebp),%eax
  800766:	89 44 24 08          	mov    %eax,0x8(%esp)
  80076a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80076d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800771:	c7 04 24 32 03 80 00 	movl   $0x800332,(%esp)
  800778:	e8 d2 fb ff ff       	call   80034f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80077d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800780:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800783:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80078e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800791:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800795:	8b 45 10             	mov    0x10(%ebp),%eax
  800798:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	89 04 24             	mov    %eax,(%esp)
  8007a9:	e8 82 ff ff ff       	call   800730 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    

008007b0 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8007b6:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8007b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	89 04 24             	mov    %eax,(%esp)
  8007d1:	e8 79 fb ff ff       	call   80034f <vprintfmt>
	va_end(ap);
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    
	...

008007e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8007eb:	eb 03                	jmp    8007f0 <strlen+0x10>
		n++;
  8007ed:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f4:	75 f7                	jne    8007ed <strlen+0xd>
		n++;
	return n;
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	53                   	push   %ebx
  8007fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800802:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800807:	eb 03                	jmp    80080c <strnlen+0x14>
		n++;
  800809:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080c:	39 c1                	cmp    %eax,%ecx
  80080e:	74 06                	je     800816 <strnlen+0x1e>
  800810:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800814:	75 f3                	jne    800809 <strnlen+0x11>
		n++;
	return n;
}
  800816:	5b                   	pop    %ebx
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	53                   	push   %ebx
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800823:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800828:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80082c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80082f:	83 c2 01             	add    $0x1,%edx
  800832:	84 c9                	test   %cl,%cl
  800834:	75 f2                	jne    800828 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800836:	5b                   	pop    %ebx
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	53                   	push   %ebx
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800843:	89 1c 24             	mov    %ebx,(%esp)
  800846:	e8 95 ff ff ff       	call   8007e0 <strlen>
	strcpy(dst + len, src);
  80084b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800852:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800855:	89 04 24             	mov    %eax,(%esp)
  800858:	e8 bc ff ff ff       	call   800819 <strcpy>
	return dst;
}
  80085d:	89 d8                	mov    %ebx,%eax
  80085f:	83 c4 08             	add    $0x8,%esp
  800862:	5b                   	pop    %ebx
  800863:	5d                   	pop    %ebp
  800864:	c3                   	ret    

00800865 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	56                   	push   %esi
  800869:	53                   	push   %ebx
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800870:	8b 75 10             	mov    0x10(%ebp),%esi
  800873:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800878:	eb 0f                	jmp    800889 <strncpy+0x24>
		*dst++ = *src;
  80087a:	0f b6 19             	movzbl (%ecx),%ebx
  80087d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800880:	80 39 01             	cmpb   $0x1,(%ecx)
  800883:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800886:	83 c2 01             	add    $0x1,%edx
  800889:	39 f2                	cmp    %esi,%edx
  80088b:	72 ed                	jb     80087a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80088d:	5b                   	pop    %ebx
  80088e:	5e                   	pop    %esi
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	56                   	push   %esi
  800895:	53                   	push   %ebx
  800896:	8b 75 08             	mov    0x8(%ebp),%esi
  800899:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80089f:	89 f0                	mov    %esi,%eax
  8008a1:	85 d2                	test   %edx,%edx
  8008a3:	75 0a                	jne    8008af <strlcpy+0x1e>
  8008a5:	eb 17                	jmp    8008be <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a7:	88 18                	mov    %bl,(%eax)
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008af:	83 ea 01             	sub    $0x1,%edx
  8008b2:	74 07                	je     8008bb <strlcpy+0x2a>
  8008b4:	0f b6 19             	movzbl (%ecx),%ebx
  8008b7:	84 db                	test   %bl,%bl
  8008b9:	75 ec                	jne    8008a7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  8008bb:	c6 00 00             	movb   $0x0,(%eax)
  8008be:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8008c0:	5b                   	pop    %ebx
  8008c1:	5e                   	pop    %esi
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008cd:	eb 06                	jmp    8008d5 <strcmp+0x11>
		p++, q++;
  8008cf:	83 c1 01             	add    $0x1,%ecx
  8008d2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008d5:	0f b6 01             	movzbl (%ecx),%eax
  8008d8:	84 c0                	test   %al,%al
  8008da:	74 04                	je     8008e0 <strcmp+0x1c>
  8008dc:	3a 02                	cmp    (%edx),%al
  8008de:	74 ef                	je     8008cf <strcmp+0xb>
  8008e0:	0f b6 c0             	movzbl %al,%eax
  8008e3:	0f b6 12             	movzbl (%edx),%edx
  8008e6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	53                   	push   %ebx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8008f7:	eb 09                	jmp    800902 <strncmp+0x18>
		n--, p++, q++;
  8008f9:	83 ea 01             	sub    $0x1,%edx
  8008fc:	83 c0 01             	add    $0x1,%eax
  8008ff:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800902:	85 d2                	test   %edx,%edx
  800904:	75 07                	jne    80090d <strncmp+0x23>
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
  80090b:	eb 13                	jmp    800920 <strncmp+0x36>
  80090d:	0f b6 18             	movzbl (%eax),%ebx
  800910:	84 db                	test   %bl,%bl
  800912:	74 04                	je     800918 <strncmp+0x2e>
  800914:	3a 19                	cmp    (%ecx),%bl
  800916:	74 e1                	je     8008f9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800918:	0f b6 00             	movzbl (%eax),%eax
  80091b:	0f b6 11             	movzbl (%ecx),%edx
  80091e:	29 d0                	sub    %edx,%eax
}
  800920:	5b                   	pop    %ebx
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092d:	eb 07                	jmp    800936 <strchr+0x13>
		if (*s == c)
  80092f:	38 ca                	cmp    %cl,%dl
  800931:	74 0f                	je     800942 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800933:	83 c0 01             	add    $0x1,%eax
  800936:	0f b6 10             	movzbl (%eax),%edx
  800939:	84 d2                	test   %dl,%dl
  80093b:	75 f2                	jne    80092f <strchr+0xc>
  80093d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80094e:	eb 07                	jmp    800957 <strfind+0x13>
		if (*s == c)
  800950:	38 ca                	cmp    %cl,%dl
  800952:	74 0a                	je     80095e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800954:	83 c0 01             	add    $0x1,%eax
  800957:	0f b6 10             	movzbl (%eax),%edx
  80095a:	84 d2                	test   %dl,%dl
  80095c:	75 f2                	jne    800950 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	89 1c 24             	mov    %ebx,(%esp)
  800969:	89 74 24 04          	mov    %esi,0x4(%esp)
  80096d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800971:	8b 7d 08             	mov    0x8(%ebp),%edi
  800974:	8b 45 0c             	mov    0xc(%ebp),%eax
  800977:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80097a:	85 c9                	test   %ecx,%ecx
  80097c:	74 30                	je     8009ae <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800984:	75 25                	jne    8009ab <memset+0x4b>
  800986:	f6 c1 03             	test   $0x3,%cl
  800989:	75 20                	jne    8009ab <memset+0x4b>
		c &= 0xFF;
  80098b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80098e:	89 d3                	mov    %edx,%ebx
  800990:	c1 e3 08             	shl    $0x8,%ebx
  800993:	89 d6                	mov    %edx,%esi
  800995:	c1 e6 18             	shl    $0x18,%esi
  800998:	89 d0                	mov    %edx,%eax
  80099a:	c1 e0 10             	shl    $0x10,%eax
  80099d:	09 f0                	or     %esi,%eax
  80099f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  8009a1:	09 d8                	or     %ebx,%eax
  8009a3:	c1 e9 02             	shr    $0x2,%ecx
  8009a6:	fc                   	cld    
  8009a7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a9:	eb 03                	jmp    8009ae <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009ab:	fc                   	cld    
  8009ac:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ae:	89 f8                	mov    %edi,%eax
  8009b0:	8b 1c 24             	mov    (%esp),%ebx
  8009b3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009b7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009bb:	89 ec                	mov    %ebp,%esp
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	89 34 24             	mov    %esi,(%esp)
  8009c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  8009d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009d5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009d7:	39 c6                	cmp    %eax,%esi
  8009d9:	73 35                	jae    800a10 <memmove+0x51>
  8009db:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009de:	39 d0                	cmp    %edx,%eax
  8009e0:	73 2e                	jae    800a10 <memmove+0x51>
		s += n;
		d += n;
  8009e2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e4:	f6 c2 03             	test   $0x3,%dl
  8009e7:	75 1b                	jne    800a04 <memmove+0x45>
  8009e9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ef:	75 13                	jne    800a04 <memmove+0x45>
  8009f1:	f6 c1 03             	test   $0x3,%cl
  8009f4:	75 0e                	jne    800a04 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8009f6:	83 ef 04             	sub    $0x4,%edi
  8009f9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009fc:	c1 e9 02             	shr    $0x2,%ecx
  8009ff:	fd                   	std    
  800a00:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a02:	eb 09                	jmp    800a0d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a04:	83 ef 01             	sub    $0x1,%edi
  800a07:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a0a:	fd                   	std    
  800a0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a0d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a0e:	eb 20                	jmp    800a30 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a10:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a16:	75 15                	jne    800a2d <memmove+0x6e>
  800a18:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a1e:	75 0d                	jne    800a2d <memmove+0x6e>
  800a20:	f6 c1 03             	test   $0x3,%cl
  800a23:	75 08                	jne    800a2d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a25:	c1 e9 02             	shr    $0x2,%ecx
  800a28:	fc                   	cld    
  800a29:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2b:	eb 03                	jmp    800a30 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a2d:	fc                   	cld    
  800a2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a30:	8b 34 24             	mov    (%esp),%esi
  800a33:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a37:	89 ec                	mov    %ebp,%esp
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a41:	8b 45 10             	mov    0x10(%ebp),%eax
  800a44:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	89 04 24             	mov    %eax,(%esp)
  800a55:	e8 65 ff ff ff       	call   8009bf <memmove>
}
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    

00800a5c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	57                   	push   %edi
  800a60:	56                   	push   %esi
  800a61:	53                   	push   %ebx
  800a62:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a6b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a70:	eb 1c                	jmp    800a8e <memcmp+0x32>
		if (*s1 != *s2)
  800a72:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800a76:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800a7a:	83 c2 01             	add    $0x1,%edx
  800a7d:	83 e9 01             	sub    $0x1,%ecx
  800a80:	38 d8                	cmp    %bl,%al
  800a82:	74 0a                	je     800a8e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800a84:	0f b6 c0             	movzbl %al,%eax
  800a87:	0f b6 db             	movzbl %bl,%ebx
  800a8a:	29 d8                	sub    %ebx,%eax
  800a8c:	eb 09                	jmp    800a97 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8e:	85 c9                	test   %ecx,%ecx
  800a90:	75 e0                	jne    800a72 <memcmp+0x16>
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa5:	89 c2                	mov    %eax,%edx
  800aa7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aaa:	eb 07                	jmp    800ab3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aac:	38 08                	cmp    %cl,(%eax)
  800aae:	74 07                	je     800ab7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ab0:	83 c0 01             	add    $0x1,%eax
  800ab3:	39 d0                	cmp    %edx,%eax
  800ab5:	72 f5                	jb     800aac <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	57                   	push   %edi
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	83 ec 04             	sub    $0x4,%esp
  800ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac8:	eb 03                	jmp    800acd <strtol+0x14>
		s++;
  800aca:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800acd:	0f b6 02             	movzbl (%edx),%eax
  800ad0:	3c 20                	cmp    $0x20,%al
  800ad2:	74 f6                	je     800aca <strtol+0x11>
  800ad4:	3c 09                	cmp    $0x9,%al
  800ad6:	74 f2                	je     800aca <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ad8:	3c 2b                	cmp    $0x2b,%al
  800ada:	75 0c                	jne    800ae8 <strtol+0x2f>
		s++;
  800adc:	8d 52 01             	lea    0x1(%edx),%edx
  800adf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ae6:	eb 15                	jmp    800afd <strtol+0x44>
	else if (*s == '-')
  800ae8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800aef:	3c 2d                	cmp    $0x2d,%al
  800af1:	75 0a                	jne    800afd <strtol+0x44>
		s++, neg = 1;
  800af3:	8d 52 01             	lea    0x1(%edx),%edx
  800af6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afd:	85 db                	test   %ebx,%ebx
  800aff:	0f 94 c0             	sete   %al
  800b02:	74 05                	je     800b09 <strtol+0x50>
  800b04:	83 fb 10             	cmp    $0x10,%ebx
  800b07:	75 15                	jne    800b1e <strtol+0x65>
  800b09:	80 3a 30             	cmpb   $0x30,(%edx)
  800b0c:	75 10                	jne    800b1e <strtol+0x65>
  800b0e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b12:	75 0a                	jne    800b1e <strtol+0x65>
		s += 2, base = 16;
  800b14:	83 c2 02             	add    $0x2,%edx
  800b17:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1c:	eb 13                	jmp    800b31 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b1e:	84 c0                	test   %al,%al
  800b20:	74 0f                	je     800b31 <strtol+0x78>
  800b22:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b27:	80 3a 30             	cmpb   $0x30,(%edx)
  800b2a:	75 05                	jne    800b31 <strtol+0x78>
		s++, base = 8;
  800b2c:	83 c2 01             	add    $0x1,%edx
  800b2f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
  800b36:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b38:	0f b6 0a             	movzbl (%edx),%ecx
  800b3b:	89 cf                	mov    %ecx,%edi
  800b3d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b40:	80 fb 09             	cmp    $0x9,%bl
  800b43:	77 08                	ja     800b4d <strtol+0x94>
			dig = *s - '0';
  800b45:	0f be c9             	movsbl %cl,%ecx
  800b48:	83 e9 30             	sub    $0x30,%ecx
  800b4b:	eb 1e                	jmp    800b6b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800b4d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b50:	80 fb 19             	cmp    $0x19,%bl
  800b53:	77 08                	ja     800b5d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800b55:	0f be c9             	movsbl %cl,%ecx
  800b58:	83 e9 57             	sub    $0x57,%ecx
  800b5b:	eb 0e                	jmp    800b6b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800b5d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b60:	80 fb 19             	cmp    $0x19,%bl
  800b63:	77 15                	ja     800b7a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b65:	0f be c9             	movsbl %cl,%ecx
  800b68:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b6b:	39 f1                	cmp    %esi,%ecx
  800b6d:	7d 0b                	jge    800b7a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b6f:	83 c2 01             	add    $0x1,%edx
  800b72:	0f af c6             	imul   %esi,%eax
  800b75:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800b78:	eb be                	jmp    800b38 <strtol+0x7f>
  800b7a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b80:	74 05                	je     800b87 <strtol+0xce>
		*endptr = (char *) s;
  800b82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b85:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b87:	89 ca                	mov    %ecx,%edx
  800b89:	f7 da                	neg    %edx
  800b8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b8f:	0f 45 c2             	cmovne %edx,%eax
}
  800b92:	83 c4 04             	add    $0x4,%esp
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5f                   	pop    %edi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    
	...

00800b9c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 0c             	sub    $0xc,%esp
  800ba2:	89 1c 24             	mov    %ebx,(%esp)
  800ba5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ba9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bad:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb7:	89 d1                	mov    %edx,%ecx
  800bb9:	89 d3                	mov    %edx,%ebx
  800bbb:	89 d7                	mov    %edx,%edi
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc1:	8b 1c 24             	mov    (%esp),%ebx
  800bc4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bc8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bcc:	89 ec                	mov    %ebp,%esp
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	89 1c 24             	mov    %ebx,(%esp)
  800bd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bdd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800be1:	b8 00 00 00 00       	mov    $0x0,%eax
  800be6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bec:	89 c3                	mov    %eax,%ebx
  800bee:	89 c7                	mov    %eax,%edi
  800bf0:	89 c6                	mov    %eax,%esi
  800bf2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bf4:	8b 1c 24             	mov    (%esp),%ebx
  800bf7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bfb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bff:	89 ec                	mov    %ebp,%esp
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 0c             	sub    $0xc,%esp
  800c09:	89 1c 24             	mov    %ebx,(%esp)
  800c0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c10:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c14:	ba 00 00 00 00       	mov    $0x0,%edx
  800c19:	b8 10 00 00 00       	mov    $0x10,%eax
  800c1e:	89 d1                	mov    %edx,%ecx
  800c20:	89 d3                	mov    %edx,%ebx
  800c22:	89 d7                	mov    %edx,%edi
  800c24:	89 d6                	mov    %edx,%esi
  800c26:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800c28:	8b 1c 24             	mov    (%esp),%ebx
  800c2b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c2f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c33:	89 ec                	mov    %ebp,%esp
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 38             	sub    $0x38,%esp
  800c3d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c40:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c43:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800c50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c53:	8b 55 08             	mov    0x8(%ebp),%edx
  800c56:	89 df                	mov    %ebx,%edi
  800c58:	89 de                	mov    %ebx,%esi
  800c5a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	7e 28                	jle    800c88 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c60:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c64:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800c6b:	00 
  800c6c:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  800c73:	00 
  800c74:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c7b:	00 
  800c7c:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  800c83:	e8 70 f4 ff ff       	call   8000f8 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800c88:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c8b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c8e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c91:	89 ec                	mov    %ebp,%esp
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 38             	sub    $0x38,%esp
  800c9b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c9e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ca1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7e 28                	jle    800ce6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbe:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800cc9:	00 
  800cca:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  800cd1:	00 
  800cd2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd9:	00 
  800cda:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  800ce1:	e8 12 f4 ff ff       	call   8000f8 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800ce6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ce9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cef:	89 ec                	mov    %ebp,%esp
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 38             	sub    $0x38,%esp
  800cf9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cfc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cff:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d07:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	89 cb                	mov    %ecx,%ebx
  800d11:	89 cf                	mov    %ecx,%edi
  800d13:	89 ce                	mov    %ecx,%esi
  800d15:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d17:	85 c0                	test   %eax,%eax
  800d19:	7e 28                	jle    800d43 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800d26:	00 
  800d27:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  800d2e:	00 
  800d2f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d36:	00 
  800d37:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  800d3e:	e8 b5 f3 ff ff       	call   8000f8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d43:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d46:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d49:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d4c:	89 ec                	mov    %ebp,%esp
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 0c             	sub    $0xc,%esp
  800d56:	89 1c 24             	mov    %ebx,(%esp)
  800d59:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d5d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d61:	be 00 00 00 00       	mov    $0x0,%esi
  800d66:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d6b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d79:	8b 1c 24             	mov    (%esp),%ebx
  800d7c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d80:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d84:	89 ec                	mov    %ebp,%esp
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 38             	sub    $0x38,%esp
  800d8e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d91:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d94:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	89 df                	mov    %ebx,%edi
  800da9:	89 de                	mov    %ebx,%esi
  800dab:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dad:	85 c0                	test   %eax,%eax
  800daf:	7e 28                	jle    800dd9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800dbc:	00 
  800dbd:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  800dc4:	00 
  800dc5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dcc:	00 
  800dcd:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  800dd4:	e8 1f f3 ff ff       	call   8000f8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dd9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ddc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ddf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800de2:	89 ec                	mov    %ebp,%esp
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 38             	sub    $0x38,%esp
  800dec:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800def:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfa:	b8 09 00 00 00       	mov    $0x9,%eax
  800dff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	89 df                	mov    %ebx,%edi
  800e07:	89 de                	mov    %ebx,%esi
  800e09:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	7e 28                	jle    800e37 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e13:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e1a:	00 
  800e1b:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  800e22:	00 
  800e23:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2a:	00 
  800e2b:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  800e32:	e8 c1 f2 ff ff       	call   8000f8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e37:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e3a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e3d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e40:	89 ec                	mov    %ebp,%esp
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    

00800e44 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 38             	sub    $0x38,%esp
  800e4a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e4d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e50:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e58:	b8 08 00 00 00       	mov    $0x8,%eax
  800e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	89 df                	mov    %ebx,%edi
  800e65:	89 de                	mov    %ebx,%esi
  800e67:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	7e 28                	jle    800e95 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e71:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e78:	00 
  800e79:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  800e80:	00 
  800e81:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e88:	00 
  800e89:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  800e90:	e8 63 f2 ff ff       	call   8000f8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e95:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e98:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e9b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e9e:	89 ec                	mov    %ebp,%esp
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 38             	sub    $0x38,%esp
  800ea8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eab:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eae:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb6:	b8 06 00 00 00       	mov    $0x6,%eax
  800ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	89 df                	mov    %ebx,%edi
  800ec3:	89 de                	mov    %ebx,%esi
  800ec5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	7e 28                	jle    800ef3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  800ede:	00 
  800edf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee6:	00 
  800ee7:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  800eee:	e8 05 f2 ff ff       	call   8000f8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ef3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800efc:	89 ec                	mov    %ebp,%esp
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 38             	sub    $0x38,%esp
  800f06:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f09:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f0c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f14:	8b 75 18             	mov    0x18(%ebp),%esi
  800f17:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7e 28                	jle    800f51 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f29:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f34:	00 
  800f35:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  800f3c:	00 
  800f3d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f44:	00 
  800f45:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  800f4c:	e8 a7 f1 ff ff       	call   8000f8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f51:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f54:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f57:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5a:	89 ec                	mov    %ebp,%esp
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 38             	sub    $0x38,%esp
  800f64:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f67:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6d:	be 00 00 00 00       	mov    $0x0,%esi
  800f72:	b8 04 00 00 00       	mov    $0x4,%eax
  800f77:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	89 f7                	mov    %esi,%edi
  800f82:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f84:	85 c0                	test   %eax,%eax
  800f86:	7e 28                	jle    800fb0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f88:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f93:	00 
  800f94:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  800f9b:	00 
  800f9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa3:	00 
  800fa4:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  800fab:	e8 48 f1 ff ff       	call   8000f8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb9:	89 ec                	mov    %ebp,%esp
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	89 1c 24             	mov    %ebx,(%esp)
  800fc6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fca:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fce:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fd8:	89 d1                	mov    %edx,%ecx
  800fda:	89 d3                	mov    %edx,%ebx
  800fdc:	89 d7                	mov    %edx,%edi
  800fde:	89 d6                	mov    %edx,%esi
  800fe0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fe2:	8b 1c 24             	mov    (%esp),%ebx
  800fe5:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fe9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fed:	89 ec                	mov    %ebp,%esp
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	89 1c 24             	mov    %ebx,(%esp)
  800ffa:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ffe:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801002:	ba 00 00 00 00       	mov    $0x0,%edx
  801007:	b8 02 00 00 00       	mov    $0x2,%eax
  80100c:	89 d1                	mov    %edx,%ecx
  80100e:	89 d3                	mov    %edx,%ebx
  801010:	89 d7                	mov    %edx,%edi
  801012:	89 d6                	mov    %edx,%esi
  801014:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801016:	8b 1c 24             	mov    (%esp),%ebx
  801019:	8b 74 24 04          	mov    0x4(%esp),%esi
  80101d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801021:	89 ec                	mov    %ebp,%esp
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 38             	sub    $0x38,%esp
  80102b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80102e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801031:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801034:	b9 00 00 00 00       	mov    $0x0,%ecx
  801039:	b8 03 00 00 00       	mov    $0x3,%eax
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	89 cb                	mov    %ecx,%ebx
  801043:	89 cf                	mov    %ecx,%edi
  801045:	89 ce                	mov    %ecx,%esi
  801047:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801049:	85 c0                	test   %eax,%eax
  80104b:	7e 28                	jle    801075 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80104d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801051:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801058:	00 
  801059:	c7 44 24 08 47 32 80 	movl   $0x803247,0x8(%esp)
  801060:	00 
  801061:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801068:	00 
  801069:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  801070:	e8 83 f0 ff ff       	call   8000f8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801075:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801078:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80107b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80107e:	89 ec                	mov    %ebp,%esp
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    
	...

00801084 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
  80108a:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801090:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801097:	00 
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	89 04 24             	mov    %eax,(%esp)
  80109e:	e8 4c 0f 00 00       	call   801fef <open>
  8010a3:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	0f 88 f7 05 00 00    	js     8016a8 <spawn+0x624>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  8010b1:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8010b8:	00 
  8010b9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8010bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010c3:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8010c9:	89 14 24             	mov    %edx,(%esp)
  8010cc:	e8 d0 09 00 00       	call   801aa1 <readn>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8010d1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8010d6:	75 0c                	jne    8010e4 <spawn+0x60>
  8010d8:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8010df:	45 4c 46 
  8010e2:	74 3b                	je     80111f <spawn+0x9b>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  8010e4:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8010ea:	89 04 24             	mov    %eax,(%esp)
  8010ed:	e8 88 0a 00 00       	call   801b7a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8010f2:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  8010f9:	46 
  8010fa:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801100:	89 44 24 04          	mov    %eax,0x4(%esp)
  801104:	c7 04 24 72 32 80 00 	movl   $0x803272,(%esp)
  80110b:	e8 a1 f0 ff ff       	call   8001b1 <cprintf>
  801110:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  801117:	ff ff ff 
		return -E_NOT_EXEC;
  80111a:	e9 89 05 00 00       	jmp    8016a8 <spawn+0x624>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80111f:	ba 07 00 00 00       	mov    $0x7,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	cd 30                	int    $0x30
  801128:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80112e:	85 c0                	test   %eax,%eax
  801130:	0f 88 66 05 00 00    	js     80169c <spawn+0x618>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801136:	89 c6                	mov    %eax,%esi
  801138:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80113e:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801141:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801147:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80114d:	b9 11 00 00 00       	mov    $0x11,%ecx
  801152:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801154:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80115a:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801160:	bb 00 00 00 00       	mov    $0x0,%ebx
  801165:	be 00 00 00 00       	mov    $0x0,%esi
  80116a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80116d:	eb 0f                	jmp    80117e <spawn+0xfa>

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  80116f:	89 04 24             	mov    %eax,(%esp)
  801172:	e8 69 f6 ff ff       	call   8007e0 <strlen>
  801177:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80117b:	83 c3 01             	add    $0x1,%ebx
  80117e:	8d 14 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edx
  801185:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801188:	85 c0                	test   %eax,%eax
  80118a:	75 e3                	jne    80116f <spawn+0xeb>
  80118c:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801192:	89 9d 7c fd ff ff    	mov    %ebx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801198:	f7 de                	neg    %esi
  80119a:	81 c6 00 10 40 00    	add    $0x401000,%esi
  8011a0:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8011a6:	89 f2                	mov    %esi,%edx
  8011a8:	83 e2 fc             	and    $0xfffffffc,%edx
  8011ab:	89 d8                	mov    %ebx,%eax
  8011ad:	f7 d0                	not    %eax
  8011af:	8d 3c 82             	lea    (%edx,%eax,4),%edi

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8011b2:	8d 57 f8             	lea    -0x8(%edi),%edx
  8011b5:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  8011bb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8011c0:	81 fa ff ff 3f 00    	cmp    $0x3fffff,%edx
  8011c6:	0f 86 ed 04 00 00    	jbe    8016b9 <spawn+0x635>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8011cc:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011d3:	00 
  8011d4:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8011db:	00 
  8011dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011e3:	e8 76 fd ff ff       	call   800f5e <sys_page_alloc>
  8011e8:	be 00 00 00 00       	mov    $0x0,%esi
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	79 4c                	jns    80123d <spawn+0x1b9>
  8011f1:	e9 c3 04 00 00       	jmp    8016b9 <spawn+0x635>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  8011f6:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8011fc:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801201:	89 04 b7             	mov    %eax,(%edi,%esi,4)
		strcpy(string_store, argv[i]);
  801204:	8b 55 0c             	mov    0xc(%ebp),%edx
  801207:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  80120a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80120e:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801214:	89 04 24             	mov    %eax,(%esp)
  801217:	e8 fd f5 ff ff       	call   800819 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80121c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121f:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  801222:	89 04 24             	mov    %eax,(%esp)
  801225:	e8 b6 f5 ff ff       	call   8007e0 <strlen>
  80122a:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801230:	8d 54 02 01          	lea    0x1(%edx,%eax,1),%edx
  801234:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80123a:	83 c6 01             	add    $0x1,%esi
  80123d:	39 de                	cmp    %ebx,%esi
  80123f:	7c b5                	jl     8011f6 <spawn+0x172>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801241:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801247:	c7 04 07 00 00 00 00 	movl   $0x0,(%edi,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80124e:	81 bd 94 fd ff ff 00 	cmpl   $0x401000,-0x26c(%ebp)
  801255:	10 40 00 
  801258:	74 24                	je     80127e <spawn+0x1fa>
  80125a:	c7 44 24 0c 2c 33 80 	movl   $0x80332c,0xc(%esp)
  801261:	00 
  801262:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  801269:	00 
  80126a:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  801271:	00 
  801272:	c7 04 24 a1 32 80 00 	movl   $0x8032a1,(%esp)
  801279:	e8 7a ee ff ff       	call   8000f8 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80127e:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801284:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801287:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  80128d:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  801293:	89 02                	mov    %eax,(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801295:	81 ef 08 30 80 11    	sub    $0x11803008,%edi
  80129b:	89 bd e0 fd ff ff    	mov    %edi,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8012a1:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012a8:	00 
  8012a9:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  8012b0:	ee 
  8012b1:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8012b7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8012bb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8012c2:	00 
  8012c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ca:	e8 31 fc ff ff       	call   800f00 <sys_page_map>
  8012cf:	89 c3                	mov    %eax,%ebx
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	78 1a                	js     8012ef <spawn+0x26b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8012d5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8012dc:	00 
  8012dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e4:	e8 b9 fb ff ff       	call   800ea2 <sys_page_unmap>
  8012e9:	89 c3                	mov    %eax,%ebx
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	79 1f                	jns    80130e <spawn+0x28a>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8012ef:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8012f6:	00 
  8012f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012fe:	e8 9f fb ff ff       	call   800ea2 <sys_page_unmap>
  801303:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801309:	e9 9a 03 00 00       	jmp    8016a8 <spawn+0x624>

	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80130e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801314:	03 85 04 fe ff ff    	add    -0x1fc(%ebp),%eax
  80131a:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  801320:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801327:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80132a:	e9 c1 01 00 00       	jmp    8014f0 <spawn+0x46c>
		if (ph->p_type != ELF_PROG_LOAD)
  80132f:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801335:	83 38 01             	cmpl   $0x1,(%eax)
  801338:	0f 85 a4 01 00 00    	jne    8014e2 <spawn+0x45e>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80133e:	89 c2                	mov    %eax,%edx
  801340:	8b 40 18             	mov    0x18(%eax),%eax
  801343:	83 e0 02             	and    $0x2,%eax
  801346:	83 f8 01             	cmp    $0x1,%eax
  801349:	19 c0                	sbb    %eax,%eax
  80134b:	83 e0 fe             	and    $0xfffffffe,%eax
  80134e:	83 c0 07             	add    $0x7,%eax
  801351:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801357:	8b 52 04             	mov    0x4(%edx),%edx
  80135a:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  801360:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801366:	8b 40 10             	mov    0x10(%eax),%eax
  801369:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80136f:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801375:	8b 52 14             	mov    0x14(%edx),%edx
  801378:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
  80137e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801384:	8b 58 08             	mov    0x8(%eax),%ebx
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801387:	89 d8                	mov    %ebx,%eax
  801389:	25 ff 0f 00 00       	and    $0xfff,%eax
  80138e:	74 16                	je     8013a6 <spawn+0x322>
		va -= i;
  801390:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801392:	01 c2                	add    %eax,%edx
  801394:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		filesz += i;
  80139a:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  8013a0:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
  8013a6:	be 00 00 00 00       	mov    $0x0,%esi
  8013ab:	89 df                	mov    %ebx,%edi
  8013ad:	e9 22 01 00 00       	jmp    8014d4 <spawn+0x450>
	}

	for (i = 0; i < memsz; i += PGSIZE) {
		if (i >= filesz) {
  8013b2:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8013b8:	77 2b                	ja     8013e5 <spawn+0x361>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8013ba:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  8013c0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013c8:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8013ce:	89 04 24             	mov    %eax,(%esp)
  8013d1:	e8 88 fb ff ff       	call   800f5e <sys_page_alloc>
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	0f 89 ea 00 00 00    	jns    8014c8 <spawn+0x444>
  8013de:	89 c3                	mov    %eax,%ebx
  8013e0:	e9 93 02 00 00       	jmp    801678 <spawn+0x5f4>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8013e5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013ec:	00 
  8013ed:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8013f4:	00 
  8013f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fc:	e8 5d fb ff ff       	call   800f5e <sys_page_alloc>
  801401:	85 c0                	test   %eax,%eax
  801403:	0f 88 65 02 00 00    	js     80166e <spawn+0x5ea>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801409:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  80140f:	01 d8                	add    %ebx,%eax
  801411:	89 44 24 04          	mov    %eax,0x4(%esp)
  801415:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  80141b:	89 14 24             	mov    %edx,(%esp)
  80141e:	e8 e1 03 00 00       	call   801804 <seek>
  801423:	85 c0                	test   %eax,%eax
  801425:	0f 88 47 02 00 00    	js     801672 <spawn+0x5ee>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80142b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801431:	29 d8                	sub    %ebx,%eax
  801433:	89 c3                	mov    %eax,%ebx
  801435:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80143a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80143f:	0f 47 da             	cmova  %edx,%ebx
  801442:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801446:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80144d:	00 
  80144e:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801454:	89 04 24             	mov    %eax,(%esp)
  801457:	e8 45 06 00 00       	call   801aa1 <readn>
  80145c:	85 c0                	test   %eax,%eax
  80145e:	0f 88 12 02 00 00    	js     801676 <spawn+0x5f2>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801464:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  80146a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80146e:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801472:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801478:	89 44 24 08          	mov    %eax,0x8(%esp)
  80147c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80148b:	e8 70 fa ff ff       	call   800f00 <sys_page_map>
  801490:	85 c0                	test   %eax,%eax
  801492:	79 20                	jns    8014b4 <spawn+0x430>
				panic("spawn: sys_page_map data: %e", r);
  801494:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801498:	c7 44 24 08 ad 32 80 	movl   $0x8032ad,0x8(%esp)
  80149f:	00 
  8014a0:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  8014a7:	00 
  8014a8:	c7 04 24 a1 32 80 00 	movl   $0x8032a1,(%esp)
  8014af:	e8 44 ec ff ff       	call   8000f8 <_panic>
			sys_page_unmap(0, UTEMP);
  8014b4:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8014bb:	00 
  8014bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c3:	e8 da f9 ff ff       	call   800ea2 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8014c8:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8014ce:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8014d4:	89 f3                	mov    %esi,%ebx
  8014d6:	39 b5 84 fd ff ff    	cmp    %esi,-0x27c(%ebp)
  8014dc:	0f 87 d0 fe ff ff    	ja     8013b2 <spawn+0x32e>
	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8014e2:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  8014e9:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  8014f0:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8014f7:	39 85 7c fd ff ff    	cmp    %eax,-0x284(%ebp)
  8014fd:	0f 8c 2c fe ff ff    	jl     80132f <spawn+0x2ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801503:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801509:	89 14 24             	mov    %edx,(%esp)
  80150c:	e8 69 06 00 00       	call   801b7a <close>
	fd = -1;

	cprintf("copy sharing pages\n");
  801511:	c7 04 24 e4 32 80 00 	movl   $0x8032e4,(%esp)
  801518:	e8 94 ec ff ff       	call   8001b1 <cprintf>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
  80151d:	e8 cf fa ff ff       	call   800ff1 <sys_getenvid>
  801522:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801528:	c7 85 8c fd ff ff 00 	movl   $0x0,-0x274(%ebp)
  80152f:	00 00 00 

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  801532:	be 00 00 40 ef       	mov    $0xef400000,%esi
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  801537:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  80153d:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801544:	a8 01                	test   $0x1,%al
  801546:	0f 84 89 00 00 00    	je     8015d5 <spawn+0x551>
  80154c:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801552:	0f 84 69 01 00 00    	je     8016c1 <spawn+0x63d>
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  801558:	89 d7                	mov    %edx,%edi
  80155a:	c1 e7 16             	shl    $0x16,%edi
  80155d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801562:	89 da                	mov    %ebx,%edx
  801564:	c1 e2 0c             	shl    $0xc,%edx
  801567:	01 fa                	add    %edi,%edx
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  801569:	89 d0                	mov    %edx,%eax
  80156b:	c1 e8 0c             	shr    $0xc,%eax
  80156e:	8b 0c 86             	mov    (%esi,%eax,4),%ecx
  801571:	f6 c1 01             	test   $0x1,%cl
  801574:	74 54                	je     8015ca <spawn+0x546>
  801576:	8b 04 86             	mov    (%esi,%eax,4),%eax
  801579:	f6 c4 04             	test   $0x4,%ah
  80157c:	74 4c                	je     8015ca <spawn+0x546>
				{
					ret = sys_page_map(curr_envid, (void *)addr, child,(void *)addr,PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  80157e:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  801585:	00 
  801586:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80158a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801590:	89 44 24 08          	mov    %eax,0x8(%esp)
  801594:	89 54 24 04          	mov    %edx,0x4(%esp)
  801598:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80159e:	89 14 24             	mov    %edx,(%esp)
  8015a1:	e8 5a f9 ff ff       	call   800f00 <sys_page_map>
					if(ret) panic("sys_page_map: %e", ret);
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	74 20                	je     8015ca <spawn+0x546>
  8015aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ae:	c7 44 24 08 ca 32 80 	movl   $0x8032ca,0x8(%esp)
  8015b5:	00 
  8015b6:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  8015bd:	00 
  8015be:	c7 04 24 a1 32 80 00 	movl   $0x8032a1,(%esp)
  8015c5:	e8 2e eb ff ff       	call   8000f8 <_panic>
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
  8015ca:	83 c3 01             	add    $0x1,%ebx
  8015cd:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8015d3:	75 8d                	jne    801562 <spawn+0x4de>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  8015d5:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  8015dc:	81 bd 8c fd ff ff bb 	cmpl   $0x3bb,-0x274(%ebp)
  8015e3:	03 00 00 
  8015e6:	0f 85 4b ff ff ff    	jne    801537 <spawn+0x4b3>

	cprintf("copy sharing pages\n");
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
	cprintf("complete copy sharing pages\n");	
  8015ec:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  8015f3:	e8 b9 eb ff ff       	call   8001b1 <cprintf>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8015f8:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8015fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801602:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801608:	89 04 24             	mov    %eax,(%esp)
  80160b:	e8 d6 f7 ff ff       	call   800de6 <sys_env_set_trapframe>
  801610:	85 c0                	test   %eax,%eax
  801612:	79 20                	jns    801634 <spawn+0x5b0>
		panic("sys_env_set_trapframe: %e", r);
  801614:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801618:	c7 44 24 08 f8 32 80 	movl   $0x8032f8,0x8(%esp)
  80161f:	00 
  801620:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  801627:	00 
  801628:	c7 04 24 a1 32 80 00 	movl   $0x8032a1,(%esp)
  80162f:	e8 c4 ea ff ff       	call   8000f8 <_panic>
	
	//thisenv = &envs[ENVX(child)];
	//cprintf("%s %x\n",__func__,thisenv->env_id);
	
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801634:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80163b:	00 
  80163c:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801642:	89 14 24             	mov    %edx,(%esp)
  801645:	e8 fa f7 ff ff       	call   800e44 <sys_env_set_status>
  80164a:	85 c0                	test   %eax,%eax
  80164c:	79 4e                	jns    80169c <spawn+0x618>
		panic("sys_env_set_status: %e", r);
  80164e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801652:	c7 44 24 08 12 33 80 	movl   $0x803312,0x8(%esp)
  801659:	00 
  80165a:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  801661:	00 
  801662:	c7 04 24 a1 32 80 00 	movl   $0x8032a1,(%esp)
  801669:	e8 8a ea ff ff       	call   8000f8 <_panic>
  80166e:	89 c3                	mov    %eax,%ebx
  801670:	eb 06                	jmp    801678 <spawn+0x5f4>
  801672:	89 c3                	mov    %eax,%ebx
  801674:	eb 02                	jmp    801678 <spawn+0x5f4>
  801676:	89 c3                	mov    %eax,%ebx
	
	return child;

error:
	sys_env_destroy(child);
  801678:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80167e:	89 04 24             	mov    %eax,(%esp)
  801681:	e8 9f f9 ff ff       	call   801025 <sys_env_destroy>
	close(fd);
  801686:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  80168c:	89 14 24             	mov    %edx,(%esp)
  80168f:	e8 e6 04 00 00       	call   801b7a <close>
  801694:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
	return r;
  80169a:	eb 0c                	jmp    8016a8 <spawn+0x624>
  80169c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8016a2:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  8016a8:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8016ae:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8016b4:	5b                   	pop    %ebx
  8016b5:	5e                   	pop    %esi
  8016b6:	5f                   	pop    %edi
  8016b7:	5d                   	pop    %ebp
  8016b8:	c3                   	ret    
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  8016b9:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8016bf:	eb e7                	jmp    8016a8 <spawn+0x624>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  8016c1:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  8016c8:	e9 6a fe ff ff       	jmp    801537 <spawn+0x4b3>

008016cd <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	56                   	push   %esi
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 10             	sub    $0x10,%esp

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  8016d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8016d8:	ba 00 00 00 00       	mov    $0x0,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8016dd:	eb 03                	jmp    8016e2 <spawnl+0x15>
		argc++;
  8016df:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8016e2:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  8016e6:	75 f7                	jne    8016df <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8016e8:	8d 04 95 26 00 00 00 	lea    0x26(,%edx,4),%eax
  8016ef:	83 e0 f0             	and    $0xfffffff0,%eax
  8016f2:	29 c4                	sub    %eax,%esp
  8016f4:	8d 5c 24 17          	lea    0x17(%esp),%ebx
  8016f8:	83 e3 f0             	and    $0xfffffff0,%ebx
	argv[0] = arg0;
  8016fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fe:	89 03                	mov    %eax,(%ebx)
	argv[argc+1] = NULL;
  801700:	c7 44 93 04 00 00 00 	movl   $0x0,0x4(%ebx,%edx,4)
  801707:	00 

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  801708:	8d 75 10             	lea    0x10(%ebp),%esi
  80170b:	b8 00 00 00 00       	mov    $0x0,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801710:	eb 0a                	jmp    80171c <spawnl+0x4f>
		argv[i+1] = va_arg(vl, const char *);
  801712:	83 c0 01             	add    $0x1,%eax
  801715:	8b 4c 86 fc          	mov    -0x4(%esi,%eax,4),%ecx
  801719:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80171c:	39 d0                	cmp    %edx,%eax
  80171e:	72 f2                	jb     801712 <spawnl+0x45>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801720:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	89 04 24             	mov    %eax,(%esp)
  80172a:	e8 55 f9 ff ff       	call   801084 <spawn>
}
  80172f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801732:	5b                   	pop    %ebx
  801733:	5e                   	pop    %esi
  801734:	5d                   	pop    %ebp
  801735:	c3                   	ret    
	...

00801738 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	05 00 00 00 30       	add    $0x30000000,%eax
  801743:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    

00801748 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	89 04 24             	mov    %eax,(%esp)
  801754:	e8 df ff ff ff       	call   801738 <fd2num>
  801759:	05 20 00 0d 00       	add    $0xd0020,%eax
  80175e:	c1 e0 0c             	shl    $0xc,%eax
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	57                   	push   %edi
  801767:	56                   	push   %esi
  801768:	53                   	push   %ebx
  801769:	8b 7d 08             	mov    0x8(%ebp),%edi
  80176c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801771:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801776:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80177b:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80177d:	89 c2                	mov    %eax,%edx
  80177f:	c1 ea 16             	shr    $0x16,%edx
  801782:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801785:	f6 c2 01             	test   $0x1,%dl
  801788:	74 0d                	je     801797 <fd_alloc+0x34>
  80178a:	89 c2                	mov    %eax,%edx
  80178c:	c1 ea 0c             	shr    $0xc,%edx
  80178f:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  801792:	f6 c2 01             	test   $0x1,%dl
  801795:	75 09                	jne    8017a0 <fd_alloc+0x3d>
			*fd_store = fd;
  801797:	89 37                	mov    %esi,(%edi)
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80179e:	eb 17                	jmp    8017b7 <fd_alloc+0x54>
  8017a0:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8017a5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017aa:	75 cf                	jne    80177b <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017ac:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8017b2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8017b7:	5b                   	pop    %ebx
  8017b8:	5e                   	pop    %esi
  8017b9:	5f                   	pop    %edi
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	83 f8 1f             	cmp    $0x1f,%eax
  8017c5:	77 36                	ja     8017fd <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017c7:	05 00 00 0d 00       	add    $0xd0000,%eax
  8017cc:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017cf:	89 c2                	mov    %eax,%edx
  8017d1:	c1 ea 16             	shr    $0x16,%edx
  8017d4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017db:	f6 c2 01             	test   $0x1,%dl
  8017de:	74 1d                	je     8017fd <fd_lookup+0x41>
  8017e0:	89 c2                	mov    %eax,%edx
  8017e2:	c1 ea 0c             	shr    $0xc,%edx
  8017e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017ec:	f6 c2 01             	test   $0x1,%dl
  8017ef:	74 0c                	je     8017fd <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f4:	89 02                	mov    %eax,(%edx)
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8017fb:	eb 05                	jmp    801802 <fd_lookup+0x46>
  8017fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801802:	5d                   	pop    %ebp
  801803:	c3                   	ret    

00801804 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80180a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80180d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	89 04 24             	mov    %eax,(%esp)
  801817:	e8 a0 ff ff ff       	call   8017bc <fd_lookup>
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 0e                	js     80182e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801820:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	89 50 04             	mov    %edx,0x4(%eax)
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	56                   	push   %esi
  801834:	53                   	push   %ebx
  801835:	83 ec 10             	sub    $0x10,%esp
  801838:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80183b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80183e:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801843:	be d4 33 80 00       	mov    $0x8033d4,%esi
  801848:	eb 10                	jmp    80185a <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  80184a:	39 08                	cmp    %ecx,(%eax)
  80184c:	75 09                	jne    801857 <dev_lookup+0x27>
			*dev = devtab[i];
  80184e:	89 03                	mov    %eax,(%ebx)
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801855:	eb 31                	jmp    801888 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801857:	83 c2 01             	add    $0x1,%edx
  80185a:	8b 04 96             	mov    (%esi,%edx,4),%eax
  80185d:	85 c0                	test   %eax,%eax
  80185f:	75 e9                	jne    80184a <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801861:	a1 08 50 80 00       	mov    0x805008,%eax
  801866:	8b 40 48             	mov    0x48(%eax),%eax
  801869:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80186d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801871:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  801878:	e8 34 e9 ff ff       	call   8001b1 <cprintf>
	*dev = 0;
  80187d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801883:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5d                   	pop    %ebp
  80188e:	c3                   	ret    

0080188f <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	53                   	push   %ebx
  801893:	83 ec 24             	sub    $0x24,%esp
  801896:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801899:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80189c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	89 04 24             	mov    %eax,(%esp)
  8018a6:	e8 11 ff ff ff       	call   8017bc <fd_lookup>
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 53                	js     801902 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b9:	8b 00                	mov    (%eax),%eax
  8018bb:	89 04 24             	mov    %eax,(%esp)
  8018be:	e8 6d ff ff ff       	call   801830 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	78 3b                	js     801902 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8018c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cf:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8018d3:	74 2d                	je     801902 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018d5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018d8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018df:	00 00 00 
	stat->st_isdir = 0;
  8018e2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018e9:	00 00 00 
	stat->st_dev = dev;
  8018ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ef:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fc:	89 14 24             	mov    %edx,(%esp)
  8018ff:	ff 50 14             	call   *0x14(%eax)
}
  801902:	83 c4 24             	add    $0x24,%esp
  801905:	5b                   	pop    %ebx
  801906:	5d                   	pop    %ebp
  801907:	c3                   	ret    

00801908 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	53                   	push   %ebx
  80190c:	83 ec 24             	sub    $0x24,%esp
  80190f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801912:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801915:	89 44 24 04          	mov    %eax,0x4(%esp)
  801919:	89 1c 24             	mov    %ebx,(%esp)
  80191c:	e8 9b fe ff ff       	call   8017bc <fd_lookup>
  801921:	85 c0                	test   %eax,%eax
  801923:	78 5f                	js     801984 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801925:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801928:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	89 04 24             	mov    %eax,(%esp)
  801934:	e8 f7 fe ff ff       	call   801830 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 47                	js     801984 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80193d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801940:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801944:	75 23                	jne    801969 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801946:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80194b:	8b 40 48             	mov    0x48(%eax),%eax
  80194e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801952:	89 44 24 04          	mov    %eax,0x4(%esp)
  801956:	c7 04 24 74 33 80 00 	movl   $0x803374,(%esp)
  80195d:	e8 4f e8 ff ff       	call   8001b1 <cprintf>
  801962:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801967:	eb 1b                	jmp    801984 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196c:	8b 48 18             	mov    0x18(%eax),%ecx
  80196f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801974:	85 c9                	test   %ecx,%ecx
  801976:	74 0c                	je     801984 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197f:	89 14 24             	mov    %edx,(%esp)
  801982:	ff d1                	call   *%ecx
}
  801984:	83 c4 24             	add    $0x24,%esp
  801987:	5b                   	pop    %ebx
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	53                   	push   %ebx
  80198e:	83 ec 24             	sub    $0x24,%esp
  801991:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801994:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801997:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199b:	89 1c 24             	mov    %ebx,(%esp)
  80199e:	e8 19 fe ff ff       	call   8017bc <fd_lookup>
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 66                	js     801a0d <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b1:	8b 00                	mov    (%eax),%eax
  8019b3:	89 04 24             	mov    %eax,(%esp)
  8019b6:	e8 75 fe ff ff       	call   801830 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 4e                	js     801a0d <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019c2:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8019c6:	75 23                	jne    8019eb <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c8:	a1 08 50 80 00       	mov    0x805008,%eax
  8019cd:	8b 40 48             	mov    0x48(%eax),%eax
  8019d0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d8:	c7 04 24 98 33 80 00 	movl   $0x803398,(%esp)
  8019df:	e8 cd e7 ff ff       	call   8001b1 <cprintf>
  8019e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8019e9:	eb 22                	jmp    801a0d <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ee:	8b 48 0c             	mov    0xc(%eax),%ecx
  8019f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f6:	85 c9                	test   %ecx,%ecx
  8019f8:	74 13                	je     801a0d <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a08:	89 14 24             	mov    %edx,(%esp)
  801a0b:	ff d1                	call   *%ecx
}
  801a0d:	83 c4 24             	add    $0x24,%esp
  801a10:	5b                   	pop    %ebx
  801a11:	5d                   	pop    %ebp
  801a12:	c3                   	ret    

00801a13 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	53                   	push   %ebx
  801a17:	83 ec 24             	sub    $0x24,%esp
  801a1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a24:	89 1c 24             	mov    %ebx,(%esp)
  801a27:	e8 90 fd ff ff       	call   8017bc <fd_lookup>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 6b                	js     801a9b <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	8b 00                	mov    (%eax),%eax
  801a3c:	89 04 24             	mov    %eax,(%esp)
  801a3f:	e8 ec fd ff ff       	call   801830 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 53                	js     801a9b <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a4b:	8b 42 08             	mov    0x8(%edx),%eax
  801a4e:	83 e0 03             	and    $0x3,%eax
  801a51:	83 f8 01             	cmp    $0x1,%eax
  801a54:	75 23                	jne    801a79 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a56:	a1 08 50 80 00       	mov    0x805008,%eax
  801a5b:	8b 40 48             	mov    0x48(%eax),%eax
  801a5e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a66:	c7 04 24 b5 33 80 00 	movl   $0x8033b5,(%esp)
  801a6d:	e8 3f e7 ff ff       	call   8001b1 <cprintf>
  801a72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801a77:	eb 22                	jmp    801a9b <read+0x88>
	}
	if (!dev->dev_read)
  801a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7c:	8b 48 08             	mov    0x8(%eax),%ecx
  801a7f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a84:	85 c9                	test   %ecx,%ecx
  801a86:	74 13                	je     801a9b <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a88:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a96:	89 14 24             	mov    %edx,(%esp)
  801a99:	ff d1                	call   *%ecx
}
  801a9b:	83 c4 24             	add    $0x24,%esp
  801a9e:	5b                   	pop    %ebx
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    

00801aa1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	57                   	push   %edi
  801aa5:	56                   	push   %esi
  801aa6:	53                   	push   %ebx
  801aa7:	83 ec 1c             	sub    $0x1c,%esp
  801aaa:	8b 7d 08             	mov    0x8(%ebp),%edi
  801aad:	8b 75 10             	mov    0x10(%ebp),%esi
  801ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ab5:	eb 21                	jmp    801ad8 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ab7:	89 f2                	mov    %esi,%edx
  801ab9:	29 c2                	sub    %eax,%edx
  801abb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801abf:	03 45 0c             	add    0xc(%ebp),%eax
  801ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac6:	89 3c 24             	mov    %edi,(%esp)
  801ac9:	e8 45 ff ff ff       	call   801a13 <read>
		if (m < 0)
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 0e                	js     801ae0 <readn+0x3f>
			return m;
		if (m == 0)
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	74 08                	je     801ade <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ad6:	01 c3                	add    %eax,%ebx
  801ad8:	89 d8                	mov    %ebx,%eax
  801ada:	39 f3                	cmp    %esi,%ebx
  801adc:	72 d9                	jb     801ab7 <readn+0x16>
  801ade:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801ae0:	83 c4 1c             	add    $0x1c,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5f                   	pop    %edi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    

00801ae8 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 38             	sub    $0x38,%esp
  801aee:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801af1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801af4:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801af7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801afa:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801afe:	89 3c 24             	mov    %edi,(%esp)
  801b01:	e8 32 fc ff ff       	call   801738 <fd2num>
  801b06:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801b09:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b0d:	89 04 24             	mov    %eax,(%esp)
  801b10:	e8 a7 fc ff ff       	call   8017bc <fd_lookup>
  801b15:	89 c3                	mov    %eax,%ebx
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 05                	js     801b20 <fd_close+0x38>
  801b1b:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801b1e:	74 0e                	je     801b2e <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801b20:	89 f0                	mov    %esi,%eax
  801b22:	84 c0                	test   %al,%al
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
  801b29:	0f 44 d8             	cmove  %eax,%ebx
  801b2c:	eb 3d                	jmp    801b6b <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b2e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b35:	8b 07                	mov    (%edi),%eax
  801b37:	89 04 24             	mov    %eax,(%esp)
  801b3a:	e8 f1 fc ff ff       	call   801830 <dev_lookup>
  801b3f:	89 c3                	mov    %eax,%ebx
  801b41:	85 c0                	test   %eax,%eax
  801b43:	78 16                	js     801b5b <fd_close+0x73>
		if (dev->dev_close)
  801b45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b48:	8b 40 10             	mov    0x10(%eax),%eax
  801b4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 07                	je     801b5b <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801b54:	89 3c 24             	mov    %edi,(%esp)
  801b57:	ff d0                	call   *%eax
  801b59:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801b5b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b66:	e8 37 f3 ff ff       	call   800ea2 <sys_page_unmap>
	return r;
}
  801b6b:	89 d8                	mov    %ebx,%eax
  801b6d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b70:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b73:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b76:	89 ec                	mov    %ebp,%esp
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    

00801b7a <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	89 04 24             	mov    %eax,(%esp)
  801b8d:	e8 2a fc ff ff       	call   8017bc <fd_lookup>
  801b92:	85 c0                	test   %eax,%eax
  801b94:	78 13                	js     801ba9 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801b96:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b9d:	00 
  801b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba1:	89 04 24             	mov    %eax,(%esp)
  801ba4:	e8 3f ff ff ff       	call   801ae8 <fd_close>
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 18             	sub    $0x18,%esp
  801bb1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801bb4:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bb7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bbe:	00 
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	89 04 24             	mov    %eax,(%esp)
  801bc5:	e8 25 04 00 00       	call   801fef <open>
  801bca:	89 c3                	mov    %eax,%ebx
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	78 1b                	js     801beb <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd7:	89 1c 24             	mov    %ebx,(%esp)
  801bda:	e8 b0 fc ff ff       	call   80188f <fstat>
  801bdf:	89 c6                	mov    %eax,%esi
	close(fd);
  801be1:	89 1c 24             	mov    %ebx,(%esp)
  801be4:	e8 91 ff ff ff       	call   801b7a <close>
  801be9:	89 f3                	mov    %esi,%ebx
	return r;
}
  801beb:	89 d8                	mov    %ebx,%eax
  801bed:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801bf0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801bf3:	89 ec                	mov    %ebp,%esp
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    

00801bf7 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	53                   	push   %ebx
  801bfb:	83 ec 14             	sub    $0x14,%esp
  801bfe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801c03:	89 1c 24             	mov    %ebx,(%esp)
  801c06:	e8 6f ff ff ff       	call   801b7a <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801c0b:	83 c3 01             	add    $0x1,%ebx
  801c0e:	83 fb 20             	cmp    $0x20,%ebx
  801c11:	75 f0                	jne    801c03 <close_all+0xc>
		close(i);
}
  801c13:	83 c4 14             	add    $0x14,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    

00801c19 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 58             	sub    $0x58,%esp
  801c1f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c22:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c25:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801c28:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801c2b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	89 04 24             	mov    %eax,(%esp)
  801c38:	e8 7f fb ff ff       	call   8017bc <fd_lookup>
  801c3d:	89 c3                	mov    %eax,%ebx
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	0f 88 e0 00 00 00    	js     801d27 <dup+0x10e>
		return r;
	close(newfdnum);
  801c47:	89 3c 24             	mov    %edi,(%esp)
  801c4a:	e8 2b ff ff ff       	call   801b7a <close>

	newfd = INDEX2FD(newfdnum);
  801c4f:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801c55:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c5b:	89 04 24             	mov    %eax,(%esp)
  801c5e:	e8 e5 fa ff ff       	call   801748 <fd2data>
  801c63:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c65:	89 34 24             	mov    %esi,(%esp)
  801c68:	e8 db fa ff ff       	call   801748 <fd2data>
  801c6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801c70:	89 da                	mov    %ebx,%edx
  801c72:	89 d8                	mov    %ebx,%eax
  801c74:	c1 e8 16             	shr    $0x16,%eax
  801c77:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c7e:	a8 01                	test   $0x1,%al
  801c80:	74 43                	je     801cc5 <dup+0xac>
  801c82:	c1 ea 0c             	shr    $0xc,%edx
  801c85:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c8c:	a8 01                	test   $0x1,%al
  801c8e:	74 35                	je     801cc5 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c90:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c97:	25 07 0e 00 00       	and    $0xe07,%eax
  801c9c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ca0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ca3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ca7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cae:	00 
  801caf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cb3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cba:	e8 41 f2 ff ff       	call   800f00 <sys_page_map>
  801cbf:	89 c3                	mov    %eax,%ebx
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	78 3f                	js     801d04 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cc8:	89 c2                	mov    %eax,%edx
  801cca:	c1 ea 0c             	shr    $0xc,%edx
  801ccd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cd4:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801cda:	89 54 24 10          	mov    %edx,0x10(%esp)
  801cde:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ce2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ce9:	00 
  801cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cf5:	e8 06 f2 ff ff       	call   800f00 <sys_page_map>
  801cfa:	89 c3                	mov    %eax,%ebx
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	78 04                	js     801d04 <dup+0xeb>
  801d00:	89 fb                	mov    %edi,%ebx
  801d02:	eb 23                	jmp    801d27 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801d04:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d0f:	e8 8e f1 ff ff       	call   800ea2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801d14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d22:	e8 7b f1 ff ff       	call   800ea2 <sys_page_unmap>
	return r;
}
  801d27:	89 d8                	mov    %ebx,%eax
  801d29:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d2c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d2f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d32:	89 ec                	mov    %ebp,%esp
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    
	...

00801d38 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	56                   	push   %esi
  801d3c:	53                   	push   %ebx
  801d3d:	83 ec 10             	sub    $0x10,%esp
  801d40:	89 c3                	mov    %eax,%ebx
  801d42:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801d44:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d4b:	75 11                	jne    801d5e <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d54:	e8 7b 0d 00 00       	call   802ad4 <ipc_find_env>
  801d59:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801d5e:	a1 08 50 80 00       	mov    0x805008,%eax
  801d63:	8b 40 48             	mov    0x48(%eax),%eax
  801d66:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801d6c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d70:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d78:	c7 04 24 e8 33 80 00 	movl   $0x8033e8,(%esp)
  801d7f:	e8 2d e4 ff ff       	call   8001b1 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d84:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d8b:	00 
  801d8c:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d93:	00 
  801d94:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d98:	a1 00 50 80 00       	mov    0x805000,%eax
  801d9d:	89 04 24             	mov    %eax,(%esp)
  801da0:	e8 65 0d 00 00       	call   802b0a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801da5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dac:	00 
  801dad:	89 74 24 04          	mov    %esi,0x4(%esp)
  801db1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db8:	e8 b9 0d 00 00       	call   802b76 <ipc_recv>
}
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	5b                   	pop    %ebx
  801dc1:	5e                   	pop    %esi
  801dc2:	5d                   	pop    %ebp
  801dc3:	c3                   	ret    

00801dc4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd8:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  801de2:	b8 02 00 00 00       	mov    $0x2,%eax
  801de7:	e8 4c ff ff ff       	call   801d38 <fsipc>
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfa:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801dff:	ba 00 00 00 00       	mov    $0x0,%edx
  801e04:	b8 06 00 00 00       	mov    $0x6,%eax
  801e09:	e8 2a ff ff ff       	call   801d38 <fsipc>
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e16:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1b:	b8 08 00 00 00       	mov    $0x8,%eax
  801e20:	e8 13 ff ff ff       	call   801d38 <fsipc>
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	53                   	push   %ebx
  801e2b:	83 ec 14             	sub    $0x14,%esp
  801e2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8b 40 0c             	mov    0xc(%eax),%eax
  801e37:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e41:	b8 05 00 00 00       	mov    $0x5,%eax
  801e46:	e8 ed fe ff ff       	call   801d38 <fsipc>
  801e4b:	85 c0                	test   %eax,%eax
  801e4d:	78 2b                	js     801e7a <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e4f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e56:	00 
  801e57:	89 1c 24             	mov    %ebx,(%esp)
  801e5a:	e8 ba e9 ff ff       	call   800819 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e5f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e6a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801e7a:	83 c4 14             	add    $0x14,%esp
  801e7d:	5b                   	pop    %ebx
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    

00801e80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	53                   	push   %ebx
  801e84:	83 ec 14             	sub    $0x14,%esp
  801e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e90:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e95:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801e9b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801ea1:	76 24                	jbe    801ec7 <devfile_write+0x47>
  801ea3:	c7 44 24 0c fe 33 80 	movl   $0x8033fe,0xc(%esp)
  801eaa:	00 
  801eab:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  801eb2:	00 
  801eb3:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801eba:	00 
  801ebb:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  801ec2:	e8 31 e2 ff ff       	call   8000f8 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801ec7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ece:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed2:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801ed9:	e8 e1 ea ff ff       	call   8009bf <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801ede:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee3:	b8 04 00 00 00       	mov    $0x4,%eax
  801ee8:	e8 4b fe ff ff       	call   801d38 <fsipc>
	if(ret<0) return ret;
  801eed:	85 c0                	test   %eax,%eax
  801eef:	78 53                	js     801f44 <devfile_write+0xc4>
	
	assert(ret <= n);
  801ef1:	39 c3                	cmp    %eax,%ebx
  801ef3:	73 24                	jae    801f19 <devfile_write+0x99>
  801ef5:	c7 44 24 0c 13 34 80 	movl   $0x803413,0xc(%esp)
  801efc:	00 
  801efd:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  801f04:	00 
  801f05:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801f0c:	00 
  801f0d:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  801f14:	e8 df e1 ff ff       	call   8000f8 <_panic>
	assert(ret <= PGSIZE);
  801f19:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f1e:	7e 24                	jle    801f44 <devfile_write+0xc4>
  801f20:	c7 44 24 0c 1c 34 80 	movl   $0x80341c,0xc(%esp)
  801f27:	00 
  801f28:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  801f2f:	00 
  801f30:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801f37:	00 
  801f38:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  801f3f:	e8 b4 e1 ff ff       	call   8000f8 <_panic>
	return ret;
}
  801f44:	83 c4 14             	add    $0x14,%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    

00801f4a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	56                   	push   %esi
  801f4e:	53                   	push   %ebx
  801f4f:	83 ec 10             	sub    $0x10,%esp
  801f52:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f60:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f66:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6b:	b8 03 00 00 00       	mov    $0x3,%eax
  801f70:	e8 c3 fd ff ff       	call   801d38 <fsipc>
  801f75:	89 c3                	mov    %eax,%ebx
  801f77:	85 c0                	test   %eax,%eax
  801f79:	78 6b                	js     801fe6 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801f7b:	39 de                	cmp    %ebx,%esi
  801f7d:	73 24                	jae    801fa3 <devfile_read+0x59>
  801f7f:	c7 44 24 0c 2a 34 80 	movl   $0x80342a,0xc(%esp)
  801f86:	00 
  801f87:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  801f8e:	00 
  801f8f:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f96:	00 
  801f97:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  801f9e:	e8 55 e1 ff ff       	call   8000f8 <_panic>
	assert(r <= PGSIZE);
  801fa3:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801fa9:	7e 24                	jle    801fcf <devfile_read+0x85>
  801fab:	c7 44 24 0c 31 34 80 	movl   $0x803431,0xc(%esp)
  801fb2:	00 
  801fb3:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  801fba:	00 
  801fbb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801fc2:	00 
  801fc3:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  801fca:	e8 29 e1 ff ff       	call   8000f8 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801fcf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fd3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fda:	00 
  801fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fde:	89 04 24             	mov    %eax,(%esp)
  801fe1:	e8 d9 e9 ff ff       	call   8009bf <memmove>
	return r;
}
  801fe6:	89 d8                	mov    %ebx,%eax
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5d                   	pop    %ebp
  801fee:	c3                   	ret    

00801fef <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 28             	sub    $0x28,%esp
  801ff5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ff8:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801ffb:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ffe:	89 34 24             	mov    %esi,(%esp)
  802001:	e8 da e7 ff ff       	call   8007e0 <strlen>
  802006:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80200b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802010:	7f 5e                	jg     802070 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  802012:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802015:	89 04 24             	mov    %eax,(%esp)
  802018:	e8 46 f7 ff ff       	call   801763 <fd_alloc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 4d                	js     802070 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802023:	89 74 24 04          	mov    %esi,0x4(%esp)
  802027:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80202e:	e8 e6 e7 ff ff       	call   800819 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802033:	8b 45 0c             	mov    0xc(%ebp),%eax
  802036:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80203b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203e:	b8 01 00 00 00       	mov    $0x1,%eax
  802043:	e8 f0 fc ff ff       	call   801d38 <fsipc>
  802048:	89 c3                	mov    %eax,%ebx
  80204a:	85 c0                	test   %eax,%eax
  80204c:	79 15                	jns    802063 <open+0x74>
		fd_close(fd, 0);
  80204e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802055:	00 
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	89 04 24             	mov    %eax,(%esp)
  80205c:	e8 87 fa ff ff       	call   801ae8 <fd_close>
		return r;
  802061:	eb 0d                	jmp    802070 <open+0x81>
	}

	return fd2num(fd);
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	89 04 24             	mov    %eax,(%esp)
  802069:	e8 ca f6 ff ff       	call   801738 <fd2num>
  80206e:	89 c3                	mov    %eax,%ebx
}
  802070:	89 d8                	mov    %ebx,%eax
  802072:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802075:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802078:	89 ec                	mov    %ebp,%esp
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    
  80207c:	00 00                	add    %al,(%eax)
	...

00802080 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802086:	c7 44 24 04 3d 34 80 	movl   $0x80343d,0x4(%esp)
  80208d:	00 
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	89 04 24             	mov    %eax,(%esp)
  802094:	e8 80 e7 ff ff       	call   800819 <strcpy>
	return 0;
}
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	53                   	push   %ebx
  8020a4:	83 ec 14             	sub    $0x14,%esp
  8020a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020aa:	89 1c 24             	mov    %ebx,(%esp)
  8020ad:	e8 4e 0b 00 00       	call   802c00 <pageref>
  8020b2:	89 c2                	mov    %eax,%edx
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b9:	83 fa 01             	cmp    $0x1,%edx
  8020bc:	75 0b                	jne    8020c9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8020be:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020c1:	89 04 24             	mov    %eax,(%esp)
  8020c4:	e8 b1 02 00 00       	call   80237a <nsipc_close>
	else
		return 0;
}
  8020c9:	83 c4 14             	add    $0x14,%esp
  8020cc:	5b                   	pop    %ebx
  8020cd:	5d                   	pop    %ebp
  8020ce:	c3                   	ret    

008020cf <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020dc:	00 
  8020dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f1:	89 04 24             	mov    %eax,(%esp)
  8020f4:	e8 bd 02 00 00       	call   8023b6 <nsipc_send>
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802101:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802108:	00 
  802109:	8b 45 10             	mov    0x10(%ebp),%eax
  80210c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802110:	8b 45 0c             	mov    0xc(%ebp),%eax
  802113:	89 44 24 04          	mov    %eax,0x4(%esp)
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8b 40 0c             	mov    0xc(%eax),%eax
  80211d:	89 04 24             	mov    %eax,(%esp)
  802120:	e8 04 03 00 00       	call   802429 <nsipc_recv>
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	56                   	push   %esi
  80212b:	53                   	push   %ebx
  80212c:	83 ec 20             	sub    $0x20,%esp
  80212f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802131:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802134:	89 04 24             	mov    %eax,(%esp)
  802137:	e8 27 f6 ff ff       	call   801763 <fd_alloc>
  80213c:	89 c3                	mov    %eax,%ebx
  80213e:	85 c0                	test   %eax,%eax
  802140:	78 21                	js     802163 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802142:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802149:	00 
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802151:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802158:	e8 01 ee ff ff       	call   800f5e <sys_page_alloc>
  80215d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80215f:	85 c0                	test   %eax,%eax
  802161:	79 0a                	jns    80216d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  802163:	89 34 24             	mov    %esi,(%esp)
  802166:	e8 0f 02 00 00       	call   80237a <nsipc_close>
		return r;
  80216b:	eb 28                	jmp    802195 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80216d:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	89 04 24             	mov    %eax,(%esp)
  80218e:	e8 a5 f5 ff ff       	call   801738 <fd2num>
  802193:	89 c3                	mov    %eax,%ebx
}
  802195:	89 d8                	mov    %ebx,%eax
  802197:	83 c4 20             	add    $0x20,%esp
  80219a:	5b                   	pop    %ebx
  80219b:	5e                   	pop    %esi
  80219c:	5d                   	pop    %ebp
  80219d:	c3                   	ret    

0080219e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	89 04 24             	mov    %eax,(%esp)
  8021b8:	e8 71 01 00 00       	call   80232e <nsipc_socket>
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	78 05                	js     8021c6 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8021c1:	e8 61 ff ff ff       	call   802127 <alloc_sockfd>
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021ce:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021d5:	89 04 24             	mov    %eax,(%esp)
  8021d8:	e8 df f5 ff ff       	call   8017bc <fd_lookup>
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 15                	js     8021f6 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e4:	8b 0a                	mov    (%edx),%ecx
  8021e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021eb:	3b 0d 20 40 80 00    	cmp    0x804020,%ecx
  8021f1:	75 03                	jne    8021f6 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021f3:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	e8 c2 ff ff ff       	call   8021c8 <fd2sockid>
  802206:	85 c0                	test   %eax,%eax
  802208:	78 0f                	js     802219 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80220a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802211:	89 04 24             	mov    %eax,(%esp)
  802214:	e8 3f 01 00 00       	call   802358 <nsipc_listen>
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	e8 9f ff ff ff       	call   8021c8 <fd2sockid>
  802229:	85 c0                	test   %eax,%eax
  80222b:	78 16                	js     802243 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  80222d:	8b 55 10             	mov    0x10(%ebp),%edx
  802230:	89 54 24 08          	mov    %edx,0x8(%esp)
  802234:	8b 55 0c             	mov    0xc(%ebp),%edx
  802237:	89 54 24 04          	mov    %edx,0x4(%esp)
  80223b:	89 04 24             	mov    %eax,(%esp)
  80223e:	e8 66 02 00 00       	call   8024a9 <nsipc_connect>
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	e8 75 ff ff ff       	call   8021c8 <fd2sockid>
  802253:	85 c0                	test   %eax,%eax
  802255:	78 0f                	js     802266 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80225e:	89 04 24             	mov    %eax,(%esp)
  802261:	e8 2e 01 00 00       	call   802394 <nsipc_shutdown>
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	e8 52 ff ff ff       	call   8021c8 <fd2sockid>
  802276:	85 c0                	test   %eax,%eax
  802278:	78 16                	js     802290 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80227a:	8b 55 10             	mov    0x10(%ebp),%edx
  80227d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802281:	8b 55 0c             	mov    0xc(%ebp),%edx
  802284:	89 54 24 04          	mov    %edx,0x4(%esp)
  802288:	89 04 24             	mov    %eax,(%esp)
  80228b:	e8 58 02 00 00       	call   8024e8 <nsipc_bind>
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	e8 28 ff ff ff       	call   8021c8 <fd2sockid>
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	78 1f                	js     8022c3 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8022a4:	8b 55 10             	mov    0x10(%ebp),%edx
  8022a7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022b2:	89 04 24             	mov    %eax,(%esp)
  8022b5:	e8 6d 02 00 00       	call   802527 <nsipc_accept>
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	78 05                	js     8022c3 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8022be:	e8 64 fe ff ff       	call   802127 <alloc_sockfd>
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    
  8022c5:	00 00                	add    %al,(%eax)
	...

008022c8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	53                   	push   %ebx
  8022cc:	83 ec 14             	sub    $0x14,%esp
  8022cf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022d1:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8022d8:	75 11                	jne    8022eb <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022da:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8022e1:	e8 ee 07 00 00       	call   802ad4 <ipc_find_env>
  8022e6:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022eb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022f2:	00 
  8022f3:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8022fa:	00 
  8022fb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022ff:	a1 04 50 80 00       	mov    0x805004,%eax
  802304:	89 04 24             	mov    %eax,(%esp)
  802307:	e8 fe 07 00 00       	call   802b0a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80230c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802313:	00 
  802314:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80231b:	00 
  80231c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802323:	e8 4e 08 00 00       	call   802b76 <ipc_recv>
}
  802328:	83 c4 14             	add    $0x14,%esp
  80232b:	5b                   	pop    %ebx
  80232c:	5d                   	pop    %ebp
  80232d:	c3                   	ret    

0080232e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80233c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802344:	8b 45 10             	mov    0x10(%ebp),%eax
  802347:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80234c:	b8 09 00 00 00       	mov    $0x9,%eax
  802351:	e8 72 ff ff ff       	call   8022c8 <nsipc>
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802366:	8b 45 0c             	mov    0xc(%ebp),%eax
  802369:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80236e:	b8 06 00 00 00       	mov    $0x6,%eax
  802373:	e8 50 ff ff ff       	call   8022c8 <nsipc>
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802388:	b8 04 00 00 00       	mov    $0x4,%eax
  80238d:	e8 36 ff ff ff       	call   8022c8 <nsipc>
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8023a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a5:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8023aa:	b8 03 00 00 00       	mov    $0x3,%eax
  8023af:	e8 14 ff ff ff       	call   8022c8 <nsipc>
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	53                   	push   %ebx
  8023ba:	83 ec 14             	sub    $0x14,%esp
  8023bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8023c8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023ce:	7e 24                	jle    8023f4 <nsipc_send+0x3e>
  8023d0:	c7 44 24 0c 49 34 80 	movl   $0x803449,0xc(%esp)
  8023d7:	00 
  8023d8:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  8023df:	00 
  8023e0:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8023e7:	00 
  8023e8:	c7 04 24 55 34 80 00 	movl   $0x803455,(%esp)
  8023ef:	e8 04 dd ff ff       	call   8000f8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ff:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802406:	e8 b4 e5 ff ff       	call   8009bf <memmove>
	nsipcbuf.send.req_size = size;
  80240b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802411:	8b 45 14             	mov    0x14(%ebp),%eax
  802414:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802419:	b8 08 00 00 00       	mov    $0x8,%eax
  80241e:	e8 a5 fe ff ff       	call   8022c8 <nsipc>
}
  802423:	83 c4 14             	add    $0x14,%esp
  802426:	5b                   	pop    %ebx
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    

00802429 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	56                   	push   %esi
  80242d:	53                   	push   %ebx
  80242e:	83 ec 10             	sub    $0x10,%esp
  802431:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80243c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802442:	8b 45 14             	mov    0x14(%ebp),%eax
  802445:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80244a:	b8 07 00 00 00       	mov    $0x7,%eax
  80244f:	e8 74 fe ff ff       	call   8022c8 <nsipc>
  802454:	89 c3                	mov    %eax,%ebx
  802456:	85 c0                	test   %eax,%eax
  802458:	78 46                	js     8024a0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80245a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80245f:	7f 04                	jg     802465 <nsipc_recv+0x3c>
  802461:	39 c6                	cmp    %eax,%esi
  802463:	7d 24                	jge    802489 <nsipc_recv+0x60>
  802465:	c7 44 24 0c 61 34 80 	movl   $0x803461,0xc(%esp)
  80246c:	00 
  80246d:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  802474:	00 
  802475:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  80247c:	00 
  80247d:	c7 04 24 55 34 80 00 	movl   $0x803455,(%esp)
  802484:	e8 6f dc ff ff       	call   8000f8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802489:	89 44 24 08          	mov    %eax,0x8(%esp)
  80248d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802494:	00 
  802495:	8b 45 0c             	mov    0xc(%ebp),%eax
  802498:	89 04 24             	mov    %eax,(%esp)
  80249b:	e8 1f e5 ff ff       	call   8009bf <memmove>
	}

	return r;
}
  8024a0:	89 d8                	mov    %ebx,%eax
  8024a2:	83 c4 10             	add    $0x10,%esp
  8024a5:	5b                   	pop    %ebx
  8024a6:	5e                   	pop    %esi
  8024a7:	5d                   	pop    %ebp
  8024a8:	c3                   	ret    

008024a9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
  8024ac:	53                   	push   %ebx
  8024ad:	83 ec 14             	sub    $0x14,%esp
  8024b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8024bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c6:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8024cd:	e8 ed e4 ff ff       	call   8009bf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024d2:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8024d8:	b8 05 00 00 00       	mov    $0x5,%eax
  8024dd:	e8 e6 fd ff ff       	call   8022c8 <nsipc>
}
  8024e2:	83 c4 14             	add    $0x14,%esp
  8024e5:	5b                   	pop    %ebx
  8024e6:	5d                   	pop    %ebp
  8024e7:	c3                   	ret    

008024e8 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	53                   	push   %ebx
  8024ec:	83 ec 14             	sub    $0x14,%esp
  8024ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802501:	89 44 24 04          	mov    %eax,0x4(%esp)
  802505:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80250c:	e8 ae e4 ff ff       	call   8009bf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802511:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802517:	b8 02 00 00 00       	mov    $0x2,%eax
  80251c:	e8 a7 fd ff ff       	call   8022c8 <nsipc>
}
  802521:	83 c4 14             	add    $0x14,%esp
  802524:	5b                   	pop    %ebx
  802525:	5d                   	pop    %ebp
  802526:	c3                   	ret    

00802527 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 28             	sub    $0x28,%esp
  80252d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802530:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802533:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802536:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802541:	8b 07                	mov    (%edi),%eax
  802543:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802548:	b8 01 00 00 00       	mov    $0x1,%eax
  80254d:	e8 76 fd ff ff       	call   8022c8 <nsipc>
  802552:	89 c6                	mov    %eax,%esi
  802554:	85 c0                	test   %eax,%eax
  802556:	78 22                	js     80257a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802558:	bb 10 80 80 00       	mov    $0x808010,%ebx
  80255d:	8b 03                	mov    (%ebx),%eax
  80255f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802563:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80256a:	00 
  80256b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256e:	89 04 24             	mov    %eax,(%esp)
  802571:	e8 49 e4 ff ff       	call   8009bf <memmove>
		*addrlen = ret->ret_addrlen;
  802576:	8b 03                	mov    (%ebx),%eax
  802578:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  80257a:	89 f0                	mov    %esi,%eax
  80257c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80257f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802582:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802585:	89 ec                	mov    %ebp,%esp
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    
  802589:	00 00                	add    %al,(%eax)
	...

0080258c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	83 ec 18             	sub    $0x18,%esp
  802592:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802595:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802598:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	89 04 24             	mov    %eax,(%esp)
  8025a1:	e8 a2 f1 ff ff       	call   801748 <fd2data>
  8025a6:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8025a8:	c7 44 24 04 76 34 80 	movl   $0x803476,0x4(%esp)
  8025af:	00 
  8025b0:	89 34 24             	mov    %esi,(%esp)
  8025b3:	e8 61 e2 ff ff       	call   800819 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025b8:	8b 43 04             	mov    0x4(%ebx),%eax
  8025bb:	2b 03                	sub    (%ebx),%eax
  8025bd:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8025c3:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8025ca:	00 00 00 
	stat->st_dev = &devpipe;
  8025cd:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  8025d4:	40 80 00 
	return 0;
}
  8025d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025df:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025e2:	89 ec                	mov    %ebp,%esp
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    

008025e6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	53                   	push   %ebx
  8025ea:	83 ec 14             	sub    $0x14,%esp
  8025ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025fb:	e8 a2 e8 ff ff       	call   800ea2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802600:	89 1c 24             	mov    %ebx,(%esp)
  802603:	e8 40 f1 ff ff       	call   801748 <fd2data>
  802608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80260c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802613:	e8 8a e8 ff ff       	call   800ea2 <sys_page_unmap>
}
  802618:	83 c4 14             	add    $0x14,%esp
  80261b:	5b                   	pop    %ebx
  80261c:	5d                   	pop    %ebp
  80261d:	c3                   	ret    

0080261e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	53                   	push   %ebx
  802624:	83 ec 2c             	sub    $0x2c,%esp
  802627:	89 c7                	mov    %eax,%edi
  802629:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80262c:	a1 08 50 80 00       	mov    0x805008,%eax
  802631:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802634:	89 3c 24             	mov    %edi,(%esp)
  802637:	e8 c4 05 00 00       	call   802c00 <pageref>
  80263c:	89 c6                	mov    %eax,%esi
  80263e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802641:	89 04 24             	mov    %eax,(%esp)
  802644:	e8 b7 05 00 00       	call   802c00 <pageref>
  802649:	39 c6                	cmp    %eax,%esi
  80264b:	0f 94 c0             	sete   %al
  80264e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802651:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802657:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80265a:	39 cb                	cmp    %ecx,%ebx
  80265c:	75 08                	jne    802666 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80265e:	83 c4 2c             	add    $0x2c,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5f                   	pop    %edi
  802664:	5d                   	pop    %ebp
  802665:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802666:	83 f8 01             	cmp    $0x1,%eax
  802669:	75 c1                	jne    80262c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80266b:	8b 52 58             	mov    0x58(%edx),%edx
  80266e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802672:	89 54 24 08          	mov    %edx,0x8(%esp)
  802676:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80267a:	c7 04 24 7d 34 80 00 	movl   $0x80347d,(%esp)
  802681:	e8 2b db ff ff       	call   8001b1 <cprintf>
  802686:	eb a4                	jmp    80262c <_pipeisclosed+0xe>

00802688 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	57                   	push   %edi
  80268c:	56                   	push   %esi
  80268d:	53                   	push   %ebx
  80268e:	83 ec 1c             	sub    $0x1c,%esp
  802691:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802694:	89 34 24             	mov    %esi,(%esp)
  802697:	e8 ac f0 ff ff       	call   801748 <fd2data>
  80269c:	89 c3                	mov    %eax,%ebx
  80269e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026a3:	eb 48                	jmp    8026ed <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8026a5:	89 da                	mov    %ebx,%edx
  8026a7:	89 f0                	mov    %esi,%eax
  8026a9:	e8 70 ff ff ff       	call   80261e <_pipeisclosed>
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	74 07                	je     8026b9 <devpipe_write+0x31>
  8026b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b7:	eb 3b                	jmp    8026f4 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8026b9:	e8 ff e8 ff ff       	call   800fbd <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026be:	8b 43 04             	mov    0x4(%ebx),%eax
  8026c1:	8b 13                	mov    (%ebx),%edx
  8026c3:	83 c2 20             	add    $0x20,%edx
  8026c6:	39 d0                	cmp    %edx,%eax
  8026c8:	73 db                	jae    8026a5 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026ca:	89 c2                	mov    %eax,%edx
  8026cc:	c1 fa 1f             	sar    $0x1f,%edx
  8026cf:	c1 ea 1b             	shr    $0x1b,%edx
  8026d2:	01 d0                	add    %edx,%eax
  8026d4:	83 e0 1f             	and    $0x1f,%eax
  8026d7:	29 d0                	sub    %edx,%eax
  8026d9:	89 c2                	mov    %eax,%edx
  8026db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026de:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8026e2:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026e6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026ea:	83 c7 01             	add    $0x1,%edi
  8026ed:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8026f0:	72 cc                	jb     8026be <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8026f2:	89 f8                	mov    %edi,%eax
}
  8026f4:	83 c4 1c             	add    $0x1c,%esp
  8026f7:	5b                   	pop    %ebx
  8026f8:	5e                   	pop    %esi
  8026f9:	5f                   	pop    %edi
  8026fa:	5d                   	pop    %ebp
  8026fb:	c3                   	ret    

008026fc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	83 ec 28             	sub    $0x28,%esp
  802702:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802705:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802708:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80270b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80270e:	89 3c 24             	mov    %edi,(%esp)
  802711:	e8 32 f0 ff ff       	call   801748 <fd2data>
  802716:	89 c3                	mov    %eax,%ebx
  802718:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80271d:	eb 48                	jmp    802767 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80271f:	85 f6                	test   %esi,%esi
  802721:	74 04                	je     802727 <devpipe_read+0x2b>
				return i;
  802723:	89 f0                	mov    %esi,%eax
  802725:	eb 47                	jmp    80276e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802727:	89 da                	mov    %ebx,%edx
  802729:	89 f8                	mov    %edi,%eax
  80272b:	e8 ee fe ff ff       	call   80261e <_pipeisclosed>
  802730:	85 c0                	test   %eax,%eax
  802732:	74 07                	je     80273b <devpipe_read+0x3f>
  802734:	b8 00 00 00 00       	mov    $0x0,%eax
  802739:	eb 33                	jmp    80276e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80273b:	e8 7d e8 ff ff       	call   800fbd <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802740:	8b 03                	mov    (%ebx),%eax
  802742:	3b 43 04             	cmp    0x4(%ebx),%eax
  802745:	74 d8                	je     80271f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802747:	89 c2                	mov    %eax,%edx
  802749:	c1 fa 1f             	sar    $0x1f,%edx
  80274c:	c1 ea 1b             	shr    $0x1b,%edx
  80274f:	01 d0                	add    %edx,%eax
  802751:	83 e0 1f             	and    $0x1f,%eax
  802754:	29 d0                	sub    %edx,%eax
  802756:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80275b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275e:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802761:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802764:	83 c6 01             	add    $0x1,%esi
  802767:	3b 75 10             	cmp    0x10(%ebp),%esi
  80276a:	72 d4                	jb     802740 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80276c:	89 f0                	mov    %esi,%eax
}
  80276e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802771:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802774:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802777:	89 ec                	mov    %ebp,%esp
  802779:	5d                   	pop    %ebp
  80277a:	c3                   	ret    

0080277b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
  80277e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802781:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802784:	89 44 24 04          	mov    %eax,0x4(%esp)
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	89 04 24             	mov    %eax,(%esp)
  80278e:	e8 29 f0 ff ff       	call   8017bc <fd_lookup>
  802793:	85 c0                	test   %eax,%eax
  802795:	78 15                	js     8027ac <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	89 04 24             	mov    %eax,(%esp)
  80279d:	e8 a6 ef ff ff       	call   801748 <fd2data>
	return _pipeisclosed(fd, p);
  8027a2:	89 c2                	mov    %eax,%edx
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	e8 72 fe ff ff       	call   80261e <_pipeisclosed>
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 48             	sub    $0x48,%esp
  8027b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8027c3:	89 04 24             	mov    %eax,(%esp)
  8027c6:	e8 98 ef ff ff       	call   801763 <fd_alloc>
  8027cb:	89 c3                	mov    %eax,%ebx
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	0f 88 42 01 00 00    	js     802917 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027d5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027dc:	00 
  8027dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027eb:	e8 6e e7 ff ff       	call   800f5e <sys_page_alloc>
  8027f0:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	0f 88 1d 01 00 00    	js     802917 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8027fd:	89 04 24             	mov    %eax,(%esp)
  802800:	e8 5e ef ff ff       	call   801763 <fd_alloc>
  802805:	89 c3                	mov    %eax,%ebx
  802807:	85 c0                	test   %eax,%eax
  802809:	0f 88 f5 00 00 00    	js     802904 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802816:	00 
  802817:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802825:	e8 34 e7 ff ff       	call   800f5e <sys_page_alloc>
  80282a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80282c:	85 c0                	test   %eax,%eax
  80282e:	0f 88 d0 00 00 00    	js     802904 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802837:	89 04 24             	mov    %eax,(%esp)
  80283a:	e8 09 ef ff ff       	call   801748 <fd2data>
  80283f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802841:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802848:	00 
  802849:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802854:	e8 05 e7 ff ff       	call   800f5e <sys_page_alloc>
  802859:	89 c3                	mov    %eax,%ebx
  80285b:	85 c0                	test   %eax,%eax
  80285d:	0f 88 8e 00 00 00    	js     8028f1 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802863:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802866:	89 04 24             	mov    %eax,(%esp)
  802869:	e8 da ee ff ff       	call   801748 <fd2data>
  80286e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802875:	00 
  802876:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80287a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802881:	00 
  802882:	89 74 24 04          	mov    %esi,0x4(%esp)
  802886:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80288d:	e8 6e e6 ff ff       	call   800f00 <sys_page_map>
  802892:	89 c3                	mov    %eax,%ebx
  802894:	85 c0                	test   %eax,%eax
  802896:	78 49                	js     8028e1 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802898:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  80289d:	8b 08                	mov    (%eax),%ecx
  80289f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a2:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8028a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8028ae:	8b 10                	mov    (%eax),%edx
  8028b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8028bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c2:	89 04 24             	mov    %eax,(%esp)
  8028c5:	e8 6e ee ff ff       	call   801738 <fd2num>
  8028ca:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8028cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cf:	89 04 24             	mov    %eax,(%esp)
  8028d2:	e8 61 ee ff ff       	call   801738 <fd2num>
  8028d7:	89 47 04             	mov    %eax,0x4(%edi)
  8028da:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8028df:	eb 36                	jmp    802917 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8028e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ec:	e8 b1 e5 ff ff       	call   800ea2 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8028f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ff:	e8 9e e5 ff ff       	call   800ea2 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802904:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802907:	89 44 24 04          	mov    %eax,0x4(%esp)
  80290b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802912:	e8 8b e5 ff ff       	call   800ea2 <sys_page_unmap>
    err:
	return r;
}
  802917:	89 d8                	mov    %ebx,%eax
  802919:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80291c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80291f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802922:	89 ec                	mov    %ebp,%esp
  802924:	5d                   	pop    %ebp
  802925:	c3                   	ret    
	...

00802930 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
  802938:	5d                   	pop    %ebp
  802939:	c3                   	ret    

0080293a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802940:	c7 44 24 04 95 34 80 	movl   $0x803495,0x4(%esp)
  802947:	00 
  802948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80294b:	89 04 24             	mov    %eax,(%esp)
  80294e:	e8 c6 de ff ff       	call   800819 <strcpy>
	return 0;
}
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
  80295d:	57                   	push   %edi
  80295e:	56                   	push   %esi
  80295f:	53                   	push   %ebx
  802960:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802966:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80296b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802971:	eb 34                	jmp    8029a7 <devcons_write+0x4d>
		m = n - tot;
  802973:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802976:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802978:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  80297e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802983:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802986:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80298a:	03 45 0c             	add    0xc(%ebp),%eax
  80298d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802991:	89 3c 24             	mov    %edi,(%esp)
  802994:	e8 26 e0 ff ff       	call   8009bf <memmove>
		sys_cputs(buf, m);
  802999:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80299d:	89 3c 24             	mov    %edi,(%esp)
  8029a0:	e8 2b e2 ff ff       	call   800bd0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029a5:	01 de                	add    %ebx,%esi
  8029a7:	89 f0                	mov    %esi,%eax
  8029a9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8029ac:	72 c5                	jb     802973 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8029ae:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8029b4:	5b                   	pop    %ebx
  8029b5:	5e                   	pop    %esi
  8029b6:	5f                   	pop    %edi
  8029b7:	5d                   	pop    %ebp
  8029b8:	c3                   	ret    

008029b9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029b9:	55                   	push   %ebp
  8029ba:	89 e5                	mov    %esp,%ebp
  8029bc:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029cc:	00 
  8029cd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029d0:	89 04 24             	mov    %eax,(%esp)
  8029d3:	e8 f8 e1 ff ff       	call   800bd0 <sys_cputs>
}
  8029d8:	c9                   	leave  
  8029d9:	c3                   	ret    

008029da <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8029da:	55                   	push   %ebp
  8029db:	89 e5                	mov    %esp,%ebp
  8029dd:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8029e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029e4:	75 07                	jne    8029ed <devcons_read+0x13>
  8029e6:	eb 28                	jmp    802a10 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029e8:	e8 d0 e5 ff ff       	call   800fbd <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029ed:	8d 76 00             	lea    0x0(%esi),%esi
  8029f0:	e8 a7 e1 ff ff       	call   800b9c <sys_cgetc>
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	74 ef                	je     8029e8 <devcons_read+0xe>
  8029f9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	78 16                	js     802a15 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029ff:	83 f8 04             	cmp    $0x4,%eax
  802a02:	74 0c                	je     802a10 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a07:	88 10                	mov    %dl,(%eax)
  802a09:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802a0e:	eb 05                	jmp    802a15 <devcons_read+0x3b>
  802a10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
  802a1a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a20:	89 04 24             	mov    %eax,(%esp)
  802a23:	e8 3b ed ff ff       	call   801763 <fd_alloc>
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	78 3f                	js     802a6b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a2c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a33:	00 
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a42:	e8 17 e5 ff ff       	call   800f5e <sys_page_alloc>
  802a47:	85 c0                	test   %eax,%eax
  802a49:	78 20                	js     802a6b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a4b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	89 04 24             	mov    %eax,(%esp)
  802a66:	e8 cd ec ff ff       	call   801738 <fd2num>
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a76:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	89 04 24             	mov    %eax,(%esp)
  802a80:	e8 37 ed ff ff       	call   8017bc <fd_lookup>
  802a85:	85 c0                	test   %eax,%eax
  802a87:	78 11                	js     802a9a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	3b 05 58 40 80 00    	cmp    0x804058,%eax
  802a94:	0f 94 c0             	sete   %al
  802a97:	0f b6 c0             	movzbl %al,%eax
}
  802a9a:	c9                   	leave  
  802a9b:	c3                   	ret    

00802a9c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802a9c:	55                   	push   %ebp
  802a9d:	89 e5                	mov    %esp,%ebp
  802a9f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802aa2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802aa9:	00 
  802aaa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ab8:	e8 56 ef ff ff       	call   801a13 <read>
	if (r < 0)
  802abd:	85 c0                	test   %eax,%eax
  802abf:	78 0f                	js     802ad0 <getchar+0x34>
		return r;
	if (r < 1)
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	7f 07                	jg     802acc <getchar+0x30>
  802ac5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802aca:	eb 04                	jmp    802ad0 <getchar+0x34>
		return -E_EOF;
	return c;
  802acc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ad0:	c9                   	leave  
  802ad1:	c3                   	ret    
	...

00802ad4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802ad4:	55                   	push   %ebp
  802ad5:	89 e5                	mov    %esp,%ebp
  802ad7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ada:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802adf:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802ae2:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802ae8:	8b 12                	mov    (%edx),%edx
  802aea:	39 ca                	cmp    %ecx,%edx
  802aec:	75 0c                	jne    802afa <ipc_find_env+0x26>
			return envs[i].env_id;
  802aee:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802af1:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802af6:	8b 00                	mov    (%eax),%eax
  802af8:	eb 0e                	jmp    802b08 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802afa:	83 c0 01             	add    $0x1,%eax
  802afd:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b02:	75 db                	jne    802adf <ipc_find_env+0xb>
  802b04:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802b08:	5d                   	pop    %ebp
  802b09:	c3                   	ret    

00802b0a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	57                   	push   %edi
  802b0e:	56                   	push   %esi
  802b0f:	53                   	push   %ebx
  802b10:	83 ec 2c             	sub    $0x2c,%esp
  802b13:	8b 75 08             	mov    0x8(%ebp),%esi
  802b16:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b19:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802b1c:	85 db                	test   %ebx,%ebx
  802b1e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802b23:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802b26:	8b 45 14             	mov    0x14(%ebp),%eax
  802b29:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b31:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b35:	89 34 24             	mov    %esi,(%esp)
  802b38:	e8 13 e2 ff ff       	call   800d50 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802b3d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b40:	74 e4                	je     802b26 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 28                	je     802b6e <ipc_send+0x64>
  802b46:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b4a:	c7 44 24 0c be 34 80 	movl   $0x8034be,0xc(%esp)
  802b51:	00 
  802b52:	c7 44 24 08 a1 34 80 	movl   $0x8034a1,0x8(%esp)
  802b59:	00 
  802b5a:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802b61:	00 
  802b62:	c7 04 24 b4 34 80 00 	movl   $0x8034b4,(%esp)
  802b69:	e8 8a d5 ff ff       	call   8000f8 <_panic>
	//if(!ret) sys_yield();
}
  802b6e:	83 c4 2c             	add    $0x2c,%esp
  802b71:	5b                   	pop    %ebx
  802b72:	5e                   	pop    %esi
  802b73:	5f                   	pop    %edi
  802b74:	5d                   	pop    %ebp
  802b75:	c3                   	ret    

00802b76 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b76:	55                   	push   %ebp
  802b77:	89 e5                	mov    %esp,%ebp
  802b79:	83 ec 28             	sub    $0x28,%esp
  802b7c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b7f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b82:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802b85:	8b 75 08             	mov    0x8(%ebp),%esi
  802b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8b:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802b8e:	85 c0                	test   %eax,%eax
  802b90:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802b95:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802b98:	89 04 24             	mov    %eax,(%esp)
  802b9b:	e8 53 e1 ff ff       	call   800cf3 <sys_ipc_recv>
  802ba0:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802ba2:	e8 4a e4 ff ff       	call   800ff1 <sys_getenvid>
  802ba7:	25 ff 03 00 00       	and    $0x3ff,%eax
  802bac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802baf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802bb4:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802bb9:	85 f6                	test   %esi,%esi
  802bbb:	74 0e                	je     802bcb <ipc_recv+0x55>
  802bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc2:	85 db                	test   %ebx,%ebx
  802bc4:	75 03                	jne    802bc9 <ipc_recv+0x53>
  802bc6:	8b 50 74             	mov    0x74(%eax),%edx
  802bc9:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802bcb:	85 ff                	test   %edi,%edi
  802bcd:	74 13                	je     802be2 <ipc_recv+0x6c>
  802bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd4:	85 db                	test   %ebx,%ebx
  802bd6:	75 08                	jne    802be0 <ipc_recv+0x6a>
  802bd8:	a1 08 50 80 00       	mov    0x805008,%eax
  802bdd:	8b 40 78             	mov    0x78(%eax),%eax
  802be0:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802be2:	85 db                	test   %ebx,%ebx
  802be4:	75 08                	jne    802bee <ipc_recv+0x78>
  802be6:	a1 08 50 80 00       	mov    0x805008,%eax
  802beb:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802bee:	89 d8                	mov    %ebx,%eax
  802bf0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802bf3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802bf6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802bf9:	89 ec                	mov    %ebp,%esp
  802bfb:	5d                   	pop    %ebp
  802bfc:	c3                   	ret    
  802bfd:	00 00                	add    %al,(%eax)
	...

00802c00 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c00:	55                   	push   %ebp
  802c01:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	89 c2                	mov    %eax,%edx
  802c08:	c1 ea 16             	shr    $0x16,%edx
  802c0b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802c12:	f6 c2 01             	test   $0x1,%dl
  802c15:	74 20                	je     802c37 <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802c17:	c1 e8 0c             	shr    $0xc,%eax
  802c1a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802c21:	a8 01                	test   $0x1,%al
  802c23:	74 12                	je     802c37 <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c25:	c1 e8 0c             	shr    $0xc,%eax
  802c28:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802c2d:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802c32:	0f b7 c0             	movzwl %ax,%eax
  802c35:	eb 05                	jmp    802c3c <pageref+0x3c>
  802c37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c3c:	5d                   	pop    %ebp
  802c3d:	c3                   	ret    
	...

00802c40 <__udivdi3>:
  802c40:	55                   	push   %ebp
  802c41:	89 e5                	mov    %esp,%ebp
  802c43:	57                   	push   %edi
  802c44:	56                   	push   %esi
  802c45:	83 ec 10             	sub    $0x10,%esp
  802c48:	8b 45 14             	mov    0x14(%ebp),%eax
  802c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4e:	8b 75 10             	mov    0x10(%ebp),%esi
  802c51:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c54:	85 c0                	test   %eax,%eax
  802c56:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802c59:	75 35                	jne    802c90 <__udivdi3+0x50>
  802c5b:	39 fe                	cmp    %edi,%esi
  802c5d:	77 61                	ja     802cc0 <__udivdi3+0x80>
  802c5f:	85 f6                	test   %esi,%esi
  802c61:	75 0b                	jne    802c6e <__udivdi3+0x2e>
  802c63:	b8 01 00 00 00       	mov    $0x1,%eax
  802c68:	31 d2                	xor    %edx,%edx
  802c6a:	f7 f6                	div    %esi
  802c6c:	89 c6                	mov    %eax,%esi
  802c6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c71:	31 d2                	xor    %edx,%edx
  802c73:	89 f8                	mov    %edi,%eax
  802c75:	f7 f6                	div    %esi
  802c77:	89 c7                	mov    %eax,%edi
  802c79:	89 c8                	mov    %ecx,%eax
  802c7b:	f7 f6                	div    %esi
  802c7d:	89 c1                	mov    %eax,%ecx
  802c7f:	89 fa                	mov    %edi,%edx
  802c81:	89 c8                	mov    %ecx,%eax
  802c83:	83 c4 10             	add    $0x10,%esp
  802c86:	5e                   	pop    %esi
  802c87:	5f                   	pop    %edi
  802c88:	5d                   	pop    %ebp
  802c89:	c3                   	ret    
  802c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c90:	39 f8                	cmp    %edi,%eax
  802c92:	77 1c                	ja     802cb0 <__udivdi3+0x70>
  802c94:	0f bd d0             	bsr    %eax,%edx
  802c97:	83 f2 1f             	xor    $0x1f,%edx
  802c9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c9d:	75 39                	jne    802cd8 <__udivdi3+0x98>
  802c9f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802ca2:	0f 86 a0 00 00 00    	jbe    802d48 <__udivdi3+0x108>
  802ca8:	39 f8                	cmp    %edi,%eax
  802caa:	0f 82 98 00 00 00    	jb     802d48 <__udivdi3+0x108>
  802cb0:	31 ff                	xor    %edi,%edi
  802cb2:	31 c9                	xor    %ecx,%ecx
  802cb4:	89 c8                	mov    %ecx,%eax
  802cb6:	89 fa                	mov    %edi,%edx
  802cb8:	83 c4 10             	add    $0x10,%esp
  802cbb:	5e                   	pop    %esi
  802cbc:	5f                   	pop    %edi
  802cbd:	5d                   	pop    %ebp
  802cbe:	c3                   	ret    
  802cbf:	90                   	nop
  802cc0:	89 d1                	mov    %edx,%ecx
  802cc2:	89 fa                	mov    %edi,%edx
  802cc4:	89 c8                	mov    %ecx,%eax
  802cc6:	31 ff                	xor    %edi,%edi
  802cc8:	f7 f6                	div    %esi
  802cca:	89 c1                	mov    %eax,%ecx
  802ccc:	89 fa                	mov    %edi,%edx
  802cce:	89 c8                	mov    %ecx,%eax
  802cd0:	83 c4 10             	add    $0x10,%esp
  802cd3:	5e                   	pop    %esi
  802cd4:	5f                   	pop    %edi
  802cd5:	5d                   	pop    %ebp
  802cd6:	c3                   	ret    
  802cd7:	90                   	nop
  802cd8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802cdc:	89 f2                	mov    %esi,%edx
  802cde:	d3 e0                	shl    %cl,%eax
  802ce0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ce3:	b8 20 00 00 00       	mov    $0x20,%eax
  802ce8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802ceb:	89 c1                	mov    %eax,%ecx
  802ced:	d3 ea                	shr    %cl,%edx
  802cef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802cf3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802cf6:	d3 e6                	shl    %cl,%esi
  802cf8:	89 c1                	mov    %eax,%ecx
  802cfa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802cfd:	89 fe                	mov    %edi,%esi
  802cff:	d3 ee                	shr    %cl,%esi
  802d01:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d05:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0b:	d3 e7                	shl    %cl,%edi
  802d0d:	89 c1                	mov    %eax,%ecx
  802d0f:	d3 ea                	shr    %cl,%edx
  802d11:	09 d7                	or     %edx,%edi
  802d13:	89 f2                	mov    %esi,%edx
  802d15:	89 f8                	mov    %edi,%eax
  802d17:	f7 75 ec             	divl   -0x14(%ebp)
  802d1a:	89 d6                	mov    %edx,%esi
  802d1c:	89 c7                	mov    %eax,%edi
  802d1e:	f7 65 e8             	mull   -0x18(%ebp)
  802d21:	39 d6                	cmp    %edx,%esi
  802d23:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d26:	72 30                	jb     802d58 <__udivdi3+0x118>
  802d28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d2f:	d3 e2                	shl    %cl,%edx
  802d31:	39 c2                	cmp    %eax,%edx
  802d33:	73 05                	jae    802d3a <__udivdi3+0xfa>
  802d35:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802d38:	74 1e                	je     802d58 <__udivdi3+0x118>
  802d3a:	89 f9                	mov    %edi,%ecx
  802d3c:	31 ff                	xor    %edi,%edi
  802d3e:	e9 71 ff ff ff       	jmp    802cb4 <__udivdi3+0x74>
  802d43:	90                   	nop
  802d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d48:	31 ff                	xor    %edi,%edi
  802d4a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802d4f:	e9 60 ff ff ff       	jmp    802cb4 <__udivdi3+0x74>
  802d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d58:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802d5b:	31 ff                	xor    %edi,%edi
  802d5d:	89 c8                	mov    %ecx,%eax
  802d5f:	89 fa                	mov    %edi,%edx
  802d61:	83 c4 10             	add    $0x10,%esp
  802d64:	5e                   	pop    %esi
  802d65:	5f                   	pop    %edi
  802d66:	5d                   	pop    %ebp
  802d67:	c3                   	ret    
	...

00802d70 <__umoddi3>:
  802d70:	55                   	push   %ebp
  802d71:	89 e5                	mov    %esp,%ebp
  802d73:	57                   	push   %edi
  802d74:	56                   	push   %esi
  802d75:	83 ec 20             	sub    $0x20,%esp
  802d78:	8b 55 14             	mov    0x14(%ebp),%edx
  802d7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d7e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802d81:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d84:	85 d2                	test   %edx,%edx
  802d86:	89 c8                	mov    %ecx,%eax
  802d88:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802d8b:	75 13                	jne    802da0 <__umoddi3+0x30>
  802d8d:	39 f7                	cmp    %esi,%edi
  802d8f:	76 3f                	jbe    802dd0 <__umoddi3+0x60>
  802d91:	89 f2                	mov    %esi,%edx
  802d93:	f7 f7                	div    %edi
  802d95:	89 d0                	mov    %edx,%eax
  802d97:	31 d2                	xor    %edx,%edx
  802d99:	83 c4 20             	add    $0x20,%esp
  802d9c:	5e                   	pop    %esi
  802d9d:	5f                   	pop    %edi
  802d9e:	5d                   	pop    %ebp
  802d9f:	c3                   	ret    
  802da0:	39 f2                	cmp    %esi,%edx
  802da2:	77 4c                	ja     802df0 <__umoddi3+0x80>
  802da4:	0f bd ca             	bsr    %edx,%ecx
  802da7:	83 f1 1f             	xor    $0x1f,%ecx
  802daa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802dad:	75 51                	jne    802e00 <__umoddi3+0x90>
  802daf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802db2:	0f 87 e0 00 00 00    	ja     802e98 <__umoddi3+0x128>
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	29 f8                	sub    %edi,%eax
  802dbd:	19 d6                	sbb    %edx,%esi
  802dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	89 f2                	mov    %esi,%edx
  802dc7:	83 c4 20             	add    $0x20,%esp
  802dca:	5e                   	pop    %esi
  802dcb:	5f                   	pop    %edi
  802dcc:	5d                   	pop    %ebp
  802dcd:	c3                   	ret    
  802dce:	66 90                	xchg   %ax,%ax
  802dd0:	85 ff                	test   %edi,%edi
  802dd2:	75 0b                	jne    802ddf <__umoddi3+0x6f>
  802dd4:	b8 01 00 00 00       	mov    $0x1,%eax
  802dd9:	31 d2                	xor    %edx,%edx
  802ddb:	f7 f7                	div    %edi
  802ddd:	89 c7                	mov    %eax,%edi
  802ddf:	89 f0                	mov    %esi,%eax
  802de1:	31 d2                	xor    %edx,%edx
  802de3:	f7 f7                	div    %edi
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	f7 f7                	div    %edi
  802dea:	eb a9                	jmp    802d95 <__umoddi3+0x25>
  802dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802df0:	89 c8                	mov    %ecx,%eax
  802df2:	89 f2                	mov    %esi,%edx
  802df4:	83 c4 20             	add    $0x20,%esp
  802df7:	5e                   	pop    %esi
  802df8:	5f                   	pop    %edi
  802df9:	5d                   	pop    %ebp
  802dfa:	c3                   	ret    
  802dfb:	90                   	nop
  802dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e00:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e04:	d3 e2                	shl    %cl,%edx
  802e06:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e09:	ba 20 00 00 00       	mov    $0x20,%edx
  802e0e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802e11:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802e14:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e18:	89 fa                	mov    %edi,%edx
  802e1a:	d3 ea                	shr    %cl,%edx
  802e1c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e20:	0b 55 f4             	or     -0xc(%ebp),%edx
  802e23:	d3 e7                	shl    %cl,%edi
  802e25:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e29:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e2c:	89 f2                	mov    %esi,%edx
  802e2e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802e31:	89 c7                	mov    %eax,%edi
  802e33:	d3 ea                	shr    %cl,%edx
  802e35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802e3c:	89 c2                	mov    %eax,%edx
  802e3e:	d3 e6                	shl    %cl,%esi
  802e40:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e44:	d3 ea                	shr    %cl,%edx
  802e46:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e4a:	09 d6                	or     %edx,%esi
  802e4c:	89 f0                	mov    %esi,%eax
  802e4e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802e51:	d3 e7                	shl    %cl,%edi
  802e53:	89 f2                	mov    %esi,%edx
  802e55:	f7 75 f4             	divl   -0xc(%ebp)
  802e58:	89 d6                	mov    %edx,%esi
  802e5a:	f7 65 e8             	mull   -0x18(%ebp)
  802e5d:	39 d6                	cmp    %edx,%esi
  802e5f:	72 2b                	jb     802e8c <__umoddi3+0x11c>
  802e61:	39 c7                	cmp    %eax,%edi
  802e63:	72 23                	jb     802e88 <__umoddi3+0x118>
  802e65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e69:	29 c7                	sub    %eax,%edi
  802e6b:	19 d6                	sbb    %edx,%esi
  802e6d:	89 f0                	mov    %esi,%eax
  802e6f:	89 f2                	mov    %esi,%edx
  802e71:	d3 ef                	shr    %cl,%edi
  802e73:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e77:	d3 e0                	shl    %cl,%eax
  802e79:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e7d:	09 f8                	or     %edi,%eax
  802e7f:	d3 ea                	shr    %cl,%edx
  802e81:	83 c4 20             	add    $0x20,%esp
  802e84:	5e                   	pop    %esi
  802e85:	5f                   	pop    %edi
  802e86:	5d                   	pop    %ebp
  802e87:	c3                   	ret    
  802e88:	39 d6                	cmp    %edx,%esi
  802e8a:	75 d9                	jne    802e65 <__umoddi3+0xf5>
  802e8c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802e8f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802e92:	eb d1                	jmp    802e65 <__umoddi3+0xf5>
  802e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e98:	39 f2                	cmp    %esi,%edx
  802e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ea0:	0f 82 12 ff ff ff    	jb     802db8 <__umoddi3+0x48>
  802ea6:	e9 17 ff ff ff       	jmp    802dc2 <__umoddi3+0x52>
