
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 eb 01 00 00       	call   80021c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800044:	00 
  800045:	c7 04 24 40 2e 80 00 	movl   $0x802e40,(%esp)
  80004c:	e8 22 1e 00 00       	call   801e73 <open>
  800051:	89 c3                	mov    %eax,%ebx
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("open motd: %e", fd);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 45 2e 80 	movl   $0x802e45,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 53 2e 80 00 	movl   $0x802e53,(%esp)
  800072:	e8 09 02 00 00       	call   800280 <_panic>
	seek(fd, 0);
  800077:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007e:	00 
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 01 16 00 00       	call   801688 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800087:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 20 52 80 	movl   $0x805220,0x4(%esp)
  800096:	00 
  800097:	89 1c 24             	mov    %ebx,(%esp)
  80009a:	e8 86 18 00 00       	call   801925 <readn>
  80009f:	89 c7                	mov    %eax,%edi
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	7f 20                	jg     8000c5 <umain+0x91>
		panic("readn: %e", n);
  8000a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a9:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  8000b0:	00 
  8000b1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b8:	00 
  8000b9:	c7 04 24 53 2e 80 00 	movl   $0x802e53,(%esp)
  8000c0:	e8 bb 01 00 00       	call   800280 <_panic>

	if ((r = fork()) < 0)
  8000c5:	e8 5c 11 00 00       	call   801226 <fork>
  8000ca:	89 c6                	mov    %eax,%esi
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	79 20                	jns    8000f0 <umain+0xbc>
		panic("fork: %e", r);
  8000d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d4:	c7 44 24 08 fa 32 80 	movl   $0x8032fa,0x8(%esp)
  8000db:	00 
  8000dc:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e3:	00 
  8000e4:	c7 04 24 53 2e 80 00 	movl   $0x802e53,(%esp)
  8000eb:	e8 90 01 00 00       	call   800280 <_panic>
	if (r == 0) {
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	0f 85 bd 00 00 00    	jne    8001b5 <umain+0x181>
		seek(fd, 0);
  8000f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ff:	00 
  800100:	89 1c 24             	mov    %ebx,(%esp)
  800103:	e8 80 15 00 00       	call   801688 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800108:	c7 04 24 a8 2e 80 00 	movl   $0x802ea8,(%esp)
  80010f:	e8 25 02 00 00       	call   800339 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800114:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011b:	00 
  80011c:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  800123:	00 
  800124:	89 1c 24             	mov    %ebx,(%esp)
  800127:	e8 f9 17 00 00       	call   801925 <readn>
  80012c:	39 c7                	cmp    %eax,%edi
  80012e:	74 24                	je     800154 <umain+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  800130:	89 44 24 10          	mov    %eax,0x10(%esp)
  800134:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800138:	c7 44 24 08 ec 2e 80 	movl   $0x802eec,0x8(%esp)
  80013f:	00 
  800140:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800147:	00 
  800148:	c7 04 24 53 2e 80 00 	movl   $0x802e53,(%esp)
  80014f:	e8 2c 01 00 00       	call   800280 <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800154:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800158:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  80015f:	00 
  800160:	c7 04 24 20 52 80 00 	movl   $0x805220,(%esp)
  800167:	e8 70 0a 00 00       	call   800bdc <memcmp>
  80016c:	85 c0                	test   %eax,%eax
  80016e:	74 1c                	je     80018c <umain+0x158>
			panic("read in parent got different bytes from read in child");
  800170:	c7 44 24 08 18 2f 80 	movl   $0x802f18,0x8(%esp)
  800177:	00 
  800178:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017f:	00 
  800180:	c7 04 24 53 2e 80 00 	movl   $0x802e53,(%esp)
  800187:	e8 f4 00 00 00       	call   800280 <_panic>
		cprintf("read in child succeeded\n");
  80018c:	c7 04 24 72 2e 80 00 	movl   $0x802e72,(%esp)
  800193:	e8 a1 01 00 00       	call   800339 <cprintf>
		seek(fd, 0);
  800198:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019f:	00 
  8001a0:	89 1c 24             	mov    %ebx,(%esp)
  8001a3:	e8 e0 14 00 00       	call   801688 <seek>
		close(fd);
  8001a8:	89 1c 24             	mov    %ebx,(%esp)
  8001ab:	e8 4e 18 00 00       	call   8019fe <close>
		exit();
  8001b0:	e8 b7 00 00 00       	call   80026c <exit>
	}
	wait(r);
  8001b5:	89 34 24             	mov    %esi,(%esp)
  8001b8:	e8 eb 25 00 00       	call   8027a8 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c4:	00 
  8001c5:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  8001cc:	00 
  8001cd:	89 1c 24             	mov    %ebx,(%esp)
  8001d0:	e8 50 17 00 00       	call   801925 <readn>
  8001d5:	39 c7                	cmp    %eax,%edi
  8001d7:	74 24                	je     8001fd <umain+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e1:	c7 44 24 08 50 2f 80 	movl   $0x802f50,0x8(%esp)
  8001e8:	00 
  8001e9:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001f0:	00 
  8001f1:	c7 04 24 53 2e 80 00 	movl   $0x802e53,(%esp)
  8001f8:	e8 83 00 00 00       	call   800280 <_panic>
	cprintf("read in parent succeeded\n");
  8001fd:	c7 04 24 8b 2e 80 00 	movl   $0x802e8b,(%esp)
  800204:	e8 30 01 00 00       	call   800339 <cprintf>
	close(fd);
  800209:	89 1c 24             	mov    %ebx,(%esp)
  80020c:	e8 ed 17 00 00       	call   8019fe <close>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800211:	cc                   	int3   

	breakpoint();
}
  800212:	83 c4 2c             	add    $0x2c,%esp
  800215:	5b                   	pop    %ebx
  800216:	5e                   	pop    %esi
  800217:	5f                   	pop    %edi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    
	...

0080021c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 18             	sub    $0x18,%esp
  800222:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800225:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800228:	8b 75 08             	mov    0x8(%ebp),%esi
  80022b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80022e:	e8 3e 0f 00 00       	call   801171 <sys_getenvid>
  800233:	25 ff 03 00 00       	and    $0x3ff,%eax
  800238:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80023b:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800240:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800245:	85 f6                	test   %esi,%esi
  800247:	7e 07                	jle    800250 <libmain+0x34>
		binaryname = argv[0];
  800249:	8b 03                	mov    (%ebx),%eax
  80024b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800250:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800254:	89 34 24             	mov    %esi,(%esp)
  800257:	e8 d8 fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80025c:	e8 0b 00 00 00       	call   80026c <exit>
}
  800261:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800264:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800267:	89 ec                	mov    %ebp,%esp
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
	...

0080026c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800272:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800279:	e8 27 0f 00 00       	call   8011a5 <sys_env_destroy>
}
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	56                   	push   %esi
  800284:	53                   	push   %ebx
  800285:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800288:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80028b:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  800291:	e8 db 0e 00 00       	call   801171 <sys_getenvid>
  800296:	8b 55 0c             	mov    0xc(%ebp),%edx
  800299:	89 54 24 10          	mov    %edx,0x10(%esp)
  80029d:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ac:	c7 04 24 80 2f 80 00 	movl   $0x802f80,(%esp)
  8002b3:	e8 81 00 00 00       	call   800339 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bf:	89 04 24             	mov    %eax,(%esp)
  8002c2:	e8 11 00 00 00       	call   8002d8 <vcprintf>
	cprintf("\n");
  8002c7:	c7 04 24 50 35 80 00 	movl   $0x803550,(%esp)
  8002ce:	e8 66 00 00 00       	call   800339 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d3:	cc                   	int3   
  8002d4:	eb fd                	jmp    8002d3 <_panic+0x53>
	...

008002d8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e8:	00 00 00 
	b.cnt = 0;
  8002eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800303:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030d:	c7 04 24 53 03 80 00 	movl   $0x800353,(%esp)
  800314:	e8 be 01 00 00       	call   8004d7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800319:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80031f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800323:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800329:	89 04 24             	mov    %eax,(%esp)
  80032c:	e8 1f 0a 00 00       	call   800d50 <sys_cputs>

	return b.cnt;
}
  800331:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80033f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800342:	89 44 24 04          	mov    %eax,0x4(%esp)
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	89 04 24             	mov    %eax,(%esp)
  80034c:	e8 87 ff ff ff       	call   8002d8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800351:	c9                   	leave  
  800352:	c3                   	ret    

00800353 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	53                   	push   %ebx
  800357:	83 ec 14             	sub    $0x14,%esp
  80035a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80035d:	8b 03                	mov    (%ebx),%eax
  80035f:	8b 55 08             	mov    0x8(%ebp),%edx
  800362:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800366:	83 c0 01             	add    $0x1,%eax
  800369:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80036b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800370:	75 19                	jne    80038b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800372:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800379:	00 
  80037a:	8d 43 08             	lea    0x8(%ebx),%eax
  80037d:	89 04 24             	mov    %eax,(%esp)
  800380:	e8 cb 09 00 00       	call   800d50 <sys_cputs>
		b->idx = 0;
  800385:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80038b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80038f:	83 c4 14             	add    $0x14,%esp
  800392:	5b                   	pop    %ebx
  800393:	5d                   	pop    %ebp
  800394:	c3                   	ret    
  800395:	00 00                	add    %al,(%eax)
	...

00800398 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	57                   	push   %edi
  80039c:	56                   	push   %esi
  80039d:	53                   	push   %ebx
  80039e:	83 ec 4c             	sub    $0x4c,%esp
  8003a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a4:	89 d6                	mov    %edx,%esi
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003af:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8003b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003b8:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c3:	39 d1                	cmp    %edx,%ecx
  8003c5:	72 07                	jb     8003ce <printnum+0x36>
  8003c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003ca:	39 d0                	cmp    %edx,%eax
  8003cc:	77 69                	ja     800437 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ce:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003d2:	83 eb 01             	sub    $0x1,%ebx
  8003d5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8003e1:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8003e5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003e8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8003eb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003ee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003f2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003f9:	00 
  8003fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fd:	89 04 24             	mov    %eax,(%esp)
  800400:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800403:	89 54 24 04          	mov    %edx,0x4(%esp)
  800407:	e8 c4 27 00 00       	call   802bd0 <__udivdi3>
  80040c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80040f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800412:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800416:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80041a:	89 04 24             	mov    %eax,(%esp)
  80041d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800421:	89 f2                	mov    %esi,%edx
  800423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800426:	e8 6d ff ff ff       	call   800398 <printnum>
  80042b:	eb 11                	jmp    80043e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80042d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800431:	89 3c 24             	mov    %edi,(%esp)
  800434:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800437:	83 eb 01             	sub    $0x1,%ebx
  80043a:	85 db                	test   %ebx,%ebx
  80043c:	7f ef                	jg     80042d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80043e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800442:	8b 74 24 04          	mov    0x4(%esp),%esi
  800446:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800449:	89 44 24 08          	mov    %eax,0x8(%esp)
  80044d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800454:	00 
  800455:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800458:	89 14 24             	mov    %edx,(%esp)
  80045b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800462:	e8 99 28 00 00       	call   802d00 <__umoddi3>
  800467:	89 74 24 04          	mov    %esi,0x4(%esp)
  80046b:	0f be 80 a3 2f 80 00 	movsbl 0x802fa3(%eax),%eax
  800472:	89 04 24             	mov    %eax,(%esp)
  800475:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800478:	83 c4 4c             	add    $0x4c,%esp
  80047b:	5b                   	pop    %ebx
  80047c:	5e                   	pop    %esi
  80047d:	5f                   	pop    %edi
  80047e:	5d                   	pop    %ebp
  80047f:	c3                   	ret    

00800480 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800483:	83 fa 01             	cmp    $0x1,%edx
  800486:	7e 0e                	jle    800496 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800488:	8b 10                	mov    (%eax),%edx
  80048a:	8d 4a 08             	lea    0x8(%edx),%ecx
  80048d:	89 08                	mov    %ecx,(%eax)
  80048f:	8b 02                	mov    (%edx),%eax
  800491:	8b 52 04             	mov    0x4(%edx),%edx
  800494:	eb 22                	jmp    8004b8 <getuint+0x38>
	else if (lflag)
  800496:	85 d2                	test   %edx,%edx
  800498:	74 10                	je     8004aa <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80049a:	8b 10                	mov    (%eax),%edx
  80049c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80049f:	89 08                	mov    %ecx,(%eax)
  8004a1:	8b 02                	mov    (%edx),%eax
  8004a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a8:	eb 0e                	jmp    8004b8 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004aa:	8b 10                	mov    (%eax),%edx
  8004ac:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004af:	89 08                	mov    %ecx,(%eax)
  8004b1:	8b 02                	mov    (%edx),%eax
  8004b3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b8:	5d                   	pop    %ebp
  8004b9:	c3                   	ret    

008004ba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004c4:	8b 10                	mov    (%eax),%edx
  8004c6:	3b 50 04             	cmp    0x4(%eax),%edx
  8004c9:	73 0a                	jae    8004d5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004ce:	88 0a                	mov    %cl,(%edx)
  8004d0:	83 c2 01             	add    $0x1,%edx
  8004d3:	89 10                	mov    %edx,(%eax)
}
  8004d5:	5d                   	pop    %ebp
  8004d6:	c3                   	ret    

