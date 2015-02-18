
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 2b 01 00 00       	call   80015c <libmain>
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
  800039:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003f:	c7 05 00 40 80 00 80 	movl   $0x802f80,0x804000
  800046:	2f 80 00 

	cprintf("icode startup\n");
  800049:	c7 04 24 86 2f 80 00 	movl   $0x802f86,(%esp)
  800050:	e8 24 02 00 00       	call   800279 <cprintf>

	cprintf("icode: open /motd\n");
  800055:	c7 04 24 95 2f 80 00 	movl   $0x802f95,(%esp)
  80005c:	e8 18 02 00 00       	call   800279 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800061:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800068:	00 
  800069:	c7 04 24 a8 2f 80 00 	movl   $0x802fa8,(%esp)
  800070:	e8 86 19 00 00       	call   8019fb <open>
  800075:	89 c6                	mov    %eax,%esi
  800077:	85 c0                	test   %eax,%eax
  800079:	79 20                	jns    80009b <umain+0x67>
		panic("icode: open /motd: %e", fd);
  80007b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007f:	c7 44 24 08 ae 2f 80 	movl   $0x802fae,0x8(%esp)
  800086:	00 
  800087:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008e:	00 
  80008f:	c7 04 24 c4 2f 80 00 	movl   $0x802fc4,(%esp)
  800096:	e8 25 01 00 00       	call   8001c0 <_panic>

	cprintf("icode: read /motd\n");
  80009b:	c7 04 24 d1 2f 80 00 	movl   $0x802fd1,(%esp)
  8000a2:	e8 d2 01 00 00       	call   800279 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a7:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ad:	eb 0c                	jmp    8000bb <umain+0x87>
		sys_cputs(buf, n);
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	89 1c 24             	mov    %ebx,(%esp)
  8000b6:	e8 d5 0b 00 00       	call   800c90 <sys_cputs>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000bb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c2:	00 
  8000c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c7:	89 34 24             	mov    %esi,(%esp)
  8000ca:	e8 50 13 00 00       	call   80141f <read>
  8000cf:	85 c0                	test   %eax,%eax
  8000d1:	7f dc                	jg     8000af <umain+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d3:	c7 04 24 e4 2f 80 00 	movl   $0x802fe4,(%esp)
  8000da:	e8 9a 01 00 00       	call   800279 <cprintf>
	close(fd);
  8000df:	89 34 24             	mov    %esi,(%esp)
  8000e2:	e8 9f 14 00 00       	call   801586 <close>

	cprintf("icode: spawn /init\n");
  8000e7:	c7 04 24 f8 2f 80 00 	movl   $0x802ff8,(%esp)
  8000ee:	e8 86 01 00 00       	call   800279 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000fa:	00 
  8000fb:	c7 44 24 0c 0c 30 80 	movl   $0x80300c,0xc(%esp)
  800102:	00 
  800103:	c7 44 24 08 15 30 80 	movl   $0x803015,0x8(%esp)
  80010a:	00 
  80010b:	c7 44 24 04 1f 30 80 	movl   $0x80301f,0x4(%esp)
  800112:	00 
  800113:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  80011a:	e8 b2 1f 00 00       	call   8020d1 <spawnl>
  80011f:	85 c0                	test   %eax,%eax
  800121:	79 20                	jns    800143 <umain+0x10f>
		panic("icode: spawn /init: %e", r);
  800123:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800127:	c7 44 24 08 24 30 80 	movl   $0x803024,0x8(%esp)
  80012e:	00 
  80012f:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800136:	00 
  800137:	c7 04 24 c4 2f 80 00 	movl   $0x802fc4,(%esp)
  80013e:	e8 7d 00 00 00       	call   8001c0 <_panic>

	cprintf("icode: exiting\n");
  800143:	c7 04 24 3b 30 80 00 	movl   $0x80303b,(%esp)
  80014a:	e8 2a 01 00 00       	call   800279 <cprintf>
}
  80014f:	81 c4 30 02 00 00    	add    $0x230,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    
  800159:	00 00                	add    %al,(%eax)
	...

0080015c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 18             	sub    $0x18,%esp
  800162:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800165:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800168:	8b 75 08             	mov    0x8(%ebp),%esi
  80016b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80016e:	e8 3e 0f 00 00       	call   8010b1 <sys_getenvid>
  800173:	25 ff 03 00 00       	and    $0x3ff,%eax
  800178:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80017b:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800180:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	85 f6                	test   %esi,%esi
  800187:	7e 07                	jle    800190 <libmain+0x34>
		binaryname = argv[0];
  800189:	8b 03                	mov    (%ebx),%eax
  80018b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800190:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800194:	89 34 24             	mov    %esi,(%esp)
  800197:	e8 98 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80019c:	e8 0b 00 00 00       	call   8001ac <exit>
}
  8001a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001a7:	89 ec                	mov    %ebp,%esp
  8001a9:	5d                   	pop    %ebp
  8001aa:	c3                   	ret    
	...

008001ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8001b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001b9:	e8 27 0f 00 00       	call   8010e5 <sys_env_destroy>
}
  8001be:	c9                   	leave  
  8001bf:	c3                   	ret    

008001c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8001c8:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001cb:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  8001d1:	e8 db 0e 00 00       	call   8010b1 <sys_getenvid>
  8001d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ec:	c7 04 24 58 30 80 00 	movl   $0x803058,(%esp)
  8001f3:	e8 81 00 00 00       	call   800279 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ff:	89 04 24             	mov    %eax,(%esp)
  800202:	e8 11 00 00 00       	call   800218 <vcprintf>
	cprintf("\n");
  800207:	c7 04 24 ed 35 80 00 	movl   $0x8035ed,(%esp)
  80020e:	e8 66 00 00 00       	call   800279 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800213:	cc                   	int3   
  800214:	eb fd                	jmp    800213 <_panic+0x53>
	...

00800218 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800221:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800228:	00 00 00 
	b.cnt = 0;
  80022b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800232:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800235:	8b 45 0c             	mov    0xc(%ebp),%eax
  800238:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80023c:	8b 45 08             	mov    0x8(%ebp),%eax
  80023f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800243:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800249:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024d:	c7 04 24 93 02 80 00 	movl   $0x800293,(%esp)
  800254:	e8 be 01 00 00       	call   800417 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800259:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80025f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800263:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800269:	89 04 24             	mov    %eax,(%esp)
  80026c:	e8 1f 0a 00 00       	call   800c90 <sys_cputs>

	return b.cnt;
}
  800271:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80027f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800282:	89 44 24 04          	mov    %eax,0x4(%esp)
  800286:	8b 45 08             	mov    0x8(%ebp),%eax
  800289:	89 04 24             	mov    %eax,(%esp)
  80028c:	e8 87 ff ff ff       	call   800218 <vcprintf>
	va_end(ap);

	return cnt;
}
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	53                   	push   %ebx
  800297:	83 ec 14             	sub    $0x14,%esp
  80029a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80029d:	8b 03                	mov    (%ebx),%eax
  80029f:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a2:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002a6:	83 c0 01             	add    $0x1,%eax
  8002a9:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b0:	75 19                	jne    8002cb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002b2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002b9:	00 
  8002ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8002bd:	89 04 24             	mov    %eax,(%esp)
  8002c0:	e8 cb 09 00 00       	call   800c90 <sys_cputs>
		b->idx = 0;
  8002c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002cb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cf:	83 c4 14             	add    $0x14,%esp
  8002d2:	5b                   	pop    %ebx
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    
  8002d5:	00 00                	add    %al,(%eax)
	...

008002d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	57                   	push   %edi
  8002dc:	56                   	push   %esi
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 4c             	sub    $0x4c,%esp
  8002e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e4:	89 d6                	mov    %edx,%esi
  8002e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ef:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002f8:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800303:	39 d1                	cmp    %edx,%ecx
  800305:	72 07                	jb     80030e <printnum+0x36>
  800307:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80030a:	39 d0                	cmp    %edx,%eax
  80030c:	77 69                	ja     800377 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80030e:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800312:	83 eb 01             	sub    $0x1,%ebx
  800315:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800319:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800321:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800325:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800328:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80032b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80032e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800332:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800339:	00 
  80033a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80033d:	89 04 24             	mov    %eax,(%esp)
  800340:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800343:	89 54 24 04          	mov    %edx,0x4(%esp)
  800347:	e8 b4 29 00 00       	call   802d00 <__udivdi3>
  80034c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80034f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800352:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800356:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80035a:	89 04 24             	mov    %eax,(%esp)
  80035d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800361:	89 f2                	mov    %esi,%edx
  800363:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800366:	e8 6d ff ff ff       	call   8002d8 <printnum>
  80036b:	eb 11                	jmp    80037e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80036d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800371:	89 3c 24             	mov    %edi,(%esp)
  800374:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800377:	83 eb 01             	sub    $0x1,%ebx
  80037a:	85 db                	test   %ebx,%ebx
  80037c:	7f ef                	jg     80036d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800382:	8b 74 24 04          	mov    0x4(%esp),%esi
  800386:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800389:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800394:	00 
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	89 14 24             	mov    %edx,(%esp)
  80039b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80039e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003a2:	e8 89 2a 00 00       	call   802e30 <__umoddi3>
  8003a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003ab:	0f be 80 7b 30 80 00 	movsbl 0x80307b(%eax),%eax
  8003b2:	89 04 24             	mov    %eax,(%esp)
  8003b5:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003b8:	83 c4 4c             	add    $0x4c,%esp
  8003bb:	5b                   	pop    %ebx
  8003bc:	5e                   	pop    %esi
  8003bd:	5f                   	pop    %edi
  8003be:	5d                   	pop    %ebp
  8003bf:	c3                   	ret    

008003c0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c3:	83 fa 01             	cmp    $0x1,%edx
  8003c6:	7e 0e                	jle    8003d6 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003c8:	8b 10                	mov    (%eax),%edx
  8003ca:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003cd:	89 08                	mov    %ecx,(%eax)
  8003cf:	8b 02                	mov    (%edx),%eax
  8003d1:	8b 52 04             	mov    0x4(%edx),%edx
  8003d4:	eb 22                	jmp    8003f8 <getuint+0x38>
	else if (lflag)
  8003d6:	85 d2                	test   %edx,%edx
  8003d8:	74 10                	je     8003ea <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003da:	8b 10                	mov    (%eax),%edx
  8003dc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003df:	89 08                	mov    %ecx,(%eax)
  8003e1:	8b 02                	mov    (%edx),%eax
  8003e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e8:	eb 0e                	jmp    8003f8 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003ea:	8b 10                	mov    (%eax),%edx
  8003ec:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ef:	89 08                	mov    %ecx,(%eax)
  8003f1:	8b 02                	mov    (%edx),%eax
  8003f3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f8:	5d                   	pop    %ebp
  8003f9:	c3                   	ret    

008003fa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800400:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800404:	8b 10                	mov    (%eax),%edx
  800406:	3b 50 04             	cmp    0x4(%eax),%edx
  800409:	73 0a                	jae    800415 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80040e:	88 0a                	mov    %cl,(%edx)
  800410:	83 c2 01             	add    $0x1,%edx
  800413:	89 10                	mov    %edx,(%eax)
}
  800415:	5d                   	pop    %ebp
  800416:	c3                   	ret    

