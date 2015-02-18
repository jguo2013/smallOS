
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 8b 01 00 00       	call   8001bc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  80003a:	a1 04 40 80 00       	mov    0x804004,%eax
  80003f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800043:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80004a:	e8 ea 08 00 00       	call   800939 <strcpy>
	exit();
  80004f:	e8 b8 01 00 00       	call   80020c <exit>
}
  800054:	c9                   	leave  
  800055:	c3                   	ret    

00800056 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	53                   	push   %ebx
  80005a:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800061:	74 05                	je     800068 <umain+0x12>
		childofspawn();
  800063:	e8 cc ff ff ff       	call   800034 <childofspawn>

	if ((r = sys_page_alloc(sys_getenvid(), VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800068:	e8 a4 10 00 00       	call   801111 <sys_getenvid>
  80006d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800074:	00 
  800075:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  80007c:	a0 
  80007d:	89 04 24             	mov    %eax,(%esp)
  800080:	e8 f9 0f 00 00       	call   80107e <sys_page_alloc>
  800085:	85 c0                	test   %eax,%eax
  800087:	79 20                	jns    8000a9 <umain+0x53>
		panic("sys_page_alloc: %e", r);
  800089:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008d:	c7 44 24 08 a0 34 80 	movl   $0x8034a0,0x8(%esp)
  800094:	00 
  800095:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009c:	00 
  80009d:	c7 04 24 b3 34 80 00 	movl   $0x8034b3,(%esp)
  8000a4:	e8 77 01 00 00       	call   800220 <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a9:	e8 18 11 00 00       	call   8011c6 <fork>
  8000ae:	89 c3                	mov    %eax,%ebx
  8000b0:	85 c0                	test   %eax,%eax
  8000b2:	79 20                	jns    8000d4 <umain+0x7e>
		panic("fork: %e", r);
  8000b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b8:	c7 44 24 08 da 38 80 	movl   $0x8038da,0x8(%esp)
  8000bf:	00 
  8000c0:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c7:	00 
  8000c8:	c7 04 24 b3 34 80 00 	movl   $0x8034b3,(%esp)
  8000cf:	e8 4c 01 00 00       	call   800220 <_panic>
	if (r == 0) {
  8000d4:	85 c0                	test   %eax,%eax
  8000d6:	75 1a                	jne    8000f2 <umain+0x9c>
		strcpy(VA, msg);
  8000d8:	a1 00 40 80 00       	mov    0x804000,%eax
  8000dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e1:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e8:	e8 4c 08 00 00       	call   800939 <strcpy>
		exit();
  8000ed:	e8 1a 01 00 00       	call   80020c <exit>
	}
	wait(r);
  8000f2:	89 1c 24             	mov    %ebx,(%esp)
  8000f5:	e8 16 1b 00 00       	call   801c10 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000fa:	a1 00 40 80 00       	mov    0x804000,%eax
  8000ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800103:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80010a:	e8 d5 08 00 00       	call   8009e4 <strcmp>
  80010f:	85 c0                	test   %eax,%eax
  800111:	b8 c7 34 80 00       	mov    $0x8034c7,%eax
  800116:	ba cd 34 80 00       	mov    $0x8034cd,%edx
  80011b:	0f 44 c2             	cmove  %edx,%eax
  80011e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800122:	c7 04 24 d3 34 80 00 	movl   $0x8034d3,(%esp)
  800129:	e8 ab 01 00 00       	call   8002d9 <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800135:	00 
  800136:	c7 44 24 08 ee 34 80 	movl   $0x8034ee,0x8(%esp)
  80013d:	00 
  80013e:	c7 44 24 04 f3 34 80 	movl   $0x8034f3,0x4(%esp)
  800145:	00 
  800146:	c7 04 24 f2 34 80 00 	movl   $0x8034f2,(%esp)
  80014d:	e8 53 1a 00 00       	call   801ba5 <spawnl>
  800152:	85 c0                	test   %eax,%eax
  800154:	79 20                	jns    800176 <umain+0x120>
		panic("spawn: %e", r);
  800156:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015a:	c7 44 24 08 00 35 80 	movl   $0x803500,0x8(%esp)
  800161:	00 
  800162:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800169:	00 
  80016a:	c7 04 24 b3 34 80 00 	movl   $0x8034b3,(%esp)
  800171:	e8 aa 00 00 00       	call   800220 <_panic>
	wait(r);
  800176:	89 04 24             	mov    %eax,(%esp)
  800179:	e8 92 1a 00 00       	call   801c10 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017e:	a1 04 40 80 00       	mov    0x804004,%eax
  800183:	89 44 24 04          	mov    %eax,0x4(%esp)
  800187:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018e:	e8 51 08 00 00       	call   8009e4 <strcmp>
  800193:	85 c0                	test   %eax,%eax
  800195:	b8 c7 34 80 00       	mov    $0x8034c7,%eax
  80019a:	ba cd 34 80 00       	mov    $0x8034cd,%edx
  80019f:	0f 44 c2             	cmove  %edx,%eax
  8001a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a6:	c7 04 24 0a 35 80 00 	movl   $0x80350a,(%esp)
  8001ad:	e8 27 01 00 00       	call   8002d9 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001b2:	cc                   	int3   

	breakpoint();
}
  8001b3:	83 c4 14             	add    $0x14,%esp
  8001b6:	5b                   	pop    %ebx
  8001b7:	5d                   	pop    %ebp
  8001b8:	c3                   	ret    
  8001b9:	00 00                	add    %al,(%eax)
	...

008001bc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	83 ec 18             	sub    $0x18,%esp
  8001c2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001c5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8001cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8001ce:	e8 3e 0f 00 00       	call   801111 <sys_getenvid>
  8001d3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001db:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8001e0:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	85 f6                	test   %esi,%esi
  8001e7:	7e 07                	jle    8001f0 <libmain+0x34>
		binaryname = argv[0];
  8001e9:	8b 03                	mov    (%ebx),%eax
  8001eb:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f4:	89 34 24             	mov    %esi,(%esp)
  8001f7:	e8 5a fe ff ff       	call   800056 <umain>

	// exit gracefully
	exit();
  8001fc:	e8 0b 00 00 00       	call   80020c <exit>
}
  800201:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800204:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800207:	89 ec                	mov    %ebp,%esp
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    
	...

0080020c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800212:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800219:	e8 27 0f 00 00       	call   801145 <sys_env_destroy>
}
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	56                   	push   %esi
  800224:	53                   	push   %ebx
  800225:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800228:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022b:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800231:	e8 db 0e 00 00       	call   801111 <sys_getenvid>
  800236:	8b 55 0c             	mov    0xc(%ebp),%edx
  800239:	89 54 24 10          	mov    %edx,0x10(%esp)
  80023d:	8b 55 08             	mov    0x8(%ebp),%edx
  800240:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800244:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024c:	c7 04 24 50 35 80 00 	movl   $0x803550,(%esp)
  800253:	e8 81 00 00 00       	call   8002d9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800258:	89 74 24 04          	mov    %esi,0x4(%esp)
  80025c:	8b 45 10             	mov    0x10(%ebp),%eax
  80025f:	89 04 24             	mov    %eax,(%esp)
  800262:	e8 11 00 00 00       	call   800278 <vcprintf>
	cprintf("\n");
  800267:	c7 04 24 e2 3b 80 00 	movl   $0x803be2,(%esp)
  80026e:	e8 66 00 00 00       	call   8002d9 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800273:	cc                   	int3   
  800274:	eb fd                	jmp    800273 <_panic+0x53>
	...

00800278 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800281:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800288:	00 00 00 
	b.cnt = 0;
  80028b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800292:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800295:	8b 45 0c             	mov    0xc(%ebp),%eax
  800298:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029c:	8b 45 08             	mov    0x8(%ebp),%eax
  80029f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ad:	c7 04 24 f3 02 80 00 	movl   $0x8002f3,(%esp)
  8002b4:	e8 be 01 00 00       	call   800477 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002c9:	89 04 24             	mov    %eax,(%esp)
  8002cc:	e8 1f 0a 00 00       	call   800cf0 <sys_cputs>

	return b.cnt;
}
  8002d1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    

008002d9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8002df:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8002e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e9:	89 04 24             	mov    %eax,(%esp)
  8002ec:	e8 87 ff ff ff       	call   800278 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002f1:	c9                   	leave  
  8002f2:	c3                   	ret    

008002f3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	53                   	push   %ebx
  8002f7:	83 ec 14             	sub    $0x14,%esp
  8002fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002fd:	8b 03                	mov    (%ebx),%eax
  8002ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800302:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800306:	83 c0 01             	add    $0x1,%eax
  800309:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80030b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800310:	75 19                	jne    80032b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800312:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800319:	00 
  80031a:	8d 43 08             	lea    0x8(%ebx),%eax
  80031d:	89 04 24             	mov    %eax,(%esp)
  800320:	e8 cb 09 00 00       	call   800cf0 <sys_cputs>
		b->idx = 0;
  800325:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80032b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80032f:	83 c4 14             	add    $0x14,%esp
  800332:	5b                   	pop    %ebx
  800333:	5d                   	pop    %ebp
  800334:	c3                   	ret    
  800335:	00 00                	add    %al,(%eax)
	...

00800338 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	57                   	push   %edi
  80033c:	56                   	push   %esi
  80033d:	53                   	push   %ebx
  80033e:	83 ec 4c             	sub    $0x4c,%esp
  800341:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800344:	89 d6                	mov    %edx,%esi
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800358:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80035e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800363:	39 d1                	cmp    %edx,%ecx
  800365:	72 07                	jb     80036e <printnum+0x36>
  800367:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80036a:	39 d0                	cmp    %edx,%eax
  80036c:	77 69                	ja     8003d7 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036e:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800372:	83 eb 01             	sub    $0x1,%ebx
  800375:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800379:	89 44 24 08          	mov    %eax,0x8(%esp)
  80037d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800381:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800385:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800388:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80038b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80038e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800392:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800399:	00 
  80039a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039d:	89 04 24             	mov    %eax,(%esp)
  8003a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003a7:	e8 74 2e 00 00       	call   803220 <__udivdi3>
  8003ac:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003af:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003b6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003ba:	89 04 24             	mov    %eax,(%esp)
  8003bd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003c1:	89 f2                	mov    %esi,%edx
  8003c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003c6:	e8 6d ff ff ff       	call   800338 <printnum>
  8003cb:	eb 11                	jmp    8003de <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d1:	89 3c 24             	mov    %edi,(%esp)
  8003d4:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d7:	83 eb 01             	sub    $0x1,%ebx
  8003da:	85 db                	test   %ebx,%ebx
  8003dc:	7f ef                	jg     8003cd <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003e2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003f4:	00 
  8003f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f8:	89 14 24             	mov    %edx,(%esp)
  8003fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800402:	e8 49 2f 00 00       	call   803350 <__umoddi3>
  800407:	89 74 24 04          	mov    %esi,0x4(%esp)
  80040b:	0f be 80 73 35 80 00 	movsbl 0x803573(%eax),%eax
  800412:	89 04 24             	mov    %eax,(%esp)
  800415:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800418:	83 c4 4c             	add    $0x4c,%esp
  80041b:	5b                   	pop    %ebx
  80041c:	5e                   	pop    %esi
  80041d:	5f                   	pop    %edi
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800423:	83 fa 01             	cmp    $0x1,%edx
  800426:	7e 0e                	jle    800436 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800428:	8b 10                	mov    (%eax),%edx
  80042a:	8d 4a 08             	lea    0x8(%edx),%ecx
  80042d:	89 08                	mov    %ecx,(%eax)
  80042f:	8b 02                	mov    (%edx),%eax
  800431:	8b 52 04             	mov    0x4(%edx),%edx
  800434:	eb 22                	jmp    800458 <getuint+0x38>
	else if (lflag)
  800436:	85 d2                	test   %edx,%edx
  800438:	74 10                	je     80044a <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80043a:	8b 10                	mov    (%eax),%edx
  80043c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80043f:	89 08                	mov    %ecx,(%eax)
  800441:	8b 02                	mov    (%edx),%eax
  800443:	ba 00 00 00 00       	mov    $0x0,%edx
  800448:	eb 0e                	jmp    800458 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80044a:	8b 10                	mov    (%eax),%edx
  80044c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80044f:	89 08                	mov    %ecx,(%eax)
  800451:	8b 02                	mov    (%edx),%eax
  800453:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800458:	5d                   	pop    %ebp
  800459:	c3                   	ret    

0080045a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800460:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800464:	8b 10                	mov    (%eax),%edx
  800466:	3b 50 04             	cmp    0x4(%eax),%edx
  800469:	73 0a                	jae    800475 <sprintputch+0x1b>
		*b->buf++ = ch;
  80046b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80046e:	88 0a                	mov    %cl,(%edx)
  800470:	83 c2 01             	add    $0x1,%edx
  800473:	89 10                	mov    %edx,(%eax)
}
  800475:	5d                   	pop    %ebp
  800476:	c3                   	ret    

00800477 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	57                   	push   %edi
  80047b:	56                   	push   %esi
  80047c:	53                   	push   %ebx
  80047d:	83 ec 4c             	sub    $0x4c,%esp
  800480:	8b 7d 08             	mov    0x8(%ebp),%edi
  800483:	8b 75 0c             	mov    0xc(%ebp),%esi
  800486:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800489:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800490:	eb 11                	jmp    8004a3 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800492:	85 c0                	test   %eax,%eax
  800494:	0f 84 b6 03 00 00    	je     800850 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80049a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80049e:	89 04 24             	mov    %eax,(%esp)
  8004a1:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a3:	0f b6 03             	movzbl (%ebx),%eax
  8004a6:	83 c3 01             	add    $0x1,%ebx
  8004a9:	83 f8 25             	cmp    $0x25,%eax
  8004ac:	75 e4                	jne    800492 <vprintfmt+0x1b>
  8004ae:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8004b2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004b9:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8004c0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004cc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004cf:	eb 06                	jmp    8004d7 <vprintfmt+0x60>
  8004d1:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8004d5:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	0f b6 0b             	movzbl (%ebx),%ecx
  8004da:	0f b6 c1             	movzbl %cl,%eax
  8004dd:	8d 53 01             	lea    0x1(%ebx),%edx
  8004e0:	83 e9 23             	sub    $0x23,%ecx
  8004e3:	80 f9 55             	cmp    $0x55,%cl
  8004e6:	0f 87 47 03 00 00    	ja     800833 <vprintfmt+0x3bc>
  8004ec:	0f b6 c9             	movzbl %cl,%ecx
  8004ef:	ff 24 8d c0 36 80 00 	jmp    *0x8036c0(,%ecx,4)
  8004f6:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8004fa:	eb d9                	jmp    8004d5 <vprintfmt+0x5e>
  8004fc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800503:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800508:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80050b:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80050f:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800512:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800515:	83 fb 09             	cmp    $0x9,%ebx
  800518:	77 30                	ja     80054a <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80051a:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80051d:	eb e9                	jmp    800508 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8d 48 04             	lea    0x4(%eax),%ecx
  800525:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  80052d:	eb 1e                	jmp    80054d <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80052f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800533:	b8 00 00 00 00       	mov    $0x0,%eax
  800538:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  80053c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053f:	eb 94                	jmp    8004d5 <vprintfmt+0x5e>
  800541:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800548:	eb 8b                	jmp    8004d5 <vprintfmt+0x5e>
  80054a:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  80054d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800551:	79 82                	jns    8004d5 <vprintfmt+0x5e>
  800553:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800559:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80055c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80055f:	e9 71 ff ff ff       	jmp    8004d5 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800564:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800568:	e9 68 ff ff ff       	jmp    8004d5 <vprintfmt+0x5e>
  80056d:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8d 50 04             	lea    0x4(%eax),%edx
  800576:	89 55 14             	mov    %edx,0x14(%ebp)
  800579:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	ff d7                	call   *%edi
  800584:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800587:	e9 17 ff ff ff       	jmp    8004a3 <vprintfmt+0x2c>
  80058c:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8d 50 04             	lea    0x4(%eax),%edx
  800595:	89 55 14             	mov    %edx,0x14(%ebp)
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	89 c2                	mov    %eax,%edx
  80059c:	c1 fa 1f             	sar    $0x1f,%edx
  80059f:	31 d0                	xor    %edx,%eax
  8005a1:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005a3:	83 f8 11             	cmp    $0x11,%eax
  8005a6:	7f 0b                	jg     8005b3 <vprintfmt+0x13c>
  8005a8:	8b 14 85 20 38 80 00 	mov    0x803820(,%eax,4),%edx
  8005af:	85 d2                	test   %edx,%edx
  8005b1:	75 20                	jne    8005d3 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8005b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005b7:	c7 44 24 08 84 35 80 	movl   $0x803584,0x8(%esp)
  8005be:	00 
  8005bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005c3:	89 3c 24             	mov    %edi,(%esp)
  8005c6:	e8 0d 03 00 00       	call   8008d8 <printfmt>
  8005cb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ce:	e9 d0 fe ff ff       	jmp    8004a3 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005d7:	c7 44 24 08 95 39 80 	movl   $0x803995,0x8(%esp)
  8005de:	00 
  8005df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005e3:	89 3c 24             	mov    %edi,(%esp)
  8005e6:	e8 ed 02 00 00       	call   8008d8 <printfmt>
  8005eb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005ee:	e9 b0 fe ff ff       	jmp    8004a3 <vprintfmt+0x2c>
  8005f3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005f6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8005f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 50 04             	lea    0x4(%eax),%edx
  800605:	89 55 14             	mov    %edx,0x14(%ebp)
  800608:	8b 18                	mov    (%eax),%ebx
  80060a:	85 db                	test   %ebx,%ebx
  80060c:	b8 8d 35 80 00       	mov    $0x80358d,%eax
  800611:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800614:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800618:	7e 76                	jle    800690 <vprintfmt+0x219>
  80061a:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80061e:	74 7a                	je     80069a <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800620:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800624:	89 1c 24             	mov    %ebx,(%esp)
  800627:	e8 ec 02 00 00       	call   800918 <strnlen>
  80062c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80062f:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800631:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800635:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800638:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80063b:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80063d:	eb 0f                	jmp    80064e <vprintfmt+0x1d7>
					putch(padc, putdat);
  80063f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800643:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800646:	89 04 24             	mov    %eax,(%esp)
  800649:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80064b:	83 eb 01             	sub    $0x1,%ebx
  80064e:	85 db                	test   %ebx,%ebx
  800650:	7f ed                	jg     80063f <vprintfmt+0x1c8>
  800652:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800655:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800658:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80065b:	89 f7                	mov    %esi,%edi
  80065d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800660:	eb 40                	jmp    8006a2 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800662:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800666:	74 18                	je     800680 <vprintfmt+0x209>
  800668:	8d 50 e0             	lea    -0x20(%eax),%edx
  80066b:	83 fa 5e             	cmp    $0x5e,%edx
  80066e:	76 10                	jbe    800680 <vprintfmt+0x209>
					putch('?', putdat);
  800670:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800674:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80067b:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80067e:	eb 0a                	jmp    80068a <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800680:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800684:	89 04 24             	mov    %eax,(%esp)
  800687:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80068e:	eb 12                	jmp    8006a2 <vprintfmt+0x22b>
  800690:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800693:	89 f7                	mov    %esi,%edi
  800695:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800698:	eb 08                	jmp    8006a2 <vprintfmt+0x22b>
  80069a:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80069d:	89 f7                	mov    %esi,%edi
  80069f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006a2:	0f be 03             	movsbl (%ebx),%eax
  8006a5:	83 c3 01             	add    $0x1,%ebx
  8006a8:	85 c0                	test   %eax,%eax
  8006aa:	74 25                	je     8006d1 <vprintfmt+0x25a>
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	78 b2                	js     800662 <vprintfmt+0x1eb>
  8006b0:	83 ee 01             	sub    $0x1,%esi
  8006b3:	79 ad                	jns    800662 <vprintfmt+0x1eb>
  8006b5:	89 fe                	mov    %edi,%esi
  8006b7:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8006bd:	eb 1a                	jmp    8006d9 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006ca:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006cc:	83 eb 01             	sub    $0x1,%ebx
  8006cf:	eb 08                	jmp    8006d9 <vprintfmt+0x262>
  8006d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8006d4:	89 fe                	mov    %edi,%esi
  8006d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006d9:	85 db                	test   %ebx,%ebx
  8006db:	7f e2                	jg     8006bf <vprintfmt+0x248>
  8006dd:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8006e0:	e9 be fd ff ff       	jmp    8004a3 <vprintfmt+0x2c>
  8006e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006e8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006eb:	83 f9 01             	cmp    $0x1,%ecx
  8006ee:	7e 16                	jle    800706 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f9:	8b 10                	mov    (%eax),%edx
  8006fb:	8b 48 04             	mov    0x4(%eax),%ecx
  8006fe:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800701:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800704:	eb 32                	jmp    800738 <vprintfmt+0x2c1>
	else if (lflag)
  800706:	85 c9                	test   %ecx,%ecx
  800708:	74 18                	je     800722 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	89 55 14             	mov    %edx,0x14(%ebp)
  800713:	8b 00                	mov    (%eax),%eax
  800715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800718:	89 c1                	mov    %eax,%ecx
  80071a:	c1 f9 1f             	sar    $0x1f,%ecx
  80071d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800720:	eb 16                	jmp    800738 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8d 50 04             	lea    0x4(%eax),%edx
  800728:	89 55 14             	mov    %edx,0x14(%ebp)
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 c2                	mov    %eax,%edx
  800732:	c1 fa 1f             	sar    $0x1f,%edx
  800735:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800738:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80073b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80073e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800743:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800747:	0f 89 a7 00 00 00    	jns    8007f4 <vprintfmt+0x37d>
				putch('-', putdat);
  80074d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800751:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800758:	ff d7                	call   *%edi
				num = -(long long) num;
  80075a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80075d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800760:	f7 d9                	neg    %ecx
  800762:	83 d3 00             	adc    $0x0,%ebx
  800765:	f7 db                	neg    %ebx
  800767:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076c:	e9 83 00 00 00       	jmp    8007f4 <vprintfmt+0x37d>
  800771:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800774:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800777:	89 ca                	mov    %ecx,%edx
  800779:	8d 45 14             	lea    0x14(%ebp),%eax
  80077c:	e8 9f fc ff ff       	call   800420 <getuint>
  800781:	89 c1                	mov    %eax,%ecx
  800783:	89 d3                	mov    %edx,%ebx
  800785:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80078a:	eb 68                	jmp    8007f4 <vprintfmt+0x37d>
  80078c:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80078f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800792:	89 ca                	mov    %ecx,%edx
  800794:	8d 45 14             	lea    0x14(%ebp),%eax
  800797:	e8 84 fc ff ff       	call   800420 <getuint>
  80079c:	89 c1                	mov    %eax,%ecx
  80079e:	89 d3                	mov    %edx,%ebx
  8007a0:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8007a5:	eb 4d                	jmp    8007f4 <vprintfmt+0x37d>
  8007a7:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8007aa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ae:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007b5:	ff d7                	call   *%edi
			putch('x', putdat);
  8007b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007bb:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007c2:	ff d7                	call   *%edi
			num = (unsigned long long)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8007cd:	8b 08                	mov    (%eax),%ecx
  8007cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007d4:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8007d9:	eb 19                	jmp    8007f4 <vprintfmt+0x37d>
  8007db:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007de:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e1:	89 ca                	mov    %ecx,%edx
  8007e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e6:	e8 35 fc ff ff       	call   800420 <getuint>
  8007eb:	89 c1                	mov    %eax,%ecx
  8007ed:	89 d3                	mov    %edx,%ebx
  8007ef:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f4:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8007f8:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007ff:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800803:	89 44 24 08          	mov    %eax,0x8(%esp)
  800807:	89 0c 24             	mov    %ecx,(%esp)
  80080a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80080e:	89 f2                	mov    %esi,%edx
  800810:	89 f8                	mov    %edi,%eax
  800812:	e8 21 fb ff ff       	call   800338 <printnum>
  800817:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80081a:	e9 84 fc ff ff       	jmp    8004a3 <vprintfmt+0x2c>
  80081f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800822:	89 74 24 04          	mov    %esi,0x4(%esp)
  800826:	89 04 24             	mov    %eax,(%esp)
  800829:	ff d7                	call   *%edi
  80082b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80082e:	e9 70 fc ff ff       	jmp    8004a3 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800833:	89 74 24 04          	mov    %esi,0x4(%esp)
  800837:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80083e:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800840:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800843:	80 38 25             	cmpb   $0x25,(%eax)
  800846:	0f 84 57 fc ff ff    	je     8004a3 <vprintfmt+0x2c>
  80084c:	89 c3                	mov    %eax,%ebx
  80084e:	eb f0                	jmp    800840 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800850:	83 c4 4c             	add    $0x4c,%esp
  800853:	5b                   	pop    %ebx
  800854:	5e                   	pop    %esi
  800855:	5f                   	pop    %edi
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 28             	sub    $0x28,%esp
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800864:	85 c0                	test   %eax,%eax
  800866:	74 04                	je     80086c <vsnprintf+0x14>
  800868:	85 d2                	test   %edx,%edx
  80086a:	7f 07                	jg     800873 <vsnprintf+0x1b>
  80086c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800871:	eb 3b                	jmp    8008ae <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800873:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800876:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  80087a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80088b:	8b 45 10             	mov    0x10(%ebp),%eax
  80088e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800892:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800895:	89 44 24 04          	mov    %eax,0x4(%esp)
  800899:	c7 04 24 5a 04 80 00 	movl   $0x80045a,(%esp)
  8008a0:	e8 d2 fb ff ff       	call   800477 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008b6:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 04 24             	mov    %eax,(%esp)
  8008d1:	e8 82 ff ff ff       	call   800858 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    

