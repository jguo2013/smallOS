
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 3b 01 00 00       	call   80016c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800043:	eb 40                	jmp    800085 <cat+0x51>
		if ((r = write(1, buf, n)) != n)
  800045:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800049:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800050:	00 
  800051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800058:	e8 49 13 00 00       	call   8013a6 <write>
  80005d:	39 c3                	cmp    %eax,%ebx
  80005f:	74 24                	je     800085 <cat+0x51>
			panic("write error copying %s: %e", s, r);
  800061:	89 44 24 10          	mov    %eax,0x10(%esp)
  800065:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800069:	c7 44 24 08 00 2a 80 	movl   $0x802a00,0x8(%esp)
  800070:	00 
  800071:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800078:	00 
  800079:	c7 04 24 1b 2a 80 00 	movl   $0x802a1b,(%esp)
  800080:	e8 4b 01 00 00       	call   8001d0 <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800085:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800094:	00 
  800095:	89 34 24             	mov    %esi,(%esp)
  800098:	e8 92 13 00 00       	call   80142f <read>
  80009d:	89 c3                	mov    %eax,%ebx
  80009f:	85 c0                	test   %eax,%eax
  8000a1:	7f a2                	jg     800045 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	79 24                	jns    8000cb <cat+0x97>
		panic("error reading %s: %e", s, n);
  8000a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000af:	c7 44 24 08 26 2a 80 	movl   $0x802a26,0x8(%esp)
  8000b6:	00 
  8000b7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 1b 2a 80 00 	movl   $0x802a1b,(%esp)
  8000c6:	e8 05 01 00 00       	call   8001d0 <_panic>
}
  8000cb:	83 c4 2c             	add    $0x2c,%esp
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5f                   	pop    %edi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 2c             	sub    $0x2c,%esp
  8000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	int f, i;

	binaryname = "cat";
  8000df:	c7 05 00 30 80 00 3b 	movl   $0x802a3b,0x803000
  8000e6:	2a 80 00 
	if (argc == 1)
  8000e9:	bb 01 00 00 00       	mov    $0x1,%ebx
  8000ee:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000f2:	75 6b                	jne    80015f <umain+0x8c>
		cat(0, "<stdin>");
  8000f4:	c7 44 24 04 3f 2a 80 	movl   $0x802a3f,0x4(%esp)
  8000fb:	00 
  8000fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800103:	e8 2c ff ff ff       	call   800034 <cat>
  800108:	eb 5a                	jmp    800164 <umain+0x91>
	if (n < 0)
		panic("error reading %s: %e", s, n);
}

void
umain(int argc, char **argv)
  80010a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  80010d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800114:	00 
  800115:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 eb 18 00 00       	call   801a0b <open>
  800120:	89 c7                	mov    %eax,%edi
			if (f < 0)
  800122:	85 c0                	test   %eax,%eax
  800124:	79 1c                	jns    800142 <umain+0x6f>
				printf("can't open %s: %e\n", argv[i], f);
  800126:	89 44 24 08          	mov    %eax,0x8(%esp)
  80012a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80012d:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800130:	89 44 24 04          	mov    %eax,0x4(%esp)
  800134:	c7 04 24 47 2a 80 00 	movl   $0x802a47,(%esp)
  80013b:	e8 17 1a 00 00       	call   801b57 <printf>
  800140:	eb 1a                	jmp    80015c <umain+0x89>
			else {
				cat(f, argv[i]);
  800142:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800145:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800148:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014c:	89 3c 24             	mov    %edi,(%esp)
  80014f:	e8 e0 fe ff ff       	call   800034 <cat>
				close(f);
  800154:	89 3c 24             	mov    %edi,(%esp)
  800157:	e8 3a 14 00 00       	call   801596 <close>

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80015c:	83 c3 01             	add    $0x1,%ebx
  80015f:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800162:	7c a6                	jl     80010a <umain+0x37>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800164:	83 c4 2c             	add    $0x2c,%esp
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	5f                   	pop    %edi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
  800172:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800175:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800178:	8b 75 08             	mov    0x8(%ebp),%esi
  80017b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80017e:	e8 3e 0f 00 00       	call   8010c1 <sys_getenvid>
  800183:	25 ff 03 00 00       	and    $0x3ff,%eax
  800188:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80018b:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800190:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800195:	85 f6                	test   %esi,%esi
  800197:	7e 07                	jle    8001a0 <libmain+0x34>
		binaryname = argv[0];
  800199:	8b 03                	mov    (%ebx),%eax
  80019b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001a4:	89 34 24             	mov    %esi,(%esp)
  8001a7:	e8 27 ff ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  8001ac:	e8 0b 00 00 00       	call   8001bc <exit>
}
  8001b1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001b4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001b7:	89 ec                	mov    %ebp,%esp
  8001b9:	5d                   	pop    %ebp
  8001ba:	c3                   	ret    
	...

008001bc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8001c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001c9:	e8 27 0f 00 00       	call   8010f5 <sys_env_destroy>
}
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	56                   	push   %esi
  8001d4:	53                   	push   %ebx
  8001d5:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8001d8:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001db:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8001e1:	e8 db 0e 00 00       	call   8010c1 <sys_getenvid>
  8001e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fc:	c7 04 24 64 2a 80 00 	movl   $0x802a64,(%esp)
  800203:	e8 81 00 00 00       	call   800289 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800208:	89 74 24 04          	mov    %esi,0x4(%esp)
  80020c:	8b 45 10             	mov    0x10(%ebp),%eax
  80020f:	89 04 24             	mov    %eax,(%esp)
  800212:	e8 11 00 00 00       	call   800228 <vcprintf>
	cprintf("\n");
  800217:	c7 04 24 27 2f 80 00 	movl   $0x802f27,(%esp)
  80021e:	e8 66 00 00 00       	call   800289 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800223:	cc                   	int3   
  800224:	eb fd                	jmp    800223 <_panic+0x53>
	...

00800228 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800231:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800238:	00 00 00 
	b.cnt = 0;
  80023b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800242:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800245:	8b 45 0c             	mov    0xc(%ebp),%eax
  800248:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80024c:	8b 45 08             	mov    0x8(%ebp),%eax
  80024f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800253:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800259:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025d:	c7 04 24 a3 02 80 00 	movl   $0x8002a3,(%esp)
  800264:	e8 be 01 00 00       	call   800427 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800269:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80026f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800273:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800279:	89 04 24             	mov    %eax,(%esp)
  80027c:	e8 1f 0a 00 00       	call   800ca0 <sys_cputs>

	return b.cnt;
}
  800281:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80028f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800292:	89 44 24 04          	mov    %eax,0x4(%esp)
  800296:	8b 45 08             	mov    0x8(%ebp),%eax
  800299:	89 04 24             	mov    %eax,(%esp)
  80029c:	e8 87 ff ff ff       	call   800228 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a1:	c9                   	leave  
  8002a2:	c3                   	ret    

008002a3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	53                   	push   %ebx
  8002a7:	83 ec 14             	sub    $0x14,%esp
  8002aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ad:	8b 03                	mov    (%ebx),%eax
  8002af:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b2:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002b6:	83 c0 01             	add    $0x1,%eax
  8002b9:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c0:	75 19                	jne    8002db <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002c2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002c9:	00 
  8002ca:	8d 43 08             	lea    0x8(%ebx),%eax
  8002cd:	89 04 24             	mov    %eax,(%esp)
  8002d0:	e8 cb 09 00 00       	call   800ca0 <sys_cputs>
		b->idx = 0;
  8002d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002db:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002df:	83 c4 14             	add    $0x14,%esp
  8002e2:	5b                   	pop    %ebx
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    
  8002e5:	00 00                	add    %al,(%eax)
	...

008002e8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	57                   	push   %edi
  8002ec:	56                   	push   %esi
  8002ed:	53                   	push   %ebx
  8002ee:	83 ec 4c             	sub    $0x4c,%esp
  8002f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002f4:	89 d6                	mov    %edx,%esi
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ff:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800302:	8b 45 10             	mov    0x10(%ebp),%eax
  800305:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800308:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80030b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80030e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800313:	39 d1                	cmp    %edx,%ecx
  800315:	72 07                	jb     80031e <printnum+0x36>
  800317:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80031a:	39 d0                	cmp    %edx,%eax
  80031c:	77 69                	ja     800387 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80031e:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800322:	83 eb 01             	sub    $0x1,%ebx
  800325:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800329:	89 44 24 08          	mov    %eax,0x8(%esp)
  80032d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800331:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800335:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800338:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80033b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80033e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800342:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800349:	00 
  80034a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80034d:	89 04 24             	mov    %eax,(%esp)
  800350:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800353:	89 54 24 04          	mov    %edx,0x4(%esp)
  800357:	e8 34 24 00 00       	call   802790 <__udivdi3>
  80035c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80035f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800362:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800366:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80036a:	89 04 24             	mov    %eax,(%esp)
  80036d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800371:	89 f2                	mov    %esi,%edx
  800373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800376:	e8 6d ff ff ff       	call   8002e8 <printnum>
  80037b:	eb 11                	jmp    80038e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800381:	89 3c 24             	mov    %edi,(%esp)
  800384:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800387:	83 eb 01             	sub    $0x1,%ebx
  80038a:	85 db                	test   %ebx,%ebx
  80038c:	7f ef                	jg     80037d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800392:	8b 74 24 04          	mov    0x4(%esp),%esi
  800396:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800399:	89 44 24 08          	mov    %eax,0x8(%esp)
  80039d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003a4:	00 
  8003a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003a8:	89 14 24             	mov    %edx,(%esp)
  8003ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003b2:	e8 09 25 00 00       	call   8028c0 <__umoddi3>
  8003b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003bb:	0f be 80 87 2a 80 00 	movsbl 0x802a87(%eax),%eax
  8003c2:	89 04 24             	mov    %eax,(%esp)
  8003c5:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003c8:	83 c4 4c             	add    $0x4c,%esp
  8003cb:	5b                   	pop    %ebx
  8003cc:	5e                   	pop    %esi
  8003cd:	5f                   	pop    %edi
  8003ce:	5d                   	pop    %ebp
  8003cf:	c3                   	ret    

008003d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d3:	83 fa 01             	cmp    $0x1,%edx
  8003d6:	7e 0e                	jle    8003e6 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003d8:	8b 10                	mov    (%eax),%edx
  8003da:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003dd:	89 08                	mov    %ecx,(%eax)
  8003df:	8b 02                	mov    (%edx),%eax
  8003e1:	8b 52 04             	mov    0x4(%edx),%edx
  8003e4:	eb 22                	jmp    800408 <getuint+0x38>
	else if (lflag)
  8003e6:	85 d2                	test   %edx,%edx
  8003e8:	74 10                	je     8003fa <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003ea:	8b 10                	mov    (%eax),%edx
  8003ec:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ef:	89 08                	mov    %ecx,(%eax)
  8003f1:	8b 02                	mov    (%edx),%eax
  8003f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f8:	eb 0e                	jmp    800408 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003fa:	8b 10                	mov    (%eax),%edx
  8003fc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ff:	89 08                	mov    %ecx,(%eax)
  800401:	8b 02                	mov    (%edx),%eax
  800403:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800410:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800414:	8b 10                	mov    (%eax),%edx
  800416:	3b 50 04             	cmp    0x4(%eax),%edx
  800419:	73 0a                	jae    800425 <sprintputch+0x1b>
		*b->buf++ = ch;
  80041b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80041e:	88 0a                	mov    %cl,(%edx)
  800420:	83 c2 01             	add    $0x1,%edx
  800423:	89 10                	mov    %edx,(%eax)
}
  800425:	5d                   	pop    %ebp
  800426:	c3                   	ret    