008004d7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	57                   	push   %edi
  8004db:	56                   	push   %esi
  8004dc:	53                   	push   %ebx
  8004dd:	83 ec 4c             	sub    $0x4c,%esp
  8004e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004e9:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8004f0:	eb 11                	jmp    800503 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004f2:	85 c0                	test   %eax,%eax
  8004f4:	0f 84 b6 03 00 00    	je     8008b0 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8004fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004fe:	89 04 24             	mov    %eax,(%esp)
  800501:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800503:	0f b6 03             	movzbl (%ebx),%eax
  800506:	83 c3 01             	add    $0x1,%ebx
  800509:	83 f8 25             	cmp    $0x25,%eax
  80050c:	75 e4                	jne    8004f2 <vprintfmt+0x1b>
  80050e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800519:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800520:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800527:	b9 00 00 00 00       	mov    $0x0,%ecx
  80052c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80052f:	eb 06                	jmp    800537 <vprintfmt+0x60>
  800531:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800535:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800537:	0f b6 0b             	movzbl (%ebx),%ecx
  80053a:	0f b6 c1             	movzbl %cl,%eax
  80053d:	8d 53 01             	lea    0x1(%ebx),%edx
  800540:	83 e9 23             	sub    $0x23,%ecx
  800543:	80 f9 55             	cmp    $0x55,%cl
  800546:	0f 87 47 03 00 00    	ja     800893 <vprintfmt+0x3bc>
  80054c:	0f b6 c9             	movzbl %cl,%ecx
  80054f:	ff 24 8d e0 30 80 00 	jmp    *0x8030e0(,%ecx,4)
  800556:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80055a:	eb d9                	jmp    800535 <vprintfmt+0x5e>
  80055c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800563:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800568:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80056b:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80056f:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800572:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800575:	83 fb 09             	cmp    $0x9,%ebx
  800578:	77 30                	ja     8005aa <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80057a:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80057d:	eb e9                	jmp    800568 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8d 48 04             	lea    0x4(%eax),%ecx
  800585:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  80058d:	eb 1e                	jmp    8005ad <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80058f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800593:	b8 00 00 00 00       	mov    $0x0,%eax
  800598:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  80059c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80059f:	eb 94                	jmp    800535 <vprintfmt+0x5e>
  8005a1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8005a8:	eb 8b                	jmp    800535 <vprintfmt+0x5e>
  8005aa:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8005ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b1:	79 82                	jns    800535 <vprintfmt+0x5e>
  8005b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005bc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8005bf:	e9 71 ff ff ff       	jmp    800535 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005c4:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005c8:	e9 68 ff ff ff       	jmp    800535 <vprintfmt+0x5e>
  8005cd:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8d 50 04             	lea    0x4(%eax),%edx
  8005d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	89 04 24             	mov    %eax,(%esp)
  8005e2:	ff d7                	call   *%edi
  8005e4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8005e7:	e9 17 ff ff ff       	jmp    800503 <vprintfmt+0x2c>
  8005ec:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8d 50 04             	lea    0x4(%eax),%edx
  8005f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	89 c2                	mov    %eax,%edx
  8005fc:	c1 fa 1f             	sar    $0x1f,%edx
  8005ff:	31 d0                	xor    %edx,%eax
  800601:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800603:	83 f8 11             	cmp    $0x11,%eax
  800606:	7f 0b                	jg     800613 <vprintfmt+0x13c>
  800608:	8b 14 85 40 32 80 00 	mov    0x803240(,%eax,4),%edx
  80060f:	85 d2                	test   %edx,%edx
  800611:	75 20                	jne    800633 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800613:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800617:	c7 44 24 08 b4 2f 80 	movl   $0x802fb4,0x8(%esp)
  80061e:	00 
  80061f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800623:	89 3c 24             	mov    %edi,(%esp)
  800626:	e8 0d 03 00 00       	call   800938 <printfmt>
  80062b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80062e:	e9 d0 fe ff ff       	jmp    800503 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800633:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800637:	c7 44 24 08 52 34 80 	movl   $0x803452,0x8(%esp)
  80063e:	00 
  80063f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800643:	89 3c 24             	mov    %edi,(%esp)
  800646:	e8 ed 02 00 00       	call   800938 <printfmt>
  80064b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80064e:	e9 b0 fe ff ff       	jmp    800503 <vprintfmt+0x2c>
  800653:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800656:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80065c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 50 04             	lea    0x4(%eax),%edx
  800665:	89 55 14             	mov    %edx,0x14(%ebp)
  800668:	8b 18                	mov    (%eax),%ebx
  80066a:	85 db                	test   %ebx,%ebx
  80066c:	b8 bd 2f 80 00       	mov    $0x802fbd,%eax
  800671:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800674:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800678:	7e 76                	jle    8006f0 <vprintfmt+0x219>
  80067a:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80067e:	74 7a                	je     8006fa <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800680:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800684:	89 1c 24             	mov    %ebx,(%esp)
  800687:	e8 ec 02 00 00       	call   800978 <strnlen>
  80068c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80068f:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800691:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800695:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800698:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80069b:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069d:	eb 0f                	jmp    8006ae <vprintfmt+0x1d7>
					putch(padc, putdat);
  80069f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a6:	89 04 24             	mov    %eax,(%esp)
  8006a9:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ab:	83 eb 01             	sub    $0x1,%ebx
  8006ae:	85 db                	test   %ebx,%ebx
  8006b0:	7f ed                	jg     80069f <vprintfmt+0x1c8>
  8006b2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8006b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006b8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006bb:	89 f7                	mov    %esi,%edi
  8006bd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006c0:	eb 40                	jmp    800702 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006c2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c6:	74 18                	je     8006e0 <vprintfmt+0x209>
  8006c8:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006cb:	83 fa 5e             	cmp    $0x5e,%edx
  8006ce:	76 10                	jbe    8006e0 <vprintfmt+0x209>
					putch('?', putdat);
  8006d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006db:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006de:	eb 0a                	jmp    8006ea <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8006e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ea:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006ee:	eb 12                	jmp    800702 <vprintfmt+0x22b>
  8006f0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006f3:	89 f7                	mov    %esi,%edi
  8006f5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006f8:	eb 08                	jmp    800702 <vprintfmt+0x22b>
  8006fa:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006fd:	89 f7                	mov    %esi,%edi
  8006ff:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800702:	0f be 03             	movsbl (%ebx),%eax
  800705:	83 c3 01             	add    $0x1,%ebx
  800708:	85 c0                	test   %eax,%eax
  80070a:	74 25                	je     800731 <vprintfmt+0x25a>
  80070c:	85 f6                	test   %esi,%esi
  80070e:	78 b2                	js     8006c2 <vprintfmt+0x1eb>
  800710:	83 ee 01             	sub    $0x1,%esi
  800713:	79 ad                	jns    8006c2 <vprintfmt+0x1eb>
  800715:	89 fe                	mov    %edi,%esi
  800717:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80071a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80071d:	eb 1a                	jmp    800739 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80071f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800723:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80072a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80072c:	83 eb 01             	sub    $0x1,%ebx
  80072f:	eb 08                	jmp    800739 <vprintfmt+0x262>
  800731:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800734:	89 fe                	mov    %edi,%esi
  800736:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800739:	85 db                	test   %ebx,%ebx
  80073b:	7f e2                	jg     80071f <vprintfmt+0x248>
  80073d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800740:	e9 be fd ff ff       	jmp    800503 <vprintfmt+0x2c>
  800745:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800748:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80074b:	83 f9 01             	cmp    $0x1,%ecx
  80074e:	7e 16                	jle    800766 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8d 50 08             	lea    0x8(%eax),%edx
  800756:	89 55 14             	mov    %edx,0x14(%ebp)
  800759:	8b 10                	mov    (%eax),%edx
  80075b:	8b 48 04             	mov    0x4(%eax),%ecx
  80075e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800761:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800764:	eb 32                	jmp    800798 <vprintfmt+0x2c1>
	else if (lflag)
  800766:	85 c9                	test   %ecx,%ecx
  800768:	74 18                	je     800782 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8d 50 04             	lea    0x4(%eax),%edx
  800770:	89 55 14             	mov    %edx,0x14(%ebp)
  800773:	8b 00                	mov    (%eax),%eax
  800775:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800778:	89 c1                	mov    %eax,%ecx
  80077a:	c1 f9 1f             	sar    $0x1f,%ecx
  80077d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800780:	eb 16                	jmp    800798 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	89 55 14             	mov    %edx,0x14(%ebp)
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800790:	89 c2                	mov    %eax,%edx
  800792:	c1 fa 1f             	sar    $0x1f,%edx
  800795:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800798:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80079b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80079e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007a7:	0f 89 a7 00 00 00    	jns    800854 <vprintfmt+0x37d>
				putch('-', putdat);
  8007ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007b8:	ff d7                	call   *%edi
				num = -(long long) num;
  8007ba:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007bd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007c0:	f7 d9                	neg    %ecx
  8007c2:	83 d3 00             	adc    $0x0,%ebx
  8007c5:	f7 db                	neg    %ebx
  8007c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cc:	e9 83 00 00 00       	jmp    800854 <vprintfmt+0x37d>
  8007d1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007d4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d7:	89 ca                	mov    %ecx,%edx
  8007d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007dc:	e8 9f fc ff ff       	call   800480 <getuint>
  8007e1:	89 c1                	mov    %eax,%ecx
  8007e3:	89 d3                	mov    %edx,%ebx
  8007e5:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007ea:	eb 68                	jmp    800854 <vprintfmt+0x37d>
  8007ec:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007ef:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8007f2:	89 ca                	mov    %ecx,%edx
  8007f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f7:	e8 84 fc ff ff       	call   800480 <getuint>
  8007fc:	89 c1                	mov    %eax,%ecx
  8007fe:	89 d3                	mov    %edx,%ebx
  800800:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800805:	eb 4d                	jmp    800854 <vprintfmt+0x37d>
  800807:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80080a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800815:	ff d7                	call   *%edi
			putch('x', putdat);
  800817:	89 74 24 04          	mov    %esi,0x4(%esp)
  80081b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800822:	ff d7                	call   *%edi
			num = (unsigned long long)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8d 50 04             	lea    0x4(%eax),%edx
  80082a:	89 55 14             	mov    %edx,0x14(%ebp)
  80082d:	8b 08                	mov    (%eax),%ecx
  80082f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800834:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800839:	eb 19                	jmp    800854 <vprintfmt+0x37d>
  80083b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80083e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800841:	89 ca                	mov    %ecx,%edx
  800843:	8d 45 14             	lea    0x14(%ebp),%eax
  800846:	e8 35 fc ff ff       	call   800480 <getuint>
  80084b:	89 c1                	mov    %eax,%ecx
  80084d:	89 d3                	mov    %edx,%ebx
  80084f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800854:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800858:	89 54 24 10          	mov    %edx,0x10(%esp)
  80085c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80085f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800863:	89 44 24 08          	mov    %eax,0x8(%esp)
  800867:	89 0c 24             	mov    %ecx,(%esp)
  80086a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80086e:	89 f2                	mov    %esi,%edx
  800870:	89 f8                	mov    %edi,%eax
  800872:	e8 21 fb ff ff       	call   800398 <printnum>
  800877:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80087a:	e9 84 fc ff ff       	jmp    800503 <vprintfmt+0x2c>
  80087f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800882:	89 74 24 04          	mov    %esi,0x4(%esp)
  800886:	89 04 24             	mov    %eax,(%esp)
  800889:	ff d7                	call   *%edi
  80088b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80088e:	e9 70 fc ff ff       	jmp    800503 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800893:	89 74 24 04          	mov    %esi,0x4(%esp)
  800897:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80089e:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8008a3:	80 38 25             	cmpb   $0x25,(%eax)
  8008a6:	0f 84 57 fc ff ff    	je     800503 <vprintfmt+0x2c>
  8008ac:	89 c3                	mov    %eax,%ebx
  8008ae:	eb f0                	jmp    8008a0 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8008b0:	83 c4 4c             	add    $0x4c,%esp
  8008b3:	5b                   	pop    %ebx
  8008b4:	5e                   	pop    %esi
  8008b5:	5f                   	pop    %edi
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 28             	sub    $0x28,%esp
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008c4:	85 c0                	test   %eax,%eax
  8008c6:	74 04                	je     8008cc <vsnprintf+0x14>
  8008c8:	85 d2                	test   %edx,%edx
  8008ca:	7f 07                	jg     8008d3 <vsnprintf+0x1b>
  8008cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d1:	eb 3b                	jmp    80090e <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8008da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f9:	c7 04 24 ba 04 80 00 	movl   $0x8004ba,(%esp)
  800900:	e8 d2 fb ff ff       	call   8004d7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800905:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800908:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80090b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800916:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800919:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80091d:	8b 45 10             	mov    0x10(%ebp),%eax
  800920:	89 44 24 08          	mov    %eax,0x8(%esp)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	89 04 24             	mov    %eax,(%esp)
  800931:	e8 82 ff ff ff       	call   8008b8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800936:	c9                   	leave  
  800937:	c3                   	ret    

00800938 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80093e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800941:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800945:	8b 45 10             	mov    0x10(%ebp),%eax
  800948:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	89 04 24             	mov    %eax,(%esp)
  800959:	e8 79 fb ff ff       	call   8004d7 <vprintfmt>
	va_end(ap);
}
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	8b 55 08             	mov    0x8(%ebp),%edx
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80096b:	eb 03                	jmp    800970 <strlen+0x10>
		n++;
  80096d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800970:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800974:	75 f7                	jne    80096d <strlen+0xd>
		n++;
	return n;
}
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	53                   	push   %ebx
  80097c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80097f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800987:	eb 03                	jmp    80098c <strnlen+0x14>
		n++;
  800989:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098c:	39 c1                	cmp    %eax,%ecx
  80098e:	74 06                	je     800996 <strnlen+0x1e>
  800990:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800994:	75 f3                	jne    800989 <strnlen+0x11>
		n++;
	return n;
}
  800996:	5b                   	pop    %ebx
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	53                   	push   %ebx
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009a3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009af:	83 c2 01             	add    $0x1,%edx
  8009b2:	84 c9                	test   %cl,%cl
  8009b4:	75 f2                	jne    8009a8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009b6:	5b                   	pop    %ebx
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	53                   	push   %ebx
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c3:	89 1c 24             	mov    %ebx,(%esp)
  8009c6:	e8 95 ff ff ff       	call   800960 <strlen>
	strcpy(dst + len, src);
  8009cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009d2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8009d5:	89 04 24             	mov    %eax,(%esp)
  8009d8:	e8 bc ff ff ff       	call   800999 <strcpy>
	return dst;
}
  8009dd:	89 d8                	mov    %ebx,%eax
  8009df:	83 c4 08             	add    $0x8,%esp
  8009e2:	5b                   	pop    %ebx
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	56                   	push   %esi
  8009e9:	53                   	push   %ebx
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f0:	8b 75 10             	mov    0x10(%ebp),%esi
  8009f3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f8:	eb 0f                	jmp    800a09 <strncpy+0x24>
		*dst++ = *src;
  8009fa:	0f b6 19             	movzbl (%ecx),%ebx
  8009fd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a00:	80 39 01             	cmpb   $0x1,(%ecx)
  800a03:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a06:	83 c2 01             	add    $0x1,%edx
  800a09:	39 f2                	cmp    %esi,%edx
  800a0b:	72 ed                	jb     8009fa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a0d:	5b                   	pop    %ebx
  800a0e:	5e                   	pop    %esi
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	56                   	push   %esi
  800a15:	53                   	push   %ebx
  800a16:	8b 75 08             	mov    0x8(%ebp),%esi
  800a19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a1c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a1f:	89 f0                	mov    %esi,%eax
  800a21:	85 d2                	test   %edx,%edx
  800a23:	75 0a                	jne    800a2f <strlcpy+0x1e>
  800a25:	eb 17                	jmp    800a3e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a27:	88 18                	mov    %bl,(%eax)
  800a29:	83 c0 01             	add    $0x1,%eax
  800a2c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a2f:	83 ea 01             	sub    $0x1,%edx
  800a32:	74 07                	je     800a3b <strlcpy+0x2a>
  800a34:	0f b6 19             	movzbl (%ecx),%ebx
  800a37:	84 db                	test   %bl,%bl
  800a39:	75 ec                	jne    800a27 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800a3b:	c6 00 00             	movb   $0x0,(%eax)
  800a3e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a40:	5b                   	pop    %ebx
  800a41:	5e                   	pop    %esi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a4d:	eb 06                	jmp    800a55 <strcmp+0x11>
		p++, q++;
  800a4f:	83 c1 01             	add    $0x1,%ecx
  800a52:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a55:	0f b6 01             	movzbl (%ecx),%eax
  800a58:	84 c0                	test   %al,%al
  800a5a:	74 04                	je     800a60 <strcmp+0x1c>
  800a5c:	3a 02                	cmp    (%edx),%al
  800a5e:	74 ef                	je     800a4f <strcmp+0xb>
  800a60:	0f b6 c0             	movzbl %al,%eax
  800a63:	0f b6 12             	movzbl (%edx),%edx
  800a66:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	53                   	push   %ebx
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a74:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800a77:	eb 09                	jmp    800a82 <strncmp+0x18>
		n--, p++, q++;
  800a79:	83 ea 01             	sub    $0x1,%edx
  800a7c:	83 c0 01             	add    $0x1,%eax
  800a7f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a82:	85 d2                	test   %edx,%edx
  800a84:	75 07                	jne    800a8d <strncmp+0x23>
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	eb 13                	jmp    800aa0 <strncmp+0x36>
  800a8d:	0f b6 18             	movzbl (%eax),%ebx
  800a90:	84 db                	test   %bl,%bl
  800a92:	74 04                	je     800a98 <strncmp+0x2e>
  800a94:	3a 19                	cmp    (%ecx),%bl
  800a96:	74 e1                	je     800a79 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a98:	0f b6 00             	movzbl (%eax),%eax
  800a9b:	0f b6 11             	movzbl (%ecx),%edx
  800a9e:	29 d0                	sub    %edx,%eax
}
  800aa0:	5b                   	pop    %ebx
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aad:	eb 07                	jmp    800ab6 <strchr+0x13>
		if (*s == c)
  800aaf:	38 ca                	cmp    %cl,%dl
  800ab1:	74 0f                	je     800ac2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ab3:	83 c0 01             	add    $0x1,%eax
  800ab6:	0f b6 10             	movzbl (%eax),%edx
  800ab9:	84 d2                	test   %dl,%dl
  800abb:	75 f2                	jne    800aaf <strchr+0xc>
  800abd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ace:	eb 07                	jmp    800ad7 <strfind+0x13>
		if (*s == c)
  800ad0:	38 ca                	cmp    %cl,%dl
  800ad2:	74 0a                	je     800ade <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ad4:	83 c0 01             	add    $0x1,%eax
  800ad7:	0f b6 10             	movzbl (%eax),%edx
  800ada:	84 d2                	test   %dl,%dl
  800adc:	75 f2                	jne    800ad0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800ade:	5d                   	pop    %ebp
  800adf:	c3                   	ret    