00800417 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	57                   	push   %edi
  80041b:	56                   	push   %esi
  80041c:	53                   	push   %ebx
  80041d:	83 ec 4c             	sub    $0x4c,%esp
  800420:	8b 7d 08             	mov    0x8(%ebp),%edi
  800423:	8b 75 0c             	mov    0xc(%ebp),%esi
  800426:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800429:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800430:	eb 11                	jmp    800443 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800432:	85 c0                	test   %eax,%eax
  800434:	0f 84 b6 03 00 00    	je     8007f0 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80043a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80043e:	89 04 24             	mov    %eax,(%esp)
  800441:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800443:	0f b6 03             	movzbl (%ebx),%eax
  800446:	83 c3 01             	add    $0x1,%ebx
  800449:	83 f8 25             	cmp    $0x25,%eax
  80044c:	75 e4                	jne    800432 <vprintfmt+0x1b>
  80044e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800452:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800459:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800460:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800467:	b9 00 00 00 00       	mov    $0x0,%ecx
  80046c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80046f:	eb 06                	jmp    800477 <vprintfmt+0x60>
  800471:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800475:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800477:	0f b6 0b             	movzbl (%ebx),%ecx
  80047a:	0f b6 c1             	movzbl %cl,%eax
  80047d:	8d 53 01             	lea    0x1(%ebx),%edx
  800480:	83 e9 23             	sub    $0x23,%ecx
  800483:	80 f9 55             	cmp    $0x55,%cl
  800486:	0f 87 47 03 00 00    	ja     8007d3 <vprintfmt+0x3bc>
  80048c:	0f b6 c9             	movzbl %cl,%ecx
  80048f:	ff 24 8d c0 31 80 00 	jmp    *0x8031c0(,%ecx,4)
  800496:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80049a:	eb d9                	jmp    800475 <vprintfmt+0x5e>
  80049c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8004a3:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004a8:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004ab:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004af:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8004b2:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004b5:	83 fb 09             	cmp    $0x9,%ebx
  8004b8:	77 30                	ja     8004ea <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ba:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004bd:	eb e9                	jmp    8004a8 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c2:	8d 48 04             	lea    0x4(%eax),%ecx
  8004c5:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8004cd:	eb 1e                	jmp    8004ed <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8004cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d8:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8004dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004df:	eb 94                	jmp    800475 <vprintfmt+0x5e>
  8004e1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8004e8:	eb 8b                	jmp    800475 <vprintfmt+0x5e>
  8004ea:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8004ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004f1:	79 82                	jns    800475 <vprintfmt+0x5e>
  8004f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004f9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004fc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004ff:	e9 71 ff ff ff       	jmp    800475 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800504:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800508:	e9 68 ff ff ff       	jmp    800475 <vprintfmt+0x5e>
  80050d:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8d 50 04             	lea    0x4(%eax),%edx
  800516:	89 55 14             	mov    %edx,0x14(%ebp)
  800519:	89 74 24 04          	mov    %esi,0x4(%esp)
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	ff d7                	call   *%edi
  800524:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800527:	e9 17 ff ff ff       	jmp    800443 <vprintfmt+0x2c>
  80052c:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8d 50 04             	lea    0x4(%eax),%edx
  800535:	89 55 14             	mov    %edx,0x14(%ebp)
  800538:	8b 00                	mov    (%eax),%eax
  80053a:	89 c2                	mov    %eax,%edx
  80053c:	c1 fa 1f             	sar    $0x1f,%edx
  80053f:	31 d0                	xor    %edx,%eax
  800541:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800543:	83 f8 11             	cmp    $0x11,%eax
  800546:	7f 0b                	jg     800553 <vprintfmt+0x13c>
  800548:	8b 14 85 20 33 80 00 	mov    0x803320(,%eax,4),%edx
  80054f:	85 d2                	test   %edx,%edx
  800551:	75 20                	jne    800573 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800553:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800557:	c7 44 24 08 8c 30 80 	movl   $0x80308c,0x8(%esp)
  80055e:	00 
  80055f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800563:	89 3c 24             	mov    %edi,(%esp)
  800566:	e8 0d 03 00 00       	call   800878 <printfmt>
  80056b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80056e:	e9 d0 fe ff ff       	jmp    800443 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800573:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800577:	c7 44 24 08 76 34 80 	movl   $0x803476,0x8(%esp)
  80057e:	00 
  80057f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800583:	89 3c 24             	mov    %edi,(%esp)
  800586:	e8 ed 02 00 00       	call   800878 <printfmt>
  80058b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80058e:	e9 b0 fe ff ff       	jmp    800443 <vprintfmt+0x2c>
  800593:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800596:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80059c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8d 50 04             	lea    0x4(%eax),%edx
  8005a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a8:	8b 18                	mov    (%eax),%ebx
  8005aa:	85 db                	test   %ebx,%ebx
  8005ac:	b8 95 30 80 00       	mov    $0x803095,%eax
  8005b1:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8005b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b8:	7e 76                	jle    800630 <vprintfmt+0x219>
  8005ba:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8005be:	74 7a                	je     80063a <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005c4:	89 1c 24             	mov    %ebx,(%esp)
  8005c7:	e8 ec 02 00 00       	call   8008b8 <strnlen>
  8005cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005cf:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8005d1:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8005d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005d8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005db:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dd:	eb 0f                	jmp    8005ee <vprintfmt+0x1d7>
					putch(padc, putdat);
  8005df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e6:	89 04 24             	mov    %eax,(%esp)
  8005e9:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005eb:	83 eb 01             	sub    $0x1,%ebx
  8005ee:	85 db                	test   %ebx,%ebx
  8005f0:	7f ed                	jg     8005df <vprintfmt+0x1c8>
  8005f2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005f5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005f8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005fb:	89 f7                	mov    %esi,%edi
  8005fd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800600:	eb 40                	jmp    800642 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800602:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800606:	74 18                	je     800620 <vprintfmt+0x209>
  800608:	8d 50 e0             	lea    -0x20(%eax),%edx
  80060b:	83 fa 5e             	cmp    $0x5e,%edx
  80060e:	76 10                	jbe    800620 <vprintfmt+0x209>
					putch('?', putdat);
  800610:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800614:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80061b:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80061e:	eb 0a                	jmp    80062a <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800620:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800624:	89 04 24             	mov    %eax,(%esp)
  800627:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80062e:	eb 12                	jmp    800642 <vprintfmt+0x22b>
  800630:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800633:	89 f7                	mov    %esi,%edi
  800635:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800638:	eb 08                	jmp    800642 <vprintfmt+0x22b>
  80063a:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80063d:	89 f7                	mov    %esi,%edi
  80063f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800642:	0f be 03             	movsbl (%ebx),%eax
  800645:	83 c3 01             	add    $0x1,%ebx
  800648:	85 c0                	test   %eax,%eax
  80064a:	74 25                	je     800671 <vprintfmt+0x25a>
  80064c:	85 f6                	test   %esi,%esi
  80064e:	78 b2                	js     800602 <vprintfmt+0x1eb>
  800650:	83 ee 01             	sub    $0x1,%esi
  800653:	79 ad                	jns    800602 <vprintfmt+0x1eb>
  800655:	89 fe                	mov    %edi,%esi
  800657:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80065a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80065d:	eb 1a                	jmp    800679 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80065f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800663:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80066a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80066c:	83 eb 01             	sub    $0x1,%ebx
  80066f:	eb 08                	jmp    800679 <vprintfmt+0x262>
  800671:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800674:	89 fe                	mov    %edi,%esi
  800676:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800679:	85 db                	test   %ebx,%ebx
  80067b:	7f e2                	jg     80065f <vprintfmt+0x248>
  80067d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800680:	e9 be fd ff ff       	jmp    800443 <vprintfmt+0x2c>
  800685:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800688:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80068b:	83 f9 01             	cmp    $0x1,%ecx
  80068e:	7e 16                	jle    8006a6 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	89 55 14             	mov    %edx,0x14(%ebp)
  800699:	8b 10                	mov    (%eax),%edx
  80069b:	8b 48 04             	mov    0x4(%eax),%ecx
  80069e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8006a1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a4:	eb 32                	jmp    8006d8 <vprintfmt+0x2c1>
	else if (lflag)
  8006a6:	85 c9                	test   %ecx,%ecx
  8006a8:	74 18                	je     8006c2 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8d 50 04             	lea    0x4(%eax),%edx
  8006b0:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b8:	89 c1                	mov    %eax,%ecx
  8006ba:	c1 f9 1f             	sar    $0x1f,%ecx
  8006bd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c0:	eb 16                	jmp    8006d8 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 50 04             	lea    0x4(%eax),%edx
  8006c8:	89 55 14             	mov    %edx,0x14(%ebp)
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d0:	89 c2                	mov    %eax,%edx
  8006d2:	c1 fa 1f             	sar    $0x1f,%edx
  8006d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006d8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006db:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006de:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006e3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006e7:	0f 89 a7 00 00 00    	jns    800794 <vprintfmt+0x37d>
				putch('-', putdat);
  8006ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006f8:	ff d7                	call   *%edi
				num = -(long long) num;
  8006fa:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006fd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800700:	f7 d9                	neg    %ecx
  800702:	83 d3 00             	adc    $0x0,%ebx
  800705:	f7 db                	neg    %ebx
  800707:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070c:	e9 83 00 00 00       	jmp    800794 <vprintfmt+0x37d>
  800711:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800714:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800717:	89 ca                	mov    %ecx,%edx
  800719:	8d 45 14             	lea    0x14(%ebp),%eax
  80071c:	e8 9f fc ff ff       	call   8003c0 <getuint>
  800721:	89 c1                	mov    %eax,%ecx
  800723:	89 d3                	mov    %edx,%ebx
  800725:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80072a:	eb 68                	jmp    800794 <vprintfmt+0x37d>
  80072c:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80072f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800732:	89 ca                	mov    %ecx,%edx
  800734:	8d 45 14             	lea    0x14(%ebp),%eax
  800737:	e8 84 fc ff ff       	call   8003c0 <getuint>
  80073c:	89 c1                	mov    %eax,%ecx
  80073e:	89 d3                	mov    %edx,%ebx
  800740:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800745:	eb 4d                	jmp    800794 <vprintfmt+0x37d>
  800747:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80074a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80074e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800755:	ff d7                	call   *%edi
			putch('x', putdat);
  800757:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800762:	ff d7                	call   *%edi
			num = (unsigned long long)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8d 50 04             	lea    0x4(%eax),%edx
  80076a:	89 55 14             	mov    %edx,0x14(%ebp)
  80076d:	8b 08                	mov    (%eax),%ecx
  80076f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800774:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800779:	eb 19                	jmp    800794 <vprintfmt+0x37d>
  80077b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80077e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800781:	89 ca                	mov    %ecx,%edx
  800783:	8d 45 14             	lea    0x14(%ebp),%eax
  800786:	e8 35 fc ff ff       	call   8003c0 <getuint>
  80078b:	89 c1                	mov    %eax,%ecx
  80078d:	89 d3                	mov    %edx,%ebx
  80078f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800794:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800798:	89 54 24 10          	mov    %edx,0x10(%esp)
  80079c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80079f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007a7:	89 0c 24             	mov    %ecx,(%esp)
  8007aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007ae:	89 f2                	mov    %esi,%edx
  8007b0:	89 f8                	mov    %edi,%eax
  8007b2:	e8 21 fb ff ff       	call   8002d8 <printnum>
  8007b7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007ba:	e9 84 fc ff ff       	jmp    800443 <vprintfmt+0x2c>
  8007bf:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c6:	89 04 24             	mov    %eax,(%esp)
  8007c9:	ff d7                	call   *%edi
  8007cb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007ce:	e9 70 fc ff ff       	jmp    800443 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007de:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8007e3:	80 38 25             	cmpb   $0x25,(%eax)
  8007e6:	0f 84 57 fc ff ff    	je     800443 <vprintfmt+0x2c>
  8007ec:	89 c3                	mov    %eax,%ebx
  8007ee:	eb f0                	jmp    8007e0 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8007f0:	83 c4 4c             	add    $0x4c,%esp
  8007f3:	5b                   	pop    %ebx
  8007f4:	5e                   	pop    %esi
  8007f5:	5f                   	pop    %edi
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 28             	sub    $0x28,%esp
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800804:	85 c0                	test   %eax,%eax
  800806:	74 04                	je     80080c <vsnprintf+0x14>
  800808:	85 d2                	test   %edx,%edx
  80080a:	7f 07                	jg     800813 <vsnprintf+0x1b>
  80080c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800811:	eb 3b                	jmp    80084e <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800813:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800816:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  80081a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80082b:	8b 45 10             	mov    0x10(%ebp),%eax
  80082e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800832:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800835:	89 44 24 04          	mov    %eax,0x4(%esp)
  800839:	c7 04 24 fa 03 80 00 	movl   $0x8003fa,(%esp)
  800840:	e8 d2 fb ff ff       	call   800417 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800848:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80084b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80084e:	c9                   	leave  
  80084f:	c3                   	ret    

00800850 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800856:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800859:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80085d:	8b 45 10             	mov    0x10(%ebp),%eax
  800860:	89 44 24 08          	mov    %eax,0x8(%esp)
  800864:	8b 45 0c             	mov    0xc(%ebp),%eax
  800867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	89 04 24             	mov    %eax,(%esp)
  800871:	e8 82 ff ff ff       	call   8007f8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800876:	c9                   	leave  
  800877:	c3                   	ret    

00800878 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80087e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800881:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800885:	8b 45 10             	mov    0x10(%ebp),%eax
  800888:	89 44 24 08          	mov    %eax,0x8(%esp)
  80088c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	89 04 24             	mov    %eax,(%esp)
  800899:	e8 79 fb ff ff       	call   800417 <vprintfmt>
	va_end(ap);
}
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ab:	eb 03                	jmp    8008b0 <strlen+0x10>
		n++;
  8008ad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b4:	75 f7                	jne    8008ad <strlen+0xd>
		n++;
	return n;
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c7:	eb 03                	jmp    8008cc <strnlen+0x14>
		n++;
  8008c9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cc:	39 c1                	cmp    %eax,%ecx
  8008ce:	74 06                	je     8008d6 <strnlen+0x1e>
  8008d0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8008d4:	75 f3                	jne    8008c9 <strnlen+0x11>
		n++;
	return n;
}
  8008d6:	5b                   	pop    %ebx
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	53                   	push   %ebx
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ef:	83 c2 01             	add    $0x1,%edx
  8008f2:	84 c9                	test   %cl,%cl
  8008f4:	75 f2                	jne    8008e8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008f6:	5b                   	pop    %ebx
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800903:	89 1c 24             	mov    %ebx,(%esp)
  800906:	e8 95 ff ff ff       	call   8008a0 <strlen>
	strcpy(dst + len, src);
  80090b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800912:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800915:	89 04 24             	mov    %eax,(%esp)
  800918:	e8 bc ff ff ff       	call   8008d9 <strcpy>
	return dst;
}
  80091d:	89 d8                	mov    %ebx,%eax
  80091f:	83 c4 08             	add    $0x8,%esp
  800922:	5b                   	pop    %ebx
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	56                   	push   %esi
  800929:	53                   	push   %ebx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800930:	8b 75 10             	mov    0x10(%ebp),%esi
  800933:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800938:	eb 0f                	jmp    800949 <strncpy+0x24>
		*dst++ = *src;
  80093a:	0f b6 19             	movzbl (%ecx),%ebx
  80093d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800940:	80 39 01             	cmpb   $0x1,(%ecx)
  800943:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	39 f2                	cmp    %esi,%edx
  80094b:	72 ed                	jb     80093a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80094d:	5b                   	pop    %ebx
  80094e:	5e                   	pop    %esi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	8b 75 08             	mov    0x8(%ebp),%esi
  800959:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80095f:	89 f0                	mov    %esi,%eax
  800961:	85 d2                	test   %edx,%edx
  800963:	75 0a                	jne    80096f <strlcpy+0x1e>
  800965:	eb 17                	jmp    80097e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800967:	88 18                	mov    %bl,(%eax)
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80096f:	83 ea 01             	sub    $0x1,%edx
  800972:	74 07                	je     80097b <strlcpy+0x2a>
  800974:	0f b6 19             	movzbl (%ecx),%ebx
  800977:	84 db                	test   %bl,%bl
  800979:	75 ec                	jne    800967 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80097b:	c6 00 00             	movb   $0x0,(%eax)
  80097e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800980:	5b                   	pop    %ebx
  800981:	5e                   	pop    %esi
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80098d:	eb 06                	jmp    800995 <strcmp+0x11>
		p++, q++;
  80098f:	83 c1 01             	add    $0x1,%ecx
  800992:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800995:	0f b6 01             	movzbl (%ecx),%eax
  800998:	84 c0                	test   %al,%al
  80099a:	74 04                	je     8009a0 <strcmp+0x1c>
  80099c:	3a 02                	cmp    (%edx),%al
  80099e:	74 ef                	je     80098f <strcmp+0xb>
  8009a0:	0f b6 c0             	movzbl %al,%eax
  8009a3:	0f b6 12             	movzbl (%edx),%edx
  8009a6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	53                   	push   %ebx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8009b7:	eb 09                	jmp    8009c2 <strncmp+0x18>
		n--, p++, q++;
  8009b9:	83 ea 01             	sub    $0x1,%edx
  8009bc:	83 c0 01             	add    $0x1,%eax
  8009bf:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009c2:	85 d2                	test   %edx,%edx
  8009c4:	75 07                	jne    8009cd <strncmp+0x23>
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cb:	eb 13                	jmp    8009e0 <strncmp+0x36>
  8009cd:	0f b6 18             	movzbl (%eax),%ebx
  8009d0:	84 db                	test   %bl,%bl
  8009d2:	74 04                	je     8009d8 <strncmp+0x2e>
  8009d4:	3a 19                	cmp    (%ecx),%bl
  8009d6:	74 e1                	je     8009b9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 00             	movzbl (%eax),%eax
  8009db:	0f b6 11             	movzbl (%ecx),%edx
  8009de:	29 d0                	sub    %edx,%eax
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ed:	eb 07                	jmp    8009f6 <strchr+0x13>
		if (*s == c)
  8009ef:	38 ca                	cmp    %cl,%dl
  8009f1:	74 0f                	je     800a02 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	0f b6 10             	movzbl (%eax),%edx
  8009f9:	84 d2                	test   %dl,%dl
  8009fb:	75 f2                	jne    8009ef <strchr+0xc>
  8009fd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0e:	eb 07                	jmp    800a17 <strfind+0x13>
		if (*s == c)
  800a10:	38 ca                	cmp    %cl,%dl
  800a12:	74 0a                	je     800a1e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a14:	83 c0 01             	add    $0x1,%eax
  800a17:	0f b6 10             	movzbl (%eax),%edx
  800a1a:	84 d2                	test   %dl,%dl
  800a1c:	75 f2                	jne    800a10 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 0c             	sub    $0xc,%esp
  800a26:	89 1c 24             	mov    %ebx,(%esp)
  800a29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a2d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a31:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a3a:	85 c9                	test   %ecx,%ecx
  800a3c:	74 30                	je     800a6e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a44:	75 25                	jne    800a6b <memset+0x4b>
  800a46:	f6 c1 03             	test   $0x3,%cl
  800a49:	75 20                	jne    800a6b <memset+0x4b>
		c &= 0xFF;
  800a4b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4e:	89 d3                	mov    %edx,%ebx
  800a50:	c1 e3 08             	shl    $0x8,%ebx
  800a53:	89 d6                	mov    %edx,%esi
  800a55:	c1 e6 18             	shl    $0x18,%esi
  800a58:	89 d0                	mov    %edx,%eax
  800a5a:	c1 e0 10             	shl    $0x10,%eax
  800a5d:	09 f0                	or     %esi,%eax
  800a5f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a61:	09 d8                	or     %ebx,%eax
  800a63:	c1 e9 02             	shr    $0x2,%ecx
  800a66:	fc                   	cld    
  800a67:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a69:	eb 03                	jmp    800a6e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a6b:	fc                   	cld    
  800a6c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6e:	89 f8                	mov    %edi,%eax
  800a70:	8b 1c 24             	mov    (%esp),%ebx
  800a73:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a77:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a7b:	89 ec                	mov    %ebp,%esp
  800a7d:	5d                   	pop    %ebp
  800a7e:	c3                   	ret    

