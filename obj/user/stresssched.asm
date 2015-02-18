
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 f3 00 00 00       	call   800124 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800048:	e8 34 10 00 00       	call   801081 <sys_getenvid>
  80004d:	89 c6                	mov    %eax,%esi
  80004f:	bb 00 00 00 00       	mov    $0x0,%ebx

	// Fork several environments
	for (i = 0; i < 20; i++)
		if (fork() == 0)
  800054:	e8 dd 10 00 00       	call   801136 <fork>
  800059:	85 c0                	test   %eax,%eax
  80005b:	74 0a                	je     800067 <umain+0x27>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80005d:	83 c3 01             	add    $0x1,%ebx
  800060:	83 fb 14             	cmp    $0x14,%ebx
  800063:	75 ef                	jne    800054 <umain+0x14>
  800065:	eb 05                	jmp    80006c <umain+0x2c>
		if (fork() == 0)
			break;
	if (i == 20) {
  800067:	83 fb 14             	cmp    $0x14,%ebx
  80006a:	75 16                	jne    800082 <umain+0x42>
		sys_yield();
  80006c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800070:	e8 d8 0f 00 00       	call   80104d <sys_yield>
		return;
  800075:	e9 a1 00 00 00       	jmp    80011b <umain+0xdb>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");
  80007a:	f3 90                	pause  
  80007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800080:	eb 11                	jmp    800093 <umain+0x53>
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800082:	89 f2                	mov    %esi,%edx
  800084:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80008a:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80008d:	81 c2 54 00 c0 ee    	add    $0xeec00054,%edx
  800093:	8b 02                	mov    (%edx),%eax
  800095:	85 c0                	test   %eax,%eax
  800097:	75 e1                	jne    80007a <umain+0x3a>
  800099:	bb 00 00 00 00       	mov    $0x0,%ebx
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80009e:	be 00 00 00 00       	mov    $0x0,%esi
  8000a3:	e8 a5 0f 00 00       	call   80104d <sys_yield>
  8000a8:	89 f0                	mov    %esi,%eax
		for (j = 0; j < 10000; j++)
			counter++;
  8000aa:	8b 15 04 20 80 00    	mov    0x802004,%edx
  8000b0:	83 c2 01             	add    $0x1,%edx
  8000b3:	89 15 04 20 80 00    	mov    %edx,0x802004
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  8000b9:	83 c0 01             	add    $0x1,%eax
  8000bc:	3d 10 27 00 00       	cmp    $0x2710,%eax
  8000c1:	75 e7                	jne    8000aa <umain+0x6a>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000c3:	83 c3 01             	add    $0x1,%ebx
  8000c6:	83 fb 0a             	cmp    $0xa,%ebx
  8000c9:	75 d8                	jne    8000a3 <umain+0x63>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  8000cb:	a1 04 20 80 00       	mov    0x802004,%eax
  8000d0:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000d5:	74 25                	je     8000fc <umain+0xbc>
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d7:	a1 04 20 80 00       	mov    0x802004,%eax
  8000dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000e0:	c7 44 24 08 e0 17 80 	movl   $0x8017e0,0x8(%esp)
  8000e7:	00 
  8000e8:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8000ef:	00 
  8000f0:	c7 04 24 08 18 80 00 	movl   $0x801808,(%esp)
  8000f7:	e8 8c 00 00 00       	call   800188 <_panic>

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000fc:	a1 08 20 80 00       	mov    0x802008,%eax
  800101:	8b 50 5c             	mov    0x5c(%eax),%edx
  800104:	8b 40 48             	mov    0x48(%eax),%eax
  800107:	89 54 24 08          	mov    %edx,0x8(%esp)
  80010b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80010f:	c7 04 24 1b 18 80 00 	movl   $0x80181b,(%esp)
  800116:	e8 26 01 00 00       	call   800241 <cprintf>

}
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
	...

00800124 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	83 ec 18             	sub    $0x18,%esp
  80012a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80012d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800130:	8b 75 08             	mov    0x8(%ebp),%esi
  800133:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800136:	e8 46 0f 00 00       	call   801081 <sys_getenvid>
  80013b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800140:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800143:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800148:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014d:	85 f6                	test   %esi,%esi
  80014f:	7e 07                	jle    800158 <libmain+0x34>
		binaryname = argv[0];
  800151:	8b 03                	mov    (%ebx),%eax
  800153:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800158:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80015c:	89 34 24             	mov    %esi,(%esp)
  80015f:	e8 dc fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800164:	e8 0b 00 00 00       	call   800174 <exit>
}
  800169:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80016c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80016f:	89 ec                	mov    %ebp,%esp
  800171:	5d                   	pop    %ebp
  800172:	c3                   	ret    
	...

00800174 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80017a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800181:	e8 2f 0f 00 00       	call   8010b5 <sys_env_destroy>
}
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	56                   	push   %esi
  80018c:	53                   	push   %ebx
  80018d:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800190:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800193:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  800199:	e8 e3 0e 00 00       	call   801081 <sys_getenvid>
  80019e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b4:	c7 04 24 44 18 80 00 	movl   $0x801844,(%esp)
  8001bb:	e8 81 00 00 00       	call   800241 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c7:	89 04 24             	mov    %eax,(%esp)
  8001ca:	e8 11 00 00 00       	call   8001e0 <vcprintf>
	cprintf("\n");
  8001cf:	c7 04 24 37 18 80 00 	movl   $0x801837,(%esp)
  8001d6:	e8 66 00 00 00       	call   800241 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001db:	cc                   	int3   
  8001dc:	eb fd                	jmp    8001db <_panic+0x53>
	...

008001e0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f0:	00 00 00 
	b.cnt = 0;
  8001f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800200:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800204:	8b 45 08             	mov    0x8(%ebp),%eax
  800207:	89 44 24 08          	mov    %eax,0x8(%esp)
  80020b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800211:	89 44 24 04          	mov    %eax,0x4(%esp)
  800215:	c7 04 24 5b 02 80 00 	movl   $0x80025b,(%esp)
  80021c:	e8 be 01 00 00       	call   8003df <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800221:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800227:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800231:	89 04 24             	mov    %eax,(%esp)
  800234:	e8 27 0a 00 00       	call   800c60 <sys_cputs>

	return b.cnt;
}
  800239:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800247:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80024a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	89 04 24             	mov    %eax,(%esp)
  800254:	e8 87 ff ff ff       	call   8001e0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	53                   	push   %ebx
  80025f:	83 ec 14             	sub    $0x14,%esp
  800262:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800265:	8b 03                	mov    (%ebx),%eax
  800267:	8b 55 08             	mov    0x8(%ebp),%edx
  80026a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80026e:	83 c0 01             	add    $0x1,%eax
  800271:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800273:	3d ff 00 00 00       	cmp    $0xff,%eax
  800278:	75 19                	jne    800293 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80027a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800281:	00 
  800282:	8d 43 08             	lea    0x8(%ebx),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	e8 d3 09 00 00       	call   800c60 <sys_cputs>
		b->idx = 0;
  80028d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800293:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800297:	83 c4 14             	add    $0x14,%esp
  80029a:	5b                   	pop    %ebx
  80029b:	5d                   	pop    %ebp
  80029c:	c3                   	ret    
  80029d:	00 00                	add    %al,(%eax)
	...