008008d8 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8008de:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8008e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	89 04 24             	mov    %eax,(%esp)
  8008f9:	e8 79 fb ff ff       	call   800477 <vprintfmt>
	va_end(ap);
}
  8008fe:	c9                   	leave  
  8008ff:	c3                   	ret    

00800900 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80090b:	eb 03                	jmp    800910 <strlen+0x10>
		n++;
  80090d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800910:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800914:	75 f7                	jne    80090d <strlen+0xd>
		n++;
	return n;
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	53                   	push   %ebx
  80091c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80091f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800922:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800927:	eb 03                	jmp    80092c <strnlen+0x14>
		n++;
  800929:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092c:	39 c1                	cmp    %eax,%ecx
  80092e:	74 06                	je     800936 <strnlen+0x1e>
  800930:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800934:	75 f3                	jne    800929 <strnlen+0x11>
		n++;
	return n;
}
  800936:	5b                   	pop    %ebx
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800948:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80094f:	83 c2 01             	add    $0x1,%edx
  800952:	84 c9                	test   %cl,%cl
  800954:	75 f2                	jne    800948 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800956:	5b                   	pop    %ebx
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	53                   	push   %ebx
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800963:	89 1c 24             	mov    %ebx,(%esp)
  800966:	e8 95 ff ff ff       	call   800900 <strlen>
	strcpy(dst + len, src);
  80096b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800972:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800975:	89 04 24             	mov    %eax,(%esp)
  800978:	e8 bc ff ff ff       	call   800939 <strcpy>
	return dst;
}
  80097d:	89 d8                	mov    %ebx,%eax
  80097f:	83 c4 08             	add    $0x8,%esp
  800982:	5b                   	pop    %ebx
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	56                   	push   %esi
  800989:	53                   	push   %ebx
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800990:	8b 75 10             	mov    0x10(%ebp),%esi
  800993:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800998:	eb 0f                	jmp    8009a9 <strncpy+0x24>
		*dst++ = *src;
  80099a:	0f b6 19             	movzbl (%ecx),%ebx
  80099d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a0:	80 39 01             	cmpb   $0x1,(%ecx)
  8009a3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	39 f2                	cmp    %esi,%edx
  8009ab:	72 ed                	jb     80099a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009ad:	5b                   	pop    %ebx
  8009ae:	5e                   	pop    %esi
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009bf:	89 f0                	mov    %esi,%eax
  8009c1:	85 d2                	test   %edx,%edx
  8009c3:	75 0a                	jne    8009cf <strlcpy+0x1e>
  8009c5:	eb 17                	jmp    8009de <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009c7:	88 18                	mov    %bl,(%eax)
  8009c9:	83 c0 01             	add    $0x1,%eax
  8009cc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009cf:	83 ea 01             	sub    $0x1,%edx
  8009d2:	74 07                	je     8009db <strlcpy+0x2a>
  8009d4:	0f b6 19             	movzbl (%ecx),%ebx
  8009d7:	84 db                	test   %bl,%bl
  8009d9:	75 ec                	jne    8009c7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  8009db:	c6 00 00             	movb   $0x0,(%eax)
  8009de:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5e                   	pop    %esi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ed:	eb 06                	jmp    8009f5 <strcmp+0x11>
		p++, q++;
  8009ef:	83 c1 01             	add    $0x1,%ecx
  8009f2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009f5:	0f b6 01             	movzbl (%ecx),%eax
  8009f8:	84 c0                	test   %al,%al
  8009fa:	74 04                	je     800a00 <strcmp+0x1c>
  8009fc:	3a 02                	cmp    (%edx),%al
  8009fe:	74 ef                	je     8009ef <strcmp+0xb>
  800a00:	0f b6 c0             	movzbl %al,%eax
  800a03:	0f b6 12             	movzbl (%edx),%edx
  800a06:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	53                   	push   %ebx
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a14:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800a17:	eb 09                	jmp    800a22 <strncmp+0x18>
		n--, p++, q++;
  800a19:	83 ea 01             	sub    $0x1,%edx
  800a1c:	83 c0 01             	add    $0x1,%eax
  800a1f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a22:	85 d2                	test   %edx,%edx
  800a24:	75 07                	jne    800a2d <strncmp+0x23>
  800a26:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2b:	eb 13                	jmp    800a40 <strncmp+0x36>
  800a2d:	0f b6 18             	movzbl (%eax),%ebx
  800a30:	84 db                	test   %bl,%bl
  800a32:	74 04                	je     800a38 <strncmp+0x2e>
  800a34:	3a 19                	cmp    (%ecx),%bl
  800a36:	74 e1                	je     800a19 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a38:	0f b6 00             	movzbl (%eax),%eax
  800a3b:	0f b6 11             	movzbl (%ecx),%edx
  800a3e:	29 d0                	sub    %edx,%eax
}
  800a40:	5b                   	pop    %ebx
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4d:	eb 07                	jmp    800a56 <strchr+0x13>
		if (*s == c)
  800a4f:	38 ca                	cmp    %cl,%dl
  800a51:	74 0f                	je     800a62 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a53:	83 c0 01             	add    $0x1,%eax
  800a56:	0f b6 10             	movzbl (%eax),%edx
  800a59:	84 d2                	test   %dl,%dl
  800a5b:	75 f2                	jne    800a4f <strchr+0xc>
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6e:	eb 07                	jmp    800a77 <strfind+0x13>
		if (*s == c)
  800a70:	38 ca                	cmp    %cl,%dl
  800a72:	74 0a                	je     800a7e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a74:	83 c0 01             	add    $0x1,%eax
  800a77:	0f b6 10             	movzbl (%eax),%edx
  800a7a:	84 d2                	test   %dl,%dl
  800a7c:	75 f2                	jne    800a70 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	89 1c 24             	mov    %ebx,(%esp)
  800a89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a91:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a97:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a9a:	85 c9                	test   %ecx,%ecx
  800a9c:	74 30                	je     800ace <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aa4:	75 25                	jne    800acb <memset+0x4b>
  800aa6:	f6 c1 03             	test   $0x3,%cl
  800aa9:	75 20                	jne    800acb <memset+0x4b>
		c &= 0xFF;
  800aab:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aae:	89 d3                	mov    %edx,%ebx
  800ab0:	c1 e3 08             	shl    $0x8,%ebx
  800ab3:	89 d6                	mov    %edx,%esi
  800ab5:	c1 e6 18             	shl    $0x18,%esi
  800ab8:	89 d0                	mov    %edx,%eax
  800aba:	c1 e0 10             	shl    $0x10,%eax
  800abd:	09 f0                	or     %esi,%eax
  800abf:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800ac1:	09 d8                	or     %ebx,%eax
  800ac3:	c1 e9 02             	shr    $0x2,%ecx
  800ac6:	fc                   	cld    
  800ac7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac9:	eb 03                	jmp    800ace <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800acb:	fc                   	cld    
  800acc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ace:	89 f8                	mov    %edi,%eax
  800ad0:	8b 1c 24             	mov    (%esp),%ebx
  800ad3:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ad7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800adb:	89 ec                	mov    %ebp,%esp
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	89 34 24             	mov    %esi,(%esp)
  800ae8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800af2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800af5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800af7:	39 c6                	cmp    %eax,%esi
  800af9:	73 35                	jae    800b30 <memmove+0x51>
  800afb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800afe:	39 d0                	cmp    %edx,%eax
  800b00:	73 2e                	jae    800b30 <memmove+0x51>
		s += n;
		d += n;
  800b02:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b04:	f6 c2 03             	test   $0x3,%dl
  800b07:	75 1b                	jne    800b24 <memmove+0x45>
  800b09:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0f:	75 13                	jne    800b24 <memmove+0x45>
  800b11:	f6 c1 03             	test   $0x3,%cl
  800b14:	75 0e                	jne    800b24 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b16:	83 ef 04             	sub    $0x4,%edi
  800b19:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b1c:	c1 e9 02             	shr    $0x2,%ecx
  800b1f:	fd                   	std    
  800b20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b22:	eb 09                	jmp    800b2d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b24:	83 ef 01             	sub    $0x1,%edi
  800b27:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b2a:	fd                   	std    
  800b2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b2d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b2e:	eb 20                	jmp    800b50 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b30:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b36:	75 15                	jne    800b4d <memmove+0x6e>
  800b38:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b3e:	75 0d                	jne    800b4d <memmove+0x6e>
  800b40:	f6 c1 03             	test   $0x3,%cl
  800b43:	75 08                	jne    800b4d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b45:	c1 e9 02             	shr    $0x2,%ecx
  800b48:	fc                   	cld    
  800b49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4b:	eb 03                	jmp    800b50 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b4d:	fc                   	cld    
  800b4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b50:	8b 34 24             	mov    (%esp),%esi
  800b53:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b57:	89 ec                	mov    %ebp,%esp
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b61:	8b 45 10             	mov    0x10(%ebp),%eax
  800b64:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	89 04 24             	mov    %eax,(%esp)
  800b75:	e8 65 ff ff ff       	call   800adf <memmove>
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	57                   	push   %edi
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b8b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b90:	eb 1c                	jmp    800bae <memcmp+0x32>
		if (*s1 != *s2)
  800b92:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800b96:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800b9a:	83 c2 01             	add    $0x1,%edx
  800b9d:	83 e9 01             	sub    $0x1,%ecx
  800ba0:	38 d8                	cmp    %bl,%al
  800ba2:	74 0a                	je     800bae <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800ba4:	0f b6 c0             	movzbl %al,%eax
  800ba7:	0f b6 db             	movzbl %bl,%ebx
  800baa:	29 d8                	sub    %ebx,%eax
  800bac:	eb 09                	jmp    800bb7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bae:	85 c9                	test   %ecx,%ecx
  800bb0:	75 e0                	jne    800b92 <memcmp+0x16>
  800bb2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bc5:	89 c2                	mov    %eax,%edx
  800bc7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bca:	eb 07                	jmp    800bd3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bcc:	38 08                	cmp    %cl,(%eax)
  800bce:	74 07                	je     800bd7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bd0:	83 c0 01             	add    $0x1,%eax
  800bd3:	39 d0                	cmp    %edx,%eax
  800bd5:	72 f5                	jb     800bcc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	57                   	push   %edi
  800bdd:	56                   	push   %esi
  800bde:	53                   	push   %ebx
  800bdf:	83 ec 04             	sub    $0x4,%esp
  800be2:	8b 55 08             	mov    0x8(%ebp),%edx
  800be5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be8:	eb 03                	jmp    800bed <strtol+0x14>
		s++;
  800bea:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bed:	0f b6 02             	movzbl (%edx),%eax
  800bf0:	3c 20                	cmp    $0x20,%al
  800bf2:	74 f6                	je     800bea <strtol+0x11>
  800bf4:	3c 09                	cmp    $0x9,%al
  800bf6:	74 f2                	je     800bea <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bf8:	3c 2b                	cmp    $0x2b,%al
  800bfa:	75 0c                	jne    800c08 <strtol+0x2f>
		s++;
  800bfc:	8d 52 01             	lea    0x1(%edx),%edx
  800bff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c06:	eb 15                	jmp    800c1d <strtol+0x44>
	else if (*s == '-')
  800c08:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c0f:	3c 2d                	cmp    $0x2d,%al
  800c11:	75 0a                	jne    800c1d <strtol+0x44>
		s++, neg = 1;
  800c13:	8d 52 01             	lea    0x1(%edx),%edx
  800c16:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1d:	85 db                	test   %ebx,%ebx
  800c1f:	0f 94 c0             	sete   %al
  800c22:	74 05                	je     800c29 <strtol+0x50>
  800c24:	83 fb 10             	cmp    $0x10,%ebx
  800c27:	75 15                	jne    800c3e <strtol+0x65>
  800c29:	80 3a 30             	cmpb   $0x30,(%edx)
  800c2c:	75 10                	jne    800c3e <strtol+0x65>
  800c2e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c32:	75 0a                	jne    800c3e <strtol+0x65>
		s += 2, base = 16;
  800c34:	83 c2 02             	add    $0x2,%edx
  800c37:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c3c:	eb 13                	jmp    800c51 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c3e:	84 c0                	test   %al,%al
  800c40:	74 0f                	je     800c51 <strtol+0x78>
  800c42:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800c47:	80 3a 30             	cmpb   $0x30,(%edx)
  800c4a:	75 05                	jne    800c51 <strtol+0x78>
		s++, base = 8;
  800c4c:	83 c2 01             	add    $0x1,%edx
  800c4f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c58:	0f b6 0a             	movzbl (%edx),%ecx
  800c5b:	89 cf                	mov    %ecx,%edi
  800c5d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c60:	80 fb 09             	cmp    $0x9,%bl
  800c63:	77 08                	ja     800c6d <strtol+0x94>
			dig = *s - '0';
  800c65:	0f be c9             	movsbl %cl,%ecx
  800c68:	83 e9 30             	sub    $0x30,%ecx
  800c6b:	eb 1e                	jmp    800c8b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800c6d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c70:	80 fb 19             	cmp    $0x19,%bl
  800c73:	77 08                	ja     800c7d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800c75:	0f be c9             	movsbl %cl,%ecx
  800c78:	83 e9 57             	sub    $0x57,%ecx
  800c7b:	eb 0e                	jmp    800c8b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800c7d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c80:	80 fb 19             	cmp    $0x19,%bl
  800c83:	77 15                	ja     800c9a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c85:	0f be c9             	movsbl %cl,%ecx
  800c88:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c8b:	39 f1                	cmp    %esi,%ecx
  800c8d:	7d 0b                	jge    800c9a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c8f:	83 c2 01             	add    $0x1,%edx
  800c92:	0f af c6             	imul   %esi,%eax
  800c95:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c98:	eb be                	jmp    800c58 <strtol+0x7f>
  800c9a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca0:	74 05                	je     800ca7 <strtol+0xce>
		*endptr = (char *) s;
  800ca2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ca5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ca7:	89 ca                	mov    %ecx,%edx
  800ca9:	f7 da                	neg    %edx
  800cab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800caf:	0f 45 c2             	cmovne %edx,%eax
}
  800cb2:	83 c4 04             	add    $0x4,%esp
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    
	...