00800a7f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	89 34 24             	mov    %esi,(%esp)
  800a88:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800a92:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a95:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a97:	39 c6                	cmp    %eax,%esi
  800a99:	73 35                	jae    800ad0 <memmove+0x51>
  800a9b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9e:	39 d0                	cmp    %edx,%eax
  800aa0:	73 2e                	jae    800ad0 <memmove+0x51>
		s += n;
		d += n;
  800aa2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa4:	f6 c2 03             	test   $0x3,%dl
  800aa7:	75 1b                	jne    800ac4 <memmove+0x45>
  800aa9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aaf:	75 13                	jne    800ac4 <memmove+0x45>
  800ab1:	f6 c1 03             	test   $0x3,%cl
  800ab4:	75 0e                	jne    800ac4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ab6:	83 ef 04             	sub    $0x4,%edi
  800ab9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800abc:	c1 e9 02             	shr    $0x2,%ecx
  800abf:	fd                   	std    
  800ac0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac2:	eb 09                	jmp    800acd <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac4:	83 ef 01             	sub    $0x1,%edi
  800ac7:	8d 72 ff             	lea    -0x1(%edx),%esi
  800aca:	fd                   	std    
  800acb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800acd:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ace:	eb 20                	jmp    800af0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad6:	75 15                	jne    800aed <memmove+0x6e>
  800ad8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ade:	75 0d                	jne    800aed <memmove+0x6e>
  800ae0:	f6 c1 03             	test   $0x3,%cl
  800ae3:	75 08                	jne    800aed <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800ae5:	c1 e9 02             	shr    $0x2,%ecx
  800ae8:	fc                   	cld    
  800ae9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aeb:	eb 03                	jmp    800af0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aed:	fc                   	cld    
  800aee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af0:	8b 34 24             	mov    (%esp),%esi
  800af3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800af7:	89 ec                	mov    %ebp,%esp
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b01:	8b 45 10             	mov    0x10(%ebp),%eax
  800b04:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 04 24             	mov    %eax,(%esp)
  800b15:	e8 65 ff ff ff       	call   800a7f <memmove>
}
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	57                   	push   %edi
  800b20:	56                   	push   %esi
  800b21:	53                   	push   %ebx
  800b22:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b2b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b30:	eb 1c                	jmp    800b4e <memcmp+0x32>
		if (*s1 != *s2)
  800b32:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800b36:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800b3a:	83 c2 01             	add    $0x1,%edx
  800b3d:	83 e9 01             	sub    $0x1,%ecx
  800b40:	38 d8                	cmp    %bl,%al
  800b42:	74 0a                	je     800b4e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800b44:	0f b6 c0             	movzbl %al,%eax
  800b47:	0f b6 db             	movzbl %bl,%ebx
  800b4a:	29 d8                	sub    %ebx,%eax
  800b4c:	eb 09                	jmp    800b57 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4e:	85 c9                	test   %ecx,%ecx
  800b50:	75 e0                	jne    800b32 <memcmp+0x16>
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b65:	89 c2                	mov    %eax,%edx
  800b67:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b6a:	eb 07                	jmp    800b73 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b6c:	38 08                	cmp    %cl,(%eax)
  800b6e:	74 07                	je     800b77 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b70:	83 c0 01             	add    $0x1,%eax
  800b73:	39 d0                	cmp    %edx,%eax
  800b75:	72 f5                	jb     800b6c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	57                   	push   %edi
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	8b 55 08             	mov    0x8(%ebp),%edx
  800b85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b88:	eb 03                	jmp    800b8d <strtol+0x14>
		s++;
  800b8a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8d:	0f b6 02             	movzbl (%edx),%eax
  800b90:	3c 20                	cmp    $0x20,%al
  800b92:	74 f6                	je     800b8a <strtol+0x11>
  800b94:	3c 09                	cmp    $0x9,%al
  800b96:	74 f2                	je     800b8a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b98:	3c 2b                	cmp    $0x2b,%al
  800b9a:	75 0c                	jne    800ba8 <strtol+0x2f>
		s++;
  800b9c:	8d 52 01             	lea    0x1(%edx),%edx
  800b9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ba6:	eb 15                	jmp    800bbd <strtol+0x44>
	else if (*s == '-')
  800ba8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800baf:	3c 2d                	cmp    $0x2d,%al
  800bb1:	75 0a                	jne    800bbd <strtol+0x44>
		s++, neg = 1;
  800bb3:	8d 52 01             	lea    0x1(%edx),%edx
  800bb6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbd:	85 db                	test   %ebx,%ebx
  800bbf:	0f 94 c0             	sete   %al
  800bc2:	74 05                	je     800bc9 <strtol+0x50>
  800bc4:	83 fb 10             	cmp    $0x10,%ebx
  800bc7:	75 15                	jne    800bde <strtol+0x65>
  800bc9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bcc:	75 10                	jne    800bde <strtol+0x65>
  800bce:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bd2:	75 0a                	jne    800bde <strtol+0x65>
		s += 2, base = 16;
  800bd4:	83 c2 02             	add    $0x2,%edx
  800bd7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bdc:	eb 13                	jmp    800bf1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bde:	84 c0                	test   %al,%al
  800be0:	74 0f                	je     800bf1 <strtol+0x78>
  800be2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800be7:	80 3a 30             	cmpb   $0x30,(%edx)
  800bea:	75 05                	jne    800bf1 <strtol+0x78>
		s++, base = 8;
  800bec:	83 c2 01             	add    $0x1,%edx
  800bef:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bf8:	0f b6 0a             	movzbl (%edx),%ecx
  800bfb:	89 cf                	mov    %ecx,%edi
  800bfd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c00:	80 fb 09             	cmp    $0x9,%bl
  800c03:	77 08                	ja     800c0d <strtol+0x94>
			dig = *s - '0';
  800c05:	0f be c9             	movsbl %cl,%ecx
  800c08:	83 e9 30             	sub    $0x30,%ecx
  800c0b:	eb 1e                	jmp    800c2b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800c0d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c10:	80 fb 19             	cmp    $0x19,%bl
  800c13:	77 08                	ja     800c1d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800c15:	0f be c9             	movsbl %cl,%ecx
  800c18:	83 e9 57             	sub    $0x57,%ecx
  800c1b:	eb 0e                	jmp    800c2b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800c1d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c20:	80 fb 19             	cmp    $0x19,%bl
  800c23:	77 15                	ja     800c3a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c25:	0f be c9             	movsbl %cl,%ecx
  800c28:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c2b:	39 f1                	cmp    %esi,%ecx
  800c2d:	7d 0b                	jge    800c3a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c2f:	83 c2 01             	add    $0x1,%edx
  800c32:	0f af c6             	imul   %esi,%eax
  800c35:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c38:	eb be                	jmp    800bf8 <strtol+0x7f>
  800c3a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c40:	74 05                	je     800c47 <strtol+0xce>
		*endptr = (char *) s;
  800c42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c45:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c47:	89 ca                	mov    %ecx,%edx
  800c49:	f7 da                	neg    %edx
  800c4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c4f:	0f 45 c2             	cmovne %edx,%eax
}
  800c52:	83 c4 04             	add    $0x4,%esp
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    
	...

00800c5c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	89 1c 24             	mov    %ebx,(%esp)
  800c65:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c69:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c72:	b8 01 00 00 00       	mov    $0x1,%eax
  800c77:	89 d1                	mov    %edx,%ecx
  800c79:	89 d3                	mov    %edx,%ebx
  800c7b:	89 d7                	mov    %edx,%edi
  800c7d:	89 d6                	mov    %edx,%esi
  800c7f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c81:	8b 1c 24             	mov    (%esp),%ebx
  800c84:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c88:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c8c:	89 ec                	mov    %ebp,%esp
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 0c             	sub    $0xc,%esp
  800c96:	89 1c 24             	mov    %ebx,(%esp)
  800c99:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c9d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	89 c3                	mov    %eax,%ebx
  800cae:	89 c7                	mov    %eax,%edi
  800cb0:	89 c6                	mov    %eax,%esi
  800cb2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb4:	8b 1c 24             	mov    (%esp),%ebx
  800cb7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cbb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cbf:	89 ec                	mov    %ebp,%esp
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	89 1c 24             	mov    %ebx,(%esp)
  800ccc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cd0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd9:	b8 10 00 00 00       	mov    $0x10,%eax
  800cde:	89 d1                	mov    %edx,%ecx
  800ce0:	89 d3                	mov    %edx,%ebx
  800ce2:	89 d7                	mov    %edx,%edi
  800ce4:	89 d6                	mov    %edx,%esi
  800ce6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ce8:	8b 1c 24             	mov    (%esp),%ebx
  800ceb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cef:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cf3:	89 ec                	mov    %ebp,%esp
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 38             	sub    $0x38,%esp
  800cfd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d00:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d03:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	89 df                	mov    %ebx,%edi
  800d18:	89 de                	mov    %ebx,%esi
  800d1a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	7e 28                	jle    800d48 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d24:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d2b:	00 
  800d2c:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  800d33:	00 
  800d34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d3b:	00 
  800d3c:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  800d43:	e8 78 f4 ff ff       	call   8001c0 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800d48:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d51:	89 ec                	mov    %ebp,%esp
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 38             	sub    $0x38,%esp
  800d5b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d5e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d61:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d69:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	89 df                	mov    %ebx,%edi
  800d76:	89 de                	mov    %ebx,%esi
  800d78:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7e 28                	jle    800da6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d82:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800d89:	00 
  800d8a:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  800d91:	00 
  800d92:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d99:	00 
  800d9a:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  800da1:	e8 1a f4 ff ff       	call   8001c0 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800da6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800da9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800daf:	89 ec                	mov    %ebp,%esp
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 38             	sub    $0x38,%esp
  800db9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dbf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	89 cb                	mov    %ecx,%ebx
  800dd1:	89 cf                	mov    %ecx,%edi
  800dd3:	89 ce                	mov    %ecx,%esi
  800dd5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	7e 28                	jle    800e03 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ddf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800de6:	00 
  800de7:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  800dee:	00 
  800def:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df6:	00 
  800df7:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  800dfe:	e8 bd f3 ff ff       	call   8001c0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e03:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e06:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e09:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e0c:	89 ec                	mov    %ebp,%esp
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	89 1c 24             	mov    %ebx,(%esp)
  800e19:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e1d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e21:	be 00 00 00 00       	mov    $0x0,%esi
  800e26:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e2b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e39:	8b 1c 24             	mov    (%esp),%ebx
  800e3c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e40:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e44:	89 ec                	mov    %ebp,%esp
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 38             	sub    $0x38,%esp
  800e4e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e51:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e54:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	89 df                	mov    %ebx,%edi
  800e69:	89 de                	mov    %ebx,%esi
  800e6b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	7e 28                	jle    800e99 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e75:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e7c:	00 
  800e7d:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  800e84:	00 
  800e85:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8c:	00 
  800e8d:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  800e94:	e8 27 f3 ff ff       	call   8001c0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e99:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e9c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e9f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea2:	89 ec                	mov    %ebp,%esp
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	83 ec 38             	sub    $0x38,%esp
  800eac:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eaf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eba:	b8 09 00 00 00       	mov    $0x9,%eax
  800ebf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	89 df                	mov    %ebx,%edi
  800ec7:	89 de                	mov    %ebx,%esi
  800ec9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	7e 28                	jle    800ef7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eda:	00 
  800edb:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  800ee2:	00 
  800ee3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eea:	00 
  800eeb:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  800ef2:	e8 c9 f2 ff ff       	call   8001c0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ef7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800efa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800efd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f00:	89 ec                	mov    %ebp,%esp
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 38             	sub    $0x38,%esp
  800f0a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f10:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f18:	b8 08 00 00 00       	mov    $0x8,%eax
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	89 df                	mov    %ebx,%edi
  800f25:	89 de                	mov    %ebx,%esi
  800f27:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7e 28                	jle    800f55 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  800f50:	e8 6b f2 ff ff       	call   8001c0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f55:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f58:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5e:	89 ec                	mov    %ebp,%esp
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 38             	sub    $0x38,%esp
  800f68:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f76:	b8 06 00 00 00       	mov    $0x6,%eax
  800f7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	89 df                	mov    %ebx,%edi
  800f83:	89 de                	mov    %ebx,%esi
  800f85:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f87:	85 c0                	test   %eax,%eax
  800f89:	7e 28                	jle    800fb3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f96:	00 
  800f97:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  800f9e:	00 
  800f9f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa6:	00 
  800fa7:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  800fae:	e8 0d f2 ff ff       	call   8001c0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fbc:	89 ec                	mov    %ebp,%esp
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 38             	sub    $0x38,%esp
  800fc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fcc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcf:	b8 05 00 00 00       	mov    $0x5,%eax
  800fd4:	8b 75 18             	mov    0x18(%ebp),%esi
  800fd7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	7e 28                	jle    801011 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fed:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ff4:	00 
  800ff5:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  800ffc:	00 
  800ffd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801004:	00 
  801005:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  80100c:	e8 af f1 ff ff       	call   8001c0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801011:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801014:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801017:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101a:	89 ec                	mov    %ebp,%esp
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 38             	sub    $0x38,%esp
  801024:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801027:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102d:	be 00 00 00 00       	mov    $0x0,%esi
  801032:	b8 04 00 00 00       	mov    $0x4,%eax
  801037:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	89 f7                	mov    %esi,%edi
  801042:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801044:	85 c0                	test   %eax,%eax
  801046:	7e 28                	jle    801070 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801048:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801053:	00 
  801054:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  80105b:	00 
  80105c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801063:	00 
  801064:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  80106b:	e8 50 f1 ff ff       	call   8001c0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801070:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801073:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801076:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801079:	89 ec                	mov    %ebp,%esp
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 0c             	sub    $0xc,%esp
  801083:	89 1c 24             	mov    %ebx,(%esp)
  801086:	89 74 24 04          	mov    %esi,0x4(%esp)
  80108a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108e:	ba 00 00 00 00       	mov    $0x0,%edx
  801093:	b8 0b 00 00 00       	mov    $0xb,%eax
  801098:	89 d1                	mov    %edx,%ecx
  80109a:	89 d3                	mov    %edx,%ebx
  80109c:	89 d7                	mov    %edx,%edi
  80109e:	89 d6                	mov    %edx,%esi
  8010a0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010a2:	8b 1c 24             	mov    (%esp),%ebx
  8010a5:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010a9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ad:	89 ec                	mov    %ebp,%esp
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    

008010b1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 0c             	sub    $0xc,%esp
  8010b7:	89 1c 24             	mov    %ebx,(%esp)
  8010ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010be:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8010cc:	89 d1                	mov    %edx,%ecx
  8010ce:	89 d3                	mov    %edx,%ebx
  8010d0:	89 d7                	mov    %edx,%edi
  8010d2:	89 d6                	mov    %edx,%esi
  8010d4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010d6:	8b 1c 24             	mov    (%esp),%ebx
  8010d9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010dd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010e1:	89 ec                	mov    %ebp,%esp
  8010e3:	5d                   	pop    %ebp
  8010e4:	c3                   	ret    

008010e5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	83 ec 38             	sub    $0x38,%esp
  8010eb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010f1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f9:	b8 03 00 00 00       	mov    $0x3,%eax
  8010fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801101:	89 cb                	mov    %ecx,%ebx
  801103:	89 cf                	mov    %ecx,%edi
  801105:	89 ce                	mov    %ecx,%esi
  801107:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801109:	85 c0                	test   %eax,%eax
  80110b:	7e 28                	jle    801135 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801111:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801118:	00 
  801119:	c7 44 24 08 87 33 80 	movl   $0x803387,0x8(%esp)
  801120:	00 
  801121:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801128:	00 
  801129:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  801130:	e8 8b f0 ff ff       	call   8001c0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801135:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801138:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80113b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80113e:	89 ec                	mov    %ebp,%esp
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    
	...

00801144 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	05 00 00 00 30       	add    $0x30000000,%eax
  80114f:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    

00801154 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	89 04 24             	mov    %eax,(%esp)
  801160:	e8 df ff ff ff       	call   801144 <fd2num>
  801165:	05 20 00 0d 00       	add    $0xd0020,%eax
  80116a:	c1 e0 0c             	shl    $0xc,%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	8b 7d 08             	mov    0x8(%ebp),%edi
  801178:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80117d:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801182:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801187:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801189:	89 c2                	mov    %eax,%edx
  80118b:	c1 ea 16             	shr    $0x16,%edx
  80118e:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801191:	f6 c2 01             	test   $0x1,%dl
  801194:	74 0d                	je     8011a3 <fd_alloc+0x34>
  801196:	89 c2                	mov    %eax,%edx
  801198:	c1 ea 0c             	shr    $0xc,%edx
  80119b:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  80119e:	f6 c2 01             	test   $0x1,%dl
  8011a1:	75 09                	jne    8011ac <fd_alloc+0x3d>
			*fd_store = fd;
  8011a3:	89 37                	mov    %esi,(%edi)
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8011aa:	eb 17                	jmp    8011c3 <fd_alloc+0x54>
  8011ac:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011b1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011b6:	75 cf                	jne    801187 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011b8:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8011be:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8011c3:	5b                   	pop    %ebx
  8011c4:	5e                   	pop    %esi
  8011c5:	5f                   	pop    %edi
  8011c6:	5d                   	pop    %ebp
  8011c7:	c3                   	ret    

008011c8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	83 f8 1f             	cmp    $0x1f,%eax
  8011d1:	77 36                	ja     801209 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011d3:	05 00 00 0d 00       	add    $0xd0000,%eax
  8011d8:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	c1 ea 16             	shr    $0x16,%edx
  8011e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011e7:	f6 c2 01             	test   $0x1,%dl
  8011ea:	74 1d                	je     801209 <fd_lookup+0x41>
  8011ec:	89 c2                	mov    %eax,%edx
  8011ee:	c1 ea 0c             	shr    $0xc,%edx
  8011f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f8:	f6 c2 01             	test   $0x1,%dl
  8011fb:	74 0c                	je     801209 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801200:	89 02                	mov    %eax,(%edx)
  801202:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801207:	eb 05                	jmp    80120e <fd_lookup+0x46>
  801209:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80120e:	5d                   	pop    %ebp
  80120f:	c3                   	ret    

00801210 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801216:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801219:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	89 04 24             	mov    %eax,(%esp)
  801223:	e8 a0 ff ff ff       	call   8011c8 <fd_lookup>
  801228:	85 c0                	test   %eax,%eax
  80122a:	78 0e                	js     80123a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80122c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801232:	89 50 04             	mov    %edx,0x4(%eax)
  801235:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	56                   	push   %esi
  801240:	53                   	push   %ebx
  801241:	83 ec 10             	sub    $0x10,%esp
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80124a:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80124f:	be 30 34 80 00       	mov    $0x803430,%esi
  801254:	eb 10                	jmp    801266 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  801256:	39 08                	cmp    %ecx,(%eax)
  801258:	75 09                	jne    801263 <dev_lookup+0x27>
			*dev = devtab[i];
  80125a:	89 03                	mov    %eax,(%ebx)
  80125c:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801261:	eb 31                	jmp    801294 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801263:	83 c2 01             	add    $0x1,%edx
  801266:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801269:	85 c0                	test   %eax,%eax
  80126b:	75 e9                	jne    801256 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80126d:	a1 08 50 80 00       	mov    0x805008,%eax
  801272:	8b 40 48             	mov    0x48(%eax),%eax
  801275:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801279:	89 44 24 04          	mov    %eax,0x4(%esp)
  80127d:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  801284:	e8 f0 ef ff ff       	call   800279 <cprintf>
	*dev = 0;
  801289:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80128f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	5b                   	pop    %ebx
  801298:	5e                   	pop    %esi
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    

0080129b <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	53                   	push   %ebx
  80129f:	83 ec 24             	sub    $0x24,%esp
  8012a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 04 24             	mov    %eax,(%esp)
  8012b2:	e8 11 ff ff ff       	call   8011c8 <fd_lookup>
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 53                	js     80130e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c5:	8b 00                	mov    (%eax),%eax
  8012c7:	89 04 24             	mov    %eax,(%esp)
  8012ca:	e8 6d ff ff ff       	call   80123c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	78 3b                	js     80130e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8012d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012db:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8012df:	74 2d                	je     80130e <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012e1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012e4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012eb:	00 00 00 
	stat->st_isdir = 0;
  8012ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012f5:	00 00 00 
	stat->st_dev = dev;
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801301:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801305:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801308:	89 14 24             	mov    %edx,(%esp)
  80130b:	ff 50 14             	call   *0x14(%eax)
}
  80130e:	83 c4 24             	add    $0x24,%esp
  801311:	5b                   	pop    %ebx
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    