008002a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 4c             	sub    $0x4c,%esp
  8002a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ac:	89 d6                	mov    %edx,%esi
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002c0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002cb:	39 d1                	cmp    %edx,%ecx
  8002cd:	72 07                	jb     8002d6 <printnum+0x36>
  8002cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002d2:	39 d0                	cmp    %edx,%eax
  8002d4:	77 69                	ja     80033f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d6:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002da:	83 eb 01             	sub    $0x1,%ebx
  8002dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8002e9:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8002ed:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8002f0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002f3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002fa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800301:	00 
  800302:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800305:	89 04 24             	mov    %eax,(%esp)
  800308:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80030b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80030f:	e8 5c 12 00 00       	call   801570 <__udivdi3>
  800314:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800317:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80031a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80031e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800322:	89 04 24             	mov    %eax,(%esp)
  800325:	89 54 24 04          	mov    %edx,0x4(%esp)
  800329:	89 f2                	mov    %esi,%edx
  80032b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80032e:	e8 6d ff ff ff       	call   8002a0 <printnum>
  800333:	eb 11                	jmp    800346 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800335:	89 74 24 04          	mov    %esi,0x4(%esp)
  800339:	89 3c 24             	mov    %edi,(%esp)
  80033c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80033f:	83 eb 01             	sub    $0x1,%ebx
  800342:	85 db                	test   %ebx,%ebx
  800344:	7f ef                	jg     800335 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800346:	89 74 24 04          	mov    %esi,0x4(%esp)
  80034a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80034e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800351:	89 44 24 08          	mov    %eax,0x8(%esp)
  800355:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80035c:	00 
  80035d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800360:	89 14 24             	mov    %edx,(%esp)
  800363:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800366:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80036a:	e8 31 13 00 00       	call   8016a0 <__umoddi3>
  80036f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800373:	0f be 80 67 18 80 00 	movsbl 0x801867(%eax),%eax
  80037a:	89 04 24             	mov    %eax,(%esp)
  80037d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800380:	83 c4 4c             	add    $0x4c,%esp
  800383:	5b                   	pop    %ebx
  800384:	5e                   	pop    %esi
  800385:	5f                   	pop    %edi
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80038b:	83 fa 01             	cmp    $0x1,%edx
  80038e:	7e 0e                	jle    80039e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800390:	8b 10                	mov    (%eax),%edx
  800392:	8d 4a 08             	lea    0x8(%edx),%ecx
  800395:	89 08                	mov    %ecx,(%eax)
  800397:	8b 02                	mov    (%edx),%eax
  800399:	8b 52 04             	mov    0x4(%edx),%edx
  80039c:	eb 22                	jmp    8003c0 <getuint+0x38>
	else if (lflag)
  80039e:	85 d2                	test   %edx,%edx
  8003a0:	74 10                	je     8003b2 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003a2:	8b 10                	mov    (%eax),%edx
  8003a4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a7:	89 08                	mov    %ecx,(%eax)
  8003a9:	8b 02                	mov    (%edx),%eax
  8003ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b0:	eb 0e                	jmp    8003c0 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003b2:	8b 10                	mov    (%eax),%edx
  8003b4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003b7:	89 08                	mov    %ecx,(%eax)
  8003b9:	8b 02                	mov    (%edx),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003c0:	5d                   	pop    %ebp
  8003c1:	c3                   	ret    