00800427 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	57                   	push   %edi
  80042b:	56                   	push   %esi
  80042c:	53                   	push   %ebx
  80042d:	83 ec 4c             	sub    $0x4c,%esp
  800430:	8b 7d 08             	mov    0x8(%ebp),%edi
  800433:	8b 75 0c             	mov    0xc(%ebp),%esi
  800436:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800439:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800440:	eb 11                	jmp    800453 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800442:	85 c0                	test   %eax,%eax
  800444:	0f 84 b6 03 00 00    	je     800800 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80044a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80044e:	89 04 24             	mov    %eax,(%esp)
  800451:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800453:	0f b6 03             	movzbl (%ebx),%eax
  800456:	83 c3 01             	add    $0x1,%ebx
  800459:	83 f8 25             	cmp    $0x25,%eax
  80045c:	75 e4                	jne    800442 <vprintfmt+0x1b>
  80045e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800462:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800469:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800470:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800477:	b9 00 00 00 00       	mov    $0x0,%ecx
  80047c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80047f:	eb 06                	jmp    800487 <vprintfmt+0x60>
  800481:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800485:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800487:	0f b6 0b             	movzbl (%ebx),%ecx
  80048a:	0f b6 c1             	movzbl %cl,%eax
  80048d:	8d 53 01             	lea    0x1(%ebx),%edx
  800490:	83 e9 23             	sub    $0x23,%ecx
  800493:	80 f9 55             	cmp    $0x55,%cl
  800496:	0f 87 47 03 00 00    	ja     8007e3 <vprintfmt+0x3bc>
  80049c:	0f b6 c9             	movzbl %cl,%ecx
  80049f:	ff 24 8d c0 2b 80 00 	jmp    *0x802bc0(,%ecx,4)
  8004a6:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8004aa:	eb d9                	jmp    800485 <vprintfmt+0x5e>
  8004ac:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8004b3:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004b8:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004bb:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004bf:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8004c2:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004c5:	83 fb 09             	cmp    $0x9,%ebx
  8004c8:	77 30                	ja     8004fa <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ca:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004cd:	eb e9                	jmp    8004b8 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	8d 48 04             	lea    0x4(%eax),%ecx
  8004d5:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8004dd:	eb 1e                	jmp    8004fd <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8004df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e8:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8004ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ef:	eb 94                	jmp    800485 <vprintfmt+0x5e>
  8004f1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8004f8:	eb 8b                	jmp    800485 <vprintfmt+0x5e>
  8004fa:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8004fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800501:	79 82                	jns    800485 <vprintfmt+0x5e>
  800503:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800509:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80050c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80050f:	e9 71 ff ff ff       	jmp    800485 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800514:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800518:	e9 68 ff ff ff       	jmp    800485 <vprintfmt+0x5e>
  80051d:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8d 50 04             	lea    0x4(%eax),%edx
  800526:	89 55 14             	mov    %edx,0x14(%ebp)
  800529:	89 74 24 04          	mov    %esi,0x4(%esp)
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 04 24             	mov    %eax,(%esp)
  800532:	ff d7                	call   *%edi
  800534:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800537:	e9 17 ff ff ff       	jmp    800453 <vprintfmt+0x2c>
  80053c:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8d 50 04             	lea    0x4(%eax),%edx
  800545:	89 55 14             	mov    %edx,0x14(%ebp)
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	89 c2                	mov    %eax,%edx
  80054c:	c1 fa 1f             	sar    $0x1f,%edx
  80054f:	31 d0                	xor    %edx,%eax
  800551:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800553:	83 f8 11             	cmp    $0x11,%eax
  800556:	7f 0b                	jg     800563 <vprintfmt+0x13c>
  800558:	8b 14 85 20 2d 80 00 	mov    0x802d20(,%eax,4),%edx
  80055f:	85 d2                	test   %edx,%edx
  800561:	75 20                	jne    800583 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800563:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800567:	c7 44 24 08 98 2a 80 	movl   $0x802a98,0x8(%esp)
  80056e:	00 
  80056f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800573:	89 3c 24             	mov    %edi,(%esp)
  800576:	e8 0d 03 00 00       	call   800888 <printfmt>
  80057b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80057e:	e9 d0 fe ff ff       	jmp    800453 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800583:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800587:	c7 44 24 08 7a 2e 80 	movl   $0x802e7a,0x8(%esp)
  80058e:	00 
  80058f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800593:	89 3c 24             	mov    %edi,(%esp)
  800596:	e8 ed 02 00 00       	call   800888 <printfmt>
  80059b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80059e:	e9 b0 fe ff ff       	jmp    800453 <vprintfmt+0x2c>
  8005a3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005a6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8005a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 50 04             	lea    0x4(%eax),%edx
  8005b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b8:	8b 18                	mov    (%eax),%ebx
  8005ba:	85 db                	test   %ebx,%ebx
  8005bc:	b8 a1 2a 80 00       	mov    $0x802aa1,%eax
  8005c1:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8005c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c8:	7e 76                	jle    800640 <vprintfmt+0x219>
  8005ca:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8005ce:	74 7a                	je     80064a <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005d4:	89 1c 24             	mov    %ebx,(%esp)
  8005d7:	e8 ec 02 00 00       	call   8008c8 <strnlen>
  8005dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005df:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8005e1:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8005e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005e8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005eb:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ed:	eb 0f                	jmp    8005fe <vprintfmt+0x1d7>
					putch(padc, putdat);
  8005ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f6:	89 04 24             	mov    %eax,(%esp)
  8005f9:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fb:	83 eb 01             	sub    $0x1,%ebx
  8005fe:	85 db                	test   %ebx,%ebx
  800600:	7f ed                	jg     8005ef <vprintfmt+0x1c8>
  800602:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800605:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800608:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80060b:	89 f7                	mov    %esi,%edi
  80060d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800610:	eb 40                	jmp    800652 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800612:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800616:	74 18                	je     800630 <vprintfmt+0x209>
  800618:	8d 50 e0             	lea    -0x20(%eax),%edx
  80061b:	83 fa 5e             	cmp    $0x5e,%edx
  80061e:	76 10                	jbe    800630 <vprintfmt+0x209>
					putch('?', putdat);
  800620:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800624:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80062b:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80062e:	eb 0a                	jmp    80063a <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800630:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800634:	89 04 24             	mov    %eax,(%esp)
  800637:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80063a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80063e:	eb 12                	jmp    800652 <vprintfmt+0x22b>
  800640:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800643:	89 f7                	mov    %esi,%edi
  800645:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800648:	eb 08                	jmp    800652 <vprintfmt+0x22b>
  80064a:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80064d:	89 f7                	mov    %esi,%edi
  80064f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800652:	0f be 03             	movsbl (%ebx),%eax
  800655:	83 c3 01             	add    $0x1,%ebx
  800658:	85 c0                	test   %eax,%eax
  80065a:	74 25                	je     800681 <vprintfmt+0x25a>
  80065c:	85 f6                	test   %esi,%esi
  80065e:	78 b2                	js     800612 <vprintfmt+0x1eb>
  800660:	83 ee 01             	sub    $0x1,%esi
  800663:	79 ad                	jns    800612 <vprintfmt+0x1eb>
  800665:	89 fe                	mov    %edi,%esi
  800667:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80066a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80066d:	eb 1a                	jmp    800689 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80066f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800673:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80067a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80067c:	83 eb 01             	sub    $0x1,%ebx
  80067f:	eb 08                	jmp    800689 <vprintfmt+0x262>
  800681:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800684:	89 fe                	mov    %edi,%esi
  800686:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800689:	85 db                	test   %ebx,%ebx
  80068b:	7f e2                	jg     80066f <vprintfmt+0x248>
  80068d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800690:	e9 be fd ff ff       	jmp    800453 <vprintfmt+0x2c>
  800695:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800698:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80069b:	83 f9 01             	cmp    $0x1,%ecx
  80069e:	7e 16                	jle    8006b6 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 50 08             	lea    0x8(%eax),%edx
  8006a6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ae:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8006b1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006b4:	eb 32                	jmp    8006e8 <vprintfmt+0x2c1>
	else if (lflag)
  8006b6:	85 c9                	test   %ecx,%ecx
  8006b8:	74 18                	je     8006d2 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8d 50 04             	lea    0x4(%eax),%edx
  8006c0:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c8:	89 c1                	mov    %eax,%ecx
  8006ca:	c1 f9 1f             	sar    $0x1f,%ecx
  8006cd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006d0:	eb 16                	jmp    8006e8 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 50 04             	lea    0x4(%eax),%edx
  8006d8:	89 55 14             	mov    %edx,0x14(%ebp)
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e0:	89 c2                	mov    %eax,%edx
  8006e2:	c1 fa 1f             	sar    $0x1f,%edx
  8006e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006e8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006eb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006ee:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f7:	0f 89 a7 00 00 00    	jns    8007a4 <vprintfmt+0x37d>
				putch('-', putdat);
  8006fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800701:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800708:	ff d7                	call   *%edi
				num = -(long long) num;
  80070a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80070d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800710:	f7 d9                	neg    %ecx
  800712:	83 d3 00             	adc    $0x0,%ebx
  800715:	f7 db                	neg    %ebx
  800717:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071c:	e9 83 00 00 00       	jmp    8007a4 <vprintfmt+0x37d>
  800721:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800724:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800727:	89 ca                	mov    %ecx,%edx
  800729:	8d 45 14             	lea    0x14(%ebp),%eax
  80072c:	e8 9f fc ff ff       	call   8003d0 <getuint>
  800731:	89 c1                	mov    %eax,%ecx
  800733:	89 d3                	mov    %edx,%ebx
  800735:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80073a:	eb 68                	jmp    8007a4 <vprintfmt+0x37d>
  80073c:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80073f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800742:	89 ca                	mov    %ecx,%edx
  800744:	8d 45 14             	lea    0x14(%ebp),%eax
  800747:	e8 84 fc ff ff       	call   8003d0 <getuint>
  80074c:	89 c1                	mov    %eax,%ecx
  80074e:	89 d3                	mov    %edx,%ebx
  800750:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800755:	eb 4d                	jmp    8007a4 <vprintfmt+0x37d>
  800757:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80075a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800765:	ff d7                	call   *%edi
			putch('x', putdat);
  800767:	89 74 24 04          	mov    %esi,0x4(%esp)
  80076b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800772:	ff d7                	call   *%edi
			num = (unsigned long long)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 50 04             	lea    0x4(%eax),%edx
  80077a:	89 55 14             	mov    %edx,0x14(%ebp)
  80077d:	8b 08                	mov    (%eax),%ecx
  80077f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800784:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800789:	eb 19                	jmp    8007a4 <vprintfmt+0x37d>
  80078b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80078e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800791:	89 ca                	mov    %ecx,%edx
  800793:	8d 45 14             	lea    0x14(%ebp),%eax
  800796:	e8 35 fc ff ff       	call   8003d0 <getuint>
  80079b:	89 c1                	mov    %eax,%ecx
  80079d:	89 d3                	mov    %edx,%ebx
  80079f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a4:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8007a8:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007af:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007b7:	89 0c 24             	mov    %ecx,(%esp)
  8007ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007be:	89 f2                	mov    %esi,%edx
  8007c0:	89 f8                	mov    %edi,%eax
  8007c2:	e8 21 fb ff ff       	call   8002e8 <printnum>
  8007c7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007ca:	e9 84 fc ff ff       	jmp    800453 <vprintfmt+0x2c>
  8007cf:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d6:	89 04 24             	mov    %eax,(%esp)
  8007d9:	ff d7                	call   *%edi
  8007db:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007de:	e9 70 fc ff ff       	jmp    800453 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007ee:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8007f3:	80 38 25             	cmpb   $0x25,(%eax)
  8007f6:	0f 84 57 fc ff ff    	je     800453 <vprintfmt+0x2c>
  8007fc:	89 c3                	mov    %eax,%ebx
  8007fe:	eb f0                	jmp    8007f0 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800800:	83 c4 4c             	add    $0x4c,%esp
  800803:	5b                   	pop    %ebx
  800804:	5e                   	pop    %esi
  800805:	5f                   	pop    %edi
  800806:	5d                   	pop    %ebp
  800807:	c3                   	ret    

00800808 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	83 ec 28             	sub    $0x28,%esp
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800814:	85 c0                	test   %eax,%eax
  800816:	74 04                	je     80081c <vsnprintf+0x14>
  800818:	85 d2                	test   %edx,%edx
  80081a:	7f 07                	jg     800823 <vsnprintf+0x1b>
  80081c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800821:	eb 3b                	jmp    80085e <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800823:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800826:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  80082a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80083b:	8b 45 10             	mov    0x10(%ebp),%eax
  80083e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800842:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800845:	89 44 24 04          	mov    %eax,0x4(%esp)
  800849:	c7 04 24 0a 04 80 00 	movl   $0x80040a,(%esp)
  800850:	e8 d2 fb ff ff       	call   800427 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800858:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80085e:	c9                   	leave  
  80085f:	c3                   	ret    

00800860 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800866:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800869:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	89 44 24 08          	mov    %eax,0x8(%esp)
  800874:	8b 45 0c             	mov    0xc(%ebp),%eax
  800877:	89 44 24 04          	mov    %eax,0x4(%esp)
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	89 04 24             	mov    %eax,(%esp)
  800881:	e8 82 ff ff ff       	call   800808 <vsnprintf>
	va_end(ap);

	return rc;
}
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80088e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800891:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800895:	8b 45 10             	mov    0x10(%ebp),%eax
  800898:	89 44 24 08          	mov    %eax,0x8(%esp)
  80089c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	89 04 24             	mov    %eax,(%esp)
  8008a9:	e8 79 fb ff ff       	call   800427 <vprintfmt>
	va_end(ap);
}
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8008bb:	eb 03                	jmp    8008c0 <strlen+0x10>
		n++;
  8008bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c4:	75 f7                	jne    8008bd <strlen+0xd>
		n++;
	return n;
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	53                   	push   %ebx
  8008cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d7:	eb 03                	jmp    8008dc <strnlen+0x14>
		n++;
  8008d9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008dc:	39 c1                	cmp    %eax,%ecx
  8008de:	74 06                	je     8008e6 <strnlen+0x1e>
  8008e0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8008e4:	75 f3                	jne    8008d9 <strnlen+0x11>
		n++;
	return n;
}
  8008e6:	5b                   	pop    %ebx
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	53                   	push   %ebx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ff:	83 c2 01             	add    $0x1,%edx
  800902:	84 c9                	test   %cl,%cl
  800904:	75 f2                	jne    8008f8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800906:	5b                   	pop    %ebx
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	53                   	push   %ebx
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800913:	89 1c 24             	mov    %ebx,(%esp)
  800916:	e8 95 ff ff ff       	call   8008b0 <strlen>
	strcpy(dst + len, src);
  80091b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800922:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800925:	89 04 24             	mov    %eax,(%esp)
  800928:	e8 bc ff ff ff       	call   8008e9 <strcpy>
	return dst;
}
  80092d:	89 d8                	mov    %ebx,%eax
  80092f:	83 c4 08             	add    $0x8,%esp
  800932:	5b                   	pop    %ebx
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800940:	8b 75 10             	mov    0x10(%ebp),%esi
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800948:	eb 0f                	jmp    800959 <strncpy+0x24>
		*dst++ = *src;
  80094a:	0f b6 19             	movzbl (%ecx),%ebx
  80094d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800950:	80 39 01             	cmpb   $0x1,(%ecx)
  800953:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800956:	83 c2 01             	add    $0x1,%edx
  800959:	39 f2                	cmp    %esi,%edx
  80095b:	72 ed                	jb     80094a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80095d:	5b                   	pop    %ebx
  80095e:	5e                   	pop    %esi
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	56                   	push   %esi
  800965:	53                   	push   %ebx
  800966:	8b 75 08             	mov    0x8(%ebp),%esi
  800969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80096f:	89 f0                	mov    %esi,%eax
  800971:	85 d2                	test   %edx,%edx
  800973:	75 0a                	jne    80097f <strlcpy+0x1e>
  800975:	eb 17                	jmp    80098e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800977:	88 18                	mov    %bl,(%eax)
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80097f:	83 ea 01             	sub    $0x1,%edx
  800982:	74 07                	je     80098b <strlcpy+0x2a>
  800984:	0f b6 19             	movzbl (%ecx),%ebx
  800987:	84 db                	test   %bl,%bl
  800989:	75 ec                	jne    800977 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80098b:	c6 00 00             	movb   $0x0,(%eax)
  80098e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800990:	5b                   	pop    %ebx
  800991:	5e                   	pop    %esi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099d:	eb 06                	jmp    8009a5 <strcmp+0x11>
		p++, q++;
  80099f:	83 c1 01             	add    $0x1,%ecx
  8009a2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009a5:	0f b6 01             	movzbl (%ecx),%eax
  8009a8:	84 c0                	test   %al,%al
  8009aa:	74 04                	je     8009b0 <strcmp+0x1c>
  8009ac:	3a 02                	cmp    (%edx),%al
  8009ae:	74 ef                	je     80099f <strcmp+0xb>
  8009b0:	0f b6 c0             	movzbl %al,%eax
  8009b3:	0f b6 12             	movzbl (%edx),%edx
  8009b6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	53                   	push   %ebx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8009c7:	eb 09                	jmp    8009d2 <strncmp+0x18>
		n--, p++, q++;
  8009c9:	83 ea 01             	sub    $0x1,%edx
  8009cc:	83 c0 01             	add    $0x1,%eax
  8009cf:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009d2:	85 d2                	test   %edx,%edx
  8009d4:	75 07                	jne    8009dd <strncmp+0x23>
  8009d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009db:	eb 13                	jmp    8009f0 <strncmp+0x36>
  8009dd:	0f b6 18             	movzbl (%eax),%ebx
  8009e0:	84 db                	test   %bl,%bl
  8009e2:	74 04                	je     8009e8 <strncmp+0x2e>
  8009e4:	3a 19                	cmp    (%ecx),%bl
  8009e6:	74 e1                	je     8009c9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e8:	0f b6 00             	movzbl (%eax),%eax
  8009eb:	0f b6 11             	movzbl (%ecx),%edx
  8009ee:	29 d0                	sub    %edx,%eax
}
  8009f0:	5b                   	pop    %ebx
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009fd:	eb 07                	jmp    800a06 <strchr+0x13>
		if (*s == c)
  8009ff:	38 ca                	cmp    %cl,%dl
  800a01:	74 0f                	je     800a12 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a03:	83 c0 01             	add    $0x1,%eax
  800a06:	0f b6 10             	movzbl (%eax),%edx
  800a09:	84 d2                	test   %dl,%dl
  800a0b:	75 f2                	jne    8009ff <strchr+0xc>
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1e:	eb 07                	jmp    800a27 <strfind+0x13>
		if (*s == c)
  800a20:	38 ca                	cmp    %cl,%dl
  800a22:	74 0a                	je     800a2e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	0f b6 10             	movzbl (%eax),%edx
  800a2a:	84 d2                	test   %dl,%dl
  800a2c:	75 f2                	jne    800a20 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a2e:	5d                   	pop    %ebp
  800a2f:	c3                   	ret    