00800cbc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 0c             	sub    $0xc,%esp
  800cc2:	89 1c 24             	mov    %ebx,(%esp)
  800cc5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cc9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd7:	89 d1                	mov    %edx,%ecx
  800cd9:	89 d3                	mov    %edx,%ebx
  800cdb:	89 d7                	mov    %edx,%edi
  800cdd:	89 d6                	mov    %edx,%esi
  800cdf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce1:	8b 1c 24             	mov    (%esp),%ebx
  800ce4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ce8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cec:	89 ec                	mov    %ebp,%esp
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d09:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0c:	89 c3                	mov    %eax,%ebx
  800d0e:	89 c7                	mov    %eax,%edi
  800d10:	89 c6                	mov    %eax,%esi
  800d12:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d14:	8b 1c 24             	mov    (%esp),%ebx
  800d17:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d1b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d1f:	89 ec                	mov    %ebp,%esp
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 0c             	sub    $0xc,%esp
  800d29:	89 1c 24             	mov    %ebx,(%esp)
  800d2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d30:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
  800d39:	b8 10 00 00 00       	mov    $0x10,%eax
  800d3e:	89 d1                	mov    %edx,%ecx
  800d40:	89 d3                	mov    %edx,%ebx
  800d42:	89 d7                	mov    %edx,%edi
  800d44:	89 d6                	mov    %edx,%esi
  800d46:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d48:	8b 1c 24             	mov    (%esp),%ebx
  800d4b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d4f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d53:	89 ec                	mov    %ebp,%esp
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 38             	sub    $0x38,%esp
  800d5d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d60:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d63:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d73:	8b 55 08             	mov    0x8(%ebp),%edx
  800d76:	89 df                	mov    %ebx,%edi
  800d78:	89 de                	mov    %ebx,%esi
  800d7a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	7e 28                	jle    800da8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d84:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d8b:	00 
  800d8c:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  800d93:	00 
  800d94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d9b:	00 
  800d9c:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  800da3:	e8 78 f4 ff ff       	call   800220 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800da8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800db1:	89 ec                	mov    %ebp,%esp
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 38             	sub    $0x38,%esp
  800dbb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dbe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dc1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd4:	89 df                	mov    %ebx,%edi
  800dd6:	89 de                	mov    %ebx,%esi
  800dd8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7e 28                	jle    800e06 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dde:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800de9:	00 
  800dea:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  800df1:	00 
  800df2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df9:	00 
  800dfa:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  800e01:	e8 1a f4 ff ff       	call   800220 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800e06:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e09:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e0c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e0f:	89 ec                	mov    %ebp,%esp
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 38             	sub    $0x38,%esp
  800e19:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e1f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e27:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	89 cb                	mov    %ecx,%ebx
  800e31:	89 cf                	mov    %ecx,%edi
  800e33:	89 ce                	mov    %ecx,%esi
  800e35:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e37:	85 c0                	test   %eax,%eax
  800e39:	7e 28                	jle    800e63 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e46:	00 
  800e47:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  800e4e:	00 
  800e4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e56:	00 
  800e57:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  800e5e:	e8 bd f3 ff ff       	call   800220 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e63:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e66:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e6c:	89 ec                	mov    %ebp,%esp
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	89 1c 24             	mov    %ebx,(%esp)
  800e79:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e7d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e81:	be 00 00 00 00       	mov    $0x0,%esi
  800e86:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e99:	8b 1c 24             	mov    (%esp),%ebx
  800e9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ea0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ea4:	89 ec                	mov    %ebp,%esp
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    

00800ea8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	83 ec 38             	sub    $0x38,%esp
  800eae:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eb1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec7:	89 df                	mov    %ebx,%edi
  800ec9:	89 de                	mov    %ebx,%esi
  800ecb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	7e 28                	jle    800ef9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800edc:	00 
  800edd:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  800ee4:	00 
  800ee5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eec:	00 
  800eed:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  800ef4:	e8 27 f3 ff ff       	call   800220 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800efc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f02:	89 ec                	mov    %ebp,%esp
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 38             	sub    $0x38,%esp
  800f0c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f12:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1a:	b8 09 00 00 00       	mov    $0x9,%eax
  800f1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f22:	8b 55 08             	mov    0x8(%ebp),%edx
  800f25:	89 df                	mov    %ebx,%edi
  800f27:	89 de                	mov    %ebx,%esi
  800f29:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	7e 28                	jle    800f57 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f33:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f3a:	00 
  800f3b:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  800f42:	00 
  800f43:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4a:	00 
  800f4b:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  800f52:	e8 c9 f2 ff ff       	call   800220 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f57:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f5a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f60:	89 ec                	mov    %ebp,%esp
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 38             	sub    $0x38,%esp
  800f6a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f70:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f78:	b8 08 00 00 00       	mov    $0x8,%eax
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	89 df                	mov    %ebx,%edi
  800f85:	89 de                	mov    %ebx,%esi
  800f87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	7e 28                	jle    800fb5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f91:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f98:	00 
  800f99:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  800fa0:	00 
  800fa1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa8:	00 
  800fa9:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  800fb0:	e8 6b f2 ff ff       	call   800220 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fb5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fbb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fbe:	89 ec                	mov    %ebp,%esp
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 38             	sub    $0x38,%esp
  800fc8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fcb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fce:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd6:	b8 06 00 00 00       	mov    $0x6,%eax
  800fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	89 df                	mov    %ebx,%edi
  800fe3:	89 de                	mov    %ebx,%esi
  800fe5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	7e 28                	jle    801013 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800feb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fef:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ff6:	00 
  800ff7:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  800ffe:	00 
  800fff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801006:	00 
  801007:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  80100e:	e8 0d f2 ff ff       	call   800220 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801013:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801016:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801019:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101c:	89 ec                	mov    %ebp,%esp
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 38             	sub    $0x38,%esp
  801026:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801029:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102f:	b8 05 00 00 00       	mov    $0x5,%eax
  801034:	8b 75 18             	mov    0x18(%ebp),%esi
  801037:	8b 7d 14             	mov    0x14(%ebp),%edi
  80103a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801045:	85 c0                	test   %eax,%eax
  801047:	7e 28                	jle    801071 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801049:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801054:	00 
  801055:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  80105c:	00 
  80105d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801064:	00 
  801065:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  80106c:	e8 af f1 ff ff       	call   800220 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801071:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801074:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801077:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80107a:	89 ec                	mov    %ebp,%esp
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 38             	sub    $0x38,%esp
  801084:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801087:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80108a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108d:	be 00 00 00 00       	mov    $0x0,%esi
  801092:	b8 04 00 00 00       	mov    $0x4,%eax
  801097:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80109a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109d:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a0:	89 f7                	mov    %esi,%edi
  8010a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	7e 28                	jle    8010d0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ac:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010b3:	00 
  8010b4:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  8010bb:	00 
  8010bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c3:	00 
  8010c4:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  8010cb:	e8 50 f1 ff ff       	call   800220 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d9:	89 ec                	mov    %ebp,%esp
  8010db:	5d                   	pop    %ebp
  8010dc:	c3                   	ret    

008010dd <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	83 ec 0c             	sub    $0xc,%esp
  8010e3:	89 1c 24             	mov    %ebx,(%esp)
  8010e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010ea:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010f8:	89 d1                	mov    %edx,%ecx
  8010fa:	89 d3                	mov    %edx,%ebx
  8010fc:	89 d7                	mov    %edx,%edi
  8010fe:	89 d6                	mov    %edx,%esi
  801100:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801102:	8b 1c 24             	mov    (%esp),%ebx
  801105:	8b 74 24 04          	mov    0x4(%esp),%esi
  801109:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80110d:	89 ec                	mov    %ebp,%esp
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    

00801111 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 0c             	sub    $0xc,%esp
  801117:	89 1c 24             	mov    %ebx,(%esp)
  80111a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80111e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801122:	ba 00 00 00 00       	mov    $0x0,%edx
  801127:	b8 02 00 00 00       	mov    $0x2,%eax
  80112c:	89 d1                	mov    %edx,%ecx
  80112e:	89 d3                	mov    %edx,%ebx
  801130:	89 d7                	mov    %edx,%edi
  801132:	89 d6                	mov    %edx,%esi
  801134:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801136:	8b 1c 24             	mov    (%esp),%ebx
  801139:	8b 74 24 04          	mov    0x4(%esp),%esi
  80113d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801141:	89 ec                	mov    %ebp,%esp
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 38             	sub    $0x38,%esp
  80114b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80114e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801151:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801154:	b9 00 00 00 00       	mov    $0x0,%ecx
  801159:	b8 03 00 00 00       	mov    $0x3,%eax
  80115e:	8b 55 08             	mov    0x8(%ebp),%edx
  801161:	89 cb                	mov    %ecx,%ebx
  801163:	89 cf                	mov    %ecx,%edi
  801165:	89 ce                	mov    %ecx,%esi
  801167:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801169:	85 c0                	test   %eax,%eax
  80116b:	7e 28                	jle    801195 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80116d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801171:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801178:	00 
  801179:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  801180:	00 
  801181:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801188:	00 
  801189:	c7 04 24 a4 38 80 00 	movl   $0x8038a4,(%esp)
  801190:	e8 8b f0 ff ff       	call   800220 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801195:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801198:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80119b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80119e:	89 ec                	mov    %ebp,%esp
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    
	...

008011a4 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8011aa:	c7 44 24 08 b2 38 80 	movl   $0x8038b2,0x8(%esp)
  8011b1:	00 
  8011b2:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  8011b9:	00 
  8011ba:	c7 04 24 c8 38 80 00 	movl   $0x8038c8,(%esp)
  8011c1:	e8 5a f0 ff ff       	call   800220 <_panic>

008011c6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  8011cf:	c7 04 24 34 14 80 00 	movl   $0x801434,(%esp)
  8011d6:	e8 95 0a 00 00       	call   801c70 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011db:	ba 07 00 00 00       	mov    $0x7,%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	cd 30                	int    $0x30
  8011e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	79 20                	jns    80120b <fork+0x45>
		panic("sys_exofork: %e", envid);
  8011eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ef:	c7 44 24 08 d3 38 80 	movl   $0x8038d3,0x8(%esp)
  8011f6:	00 
  8011f7:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8011fe:	00 
  8011ff:	c7 04 24 c8 38 80 00 	movl   $0x8038c8,(%esp)
  801206:	e8 15 f0 ff ff       	call   800220 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  80120b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801212:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801217:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80121b:	75 21                	jne    80123e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80121d:	e8 ef fe ff ff       	call   801111 <sys_getenvid>
  801222:	25 ff 03 00 00       	and    $0x3ff,%eax
  801227:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80122a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80122f:	a3 08 50 80 00       	mov    %eax,0x805008
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801239:	e9 e5 01 00 00       	jmp    801423 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80123e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801241:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801248:	a8 01                	test   $0x1,%al
  80124a:	0f 84 4c 01 00 00    	je     80139c <fork+0x1d6>
  801250:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801256:	0f 84 cf 01 00 00    	je     80142b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  80125c:	c1 e2 16             	shl    $0x16,%edx
  80125f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801262:	89 d3                	mov    %edx,%ebx
  801264:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80126b:	00 
  80126c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801270:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801273:	89 04 24             	mov    %eax,(%esp)
  801276:	e8 03 fe ff ff       	call   80107e <sys_page_alloc>
			if(ret < 0) return ret;
  80127b:	85 c0                	test   %eax,%eax
  80127d:	0f 88 a0 01 00 00    	js     801423 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801283:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801287:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80128a:	89 14 24             	mov    %edx,(%esp)
  80128d:	e8 30 fd ff ff       	call   800fc2 <sys_page_unmap>
			if(ret < 0) return ret;
  801292:	85 c0                	test   %eax,%eax
  801294:	0f 88 89 01 00 00    	js     801423 <fork+0x25d>
  80129a:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  80129f:	89 de                	mov    %ebx,%esi
  8012a1:	c1 e6 0c             	shl    $0xc,%esi
  8012a4:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  8012a7:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  8012ad:	0f 84 da 00 00 00    	je     80138d <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8012b3:	c1 ee 0c             	shr    $0xc,%esi
  8012b6:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8012b9:	a8 01                	test   $0x1,%al
  8012bb:	0f 84 cc 00 00 00    	je     80138d <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  8012c1:	89 f0                	mov    %esi,%eax
  8012c3:	c1 e0 0c             	shl    $0xc,%eax
  8012c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  8012c9:	e8 43 fe ff ff       	call   801111 <sys_getenvid>
  8012ce:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  8012d1:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8012d4:	89 c6                	mov    %eax,%esi
  8012d6:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  8012dc:	25 01 04 00 00       	and    $0x401,%eax
  8012e1:	3d 01 04 00 00       	cmp    $0x401,%eax
  8012e6:	75 3a                	jne    801322 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  8012e8:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  8012ef:	00 
  8012f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012f3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  801302:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801305:	89 14 24             	mov    %edx,(%esp)
  801308:	e8 13 fd ff ff       	call   801020 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  80130d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801310:	89 44 24 04          	mov    %eax,0x4(%esp)
  801314:	c7 04 24 e3 38 80 00 	movl   $0x8038e3,(%esp)
  80131b:	e8 b9 ef ff ff       	call   8002d9 <cprintf>
  801320:	eb 6b                	jmp    80138d <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801322:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801328:	74 14                	je     80133e <fork+0x178>
  80132a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801330:	74 0c                	je     80133e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801332:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801338:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80133e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801341:	89 74 24 10          	mov    %esi,0x10(%esp)
  801345:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801349:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80134c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801350:	89 54 24 04          	mov    %edx,0x4(%esp)
  801354:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801357:	89 14 24             	mov    %edx,(%esp)
  80135a:	e8 c1 fc ff ff       	call   801020 <sys_page_map>
	if(ret<0) return ret;
  80135f:	85 c0                	test   %eax,%eax
  801361:	0f 88 bc 00 00 00    	js     801423 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801367:	89 74 24 10          	mov    %esi,0x10(%esp)
  80136b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801372:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801375:	89 54 24 08          	mov    %edx,0x8(%esp)
  801379:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137d:	89 14 24             	mov    %edx,(%esp)
  801380:	e8 9b fc ff ff       	call   801020 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801385:	85 c0                	test   %eax,%eax
  801387:	0f 88 96 00 00 00    	js     801423 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  80138d:	83 c3 01             	add    $0x1,%ebx
  801390:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801396:	0f 85 03 ff ff ff    	jne    80129f <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80139c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  8013a0:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  8013a7:	0f 85 91 fe ff ff    	jne    80123e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  8013ad:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013b4:	00 
  8013b5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013bc:	ee 
  8013bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013c0:	89 04 24             	mov    %eax,(%esp)
  8013c3:	e8 b6 fc ff ff       	call   80107e <sys_page_alloc>
	if(ret < 0) return ret;
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	78 57                	js     801423 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  8013cc:	a1 08 50 80 00       	mov    0x805008,%eax
  8013d1:	8b 40 64             	mov    0x64(%eax),%eax
  8013d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8013db:	89 14 24             	mov    %edx,(%esp)
  8013de:	e8 c5 fa ff ff       	call   800ea8 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 3c                	js     801423 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8013e7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013ee:	00 
  8013ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013f2:	89 04 24             	mov    %eax,(%esp)
  8013f5:	e8 6a fb ff ff       	call   800f64 <sys_env_set_status>
  8013fa:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  8013fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8013ff:	85 d2                	test   %edx,%edx
  801401:	79 20                	jns    801423 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801403:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801407:	c7 44 24 08 fa 38 80 	movl   $0x8038fa,0x8(%esp)
  80140e:	00 
  80140f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801416:	00 
  801417:	c7 04 24 c8 38 80 00 	movl   $0x8038c8,(%esp)
  80141e:	e8 fd ed ff ff       	call   800220 <_panic>

	return envid;
}
  801423:	83 c4 4c             	add    $0x4c,%esp
  801426:	5b                   	pop    %ebx
  801427:	5e                   	pop    %esi
  801428:	5f                   	pop    %edi
  801429:	5d                   	pop    %ebp
  80142a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80142b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80142f:	e9 0a fe ff ff       	jmp    80123e <fork+0x78>

00801434 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	56                   	push   %esi
  801438:	53                   	push   %ebx
  801439:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80143c:	e8 d0 fc ff ff       	call   801111 <sys_getenvid>
  801441:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8b 00                	mov    (%eax),%eax
  801448:	89 c6                	mov    %eax,%esi
  80144a:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  80144d:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801454:	f6 c2 02             	test   $0x2,%dl
  801457:	75 2c                	jne    801485 <pgfault+0x51>
  801459:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801460:	f6 c6 08             	test   $0x8,%dh
  801463:	75 20                	jne    801485 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801465:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801469:	c7 44 24 08 48 39 80 	movl   $0x803948,0x8(%esp)
  801470:	00 
  801471:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801478:	00 
  801479:	c7 04 24 c8 38 80 00 	movl   $0x8038c8,(%esp)
  801480:	e8 9b ed ff ff       	call   800220 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801485:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80148c:	00 
  80148d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801494:	00 
  801495:	89 1c 24             	mov    %ebx,(%esp)
  801498:	e8 e1 fb ff ff       	call   80107e <sys_page_alloc>
  80149d:	85 c0                	test   %eax,%eax
  80149f:	79 20                	jns    8014c1 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  8014a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014a5:	c7 44 24 08 11 39 80 	movl   $0x803911,0x8(%esp)
  8014ac:	00 
  8014ad:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8014b4:	00 
  8014b5:	c7 04 24 c8 38 80 00 	movl   $0x8038c8,(%esp)
  8014bc:	e8 5f ed ff ff       	call   800220 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  8014c1:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  8014c4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014cb:	00 
  8014cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014d0:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8014d7:	e8 03 f6 ff ff       	call   800adf <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8014dc:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014e3:	00 
  8014e4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014ec:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8014f3:	00 
  8014f4:	89 1c 24             	mov    %ebx,(%esp)
  8014f7:	e8 24 fb ff ff       	call   801020 <sys_page_map>
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	79 20                	jns    801520 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801500:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801504:	c7 44 24 08 23 39 80 	movl   $0x803923,0x8(%esp)
  80150b:	00 
  80150c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801513:	00 
  801514:	c7 04 24 c8 38 80 00 	movl   $0x8038c8,(%esp)
  80151b:	e8 00 ed ff ff       	call   800220 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801520:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801527:	00 
  801528:	89 1c 24             	mov    %ebx,(%esp)
  80152b:	e8 92 fa ff ff       	call   800fc2 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801530:	85 c0                	test   %eax,%eax
  801532:	74 20                	je     801554 <pgfault+0x120>
  801534:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801538:	c7 44 24 08 33 39 80 	movl   $0x803933,0x8(%esp)
  80153f:	00 
  801540:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801547:	00 
  801548:	c7 04 24 c8 38 80 00 	movl   $0x8038c8,(%esp)
  80154f:	e8 cc ec ff ff       	call   800220 <_panic>

}
  801554:	83 c4 20             	add    $0x20,%esp
  801557:	5b                   	pop    %ebx
  801558:	5e                   	pop    %esi
  801559:	5d                   	pop    %ebp
  80155a:	c3                   	ret    
	...