008003c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003cc:	8b 10                	mov    (%eax),%edx
  8003ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d1:	73 0a                	jae    8003dd <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d6:	88 0a                	mov    %cl,(%edx)
  8003d8:	83 c2 01             	add    $0x1,%edx
  8003db:	89 10                	mov    %edx,(%eax)
}
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	57                   	push   %edi
  8003e3:	56                   	push   %esi
  8003e4:	53                   	push   %ebx
  8003e5:	83 ec 4c             	sub    $0x4c,%esp
  8003e8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8003f1:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8003f8:	eb 11                	jmp    80040b <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003fa:	85 c0                	test   %eax,%eax
  8003fc:	0f 84 b6 03 00 00    	je     8007b8 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800402:	89 74 24 04          	mov    %esi,0x4(%esp)
  800406:	89 04 24             	mov    %eax,(%esp)
  800409:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80040b:	0f b6 03             	movzbl (%ebx),%eax
  80040e:	83 c3 01             	add    $0x1,%ebx
  800411:	83 f8 25             	cmp    $0x25,%eax
  800414:	75 e4                	jne    8003fa <vprintfmt+0x1b>
  800416:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80041a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800421:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800428:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80042f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800434:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800437:	eb 06                	jmp    80043f <vprintfmt+0x60>
  800439:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  80043d:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043f:	0f b6 0b             	movzbl (%ebx),%ecx
  800442:	0f b6 c1             	movzbl %cl,%eax
  800445:	8d 53 01             	lea    0x1(%ebx),%edx
  800448:	83 e9 23             	sub    $0x23,%ecx
  80044b:	80 f9 55             	cmp    $0x55,%cl
  80044e:	0f 87 47 03 00 00    	ja     80079b <vprintfmt+0x3bc>
  800454:	0f b6 c9             	movzbl %cl,%ecx
  800457:	ff 24 8d a0 19 80 00 	jmp    *0x8019a0(,%ecx,4)
  80045e:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800462:	eb d9                	jmp    80043d <vprintfmt+0x5e>
  800464:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80046b:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800470:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800473:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800477:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80047a:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80047d:	83 fb 09             	cmp    $0x9,%ebx
  800480:	77 30                	ja     8004b2 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800482:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800485:	eb e9                	jmp    800470 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800487:	8b 45 14             	mov    0x14(%ebp),%eax
  80048a:	8d 48 04             	lea    0x4(%eax),%ecx
  80048d:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800490:	8b 00                	mov    (%eax),%eax
  800492:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800495:	eb 1e                	jmp    8004b5 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800497:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80049b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a0:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8004a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a7:	eb 94                	jmp    80043d <vprintfmt+0x5e>
  8004a9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8004b0:	eb 8b                	jmp    80043d <vprintfmt+0x5e>
  8004b2:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8004b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004b9:	79 82                	jns    80043d <vprintfmt+0x5e>
  8004bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004c1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004c4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004c7:	e9 71 ff ff ff       	jmp    80043d <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004cc:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004d0:	e9 68 ff ff ff       	jmp    80043d <vprintfmt+0x5e>
  8004d5:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	8d 50 04             	lea    0x4(%eax),%edx
  8004de:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	89 04 24             	mov    %eax,(%esp)
  8004ea:	ff d7                	call   *%edi
  8004ec:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8004ef:	e9 17 ff ff ff       	jmp    80040b <vprintfmt+0x2c>
  8004f4:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8d 50 04             	lea    0x4(%eax),%edx
  8004fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800500:	8b 00                	mov    (%eax),%eax
  800502:	89 c2                	mov    %eax,%edx
  800504:	c1 fa 1f             	sar    $0x1f,%edx
  800507:	31 d0                	xor    %edx,%eax
  800509:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050b:	83 f8 11             	cmp    $0x11,%eax
  80050e:	7f 0b                	jg     80051b <vprintfmt+0x13c>
  800510:	8b 14 85 00 1b 80 00 	mov    0x801b00(,%eax,4),%edx
  800517:	85 d2                	test   %edx,%edx
  800519:	75 20                	jne    80053b <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80051b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80051f:	c7 44 24 08 78 18 80 	movl   $0x801878,0x8(%esp)
  800526:	00 
  800527:	89 74 24 04          	mov    %esi,0x4(%esp)
  80052b:	89 3c 24             	mov    %edi,(%esp)
  80052e:	e8 0d 03 00 00       	call   800840 <printfmt>
  800533:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800536:	e9 d0 fe ff ff       	jmp    80040b <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80053b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80053f:	c7 44 24 08 81 18 80 	movl   $0x801881,0x8(%esp)
  800546:	00 
  800547:	89 74 24 04          	mov    %esi,0x4(%esp)
  80054b:	89 3c 24             	mov    %edi,(%esp)
  80054e:	e8 ed 02 00 00       	call   800840 <printfmt>
  800553:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800556:	e9 b0 fe ff ff       	jmp    80040b <vprintfmt+0x2c>
  80055b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80055e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800564:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 50 04             	lea    0x4(%eax),%edx
  80056d:	89 55 14             	mov    %edx,0x14(%ebp)
  800570:	8b 18                	mov    (%eax),%ebx
  800572:	85 db                	test   %ebx,%ebx
  800574:	b8 84 18 80 00       	mov    $0x801884,%eax
  800579:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  80057c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800580:	7e 76                	jle    8005f8 <vprintfmt+0x219>
  800582:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800586:	74 7a                	je     800602 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800588:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80058c:	89 1c 24             	mov    %ebx,(%esp)
  80058f:	e8 f4 02 00 00       	call   800888 <strnlen>
  800594:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800597:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800599:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  80059d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005a0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005a3:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a5:	eb 0f                	jmp    8005b6 <vprintfmt+0x1d7>
					putch(padc, putdat);
  8005a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ae:	89 04 24             	mov    %eax,(%esp)
  8005b1:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b3:	83 eb 01             	sub    $0x1,%ebx
  8005b6:	85 db                	test   %ebx,%ebx
  8005b8:	7f ed                	jg     8005a7 <vprintfmt+0x1c8>
  8005ba:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005bd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005c3:	89 f7                	mov    %esi,%edi
  8005c5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005c8:	eb 40                	jmp    80060a <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005ca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ce:	74 18                	je     8005e8 <vprintfmt+0x209>
  8005d0:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005d3:	83 fa 5e             	cmp    $0x5e,%edx
  8005d6:	76 10                	jbe    8005e8 <vprintfmt+0x209>
					putch('?', putdat);
  8005d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005dc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005e3:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005e6:	eb 0a                	jmp    8005f2 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8005e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ec:	89 04 24             	mov    %eax,(%esp)
  8005ef:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005f6:	eb 12                	jmp    80060a <vprintfmt+0x22b>
  8005f8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005fb:	89 f7                	mov    %esi,%edi
  8005fd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800600:	eb 08                	jmp    80060a <vprintfmt+0x22b>
  800602:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800605:	89 f7                	mov    %esi,%edi
  800607:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80060a:	0f be 03             	movsbl (%ebx),%eax
  80060d:	83 c3 01             	add    $0x1,%ebx
  800610:	85 c0                	test   %eax,%eax
  800612:	74 25                	je     800639 <vprintfmt+0x25a>
  800614:	85 f6                	test   %esi,%esi
  800616:	78 b2                	js     8005ca <vprintfmt+0x1eb>
  800618:	83 ee 01             	sub    $0x1,%esi
  80061b:	79 ad                	jns    8005ca <vprintfmt+0x1eb>
  80061d:	89 fe                	mov    %edi,%esi
  80061f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800622:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800625:	eb 1a                	jmp    800641 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800627:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800632:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800634:	83 eb 01             	sub    $0x1,%ebx
  800637:	eb 08                	jmp    800641 <vprintfmt+0x262>
  800639:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80063c:	89 fe                	mov    %edi,%esi
  80063e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800641:	85 db                	test   %ebx,%ebx
  800643:	7f e2                	jg     800627 <vprintfmt+0x248>
  800645:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800648:	e9 be fd ff ff       	jmp    80040b <vprintfmt+0x2c>
  80064d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800650:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800653:	83 f9 01             	cmp    $0x1,%ecx
  800656:	7e 16                	jle    80066e <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 50 08             	lea    0x8(%eax),%edx
  80065e:	89 55 14             	mov    %edx,0x14(%ebp)
  800661:	8b 10                	mov    (%eax),%edx
  800663:	8b 48 04             	mov    0x4(%eax),%ecx
  800666:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800669:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80066c:	eb 32                	jmp    8006a0 <vprintfmt+0x2c1>
	else if (lflag)
  80066e:	85 c9                	test   %ecx,%ecx
  800670:	74 18                	je     80068a <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 50 04             	lea    0x4(%eax),%edx
  800678:	89 55 14             	mov    %edx,0x14(%ebp)
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800680:	89 c1                	mov    %eax,%ecx
  800682:	c1 f9 1f             	sar    $0x1f,%ecx
  800685:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800688:	eb 16                	jmp    8006a0 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	89 55 14             	mov    %edx,0x14(%ebp)
  800693:	8b 00                	mov    (%eax),%eax
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	89 c2                	mov    %eax,%edx
  80069a:	c1 fa 1f             	sar    $0x1f,%edx
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006a0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006a3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006a6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006af:	0f 89 a7 00 00 00    	jns    80075c <vprintfmt+0x37d>
				putch('-', putdat);
  8006b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006b9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006c0:	ff d7                	call   *%edi
				num = -(long long) num;
  8006c2:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006c5:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006c8:	f7 d9                	neg    %ecx
  8006ca:	83 d3 00             	adc    $0x0,%ebx
  8006cd:	f7 db                	neg    %ebx
  8006cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d4:	e9 83 00 00 00       	jmp    80075c <vprintfmt+0x37d>
  8006d9:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006df:	89 ca                	mov    %ecx,%edx
  8006e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e4:	e8 9f fc ff ff       	call   800388 <getuint>
  8006e9:	89 c1                	mov    %eax,%ecx
  8006eb:	89 d3                	mov    %edx,%ebx
  8006ed:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8006f2:	eb 68                	jmp    80075c <vprintfmt+0x37d>
  8006f4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006f7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006fa:	89 ca                	mov    %ecx,%edx
  8006fc:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ff:	e8 84 fc ff ff       	call   800388 <getuint>
  800704:	89 c1                	mov    %eax,%ecx
  800706:	89 d3                	mov    %edx,%ebx
  800708:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  80070d:	eb 4d                	jmp    80075c <vprintfmt+0x37d>
  80070f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800712:	89 74 24 04          	mov    %esi,0x4(%esp)
  800716:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80071d:	ff d7                	call   *%edi
			putch('x', putdat);
  80071f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800723:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80072a:	ff d7                	call   *%edi
			num = (unsigned long long)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	89 55 14             	mov    %edx,0x14(%ebp)
  800735:	8b 08                	mov    (%eax),%ecx
  800737:	bb 00 00 00 00       	mov    $0x0,%ebx
  80073c:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800741:	eb 19                	jmp    80075c <vprintfmt+0x37d>
  800743:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800746:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800749:	89 ca                	mov    %ecx,%edx
  80074b:	8d 45 14             	lea    0x14(%ebp),%eax
  80074e:	e8 35 fc ff ff       	call   800388 <getuint>
  800753:	89 c1                	mov    %eax,%ecx
  800755:	89 d3                	mov    %edx,%ebx
  800757:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80075c:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800760:	89 54 24 10          	mov    %edx,0x10(%esp)
  800764:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800767:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80076b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80076f:	89 0c 24             	mov    %ecx,(%esp)
  800772:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800776:	89 f2                	mov    %esi,%edx
  800778:	89 f8                	mov    %edi,%eax
  80077a:	e8 21 fb ff ff       	call   8002a0 <printnum>
  80077f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800782:	e9 84 fc ff ff       	jmp    80040b <vprintfmt+0x2c>
  800787:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80078a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80078e:	89 04 24             	mov    %eax,(%esp)
  800791:	ff d7                	call   *%edi
  800793:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800796:	e9 70 fc ff ff       	jmp    80040b <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80079b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80079f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007a6:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8007ab:	80 38 25             	cmpb   $0x25,(%eax)
  8007ae:	0f 84 57 fc ff ff    	je     80040b <vprintfmt+0x2c>
  8007b4:	89 c3                	mov    %eax,%ebx
  8007b6:	eb f0                	jmp    8007a8 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8007b8:	83 c4 4c             	add    $0x4c,%esp
  8007bb:	5b                   	pop    %ebx
  8007bc:	5e                   	pop    %esi
  8007bd:	5f                   	pop    %edi
  8007be:	5d                   	pop    %ebp
  8007bf:	c3                   	ret    