00800a30 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	83 ec 0c             	sub    $0xc,%esp
  800a36:	89 1c 24             	mov    %ebx,(%esp)
  800a39:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a3d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a41:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4a:	85 c9                	test   %ecx,%ecx
  800a4c:	74 30                	je     800a7e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a4e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a54:	75 25                	jne    800a7b <memset+0x4b>
  800a56:	f6 c1 03             	test   $0x3,%cl
  800a59:	75 20                	jne    800a7b <memset+0x4b>
		c &= 0xFF;
  800a5b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5e:	89 d3                	mov    %edx,%ebx
  800a60:	c1 e3 08             	shl    $0x8,%ebx
  800a63:	89 d6                	mov    %edx,%esi
  800a65:	c1 e6 18             	shl    $0x18,%esi
  800a68:	89 d0                	mov    %edx,%eax
  800a6a:	c1 e0 10             	shl    $0x10,%eax
  800a6d:	09 f0                	or     %esi,%eax
  800a6f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a71:	09 d8                	or     %ebx,%eax
  800a73:	c1 e9 02             	shr    $0x2,%ecx
  800a76:	fc                   	cld    
  800a77:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a79:	eb 03                	jmp    800a7e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7b:	fc                   	cld    
  800a7c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7e:	89 f8                	mov    %edi,%eax
  800a80:	8b 1c 24             	mov    (%esp),%ebx
  800a83:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a87:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a8b:	89 ec                	mov    %ebp,%esp
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    

00800a8f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	89 34 24             	mov    %esi,(%esp)
  800a98:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800aa2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800aa5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800aa7:	39 c6                	cmp    %eax,%esi
  800aa9:	73 35                	jae    800ae0 <memmove+0x51>
  800aab:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aae:	39 d0                	cmp    %edx,%eax
  800ab0:	73 2e                	jae    800ae0 <memmove+0x51>
		s += n;
		d += n;
  800ab2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab4:	f6 c2 03             	test   $0x3,%dl
  800ab7:	75 1b                	jne    800ad4 <memmove+0x45>
  800ab9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800abf:	75 13                	jne    800ad4 <memmove+0x45>
  800ac1:	f6 c1 03             	test   $0x3,%cl
  800ac4:	75 0e                	jne    800ad4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ac6:	83 ef 04             	sub    $0x4,%edi
  800ac9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800acc:	c1 e9 02             	shr    $0x2,%ecx
  800acf:	fd                   	std    
  800ad0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad2:	eb 09                	jmp    800add <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ad4:	83 ef 01             	sub    $0x1,%edi
  800ad7:	8d 72 ff             	lea    -0x1(%edx),%esi
  800ada:	fd                   	std    
  800adb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800add:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ade:	eb 20                	jmp    800b00 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae6:	75 15                	jne    800afd <memmove+0x6e>
  800ae8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aee:	75 0d                	jne    800afd <memmove+0x6e>
  800af0:	f6 c1 03             	test   $0x3,%cl
  800af3:	75 08                	jne    800afd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800af5:	c1 e9 02             	shr    $0x2,%ecx
  800af8:	fc                   	cld    
  800af9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afb:	eb 03                	jmp    800b00 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800afd:	fc                   	cld    
  800afe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b00:	8b 34 24             	mov    (%esp),%esi
  800b03:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b07:	89 ec                	mov    %ebp,%esp
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b11:	8b 45 10             	mov    0x10(%ebp),%eax
  800b14:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	89 04 24             	mov    %eax,(%esp)
  800b25:	e8 65 ff ff ff       	call   800a8f <memmove>
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	57                   	push   %edi
  800b30:	56                   	push   %esi
  800b31:	53                   	push   %ebx
  800b32:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b3b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b40:	eb 1c                	jmp    800b5e <memcmp+0x32>
		if (*s1 != *s2)
  800b42:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800b46:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800b4a:	83 c2 01             	add    $0x1,%edx
  800b4d:	83 e9 01             	sub    $0x1,%ecx
  800b50:	38 d8                	cmp    %bl,%al
  800b52:	74 0a                	je     800b5e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800b54:	0f b6 c0             	movzbl %al,%eax
  800b57:	0f b6 db             	movzbl %bl,%ebx
  800b5a:	29 d8                	sub    %ebx,%eax
  800b5c:	eb 09                	jmp    800b67 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b5e:	85 c9                	test   %ecx,%ecx
  800b60:	75 e0                	jne    800b42 <memcmp+0x16>
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5f                   	pop    %edi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7a:	eb 07                	jmp    800b83 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b7c:	38 08                	cmp    %cl,(%eax)
  800b7e:	74 07                	je     800b87 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b80:	83 c0 01             	add    $0x1,%eax
  800b83:	39 d0                	cmp    %edx,%eax
  800b85:	72 f5                	jb     800b7c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	57                   	push   %edi
  800b8d:	56                   	push   %esi
  800b8e:	53                   	push   %ebx
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	8b 55 08             	mov    0x8(%ebp),%edx
  800b95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b98:	eb 03                	jmp    800b9d <strtol+0x14>
		s++;
  800b9a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9d:	0f b6 02             	movzbl (%edx),%eax
  800ba0:	3c 20                	cmp    $0x20,%al
  800ba2:	74 f6                	je     800b9a <strtol+0x11>
  800ba4:	3c 09                	cmp    $0x9,%al
  800ba6:	74 f2                	je     800b9a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ba8:	3c 2b                	cmp    $0x2b,%al
  800baa:	75 0c                	jne    800bb8 <strtol+0x2f>
		s++;
  800bac:	8d 52 01             	lea    0x1(%edx),%edx
  800baf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bb6:	eb 15                	jmp    800bcd <strtol+0x44>
	else if (*s == '-')
  800bb8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bbf:	3c 2d                	cmp    $0x2d,%al
  800bc1:	75 0a                	jne    800bcd <strtol+0x44>
		s++, neg = 1;
  800bc3:	8d 52 01             	lea    0x1(%edx),%edx
  800bc6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bcd:	85 db                	test   %ebx,%ebx
  800bcf:	0f 94 c0             	sete   %al
  800bd2:	74 05                	je     800bd9 <strtol+0x50>
  800bd4:	83 fb 10             	cmp    $0x10,%ebx
  800bd7:	75 15                	jne    800bee <strtol+0x65>
  800bd9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bdc:	75 10                	jne    800bee <strtol+0x65>
  800bde:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800be2:	75 0a                	jne    800bee <strtol+0x65>
		s += 2, base = 16;
  800be4:	83 c2 02             	add    $0x2,%edx
  800be7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bec:	eb 13                	jmp    800c01 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bee:	84 c0                	test   %al,%al
  800bf0:	74 0f                	je     800c01 <strtol+0x78>
  800bf2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800bf7:	80 3a 30             	cmpb   $0x30,(%edx)
  800bfa:	75 05                	jne    800c01 <strtol+0x78>
		s++, base = 8;
  800bfc:	83 c2 01             	add    $0x1,%edx
  800bff:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
  800c06:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c08:	0f b6 0a             	movzbl (%edx),%ecx
  800c0b:	89 cf                	mov    %ecx,%edi
  800c0d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c10:	80 fb 09             	cmp    $0x9,%bl
  800c13:	77 08                	ja     800c1d <strtol+0x94>
			dig = *s - '0';
  800c15:	0f be c9             	movsbl %cl,%ecx
  800c18:	83 e9 30             	sub    $0x30,%ecx
  800c1b:	eb 1e                	jmp    800c3b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800c1d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c20:	80 fb 19             	cmp    $0x19,%bl
  800c23:	77 08                	ja     800c2d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800c25:	0f be c9             	movsbl %cl,%ecx
  800c28:	83 e9 57             	sub    $0x57,%ecx
  800c2b:	eb 0e                	jmp    800c3b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800c2d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c30:	80 fb 19             	cmp    $0x19,%bl
  800c33:	77 15                	ja     800c4a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c35:	0f be c9             	movsbl %cl,%ecx
  800c38:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c3b:	39 f1                	cmp    %esi,%ecx
  800c3d:	7d 0b                	jge    800c4a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c3f:	83 c2 01             	add    $0x1,%edx
  800c42:	0f af c6             	imul   %esi,%eax
  800c45:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c48:	eb be                	jmp    800c08 <strtol+0x7f>
  800c4a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c50:	74 05                	je     800c57 <strtol+0xce>
		*endptr = (char *) s;
  800c52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c55:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c57:	89 ca                	mov    %ecx,%edx
  800c59:	f7 da                	neg    %edx
  800c5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c5f:	0f 45 c2             	cmovne %edx,%eax
}
  800c62:	83 c4 04             	add    $0x4,%esp
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    
	...

00800c6c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 0c             	sub    $0xc,%esp
  800c72:	89 1c 24             	mov    %ebx,(%esp)
  800c75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c79:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c82:	b8 01 00 00 00       	mov    $0x1,%eax
  800c87:	89 d1                	mov    %edx,%ecx
  800c89:	89 d3                	mov    %edx,%ebx
  800c8b:	89 d7                	mov    %edx,%edi
  800c8d:	89 d6                	mov    %edx,%esi
  800c8f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c91:	8b 1c 24             	mov    (%esp),%ebx
  800c94:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c98:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c9c:	89 ec                	mov    %ebp,%esp
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 0c             	sub    $0xc,%esp
  800ca6:	89 1c 24             	mov    %ebx,(%esp)
  800ca9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	89 c3                	mov    %eax,%ebx
  800cbe:	89 c7                	mov    %eax,%edi
  800cc0:	89 c6                	mov    %eax,%esi
  800cc2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc4:	8b 1c 24             	mov    (%esp),%ebx
  800cc7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ccb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ccf:	89 ec                	mov    %ebp,%esp
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	89 1c 24             	mov    %ebx,(%esp)
  800cdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ce0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce9:	b8 10 00 00 00       	mov    $0x10,%eax
  800cee:	89 d1                	mov    %edx,%ecx
  800cf0:	89 d3                	mov    %edx,%ebx
  800cf2:	89 d7                	mov    %edx,%edi
  800cf4:	89 d6                	mov    %edx,%esi
  800cf6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800cf8:	8b 1c 24             	mov    (%esp),%ebx
  800cfb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cff:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d03:	89 ec                	mov    %ebp,%esp
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	83 ec 38             	sub    $0x38,%esp
  800d0d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d10:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d13:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	89 df                	mov    %ebx,%edi
  800d28:	89 de                	mov    %ebx,%esi
  800d2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7e 28                	jle    800d58 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d34:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d3b:	00 
  800d3c:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  800d43:	00 
  800d44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d4b:	00 
  800d4c:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  800d53:	e8 78 f4 ff ff       	call   8001d0 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800d58:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d5b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d5e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d61:	89 ec                	mov    %ebp,%esp
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 38             	sub    $0x38,%esp
  800d6b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d6e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d71:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d79:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	89 df                	mov    %ebx,%edi
  800d86:	89 de                	mov    %ebx,%esi
  800d88:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7e 28                	jle    800db6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d92:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800d99:	00 
  800d9a:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  800da1:	00 
  800da2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da9:	00 
  800daa:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  800db1:	e8 1a f4 ff ff       	call   8001d0 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800db6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800db9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dbc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dbf:	89 ec                	mov    %ebp,%esp
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 38             	sub    $0x38,%esp
  800dc9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dcc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dcf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	89 cb                	mov    %ecx,%ebx
  800de1:	89 cf                	mov    %ecx,%edi
  800de3:	89 ce                	mov    %ecx,%esi
  800de5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7e 28                	jle    800e13 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800deb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800def:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800df6:	00 
  800df7:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  800dfe:	00 
  800dff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e06:	00 
  800e07:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  800e0e:	e8 bd f3 ff ff       	call   8001d0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e13:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e16:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e19:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e1c:	89 ec                	mov    %ebp,%esp
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	89 1c 24             	mov    %ebx,(%esp)
  800e29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e2d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e31:	be 00 00 00 00       	mov    $0x0,%esi
  800e36:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e49:	8b 1c 24             	mov    (%esp),%ebx
  800e4c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e50:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e54:	89 ec                	mov    %ebp,%esp
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 38             	sub    $0x38,%esp
  800e5e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e61:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e64:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e74:	8b 55 08             	mov    0x8(%ebp),%edx
  800e77:	89 df                	mov    %ebx,%edi
  800e79:	89 de                	mov    %ebx,%esi
  800e7b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	7e 28                	jle    800ea9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e81:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e85:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e8c:	00 
  800e8d:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  800e94:	00 
  800e95:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e9c:	00 
  800e9d:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  800ea4:	e8 27 f3 ff ff       	call   8001d0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ea9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eac:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eaf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eb2:	89 ec                	mov    %ebp,%esp
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    

00800eb6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 38             	sub    $0x38,%esp
  800ebc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ebf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ec2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eca:	b8 09 00 00 00       	mov    $0x9,%eax
  800ecf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	89 df                	mov    %ebx,%edi
  800ed7:	89 de                	mov    %ebx,%esi
  800ed9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800edb:	85 c0                	test   %eax,%eax
  800edd:	7e 28                	jle    800f07 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800edf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eea:	00 
  800eeb:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  800ef2:	00 
  800ef3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efa:	00 
  800efb:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  800f02:	e8 c9 f2 ff ff       	call   8001d0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f07:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f0a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f0d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f10:	89 ec                	mov    %ebp,%esp
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 38             	sub    $0x38,%esp
  800f1a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f1d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f20:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f28:	b8 08 00 00 00       	mov    $0x8,%eax
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	89 df                	mov    %ebx,%edi
  800f35:	89 de                	mov    %ebx,%esi
  800f37:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7e 28                	jle    800f65 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f41:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f48:	00 
  800f49:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  800f50:	00 
  800f51:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f58:	00 
  800f59:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  800f60:	e8 6b f2 ff ff       	call   8001d0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f65:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f68:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f6b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f6e:	89 ec                	mov    %ebp,%esp
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    