00801314 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	53                   	push   %ebx
  801318:	83 ec 24             	sub    $0x24,%esp
  80131b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801321:	89 44 24 04          	mov    %eax,0x4(%esp)
  801325:	89 1c 24             	mov    %ebx,(%esp)
  801328:	e8 9b fe ff ff       	call   8011c8 <fd_lookup>
  80132d:	85 c0                	test   %eax,%eax
  80132f:	78 5f                	js     801390 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801331:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801334:	89 44 24 04          	mov    %eax,0x4(%esp)
  801338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133b:	8b 00                	mov    (%eax),%eax
  80133d:	89 04 24             	mov    %eax,(%esp)
  801340:	e8 f7 fe ff ff       	call   80123c <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801345:	85 c0                	test   %eax,%eax
  801347:	78 47                	js     801390 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801349:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80134c:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801350:	75 23                	jne    801375 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801352:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801357:	8b 40 48             	mov    0x48(%eax),%eax
  80135a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80135e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801362:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  801369:	e8 0b ef ff ff       	call   800279 <cprintf>
  80136e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801373:	eb 1b                	jmp    801390 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801378:	8b 48 18             	mov    0x18(%eax),%ecx
  80137b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801380:	85 c9                	test   %ecx,%ecx
  801382:	74 0c                	je     801390 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138b:	89 14 24             	mov    %edx,(%esp)
  80138e:	ff d1                	call   *%ecx
}
  801390:	83 c4 24             	add    $0x24,%esp
  801393:	5b                   	pop    %ebx
  801394:	5d                   	pop    %ebp
  801395:	c3                   	ret    

00801396 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	53                   	push   %ebx
  80139a:	83 ec 24             	sub    $0x24,%esp
  80139d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a7:	89 1c 24             	mov    %ebx,(%esp)
  8013aa:	e8 19 fe ff ff       	call   8011c8 <fd_lookup>
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 66                	js     801419 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	89 04 24             	mov    %eax,(%esp)
  8013c2:	e8 75 fe ff ff       	call   80123c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 4e                	js     801419 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ce:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8013d2:	75 23                	jne    8013f7 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013d4:	a1 08 50 80 00       	mov    0x805008,%eax
  8013d9:	8b 40 48             	mov    0x48(%eax),%eax
  8013dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e4:	c7 04 24 f5 33 80 00 	movl   $0x8033f5,(%esp)
  8013eb:	e8 89 ee ff ff       	call   800279 <cprintf>
  8013f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8013f5:	eb 22                	jmp    801419 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fa:	8b 48 0c             	mov    0xc(%eax),%ecx
  8013fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801402:	85 c9                	test   %ecx,%ecx
  801404:	74 13                	je     801419 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	89 44 24 04          	mov    %eax,0x4(%esp)
  801414:	89 14 24             	mov    %edx,(%esp)
  801417:	ff d1                	call   *%ecx
}
  801419:	83 c4 24             	add    $0x24,%esp
  80141c:	5b                   	pop    %ebx
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    

0080141f <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	53                   	push   %ebx
  801423:	83 ec 24             	sub    $0x24,%esp
  801426:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801429:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801430:	89 1c 24             	mov    %ebx,(%esp)
  801433:	e8 90 fd ff ff       	call   8011c8 <fd_lookup>
  801438:	85 c0                	test   %eax,%eax
  80143a:	78 6b                	js     8014a7 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801446:	8b 00                	mov    (%eax),%eax
  801448:	89 04 24             	mov    %eax,(%esp)
  80144b:	e8 ec fd ff ff       	call   80123c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801450:	85 c0                	test   %eax,%eax
  801452:	78 53                	js     8014a7 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801457:	8b 42 08             	mov    0x8(%edx),%eax
  80145a:	83 e0 03             	and    $0x3,%eax
  80145d:	83 f8 01             	cmp    $0x1,%eax
  801460:	75 23                	jne    801485 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801462:	a1 08 50 80 00       	mov    0x805008,%eax
  801467:	8b 40 48             	mov    0x48(%eax),%eax
  80146a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80146e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801472:	c7 04 24 12 34 80 00 	movl   $0x803412,(%esp)
  801479:	e8 fb ed ff ff       	call   800279 <cprintf>
  80147e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801483:	eb 22                	jmp    8014a7 <read+0x88>
	}
	if (!dev->dev_read)
  801485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801488:	8b 48 08             	mov    0x8(%eax),%ecx
  80148b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801490:	85 c9                	test   %ecx,%ecx
  801492:	74 13                	je     8014a7 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	89 44 24 08          	mov    %eax,0x8(%esp)
  80149b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a2:	89 14 24             	mov    %edx,(%esp)
  8014a5:	ff d1                	call   *%ecx
}
  8014a7:	83 c4 24             	add    $0x24,%esp
  8014aa:	5b                   	pop    %ebx
  8014ab:	5d                   	pop    %ebp
  8014ac:	c3                   	ret    

008014ad <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	57                   	push   %edi
  8014b1:	56                   	push   %esi
  8014b2:	53                   	push   %ebx
  8014b3:	83 ec 1c             	sub    $0x1c,%esp
  8014b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b9:	8b 75 10             	mov    0x10(%ebp),%esi
  8014bc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014c1:	eb 21                	jmp    8014e4 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c3:	89 f2                	mov    %esi,%edx
  8014c5:	29 c2                	sub    %eax,%edx
  8014c7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014cb:	03 45 0c             	add    0xc(%ebp),%eax
  8014ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d2:	89 3c 24             	mov    %edi,(%esp)
  8014d5:	e8 45 ff ff ff       	call   80141f <read>
		if (m < 0)
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	78 0e                	js     8014ec <readn+0x3f>
			return m;
		if (m == 0)
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	74 08                	je     8014ea <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014e2:	01 c3                	add    %eax,%ebx
  8014e4:	89 d8                	mov    %ebx,%eax
  8014e6:	39 f3                	cmp    %esi,%ebx
  8014e8:	72 d9                	jb     8014c3 <readn+0x16>
  8014ea:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014ec:	83 c4 1c             	add    $0x1c,%esp
  8014ef:	5b                   	pop    %ebx
  8014f0:	5e                   	pop    %esi
  8014f1:	5f                   	pop    %edi
  8014f2:	5d                   	pop    %ebp
  8014f3:	c3                   	ret    

008014f4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 38             	sub    $0x38,%esp
  8014fa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014fd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801500:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801503:	8b 7d 08             	mov    0x8(%ebp),%edi
  801506:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80150a:	89 3c 24             	mov    %edi,(%esp)
  80150d:	e8 32 fc ff ff       	call   801144 <fd2num>
  801512:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801515:	89 54 24 04          	mov    %edx,0x4(%esp)
  801519:	89 04 24             	mov    %eax,(%esp)
  80151c:	e8 a7 fc ff ff       	call   8011c8 <fd_lookup>
  801521:	89 c3                	mov    %eax,%ebx
  801523:	85 c0                	test   %eax,%eax
  801525:	78 05                	js     80152c <fd_close+0x38>
  801527:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  80152a:	74 0e                	je     80153a <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80152c:	89 f0                	mov    %esi,%eax
  80152e:	84 c0                	test   %al,%al
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
  801535:	0f 44 d8             	cmove  %eax,%ebx
  801538:	eb 3d                	jmp    801577 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80153a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80153d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801541:	8b 07                	mov    (%edi),%eax
  801543:	89 04 24             	mov    %eax,(%esp)
  801546:	e8 f1 fc ff ff       	call   80123c <dev_lookup>
  80154b:	89 c3                	mov    %eax,%ebx
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 16                	js     801567 <fd_close+0x73>
		if (dev->dev_close)
  801551:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801554:	8b 40 10             	mov    0x10(%eax),%eax
  801557:	bb 00 00 00 00       	mov    $0x0,%ebx
  80155c:	85 c0                	test   %eax,%eax
  80155e:	74 07                	je     801567 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801560:	89 3c 24             	mov    %edi,(%esp)
  801563:	ff d0                	call   *%eax
  801565:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801567:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80156b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801572:	e8 eb f9 ff ff       	call   800f62 <sys_page_unmap>
	return r;
}
  801577:	89 d8                	mov    %ebx,%eax
  801579:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80157c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80157f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801582:	89 ec                	mov    %ebp,%esp
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	89 04 24             	mov    %eax,(%esp)
  801599:	e8 2a fc ff ff       	call   8011c8 <fd_lookup>
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 13                	js     8015b5 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8015a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015a9:	00 
  8015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ad:	89 04 24             	mov    %eax,(%esp)
  8015b0:	e8 3f ff ff ff       	call   8014f4 <fd_close>
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 18             	sub    $0x18,%esp
  8015bd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015c0:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015ca:	00 
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	89 04 24             	mov    %eax,(%esp)
  8015d1:	e8 25 04 00 00       	call   8019fb <open>
  8015d6:	89 c3                	mov    %eax,%ebx
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	78 1b                	js     8015f7 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e3:	89 1c 24             	mov    %ebx,(%esp)
  8015e6:	e8 b0 fc ff ff       	call   80129b <fstat>
  8015eb:	89 c6                	mov    %eax,%esi
	close(fd);
  8015ed:	89 1c 24             	mov    %ebx,(%esp)
  8015f0:	e8 91 ff ff ff       	call   801586 <close>
  8015f5:	89 f3                	mov    %esi,%ebx
	return r;
}
  8015f7:	89 d8                	mov    %ebx,%eax
  8015f9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015fc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015ff:	89 ec                	mov    %ebp,%esp
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    

00801603 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	53                   	push   %ebx
  801607:	83 ec 14             	sub    $0x14,%esp
  80160a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  80160f:	89 1c 24             	mov    %ebx,(%esp)
  801612:	e8 6f ff ff ff       	call   801586 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801617:	83 c3 01             	add    $0x1,%ebx
  80161a:	83 fb 20             	cmp    $0x20,%ebx
  80161d:	75 f0                	jne    80160f <close_all+0xc>
		close(i);
}
  80161f:	83 c4 14             	add    $0x14,%esp
  801622:	5b                   	pop    %ebx
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    

00801625 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 58             	sub    $0x58,%esp
  80162b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80162e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801631:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801634:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801637:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80163a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 04 24             	mov    %eax,(%esp)
  801644:	e8 7f fb ff ff       	call   8011c8 <fd_lookup>
  801649:	89 c3                	mov    %eax,%ebx
  80164b:	85 c0                	test   %eax,%eax
  80164d:	0f 88 e0 00 00 00    	js     801733 <dup+0x10e>
		return r;
	close(newfdnum);
  801653:	89 3c 24             	mov    %edi,(%esp)
  801656:	e8 2b ff ff ff       	call   801586 <close>

	newfd = INDEX2FD(newfdnum);
  80165b:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801661:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801667:	89 04 24             	mov    %eax,(%esp)
  80166a:	e8 e5 fa ff ff       	call   801154 <fd2data>
  80166f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801671:	89 34 24             	mov    %esi,(%esp)
  801674:	e8 db fa ff ff       	call   801154 <fd2data>
  801679:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80167c:	89 da                	mov    %ebx,%edx
  80167e:	89 d8                	mov    %ebx,%eax
  801680:	c1 e8 16             	shr    $0x16,%eax
  801683:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80168a:	a8 01                	test   $0x1,%al
  80168c:	74 43                	je     8016d1 <dup+0xac>
  80168e:	c1 ea 0c             	shr    $0xc,%edx
  801691:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801698:	a8 01                	test   $0x1,%al
  80169a:	74 35                	je     8016d1 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80169c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8016a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016ba:	00 
  8016bb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016c6:	e8 f5 f8 ff ff       	call   800fc0 <sys_page_map>
  8016cb:	89 c3                	mov    %eax,%ebx
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 3f                	js     801710 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d4:	89 c2                	mov    %eax,%edx
  8016d6:	c1 ea 0c             	shr    $0xc,%edx
  8016d9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016e0:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016e6:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016ee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016f5:	00 
  8016f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801701:	e8 ba f8 ff ff       	call   800fc0 <sys_page_map>
  801706:	89 c3                	mov    %eax,%ebx
  801708:	85 c0                	test   %eax,%eax
  80170a:	78 04                	js     801710 <dup+0xeb>
  80170c:	89 fb                	mov    %edi,%ebx
  80170e:	eb 23                	jmp    801733 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801710:	89 74 24 04          	mov    %esi,0x4(%esp)
  801714:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171b:	e8 42 f8 ff ff       	call   800f62 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801723:	89 44 24 04          	mov    %eax,0x4(%esp)
  801727:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80172e:	e8 2f f8 ff ff       	call   800f62 <sys_page_unmap>
	return r;
}
  801733:	89 d8                	mov    %ebx,%eax
  801735:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801738:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80173b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80173e:	89 ec                	mov    %ebp,%esp
  801740:	5d                   	pop    %ebp
  801741:	c3                   	ret    
	...

00801744 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	56                   	push   %esi
  801748:	53                   	push   %ebx
  801749:	83 ec 10             	sub    $0x10,%esp
  80174c:	89 c3                	mov    %eax,%ebx
  80174e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801750:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801757:	75 11                	jne    80176a <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801759:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801760:	e8 2f 14 00 00       	call   802b94 <ipc_find_env>
  801765:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  80176a:	a1 08 50 80 00       	mov    0x805008,%eax
  80176f:	8b 40 48             	mov    0x48(%eax),%eax
  801772:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801778:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80177c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801780:	89 44 24 04          	mov    %eax,0x4(%esp)
  801784:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  80178b:	e8 e9 ea ff ff       	call   800279 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801790:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801797:	00 
  801798:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80179f:	00 
  8017a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017a4:	a1 00 50 80 00       	mov    0x805000,%eax
  8017a9:	89 04 24             	mov    %eax,(%esp)
  8017ac:	e8 19 14 00 00       	call   802bca <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017b1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b8:	00 
  8017b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c4:	e8 6d 14 00 00       	call   802c36 <ipc_recv>
}
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	5b                   	pop    %ebx
  8017cd:	5e                   	pop    %esi
  8017ce:	5d                   	pop    %ebp
  8017cf:	c3                   	ret    

008017d0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017dc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ee:	b8 02 00 00 00       	mov    $0x2,%eax
  8017f3:	e8 4c ff ff ff       	call   801744 <fsipc>
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	8b 40 0c             	mov    0xc(%eax),%eax
  801806:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80180b:	ba 00 00 00 00       	mov    $0x0,%edx
  801810:	b8 06 00 00 00       	mov    $0x6,%eax
  801815:	e8 2a ff ff ff       	call   801744 <fsipc>
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801822:	ba 00 00 00 00       	mov    $0x0,%edx
  801827:	b8 08 00 00 00       	mov    $0x8,%eax
  80182c:	e8 13 ff ff ff       	call   801744 <fsipc>
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	53                   	push   %ebx
  801837:	83 ec 14             	sub    $0x14,%esp
  80183a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8b 40 0c             	mov    0xc(%eax),%eax
  801843:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801848:	ba 00 00 00 00       	mov    $0x0,%edx
  80184d:	b8 05 00 00 00       	mov    $0x5,%eax
  801852:	e8 ed fe ff ff       	call   801744 <fsipc>
  801857:	85 c0                	test   %eax,%eax
  801859:	78 2b                	js     801886 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80185b:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801862:	00 
  801863:	89 1c 24             	mov    %ebx,(%esp)
  801866:	e8 6e f0 ff ff       	call   8008d9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80186b:	a1 80 60 80 00       	mov    0x806080,%eax
  801870:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801876:	a1 84 60 80 00       	mov    0x806084,%eax
  80187b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801881:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801886:	83 c4 14             	add    $0x14,%esp
  801889:	5b                   	pop    %ebx
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	53                   	push   %ebx
  801890:	83 ec 14             	sub    $0x14,%esp
  801893:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8b 40 0c             	mov    0xc(%eax),%eax
  80189c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8018a1:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  8018a7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8018ad:	76 24                	jbe    8018d3 <devfile_write+0x47>
  8018af:	c7 44 24 0c 5a 34 80 	movl   $0x80345a,0xc(%esp)
  8018b6:	00 
  8018b7:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  8018be:	00 
  8018bf:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  8018c6:	00 
  8018c7:	c7 04 24 79 34 80 00 	movl   $0x803479,(%esp)
  8018ce:	e8 ed e8 ff ff       	call   8001c0 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  8018d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018de:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8018e5:	e8 95 f1 ff ff       	call   800a7f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  8018ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ef:	b8 04 00 00 00       	mov    $0x4,%eax
  8018f4:	e8 4b fe ff ff       	call   801744 <fsipc>
	if(ret<0) return ret;
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	78 53                	js     801950 <devfile_write+0xc4>
	
	assert(ret <= n);
  8018fd:	39 c3                	cmp    %eax,%ebx
  8018ff:	73 24                	jae    801925 <devfile_write+0x99>
  801901:	c7 44 24 0c 84 34 80 	movl   $0x803484,0xc(%esp)
  801908:	00 
  801909:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  801910:	00 
  801911:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801918:	00 
  801919:	c7 04 24 79 34 80 00 	movl   $0x803479,(%esp)
  801920:	e8 9b e8 ff ff       	call   8001c0 <_panic>
	assert(ret <= PGSIZE);
  801925:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80192a:	7e 24                	jle    801950 <devfile_write+0xc4>
  80192c:	c7 44 24 0c 8d 34 80 	movl   $0x80348d,0xc(%esp)
  801933:	00 
  801934:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  80193b:	00 
  80193c:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801943:	00 
  801944:	c7 04 24 79 34 80 00 	movl   $0x803479,(%esp)
  80194b:	e8 70 e8 ff ff       	call   8001c0 <_panic>
	return ret;
}
  801950:	83 c4 14             	add    $0x14,%esp
  801953:	5b                   	pop    %ebx
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    