008007c0 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 28             	sub    $0x28,%esp
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8007cc:	85 c0                	test   %eax,%eax
  8007ce:	74 04                	je     8007d4 <vsnprintf+0x14>
  8007d0:	85 d2                	test   %edx,%edx
  8007d2:	7f 07                	jg     8007db <vsnprintf+0x1b>
  8007d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d9:	eb 3b                	jmp    800816 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007de:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8007e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800801:	c7 04 24 c2 03 80 00 	movl   $0x8003c2,(%esp)
  800808:	e8 d2 fb ff ff       	call   8003df <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80080d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800810:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800813:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800816:	c9                   	leave  
  800817:	c3                   	ret    

00800818 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80081e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800821:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800825:	8b 45 10             	mov    0x10(%ebp),%eax
  800828:	89 44 24 08          	mov    %eax,0x8(%esp)
  80082c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	89 04 24             	mov    %eax,(%esp)
  800839:	e8 82 ff ff ff       	call   8007c0 <vsnprintf>
	va_end(ap);

	return rc;
}
  80083e:	c9                   	leave  
  80083f:	c3                   	ret    

00800840 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800846:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800849:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80084d:	8b 45 10             	mov    0x10(%ebp),%eax
  800850:	89 44 24 08          	mov    %eax,0x8(%esp)
  800854:	8b 45 0c             	mov    0xc(%ebp),%eax
  800857:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	89 04 24             	mov    %eax,(%esp)
  800861:	e8 79 fb ff ff       	call   8003df <vprintfmt>
	va_end(ap);
}
  800866:	c9                   	leave  
  800867:	c3                   	ret    
	...

00800870 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 55 08             	mov    0x8(%ebp),%edx
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80087b:	eb 03                	jmp    800880 <strlen+0x10>
		n++;
  80087d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800880:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800884:	75 f7                	jne    80087d <strlen+0xd>
		n++;
	return n;
}
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	53                   	push   %ebx
  80088c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80088f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800892:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800897:	eb 03                	jmp    80089c <strnlen+0x14>
		n++;
  800899:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089c:	39 c1                	cmp    %eax,%ecx
  80089e:	74 06                	je     8008a6 <strnlen+0x1e>
  8008a0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8008a4:	75 f3                	jne    800899 <strnlen+0x11>
		n++;
	return n;
}
  8008a6:	5b                   	pop    %ebx
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	53                   	push   %ebx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008b3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008bf:	83 c2 01             	add    $0x1,%edx
  8008c2:	84 c9                	test   %cl,%cl
  8008c4:	75 f2                	jne    8008b8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008c6:	5b                   	pop    %ebx
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	53                   	push   %ebx
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d3:	89 1c 24             	mov    %ebx,(%esp)
  8008d6:	e8 95 ff ff ff       	call   800870 <strlen>
	strcpy(dst + len, src);
  8008db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008de:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008e2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8008e5:	89 04 24             	mov    %eax,(%esp)
  8008e8:	e8 bc ff ff ff       	call   8008a9 <strcpy>
	return dst;
}
  8008ed:	89 d8                	mov    %ebx,%eax
  8008ef:	83 c4 08             	add    $0x8,%esp
  8008f2:	5b                   	pop    %ebx
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	56                   	push   %esi
  8008f9:	53                   	push   %ebx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800900:	8b 75 10             	mov    0x10(%ebp),%esi
  800903:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800908:	eb 0f                	jmp    800919 <strncpy+0x24>
		*dst++ = *src;
  80090a:	0f b6 19             	movzbl (%ecx),%ebx
  80090d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800910:	80 39 01             	cmpb   $0x1,(%ecx)
  800913:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	39 f2                	cmp    %esi,%edx
  80091b:	72 ed                	jb     80090a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80091d:	5b                   	pop    %ebx
  80091e:	5e                   	pop    %esi
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	56                   	push   %esi
  800925:	53                   	push   %ebx
  800926:	8b 75 08             	mov    0x8(%ebp),%esi
  800929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80092f:	89 f0                	mov    %esi,%eax
  800931:	85 d2                	test   %edx,%edx
  800933:	75 0a                	jne    80093f <strlcpy+0x1e>
  800935:	eb 17                	jmp    80094e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800937:	88 18                	mov    %bl,(%eax)
  800939:	83 c0 01             	add    $0x1,%eax
  80093c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80093f:	83 ea 01             	sub    $0x1,%edx
  800942:	74 07                	je     80094b <strlcpy+0x2a>
  800944:	0f b6 19             	movzbl (%ecx),%ebx
  800947:	84 db                	test   %bl,%bl
  800949:	75 ec                	jne    800937 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80094b:	c6 00 00             	movb   $0x0,(%eax)
  80094e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	5d                   	pop    %ebp
  800953:	c3                   	ret    