00800ae0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 0c             	sub    $0xc,%esp
  800ae6:	89 1c 24             	mov    %ebx,(%esp)
  800ae9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aed:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800af1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800afa:	85 c9                	test   %ecx,%ecx
  800afc:	74 30                	je     800b2e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800afe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b04:	75 25                	jne    800b2b <memset+0x4b>
  800b06:	f6 c1 03             	test   $0x3,%cl
  800b09:	75 20                	jne    800b2b <memset+0x4b>
		c &= 0xFF;
  800b0b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b0e:	89 d3                	mov    %edx,%ebx
  800b10:	c1 e3 08             	shl    $0x8,%ebx
  800b13:	89 d6                	mov    %edx,%esi
  800b15:	c1 e6 18             	shl    $0x18,%esi
  800b18:	89 d0                	mov    %edx,%eax
  800b1a:	c1 e0 10             	shl    $0x10,%eax
  800b1d:	09 f0                	or     %esi,%eax
  800b1f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b21:	09 d8                	or     %ebx,%eax
  800b23:	c1 e9 02             	shr    $0x2,%ecx
  800b26:	fc                   	cld    
  800b27:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b29:	eb 03                	jmp    800b2e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b2b:	fc                   	cld    
  800b2c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b2e:	89 f8                	mov    %edi,%eax
  800b30:	8b 1c 24             	mov    (%esp),%ebx
  800b33:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b37:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b3b:	89 ec                	mov    %ebp,%esp
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	89 34 24             	mov    %esi,(%esp)
  800b48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800b52:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b55:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b57:	39 c6                	cmp    %eax,%esi
  800b59:	73 35                	jae    800b90 <memmove+0x51>
  800b5b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b5e:	39 d0                	cmp    %edx,%eax
  800b60:	73 2e                	jae    800b90 <memmove+0x51>
		s += n;
		d += n;
  800b62:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b64:	f6 c2 03             	test   $0x3,%dl
  800b67:	75 1b                	jne    800b84 <memmove+0x45>
  800b69:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b6f:	75 13                	jne    800b84 <memmove+0x45>
  800b71:	f6 c1 03             	test   $0x3,%cl
  800b74:	75 0e                	jne    800b84 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b76:	83 ef 04             	sub    $0x4,%edi
  800b79:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7c:	c1 e9 02             	shr    $0x2,%ecx
  800b7f:	fd                   	std    
  800b80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b82:	eb 09                	jmp    800b8d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b84:	83 ef 01             	sub    $0x1,%edi
  800b87:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b8a:	fd                   	std    
  800b8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b8d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b8e:	eb 20                	jmp    800bb0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b90:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b96:	75 15                	jne    800bad <memmove+0x6e>
  800b98:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b9e:	75 0d                	jne    800bad <memmove+0x6e>
  800ba0:	f6 c1 03             	test   $0x3,%cl
  800ba3:	75 08                	jne    800bad <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800ba5:	c1 e9 02             	shr    $0x2,%ecx
  800ba8:	fc                   	cld    
  800ba9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bab:	eb 03                	jmp    800bb0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bad:	fc                   	cld    
  800bae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb0:	8b 34 24             	mov    (%esp),%esi
  800bb3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bb7:	89 ec                	mov    %ebp,%esp
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 04 24             	mov    %eax,(%esp)
  800bd5:	e8 65 ff ff ff       	call   800b3f <memmove>
}
  800bda:	c9                   	leave  
  800bdb:	c3                   	ret    

00800bdc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800be5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800beb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf0:	eb 1c                	jmp    800c0e <memcmp+0x32>
		if (*s1 != *s2)
  800bf2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800bf6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800bfa:	83 c2 01             	add    $0x1,%edx
  800bfd:	83 e9 01             	sub    $0x1,%ecx
  800c00:	38 d8                	cmp    %bl,%al
  800c02:	74 0a                	je     800c0e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800c04:	0f b6 c0             	movzbl %al,%eax
  800c07:	0f b6 db             	movzbl %bl,%ebx
  800c0a:	29 d8                	sub    %ebx,%eax
  800c0c:	eb 09                	jmp    800c17 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c0e:	85 c9                	test   %ecx,%ecx
  800c10:	75 e0                	jne    800bf2 <memcmp+0x16>
  800c12:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c17:	5b                   	pop    %ebx
  800c18:	5e                   	pop    %esi
  800c19:	5f                   	pop    %edi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c25:	89 c2                	mov    %eax,%edx
  800c27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c2a:	eb 07                	jmp    800c33 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c2c:	38 08                	cmp    %cl,(%eax)
  800c2e:	74 07                	je     800c37 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c30:	83 c0 01             	add    $0x1,%eax
  800c33:	39 d0                	cmp    %edx,%eax
  800c35:	72 f5                	jb     800c2c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	83 ec 04             	sub    $0x4,%esp
  800c42:	8b 55 08             	mov    0x8(%ebp),%edx
  800c45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c48:	eb 03                	jmp    800c4d <strtol+0x14>
		s++;
  800c4a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4d:	0f b6 02             	movzbl (%edx),%eax
  800c50:	3c 20                	cmp    $0x20,%al
  800c52:	74 f6                	je     800c4a <strtol+0x11>
  800c54:	3c 09                	cmp    $0x9,%al
  800c56:	74 f2                	je     800c4a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c58:	3c 2b                	cmp    $0x2b,%al
  800c5a:	75 0c                	jne    800c68 <strtol+0x2f>
		s++;
  800c5c:	8d 52 01             	lea    0x1(%edx),%edx
  800c5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c66:	eb 15                	jmp    800c7d <strtol+0x44>
	else if (*s == '-')
  800c68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c6f:	3c 2d                	cmp    $0x2d,%al
  800c71:	75 0a                	jne    800c7d <strtol+0x44>
		s++, neg = 1;
  800c73:	8d 52 01             	lea    0x1(%edx),%edx
  800c76:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c7d:	85 db                	test   %ebx,%ebx
  800c7f:	0f 94 c0             	sete   %al
  800c82:	74 05                	je     800c89 <strtol+0x50>
  800c84:	83 fb 10             	cmp    $0x10,%ebx
  800c87:	75 15                	jne    800c9e <strtol+0x65>
  800c89:	80 3a 30             	cmpb   $0x30,(%edx)
  800c8c:	75 10                	jne    800c9e <strtol+0x65>
  800c8e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c92:	75 0a                	jne    800c9e <strtol+0x65>
		s += 2, base = 16;
  800c94:	83 c2 02             	add    $0x2,%edx
  800c97:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9c:	eb 13                	jmp    800cb1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c9e:	84 c0                	test   %al,%al
  800ca0:	74 0f                	je     800cb1 <strtol+0x78>
  800ca2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ca7:	80 3a 30             	cmpb   $0x30,(%edx)
  800caa:	75 05                	jne    800cb1 <strtol+0x78>
		s++, base = 8;
  800cac:	83 c2 01             	add    $0x1,%edx
  800caf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cb8:	0f b6 0a             	movzbl (%edx),%ecx
  800cbb:	89 cf                	mov    %ecx,%edi
  800cbd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cc0:	80 fb 09             	cmp    $0x9,%bl
  800cc3:	77 08                	ja     800ccd <strtol+0x94>
			dig = *s - '0';
  800cc5:	0f be c9             	movsbl %cl,%ecx
  800cc8:	83 e9 30             	sub    $0x30,%ecx
  800ccb:	eb 1e                	jmp    800ceb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800ccd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800cd0:	80 fb 19             	cmp    $0x19,%bl
  800cd3:	77 08                	ja     800cdd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800cd5:	0f be c9             	movsbl %cl,%ecx
  800cd8:	83 e9 57             	sub    $0x57,%ecx
  800cdb:	eb 0e                	jmp    800ceb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800cdd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ce0:	80 fb 19             	cmp    $0x19,%bl
  800ce3:	77 15                	ja     800cfa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ce5:	0f be c9             	movsbl %cl,%ecx
  800ce8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ceb:	39 f1                	cmp    %esi,%ecx
  800ced:	7d 0b                	jge    800cfa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cef:	83 c2 01             	add    $0x1,%edx
  800cf2:	0f af c6             	imul   %esi,%eax
  800cf5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800cf8:	eb be                	jmp    800cb8 <strtol+0x7f>
  800cfa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800cfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d00:	74 05                	je     800d07 <strtol+0xce>
		*endptr = (char *) s;
  800d02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d05:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d07:	89 ca                	mov    %ecx,%edx
  800d09:	f7 da                	neg    %edx
  800d0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d0f:	0f 45 c2             	cmovne %edx,%eax
}
  800d12:	83 c4 04             	add    $0x4,%esp
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    
	...

00800d1c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	89 1c 24             	mov    %ebx,(%esp)
  800d25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d29:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d32:	b8 01 00 00 00       	mov    $0x1,%eax
  800d37:	89 d1                	mov    %edx,%ecx
  800d39:	89 d3                	mov    %edx,%ebx
  800d3b:	89 d7                	mov    %edx,%edi
  800d3d:	89 d6                	mov    %edx,%esi
  800d3f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d41:	8b 1c 24             	mov    (%esp),%ebx
  800d44:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d48:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d4c:	89 ec                	mov    %ebp,%esp
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	89 c3                	mov    %eax,%ebx
  800d6e:	89 c7                	mov    %eax,%edi
  800d70:	89 c6                	mov    %eax,%esi
  800d72:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d74:	8b 1c 24             	mov    (%esp),%ebx
  800d77:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d7b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d7f:	89 ec                	mov    %ebp,%esp
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	89 1c 24             	mov    %ebx,(%esp)
  800d8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d90:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d94:	ba 00 00 00 00       	mov    $0x0,%edx
  800d99:	b8 10 00 00 00       	mov    $0x10,%eax
  800d9e:	89 d1                	mov    %edx,%ecx
  800da0:	89 d3                	mov    %edx,%ebx
  800da2:	89 d7                	mov    %edx,%edi
  800da4:	89 d6                	mov    %edx,%esi
  800da6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800da8:	8b 1c 24             	mov    (%esp),%ebx
  800dab:	8b 74 24 04          	mov    0x4(%esp),%esi
  800daf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800db3:	89 ec                	mov    %ebp,%esp
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 38             	sub    $0x38,%esp
  800dbd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dc0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dc3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	89 df                	mov    %ebx,%edi
  800dd8:	89 de                	mov    %ebx,%esi
  800dda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	7e 28                	jle    800e08 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800deb:	00 
  800dec:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800df3:	00 
  800df4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfb:	00 
  800dfc:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800e03:	e8 78 f4 ff ff       	call   800280 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800e08:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e0b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e0e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e11:	89 ec                	mov    %ebp,%esp
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    

00800e15 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 38             	sub    $0x38,%esp
  800e1b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e1e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e21:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e29:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	89 df                	mov    %ebx,%edi
  800e36:	89 de                	mov    %ebx,%esi
  800e38:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7e 28                	jle    800e66 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e42:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800e49:	00 
  800e4a:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800e51:	00 
  800e52:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e59:	00 
  800e5a:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800e61:	e8 1a f4 ff ff       	call   800280 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800e66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e69:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e6c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e6f:	89 ec                	mov    %ebp,%esp
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	83 ec 38             	sub    $0x38,%esp
  800e79:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e7f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e87:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 cb                	mov    %ecx,%ebx
  800e91:	89 cf                	mov    %ecx,%edi
  800e93:	89 ce                	mov    %ecx,%esi
  800e95:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e97:	85 c0                	test   %eax,%eax
  800e99:	7e 28                	jle    800ec3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ea6:	00 
  800ea7:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800eae:	00 
  800eaf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb6:	00 
  800eb7:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800ebe:	e8 bd f3 ff ff       	call   800280 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ecc:	89 ec                	mov    %ebp,%esp
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 0c             	sub    $0xc,%esp
  800ed6:	89 1c 24             	mov    %ebx,(%esp)
  800ed9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800edd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee1:	be 00 00 00 00       	mov    $0x0,%esi
  800ee6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eeb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef9:	8b 1c 24             	mov    (%esp),%ebx
  800efc:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f00:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f04:	89 ec                	mov    %ebp,%esp
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 38             	sub    $0x38,%esp
  800f0e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f11:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f14:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
  800f27:	89 df                	mov    %ebx,%edi
  800f29:	89 de                	mov    %ebx,%esi
  800f2b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	7e 28                	jle    800f59 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f31:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f35:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f3c:	00 
  800f3d:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800f44:	00 
  800f45:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4c:	00 
  800f4d:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800f54:	e8 27 f3 ff ff       	call   800280 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f59:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f5c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f62:	89 ec                	mov    %ebp,%esp
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 38             	sub    $0x38,%esp
  800f6c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f72:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800f7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f82:	8b 55 08             	mov    0x8(%ebp),%edx
  800f85:	89 df                	mov    %ebx,%edi
  800f87:	89 de                	mov    %ebx,%esi
  800f89:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	7e 28                	jle    800fb7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f93:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f9a:	00 
  800f9b:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800fa2:	00 
  800fa3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800faa:	00 
  800fab:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800fb2:	e8 c9 f2 ff ff       	call   800280 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fbd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fc0:	89 ec                	mov    %ebp,%esp
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	83 ec 38             	sub    $0x38,%esp
  800fca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fcd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fd0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd8:	b8 08 00 00 00       	mov    $0x8,%eax
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe3:	89 df                	mov    %ebx,%edi
  800fe5:	89 de                	mov    %ebx,%esi
  800fe7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7e 28                	jle    801015 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fed:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ff8:	00 
  800ff9:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  801000:	00 
  801001:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801008:	00 
  801009:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  801010:	e8 6b f2 ff ff       	call   800280 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801015:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801018:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80101b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101e:	89 ec                	mov    %ebp,%esp
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    

00801022 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 38             	sub    $0x38,%esp
  801028:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80102b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801031:	bb 00 00 00 00       	mov    $0x0,%ebx
  801036:	b8 06 00 00 00       	mov    $0x6,%eax
  80103b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	89 df                	mov    %ebx,%edi
  801043:	89 de                	mov    %ebx,%esi
  801045:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801047:	85 c0                	test   %eax,%eax
  801049:	7e 28                	jle    801073 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80104b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801056:	00 
  801057:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  80105e:	00 
  80105f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801066:	00 
  801067:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  80106e:	e8 0d f2 ff ff       	call   800280 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801073:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801076:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801079:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80107c:	89 ec                	mov    %ebp,%esp
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    

00801080 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	83 ec 38             	sub    $0x38,%esp
  801086:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801089:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80108c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108f:	b8 05 00 00 00       	mov    $0x5,%eax
  801094:	8b 75 18             	mov    0x18(%ebp),%esi
  801097:	8b 7d 14             	mov    0x14(%ebp),%edi
  80109a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80109d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	7e 28                	jle    8010d1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ad:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010b4:	00 
  8010b5:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  8010bc:	00 
  8010bd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c4:	00 
  8010c5:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  8010cc:	e8 af f1 ff ff       	call   800280 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010d1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010da:	89 ec                	mov    %ebp,%esp
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 38             	sub    $0x38,%esp
  8010e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ed:	be 00 00 00 00       	mov    $0x0,%esi
  8010f2:	b8 04 00 00 00       	mov    $0x4,%eax
  8010f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	89 f7                	mov    %esi,%edi
  801102:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801104:	85 c0                	test   %eax,%eax
  801106:	7e 28                	jle    801130 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801108:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801113:	00 
  801114:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  80111b:	00 
  80111c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801123:	00 
  801124:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  80112b:	e8 50 f1 ff ff       	call   800280 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801130:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801133:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801136:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801139:	89 ec                	mov    %ebp,%esp
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 0c             	sub    $0xc,%esp
  801143:	89 1c 24             	mov    %ebx,(%esp)
  801146:	89 74 24 04          	mov    %esi,0x4(%esp)
  80114a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114e:	ba 00 00 00 00       	mov    $0x0,%edx
  801153:	b8 0b 00 00 00       	mov    $0xb,%eax
  801158:	89 d1                	mov    %edx,%ecx
  80115a:	89 d3                	mov    %edx,%ebx
  80115c:	89 d7                	mov    %edx,%edi
  80115e:	89 d6                	mov    %edx,%esi
  801160:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801162:	8b 1c 24             	mov    (%esp),%ebx
  801165:	8b 74 24 04          	mov    0x4(%esp),%esi
  801169:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80116d:	89 ec                	mov    %ebp,%esp
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    

00801171 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	83 ec 0c             	sub    $0xc,%esp
  801177:	89 1c 24             	mov    %ebx,(%esp)
  80117a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801182:	ba 00 00 00 00       	mov    $0x0,%edx
  801187:	b8 02 00 00 00       	mov    $0x2,%eax
  80118c:	89 d1                	mov    %edx,%ecx
  80118e:	89 d3                	mov    %edx,%ebx
  801190:	89 d7                	mov    %edx,%edi
  801192:	89 d6                	mov    %edx,%esi
  801194:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801196:	8b 1c 24             	mov    (%esp),%ebx
  801199:	8b 74 24 04          	mov    0x4(%esp),%esi
  80119d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011a1:	89 ec                	mov    %ebp,%esp
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    

008011a5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 38             	sub    $0x38,%esp
  8011ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8011be:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c1:	89 cb                	mov    %ecx,%ebx
  8011c3:	89 cf                	mov    %ecx,%edi
  8011c5:	89 ce                	mov    %ecx,%esi
  8011c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	7e 28                	jle    8011f5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8011d8:	00 
  8011d9:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  8011e0:	00 
  8011e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011e8:	00 
  8011e9:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  8011f0:	e8 8b f0 ff ff       	call   800280 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011f8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011fe:	89 ec                	mov    %ebp,%esp
  801200:	5d                   	pop    %ebp
  801201:	c3                   	ret    
	...

00801204 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80120a:	c7 44 24 08 d2 32 80 	movl   $0x8032d2,0x8(%esp)
  801211:	00 
  801212:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801219:	00 
  80121a:	c7 04 24 e8 32 80 00 	movl   $0x8032e8,(%esp)
  801221:	e8 5a f0 ff ff       	call   800280 <_panic>