0080155c <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	57                   	push   %edi
  801560:	56                   	push   %esi
  801561:	53                   	push   %ebx
  801562:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801568:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80156f:	00 
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	89 04 24             	mov    %eax,(%esp)
  801576:	e8 50 10 00 00       	call   8025cb <open>
  80157b:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801581:	85 c0                	test   %eax,%eax
  801583:	0f 88 f7 05 00 00    	js     801b80 <spawn+0x624>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  801589:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801590:	00 
  801591:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801597:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159b:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8015a1:	89 14 24             	mov    %edx,(%esp)
  8015a4:	e8 d4 0a 00 00       	call   80207d <readn>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8015a9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8015ae:	75 0c                	jne    8015bc <spawn+0x60>
  8015b0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8015b7:	45 4c 46 
  8015ba:	74 3b                	je     8015f7 <spawn+0x9b>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  8015bc:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8015c2:	89 04 24             	mov    %eax,(%esp)
  8015c5:	e8 8c 0b 00 00       	call   802156 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8015ca:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  8015d1:	46 
  8015d2:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  8015d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015dc:	c7 04 24 69 39 80 00 	movl   $0x803969,(%esp)
  8015e3:	e8 f1 ec ff ff       	call   8002d9 <cprintf>
  8015e8:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  8015ef:	ff ff ff 
		return -E_NOT_EXEC;
  8015f2:	e9 89 05 00 00       	jmp    801b80 <spawn+0x624>
  8015f7:	ba 07 00 00 00       	mov    $0x7,%edx
  8015fc:	89 d0                	mov    %edx,%eax
  8015fe:	cd 30                	int    $0x30
  801600:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801606:	85 c0                	test   %eax,%eax
  801608:	0f 88 66 05 00 00    	js     801b74 <spawn+0x618>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80160e:	89 c6                	mov    %eax,%esi
  801610:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801616:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801619:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80161f:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801625:	b9 11 00 00 00       	mov    $0x11,%ecx
  80162a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80162c:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801632:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801638:	bb 00 00 00 00       	mov    $0x0,%ebx
  80163d:	be 00 00 00 00       	mov    $0x0,%esi
  801642:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801645:	eb 0f                	jmp    801656 <spawn+0xfa>

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801647:	89 04 24             	mov    %eax,(%esp)
  80164a:	e8 b1 f2 ff ff       	call   800900 <strlen>
  80164f:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801653:	83 c3 01             	add    $0x1,%ebx
  801656:	8d 14 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edx
  80165d:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801660:	85 c0                	test   %eax,%eax
  801662:	75 e3                	jne    801647 <spawn+0xeb>
  801664:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  80166a:	89 9d 7c fd ff ff    	mov    %ebx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801670:	f7 de                	neg    %esi
  801672:	81 c6 00 10 40 00    	add    $0x401000,%esi
  801678:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80167e:	89 f2                	mov    %esi,%edx
  801680:	83 e2 fc             	and    $0xfffffffc,%edx
  801683:	89 d8                	mov    %ebx,%eax
  801685:	f7 d0                	not    %eax
  801687:	8d 3c 82             	lea    (%edx,%eax,4),%edi

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80168a:	8d 57 f8             	lea    -0x8(%edi),%edx
  80168d:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801693:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801698:	81 fa ff ff 3f 00    	cmp    $0x3fffff,%edx
  80169e:	0f 86 ed 04 00 00    	jbe    801b91 <spawn+0x635>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8016a4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016ab:	00 
  8016ac:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8016b3:	00 
  8016b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016bb:	e8 be f9 ff ff       	call   80107e <sys_page_alloc>
  8016c0:	be 00 00 00 00       	mov    $0x0,%esi
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	79 4c                	jns    801715 <spawn+0x1b9>
  8016c9:	e9 c3 04 00 00       	jmp    801b91 <spawn+0x635>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  8016ce:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8016d4:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8016d9:	89 04 b7             	mov    %eax,(%edi,%esi,4)
		strcpy(string_store, argv[i]);
  8016dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016df:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  8016e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e6:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8016ec:	89 04 24             	mov    %eax,(%esp)
  8016ef:	e8 45 f2 ff ff       	call   800939 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8016f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f7:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  8016fa:	89 04 24             	mov    %eax,(%esp)
  8016fd:	e8 fe f1 ff ff       	call   800900 <strlen>
  801702:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801708:	8d 54 02 01          	lea    0x1(%edx,%eax,1),%edx
  80170c:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801712:	83 c6 01             	add    $0x1,%esi
  801715:	39 de                	cmp    %ebx,%esi
  801717:	7c b5                	jl     8016ce <spawn+0x172>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801719:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80171f:	c7 04 07 00 00 00 00 	movl   $0x0,(%edi,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801726:	81 bd 94 fd ff ff 00 	cmpl   $0x401000,-0x26c(%ebp)
  80172d:	10 40 00 
  801730:	74 24                	je     801756 <spawn+0x1fa>
  801732:	c7 44 24 0c 0c 3a 80 	movl   $0x803a0c,0xc(%esp)
  801739:	00 
  80173a:	c7 44 24 08 83 39 80 	movl   $0x803983,0x8(%esp)
  801741:	00 
  801742:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  801749:	00 
  80174a:	c7 04 24 98 39 80 00 	movl   $0x803998,(%esp)
  801751:	e8 ca ea ff ff       	call   800220 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801756:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80175c:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  80175f:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801765:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  80176b:	89 02                	mov    %eax,(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80176d:	81 ef 08 30 80 11    	sub    $0x11803008,%edi
  801773:	89 bd e0 fd ff ff    	mov    %edi,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801779:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801780:	00 
  801781:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801788:	ee 
  801789:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  80178f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801793:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80179a:	00 
  80179b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a2:	e8 79 f8 ff ff       	call   801020 <sys_page_map>
  8017a7:	89 c3                	mov    %eax,%ebx
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 1a                	js     8017c7 <spawn+0x26b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8017ad:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8017b4:	00 
  8017b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017bc:	e8 01 f8 ff ff       	call   800fc2 <sys_page_unmap>
  8017c1:	89 c3                	mov    %eax,%ebx
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	79 1f                	jns    8017e6 <spawn+0x28a>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8017c7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8017ce:	00 
  8017cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d6:	e8 e7 f7 ff ff       	call   800fc2 <sys_page_unmap>
  8017db:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8017e1:	e9 9a 03 00 00       	jmp    801b80 <spawn+0x624>

	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8017e6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8017ec:	03 85 04 fe ff ff    	add    -0x1fc(%ebp),%eax
  8017f2:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  8017f8:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8017ff:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801802:	e9 c1 01 00 00       	jmp    8019c8 <spawn+0x46c>
		if (ph->p_type != ELF_PROG_LOAD)
  801807:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80180d:	83 38 01             	cmpl   $0x1,(%eax)
  801810:	0f 85 a4 01 00 00    	jne    8019ba <spawn+0x45e>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801816:	89 c2                	mov    %eax,%edx
  801818:	8b 40 18             	mov    0x18(%eax),%eax
  80181b:	83 e0 02             	and    $0x2,%eax
  80181e:	83 f8 01             	cmp    $0x1,%eax
  801821:	19 c0                	sbb    %eax,%eax
  801823:	83 e0 fe             	and    $0xfffffffe,%eax
  801826:	83 c0 07             	add    $0x7,%eax
  801829:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80182f:	8b 52 04             	mov    0x4(%edx),%edx
  801832:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  801838:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80183e:	8b 40 10             	mov    0x10(%eax),%eax
  801841:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801847:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  80184d:	8b 52 14             	mov    0x14(%edx),%edx
  801850:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
  801856:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80185c:	8b 58 08             	mov    0x8(%eax),%ebx
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80185f:	89 d8                	mov    %ebx,%eax
  801861:	25 ff 0f 00 00       	and    $0xfff,%eax
  801866:	74 16                	je     80187e <spawn+0x322>
		va -= i;
  801868:	29 c3                	sub    %eax,%ebx
		memsz += i;
  80186a:	01 c2                	add    %eax,%edx
  80186c:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		filesz += i;
  801872:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801878:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
  80187e:	be 00 00 00 00       	mov    $0x0,%esi
  801883:	89 df                	mov    %ebx,%edi
  801885:	e9 22 01 00 00       	jmp    8019ac <spawn+0x450>
	}

	for (i = 0; i < memsz; i += PGSIZE) {
		if (i >= filesz) {
  80188a:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801890:	77 2b                	ja     8018bd <spawn+0x361>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801892:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  801898:	89 54 24 08          	mov    %edx,0x8(%esp)
  80189c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018a0:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8018a6:	89 04 24             	mov    %eax,(%esp)
  8018a9:	e8 d0 f7 ff ff       	call   80107e <sys_page_alloc>
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	0f 89 ea 00 00 00    	jns    8019a0 <spawn+0x444>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	e9 93 02 00 00       	jmp    801b50 <spawn+0x5f4>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8018bd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8018c4:	00 
  8018c5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8018cc:	00 
  8018cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018d4:	e8 a5 f7 ff ff       	call   80107e <sys_page_alloc>
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	0f 88 65 02 00 00    	js     801b46 <spawn+0x5ea>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8018e1:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  8018e7:	01 d8                	add    %ebx,%eax
  8018e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ed:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8018f3:	89 14 24             	mov    %edx,(%esp)
  8018f6:	e8 e5 04 00 00       	call   801de0 <seek>
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	0f 88 47 02 00 00    	js     801b4a <spawn+0x5ee>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801903:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801909:	29 d8                	sub    %ebx,%eax
  80190b:	89 c3                	mov    %eax,%ebx
  80190d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801912:	ba 00 10 00 00       	mov    $0x1000,%edx
  801917:	0f 47 da             	cmova  %edx,%ebx
  80191a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80191e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801925:	00 
  801926:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80192c:	89 04 24             	mov    %eax,(%esp)
  80192f:	e8 49 07 00 00       	call   80207d <readn>
  801934:	85 c0                	test   %eax,%eax
  801936:	0f 88 12 02 00 00    	js     801b4e <spawn+0x5f2>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80193c:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  801942:	89 54 24 10          	mov    %edx,0x10(%esp)
  801946:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80194a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801950:	89 44 24 08          	mov    %eax,0x8(%esp)
  801954:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80195b:	00 
  80195c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801963:	e8 b8 f6 ff ff       	call   801020 <sys_page_map>
  801968:	85 c0                	test   %eax,%eax
  80196a:	79 20                	jns    80198c <spawn+0x430>
				panic("spawn: sys_page_map data: %e", r);
  80196c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801970:	c7 44 24 08 a4 39 80 	movl   $0x8039a4,0x8(%esp)
  801977:	00 
  801978:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  80197f:	00 
  801980:	c7 04 24 98 39 80 00 	movl   $0x803998,(%esp)
  801987:	e8 94 e8 ff ff       	call   800220 <_panic>
			sys_page_unmap(0, UTEMP);
  80198c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801993:	00 
  801994:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80199b:	e8 22 f6 ff ff       	call   800fc2 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8019a0:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8019a6:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8019ac:	89 f3                	mov    %esi,%ebx
  8019ae:	39 b5 84 fd ff ff    	cmp    %esi,-0x27c(%ebp)
  8019b4:	0f 87 d0 fe ff ff    	ja     80188a <spawn+0x32e>
	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8019ba:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  8019c1:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  8019c8:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8019cf:	39 85 7c fd ff ff    	cmp    %eax,-0x284(%ebp)
  8019d5:	0f 8c 2c fe ff ff    	jl     801807 <spawn+0x2ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8019db:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8019e1:	89 14 24             	mov    %edx,(%esp)
  8019e4:	e8 6d 07 00 00       	call   802156 <close>
	fd = -1;

	cprintf("copy sharing pages\n");
  8019e9:	c7 04 24 db 39 80 00 	movl   $0x8039db,(%esp)
  8019f0:	e8 e4 e8 ff ff       	call   8002d9 <cprintf>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
  8019f5:	e8 17 f7 ff ff       	call   801111 <sys_getenvid>
  8019fa:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801a00:	c7 85 8c fd ff ff 00 	movl   $0x0,-0x274(%ebp)
  801a07:	00 00 00 

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  801a0a:	be 00 00 40 ef       	mov    $0xef400000,%esi
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  801a0f:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801a15:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801a1c:	a8 01                	test   $0x1,%al
  801a1e:	0f 84 89 00 00 00    	je     801aad <spawn+0x551>
  801a24:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801a2a:	0f 84 69 01 00 00    	je     801b99 <spawn+0x63d>
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  801a30:	89 d7                	mov    %edx,%edi
  801a32:	c1 e7 16             	shl    $0x16,%edi
  801a35:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a3a:	89 da                	mov    %ebx,%edx
  801a3c:	c1 e2 0c             	shl    $0xc,%edx
  801a3f:	01 fa                	add    %edi,%edx
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  801a41:	89 d0                	mov    %edx,%eax
  801a43:	c1 e8 0c             	shr    $0xc,%eax
  801a46:	8b 0c 86             	mov    (%esi,%eax,4),%ecx
  801a49:	f6 c1 01             	test   $0x1,%cl
  801a4c:	74 54                	je     801aa2 <spawn+0x546>
  801a4e:	8b 04 86             	mov    (%esi,%eax,4),%eax
  801a51:	f6 c4 04             	test   $0x4,%ah
  801a54:	74 4c                	je     801aa2 <spawn+0x546>
				{
					ret = sys_page_map(curr_envid, (void *)addr, child,(void *)addr,PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801a56:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  801a5d:	00 
  801a5e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a62:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801a68:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a6c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a70:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801a76:	89 14 24             	mov    %edx,(%esp)
  801a79:	e8 a2 f5 ff ff       	call   801020 <sys_page_map>
					if(ret) panic("sys_page_map: %e", ret);
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	74 20                	je     801aa2 <spawn+0x546>
  801a82:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a86:	c7 44 24 08 c1 39 80 	movl   $0x8039c1,0x8(%esp)
  801a8d:	00 
  801a8e:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  801a95:	00 
  801a96:	c7 04 24 98 39 80 00 	movl   $0x803998,(%esp)
  801a9d:	e8 7e e7 ff ff       	call   800220 <_panic>
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
  801aa2:	83 c3 01             	add    $0x1,%ebx
  801aa5:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801aab:	75 8d                	jne    801a3a <spawn+0x4de>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  801aad:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  801ab4:	81 bd 8c fd ff ff bb 	cmpl   $0x3bb,-0x274(%ebp)
  801abb:	03 00 00 
  801abe:	0f 85 4b ff ff ff    	jne    801a0f <spawn+0x4b3>

	cprintf("copy sharing pages\n");
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
	cprintf("complete copy sharing pages\n");	
  801ac4:	c7 04 24 d2 39 80 00 	movl   $0x8039d2,(%esp)
  801acb:	e8 09 e8 ff ff       	call   8002d9 <cprintf>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801ad0:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ada:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ae0:	89 04 24             	mov    %eax,(%esp)
  801ae3:	e8 1e f4 ff ff       	call   800f06 <sys_env_set_trapframe>
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	79 20                	jns    801b0c <spawn+0x5b0>
		panic("sys_env_set_trapframe: %e", r);
  801aec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801af0:	c7 44 24 08 ef 39 80 	movl   $0x8039ef,0x8(%esp)
  801af7:	00 
  801af8:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  801aff:	00 
  801b00:	c7 04 24 98 39 80 00 	movl   $0x803998,(%esp)
  801b07:	e8 14 e7 ff ff       	call   800220 <_panic>
	
	//thisenv = &envs[ENVX(child)];
	//cprintf("%s %x\n",__func__,thisenv->env_id);
	
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801b0c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801b13:	00 
  801b14:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801b1a:	89 14 24             	mov    %edx,(%esp)
  801b1d:	e8 42 f4 ff ff       	call   800f64 <sys_env_set_status>
  801b22:	85 c0                	test   %eax,%eax
  801b24:	79 4e                	jns    801b74 <spawn+0x618>
		panic("sys_env_set_status: %e", r);
  801b26:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2a:	c7 44 24 08 fa 38 80 	movl   $0x8038fa,0x8(%esp)
  801b31:	00 
  801b32:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  801b39:	00 
  801b3a:	c7 04 24 98 39 80 00 	movl   $0x803998,(%esp)
  801b41:	e8 da e6 ff ff       	call   800220 <_panic>
  801b46:	89 c3                	mov    %eax,%ebx
  801b48:	eb 06                	jmp    801b50 <spawn+0x5f4>
  801b4a:	89 c3                	mov    %eax,%ebx
  801b4c:	eb 02                	jmp    801b50 <spawn+0x5f4>
  801b4e:	89 c3                	mov    %eax,%ebx
	
	return child;

error:
	sys_env_destroy(child);
  801b50:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b56:	89 04 24             	mov    %eax,(%esp)
  801b59:	e8 e7 f5 ff ff       	call   801145 <sys_env_destroy>
	close(fd);
  801b5e:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801b64:	89 14 24             	mov    %edx,(%esp)
  801b67:	e8 ea 05 00 00       	call   802156 <close>
  801b6c:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
	return r;
  801b72:	eb 0c                	jmp    801b80 <spawn+0x624>
  801b74:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b7a:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  801b80:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801b86:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801b8c:	5b                   	pop    %ebx
  801b8d:	5e                   	pop    %esi
  801b8e:	5f                   	pop    %edi
  801b8f:	5d                   	pop    %ebp
  801b90:	c3                   	ret    
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801b91:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801b97:	eb e7                	jmp    801b80 <spawn+0x624>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  801b99:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  801ba0:	e9 6a fe ff ff       	jmp    801a0f <spawn+0x4b3>

00801ba5 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	56                   	push   %esi
  801ba9:	53                   	push   %ebx
  801baa:	83 ec 10             	sub    $0x10,%esp

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  801bad:	8d 45 10             	lea    0x10(%ebp),%eax
  801bb0:	ba 00 00 00 00       	mov    $0x0,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801bb5:	eb 03                	jmp    801bba <spawnl+0x15>
		argc++;
  801bb7:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801bba:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  801bbe:	75 f7                	jne    801bb7 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801bc0:	8d 04 95 26 00 00 00 	lea    0x26(,%edx,4),%eax
  801bc7:	83 e0 f0             	and    $0xfffffff0,%eax
  801bca:	29 c4                	sub    %eax,%esp
  801bcc:	8d 5c 24 17          	lea    0x17(%esp),%ebx
  801bd0:	83 e3 f0             	and    $0xfffffff0,%ebx
	argv[0] = arg0;
  801bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd6:	89 03                	mov    %eax,(%ebx)
	argv[argc+1] = NULL;
  801bd8:	c7 44 93 04 00 00 00 	movl   $0x0,0x4(%ebx,%edx,4)
  801bdf:	00 

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  801be0:	8d 75 10             	lea    0x10(%ebp),%esi
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801be8:	eb 0a                	jmp    801bf4 <spawnl+0x4f>
		argv[i+1] = va_arg(vl, const char *);
  801bea:	83 c0 01             	add    $0x1,%eax
  801bed:	8b 4c 86 fc          	mov    -0x4(%esi,%eax,4),%ecx
  801bf1:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801bf4:	39 d0                	cmp    %edx,%eax
  801bf6:	72 f2                	jb     801bea <spawnl+0x45>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801bf8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	89 04 24             	mov    %eax,(%esp)
  801c02:	e8 55 f9 ff ff       	call   80155c <spawn>
}
  801c07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0a:	5b                   	pop    %ebx
  801c0b:	5e                   	pop    %esi
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    
	...

00801c10 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	56                   	push   %esi
  801c14:	53                   	push   %ebx
  801c15:	83 ec 10             	sub    $0x10,%esp
  801c18:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801c1b:	85 f6                	test   %esi,%esi
  801c1d:	75 24                	jne    801c43 <wait+0x33>
  801c1f:	c7 44 24 0c 32 3a 80 	movl   $0x803a32,0xc(%esp)
  801c26:	00 
  801c27:	c7 44 24 08 83 39 80 	movl   $0x803983,0x8(%esp)
  801c2e:	00 
  801c2f:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  801c36:	00 
  801c37:	c7 04 24 3d 3a 80 00 	movl   $0x803a3d,(%esp)
  801c3e:	e8 dd e5 ff ff       	call   800220 <_panic>
	e = &envs[ENVX(envid)];
  801c43:	89 f3                	mov    %esi,%ebx
  801c45:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  801c4b:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801c4e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801c54:	eb 05                	jmp    801c5b <wait+0x4b>
		sys_yield();
  801c56:	e8 82 f4 ff ff       	call   8010dd <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801c5b:	8b 43 48             	mov    0x48(%ebx),%eax
  801c5e:	39 f0                	cmp    %esi,%eax
  801c60:	75 07                	jne    801c69 <wait+0x59>
  801c62:	8b 43 54             	mov    0x54(%ebx),%eax
  801c65:	85 c0                	test   %eax,%eax
  801c67:	75 ed                	jne    801c56 <wait+0x46>
		sys_yield();
}
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	5b                   	pop    %ebx
  801c6d:	5e                   	pop    %esi
  801c6e:	5d                   	pop    %ebp
  801c6f:	c3                   	ret    

00801c70 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	53                   	push   %ebx
  801c74:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  801c77:	83 3d 0c 50 80 00 00 	cmpl   $0x0,0x80500c
  801c7e:	75 5b                	jne    801cdb <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  801c80:	e8 8c f4 ff ff       	call   801111 <sys_getenvid>
  801c85:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  801c87:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c8e:	00 
  801c8f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801c96:	ee 
  801c97:	89 04 24             	mov    %eax,(%esp)
  801c9a:	e8 df f3 ff ff       	call   80107e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	74 28                	je     801ccb <set_pgfault_handler+0x5b>
  801ca3:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ca7:	c7 44 24 0c 6f 3a 80 	movl   $0x803a6f,0xc(%esp)
  801cae:	00 
  801caf:	c7 44 24 08 48 3a 80 	movl   $0x803a48,0x8(%esp)
  801cb6:	00 
  801cb7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801cbe:	00 
  801cbf:	c7 04 24 61 3a 80 00 	movl   $0x803a61,(%esp)
  801cc6:	e8 55 e5 ff ff       	call   800220 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  801ccb:	c7 44 24 04 ec 1c 80 	movl   $0x801cec,0x4(%esp)
  801cd2:	00 
  801cd3:	89 1c 24             	mov    %ebx,(%esp)
  801cd6:	e8 cd f1 ff ff       	call   800ea8 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	a3 0c 50 80 00       	mov    %eax,0x80500c
	
}
  801ce3:	83 c4 24             	add    $0x24,%esp
  801ce6:	5b                   	pop    %ebx
  801ce7:	5d                   	pop    %ebp
  801ce8:	c3                   	ret    
  801ce9:	00 00                	add    %al,(%eax)
	...

00801cec <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801cec:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801ced:	a1 0c 50 80 00       	mov    0x80500c,%eax
	call *%eax
  801cf2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801cf4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  801cf7:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  801cfa:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  801cfe:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  801d02:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  801d05:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  801d08:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  801d0c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  801d0d:	83 c4 04             	add    $0x4,%esp
	popfl ;
  801d10:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  801d11:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801d12:	c3                   	ret    
	...

00801d14 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	05 00 00 00 30       	add    $0x30000000,%eax
  801d1f:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	89 04 24             	mov    %eax,(%esp)
  801d30:	e8 df ff ff ff       	call   801d14 <fd2num>
  801d35:	05 20 00 0d 00       	add    $0xd0020,%eax
  801d3a:	c1 e0 0c             	shl    $0xc,%eax
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	57                   	push   %edi
  801d43:	56                   	push   %esi
  801d44:	53                   	push   %ebx
  801d45:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d48:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d4d:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801d52:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d57:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d59:	89 c2                	mov    %eax,%edx
  801d5b:	c1 ea 16             	shr    $0x16,%edx
  801d5e:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801d61:	f6 c2 01             	test   $0x1,%dl
  801d64:	74 0d                	je     801d73 <fd_alloc+0x34>
  801d66:	89 c2                	mov    %eax,%edx
  801d68:	c1 ea 0c             	shr    $0xc,%edx
  801d6b:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  801d6e:	f6 c2 01             	test   $0x1,%dl
  801d71:	75 09                	jne    801d7c <fd_alloc+0x3d>
			*fd_store = fd;
  801d73:	89 37                	mov    %esi,(%edi)
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801d7a:	eb 17                	jmp    801d93 <fd_alloc+0x54>
  801d7c:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d81:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801d86:	75 cf                	jne    801d57 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d88:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801d8e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    

00801d98 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	83 f8 1f             	cmp    $0x1f,%eax
  801da1:	77 36                	ja     801dd9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801da3:	05 00 00 0d 00       	add    $0xd0000,%eax
  801da8:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801dab:	89 c2                	mov    %eax,%edx
  801dad:	c1 ea 16             	shr    $0x16,%edx
  801db0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801db7:	f6 c2 01             	test   $0x1,%dl
  801dba:	74 1d                	je     801dd9 <fd_lookup+0x41>
  801dbc:	89 c2                	mov    %eax,%edx
  801dbe:	c1 ea 0c             	shr    $0xc,%edx
  801dc1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801dc8:	f6 c2 01             	test   $0x1,%dl
  801dcb:	74 0c                	je     801dd9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd0:	89 02                	mov    %eax,(%edx)
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801dd7:	eb 05                	jmp    801dde <fd_lookup+0x46>
  801dd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    

00801de0 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801de6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801de9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	89 04 24             	mov    %eax,(%esp)
  801df3:	e8 a0 ff ff ff       	call   801d98 <fd_lookup>
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 0e                	js     801e0a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e02:	89 50 04             	mov    %edx,0x4(%eax)
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	56                   	push   %esi
  801e10:	53                   	push   %ebx
  801e11:	83 ec 10             	sub    $0x10,%esp
  801e14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801e1a:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801e1f:	be 04 3b 80 00       	mov    $0x803b04,%esi
  801e24:	eb 10                	jmp    801e36 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  801e26:	39 08                	cmp    %ecx,(%eax)
  801e28:	75 09                	jne    801e33 <dev_lookup+0x27>
			*dev = devtab[i];
  801e2a:	89 03                	mov    %eax,(%ebx)
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801e31:	eb 31                	jmp    801e64 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e33:	83 c2 01             	add    $0x1,%edx
  801e36:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	75 e9                	jne    801e26 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e3d:	a1 08 50 80 00       	mov    0x805008,%eax
  801e42:	8b 40 48             	mov    0x48(%eax),%eax
  801e45:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	c7 04 24 84 3a 80 00 	movl   $0x803a84,(%esp)
  801e54:	e8 80 e4 ff ff       	call   8002d9 <cprintf>
	*dev = 0;
  801e59:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5d                   	pop    %ebp
  801e6a:	c3                   	ret    

00801e6b <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	53                   	push   %ebx
  801e6f:	83 ec 24             	sub    $0x24,%esp
  801e72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e75:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	89 04 24             	mov    %eax,(%esp)
  801e82:	e8 11 ff ff ff       	call   801d98 <fd_lookup>
  801e87:	85 c0                	test   %eax,%eax
  801e89:	78 53                	js     801ede <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e95:	8b 00                	mov    (%eax),%eax
  801e97:	89 04 24             	mov    %eax,(%esp)
  801e9a:	e8 6d ff ff ff       	call   801e0c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	78 3b                	js     801ede <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801ea3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eab:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801eaf:	74 2d                	je     801ede <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801eb1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801eb4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ebb:	00 00 00 
	stat->st_isdir = 0;
  801ebe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ec5:	00 00 00 
	stat->st_dev = dev;
  801ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ed1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ed5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed8:	89 14 24             	mov    %edx,(%esp)
  801edb:	ff 50 14             	call   *0x14(%eax)
}
  801ede:	83 c4 24             	add    $0x24,%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    

00801ee4 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	53                   	push   %ebx
  801ee8:	83 ec 24             	sub    $0x24,%esp
  801eeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801eee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef5:	89 1c 24             	mov    %ebx,(%esp)
  801ef8:	e8 9b fe ff ff       	call   801d98 <fd_lookup>
  801efd:	85 c0                	test   %eax,%eax
  801eff:	78 5f                	js     801f60 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0b:	8b 00                	mov    (%eax),%eax
  801f0d:	89 04 24             	mov    %eax,(%esp)
  801f10:	e8 f7 fe ff ff       	call   801e0c <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f15:	85 c0                	test   %eax,%eax
  801f17:	78 47                	js     801f60 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f1c:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801f20:	75 23                	jne    801f45 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801f22:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f27:	8b 40 48             	mov    0x48(%eax),%eax
  801f2a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f32:	c7 04 24 a4 3a 80 00 	movl   $0x803aa4,(%esp)
  801f39:	e8 9b e3 ff ff       	call   8002d9 <cprintf>
  801f3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801f43:	eb 1b                	jmp    801f60 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 48 18             	mov    0x18(%eax),%ecx
  801f4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f50:	85 c9                	test   %ecx,%ecx
  801f52:	74 0c                	je     801f60 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5b:	89 14 24             	mov    %edx,(%esp)
  801f5e:	ff d1                	call   *%ecx
}
  801f60:	83 c4 24             	add    $0x24,%esp
  801f63:	5b                   	pop    %ebx
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	53                   	push   %ebx
  801f6a:	83 ec 24             	sub    $0x24,%esp
  801f6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f70:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f77:	89 1c 24             	mov    %ebx,(%esp)
  801f7a:	e8 19 fe ff ff       	call   801d98 <fd_lookup>
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	78 66                	js     801fe9 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f86:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8d:	8b 00                	mov    (%eax),%eax
  801f8f:	89 04 24             	mov    %eax,(%esp)
  801f92:	e8 75 fe ff ff       	call   801e0c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f97:	85 c0                	test   %eax,%eax
  801f99:	78 4e                	js     801fe9 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f9e:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801fa2:	75 23                	jne    801fc7 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801fa4:	a1 08 50 80 00       	mov    0x805008,%eax
  801fa9:	8b 40 48             	mov    0x48(%eax),%eax
  801fac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb4:	c7 04 24 c8 3a 80 00 	movl   $0x803ac8,(%esp)
  801fbb:	e8 19 e3 ff ff       	call   8002d9 <cprintf>
  801fc0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801fc5:	eb 22                	jmp    801fe9 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 48 0c             	mov    0xc(%eax),%ecx
  801fcd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fd2:	85 c9                	test   %ecx,%ecx
  801fd4:	74 13                	je     801fe9 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe4:	89 14 24             	mov    %edx,(%esp)
  801fe7:	ff d1                	call   *%ecx
}
  801fe9:	83 c4 24             	add    $0x24,%esp
  801fec:	5b                   	pop    %ebx
  801fed:	5d                   	pop    %ebp
  801fee:	c3                   	ret    