00800954 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095d:	eb 06                	jmp    800965 <strcmp+0x11>
		p++, q++;
  80095f:	83 c1 01             	add    $0x1,%ecx
  800962:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800965:	0f b6 01             	movzbl (%ecx),%eax
  800968:	84 c0                	test   %al,%al
  80096a:	74 04                	je     800970 <strcmp+0x1c>
  80096c:	3a 02                	cmp    (%edx),%al
  80096e:	74 ef                	je     80095f <strcmp+0xb>
  800970:	0f b6 c0             	movzbl %al,%eax
  800973:	0f b6 12             	movzbl (%edx),%edx
  800976:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	53                   	push   %ebx
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800984:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800987:	eb 09                	jmp    800992 <strncmp+0x18>
		n--, p++, q++;
  800989:	83 ea 01             	sub    $0x1,%edx
  80098c:	83 c0 01             	add    $0x1,%eax
  80098f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800992:	85 d2                	test   %edx,%edx
  800994:	75 07                	jne    80099d <strncmp+0x23>
  800996:	b8 00 00 00 00       	mov    $0x0,%eax
  80099b:	eb 13                	jmp    8009b0 <strncmp+0x36>
  80099d:	0f b6 18             	movzbl (%eax),%ebx
  8009a0:	84 db                	test   %bl,%bl
  8009a2:	74 04                	je     8009a8 <strncmp+0x2e>
  8009a4:	3a 19                	cmp    (%ecx),%bl
  8009a6:	74 e1                	je     800989 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 00             	movzbl (%eax),%eax
  8009ab:	0f b6 11             	movzbl (%ecx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
}
  8009b0:	5b                   	pop    %ebx
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009bd:	eb 07                	jmp    8009c6 <strchr+0x13>
		if (*s == c)
  8009bf:	38 ca                	cmp    %cl,%dl
  8009c1:	74 0f                	je     8009d2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009c3:	83 c0 01             	add    $0x1,%eax
  8009c6:	0f b6 10             	movzbl (%eax),%edx
  8009c9:	84 d2                	test   %dl,%dl
  8009cb:	75 f2                	jne    8009bf <strchr+0xc>
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009de:	eb 07                	jmp    8009e7 <strfind+0x13>
		if (*s == c)
  8009e0:	38 ca                	cmp    %cl,%dl
  8009e2:	74 0a                	je     8009ee <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009e4:	83 c0 01             	add    $0x1,%eax
  8009e7:	0f b6 10             	movzbl (%eax),%edx
  8009ea:	84 d2                	test   %dl,%dl
  8009ec:	75 f2                	jne    8009e0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	83 ec 0c             	sub    $0xc,%esp
  8009f6:	89 1c 24             	mov    %ebx,(%esp)
  8009f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009fd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a01:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a07:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a0a:	85 c9                	test   %ecx,%ecx
  800a0c:	74 30                	je     800a3e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a14:	75 25                	jne    800a3b <memset+0x4b>
  800a16:	f6 c1 03             	test   $0x3,%cl
  800a19:	75 20                	jne    800a3b <memset+0x4b>
		c &= 0xFF;
  800a1b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1e:	89 d3                	mov    %edx,%ebx
  800a20:	c1 e3 08             	shl    $0x8,%ebx
  800a23:	89 d6                	mov    %edx,%esi
  800a25:	c1 e6 18             	shl    $0x18,%esi
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	c1 e0 10             	shl    $0x10,%eax
  800a2d:	09 f0                	or     %esi,%eax
  800a2f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a31:	09 d8                	or     %ebx,%eax
  800a33:	c1 e9 02             	shr    $0x2,%ecx
  800a36:	fc                   	cld    
  800a37:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a39:	eb 03                	jmp    800a3e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3b:	fc                   	cld    
  800a3c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3e:	89 f8                	mov    %edi,%eax
  800a40:	8b 1c 24             	mov    (%esp),%ebx
  800a43:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a47:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a4b:	89 ec                	mov    %ebp,%esp
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	89 34 24             	mov    %esi,(%esp)
  800a58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800a62:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a65:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a67:	39 c6                	cmp    %eax,%esi
  800a69:	73 35                	jae    800aa0 <memmove+0x51>
  800a6b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a6e:	39 d0                	cmp    %edx,%eax
  800a70:	73 2e                	jae    800aa0 <memmove+0x51>
		s += n;
		d += n;
  800a72:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a74:	f6 c2 03             	test   $0x3,%dl
  800a77:	75 1b                	jne    800a94 <memmove+0x45>
  800a79:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a7f:	75 13                	jne    800a94 <memmove+0x45>
  800a81:	f6 c1 03             	test   $0x3,%cl
  800a84:	75 0e                	jne    800a94 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a86:	83 ef 04             	sub    $0x4,%edi
  800a89:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a8c:	c1 e9 02             	shr    $0x2,%ecx
  800a8f:	fd                   	std    
  800a90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a92:	eb 09                	jmp    800a9d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a94:	83 ef 01             	sub    $0x1,%edi
  800a97:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a9a:	fd                   	std    
  800a9b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a9d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a9e:	eb 20                	jmp    800ac0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aa6:	75 15                	jne    800abd <memmove+0x6e>
  800aa8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aae:	75 0d                	jne    800abd <memmove+0x6e>
  800ab0:	f6 c1 03             	test   $0x3,%cl
  800ab3:	75 08                	jne    800abd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800ab5:	c1 e9 02             	shr    $0x2,%ecx
  800ab8:	fc                   	cld    
  800ab9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abb:	eb 03                	jmp    800ac0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800abd:	fc                   	cld    
  800abe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac0:	8b 34 24             	mov    (%esp),%esi
  800ac3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ac7:	89 ec                	mov    %ebp,%esp
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	89 04 24             	mov    %eax,(%esp)
  800ae5:	e8 65 ff ff ff       	call   800a4f <memmove>
}
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800afb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b00:	eb 1c                	jmp    800b1e <memcmp+0x32>
		if (*s1 != *s2)
  800b02:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800b06:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800b0a:	83 c2 01             	add    $0x1,%edx
  800b0d:	83 e9 01             	sub    $0x1,%ecx
  800b10:	38 d8                	cmp    %bl,%al
  800b12:	74 0a                	je     800b1e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800b14:	0f b6 c0             	movzbl %al,%eax
  800b17:	0f b6 db             	movzbl %bl,%ebx
  800b1a:	29 d8                	sub    %ebx,%eax
  800b1c:	eb 09                	jmp    800b27 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1e:	85 c9                	test   %ecx,%ecx
  800b20:	75 e0                	jne    800b02 <memcmp+0x16>
  800b22:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b27:	5b                   	pop    %ebx
  800b28:	5e                   	pop    %esi
  800b29:	5f                   	pop    %edi
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b35:	89 c2                	mov    %eax,%edx
  800b37:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b3a:	eb 07                	jmp    800b43 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3c:	38 08                	cmp    %cl,(%eax)
  800b3e:	74 07                	je     800b47 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b40:	83 c0 01             	add    $0x1,%eax
  800b43:	39 d0                	cmp    %edx,%eax
  800b45:	72 f5                	jb     800b3c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	57                   	push   %edi
  800b4d:	56                   	push   %esi
  800b4e:	53                   	push   %ebx
  800b4f:	83 ec 04             	sub    $0x4,%esp
  800b52:	8b 55 08             	mov    0x8(%ebp),%edx
  800b55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b58:	eb 03                	jmp    800b5d <strtol+0x14>
		s++;
  800b5a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5d:	0f b6 02             	movzbl (%edx),%eax
  800b60:	3c 20                	cmp    $0x20,%al
  800b62:	74 f6                	je     800b5a <strtol+0x11>
  800b64:	3c 09                	cmp    $0x9,%al
  800b66:	74 f2                	je     800b5a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b68:	3c 2b                	cmp    $0x2b,%al
  800b6a:	75 0c                	jne    800b78 <strtol+0x2f>
		s++;
  800b6c:	8d 52 01             	lea    0x1(%edx),%edx
  800b6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b76:	eb 15                	jmp    800b8d <strtol+0x44>
	else if (*s == '-')
  800b78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b7f:	3c 2d                	cmp    $0x2d,%al
  800b81:	75 0a                	jne    800b8d <strtol+0x44>
		s++, neg = 1;
  800b83:	8d 52 01             	lea    0x1(%edx),%edx
  800b86:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8d:	85 db                	test   %ebx,%ebx
  800b8f:	0f 94 c0             	sete   %al
  800b92:	74 05                	je     800b99 <strtol+0x50>
  800b94:	83 fb 10             	cmp    $0x10,%ebx
  800b97:	75 15                	jne    800bae <strtol+0x65>
  800b99:	80 3a 30             	cmpb   $0x30,(%edx)
  800b9c:	75 10                	jne    800bae <strtol+0x65>
  800b9e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba2:	75 0a                	jne    800bae <strtol+0x65>
		s += 2, base = 16;
  800ba4:	83 c2 02             	add    $0x2,%edx
  800ba7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bac:	eb 13                	jmp    800bc1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bae:	84 c0                	test   %al,%al
  800bb0:	74 0f                	je     800bc1 <strtol+0x78>
  800bb2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800bb7:	80 3a 30             	cmpb   $0x30,(%edx)
  800bba:	75 05                	jne    800bc1 <strtol+0x78>
		s++, base = 8;
  800bbc:	83 c2 01             	add    $0x1,%edx
  800bbf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bc8:	0f b6 0a             	movzbl (%edx),%ecx
  800bcb:	89 cf                	mov    %ecx,%edi
  800bcd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bd0:	80 fb 09             	cmp    $0x9,%bl
  800bd3:	77 08                	ja     800bdd <strtol+0x94>
			dig = *s - '0';
  800bd5:	0f be c9             	movsbl %cl,%ecx
  800bd8:	83 e9 30             	sub    $0x30,%ecx
  800bdb:	eb 1e                	jmp    800bfb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800bdd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800be0:	80 fb 19             	cmp    $0x19,%bl
  800be3:	77 08                	ja     800bed <strtol+0xa4>
			dig = *s - 'a' + 10;
  800be5:	0f be c9             	movsbl %cl,%ecx
  800be8:	83 e9 57             	sub    $0x57,%ecx
  800beb:	eb 0e                	jmp    800bfb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800bed:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800bf0:	80 fb 19             	cmp    $0x19,%bl
  800bf3:	77 15                	ja     800c0a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bf5:	0f be c9             	movsbl %cl,%ecx
  800bf8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bfb:	39 f1                	cmp    %esi,%ecx
  800bfd:	7d 0b                	jge    800c0a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bff:	83 c2 01             	add    $0x1,%edx
  800c02:	0f af c6             	imul   %esi,%eax
  800c05:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c08:	eb be                	jmp    800bc8 <strtol+0x7f>
  800c0a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c10:	74 05                	je     800c17 <strtol+0xce>
		*endptr = (char *) s;
  800c12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c15:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c17:	89 ca                	mov    %ecx,%edx
  800c19:	f7 da                	neg    %edx
  800c1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c1f:	0f 45 c2             	cmovne %edx,%eax
}
  800c22:	83 c4 04             	add    $0x4,%esp
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    
	...