00801956 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	56                   	push   %esi
  80195a:	53                   	push   %ebx
  80195b:	83 ec 10             	sub    $0x10,%esp
  80195e:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	8b 40 0c             	mov    0xc(%eax),%eax
  801967:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80196c:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801972:	ba 00 00 00 00       	mov    $0x0,%edx
  801977:	b8 03 00 00 00       	mov    $0x3,%eax
  80197c:	e8 c3 fd ff ff       	call   801744 <fsipc>
  801981:	89 c3                	mov    %eax,%ebx
  801983:	85 c0                	test   %eax,%eax
  801985:	78 6b                	js     8019f2 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801987:	39 de                	cmp    %ebx,%esi
  801989:	73 24                	jae    8019af <devfile_read+0x59>
  80198b:	c7 44 24 0c 9b 34 80 	movl   $0x80349b,0xc(%esp)
  801992:	00 
  801993:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  80199a:	00 
  80199b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8019a2:	00 
  8019a3:	c7 04 24 79 34 80 00 	movl   $0x803479,(%esp)
  8019aa:	e8 11 e8 ff ff       	call   8001c0 <_panic>
	assert(r <= PGSIZE);
  8019af:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8019b5:	7e 24                	jle    8019db <devfile_read+0x85>
  8019b7:	c7 44 24 0c a2 34 80 	movl   $0x8034a2,0xc(%esp)
  8019be:	00 
  8019bf:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  8019c6:	00 
  8019c7:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8019ce:	00 
  8019cf:	c7 04 24 79 34 80 00 	movl   $0x803479,(%esp)
  8019d6:	e8 e5 e7 ff ff       	call   8001c0 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019df:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8019e6:	00 
  8019e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ea:	89 04 24             	mov    %eax,(%esp)
  8019ed:	e8 8d f0 ff ff       	call   800a7f <memmove>
	return r;
}
  8019f2:	89 d8                	mov    %ebx,%eax
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    

008019fb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 28             	sub    $0x28,%esp
  801a01:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a04:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a07:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a0a:	89 34 24             	mov    %esi,(%esp)
  801a0d:	e8 8e ee ff ff       	call   8008a0 <strlen>
  801a12:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a17:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a1c:	7f 5e                	jg     801a7c <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a21:	89 04 24             	mov    %eax,(%esp)
  801a24:	e8 46 f7 ff ff       	call   80116f <fd_alloc>
  801a29:	89 c3                	mov    %eax,%ebx
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 4d                	js     801a7c <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a2f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a33:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801a3a:	e8 9a ee ff ff       	call   8008d9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a42:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4f:	e8 f0 fc ff ff       	call   801744 <fsipc>
  801a54:	89 c3                	mov    %eax,%ebx
  801a56:	85 c0                	test   %eax,%eax
  801a58:	79 15                	jns    801a6f <open+0x74>
		fd_close(fd, 0);
  801a5a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a61:	00 
  801a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a65:	89 04 24             	mov    %eax,(%esp)
  801a68:	e8 87 fa ff ff       	call   8014f4 <fd_close>
		return r;
  801a6d:	eb 0d                	jmp    801a7c <open+0x81>
	}

	return fd2num(fd);
  801a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a72:	89 04 24             	mov    %eax,(%esp)
  801a75:	e8 ca f6 ff ff       	call   801144 <fd2num>
  801a7a:	89 c3                	mov    %eax,%ebx
}
  801a7c:	89 d8                	mov    %ebx,%eax
  801a7e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a81:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a84:	89 ec                	mov    %ebp,%esp
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    

00801a88 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	57                   	push   %edi
  801a8c:	56                   	push   %esi
  801a8d:	53                   	push   %ebx
  801a8e:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801a94:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a9b:	00 
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	89 04 24             	mov    %eax,(%esp)
  801aa2:	e8 54 ff ff ff       	call   8019fb <open>
  801aa7:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	0f 88 f7 05 00 00    	js     8020ac <spawn+0x624>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  801ab5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801abc:	00 
  801abd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac7:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801acd:	89 14 24             	mov    %edx,(%esp)
  801ad0:	e8 d8 f9 ff ff       	call   8014ad <readn>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801ad5:	3d 00 02 00 00       	cmp    $0x200,%eax
  801ada:	75 0c                	jne    801ae8 <spawn+0x60>
  801adc:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801ae3:	45 4c 46 
  801ae6:	74 3b                	je     801b23 <spawn+0x9b>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  801ae8:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801aee:	89 04 24             	mov    %eax,(%esp)
  801af1:	e8 90 fa ff ff       	call   801586 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801af6:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801afd:	46 
  801afe:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b08:	c7 04 24 ae 34 80 00 	movl   $0x8034ae,(%esp)
  801b0f:	e8 65 e7 ff ff       	call   800279 <cprintf>
  801b14:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  801b1b:	ff ff ff 
		return -E_NOT_EXEC;
  801b1e:	e9 89 05 00 00       	jmp    8020ac <spawn+0x624>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801b23:	ba 07 00 00 00       	mov    $0x7,%edx
  801b28:	89 d0                	mov    %edx,%eax
  801b2a:	cd 30                	int    $0x30
  801b2c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801b32:	85 c0                	test   %eax,%eax
  801b34:	0f 88 66 05 00 00    	js     8020a0 <spawn+0x618>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801b3a:	89 c6                	mov    %eax,%esi
  801b3c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801b42:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801b45:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801b4b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801b51:	b9 11 00 00 00       	mov    $0x11,%ecx
  801b56:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801b58:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801b5e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801b64:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b69:	be 00 00 00 00       	mov    $0x0,%esi
  801b6e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b71:	eb 0f                	jmp    801b82 <spawn+0xfa>

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801b73:	89 04 24             	mov    %eax,(%esp)
  801b76:	e8 25 ed ff ff       	call   8008a0 <strlen>
  801b7b:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b7f:	83 c3 01             	add    $0x1,%ebx
  801b82:	8d 14 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edx
  801b89:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	75 e3                	jne    801b73 <spawn+0xeb>
  801b90:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801b96:	89 9d 7c fd ff ff    	mov    %ebx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801b9c:	f7 de                	neg    %esi
  801b9e:	81 c6 00 10 40 00    	add    $0x401000,%esi
  801ba4:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801baa:	89 f2                	mov    %esi,%edx
  801bac:	83 e2 fc             	and    $0xfffffffc,%edx
  801baf:	89 d8                	mov    %ebx,%eax
  801bb1:	f7 d0                	not    %eax
  801bb3:	8d 3c 82             	lea    (%edx,%eax,4),%edi

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801bb6:	8d 57 f8             	lea    -0x8(%edi),%edx
  801bb9:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801bbf:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801bc4:	81 fa ff ff 3f 00    	cmp    $0x3fffff,%edx
  801bca:	0f 86 ed 04 00 00    	jbe    8020bd <spawn+0x635>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bd0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801bd7:	00 
  801bd8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bdf:	00 
  801be0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be7:	e8 32 f4 ff ff       	call   80101e <sys_page_alloc>
  801bec:	be 00 00 00 00       	mov    $0x0,%esi
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	79 4c                	jns    801c41 <spawn+0x1b9>
  801bf5:	e9 c3 04 00 00       	jmp    8020bd <spawn+0x635>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801bfa:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c00:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801c05:	89 04 b7             	mov    %eax,(%edi,%esi,4)
		strcpy(string_store, argv[i]);
  801c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0b:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  801c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c12:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c18:	89 04 24             	mov    %eax,(%esp)
  801c1b:	e8 b9 ec ff ff       	call   8008d9 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c23:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  801c26:	89 04 24             	mov    %eax,(%esp)
  801c29:	e8 72 ec ff ff       	call   8008a0 <strlen>
  801c2e:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801c34:	8d 54 02 01          	lea    0x1(%edx,%eax,1),%edx
  801c38:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801c3e:	83 c6 01             	add    $0x1,%esi
  801c41:	39 de                	cmp    %ebx,%esi
  801c43:	7c b5                	jl     801bfa <spawn+0x172>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801c45:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c4b:	c7 04 07 00 00 00 00 	movl   $0x0,(%edi,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c52:	81 bd 94 fd ff ff 00 	cmpl   $0x401000,-0x26c(%ebp)
  801c59:	10 40 00 
  801c5c:	74 24                	je     801c82 <spawn+0x1fa>
  801c5e:	c7 44 24 0c 50 35 80 	movl   $0x803550,0xc(%esp)
  801c65:	00 
  801c66:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  801c6d:	00 
  801c6e:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  801c75:	00 
  801c76:	c7 04 24 c8 34 80 00 	movl   $0x8034c8,(%esp)
  801c7d:	e8 3e e5 ff ff       	call   8001c0 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c82:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801c88:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801c8b:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801c91:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  801c97:	89 02                	mov    %eax,(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c99:	81 ef 08 30 80 11    	sub    $0x11803008,%edi
  801c9f:	89 bd e0 fd ff ff    	mov    %edi,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801ca5:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801cac:	00 
  801cad:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801cb4:	ee 
  801cb5:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801cbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cbf:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cc6:	00 
  801cc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cce:	e8 ed f2 ff ff       	call   800fc0 <sys_page_map>
  801cd3:	89 c3                	mov    %eax,%ebx
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	78 1a                	js     801cf3 <spawn+0x26b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801cd9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ce0:	00 
  801ce1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce8:	e8 75 f2 ff ff       	call   800f62 <sys_page_unmap>
  801ced:	89 c3                	mov    %eax,%ebx
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	79 1f                	jns    801d12 <spawn+0x28a>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801cf3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cfa:	00 
  801cfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d02:	e8 5b f2 ff ff       	call   800f62 <sys_page_unmap>
  801d07:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801d0d:	e9 9a 03 00 00       	jmp    8020ac <spawn+0x624>

	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801d12:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801d18:	03 85 04 fe ff ff    	add    -0x1fc(%ebp),%eax
  801d1e:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  801d24:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801d2b:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d2e:	e9 c1 01 00 00       	jmp    801ef4 <spawn+0x46c>
		if (ph->p_type != ELF_PROG_LOAD)
  801d33:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d39:	83 38 01             	cmpl   $0x1,(%eax)
  801d3c:	0f 85 a4 01 00 00    	jne    801ee6 <spawn+0x45e>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d42:	89 c2                	mov    %eax,%edx
  801d44:	8b 40 18             	mov    0x18(%eax),%eax
  801d47:	83 e0 02             	and    $0x2,%eax
  801d4a:	83 f8 01             	cmp    $0x1,%eax
  801d4d:	19 c0                	sbb    %eax,%eax
  801d4f:	83 e0 fe             	and    $0xfffffffe,%eax
  801d52:	83 c0 07             	add    $0x7,%eax
  801d55:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d5b:	8b 52 04             	mov    0x4(%edx),%edx
  801d5e:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  801d64:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d6a:	8b 40 10             	mov    0x10(%eax),%eax
  801d6d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801d73:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801d79:	8b 52 14             	mov    0x14(%edx),%edx
  801d7c:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
  801d82:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d88:	8b 58 08             	mov    0x8(%eax),%ebx
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801d8b:	89 d8                	mov    %ebx,%eax
  801d8d:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d92:	74 16                	je     801daa <spawn+0x322>
		va -= i;
  801d94:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801d96:	01 c2                	add    %eax,%edx
  801d98:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		filesz += i;
  801d9e:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801da4:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
  801daa:	be 00 00 00 00       	mov    $0x0,%esi
  801daf:	89 df                	mov    %ebx,%edi
  801db1:	e9 22 01 00 00       	jmp    801ed8 <spawn+0x450>
	}

	for (i = 0; i < memsz; i += PGSIZE) {
		if (i >= filesz) {
  801db6:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801dbc:	77 2b                	ja     801de9 <spawn+0x361>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801dbe:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  801dc4:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dc8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dcc:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801dd2:	89 04 24             	mov    %eax,(%esp)
  801dd5:	e8 44 f2 ff ff       	call   80101e <sys_page_alloc>
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	0f 89 ea 00 00 00    	jns    801ecc <spawn+0x444>
  801de2:	89 c3                	mov    %eax,%ebx
  801de4:	e9 93 02 00 00       	jmp    80207c <spawn+0x5f4>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801de9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801df0:	00 
  801df1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801df8:	00 
  801df9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e00:	e8 19 f2 ff ff       	call   80101e <sys_page_alloc>
  801e05:	85 c0                	test   %eax,%eax
  801e07:	0f 88 65 02 00 00    	js     802072 <spawn+0x5ea>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e0d:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  801e13:	01 d8                	add    %ebx,%eax
  801e15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e19:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801e1f:	89 14 24             	mov    %edx,(%esp)
  801e22:	e8 e9 f3 ff ff       	call   801210 <seek>
  801e27:	85 c0                	test   %eax,%eax
  801e29:	0f 88 47 02 00 00    	js     802076 <spawn+0x5ee>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801e2f:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e35:	29 d8                	sub    %ebx,%eax
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e3e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e43:	0f 47 da             	cmova  %edx,%ebx
  801e46:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e4a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e51:	00 
  801e52:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801e58:	89 04 24             	mov    %eax,(%esp)
  801e5b:	e8 4d f6 ff ff       	call   8014ad <readn>
  801e60:	85 c0                	test   %eax,%eax
  801e62:	0f 88 12 02 00 00    	js     80207a <spawn+0x5f2>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801e68:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  801e6e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801e72:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e76:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801e7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e80:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e87:	00 
  801e88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e8f:	e8 2c f1 ff ff       	call   800fc0 <sys_page_map>
  801e94:	85 c0                	test   %eax,%eax
  801e96:	79 20                	jns    801eb8 <spawn+0x430>
				panic("spawn: sys_page_map data: %e", r);
  801e98:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e9c:	c7 44 24 08 d4 34 80 	movl   $0x8034d4,0x8(%esp)
  801ea3:	00 
  801ea4:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  801eab:	00 
  801eac:	c7 04 24 c8 34 80 00 	movl   $0x8034c8,(%esp)
  801eb3:	e8 08 e3 ff ff       	call   8001c0 <_panic>
			sys_page_unmap(0, UTEMP);
  801eb8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ebf:	00 
  801ec0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec7:	e8 96 f0 ff ff       	call   800f62 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801ecc:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801ed2:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801ed8:	89 f3                	mov    %esi,%ebx
  801eda:	39 b5 84 fd ff ff    	cmp    %esi,-0x27c(%ebp)
  801ee0:	0f 87 d0 fe ff ff    	ja     801db6 <spawn+0x32e>
	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ee6:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801eed:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  801ef4:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801efb:	39 85 7c fd ff ff    	cmp    %eax,-0x284(%ebp)
  801f01:	0f 8c 2c fe ff ff    	jl     801d33 <spawn+0x2ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801f07:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801f0d:	89 14 24             	mov    %edx,(%esp)
  801f10:	e8 71 f6 ff ff       	call   801586 <close>
	fd = -1;

	cprintf("copy sharing pages\n");
  801f15:	c7 04 24 0b 35 80 00 	movl   $0x80350b,(%esp)
  801f1c:	e8 58 e3 ff ff       	call   800279 <cprintf>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
  801f21:	e8 8b f1 ff ff       	call   8010b1 <sys_getenvid>
  801f26:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f2c:	c7 85 8c fd ff ff 00 	movl   $0x0,-0x274(%ebp)
  801f33:	00 00 00 

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  801f36:	be 00 00 40 ef       	mov    $0xef400000,%esi
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  801f3b:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801f41:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801f48:	a8 01                	test   $0x1,%al
  801f4a:	0f 84 89 00 00 00    	je     801fd9 <spawn+0x551>
  801f50:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801f56:	0f 84 69 01 00 00    	je     8020c5 <spawn+0x63d>
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  801f5c:	89 d7                	mov    %edx,%edi
  801f5e:	c1 e7 16             	shl    $0x16,%edi
  801f61:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f66:	89 da                	mov    %ebx,%edx
  801f68:	c1 e2 0c             	shl    $0xc,%edx
  801f6b:	01 fa                	add    %edi,%edx
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  801f6d:	89 d0                	mov    %edx,%eax
  801f6f:	c1 e8 0c             	shr    $0xc,%eax
  801f72:	8b 0c 86             	mov    (%esi,%eax,4),%ecx
  801f75:	f6 c1 01             	test   $0x1,%cl
  801f78:	74 54                	je     801fce <spawn+0x546>
  801f7a:	8b 04 86             	mov    (%esi,%eax,4),%eax
  801f7d:	f6 c4 04             	test   $0x4,%ah
  801f80:	74 4c                	je     801fce <spawn+0x546>
				{
					ret = sys_page_map(curr_envid, (void *)addr, child,(void *)addr,PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801f82:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  801f89:	00 
  801f8a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f8e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f94:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f98:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f9c:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801fa2:	89 14 24             	mov    %edx,(%esp)
  801fa5:	e8 16 f0 ff ff       	call   800fc0 <sys_page_map>
					if(ret) panic("sys_page_map: %e", ret);
  801faa:	85 c0                	test   %eax,%eax
  801fac:	74 20                	je     801fce <spawn+0x546>
  801fae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fb2:	c7 44 24 08 f1 34 80 	movl   $0x8034f1,0x8(%esp)
  801fb9:	00 
  801fba:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  801fc1:	00 
  801fc2:	c7 04 24 c8 34 80 00 	movl   $0x8034c8,(%esp)
  801fc9:	e8 f2 e1 ff ff       	call   8001c0 <_panic>
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
  801fce:	83 c3 01             	add    $0x1,%ebx
  801fd1:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801fd7:	75 8d                	jne    801f66 <spawn+0x4de>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  801fd9:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  801fe0:	81 bd 8c fd ff ff bb 	cmpl   $0x3bb,-0x274(%ebp)
  801fe7:	03 00 00 
  801fea:	0f 85 4b ff ff ff    	jne    801f3b <spawn+0x4b3>

	cprintf("copy sharing pages\n");
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
	cprintf("complete copy sharing pages\n");	
  801ff0:	c7 04 24 02 35 80 00 	movl   $0x803502,(%esp)
  801ff7:	e8 7d e2 ff ff       	call   800279 <cprintf>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801ffc:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802002:	89 44 24 04          	mov    %eax,0x4(%esp)
  802006:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80200c:	89 04 24             	mov    %eax,(%esp)
  80200f:	e8 92 ee ff ff       	call   800ea6 <sys_env_set_trapframe>
  802014:	85 c0                	test   %eax,%eax
  802016:	79 20                	jns    802038 <spawn+0x5b0>
		panic("sys_env_set_trapframe: %e", r);
  802018:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80201c:	c7 44 24 08 1f 35 80 	movl   $0x80351f,0x8(%esp)
  802023:	00 
  802024:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  80202b:	00 
  80202c:	c7 04 24 c8 34 80 00 	movl   $0x8034c8,(%esp)
  802033:	e8 88 e1 ff ff       	call   8001c0 <_panic>
	
	//thisenv = &envs[ENVX(child)];
	//cprintf("%s %x\n",__func__,thisenv->env_id);
	
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802038:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80203f:	00 
  802040:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802046:	89 14 24             	mov    %edx,(%esp)
  802049:	e8 b6 ee ff ff       	call   800f04 <sys_env_set_status>
  80204e:	85 c0                	test   %eax,%eax
  802050:	79 4e                	jns    8020a0 <spawn+0x618>
		panic("sys_env_set_status: %e", r);
  802052:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802056:	c7 44 24 08 39 35 80 	movl   $0x803539,0x8(%esp)
  80205d:	00 
  80205e:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  802065:	00 
  802066:	c7 04 24 c8 34 80 00 	movl   $0x8034c8,(%esp)
  80206d:	e8 4e e1 ff ff       	call   8001c0 <_panic>
  802072:	89 c3                	mov    %eax,%ebx
  802074:	eb 06                	jmp    80207c <spawn+0x5f4>
  802076:	89 c3                	mov    %eax,%ebx
  802078:	eb 02                	jmp    80207c <spawn+0x5f4>
  80207a:	89 c3                	mov    %eax,%ebx
	
	return child;

error:
	sys_env_destroy(child);
  80207c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802082:	89 04 24             	mov    %eax,(%esp)
  802085:	e8 5b f0 ff ff       	call   8010e5 <sys_env_destroy>
	close(fd);
  80208a:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802090:	89 14 24             	mov    %edx,(%esp)
  802093:	e8 ee f4 ff ff       	call   801586 <close>
  802098:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
	return r;
  80209e:	eb 0c                	jmp    8020ac <spawn+0x624>
  8020a0:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8020a6:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  8020ac:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8020b2:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8020b8:	5b                   	pop    %ebx
  8020b9:	5e                   	pop    %esi
  8020ba:	5f                   	pop    %edi
  8020bb:	5d                   	pop    %ebp
  8020bc:	c3                   	ret    
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  8020bd:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8020c3:	eb e7                	jmp    8020ac <spawn+0x624>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  8020c5:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  8020cc:	e9 6a fe ff ff       	jmp    801f3b <spawn+0x4b3>

008020d1 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	56                   	push   %esi
  8020d5:	53                   	push   %ebx
  8020d6:	83 ec 10             	sub    $0x10,%esp

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  8020d9:	8d 45 10             	lea    0x10(%ebp),%eax
  8020dc:	ba 00 00 00 00       	mov    $0x0,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8020e1:	eb 03                	jmp    8020e6 <spawnl+0x15>
		argc++;
  8020e3:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8020e6:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  8020ea:	75 f7                	jne    8020e3 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8020ec:	8d 04 95 26 00 00 00 	lea    0x26(,%edx,4),%eax
  8020f3:	83 e0 f0             	and    $0xfffffff0,%eax
  8020f6:	29 c4                	sub    %eax,%esp
  8020f8:	8d 5c 24 17          	lea    0x17(%esp),%ebx
  8020fc:	83 e3 f0             	and    $0xfffffff0,%ebx
	argv[0] = arg0;
  8020ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802102:	89 03                	mov    %eax,(%ebx)
	argv[argc+1] = NULL;
  802104:	c7 44 93 04 00 00 00 	movl   $0x0,0x4(%ebx,%edx,4)
  80210b:	00 

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  80210c:	8d 75 10             	lea    0x10(%ebp),%esi
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802114:	eb 0a                	jmp    802120 <spawnl+0x4f>
		argv[i+1] = va_arg(vl, const char *);
  802116:	83 c0 01             	add    $0x1,%eax
  802119:	8b 4c 86 fc          	mov    -0x4(%esi,%eax,4),%ecx
  80211d:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802120:	39 d0                	cmp    %edx,%eax
  802122:	72 f2                	jb     802116 <spawnl+0x45>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802124:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	89 04 24             	mov    %eax,(%esp)
  80212e:	e8 55 f9 ff ff       	call   801a88 <spawn>
}
  802133:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802136:	5b                   	pop    %ebx
  802137:	5e                   	pop    %esi
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    
  80213a:	00 00                	add    %al,(%eax)
  80213c:	00 00                	add    %al,(%eax)
	...

00802140 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802146:	c7 44 24 04 78 35 80 	movl   $0x803578,0x4(%esp)
  80214d:	00 
  80214e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802151:	89 04 24             	mov    %eax,(%esp)
  802154:	e8 80 e7 ff ff       	call   8008d9 <strcpy>
	return 0;
}
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	53                   	push   %ebx
  802164:	83 ec 14             	sub    $0x14,%esp
  802167:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80216a:	89 1c 24             	mov    %ebx,(%esp)
  80216d:	e8 4e 0b 00 00       	call   802cc0 <pageref>
  802172:	89 c2                	mov    %eax,%edx
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
  802179:	83 fa 01             	cmp    $0x1,%edx
  80217c:	75 0b                	jne    802189 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80217e:	8b 43 0c             	mov    0xc(%ebx),%eax
  802181:	89 04 24             	mov    %eax,(%esp)
  802184:	e8 b1 02 00 00       	call   80243a <nsipc_close>
	else
		return 0;
}
  802189:	83 c4 14             	add    $0x14,%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    

0080218f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802195:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80219c:	00 
  80219d:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b1:	89 04 24             	mov    %eax,(%esp)
  8021b4:	e8 bd 02 00 00       	call   802476 <nsipc_send>
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021c8:	00 
  8021c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	8b 40 0c             	mov    0xc(%eax),%eax
  8021dd:	89 04 24             	mov    %eax,(%esp)
  8021e0:	e8 04 03 00 00       	call   8024e9 <nsipc_recv>
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	56                   	push   %esi
  8021eb:	53                   	push   %ebx
  8021ec:	83 ec 20             	sub    $0x20,%esp
  8021ef:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f4:	89 04 24             	mov    %eax,(%esp)
  8021f7:	e8 73 ef ff ff       	call   80116f <fd_alloc>
  8021fc:	89 c3                	mov    %eax,%ebx
  8021fe:	85 c0                	test   %eax,%eax
  802200:	78 21                	js     802223 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802202:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802209:	00 
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802218:	e8 01 ee ff ff       	call   80101e <sys_page_alloc>
  80221d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80221f:	85 c0                	test   %eax,%eax
  802221:	79 0a                	jns    80222d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  802223:	89 34 24             	mov    %esi,(%esp)
  802226:	e8 0f 02 00 00       	call   80243a <nsipc_close>
		return r;
  80222b:	eb 28                	jmp    802255 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80222d:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802236:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	89 04 24             	mov    %eax,(%esp)
  80224e:	e8 f1 ee ff ff       	call   801144 <fd2num>
  802253:	89 c3                	mov    %eax,%ebx
}
  802255:	89 d8                	mov    %ebx,%eax
  802257:	83 c4 20             	add    $0x20,%esp
  80225a:	5b                   	pop    %ebx
  80225b:	5e                   	pop    %esi
  80225c:	5d                   	pop    %ebp
  80225d:	c3                   	ret    

0080225e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802264:	8b 45 10             	mov    0x10(%ebp),%eax
  802267:	89 44 24 08          	mov    %eax,0x8(%esp)
  80226b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	89 04 24             	mov    %eax,(%esp)
  802278:	e8 71 01 00 00       	call   8023ee <nsipc_socket>
  80227d:	85 c0                	test   %eax,%eax
  80227f:	78 05                	js     802286 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802281:	e8 61 ff ff ff       	call   8021e7 <alloc_sockfd>
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80228e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802291:	89 54 24 04          	mov    %edx,0x4(%esp)
  802295:	89 04 24             	mov    %eax,(%esp)
  802298:	e8 2b ef ff ff       	call   8011c8 <fd_lookup>
  80229d:	85 c0                	test   %eax,%eax
  80229f:	78 15                	js     8022b6 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8022a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a4:	8b 0a                	mov    (%edx),%ecx
  8022a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022ab:	3b 0d 20 40 80 00    	cmp    0x804020,%ecx
  8022b1:	75 03                	jne    8022b6 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8022b3:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	e8 c2 ff ff ff       	call   802288 <fd2sockid>
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	78 0f                	js     8022d9 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8022ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022d1:	89 04 24             	mov    %eax,(%esp)
  8022d4:	e8 3f 01 00 00       	call   802418 <nsipc_listen>
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	e8 9f ff ff ff       	call   802288 <fd2sockid>
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	78 16                	js     802303 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8022ed:	8b 55 10             	mov    0x10(%ebp),%edx
  8022f0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022fb:	89 04 24             	mov    %eax,(%esp)
  8022fe:	e8 66 02 00 00       	call   802569 <nsipc_connect>
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	e8 75 ff ff ff       	call   802288 <fd2sockid>
  802313:	85 c0                	test   %eax,%eax
  802315:	78 0f                	js     802326 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80231e:	89 04 24             	mov    %eax,(%esp)
  802321:	e8 2e 01 00 00       	call   802454 <nsipc_shutdown>
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	e8 52 ff ff ff       	call   802288 <fd2sockid>
  802336:	85 c0                	test   %eax,%eax
  802338:	78 16                	js     802350 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80233a:	8b 55 10             	mov    0x10(%ebp),%edx
  80233d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802341:	8b 55 0c             	mov    0xc(%ebp),%edx
  802344:	89 54 24 04          	mov    %edx,0x4(%esp)
  802348:	89 04 24             	mov    %eax,(%esp)
  80234b:	e8 58 02 00 00       	call   8025a8 <nsipc_bind>
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	e8 28 ff ff ff       	call   802288 <fd2sockid>
  802360:	85 c0                	test   %eax,%eax
  802362:	78 1f                	js     802383 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802364:	8b 55 10             	mov    0x10(%ebp),%edx
  802367:	89 54 24 08          	mov    %edx,0x8(%esp)
  80236b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802372:	89 04 24             	mov    %eax,(%esp)
  802375:	e8 6d 02 00 00       	call   8025e7 <nsipc_accept>
  80237a:	85 c0                	test   %eax,%eax
  80237c:	78 05                	js     802383 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80237e:	e8 64 fe ff ff       	call   8021e7 <alloc_sockfd>
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    
  802385:	00 00                	add    %al,(%eax)
	...

00802388 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	53                   	push   %ebx
  80238c:	83 ec 14             	sub    $0x14,%esp
  80238f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802391:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802398:	75 11                	jne    8023ab <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80239a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8023a1:	e8 ee 07 00 00       	call   802b94 <ipc_find_env>
  8023a6:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8023ab:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8023b2:	00 
  8023b3:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8023ba:	00 
  8023bb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023bf:	a1 04 50 80 00       	mov    0x805004,%eax
  8023c4:	89 04 24             	mov    %eax,(%esp)
  8023c7:	e8 fe 07 00 00       	call   802bca <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023d3:	00 
  8023d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023db:	00 
  8023dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e3:	e8 4e 08 00 00       	call   802c36 <ipc_recv>
}
  8023e8:	83 c4 14             	add    $0x14,%esp
  8023eb:	5b                   	pop    %ebx
  8023ec:	5d                   	pop    %ebp
  8023ed:	c3                   	ret    