00801fef <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	53                   	push   %ebx
  801ff3:	83 ec 24             	sub    $0x24,%esp
  801ff6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ff9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802000:	89 1c 24             	mov    %ebx,(%esp)
  802003:	e8 90 fd ff ff       	call   801d98 <fd_lookup>
  802008:	85 c0                	test   %eax,%eax
  80200a:	78 6b                	js     802077 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80200c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802016:	8b 00                	mov    (%eax),%eax
  802018:	89 04 24             	mov    %eax,(%esp)
  80201b:	e8 ec fd ff ff       	call   801e0c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802020:	85 c0                	test   %eax,%eax
  802022:	78 53                	js     802077 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802024:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802027:	8b 42 08             	mov    0x8(%edx),%eax
  80202a:	83 e0 03             	and    $0x3,%eax
  80202d:	83 f8 01             	cmp    $0x1,%eax
  802030:	75 23                	jne    802055 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802032:	a1 08 50 80 00       	mov    0x805008,%eax
  802037:	8b 40 48             	mov    0x48(%eax),%eax
  80203a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80203e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802042:	c7 04 24 e5 3a 80 00 	movl   $0x803ae5,(%esp)
  802049:	e8 8b e2 ff ff       	call   8002d9 <cprintf>
  80204e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  802053:	eb 22                	jmp    802077 <read+0x88>
	}
	if (!dev->dev_read)
  802055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802058:	8b 48 08             	mov    0x8(%eax),%ecx
  80205b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802060:	85 c9                	test   %ecx,%ecx
  802062:	74 13                	je     802077 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802064:	8b 45 10             	mov    0x10(%ebp),%eax
  802067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80206b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802072:	89 14 24             	mov    %edx,(%esp)
  802075:	ff d1                	call   *%ecx
}
  802077:	83 c4 24             	add    $0x24,%esp
  80207a:	5b                   	pop    %ebx
  80207b:	5d                   	pop    %ebp
  80207c:	c3                   	ret    

0080207d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	57                   	push   %edi
  802081:	56                   	push   %esi
  802082:	53                   	push   %ebx
  802083:	83 ec 1c             	sub    $0x1c,%esp
  802086:	8b 7d 08             	mov    0x8(%ebp),%edi
  802089:	8b 75 10             	mov    0x10(%ebp),%esi
  80208c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802091:	eb 21                	jmp    8020b4 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802093:	89 f2                	mov    %esi,%edx
  802095:	29 c2                	sub    %eax,%edx
  802097:	89 54 24 08          	mov    %edx,0x8(%esp)
  80209b:	03 45 0c             	add    0xc(%ebp),%eax
  80209e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a2:	89 3c 24             	mov    %edi,(%esp)
  8020a5:	e8 45 ff ff ff       	call   801fef <read>
		if (m < 0)
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 0e                	js     8020bc <readn+0x3f>
			return m;
		if (m == 0)
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	74 08                	je     8020ba <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020b2:	01 c3                	add    %eax,%ebx
  8020b4:	89 d8                	mov    %ebx,%eax
  8020b6:	39 f3                	cmp    %esi,%ebx
  8020b8:	72 d9                	jb     802093 <readn+0x16>
  8020ba:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8020bc:	83 c4 1c             	add    $0x1c,%esp
  8020bf:	5b                   	pop    %ebx
  8020c0:	5e                   	pop    %esi
  8020c1:	5f                   	pop    %edi
  8020c2:	5d                   	pop    %ebp
  8020c3:	c3                   	ret    

008020c4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 38             	sub    $0x38,%esp
  8020ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8020cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8020d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8020d3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020d6:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8020da:	89 3c 24             	mov    %edi,(%esp)
  8020dd:	e8 32 fc ff ff       	call   801d14 <fd2num>
  8020e2:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8020e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e9:	89 04 24             	mov    %eax,(%esp)
  8020ec:	e8 a7 fc ff ff       	call   801d98 <fd_lookup>
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 05                	js     8020fc <fd_close+0x38>
  8020f7:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8020fa:	74 0e                	je     80210a <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8020fc:	89 f0                	mov    %esi,%eax
  8020fe:	84 c0                	test   %al,%al
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
  802105:	0f 44 d8             	cmove  %eax,%ebx
  802108:	eb 3d                	jmp    802147 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80210a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80210d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802111:	8b 07                	mov    (%edi),%eax
  802113:	89 04 24             	mov    %eax,(%esp)
  802116:	e8 f1 fc ff ff       	call   801e0c <dev_lookup>
  80211b:	89 c3                	mov    %eax,%ebx
  80211d:	85 c0                	test   %eax,%eax
  80211f:	78 16                	js     802137 <fd_close+0x73>
		if (dev->dev_close)
  802121:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802124:	8b 40 10             	mov    0x10(%eax),%eax
  802127:	bb 00 00 00 00       	mov    $0x0,%ebx
  80212c:	85 c0                	test   %eax,%eax
  80212e:	74 07                	je     802137 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  802130:	89 3c 24             	mov    %edi,(%esp)
  802133:	ff d0                	call   *%eax
  802135:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802137:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80213b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802142:	e8 7b ee ff ff       	call   800fc2 <sys_page_unmap>
	return r;
}
  802147:	89 d8                	mov    %ebx,%eax
  802149:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80214c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80214f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802152:	89 ec                	mov    %ebp,%esp
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    

00802156 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80215c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	89 04 24             	mov    %eax,(%esp)
  802169:	e8 2a fc ff ff       	call   801d98 <fd_lookup>
  80216e:	85 c0                	test   %eax,%eax
  802170:	78 13                	js     802185 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  802172:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802179:	00 
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	89 04 24             	mov    %eax,(%esp)
  802180:	e8 3f ff ff ff       	call   8020c4 <fd_close>
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 18             	sub    $0x18,%esp
  80218d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802190:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802193:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80219a:	00 
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	89 04 24             	mov    %eax,(%esp)
  8021a1:	e8 25 04 00 00       	call   8025cb <open>
  8021a6:	89 c3                	mov    %eax,%ebx
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	78 1b                	js     8021c7 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8021ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b3:	89 1c 24             	mov    %ebx,(%esp)
  8021b6:	e8 b0 fc ff ff       	call   801e6b <fstat>
  8021bb:	89 c6                	mov    %eax,%esi
	close(fd);
  8021bd:	89 1c 24             	mov    %ebx,(%esp)
  8021c0:	e8 91 ff ff ff       	call   802156 <close>
  8021c5:	89 f3                	mov    %esi,%ebx
	return r;
}
  8021c7:	89 d8                	mov    %ebx,%eax
  8021c9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8021cc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8021cf:	89 ec                	mov    %ebp,%esp
  8021d1:	5d                   	pop    %ebp
  8021d2:	c3                   	ret    

008021d3 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	53                   	push   %ebx
  8021d7:	83 ec 14             	sub    $0x14,%esp
  8021da:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8021df:	89 1c 24             	mov    %ebx,(%esp)
  8021e2:	e8 6f ff ff ff       	call   802156 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021e7:	83 c3 01             	add    $0x1,%ebx
  8021ea:	83 fb 20             	cmp    $0x20,%ebx
  8021ed:	75 f0                	jne    8021df <close_all+0xc>
		close(i);
}
  8021ef:	83 c4 14             	add    $0x14,%esp
  8021f2:	5b                   	pop    %ebx
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    

008021f5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 58             	sub    $0x58,%esp
  8021fb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8021fe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802201:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802204:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802207:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80220a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	89 04 24             	mov    %eax,(%esp)
  802214:	e8 7f fb ff ff       	call   801d98 <fd_lookup>
  802219:	89 c3                	mov    %eax,%ebx
  80221b:	85 c0                	test   %eax,%eax
  80221d:	0f 88 e0 00 00 00    	js     802303 <dup+0x10e>
		return r;
	close(newfdnum);
  802223:	89 3c 24             	mov    %edi,(%esp)
  802226:	e8 2b ff ff ff       	call   802156 <close>

	newfd = INDEX2FD(newfdnum);
  80222b:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  802231:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  802234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802237:	89 04 24             	mov    %eax,(%esp)
  80223a:	e8 e5 fa ff ff       	call   801d24 <fd2data>
  80223f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802241:	89 34 24             	mov    %esi,(%esp)
  802244:	e8 db fa ff ff       	call   801d24 <fd2data>
  802249:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80224c:	89 da                	mov    %ebx,%edx
  80224e:	89 d8                	mov    %ebx,%eax
  802250:	c1 e8 16             	shr    $0x16,%eax
  802253:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80225a:	a8 01                	test   $0x1,%al
  80225c:	74 43                	je     8022a1 <dup+0xac>
  80225e:	c1 ea 0c             	shr    $0xc,%edx
  802261:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802268:	a8 01                	test   $0x1,%al
  80226a:	74 35                	je     8022a1 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80226c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802273:	25 07 0e 00 00       	and    $0xe07,%eax
  802278:	89 44 24 10          	mov    %eax,0x10(%esp)
  80227c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80227f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802283:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80228a:	00 
  80228b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80228f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802296:	e8 85 ed ff ff       	call   801020 <sys_page_map>
  80229b:	89 c3                	mov    %eax,%ebx
  80229d:	85 c0                	test   %eax,%eax
  80229f:	78 3f                	js     8022e0 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8022a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a4:	89 c2                	mov    %eax,%edx
  8022a6:	c1 ea 0c             	shr    $0xc,%edx
  8022a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8022b0:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8022b6:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8022be:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022c5:	00 
  8022c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d1:	e8 4a ed ff ff       	call   801020 <sys_page_map>
  8022d6:	89 c3                	mov    %eax,%ebx
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	78 04                	js     8022e0 <dup+0xeb>
  8022dc:	89 fb                	mov    %edi,%ebx
  8022de:	eb 23                	jmp    802303 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8022e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022eb:	e8 d2 ec ff ff       	call   800fc2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8022f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022fe:	e8 bf ec ff ff       	call   800fc2 <sys_page_unmap>
	return r;
}
  802303:	89 d8                	mov    %ebx,%eax
  802305:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802308:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80230b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80230e:	89 ec                	mov    %ebp,%esp
  802310:	5d                   	pop    %ebp
  802311:	c3                   	ret    
	...