00800f72 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 38             	sub    $0x38,%esp
  800f78:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f7b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f7e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f86:	b8 06 00 00 00       	mov    $0x6,%eax
  800f8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f91:	89 df                	mov    %ebx,%edi
  800f93:	89 de                	mov    %ebx,%esi
  800f95:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f97:	85 c0                	test   %eax,%eax
  800f99:	7e 28                	jle    800fc3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fa6:	00 
  800fa7:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  800fae:	00 
  800faf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb6:	00 
  800fb7:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  800fbe:	e8 0d f2 ff ff       	call   8001d0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fc3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fc6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fc9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fcc:	89 ec                	mov    %ebp,%esp
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 38             	sub    $0x38,%esp
  800fd6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fd9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fdc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fdf:	b8 05 00 00 00       	mov    $0x5,%eax
  800fe4:	8b 75 18             	mov    0x18(%ebp),%esi
  800fe7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	7e 28                	jle    801021 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ffd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801004:	00 
  801005:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  80100c:	00 
  80100d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801014:	00 
  801015:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  80101c:	e8 af f1 ff ff       	call   8001d0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801021:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801024:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801027:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80102a:	89 ec                	mov    %ebp,%esp
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	83 ec 38             	sub    $0x38,%esp
  801034:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801037:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80103a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103d:	be 00 00 00 00       	mov    $0x0,%esi
  801042:	b8 04 00 00 00       	mov    $0x4,%eax
  801047:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80104a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104d:	8b 55 08             	mov    0x8(%ebp),%edx
  801050:	89 f7                	mov    %esi,%edi
  801052:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801054:	85 c0                	test   %eax,%eax
  801056:	7e 28                	jle    801080 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801058:	89 44 24 10          	mov    %eax,0x10(%esp)
  80105c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801063:	00 
  801064:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  80106b:	00 
  80106c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801073:	00 
  801074:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  80107b:	e8 50 f1 ff ff       	call   8001d0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801080:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801083:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801086:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801089:	89 ec                	mov    %ebp,%esp
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    

0080108d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	83 ec 0c             	sub    $0xc,%esp
  801093:	89 1c 24             	mov    %ebx,(%esp)
  801096:	89 74 24 04          	mov    %esi,0x4(%esp)
  80109a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109e:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010a8:	89 d1                	mov    %edx,%ecx
  8010aa:	89 d3                	mov    %edx,%ebx
  8010ac:	89 d7                	mov    %edx,%edi
  8010ae:	89 d6                	mov    %edx,%esi
  8010b0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010b2:	8b 1c 24             	mov    (%esp),%ebx
  8010b5:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010b9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010bd:	89 ec                	mov    %ebp,%esp
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    

008010c1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 0c             	sub    $0xc,%esp
  8010c7:	89 1c 24             	mov    %ebx,(%esp)
  8010ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8010dc:	89 d1                	mov    %edx,%ecx
  8010de:	89 d3                	mov    %edx,%ebx
  8010e0:	89 d7                	mov    %edx,%edi
  8010e2:	89 d6                	mov    %edx,%esi
  8010e4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010e6:	8b 1c 24             	mov    (%esp),%ebx
  8010e9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010ed:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010f1:	89 ec                	mov    %ebp,%esp
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 38             	sub    $0x38,%esp
  8010fb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010fe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801101:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801104:	b9 00 00 00 00       	mov    $0x0,%ecx
  801109:	b8 03 00 00 00       	mov    $0x3,%eax
  80110e:	8b 55 08             	mov    0x8(%ebp),%edx
  801111:	89 cb                	mov    %ecx,%ebx
  801113:	89 cf                	mov    %ecx,%edi
  801115:	89 ce                	mov    %ecx,%esi
  801117:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801119:	85 c0                	test   %eax,%eax
  80111b:	7e 28                	jle    801145 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80111d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801121:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801128:	00 
  801129:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  801130:	00 
  801131:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801138:	00 
  801139:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  801140:	e8 8b f0 ff ff       	call   8001d0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801145:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801148:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80114b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80114e:	89 ec                	mov    %ebp,%esp
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    
	...

00801154 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	05 00 00 00 30       	add    $0x30000000,%eax
  80115f:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    

00801164 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	89 04 24             	mov    %eax,(%esp)
  801170:	e8 df ff ff ff       	call   801154 <fd2num>
  801175:	05 20 00 0d 00       	add    $0xd0020,%eax
  80117a:	c1 e0 0c             	shl    $0xc,%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	57                   	push   %edi
  801183:	56                   	push   %esi
  801184:	53                   	push   %ebx
  801185:	8b 7d 08             	mov    0x8(%ebp),%edi
  801188:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80118d:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801192:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801197:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801199:	89 c2                	mov    %eax,%edx
  80119b:	c1 ea 16             	shr    $0x16,%edx
  80119e:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8011a1:	f6 c2 01             	test   $0x1,%dl
  8011a4:	74 0d                	je     8011b3 <fd_alloc+0x34>
  8011a6:	89 c2                	mov    %eax,%edx
  8011a8:	c1 ea 0c             	shr    $0xc,%edx
  8011ab:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  8011ae:	f6 c2 01             	test   $0x1,%dl
  8011b1:	75 09                	jne    8011bc <fd_alloc+0x3d>
			*fd_store = fd;
  8011b3:	89 37                	mov    %esi,(%edi)
  8011b5:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8011ba:	eb 17                	jmp    8011d3 <fd_alloc+0x54>
  8011bc:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011c1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011c6:	75 cf                	jne    801197 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011c8:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8011ce:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8011d3:	5b                   	pop    %ebx
  8011d4:	5e                   	pop    %esi
  8011d5:	5f                   	pop    %edi
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    

008011d8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	83 f8 1f             	cmp    $0x1f,%eax
  8011e1:	77 36                	ja     801219 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011e3:	05 00 00 0d 00       	add    $0xd0000,%eax
  8011e8:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011eb:	89 c2                	mov    %eax,%edx
  8011ed:	c1 ea 16             	shr    $0x16,%edx
  8011f0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011f7:	f6 c2 01             	test   $0x1,%dl
  8011fa:	74 1d                	je     801219 <fd_lookup+0x41>
  8011fc:	89 c2                	mov    %eax,%edx
  8011fe:	c1 ea 0c             	shr    $0xc,%edx
  801201:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801208:	f6 c2 01             	test   $0x1,%dl
  80120b:	74 0c                	je     801219 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80120d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801210:	89 02                	mov    %eax,(%edx)
  801212:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801217:	eb 05                	jmp    80121e <fd_lookup+0x46>
  801219:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801226:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801229:	89 44 24 04          	mov    %eax,0x4(%esp)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	89 04 24             	mov    %eax,(%esp)
  801233:	e8 a0 ff ff ff       	call   8011d8 <fd_lookup>
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 0e                	js     80124a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80123c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801242:	89 50 04             	mov    %edx,0x4(%eax)
  801245:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
  801251:	83 ec 10             	sub    $0x10,%esp
  801254:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801257:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80125a:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80125f:	be 34 2e 80 00       	mov    $0x802e34,%esi
  801264:	eb 10                	jmp    801276 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  801266:	39 08                	cmp    %ecx,(%eax)
  801268:	75 09                	jne    801273 <dev_lookup+0x27>
			*dev = devtab[i];
  80126a:	89 03                	mov    %eax,(%ebx)
  80126c:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801271:	eb 31                	jmp    8012a4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801273:	83 c2 01             	add    $0x1,%edx
  801276:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801279:	85 c0                	test   %eax,%eax
  80127b:	75 e9                	jne    801266 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80127d:	a1 20 60 80 00       	mov    0x806020,%eax
  801282:	8b 40 48             	mov    0x48(%eax),%eax
  801285:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128d:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  801294:	e8 f0 ef ff ff       	call   800289 <cprintf>
	*dev = 0;
  801299:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80129f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	5b                   	pop    %ebx
  8012a8:	5e                   	pop    %esi
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    

008012ab <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	53                   	push   %ebx
  8012af:	83 ec 24             	sub    $0x24,%esp
  8012b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	89 04 24             	mov    %eax,(%esp)
  8012c2:	e8 11 ff ff ff       	call   8011d8 <fd_lookup>
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	78 53                	js     80131e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	89 04 24             	mov    %eax,(%esp)
  8012da:	e8 6d ff ff ff       	call   80124c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	78 3b                	js     80131e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8012e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012eb:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8012ef:	74 2d                	je     80131e <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012f1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012f4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012fb:	00 00 00 
	stat->st_isdir = 0;
  8012fe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801305:	00 00 00 
	stat->st_dev = dev;
  801308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801311:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801315:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801318:	89 14 24             	mov    %edx,(%esp)
  80131b:	ff 50 14             	call   *0x14(%eax)
}
  80131e:	83 c4 24             	add    $0x24,%esp
  801321:	5b                   	pop    %ebx
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    

00801324 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	53                   	push   %ebx
  801328:	83 ec 24             	sub    $0x24,%esp
  80132b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80132e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801331:	89 44 24 04          	mov    %eax,0x4(%esp)
  801335:	89 1c 24             	mov    %ebx,(%esp)
  801338:	e8 9b fe ff ff       	call   8011d8 <fd_lookup>
  80133d:	85 c0                	test   %eax,%eax
  80133f:	78 5f                	js     8013a0 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801341:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801344:	89 44 24 04          	mov    %eax,0x4(%esp)
  801348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134b:	8b 00                	mov    (%eax),%eax
  80134d:	89 04 24             	mov    %eax,(%esp)
  801350:	e8 f7 fe ff ff       	call   80124c <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801355:	85 c0                	test   %eax,%eax
  801357:	78 47                	js     8013a0 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801359:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80135c:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801360:	75 23                	jne    801385 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801362:	a1 20 60 80 00       	mov    0x806020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801367:	8b 40 48             	mov    0x48(%eax),%eax
  80136a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80136e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801372:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  801379:	e8 0b ef ff ff       	call   800289 <cprintf>
  80137e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801383:	eb 1b                	jmp    8013a0 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801388:	8b 48 18             	mov    0x18(%eax),%ecx
  80138b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801390:	85 c9                	test   %ecx,%ecx
  801392:	74 0c                	je     8013a0 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139b:	89 14 24             	mov    %edx,(%esp)
  80139e:	ff d1                	call   *%ecx
}
  8013a0:	83 c4 24             	add    $0x24,%esp
  8013a3:	5b                   	pop    %ebx
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 24             	sub    $0x24,%esp
  8013ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b7:	89 1c 24             	mov    %ebx,(%esp)
  8013ba:	e8 19 fe ff ff       	call   8011d8 <fd_lookup>
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 66                	js     801429 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	89 04 24             	mov    %eax,(%esp)
  8013d2:	e8 75 fe ff ff       	call   80124c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	78 4e                	js     801429 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013de:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8013e2:	75 23                	jne    801407 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e4:	a1 20 60 80 00       	mov    0x806020,%eax
  8013e9:	8b 40 48             	mov    0x48(%eax),%eax
  8013ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f4:	c7 04 24 f8 2d 80 00 	movl   $0x802df8,(%esp)
  8013fb:	e8 89 ee ff ff       	call   800289 <cprintf>
  801400:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801405:	eb 22                	jmp    801429 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80140d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801412:	85 c9                	test   %ecx,%ecx
  801414:	74 13                	je     801429 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	89 44 24 08          	mov    %eax,0x8(%esp)
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	89 44 24 04          	mov    %eax,0x4(%esp)
  801424:	89 14 24             	mov    %edx,(%esp)
  801427:	ff d1                	call   *%ecx
}
  801429:	83 c4 24             	add    $0x24,%esp
  80142c:	5b                   	pop    %ebx
  80142d:	5d                   	pop    %ebp
  80142e:	c3                   	ret    

0080142f <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	53                   	push   %ebx
  801433:	83 ec 24             	sub    $0x24,%esp
  801436:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801439:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80143c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801440:	89 1c 24             	mov    %ebx,(%esp)
  801443:	e8 90 fd ff ff       	call   8011d8 <fd_lookup>
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 6b                	js     8014b7 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80144c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	8b 00                	mov    (%eax),%eax
  801458:	89 04 24             	mov    %eax,(%esp)
  80145b:	e8 ec fd ff ff       	call   80124c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801460:	85 c0                	test   %eax,%eax
  801462:	78 53                	js     8014b7 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801467:	8b 42 08             	mov    0x8(%edx),%eax
  80146a:	83 e0 03             	and    $0x3,%eax
  80146d:	83 f8 01             	cmp    $0x1,%eax
  801470:	75 23                	jne    801495 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801472:	a1 20 60 80 00       	mov    0x806020,%eax
  801477:	8b 40 48             	mov    0x48(%eax),%eax
  80147a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80147e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801482:	c7 04 24 15 2e 80 00 	movl   $0x802e15,(%esp)
  801489:	e8 fb ed ff ff       	call   800289 <cprintf>
  80148e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801493:	eb 22                	jmp    8014b7 <read+0x88>
	}
	if (!dev->dev_read)
  801495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801498:	8b 48 08             	mov    0x8(%eax),%ecx
  80149b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a0:	85 c9                	test   %ecx,%ecx
  8014a2:	74 13                	je     8014b7 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b2:	89 14 24             	mov    %edx,(%esp)
  8014b5:	ff d1                	call   *%ecx
}
  8014b7:	83 c4 24             	add    $0x24,%esp
  8014ba:	5b                   	pop    %ebx
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    

008014bd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	57                   	push   %edi
  8014c1:	56                   	push   %esi
  8014c2:	53                   	push   %ebx
  8014c3:	83 ec 1c             	sub    $0x1c,%esp
  8014c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014c9:	8b 75 10             	mov    0x10(%ebp),%esi
  8014cc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014d1:	eb 21                	jmp    8014f4 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014d3:	89 f2                	mov    %esi,%edx
  8014d5:	29 c2                	sub    %eax,%edx
  8014d7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014db:	03 45 0c             	add    0xc(%ebp),%eax
  8014de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e2:	89 3c 24             	mov    %edi,(%esp)
  8014e5:	e8 45 ff ff ff       	call   80142f <read>
		if (m < 0)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 0e                	js     8014fc <readn+0x3f>
			return m;
		if (m == 0)
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	74 08                	je     8014fa <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014f2:	01 c3                	add    %eax,%ebx
  8014f4:	89 d8                	mov    %ebx,%eax
  8014f6:	39 f3                	cmp    %esi,%ebx
  8014f8:	72 d9                	jb     8014d3 <readn+0x16>
  8014fa:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014fc:	83 c4 1c             	add    $0x1c,%esp
  8014ff:	5b                   	pop    %ebx
  801500:	5e                   	pop    %esi
  801501:	5f                   	pop    %edi
  801502:	5d                   	pop    %ebp
  801503:	c3                   	ret    

00801504 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 38             	sub    $0x38,%esp
  80150a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80150d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801510:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801513:	8b 7d 08             	mov    0x8(%ebp),%edi
  801516:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80151a:	89 3c 24             	mov    %edi,(%esp)
  80151d:	e8 32 fc ff ff       	call   801154 <fd2num>
  801522:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801525:	89 54 24 04          	mov    %edx,0x4(%esp)
  801529:	89 04 24             	mov    %eax,(%esp)
  80152c:	e8 a7 fc ff ff       	call   8011d8 <fd_lookup>
  801531:	89 c3                	mov    %eax,%ebx
  801533:	85 c0                	test   %eax,%eax
  801535:	78 05                	js     80153c <fd_close+0x38>
  801537:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  80153a:	74 0e                	je     80154a <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80153c:	89 f0                	mov    %esi,%eax
  80153e:	84 c0                	test   %al,%al
  801540:	b8 00 00 00 00       	mov    $0x0,%eax
  801545:	0f 44 d8             	cmove  %eax,%ebx
  801548:	eb 3d                	jmp    801587 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80154a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80154d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801551:	8b 07                	mov    (%edi),%eax
  801553:	89 04 24             	mov    %eax,(%esp)
  801556:	e8 f1 fc ff ff       	call   80124c <dev_lookup>
  80155b:	89 c3                	mov    %eax,%ebx
  80155d:	85 c0                	test   %eax,%eax
  80155f:	78 16                	js     801577 <fd_close+0x73>
		if (dev->dev_close)
  801561:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801564:	8b 40 10             	mov    0x10(%eax),%eax
  801567:	bb 00 00 00 00       	mov    $0x0,%ebx
  80156c:	85 c0                	test   %eax,%eax
  80156e:	74 07                	je     801577 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801570:	89 3c 24             	mov    %edi,(%esp)
  801573:	ff d0                	call   *%eax
  801575:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801577:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80157b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801582:	e8 eb f9 ff ff       	call   800f72 <sys_page_unmap>
	return r;
}
  801587:	89 d8                	mov    %ebx,%eax
  801589:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80158c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80158f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801592:	89 ec                	mov    %ebp,%esp
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    