008023ee <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8023fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ff:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802404:	8b 45 10             	mov    0x10(%ebp),%eax
  802407:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80240c:	b8 09 00 00 00       	mov    $0x9,%eax
  802411:	e8 72 ff ff ff       	call   802388 <nsipc>
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802426:	8b 45 0c             	mov    0xc(%ebp),%eax
  802429:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80242e:	b8 06 00 00 00       	mov    $0x6,%eax
  802433:	e8 50 ff ff ff       	call   802388 <nsipc>
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802440:	8b 45 08             	mov    0x8(%ebp),%eax
  802443:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802448:	b8 04 00 00 00       	mov    $0x4,%eax
  80244d:	e8 36 ff ff ff       	call   802388 <nsipc>
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802462:	8b 45 0c             	mov    0xc(%ebp),%eax
  802465:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80246a:	b8 03 00 00 00       	mov    $0x3,%eax
  80246f:	e8 14 ff ff ff       	call   802388 <nsipc>
}
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
  802479:	53                   	push   %ebx
  80247a:	83 ec 14             	sub    $0x14,%esp
  80247d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802488:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80248e:	7e 24                	jle    8024b4 <nsipc_send+0x3e>
  802490:	c7 44 24 0c 84 35 80 	movl   $0x803584,0xc(%esp)
  802497:	00 
  802498:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  80249f:	00 
  8024a0:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8024a7:	00 
  8024a8:	c7 04 24 90 35 80 00 	movl   $0x803590,(%esp)
  8024af:	e8 0c dd ff ff       	call   8001c0 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024bf:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8024c6:	e8 b4 e5 ff ff       	call   800a7f <memmove>
	nsipcbuf.send.req_size = size;
  8024cb:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8024d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8024d4:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8024d9:	b8 08 00 00 00       	mov    $0x8,%eax
  8024de:	e8 a5 fe ff ff       	call   802388 <nsipc>
}
  8024e3:	83 c4 14             	add    $0x14,%esp
  8024e6:	5b                   	pop    %ebx
  8024e7:	5d                   	pop    %ebp
  8024e8:	c3                   	ret    

008024e9 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	56                   	push   %esi
  8024ed:	53                   	push   %ebx
  8024ee:	83 ec 10             	sub    $0x10,%esp
  8024f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8024fc:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802502:	8b 45 14             	mov    0x14(%ebp),%eax
  802505:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80250a:	b8 07 00 00 00       	mov    $0x7,%eax
  80250f:	e8 74 fe ff ff       	call   802388 <nsipc>
  802514:	89 c3                	mov    %eax,%ebx
  802516:	85 c0                	test   %eax,%eax
  802518:	78 46                	js     802560 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80251a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80251f:	7f 04                	jg     802525 <nsipc_recv+0x3c>
  802521:	39 c6                	cmp    %eax,%esi
  802523:	7d 24                	jge    802549 <nsipc_recv+0x60>
  802525:	c7 44 24 0c 9c 35 80 	movl   $0x80359c,0xc(%esp)
  80252c:	00 
  80252d:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  802534:	00 
  802535:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  80253c:	00 
  80253d:	c7 04 24 90 35 80 00 	movl   $0x803590,(%esp)
  802544:	e8 77 dc ff ff       	call   8001c0 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802549:	89 44 24 08          	mov    %eax,0x8(%esp)
  80254d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802554:	00 
  802555:	8b 45 0c             	mov    0xc(%ebp),%eax
  802558:	89 04 24             	mov    %eax,(%esp)
  80255b:	e8 1f e5 ff ff       	call   800a7f <memmove>
	}

	return r;
}
  802560:	89 d8                	mov    %ebx,%eax
  802562:	83 c4 10             	add    $0x10,%esp
  802565:	5b                   	pop    %ebx
  802566:	5e                   	pop    %esi
  802567:	5d                   	pop    %ebp
  802568:	c3                   	ret    

00802569 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	53                   	push   %ebx
  80256d:	83 ec 14             	sub    $0x14,%esp
  802570:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80257b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80257f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802582:	89 44 24 04          	mov    %eax,0x4(%esp)
  802586:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80258d:	e8 ed e4 ff ff       	call   800a7f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802592:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802598:	b8 05 00 00 00       	mov    $0x5,%eax
  80259d:	e8 e6 fd ff ff       	call   802388 <nsipc>
}
  8025a2:	83 c4 14             	add    $0x14,%esp
  8025a5:	5b                   	pop    %ebx
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    

008025a8 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	53                   	push   %ebx
  8025ac:	83 ec 14             	sub    $0x14,%esp
  8025af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8025ba:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c5:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8025cc:	e8 ae e4 ff ff       	call   800a7f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8025d1:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  8025d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8025dc:	e8 a7 fd ff ff       	call   802388 <nsipc>
}
  8025e1:	83 c4 14             	add    $0x14,%esp
  8025e4:	5b                   	pop    %ebx
  8025e5:	5d                   	pop    %ebp
  8025e6:	c3                   	ret    