00802314 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	56                   	push   %esi
  802318:	53                   	push   %ebx
  802319:	83 ec 10             	sub    $0x10,%esp
  80231c:	89 c3                	mov    %eax,%ebx
  80231e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  802320:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  802327:	75 11                	jne    80233a <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802329:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802330:	e8 7f 0d 00 00       	call   8030b4 <ipc_find_env>
  802335:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  80233a:	a1 08 50 80 00       	mov    0x805008,%eax
  80233f:	8b 40 48             	mov    0x48(%eax),%eax
  802342:	8b 15 00 60 80 00    	mov    0x806000,%edx
  802348:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80234c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802350:	89 44 24 04          	mov    %eax,0x4(%esp)
  802354:	c7 04 24 18 3b 80 00 	movl   $0x803b18,(%esp)
  80235b:	e8 79 df ff ff       	call   8002d9 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802360:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802367:	00 
  802368:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80236f:	00 
  802370:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802374:	a1 00 50 80 00       	mov    0x805000,%eax
  802379:	89 04 24             	mov    %eax,(%esp)
  80237c:	e8 69 0d 00 00       	call   8030ea <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802381:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802388:	00 
  802389:	89 74 24 04          	mov    %esi,0x4(%esp)
  80238d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802394:	e8 bd 0d 00 00       	call   803156 <ipc_recv>
}
  802399:	83 c4 10             	add    $0x10,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5d                   	pop    %ebp
  80239f:	c3                   	ret    

008023a0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ac:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8023b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b4:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8023b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8023be:	b8 02 00 00 00       	mov    $0x2,%eax
  8023c3:	e8 4c ff ff ff       	call   802314 <fsipc>
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8023db:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e0:	b8 06 00 00 00       	mov    $0x6,%eax
  8023e5:	e8 2a ff ff ff       	call   802314 <fsipc>
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8023f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8023fc:	e8 13 ff ff ff       	call   802314 <fsipc>
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	53                   	push   %ebx
  802407:	83 ec 14             	sub    $0x14,%esp
  80240a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	8b 40 0c             	mov    0xc(%eax),%eax
  802413:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802418:	ba 00 00 00 00       	mov    $0x0,%edx
  80241d:	b8 05 00 00 00       	mov    $0x5,%eax
  802422:	e8 ed fe ff ff       	call   802314 <fsipc>
  802427:	85 c0                	test   %eax,%eax
  802429:	78 2b                	js     802456 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80242b:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802432:	00 
  802433:	89 1c 24             	mov    %ebx,(%esp)
  802436:	e8 fe e4 ff ff       	call   800939 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80243b:	a1 80 60 80 00       	mov    0x806080,%eax
  802440:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802446:	a1 84 60 80 00       	mov    0x806084,%eax
  80244b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  802456:	83 c4 14             	add    $0x14,%esp
  802459:	5b                   	pop    %ebx
  80245a:	5d                   	pop    %ebp
  80245b:	c3                   	ret    

0080245c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	53                   	push   %ebx
  802460:	83 ec 14             	sub    $0x14,%esp
  802463:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	8b 40 0c             	mov    0xc(%eax),%eax
  80246c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  802471:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  802477:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80247d:	76 24                	jbe    8024a3 <devfile_write+0x47>
  80247f:	c7 44 24 0c 2e 3b 80 	movl   $0x803b2e,0xc(%esp)
  802486:	00 
  802487:	c7 44 24 08 83 39 80 	movl   $0x803983,0x8(%esp)
  80248e:	00 
  80248f:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  802496:	00 
  802497:	c7 04 24 38 3b 80 00 	movl   $0x803b38,(%esp)
  80249e:	e8 7d dd ff ff       	call   800220 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  8024a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ae:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8024b5:	e8 25 e6 ff ff       	call   800adf <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  8024ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8024bf:	b8 04 00 00 00       	mov    $0x4,%eax
  8024c4:	e8 4b fe ff ff       	call   802314 <fsipc>
	if(ret<0) return ret;
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	78 53                	js     802520 <devfile_write+0xc4>
	
	assert(ret <= n);
  8024cd:	39 c3                	cmp    %eax,%ebx
  8024cf:	73 24                	jae    8024f5 <devfile_write+0x99>
  8024d1:	c7 44 24 0c 43 3b 80 	movl   $0x803b43,0xc(%esp)
  8024d8:	00 
  8024d9:	c7 44 24 08 83 39 80 	movl   $0x803983,0x8(%esp)
  8024e0:	00 
  8024e1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8024e8:	00 
  8024e9:	c7 04 24 38 3b 80 00 	movl   $0x803b38,(%esp)
  8024f0:	e8 2b dd ff ff       	call   800220 <_panic>
	assert(ret <= PGSIZE);
  8024f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8024fa:	7e 24                	jle    802520 <devfile_write+0xc4>
  8024fc:	c7 44 24 0c 4c 3b 80 	movl   $0x803b4c,0xc(%esp)
  802503:	00 
  802504:	c7 44 24 08 83 39 80 	movl   $0x803983,0x8(%esp)
  80250b:	00 
  80250c:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  802513:	00 
  802514:	c7 04 24 38 3b 80 00 	movl   $0x803b38,(%esp)
  80251b:	e8 00 dd ff ff       	call   800220 <_panic>
	return ret;
}
  802520:	83 c4 14             	add    $0x14,%esp
  802523:	5b                   	pop    %ebx
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    

00802526 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	56                   	push   %esi
  80252a:	53                   	push   %ebx
  80252b:	83 ec 10             	sub    $0x10,%esp
  80252e:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	8b 40 0c             	mov    0xc(%eax),%eax
  802537:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80253c:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802542:	ba 00 00 00 00       	mov    $0x0,%edx
  802547:	b8 03 00 00 00       	mov    $0x3,%eax
  80254c:	e8 c3 fd ff ff       	call   802314 <fsipc>
  802551:	89 c3                	mov    %eax,%ebx
  802553:	85 c0                	test   %eax,%eax
  802555:	78 6b                	js     8025c2 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  802557:	39 de                	cmp    %ebx,%esi
  802559:	73 24                	jae    80257f <devfile_read+0x59>
  80255b:	c7 44 24 0c 5a 3b 80 	movl   $0x803b5a,0xc(%esp)
  802562:	00 
  802563:	c7 44 24 08 83 39 80 	movl   $0x803983,0x8(%esp)
  80256a:	00 
  80256b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  802572:	00 
  802573:	c7 04 24 38 3b 80 00 	movl   $0x803b38,(%esp)
  80257a:	e8 a1 dc ff ff       	call   800220 <_panic>
	assert(r <= PGSIZE);
  80257f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  802585:	7e 24                	jle    8025ab <devfile_read+0x85>
  802587:	c7 44 24 0c 61 3b 80 	movl   $0x803b61,0xc(%esp)
  80258e:	00 
  80258f:	c7 44 24 08 83 39 80 	movl   $0x803983,0x8(%esp)
  802596:	00 
  802597:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  80259e:	00 
  80259f:	c7 04 24 38 3b 80 00 	movl   $0x803b38,(%esp)
  8025a6:	e8 75 dc ff ff       	call   800220 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8025ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025af:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8025b6:	00 
  8025b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ba:	89 04 24             	mov    %eax,(%esp)
  8025bd:	e8 1d e5 ff ff       	call   800adf <memmove>
	return r;
}
  8025c2:	89 d8                	mov    %ebx,%eax
  8025c4:	83 c4 10             	add    $0x10,%esp
  8025c7:	5b                   	pop    %ebx
  8025c8:	5e                   	pop    %esi
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    

008025cb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	83 ec 28             	sub    $0x28,%esp
  8025d1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8025d4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8025d7:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8025da:	89 34 24             	mov    %esi,(%esp)
  8025dd:	e8 1e e3 ff ff       	call   800900 <strlen>
  8025e2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8025e7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8025ec:	7f 5e                	jg     80264c <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8025ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025f1:	89 04 24             	mov    %eax,(%esp)
  8025f4:	e8 46 f7 ff ff       	call   801d3f <fd_alloc>
  8025f9:	89 c3                	mov    %eax,%ebx
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	78 4d                	js     80264c <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8025ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  802603:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80260a:	e8 2a e3 ff ff       	call   800939 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80260f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802612:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261a:	b8 01 00 00 00       	mov    $0x1,%eax
  80261f:	e8 f0 fc ff ff       	call   802314 <fsipc>
  802624:	89 c3                	mov    %eax,%ebx
  802626:	85 c0                	test   %eax,%eax
  802628:	79 15                	jns    80263f <open+0x74>
		fd_close(fd, 0);
  80262a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802631:	00 
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	89 04 24             	mov    %eax,(%esp)
  802638:	e8 87 fa ff ff       	call   8020c4 <fd_close>
		return r;
  80263d:	eb 0d                	jmp    80264c <open+0x81>
	}

	return fd2num(fd);
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	89 04 24             	mov    %eax,(%esp)
  802645:	e8 ca f6 ff ff       	call   801d14 <fd2num>
  80264a:	89 c3                	mov    %eax,%ebx
}
  80264c:	89 d8                	mov    %ebx,%eax
  80264e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802651:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802654:	89 ec                	mov    %ebp,%esp
  802656:	5d                   	pop    %ebp
  802657:	c3                   	ret    
	...

00802660 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802666:	c7 44 24 04 6d 3b 80 	movl   $0x803b6d,0x4(%esp)
  80266d:	00 
  80266e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802671:	89 04 24             	mov    %eax,(%esp)
  802674:	e8 c0 e2 ff ff       	call   800939 <strcpy>
	return 0;
}
  802679:	b8 00 00 00 00       	mov    $0x0,%eax
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	53                   	push   %ebx
  802684:	83 ec 14             	sub    $0x14,%esp
  802687:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80268a:	89 1c 24             	mov    %ebx,(%esp)
  80268d:	e8 4e 0b 00 00       	call   8031e0 <pageref>
  802692:	89 c2                	mov    %eax,%edx
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
  802699:	83 fa 01             	cmp    $0x1,%edx
  80269c:	75 0b                	jne    8026a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80269e:	8b 43 0c             	mov    0xc(%ebx),%eax
  8026a1:	89 04 24             	mov    %eax,(%esp)
  8026a4:	e8 b1 02 00 00       	call   80295a <nsipc_close>
	else
		return 0;
}
  8026a9:	83 c4 14             	add    $0x14,%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5d                   	pop    %ebp
  8026ae:	c3                   	ret    

008026af <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
  8026b2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8026b5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026bc:	00 
  8026bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d1:	89 04 24             	mov    %eax,(%esp)
  8026d4:	e8 bd 02 00 00       	call   802996 <nsipc_send>
}
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8026e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026e8:	00 
  8026e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fd:	89 04 24             	mov    %eax,(%esp)
  802700:	e8 04 03 00 00       	call   802a09 <nsipc_recv>
}
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
  80270a:	56                   	push   %esi
  80270b:	53                   	push   %ebx
  80270c:	83 ec 20             	sub    $0x20,%esp
  80270f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802711:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802714:	89 04 24             	mov    %eax,(%esp)
  802717:	e8 23 f6 ff ff       	call   801d3f <fd_alloc>
  80271c:	89 c3                	mov    %eax,%ebx
  80271e:	85 c0                	test   %eax,%eax
  802720:	78 21                	js     802743 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802722:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802729:	00 
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802731:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802738:	e8 41 e9 ff ff       	call   80107e <sys_page_alloc>
  80273d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80273f:	85 c0                	test   %eax,%eax
  802741:	79 0a                	jns    80274d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  802743:	89 34 24             	mov    %esi,(%esp)
  802746:	e8 0f 02 00 00       	call   80295a <nsipc_close>
		return r;
  80274b:	eb 28                	jmp    802775 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80274d:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	89 04 24             	mov    %eax,(%esp)
  80276e:	e8 a1 f5 ff ff       	call   801d14 <fd2num>
  802773:	89 c3                	mov    %eax,%ebx
}
  802775:	89 d8                	mov    %ebx,%eax
  802777:	83 c4 20             	add    $0x20,%esp
  80277a:	5b                   	pop    %ebx
  80277b:	5e                   	pop    %esi
  80277c:	5d                   	pop    %ebp
  80277d:	c3                   	ret    

0080277e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802784:	8b 45 10             	mov    0x10(%ebp),%eax
  802787:	89 44 24 08          	mov    %eax,0x8(%esp)
  80278b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	89 04 24             	mov    %eax,(%esp)
  802798:	e8 71 01 00 00       	call   80290e <nsipc_socket>
  80279d:	85 c0                	test   %eax,%eax
  80279f:	78 05                	js     8027a6 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8027a1:	e8 61 ff ff ff       	call   802707 <alloc_sockfd>
}
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
  8027ab:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8027ae:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8027b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027b5:	89 04 24             	mov    %eax,(%esp)
  8027b8:	e8 db f5 ff ff       	call   801d98 <fd_lookup>
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	78 15                	js     8027d6 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8027c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c4:	8b 0a                	mov    (%edx),%ecx
  8027c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8027cb:	3b 0d 28 40 80 00    	cmp    0x804028,%ecx
  8027d1:	75 03                	jne    8027d6 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8027d3:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8027d6:	c9                   	leave  
  8027d7:	c3                   	ret    

008027d8 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	e8 c2 ff ff ff       	call   8027a8 <fd2sockid>
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	78 0f                	js     8027f9 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8027ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027f1:	89 04 24             	mov    %eax,(%esp)
  8027f4:	e8 3f 01 00 00       	call   802938 <nsipc_listen>
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
  8027fe:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	e8 9f ff ff ff       	call   8027a8 <fd2sockid>
  802809:	85 c0                	test   %eax,%eax
  80280b:	78 16                	js     802823 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  80280d:	8b 55 10             	mov    0x10(%ebp),%edx
  802810:	89 54 24 08          	mov    %edx,0x8(%esp)
  802814:	8b 55 0c             	mov    0xc(%ebp),%edx
  802817:	89 54 24 04          	mov    %edx,0x4(%esp)
  80281b:	89 04 24             	mov    %eax,(%esp)
  80281e:	e8 66 02 00 00       	call   802a89 <nsipc_connect>
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	e8 75 ff ff ff       	call   8027a8 <fd2sockid>
  802833:	85 c0                	test   %eax,%eax
  802835:	78 0f                	js     802846 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80283e:	89 04 24             	mov    %eax,(%esp)
  802841:	e8 2e 01 00 00       	call   802974 <nsipc_shutdown>
}
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802848:	55                   	push   %ebp
  802849:	89 e5                	mov    %esp,%ebp
  80284b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	e8 52 ff ff ff       	call   8027a8 <fd2sockid>
  802856:	85 c0                	test   %eax,%eax
  802858:	78 16                	js     802870 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80285a:	8b 55 10             	mov    0x10(%ebp),%edx
  80285d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802861:	8b 55 0c             	mov    0xc(%ebp),%edx
  802864:	89 54 24 04          	mov    %edx,0x4(%esp)
  802868:	89 04 24             	mov    %eax,(%esp)
  80286b:	e8 58 02 00 00       	call   802ac8 <nsipc_bind>
}
  802870:	c9                   	leave  
  802871:	c3                   	ret    

00802872 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
  802875:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802878:	8b 45 08             	mov    0x8(%ebp),%eax
  80287b:	e8 28 ff ff ff       	call   8027a8 <fd2sockid>
  802880:	85 c0                	test   %eax,%eax
  802882:	78 1f                	js     8028a3 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802884:	8b 55 10             	mov    0x10(%ebp),%edx
  802887:	89 54 24 08          	mov    %edx,0x8(%esp)
  80288b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802892:	89 04 24             	mov    %eax,(%esp)
  802895:	e8 6d 02 00 00       	call   802b07 <nsipc_accept>
  80289a:	85 c0                	test   %eax,%eax
  80289c:	78 05                	js     8028a3 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80289e:	e8 64 fe ff ff       	call   802707 <alloc_sockfd>
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    
  8028a5:	00 00                	add    %al,(%eax)
	...

008028a8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	53                   	push   %ebx
  8028ac:	83 ec 14             	sub    $0x14,%esp
  8028af:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8028b1:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8028b8:	75 11                	jne    8028cb <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8028ba:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8028c1:	e8 ee 07 00 00       	call   8030b4 <ipc_find_env>
  8028c6:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8028cb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8028d2:	00 
  8028d3:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8028da:	00 
  8028db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028df:	a1 04 50 80 00       	mov    0x805004,%eax
  8028e4:	89 04 24             	mov    %eax,(%esp)
  8028e7:	e8 fe 07 00 00       	call   8030ea <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8028ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8028f3:	00 
  8028f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8028fb:	00 
  8028fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802903:	e8 4e 08 00 00       	call   803156 <ipc_recv>
}
  802908:	83 c4 14             	add    $0x14,%esp
  80290b:	5b                   	pop    %ebx
  80290c:	5d                   	pop    %ebp
  80290d:	c3                   	ret    

0080290e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80291c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80291f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802924:	8b 45 10             	mov    0x10(%ebp),%eax
  802927:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80292c:	b8 09 00 00 00       	mov    $0x9,%eax
  802931:	e8 72 ff ff ff       	call   8028a8 <nsipc>
}
  802936:	c9                   	leave  
  802937:	c3                   	ret    

00802938 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802946:	8b 45 0c             	mov    0xc(%ebp),%eax
  802949:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80294e:	b8 06 00 00 00       	mov    $0x6,%eax
  802953:	e8 50 ff ff ff       	call   8028a8 <nsipc>
}
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
  80295d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802968:	b8 04 00 00 00       	mov    $0x4,%eax
  80296d:	e8 36 ff ff ff       	call   8028a8 <nsipc>
}
  802972:	c9                   	leave  
  802973:	c3                   	ret    

00802974 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802974:	55                   	push   %ebp
  802975:	89 e5                	mov    %esp,%ebp
  802977:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80297a:	8b 45 08             	mov    0x8(%ebp),%eax
  80297d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802982:	8b 45 0c             	mov    0xc(%ebp),%eax
  802985:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80298a:	b8 03 00 00 00       	mov    $0x3,%eax
  80298f:	e8 14 ff ff ff       	call   8028a8 <nsipc>
}
  802994:	c9                   	leave  
  802995:	c3                   	ret    

00802996 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
  802999:	53                   	push   %ebx
  80299a:	83 ec 14             	sub    $0x14,%esp
  80299d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8029a8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8029ae:	7e 24                	jle    8029d4 <nsipc_send+0x3e>
  8029b0:	c7 44 24 0c 79 3b 80 	movl   $0x803b79,0xc(%esp)
  8029b7:	00 
  8029b8:	c7 44 24 08 83 39 80 	movl   $0x803983,0x8(%esp)
  8029bf:	00 
  8029c0:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8029c7:	00 
  8029c8:	c7 04 24 85 3b 80 00 	movl   $0x803b85,(%esp)
  8029cf:	e8 4c d8 ff ff       	call   800220 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8029d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029df:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8029e6:	e8 f4 e0 ff ff       	call   800adf <memmove>
	nsipcbuf.send.req_size = size;
  8029eb:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8029f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8029f4:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8029f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8029fe:	e8 a5 fe ff ff       	call   8028a8 <nsipc>
}
  802a03:	83 c4 14             	add    $0x14,%esp
  802a06:	5b                   	pop    %ebx
  802a07:	5d                   	pop    %ebp
  802a08:	c3                   	ret    