00801226 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	57                   	push   %edi
  80122a:	56                   	push   %esi
  80122b:	53                   	push   %ebx
  80122c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  80122f:	c7 04 24 94 14 80 00 	movl   $0x801494,(%esp)
  801236:	e8 79 17 00 00       	call   8029b4 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80123b:	ba 07 00 00 00       	mov    $0x7,%edx
  801240:	89 d0                	mov    %edx,%eax
  801242:	cd 30                	int    $0x30
  801244:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801247:	85 c0                	test   %eax,%eax
  801249:	79 20                	jns    80126b <fork+0x45>
		panic("sys_exofork: %e", envid);
  80124b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80124f:	c7 44 24 08 f3 32 80 	movl   $0x8032f3,0x8(%esp)
  801256:	00 
  801257:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80125e:	00 
  80125f:	c7 04 24 e8 32 80 00 	movl   $0x8032e8,(%esp)
  801266:	e8 15 f0 ff ff       	call   800280 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  80126b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801272:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801277:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80127b:	75 21                	jne    80129e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80127d:	e8 ef fe ff ff       	call   801171 <sys_getenvid>
  801282:	25 ff 03 00 00       	and    $0x3ff,%eax
  801287:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80128a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80128f:	a3 20 54 80 00       	mov    %eax,0x805420
  801294:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801299:	e9 e5 01 00 00       	jmp    801483 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80129e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8012a1:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8012a8:	a8 01                	test   $0x1,%al
  8012aa:	0f 84 4c 01 00 00    	je     8013fc <fork+0x1d6>
  8012b0:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  8012b6:	0f 84 cf 01 00 00    	je     80148b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  8012bc:	c1 e2 16             	shl    $0x16,%edx
  8012bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  8012c2:	89 d3                	mov    %edx,%ebx
  8012c4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012cb:	00 
  8012cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012d3:	89 04 24             	mov    %eax,(%esp)
  8012d6:	e8 03 fe ff ff       	call   8010de <sys_page_alloc>
			if(ret < 0) return ret;
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	0f 88 a0 01 00 00    	js     801483 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  8012e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8012ea:	89 14 24             	mov    %edx,(%esp)
  8012ed:	e8 30 fd ff ff       	call   801022 <sys_page_unmap>
			if(ret < 0) return ret;
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	0f 88 89 01 00 00    	js     801483 <fork+0x25d>
  8012fa:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  8012ff:	89 de                	mov    %ebx,%esi
  801301:	c1 e6 0c             	shl    $0xc,%esi
  801304:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801307:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  80130d:	0f 84 da 00 00 00    	je     8013ed <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801313:	c1 ee 0c             	shr    $0xc,%esi
  801316:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801319:	a8 01                	test   $0x1,%al
  80131b:	0f 84 cc 00 00 00    	je     8013ed <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801321:	89 f0                	mov    %esi,%eax
  801323:	c1 e0 0c             	shl    $0xc,%eax
  801326:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801329:	e8 43 fe ff ff       	call   801171 <sys_getenvid>
  80132e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801331:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801334:	89 c6                	mov    %eax,%esi
  801336:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  80133c:	25 01 04 00 00       	and    $0x401,%eax
  801341:	3d 01 04 00 00       	cmp    $0x401,%eax
  801346:	75 3a                	jne    801382 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801348:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80134f:	00 
  801350:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801353:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801357:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80135a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80135e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801362:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801365:	89 14 24             	mov    %edx,(%esp)
  801368:	e8 13 fd ff ff       	call   801080 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  80136d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801370:	89 44 24 04          	mov    %eax,0x4(%esp)
  801374:	c7 04 24 03 33 80 00 	movl   $0x803303,(%esp)
  80137b:	e8 b9 ef ff ff       	call   800339 <cprintf>
  801380:	eb 6b                	jmp    8013ed <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801382:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801388:	74 14                	je     80139e <fork+0x178>
  80138a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801390:	74 0c                	je     80139e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801392:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801398:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80139e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013a1:	89 74 24 10          	mov    %esi,0x10(%esp)
  8013a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013b7:	89 14 24             	mov    %edx,(%esp)
  8013ba:	e8 c1 fc ff ff       	call   801080 <sys_page_map>
	if(ret<0) return ret;
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	0f 88 bc 00 00 00    	js     801483 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  8013c7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8013cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013d5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013dd:	89 14 24             	mov    %edx,(%esp)
  8013e0:	e8 9b fc ff ff       	call   801080 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	0f 88 96 00 00 00    	js     801483 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  8013ed:	83 c3 01             	add    $0x1,%ebx
  8013f0:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8013f6:	0f 85 03 ff ff ff    	jne    8012ff <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8013fc:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801400:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801407:	0f 85 91 fe ff ff    	jne    80129e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  80140d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801414:	00 
  801415:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80141c:	ee 
  80141d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801420:	89 04 24             	mov    %eax,(%esp)
  801423:	e8 b6 fc ff ff       	call   8010de <sys_page_alloc>
	if(ret < 0) return ret;
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 57                	js     801483 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  80142c:	a1 20 54 80 00       	mov    0x805420,%eax
  801431:	8b 40 64             	mov    0x64(%eax),%eax
  801434:	89 44 24 04          	mov    %eax,0x4(%esp)
  801438:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80143b:	89 14 24             	mov    %edx,(%esp)
  80143e:	e8 c5 fa ff ff       	call   800f08 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801443:	85 c0                	test   %eax,%eax
  801445:	78 3c                	js     801483 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801447:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80144e:	00 
  80144f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801452:	89 04 24             	mov    %eax,(%esp)
  801455:	e8 6a fb ff ff       	call   800fc4 <sys_env_set_status>
  80145a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  80145c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80145f:	85 d2                	test   %edx,%edx
  801461:	79 20                	jns    801483 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801463:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801467:	c7 44 24 08 1a 33 80 	movl   $0x80331a,0x8(%esp)
  80146e:	00 
  80146f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801476:	00 
  801477:	c7 04 24 e8 32 80 00 	movl   $0x8032e8,(%esp)
  80147e:	e8 fd ed ff ff       	call   800280 <_panic>

	return envid;
}
  801483:	83 c4 4c             	add    $0x4c,%esp
  801486:	5b                   	pop    %ebx
  801487:	5e                   	pop    %esi
  801488:	5f                   	pop    %edi
  801489:	5d                   	pop    %ebp
  80148a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80148b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80148f:	e9 0a fe ff ff       	jmp    80129e <fork+0x78>

00801494 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	56                   	push   %esi
  801498:	53                   	push   %ebx
  801499:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80149c:	e8 d0 fc ff ff       	call   801171 <sys_getenvid>
  8014a1:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	8b 00                	mov    (%eax),%eax
  8014a8:	89 c6                	mov    %eax,%esi
  8014aa:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  8014ad:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8014b4:	f6 c2 02             	test   $0x2,%dl
  8014b7:	75 2c                	jne    8014e5 <pgfault+0x51>
  8014b9:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8014c0:	f6 c6 08             	test   $0x8,%dh
  8014c3:	75 20                	jne    8014e5 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  8014c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014c9:	c7 44 24 08 68 33 80 	movl   $0x803368,0x8(%esp)
  8014d0:	00 
  8014d1:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8014d8:	00 
  8014d9:	c7 04 24 e8 32 80 00 	movl   $0x8032e8,(%esp)
  8014e0:	e8 9b ed ff ff       	call   800280 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8014e5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014ec:	00 
  8014ed:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8014f4:	00 
  8014f5:	89 1c 24             	mov    %ebx,(%esp)
  8014f8:	e8 e1 fb ff ff       	call   8010de <sys_page_alloc>
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	79 20                	jns    801521 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801501:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801505:	c7 44 24 08 31 33 80 	movl   $0x803331,0x8(%esp)
  80150c:	00 
  80150d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801514:	00 
  801515:	c7 04 24 e8 32 80 00 	movl   $0x8032e8,(%esp)
  80151c:	e8 5f ed ff ff       	call   800280 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801521:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801524:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80152b:	00 
  80152c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801530:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801537:	e8 03 f6 ff ff       	call   800b3f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80153c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801543:	00 
  801544:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801548:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80154c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801553:	00 
  801554:	89 1c 24             	mov    %ebx,(%esp)
  801557:	e8 24 fb ff ff       	call   801080 <sys_page_map>
  80155c:	85 c0                	test   %eax,%eax
  80155e:	79 20                	jns    801580 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801560:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801564:	c7 44 24 08 43 33 80 	movl   $0x803343,0x8(%esp)
  80156b:	00 
  80156c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801573:	00 
  801574:	c7 04 24 e8 32 80 00 	movl   $0x8032e8,(%esp)
  80157b:	e8 00 ed ff ff       	call   800280 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801580:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801587:	00 
  801588:	89 1c 24             	mov    %ebx,(%esp)
  80158b:	e8 92 fa ff ff       	call   801022 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801590:	85 c0                	test   %eax,%eax
  801592:	74 20                	je     8015b4 <pgfault+0x120>
  801594:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801598:	c7 44 24 08 53 33 80 	movl   $0x803353,0x8(%esp)
  80159f:	00 
  8015a0:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8015a7:	00 
  8015a8:	c7 04 24 e8 32 80 00 	movl   $0x8032e8,(%esp)
  8015af:	e8 cc ec ff ff       	call   800280 <_panic>

}
  8015b4:	83 c4 20             	add    $0x20,%esp
  8015b7:	5b                   	pop    %ebx
  8015b8:	5e                   	pop    %esi
  8015b9:	5d                   	pop    %ebp
  8015ba:	c3                   	ret    
	...

008015bc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	05 00 00 00 30       	add    $0x30000000,%eax
  8015c7:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8015ca:	5d                   	pop    %ebp
  8015cb:	c3                   	ret    

008015cc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	89 04 24             	mov    %eax,(%esp)
  8015d8:	e8 df ff ff ff       	call   8015bc <fd2num>
  8015dd:	05 20 00 0d 00       	add    $0xd0020,%eax
  8015e2:	c1 e0 0c             	shl    $0xc,%eax
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	57                   	push   %edi
  8015eb:	56                   	push   %esi
  8015ec:	53                   	push   %ebx
  8015ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015f0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015f5:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8015fa:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015ff:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801601:	89 c2                	mov    %eax,%edx
  801603:	c1 ea 16             	shr    $0x16,%edx
  801606:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801609:	f6 c2 01             	test   $0x1,%dl
  80160c:	74 0d                	je     80161b <fd_alloc+0x34>
  80160e:	89 c2                	mov    %eax,%edx
  801610:	c1 ea 0c             	shr    $0xc,%edx
  801613:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  801616:	f6 c2 01             	test   $0x1,%dl
  801619:	75 09                	jne    801624 <fd_alloc+0x3d>
			*fd_store = fd;
  80161b:	89 37                	mov    %esi,(%edi)
  80161d:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801622:	eb 17                	jmp    80163b <fd_alloc+0x54>
  801624:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801629:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80162e:	75 cf                	jne    8015ff <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801630:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801636:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  80163b:	5b                   	pop    %ebx
  80163c:	5e                   	pop    %esi
  80163d:	5f                   	pop    %edi
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	83 f8 1f             	cmp    $0x1f,%eax
  801649:	77 36                	ja     801681 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80164b:	05 00 00 0d 00       	add    $0xd0000,%eax
  801650:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801653:	89 c2                	mov    %eax,%edx
  801655:	c1 ea 16             	shr    $0x16,%edx
  801658:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80165f:	f6 c2 01             	test   $0x1,%dl
  801662:	74 1d                	je     801681 <fd_lookup+0x41>
  801664:	89 c2                	mov    %eax,%edx
  801666:	c1 ea 0c             	shr    $0xc,%edx
  801669:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801670:	f6 c2 01             	test   $0x1,%dl
  801673:	74 0c                	je     801681 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801675:	8b 55 0c             	mov    0xc(%ebp),%edx
  801678:	89 02                	mov    %eax,(%edx)
  80167a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80167f:	eb 05                	jmp    801686 <fd_lookup+0x46>
  801681:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801686:	5d                   	pop    %ebp
  801687:	c3                   	ret    

00801688 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801691:	89 44 24 04          	mov    %eax,0x4(%esp)
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	89 04 24             	mov    %eax,(%esp)
  80169b:	e8 a0 ff ff ff       	call   801640 <fd_lookup>
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 0e                	js     8016b2 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8016a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016aa:	89 50 04             	mov    %edx,0x4(%eax)
  8016ad:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	56                   	push   %esi
  8016b8:	53                   	push   %ebx
  8016b9:	83 ec 10             	sub    $0x10,%esp
  8016bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016c2:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8016c7:	be 0c 34 80 00       	mov    $0x80340c,%esi
  8016cc:	eb 10                	jmp    8016de <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  8016ce:	39 08                	cmp    %ecx,(%eax)
  8016d0:	75 09                	jne    8016db <dev_lookup+0x27>
			*dev = devtab[i];
  8016d2:	89 03                	mov    %eax,(%ebx)
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8016d9:	eb 31                	jmp    80170c <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016db:	83 c2 01             	add    $0x1,%edx
  8016de:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	75 e9                	jne    8016ce <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016e5:	a1 20 54 80 00       	mov    0x805420,%eax
  8016ea:	8b 40 48             	mov    0x48(%eax),%eax
  8016ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f5:	c7 04 24 8c 33 80 00 	movl   $0x80338c,(%esp)
  8016fc:	e8 38 ec ff ff       	call   800339 <cprintf>
	*dev = 0;
  801701:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801707:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5d                   	pop    %ebp
  801712:	c3                   	ret    

00801713 <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	53                   	push   %ebx
  801717:	83 ec 24             	sub    $0x24,%esp
  80171a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801720:	89 44 24 04          	mov    %eax,0x4(%esp)
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	89 04 24             	mov    %eax,(%esp)
  80172a:	e8 11 ff ff ff       	call   801640 <fd_lookup>
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 53                	js     801786 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801733:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801736:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173d:	8b 00                	mov    (%eax),%eax
  80173f:	89 04 24             	mov    %eax,(%esp)
  801742:	e8 6d ff ff ff       	call   8016b4 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801747:	85 c0                	test   %eax,%eax
  801749:	78 3b                	js     801786 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  80174b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801750:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801753:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801757:	74 2d                	je     801786 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801759:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80175c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801763:	00 00 00 
	stat->st_isdir = 0;
  801766:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80176d:	00 00 00 
	stat->st_dev = dev;
  801770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801773:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801779:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80177d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801780:	89 14 24             	mov    %edx,(%esp)
  801783:	ff 50 14             	call   *0x14(%eax)
}
  801786:	83 c4 24             	add    $0x24,%esp
  801789:	5b                   	pop    %ebx
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    

0080178c <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	53                   	push   %ebx
  801790:	83 ec 24             	sub    $0x24,%esp
  801793:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801796:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801799:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179d:	89 1c 24             	mov    %ebx,(%esp)
  8017a0:	e8 9b fe ff ff       	call   801640 <fd_lookup>
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 5f                	js     801808 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	8b 00                	mov    (%eax),%eax
  8017b5:	89 04 24             	mov    %eax,(%esp)
  8017b8:	e8 f7 fe ff ff       	call   8016b4 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 47                	js     801808 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c4:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8017c8:	75 23                	jne    8017ed <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017ca:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017cf:	8b 40 48             	mov    0x48(%eax),%eax
  8017d2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017da:	c7 04 24 ac 33 80 00 	movl   $0x8033ac,(%esp)
  8017e1:	e8 53 eb ff ff       	call   800339 <cprintf>
  8017e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017eb:	eb 1b                	jmp    801808 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8017ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f0:	8b 48 18             	mov    0x18(%eax),%ecx
  8017f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f8:	85 c9                	test   %ecx,%ecx
  8017fa:	74 0c                	je     801808 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801803:	89 14 24             	mov    %edx,(%esp)
  801806:	ff d1                	call   *%ecx
}
  801808:	83 c4 24             	add    $0x24,%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	53                   	push   %ebx
  801812:	83 ec 24             	sub    $0x24,%esp
  801815:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801818:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181f:	89 1c 24             	mov    %ebx,(%esp)
  801822:	e8 19 fe ff ff       	call   801640 <fd_lookup>
  801827:	85 c0                	test   %eax,%eax
  801829:	78 66                	js     801891 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	89 04 24             	mov    %eax,(%esp)
  80183a:	e8 75 fe ff ff       	call   8016b4 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 4e                	js     801891 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801843:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801846:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80184a:	75 23                	jne    80186f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80184c:	a1 20 54 80 00       	mov    0x805420,%eax
  801851:	8b 40 48             	mov    0x48(%eax),%eax
  801854:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185c:	c7 04 24 d0 33 80 00 	movl   $0x8033d0,(%esp)
  801863:	e8 d1 ea ff ff       	call   800339 <cprintf>
  801868:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  80186d:	eb 22                	jmp    801891 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80186f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801872:	8b 48 0c             	mov    0xc(%eax),%ecx
  801875:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80187a:	85 c9                	test   %ecx,%ecx
  80187c:	74 13                	je     801891 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80187e:	8b 45 10             	mov    0x10(%ebp),%eax
  801881:	89 44 24 08          	mov    %eax,0x8(%esp)
  801885:	8b 45 0c             	mov    0xc(%ebp),%eax
  801888:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188c:	89 14 24             	mov    %edx,(%esp)
  80188f:	ff d1                	call   *%ecx
}
  801891:	83 c4 24             	add    $0x24,%esp
  801894:	5b                   	pop    %ebx
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    