00801596 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80159c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	89 04 24             	mov    %eax,(%esp)
  8015a9:	e8 2a fc ff ff       	call   8011d8 <fd_lookup>
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 13                	js     8015c5 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8015b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015b9:	00 
  8015ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bd:	89 04 24             	mov    %eax,(%esp)
  8015c0:	e8 3f ff ff ff       	call   801504 <fd_close>
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 18             	sub    $0x18,%esp
  8015cd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015d0:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015da:	00 
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	89 04 24             	mov    %eax,(%esp)
  8015e1:	e8 25 04 00 00       	call   801a0b <open>
  8015e6:	89 c3                	mov    %eax,%ebx
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	78 1b                	js     801607 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8015ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f3:	89 1c 24             	mov    %ebx,(%esp)
  8015f6:	e8 b0 fc ff ff       	call   8012ab <fstat>
  8015fb:	89 c6                	mov    %eax,%esi
	close(fd);
  8015fd:	89 1c 24             	mov    %ebx,(%esp)
  801600:	e8 91 ff ff ff       	call   801596 <close>
  801605:	89 f3                	mov    %esi,%ebx
	return r;
}
  801607:	89 d8                	mov    %ebx,%eax
  801609:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80160c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80160f:	89 ec                	mov    %ebp,%esp
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    

00801613 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	53                   	push   %ebx
  801617:	83 ec 14             	sub    $0x14,%esp
  80161a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  80161f:	89 1c 24             	mov    %ebx,(%esp)
  801622:	e8 6f ff ff ff       	call   801596 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801627:	83 c3 01             	add    $0x1,%ebx
  80162a:	83 fb 20             	cmp    $0x20,%ebx
  80162d:	75 f0                	jne    80161f <close_all+0xc>
		close(i);
}
  80162f:	83 c4 14             	add    $0x14,%esp
  801632:	5b                   	pop    %ebx
  801633:	5d                   	pop    %ebp
  801634:	c3                   	ret    

00801635 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 58             	sub    $0x58,%esp
  80163b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80163e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801641:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801644:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801647:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80164a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	89 04 24             	mov    %eax,(%esp)
  801654:	e8 7f fb ff ff       	call   8011d8 <fd_lookup>
  801659:	89 c3                	mov    %eax,%ebx
  80165b:	85 c0                	test   %eax,%eax
  80165d:	0f 88 e0 00 00 00    	js     801743 <dup+0x10e>
		return r;
	close(newfdnum);
  801663:	89 3c 24             	mov    %edi,(%esp)
  801666:	e8 2b ff ff ff       	call   801596 <close>

	newfd = INDEX2FD(newfdnum);
  80166b:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801671:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801677:	89 04 24             	mov    %eax,(%esp)
  80167a:	e8 e5 fa ff ff       	call   801164 <fd2data>
  80167f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801681:	89 34 24             	mov    %esi,(%esp)
  801684:	e8 db fa ff ff       	call   801164 <fd2data>
  801689:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80168c:	89 da                	mov    %ebx,%edx
  80168e:	89 d8                	mov    %ebx,%eax
  801690:	c1 e8 16             	shr    $0x16,%eax
  801693:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80169a:	a8 01                	test   $0x1,%al
  80169c:	74 43                	je     8016e1 <dup+0xac>
  80169e:	c1 ea 0c             	shr    $0xc,%edx
  8016a1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016a8:	a8 01                	test   $0x1,%al
  8016aa:	74 35                	je     8016e1 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016ac:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8016b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016ca:	00 
  8016cb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d6:	e8 f5 f8 ff ff       	call   800fd0 <sys_page_map>
  8016db:	89 c3                	mov    %eax,%ebx
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 3f                	js     801720 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e4:	89 c2                	mov    %eax,%edx
  8016e6:	c1 ea 0c             	shr    $0xc,%edx
  8016e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016f0:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016f6:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801705:	00 
  801706:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801711:	e8 ba f8 ff ff       	call   800fd0 <sys_page_map>
  801716:	89 c3                	mov    %eax,%ebx
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 04                	js     801720 <dup+0xeb>
  80171c:	89 fb                	mov    %edi,%ebx
  80171e:	eb 23                	jmp    801743 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801720:	89 74 24 04          	mov    %esi,0x4(%esp)
  801724:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80172b:	e8 42 f8 ff ff       	call   800f72 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801730:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801733:	89 44 24 04          	mov    %eax,0x4(%esp)
  801737:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80173e:	e8 2f f8 ff ff       	call   800f72 <sys_page_unmap>
	return r;
}
  801743:	89 d8                	mov    %ebx,%eax
  801745:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801748:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80174b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80174e:	89 ec                	mov    %ebp,%esp
  801750:	5d                   	pop    %ebp
  801751:	c3                   	ret    
	...

00801754 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	56                   	push   %esi
  801758:	53                   	push   %ebx
  801759:	83 ec 10             	sub    $0x10,%esp
  80175c:	89 c3                	mov    %eax,%ebx
  80175e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801760:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801767:	75 11                	jne    80177a <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801769:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801770:	e8 af 0e 00 00       	call   802624 <ipc_find_env>
  801775:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  80177a:	a1 20 60 80 00       	mov    0x806020,%eax
  80177f:	8b 40 48             	mov    0x48(%eax),%eax
  801782:	8b 15 00 70 80 00    	mov    0x807000,%edx
  801788:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80178c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801790:	89 44 24 04          	mov    %eax,0x4(%esp)
  801794:	c7 04 24 48 2e 80 00 	movl   $0x802e48,(%esp)
  80179b:	e8 e9 ea ff ff       	call   800289 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017a0:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8017a7:	00 
  8017a8:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8017af:	00 
  8017b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017b4:	a1 00 40 80 00       	mov    0x804000,%eax
  8017b9:	89 04 24             	mov    %eax,(%esp)
  8017bc:	e8 99 0e 00 00       	call   80265a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017c1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017c8:	00 
  8017c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d4:	e8 ed 0e 00 00       	call   8026c6 <ipc_recv>
}
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	5b                   	pop    %ebx
  8017dd:	5e                   	pop    %esi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    

008017e0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ec:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8017f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f4:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fe:	b8 02 00 00 00       	mov    $0x2,%eax
  801803:	e8 4c ff ff ff       	call   801754 <fsipc>
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8b 40 0c             	mov    0xc(%eax),%eax
  801816:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  80181b:	ba 00 00 00 00       	mov    $0x0,%edx
  801820:	b8 06 00 00 00       	mov    $0x6,%eax
  801825:	e8 2a ff ff ff       	call   801754 <fsipc>
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	b8 08 00 00 00       	mov    $0x8,%eax
  80183c:	e8 13 ff ff ff       	call   801754 <fsipc>
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	53                   	push   %ebx
  801847:	83 ec 14             	sub    $0x14,%esp
  80184a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	8b 40 0c             	mov    0xc(%eax),%eax
  801853:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	b8 05 00 00 00       	mov    $0x5,%eax
  801862:	e8 ed fe ff ff       	call   801754 <fsipc>
  801867:	85 c0                	test   %eax,%eax
  801869:	78 2b                	js     801896 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80186b:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801872:	00 
  801873:	89 1c 24             	mov    %ebx,(%esp)
  801876:	e8 6e f0 ff ff       	call   8008e9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80187b:	a1 80 70 80 00       	mov    0x807080,%eax
  801880:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801886:	a1 84 70 80 00       	mov    0x807084,%eax
  80188b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801896:	83 c4 14             	add    $0x14,%esp
  801899:	5b                   	pop    %ebx
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    

0080189c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 14             	sub    $0x14,%esp
  8018a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ac:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  8018b1:	89 1d 04 70 80 00    	mov    %ebx,0x807004

	assert(n<=PGSIZE);
  8018b7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8018bd:	76 24                	jbe    8018e3 <devfile_write+0x47>
  8018bf:	c7 44 24 0c 5e 2e 80 	movl   $0x802e5e,0xc(%esp)
  8018c6:	00 
  8018c7:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  8018ce:	00 
  8018cf:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  8018d6:	00 
  8018d7:	c7 04 24 7d 2e 80 00 	movl   $0x802e7d,(%esp)
  8018de:	e8 ed e8 ff ff       	call   8001d0 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  8018e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ee:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  8018f5:	e8 95 f1 ff ff       	call   800a8f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  8018fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ff:	b8 04 00 00 00       	mov    $0x4,%eax
  801904:	e8 4b fe ff ff       	call   801754 <fsipc>
	if(ret<0) return ret;
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 53                	js     801960 <devfile_write+0xc4>
	
	assert(ret <= n);
  80190d:	39 c3                	cmp    %eax,%ebx
  80190f:	73 24                	jae    801935 <devfile_write+0x99>
  801911:	c7 44 24 0c 88 2e 80 	movl   $0x802e88,0xc(%esp)
  801918:	00 
  801919:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  801920:	00 
  801921:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801928:	00 
  801929:	c7 04 24 7d 2e 80 00 	movl   $0x802e7d,(%esp)
  801930:	e8 9b e8 ff ff       	call   8001d0 <_panic>
	assert(ret <= PGSIZE);
  801935:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80193a:	7e 24                	jle    801960 <devfile_write+0xc4>
  80193c:	c7 44 24 0c 91 2e 80 	movl   $0x802e91,0xc(%esp)
  801943:	00 
  801944:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  80194b:	00 
  80194c:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801953:	00 
  801954:	c7 04 24 7d 2e 80 00 	movl   $0x802e7d,(%esp)
  80195b:	e8 70 e8 ff ff       	call   8001d0 <_panic>
	return ret;
}
  801960:	83 c4 14             	add    $0x14,%esp
  801963:	5b                   	pop    %ebx
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	56                   	push   %esi
  80196a:	53                   	push   %ebx
  80196b:	83 ec 10             	sub    $0x10,%esp
  80196e:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	8b 40 0c             	mov    0xc(%eax),%eax
  801977:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80197c:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801982:	ba 00 00 00 00       	mov    $0x0,%edx
  801987:	b8 03 00 00 00       	mov    $0x3,%eax
  80198c:	e8 c3 fd ff ff       	call   801754 <fsipc>
  801991:	89 c3                	mov    %eax,%ebx
  801993:	85 c0                	test   %eax,%eax
  801995:	78 6b                	js     801a02 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801997:	39 de                	cmp    %ebx,%esi
  801999:	73 24                	jae    8019bf <devfile_read+0x59>
  80199b:	c7 44 24 0c 9f 2e 80 	movl   $0x802e9f,0xc(%esp)
  8019a2:	00 
  8019a3:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  8019aa:	00 
  8019ab:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8019b2:	00 
  8019b3:	c7 04 24 7d 2e 80 00 	movl   $0x802e7d,(%esp)
  8019ba:	e8 11 e8 ff ff       	call   8001d0 <_panic>
	assert(r <= PGSIZE);
  8019bf:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8019c5:	7e 24                	jle    8019eb <devfile_read+0x85>
  8019c7:	c7 44 24 0c a6 2e 80 	movl   $0x802ea6,0xc(%esp)
  8019ce:	00 
  8019cf:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  8019d6:	00 
  8019d7:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8019de:	00 
  8019df:	c7 04 24 7d 2e 80 00 	movl   $0x802e7d,(%esp)
  8019e6:	e8 e5 e7 ff ff       	call   8001d0 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ef:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8019f6:	00 
  8019f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fa:	89 04 24             	mov    %eax,(%esp)
  8019fd:	e8 8d f0 ff ff       	call   800a8f <memmove>
	return r;
}
  801a02:	89 d8                	mov    %ebx,%eax
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	5b                   	pop    %ebx
  801a08:	5e                   	pop    %esi
  801a09:	5d                   	pop    %ebp
  801a0a:	c3                   	ret    

00801a0b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 28             	sub    $0x28,%esp
  801a11:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a14:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a17:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a1a:	89 34 24             	mov    %esi,(%esp)
  801a1d:	e8 8e ee ff ff       	call   8008b0 <strlen>
  801a22:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a27:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a2c:	7f 5e                	jg     801a8c <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a31:	89 04 24             	mov    %eax,(%esp)
  801a34:	e8 46 f7 ff ff       	call   80117f <fd_alloc>
  801a39:	89 c3                	mov    %eax,%ebx
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	78 4d                	js     801a8c <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a3f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a43:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  801a4a:	e8 9a ee ff ff       	call   8008e9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5f:	e8 f0 fc ff ff       	call   801754 <fsipc>
  801a64:	89 c3                	mov    %eax,%ebx
  801a66:	85 c0                	test   %eax,%eax
  801a68:	79 15                	jns    801a7f <open+0x74>
		fd_close(fd, 0);
  801a6a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a71:	00 
  801a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a75:	89 04 24             	mov    %eax,(%esp)
  801a78:	e8 87 fa ff ff       	call   801504 <fd_close>
		return r;
  801a7d:	eb 0d                	jmp    801a8c <open+0x81>
	}

	return fd2num(fd);
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	89 04 24             	mov    %eax,(%esp)
  801a85:	e8 ca f6 ff ff       	call   801154 <fd2num>
  801a8a:	89 c3                	mov    %eax,%ebx
}
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a91:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a94:	89 ec                	mov    %ebp,%esp
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    

00801a98 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	53                   	push   %ebx
  801a9c:	83 ec 14             	sub    $0x14,%esp
  801a9f:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801aa1:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801aa5:	7e 31                	jle    801ad8 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801aa7:	8b 40 04             	mov    0x4(%eax),%eax
  801aaa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aae:	8d 43 10             	lea    0x10(%ebx),%eax
  801ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab5:	8b 03                	mov    (%ebx),%eax
  801ab7:	89 04 24             	mov    %eax,(%esp)
  801aba:	e8 e7 f8 ff ff       	call   8013a6 <write>
		if (result > 0)
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	7e 03                	jle    801ac6 <writebuf+0x2e>
			b->result += result;
  801ac3:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801ac6:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ac9:	74 0d                	je     801ad8 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801acb:	85 c0                	test   %eax,%eax
  801acd:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad2:	0f 4f c2             	cmovg  %edx,%eax
  801ad5:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801ad8:	83 c4 14             	add    $0x14,%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5d                   	pop    %ebp
  801add:	c3                   	ret    