00802a09 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802a09:	55                   	push   %ebp
  802a0a:	89 e5                	mov    %esp,%ebp
  802a0c:	56                   	push   %esi
  802a0d:	53                   	push   %ebx
  802a0e:	83 ec 10             	sub    $0x10,%esp
  802a11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  802a1c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802a22:	8b 45 14             	mov    0x14(%ebp),%eax
  802a25:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802a2a:	b8 07 00 00 00       	mov    $0x7,%eax
  802a2f:	e8 74 fe ff ff       	call   8028a8 <nsipc>
  802a34:	89 c3                	mov    %eax,%ebx
  802a36:	85 c0                	test   %eax,%eax
  802a38:	78 46                	js     802a80 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802a3a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802a3f:	7f 04                	jg     802a45 <nsipc_recv+0x3c>
  802a41:	39 c6                	cmp    %eax,%esi
  802a43:	7d 24                	jge    802a69 <nsipc_recv+0x60>
  802a45:	c7 44 24 0c 91 3b 80 	movl   $0x803b91,0xc(%esp)
  802a4c:	00 
  802a4d:	c7 44 24 08 83 39 80 	movl   $0x803983,0x8(%esp)
  802a54:	00 
  802a55:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  802a5c:	00 
  802a5d:	c7 04 24 85 3b 80 00 	movl   $0x803b85,(%esp)
  802a64:	e8 b7 d7 ff ff       	call   800220 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802a69:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a6d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802a74:	00 
  802a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a78:	89 04 24             	mov    %eax,(%esp)
  802a7b:	e8 5f e0 ff ff       	call   800adf <memmove>
	}

	return r;
}
  802a80:	89 d8                	mov    %ebx,%eax
  802a82:	83 c4 10             	add    $0x10,%esp
  802a85:	5b                   	pop    %ebx
  802a86:	5e                   	pop    %esi
  802a87:	5d                   	pop    %ebp
  802a88:	c3                   	ret    

00802a89 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	53                   	push   %ebx
  802a8d:	83 ec 14             	sub    $0x14,%esp
  802a90:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802a9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa6:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  802aad:	e8 2d e0 ff ff       	call   800adf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802ab2:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802ab8:	b8 05 00 00 00       	mov    $0x5,%eax
  802abd:	e8 e6 fd ff ff       	call   8028a8 <nsipc>
}
  802ac2:	83 c4 14             	add    $0x14,%esp
  802ac5:	5b                   	pop    %ebx
  802ac6:	5d                   	pop    %ebp
  802ac7:	c3                   	ret    

00802ac8 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802ac8:	55                   	push   %ebp
  802ac9:	89 e5                	mov    %esp,%ebp
  802acb:	53                   	push   %ebx
  802acc:	83 ec 14             	sub    $0x14,%esp
  802acf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802ada:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ae5:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  802aec:	e8 ee df ff ff       	call   800adf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802af1:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802af7:	b8 02 00 00 00       	mov    $0x2,%eax
  802afc:	e8 a7 fd ff ff       	call   8028a8 <nsipc>
}
  802b01:	83 c4 14             	add    $0x14,%esp
  802b04:	5b                   	pop    %ebx
  802b05:	5d                   	pop    %ebp
  802b06:	c3                   	ret    

00802b07 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b07:	55                   	push   %ebp
  802b08:	89 e5                	mov    %esp,%ebp
  802b0a:	83 ec 28             	sub    $0x28,%esp
  802b0d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b10:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b13:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802b16:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802b21:	8b 07                	mov    (%edi),%eax
  802b23:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802b28:	b8 01 00 00 00       	mov    $0x1,%eax
  802b2d:	e8 76 fd ff ff       	call   8028a8 <nsipc>
  802b32:	89 c6                	mov    %eax,%esi
  802b34:	85 c0                	test   %eax,%eax
  802b36:	78 22                	js     802b5a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802b38:	bb 10 80 80 00       	mov    $0x808010,%ebx
  802b3d:	8b 03                	mov    (%ebx),%eax
  802b3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b43:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802b4a:	00 
  802b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b4e:	89 04 24             	mov    %eax,(%esp)
  802b51:	e8 89 df ff ff       	call   800adf <memmove>
		*addrlen = ret->ret_addrlen;
  802b56:	8b 03                	mov    (%ebx),%eax
  802b58:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  802b5a:	89 f0                	mov    %esi,%eax
  802b5c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802b5f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802b62:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802b65:	89 ec                	mov    %ebp,%esp
  802b67:	5d                   	pop    %ebp
  802b68:	c3                   	ret    
  802b69:	00 00                	add    %al,(%eax)
	...

00802b6c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
  802b6f:	83 ec 18             	sub    $0x18,%esp
  802b72:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802b75:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802b78:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	89 04 24             	mov    %eax,(%esp)
  802b81:	e8 9e f1 ff ff       	call   801d24 <fd2data>
  802b86:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802b88:	c7 44 24 04 a6 3b 80 	movl   $0x803ba6,0x4(%esp)
  802b8f:	00 
  802b90:	89 34 24             	mov    %esi,(%esp)
  802b93:	e8 a1 dd ff ff       	call   800939 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802b98:	8b 43 04             	mov    0x4(%ebx),%eax
  802b9b:	2b 03                	sub    (%ebx),%eax
  802b9d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802ba3:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  802baa:	00 00 00 
	stat->st_dev = &devpipe;
  802bad:	c7 86 88 00 00 00 44 	movl   $0x804044,0x88(%esi)
  802bb4:	40 80 00 
	return 0;
}
  802bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802bbf:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802bc2:	89 ec                	mov    %ebp,%esp
  802bc4:	5d                   	pop    %ebp
  802bc5:	c3                   	ret    

00802bc6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
  802bc9:	53                   	push   %ebx
  802bca:	83 ec 14             	sub    $0x14,%esp
  802bcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802bd0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802bd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bdb:	e8 e2 e3 ff ff       	call   800fc2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802be0:	89 1c 24             	mov    %ebx,(%esp)
  802be3:	e8 3c f1 ff ff       	call   801d24 <fd2data>
  802be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bf3:	e8 ca e3 ff ff       	call   800fc2 <sys_page_unmap>
}
  802bf8:	83 c4 14             	add    $0x14,%esp
  802bfb:	5b                   	pop    %ebx
  802bfc:	5d                   	pop    %ebp
  802bfd:	c3                   	ret    

00802bfe <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802bfe:	55                   	push   %ebp
  802bff:	89 e5                	mov    %esp,%ebp
  802c01:	57                   	push   %edi
  802c02:	56                   	push   %esi
  802c03:	53                   	push   %ebx
  802c04:	83 ec 2c             	sub    $0x2c,%esp
  802c07:	89 c7                	mov    %eax,%edi
  802c09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c0c:	a1 08 50 80 00       	mov    0x805008,%eax
  802c11:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c14:	89 3c 24             	mov    %edi,(%esp)
  802c17:	e8 c4 05 00 00       	call   8031e0 <pageref>
  802c1c:	89 c6                	mov    %eax,%esi
  802c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c21:	89 04 24             	mov    %eax,(%esp)
  802c24:	e8 b7 05 00 00       	call   8031e0 <pageref>
  802c29:	39 c6                	cmp    %eax,%esi
  802c2b:	0f 94 c0             	sete   %al
  802c2e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802c31:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802c37:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802c3a:	39 cb                	cmp    %ecx,%ebx
  802c3c:	75 08                	jne    802c46 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802c3e:	83 c4 2c             	add    $0x2c,%esp
  802c41:	5b                   	pop    %ebx
  802c42:	5e                   	pop    %esi
  802c43:	5f                   	pop    %edi
  802c44:	5d                   	pop    %ebp
  802c45:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802c46:	83 f8 01             	cmp    $0x1,%eax
  802c49:	75 c1                	jne    802c0c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c4b:	8b 52 58             	mov    0x58(%edx),%edx
  802c4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c52:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c5a:	c7 04 24 ad 3b 80 00 	movl   $0x803bad,(%esp)
  802c61:	e8 73 d6 ff ff       	call   8002d9 <cprintf>
  802c66:	eb a4                	jmp    802c0c <_pipeisclosed+0xe>

00802c68 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c68:	55                   	push   %ebp
  802c69:	89 e5                	mov    %esp,%ebp
  802c6b:	57                   	push   %edi
  802c6c:	56                   	push   %esi
  802c6d:	53                   	push   %ebx
  802c6e:	83 ec 1c             	sub    $0x1c,%esp
  802c71:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802c74:	89 34 24             	mov    %esi,(%esp)
  802c77:	e8 a8 f0 ff ff       	call   801d24 <fd2data>
  802c7c:	89 c3                	mov    %eax,%ebx
  802c7e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c83:	eb 48                	jmp    802ccd <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802c85:	89 da                	mov    %ebx,%edx
  802c87:	89 f0                	mov    %esi,%eax
  802c89:	e8 70 ff ff ff       	call   802bfe <_pipeisclosed>
  802c8e:	85 c0                	test   %eax,%eax
  802c90:	74 07                	je     802c99 <devpipe_write+0x31>
  802c92:	b8 00 00 00 00       	mov    $0x0,%eax
  802c97:	eb 3b                	jmp    802cd4 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802c99:	e8 3f e4 ff ff       	call   8010dd <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802c9e:	8b 43 04             	mov    0x4(%ebx),%eax
  802ca1:	8b 13                	mov    (%ebx),%edx
  802ca3:	83 c2 20             	add    $0x20,%edx
  802ca6:	39 d0                	cmp    %edx,%eax
  802ca8:	73 db                	jae    802c85 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802caa:	89 c2                	mov    %eax,%edx
  802cac:	c1 fa 1f             	sar    $0x1f,%edx
  802caf:	c1 ea 1b             	shr    $0x1b,%edx
  802cb2:	01 d0                	add    %edx,%eax
  802cb4:	83 e0 1f             	and    $0x1f,%eax
  802cb7:	29 d0                	sub    %edx,%eax
  802cb9:	89 c2                	mov    %eax,%edx
  802cbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cbe:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802cc2:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802cc6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802cca:	83 c7 01             	add    $0x1,%edi
  802ccd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802cd0:	72 cc                	jb     802c9e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802cd2:	89 f8                	mov    %edi,%eax
}
  802cd4:	83 c4 1c             	add    $0x1c,%esp
  802cd7:	5b                   	pop    %ebx
  802cd8:	5e                   	pop    %esi
  802cd9:	5f                   	pop    %edi
  802cda:	5d                   	pop    %ebp
  802cdb:	c3                   	ret    

00802cdc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802cdc:	55                   	push   %ebp
  802cdd:	89 e5                	mov    %esp,%ebp
  802cdf:	83 ec 28             	sub    $0x28,%esp
  802ce2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802ce5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802ce8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802ceb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802cee:	89 3c 24             	mov    %edi,(%esp)
  802cf1:	e8 2e f0 ff ff       	call   801d24 <fd2data>
  802cf6:	89 c3                	mov    %eax,%ebx
  802cf8:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802cfd:	eb 48                	jmp    802d47 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802cff:	85 f6                	test   %esi,%esi
  802d01:	74 04                	je     802d07 <devpipe_read+0x2b>
				return i;
  802d03:	89 f0                	mov    %esi,%eax
  802d05:	eb 47                	jmp    802d4e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802d07:	89 da                	mov    %ebx,%edx
  802d09:	89 f8                	mov    %edi,%eax
  802d0b:	e8 ee fe ff ff       	call   802bfe <_pipeisclosed>
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 07                	je     802d1b <devpipe_read+0x3f>
  802d14:	b8 00 00 00 00       	mov    $0x0,%eax
  802d19:	eb 33                	jmp    802d4e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802d1b:	e8 bd e3 ff ff       	call   8010dd <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802d20:	8b 03                	mov    (%ebx),%eax
  802d22:	3b 43 04             	cmp    0x4(%ebx),%eax
  802d25:	74 d8                	je     802cff <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d27:	89 c2                	mov    %eax,%edx
  802d29:	c1 fa 1f             	sar    $0x1f,%edx
  802d2c:	c1 ea 1b             	shr    $0x1b,%edx
  802d2f:	01 d0                	add    %edx,%eax
  802d31:	83 e0 1f             	and    $0x1f,%eax
  802d34:	29 d0                	sub    %edx,%eax
  802d36:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3e:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802d41:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d44:	83 c6 01             	add    $0x1,%esi
  802d47:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d4a:	72 d4                	jb     802d20 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802d4c:	89 f0                	mov    %esi,%eax
}
  802d4e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802d51:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802d54:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802d57:	89 ec                	mov    %ebp,%esp
  802d59:	5d                   	pop    %ebp
  802d5a:	c3                   	ret    

00802d5b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802d5b:	55                   	push   %ebp
  802d5c:	89 e5                	mov    %esp,%ebp
  802d5e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	89 04 24             	mov    %eax,(%esp)
  802d6e:	e8 25 f0 ff ff       	call   801d98 <fd_lookup>
  802d73:	85 c0                	test   %eax,%eax
  802d75:	78 15                	js     802d8c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	89 04 24             	mov    %eax,(%esp)
  802d7d:	e8 a2 ef ff ff       	call   801d24 <fd2data>
	return _pipeisclosed(fd, p);
  802d82:	89 c2                	mov    %eax,%edx
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	e8 72 fe ff ff       	call   802bfe <_pipeisclosed>
}
  802d8c:	c9                   	leave  
  802d8d:	c3                   	ret    

00802d8e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d8e:	55                   	push   %ebp
  802d8f:	89 e5                	mov    %esp,%ebp
  802d91:	83 ec 48             	sub    $0x48,%esp
  802d94:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802d97:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802d9a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802d9d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802da0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802da3:	89 04 24             	mov    %eax,(%esp)
  802da6:	e8 94 ef ff ff       	call   801d3f <fd_alloc>
  802dab:	89 c3                	mov    %eax,%ebx
  802dad:	85 c0                	test   %eax,%eax
  802daf:	0f 88 42 01 00 00    	js     802ef7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802db5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802dbc:	00 
  802dbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dcb:	e8 ae e2 ff ff       	call   80107e <sys_page_alloc>
  802dd0:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802dd2:	85 c0                	test   %eax,%eax
  802dd4:	0f 88 1d 01 00 00    	js     802ef7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802dda:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802ddd:	89 04 24             	mov    %eax,(%esp)
  802de0:	e8 5a ef ff ff       	call   801d3f <fd_alloc>
  802de5:	89 c3                	mov    %eax,%ebx
  802de7:	85 c0                	test   %eax,%eax
  802de9:	0f 88 f5 00 00 00    	js     802ee4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802def:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802df6:	00 
  802df7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dfe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e05:	e8 74 e2 ff ff       	call   80107e <sys_page_alloc>
  802e0a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	0f 88 d0 00 00 00    	js     802ee4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e17:	89 04 24             	mov    %eax,(%esp)
  802e1a:	e8 05 ef ff ff       	call   801d24 <fd2data>
  802e1f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e21:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802e28:	00 
  802e29:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e34:	e8 45 e2 ff ff       	call   80107e <sys_page_alloc>
  802e39:	89 c3                	mov    %eax,%ebx
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	0f 88 8e 00 00 00    	js     802ed1 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e46:	89 04 24             	mov    %eax,(%esp)
  802e49:	e8 d6 ee ff ff       	call   801d24 <fd2data>
  802e4e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802e55:	00 
  802e56:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802e61:	00 
  802e62:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e6d:	e8 ae e1 ff ff       	call   801020 <sys_page_map>
  802e72:	89 c3                	mov    %eax,%ebx
  802e74:	85 c0                	test   %eax,%eax
  802e76:	78 49                	js     802ec1 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e78:	b8 44 40 80 00       	mov    $0x804044,%eax
  802e7d:	8b 08                	mov    (%eax),%ecx
  802e7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e82:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802e84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e87:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802e8e:	8b 10                	mov    (%eax),%edx
  802e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e93:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e98:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea2:	89 04 24             	mov    %eax,(%esp)
  802ea5:	e8 6a ee ff ff       	call   801d14 <fd2num>
  802eaa:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802eac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eaf:	89 04 24             	mov    %eax,(%esp)
  802eb2:	e8 5d ee ff ff       	call   801d14 <fd2num>
  802eb7:	89 47 04             	mov    %eax,0x4(%edi)
  802eba:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802ebf:	eb 36                	jmp    802ef7 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802ec1:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ec5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ecc:	e8 f1 e0 ff ff       	call   800fc2 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802ed1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ed8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802edf:	e8 de e0 ff ff       	call   800fc2 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eeb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ef2:	e8 cb e0 ff ff       	call   800fc2 <sys_page_unmap>
    err:
	return r;
}
  802ef7:	89 d8                	mov    %ebx,%eax
  802ef9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802efc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802eff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802f02:	89 ec                	mov    %ebp,%esp
  802f04:	5d                   	pop    %ebp
  802f05:	c3                   	ret    
	...

00802f10 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802f10:	55                   	push   %ebp
  802f11:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802f13:	b8 00 00 00 00       	mov    $0x0,%eax
  802f18:	5d                   	pop    %ebp
  802f19:	c3                   	ret    

00802f1a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802f1a:	55                   	push   %ebp
  802f1b:	89 e5                	mov    %esp,%ebp
  802f1d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802f20:	c7 44 24 04 c5 3b 80 	movl   $0x803bc5,0x4(%esp)
  802f27:	00 
  802f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2b:	89 04 24             	mov    %eax,(%esp)
  802f2e:	e8 06 da ff ff       	call   800939 <strcpy>
	return 0;
}
  802f33:	b8 00 00 00 00       	mov    $0x0,%eax
  802f38:	c9                   	leave  
  802f39:	c3                   	ret    

00802f3a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f3a:	55                   	push   %ebp
  802f3b:	89 e5                	mov    %esp,%ebp
  802f3d:	57                   	push   %edi
  802f3e:	56                   	push   %esi
  802f3f:	53                   	push   %ebx
  802f40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802f46:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802f4b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f51:	eb 34                	jmp    802f87 <devcons_write+0x4d>
		m = n - tot;
  802f53:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802f56:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802f58:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  802f5e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802f63:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802f66:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f6a:	03 45 0c             	add    0xc(%ebp),%eax
  802f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f71:	89 3c 24             	mov    %edi,(%esp)
  802f74:	e8 66 db ff ff       	call   800adf <memmove>
		sys_cputs(buf, m);
  802f79:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f7d:	89 3c 24             	mov    %edi,(%esp)
  802f80:	e8 6b dd ff ff       	call   800cf0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f85:	01 de                	add    %ebx,%esi
  802f87:	89 f0                	mov    %esi,%eax
  802f89:	3b 75 10             	cmp    0x10(%ebp),%esi
  802f8c:	72 c5                	jb     802f53 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802f8e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802f94:	5b                   	pop    %ebx
  802f95:	5e                   	pop    %esi
  802f96:	5f                   	pop    %edi
  802f97:	5d                   	pop    %ebp
  802f98:	c3                   	ret    

00802f99 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802f99:	55                   	push   %ebp
  802f9a:	89 e5                	mov    %esp,%ebp
  802f9c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802fa5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802fac:	00 
  802fad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802fb0:	89 04 24             	mov    %eax,(%esp)
  802fb3:	e8 38 dd ff ff       	call   800cf0 <sys_cputs>
}
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
  802fbd:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fc4:	75 07                	jne    802fcd <devcons_read+0x13>
  802fc6:	eb 28                	jmp    802ff0 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802fc8:	e8 10 e1 ff ff       	call   8010dd <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802fcd:	8d 76 00             	lea    0x0(%esi),%esi
  802fd0:	e8 e7 dc ff ff       	call   800cbc <sys_cgetc>
  802fd5:	85 c0                	test   %eax,%eax
  802fd7:	74 ef                	je     802fc8 <devcons_read+0xe>
  802fd9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	78 16                	js     802ff5 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802fdf:	83 f8 04             	cmp    $0x4,%eax
  802fe2:	74 0c                	je     802ff0 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe7:	88 10                	mov    %dl,(%eax)
  802fe9:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802fee:	eb 05                	jmp    802ff5 <devcons_read+0x3b>
  802ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff5:	c9                   	leave  
  802ff6:	c3                   	ret    