00801897 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	53                   	push   %ebx
  80189b:	83 ec 24             	sub    $0x24,%esp
  80189e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a8:	89 1c 24             	mov    %ebx,(%esp)
  8018ab:	e8 90 fd ff ff       	call   801640 <fd_lookup>
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	78 6b                	js     80191f <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018be:	8b 00                	mov    (%eax),%eax
  8018c0:	89 04 24             	mov    %eax,(%esp)
  8018c3:	e8 ec fd ff ff       	call   8016b4 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	78 53                	js     80191f <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018cf:	8b 42 08             	mov    0x8(%edx),%eax
  8018d2:	83 e0 03             	and    $0x3,%eax
  8018d5:	83 f8 01             	cmp    $0x1,%eax
  8018d8:	75 23                	jne    8018fd <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018da:	a1 20 54 80 00       	mov    0x805420,%eax
  8018df:	8b 40 48             	mov    0x48(%eax),%eax
  8018e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ea:	c7 04 24 ed 33 80 00 	movl   $0x8033ed,(%esp)
  8018f1:	e8 43 ea ff ff       	call   800339 <cprintf>
  8018f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8018fb:	eb 22                	jmp    80191f <read+0x88>
	}
	if (!dev->dev_read)
  8018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801900:	8b 48 08             	mov    0x8(%eax),%ecx
  801903:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801908:	85 c9                	test   %ecx,%ecx
  80190a:	74 13                	je     80191f <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80190c:	8b 45 10             	mov    0x10(%ebp),%eax
  80190f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801913:	8b 45 0c             	mov    0xc(%ebp),%eax
  801916:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191a:	89 14 24             	mov    %edx,(%esp)
  80191d:	ff d1                	call   *%ecx
}
  80191f:	83 c4 24             	add    $0x24,%esp
  801922:	5b                   	pop    %ebx
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	57                   	push   %edi
  801929:	56                   	push   %esi
  80192a:	53                   	push   %ebx
  80192b:	83 ec 1c             	sub    $0x1c,%esp
  80192e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801931:	8b 75 10             	mov    0x10(%ebp),%esi
  801934:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801939:	eb 21                	jmp    80195c <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80193b:	89 f2                	mov    %esi,%edx
  80193d:	29 c2                	sub    %eax,%edx
  80193f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801943:	03 45 0c             	add    0xc(%ebp),%eax
  801946:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194a:	89 3c 24             	mov    %edi,(%esp)
  80194d:	e8 45 ff ff ff       	call   801897 <read>
		if (m < 0)
  801952:	85 c0                	test   %eax,%eax
  801954:	78 0e                	js     801964 <readn+0x3f>
			return m;
		if (m == 0)
  801956:	85 c0                	test   %eax,%eax
  801958:	74 08                	je     801962 <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80195a:	01 c3                	add    %eax,%ebx
  80195c:	89 d8                	mov    %ebx,%eax
  80195e:	39 f3                	cmp    %esi,%ebx
  801960:	72 d9                	jb     80193b <readn+0x16>
  801962:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801964:	83 c4 1c             	add    $0x1c,%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 38             	sub    $0x38,%esp
  801972:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801975:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801978:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80197b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80197e:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801982:	89 3c 24             	mov    %edi,(%esp)
  801985:	e8 32 fc ff ff       	call   8015bc <fd2num>
  80198a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80198d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801991:	89 04 24             	mov    %eax,(%esp)
  801994:	e8 a7 fc ff ff       	call   801640 <fd_lookup>
  801999:	89 c3                	mov    %eax,%ebx
  80199b:	85 c0                	test   %eax,%eax
  80199d:	78 05                	js     8019a4 <fd_close+0x38>
  80199f:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8019a2:	74 0e                	je     8019b2 <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8019a4:	89 f0                	mov    %esi,%eax
  8019a6:	84 c0                	test   %al,%al
  8019a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ad:	0f 44 d8             	cmove  %eax,%ebx
  8019b0:	eb 3d                	jmp    8019ef <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019b2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b9:	8b 07                	mov    (%edi),%eax
  8019bb:	89 04 24             	mov    %eax,(%esp)
  8019be:	e8 f1 fc ff ff       	call   8016b4 <dev_lookup>
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	78 16                	js     8019df <fd_close+0x73>
		if (dev->dev_close)
  8019c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019cc:	8b 40 10             	mov    0x10(%eax),%eax
  8019cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	74 07                	je     8019df <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8019d8:	89 3c 24             	mov    %edi,(%esp)
  8019db:	ff d0                	call   *%eax
  8019dd:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8019df:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ea:	e8 33 f6 ff ff       	call   801022 <sys_page_unmap>
	return r;
}
  8019ef:	89 d8                	mov    %ebx,%eax
  8019f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019f4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019fa:	89 ec                	mov    %ebp,%esp
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    

008019fe <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	89 04 24             	mov    %eax,(%esp)
  801a11:	e8 2a fc ff ff       	call   801640 <fd_lookup>
  801a16:	85 c0                	test   %eax,%eax
  801a18:	78 13                	js     801a2d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801a1a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a21:	00 
  801a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a25:	89 04 24             	mov    %eax,(%esp)
  801a28:	e8 3f ff ff ff       	call   80196c <fd_close>
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 18             	sub    $0x18,%esp
  801a35:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a38:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a42:	00 
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	89 04 24             	mov    %eax,(%esp)
  801a49:	e8 25 04 00 00       	call   801e73 <open>
  801a4e:	89 c3                	mov    %eax,%ebx
  801a50:	85 c0                	test   %eax,%eax
  801a52:	78 1b                	js     801a6f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5b:	89 1c 24             	mov    %ebx,(%esp)
  801a5e:	e8 b0 fc ff ff       	call   801713 <fstat>
  801a63:	89 c6                	mov    %eax,%esi
	close(fd);
  801a65:	89 1c 24             	mov    %ebx,(%esp)
  801a68:	e8 91 ff ff ff       	call   8019fe <close>
  801a6d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801a6f:	89 d8                	mov    %ebx,%eax
  801a71:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a74:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a77:	89 ec                	mov    %ebp,%esp
  801a79:	5d                   	pop    %ebp
  801a7a:	c3                   	ret    

00801a7b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	53                   	push   %ebx
  801a7f:	83 ec 14             	sub    $0x14,%esp
  801a82:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801a87:	89 1c 24             	mov    %ebx,(%esp)
  801a8a:	e8 6f ff ff ff       	call   8019fe <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801a8f:	83 c3 01             	add    $0x1,%ebx
  801a92:	83 fb 20             	cmp    $0x20,%ebx
  801a95:	75 f0                	jne    801a87 <close_all+0xc>
		close(i);
}
  801a97:	83 c4 14             	add    $0x14,%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5d                   	pop    %ebp
  801a9c:	c3                   	ret    

00801a9d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 58             	sub    $0x58,%esp
  801aa3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801aa6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801aa9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801aac:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801aaf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	89 04 24             	mov    %eax,(%esp)
  801abc:	e8 7f fb ff ff       	call   801640 <fd_lookup>
  801ac1:	89 c3                	mov    %eax,%ebx
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	0f 88 e0 00 00 00    	js     801bab <dup+0x10e>
		return r;
	close(newfdnum);
  801acb:	89 3c 24             	mov    %edi,(%esp)
  801ace:	e8 2b ff ff ff       	call   8019fe <close>

	newfd = INDEX2FD(newfdnum);
  801ad3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801ad9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801adf:	89 04 24             	mov    %eax,(%esp)
  801ae2:	e8 e5 fa ff ff       	call   8015cc <fd2data>
  801ae7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801ae9:	89 34 24             	mov    %esi,(%esp)
  801aec:	e8 db fa ff ff       	call   8015cc <fd2data>
  801af1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801af4:	89 da                	mov    %ebx,%edx
  801af6:	89 d8                	mov    %ebx,%eax
  801af8:	c1 e8 16             	shr    $0x16,%eax
  801afb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b02:	a8 01                	test   $0x1,%al
  801b04:	74 43                	je     801b49 <dup+0xac>
  801b06:	c1 ea 0c             	shr    $0xc,%edx
  801b09:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b10:	a8 01                	test   $0x1,%al
  801b12:	74 35                	je     801b49 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b14:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b1b:	25 07 0e 00 00       	and    $0xe07,%eax
  801b20:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b32:	00 
  801b33:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b3e:	e8 3d f5 ff ff       	call   801080 <sys_page_map>
  801b43:	89 c3                	mov    %eax,%ebx
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 3f                	js     801b88 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b4c:	89 c2                	mov    %eax,%edx
  801b4e:	c1 ea 0c             	shr    $0xc,%edx
  801b51:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b58:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801b5e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801b62:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801b66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b6d:	00 
  801b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b79:	e8 02 f5 ff ff       	call   801080 <sys_page_map>
  801b7e:	89 c3                	mov    %eax,%ebx
  801b80:	85 c0                	test   %eax,%eax
  801b82:	78 04                	js     801b88 <dup+0xeb>
  801b84:	89 fb                	mov    %edi,%ebx
  801b86:	eb 23                	jmp    801bab <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b88:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b93:	e8 8a f4 ff ff       	call   801022 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ba6:	e8 77 f4 ff ff       	call   801022 <sys_page_unmap>
	return r;
}
  801bab:	89 d8                	mov    %ebx,%eax
  801bad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801bb0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bb3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801bb6:	89 ec                	mov    %ebp,%esp
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    
	...

00801bbc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	56                   	push   %esi
  801bc0:	53                   	push   %ebx
  801bc1:	83 ec 10             	sub    $0x10,%esp
  801bc4:	89 c3                	mov    %eax,%ebx
  801bc6:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801bc8:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bcf:	75 11                	jne    801be2 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bd8:	e8 7b 0e 00 00       	call   802a58 <ipc_find_env>
  801bdd:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801be2:	a1 20 54 80 00       	mov    0x805420,%eax
  801be7:	8b 40 48             	mov    0x48(%eax),%eax
  801bea:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801bf0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801bf4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfc:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  801c03:	e8 31 e7 ff ff       	call   800339 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c08:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c0f:	00 
  801c10:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c17:	00 
  801c18:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c1c:	a1 00 50 80 00       	mov    0x805000,%eax
  801c21:	89 04 24             	mov    %eax,(%esp)
  801c24:	e8 65 0e 00 00       	call   802a8e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c29:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c30:	00 
  801c31:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c3c:	e8 b9 0e 00 00       	call   802afa <ipc_recv>
}
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5d                   	pop    %ebp
  801c47:	c3                   	ret    

00801c48 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8b 40 0c             	mov    0xc(%eax),%eax
  801c54:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c61:	ba 00 00 00 00       	mov    $0x0,%edx
  801c66:	b8 02 00 00 00       	mov    $0x2,%eax
  801c6b:	e8 4c ff ff ff       	call   801bbc <fsipc>
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c83:	ba 00 00 00 00       	mov    $0x0,%edx
  801c88:	b8 06 00 00 00       	mov    $0x6,%eax
  801c8d:	e8 2a ff ff ff       	call   801bbc <fsipc>
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9f:	b8 08 00 00 00       	mov    $0x8,%eax
  801ca4:	e8 13 ff ff ff       	call   801bbc <fsipc>
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	53                   	push   %ebx
  801caf:	83 ec 14             	sub    $0x14,%esp
  801cb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	8b 40 0c             	mov    0xc(%eax),%eax
  801cbb:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc5:	b8 05 00 00 00       	mov    $0x5,%eax
  801cca:	e8 ed fe ff ff       	call   801bbc <fsipc>
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	78 2b                	js     801cfe <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cd3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cda:	00 
  801cdb:	89 1c 24             	mov    %ebx,(%esp)
  801cde:	e8 b6 ec ff ff       	call   800999 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ce3:	a1 80 60 80 00       	mov    0x806080,%eax
  801ce8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cee:	a1 84 60 80 00       	mov    0x806084,%eax
  801cf3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801cfe:	83 c4 14             	add    $0x14,%esp
  801d01:	5b                   	pop    %ebx
  801d02:	5d                   	pop    %ebp
  801d03:	c3                   	ret    

00801d04 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	53                   	push   %ebx
  801d08:	83 ec 14             	sub    $0x14,%esp
  801d0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8b 40 0c             	mov    0xc(%eax),%eax
  801d14:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d19:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801d1f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801d25:	76 24                	jbe    801d4b <devfile_write+0x47>
  801d27:	c7 44 24 0c 36 34 80 	movl   $0x803436,0xc(%esp)
  801d2e:	00 
  801d2f:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  801d36:	00 
  801d37:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801d3e:	00 
  801d3f:	c7 04 24 55 34 80 00 	movl   $0x803455,(%esp)
  801d46:	e8 35 e5 ff ff       	call   800280 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801d4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d56:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801d5d:	e8 dd ed ff ff       	call   800b3f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801d62:	ba 00 00 00 00       	mov    $0x0,%edx
  801d67:	b8 04 00 00 00       	mov    $0x4,%eax
  801d6c:	e8 4b fe ff ff       	call   801bbc <fsipc>
	if(ret<0) return ret;
  801d71:	85 c0                	test   %eax,%eax
  801d73:	78 53                	js     801dc8 <devfile_write+0xc4>
	
	assert(ret <= n);
  801d75:	39 c3                	cmp    %eax,%ebx
  801d77:	73 24                	jae    801d9d <devfile_write+0x99>
  801d79:	c7 44 24 0c 60 34 80 	movl   $0x803460,0xc(%esp)
  801d80:	00 
  801d81:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  801d88:	00 
  801d89:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801d90:	00 
  801d91:	c7 04 24 55 34 80 00 	movl   $0x803455,(%esp)
  801d98:	e8 e3 e4 ff ff       	call   800280 <_panic>
	assert(ret <= PGSIZE);
  801d9d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801da2:	7e 24                	jle    801dc8 <devfile_write+0xc4>
  801da4:	c7 44 24 0c 69 34 80 	movl   $0x803469,0xc(%esp)
  801dab:	00 
  801dac:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  801db3:	00 
  801db4:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801dbb:	00 
  801dbc:	c7 04 24 55 34 80 00 	movl   $0x803455,(%esp)
  801dc3:	e8 b8 e4 ff ff       	call   800280 <_panic>
	return ret;
}
  801dc8:	83 c4 14             	add    $0x14,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	56                   	push   %esi
  801dd2:	53                   	push   %ebx
  801dd3:	83 ec 10             	sub    $0x10,%esp
  801dd6:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddf:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801de4:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dea:	ba 00 00 00 00       	mov    $0x0,%edx
  801def:	b8 03 00 00 00       	mov    $0x3,%eax
  801df4:	e8 c3 fd ff ff       	call   801bbc <fsipc>
  801df9:	89 c3                	mov    %eax,%ebx
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	78 6b                	js     801e6a <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801dff:	39 de                	cmp    %ebx,%esi
  801e01:	73 24                	jae    801e27 <devfile_read+0x59>
  801e03:	c7 44 24 0c 77 34 80 	movl   $0x803477,0xc(%esp)
  801e0a:	00 
  801e0b:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  801e12:	00 
  801e13:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801e1a:	00 
  801e1b:	c7 04 24 55 34 80 00 	movl   $0x803455,(%esp)
  801e22:	e8 59 e4 ff ff       	call   800280 <_panic>
	assert(r <= PGSIZE);
  801e27:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801e2d:	7e 24                	jle    801e53 <devfile_read+0x85>
  801e2f:	c7 44 24 0c 7e 34 80 	movl   $0x80347e,0xc(%esp)
  801e36:	00 
  801e37:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  801e3e:	00 
  801e3f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e46:	00 
  801e47:	c7 04 24 55 34 80 00 	movl   $0x803455,(%esp)
  801e4e:	e8 2d e4 ff ff       	call   800280 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e53:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e57:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e5e:	00 
  801e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e62:	89 04 24             	mov    %eax,(%esp)
  801e65:	e8 d5 ec ff ff       	call   800b3f <memmove>
	return r;
}
  801e6a:	89 d8                	mov    %ebx,%eax
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5e                   	pop    %esi
  801e71:	5d                   	pop    %ebp
  801e72:	c3                   	ret    