00800c2c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	89 1c 24             	mov    %ebx,(%esp)
  800c35:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c39:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c42:	b8 01 00 00 00       	mov    $0x1,%eax
  800c47:	89 d1                	mov    %edx,%ecx
  800c49:	89 d3                	mov    %edx,%ebx
  800c4b:	89 d7                	mov    %edx,%edi
  800c4d:	89 d6                	mov    %edx,%esi
  800c4f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c51:	8b 1c 24             	mov    (%esp),%ebx
  800c54:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c5c:	89 ec                	mov    %ebp,%esp
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    

00800c60 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 0c             	sub    $0xc,%esp
  800c66:	89 1c 24             	mov    %ebx,(%esp)
  800c69:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c6d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c79:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7c:	89 c3                	mov    %eax,%ebx
  800c7e:	89 c7                	mov    %eax,%edi
  800c80:	89 c6                	mov    %eax,%esi
  800c82:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c84:	8b 1c 24             	mov    (%esp),%ebx
  800c87:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c8b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c8f:	89 ec                	mov    %ebp,%esp
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	89 1c 24             	mov    %ebx,(%esp)
  800c9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ca0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca9:	b8 10 00 00 00       	mov    $0x10,%eax
  800cae:	89 d1                	mov    %edx,%ecx
  800cb0:	89 d3                	mov    %edx,%ebx
  800cb2:	89 d7                	mov    %edx,%edi
  800cb4:	89 d6                	mov    %edx,%esi
  800cb6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800cb8:	8b 1c 24             	mov    (%esp),%ebx
  800cbb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cbf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cc3:	89 ec                	mov    %ebp,%esp
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 38             	sub    $0x38,%esp
  800ccd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cd0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cd3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	89 df                	mov    %ebx,%edi
  800ce8:	89 de                	mov    %ebx,%esi
  800cea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7e 28                	jle    800d18 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cf4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800cfb:	00 
  800cfc:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  800d03:	00 
  800d04:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d0b:	00 
  800d0c:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  800d13:	e8 70 f4 ff ff       	call   800188 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800d18:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d1b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d1e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d21:	89 ec                	mov    %ebp,%esp
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 38             	sub    $0x38,%esp
  800d2b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d2e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d31:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d39:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d41:	8b 55 08             	mov    0x8(%ebp),%edx
  800d44:	89 df                	mov    %ebx,%edi
  800d46:	89 de                	mov    %ebx,%esi
  800d48:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	7e 28                	jle    800d76 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d52:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800d59:	00 
  800d5a:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  800d61:	00 
  800d62:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d69:	00 
  800d6a:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  800d71:	e8 12 f4 ff ff       	call   800188 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800d76:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d79:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d7c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d7f:	89 ec                	mov    %ebp,%esp
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 38             	sub    $0x38,%esp
  800d89:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d8c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d8f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d97:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	89 cb                	mov    %ecx,%ebx
  800da1:	89 cf                	mov    %ecx,%edi
  800da3:	89 ce                	mov    %ecx,%esi
  800da5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	7e 28                	jle    800dd3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dab:	89 44 24 10          	mov    %eax,0x10(%esp)
  800daf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800db6:	00 
  800db7:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  800dbe:	00 
  800dbf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc6:	00 
  800dc7:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  800dce:	e8 b5 f3 ff ff       	call   800188 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dd3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ddc:	89 ec                	mov    %ebp,%esp
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 0c             	sub    $0xc,%esp
  800de6:	89 1c 24             	mov    %ebx,(%esp)
  800de9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ded:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df1:	be 00 00 00 00       	mov    $0x0,%esi
  800df6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dfb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e09:	8b 1c 24             	mov    (%esp),%ebx
  800e0c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e10:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e14:	89 ec                	mov    %ebp,%esp
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 38             	sub    $0x38,%esp
  800e1e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e21:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e24:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	89 df                	mov    %ebx,%edi
  800e39:	89 de                	mov    %ebx,%esi
  800e3b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	7e 28                	jle    800e69 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e41:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e45:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e4c:	00 
  800e4d:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  800e54:	00 
  800e55:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e5c:	00 
  800e5d:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  800e64:	e8 1f f3 ff ff       	call   800188 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e69:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e6c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e6f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e72:	89 ec                	mov    %ebp,%esp
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 38             	sub    $0x38,%esp
  800e7c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e7f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e82:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	89 df                	mov    %ebx,%edi
  800e97:	89 de                	mov    %ebx,%esi
  800e99:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	7e 28                	jle    800ec7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eaa:	00 
  800eab:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  800eb2:	00 
  800eb3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eba:	00 
  800ebb:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  800ec2:	e8 c1 f2 ff ff       	call   800188 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ec7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eca:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ecd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ed0:	89 ec                	mov    %ebp,%esp
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    

00800ed4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 38             	sub    $0x38,%esp
  800eda:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800edd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ee0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee8:	b8 08 00 00 00       	mov    $0x8,%eax
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	89 df                	mov    %ebx,%edi
  800ef5:	89 de                	mov    %ebx,%esi
  800ef7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	7e 28                	jle    800f25 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f01:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f08:	00 
  800f09:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  800f10:	00 
  800f11:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f18:	00 
  800f19:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  800f20:	e8 63 f2 ff ff       	call   800188 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f25:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f28:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f2b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f2e:	89 ec                	mov    %ebp,%esp
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    

00800f32 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 38             	sub    $0x38,%esp
  800f38:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f3b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f46:	b8 06 00 00 00       	mov    $0x6,%eax
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	89 df                	mov    %ebx,%edi
  800f53:	89 de                	mov    %ebx,%esi
  800f55:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	7e 28                	jle    800f83 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f66:	00 
  800f67:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  800f6e:	00 
  800f6f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f76:	00 
  800f77:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  800f7e:	e8 05 f2 ff ff       	call   800188 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f83:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f86:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f89:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f8c:	89 ec                	mov    %ebp,%esp
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	83 ec 38             	sub    $0x38,%esp
  800f96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f99:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f9c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9f:	b8 05 00 00 00       	mov    $0x5,%eax
  800fa4:	8b 75 18             	mov    0x18(%ebp),%esi
  800fa7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800faa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	7e 28                	jle    800fe1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fc4:	00 
  800fc5:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  800fcc:	00 
  800fcd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd4:	00 
  800fd5:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  800fdc:	e8 a7 f1 ff ff       	call   800188 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fe1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fea:	89 ec                	mov    %ebp,%esp
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    