008025e7 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	83 ec 28             	sub    $0x28,%esp
  8025ed:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025f0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025f3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025f6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802601:	8b 07                	mov    (%edi),%eax
  802603:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802608:	b8 01 00 00 00       	mov    $0x1,%eax
  80260d:	e8 76 fd ff ff       	call   802388 <nsipc>
  802612:	89 c6                	mov    %eax,%esi
  802614:	85 c0                	test   %eax,%eax
  802616:	78 22                	js     80263a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802618:	bb 10 80 80 00       	mov    $0x808010,%ebx
  80261d:	8b 03                	mov    (%ebx),%eax
  80261f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802623:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80262a:	00 
  80262b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262e:	89 04 24             	mov    %eax,(%esp)
  802631:	e8 49 e4 ff ff       	call   800a7f <memmove>
		*addrlen = ret->ret_addrlen;
  802636:	8b 03                	mov    (%ebx),%eax
  802638:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  80263a:	89 f0                	mov    %esi,%eax
  80263c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80263f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802642:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802645:	89 ec                	mov    %ebp,%esp
  802647:	5d                   	pop    %ebp
  802648:	c3                   	ret    
  802649:	00 00                	add    %al,(%eax)
	...

0080264c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	83 ec 18             	sub    $0x18,%esp
  802652:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802655:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802658:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	89 04 24             	mov    %eax,(%esp)
  802661:	e8 ee ea ff ff       	call   801154 <fd2data>
  802666:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802668:	c7 44 24 04 b1 35 80 	movl   $0x8035b1,0x4(%esp)
  80266f:	00 
  802670:	89 34 24             	mov    %esi,(%esp)
  802673:	e8 61 e2 ff ff       	call   8008d9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802678:	8b 43 04             	mov    0x4(%ebx),%eax
  80267b:	2b 03                	sub    (%ebx),%eax
  80267d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802683:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80268a:	00 00 00 
	stat->st_dev = &devpipe;
  80268d:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  802694:	40 80 00 
	return 0;
}
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80269f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8026a2:	89 ec                	mov    %ebp,%esp
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    

008026a6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	53                   	push   %ebx
  8026aa:	83 ec 14             	sub    $0x14,%esp
  8026ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026bb:	e8 a2 e8 ff ff       	call   800f62 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026c0:	89 1c 24             	mov    %ebx,(%esp)
  8026c3:	e8 8c ea ff ff       	call   801154 <fd2data>
  8026c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d3:	e8 8a e8 ff ff       	call   800f62 <sys_page_unmap>
}
  8026d8:	83 c4 14             	add    $0x14,%esp
  8026db:	5b                   	pop    %ebx
  8026dc:	5d                   	pop    %ebp
  8026dd:	c3                   	ret    

008026de <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	57                   	push   %edi
  8026e2:	56                   	push   %esi
  8026e3:	53                   	push   %ebx
  8026e4:	83 ec 2c             	sub    $0x2c,%esp
  8026e7:	89 c7                	mov    %eax,%edi
  8026e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8026ec:	a1 08 50 80 00       	mov    0x805008,%eax
  8026f1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026f4:	89 3c 24             	mov    %edi,(%esp)
  8026f7:	e8 c4 05 00 00       	call   802cc0 <pageref>
  8026fc:	89 c6                	mov    %eax,%esi
  8026fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802701:	89 04 24             	mov    %eax,(%esp)
  802704:	e8 b7 05 00 00       	call   802cc0 <pageref>
  802709:	39 c6                	cmp    %eax,%esi
  80270b:	0f 94 c0             	sete   %al
  80270e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802711:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802717:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80271a:	39 cb                	cmp    %ecx,%ebx
  80271c:	75 08                	jne    802726 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80271e:	83 c4 2c             	add    $0x2c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802726:	83 f8 01             	cmp    $0x1,%eax
  802729:	75 c1                	jne    8026ec <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80272b:	8b 52 58             	mov    0x58(%edx),%edx
  80272e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802732:	89 54 24 08          	mov    %edx,0x8(%esp)
  802736:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80273a:	c7 04 24 b8 35 80 00 	movl   $0x8035b8,(%esp)
  802741:	e8 33 db ff ff       	call   800279 <cprintf>
  802746:	eb a4                	jmp    8026ec <_pipeisclosed+0xe>

00802748 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	57                   	push   %edi
  80274c:	56                   	push   %esi
  80274d:	53                   	push   %ebx
  80274e:	83 ec 1c             	sub    $0x1c,%esp
  802751:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802754:	89 34 24             	mov    %esi,(%esp)
  802757:	e8 f8 e9 ff ff       	call   801154 <fd2data>
  80275c:	89 c3                	mov    %eax,%ebx
  80275e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802763:	eb 48                	jmp    8027ad <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802765:	89 da                	mov    %ebx,%edx
  802767:	89 f0                	mov    %esi,%eax
  802769:	e8 70 ff ff ff       	call   8026de <_pipeisclosed>
  80276e:	85 c0                	test   %eax,%eax
  802770:	74 07                	je     802779 <devpipe_write+0x31>
  802772:	b8 00 00 00 00       	mov    $0x0,%eax
  802777:	eb 3b                	jmp    8027b4 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802779:	e8 ff e8 ff ff       	call   80107d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80277e:	8b 43 04             	mov    0x4(%ebx),%eax
  802781:	8b 13                	mov    (%ebx),%edx
  802783:	83 c2 20             	add    $0x20,%edx
  802786:	39 d0                	cmp    %edx,%eax
  802788:	73 db                	jae    802765 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80278a:	89 c2                	mov    %eax,%edx
  80278c:	c1 fa 1f             	sar    $0x1f,%edx
  80278f:	c1 ea 1b             	shr    $0x1b,%edx
  802792:	01 d0                	add    %edx,%eax
  802794:	83 e0 1f             	and    $0x1f,%eax
  802797:	29 d0                	sub    %edx,%eax
  802799:	89 c2                	mov    %eax,%edx
  80279b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80279e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8027a2:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8027a6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027aa:	83 c7 01             	add    $0x1,%edi
  8027ad:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8027b0:	72 cc                	jb     80277e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8027b2:	89 f8                	mov    %edi,%eax
}
  8027b4:	83 c4 1c             	add    $0x1c,%esp
  8027b7:	5b                   	pop    %ebx
  8027b8:	5e                   	pop    %esi
  8027b9:	5f                   	pop    %edi
  8027ba:	5d                   	pop    %ebp
  8027bb:	c3                   	ret    

008027bc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	83 ec 28             	sub    $0x28,%esp
  8027c2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027c5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027c8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027cb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8027ce:	89 3c 24             	mov    %edi,(%esp)
  8027d1:	e8 7e e9 ff ff       	call   801154 <fd2data>
  8027d6:	89 c3                	mov    %eax,%ebx
  8027d8:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027dd:	eb 48                	jmp    802827 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8027df:	85 f6                	test   %esi,%esi
  8027e1:	74 04                	je     8027e7 <devpipe_read+0x2b>
				return i;
  8027e3:	89 f0                	mov    %esi,%eax
  8027e5:	eb 47                	jmp    80282e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8027e7:	89 da                	mov    %ebx,%edx
  8027e9:	89 f8                	mov    %edi,%eax
  8027eb:	e8 ee fe ff ff       	call   8026de <_pipeisclosed>
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	74 07                	je     8027fb <devpipe_read+0x3f>
  8027f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f9:	eb 33                	jmp    80282e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8027fb:	e8 7d e8 ff ff       	call   80107d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802800:	8b 03                	mov    (%ebx),%eax
  802802:	3b 43 04             	cmp    0x4(%ebx),%eax
  802805:	74 d8                	je     8027df <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802807:	89 c2                	mov    %eax,%edx
  802809:	c1 fa 1f             	sar    $0x1f,%edx
  80280c:	c1 ea 1b             	shr    $0x1b,%edx
  80280f:	01 d0                	add    %edx,%eax
  802811:	83 e0 1f             	and    $0x1f,%eax
  802814:	29 d0                	sub    %edx,%eax
  802816:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80281b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281e:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802821:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802824:	83 c6 01             	add    $0x1,%esi
  802827:	3b 75 10             	cmp    0x10(%ebp),%esi
  80282a:	72 d4                	jb     802800 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80282c:	89 f0                	mov    %esi,%eax
}
  80282e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802831:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802834:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802837:	89 ec                	mov    %ebp,%esp
  802839:	5d                   	pop    %ebp
  80283a:	c3                   	ret    

0080283b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
  80283e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802841:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802844:	89 44 24 04          	mov    %eax,0x4(%esp)
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	89 04 24             	mov    %eax,(%esp)
  80284e:	e8 75 e9 ff ff       	call   8011c8 <fd_lookup>
  802853:	85 c0                	test   %eax,%eax
  802855:	78 15                	js     80286c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	89 04 24             	mov    %eax,(%esp)
  80285d:	e8 f2 e8 ff ff       	call   801154 <fd2data>
	return _pipeisclosed(fd, p);
  802862:	89 c2                	mov    %eax,%edx
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	e8 72 fe ff ff       	call   8026de <_pipeisclosed>
}
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    

0080286e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
  802871:	83 ec 48             	sub    $0x48,%esp
  802874:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802877:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80287a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80287d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802880:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802883:	89 04 24             	mov    %eax,(%esp)
  802886:	e8 e4 e8 ff ff       	call   80116f <fd_alloc>
  80288b:	89 c3                	mov    %eax,%ebx
  80288d:	85 c0                	test   %eax,%eax
  80288f:	0f 88 42 01 00 00    	js     8029d7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802895:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80289c:	00 
  80289d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ab:	e8 6e e7 ff ff       	call   80101e <sys_page_alloc>
  8028b0:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	0f 88 1d 01 00 00    	js     8029d7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028ba:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8028bd:	89 04 24             	mov    %eax,(%esp)
  8028c0:	e8 aa e8 ff ff       	call   80116f <fd_alloc>
  8028c5:	89 c3                	mov    %eax,%ebx
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	0f 88 f5 00 00 00    	js     8029c4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028cf:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028d6:	00 
  8028d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e5:	e8 34 e7 ff ff       	call   80101e <sys_page_alloc>
  8028ea:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	0f 88 d0 00 00 00    	js     8029c4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8028f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f7:	89 04 24             	mov    %eax,(%esp)
  8028fa:	e8 55 e8 ff ff       	call   801154 <fd2data>
  8028ff:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802901:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802908:	00 
  802909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80290d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802914:	e8 05 e7 ff ff       	call   80101e <sys_page_alloc>
  802919:	89 c3                	mov    %eax,%ebx
  80291b:	85 c0                	test   %eax,%eax
  80291d:	0f 88 8e 00 00 00    	js     8029b1 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802923:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802926:	89 04 24             	mov    %eax,(%esp)
  802929:	e8 26 e8 ff ff       	call   801154 <fd2data>
  80292e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802935:	00 
  802936:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80293a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802941:	00 
  802942:	89 74 24 04          	mov    %esi,0x4(%esp)
  802946:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80294d:	e8 6e e6 ff ff       	call   800fc0 <sys_page_map>
  802952:	89 c3                	mov    %eax,%ebx
  802954:	85 c0                	test   %eax,%eax
  802956:	78 49                	js     8029a1 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802958:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  80295d:	8b 08                	mov    (%eax),%ecx
  80295f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802962:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802964:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802967:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80296e:	8b 10                	mov    (%eax),%edx
  802970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802973:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802978:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80297f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802982:	89 04 24             	mov    %eax,(%esp)
  802985:	e8 ba e7 ff ff       	call   801144 <fd2num>
  80298a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80298c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298f:	89 04 24             	mov    %eax,(%esp)
  802992:	e8 ad e7 ff ff       	call   801144 <fd2num>
  802997:	89 47 04             	mov    %eax,0x4(%edi)
  80299a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80299f:	eb 36                	jmp    8029d7 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8029a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ac:	e8 b1 e5 ff ff       	call   800f62 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8029b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029bf:	e8 9e e5 ff ff       	call   800f62 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8029c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029d2:	e8 8b e5 ff ff       	call   800f62 <sys_page_unmap>
    err:
	return r;
}
  8029d7:	89 d8                	mov    %ebx,%eax
  8029d9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029dc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029df:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029e2:	89 ec                	mov    %ebp,%esp
  8029e4:	5d                   	pop    %ebp
  8029e5:	c3                   	ret    
	...

008029f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	5d                   	pop    %ebp
  8029f9:	c3                   	ret    

008029fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8029fa:	55                   	push   %ebp
  8029fb:	89 e5                	mov    %esp,%ebp
  8029fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802a00:	c7 44 24 04 d0 35 80 	movl   $0x8035d0,0x4(%esp)
  802a07:	00 
  802a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0b:	89 04 24             	mov    %eax,(%esp)
  802a0e:	e8 c6 de ff ff       	call   8008d9 <strcpy>
	return 0;
}
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
  802a1d:	57                   	push   %edi
  802a1e:	56                   	push   %esi
  802a1f:	53                   	push   %ebx
  802a20:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802a26:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a2b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a31:	eb 34                	jmp    802a67 <devcons_write+0x4d>
		m = n - tot;
  802a33:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a36:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802a38:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  802a3e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802a43:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a46:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a4a:	03 45 0c             	add    0xc(%ebp),%eax
  802a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a51:	89 3c 24             	mov    %edi,(%esp)
  802a54:	e8 26 e0 ff ff       	call   800a7f <memmove>
		sys_cputs(buf, m);
  802a59:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a5d:	89 3c 24             	mov    %edi,(%esp)
  802a60:	e8 2b e2 ff ff       	call   800c90 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a65:	01 de                	add    %ebx,%esi
  802a67:	89 f0                	mov    %esi,%eax
  802a69:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a6c:	72 c5                	jb     802a33 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a6e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802a74:	5b                   	pop    %ebx
  802a75:	5e                   	pop    %esi
  802a76:	5f                   	pop    %edi
  802a77:	5d                   	pop    %ebp
  802a78:	c3                   	ret    

00802a79 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a79:	55                   	push   %ebp
  802a7a:	89 e5                	mov    %esp,%ebp
  802a7c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a85:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802a8c:	00 
  802a8d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a90:	89 04 24             	mov    %eax,(%esp)
  802a93:	e8 f8 e1 ff ff       	call   800c90 <sys_cputs>
}
  802a98:	c9                   	leave  
  802a99:	c3                   	ret    

00802a9a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802aa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802aa4:	75 07                	jne    802aad <devcons_read+0x13>
  802aa6:	eb 28                	jmp    802ad0 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802aa8:	e8 d0 e5 ff ff       	call   80107d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802aad:	8d 76 00             	lea    0x0(%esi),%esi
  802ab0:	e8 a7 e1 ff ff       	call   800c5c <sys_cgetc>
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	74 ef                	je     802aa8 <devcons_read+0xe>
  802ab9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802abb:	85 c0                	test   %eax,%eax
  802abd:	78 16                	js     802ad5 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802abf:	83 f8 04             	cmp    $0x4,%eax
  802ac2:	74 0c                	je     802ad0 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac7:	88 10                	mov    %dl,(%eax)
  802ac9:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802ace:	eb 05                	jmp    802ad5 <devcons_read+0x3b>
  802ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad5:	c9                   	leave  
  802ad6:	c3                   	ret    

00802ad7 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802ad7:	55                   	push   %ebp
  802ad8:	89 e5                	mov    %esp,%ebp
  802ada:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802add:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ae0:	89 04 24             	mov    %eax,(%esp)
  802ae3:	e8 87 e6 ff ff       	call   80116f <fd_alloc>
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	78 3f                	js     802b2b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802aec:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802af3:	00 
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802afb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b02:	e8 17 e5 ff ff       	call   80101e <sys_page_alloc>
  802b07:	85 c0                	test   %eax,%eax
  802b09:	78 20                	js     802b2b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b0b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	89 04 24             	mov    %eax,(%esp)
  802b26:	e8 19 e6 ff ff       	call   801144 <fd2num>
}
  802b2b:	c9                   	leave  
  802b2c:	c3                   	ret    

00802b2d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802b2d:	55                   	push   %ebp
  802b2e:	89 e5                	mov    %esp,%ebp
  802b30:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b33:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b36:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	89 04 24             	mov    %eax,(%esp)
  802b40:	e8 83 e6 ff ff       	call   8011c8 <fd_lookup>
  802b45:	85 c0                	test   %eax,%eax
  802b47:	78 11                	js     802b5a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	3b 05 58 40 80 00    	cmp    0x804058,%eax
  802b54:	0f 94 c0             	sete   %al
  802b57:	0f b6 c0             	movzbl %al,%eax
}
  802b5a:	c9                   	leave  
  802b5b:	c3                   	ret    

00802b5c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802b5c:	55                   	push   %ebp
  802b5d:	89 e5                	mov    %esp,%ebp
  802b5f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802b62:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802b69:	00 
  802b6a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b78:	e8 a2 e8 ff ff       	call   80141f <read>
	if (r < 0)
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	78 0f                	js     802b90 <getchar+0x34>
		return r;
	if (r < 1)
  802b81:	85 c0                	test   %eax,%eax
  802b83:	7f 07                	jg     802b8c <getchar+0x30>
  802b85:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802b8a:	eb 04                	jmp    802b90 <getchar+0x34>
		return -E_EOF;
	return c;
  802b8c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802b90:	c9                   	leave  
  802b91:	c3                   	ret    
	...