00801ade <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801af0:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801af7:	00 00 00 
	b.result = 0;
  801afa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b01:	00 00 00 
	b.error = 1;
  801b04:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b0b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b11:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b18:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b1c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b26:	c7 04 24 9a 1b 80 00 	movl   $0x801b9a,(%esp)
  801b2d:	e8 f5 e8 ff ff       	call   800427 <vprintfmt>
	if (b.idx > 0)
  801b32:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b39:	7e 0b                	jle    801b46 <vfprintf+0x68>
		writebuf(&b);
  801b3b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b41:	e8 52 ff ff ff       	call   801a98 <writebuf>

	return (b.result ? b.result : b.error);
  801b46:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801b5d:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801b60:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b72:	e8 67 ff ff ff       	call   801ade <vfprintf>
	va_end(ap);

	return cnt;
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801b7f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801b82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	89 04 24             	mov    %eax,(%esp)
  801b93:	e8 46 ff ff ff       	call   801ade <vfprintf>
	va_end(ap);

	return cnt;
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	53                   	push   %ebx
  801b9e:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801ba1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801ba4:	8b 43 04             	mov    0x4(%ebx),%eax
  801ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  801baa:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801bae:	83 c0 01             	add    $0x1,%eax
  801bb1:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801bb4:	3d 00 01 00 00       	cmp    $0x100,%eax
  801bb9:	75 0e                	jne    801bc9 <putch+0x2f>
		writebuf(b);
  801bbb:	89 d8                	mov    %ebx,%eax
  801bbd:	e8 d6 fe ff ff       	call   801a98 <writebuf>
		b->idx = 0;
  801bc2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801bc9:	83 c4 04             	add    $0x4,%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5d                   	pop    %ebp
  801bce:	c3                   	ret    
	...

00801bd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801bd6:	c7 44 24 04 b2 2e 80 	movl   $0x802eb2,0x4(%esp)
  801bdd:	00 
  801bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be1:	89 04 24             	mov    %eax,(%esp)
  801be4:	e8 00 ed ff ff       	call   8008e9 <strcpy>
	return 0;
}
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 14             	sub    $0x14,%esp
  801bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bfa:	89 1c 24             	mov    %ebx,(%esp)
  801bfd:	e8 4e 0b 00 00       	call   802750 <pageref>
  801c02:	89 c2                	mov    %eax,%edx
  801c04:	b8 00 00 00 00       	mov    $0x0,%eax
  801c09:	83 fa 01             	cmp    $0x1,%edx
  801c0c:	75 0b                	jne    801c19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801c0e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801c11:	89 04 24             	mov    %eax,(%esp)
  801c14:	e8 b1 02 00 00       	call   801eca <nsipc_close>
	else
		return 0;
}
  801c19:	83 c4 14             	add    $0x14,%esp
  801c1c:	5b                   	pop    %ebx
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    

00801c1f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c25:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c2c:	00 
  801c2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c30:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c41:	89 04 24             	mov    %eax,(%esp)
  801c44:	e8 bd 02 00 00       	call   801f06 <nsipc_send>
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c51:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c58:	00 
  801c59:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c6d:	89 04 24             	mov    %eax,(%esp)
  801c70:	e8 04 03 00 00       	call   801f79 <nsipc_recv>
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	56                   	push   %esi
  801c7b:	53                   	push   %ebx
  801c7c:	83 ec 20             	sub    $0x20,%esp
  801c7f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c84:	89 04 24             	mov    %eax,(%esp)
  801c87:	e8 f3 f4 ff ff       	call   80117f <fd_alloc>
  801c8c:	89 c3                	mov    %eax,%ebx
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	78 21                	js     801cb3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c92:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c99:	00 
  801c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca8:	e8 81 f3 ff ff       	call   80102e <sys_page_alloc>
  801cad:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	79 0a                	jns    801cbd <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801cb3:	89 34 24             	mov    %esi,(%esp)
  801cb6:	e8 0f 02 00 00       	call   801eca <nsipc_close>
		return r;
  801cbb:	eb 28                	jmp    801ce5 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801cbd:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdb:	89 04 24             	mov    %eax,(%esp)
  801cde:	e8 71 f4 ff ff       	call   801154 <fd2num>
  801ce3:	89 c3                	mov    %eax,%ebx
}
  801ce5:	89 d8                	mov    %ebx,%eax
  801ce7:	83 c4 20             	add    $0x20,%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5d                   	pop    %ebp
  801ced:	c3                   	ret    

00801cee <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cf4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	89 04 24             	mov    %eax,(%esp)
  801d08:	e8 71 01 00 00       	call   801e7e <nsipc_socket>
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	78 05                	js     801d16 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801d11:	e8 61 ff ff ff       	call   801c77 <alloc_sockfd>
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d1e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d21:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d25:	89 04 24             	mov    %eax,(%esp)
  801d28:	e8 ab f4 ff ff       	call   8011d8 <fd_lookup>
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	78 15                	js     801d46 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d34:	8b 0a                	mov    (%edx),%ecx
  801d36:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d3b:	3b 0d 20 30 80 00    	cmp    0x803020,%ecx
  801d41:	75 03                	jne    801d46 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d43:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	e8 c2 ff ff ff       	call   801d18 <fd2sockid>
  801d56:	85 c0                	test   %eax,%eax
  801d58:	78 0f                	js     801d69 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d61:	89 04 24             	mov    %eax,(%esp)
  801d64:	e8 3f 01 00 00       	call   801ea8 <nsipc_listen>
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	e8 9f ff ff ff       	call   801d18 <fd2sockid>
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	78 16                	js     801d93 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801d7d:	8b 55 10             	mov    0x10(%ebp),%edx
  801d80:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d87:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d8b:	89 04 24             	mov    %eax,(%esp)
  801d8e:	e8 66 02 00 00       	call   801ff9 <nsipc_connect>
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	e8 75 ff ff ff       	call   801d18 <fd2sockid>
  801da3:	85 c0                	test   %eax,%eax
  801da5:	78 0f                	js     801db6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daa:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dae:	89 04 24             	mov    %eax,(%esp)
  801db1:	e8 2e 01 00 00       	call   801ee4 <nsipc_shutdown>
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	e8 52 ff ff ff       	call   801d18 <fd2sockid>
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	78 16                	js     801de0 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801dca:	8b 55 10             	mov    0x10(%ebp),%edx
  801dcd:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dd8:	89 04 24             	mov    %eax,(%esp)
  801ddb:	e8 58 02 00 00       	call   802038 <nsipc_bind>
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	e8 28 ff ff ff       	call   801d18 <fd2sockid>
  801df0:	85 c0                	test   %eax,%eax
  801df2:	78 1f                	js     801e13 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801df4:	8b 55 10             	mov    0x10(%ebp),%edx
  801df7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfe:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e02:	89 04 24             	mov    %eax,(%esp)
  801e05:	e8 6d 02 00 00       	call   802077 <nsipc_accept>
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	78 05                	js     801e13 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801e0e:	e8 64 fe ff ff       	call   801c77 <alloc_sockfd>
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    
  801e15:	00 00                	add    %al,(%eax)
	...

00801e18 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	53                   	push   %ebx
  801e1c:	83 ec 14             	sub    $0x14,%esp
  801e1f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e21:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801e28:	75 11                	jne    801e3b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e2a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801e31:	e8 ee 07 00 00       	call   802624 <ipc_find_env>
  801e36:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e3b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e42:	00 
  801e43:	c7 44 24 08 00 90 80 	movl   $0x809000,0x8(%esp)
  801e4a:	00 
  801e4b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e4f:	a1 04 40 80 00       	mov    0x804004,%eax
  801e54:	89 04 24             	mov    %eax,(%esp)
  801e57:	e8 fe 07 00 00       	call   80265a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e5c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e63:	00 
  801e64:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e6b:	00 
  801e6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e73:	e8 4e 08 00 00       	call   8026c6 <ipc_recv>
}
  801e78:	83 c4 14             	add    $0x14,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  801e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8f:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  801e94:	8b 45 10             	mov    0x10(%ebp),%eax
  801e97:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  801e9c:	b8 09 00 00 00       	mov    $0x9,%eax
  801ea1:	e8 72 ff ff ff       	call   801e18 <nsipc>
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  801eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb9:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  801ebe:	b8 06 00 00 00       	mov    $0x6,%eax
  801ec3:	e8 50 ff ff ff       	call   801e18 <nsipc>
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  801ed8:	b8 04 00 00 00       	mov    $0x4,%eax
  801edd:	e8 36 ff ff ff       	call   801e18 <nsipc>
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  801ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef5:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  801efa:	b8 03 00 00 00       	mov    $0x3,%eax
  801eff:	e8 14 ff ff ff       	call   801e18 <nsipc>
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	53                   	push   %ebx
  801f0a:	83 ec 14             	sub    $0x14,%esp
  801f0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  801f18:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f1e:	7e 24                	jle    801f44 <nsipc_send+0x3e>
  801f20:	c7 44 24 0c be 2e 80 	movl   $0x802ebe,0xc(%esp)
  801f27:	00 
  801f28:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  801f2f:	00 
  801f30:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  801f37:	00 
  801f38:	c7 04 24 ca 2e 80 00 	movl   $0x802eca,(%esp)
  801f3f:	e8 8c e2 ff ff       	call   8001d0 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f44:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f4f:	c7 04 24 0c 90 80 00 	movl   $0x80900c,(%esp)
  801f56:	e8 34 eb ff ff       	call   800a8f <memmove>
	nsipcbuf.send.req_size = size;
  801f5b:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  801f61:	8b 45 14             	mov    0x14(%ebp),%eax
  801f64:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  801f69:	b8 08 00 00 00       	mov    $0x8,%eax
  801f6e:	e8 a5 fe ff ff       	call   801e18 <nsipc>
}
  801f73:	83 c4 14             	add    $0x14,%esp
  801f76:	5b                   	pop    %ebx
  801f77:	5d                   	pop    %ebp
  801f78:	c3                   	ret    

00801f79 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 10             	sub    $0x10,%esp
  801f81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  801f8c:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  801f92:	8b 45 14             	mov    0x14(%ebp),%eax
  801f95:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f9a:	b8 07 00 00 00       	mov    $0x7,%eax
  801f9f:	e8 74 fe ff ff       	call   801e18 <nsipc>
  801fa4:	89 c3                	mov    %eax,%ebx
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	78 46                	js     801ff0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801faa:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801faf:	7f 04                	jg     801fb5 <nsipc_recv+0x3c>
  801fb1:	39 c6                	cmp    %eax,%esi
  801fb3:	7d 24                	jge    801fd9 <nsipc_recv+0x60>
  801fb5:	c7 44 24 0c d6 2e 80 	movl   $0x802ed6,0xc(%esp)
  801fbc:	00 
  801fbd:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  801fc4:	00 
  801fc5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  801fcc:	00 
  801fcd:	c7 04 24 ca 2e 80 00 	movl   $0x802eca,(%esp)
  801fd4:	e8 f7 e1 ff ff       	call   8001d0 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fd9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fdd:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  801fe4:	00 
  801fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe8:	89 04 24             	mov    %eax,(%esp)
  801feb:	e8 9f ea ff ff       	call   800a8f <memmove>
	}

	return r;
}
  801ff0:	89 d8                	mov    %ebx,%eax
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	5b                   	pop    %ebx
  801ff6:	5e                   	pop    %esi
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    

00801ff9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	53                   	push   %ebx
  801ffd:	83 ec 14             	sub    $0x14,%esp
  802000:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80200b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80200f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802012:	89 44 24 04          	mov    %eax,0x4(%esp)
  802016:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  80201d:	e8 6d ea ff ff       	call   800a8f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802022:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  802028:	b8 05 00 00 00       	mov    $0x5,%eax
  80202d:	e8 e6 fd ff ff       	call   801e18 <nsipc>
}
  802032:	83 c4 14             	add    $0x14,%esp
  802035:	5b                   	pop    %ebx
  802036:	5d                   	pop    %ebp
  802037:	c3                   	ret    

00802038 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	53                   	push   %ebx
  80203c:	83 ec 14             	sub    $0x14,%esp
  80203f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80204a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80204e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802051:	89 44 24 04          	mov    %eax,0x4(%esp)
  802055:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  80205c:	e8 2e ea ff ff       	call   800a8f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802061:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  802067:	b8 02 00 00 00       	mov    $0x2,%eax
  80206c:	e8 a7 fd ff ff       	call   801e18 <nsipc>
}
  802071:	83 c4 14             	add    $0x14,%esp
  802074:	5b                   	pop    %ebx
  802075:	5d                   	pop    %ebp
  802076:	c3                   	ret    

00802077 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 28             	sub    $0x28,%esp
  80207d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802080:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802083:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802086:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802091:	8b 07                	mov    (%edi),%eax
  802093:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802098:	b8 01 00 00 00       	mov    $0x1,%eax
  80209d:	e8 76 fd ff ff       	call   801e18 <nsipc>
  8020a2:	89 c6                	mov    %eax,%esi
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	78 22                	js     8020ca <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020a8:	bb 10 90 80 00       	mov    $0x809010,%ebx
  8020ad:	8b 03                	mov    (%ebx),%eax
  8020af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020b3:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  8020ba:	00 
  8020bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020be:	89 04 24             	mov    %eax,(%esp)
  8020c1:	e8 c9 e9 ff ff       	call   800a8f <memmove>
		*addrlen = ret->ret_addrlen;
  8020c6:	8b 03                	mov    (%ebx),%eax
  8020c8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8020ca:	89 f0                	mov    %esi,%eax
  8020cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020cf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020d5:	89 ec                	mov    %ebp,%esp
  8020d7:	5d                   	pop    %ebp
  8020d8:	c3                   	ret    
  8020d9:	00 00                	add    %al,(%eax)
	...

008020dc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 18             	sub    $0x18,%esp
  8020e2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8020e5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8020e8:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	89 04 24             	mov    %eax,(%esp)
  8020f1:	e8 6e f0 ff ff       	call   801164 <fd2data>
  8020f6:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8020f8:	c7 44 24 04 eb 2e 80 	movl   $0x802eeb,0x4(%esp)
  8020ff:	00 
  802100:	89 34 24             	mov    %esi,(%esp)
  802103:	e8 e1 e7 ff ff       	call   8008e9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802108:	8b 43 04             	mov    0x4(%ebx),%eax
  80210b:	2b 03                	sub    (%ebx),%eax
  80210d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802113:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80211a:	00 00 00 
	stat->st_dev = &devpipe;
  80211d:	c7 86 88 00 00 00 3c 	movl   $0x80303c,0x88(%esi)
  802124:	30 80 00 
	return 0;
}
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
  80212c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80212f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802132:	89 ec                	mov    %ebp,%esp
  802134:	5d                   	pop    %ebp
  802135:	c3                   	ret    

00802136 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	53                   	push   %ebx
  80213a:	83 ec 14             	sub    $0x14,%esp
  80213d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802140:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802144:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80214b:	e8 22 ee ff ff       	call   800f72 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802150:	89 1c 24             	mov    %ebx,(%esp)
  802153:	e8 0c f0 ff ff       	call   801164 <fd2data>
  802158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802163:	e8 0a ee ff ff       	call   800f72 <sys_page_unmap>
}
  802168:	83 c4 14             	add    $0x14,%esp
  80216b:	5b                   	pop    %ebx
  80216c:	5d                   	pop    %ebp
  80216d:	c3                   	ret    