00800fee <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 38             	sub    $0x38,%esp
  800ff4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ff7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ffa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffd:	be 00 00 00 00       	mov    $0x0,%esi
  801002:	b8 04 00 00 00       	mov    $0x4,%eax
  801007:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80100a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100d:	8b 55 08             	mov    0x8(%ebp),%edx
  801010:	89 f7                	mov    %esi,%edi
  801012:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801014:	85 c0                	test   %eax,%eax
  801016:	7e 28                	jle    801040 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801018:	89 44 24 10          	mov    %eax,0x10(%esp)
  80101c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801023:	00 
  801024:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  80102b:	00 
  80102c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801033:	00 
  801034:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  80103b:	e8 48 f1 ff ff       	call   800188 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801040:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801043:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801046:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801049:	89 ec                	mov    %ebp,%esp
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	89 1c 24             	mov    %ebx,(%esp)
  801056:	89 74 24 04          	mov    %esi,0x4(%esp)
  80105a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105e:	ba 00 00 00 00       	mov    $0x0,%edx
  801063:	b8 0b 00 00 00       	mov    $0xb,%eax
  801068:	89 d1                	mov    %edx,%ecx
  80106a:	89 d3                	mov    %edx,%ebx
  80106c:	89 d7                	mov    %edx,%edi
  80106e:	89 d6                	mov    %edx,%esi
  801070:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801072:	8b 1c 24             	mov    (%esp),%ebx
  801075:	8b 74 24 04          	mov    0x4(%esp),%esi
  801079:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80107d:	89 ec                	mov    %ebp,%esp
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 0c             	sub    $0xc,%esp
  801087:	89 1c 24             	mov    %ebx,(%esp)
  80108a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80108e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801092:	ba 00 00 00 00       	mov    $0x0,%edx
  801097:	b8 02 00 00 00       	mov    $0x2,%eax
  80109c:	89 d1                	mov    %edx,%ecx
  80109e:	89 d3                	mov    %edx,%ebx
  8010a0:	89 d7                	mov    %edx,%edi
  8010a2:	89 d6                	mov    %edx,%esi
  8010a4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010a6:	8b 1c 24             	mov    (%esp),%ebx
  8010a9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010ad:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010b1:	89 ec                	mov    %ebp,%esp
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	83 ec 38             	sub    $0x38,%esp
  8010bb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010be:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010c1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c9:	b8 03 00 00 00       	mov    $0x3,%eax
  8010ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d1:	89 cb                	mov    %ecx,%ebx
  8010d3:	89 cf                	mov    %ecx,%edi
  8010d5:	89 ce                	mov    %ecx,%esi
  8010d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	7e 28                	jle    801105 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010e8:	00 
  8010e9:	c7 44 24 08 67 1b 80 	movl   $0x801b67,0x8(%esp)
  8010f0:	00 
  8010f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f8:	00 
  8010f9:	c7 04 24 84 1b 80 00 	movl   $0x801b84,(%esp)
  801100:	e8 83 f0 ff ff       	call   800188 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801105:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801108:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80110b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80110e:	89 ec                	mov    %ebp,%esp
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    
	...

00801114 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80111a:	c7 44 24 08 92 1b 80 	movl   $0x801b92,0x8(%esp)
  801121:	00 
  801122:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801129:	00 
  80112a:	c7 04 24 a8 1b 80 00 	movl   $0x801ba8,(%esp)
  801131:	e8 52 f0 ff ff       	call   800188 <_panic>

00801136 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	57                   	push   %edi
  80113a:	56                   	push   %esi
  80113b:	53                   	push   %ebx
  80113c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  80113f:	c7 04 24 a4 13 80 00 	movl   $0x8013a4,(%esp)
  801146:	e8 81 03 00 00       	call   8014cc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80114b:	ba 07 00 00 00       	mov    $0x7,%edx
  801150:	89 d0                	mov    %edx,%eax
  801152:	cd 30                	int    $0x30
  801154:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801157:	85 c0                	test   %eax,%eax
  801159:	79 20                	jns    80117b <fork+0x45>
		panic("sys_exofork: %e", envid);
  80115b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80115f:	c7 44 24 08 b3 1b 80 	movl   $0x801bb3,0x8(%esp)
  801166:	00 
  801167:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80116e:	00 
  80116f:	c7 04 24 a8 1b 80 00 	movl   $0x801ba8,(%esp)
  801176:	e8 0d f0 ff ff       	call   800188 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  80117b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801182:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801187:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80118b:	75 21                	jne    8011ae <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80118d:	e8 ef fe ff ff       	call   801081 <sys_getenvid>
  801192:	25 ff 03 00 00       	and    $0x3ff,%eax
  801197:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80119a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80119f:	a3 08 20 80 00       	mov    %eax,0x802008
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  8011a9:	e9 e5 01 00 00       	jmp    801393 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  8011ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8011b1:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8011b8:	a8 01                	test   $0x1,%al
  8011ba:	0f 84 4c 01 00 00    	je     80130c <fork+0x1d6>
  8011c0:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  8011c6:	0f 84 cf 01 00 00    	je     80139b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  8011cc:	c1 e2 16             	shl    $0x16,%edx
  8011cf:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  8011d2:	89 d3                	mov    %edx,%ebx
  8011d4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011db:	00 
  8011dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011e3:	89 04 24             	mov    %eax,(%esp)
  8011e6:	e8 03 fe ff ff       	call   800fee <sys_page_alloc>
			if(ret < 0) return ret;
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	0f 88 a0 01 00 00    	js     801393 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  8011f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8011fa:	89 14 24             	mov    %edx,(%esp)
  8011fd:	e8 30 fd ff ff       	call   800f32 <sys_page_unmap>
			if(ret < 0) return ret;
  801202:	85 c0                	test   %eax,%eax
  801204:	0f 88 89 01 00 00    	js     801393 <fork+0x25d>
  80120a:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  80120f:	89 de                	mov    %ebx,%esi
  801211:	c1 e6 0c             	shl    $0xc,%esi
  801214:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801217:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  80121d:	0f 84 da 00 00 00    	je     8012fd <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801223:	c1 ee 0c             	shr    $0xc,%esi
  801226:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801229:	a8 01                	test   $0x1,%al
  80122b:	0f 84 cc 00 00 00    	je     8012fd <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801231:	89 f0                	mov    %esi,%eax
  801233:	c1 e0 0c             	shl    $0xc,%eax
  801236:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801239:	e8 43 fe ff ff       	call   801081 <sys_getenvid>
  80123e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801241:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801244:	89 c6                	mov    %eax,%esi
  801246:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  80124c:	25 01 04 00 00       	and    $0x401,%eax
  801251:	3d 01 04 00 00       	cmp    $0x401,%eax
  801256:	75 3a                	jne    801292 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801258:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80125f:	00 
  801260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801263:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801267:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80126a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80126e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801272:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801275:	89 14 24             	mov    %edx,(%esp)
  801278:	e8 13 fd ff ff       	call   800f90 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  80127d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801280:	89 44 24 04          	mov    %eax,0x4(%esp)
  801284:	c7 04 24 c3 1b 80 00 	movl   $0x801bc3,(%esp)
  80128b:	e8 b1 ef ff ff       	call   800241 <cprintf>
  801290:	eb 6b                	jmp    8012fd <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801292:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801298:	74 14                	je     8012ae <fork+0x178>
  80129a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  8012a0:	74 0c                	je     8012ae <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  8012a2:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  8012a8:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  8012ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012b1:	89 74 24 10          	mov    %esi,0x10(%esp)
  8012b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012c7:	89 14 24             	mov    %edx,(%esp)
  8012ca:	e8 c1 fc ff ff       	call   800f90 <sys_page_map>
	if(ret<0) return ret;
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	0f 88 bc 00 00 00    	js     801393 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  8012d7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8012db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012e5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8012e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ed:	89 14 24             	mov    %edx,(%esp)
  8012f0:	e8 9b fc ff ff       	call   800f90 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	0f 88 96 00 00 00    	js     801393 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  8012fd:	83 c3 01             	add    $0x1,%ebx
  801300:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801306:	0f 85 03 ff ff ff    	jne    80120f <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80130c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801310:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801317:	0f 85 91 fe ff ff    	jne    8011ae <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  80131d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801324:	00 
  801325:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80132c:	ee 
  80132d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801330:	89 04 24             	mov    %eax,(%esp)
  801333:	e8 b6 fc ff ff       	call   800fee <sys_page_alloc>
	if(ret < 0) return ret;
  801338:	85 c0                	test   %eax,%eax
  80133a:	78 57                	js     801393 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  80133c:	a1 08 20 80 00       	mov    0x802008,%eax
  801341:	8b 40 64             	mov    0x64(%eax),%eax
  801344:	89 44 24 04          	mov    %eax,0x4(%esp)
  801348:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80134b:	89 14 24             	mov    %edx,(%esp)
  80134e:	e8 c5 fa ff ff       	call   800e18 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801353:	85 c0                	test   %eax,%eax
  801355:	78 3c                	js     801393 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801357:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80135e:	00 
  80135f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801362:	89 04 24             	mov    %eax,(%esp)
  801365:	e8 6a fb ff ff       	call   800ed4 <sys_env_set_status>
  80136a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  80136c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80136f:	85 d2                	test   %edx,%edx
  801371:	79 20                	jns    801393 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801373:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801377:	c7 44 24 08 da 1b 80 	movl   $0x801bda,0x8(%esp)
  80137e:	00 
  80137f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801386:	00 
  801387:	c7 04 24 a8 1b 80 00 	movl   $0x801ba8,(%esp)
  80138e:	e8 f5 ed ff ff       	call   800188 <_panic>

	return envid;
}
  801393:	83 c4 4c             	add    $0x4c,%esp
  801396:	5b                   	pop    %ebx
  801397:	5e                   	pop    %esi
  801398:	5f                   	pop    %edi
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80139b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80139f:	e9 0a fe ff ff       	jmp    8011ae <fork+0x78>