00802b94 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b94:	55                   	push   %ebp
  802b95:	89 e5                	mov    %esp,%ebp
  802b97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b9a:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802b9f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802ba2:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802ba8:	8b 12                	mov    (%edx),%edx
  802baa:	39 ca                	cmp    %ecx,%edx
  802bac:	75 0c                	jne    802bba <ipc_find_env+0x26>
			return envs[i].env_id;
  802bae:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802bb1:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	eb 0e                	jmp    802bc8 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802bba:	83 c0 01             	add    $0x1,%eax
  802bbd:	3d 00 04 00 00       	cmp    $0x400,%eax
  802bc2:	75 db                	jne    802b9f <ipc_find_env+0xb>
  802bc4:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802bc8:	5d                   	pop    %ebp
  802bc9:	c3                   	ret    

00802bca <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
  802bcd:	57                   	push   %edi
  802bce:	56                   	push   %esi
  802bcf:	53                   	push   %ebx
  802bd0:	83 ec 2c             	sub    $0x2c,%esp
  802bd3:	8b 75 08             	mov    0x8(%ebp),%esi
  802bd6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802bd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802bdc:	85 db                	test   %ebx,%ebx
  802bde:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802be3:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802be6:	8b 45 14             	mov    0x14(%ebp),%eax
  802be9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802bf1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bf5:	89 34 24             	mov    %esi,(%esp)
  802bf8:	e8 13 e2 ff ff       	call   800e10 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802bfd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c00:	74 e4                	je     802be6 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802c02:	85 c0                	test   %eax,%eax
  802c04:	74 28                	je     802c2e <ipc_send+0x64>
  802c06:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c0a:	c7 44 24 0c f9 35 80 	movl   $0x8035f9,0xc(%esp)
  802c11:	00 
  802c12:	c7 44 24 08 dc 35 80 	movl   $0x8035dc,0x8(%esp)
  802c19:	00 
  802c1a:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802c21:	00 
  802c22:	c7 04 24 ef 35 80 00 	movl   $0x8035ef,(%esp)
  802c29:	e8 92 d5 ff ff       	call   8001c0 <_panic>
	//if(!ret) sys_yield();
}
  802c2e:	83 c4 2c             	add    $0x2c,%esp
  802c31:	5b                   	pop    %ebx
  802c32:	5e                   	pop    %esi
  802c33:	5f                   	pop    %edi
  802c34:	5d                   	pop    %ebp
  802c35:	c3                   	ret    

00802c36 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c36:	55                   	push   %ebp
  802c37:	89 e5                	mov    %esp,%ebp
  802c39:	83 ec 28             	sub    $0x28,%esp
  802c3c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802c3f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802c42:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802c45:	8b 75 08             	mov    0x8(%ebp),%esi
  802c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4b:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802c55:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802c58:	89 04 24             	mov    %eax,(%esp)
  802c5b:	e8 53 e1 ff ff       	call   800db3 <sys_ipc_recv>
  802c60:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802c62:	e8 4a e4 ff ff       	call   8010b1 <sys_getenvid>
  802c67:	25 ff 03 00 00       	and    $0x3ff,%eax
  802c6c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802c6f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802c74:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802c79:	85 f6                	test   %esi,%esi
  802c7b:	74 0e                	je     802c8b <ipc_recv+0x55>
  802c7d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c82:	85 db                	test   %ebx,%ebx
  802c84:	75 03                	jne    802c89 <ipc_recv+0x53>
  802c86:	8b 50 74             	mov    0x74(%eax),%edx
  802c89:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802c8b:	85 ff                	test   %edi,%edi
  802c8d:	74 13                	je     802ca2 <ipc_recv+0x6c>
  802c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c94:	85 db                	test   %ebx,%ebx
  802c96:	75 08                	jne    802ca0 <ipc_recv+0x6a>
  802c98:	a1 08 50 80 00       	mov    0x805008,%eax
  802c9d:	8b 40 78             	mov    0x78(%eax),%eax
  802ca0:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802ca2:	85 db                	test   %ebx,%ebx
  802ca4:	75 08                	jne    802cae <ipc_recv+0x78>
  802ca6:	a1 08 50 80 00       	mov    0x805008,%eax
  802cab:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802cae:	89 d8                	mov    %ebx,%eax
  802cb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802cb3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802cb6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802cb9:	89 ec                	mov    %ebp,%esp
  802cbb:	5d                   	pop    %ebp
  802cbc:	c3                   	ret    
  802cbd:	00 00                	add    %al,(%eax)
	...

00802cc0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	89 c2                	mov    %eax,%edx
  802cc8:	c1 ea 16             	shr    $0x16,%edx
  802ccb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802cd2:	f6 c2 01             	test   $0x1,%dl
  802cd5:	74 20                	je     802cf7 <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802cd7:	c1 e8 0c             	shr    $0xc,%eax
  802cda:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802ce1:	a8 01                	test   $0x1,%al
  802ce3:	74 12                	je     802cf7 <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ce5:	c1 e8 0c             	shr    $0xc,%eax
  802ce8:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802ced:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802cf2:	0f b7 c0             	movzwl %ax,%eax
  802cf5:	eb 05                	jmp    802cfc <pageref+0x3c>
  802cf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cfc:	5d                   	pop    %ebp
  802cfd:	c3                   	ret    
	...

00802d00 <__udivdi3>:
  802d00:	55                   	push   %ebp
  802d01:	89 e5                	mov    %esp,%ebp
  802d03:	57                   	push   %edi
  802d04:	56                   	push   %esi
  802d05:	83 ec 10             	sub    $0x10,%esp
  802d08:	8b 45 14             	mov    0x14(%ebp),%eax
  802d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0e:	8b 75 10             	mov    0x10(%ebp),%esi
  802d11:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802d14:	85 c0                	test   %eax,%eax
  802d16:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802d19:	75 35                	jne    802d50 <__udivdi3+0x50>
  802d1b:	39 fe                	cmp    %edi,%esi
  802d1d:	77 61                	ja     802d80 <__udivdi3+0x80>
  802d1f:	85 f6                	test   %esi,%esi
  802d21:	75 0b                	jne    802d2e <__udivdi3+0x2e>
  802d23:	b8 01 00 00 00       	mov    $0x1,%eax
  802d28:	31 d2                	xor    %edx,%edx
  802d2a:	f7 f6                	div    %esi
  802d2c:	89 c6                	mov    %eax,%esi
  802d2e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d31:	31 d2                	xor    %edx,%edx
  802d33:	89 f8                	mov    %edi,%eax
  802d35:	f7 f6                	div    %esi
  802d37:	89 c7                	mov    %eax,%edi
  802d39:	89 c8                	mov    %ecx,%eax
  802d3b:	f7 f6                	div    %esi
  802d3d:	89 c1                	mov    %eax,%ecx
  802d3f:	89 fa                	mov    %edi,%edx
  802d41:	89 c8                	mov    %ecx,%eax
  802d43:	83 c4 10             	add    $0x10,%esp
  802d46:	5e                   	pop    %esi
  802d47:	5f                   	pop    %edi
  802d48:	5d                   	pop    %ebp
  802d49:	c3                   	ret    
  802d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d50:	39 f8                	cmp    %edi,%eax
  802d52:	77 1c                	ja     802d70 <__udivdi3+0x70>
  802d54:	0f bd d0             	bsr    %eax,%edx
  802d57:	83 f2 1f             	xor    $0x1f,%edx
  802d5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d5d:	75 39                	jne    802d98 <__udivdi3+0x98>
  802d5f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802d62:	0f 86 a0 00 00 00    	jbe    802e08 <__udivdi3+0x108>
  802d68:	39 f8                	cmp    %edi,%eax
  802d6a:	0f 82 98 00 00 00    	jb     802e08 <__udivdi3+0x108>
  802d70:	31 ff                	xor    %edi,%edi
  802d72:	31 c9                	xor    %ecx,%ecx
  802d74:	89 c8                	mov    %ecx,%eax
  802d76:	89 fa                	mov    %edi,%edx
  802d78:	83 c4 10             	add    $0x10,%esp
  802d7b:	5e                   	pop    %esi
  802d7c:	5f                   	pop    %edi
  802d7d:	5d                   	pop    %ebp
  802d7e:	c3                   	ret    
  802d7f:	90                   	nop
  802d80:	89 d1                	mov    %edx,%ecx
  802d82:	89 fa                	mov    %edi,%edx
  802d84:	89 c8                	mov    %ecx,%eax
  802d86:	31 ff                	xor    %edi,%edi
  802d88:	f7 f6                	div    %esi
  802d8a:	89 c1                	mov    %eax,%ecx
  802d8c:	89 fa                	mov    %edi,%edx
  802d8e:	89 c8                	mov    %ecx,%eax
  802d90:	83 c4 10             	add    $0x10,%esp
  802d93:	5e                   	pop    %esi
  802d94:	5f                   	pop    %edi
  802d95:	5d                   	pop    %ebp
  802d96:	c3                   	ret    
  802d97:	90                   	nop
  802d98:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d9c:	89 f2                	mov    %esi,%edx
  802d9e:	d3 e0                	shl    %cl,%eax
  802da0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802da3:	b8 20 00 00 00       	mov    $0x20,%eax
  802da8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802dab:	89 c1                	mov    %eax,%ecx
  802dad:	d3 ea                	shr    %cl,%edx
  802daf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802db3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802db6:	d3 e6                	shl    %cl,%esi
  802db8:	89 c1                	mov    %eax,%ecx
  802dba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802dbd:	89 fe                	mov    %edi,%esi
  802dbf:	d3 ee                	shr    %cl,%esi
  802dc1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802dc5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcb:	d3 e7                	shl    %cl,%edi
  802dcd:	89 c1                	mov    %eax,%ecx
  802dcf:	d3 ea                	shr    %cl,%edx
  802dd1:	09 d7                	or     %edx,%edi
  802dd3:	89 f2                	mov    %esi,%edx
  802dd5:	89 f8                	mov    %edi,%eax
  802dd7:	f7 75 ec             	divl   -0x14(%ebp)
  802dda:	89 d6                	mov    %edx,%esi
  802ddc:	89 c7                	mov    %eax,%edi
  802dde:	f7 65 e8             	mull   -0x18(%ebp)
  802de1:	39 d6                	cmp    %edx,%esi
  802de3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802de6:	72 30                	jb     802e18 <__udivdi3+0x118>
  802de8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802deb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802def:	d3 e2                	shl    %cl,%edx
  802df1:	39 c2                	cmp    %eax,%edx
  802df3:	73 05                	jae    802dfa <__udivdi3+0xfa>
  802df5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802df8:	74 1e                	je     802e18 <__udivdi3+0x118>
  802dfa:	89 f9                	mov    %edi,%ecx
  802dfc:	31 ff                	xor    %edi,%edi
  802dfe:	e9 71 ff ff ff       	jmp    802d74 <__udivdi3+0x74>
  802e03:	90                   	nop
  802e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e08:	31 ff                	xor    %edi,%edi
  802e0a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802e0f:	e9 60 ff ff ff       	jmp    802d74 <__udivdi3+0x74>
  802e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e18:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802e1b:	31 ff                	xor    %edi,%edi
  802e1d:	89 c8                	mov    %ecx,%eax
  802e1f:	89 fa                	mov    %edi,%edx
  802e21:	83 c4 10             	add    $0x10,%esp
  802e24:	5e                   	pop    %esi
  802e25:	5f                   	pop    %edi
  802e26:	5d                   	pop    %ebp
  802e27:	c3                   	ret    
	...

00802e30 <__umoddi3>:
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
  802e33:	57                   	push   %edi
  802e34:	56                   	push   %esi
  802e35:	83 ec 20             	sub    $0x20,%esp
  802e38:	8b 55 14             	mov    0x14(%ebp),%edx
  802e3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e3e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802e41:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e44:	85 d2                	test   %edx,%edx
  802e46:	89 c8                	mov    %ecx,%eax
  802e48:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802e4b:	75 13                	jne    802e60 <__umoddi3+0x30>
  802e4d:	39 f7                	cmp    %esi,%edi
  802e4f:	76 3f                	jbe    802e90 <__umoddi3+0x60>
  802e51:	89 f2                	mov    %esi,%edx
  802e53:	f7 f7                	div    %edi
  802e55:	89 d0                	mov    %edx,%eax
  802e57:	31 d2                	xor    %edx,%edx
  802e59:	83 c4 20             	add    $0x20,%esp
  802e5c:	5e                   	pop    %esi
  802e5d:	5f                   	pop    %edi
  802e5e:	5d                   	pop    %ebp
  802e5f:	c3                   	ret    
  802e60:	39 f2                	cmp    %esi,%edx
  802e62:	77 4c                	ja     802eb0 <__umoddi3+0x80>
  802e64:	0f bd ca             	bsr    %edx,%ecx
  802e67:	83 f1 1f             	xor    $0x1f,%ecx
  802e6a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802e6d:	75 51                	jne    802ec0 <__umoddi3+0x90>
  802e6f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802e72:	0f 87 e0 00 00 00    	ja     802f58 <__umoddi3+0x128>
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	29 f8                	sub    %edi,%eax
  802e7d:	19 d6                	sbb    %edx,%esi
  802e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	89 f2                	mov    %esi,%edx
  802e87:	83 c4 20             	add    $0x20,%esp
  802e8a:	5e                   	pop    %esi
  802e8b:	5f                   	pop    %edi
  802e8c:	5d                   	pop    %ebp
  802e8d:	c3                   	ret    
  802e8e:	66 90                	xchg   %ax,%ax
  802e90:	85 ff                	test   %edi,%edi
  802e92:	75 0b                	jne    802e9f <__umoddi3+0x6f>
  802e94:	b8 01 00 00 00       	mov    $0x1,%eax
  802e99:	31 d2                	xor    %edx,%edx
  802e9b:	f7 f7                	div    %edi
  802e9d:	89 c7                	mov    %eax,%edi
  802e9f:	89 f0                	mov    %esi,%eax
  802ea1:	31 d2                	xor    %edx,%edx
  802ea3:	f7 f7                	div    %edi
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	f7 f7                	div    %edi
  802eaa:	eb a9                	jmp    802e55 <__umoddi3+0x25>
  802eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802eb0:	89 c8                	mov    %ecx,%eax
  802eb2:	89 f2                	mov    %esi,%edx
  802eb4:	83 c4 20             	add    $0x20,%esp
  802eb7:	5e                   	pop    %esi
  802eb8:	5f                   	pop    %edi
  802eb9:	5d                   	pop    %ebp
  802eba:	c3                   	ret    
  802ebb:	90                   	nop
  802ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ec0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ec4:	d3 e2                	shl    %cl,%edx
  802ec6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802ec9:	ba 20 00 00 00       	mov    $0x20,%edx
  802ece:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802ed1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ed4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ed8:	89 fa                	mov    %edi,%edx
  802eda:	d3 ea                	shr    %cl,%edx
  802edc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ee0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802ee3:	d3 e7                	shl    %cl,%edi
  802ee5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ee9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802eec:	89 f2                	mov    %esi,%edx
  802eee:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802ef1:	89 c7                	mov    %eax,%edi
  802ef3:	d3 ea                	shr    %cl,%edx
  802ef5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ef9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802efc:	89 c2                	mov    %eax,%edx
  802efe:	d3 e6                	shl    %cl,%esi
  802f00:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802f04:	d3 ea                	shr    %cl,%edx
  802f06:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f0a:	09 d6                	or     %edx,%esi
  802f0c:	89 f0                	mov    %esi,%eax
  802f0e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802f11:	d3 e7                	shl    %cl,%edi
  802f13:	89 f2                	mov    %esi,%edx
  802f15:	f7 75 f4             	divl   -0xc(%ebp)
  802f18:	89 d6                	mov    %edx,%esi
  802f1a:	f7 65 e8             	mull   -0x18(%ebp)
  802f1d:	39 d6                	cmp    %edx,%esi
  802f1f:	72 2b                	jb     802f4c <__umoddi3+0x11c>
  802f21:	39 c7                	cmp    %eax,%edi
  802f23:	72 23                	jb     802f48 <__umoddi3+0x118>
  802f25:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f29:	29 c7                	sub    %eax,%edi
  802f2b:	19 d6                	sbb    %edx,%esi
  802f2d:	89 f0                	mov    %esi,%eax
  802f2f:	89 f2                	mov    %esi,%edx
  802f31:	d3 ef                	shr    %cl,%edi
  802f33:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802f37:	d3 e0                	shl    %cl,%eax
  802f39:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f3d:	09 f8                	or     %edi,%eax
  802f3f:	d3 ea                	shr    %cl,%edx
  802f41:	83 c4 20             	add    $0x20,%esp
  802f44:	5e                   	pop    %esi
  802f45:	5f                   	pop    %edi
  802f46:	5d                   	pop    %ebp
  802f47:	c3                   	ret    
  802f48:	39 d6                	cmp    %edx,%esi
  802f4a:	75 d9                	jne    802f25 <__umoddi3+0xf5>
  802f4c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f4f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802f52:	eb d1                	jmp    802f25 <__umoddi3+0xf5>
  802f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f58:	39 f2                	cmp    %esi,%edx
  802f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f60:	0f 82 12 ff ff ff    	jb     802e78 <__umoddi3+0x48>
  802f66:	e9 17 ff ff ff       	jmp    802e82 <__umoddi3+0x52>