0080216e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	57                   	push   %edi
  802172:	56                   	push   %esi
  802173:	53                   	push   %ebx
  802174:	83 ec 2c             	sub    $0x2c,%esp
  802177:	89 c7                	mov    %eax,%edi
  802179:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80217c:	a1 20 60 80 00       	mov    0x806020,%eax
  802181:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802184:	89 3c 24             	mov    %edi,(%esp)
  802187:	e8 c4 05 00 00       	call   802750 <pageref>
  80218c:	89 c6                	mov    %eax,%esi
  80218e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802191:	89 04 24             	mov    %eax,(%esp)
  802194:	e8 b7 05 00 00       	call   802750 <pageref>
  802199:	39 c6                	cmp    %eax,%esi
  80219b:	0f 94 c0             	sete   %al
  80219e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8021a1:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8021a7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021aa:	39 cb                	cmp    %ecx,%ebx
  8021ac:	75 08                	jne    8021b6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8021ae:	83 c4 2c             	add    $0x2c,%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5f                   	pop    %edi
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8021b6:	83 f8 01             	cmp    $0x1,%eax
  8021b9:	75 c1                	jne    80217c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021bb:	8b 52 58             	mov    0x58(%edx),%edx
  8021be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021c2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021ca:	c7 04 24 f2 2e 80 00 	movl   $0x802ef2,(%esp)
  8021d1:	e8 b3 e0 ff ff       	call   800289 <cprintf>
  8021d6:	eb a4                	jmp    80217c <_pipeisclosed+0xe>

008021d8 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	57                   	push   %edi
  8021dc:	56                   	push   %esi
  8021dd:	53                   	push   %ebx
  8021de:	83 ec 1c             	sub    $0x1c,%esp
  8021e1:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8021e4:	89 34 24             	mov    %esi,(%esp)
  8021e7:	e8 78 ef ff ff       	call   801164 <fd2data>
  8021ec:	89 c3                	mov    %eax,%ebx
  8021ee:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021f3:	eb 48                	jmp    80223d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8021f5:	89 da                	mov    %ebx,%edx
  8021f7:	89 f0                	mov    %esi,%eax
  8021f9:	e8 70 ff ff ff       	call   80216e <_pipeisclosed>
  8021fe:	85 c0                	test   %eax,%eax
  802200:	74 07                	je     802209 <devpipe_write+0x31>
  802202:	b8 00 00 00 00       	mov    $0x0,%eax
  802207:	eb 3b                	jmp    802244 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802209:	e8 7f ee ff ff       	call   80108d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80220e:	8b 43 04             	mov    0x4(%ebx),%eax
  802211:	8b 13                	mov    (%ebx),%edx
  802213:	83 c2 20             	add    $0x20,%edx
  802216:	39 d0                	cmp    %edx,%eax
  802218:	73 db                	jae    8021f5 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80221a:	89 c2                	mov    %eax,%edx
  80221c:	c1 fa 1f             	sar    $0x1f,%edx
  80221f:	c1 ea 1b             	shr    $0x1b,%edx
  802222:	01 d0                	add    %edx,%eax
  802224:	83 e0 1f             	and    $0x1f,%eax
  802227:	29 d0                	sub    %edx,%eax
  802229:	89 c2                	mov    %eax,%edx
  80222b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80222e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802232:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802236:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80223a:	83 c7 01             	add    $0x1,%edi
  80223d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802240:	72 cc                	jb     80220e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802242:	89 f8                	mov    %edi,%eax
}
  802244:	83 c4 1c             	add    $0x1c,%esp
  802247:	5b                   	pop    %ebx
  802248:	5e                   	pop    %esi
  802249:	5f                   	pop    %edi
  80224a:	5d                   	pop    %ebp
  80224b:	c3                   	ret    

0080224c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 28             	sub    $0x28,%esp
  802252:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802255:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802258:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80225b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80225e:	89 3c 24             	mov    %edi,(%esp)
  802261:	e8 fe ee ff ff       	call   801164 <fd2data>
  802266:	89 c3                	mov    %eax,%ebx
  802268:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80226d:	eb 48                	jmp    8022b7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80226f:	85 f6                	test   %esi,%esi
  802271:	74 04                	je     802277 <devpipe_read+0x2b>
				return i;
  802273:	89 f0                	mov    %esi,%eax
  802275:	eb 47                	jmp    8022be <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802277:	89 da                	mov    %ebx,%edx
  802279:	89 f8                	mov    %edi,%eax
  80227b:	e8 ee fe ff ff       	call   80216e <_pipeisclosed>
  802280:	85 c0                	test   %eax,%eax
  802282:	74 07                	je     80228b <devpipe_read+0x3f>
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
  802289:	eb 33                	jmp    8022be <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80228b:	e8 fd ed ff ff       	call   80108d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802290:	8b 03                	mov    (%ebx),%eax
  802292:	3b 43 04             	cmp    0x4(%ebx),%eax
  802295:	74 d8                	je     80226f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802297:	89 c2                	mov    %eax,%edx
  802299:	c1 fa 1f             	sar    $0x1f,%edx
  80229c:	c1 ea 1b             	shr    $0x1b,%edx
  80229f:	01 d0                	add    %edx,%eax
  8022a1:	83 e0 1f             	and    $0x1f,%eax
  8022a4:	29 d0                	sub    %edx,%eax
  8022a6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ae:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8022b1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022b4:	83 c6 01             	add    $0x1,%esi
  8022b7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022ba:	72 d4                	jb     802290 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8022bc:	89 f0                	mov    %esi,%eax
}
  8022be:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8022c1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8022c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8022c7:	89 ec                	mov    %ebp,%esp
  8022c9:	5d                   	pop    %ebp
  8022ca:	c3                   	ret    

008022cb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	89 04 24             	mov    %eax,(%esp)
  8022de:	e8 f5 ee ff ff       	call   8011d8 <fd_lookup>
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	78 15                	js     8022fc <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	89 04 24             	mov    %eax,(%esp)
  8022ed:	e8 72 ee ff ff       	call   801164 <fd2data>
	return _pipeisclosed(fd, p);
  8022f2:	89 c2                	mov    %eax,%edx
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	e8 72 fe ff ff       	call   80216e <_pipeisclosed>
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 48             	sub    $0x48,%esp
  802304:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802307:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80230a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80230d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802310:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802313:	89 04 24             	mov    %eax,(%esp)
  802316:	e8 64 ee ff ff       	call   80117f <fd_alloc>
  80231b:	89 c3                	mov    %eax,%ebx
  80231d:	85 c0                	test   %eax,%eax
  80231f:	0f 88 42 01 00 00    	js     802467 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802325:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80232c:	00 
  80232d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802330:	89 44 24 04          	mov    %eax,0x4(%esp)
  802334:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80233b:	e8 ee ec ff ff       	call   80102e <sys_page_alloc>
  802340:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802342:	85 c0                	test   %eax,%eax
  802344:	0f 88 1d 01 00 00    	js     802467 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80234a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80234d:	89 04 24             	mov    %eax,(%esp)
  802350:	e8 2a ee ff ff       	call   80117f <fd_alloc>
  802355:	89 c3                	mov    %eax,%ebx
  802357:	85 c0                	test   %eax,%eax
  802359:	0f 88 f5 00 00 00    	js     802454 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80235f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802366:	00 
  802367:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802375:	e8 b4 ec ff ff       	call   80102e <sys_page_alloc>
  80237a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80237c:	85 c0                	test   %eax,%eax
  80237e:	0f 88 d0 00 00 00    	js     802454 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802384:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802387:	89 04 24             	mov    %eax,(%esp)
  80238a:	e8 d5 ed ff ff       	call   801164 <fd2data>
  80238f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802391:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802398:	00 
  802399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023a4:	e8 85 ec ff ff       	call   80102e <sys_page_alloc>
  8023a9:	89 c3                	mov    %eax,%ebx
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	0f 88 8e 00 00 00    	js     802441 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b6:	89 04 24             	mov    %eax,(%esp)
  8023b9:	e8 a6 ed ff ff       	call   801164 <fd2data>
  8023be:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8023c5:	00 
  8023c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023d1:	00 
  8023d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023dd:	e8 ee eb ff ff       	call   800fd0 <sys_page_map>
  8023e2:	89 c3                	mov    %eax,%ebx
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	78 49                	js     802431 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8023e8:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8023ed:	8b 08                	mov    (%eax),%ecx
  8023ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023f2:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023f7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8023fe:	8b 10                	mov    (%eax),%edx
  802400:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802403:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802408:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80240f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802412:	89 04 24             	mov    %eax,(%esp)
  802415:	e8 3a ed ff ff       	call   801154 <fd2num>
  80241a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80241c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241f:	89 04 24             	mov    %eax,(%esp)
  802422:	e8 2d ed ff ff       	call   801154 <fd2num>
  802427:	89 47 04             	mov    %eax,0x4(%edi)
  80242a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80242f:	eb 36                	jmp    802467 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802431:	89 74 24 04          	mov    %esi,0x4(%esp)
  802435:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80243c:	e8 31 eb ff ff       	call   800f72 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802441:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802444:	89 44 24 04          	mov    %eax,0x4(%esp)
  802448:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80244f:	e8 1e eb ff ff       	call   800f72 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802462:	e8 0b eb ff ff       	call   800f72 <sys_page_unmap>
    err:
	return r;
}
  802467:	89 d8                	mov    %ebx,%eax
  802469:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80246c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80246f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802472:	89 ec                	mov    %ebp,%esp
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    
	...

00802480 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
  802488:	5d                   	pop    %ebp
  802489:	c3                   	ret    

0080248a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802490:	c7 44 24 04 0a 2f 80 	movl   $0x802f0a,0x4(%esp)
  802497:	00 
  802498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249b:	89 04 24             	mov    %eax,(%esp)
  80249e:	e8 46 e4 ff ff       	call   8008e9 <strcpy>
	return 0;
}
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	57                   	push   %edi
  8024ae:	56                   	push   %esi
  8024af:	53                   	push   %ebx
  8024b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8024b6:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024c1:	eb 34                	jmp    8024f7 <devcons_write+0x4d>
		m = n - tot;
  8024c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024c6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8024c8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8024ce:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8024d3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024d6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024da:	03 45 0c             	add    0xc(%ebp),%eax
  8024dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e1:	89 3c 24             	mov    %edi,(%esp)
  8024e4:	e8 a6 e5 ff ff       	call   800a8f <memmove>
		sys_cputs(buf, m);
  8024e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024ed:	89 3c 24             	mov    %edi,(%esp)
  8024f0:	e8 ab e7 ff ff       	call   800ca0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024f5:	01 de                	add    %ebx,%esi
  8024f7:	89 f0                	mov    %esi,%eax
  8024f9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024fc:	72 c5                	jb     8024c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8024fe:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802504:	5b                   	pop    %ebx
  802505:	5e                   	pop    %esi
  802506:	5f                   	pop    %edi
  802507:	5d                   	pop    %ebp
  802508:	c3                   	ret    

00802509 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802515:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80251c:	00 
  80251d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802520:	89 04 24             	mov    %eax,(%esp)
  802523:	e8 78 e7 ff ff       	call   800ca0 <sys_cputs>
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802530:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802534:	75 07                	jne    80253d <devcons_read+0x13>
  802536:	eb 28                	jmp    802560 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802538:	e8 50 eb ff ff       	call   80108d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80253d:	8d 76 00             	lea    0x0(%esi),%esi
  802540:	e8 27 e7 ff ff       	call   800c6c <sys_cgetc>
  802545:	85 c0                	test   %eax,%eax
  802547:	74 ef                	je     802538 <devcons_read+0xe>
  802549:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80254b:	85 c0                	test   %eax,%eax
  80254d:	78 16                	js     802565 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80254f:	83 f8 04             	cmp    $0x4,%eax
  802552:	74 0c                	je     802560 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802554:	8b 45 0c             	mov    0xc(%ebp),%eax
  802557:	88 10                	mov    %dl,(%eax)
  802559:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80255e:	eb 05                	jmp    802565 <devcons_read+0x3b>
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80256d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802570:	89 04 24             	mov    %eax,(%esp)
  802573:	e8 07 ec ff ff       	call   80117f <fd_alloc>
  802578:	85 c0                	test   %eax,%eax
  80257a:	78 3f                	js     8025bb <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80257c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802583:	00 
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802592:	e8 97 ea ff ff       	call   80102e <sys_page_alloc>
  802597:	85 c0                	test   %eax,%eax
  802599:	78 20                	js     8025bb <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80259b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	89 04 24             	mov    %eax,(%esp)
  8025b6:	e8 99 eb ff ff       	call   801154 <fd2num>
}
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	89 04 24             	mov    %eax,(%esp)
  8025d0:	e8 03 ec ff ff       	call   8011d8 <fd_lookup>
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	78 11                	js     8025ea <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 00                	mov    (%eax),%eax
  8025de:	3b 05 58 30 80 00    	cmp    0x803058,%eax
  8025e4:	0f 94 c0             	sete   %al
  8025e7:	0f b6 c0             	movzbl %al,%eax
}
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8025f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8025f9:	00 
  8025fa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802601:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802608:	e8 22 ee ff ff       	call   80142f <read>
	if (r < 0)
  80260d:	85 c0                	test   %eax,%eax
  80260f:	78 0f                	js     802620 <getchar+0x34>
		return r;
	if (r < 1)
  802611:	85 c0                	test   %eax,%eax
  802613:	7f 07                	jg     80261c <getchar+0x30>
  802615:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80261a:	eb 04                	jmp    802620 <getchar+0x34>
		return -E_EOF;
	return c;
  80261c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802620:	c9                   	leave  
  802621:	c3                   	ret    
	...

00802624 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80262f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802632:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802638:	8b 12                	mov    (%edx),%edx
  80263a:	39 ca                	cmp    %ecx,%edx
  80263c:	75 0c                	jne    80264a <ipc_find_env+0x26>
			return envs[i].env_id;
  80263e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802641:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	eb 0e                	jmp    802658 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80264a:	83 c0 01             	add    $0x1,%eax
  80264d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802652:	75 db                	jne    80262f <ipc_find_env+0xb>
  802654:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    

0080265a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	57                   	push   %edi
  80265e:	56                   	push   %esi
  80265f:	53                   	push   %ebx
  802660:	83 ec 2c             	sub    $0x2c,%esp
  802663:	8b 75 08             	mov    0x8(%ebp),%esi
  802666:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802669:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  80266c:	85 db                	test   %ebx,%ebx
  80266e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802673:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802676:	8b 45 14             	mov    0x14(%ebp),%eax
  802679:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80267d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802681:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802685:	89 34 24             	mov    %esi,(%esp)
  802688:	e8 93 e7 ff ff       	call   800e20 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  80268d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802690:	74 e4                	je     802676 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802692:	85 c0                	test   %eax,%eax
  802694:	74 28                	je     8026be <ipc_send+0x64>
  802696:	89 44 24 10          	mov    %eax,0x10(%esp)
  80269a:	c7 44 24 0c 33 2f 80 	movl   $0x802f33,0xc(%esp)
  8026a1:	00 
  8026a2:	c7 44 24 08 16 2f 80 	movl   $0x802f16,0x8(%esp)
  8026a9:	00 
  8026aa:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8026b1:	00 
  8026b2:	c7 04 24 29 2f 80 00 	movl   $0x802f29,(%esp)
  8026b9:	e8 12 db ff ff       	call   8001d0 <_panic>
	//if(!ret) sys_yield();
}
  8026be:	83 c4 2c             	add    $0x2c,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    