008013a4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	56                   	push   %esi
  8013a8:	53                   	push   %ebx
  8013a9:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  8013ac:	e8 d0 fc ff ff       	call   801081 <sys_getenvid>
  8013b1:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8b 00                	mov    (%eax),%eax
  8013b8:	89 c6                	mov    %eax,%esi
  8013ba:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  8013bd:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8013c4:	f6 c2 02             	test   $0x2,%dl
  8013c7:	75 2c                	jne    8013f5 <pgfault+0x51>
  8013c9:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8013d0:	f6 c6 08             	test   $0x8,%dh
  8013d3:	75 20                	jne    8013f5 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  8013d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013d9:	c7 44 24 08 28 1c 80 	movl   $0x801c28,0x8(%esp)
  8013e0:	00 
  8013e1:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8013e8:	00 
  8013e9:	c7 04 24 a8 1b 80 00 	movl   $0x801ba8,(%esp)
  8013f0:	e8 93 ed ff ff       	call   800188 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8013f5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013fc:	00 
  8013fd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801404:	00 
  801405:	89 1c 24             	mov    %ebx,(%esp)
  801408:	e8 e1 fb ff ff       	call   800fee <sys_page_alloc>
  80140d:	85 c0                	test   %eax,%eax
  80140f:	79 20                	jns    801431 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801411:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801415:	c7 44 24 08 f1 1b 80 	movl   $0x801bf1,0x8(%esp)
  80141c:	00 
  80141d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801424:	00 
  801425:	c7 04 24 a8 1b 80 00 	movl   $0x801ba8,(%esp)
  80142c:	e8 57 ed ff ff       	call   800188 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801431:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801434:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80143b:	00 
  80143c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801440:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801447:	e8 03 f6 ff ff       	call   800a4f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80144c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801453:	00 
  801454:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801458:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80145c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801463:	00 
  801464:	89 1c 24             	mov    %ebx,(%esp)
  801467:	e8 24 fb ff ff       	call   800f90 <sys_page_map>
  80146c:	85 c0                	test   %eax,%eax
  80146e:	79 20                	jns    801490 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801470:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801474:	c7 44 24 08 03 1c 80 	movl   $0x801c03,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 a8 1b 80 00 	movl   $0x801ba8,(%esp)
  80148b:	e8 f8 ec ff ff       	call   800188 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801490:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801497:	00 
  801498:	89 1c 24             	mov    %ebx,(%esp)
  80149b:	e8 92 fa ff ff       	call   800f32 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	74 20                	je     8014c4 <pgfault+0x120>
  8014a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014a8:	c7 44 24 08 13 1c 80 	movl   $0x801c13,0x8(%esp)
  8014af:	00 
  8014b0:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8014b7:	00 
  8014b8:	c7 04 24 a8 1b 80 00 	movl   $0x801ba8,(%esp)
  8014bf:	e8 c4 ec ff ff       	call   800188 <_panic>

}
  8014c4:	83 c4 20             	add    $0x20,%esp
  8014c7:	5b                   	pop    %ebx
  8014c8:	5e                   	pop    %esi
  8014c9:	5d                   	pop    %ebp
  8014ca:	c3                   	ret    
	...

008014cc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  8014d3:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  8014da:	75 5b                	jne    801537 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  8014dc:	e8 a0 fb ff ff       	call   801081 <sys_getenvid>
  8014e1:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  8014e3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014ea:	00 
  8014eb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014f2:	ee 
  8014f3:	89 04 24             	mov    %eax,(%esp)
  8014f6:	e8 f3 fa ff ff       	call   800fee <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	74 28                	je     801527 <set_pgfault_handler+0x5b>
  8014ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  801503:	c7 44 24 0c 73 1c 80 	movl   $0x801c73,0xc(%esp)
  80150a:	00 
  80150b:	c7 44 24 08 4c 1c 80 	movl   $0x801c4c,0x8(%esp)
  801512:	00 
  801513:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80151a:	00 
  80151b:	c7 04 24 65 1c 80 00 	movl   $0x801c65,(%esp)
  801522:	e8 61 ec ff ff       	call   800188 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  801527:	c7 44 24 04 48 15 80 	movl   $0x801548,0x4(%esp)
  80152e:	00 
  80152f:	89 1c 24             	mov    %ebx,(%esp)
  801532:	e8 e1 f8 ff ff       	call   800e18 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	a3 0c 20 80 00       	mov    %eax,0x80200c
	
}
  80153f:	83 c4 24             	add    $0x24,%esp
  801542:	5b                   	pop    %ebx
  801543:	5d                   	pop    %ebp
  801544:	c3                   	ret    
  801545:	00 00                	add    %al,(%eax)
	...

00801548 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801548:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801549:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  80154e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801550:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  801553:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  801556:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  80155a:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  80155e:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  801561:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  801564:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  801568:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  801569:	83 c4 04             	add    $0x4,%esp
	popfl ;
  80156c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  80156d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80156e:	c3                   	ret    
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