00801e73 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 28             	sub    $0x28,%esp
  801e79:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e7c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e7f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e82:	89 34 24             	mov    %esi,(%esp)
  801e85:	e8 d6 ea ff ff       	call   800960 <strlen>
  801e8a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e8f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e94:	7f 5e                	jg     801ef4 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e99:	89 04 24             	mov    %eax,(%esp)
  801e9c:	e8 46 f7 ff ff       	call   8015e7 <fd_alloc>
  801ea1:	89 c3                	mov    %eax,%ebx
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	78 4d                	js     801ef4 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801ea7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eab:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801eb2:	e8 e2 ea ff ff       	call   800999 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eba:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec7:	e8 f0 fc ff ff       	call   801bbc <fsipc>
  801ecc:	89 c3                	mov    %eax,%ebx
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	79 15                	jns    801ee7 <open+0x74>
		fd_close(fd, 0);
  801ed2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ed9:	00 
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	89 04 24             	mov    %eax,(%esp)
  801ee0:	e8 87 fa ff ff       	call   80196c <fd_close>
		return r;
  801ee5:	eb 0d                	jmp    801ef4 <open+0x81>
	}

	return fd2num(fd);
  801ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eea:	89 04 24             	mov    %eax,(%esp)
  801eed:	e8 ca f6 ff ff       	call   8015bc <fd2num>
  801ef2:	89 c3                	mov    %eax,%ebx
}
  801ef4:	89 d8                	mov    %ebx,%eax
  801ef6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ef9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801efc:	89 ec                	mov    %ebp,%esp
  801efe:	5d                   	pop    %ebp
  801eff:	c3                   	ret    

00801f00 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f06:	c7 44 24 04 8a 34 80 	movl   $0x80348a,0x4(%esp)
  801f0d:	00 
  801f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f11:	89 04 24             	mov    %eax,(%esp)
  801f14:	e8 80 ea ff ff       	call   800999 <strcpy>
	return 0;
}
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	53                   	push   %ebx
  801f24:	83 ec 14             	sub    $0x14,%esp
  801f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f2a:	89 1c 24             	mov    %ebx,(%esp)
  801f2d:	e8 52 0c 00 00       	call   802b84 <pageref>
  801f32:	89 c2                	mov    %eax,%edx
  801f34:	b8 00 00 00 00       	mov    $0x0,%eax
  801f39:	83 fa 01             	cmp    $0x1,%edx
  801f3c:	75 0b                	jne    801f49 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f3e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f41:	89 04 24             	mov    %eax,(%esp)
  801f44:	e8 b1 02 00 00       	call   8021fa <nsipc_close>
	else
		return 0;
}
  801f49:	83 c4 14             	add    $0x14,%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5d                   	pop    %ebp
  801f4e:	c3                   	ret    

00801f4f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f55:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f5c:	00 
  801f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f60:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f71:	89 04 24             	mov    %eax,(%esp)
  801f74:	e8 bd 02 00 00       	call   802236 <nsipc_send>
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f81:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f88:	00 
  801f89:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9d:	89 04 24             	mov    %eax,(%esp)
  801fa0:	e8 04 03 00 00       	call   8022a9 <nsipc_recv>
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	56                   	push   %esi
  801fab:	53                   	push   %ebx
  801fac:	83 ec 20             	sub    $0x20,%esp
  801faf:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb4:	89 04 24             	mov    %eax,(%esp)
  801fb7:	e8 2b f6 ff ff       	call   8015e7 <fd_alloc>
  801fbc:	89 c3                	mov    %eax,%ebx
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	78 21                	js     801fe3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fc2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fc9:	00 
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd8:	e8 01 f1 ff ff       	call   8010de <sys_page_alloc>
  801fdd:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	79 0a                	jns    801fed <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801fe3:	89 34 24             	mov    %esi,(%esp)
  801fe6:	e8 0f 02 00 00       	call   8021fa <nsipc_close>
		return r;
  801feb:	eb 28                	jmp    802015 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fed:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	89 04 24             	mov    %eax,(%esp)
  80200e:	e8 a9 f5 ff ff       	call   8015bc <fd2num>
  802013:	89 c3                	mov    %eax,%ebx
}
  802015:	89 d8                	mov    %ebx,%eax
  802017:	83 c4 20             	add    $0x20,%esp
  80201a:	5b                   	pop    %ebx
  80201b:	5e                   	pop    %esi
  80201c:	5d                   	pop    %ebp
  80201d:	c3                   	ret    

0080201e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802024:	8b 45 10             	mov    0x10(%ebp),%eax
  802027:	89 44 24 08          	mov    %eax,0x8(%esp)
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	89 04 24             	mov    %eax,(%esp)
  802038:	e8 71 01 00 00       	call   8021ae <nsipc_socket>
  80203d:	85 c0                	test   %eax,%eax
  80203f:	78 05                	js     802046 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802041:	e8 61 ff ff ff       	call   801fa7 <alloc_sockfd>
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80204e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802051:	89 54 24 04          	mov    %edx,0x4(%esp)
  802055:	89 04 24             	mov    %eax,(%esp)
  802058:	e8 e3 f5 ff ff       	call   801640 <fd_lookup>
  80205d:	85 c0                	test   %eax,%eax
  80205f:	78 15                	js     802076 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802064:	8b 0a                	mov    (%edx),%ecx
  802066:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80206b:	3b 0d 20 40 80 00    	cmp    0x804020,%ecx
  802071:	75 03                	jne    802076 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802073:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	e8 c2 ff ff ff       	call   802048 <fd2sockid>
  802086:	85 c0                	test   %eax,%eax
  802088:	78 0f                	js     802099 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80208a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802091:	89 04 24             	mov    %eax,(%esp)
  802094:	e8 3f 01 00 00       	call   8021d8 <nsipc_listen>
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	e8 9f ff ff ff       	call   802048 <fd2sockid>
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	78 16                	js     8020c3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8020ad:	8b 55 10             	mov    0x10(%ebp),%edx
  8020b0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020bb:	89 04 24             	mov    %eax,(%esp)
  8020be:	e8 66 02 00 00       	call   802329 <nsipc_connect>
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	e8 75 ff ff ff       	call   802048 <fd2sockid>
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 0f                	js     8020e6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8020d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020da:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020de:	89 04 24             	mov    %eax,(%esp)
  8020e1:	e8 2e 01 00 00       	call   802214 <nsipc_shutdown>
}
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	e8 52 ff ff ff       	call   802048 <fd2sockid>
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	78 16                	js     802110 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8020fa:	8b 55 10             	mov    0x10(%ebp),%edx
  8020fd:	89 54 24 08          	mov    %edx,0x8(%esp)
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	89 54 24 04          	mov    %edx,0x4(%esp)
  802108:	89 04 24             	mov    %eax,(%esp)
  80210b:	e8 58 02 00 00       	call   802368 <nsipc_bind>
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	e8 28 ff ff ff       	call   802048 <fd2sockid>
  802120:	85 c0                	test   %eax,%eax
  802122:	78 1f                	js     802143 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802124:	8b 55 10             	mov    0x10(%ebp),%edx
  802127:	89 54 24 08          	mov    %edx,0x8(%esp)
  80212b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802132:	89 04 24             	mov    %eax,(%esp)
  802135:	e8 6d 02 00 00       	call   8023a7 <nsipc_accept>
  80213a:	85 c0                	test   %eax,%eax
  80213c:	78 05                	js     802143 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80213e:	e8 64 fe ff ff       	call   801fa7 <alloc_sockfd>
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    
  802145:	00 00                	add    %al,(%eax)
	...

00802148 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	53                   	push   %ebx
  80214c:	83 ec 14             	sub    $0x14,%esp
  80214f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802151:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802158:	75 11                	jne    80216b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80215a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802161:	e8 f2 08 00 00       	call   802a58 <ipc_find_env>
  802166:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80216b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802172:	00 
  802173:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  80217a:	00 
  80217b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80217f:	a1 04 50 80 00       	mov    0x805004,%eax
  802184:	89 04 24             	mov    %eax,(%esp)
  802187:	e8 02 09 00 00       	call   802a8e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80218c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802193:	00 
  802194:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80219b:	00 
  80219c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a3:	e8 52 09 00 00       	call   802afa <ipc_recv>
}
  8021a8:	83 c4 14             	add    $0x14,%esp
  8021ab:	5b                   	pop    %ebx
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    

008021ae <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8021bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bf:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8021c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8021cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8021d1:	e8 72 ff ff ff       	call   802148 <nsipc>
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8021ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8021f3:	e8 50 ff ff ff       	call   802148 <nsipc>
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802208:	b8 04 00 00 00       	mov    $0x4,%eax
  80220d:	e8 36 ff ff ff       	call   802148 <nsipc>
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802222:	8b 45 0c             	mov    0xc(%ebp),%eax
  802225:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80222a:	b8 03 00 00 00       	mov    $0x3,%eax
  80222f:	e8 14 ff ff ff       	call   802148 <nsipc>
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	53                   	push   %ebx
  80223a:	83 ec 14             	sub    $0x14,%esp
  80223d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802248:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80224e:	7e 24                	jle    802274 <nsipc_send+0x3e>
  802250:	c7 44 24 0c 96 34 80 	movl   $0x803496,0xc(%esp)
  802257:	00 
  802258:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  80225f:	00 
  802260:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802267:	00 
  802268:	c7 04 24 a2 34 80 00 	movl   $0x8034a2,(%esp)
  80226f:	e8 0c e0 ff ff       	call   800280 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802274:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802286:	e8 b4 e8 ff ff       	call   800b3f <memmove>
	nsipcbuf.send.req_size = size;
  80228b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802291:	8b 45 14             	mov    0x14(%ebp),%eax
  802294:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802299:	b8 08 00 00 00       	mov    $0x8,%eax
  80229e:	e8 a5 fe ff ff       	call   802148 <nsipc>
}
  8022a3:	83 c4 14             	add    $0x14,%esp
  8022a6:	5b                   	pop    %ebx
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    

008022a9 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	83 ec 10             	sub    $0x10,%esp
  8022b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8022bc:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8022c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c5:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022ca:	b8 07 00 00 00       	mov    $0x7,%eax
  8022cf:	e8 74 fe ff ff       	call   802148 <nsipc>
  8022d4:	89 c3                	mov    %eax,%ebx
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	78 46                	js     802320 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022da:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022df:	7f 04                	jg     8022e5 <nsipc_recv+0x3c>
  8022e1:	39 c6                	cmp    %eax,%esi
  8022e3:	7d 24                	jge    802309 <nsipc_recv+0x60>
  8022e5:	c7 44 24 0c ae 34 80 	movl   $0x8034ae,0xc(%esp)
  8022ec:	00 
  8022ed:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  8022f4:	00 
  8022f5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8022fc:	00 
  8022fd:	c7 04 24 a2 34 80 00 	movl   $0x8034a2,(%esp)
  802304:	e8 77 df ff ff       	call   800280 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802309:	89 44 24 08          	mov    %eax,0x8(%esp)
  80230d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802314:	00 
  802315:	8b 45 0c             	mov    0xc(%ebp),%eax
  802318:	89 04 24             	mov    %eax,(%esp)
  80231b:	e8 1f e8 ff ff       	call   800b3f <memmove>
	}

	return r;
}
  802320:	89 d8                	mov    %ebx,%eax
  802322:	83 c4 10             	add    $0x10,%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    

00802329 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	53                   	push   %ebx
  80232d:	83 ec 14             	sub    $0x14,%esp
  802330:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80233b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80233f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802342:	89 44 24 04          	mov    %eax,0x4(%esp)
  802346:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80234d:	e8 ed e7 ff ff       	call   800b3f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802352:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802358:	b8 05 00 00 00       	mov    $0x5,%eax
  80235d:	e8 e6 fd ff ff       	call   802148 <nsipc>
}
  802362:	83 c4 14             	add    $0x14,%esp
  802365:	5b                   	pop    %ebx
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    

00802368 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	53                   	push   %ebx
  80236c:	83 ec 14             	sub    $0x14,%esp
  80236f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80237a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80237e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802381:	89 44 24 04          	mov    %eax,0x4(%esp)
  802385:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80238c:	e8 ae e7 ff ff       	call   800b3f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802391:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802397:	b8 02 00 00 00       	mov    $0x2,%eax
  80239c:	e8 a7 fd ff ff       	call   802148 <nsipc>
}
  8023a1:	83 c4 14             	add    $0x14,%esp
  8023a4:	5b                   	pop    %ebx
  8023a5:	5d                   	pop    %ebp
  8023a6:	c3                   	ret    

008023a7 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	83 ec 28             	sub    $0x28,%esp
  8023ad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023b0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023b3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023b6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8023c1:	8b 07                	mov    (%edi),%eax
  8023c3:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8023cd:	e8 76 fd ff ff       	call   802148 <nsipc>
  8023d2:	89 c6                	mov    %eax,%esi
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	78 22                	js     8023fa <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023d8:	bb 10 80 80 00       	mov    $0x808010,%ebx
  8023dd:	8b 03                	mov    (%ebx),%eax
  8023df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e3:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8023ea:	00 
  8023eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ee:	89 04 24             	mov    %eax,(%esp)
  8023f1:	e8 49 e7 ff ff       	call   800b3f <memmove>
		*addrlen = ret->ret_addrlen;
  8023f6:	8b 03                	mov    (%ebx),%eax
  8023f8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8023fa:	89 f0                	mov    %esi,%eax
  8023fc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023ff:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802402:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802405:	89 ec                	mov    %ebp,%esp
  802407:	5d                   	pop    %ebp
  802408:	c3                   	ret    
  802409:	00 00                	add    %al,(%eax)
	...

0080240c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	83 ec 18             	sub    $0x18,%esp
  802412:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802415:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802418:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	89 04 24             	mov    %eax,(%esp)
  802421:	e8 a6 f1 ff ff       	call   8015cc <fd2data>
  802426:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802428:	c7 44 24 04 c3 34 80 	movl   $0x8034c3,0x4(%esp)
  80242f:	00 
  802430:	89 34 24             	mov    %esi,(%esp)
  802433:	e8 61 e5 ff ff       	call   800999 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802438:	8b 43 04             	mov    0x4(%ebx),%eax
  80243b:	2b 03                	sub    (%ebx),%eax
  80243d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802443:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80244a:	00 00 00 
	stat->st_dev = &devpipe;
  80244d:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  802454:	40 80 00 
	return 0;
}
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
  80245c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80245f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802462:	89 ec                	mov    %ebp,%esp
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    

00802466 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	53                   	push   %ebx
  80246a:	83 ec 14             	sub    $0x14,%esp
  80246d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802470:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80247b:	e8 a2 eb ff ff       	call   801022 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802480:	89 1c 24             	mov    %ebx,(%esp)
  802483:	e8 44 f1 ff ff       	call   8015cc <fd2data>
  802488:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802493:	e8 8a eb ff ff       	call   801022 <sys_page_unmap>
}
  802498:	83 c4 14             	add    $0x14,%esp
  80249b:	5b                   	pop    %ebx
  80249c:	5d                   	pop    %ebp
  80249d:	c3                   	ret    

0080249e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	57                   	push   %edi
  8024a2:	56                   	push   %esi
  8024a3:	53                   	push   %ebx
  8024a4:	83 ec 2c             	sub    $0x2c,%esp
  8024a7:	89 c7                	mov    %eax,%edi
  8024a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8024ac:	a1 20 54 80 00       	mov    0x805420,%eax
  8024b1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024b4:	89 3c 24             	mov    %edi,(%esp)
  8024b7:	e8 c8 06 00 00       	call   802b84 <pageref>
  8024bc:	89 c6                	mov    %eax,%esi
  8024be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c1:	89 04 24             	mov    %eax,(%esp)
  8024c4:	e8 bb 06 00 00       	call   802b84 <pageref>
  8024c9:	39 c6                	cmp    %eax,%esi
  8024cb:	0f 94 c0             	sete   %al
  8024ce:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8024d1:	8b 15 20 54 80 00    	mov    0x805420,%edx
  8024d7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024da:	39 cb                	cmp    %ecx,%ebx
  8024dc:	75 08                	jne    8024e6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8024de:	83 c4 2c             	add    $0x2c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8024e6:	83 f8 01             	cmp    $0x1,%eax
  8024e9:	75 c1                	jne    8024ac <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024eb:	8b 52 58             	mov    0x58(%edx),%edx
  8024ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024f2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024fa:	c7 04 24 ca 34 80 00 	movl   $0x8034ca,(%esp)
  802501:	e8 33 de ff ff       	call   800339 <cprintf>
  802506:	eb a4                	jmp    8024ac <_pipeisclosed+0xe>