008026c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	83 ec 28             	sub    $0x28,%esp
  8026cc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8026cf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8026d2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8026d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8026d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026db:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8026e5:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8026e8:	89 04 24             	mov    %eax,(%esp)
  8026eb:	e8 d3 e6 ff ff       	call   800dc3 <sys_ipc_recv>
  8026f0:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  8026f2:	e8 ca e9 ff ff       	call   8010c1 <sys_getenvid>
  8026f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8026fc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802704:	a3 20 60 80 00       	mov    %eax,0x806020
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802709:	85 f6                	test   %esi,%esi
  80270b:	74 0e                	je     80271b <ipc_recv+0x55>
  80270d:	ba 00 00 00 00       	mov    $0x0,%edx
  802712:	85 db                	test   %ebx,%ebx
  802714:	75 03                	jne    802719 <ipc_recv+0x53>
  802716:	8b 50 74             	mov    0x74(%eax),%edx
  802719:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  80271b:	85 ff                	test   %edi,%edi
  80271d:	74 13                	je     802732 <ipc_recv+0x6c>
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
  802724:	85 db                	test   %ebx,%ebx
  802726:	75 08                	jne    802730 <ipc_recv+0x6a>
  802728:	a1 20 60 80 00       	mov    0x806020,%eax
  80272d:	8b 40 78             	mov    0x78(%eax),%eax
  802730:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802732:	85 db                	test   %ebx,%ebx
  802734:	75 08                	jne    80273e <ipc_recv+0x78>
  802736:	a1 20 60 80 00       	mov    0x806020,%eax
  80273b:	8b 58 70             	mov    0x70(%eax),%ebx
}
  80273e:	89 d8                	mov    %ebx,%eax
  802740:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802743:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802746:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802749:	89 ec                	mov    %ebp,%esp
  80274b:	5d                   	pop    %ebp
  80274c:	c3                   	ret    
  80274d:	00 00                	add    %al,(%eax)
	...

00802750 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	89 c2                	mov    %eax,%edx
  802758:	c1 ea 16             	shr    $0x16,%edx
  80275b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802762:	f6 c2 01             	test   $0x1,%dl
  802765:	74 20                	je     802787 <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802767:	c1 e8 0c             	shr    $0xc,%eax
  80276a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802771:	a8 01                	test   $0x1,%al
  802773:	74 12                	je     802787 <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802775:	c1 e8 0c             	shr    $0xc,%eax
  802778:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  80277d:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802782:	0f b7 c0             	movzwl %ax,%eax
  802785:	eb 05                	jmp    80278c <pageref+0x3c>
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80278c:	5d                   	pop    %ebp
  80278d:	c3                   	ret    
	...

00802790 <__udivdi3>:
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	57                   	push   %edi
  802794:	56                   	push   %esi
  802795:	83 ec 10             	sub    $0x10,%esp
  802798:	8b 45 14             	mov    0x14(%ebp),%eax
  80279b:	8b 55 08             	mov    0x8(%ebp),%edx
  80279e:	8b 75 10             	mov    0x10(%ebp),%esi
  8027a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8027a9:	75 35                	jne    8027e0 <__udivdi3+0x50>
  8027ab:	39 fe                	cmp    %edi,%esi
  8027ad:	77 61                	ja     802810 <__udivdi3+0x80>
  8027af:	85 f6                	test   %esi,%esi
  8027b1:	75 0b                	jne    8027be <__udivdi3+0x2e>
  8027b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b8:	31 d2                	xor    %edx,%edx
  8027ba:	f7 f6                	div    %esi
  8027bc:	89 c6                	mov    %eax,%esi
  8027be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027c1:	31 d2                	xor    %edx,%edx
  8027c3:	89 f8                	mov    %edi,%eax
  8027c5:	f7 f6                	div    %esi
  8027c7:	89 c7                	mov    %eax,%edi
  8027c9:	89 c8                	mov    %ecx,%eax
  8027cb:	f7 f6                	div    %esi
  8027cd:	89 c1                	mov    %eax,%ecx
  8027cf:	89 fa                	mov    %edi,%edx
  8027d1:	89 c8                	mov    %ecx,%eax
  8027d3:	83 c4 10             	add    $0x10,%esp
  8027d6:	5e                   	pop    %esi
  8027d7:	5f                   	pop    %edi
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    
  8027da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027e0:	39 f8                	cmp    %edi,%eax
  8027e2:	77 1c                	ja     802800 <__udivdi3+0x70>
  8027e4:	0f bd d0             	bsr    %eax,%edx
  8027e7:	83 f2 1f             	xor    $0x1f,%edx
  8027ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8027ed:	75 39                	jne    802828 <__udivdi3+0x98>
  8027ef:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8027f2:	0f 86 a0 00 00 00    	jbe    802898 <__udivdi3+0x108>
  8027f8:	39 f8                	cmp    %edi,%eax
  8027fa:	0f 82 98 00 00 00    	jb     802898 <__udivdi3+0x108>
  802800:	31 ff                	xor    %edi,%edi
  802802:	31 c9                	xor    %ecx,%ecx
  802804:	89 c8                	mov    %ecx,%eax
  802806:	89 fa                	mov    %edi,%edx
  802808:	83 c4 10             	add    $0x10,%esp
  80280b:	5e                   	pop    %esi
  80280c:	5f                   	pop    %edi
  80280d:	5d                   	pop    %ebp
  80280e:	c3                   	ret    
  80280f:	90                   	nop
  802810:	89 d1                	mov    %edx,%ecx
  802812:	89 fa                	mov    %edi,%edx
  802814:	89 c8                	mov    %ecx,%eax
  802816:	31 ff                	xor    %edi,%edi
  802818:	f7 f6                	div    %esi
  80281a:	89 c1                	mov    %eax,%ecx
  80281c:	89 fa                	mov    %edi,%edx
  80281e:	89 c8                	mov    %ecx,%eax
  802820:	83 c4 10             	add    $0x10,%esp
  802823:	5e                   	pop    %esi
  802824:	5f                   	pop    %edi
  802825:	5d                   	pop    %ebp
  802826:	c3                   	ret    
  802827:	90                   	nop
  802828:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80282c:	89 f2                	mov    %esi,%edx
  80282e:	d3 e0                	shl    %cl,%eax
  802830:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802833:	b8 20 00 00 00       	mov    $0x20,%eax
  802838:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80283b:	89 c1                	mov    %eax,%ecx
  80283d:	d3 ea                	shr    %cl,%edx
  80283f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802843:	0b 55 ec             	or     -0x14(%ebp),%edx
  802846:	d3 e6                	shl    %cl,%esi
  802848:	89 c1                	mov    %eax,%ecx
  80284a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80284d:	89 fe                	mov    %edi,%esi
  80284f:	d3 ee                	shr    %cl,%esi
  802851:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802855:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802858:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285b:	d3 e7                	shl    %cl,%edi
  80285d:	89 c1                	mov    %eax,%ecx
  80285f:	d3 ea                	shr    %cl,%edx
  802861:	09 d7                	or     %edx,%edi
  802863:	89 f2                	mov    %esi,%edx
  802865:	89 f8                	mov    %edi,%eax
  802867:	f7 75 ec             	divl   -0x14(%ebp)
  80286a:	89 d6                	mov    %edx,%esi
  80286c:	89 c7                	mov    %eax,%edi
  80286e:	f7 65 e8             	mull   -0x18(%ebp)
  802871:	39 d6                	cmp    %edx,%esi
  802873:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802876:	72 30                	jb     8028a8 <__udivdi3+0x118>
  802878:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80287b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80287f:	d3 e2                	shl    %cl,%edx
  802881:	39 c2                	cmp    %eax,%edx
  802883:	73 05                	jae    80288a <__udivdi3+0xfa>
  802885:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802888:	74 1e                	je     8028a8 <__udivdi3+0x118>
  80288a:	89 f9                	mov    %edi,%ecx
  80288c:	31 ff                	xor    %edi,%edi
  80288e:	e9 71 ff ff ff       	jmp    802804 <__udivdi3+0x74>
  802893:	90                   	nop
  802894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802898:	31 ff                	xor    %edi,%edi
  80289a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80289f:	e9 60 ff ff ff       	jmp    802804 <__udivdi3+0x74>
  8028a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028a8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8028ab:	31 ff                	xor    %edi,%edi
  8028ad:	89 c8                	mov    %ecx,%eax
  8028af:	89 fa                	mov    %edi,%edx
  8028b1:	83 c4 10             	add    $0x10,%esp
  8028b4:	5e                   	pop    %esi
  8028b5:	5f                   	pop    %edi
  8028b6:	5d                   	pop    %ebp
  8028b7:	c3                   	ret    
	...

008028c0 <__umoddi3>:
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
  8028c3:	57                   	push   %edi
  8028c4:	56                   	push   %esi
  8028c5:	83 ec 20             	sub    $0x20,%esp
  8028c8:	8b 55 14             	mov    0x14(%ebp),%edx
  8028cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028ce:	8b 7d 10             	mov    0x10(%ebp),%edi
  8028d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028d4:	85 d2                	test   %edx,%edx
  8028d6:	89 c8                	mov    %ecx,%eax
  8028d8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8028db:	75 13                	jne    8028f0 <__umoddi3+0x30>
  8028dd:	39 f7                	cmp    %esi,%edi
  8028df:	76 3f                	jbe    802920 <__umoddi3+0x60>
  8028e1:	89 f2                	mov    %esi,%edx
  8028e3:	f7 f7                	div    %edi
  8028e5:	89 d0                	mov    %edx,%eax
  8028e7:	31 d2                	xor    %edx,%edx
  8028e9:	83 c4 20             	add    $0x20,%esp
  8028ec:	5e                   	pop    %esi
  8028ed:	5f                   	pop    %edi
  8028ee:	5d                   	pop    %ebp
  8028ef:	c3                   	ret    
  8028f0:	39 f2                	cmp    %esi,%edx
  8028f2:	77 4c                	ja     802940 <__umoddi3+0x80>
  8028f4:	0f bd ca             	bsr    %edx,%ecx
  8028f7:	83 f1 1f             	xor    $0x1f,%ecx
  8028fa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8028fd:	75 51                	jne    802950 <__umoddi3+0x90>
  8028ff:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802902:	0f 87 e0 00 00 00    	ja     8029e8 <__umoddi3+0x128>
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	29 f8                	sub    %edi,%eax
  80290d:	19 d6                	sbb    %edx,%esi
  80290f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	89 f2                	mov    %esi,%edx
  802917:	83 c4 20             	add    $0x20,%esp
  80291a:	5e                   	pop    %esi
  80291b:	5f                   	pop    %edi
  80291c:	5d                   	pop    %ebp
  80291d:	c3                   	ret    
  80291e:	66 90                	xchg   %ax,%ax
  802920:	85 ff                	test   %edi,%edi
  802922:	75 0b                	jne    80292f <__umoddi3+0x6f>
  802924:	b8 01 00 00 00       	mov    $0x1,%eax
  802929:	31 d2                	xor    %edx,%edx
  80292b:	f7 f7                	div    %edi
  80292d:	89 c7                	mov    %eax,%edi
  80292f:	89 f0                	mov    %esi,%eax
  802931:	31 d2                	xor    %edx,%edx
  802933:	f7 f7                	div    %edi
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	f7 f7                	div    %edi
  80293a:	eb a9                	jmp    8028e5 <__umoddi3+0x25>
  80293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802940:	89 c8                	mov    %ecx,%eax
  802942:	89 f2                	mov    %esi,%edx
  802944:	83 c4 20             	add    $0x20,%esp
  802947:	5e                   	pop    %esi
  802948:	5f                   	pop    %edi
  802949:	5d                   	pop    %ebp
  80294a:	c3                   	ret    
  80294b:	90                   	nop
  80294c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802950:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802954:	d3 e2                	shl    %cl,%edx
  802956:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802959:	ba 20 00 00 00       	mov    $0x20,%edx
  80295e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802961:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802964:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802968:	89 fa                	mov    %edi,%edx
  80296a:	d3 ea                	shr    %cl,%edx
  80296c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802970:	0b 55 f4             	or     -0xc(%ebp),%edx
  802973:	d3 e7                	shl    %cl,%edi
  802975:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802979:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80297c:	89 f2                	mov    %esi,%edx
  80297e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802981:	89 c7                	mov    %eax,%edi
  802983:	d3 ea                	shr    %cl,%edx
  802985:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802989:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80298c:	89 c2                	mov    %eax,%edx
  80298e:	d3 e6                	shl    %cl,%esi
  802990:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802994:	d3 ea                	shr    %cl,%edx
  802996:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80299a:	09 d6                	or     %edx,%esi
  80299c:	89 f0                	mov    %esi,%eax
  80299e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8029a1:	d3 e7                	shl    %cl,%edi
  8029a3:	89 f2                	mov    %esi,%edx
  8029a5:	f7 75 f4             	divl   -0xc(%ebp)
  8029a8:	89 d6                	mov    %edx,%esi
  8029aa:	f7 65 e8             	mull   -0x18(%ebp)
  8029ad:	39 d6                	cmp    %edx,%esi
  8029af:	72 2b                	jb     8029dc <__umoddi3+0x11c>
  8029b1:	39 c7                	cmp    %eax,%edi
  8029b3:	72 23                	jb     8029d8 <__umoddi3+0x118>
  8029b5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029b9:	29 c7                	sub    %eax,%edi
  8029bb:	19 d6                	sbb    %edx,%esi
  8029bd:	89 f0                	mov    %esi,%eax
  8029bf:	89 f2                	mov    %esi,%edx
  8029c1:	d3 ef                	shr    %cl,%edi
  8029c3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029c7:	d3 e0                	shl    %cl,%eax
  8029c9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029cd:	09 f8                	or     %edi,%eax
  8029cf:	d3 ea                	shr    %cl,%edx
  8029d1:	83 c4 20             	add    $0x20,%esp
  8029d4:	5e                   	pop    %esi
  8029d5:	5f                   	pop    %edi
  8029d6:	5d                   	pop    %ebp
  8029d7:	c3                   	ret    
  8029d8:	39 d6                	cmp    %edx,%esi
  8029da:	75 d9                	jne    8029b5 <__umoddi3+0xf5>
  8029dc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8029df:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8029e2:	eb d1                	jmp    8029b5 <__umoddi3+0xf5>
  8029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	39 f2                	cmp    %esi,%edx
  8029ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029f0:	0f 82 12 ff ff ff    	jb     802908 <__umoddi3+0x48>
  8029f6:	e9 17 ff ff ff       	jmp    802912 <__umoddi3+0x52>