00802ff7 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802ff7:	55                   	push   %ebp
  802ff8:	89 e5                	mov    %esp,%ebp
  802ffa:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ffd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803000:	89 04 24             	mov    %eax,(%esp)
  803003:	e8 37 ed ff ff       	call   801d3f <fd_alloc>
  803008:	85 c0                	test   %eax,%eax
  80300a:	78 3f                	js     80304b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80300c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803013:	00 
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	89 44 24 04          	mov    %eax,0x4(%esp)
  80301b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803022:	e8 57 e0 ff ff       	call   80107e <sys_page_alloc>
  803027:	85 c0                	test   %eax,%eax
  803029:	78 20                	js     80304b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80302b:	8b 15 60 40 80 00    	mov    0x804060,%edx
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	89 04 24             	mov    %eax,(%esp)
  803046:	e8 c9 ec ff ff       	call   801d14 <fd2num>
}
  80304b:	c9                   	leave  
  80304c:	c3                   	ret    

0080304d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80304d:	55                   	push   %ebp
  80304e:	89 e5                	mov    %esp,%ebp
  803050:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803053:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803056:	89 44 24 04          	mov    %eax,0x4(%esp)
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	89 04 24             	mov    %eax,(%esp)
  803060:	e8 33 ed ff ff       	call   801d98 <fd_lookup>
  803065:	85 c0                	test   %eax,%eax
  803067:	78 11                	js     80307a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  803069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306c:	8b 00                	mov    (%eax),%eax
  80306e:	3b 05 60 40 80 00    	cmp    0x804060,%eax
  803074:	0f 94 c0             	sete   %al
  803077:	0f b6 c0             	movzbl %al,%eax
}
  80307a:	c9                   	leave  
  80307b:	c3                   	ret    

0080307c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  80307c:	55                   	push   %ebp
  80307d:	89 e5                	mov    %esp,%ebp
  80307f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803082:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803089:	00 
  80308a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80308d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803091:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803098:	e8 52 ef ff ff       	call   801fef <read>
	if (r < 0)
  80309d:	85 c0                	test   %eax,%eax
  80309f:	78 0f                	js     8030b0 <getchar+0x34>
		return r;
	if (r < 1)
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	7f 07                	jg     8030ac <getchar+0x30>
  8030a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8030aa:	eb 04                	jmp    8030b0 <getchar+0x34>
		return -E_EOF;
	return c;
  8030ac:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8030b0:	c9                   	leave  
  8030b1:	c3                   	ret    
	...

008030b4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8030b4:	55                   	push   %ebp
  8030b5:	89 e5                	mov    %esp,%ebp
  8030b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8030ba:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8030bf:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8030c2:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  8030c8:	8b 12                	mov    (%edx),%edx
  8030ca:	39 ca                	cmp    %ecx,%edx
  8030cc:	75 0c                	jne    8030da <ipc_find_env+0x26>
			return envs[i].env_id;
  8030ce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8030d1:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	eb 0e                	jmp    8030e8 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8030da:	83 c0 01             	add    $0x1,%eax
  8030dd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8030e2:	75 db                	jne    8030bf <ipc_find_env+0xb>
  8030e4:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8030e8:	5d                   	pop    %ebp
  8030e9:	c3                   	ret    

008030ea <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8030ea:	55                   	push   %ebp
  8030eb:	89 e5                	mov    %esp,%ebp
  8030ed:	57                   	push   %edi
  8030ee:	56                   	push   %esi
  8030ef:	53                   	push   %ebx
  8030f0:	83 ec 2c             	sub    $0x2c,%esp
  8030f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8030f6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8030f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  8030fc:	85 db                	test   %ebx,%ebx
  8030fe:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  803103:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  803106:	8b 45 14             	mov    0x14(%ebp),%eax
  803109:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80310d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803111:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803115:	89 34 24             	mov    %esi,(%esp)
  803118:	e8 53 dd ff ff       	call   800e70 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  80311d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803120:	74 e4                	je     803106 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  803122:	85 c0                	test   %eax,%eax
  803124:	74 28                	je     80314e <ipc_send+0x64>
  803126:	89 44 24 10          	mov    %eax,0x10(%esp)
  80312a:	c7 44 24 0c ee 3b 80 	movl   $0x803bee,0xc(%esp)
  803131:	00 
  803132:	c7 44 24 08 d1 3b 80 	movl   $0x803bd1,0x8(%esp)
  803139:	00 
  80313a:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  803141:	00 
  803142:	c7 04 24 e4 3b 80 00 	movl   $0x803be4,(%esp)
  803149:	e8 d2 d0 ff ff       	call   800220 <_panic>
	//if(!ret) sys_yield();
}
  80314e:	83 c4 2c             	add    $0x2c,%esp
  803151:	5b                   	pop    %ebx
  803152:	5e                   	pop    %esi
  803153:	5f                   	pop    %edi
  803154:	5d                   	pop    %ebp
  803155:	c3                   	ret    

00803156 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
  803159:	83 ec 28             	sub    $0x28,%esp
  80315c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80315f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803162:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803165:	8b 75 08             	mov    0x8(%ebp),%esi
  803168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316b:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  80316e:	85 c0                	test   %eax,%eax
  803170:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803175:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803178:	89 04 24             	mov    %eax,(%esp)
  80317b:	e8 93 dc ff ff       	call   800e13 <sys_ipc_recv>
  803180:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  803182:	e8 8a df ff ff       	call   801111 <sys_getenvid>
  803187:	25 ff 03 00 00       	and    $0x3ff,%eax
  80318c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80318f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803194:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  803199:	85 f6                	test   %esi,%esi
  80319b:	74 0e                	je     8031ab <ipc_recv+0x55>
  80319d:	ba 00 00 00 00       	mov    $0x0,%edx
  8031a2:	85 db                	test   %ebx,%ebx
  8031a4:	75 03                	jne    8031a9 <ipc_recv+0x53>
  8031a6:	8b 50 74             	mov    0x74(%eax),%edx
  8031a9:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  8031ab:	85 ff                	test   %edi,%edi
  8031ad:	74 13                	je     8031c2 <ipc_recv+0x6c>
  8031af:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b4:	85 db                	test   %ebx,%ebx
  8031b6:	75 08                	jne    8031c0 <ipc_recv+0x6a>
  8031b8:	a1 08 50 80 00       	mov    0x805008,%eax
  8031bd:	8b 40 78             	mov    0x78(%eax),%eax
  8031c0:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  8031c2:	85 db                	test   %ebx,%ebx
  8031c4:	75 08                	jne    8031ce <ipc_recv+0x78>
  8031c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8031cb:	8b 58 70             	mov    0x70(%eax),%ebx
}
  8031ce:	89 d8                	mov    %ebx,%eax
  8031d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8031d3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8031d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8031d9:	89 ec                	mov    %ebp,%esp
  8031db:	5d                   	pop    %ebp
  8031dc:	c3                   	ret    
  8031dd:	00 00                	add    %al,(%eax)
	...

008031e0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8031e0:	55                   	push   %ebp
  8031e1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	89 c2                	mov    %eax,%edx
  8031e8:	c1 ea 16             	shr    $0x16,%edx
  8031eb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8031f2:	f6 c2 01             	test   $0x1,%dl
  8031f5:	74 20                	je     803217 <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  8031f7:	c1 e8 0c             	shr    $0xc,%eax
  8031fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803201:	a8 01                	test   $0x1,%al
  803203:	74 12                	je     803217 <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803205:	c1 e8 0c             	shr    $0xc,%eax
  803208:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  80320d:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  803212:	0f b7 c0             	movzwl %ax,%eax
  803215:	eb 05                	jmp    80321c <pageref+0x3c>
  803217:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80321c:	5d                   	pop    %ebp
  80321d:	c3                   	ret    
	...

00803220 <__udivdi3>:
  803220:	55                   	push   %ebp
  803221:	89 e5                	mov    %esp,%ebp
  803223:	57                   	push   %edi
  803224:	56                   	push   %esi
  803225:	83 ec 10             	sub    $0x10,%esp
  803228:	8b 45 14             	mov    0x14(%ebp),%eax
  80322b:	8b 55 08             	mov    0x8(%ebp),%edx
  80322e:	8b 75 10             	mov    0x10(%ebp),%esi
  803231:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803234:	85 c0                	test   %eax,%eax
  803236:	89 55 f0             	mov    %edx,-0x10(%ebp)
  803239:	75 35                	jne    803270 <__udivdi3+0x50>
  80323b:	39 fe                	cmp    %edi,%esi
  80323d:	77 61                	ja     8032a0 <__udivdi3+0x80>
  80323f:	85 f6                	test   %esi,%esi
  803241:	75 0b                	jne    80324e <__udivdi3+0x2e>
  803243:	b8 01 00 00 00       	mov    $0x1,%eax
  803248:	31 d2                	xor    %edx,%edx
  80324a:	f7 f6                	div    %esi
  80324c:	89 c6                	mov    %eax,%esi
  80324e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803251:	31 d2                	xor    %edx,%edx
  803253:	89 f8                	mov    %edi,%eax
  803255:	f7 f6                	div    %esi
  803257:	89 c7                	mov    %eax,%edi
  803259:	89 c8                	mov    %ecx,%eax
  80325b:	f7 f6                	div    %esi
  80325d:	89 c1                	mov    %eax,%ecx
  80325f:	89 fa                	mov    %edi,%edx
  803261:	89 c8                	mov    %ecx,%eax
  803263:	83 c4 10             	add    $0x10,%esp
  803266:	5e                   	pop    %esi
  803267:	5f                   	pop    %edi
  803268:	5d                   	pop    %ebp
  803269:	c3                   	ret    
  80326a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803270:	39 f8                	cmp    %edi,%eax
  803272:	77 1c                	ja     803290 <__udivdi3+0x70>
  803274:	0f bd d0             	bsr    %eax,%edx
  803277:	83 f2 1f             	xor    $0x1f,%edx
  80327a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80327d:	75 39                	jne    8032b8 <__udivdi3+0x98>
  80327f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803282:	0f 86 a0 00 00 00    	jbe    803328 <__udivdi3+0x108>
  803288:	39 f8                	cmp    %edi,%eax
  80328a:	0f 82 98 00 00 00    	jb     803328 <__udivdi3+0x108>
  803290:	31 ff                	xor    %edi,%edi
  803292:	31 c9                	xor    %ecx,%ecx
  803294:	89 c8                	mov    %ecx,%eax
  803296:	89 fa                	mov    %edi,%edx
  803298:	83 c4 10             	add    $0x10,%esp
  80329b:	5e                   	pop    %esi
  80329c:	5f                   	pop    %edi
  80329d:	5d                   	pop    %ebp
  80329e:	c3                   	ret    
  80329f:	90                   	nop
  8032a0:	89 d1                	mov    %edx,%ecx
  8032a2:	89 fa                	mov    %edi,%edx
  8032a4:	89 c8                	mov    %ecx,%eax
  8032a6:	31 ff                	xor    %edi,%edi
  8032a8:	f7 f6                	div    %esi
  8032aa:	89 c1                	mov    %eax,%ecx
  8032ac:	89 fa                	mov    %edi,%edx
  8032ae:	89 c8                	mov    %ecx,%eax
  8032b0:	83 c4 10             	add    $0x10,%esp
  8032b3:	5e                   	pop    %esi
  8032b4:	5f                   	pop    %edi
  8032b5:	5d                   	pop    %ebp
  8032b6:	c3                   	ret    
  8032b7:	90                   	nop
  8032b8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8032bc:	89 f2                	mov    %esi,%edx
  8032be:	d3 e0                	shl    %cl,%eax
  8032c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8032c3:	b8 20 00 00 00       	mov    $0x20,%eax
  8032c8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8032cb:	89 c1                	mov    %eax,%ecx
  8032cd:	d3 ea                	shr    %cl,%edx
  8032cf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8032d3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8032d6:	d3 e6                	shl    %cl,%esi
  8032d8:	89 c1                	mov    %eax,%ecx
  8032da:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8032dd:	89 fe                	mov    %edi,%esi
  8032df:	d3 ee                	shr    %cl,%esi
  8032e1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8032e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8032e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032eb:	d3 e7                	shl    %cl,%edi
  8032ed:	89 c1                	mov    %eax,%ecx
  8032ef:	d3 ea                	shr    %cl,%edx
  8032f1:	09 d7                	or     %edx,%edi
  8032f3:	89 f2                	mov    %esi,%edx
  8032f5:	89 f8                	mov    %edi,%eax
  8032f7:	f7 75 ec             	divl   -0x14(%ebp)
  8032fa:	89 d6                	mov    %edx,%esi
  8032fc:	89 c7                	mov    %eax,%edi
  8032fe:	f7 65 e8             	mull   -0x18(%ebp)
  803301:	39 d6                	cmp    %edx,%esi
  803303:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803306:	72 30                	jb     803338 <__udivdi3+0x118>
  803308:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80330b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80330f:	d3 e2                	shl    %cl,%edx
  803311:	39 c2                	cmp    %eax,%edx
  803313:	73 05                	jae    80331a <__udivdi3+0xfa>
  803315:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  803318:	74 1e                	je     803338 <__udivdi3+0x118>
  80331a:	89 f9                	mov    %edi,%ecx
  80331c:	31 ff                	xor    %edi,%edi
  80331e:	e9 71 ff ff ff       	jmp    803294 <__udivdi3+0x74>
  803323:	90                   	nop
  803324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803328:	31 ff                	xor    %edi,%edi
  80332a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80332f:	e9 60 ff ff ff       	jmp    803294 <__udivdi3+0x74>
  803334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803338:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80333b:	31 ff                	xor    %edi,%edi
  80333d:	89 c8                	mov    %ecx,%eax
  80333f:	89 fa                	mov    %edi,%edx
  803341:	83 c4 10             	add    $0x10,%esp
  803344:	5e                   	pop    %esi
  803345:	5f                   	pop    %edi
  803346:	5d                   	pop    %ebp
  803347:	c3                   	ret    
	...

00803350 <__umoddi3>:
  803350:	55                   	push   %ebp
  803351:	89 e5                	mov    %esp,%ebp
  803353:	57                   	push   %edi
  803354:	56                   	push   %esi
  803355:	83 ec 20             	sub    $0x20,%esp
  803358:	8b 55 14             	mov    0x14(%ebp),%edx
  80335b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80335e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803361:	8b 75 0c             	mov    0xc(%ebp),%esi
  803364:	85 d2                	test   %edx,%edx
  803366:	89 c8                	mov    %ecx,%eax
  803368:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80336b:	75 13                	jne    803380 <__umoddi3+0x30>
  80336d:	39 f7                	cmp    %esi,%edi
  80336f:	76 3f                	jbe    8033b0 <__umoddi3+0x60>
  803371:	89 f2                	mov    %esi,%edx
  803373:	f7 f7                	div    %edi
  803375:	89 d0                	mov    %edx,%eax
  803377:	31 d2                	xor    %edx,%edx
  803379:	83 c4 20             	add    $0x20,%esp
  80337c:	5e                   	pop    %esi
  80337d:	5f                   	pop    %edi
  80337e:	5d                   	pop    %ebp
  80337f:	c3                   	ret    
  803380:	39 f2                	cmp    %esi,%edx
  803382:	77 4c                	ja     8033d0 <__umoddi3+0x80>
  803384:	0f bd ca             	bsr    %edx,%ecx
  803387:	83 f1 1f             	xor    $0x1f,%ecx
  80338a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80338d:	75 51                	jne    8033e0 <__umoddi3+0x90>
  80338f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  803392:	0f 87 e0 00 00 00    	ja     803478 <__umoddi3+0x128>
  803398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339b:	29 f8                	sub    %edi,%eax
  80339d:	19 d6                	sbb    %edx,%esi
  80339f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	89 f2                	mov    %esi,%edx
  8033a7:	83 c4 20             	add    $0x20,%esp
  8033aa:	5e                   	pop    %esi
  8033ab:	5f                   	pop    %edi
  8033ac:	5d                   	pop    %ebp
  8033ad:	c3                   	ret    
  8033ae:	66 90                	xchg   %ax,%ax
  8033b0:	85 ff                	test   %edi,%edi
  8033b2:	75 0b                	jne    8033bf <__umoddi3+0x6f>
  8033b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8033b9:	31 d2                	xor    %edx,%edx
  8033bb:	f7 f7                	div    %edi
  8033bd:	89 c7                	mov    %eax,%edi
  8033bf:	89 f0                	mov    %esi,%eax
  8033c1:	31 d2                	xor    %edx,%edx
  8033c3:	f7 f7                	div    %edi
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	f7 f7                	div    %edi
  8033ca:	eb a9                	jmp    803375 <__umoddi3+0x25>
  8033cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8033d0:	89 c8                	mov    %ecx,%eax
  8033d2:	89 f2                	mov    %esi,%edx
  8033d4:	83 c4 20             	add    $0x20,%esp
  8033d7:	5e                   	pop    %esi
  8033d8:	5f                   	pop    %edi
  8033d9:	5d                   	pop    %ebp
  8033da:	c3                   	ret    
  8033db:	90                   	nop
  8033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8033e0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8033e4:	d3 e2                	shl    %cl,%edx
  8033e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8033e9:	ba 20 00 00 00       	mov    $0x20,%edx
  8033ee:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8033f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8033f4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8033f8:	89 fa                	mov    %edi,%edx
  8033fa:	d3 ea                	shr    %cl,%edx
  8033fc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803400:	0b 55 f4             	or     -0xc(%ebp),%edx
  803403:	d3 e7                	shl    %cl,%edi
  803405:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803409:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80340c:	89 f2                	mov    %esi,%edx
  80340e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  803411:	89 c7                	mov    %eax,%edi
  803413:	d3 ea                	shr    %cl,%edx
  803415:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803419:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80341c:	89 c2                	mov    %eax,%edx
  80341e:	d3 e6                	shl    %cl,%esi
  803420:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803424:	d3 ea                	shr    %cl,%edx
  803426:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80342a:	09 d6                	or     %edx,%esi
  80342c:	89 f0                	mov    %esi,%eax
  80342e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803431:	d3 e7                	shl    %cl,%edi
  803433:	89 f2                	mov    %esi,%edx
  803435:	f7 75 f4             	divl   -0xc(%ebp)
  803438:	89 d6                	mov    %edx,%esi
  80343a:	f7 65 e8             	mull   -0x18(%ebp)
  80343d:	39 d6                	cmp    %edx,%esi
  80343f:	72 2b                	jb     80346c <__umoddi3+0x11c>
  803441:	39 c7                	cmp    %eax,%edi
  803443:	72 23                	jb     803468 <__umoddi3+0x118>
  803445:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803449:	29 c7                	sub    %eax,%edi
  80344b:	19 d6                	sbb    %edx,%esi
  80344d:	89 f0                	mov    %esi,%eax
  80344f:	89 f2                	mov    %esi,%edx
  803451:	d3 ef                	shr    %cl,%edi
  803453:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803457:	d3 e0                	shl    %cl,%eax
  803459:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80345d:	09 f8                	or     %edi,%eax
  80345f:	d3 ea                	shr    %cl,%edx
  803461:	83 c4 20             	add    $0x20,%esp
  803464:	5e                   	pop    %esi
  803465:	5f                   	pop    %edi
  803466:	5d                   	pop    %ebp
  803467:	c3                   	ret    
  803468:	39 d6                	cmp    %edx,%esi
  80346a:	75 d9                	jne    803445 <__umoddi3+0xf5>
  80346c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80346f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803472:	eb d1                	jmp    803445 <__umoddi3+0xf5>
  803474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803478:	39 f2                	cmp    %esi,%edx
  80347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803480:	0f 82 12 ff ff ff    	jb     803398 <__umoddi3+0x48>
  803486:	e9 17 ff ff ff       	jmp    8033a2 <__umoddi3+0x52>