00802508 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	57                   	push   %edi
  80250c:	56                   	push   %esi
  80250d:	53                   	push   %ebx
  80250e:	83 ec 1c             	sub    $0x1c,%esp
  802511:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802514:	89 34 24             	mov    %esi,(%esp)
  802517:	e8 b0 f0 ff ff       	call   8015cc <fd2data>
  80251c:	89 c3                	mov    %eax,%ebx
  80251e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802523:	eb 48                	jmp    80256d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802525:	89 da                	mov    %ebx,%edx
  802527:	89 f0                	mov    %esi,%eax
  802529:	e8 70 ff ff ff       	call   80249e <_pipeisclosed>
  80252e:	85 c0                	test   %eax,%eax
  802530:	74 07                	je     802539 <devpipe_write+0x31>
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
  802537:	eb 3b                	jmp    802574 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802539:	e8 ff eb ff ff       	call   80113d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80253e:	8b 43 04             	mov    0x4(%ebx),%eax
  802541:	8b 13                	mov    (%ebx),%edx
  802543:	83 c2 20             	add    $0x20,%edx
  802546:	39 d0                	cmp    %edx,%eax
  802548:	73 db                	jae    802525 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80254a:	89 c2                	mov    %eax,%edx
  80254c:	c1 fa 1f             	sar    $0x1f,%edx
  80254f:	c1 ea 1b             	shr    $0x1b,%edx
  802552:	01 d0                	add    %edx,%eax
  802554:	83 e0 1f             	and    $0x1f,%eax
  802557:	29 d0                	sub    %edx,%eax
  802559:	89 c2                	mov    %eax,%edx
  80255b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80255e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802562:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802566:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80256a:	83 c7 01             	add    $0x1,%edi
  80256d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802570:	72 cc                	jb     80253e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802572:	89 f8                	mov    %edi,%eax
}
  802574:	83 c4 1c             	add    $0x1c,%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5f                   	pop    %edi
  80257a:	5d                   	pop    %ebp
  80257b:	c3                   	ret    

0080257c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	83 ec 28             	sub    $0x28,%esp
  802582:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802585:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802588:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80258b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80258e:	89 3c 24             	mov    %edi,(%esp)
  802591:	e8 36 f0 ff ff       	call   8015cc <fd2data>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80259d:	eb 48                	jmp    8025e7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80259f:	85 f6                	test   %esi,%esi
  8025a1:	74 04                	je     8025a7 <devpipe_read+0x2b>
				return i;
  8025a3:	89 f0                	mov    %esi,%eax
  8025a5:	eb 47                	jmp    8025ee <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8025a7:	89 da                	mov    %ebx,%edx
  8025a9:	89 f8                	mov    %edi,%eax
  8025ab:	e8 ee fe ff ff       	call   80249e <_pipeisclosed>
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	74 07                	je     8025bb <devpipe_read+0x3f>
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b9:	eb 33                	jmp    8025ee <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8025bb:	e8 7d eb ff ff       	call   80113d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8025c0:	8b 03                	mov    (%ebx),%eax
  8025c2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025c5:	74 d8                	je     80259f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025c7:	89 c2                	mov    %eax,%edx
  8025c9:	c1 fa 1f             	sar    $0x1f,%edx
  8025cc:	c1 ea 1b             	shr    $0x1b,%edx
  8025cf:	01 d0                	add    %edx,%eax
  8025d1:	83 e0 1f             	and    $0x1f,%eax
  8025d4:	29 d0                	sub    %edx,%eax
  8025d6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025de:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8025e1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025e4:	83 c6 01             	add    $0x1,%esi
  8025e7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ea:	72 d4                	jb     8025c0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025ec:	89 f0                	mov    %esi,%eax
}
  8025ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025f1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025f7:	89 ec                	mov    %ebp,%esp
  8025f9:	5d                   	pop    %ebp
  8025fa:	c3                   	ret    

008025fb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802601:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802604:	89 44 24 04          	mov    %eax,0x4(%esp)
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	89 04 24             	mov    %eax,(%esp)
  80260e:	e8 2d f0 ff ff       	call   801640 <fd_lookup>
  802613:	85 c0                	test   %eax,%eax
  802615:	78 15                	js     80262c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	89 04 24             	mov    %eax,(%esp)
  80261d:	e8 aa ef ff ff       	call   8015cc <fd2data>
	return _pipeisclosed(fd, p);
  802622:	89 c2                	mov    %eax,%edx
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	e8 72 fe ff ff       	call   80249e <_pipeisclosed>
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 48             	sub    $0x48,%esp
  802634:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802637:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80263a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80263d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802640:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802643:	89 04 24             	mov    %eax,(%esp)
  802646:	e8 9c ef ff ff       	call   8015e7 <fd_alloc>
  80264b:	89 c3                	mov    %eax,%ebx
  80264d:	85 c0                	test   %eax,%eax
  80264f:	0f 88 42 01 00 00    	js     802797 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802655:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80265c:	00 
  80265d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802660:	89 44 24 04          	mov    %eax,0x4(%esp)
  802664:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80266b:	e8 6e ea ff ff       	call   8010de <sys_page_alloc>
  802670:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802672:	85 c0                	test   %eax,%eax
  802674:	0f 88 1d 01 00 00    	js     802797 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80267a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80267d:	89 04 24             	mov    %eax,(%esp)
  802680:	e8 62 ef ff ff       	call   8015e7 <fd_alloc>
  802685:	89 c3                	mov    %eax,%ebx
  802687:	85 c0                	test   %eax,%eax
  802689:	0f 88 f5 00 00 00    	js     802784 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80268f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802696:	00 
  802697:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80269e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a5:	e8 34 ea ff ff       	call   8010de <sys_page_alloc>
  8026aa:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	0f 88 d0 00 00 00    	js     802784 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8026b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b7:	89 04 24             	mov    %eax,(%esp)
  8026ba:	e8 0d ef ff ff       	call   8015cc <fd2data>
  8026bf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026c8:	00 
  8026c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d4:	e8 05 ea ff ff       	call   8010de <sys_page_alloc>
  8026d9:	89 c3                	mov    %eax,%ebx
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	0f 88 8e 00 00 00    	js     802771 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e6:	89 04 24             	mov    %eax,(%esp)
  8026e9:	e8 de ee ff ff       	call   8015cc <fd2data>
  8026ee:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026f5:	00 
  8026f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802701:	00 
  802702:	89 74 24 04          	mov    %esi,0x4(%esp)
  802706:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80270d:	e8 6e e9 ff ff       	call   801080 <sys_page_map>
  802712:	89 c3                	mov    %eax,%ebx
  802714:	85 c0                	test   %eax,%eax
  802716:	78 49                	js     802761 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802718:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  80271d:	8b 08                	mov    (%eax),%ecx
  80271f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802722:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802724:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802727:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80272e:	8b 10                	mov    (%eax),%edx
  802730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802733:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802735:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802738:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80273f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802742:	89 04 24             	mov    %eax,(%esp)
  802745:	e8 72 ee ff ff       	call   8015bc <fd2num>
  80274a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80274c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274f:	89 04 24             	mov    %eax,(%esp)
  802752:	e8 65 ee ff ff       	call   8015bc <fd2num>
  802757:	89 47 04             	mov    %eax,0x4(%edi)
  80275a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80275f:	eb 36                	jmp    802797 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802761:	89 74 24 04          	mov    %esi,0x4(%esp)
  802765:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80276c:	e8 b1 e8 ff ff       	call   801022 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802771:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802774:	89 44 24 04          	mov    %eax,0x4(%esp)
  802778:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80277f:	e8 9e e8 ff ff       	call   801022 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802787:	89 44 24 04          	mov    %eax,0x4(%esp)
  80278b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802792:	e8 8b e8 ff ff       	call   801022 <sys_page_unmap>
    err:
	return r;
}
  802797:	89 d8                	mov    %ebx,%eax
  802799:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80279c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80279f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8027a2:	89 ec                	mov    %ebp,%esp
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    
	...

008027a8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
  8027ab:	56                   	push   %esi
  8027ac:	53                   	push   %ebx
  8027ad:	83 ec 10             	sub    $0x10,%esp
  8027b0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8027b3:	85 f6                	test   %esi,%esi
  8027b5:	75 24                	jne    8027db <wait+0x33>
  8027b7:	c7 44 24 0c e2 34 80 	movl   $0x8034e2,0xc(%esp)
  8027be:	00 
  8027bf:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  8027c6:	00 
  8027c7:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8027ce:	00 
  8027cf:	c7 04 24 ed 34 80 00 	movl   $0x8034ed,(%esp)
  8027d6:	e8 a5 da ff ff       	call   800280 <_panic>
	e = &envs[ENVX(envid)];
  8027db:	89 f3                	mov    %esi,%ebx
  8027dd:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8027e3:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8027e6:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027ec:	eb 05                	jmp    8027f3 <wait+0x4b>
		sys_yield();
  8027ee:	e8 4a e9 ff ff       	call   80113d <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027f3:	8b 43 48             	mov    0x48(%ebx),%eax
  8027f6:	39 f0                	cmp    %esi,%eax
  8027f8:	75 07                	jne    802801 <wait+0x59>
  8027fa:	8b 43 54             	mov    0x54(%ebx),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	75 ed                	jne    8027ee <wait+0x46>
		sys_yield();
}
  802801:	83 c4 10             	add    $0x10,%esp
  802804:	5b                   	pop    %ebx
  802805:	5e                   	pop    %esi
  802806:	5d                   	pop    %ebp
  802807:	c3                   	ret    
	...

00802810 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802813:	b8 00 00 00 00       	mov    $0x0,%eax
  802818:	5d                   	pop    %ebp
  802819:	c3                   	ret    

0080281a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
  80281d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802820:	c7 44 24 04 f8 34 80 	movl   $0x8034f8,0x4(%esp)
  802827:	00 
  802828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80282b:	89 04 24             	mov    %eax,(%esp)
  80282e:	e8 66 e1 ff ff       	call   800999 <strcpy>
	return 0;
}
  802833:	b8 00 00 00 00       	mov    $0x0,%eax
  802838:	c9                   	leave  
  802839:	c3                   	ret    

0080283a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
  80283d:	57                   	push   %edi
  80283e:	56                   	push   %esi
  80283f:	53                   	push   %ebx
  802840:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802846:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80284b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802851:	eb 34                	jmp    802887 <devcons_write+0x4d>
		m = n - tot;
  802853:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802856:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802858:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  80285e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802863:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802866:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80286a:	03 45 0c             	add    0xc(%ebp),%eax
  80286d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802871:	89 3c 24             	mov    %edi,(%esp)
  802874:	e8 c6 e2 ff ff       	call   800b3f <memmove>
		sys_cputs(buf, m);
  802879:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80287d:	89 3c 24             	mov    %edi,(%esp)
  802880:	e8 cb e4 ff ff       	call   800d50 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802885:	01 de                	add    %ebx,%esi
  802887:	89 f0                	mov    %esi,%eax
  802889:	3b 75 10             	cmp    0x10(%ebp),%esi
  80288c:	72 c5                	jb     802853 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80288e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802894:	5b                   	pop    %ebx
  802895:	5e                   	pop    %esi
  802896:	5f                   	pop    %edi
  802897:	5d                   	pop    %ebp
  802898:	c3                   	ret    

00802899 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
  80289c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80289f:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8028a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028ac:	00 
  8028ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028b0:	89 04 24             	mov    %eax,(%esp)
  8028b3:	e8 98 e4 ff ff       	call   800d50 <sys_cputs>
}
  8028b8:	c9                   	leave  
  8028b9:	c3                   	ret    

008028ba <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028ba:	55                   	push   %ebp
  8028bb:	89 e5                	mov    %esp,%ebp
  8028bd:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8028c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028c4:	75 07                	jne    8028cd <devcons_read+0x13>
  8028c6:	eb 28                	jmp    8028f0 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8028c8:	e8 70 e8 ff ff       	call   80113d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8028cd:	8d 76 00             	lea    0x0(%esi),%esi
  8028d0:	e8 47 e4 ff ff       	call   800d1c <sys_cgetc>
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 ef                	je     8028c8 <devcons_read+0xe>
  8028d9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	78 16                	js     8028f5 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8028df:	83 f8 04             	cmp    $0x4,%eax
  8028e2:	74 0c                	je     8028f0 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8028e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e7:	88 10                	mov    %dl,(%eax)
  8028e9:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8028ee:	eb 05                	jmp    8028f5 <devcons_read+0x3b>
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802900:	89 04 24             	mov    %eax,(%esp)
  802903:	e8 df ec ff ff       	call   8015e7 <fd_alloc>
  802908:	85 c0                	test   %eax,%eax
  80290a:	78 3f                	js     80294b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80290c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802913:	00 
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	89 44 24 04          	mov    %eax,0x4(%esp)
  80291b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802922:	e8 b7 e7 ff ff       	call   8010de <sys_page_alloc>
  802927:	85 c0                	test   %eax,%eax
  802929:	78 20                	js     80294b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80292b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	89 04 24             	mov    %eax,(%esp)
  802946:	e8 71 ec ff ff       	call   8015bc <fd2num>
}
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
  802950:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802953:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802956:	89 44 24 04          	mov    %eax,0x4(%esp)
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	89 04 24             	mov    %eax,(%esp)
  802960:	e8 db ec ff ff       	call   801640 <fd_lookup>
  802965:	85 c0                	test   %eax,%eax
  802967:	78 11                	js     80297a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	3b 05 58 40 80 00    	cmp    0x804058,%eax
  802974:	0f 94 c0             	sete   %al
  802977:	0f b6 c0             	movzbl %al,%eax
}
  80297a:	c9                   	leave  
  80297b:	c3                   	ret    

0080297c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  80297c:	55                   	push   %ebp
  80297d:	89 e5                	mov    %esp,%ebp
  80297f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802982:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802989:	00 
  80298a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80298d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802991:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802998:	e8 fa ee ff ff       	call   801897 <read>
	if (r < 0)
  80299d:	85 c0                	test   %eax,%eax
  80299f:	78 0f                	js     8029b0 <getchar+0x34>
		return r;
	if (r < 1)
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	7f 07                	jg     8029ac <getchar+0x30>
  8029a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029aa:	eb 04                	jmp    8029b0 <getchar+0x34>
		return -E_EOF;
	return c;
  8029ac:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    
	...

008029b4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029b4:	55                   	push   %ebp
  8029b5:	89 e5                	mov    %esp,%ebp
  8029b7:	53                   	push   %ebx
  8029b8:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  8029bb:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8029c2:	75 5b                	jne    802a1f <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  8029c4:	e8 a8 e7 ff ff       	call   801171 <sys_getenvid>
  8029c9:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  8029cb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029d2:	00 
  8029d3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8029da:	ee 
  8029db:	89 04 24             	mov    %eax,(%esp)
  8029de:	e8 fb e6 ff ff       	call   8010de <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	74 28                	je     802a0f <set_pgfault_handler+0x5b>
  8029e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8029eb:	c7 44 24 0c 2b 35 80 	movl   $0x80352b,0xc(%esp)
  8029f2:	00 
  8029f3:	c7 44 24 08 04 35 80 	movl   $0x803504,0x8(%esp)
  8029fa:	00 
  8029fb:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802a02:	00 
  802a03:	c7 04 24 1d 35 80 00 	movl   $0x80351d,(%esp)
  802a0a:	e8 71 d8 ff ff       	call   800280 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802a0f:	c7 44 24 04 30 2a 80 	movl   $0x802a30,0x4(%esp)
  802a16:	00 
  802a17:	89 1c 24             	mov    %ebx,(%esp)
  802a1a:	e8 e9 e4 ff ff       	call   800f08 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	a3 00 90 80 00       	mov    %eax,0x809000
	
}
  802a27:	83 c4 24             	add    $0x24,%esp
  802a2a:	5b                   	pop    %ebx
  802a2b:	5d                   	pop    %ebp
  802a2c:	c3                   	ret    
  802a2d:	00 00                	add    %al,(%eax)
	...

00802a30 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a30:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a31:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  802a36:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a38:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  802a3b:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  802a3e:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  802a42:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  802a46:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  802a49:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  802a4c:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  802a50:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  802a51:	83 c4 04             	add    $0x4,%esp
	popfl ;
  802a54:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802a55:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802a56:	c3                   	ret    
	...

00802a58 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a58:	55                   	push   %ebp
  802a59:	89 e5                	mov    %esp,%ebp
  802a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a5e:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802a63:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802a66:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802a6c:	8b 12                	mov    (%edx),%edx
  802a6e:	39 ca                	cmp    %ecx,%edx
  802a70:	75 0c                	jne    802a7e <ipc_find_env+0x26>
			return envs[i].env_id;
  802a72:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802a75:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	eb 0e                	jmp    802a8c <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802a7e:	83 c0 01             	add    $0x1,%eax
  802a81:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a86:	75 db                	jne    802a63 <ipc_find_env+0xb>
  802a88:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802a8c:	5d                   	pop    %ebp
  802a8d:	c3                   	ret    

00802a8e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a8e:	55                   	push   %ebp
  802a8f:	89 e5                	mov    %esp,%ebp
  802a91:	57                   	push   %edi
  802a92:	56                   	push   %esi
  802a93:	53                   	push   %ebx
  802a94:	83 ec 2c             	sub    $0x2c,%esp
  802a97:	8b 75 08             	mov    0x8(%ebp),%esi
  802a9a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802aa0:	85 db                	test   %ebx,%ebx
  802aa2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802aa7:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  802aad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ab1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ab5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802ab9:	89 34 24             	mov    %esi,(%esp)
  802abc:	e8 0f e4 ff ff       	call   800ed0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802ac1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ac4:	74 e4                	je     802aaa <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 28                	je     802af2 <ipc_send+0x64>
  802aca:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ace:	c7 44 24 0c 5c 35 80 	movl   $0x80355c,0xc(%esp)
  802ad5:	00 
  802ad6:	c7 44 24 08 3f 35 80 	movl   $0x80353f,0x8(%esp)
  802add:	00 
  802ade:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802ae5:	00 
  802ae6:	c7 04 24 52 35 80 00 	movl   $0x803552,(%esp)
  802aed:	e8 8e d7 ff ff       	call   800280 <_panic>
	//if(!ret) sys_yield();
}
  802af2:	83 c4 2c             	add    $0x2c,%esp
  802af5:	5b                   	pop    %ebx
  802af6:	5e                   	pop    %esi
  802af7:	5f                   	pop    %edi
  802af8:	5d                   	pop    %ebp
  802af9:	c3                   	ret    

00802afa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802afa:	55                   	push   %ebp
  802afb:	89 e5                	mov    %esp,%ebp
  802afd:	83 ec 28             	sub    $0x28,%esp
  802b00:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b03:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b06:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802b09:	8b 75 08             	mov    0x8(%ebp),%esi
  802b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b0f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802b12:	85 c0                	test   %eax,%eax
  802b14:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802b19:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802b1c:	89 04 24             	mov    %eax,(%esp)
  802b1f:	e8 4f e3 ff ff       	call   800e73 <sys_ipc_recv>
  802b24:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802b26:	e8 46 e6 ff ff       	call   801171 <sys_getenvid>
  802b2b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b30:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802b33:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b38:	a3 20 54 80 00       	mov    %eax,0x805420
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802b3d:	85 f6                	test   %esi,%esi
  802b3f:	74 0e                	je     802b4f <ipc_recv+0x55>
  802b41:	ba 00 00 00 00       	mov    $0x0,%edx
  802b46:	85 db                	test   %ebx,%ebx
  802b48:	75 03                	jne    802b4d <ipc_recv+0x53>
  802b4a:	8b 50 74             	mov    0x74(%eax),%edx
  802b4d:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802b4f:	85 ff                	test   %edi,%edi
  802b51:	74 13                	je     802b66 <ipc_recv+0x6c>
  802b53:	b8 00 00 00 00       	mov    $0x0,%eax
  802b58:	85 db                	test   %ebx,%ebx
  802b5a:	75 08                	jne    802b64 <ipc_recv+0x6a>
  802b5c:	a1 20 54 80 00       	mov    0x805420,%eax
  802b61:	8b 40 78             	mov    0x78(%eax),%eax
  802b64:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802b66:	85 db                	test   %ebx,%ebx
  802b68:	75 08                	jne    802b72 <ipc_recv+0x78>
  802b6a:	a1 20 54 80 00       	mov    0x805420,%eax
  802b6f:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802b72:	89 d8                	mov    %ebx,%eax
  802b74:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802b77:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802b7a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802b7d:	89 ec                	mov    %ebp,%esp
  802b7f:	5d                   	pop    %ebp
  802b80:	c3                   	ret    
  802b81:	00 00                	add    %al,(%eax)
	...

00802b84 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	89 c2                	mov    %eax,%edx
  802b8c:	c1 ea 16             	shr    $0x16,%edx
  802b8f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802b96:	f6 c2 01             	test   $0x1,%dl
  802b99:	74 20                	je     802bbb <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b9b:	c1 e8 0c             	shr    $0xc,%eax
  802b9e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802ba5:	a8 01                	test   $0x1,%al
  802ba7:	74 12                	je     802bbb <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ba9:	c1 e8 0c             	shr    $0xc,%eax
  802bac:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802bb1:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802bb6:	0f b7 c0             	movzwl %ax,%eax
  802bb9:	eb 05                	jmp    802bc0 <pageref+0x3c>
  802bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc0:	5d                   	pop    %ebp
  802bc1:	c3                   	ret    
	...

00802bd0 <__udivdi3>:
  802bd0:	55                   	push   %ebp
  802bd1:	89 e5                	mov    %esp,%ebp
  802bd3:	57                   	push   %edi
  802bd4:	56                   	push   %esi
  802bd5:	83 ec 10             	sub    $0x10,%esp
  802bd8:	8b 45 14             	mov    0x14(%ebp),%eax
  802bdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bde:	8b 75 10             	mov    0x10(%ebp),%esi
  802be1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802be4:	85 c0                	test   %eax,%eax
  802be6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802be9:	75 35                	jne    802c20 <__udivdi3+0x50>
  802beb:	39 fe                	cmp    %edi,%esi
  802bed:	77 61                	ja     802c50 <__udivdi3+0x80>
  802bef:	85 f6                	test   %esi,%esi
  802bf1:	75 0b                	jne    802bfe <__udivdi3+0x2e>
  802bf3:	b8 01 00 00 00       	mov    $0x1,%eax
  802bf8:	31 d2                	xor    %edx,%edx
  802bfa:	f7 f6                	div    %esi
  802bfc:	89 c6                	mov    %eax,%esi
  802bfe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c01:	31 d2                	xor    %edx,%edx
  802c03:	89 f8                	mov    %edi,%eax
  802c05:	f7 f6                	div    %esi
  802c07:	89 c7                	mov    %eax,%edi
  802c09:	89 c8                	mov    %ecx,%eax
  802c0b:	f7 f6                	div    %esi
  802c0d:	89 c1                	mov    %eax,%ecx
  802c0f:	89 fa                	mov    %edi,%edx
  802c11:	89 c8                	mov    %ecx,%eax
  802c13:	83 c4 10             	add    $0x10,%esp
  802c16:	5e                   	pop    %esi
  802c17:	5f                   	pop    %edi
  802c18:	5d                   	pop    %ebp
  802c19:	c3                   	ret    
  802c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c20:	39 f8                	cmp    %edi,%eax
  802c22:	77 1c                	ja     802c40 <__udivdi3+0x70>
  802c24:	0f bd d0             	bsr    %eax,%edx
  802c27:	83 f2 1f             	xor    $0x1f,%edx
  802c2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c2d:	75 39                	jne    802c68 <__udivdi3+0x98>
  802c2f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802c32:	0f 86 a0 00 00 00    	jbe    802cd8 <__udivdi3+0x108>
  802c38:	39 f8                	cmp    %edi,%eax
  802c3a:	0f 82 98 00 00 00    	jb     802cd8 <__udivdi3+0x108>
  802c40:	31 ff                	xor    %edi,%edi
  802c42:	31 c9                	xor    %ecx,%ecx
  802c44:	89 c8                	mov    %ecx,%eax
  802c46:	89 fa                	mov    %edi,%edx
  802c48:	83 c4 10             	add    $0x10,%esp
  802c4b:	5e                   	pop    %esi
  802c4c:	5f                   	pop    %edi
  802c4d:	5d                   	pop    %ebp
  802c4e:	c3                   	ret    
  802c4f:	90                   	nop
  802c50:	89 d1                	mov    %edx,%ecx
  802c52:	89 fa                	mov    %edi,%edx
  802c54:	89 c8                	mov    %ecx,%eax
  802c56:	31 ff                	xor    %edi,%edi
  802c58:	f7 f6                	div    %esi
  802c5a:	89 c1                	mov    %eax,%ecx
  802c5c:	89 fa                	mov    %edi,%edx
  802c5e:	89 c8                	mov    %ecx,%eax
  802c60:	83 c4 10             	add    $0x10,%esp
  802c63:	5e                   	pop    %esi
  802c64:	5f                   	pop    %edi
  802c65:	5d                   	pop    %ebp
  802c66:	c3                   	ret    
  802c67:	90                   	nop
  802c68:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c6c:	89 f2                	mov    %esi,%edx
  802c6e:	d3 e0                	shl    %cl,%eax
  802c70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c73:	b8 20 00 00 00       	mov    $0x20,%eax
  802c78:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802c7b:	89 c1                	mov    %eax,%ecx
  802c7d:	d3 ea                	shr    %cl,%edx
  802c7f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c83:	0b 55 ec             	or     -0x14(%ebp),%edx
  802c86:	d3 e6                	shl    %cl,%esi
  802c88:	89 c1                	mov    %eax,%ecx
  802c8a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802c8d:	89 fe                	mov    %edi,%esi
  802c8f:	d3 ee                	shr    %cl,%esi
  802c91:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c95:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c9b:	d3 e7                	shl    %cl,%edi
  802c9d:	89 c1                	mov    %eax,%ecx
  802c9f:	d3 ea                	shr    %cl,%edx
  802ca1:	09 d7                	or     %edx,%edi
  802ca3:	89 f2                	mov    %esi,%edx
  802ca5:	89 f8                	mov    %edi,%eax
  802ca7:	f7 75 ec             	divl   -0x14(%ebp)
  802caa:	89 d6                	mov    %edx,%esi
  802cac:	89 c7                	mov    %eax,%edi
  802cae:	f7 65 e8             	mull   -0x18(%ebp)
  802cb1:	39 d6                	cmp    %edx,%esi
  802cb3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802cb6:	72 30                	jb     802ce8 <__udivdi3+0x118>
  802cb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cbb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802cbf:	d3 e2                	shl    %cl,%edx
  802cc1:	39 c2                	cmp    %eax,%edx
  802cc3:	73 05                	jae    802cca <__udivdi3+0xfa>
  802cc5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802cc8:	74 1e                	je     802ce8 <__udivdi3+0x118>
  802cca:	89 f9                	mov    %edi,%ecx
  802ccc:	31 ff                	xor    %edi,%edi
  802cce:	e9 71 ff ff ff       	jmp    802c44 <__udivdi3+0x74>
  802cd3:	90                   	nop
  802cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cd8:	31 ff                	xor    %edi,%edi
  802cda:	b9 01 00 00 00       	mov    $0x1,%ecx
  802cdf:	e9 60 ff ff ff       	jmp    802c44 <__udivdi3+0x74>
  802ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ce8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802ceb:	31 ff                	xor    %edi,%edi
  802ced:	89 c8                	mov    %ecx,%eax
  802cef:	89 fa                	mov    %edi,%edx
  802cf1:	83 c4 10             	add    $0x10,%esp
  802cf4:	5e                   	pop    %esi
  802cf5:	5f                   	pop    %edi
  802cf6:	5d                   	pop    %ebp
  802cf7:	c3                   	ret    
	...

00802d00 <__umoddi3>:
  802d00:	55                   	push   %ebp
  802d01:	89 e5                	mov    %esp,%ebp
  802d03:	57                   	push   %edi
  802d04:	56                   	push   %esi
  802d05:	83 ec 20             	sub    $0x20,%esp
  802d08:	8b 55 14             	mov    0x14(%ebp),%edx
  802d0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d0e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802d11:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d14:	85 d2                	test   %edx,%edx
  802d16:	89 c8                	mov    %ecx,%eax
  802d18:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802d1b:	75 13                	jne    802d30 <__umoddi3+0x30>
  802d1d:	39 f7                	cmp    %esi,%edi
  802d1f:	76 3f                	jbe    802d60 <__umoddi3+0x60>
  802d21:	89 f2                	mov    %esi,%edx
  802d23:	f7 f7                	div    %edi
  802d25:	89 d0                	mov    %edx,%eax
  802d27:	31 d2                	xor    %edx,%edx
  802d29:	83 c4 20             	add    $0x20,%esp
  802d2c:	5e                   	pop    %esi
  802d2d:	5f                   	pop    %edi
  802d2e:	5d                   	pop    %ebp
  802d2f:	c3                   	ret    
  802d30:	39 f2                	cmp    %esi,%edx
  802d32:	77 4c                	ja     802d80 <__umoddi3+0x80>
  802d34:	0f bd ca             	bsr    %edx,%ecx
  802d37:	83 f1 1f             	xor    $0x1f,%ecx
  802d3a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802d3d:	75 51                	jne    802d90 <__umoddi3+0x90>
  802d3f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802d42:	0f 87 e0 00 00 00    	ja     802e28 <__umoddi3+0x128>
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	29 f8                	sub    %edi,%eax
  802d4d:	19 d6                	sbb    %edx,%esi
  802d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	89 f2                	mov    %esi,%edx
  802d57:	83 c4 20             	add    $0x20,%esp
  802d5a:	5e                   	pop    %esi
  802d5b:	5f                   	pop    %edi
  802d5c:	5d                   	pop    %ebp
  802d5d:	c3                   	ret    
  802d5e:	66 90                	xchg   %ax,%ax
  802d60:	85 ff                	test   %edi,%edi
  802d62:	75 0b                	jne    802d6f <__umoddi3+0x6f>
  802d64:	b8 01 00 00 00       	mov    $0x1,%eax
  802d69:	31 d2                	xor    %edx,%edx
  802d6b:	f7 f7                	div    %edi
  802d6d:	89 c7                	mov    %eax,%edi
  802d6f:	89 f0                	mov    %esi,%eax
  802d71:	31 d2                	xor    %edx,%edx
  802d73:	f7 f7                	div    %edi
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	f7 f7                	div    %edi
  802d7a:	eb a9                	jmp    802d25 <__umoddi3+0x25>
  802d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d80:	89 c8                	mov    %ecx,%eax
  802d82:	89 f2                	mov    %esi,%edx
  802d84:	83 c4 20             	add    $0x20,%esp
  802d87:	5e                   	pop    %esi
  802d88:	5f                   	pop    %edi
  802d89:	5d                   	pop    %ebp
  802d8a:	c3                   	ret    
  802d8b:	90                   	nop
  802d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d90:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d94:	d3 e2                	shl    %cl,%edx
  802d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d99:	ba 20 00 00 00       	mov    $0x20,%edx
  802d9e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802da1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802da4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802da8:	89 fa                	mov    %edi,%edx
  802daa:	d3 ea                	shr    %cl,%edx
  802dac:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802db0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802db3:	d3 e7                	shl    %cl,%edi
  802db5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802db9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802dbc:	89 f2                	mov    %esi,%edx
  802dbe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802dc1:	89 c7                	mov    %eax,%edi
  802dc3:	d3 ea                	shr    %cl,%edx
  802dc5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802dc9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802dcc:	89 c2                	mov    %eax,%edx
  802dce:	d3 e6                	shl    %cl,%esi
  802dd0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802dd4:	d3 ea                	shr    %cl,%edx
  802dd6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802dda:	09 d6                	or     %edx,%esi
  802ddc:	89 f0                	mov    %esi,%eax
  802dde:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802de1:	d3 e7                	shl    %cl,%edi
  802de3:	89 f2                	mov    %esi,%edx
  802de5:	f7 75 f4             	divl   -0xc(%ebp)
  802de8:	89 d6                	mov    %edx,%esi
  802dea:	f7 65 e8             	mull   -0x18(%ebp)
  802ded:	39 d6                	cmp    %edx,%esi
  802def:	72 2b                	jb     802e1c <__umoddi3+0x11c>
  802df1:	39 c7                	cmp    %eax,%edi
  802df3:	72 23                	jb     802e18 <__umoddi3+0x118>
  802df5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802df9:	29 c7                	sub    %eax,%edi
  802dfb:	19 d6                	sbb    %edx,%esi
  802dfd:	89 f0                	mov    %esi,%eax
  802dff:	89 f2                	mov    %esi,%edx
  802e01:	d3 ef                	shr    %cl,%edi
  802e03:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e07:	d3 e0                	shl    %cl,%eax
  802e09:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e0d:	09 f8                	or     %edi,%eax
  802e0f:	d3 ea                	shr    %cl,%edx
  802e11:	83 c4 20             	add    $0x20,%esp
  802e14:	5e                   	pop    %esi
  802e15:	5f                   	pop    %edi
  802e16:	5d                   	pop    %ebp
  802e17:	c3                   	ret    
  802e18:	39 d6                	cmp    %edx,%esi
  802e1a:	75 d9                	jne    802df5 <__umoddi3+0xf5>
  802e1c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802e1f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802e22:	eb d1                	jmp    802df5 <__umoddi3+0xf5>
  802e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e28:	39 f2                	cmp    %esi,%edx
  802e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e30:	0f 82 12 ff ff ff    	jb     802d48 <__umoddi3+0x48>
  802e36:	e9 17 ff ff ff       	jmp    802d52 <__umoddi3+0x52>
